BOCKER        = ./compiler/bocker.sh
REMOTE_REPO   = some_host\:/some/path

default:
	@echo "make all                # compile all Bockerfile files"
	@echo "make ITEMS=demo-proxy   # compile demo-proxy only"

$(REMOTE_REPO):
	@echo rsync item = context/
	@rsync -rapv \
			./context/ \
			$(@) \
		--delete --exclude=".git/*" \
		--exclude=Makefile \
		--delete-excluded

submodules::
	git submodule update --init  || true
	git submodule update --checkout

all: submodules bocker/* $(BOCKER)
	@./bin/compile.sh

clean:
	@rm -fv context/Dockerfile*
