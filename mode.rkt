#lang racket
(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))


(define (tokenize str )
     (reverse (cdr (join (string->list str) '() "" 0))))

(define (join lst acc lastTokens lastType)
    (cond
        ; handle end of list
        [(empty? lst)
            (if (= 1 lastType)
                (cons #t (cons lastTokens acc))
                (cons #t acc))]
        ; handle case where we don't need to include precding tokens
        [(= 0 lastType)
            (cond
                [(op? (first lst))
                     (join (rest lst) (cons (string (first lst)) acc) "" 0)]
                [(space? (first lst))
                     (join (rest lst) acc   "" 0)]
                [(or (num? (first lst)) (dollar? (first lst)))
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
                 [(num? (first lst))
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

(define (num? c)
    (member c '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 )))