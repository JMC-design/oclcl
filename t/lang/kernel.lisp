#|
  This file is a part of oclcl project.
  Copyright (c) 2012 Masayuki Takagi (kamonama@gmail.com)
                2015 gos-k (mag4.elan@gmail.com)
|#

(in-package :cl-user)
(defpackage oclcl-test.lang.kernel
  (:use :cl :prove
        :oclcl.lang.kernel
        :oclcl.lang.type))
(in-package :oclcl-test.lang.kernel)

(plan nil)


;;;
;;; test MAKE-KERNEL function
;;;

(subtest "MAKE-KERNEL"

  (let ((kernel (make-kernel)))
    (is (kernel-function-names kernel) nil
        "basic case 1")
    (is (kernel-symbol-macro-names kernel) nil
        "basic case 2")))


;;; test KERNEL-MEMORY-NAMES function
;;;

(subtest "KERNEL-MEMORY-NAMES"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'x :global 42)
    (kernel-define-symbol-macro kernel 'y 42)
    (is (kernel-memory-names kernel) '(x)
        "kernel basic 1")))
;;;
;;; test KERNEL-FUNCTION-NAMES function
;;;

(subtest "KERNEL-FUNCTION-NAMES"

  (let ((kernel (make-kernel)))
    (kernel-define-function kernel 'foo 'int '((x int)) '((return x)))
    (kernel-define-macro kernel 'bar '(x) '(`(return ,x)))
    (is (kernel-function-names kernel) '(foo)
        "basic case 1")))


;;;
;;; test KERNEL-MACRO-NAMES function
;;;

(subtest "KERNEL-MACRO-NAMES"

  (let ((kernel (make-kernel)))
    (kernel-define-function kernel 'foo 'int '((x int)) '((return x)))
    (kernel-define-macro kernel 'bar '(x) '(`(return ,x)))
    (is (kernel-macro-names kernel) '(bar)
        "basic case 1")))


;;;
;;; test KERNEL-SYMBOL-MACRO-NAMES function
;;;

(subtest "KERNEL-SYMBOL-MACRO-NAMES"

  (let ((kernel (make-kernel)))
    (kernel-define-symbol-macro kernel 'x 1.0)
    (is (kernel-symbol-macro-names kernel) '(x)
        "kernel basic 1")))


;;;
;;; test KERNEL-DEFINE-FUNCTION function
;;;

(subtest "KERNEL-DEFINE-FUNCTION"

  (let ((kernel (make-kernel)))
    (is (kernel-define-function kernel 'foo 'int '((x int)) '((return x)))
        'foo "basic case 1"))

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-function kernel
                                      1 'int '((x int)) '((return x)))
              type-error
              "NAME which is not a oclcl symbol."))

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-function kernel 'foo 1 '((x int)) '((return x)))
              type-error
              "RETURN-TYPE which is not a oclcl type."))

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-function kernel 'foo 1 'bar '((return x)))
              type-error
              "ARGUMENTS which are invlalid arguments.")))


;;;
;;; test KERNEL-FUNCTION-EXISTS-P function
;;;

(subtest "KERNEL-FUNCTION-EXISTS-P"

  (let ((kernel (make-kernel)))
    (kernel-define-function kernel 'foo 'int '((x int)) '((return x)))
    (kernel-define-macro kernel 'bar '(x) '(`(return ,x)))
    (is (kernel-function-exists-p kernel 'foo) t
        "basic case 1")
    (is (kernel-function-exists-p kernel 'bar) nil
        "basic case 2")
    (is (kernel-function-exists-p kernel 'baz) nil
        "basic case 3")))


;;;
;;; test KERNEL-FUNCTION-NAME function
;;;


;;;
;;; test KERNEL-FUNCTION-C-NAME function
;;;


;;;
;;; test KERNEL-FUNCTION-RETURN-TYPE function
;;;


;;;
;;; test KERNEL-FUNCTION-ARGUMENTS function
;;;




;;;
;;; test KERNEL-FUNCTION-ARGUMENT-VARS function
;;;




;;;
;;; test KERNEL-FUNCTION-ARGUMENT-TYPES function
;;;




;;;
;;; test KERNEL-FUNCTION-BODY function
;;;




;;;
;;; test KERNEL-DEFINE-MACRO function
;;;

(subtest "KERNEL-DEFINE-MACRO"

  (let ((kernel (make-kernel)))
    (is (kernel-define-macro kernel 'foo '(x) '(`(return ,x)))
        'foo "basic case 1"))

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-macro kernel 1 '(x) '(`(return ,x)))
              type-error
              "NAME which is not a oclcl symbol.")))


;;;
;;; test KERNEL-MACRO-EXISTS-P function
;;;

(subtest "KERNEL-MACRO-EXISTS-P"

  (let ((kernel (make-kernel)))
    (kernel-define-function kernel 'foo 'int '((x int)) '((return x)))
    (kernel-define-macro kernel 'bar '(x) '(`(return ,x)))
    (is (kernel-macro-exists-p kernel 'foo) nil
        "basic case 1")
    (is (kernel-macro-exists-p kernel 'bar) t
        "basic case 2")
    (is (kernel-macro-exists-p kernel 'baz) nil
        "basic case 3")))


;;;
;;; test KERNEL-MACRO-NAME function
;;;




;;;
;;; test KERNEL-MACRO-ARGUMENTS function
;;;




;;;
;;; test KERNEL-MACRO-BODY function
;;;




;;;
;;; test KERNEL-MACRO-EXPANDER function
;;;




;;;
;;; test EXPAND-MACRO-1 function
;;;

(subtest "EXPAND-MACRO-1"
  (let ((kernel (make-kernel)))
    (kernel-define-macro kernel 'foo '(x) '(`(return ,x)))
    (kernel-define-macro kernel 'bar '(x) '(`(foo ,x)))
    (kernel-define-symbol-macro kernel 'a 1.0)
    (kernel-define-symbol-macro kernel 'b 'a)
    (is-values (expand-macro-1 '(foo 1) kernel) '((return 1) t))
    (is-values (expand-macro-1 '(bar 1) kernel) '((foo 1) t))
    (is-values (expand-macro-1 '(baz 1) kernel) '((baz 1) nil))
    (is-values (expand-macro-1 'a kernel) '(1.0 t))
    (is-values (expand-macro-1 'b kernel) '(a t))
    (is-values (expand-macro-1 'c kernel) '(c nil))
    (is-error (expand-macro-1 '(foo) kernel) error)))


;;;
;;; test EXPAND-MACRO function
;;;

(subtest "EXPAND-MACRO"

  (let ((kernel (make-kernel)))
    (kernel-define-macro kernel 'foo '(x) '(`(return ,x)))
    (kernel-define-macro kernel 'bar '(x) '(`(foo ,x)))
    (kernel-define-symbol-macro kernel 'a 1.0)
    (kernel-define-symbol-macro kernel 'b 'a)
    (is-values (expand-macro '(foo 1) kernel) '((return 1) t))
    (is-values (expand-macro '(bar 1) kernel) '((return 1) t))
    (is-values (expand-macro '(baz 1) kernel) '((baz 1) nil))
    (is-values (expand-macro 'a kernel) '(1.0 t))
    (is-values (expand-macro 'b kernel) '(1.0 t))
    (is-values (expand-macro 'c kernel) '(c nil))
    (is-error (expand-macro '(foo)) error)))


;;;
;;; test KERNEL-DEFINE-SYMBOL-MACRO function
;;;

(subtest "KERNEL-DEFINE-SYMBOL-MACRO"

  (let ((kernel (make-kernel)))
    (is (kernel-define-symbol-macro kernel 'x 1.0)
        'x "basic case 1"))

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-symbol-macro kernel 1 1.0) type-error
              "NAME which is not a oclcl symbol.")))


;;;
;;; test KERNEL-SYMBOL-MACRO-EXISTS-P function
;;;

(subtest "KERNEL-SYMBOL-MACRO-EXISTS-P"

  (let ((kernel (make-kernel)))
    (kernel-define-symbol-macro kernel 'x 1.0)
    (is (kernel-symbol-macro-exists-p kernel 'x) t
        "basic case 1")
    (is (kernel-symbol-macro-exists-p kernel 'y) nil
        "basic case 2")))


;;;
;;; test KERNEL-SYMBOL-MACRO-NAME function
;;;




;;;
;;; test KERNEL-SYMBOL-MACRO-EXPANSION function
;;;

;;; Global
;;;

(subtest "kernel-define-memory"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'foo :global 42)
    (is (kernel-memory-exists-p kernel 'foo)
        t)
    (is (kernel-memory-name kernel 'foo)
        'foo)
    (is (kernel-memory-c-name kernel 'foo)
        "oclcl_test_lang_kernel_foo")
    (is (kernel-address-space-qualifiers kernel 'foo)
        '(:global))
    (is (kernel-memory-expression kernel 'foo)
        42))

  (let ((kernel (make-kernel)))
    ;; Name in variable namespace should be overwrited.
    (kernel-define-symbol-macro kernel 'foo 42)
    (kernel-define-memory kernel 'foo :global 42)
    (is (kernel-memory-exists-p kernel 'foo)
        t)
    (is (kernel-symbol-macro-exists-p kernel 'foo)
        nil))

  (let ((kernel (make-kernel)))
    ;; Give multiple qualifiers.
    (kernel-define-memory kernel 'foo '(:global :constant) 42)
    (is (kernel-address-space-qualifiers kernel 'foo)
        '(:global :constant)))

  (is-error (kernel-define-memory :foo 'foo :global 42)
            type-error
            "Invalid kernel.")

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-memory kernel "foo" :global 42)
              type-error
              "Invalid name."))

  (let ((kernel (make-kernel)))
    (is-error (kernel-define-memory kernel 'foo :foo 42)
              type-error
              "Invalid qualifier.")))

(subtest "kernel-memory-exists-p"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'foo :global 42)
    (kernel-define-symbol-macro kernel 'bar 42)
    (is (kernel-memory-exists-p kernel 'foo)
        t)
    (is (kernel-memory-exists-p kernel 'bar)
        nil)
    (is (kernel-memory-exists-p kernel 'baz)
        nil))

  (is-error (kernel-memory-exists-p :foo 'foo)
            type-error
            "Invalid kernel.")

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-exists-p kernel "foo")
              type-error
              "Invalid name.")))

(subtest "kernel-memory-name"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'foo :global 42)
    (is (kernel-memory-name kernel 'foo)
        'foo))

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-name kernel 'foo)
              simple-error
              "Global not found."))

  (is-error (kernel-memory-name :foo 'foo)
            type-error
            "Invalid kernel.")

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-name kernel "foo")
              type-error
              "Invalid name.")))

(subtest "kernel-memory-c-name"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'foo :global 42)
    (is (kernel-memory-c-name kernel 'foo)
        "oclcl_test_lang_kernel_foo"))

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-c-name kernel 'foo)
              simple-error
              "Global not found."))

  (is-error (kernel-memory-c-name :foo 'foo)
            type-error
            "Invalid kernel.")

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-c-name kernel "foo")
              type-error
              "Invalid name.")))

(subtest "kernel-address-space-qualifiers"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'foo :global 42)
    (is (kernel-address-space-qualifiers kernel 'foo)
        '(:global)))

  (let ((kernel (make-kernel)))
    (is-error (kernel-address-space-qualifiers kernel 'foo)
              simple-error
              "Global not found."))

  (is-error (kernel-address-space-qualifiers :foo 'foo)
            type-error
            "Invalid kernel.")

  (let ((kernel (make-kernel)))
    (is-error (kernel-address-space-qualifiers kernel "foo")
              type-error
              "Invalid name.")))

(subtest "kernel-memory-expression"
  (let ((kernel (make-kernel)))
    (kernel-define-memory kernel 'foo :global 42)
    (is (kernel-memory-expression kernel 'foo)
        42))

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-expression kernel 'foo)
              simple-error
              "Global not found."))

  (is-error (kernel-memory-expression :foo 'foo)
            type-error
            "Invalid kernel.")

  (let ((kernel (make-kernel)))
    (is-error (kernel-memory-expression kernel "foo")
              type-error
              "Invalid name.")))

(finalize)
