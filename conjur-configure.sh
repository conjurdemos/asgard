#!/bin/bash

# creates Conjur config files based on environment variables

ARGS="APPLIANCE_URL CERT ACCOUNT LOGIN PASSWORD"

for a in $ARGS; do
  VAR=CONJUR_$a
  if eval [ -z \"\$$VAR\" ]; then
    echo "$VAR environment variable required but not set."
    exit 1
  fi
done

echo "$CONJUR_CERT" > /etc/conjur.pem

# set up Conjur configuration
cat > /etc/conjur.conf << EOF
appliance_url: $CONJUR_APPLIANCE_URL
account: $CONJUR_ACCOUNT
netrc_path: /etc/conjur.identity
cert_file: /etc/conjur.pem
EOF

cat > /etc/conjur.identity << EOF
machine $CONJUR_APPLIANCE_URL/authn
login $CONJUR_LOGIN
password $CONJUR_PASSWORD
EOF

chmod 0600 /etc/conjur.identity
