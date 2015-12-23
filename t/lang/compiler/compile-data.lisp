#|
  This file is a part of oclcl project.
  Copyright (c) 2012 Masayuki Takagi (kamonama@gmail.com)
                2015 gos-k (mag4.elan@gmail.com)
|#

(in-package :cl-user)
(defpackage oclcl-test.lang.compiler.compile-data
  (:use :cl :prove
        :oclcl.lang.compiler.compile-data))
(in-package :oclcl-test.lang.compiler.compile-data)

(plan nil)


;;;
;;; test COMPILE-SYMBOL function
;;;

(diag "COMPILE-SYMBOL")

(is (compile-symbol 'x) "x"
    "basic case 1")
(is (compile-symbol 'vec-add-kernel) "vec_add_kernel"
    "basic case 2")


;;;
;;; test COMPILE-BOOL function
;;;

(diag "COMPILE-BOOL")

(is (compile-bool t) "true"
    "basic case 1")
(is (compile-bool nil) "false"
    "basic case 2")


;;;
;;; test COMPILE-INT function
;;;

(diag "COMPILE-INT")

(is (compile-int 1) "1"
    "basic case 1")


;;;
;;; test COMPILE-FLOAT function
;;;

(diag "COMPILE-FLOAT")

(is (compile-float 1.0) "1.0"
    "basic case 1")


;;;
;;; test COMPILE-DOUBLE function
;;;

(diag "COMPILE-DOUBLE")

(is (compile-double 1.0d0) "(double)1.0"
    "basic case 1")

(is (compile-double 1.23456789012345d0) "(double)1.23456789012345"
    "basic case 2")


(finalize)
