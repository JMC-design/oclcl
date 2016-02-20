#|
  This file is a part of oclcl project.
  Copyright (c) 2012 Masayuki Takagi (kamonama@gmail.com)
                2015 gos-k (mag4.elan@gmail.com)
|#

(in-package :cl-user)
(defpackage oclcl-test.lang.util
  (:use :cl :prove
        :oclcl.lang.util))
(in-package :oclcl-test.lang.util)

(plan nil)


;;;
;;; test C-IDENTIFIER function
;;;

(subtest "C-IDENTIFIER"
  (is (c-identifier 'x) "x"
      "basic case 1")
  (is (c-identifier 'vec-add-kernel) "vec_add_kernel"
      "basic case 2")
  (is (c-identifier 'vec.add.kernel) "vec_add_kernel"
      "basic case 3")
  (is (c-identifier '%vec-add-kernel) "_vec_add_kernel"
      "basic case 4")
  (is (c-identifier 'VecAdd_kernel) "vecadd_kernel"
      "basic case 5")
  (is (c-identifier 'foo t) "oclcl_test_lang_util_foo"
      "basic case 6"))

(subtest "C-MACRO-NAME"
  (is (c-macro-name :--alfa-bravo-charlie--)
      "__ALFA_BRAVO_CHARLIE__"
      "keyword symbol to C macro name"))

;;;
;;; test LINES function
;;;

(subtest "LINES"
  (is (lines (format nil "1~%2~%3~%")) '("1" "2" "3")
      "basic case 1")
  (is (lines (format nil "1~%2~%3")) '("1" "2" "3")
      "basic case 2"))


;
;;; test UNLINES function
;;;

(subtest "UNLINES"
  (is (unlines "1" "2" "3") "1
2
3
" "basic case 1"))


;;;
;;; test INDENT function
;;;

(subtest "INDENT"
  (is (indent 2 (format nil "1~%2~%3~%")) "  1
  2
  3
" "basic case 1")

  (is (indent 2 (format nil "1~%2~%3")) "  1
  2
  3
" "basic case 2"))


(finalize)
