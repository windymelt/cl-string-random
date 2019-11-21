# Cl-String-Random

Utility to generate string which matches specific regexp.

string_random in Common Lisp

## Usage

`(string-random "\\d{3}-\\d{4}") ;; => "123-4567"`

## Installation

```lisp
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload :cl-string-random)
(use-package :cl-string-random)
```
