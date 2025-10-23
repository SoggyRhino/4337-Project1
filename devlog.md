(October 22 11pm)
 - Thoughts 
   - The project looks like more effort than I had originally thought, 
     need to get started asap
   - I'm not currently sure how to handle the higher level portion and 
     the history but for that calculation the first step needs to be cleaning the input,
        - After splitting the input into Operations, Numbers, and References we can begin
          evaluating
        - After "tokenized" we can replace references with values 
        - Then It should be relatively simple to evaluate expressions
 - Plan to accomplish 
   - Finish the function to tokenize a string
   - Next session will tackle 
     - Replacing references with past values (simulated for now)
     - Get started on the function to actually evaluate expressions
   

(October 23 12:13pm)
   
Writing the Tokenizing function was not too difficult. The function was not 
very complex, all it was doing was deciding whether or not to join/ add or skip
elements in a list of characters based on the state before the index. 

The hardest part was making sure that I accounted for all the possible states
and not adding minor mistakes to the code. 

The biggest issue I had was that I thought it would be fine to mix characters and 
strings in the array, but now I changed it such that it is all strings.

It's not really accomplishing something, but I've started to work out how error handling
is going to work.

Next session is to work on a basic implemntation of the calculator. It shouldn't be too bad
since im going to skip the $ references for now (just hard coded $2 -> 2 etc)



(October 23 7 am)

 - Thoughts
    - I was thinking about whether I could directly replace '-' with "*" "-1" this would make evaluating easier
      as - is a weird case since it only takes in 1 operation.
 - Plan to accomplish 
   - Complete the eval function (ignoring the - for now)
   - Create a placeholder preprocessing function for replacing $n 


(October 23 9 am)

I made decent progress on the eval function but I think my approach is completely wrong and introduces to many edge cases
The problem is that I am essentially using an imperative approach, but I am just storing the state in the 
arguments which somewhat defeats the point of functional programming.


(October 23 3:15)
 - Thoughts 
   - I've looked over the instructions again and have seen the hint about using a function that returns 2 lists. I think
     I am going to implement this approach as it looks more straight forward.
   - More of a future thought but originally i didn't realize that a map would be somewhat obnoxious to implement 
     so for the $n replacement im just going to embed the whole equation. performance shouldn't really be an issue.
   - Plan to accomplish 
     - Complete the eval function with the new approach 
       - (get left "tree" ) (operation) (get right "tree") 
         - recursively evaluate this on each tree until we hit numbers 



(October 23 3:15)

Eval was complete, it was much more conducive to the language. I added some tests to make sure it was working
I will probably need add some more as I add more functions. 

I made a pre-process function in order to make all expressions into the form that is expected by the evlauation function.
    - Replace unary operators with * -1, this avoids having to make the eval more complex and handle single operand operators
    - Replace $n with correct value from history.


I have done most of the hard parts now it is just working on the User input. After that is done I will need to go back throough 
and add/fix how errors are handle. This probably will have to be done in conjunction with adding ui.

Next session I will work on a function that will evaluate an expression from a string it will :
 - Tokenize string (handle error)
 - Preprocess string (handle error)
 - Evaluate (handle error)
 - Return #t/#f, msg/value

Also the code is just random as i work on things i will clean it up later