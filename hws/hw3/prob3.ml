(* Problem 3 in Homework 3, CSci 2041, Spring 2020 *)

(* Solution to Part 1 *)

let rec reduce f lst u =
   match lst with
   | [] -> u
   | (h::t) -> f h (reduce f t u)   

(*

   You are inputting f ('a -> 'b -> 'b) that is essentially a helper function. 
   You're also inputting the list, and then you're also inputting u ('b) that is the eventual return value
   Final: ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b

*)

(* Solution to Part 2 *)

let rec forall2 p l1 l2 =
   match (l1,l2) with
   | ([],[]) -> true
   | ([],_) -> false
   | (_,[]) -> false
   | ((h1::t1),(h2::t2)) ->
         (p h1 h2) && (forall2 p t1 t2)

(*

   You input a function p that takes 2 arguments ('a and 'b) that returns a bool. 
   You also input two lists. If the two lists are empty, it returns true. If only one is empty, return false.
   If both aren't empty, you run the function on the first element of each list and runs the forall2 functions
   on the same p function and the remaining elements of each list. It seems to just check if the lists are the same
   length and their same indexed elements return true in p.
   ('a -> 'b -> bool) -> 'a list -> 'b list -> bool

*)
