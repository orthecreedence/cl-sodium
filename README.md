libsodium bindings for Common Lisp
=================================
This is a wrapper of the the [libsodium](https://github.com/jedisct1/libsodium)
library as well as a very thin layer of abstraction to make things a bit more
lispy than running raw C functions.

The goal of this project is to provide easy, correct, safe crypto for common
lisp. It relies entirely on libsodium for all cryptographic tasks.


Conventions
-----------
Who needs documentation when you follow simple function-naming conventions?

- The package prefix is `cr:`
- Underscores become dashes

See the examples/ folder and also the [NaCL documentation](http://nacl.cr.yp.to/)
(libsodium is a fork of NaCL).

### Example
TODO

(re)Generating
--------------
If a new version of libsodium comes out, you can regenerate these bindings by
doing the following (if you have [swig](http://www.swig.org/) installed):

```bash
cd /path/to/cl-sodium
ls -la path-to-sodium-headers 
# Check and/or update the symlink to point at your libsodium headers;
# it has to point to the directory containing the "sodium/" subdirectory.
./scripts/generate.sh          # must be run in cl-sodium folder
```

This will generate new bindings in their entirety (it's fully automated).

License
-------
MIT Licensed.

