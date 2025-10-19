#!/usr/bin/env guile
!#

(use-modules (srfi srfi-64)
             (decelle queue))

(test-begin "decelle-queue")

(define q (make-queue))

(test-assert "queue should start empty"
  (empty-queue? q))

(insert-queue! q 'a)
(test-equal "front element after first insert"
  'a (front-queue q))
(test-assert "queue not empty after insert"
  (not (empty-queue? q)))

(insert-queue! q 'b)
(insert-queue! q 'c)

(test-equal "front remains the same after multiple inserts"
  'a (front-queue q))

(delete-queue! q)
(test-equal "front updates after delete"
  'b (front-queue q))

(delete-queue! q)
(delete-queue! q)
(test-assert "queue empty after deleting all elements"
  (empty-queue? q))

(test-error "delete-queue! should raise error when empty"
  (delete-queue! q))

(test-end)
