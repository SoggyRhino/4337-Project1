#lang racket
(require racket/string)

(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))

(define (run value-history i)
    (begin
        (when prompt?
                (display "Enter a prefix expression: "))
        (let [(expression (string-trim  (read-line)))]
            (if (equal? "quit" expression)
            (when prompt?
                (displayln "Quitting program"))
                (let [(result (exc-expr expression (reverse value-history)))]
                   (if (car result)
                       (begin
                          (display i)
                          (display ": ")
                          (displayln (real->double-flonum (cdr result)))
                          (run (cons (number->string (cdr result)) value-history ) (+ i 1)))
                       (begin
                            (displayln (cdr result))
                            (run value-history i))))))))

(define (exc-expr str value-history)
  (let [(tokenized (tokenize str))]
    (define token-success (car tokenized))
    (define tokens (cdr tokenized))
    (if token-success
        (let ([processed-tokens (pre-process tokens value-history '())])
          (if processed-tokens
              (let ([result (evaluate processed-tokens)])
                (if result
                    (cons #t result)
                    (cons #f "Error: Invalid Expression")))
              (cons #f "Error: $n is out of bounds")))
        (cons #f (format "Error: ~a" tokens)))))


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
            (define token (first lst))
            (cond
                [(op? token)
                     (join (rest lst) (cons (string token) acc) "" 0)]
                [(char-whitespace? token)
                     (join (rest lst) acc   "" 0)]
                [(or (digit? token) (dollar? token))
                    (join (rest lst)  acc   (string token) 1)]
                [else
                    (cons #f (format "Unknown character ~a" token))]
            )]
        ; handle cases when we need to include the previous chars
        [(= 1 lastType)
            (define token (first lst))
            (cond
                 ; if the current char is an operator then we know the number is over
                 [(op? token)
                    (join (rest lst) (cons (string token) (cons lastTokens acc)) "" 0)]
                 ; if the current char is an " " then we know the number is over
                 [(char-whitespace? token)
                    (join (rest lst) (cons lastTokens acc) "" 0)]
                 [(digit? token)
                    (join (rest lst) acc (string-append lastTokens (string token)) 1)]
                 [(dollar? token)
                    (join (rest lst) (cons lastTokens acc) (string token) 1)]
                 [else
                    (cons #f (format "Unknown character ~s" token))])]))

(define (dollar? c)
  (char=? c #\$))

(define (space? c)
  (member c '(#\space #\return)))

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
      [(empty? lst) #f]
      [(string->number (first lst))
       (if (empty? (rest lst))
         (real->double-flonum (string->number (first lst)))
         #f)]
      [else
            (let* ([left (evaluate (left (rest lst)))]
                [right (evaluate (right (rest lst)))])
                (cond
                    [(or (not left) (not right)) #f]
                    [(equal? (first lst) "+") (+ left right )]
                    [(equal? (first lst) "*") (* left right )]
                    [(equal? (first lst) "/") (if (zero? right) #f (/ left right ))]
                    [else #f]))]))

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


(run '() 1)