;; src/decelle/circuits.scm
(define-module (decelle circuits)
  #:use-module (decelle wire)
  #:use-module (decelle gates)
  #:export (half-adder full-adder ripple-carry-adder))

(define (half-adder a b s c after-delay)
  (xor-gate a b s after-delay)
  (and-gate a b c after-delay)
  'ok)

(define (full-adder a b c-in sum c-out after-delay)
  (let ((s (make-wire)) (c1 (make-wire)) (c2 (make-wire)))
    (half-adder b c-in s c1 after-delay)
    (half-adder a s sum c2 after-delay)
    (or-gate c1 c2 c-out after-delay)
    'ok))

;; Use the least significant bit (LSB)
(define (ripple-carry-adder a-lst b-lst c-start s-lst c-final after-delay)
  (define (make-ripple ak bk c-in sk)
    (if (null? ak)
      'ok
      (let ((c-out (if (null? (cdr ak))
                     c-final
                     (make-wire))))
        (full-adder (car ak) (car bk) c-in (car sk) c-out after-delay)
        (make-ripple (cdr ak) (cdr bk) c-out (cdr sk)))))
  (if (= (length a-lst) (length b-lst) (length s-lst))
    (make-ripple a-lst b-lst c-start s-lst)
    (error "Wrong number of wires: RIPPLE-CARRY-ADDER"
           (list a-lst b-lst s-lst))))
