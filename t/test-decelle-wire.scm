;; t/test-decelle-wire.scm
(use-modules (srfi srfi-64)
             (decelle wire))

(test-begin "decelle-wire")

(test-equal "new wire has signal 0"
  0
  (let ((w (make-wire)))
    (get-signal w)))

(test-equal "set-signal! updates the signal value"
  1
  (let ((w (make-wire)))
    (set-signal! w 1)
    (get-signal w)))

(test-equal "add-action! runs procedure immediately on registration"
  '(called)
  (let ((w (make-wire))
        (flag '()))
    (add-action! w (λ () (set! flag (cons 'called flag))))
    flag))

(test-equal "add-action! triggers procedure on signal change"
  '(called called)
  (let ((w (make-wire))
        (flag '()))
    (add-action! w (λ () (set! flag (cons 'called flag))))
    (set-signal! w 1)
    flag))

(test-equal "adding the same procedure twice triggers both independently"
  '(called called called called)
  (let ((w (make-wire))
        (flag '()))
    (define proc (λ () (set! flag (cons 'called flag))))
    (add-action! w proc) ;; runs once
    (add-action! w proc) ;; runs again
    (set-signal! w 1)    ;; triggers both again
    flag))

(test-end "decelle-wire")
