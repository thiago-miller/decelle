;; t/test-decelle-gates.scm
(use-modules (srfi srfi-64)
             (decelle wire)
             (decelle gates))

(test-begin "decelle-gates")

;; Mock after-delay
(define test-events '())

(define (mock-after-delay delay action)
  (set! test-events (cons delay test-events))
  (action))

;; OR
(test-equal "inverter 0 => 1"
  (let ((w1 (make-wire))
        (wout (make-wire)))
    (set! test-events '())
    (set-signal! w1 0)
    (inverter w1 wout mock-after-delay)
    (get-signal wout))
  1)

(test-equal "inverter 1 => 0"
  (let ((w1 (make-wire))
        (wout (make-wire)))
    (set! test-events '())
    (set-signal! w1 1)
    (inverter w1 wout mock-after-delay)
    (get-signal wout))
  0)

;; AND
(test-equal "and-gate 1 1 => 1"
  (let ((a (make-wire))
        (b (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (set-signal! a 1)
    (set-signal! b 1)
    (and-gate a b out mock-after-delay)
    (get-signal out))
  1)

(test-equal "and-gate 1 0 => 0"
  (let ((a (make-wire))
        (b (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (set-signal! a 1)
    (set-signal! b 0)
    (and-gate a b out mock-after-delay)
    (get-signal out))
  0)

;; OR
(test-equal "or-gate 1 0 => 1"
  (let ((a (make-wire))
        (b (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (set-signal! a 1)
    (set-signal! b 0)
    (or-gate a b out mock-after-delay)
    (get-signal out))
  1)

(test-equal "or-gate 0 0 => 0"
  (let ((a (make-wire))
        (b (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (set-signal! a 0)
    (set-signal! b 0)
    (or-gate a b out mock-after-delay)
    (get-signal out))
  0)

;; after-delay called check (isolated)
(test-equal "after-delay called once per gate connection"
  (let ((a (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (set-signal! a 0)
    (inverter a out mock-after-delay)
    (length test-events))
  1)

(test-end "decelle-gates")
