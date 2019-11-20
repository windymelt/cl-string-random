(defpackage cl-string-random
  (:use :cl :trivia :iter)
  (:export :string-random))
(in-package :cl-string-random)

(defparameter *random-max-count* 10)

(defun solve-char-class-range (c d)
  (let* ((cc (char-code c))
         (cd (char-code d))
         (cx (min cc cd))
         (cy (max cc cd)))
    (code-char (+ cx (random (- cy (+ 1 cx)))))))

(defun printable-ascii-list () (alexandria:iota (- 127 #.(char-code #\Space)) :start #.(char-code #\Space)))

;;; 反転文字クラスを解決する関数
;;; printableなASCIIから奪っていく
(defun solve-inverted-char-class-range (xs) ;; '(#\a #\b (:RANGE #\v #\x)) みたいなのを想定している
  (code-char
   (alexandria:random-elt
    (let ((codes (printable-ascii-list))) ;; printableなものだけ使う
      (iter
        (for x in xs)
        (match x
          ((list :RANGE a z) ;; TODO: 大小正規化する
           (iter
             (for y from (char-code (or a (code-char 0))) to (char-code (or z (code-char 127))))
             (setf codes (remove y codes))))
          (otherwise (setf codes (remove (char-code x) codes)))))
      codes))))

(defun do-reduction (parsed-tree)
  (match parsed-tree
    (:VOID "")
    ((list* :SEQUENCE seq)
     (if (notany #'(lambda (x) (or (listp x) (keywordp x))) seq)
         (format nil "~{~A~}" seq)
         (append '(:SEQUENCE) (mapcar #'do-reduction seq)))) ; todo
    ((list* :ALTERNATION options) (alexandria:random-elt options))
    ((list :REGISTER sth) sth) ; ignoring
    ((list :RANGE a z)
      (solve-char-class-range a z))
    ((list :GREEDY-REPETITION n m tr)
     (match m
       (nil
        `(:SEQUENCE ,@(make-list (+ n (random (- *random-max-count* n))) :initial-element tr)))
       ((guard m (= n m))
        `(:SEQUENCE ,@(make-list n :initial-element tr)))
       (otherwise `(:SEQUENCE ,@(make-list (+ n (random (+ 1 (- m n)))) :initial-element tr)))))
    ((list* :CHAR-CLASS cls) (alexandria:random-elt cls))
    ((list* :INVERTED-CHAR-CLASS cls) (solve-inverted-char-class-range cls))
    (:DIGIT-CLASS (char (format nil "~A" (random 10)) 0))
    (:EVERYTHING (code-char (alexandria:random-elt (printable-ascii-list))))
    (as-is as-is)))

(defun string-random (regex-string)
  (string (iter
            (initially (setf tree (cl-ppcre:parse-string regex-string)))
            (for tree next (do-reduction tree))
            (for ptree previous tree initially nil)
            (when (equal tree ptree) (leave tree)))))
