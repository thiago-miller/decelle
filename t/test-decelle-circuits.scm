;; t/test-decelle-circuits.scm
(use-modules (srfi srfi-64)
             (decelle utils)
             (decelle wire)
             (decelle gates)
             (decelle circuits))

(test-begin "decelle-circuits")

;; Mock after-delay
(define test-events '())
(define (mock-after-delay delay action)
  (set! test-events (cons (list delay action) test-events))
  (action))

;; HALF ADDER
(test-group "half-adder"
  (let ((a (make-wire))
        (b (make-wire))
        (s (make-wire))
        (c (make-wire)))
    (half-adder a b s c mock-after-delay)

    (set-signal! a 0)
    (set-signal! b 0)
    (test-equal "HA: 0 0 -> sum=0 carry=0" 0 (get-signal s))
    (test-equal "HA: 0 0 -> carry=0" 0 (get-signal c))

    (set-signal! b 1)
    (test-equal "HA: 0 1 -> sum=1 carry=0" 1 (get-signal s))
    (test-equal "HA: 0 1 -> carry=0" 0 (get-signal c))

    (set-signal! a 1)
    (test-equal "HA: 1 1 -> sum=0 carry=1" 0 (get-signal s))
    (test-equal "HA: 1 1 -> carry=1" 1 (get-signal c))))

;; FULL ADDER
(test-group "full-adder"
  (let ((a2 (make-wire))
        (b2 (make-wire))
        (cin (make-wire))
        (sum (make-wire))
        (cout (make-wire)))
    (full-adder a2 b2 cin sum cout mock-after-delay)

    (set-signal! a2 1)
    (set-signal! b2 1)
    (set-signal! cin 1)

    (test-equal "FA: 1 1 1 -> sum=1 carry=1" 1 (get-signal sum))
    (test-equal "FA: 1 1 1 -> carry=1" 1 (get-signal cout))))

(test-group "ripple-carry-adder-4"
  (let ((a-lst (make-wire-list 4))
        (b-lst (make-wire-list 4))
        (s-lst (make-wire-list 4))
        (c-in  (make-wire))
        (c-out (make-wire)))
    (ripple-carry-adder-4 a-lst b-lst c-in s-lst c-out mock-after-delay)

    ;; Simulating 01 + 11 = 100
    (set-signal! (car a-lst) 1)    ;; A0 = 1
    (set-signal! (cadr a-lst) 0)   ;; A2 = 0
    (set-signal! (caddr a-lst) 0)  ;; A3 = 0
    (set-signal! (cadddr a-lst) 0) ;; A4 = 0

    (set-signal! (car b-lst) 1)    ;; B0 = 1
    (set-signal! (cadr b-lst) 1)   ;; B1 = 1
    (set-signal! (caddr b-lst) 1)  ;; B2 = 1
    (set-signal! (cadddr b-lst) 1) ;; B3 = 1

    (set-signal! c-in 0)

    (test-equal "RCA: sum bit 1 = 1" 0 (get-signal (car s-lst)))
    (test-equal "RCA: sum bit 0 = 1" 0 (get-signal (cadr s-lst)))
    (test-equal "RCA: sum bit 0 = 1" 0 (get-signal (caddr s-lst)))
    (test-equal "RCA: sum bit 0 = 1" 0 (get-signal (cadddr s-lst)))
    (test-equal "RCA: carry out = 1" 1 (get-signal c-out))))

;; MUX-2
(test-group "mux-2"
  (let ((a (make-wire))
        (b (make-wire))
        (sel (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (mux-2 a b sel out mock-after-delay)

    ;; sel = 0 → out follows a
    (set-signal! sel 0)
    (set-signal! a 1)
    (set-signal! b 0)
    (test-equal "MUX2: sel=0 -> out=a" 1 (get-signal out))

    ;; sel = 1 → out follows b
    (set-signal! sel 1)
    (set-signal! a 0)
    (set-signal! b 1)
    (test-equal "MUX2: sel=1 -> out=b" 1 (get-signal out))

    ;; alternating
    (set-signal! sel 0)
    (set-signal! a 0)
    (set-signal! b 1)
    (test-equal "MUX2: sel=0 -> out=0" 0 (get-signal out))
    (set-signal! sel 1)
    (test-equal "MUX2: sel=1 -> out=1" 1 (get-signal out))

    (test-assert "MUX2: after-delay called" (> (length test-events) 2))))

;; MUX-4
(test-group "mux-4"
  (let ((a (make-wire))
        (b (make-wire))
        (c (make-wire))
        (d (make-wire))
        (sel0 (make-wire))
        (sel1 (make-wire))
        (out (make-wire)))
    (set! test-events '())
    (mux-4 a b c d sel0 sel1 out mock-after-delay)

    ;; inputs
    (set-signal! a 0)
    (set-signal! b 1)
    (set-signal! c 0)
    (set-signal! d 1)

    ;; 00 -> a
    (set-signal! sel0 0)
    (set-signal! sel1 0)
    (test-equal "MUX4: sel=00 -> out=a" (get-signal a) (get-signal out))

    ;; 01 -> b
    (set-signal! sel0 1)
    (set-signal! sel1 0)
    (test-equal "MUX4: sel=01 -> out=b" (get-signal b) (get-signal out))

    ;; 10 -> c
    (set-signal! sel0 0)
    (set-signal! sel1 1)
    (test-equal "MUX4: sel=10 -> out=c" (get-signal c) (get-signal out))

    ;; 11 -> d
    (set-signal! sel0 1)
    (set-signal! sel1 1)
    (test-equal "MUX4: sel=11 -> out=d" (get-signal d) (get-signal out))

    (test-assert "MUX4: after-delay called" (> (length test-events) 4))))

(test-end "decelle-circuits")
