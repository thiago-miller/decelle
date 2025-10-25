;; src/decelle/circuits.scm
(define-module (decelle circuits)
  #:use-module (decelle utils)
  #:use-module (decelle wire)
  #:use-module (decelle gates)
  #:export (half-adder full-adder ripple-carry-adder-4 mux-2 mux-4))

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
(define (make-ripple-carry-adder-n n a-lst b-lst c-start s-lst c-final after-delay)
  (define (make-ripple ak bk c-in sk)
    (if (null? ak)
      'ok
      (let ((c-out (if (null? (cdr ak))
                     c-final
                     (make-wire))))
        (full-adder (car ak) (car bk) c-in (car sk) c-out after-delay)
        (make-ripple (cdr ak) (cdr bk) c-out (cdr sk)))))
  (check-wire-counts make-ripple-carry-adder-n n a-lst b-lst s-lst)
  (make-ripple a-lst b-lst c-start s-lst))

(define (ripple-carry-adder-4 . args)
  (apply make-ripple-carry-adder-n 4 args))

;; out = (NOT sel AND a) OR (sel AND b)
(define (mux-2 a b sel out after-delay)
  (let ((not-sel (make-wire))
        (and-1 (make-wire))
        (and-2 (make-wire)))
    (inverter sel not-sel after-delay)
    (and-gate not-sel a and-1 after-delay)
    (and-gate sel b and-2 after-delay)
    (or-gate and-1 and-2 out after-delay)
    'ok))

;; High order constructor
(define (make-mux-n n inputs selectors output after-delay)
  ;; folding pairwise reduction
  (define (reduce-level cur-lst next-lst sel)
    (if (and (null? (cddr cur-lst))
             (null? next-lst))
      (begin ;; last reduction
        (mux-2 (car cur-lst) (cadr cur-lst) (car sel)
               output after-delay)
        'ok)
      (let ((o (make-wire)))
        (mux-2 (car cur-lst) (cadr cur-lst) (car sel)
               o after-delay)
        (if (null? (cddr cur-lst))
          ;; reduce one level
          (reduce-level (reverse (cons o next-lst))
                        '() (cdr sel))
          ;; next pair
          (reduce-level (cddr cur-lst)
                        (cons o next-lst) sel)))))
  (check-wire-counts make-mux-n n inputs)
  (check-wire-counts make-mux-n (/ (log n) (log 2)) selectors)
  (reduce-level inputs '() selectors))

(define (mux-4 a b c d sel0 sel1 out after-delay)
  (make-mux-n 4
              (list a b c d)
              (list sel0 sel1)
              out
              after-delay))
