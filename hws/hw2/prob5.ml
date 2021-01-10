(* Solution to Problem 5, Homework 2, CSci 2041, Spring 2020 *)

(* The type declarations included with the problem writeup. *)

type ty = BoolTy | IntTy | FunTy of ty * ty

type expr =
       Id of string                     (* for identifiers *)
     | Int of int                       (* for integers *)
     | True                             (* for the boolean value true *)
     | False                            (* for the boolean value false *)
     | Plus of expr * expr              (* for exp1 + exp2 *)
     | Minus of expr * expr             (* for exp1 - exp2 *)
     | Times of expr * expr             (* for exp1 * exp2 *)
     | Div of expr * expr               (* for exp1 / exp2, division being for integers *)
     | Lss of expr * expr               (* for exp1 < exp2 *)
     | Eq of expr * expr                (* for exp1 = exp2, = being equality comparison *)
     | Gtr of expr * expr               (* for exp1 > exp2 *)
     | And of expr * expr               (* for exp1 && exp2 *)
     | Or of expr * expr                (* for exp1 || exp2 *)
     | Not of expr                      (* for not exp *)
     | Cond of expr * expr * expr       (* for if exp1 then exp2 else exp3 *)
     | Let of string * expr * expr      (* for let <id> = exp1 in exp2 *)
     | Fun of string * ty * expr        (* for fun (x:ty) -> exp *)
     | App of expr * expr               (* for (exp1 exp2) *)


(* Solution to Part 1 *)                                  

let exp1 = Let("x", Int 5, (Let("y", Int 7, Plus(Id "x", Id "y"))))

let exp2 = Fun("x", IntTy, Fun("y", BoolTy, (Cond(Id "y", (Plus(Id "x", Int 1)), (Minus(Id "x", Int 5))))))

let exp3 = App((Fun("x", IntTy, App(Fun("y", IntTy, Plus(Id "x", Id "y")), Id "x"))), Int 5)
    
(* Solution to Part 2 *)

let rec search_list list x =
  match list with
  | (h, t)::t2 -> if x = h then Some t else search_list t2 x
  | _ -> None

let rec add_list list x y =
  match list with
  | (h, t)::t2 -> if x = h then (x, y) :: t2 else (h, t)::(add_list t2 x y)
  | [] -> (x, y)::[]                                                   

let helper x =
  match x with
  | Some y -> y
  | None -> BoolTy
                                                     
let rec typeof_aux exp list =
  match exp with
  | Id x -> search_list list x
  | Int i ->
     Some IntTy
  | True | False ->
     Some BoolTy
  | Plus(x,y) | Minus(x,y) | Times(x,y) | Div(x,y) -> 
     if ((typeof_aux x list) == (Some IntTy) && (typeof_aux y list) == (Some IntTy)) then Some IntTy
     else None
  | Lss(x,y) | Gtr(x,y) ->
     if ((typeof_aux x list) == Some IntTy && (typeof_aux y list) == Some IntTy) then Some BoolTy
     else None
  | Eq(x,y) ->
     if (typeof_aux x list) == (typeof_aux y list) then Some BoolTy
     else None
  | And(x,y) | Or(x,y) ->
     if (typeof_aux x list) == (Some BoolTy) && (typeof_aux y list) == (Some BoolTy) then Some BoolTy
     else None
  | Not x ->
     if (typeof_aux x list == Some BoolTy) then Some BoolTy
     else None
  | Cond(x1, x2, x3) ->
     if (typeof_aux x1 list = Some BoolTy && typeof_aux x2 list = typeof_aux x3 list)
     then typeof_aux x2 list
     else None
  | Let (x1, x2, x3) ->
     if (typeof_aux x2 list != None && typeof_aux x3 (add_list list x1 (helper (typeof_aux x2 list))) != None)
     then typeof_aux x3 (add_list list x1 (helper (typeof_aux x2 list)))
     else None
  | Fun (x1, x2, x3) ->
     if (typeof_aux x3 (add_list list x1 x2) != None)
     then Some (FunTy (x2, helper (typeof_aux x3 (add_list list x1 x2))))
     else None
  | App (x1, x2) ->
     (match helper (typeof_aux x1 list) with
      | FunTy (x3, x4) ->
          if (x3 = (helper (typeof_aux x2 list)))
            then typeof_aux x2 list
          else None
      | _ -> None)



(* Solution to Part 3 *)

let typeof exp =
  typeof_aux exp []
