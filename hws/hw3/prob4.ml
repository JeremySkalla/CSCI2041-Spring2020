(* Problem 4 in Homework 3, CSci 2041, Spring 2020 *)

(* The definitions of accumulate and reduce *)

let rec accumulate f lst u =
   match lst with
   | [] -> u
   | (h::t) -> accumulate f t (f u h)


let rec reduce f lst u =
   match lst with
   | [] -> u
   | (h::t) -> f h (reduce f t u)   


(* Solution to Part 1 *)

let append l1 l2 = reduce (fun x y -> x::y) l1 l2

(* Solution to Part 2 *)

let reverse l1 = accumulate (fun x y -> (y::x)) l1 []

(* Solution to Part 3 *)

let filter f l1 = reduce (fun x y -> if (f x) == true then x::y else y) l1 []

(* Note on how append works for me :
list1 = [1;2]
list2 = [3;4]
fun a x -> a::x

run 1: match list1 with h::t ->
(fun 1 (reduce f t u))

run thru:
(fun 1 (fun 2 u))
(fun 1 (2::u))
1::2::u
[1;2;3;4]

 *)
