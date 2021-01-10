(* Solution to Problem 3, Homework 2, CSci 2041, Spring 2020 *)

(* Previously, I used "raise" to raise an error when there wasn't a particular person in the database, but I've just listed it out as None to fix the issue and changed the value after then to "Some z" and "Some y" *) 

let rec find_salary list name =
  match list with
  | [] -> None
  | _ -> (match List.hd list with
          | ((x : string), (y : string), (z : float)) ->
             if x = name then Some z else find_salary (List.tl list) name)

let rec find_phno list name =
  match list with
  | [] -> None
  | _ -> (match List.hd list with
          | ((x : string), (y : string), (z : float)) ->
             if x = name then Some y else find_phno (List.tl list) name)
