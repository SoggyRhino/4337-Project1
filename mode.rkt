(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))


(define (test str )
     (join (string->list str) '() 0 '())
)

(define (join lst acc lastTokens lastType)
    (cond
        [(null? (first lst)) (#t acc)]
        [(0 = lastType)
            (cond
                [(op? (first lst)) (join (rest lst) (cons (first lst) acc) 0 "")]
                [(= (first lst) #\ ) (join (rest lst) (cons (first lst) acc) 0 "")]
                [(num? (first lst)) (join (rest lst) (cons (first lst) acc) 1 "")]
                [else (#f (format "Unknown character " (first lst))) ]
            )]
        [(1 = lastType)
            (cond
                 [(op? (first lst)) (join (rest lst) (cons (first lst) (cons lastTokens acc)) 0 "")]
                 [(= (first lst) #\ ) (join (rest lst) (cons (first lst) acc) 0 "")]
                 [(num? (first lst)) (join (rest lst) (cons (first lst) acc) 1 "")]
                 [else (#f (format "Unknown character " (first lst))) ]
            )]
    )

)

(define (op? c)
    (member? c '(#\+ #\- #\* #\/))
)

(define (num? c)
    (member? c '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 ))
)



(test "+*2$1+$2 1")