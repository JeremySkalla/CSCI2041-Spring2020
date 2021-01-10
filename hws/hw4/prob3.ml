(* Jeremy Skalla *)

(* Problem 3 in Homework 4, CSci 2041, Spring 2020 *)

(* Part 1 *)

let rec cont_reverse l f =
    match l with
    | [] -> f []
    | h::t -> cont_reverse t (fun lst -> f (lst @ [h]))

(* Part 2 *)

(* The btree type constructor as defined in the homework writeup. *)
type 'a btree = Empty | Node of 'a * 'a btree * 'a btree

let rec cont_sumTree t f =
    match t with
    | Empty -> f 0
    | Node (i,l,r) -> cont_sumTree l (fun sum -> (sum + (cont_sumTree r (fun sum -> f (sum + i)))) )
