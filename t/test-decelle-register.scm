;; t/test-decelle-register.scm
(use-modules (srfi srfi-64)
             (decelle wire)
             (decelle gates)
             (decelle flip-flop)
             (decelle register)
             (decelle utils))

(test-begin "decelle-register")

(define (after-delay delay proc)
  (proc))

(define clk (make-wire))

(define (make-bundle n)
  (make-wire-list n))

(let* ((in  (make-bundle 4))
       (out (make-bundle 4))
       (load (make-wire)))
  (reg-4 in clk load out after-delay)
  (test-equal "register wires created" 4 (length in))
  (test-equal "output wires created" 4 (length out)))

(let* ((in  (make-bundle 4))
       (out (make-bundle 4))
       (load (make-wire))
       (clk (make-wire)))
  (for-each (λ (w) (set-signal! w 0)) in)
  (for-each (λ (w) (set-signal! w 0)) out)
  (set-signal! load 1)

  (reg-4 in clk load out after-delay)

  (for-each (λ (w) (set-signal! w 1)) in)
  (set-signal! clk 1)

  (test-equal "register stores new values"
    (map get-signal in)
    (map get-signal out))

  (set-signal! load 0)
  (for-each (λ (w) (set-signal! w 0)) in)
  (set-signal! clk 1)

  (test-equal "register holds value when load=0"
    '(1 1 1 1)
    (map get-signal out)))

(test-end "decelle-register")
