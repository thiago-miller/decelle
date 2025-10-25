;; src/decelle/register.scm
(define-module (decelle register)
  #:use-module (decelle utils)
  #:use-module (decelle wire)
  #:use-module (decelle circuits)
  #:use-module (decelle flip-flop)
  #:export (reg reg-4))

;; General Purpose Register - GPR
(define (reg in clk load out after-delay)
  (let ((mux-out (make-wire))
        (~out (make-wire)))
    (mux-2 out in load mux-out after-delay)
    (dff mux-out clk out ~out after-delay)
    'ok))

;; Generic reg constructor
(define (make-reg-n n in-lst clk load out-lst after-delay)
  (check-wire-counts 'make-reg-n n in-lst out-lst)
  (for-each
    (λ (d q)
       (reg d clk load q after-delay))
    in-lst out-lst)
  'ok)

;; 4 bits reg
(define (reg-4 . args)
  (apply make-reg-n 4 args))
