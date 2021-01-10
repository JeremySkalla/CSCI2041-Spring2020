(* Problem 2 in Homework 3, CSci 2041, Spring 2020 *)

type 'a btree =
  | Empty
  | Node of 'a * 'a btree * 'a btree

let rec treemap t f =
  match t with
  | Empty -> Empty
  | Node(a, tree1, tree2) ->
     Node((f a), (treemap tree1 f), (treemap tree2 f))
