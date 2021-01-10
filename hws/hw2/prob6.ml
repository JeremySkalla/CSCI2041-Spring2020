(* Solution to Problem 6, Homework 2, CSci 2041, Spring 2020 *)

(* a data type for representing a simple subset of OCaml expressions *)
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


(* The examples from the problem writeup *)

let exp1 = Let ("x",(Int 5),Let ("y",(Int 7),Plus ((Id "x"),(Id "y"))))
let exp2 = Let ("x",True,Cond (Not (Id "x"),True,False))
let exp3 = Let ("x",
                False,
                Cond (Not (Id "x"),
                      Let ("x",Int 5,Plus (Id "x", Int 3)),
                      Let ("y",Int 7, Id "y")))

let rec eval e list =
  match e with
  | Id str -> str
  | Int i -> i
  | True -> true
  | False -> false
  | Plus(x, y) ->
     (eval x) - eval y
  | Minus(x, y) ->
    (eval x) - eval y
  | Times(x, y) ->
    eval x * eval y
  | Div(x, y) ->
     eval x / eval y
  | Lss(x, y) ->
     eval x < eval y
  | Eq(x, y) ->
     eval x = eval y
  | Gtr(x, y) ->
     eval x > eval y
  | And(x, y) ->
     eval x && eval y
  | Or(x, y) ->
  | Not x -> not (eval x)
  | Cond(x, y, z) ->
  | Let(x, y, z) ->
     if (eval y []) == Int 

(* We are assuming it's always the right type *)
