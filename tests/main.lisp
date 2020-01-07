(defpackage cl-string-random/tests/main
  (:use :cl
        :cl-string-random
        :rove
        :iterate))
(in-package :cl-string-random/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-string-random)' in your Lisp.

(defparameter *regexes*
  '("" "a" "ab" "[ab]" "a|b" "(ab)" "a*" "a+" "(ab)*" "(ab)+" "(ab){4,10}" "(日|本|語)*" "\\d" "\\d{3}-\\d{4}" "\\s\\s\\s\\s"))

(deftest test-target-1
  (iter (for regex in *regexes*)
    (testing regex
             (ok (cl-ppcre:scan regex (string-random regex))))))
