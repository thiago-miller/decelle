;; t/test-decelle-agenda.scm
(use-modules (srfi srfi-64)
             (decelle agenda))

(test-begin "decelle-agenda")

(define a (make-agenda))

(test-assert "agenda starts empty"
  (empty-agenda? a))

(test-equal "current time starts at 0"
  0
  (current-agenda-time a))

;; Adiciona ações em tempos diferentes
(add-to-agenda! 10 'A a)
(add-to-agenda! 5 'B a)
(add-to-agenda! 15 'C a)
(add-to-agenda! 10 'D a)

(test-equal "first item should be B (time 5)"
  'B
  (first-agenda-item a))

(test-equal "current time should now be 5"
  5
  (current-agenda-time a))

(remove-first-agenda-item! a)

(test-equal "next item should be A (time 10)"
  'A
  (first-agenda-item a))

(remove-first-agenda-item! a)

(test-equal "next item should be D (also time 10)"
  'D
  (first-agenda-item a))

(remove-first-agenda-item! a)

(test-equal "next item should be C (time 15)"
  'C
  (first-agenda-item a))

(remove-first-agenda-item! a)

(test-assert "agenda is empty again"
  (empty-agenda? a))

(test-end "decelle-agenda")
