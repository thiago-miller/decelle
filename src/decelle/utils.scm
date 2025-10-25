;; src/decelle/utils.scm
(define-module (decelle utils)
  #:use-module (decelle wire)
  #:export (check-wire-counts make-wire-list))

(define (check-wire-counts caller expected-count . bundle)
  (let ((count-lst (map length bundle)))
    (unless (and (= (car count-lst) expected-count)
                 (or (= (length count-lst) 1)
                     (apply = count-lst)))
      (error "Wire count mismatch"
             expected-count count-lst
             caller))))

(define (ι n)
  (let loop ((i 0) (acc '()))
    (if (= i n)
      (reverse acc)
      (loop (+ i 1) (cons i acc)))))

(define (make-wire-list n)
  (map (λ (_) (make-wire)) (ι n)))
