;; t/test-decelle-alu.scm
(use-modules (srfi srfi-64)
             (decelle wire)
             (decelle gates)
             (decelle circuits)
             (decelle alu))

(test-begin "decelle-alu")

;; --- Mock after-delay (executa imediatamente) ---
(define (mock-after-delay delay action)
  (action))

;; --- Helpers ---
(define (wire-signals wires)
  (map get-signal wires))

(define (set-bits! wires bits)
  (for-each set-signal! wires bits))

;; --- ALU wires ---
(define a      (map (λ (_) (make-wire)) '(0 1 2 3)))
(define b      (map (λ (_) (make-wire)) '(0 1 2 3)))
(define out    (map (λ (_) (make-wire)) '(0 1 2 3)))
(define sel0   (make-wire))
(define sel1   (make-wire))
(define c-out  (make-wire))

(alu-4 a b sel0 sel1 out c-out mock-after-delay)

(define a4 '(0 1 1 0)) ;; A = 6
(define b4 '(1 0 1 0)) ;; B = 5

;; --- Testes ---
;; AND
(set-bits! a a4)
(set-bits! b b4)
(set-signal! sel0 0)
(set-signal! sel1 0)
(test-equal "ALU AND output" '(0 0 1 0) (wire-signals out))
(test-equal "ALU AND carry" 0 (get-signal c-out))

;; OR
(set-bits! a a4)
(set-bits! b b4)
(set-signal! sel0 1)
(set-signal! sel1 0)
(test-equal "ALU OR output" '(1 1 1 0) (wire-signals out))
(test-equal "ALU OR carry" 0 (get-signal c-out))

;; ADD
(set-bits! a a4)
(set-bits! b b4)
(set-signal! sel0 0)
(set-signal! sel1 1)
(test-equal "ALU ADD output" '(1 1 0 1) (wire-signals out))
(test-equal "ALU ADD carry" 0 (get-signal c-out))

;; SUB
(set-bits! a a4)
(set-bits! b b4)
(set-signal! sel0 1)
(set-signal! sel1 1)
(test-equal "ALU SUB output" '(1 0 0 0) (wire-signals out))
(test-equal "ALU SUB carry" 1 (get-signal c-out))

(test-end "decelle-alu")
