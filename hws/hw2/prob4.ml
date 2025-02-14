(* Solution to Problem 4, Homework 2, CSci 2041, Spring 2020 *)

(* Solution to Part 1 *)

type ('a, 'b) btree =
  | Empty
  | Node of 'a * 'b * ('a, 'b) btree * ('a, 'b) btree
                       
(* Solution to Part 2 *)

let inittree = Empty

(* Solution to Part 3 *)

let tree1 = Node(1, "hi", Node(-1, "no", Empty, Empty), Node(3, "yes", Empty, Empty))

let tree2 = Node("Jeremy", 69.69, Node("Ethan", 42.0, Empty, Empty), Node("Reese", 4.20, Empty, Empty))

(* Solution to Part 4 *)

(* 
find : ('a, 'b) btree -> 'a -> 'b 
Precondition: Exactly one entry per key in the tree 
Invariant: Output is the value that matches the input
*)

let rec find btree query =
  match btree with
  | Empty -> None
  | Node(key, value, tree1, tree2) ->
     if query == key then Some value
     else if query < key then find tree1 query
     else find tree2 query          

(* Solution to Part 5 *)

(* 
insert : ('a, 'b) btree -> 'a -> 'b -> ('a, 'b) btree
Precondition: Assuming that the tree satisfies the standard ordering
Invariant: Output is the input with the new key and value pair added on
 *)

let rec insert btree k v =
  match btree with
  | Empty -> Node(k, v, Empty, Empty)
  | Node(key, value, left, right) ->
     if k < key then Node(key, value, insert left k v, right)
     else if k > key then Node(key, value, left, insert right k v)
     else Node(k, v, left, right)

(* Solution to Part 6 *)

(* 
keylist : ('a, 'b) btree -> ('a list)
Precondition: Assuming the tree satisfies the standard ordering
Invariant: Output is the list of all the keys inorder 
 *)
    
let rec keylist btree =
  match btree with
  | Empty -> []
  | Node(k, v, left, right) ->
     (keylist left) @ (k :: (keylist right))             

(* Solution to Part 7 *)

(*
delete : ('a, 'b) btree -> 'a -> ('a, 'b) btree
Precondtion: Assuming that the tree satisfies standard ordering
Invariant: Output is a new tree with input removed 
 *)

let rec delete btree k =
  match btree with
  | Empty -> Empty
  | Node(key, value, left, right) ->
     if k < key then Node(key, value, (delete left k), right)
     else if k > key then Node(key, value, left, (delete right k)) 
     else if left == Empty then right
     else if right == Empty then left
     else Node(None, None, left, right)
            
                                                         
