#!/bin/bash

#
# This script can be used to regenerate the bindings.lisp file using
# SWIG. 
#

swig -cffi -module bindings -noswig-lisp -o bindings.lisp scripts/bindings.i 

# well done, swig. once again, i'm left to clean up your mess
ASN1_TYPE_CONSTRUCTED_VAL="`grep ASN1_TYPE_CONSTRUCTED bindings.lisp | head -1 | sed 's|.*#\.\((cl:ash[^)]\+)\).*|\1|' `"
sed -i "s|(cl:logior \([0-9]\+\) ASN1_TYPE_CONSTRUCTED)|(cl:logior \1 $ASN1_TYPE_CONSTRUCTED_VAL)|g" bindings.lisp

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

