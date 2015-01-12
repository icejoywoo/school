
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

; 1
(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

; 2
(define (string-append-map xs suffix)
  (map (lambda (x)
         (string-append x suffix)) xs))

; 3
(define (list-nth-mod xs n)
  (cond
    [(< n 0) (error "list-nth-mod: negative number")]
    [(null? xs) (error "list-nth-mod: empty list")]
    [#t (car (list-tail xs (remainder n (length xs))))]))

; 4
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([pr (s)])
        (cons (car pr) (stream-for-n-steps (cdr pr) (- n 1))))))

; 5
(define (funny-number-stream)
  (letrec ([f (lambda (n) (cons (if (= (remainder n 5) 0) (- n) n) (lambda () (f (+ n 1)))))])
    (cons 1 (lambda () (f 2)))))

; 6
(define (dan-then-dog)
  (letrec ([xs (list "dan.jpg" "dog.jpg")]
           [f (lambda (n) (cons (list-nth-mod xs n) (lambda () (f (+ n 1)))))])
    (cons (list-nth-mod xs 0) (lambda () (f 1)))))

; 7
(define (stream-add-zero s)
  (letrec ([f (lambda (s) (let ([pr (s)])
                (cons (cons 0 (car pr)) (lambda () (f (cdr pr))))))])
    (lambda () (f s))))

; 8
(define (cycle-lists xs ys)
  (letrec ([f (lambda (n)
                (cons
                 (cons (list-nth-mod xs n) (list-nth-mod ys n))
                 (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

; 9
(define (vector-assoc v vec)
  (letrec ([f (lambda (n)
                (if (< n (vector-length vec)) 
                    (let ([current (vector-ref vec n)])
                      (if (pair? current)
                          (if (equal? (car current) v)
                              current
                              (f (+ n 1)))
                          (f (+ n 1))))
                    #f))])
    (f 0)))

; 10
(define (cached-assoc xs n)
  (letrec ([index 0]
           [cache (make-vector n #f)]
           [f (lambda (v)
             (let ([cache-ret (vector-assoc v cache)])
               (if cache-ret
                   (cdr cache-ret)
                   (let ([ret (assoc v xs)])
                     (begin
                       (vector-set! cache index (cons v ret))
                       (set! index (+ index 1))
                       ret)))))])
    f))
               
; 11
(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (letrec ([high e1]
              [low e2]
              [f (lambda () (if (< low high)
                                (begin 
                                  (set! low e2)
                                  (f))
                                #t))])
       (f))]))

