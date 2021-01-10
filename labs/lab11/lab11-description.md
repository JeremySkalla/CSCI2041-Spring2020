# Lab 11: Programming Search

*CSci 2041: Advanced Programming Principles, Spring 2020*

**Due by:** Friday, April 17, at 5:00 pm.

## The Objective for this Lab

The new topic to be covered in this lab is that of programming search.
Specifically, you will familiarize yourself with the two different
programming techniques introduced in the video-taped lectures for managing 
search: that based on using exceptions and that based on using two
continuations, one for success and another for failure. The specific search
problem is quite simple and writing up a solution should not take a lot
of time. However, the problem has sufficient structure to get you started
with the search related programming that you have to do in the homework
that is due on April 22; this problem will also help you understand the 
code you have been given in homework 6 to manage interactions with the 
user. 

## The Actual Work in this Lab

You should try the problems provided below, putting your work in the indicated
places in the file called ```lab11.ml``` that has been provided to you. The 
resulting file should be included within the folder for ```lab11``` in the 
```labs``` folder of your private repository which should then be pushed to 
the copy of your repository in the github organization for the course. 

### 1. Programming Search Using Exceptions

As discussed in class, search is a notion that crops up in many
computational situations. For example, consider puzzles such as this one
```
  Three missionaries and three cannibals have arrived at the bank of a
  river and want to get across intact. They have a boat at their disposal
  that can seat up to two people. There is one catch: if the
  cannibals outnumber the missionaries on either bank or in the boat,
  we are likely to quickly have fewer missionaries. Plan a set of boat
  trips to get all across safely.
```
This is actually an entertaining example of a kind of situation we are
all intimately familiar with from real life: from planning airplane
trips to determining the sequence of courses to take to graduate, we
need to plan a set of "moves" in a context where we typically can make
choices to get to a goal.

As we saw in the video-taped lecture, one general approach to handling 
such computations at a programming level is the following. We make a 
choice of move when we are confronted with the need to; we can use 
intuitions (often called heuristics) in making such choices. Once we have 
made the choice, we then proceed as if it is going to work out, making 
further moves, etc. We might get lucky and things may actually work out. 
However, there is a possibility that we reach a deadend. What then? To 
prepare for this eventuality, we should have determined how to consider
alternatives if forced to do so _at the time we made a choice_. When
we reach a deadend, we _backtrack_ to consider the alternatives.

One way to program this paradigm in OCaml (and other languages) is to
use exceptions. In OCaml, exceptions are characterized by three
things:

1. You declare them using a _exception_ declaration. An example of
such a declaration is the following
  ```
    exception Search_Failure
  ```

2. You _raise_ an exception using a ```raise``` expression. For
example, the following expression raises a ```Search_Failure```
exception in OCaml:
  ```
   raise Search_Failure
  ```
   Exceptions are typically raised when there isn't any sensible way to
   proceed in a computation, i.e. when a deadend has been reached.

3. You _catch_ and _handle_ an exception. In OCaml, you do this by
wrapping an expression you want to compute but whose computation could
end up raising an exception in a ```try``` expression. For example,
consider the following (partially shown) expression
  ```
   try  <some expression> with
     | Search_Failure -> <another expression>
  ```
   Evaluation of this expression proceeds with an attempt to compute
   ```<some expression>```. If things work out, that is
   swell. However, it is also possible that things do not work out and
   that the exception ```Search_Failure``` is raised to signal
   this. In this case, the ```try``` expression above has set up to
   catch the exception and to channel the computation into continuing
   with ```<another expression>```.

In this problem, we will experiment with this style of dealing with
search in the context of a simple, even contrived, example; just get
into the spirit and the silliness of the problem itself will not
bother you. 

What is the problem? We are given a list of lists of
numbers such as this one:
```
   [[1;2;3]; [4;3;2]; [1;5]; [6]; [1;7]]
```
and we need to select a list from these that sum up to a number such
as ```6```. However, the "user" who wants us to select such a list is
quirky and is prone to rejecting particular lists that we provide
him/her. To deal with this, we look for a "good" list, present it to
the user and, if he/she rejects it, we raise an exception to backtrack
to looking for another.

The code for interacting with the user requires the use of OCaml
expressions for printing to and reading from the terminal. Here is the
code for doing that; it will also be included in a starting file
called ```lab11.ml``` that you will find in the ```lab11``` folder 
in the public repository for this course (i.e. in the folder containing
this document).
```
exception Search_Failure

let ask_user printer config =
   printer config;
   Printf.printf "More solutions (y/n)? ";
   if (read_line () = "y")
   then (raise Search_Failure)
   else ()

let printlist item_printer l =
   let rec printlist_aux l =
     match l with
     | [] -> Printf.printf "%c" ']'
     | (h::t) -> Printf.printf "%s" ", ";
                 item_printer h;
                 printlist_aux t
   in (Printf.printf "%c" '[';
       match l with
       | (h::t) -> item_printer h; printlist_aux t
       | _ -> printlist_aux l)

let int_printer i = Printf.printf "%d" i

let show_solution s =
   fun l ->
      Printf.printf "A list that sums to %d: " s;
      printlist int_printer l;
      Printf.printf "\n"
```
To use this code for printing the list of numbers ```[1;2;3]``` that
   sum up to ```6```, you would invoke the expression
```
   ask_user (show_solution 6) [1;2;3]
```
This would cause the following to be displayed on the screen
```
  A list that sums to 6: [1, 2, 3]
  More solutions (y/n)?
```
If the user types in _y_ at the terminal at this point, this would
   cause the solution to be rejected, i.e. an exception would be
   raised.

Your task is to use the above code and the introduction to exceptions
provided above to provide a definition of the following function
```
   find_list : int list list -> int -> unit
```
that takes a list of lists of numbers and a number and that interacts
with the user to find an acceptable "answer" list. Here are some
example uses of the function:
```
  # find_list [[1;2;3]; [4;3;2]; [1;5]; [6]; [1;7]] 6;;
  A list that sums to 6: [1, 2, 3]
  More solutions (y/n)? n
  - : unit = ()
  # find_list [[1;2;3]; [4;3;2]; [1;5]; [6]; [1;7]] 6;;
  A list that sums to 6: [1, 2, 3]
  More solutions (y/n)? y
  A list that sums to 6: [1, 5]
  More solutions (y/n)? y
  A list that sums to 6: [6]
  More solutions (y/n)? y
  No more solutions
  - : unit = ()
  #
```
Insert your definition in the indicated place in the file ```lab11.ml```
that has been given to you for this lab. The code given to you includes
definitions of all the functions discussed above as well as a definition 
of the ```sumlist``` function that adds the numbers in a list; you will 
find this useful in defining ```find_list```. 

Note that you should use the ```ask_user``` function as given above and 
you _must_ utilize exceptions and exception handlers in the way discussed 
in the lecture and also in the writeup here in solving this problem.

### 2. Treating Search Via Success and Failure Continuations

Another way to deal with search that is discussed in the video-taped
lectures is the following: you make a choice
when you need to do this and you prepare also for the possibility that
the choice will not work out. However, instead of having the task
come back to you if the choice does not work out, you pass the
information needed to try an alternative to the "callee" and let it
take care of the problem. This is the old idea of using a
_continuation_ except that now we are passing __two__ continuations,
one when everything works out, called the _success_ continuation, and
the other when there is failure, called the _failure_ continuation.

We will rewrite the ```find_list``` function to use this success and
failure continuation idea. To begin with, here is the modified code
for interacting with the user
```
  let ask_user_cont printer config succ fail =
      printer config;
      Printf.printf "More solutions (y/n)? ";
      if (read_line () = "y") then (fail ()) else (succ ())
```
Note that the new ```ask_user_cont``` function now takes two function
parameters ```succ``` and ```fail```. These functions take the "dummy"
unit argument. Which one of them is invoked depends on the user
response, whether this signals success or failure. An example use of
this code is the following:
```
   # ask_user_cont (show_solution 6) [1;2;3] (fun () -> ()) (fun () -> ());;
   A list that sums to 6: [1, 2, 3]
   More solutions (y/n)? y
   - : unit = ()
   #
```
Since the two continuations do nothing, this code will terminate as
shown regardless of whether the user types in "y" or something
else. However, we can use other continuations to get a different
behaviour.

Your task in this problem is to define the function
```
  find_list_cont : int list list -> int -> (unit -> 'a) -> (unit -> 'a) -> 'a
```
that behaves like ```find_list``` defined earlier, except that it uses
continuations instead of exceptions. Here is an example interaction
that shows the kind of behaviour expected:
```
  # find_list_cont [[1;2;3]; [4;3;2]; [1;5]; [6]; [1;7]]
                   6
                   (fun () -> ())
                   (fun () -> Printf.printf "No (more) solutions\n");;
  A list that sums to 6: [1, 2, 3]
    More solutions (y/n)? n
  - : unit = ()
  # find_list_cont [[1;2;3]; [4;3;2]; [1;5]; [6]; [1;7]]
                   6
                   (fun () -> ())
                   (fun () -> Printf.printf "No (more) solutions\n");;
  A list that sums to 6: [1, 2, 3]
  More solutions (y/n)? y
  A list that sums to 6: [1, 5]
  More solutions (y/n)? y
  A list that sums to 6: [6]
  More solutions (y/n)? y
  No (more) solutions
  - : unit = ()
  #
```

Insert your definition in the indicated place in the file ```lab11.ml```
that has been given to you for this lab. Test your definition using examples
like those shown above. Once you have this function working, you might want
to consider using it to define a function that takes only the list and the number
as arguments; that function would work by calling find_list_cont with the 
relevant continuations, something that should really be internal to the code.

## What to Turn In

A file named `lab11.ml` should be put in the ```lab11``` folder of your
copy of your private repository and then pushed to the copy of this 
repository in the github organization for this course.

_This concludes lab 11_

**Due:** April 17, 2020 at 5:00 pm

Remember: you need to **push** your file to your remote repository.
If you do not do this, we cannot see the file and you will not get credit
for the lab.
