;; src/decelle/alu.scm
(define-module (decelle alu)
  #:use-module (decelle utils)
  #:use-module (decelle wire)
  #:use-module (decelle gates)
  #:use-module (decelle circuits)
  #:export (alu-4))

;; ALU 4 operations: AND, OR, ADD, SUB
;; sel1 sel0 op
;; 0    0    AND
;; 0    1    OR
;; 1    0    ADD
;; 1    1    SUB

;; 74181, the classic 4-bits ALU from TTL
(define (alu-4 a-lst b-lst sel0 sel1 out-lst c-out after-delay)
  (check-wire-counts 'alu-4 4 a-lst b-lst out-lst)

  (let ((and-outs  (make-wire-list 4))
        (or-outs   (make-wire-list 4))
        (sum-outs  (make-wire-list 4))
        (sub-outs  (make-wire-list 4))
        (~b-lst    (make-wire-list 4))
        (c-in-add  (make-wire))
        (c-in-sub  (make-wire))
        (c-out-add (make-wire))
        (c-out-sub (make-wire))
        (c-zero    (make-wire))
        (c-arith   (make-wire)))

    ;; Init constant signals
    (set-signal! c-zero 0)
    (set-signal! c-in-add 0)
    (set-signal! c-in-sub 1)

    ;; 00 -> AND
    (for-each
      (λ (a b o)
        (and-gate a b o after-delay))
      a-lst b-lst and-outs)

    ;; 01 -> OR
    (for-each
      (λ (a b o)
        (or-gate a b o after-delay))
      a-lst b-lst or-outs)

    ;; Create the inverted B wires for SUB (NOT B)
    (for-each
      (λ (b bi)
        (inverter b bi after-delay))
      b-lst ~b-lst)

    ;; 10 -> ADD
    (ripple-carry-adder-4
      a-lst
      b-lst
      c-in-add
      sum-outs
      c-out-add
      after-delay)

    ;; 11 -> SUB
    (ripple-carry-adder-4
      a-lst
      ~b-lst
      c-in-sub
      sub-outs
      c-out-sub
      after-delay)

    ;;; Select op via mux-4
    (for-each
      (λ (a b c d o)
         (mux-4 a b c d sel0 sel1 o after-delay))
      and-outs or-outs sum-outs sub-outs out-lst)

    ;;; Select c-out:
    ;;; - sel0: add, sub -> c-arithmetic
    ;;; - sel1: c-zero, c-arith -> c-out

    ;; sel0
    (mux-2
      c-out-add
      c-out-sub
      sel0
      c-arith
      after-delay)

    ;; sel1
    (mux-2
      c-zero
      c-arith
      sel1
      c-out
      after-delay)

    'ok))
