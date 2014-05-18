(defpackage #:sodium
  (:use :cl :cffi)
  (:nicknames :cr))

(defpackage #:sodium.accessors
  (:use :cl :cffi :sodium)
  (:nicknames :cr-a))

(in-package :sodium)

(eval-when (:load-toplevel)
  (unless (cffi:foreign-symbol-pointer "sodium_init")
    (define-foreign-library libsodium
      (:darwin (:or "libsodium.dylib"))
      (:unix (:or "libsodium"))
      (:windows (:or "libsodium-10.dll"
                     "libsodium.dll"))
      (t (:default "libsodium")))
    (unless (foreign-library-loaded-p 'libsodium)
      (use-foreign-library libsodium))))

