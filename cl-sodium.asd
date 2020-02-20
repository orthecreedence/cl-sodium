(asdf:defsystem cl-sodium
  :author "Andrew Danger Lyon <orthecreedence@gmail.com>"
  :license "MIT"
  :version "0.1.0"
  :description "A wrapper around libsodium, providing easy, correct, safe crypto for common lisp."
  :depends-on (#:cffi
               #:alexandria)
  :components ((:file "sodium")
               (:file "wrapper" :depends-on ("sodium"))
               (:file "bindings" :depends-on ("wrapper"))
               (:file "exports" :depends-on ("bindings"))
               (:file "accessors" :depends-on ("exports"))
               (:file "high-level" :depends-on ("accessors"))))

