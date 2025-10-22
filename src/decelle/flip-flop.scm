;; src/decelle/flip-flop.scm
(define-module (decelle flip-flop)
  #:use-module (decelle wire)
  #:use-module (decelle gates)
  #:export (sr-latch-nand d-latch-nand dff))

(define (sr-latch-nand ~s ~r q ~q after-delay)
  (nand-gate ~s ~q q after-delay)
  (nand-gate q ~r ~q after-delay)
  'ok)

(define (d-latch-nand d e q ~q after-delay)
  (let ((~d (make-wire))
	(~s (make-wire))
	(~r (make-wire)))
    (nand-gate d e ~s after-delay)
    (inverter d ~d after-delay)
    (nand-gate e ~d ~r after-delay)
    (sr-latch-nand ~s ~r q ~q after-delay)
    'ok))

;; positive-edge-triggered d-type flip-flop
(define (dff d clk q ~q after-delay)
  (let ((q-master  (make-wire))
	(~q-master (make-wire))
	(e-master  (make-wire))
	(e-slave   (make-wire)))
    ;; master
    (inverter clk e-master after-delay)
    (d-latch-nand d e-master q-master ~q-master after-delay)
    ;; slave
    (inverter e-master e-slave after-delay)
    (d-latch-nand q-master e-slave q ~q after-delay)
    'ok))
