# metadata-qa-ddb-web
Web interface for DDB metadata quality assessment

## Container logging and OpenShift

The Docker image is configured for container-native logging:

- Apache access log: stdout (`/proc/self/fd/1`)
- Apache error log: stderr (`/proc/self/fd/2`)
- PHP error log: stderr (`/proc/self/fd/2`)
- Additional Apache vhost log files are disabled (`other-vhosts-access-log`) so logs are only emitted to stdout/stderr.

Additional container hardening in Apache:

- `ServerTokens Prod`
- `ServerSignature Off`
- `TraceEnable Off`

This allows OpenShift to collect all logs through the platform logging stack.

The image is also prepared for OpenShift-style arbitrary UIDs by making relevant
runtime paths group-writable for GID `0`.

```
sudo apt-get install php-intl php-sqlite3 php-mysql
```

```
export SMARTY_VERSION=3.1.33
cd libs/
curl -s -L https://github.com/smarty-php/smarty/archive/v${SMARTY_VERSION}.zip --output v$SMARTY_VERSION.zip
unzip -q v${SMARTY_VERSION}.zip
rm v${SMARTY_VERSION}.zip
mkdir -p _smarty/templates_c
chmod a+w -R _smarty/templates_c/
cd ..
```
