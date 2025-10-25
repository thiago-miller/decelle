;; t/test-decelle-utils.scm
(use-modules (srfi srfi-64)
             (decelle utils)
             (decelle wire))

(test-begin "decelle-utils")

(test-equal "make-wire-list returns correct length"
  5
  (length (make-wire-list 5)))

(test-equal "make-wire-list produces unique wires"
  #t
  (let* ((lst (make-wire-list 3))
         (ids (map identity lst)))
    (not (equal? (list-ref ids 0) (list-ref ids 1)))))

(test-equal "check-wire-counts accepts matching lists"
  'ok
  (begin
    (check-wire-counts 'dummy 3
      (list (make-wire) (make-wire) (make-wire))
      (list (make-wire) (make-wire) (make-wire)))
    'ok))

(test-error "check-wire-counts raises error on mismatch"
  error
  (check-wire-counts 'dummy 3
    (list (make-wire) (make-wire) (make-wire))
    (list (make-wire) (make-wire))))

(test-equal "check-wire-counts works with single list"
  'ok
  (begin
    (check-wire-counts 'single 2
      (list (make-wire) (make-wire)))
    'ok))

(test-end "decelle-utils")
