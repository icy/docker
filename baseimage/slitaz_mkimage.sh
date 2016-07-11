#!/bin/bash

# Purpose: Build Slitaz base image
# Author : Anh K. Huynh
# License: MIT
# Options:
#
#   --mirror http://f.archlinuxvn.org/slitaz/
#   --version 4.0
#   --dir <target>
#   --dcache <download directory>
#   --cached
#   --chroot
#

_help() {
  cat << 'EOF'
PURPOSE

  This script is to build a SliTaz base image.

USAGE

  Build an image and import to Docker

    $ $PWD/mkimage-slitaz.sh build \
        --version VERSION
        --mirror MIRROR

  Build local rootfs without importing them to Docker

    $ docker run -v $PWD:/build ubuntu:14.04 \
        /build/mkimage-slitaz.sh \
        makefs \
        --version VERSION \
        [--mirror MIRROR] [--cached] [--chroot]

  (Running this command insider Docker container is just safe.)

OPTIONS

  --version VERSION   SliTaz version. 4.0 or 5.0
  --mirror  MIRROR    The nearest mirror (Default: http://mirror.slitaz.org/)

  --cached            Reuse local cached directory
  --chroot            The script is running in `root` environment.
                      It's required to fix `tazpkg` database.
EOF
}

_warn() {
  echo >&2 ":: (warn) $*"
}

_err() {
  echo >&2 ":: (error) $*"
  return 1
}

_info() {
  echo >&1 ":: (info) $*"
}

# ls  target-from-packages/downloads/ \
# | sed -r -e 's#-([0-9.\-]+[a-z]?)\.tazpkg$##g'
_list_packages() {
  echo \
    bash \
    busybox \
    bzlib \
    coreutils \
    curl \
    gettext-base \
    glibc-base \
    libcrypto \
    libcurl \
    libidn \
    libssl \
    ncurses \
    ncurses-common \
    openssl \
    readline \
    slitaz-base-files \
    tazpkg \
    zlib

  case "$_VERSION" in
  "4.0")
    echo "libtaz"
    ;;

  "5.0")
    echo "cacerts"
    echo "libtinfo"
    ;;
  esac
}

_get_wdir() {
  if [[ -z "${__WDIR:-}" ]]; then
    export __WDIR="$(dirname $0)"
  fi
  echo "$__WDIR"
}

_parse_arguments() {
  _CACHED=0
  _CHROOT=0

  while (( $# )); do
    case "$1" in
    "--mirror")   shift; _MIRROR="${1:-}" ;;
    "--version")  shift; _VERSION="${1:-}" ;;
    "--dir")      shift; _DIR="${1:-}" ;;
    "--dcache")   shift; _CDIR="${1:-}" ;;
    "--cached")   shift; _CACHED=1 ;;
    "--chroot")   shift; _CHROOT=1 ;;
    "--help")     _help; return 1 ;;
    *) shift;
    esac
  done

  if [[ -z "${_MIRROR:-}" ]]; then
    _MIRROR="http://mirror.slitaz.org/"
    _warn "Mirror not set. Use default '$_MIRROR'."
  fi

  grep -qE -- "https?:\/\/.+" <<< "$_MIRROR" \
  || {
    _err "Mirror is unknown. Return(1)."
    return 1
  }

  case "${_VERSION:-}" in
  "4.0"|"5.0") ;;
  *)  _err "Unsupported version '${_VERSION:-}'" || return 1;;
  esac

  if [[ -z "${_DIR:-}" ]]; then
    _DIR="$(_get_wdir)/fs/"
    _warn "Target not set. Use default '$_DIR'."
  else
    if [[ "$(basename "$_DIR")" != "fs" ]]; then
      _err "Target directory must be ended by /fs/." || return 1
    fi
  fi

  if [[ -z "${_CDIR:-}" ]]; then
    _CDIR="$(_get_wdir)/downloads/"
    _warn "Cache directory not set. Use default '$_CDIR'."
  fi

  # FIXME
  if [[ -d "$_DIR" ]]; then
    if [[ "$_CACHED" == "1" ]]; then
      _warn "Re-use target directory '$_DIR'."
    else
      _err "Target exists. Use '--cached' to avoid this. Exit(1)."
      return 1
    fi
  else
    _is_fakeroot && mkdir -p "$_DIR"
  fi

  _CDIR="$_CDIR/$_VERSION"
  if [[ ! -d "$_CDIR" ]]; then
    _warn "Cache directory not exist. Creating."
    _is_fakeroot && mkdir -p "$_CDIR"
  fi

  _FETCHED="$_CDIR/packages.desc.fetched"
  _is_fakeroot && echo > "$_FETCHED"
}

_download_files() {
  _require_fakeroot $FUNCNAME || return 1

  local _dl=1         # force download, or not
  local _listed=1     # list of a package, or normal package
  local _pkg=         # package name
  local _pkg_found=   # remote package name
  local _url=         # remote url to download package
  local _target=      # local target

  local _flist="$_CDIR/packages.desc"

  grep -q -- "--force" <<< "$@" || _dl=0

  while (( $# )); do
    _pkg="$1"; shift
    _listed=1

    case "$_pkg" in
    "--force")
      continue ;;

    "packages.desc")
      _listed=0 ;;
    esac

    # // download list of packages

    if [[ "$_listed" == 0 ]]; then
      _target="$_CDIR/$_pkg"
      if [[ ! -f "$_target" || "$_dl" == 1 ]]; then
        wget -O "$_target" "$_MIRROR/packages/$_VERSION/$_pkg"
      else
        _info "File downloaded ($_target)."
      fi
      continue
    fi

    # // download a normal package

    if [[ ! -f "$_flist" ]]; then
      _err "Listing not found '$_flist'. Return(1)." || return 1
    fi

    #
    _pkg_found="$( \
      cat "$_flist" \
      | awk \
          -v "PKG=$_pkg" \
          '{
            if ($1 == PKG) {
              printf("%s %s\n", $1, $3)
            }
          }'
      )"

    _pkg_found2="${_pkg_found/ /-}"

    if [[ -z "$_pkg_found" ]]; then
      _err "Package not found '$_pkg' from '$_flist'. Return(1)." || return 1
    fi

    _url="$_MIRROR/packages/$_VERSION/$_pkg_found2.tazpkg"
    _info "Found remote package '$_url'"

    _target="$_CDIR/$_pkg_found2.tazpkg"
    if [[ ! -f "$_target" || "$_dl" == 1 ]]; then
      wget -O "$_target" "$_url"
    fi

    grep -q -- "$_pkg_found" "$_FETCHED" \
    || echo "$_pkg_found" >> "$_FETCHED"
  done
}

_make_rootfs_simple() {
  _require_fakeroot $FUNCNAME || return 1

  mkdir -p \
    "$_DIR/root/" \
    "$_DIR/var/lib/tazpkg/" \
    "$_DIR/usr/bin/" \
    "$_DIR/etc/profile.d/" \
    "$(_slitaz_tazpkg_cache_dir)"

  # Update mirror information
  echo "$_MIRROR/packages/$_VERSION/" > "$_DIR/var/lib/tazpkg/mirror"

  # Update pacapt script
  wget -c -O "$_DIR/usr/bin/pacman" "https://raw.githubusercontent.com/icy/pacapt/ng/pacapt"
  chmod 755 "$_DIR/usr/bin/pacman"
}

_make_rootfs_before_refresh() {
  _require_fakeroot $FUNCNAME || return 1

  _info "Updating /etc/resolv.conf"
  {
    echo "nameserver 8.8.8.8"
    echo "nameserver 8.8.4.4"
  } > "$_DIR/etc/resolv.conf"

  # FIXME:
  #   5.0 or rolling: `cacerts` bundle is still out-of-date

  # Update ca-certificates
  _info "Updating bundle of certificate."
  curl -Lso "$_DIR/etc/ssl/cert.pem" https://curl.haxx.se/ca/cacert.pem

  _info "Generating /root/.curlrc"
  cat > "$_DIR/root/.curlrc" <<'EOF'
--cacert /etc/ssl/cert.pem
EOF

  _info "Generating /root/.gitrc"
  cat > "$_DIR/root/.gitrc" <<'EOF'
[http]
sslCAinfo = /etc/ssl/cert.pem
EOF
}

_extract_files() {
  _require_fakeroot $FUNCNAME || return 1

  while read _line; do
    read _name _ver _ <<< "$_line"
    _pkg="${_name}-${_ver}.tazpkg"

    if [[ -f "$_CDIR/$_pkg" ]]; then
      _info "Extracting '$_name ($_ver)'."

      _ftmp="$_DIR/var/lib/tazpkg/installed/$_name"

      (
        mkdir -p "$_ftmp"
        cd "$_ftmp" \
        && cpio -idm --quiet < "$_CDIR/$_pkg"
      )

      cd "$(_get_wdir)" \
      && {
        _ftmp="$_ftmp/fs.cpio.lzma"
        if [[ -f "$_ftmp" ]]; then
          unlzma -c "$_ftmp" | cpio -idm --quiet
          rm -f "$_ftmp"
        else
          _warn "$_name-$_ver: Unable to extract."
        fi
      } \
      || {
        _err "Unable to move to $(_get_wdir). Return(1)."
        return 1
      }
    else
      _warn "File not found '$_CDIR/$_pkg'"
    fi
  done < <(cat "$_FETCHED" | grep -E '[a-z]')
}

_is_fakeroot() {
  [[ -n "${FAKEROOTKEY:-}" ]]
}

_require_fakeroot() {
  _is_fakeroot || {
    _warn "$@: Fakeroot is required."
    return 1
  }
}

# FIXME: The cache directory is still `5.0` for rolling/cooking
_slitaz_tazpkg_cache_dir() {
  mkdir -p "$_DIR/var/cache/tazpkg/$_VERSION/packages/"
  echo "$_DIR/var/cache/tazpkg/$_VERSION/packages/"
}

# This is hard process!!! sudo/root is required, all packages are reinstalled
# and all files uid/gid are reset. After that, a manual fix would be done
# to allow normal users to download and fix the files...
#
# After this script, the directory is ready for Docker...
_refresh_tazpkg() {
  if [[ "$_CHROOT" == 0 ]]; then
    _err "Please use --chroot to refresh tazpkg database. Require sudo+chroot."
    return 1
  fi

  if _is_fakeroot; then
    _err "$FUNCNAME: Fakeroot environment is being used. Exit(1)."
    return 1
  fi

  _info "Chrooting and clean up tazpkg database"
  PATH="/sbin:/bin:/usr/sbin:/bin/" \
  chroot "$_DIR/" \
    /bin/bash -c '
      PATH="/sbin:/bin:/usr/sbin:/usr/bin/"
      pacman -Sy
      pacman -S -- --forced slitaz-base-files
      pacman -Su
      pacman -Q
      pacman -Scc
      '
}

_ensure_root() {
  if [[ "$(id -un)" != "root" ]]; then
    _err "This build process requires 'root' account. Return(1)."
    return 1
  fi

  export FAKEROOTKEY=000000
}

_ensure_packages() {
  if [[ -x "/usr/bin/pacman" ]]; then
    which wget \
    || {
      pacman -Sy
      { echo y; echo y; echo y; } | pacman -S curl wget xz
    }
  elif [[ -x "/usr/bin/apt-get" ]]; then
    apt-get update
    { echo y; echo y; echo y; } | apt-get install curl wget lzma
  fi

  if [[ ! -x /usr/sbin/chroot ]]; then
    _err "chroot not found. Return(1)."
    return 1
  fi

  which unlzma \
  && which curl \
  && which cpio
}

_clean_up_and_print_stats() {
  _info "Removing temporary files"
  rm -f "$_DIR/var/lib/tazpkg/mirror"

  _info "Removing /dev/, /proc/ (and re-creating them with empty contents.)"
  rm -rf "$_DIR/dev" "$_DIR/proc"
  mkdir -p "$_DIR/dev" "$_DIR/proc"

  _info "Target statistics:"
  du -hcs "$_DIR/" | grep 'total'
}

set -u

_make_rootfs() {
  _warn "Command: $0 $*"

  _ensure_root || { _help; exit 1; }
  _parse_arguments "$@" || exit 1

  _ensure_packages || exit 1
  _make_rootfs_simple
  _download_files "packages.desc"
  _download_files $(_list_packages) || exit 1
  _extract_files || exit 1
  _make_rootfs_before_refresh

  unset FAKEROOTKEY
  _refresh_tazpkg

  _clean_up_and_print_stats
}

_build_and_import() {
  set -eu

  ROOTFS="$(mktemp -d ${TMPDIR:-/var/tmp}/rootfs-slitaz-XXXXXXXXXX)"
  cd "$ROOTFS/"
  export __WDIR="$ROOTFS/"

  _parse_arguments "$@"
  _make_rootfs --version "$_VERSION" --mirror "$_MIRROR" --chroot --cached

  tar -C "./fs/" -c . \
  | docker import - slitaz"${_VERSION}"

  cd / && rm -rf "$ROOTFS"
}

case "${1:-}" in
"build")  shift; _build_and_import "$@" ;;
"makefs") shift; _make_rootfs "$@" ;;
*) _help; exit 1 ;;
esac
