#!/bin/bash

cat <<EOF
<filter **>
  type record_transformer
  <record>
    ident $(echo "${FLUENTD_MONSTER_IDENT:-docker}")
  </record>
</filter>
EOF
