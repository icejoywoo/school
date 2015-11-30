;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1

(define (racketlist->mupllist es)
  (if (null? es)
      (aunit)
      (apair (car es) (racketlist->mupllist (cdr es)))))

; (b)
(define (mupllist->racketlist ms)
  (if (aunit? ms)
      null
      (cons (apair-e1 ms) (mupllist->racketlist (apair-e2 ms)))))

;; Problem 2

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))]
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        ;; CHANGE add more cases here
        [(int? e) e]
        [(ifgreater? e)
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error (format "bad MUPL expression: ~v" e))))]
        [(mlet? e)
         (let ([name (mlet-var e)]
               [value (eval-under-env (mlet-e e) env)])
           (eval-under-env (mlet-body e) (cons (cons name value) env)))]
        [(call? e)
         (let ([funexp (eval-under-env (call-funexp e) env)]
               [actual (eval-under-env (call-actual e) env)])
           (if (closure? funexp)
               (letrec ([c-env (closure-env funexp)]
                        [c-fun (closure-fun funexp)]
                        [c-fun-name (fun-nameopt c-fun)]
                        [c-fun-formal (fun-formal c-fun)])
                 (if c-fun-name
                     (eval-under-env (fun-body c-fun) (cons (cons c-fun-name funexp) (cons (cons c-fun-formal actual) (append c-env env))))
                     (eval-under-env (fun-body c-fun) (cons (cons c-fun-formal actual) (append c-env env)))))
               (error (format "bad MUPL expression: ~v" e))))]
        [(fun? e) (closure env e)]
        [(closure? e) e]
        [(apair? e)
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]
        [(aunit? e) e]
        [(fst? e)
         (let ([p (eval-under-env (fst-e e) env)])
           (if (apair? p)
               (apair-e1 (eval-under-env p env))
               (error (format "bad MUPL expression: ~v" e))))]
        [(snd? e)
         (let ([p (eval-under-env (snd-e e) env)])
           (if (apair? p)
               (apair-e2 (eval-under-env p env))
               (error (format "bad MUPL expression: ~v" e))))]
        [(isaunit? e)
         (let ([exp (eval-under-env (isaunit-e e) env)])
           (if (aunit? exp) (int 1) (int 0)))]

        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3))

(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (let ([var (caar lstlst)]
            [e (cdar lstlst)])
        (mlet var e (mlet* (cdr lstlst) e2)))))

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2))
         (ifgreater (var "_x") (var "_y") e4
                    (ifgreater (var "_y") (var "_x")
                               e4 e3))))

;; Problem 4

(define mupl-map
  (fun "mupl-map" "f"
       (fun #f "xs"
            (ifaunit (var "xs")
                     (aunit)
                     (apair (call (var "f") (fst (var "xs")))
                            (call (call (var "mupl-map") (var "f"))
                                  (snd (var "xs"))))))))

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "f" (call (var "map") (fun #f "x" (add (var "x") (var "f")))))))

;; Challenge Problem

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e)
  (letrec ([helper
            (lambda (e)
              (cond ([(var? e)
                      (cons e (set (var-string e)))]
                     [(int? e)
                      (begin
                        (print (format "~v" e))
                        (cons e (set)))]
                     [(add? e)
                      (let ([v1 (helper (add-e1 e))]
                            [v2 (helper (add-e2 e))])
                        (cons (add (car v1) (car v2))
                              (set-union (cdr v2) (cdr v2))))]
                     [(ifgreater? e)
                      (let ([v1 (helper (ifgreater-e1 e))]
                            [v2 (helper (ifgreater-e2 e))]
                            [v3 (helper (ifgreater-e3 e))]
                            [v4 (helper (ifgreater-e4 e))])
                        (cons (ifgreater (car v1) (car v2) (car v3) (car v4))
                              (set-union (cdr v1) (cdr v2) (cdr v3) (cdr v4))))]
                     [(fun? e)
                      (letrec ([v1 (fun-nameopt e)]
                               [v2 (fun-formal e)]
                               [r1 (helper (fun-body e))]
                               [fvs (set-remove (set-remove (cdr r1) v1) v2)])
                        (cons (fun-challenge v1 v2 (car r1) fvs)
                              fvs))]
                     [(call? e)
                      (let ([v1 (helper (call-funexp e))]
                            [v2 (helper (call-actual e))])
                        (cons (call (car v1) (car v2))
                              (set-union (cdr v1) (cdr v2))))]
                     [(mlet? e)
                      (let ([v1 (mlet-var e)]
                            [r1 (helper (mlet-e e))]
                            [r2 (helper (mlet-body e))])
                        (cons (mlet v1 (car r1) (car r2))
                              (set-remove (set-union (cdr r1) (cdr r2)) v1)))]
                     [(apair? e)
                      (let ([v1 (helper (apair-e1 e))]
                            [v2 (helper (apair-e2 e))])
                        (cons (apair (car v1) (car v2))
                              (set-union (cdr v1) (cdr v2))))]
                     [(fst? e)
                      (let ([v1 (helper (fst-e e))])
                        (cons (fst (car v1)) (cdr v1)))]
                     [(snd? e)
                      (let ([v1 (helper (snd-e e))])
                        (cons (snd (car v1)) (cdr v1)))]
                     [(aunit? e)
                      (cons e (set))]
                     [(isaunit? e)
                      (let ([v1 (helper (isaunit-e e))])
                        (cons (isaunit (car v1)) (cdr v1)))]
                     [#t (error "bad MUPL expression to compute free-vars")])))])
       (car (helper e))))

;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env) "CHANGE")
          

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))