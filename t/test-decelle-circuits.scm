;; t/test-decelle-circuits.scm
(use-modules (srfi srfi-64)
             (decelle wire)
             (decelle gates)
             (decelle circuits))

(test-begin "decelle-circuits")

;; Mock do after-delay
(define test-events '())
(define (mock-after-delay delay action)
  (set! test-events (cons (list delay action) test-events))
  (action))

;; --- Half Adder ---
(define a (make-wire))
(define b (make-wire))
(define s (make-wire))
(define c (make-wire))

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
(test-equal "HA: 1 1 -> carry=1" 1 (get-signal c))

;; --- Full Adder ---
(define a2 (make-wire))
(define b2 (make-wire))
(define cin (make-wire))
(define sum (make-wire))
(define cout (make-wire))

(full-adder a2 b2 cin sum cout mock-after-delay)

(set-signal! a2 1)
(set-signal! b2 1)
(set-signal! cin 1)

(test-equal "FA: 1 1 1 -> sum=1 carry=1" 1 (get-signal sum))
(test-equal "FA: 1 1 1 -> carry=1" 1 (get-signal cout))

;; --- Ripple Carry Adder (2 bits) ---
(define a-lst (list (make-wire) (make-wire)))
(define b-lst (list (make-wire) (make-wire)))
(define s-lst (list (make-wire) (make-wire)))
(define c-in (make-wire))
(define c-out (make-wire))

(ripple-carry-adder a-lst b-lst c-in s-lst c-out mock-after-delay)

;; Simulating 01 + 11 = 100
(set-signal! (car a-lst) 1)  ;; A0 = 1
(set-signal! (cadr a-lst) 0) ;; A1 = 0
(set-signal! (car b-lst) 1)  ;; B0 = 1
(set-signal! (cadr b-lst) 1) ;; B1 = 1
(set-signal! c-in 0)

(test-equal "RCA: sum bit 0 = 0" 0 (get-signal (car s-lst)))
(test-equal "RCA: sum bit 1 = 0" 0 (get-signal (cadr s-lst)))
(test-equal "RCA: carry out = 1" 1 (get-signal c-out))

(test-end "decelle-circuits")
