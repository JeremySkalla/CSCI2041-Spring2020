                 (* Copyright (c) Gopalan Nadathur *)


(* Problem 1 *)

(* The code given to you at the outset *)

type 'a stream = Stream of (unit -> 'a * 'a stream)

let mkStream f = Stream f
let nextStream (Stream f) = f ()

let rec fromNStream n = mkStream (fun () -> (n, fromNStream (n+1)))
let natStream = (fromNStream 0)

(* Write the definition of zipStreams below *)

let rec zipStreams s1 s2 = () (* temporary *)
  (* match s1 with
  | Stream of (() -> x1, f1) ->
    (match s2 with
      | (() -> x2, f2) -> zipStreams (nextStream s1) (nextStream s2))
    ) *)

(* Problem 2 *)

(* The code given to you to analyze *)
let rec fib_aux n i f s =
    if (n = i) then f
    else fib_aux n (i+1) s (f+s)

let fib n = fib_aux n 1 1 1

(* the cost of an addition as c1
the cost of a recursive call as c2
the cost of a match and return from a recursive call as c3 *)


(* Part 1

   Replace this text with the recurrence equation for the running time for
   (fib_aux n i f s) expressed as a function of (n-i).

   T(m = 0) = c2 + c3
   T(m > 0) = T(m-1) + c1 + c1 + c2

*)

(* Part 2

   Replace these sentences with your guess of a solution for the recurrence
   relation. Then include an inductive proof of the fact that your guess is
   correct.

   If you are unable to provide an inductive proof, then at least include
   a rationale underlying your guess.

*)

(* Part 3

   Replace this sentence with your answer to this part.

*)


(* Problem 3 *)

(* The type declarations that set the problem up *)

type color = R | B

type 'a rbtree =
    Empty
  | Node of color * 'a * 'a rbtree * 'a rbtree


(* Part 1 *)

(* Replace this comment with a definition of the function
       is_RBTree_aux : 'a rbtree -> int * bool
   *)


(* Part 2 *)

(* Replace this comment with a definition of the function
       is_RBTree : 'a rbtree -> bool
*)

(* Part 3 *)

(* Replace this comment with a definition of the function
       bh_RBTree : 'a rbtree -> int option
*)
