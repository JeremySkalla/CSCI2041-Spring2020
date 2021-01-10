# Lab 10: A Bit of This and a Bit of That

*CSci 2041: Advanced Programming Principles, Spring 2020*

**Due by:** Monday, April 13, 2020 at 5:00 p.m.

## The Objective for this Lab

One goal in this lab is to give you a chance to ask questions about the 
upcoming second mid term exam and about the problems in hw5. There are 
also a few problems about reasoning about imperative programs and side 
effects for you to try out.

Focus first on getting questions concerning the mid term exam and hw5 
answered. <i>Hint: Attend the lab, it could be important.</i> If doing 
this takes all the time, that is okay, try the problems on your own after 
the lab session and ask questions on Piazza if you need help with them.

_In recognition of the fact that we have both an exam and a homework due
the coming week, this lab has been made due later than usual, on 
April 13, 2020._

## Problems to Work on

There are three specific problems described below that you should try out.

### 1. Reasoning about Imperative Programs

In this problem we will look at code that computes the (n0)th
fibonnaci number, but it does this in the imperative programming
style, using variables and assignments. 

The program in question is the one below that we have already seen a
while ago in homework 2:
```
  n = n0;
  i = 1;
  fib1 = 1;
  fib2 = 1;
  while (i != n) {
    temp = fib1;
    fib1 = fib2;
    fib2 = fib2 + temp;
    i = i + 1
  }
  return fib1;
```
How do we reason about such iterative programs? Here is the idea that
a computer scientist by the name of Robert Floyd introduced
a long time ago and that a well-known computer scientist by the name of
CAR Hoare picked up on and popularized: we introduce properties on
program variables at particular program points and show that these
properties that are also known as invariants actually hold at those
points. One of the points where you would have introduced a property
of this kind will be the one where you "read off" the result of the
program from a particular variable. The property you have at that point
will then express the correctness of the result.

The crucial part of this overall process is what property you introduce
at the beginning of a loop.
Control can come to that point many times---this is what happens when we
have a loop in a program---and we need to choose a property that 
is guaranteed to hold _no matter how control gets to that point_. Now,
we can choose an extremely simple property, for example, the contentless
property _true_, and it will be easy to show that it has to be true no 
matter how control gets to that point. The problem with this, though, is
that such a property will be quite useless with respect to helping us 
show that something has to be true _after_ the loop. Thus, we have to find
some property that will match _both_ requirements: the property should be 
weak enough for us to be able to show that it has to be true each time 
control reaches the point before the loop _and_ the property has to be 
strong enough for us to be able to use it to show that something has
to be true after the loop. This is what makes coming up with the 
property a challenge; in essence this property embodies in it the real
content of the loop and in identifying it we have to properly understand
what the loop is trying to do. 

What properties should we introduce at the beginning of the loop in the
program above? In thinking through this, it is useful to relate the loop
to the tail-recursive rendition of it. Here is that version that we
saw, with argument names fixed to correspond to those used in the
iterative program above:
```
 let rec fib_aux n i fib1 fib2 =
    if (n = i) then fib1
    else fib_aux n (i+1) fib2 (fib1+fib2)
```
In proving this function correct, we would need to pick a precondition
for its use. Let us assume that we are intending to use
```fib_aux``` to find the fibonnaci of a positive, nonzero number ```n0```. 
Then, a precondition that would be useful  is the following:
```
  fib1 is the ith fibonnaci number and
  fib2 is the (i+1)th fibonnaci number
  and i <= n and n = n0
```
The result we want of the function is, of course, that it returns the
(n0)th fibonnaci number, provided the preconditions are satisfied.

How does all this translate into conditions for the iterative version?
The idea is simple: the precondition for the tail-recursive rendition
becomes the property we expect to hold each time at the beginning of
the loop. This seems obvious once we think about it a bit, the
precondition is what we expect to be true each time the function
representing the loop is called. Taking this analogy to its logical 
conclusion, the property about what the result of the function should 
be becomes the property we want to show is true at the end of the loop.

Playing these ideas out and writing the properties into the iterative
program, here is what we get:
```
  [ n0 is a natural number greater than 0 ]

  n = n0;
  i = 1;
  fib1 = 1;
  fib2 = 1;

  [ fib1 is the ith fibonnaci number and
    fib2 is the (i+1)th fibonnaci number
    and i <= n and n = n0 ]

  while (i != n) {
    temp = fib1;
    fib1 = fib2;
    fib2 = fib2 + temp;
    i = i + 1
  }

  [ fib1 is the (n0)th fibonnaci number ]

  return fib1;
```
We have shown properties here within square brackets and we have
written them at the point where we expect them to be true.
One small clarification here: the property we write just before the loop
is intended actually to represent something that we want to argue is true
each time around the loop as well. In this sense, the point we are actually
talking about is the one just before the test in the loop.

Okay, so what is the thing that you should do with all this? One thing is
just to understand the correspondence between the iterative program and
the tail-recursive one even at the level of reasoning. The second thing
is to make use of this understanding to argue that the properties written in at
the different points are in fact true at those points, i.e. they are
genuinely invariants. The only non-trivial part of this is showing that
the property written at the beginning of the loop---the so-called
"loop invariant"---is actually an invariant. If you follow the process
that you might have used in homework 5 to show that the preconditions
of the ```fib_aux``` function are always satisfied, both at the beginning and
for each recursive call, you should be able to do this quite easily. Look
also at how we did this in the two examples in the video-taped Lecture 6
on the topic of reasoning about programs.

### 2. Mutable Data Structures

The data structures in languages like C are "mutable," i.e. you can
change fields in them in place. This gives rise to what are sometimes
called "in-place" computations. A classic example of this is the
in-place reverse. In this style for implementing reverse, you walk
down the list simply "reversing" the pointers.

Included in this directory is a file called ```reverse.c``` that contains 
code that realizes this kind of in-place reverse. The crucial part of 
this code from the perspective of this problem is the following:
```
typedef struct listcell *intlist;
struct listcell { int hd; intlist tl; };

intlist reverse(intlist l, intlist acc) {
  intlist nextl;
  if (l==NULL) return acc;
  else { nextl = l->tl; l->tl = acc; reverse(nextl,l); }
}
```
This function will be called with the list that you want to reverse
  and ```NULL``` as its arguments. Observe how it reverses pointers as
  it traverses the list. The file also contains code for testing the
  function that demonstrates some of the pain in dealing with data of
  this sort in a language like C. In case you are not entirely familiar with
C, you can compile this program by using a command like
```
  gcc -o reverse.o reverse.c
```
This will give you object code in the file
  ```reverse.o``` that you can run simply by calling the file at the
  shell level; try it.

I don't advocate this in-place style of programming because it destroys the
list we start out with; destroying data in this fashion is bad for
modularity because the list may have been in use somewhere else and
the meaning of that code changes because of what we do in another
place. The recommended style of programming in OCaml, the one we have
been using up to this point, is based on ```immutable``` data
structures: we don't change existing lists, instead we create new ones
as you can see by comparing the above code to the tail-recursive
reverse we have seen a few times in this course. The point of this
exercise is to see that this is a conscious choice, not something
forced on us by the language. In particular, we will see that we can
emulate this (bad) style of programming using references.

The key to realizing the in-place reverse is to define the list type
via cells that have mutable tails. Here is the type declaration for
this.
```
  type 'a mylist = 'a listcell ref
  and  'a listcell = Nil | Cons of 'a * ('a mylist) ref
```
One thing to note out here is that the second component of a
```Cons``` is a _reference_ to a list and not a list itself; this is
necessary to be able to make the tail point to another physical list
rather than changing the contents of the list it points to.

The type declaration above is provided to you in the file named 
```lab10.ml``` that is a part of the folder for this lab. Your task 
in this problem is to define a function
```
   reverse : 'a mylist -> 'a mylist -> 'a mylist
```
that behaves like the C function above: it takes a list and returns
its reverse realized via an in-place computation. An example of a
computation that you should get using this function is the following:
```
# reverse (ref (Cons (1,ref (ref (Cons (2, ref (ref (Cons (3,ref (ref Nil)))))))))) (ref Nil);;
- : int mylist =
{contents =
  Cons (3,
   {contents =
     {contents =
       Cons (2,
        {contents = {contents = Cons (1, {contents = {contents = Nil}})}})}})}
#
```
Provide the definition of this function in the place marked by a comment in the
file ```lab10.ml```.


### 3. Formatted Input

All input is, in the end, composed of a sequence of characters. Some
languages give you facilities that obscure this fact. This is true
even of OCaml. For example, using the ```read_int``` and
```read_float``` functions, you can read integers and reals directly
from the channel ```stdin```, i.e. from the terminal. This works up to
a point: it is great if the input is guaranteed to be well-formed, but
can lead to unexpected situations otherwise. Here is an interaction
that shows this:
```
   # read_int ();;
   abcd
   Exception: Failure "int_of_string".
   #
```
If we are in the business of building robust programs, it is better to
use simple character input which cannot fail in this way and to
fashion our own functions for converting such input into integers,
reals, lists, etc. In this problem we will consider a simple example
of how this can be done. In particular, we will see how we can read
character sequences and extract numbers from them.

The particular task is simple: we want to skip over a bunch of spaces
in an input channel till we reach the first digit and then extract a
number from the sequence of digits that follow. If the next thing in
the input following the spaces is actually a number that we can
extract in this way, we return it as an object of option type; if it
is not a number, we signal this by returning ```None```.

To keep this simple enough for you to accomplish in the lab, we have
set up most of the code for you, leaving you to fill in only the part
that converts the sequence of digits into a number. Here is the
"skeleton" code that is also present in the file ```lab10.ml``` that
is provided to you in the lab directory:
```
let readnum infile =
  let rec skip_space () =
    let ch = input_char infile
    in if (ch = ' ') then skip_space ()
       else ch in
  let is_digit ch = (ch >= '0' && ch <= '9') in
  let rec getnum num =
       (* Fill code in here *)
         0
   in let ch = skip_space ()
      in if (is_digit ch)
         then Some (getnum (int_of_char ch - int_of_char '0'))
         else None
```
Your task is to complete the definition of ```getnum```. Right now,
this function simply returns a ```0```; we had to make it return
something to ensure that the file compiles and ```0``` seemed to be a
good default value.

How should we extract a number from a sequence of characters
corresponding to digits? Here is the general idea. Consider the
character string ```1524```. At each stage of the processing, you
would have extracted an initial part of this character sequence into a
number and your goal is to extend this step-by-step to encompass the
entire character sequence. Suppose you have finished processing the
first two characters and have extracted from it the number
```15```. How would you extend this to cover the third character,
giving you the number ```152```? First, you should read the character
```2```. Next you should convert this into the _number_ ```2```. You
can do this by converting the character ```2``` into its code using
the function ```int_of_char``` and then subtracting the code for
```0``` from it. Here is an example that shows how to do this
concretely:
```
# (int_of_char '2') - (int_of_char '0');;
- : int = 2
#
```
Once you have got the number corresponding to the digit character, you
can assimilate it into what you have read already by adding it to the result
of multiplying the number you have already by ```10```; remember how
the decimal system works to make sense of this.

The file ```lab10.ml``` also contains a function called
```get_num_from_user``` that you can use to test that the function
```readnum``` works as expected after you have completed its
definition.


## What to Turn In

You do not need to turn anything in for Problem 1 although you should 
work on it yourself and ask questions as you try to fill in the 
proof, the understanding that you gain from this could be needed
for a future homeowork or exam problem. 

The remaining two problems require you to write OCaml code. Put
your work in the appropriate places in a copy of the file 
`lab10.ml` that you have obtained from the public repo. This file
should be placed within a folder called ```lab10``` that is itself within
the ```labs``` folder in your private repository for this course. This 
file and folder should be pushed to the github version of your 
repository before the deadline for submission. 
_This concludes lab 11_

**Due:** Monday, April 13, 2020 at 5:00 pm

Remember: you need to **push** your ```lab10``` folder containing
the file ```lab10.ml``` to the github copy of your repository.
If you do not do this, we cannot see the file and you will not get credit
for the lab.

