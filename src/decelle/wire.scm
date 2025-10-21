;; src/decelle/wire.scm
(define-module (decelle wire)
  #:export (make-wire get-signal set-signal! add-action!))

(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (unless (= signal-value new-value)
        (set! signal-value new-value)
        (for-each (λ (f) (f)) action-procedures))
      'done)
    (define (accept-action-procedure! proc)
      (set! action-procedures
        (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (case m
        ((get-signal) signal-value)
        ((set-signal!) set-my-signal!)
        ((add-action!) accept-action-procedure!)
        (else (error "Unknown operation: WIRE" m))))
    dispatch))

(define (get-signal wire)
  (wire 'get-signal))

(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))

(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))
