type empItemTy = {name : string; phno : string; salary : float }

let smalldb = [{name = "John"; phno = "x3456"; salary = 50.1};
               {name = "Jane"; phno = "x1234"; salary = 107.3};
               {name = "Joan"; phno = "unlisted"; salary = 12.7}]

let rec find_salary eList name =
  match eList with
  | [] -> None
  | (h::t) -> if h.name = name then Some h.salary else find_salary t name

let rec find_phno eList name =
  match eList with
  | [] -> None
  | (h::t) -> if h.name = name then Some h.phno else find_phno t name
                
(* Problem 2 *)

type nestedList =
  | Int of int
  | Bool of bool
  | 






                                                       
