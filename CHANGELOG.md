## Changelog

* 1.3.8: update `cut_tiles.sh` to accept a value `S3_TARBALL_ONLY` which, if set to any value, will
result in only the planet tarball being pushed to S3 (assuming S3 upload is also enabled), rather than
the entire contents of the planet directory.
