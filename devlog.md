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
  - Post

(October 23 12:13pm)
   
Writing the Tokenizing function was not too difficult. The function was not 
very complex, all it was doing was deciding whether or not to join/ add or skip
elements in a list of characters based on the state before the index. 

The hardest part was making sure that I accounted for all the possible states
and not adding minor mistakes to the code. 

The biggest issue I had was that I thought it would be fine to mix characters and 
strings in the array but now I changed it such that it is all strings.