(defsystem "cl-string-random"
  :version "0.1.0"
  :author "Windymelt"
  :license "Apache License 2.0"
  :depends-on (:cl-ppcre :trivia :iterate)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Utility to generate string which matches specific regexp"
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "cl-string-random/tests"))))

(defsystem "cl-string-random/tests"
  :author "Windymelt"
  :license "Apache License 2.0"
  :depends-on ("cl-string-random"
               "rove"
               "iterate")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-string-random"

  :perform (test-op (op c) (symbol-call :rove :run c)))
