# Lab 13: Streams, Assessing Complexity

*CSci 2041: Advanced Programming Principles, Spring 2020*

**Due by:** Friday, May 1, 2020, at 5:00 pm.

## The Objective for this Lab

The first problem in this lab will help you work with the notion of 
streams, a topic on which there are a few problems in homework 7. 
The second problem involves carrying out an exercise on assessing the 
complexity of a function in a manner that will be discussed in the 
video-recorded lectures. Although there will not be a homework on this
topic, you will be expected to have an understanding of the underlying
notions, i.e. the final exam could include a problem on this material. 
The last problem concerns the notion of red-black trees, a data structure
that will be discussed in the video-taped lectures. You are not expected 
to have viewed the lecture before this lab. Rather, the material in the 
lab will help you become familiar with the idea of red-black trees, and 
thus will ease your understanding of the material that you will see in 
the video-recorded lectures. If you find this topic interesting, I also 
urge you to look at the code I have made available in the code repository
for the course, which includes both an insert and a delete function on 
red-black trees that maintain the properties of such trees and hence 
do their tasks while ensuring that the new tree remains balanced. However,
before you look up the definitions of these functions, I recommend that 
you try to define them yourself. Moreover, if you are having difficulty
with writing the code, especially for the delete function, look up the 
lengthy comment in the file I have made available and then try again. 
Looking at my code for it should be done only after you have written a
solution or as a last resort, if you are unable to write the definition
yourself, don't deprive yourself of all the fun and exhilaration of 
actually doing this on your own!

## The Actual Work in this Lab

Make sure to check out the file called `lab13.ml` that is included in the folder 
containing this writeup. This file provides the skeleton for the file that you 
must eventually turn in, after filling in the marked spaces for each of the 
problems below. 

### 1. Working with streams

Consider the following definitions in OCaml that provide a way
to implement streams which are infinite lists of objects of a
relevant type:
```
type 'a stream = Stream of (unit -> 'a * 'a stream)

let mkStream f = Stream f
let nextStream (Stream f) = f ()
```
You can use these declarations to create the infinite sequence of
natural numbers (starting from 1) by using the following
declarations:
```
let rec fromNStream n = mkStream (fun () -> (n, fromNStream (n+1)))

let natStream = (fromNStream 0)
```
Your task in this problem is to define the function
```
zipStreams : 'a stream -> 'b stream -> ('a * 'b) stream
```
that takes two streams and combines them into one stream whose
elements are pairs of the corresponding elements in the input
streams. You might test your function using the following kind of
interaction:
```
# let natnatStream = zipStreams natStream natStream;;
val natnatStream : (int * int) stream = Stream <fun>
# let (x,rst) = nextStream natnatStream;;
val x : int * int = (0, 0)
val rst : (int * int) stream = Stream <fun>
# let (x,rst) = nextStream rst;;
val x : int * int = (1, 1)
val rst : (int * int) stream = Stream <fun>
# let (x,rst) = nextStream rst;;
val x : int * int = (2, 2)
val rst : (int * int) stream = Stream <fun>
# 
```

The definition you write for `zipStreams` should be put into the
marked space in the `lab13.ml` file.

### 2. Assessing the Fibonnaci Function with Specialized Memoization

We will be assessing two versions of the Fibonnaci function in
class. In this problem you will assess a third one that specializes
the memoization version based on the observation that only the last
two memoized values are needed in the computation. This realization
leads to the code below that we are already quite familiar with:
```
let rec fib_aux n i f s =
    if (n = i) then f
    else fib_aux n (i+1) s (f+s)
    
let fib n = fib_aux n 1 1 1 
```

1. Set up a recurrence equation that expresses the time required to
evaluate ```fib_aux n i f s``` as a function of the difference between n
and i. What this means is that you should write an equation of the form
   ```
     T(m) = ...
   ```
   where T(m) represents the time required to evaluate ```fib_aux``` when
   the difference between the first and second arguments is  ```m``` (and
   the remaining arguments are arbitrary) and the ```...``` part is an
   expression that may use values of ```T``` for arguments related in
   some way to ```m```. To determine this recurrence equation, look at
   the way the first two arguments change in a recursive call and also
   find ways to estimate what calculations need to be done before (or
   after) the recursive call. Finally distinguish the base case which for
   this function happens when ```m``` is 0.

2. Guess a solution to the recurrence equation using the idea of
expanding ```T``` on the right-hand side using the equations and
observing a pattern. Then check the guess using induction.

3. Using what you get in step 2, express the time complexity of this
version of ```fib```---the main function---in terms of its input. How
does it compare with the naive implementation and also with the
memoized version that is/will be discussed in the video-recorded lectures?

Include the solutions to the three parts of this problem in a comment in the
designated place in the file ```lab13.ml```.


### 3. Some functions on (purported) red-black trees

The following type declarations will be provided for red-black trees in 
the video-recorded lectures and in the slides that will be made available
via the course web site:
```
type color = R | B

type 'a rbtree =
    Empty
  | Node of color * 'a * 'a rbtree * 'a rbtree
```
The difference between this type declaration and the one we have seen for 
binary trees earlier in the semester is that we now include a _color_ with
each node. Note that he type declaration does not include a color with the 
(empty) leaf nodes. These nodes are considered to be implicitly colored 
black. 

The coloring of nodes as red or black serves to ensure that the trees we
create are balanced. This balancing requirement is achieved, as we shall 
see in the lectures, by requiring "good" red-black trees to satisfy some 
additional properties:

* if a node is colored red, _all_ of its children must be colored black, and

* every path from a given node to its leaves must have the same
  number of black nodes

As should be clear at this point, the properties described above
_are not_ enforced by the type declarations. In this problem, we will define 
functions that will check that a given object of the type ```('a rbtree)``` 
in fact satisfies these  properties.

1. Let the black height of a node in a red-black tree be the number of 
   black nodes on any path from that node to a leaf in the tree _but excluding
   the leaf itself_. Note that
   this is a well-defined quantity because of the second property above that
   a red-black tree is required to satisfy. Define a function
   ```
      is_RBTree_aux : 'a rbtree -> int * bool
   ```
   that returns the value ```(n,true)``` if the input satisfies the
   required properties where ```n``` is the black height and ```(n,false)``` 
   otherwise; in the latter case, ```n``` can be any arbitrary value that 
   you settle on. As examples that show the behaviour desired
   of this function, consider the following:
   ```
     # is_RBTree_aux Empty;;
     - : int * bool = (0, true)
     # is_RBTree_aux (Node (R, 5, Node(B, 3, Node(R, 1, Empty, Empty),
                                             Empty),
                                  Node(B, 7, Empty, Empty)));;
     - : int * bool = (1, true)
     # is_RBTree_aux (Node (B, 5, Node(R, 3, Node(R, 1, Empty, Empty),
                                             Empty),
                                  Node(B, 7, Empty, Empty)));;
     - : int * bool = (1, false)
     # is_RBTree_aux (Node (B, 5, Node(B, 3, Node(R, 1, Empty, Empty),
                                             Empty),
                                  Node(B, 7, Empty, Empty)));;
     - : int * bool = (2, true)
     # is_RBTree_aux (Node (R, 5, Node(B, 3, Node(B, 1, Empty, Empty),
                                             Empty),
                                  Node(B, 7, Empty, Empty)));;
     - : int * bool = (2, false)
     #
   ```

2. Using ```is_RBTree_aux```, define the function
   ```
     is_RBTree : 'a rbtree -> bool
   ```
   That returns the value ```true``` just in the case that its input
   satisfies the properties required of a red-black tree.

3. Using ```is_RBTree_aux``` (or otherwise) define the function
   ```
      bh_RBTree : 'a rbtree -> int option
   ```
   that returns a value of the form ```(Some n)``` if its input is a
   red-black tree with black height ```n``` and ```None``` otherwise.
   
Include the definitions of the functions asked for in this problem in the 
space indicated in the file ```lab13.ml``` provided to you at the start of 
this lab. 

## What to Turn In

A file named `lab13.ml` should be  placed in the folder named ```lab13``` 
which is itself within the ```labs``` folder for the course and the 
resulting structure should be pushed to your personal repository
in the github organization for the course. 

_This concludes lab 13_

**Due:** Friday, May 1, 2020 at 5:00 pm

Remember: you need to **push** your file to your remote repository.
If you do not do this, we cannot see the file and you will not get credit
for the lab.


