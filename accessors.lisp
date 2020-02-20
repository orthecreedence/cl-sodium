(in-package :sodium.accessors)

(defmacro make-accessors (c-struct)
  `(progn
     ,@(loop for slot-name in (foreign-slot-names `(:struct ,(intern (string c-struct) :sodium)))
             for accessor-name = (intern (concatenate 'string (symbol-name c-struct)
                                                      "-"
                                                      (symbol-name slot-name)))
             append (list `(defmacro ,accessor-name (ptr)
                             (list 'foreign-slot-value ptr '(:struct ,(intern (string c-struct) :sodium)) '',slot-name))
                          `(export ',accessor-name :sodium.accessors)))))

(make-accessors #.(sodium::lispify "crypto_auth_hmacsha256_state" 'classname))
(make-accessors #.(sodium::lispify "crypto_auth_hmacsha512_state" 'classname))
(make-accessors #.(sodium::lispify "crypto_generichash_blake2b_state" 'classname))
(make-accessors #.(sodium::lispify "crypto_hash_sha256_state" 'classname))
(make-accessors #.(sodium::lispify "crypto_hash_sha512_state" 'classname))
(make-accessors #.(sodium::lispify "crypto_onetimeauth_poly1305_state" 'classname))
(make-accessors #.(sodium::lispify "crypto_sign_ed25519ph_state" 'classname))
(make-accessors #.(sodium::lispify "randombytes_implementation" 'classname))
