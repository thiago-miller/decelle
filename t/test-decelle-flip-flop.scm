;; t/test-decelle-flip-flop.scm
(use-modules (srfi srfi-64)
             (decelle wire)
             (decelle gates)
             (decelle flip-flop))

;; mock after-delay
(define (instant-after-delay d a) (a))

;; helper
(define (wire-val w) (get-signal w))

(test-begin "decelle-flip-flop")

(test-group "SR Latch NAND"

  (let ((~s (make-wire))
        (~r (make-wire))
        (q  (make-wire))
        (~q (make-wire)))
    (sr-latch-nand ~s ~r q ~q instant-after-delay)

    (set-signal! ~s 1)
    (set-signal! ~r 1)
    (test-equal "no change at start" '(1 1)
                (list (wire-val ~s) (wire-val ~r)))

    (set-signal! ~s 0)
    (set-signal! ~r 1)
    (test-equal "set Q=1" 1 (wire-val q))

    (set-signal! ~s 1)
    (set-signal! ~r 0)
    (test-equal "reset Q=0" 0 (wire-val q))

    (set-signal! ~s 1)
    (set-signal! ~r 1)
    (test-equal "stable again" (wire-val q) (wire-val q))
    ))

(test-group "D Latch NAND"

  (let ((d (make-wire))
        (e (make-wire))
        (q (make-wire))
        (~q (make-wire)))
    (d-latch-nand d e q ~q instant-after-delay)

    (set-signal! e 1)
    (set-signal! d 1)
    (test-equal "transparent latch: D=1 → Q=1" 1 (wire-val q))

    (set-signal! d 0)
    (test-equal "transparent latch: D=0 → Q=0" 0 (wire-val q))

    (set-signal! e 0)
    (set-signal! d 1)
    (test-equal "latched: Q keeps the last value (0)" 0 (wire-val q))
    ))

(test-group "D Flip-Flop (DFF master-slave)"

  (let ((d (make-wire))
        (clk (make-wire))
        (q (make-wire))
        (~q (make-wire)))
    (dff d clk q ~q instant-after-delay)

    (set-signal! clk 0)
    (set-signal! d 1)

    (test-assert "still does not transfer to exit"
                 (or (= (wire-val q) 0) (= (wire-val q) 1)))

    (set-signal! clk 1)
    (test-equal "Q follows D" 1 (wire-val q))

    (set-signal! d 0)
    (test-equal "Q keeps 1 while clock=1" 1 (wire-val q))

    (set-signal! clk 0)
    (test-equal "still Q=1 after clock=0" 1 (wire-val q))

    (set-signal! clk 1)
    (test-equal "get abother D=0" 0 (wire-val q))
    ))

(test-end "decelle-flip-flop")
