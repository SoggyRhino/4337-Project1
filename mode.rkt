#lang racket
(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))

(define (exc-expr str value-history)
  (define tokenized (tokenize str))
  (define token-success (car tokenized))
  (define tokens (cdr tokenized))
  (if token-success
      (let ([processed-tokens (pre-process tokens value-history '())])
        (if processed-tokens
            (let ([result (evaluate processed-tokens)])
              (if result
                  (cons #t result)
                  (cons #f (format "Result: ~s" result))))
            (cons #f "Invalid Expression: $n is out of bounds")))
      (cons #f (format "Error: ~s" tokens))))




(define (tokenize str )
     (join (string->list str) '() "" 0))

(define (join lst acc lastTokens lastType)
    (cond
        ; handle end of list
        [(empty? lst)
            (if (= 1 lastType)
                (cons #t (reverse (cons lastTokens acc)))
                (cons #t (reverse acc)))]
        ; handle case where we don't need to include precding tokens
        [(= 0 lastType)
            (cond
                [(op? (first lst))
                     (join (rest lst) (cons (string (first lst)) acc) "" 0)]
                [(space? (first lst))
                     (join (rest lst) acc   "" 0)]
                [(or (digit? (first lst)) (dollar? (first lst)))
                    (join (rest lst)  acc   (string(first lst)) 1)]
                [else
                    (cons #f (format "Unknown character ~s" (first lst)))]
            )]
        ; handle cases when we need to include the previous chars
        [(= 1 lastType)
            (cond
                 ; if the current char is an operator then we know the number is over
                 [(op? (first lst))
                    (join (rest lst) (cons (string (first lst)) (cons lastTokens acc)) "" 0)]
                 ; if the current char is an " " then we know the number is over
                 [(space? (first lst))
                    (join (rest lst) (cons lastTokens acc) "" 0)]
                 [(digit? (first lst))
                    (join (rest lst) acc (string-append lastTokens (string(first lst))) 1)]
                 [(dollar? (first lst))
                    (join (rest lst)    (cons lastTokens acc) (string(first lst)) 1)]
                 [else
                    (cons #f (format "Unknown character ~s" (first lst)))]
            )]))

(define (dollar? c)
  (char=? c #\$))

(define (space? c)
  (char=? c #\space))

(define (op? c)
    (member c '(#\+ #\- #\* #\/)))

(define (digit? c)
    (member c '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 )))



(define (pre-process lst history acc)
    (cond
        [(empty? lst) (reverse acc)]
        [(equal? "-" (first lst))
            (pre-process (rest lst) history (cons "-1" (cons "*" acc)))]
        [(char=? #\$ (first (string->list (first lst))))
            (define index (string->number (list->string (rest (string->list (first lst))))))
            (let ([res (get-n index history 1)])
            (if res
                (pre-process (rest lst) history (cons res acc))
                 #f ))]; no need to pass a string as this is the only type of error
        [else
            (pre-process (rest lst) history (cons (first lst) acc))]))


; make sure that history is stored as a list of strings
(define (get-n n lst i)
    (cond
        [(empty? lst) #f] ; no need to pass a string as this is the only type of error
        [(= n i) (first lst) ]
        [else (get-n n (rest lst) (+ i 1))]))

(define (evaluate lst)
  (cond
    [(empty? lst) 0]
    [(equal? (first lst) "+")
     (+ (evaluate (left (rest lst)))
        (evaluate (right (rest lst))))]
    [(equal? (first lst) "*")
     (* (evaluate (left (rest lst)))
        (evaluate (right (rest lst))))]
    [(equal? (first lst) "/")
     (/ (evaluate (left (rest lst)))
        (evaluate (right (rest lst))))]
    [else (string->number (first lst))]))

(define (left lst)
  (left-helper lst 1 '()))

(define (left-helper lst need acc)
  (cond
    [(zero? need) (reverse acc)]
    [(empty? lst) (reverse acc)]
    [(member (first lst) '("+" "*" "/"))
     (left-helper (rest lst) (+ need 1) (cons (first lst) acc))]
    [else
     (left-helper (rest lst) (- need 1) (cons (first lst) acc))]))

(define (right lst)
  (right-helper lst 1))

(define (right-helper lst need)
  (cond
    [(zero? need) lst]
    [(empty? lst) lst]
    [(member (first lst) '("+" "*" "/"))
     (right-helper (rest lst) (+ need 1))]
    [else
     (right-helper (rest lst) (- need 1))]))


(exc-expr "+ $1 $2" '("4" "5")  )