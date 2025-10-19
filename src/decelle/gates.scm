;; src/decelle/gates.scm
(define-module (decelle gates)
  #:use-module (decelle wire)
  #:export (inverter and-gate or-gate))

;; Local constants
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)

;; Logical tests
;; Not the most efficient code, but it is simple
;; as we were building logical tests from scratch
(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))

(define (logical-and s1 s2)
  (cond ((and (= s1 1) (= s2 1)) 1)
        ((and (= s1 1) (= s2 0)) 0)
        ((and (= s1 0) (= s2 1)) 0)
        ((and (= s1 0) (= s2 0)) 0)
        (else (error "Invalid signal" (list s1 s2)))))

(define (logical-or s1 s2)
  (cond ((and (= s1 1) (= s2 1)) 1)
        ((and (= s1 1) (= s2 0)) 1)
        ((and (= s1 0) (= s2 1)) 1)
        ((and (= s1 0) (= s2 0)) 0)
        (else (error "Invalid signal" (list s1 s2)))))

;; High order constructor
;; (after-delay delay action)
(define (make-gate gate-delay logical-test input-wires output-wire after-delay)
  (define (gate-action)
    (let ((new-value (apply logical-test (map get-signal input-wires))))
      (after-delay gate-delay
                   (λ () (set-signal! output-wire new-value)))))
  (for-each (λ (w) (add-action! w gate-action)) input-wires))

(define (inverter input output after-delay)
  (make-gate
    inverter-delay
    logical-not
    (list input)
    output
    after-delay))

(define (and-gate a1 a2 output after-delay)
  (make-gate
    and-gate-delay
    logical-and
    (list a1 a2)
    output
    after-delay))

(define (or-gate a1 a2 output after-delay)
  (make-gate
    or-gate-delay
    logical-or
    (list a1 a2)
    output
    after-delay))
