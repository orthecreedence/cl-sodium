/* NOTE: This file is used to generate bindings only when the
 * sodium.h header is present. If you are building against a
 * non-ancient version (0.1 or later) of libsodium, this is not
 * the file you want. See scripts/generate.sh and the generated
 * scripts/bindings.gen.i file.
 */
%module bindings

%feature("intern_function", "lispify");

%insert("lisphead") %{
(in-package :sodium)
%}

%include "sodium/export.h"
%include "sodium/core.h"
%include "sodium/crypto_auth.h"
%include "sodium/crypto_auth_hmacsha256.h"
%include "sodium/crypto_auth_hmacsha512.h"
%include "sodium/crypto_auth_hmacsha512256.h"
%include "sodium/crypto_box.h"
%include "sodium/crypto_box_curve25519xsalsa20poly1305.h"
%include "sodium/crypto_core_hsalsa20.h"
%include "sodium/crypto_core_salsa20.h"
%include "sodium/crypto_core_salsa2012.h"
%include "sodium/crypto_core_salsa208.h"
%include "sodium/crypto_generichash.h"
%include "sodium/crypto_generichash_blake2b.h"
%include "sodium/crypto_hash.h"
%include "sodium/crypto_hash_sha256.h"
%include "sodium/crypto_hash_sha512.h"
%include "sodium/crypto_onetimeauth.h"
%include "sodium/crypto_onetimeauth_poly1305.h"
%include "sodium/crypto_pwhash_scryptsalsa208sha256.h"
%include "sodium/crypto_scalarmult.h"
%include "sodium/crypto_scalarmult_curve25519.h"
%include "sodium/crypto_secretbox.h"
%include "sodium/crypto_secretbox_xsalsa20poly1305.h"
%include "sodium/crypto_shorthash.h"
%include "sodium/crypto_shorthash_siphash24.h"
%include "sodium/crypto_sign.h"
%include "sodium/crypto_sign_ed25519.h"
%include "sodium/crypto_stream.h"
#%include "sodium/crypto_stream_aes128ctr.h"
#%include "sodium/crypto_stream_aes256estream.h"
%include "sodium/crypto_stream_chacha20.h"
%include "sodium/crypto_stream_salsa20.h"
%include "sodium/crypto_stream_salsa2012.h"
%include "sodium/crypto_stream_salsa208.h"
%include "sodium/crypto_stream_xsalsa20.h"
%include "sodium/crypto_verify_16.h"
%include "sodium/crypto_verify_32.h"
%include "sodium/crypto_verify_64.h"
%include "sodium/randombytes.h"
#%include "sodium/randombytes_salsa20_random.h"
%include "sodium/randombytes_sysrandom.h"
%include "sodium/runtime.h"
%include "sodium/utils.h"
%include "sodium/version.h"

