# Lab 12: Modularity and Evaluation Order Mainly

*CSci 2041: Advanced Programming Principles, Spring 2020*

**Due by:** Friday, April 24, 2020, at 5:00 pm.

## The Objective for this Lab

We will look at a mix of things related to programming using OCaml as
a vehicle:

* Using OCaml programs in standalone mode

* Using modules and functors

* The importance of selective evaluation to recursive definitions

* Differences between call-by-name and call-by-value evaluation

## The Actual Work in this Lab

You have been given a file called `lab12.ml` that provides the skeleton
for the work in this lab. You should fill this file out as you try the
problems below. You will eventually upload this file within the
folder for ```lab12``` to your personal repository in the github
organization for this course.

### 1. Running OCaml Code in Standalone Mode

We have been running OCaml in an interactive mode for most of this
course. However, very early in the course we had observed that this is
not essential: we could develop OCaml code that is supposed to realize
a particular functionality, add to the file containing this code an
invocation of the function that realizes this functionality, compile
it to obtain object code and then run that code without invoking
OCaml. This exercise is designed to show you how easy it is to do this
so as to remove any lingering doubts you might have about OCaml
being a "real programming language."

In the file ```sorter.ml```, I have provided you some code for reading
in a sequence of numbers and then printing this sequence in sorted
order. This seems to be a silly function but it is only meant to make
a point; I think you can see the possibilities even if this particular
functionality seems silly. The initial part of the code realizes an
implementation of red-black trees, a form of binary search trees that
maintains a balance in the sizes of subtrees. Don't worry too much about
this part, I intend to discuss the details of red-black trees in one of
the remaining lectures and I expect that you will also learn
about them in a course like CSci 4041. The main function for you
to focus on in ```sorter.ml``` is called ```get_and_sort_numbers```.
If you look at this code, you will
see what it does: it reads in a sequence of numbers, creates a
red-black tree containing them, generates a list of the elements in
the tree using an in-order traversal and then prints this list
out. The code should be easy for you to understand, if you recognize
that `Empty` represents the empty red-black tree, that `insert` is a
function for inserting an item into an existing red-black tree and
`keylist` is a function to perform an in-order traversal of a tree,
returning the elements seen as a list.

Observe that the last line in ```sorter.ml``` is a call to the
function. (We have terminated the definition just before this with
two semicolons because otherwise OCaml will think that the function call
is part of that definition and this will cause errors.) When we compile
this file, object code will be produced for all the definitions and
this last expression will be run.

How do we compile the file to produce object code? You can do it by
issuing the following command at the shell level:
```
   ocamlopt -o sorter sorter.ml
```
This will produce a file called ```sorter``` that you can run in
standalone mode.

The exercise for you: read the code in ```sorter.ml```, understand it,
compile it and run it to see that you can program in pretty much the
same way as in a language like Java or C. You do not need to turn in
anything for this problem, just feel empowered by what you would have
learned.

### 2. Using the Module System in OCaml

We will work with the heap example that was used in the video-recorded
lectures on modularity in this problem.

1. The section of the file ```lab12.ml``` indicated as being relevant
to Problem 2, part 1 contains the definition of a signature called
ITEM. Your task is to define two modules named _IntItem_ and _StringItem_,
respectively, that satisfy this signature. These modules should correspond
to what we would expect the "ITEM" structures for integers and strings to
be. The examples below assume the use of ```0``` as the initial item for
integers and the string with the single blank character, i.e. the string " ",
as the initial item for strings.

   You should use a signature qualification for the modules
you define so as to have type checking ensure that they actually meet
the requirements described by the signature. You should also annotate
these qualifications with type constraints to ensure that you can
use the modules externally to work with string and integer data.
In particular ensure that you will get behavior of the following sort:
     ```
      # IntItem.leq(3,5);;
      - : bool = true
      # StringItem.leq("mine","yours");;
      - : bool = true
      #
      ```

   Also, experiment with and without the type constraint and with "bad"
   constraints in the signature qualification to make sure you understand
   what role exactly the constraint is playing.

2. The section of the file ```lab12.ml``` indicated as being relevant to
Problem 2, part 2 also contains an elaborated version of the
HEAP signature that was discussed in the lectures. I have also provided
you code that realizes the various functions required by the HEAP signature
in the file ```heapcode.ml```. Copy this code over to the file
```lab12.ml``` in the place reserved for this part of Problem 2 and use it
to construct a _functor_ called ```Heap``` that takes in a structure
that satisfies the signature ```ITEM``` as an argument and
that produces a structure that satisfies the signature ```HEAP```.

   __Note:__ The code in ```heapcode.ml``` _will not_ compile as
provided because it assumes available a module with name ```Item```
that satisfies the ```ITEM``` signature. I have done this to make it
easier for you to use it in defining the functor: use the name
```Item``` for the module parameter for the functor and things should
compile properly.

3. The functor ```Heap``` can be applied to the structures ```IntItem``` and
```StringItem``` to realize modules that implement integer and string heaps
as follows:
   ```
   module IntHeap = Heap(IntItem)
   module StringHeap = Heap(StringItem)
   ```

   These definitions are included in comments in the part of the file ```lab12.ml```
   marked as relevant to this part of Problem 2. Uncomment these definitions,
   understand what they are doing and then test the definitions through
   interactions such as the following:
   ```
   # let ih = IntHeap.initHeap 4;;
   val ih : IntHeap.tree = <abstr>
   # let s = IntHeap.size ih;;
   val s : int = 15
   # let m = IntHeap.maxHeap ih;;
   val m : IntHeap.item = 0
   # let ih = IntHeap.initHeap 4;;
   val ih : IntHeap.tree = <abstr>
   # let (x,ih) = IntHeap.replace (3,ih);;
   val x : IntHeap.item = 0
   val ih : IntHeap.tree = <abstr>
   # let m = IntHeap.maxHeap ih;;
   val m : IntHeap.item = 3
   # let sh = StringHeap.initHeap 3;;
   val sh : StringHeap.tree = <abstr>
   # let s = StringHeap.size sh;;
   val s : int = 7
   # let m = StringHeap.maxHeap sh;;
   val m : StringHeap.item = " "
   # let (str,sh) = StringHeap.replace ("string",sh);;
   val str : StringHeap.item = " "
   val sh : StringHeap.tree = <abstr>
   # let m = StringHeap.maxHeap sh;;
   val m : StringHeap.item = "string"
   #
   ```
   Note that the use of ```replace``` above occurs with objects of
```int``` and ```string``` type respectively. For this to be
acceptable, the ```item``` type in the structure that ```Heap```
constructs should be exposed externally. You would need to use a
typing constraint to realize such an exposure.

### 3. The Importance of Selective Evaluation to Recursion

OCaml gives us an ```if-then-else``` expression as do most other
languages. But OCaml also allows us to define functions so one might
think that the ```if-then-else``` expression is actually
redundant. For example, perhaps the following ```cond``` function
realizes the effect of the ```if-then-else```.
```
  let cond (c,t,e) =
     match c with
     | true -> t
     |  false -> e
```
Once we have defined ```cond``` in this way, we might think of using
it in the definition of the ```fact``` function as follows:
```
   let rec fact n =
      cond (n=0,1, n * fact (n-1))
```
Alas, this idea does not work. Your task is to understand why it does
not work and to explain what the aspect of the
```if-then-else``` expression is that is critical to recursive
definitions of this kind that is missing in the ```cond```
function. Put this explanation in the space indicated for it in the
```lab12.ml``` file.

### 4. Understanding evaluation order

Consider the following definitions in a language whose syntax is identical
to OCaml
```
  let rec append l1 l2 =
     match l1 with
     | [] -> l2
     | (h::t) -> h::(append t l2)

  let head l =
     match l with
     | [] -> 0
     | (h::t) -> h
```

  1. Show the step-by-step evaluation of the expression
     ```
        head (append (append [1;2] [3]) [4])
     ```
     assuming _call-by-name_ evaluation.

  2. Do the same as above but this time using call-by-value
  evaluation.

The work you do for this problem should be included within a comment in
the space indicated for this problem in the `lab12.ml` file.

## What to Turn In

A folder called ```lab12``` containing the file ```lab12.ml``` that
results from the work on the above problems should be pushed to your
personal repository in the github organization for this course.

_This concludes lab 12_

**Due:** Friday, April 24, 2020 at 5:00 pm

Remember: you need to **push** your file to your remote repository.
If you do not do this, we cannot see the file and you will not get credit
for the lab.
