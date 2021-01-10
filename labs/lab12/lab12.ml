                 (* Copyright (c) Gopalan Nadathur *)

(* Lab 12, CSci 2041, Spring 2020 *)

(* Problem 2, part 1 *)

module type ITEM =
 (* the last component, initial, is meant to identify a value of item type
    that can be used in initialization *)
    sig
        type item
        val leq : item * item -> bool
        val initial : item
    end

(* Provide definitions of IntItem and StringItem here *)


(* For Problem 2, part 2 *)

module type HEAP =
  sig
    type item
    type tree
    exception InitHeap
    val depth : tree -> int
    val initHeap : int -> tree
    val insert : item * tree -> tree
    val isHeap : tree -> bool
    val maxHeap : tree -> item
    val replace : item * tree -> item * tree
    val size : tree -> int
    val top : tree -> item
  end


(* Using the code in heapcode.ml, define a functor called Heap that
takes a module satisfying the ITEM signature and produces a module satisfying
the HEAP signature here. *)


(* Problem 2, part 3 *)

(* Uncomment the lines below to get integer and string heaps.

module IntHeap = Heap(IntItem)
module StringHeap = Heap(StringItem)

*)

(* Problem 3, Code to experiment with and then comment on *)

let cond (c,t,e) =
   match c with
   | true -> t
   |  false -> e

let rec fact n =
   cond (n=0,1, n * fact (n-1))

(* Write your explanation for why this code does not work here *)

(* Problem 4 *)

(* The code that you have to consider in this problem *)

  let rec append l1 l2 =
     match l1 with
     | [] -> l2
     | (h::t) -> h::(append t l2)

  let head l =
     match l with
     | [] -> 0
     | (h::t) -> h

(* The expression whose evaluation you have to consider:
       head (append (append [1;2] [3]) [4])

Part 1: Show the steps in call-by-name evaluation below


Part 2: Show the steps in call-by-value evaluation below

*)
