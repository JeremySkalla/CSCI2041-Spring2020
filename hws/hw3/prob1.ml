(* Problem 1 in Homework 3, CSci 2041, Spring 2020 *)

let divide_list b_fun l =
  let rec aux b_fun2 l2 l3 l4 =
    match l2 with
    | [] -> (l3, l4)
    | (h::t) -> if (b_fun2 h) == true then (aux b_fun2 t (l3@h) l4)
                else (aux b_fun2 t l3 (l4@h))
                in
  match l with
  | [] -> ([], [])
  | _ -> aux b_fun l [] []
