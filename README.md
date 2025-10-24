# 4337 - Project 1: Prefix expression evaluator 

## Running the Program 

You can run the program with the following command (assuming you have racket installed)

```
racket mode.rkt
```

There is also a batch flag for running several commands in a row. Intended to be used by a piping in input from a file.
You need to use `-b` or `--batch` after `mode.rkt` as it is a flag for the program not racket.

```
    racket mode.rkt -b < test.txt
```

## Instructions 

- Operators
  - `+` addition
  - `*` multiplication 
  - `/` Integer division
  - `-` Negation (Unary operator)
  - `$n` History operator, inserts the result of the nth expression evaluated
  - There is no subtraction operator use addition and negation
- Operands 
  - All integers
    - Note that negative numbers are allowed, but they are treated as a unary operator and a number 
      - i.e -5 is not -5 but <Negation_Op> 5, 
      - Regardless it is functionally the same as allowing a negative number
- White space 
  - `#\space` `#\r` , and `#\newline` are all allowed characters an ignored in evaluation 
  - White space is only required to separate numbers and history references
    - `+123` => `"+" "123"`
    - `+ 1 2 ` => `"+" "1" "2"`
    - `+$1$2 ` => `"+" "$1" "$2"` (if `$` is present then white space isn't needed)

- Quitting 
  - Input `quit` to exit the program
  - Do not use Ctl-C 

## Batch Input 

You need to use `-b` or `--batch` after `mode.rkt`

Then you need to pipe in input from a text file (it still works with keyboard but that kinda defeats the purpose).

Your text file will contain expression, each line is considered an expression. Expressions are executed top down, and 
the first expression will store its result in $1. 

You need to include `quit` as the last line in the text file for it to work properly, otherwise the program will wait 
until you manually input `quit`.

### Exceptions 

When there is an exception, `Error: Message` will be printed to the screen. If an error occurs, that value will *not* be 
added to the history, meaning that it is likely following values that utilize history will be incorrect or will fail. 

Error Messages: 
 - "Invalid Expression"
   - This is the general error message for when evaluation fails, there are several reasons this could happen but these 
     are the most likely 
     - Extra operators `+++++ 1`
     - Extra operands `+ 2 2 2`
     - Division by 0 `/ 2 0`
   - "Unknown Character"
     - Occurs whenever there is a character in the input that is not an operator, number, $ or whitespace. 
   - "$n is out of bounds"
     - Occurs whenever you access a history value that is after the current value.
     - For example using $1 for the first statement will result in this error

### Example (batch)

Sample input (found in test.txt)

```
+ 0 1
+ $1 1
+ $2 1
* 2 2
/ 10 2
+ $5 - -1
+ $6 1
/ $7 0
+ 1 1 5
+ $99 1
+ $7 1
quit
```

Result 

``` 
1: 1.0
2: 2.0
3: 3.0
4: 4.0
5: 5.0
6: 6.0
7: 7.0
Error: Invalid Expression
Error: Invalid Expression
Error: $n is out of bounds
8: 8.0
```

### Example (Interactive)

```
C:\Users\name\IdeaProjects\4337-Project1>racket mode.rkt
Enter a prefix expression: / 1 6
1: 0.0
Enter a prefix expression: + * 2 3 / 8 4
2: 8.0
Enter a prefix expression: quit
Quitting program
```
    
