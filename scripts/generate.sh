#!/bin/bash

#
# This script can be used to regenerate the bindings.lisp file using
# SWIG. 
#

if [ -z "$SODIUM_HEADERS" ]; then
	SODIUM_HEADERS="/usr/include"
fi

TEST_HEADER="$SODIUM_HEADERS/sodium/export.h"
if [ ! -f "$TEST_HEADER" ]; then
	echo >&2 "Header $TEST_HEADER doesn't exist; are the libsodium headers installed, and is SODIUM_HEADERS set correctly?"
	exit 1
fi

if [ -f "$SODIUM_HEADERS/sodium.h" ]; then
	BINDING_FILE=scripts/bindings.gen.i

	cat >"$BINDING_FILE" << EOF
%module bindings

%feature("intern_function", "lispify");

%insert("lisphead") %{
(in-package :sodium)
%}

# These are necessary to fix ordering issues.
%include "sodium/export.h"
%include "sodium/crypto_stream_chacha20.h"
EOF
	cat "$SODIUM_HEADERS/sodium.h" >> "$BINDING_FILE"
	sed -i -e 's/# *include/%include/' "$BINDING_FILE"
else
	BINDING_FILE=scripts/bindings.i
fi

swig "-I$SODIUM_HEADERS" -cffi -module bindings -noswig-lisp -o bindings.lisp "$BINDING_FILE"

# well done, swig. once again, i'm left to clean up your mess
ASN1_TYPE_CONSTRUCTED_VAL="`grep ASN1_TYPE_CONSTRUCTED bindings.lisp | head -1 | sed 's|.*#\.\((cl:ash[^)]\+)\).*|\1|' `"
sed -i "s|(cl:logior \([0-9]\+\) ASN1_TYPE_CONSTRUCTED)|(cl:logior \1 $ASN1_TYPE_CONSTRUCTED_VAL)|g" bindings.lisp
perl -i.bak -pe 's/^\(cl:defconstant /(define-string / if /"\)$/;' bindings.lisp
# Fix integers with a length suffix. Only convert an integer followed by a space, end-of-line, or close-paren
# to avoid accidentally clobbering some integer-looking value.
sed -E -i -e 's/( -?[0-9]+)[UulL]( |\)|$)/\1\2/' bindings.lisp

# ------------------------------------------------------------------------------
# make our exports
# ------------------------------------------------------------------------------
echo -ne "(in-package :sodium)\n\n" > exports.lisp
cat bindings.lisp | \
    grep -e '^(\(cffi\|cl\):' | \
    sed 's|^(cffi:defcfun.*" \(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cffi:defcenum.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cffi:defcunion.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cffi:defcvar.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cffi:defcstruct.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^(cl:defconstant.*\(#.(lispify[^)]\+)\).*|\1|' | \
    sed 's|^\(.*\)$|(export '"'"'\1)|' \
    >> exports.lisp
echo >> exports.lisp

# anonymous enum BS
cat bindings.lisp | \
	grep "'enumvalue)" | \
	sed 's|^\s*(\?||' | \
	sed 's|enumvalue\( :keyword\)\?).*$|enumvalue\1)|' | \
    sed 's|^\(.*\)$|(export '"'"'\1)|' \
    >> exports.lisp

# ------------------------------------------------------------------------------
# make our accessors
# ------------------------------------------------------------------------------
cat <<-EOFMAC > accessors.lisp
(in-package :sodium.accessors)

(defmacro make-accessors (c-struct)
  \`(progn
     ,@(loop for slot-name in (foreign-slot-names \`(:struct ,(intern (string c-struct) :sodium)))
             for accessor-name = (intern (concatenate 'string (symbol-name c-struct)
                                                      "-"
                                                      (symbol-name slot-name)))
             append (list \`(defmacro ,accessor-name (ptr)
                             (list 'foreign-slot-value ptr '(:struct ,(intern (string c-struct) :sodium)) '',slot-name))
                          \`(export ',accessor-name :sodium.accessors)))))

EOFMAC

cat bindings.lisp | \
    grep defcstruct | \
    sed 's|.*#\.(lispify|(make-accessors #.(sodium::lispify|g' | sed 's|$|)|' \
    >> accessors.lisp

