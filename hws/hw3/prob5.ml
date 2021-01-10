(* Problem 5 in Homework 3, CSci 2041, Spring 2020 *)

(* The type for expressions and the new name function given in the homework appear below *)

type expr =
       Id of string                   (* for identifiers *)
     | Int of int                     (* for integers *)
     | True                           (* for the boolean value true *)
     | False                          (* for the boolean value false *)
     | Plus of (expr * expr)          (* for exp1 + exp2 *)
     | Minus of (expr * expr)         (* for exp1 - exp2 *)
     | Times of (expr * expr)         (* for exp1 * exp2 *)
     | Div of (expr * expr)           (* for exp1 / exp2, division being for integers *)
     | Lss of (expr * expr)           (* for exp1 < exp2 *)
     | Eq of (expr * expr)            (* for exp1 = exp2, = being equality comparison *)
     | Gtr of (expr * expr)           (* for exp1 > exp2 *)
     | And of (expr * expr)           (* for exp1 && exp2 *)
     | Or of (expr * expr)            (* for exp1 || exp2 *)
     | Not of expr                    (* for not exp *)
     | Cond of (expr * expr * expr)   (* for if exp1 then exp2 else exp3 *)
     | Let of (string * expr * expr)  (* for let <id> = exp1 in exp2 *)
     | Fun of (string * expr)         (* for fun (x:ty) -> exp *)
     | App of (expr * expr)           (* for (exp1 exp2) *)

let namecounter = ref 0
let newname () =
     ( namecounter := !namecounter + 1; "var" ^ string_of_int !namecounter)



(* Solution to Part 1 *)

let rec freeIn exp str =
  match exp with
  | Let(s, x1, x2) ->
     (match x1 with
      | Id(var) ->
         if str = var then true else
           (match x2 with
            | Plus(y1, y2) | Minus(y1,y2) | Times(y1,y2) | Div(y1,y2) | Lss(y1, y2) | Gtr(y1,y2) ->
               (match (y1, y2) with
                | (Id(var1), Id(var2)) -> if (s = var1 || s = var2) && str = s then false
                                          else if str = var1 || str = var2 then true
                                          else false
                | (_,_) -> false
               )
            | _ -> false
           )
        
      | _ ->
         (match x2 with
          | Plus(y1, y2) | Minus(y1,y2) | Times(y1,y2) | Div(y1,y2) | Lss(y1, y2) | Gtr(y1,y2) ->
             (match (y1, y2) with
              | (Id(var1), Id(var2)) -> if (s = var1 || s = var2) && str = s then false
                                        else if str = var1 || str = var2 then true
                                        else false
              | (_,_) -> false
             )
          | _ -> false
         )
     )
  | Fun(s, x1) ->
     (match x1 with
      | Id(var) ->
         if str = var then
           (if str = s then false
            else true)
         else false
      | Plus(x1,x2) | Minus(x1,x2) | Times(x1,x2) | Div(x1,x2) | Lss(x1, x2) | Gtr(x1,x2) ->
         (match (x1, x2) with
            | (Id(var1), Id(var2)) -> if (s = var1 || s = var2) && str = s then false
                                      else if str = var1 || str = var2 then true
                                      else false
            | (_,_) -> false
         )
      | _ -> freeIn x1 str
     )
  | Plus(x1,x2) | Minus(x1,x2) | Times(x1,x2) | Div(x1,x2) | Lss(x1, x2) | Gtr(x1,x2) ->
     (match (x1, x2) with
      | (Id(var1),Int(var2)) -> if str = var1 then true else false
      | (Int(var1),Id(var2)) -> if str = var2 then true else false
      | (Id(var1),Id(var2)) ->
         if str = var1 || str = var2 then true else false
      | (_,_) -> false
     )
  | Id(var) ->
     if str = var then true else false
  | _ -> false
             


(* Solution to Part 2 *)

(* If variable name in exp2 exists in exp1 but isn't the same as str, replace it with newname();; *)

let cListMaker exp =
  match exp with
  | Plus(x1,x2) | Minus(x1,x2) | Times(x1,x2) | Div(x1,x2) | Lss(x1, x2) | Gtr(x1,x2) ->
     (match (x1,x2) with
      | (Id(v1), Int(v2)) -> [v1]
      | (Int(v1), Id(v2)) -> [v2]
      | (Id(v1), Id(v2)) -> [v1; v2]
      | (_,_) -> []
     )
  | _ -> []
                             
let rec subst exp1 str exp2 =
  if freeIn exp1 str = true then
    (match exp1 with
     | Id(x) -> exp2
     | Int(x) -> exp1
     | Plus(x1,x2) ->
        (match (x1, x2) with
         | (Id(v1), Int(v2)) -> Plus(exp2, x2)
         | (Int(v1), Id(v2)) -> Plus(x1, exp2)
         | (Id(v1), Id(v2)) ->
            if str = v1 then
              (if (List.mem v2 (cListMaker exp2)) = true then Plus(exp2, Id(newname ()))
               else Plus(exp2, x2))
            else
              (if (List.mem v1 (cListMaker exp2)) = true then Plus(Id(newname ()), exp2)
               else Plus(x1, exp2))
         (* This next case should never happen but it's just to not get any warnings *)
         | (_,_) -> exp1
        )
       
     | Minus(x1,x2) ->
        (match (x1, x2) with
         | (Id(v1), Int(v2)) -> Minus(exp2, x2)
         | (Int(v1), Id(v2)) -> Minus(x1, exp2)
         | (Id(v1), Id(v2)) ->
            if str = v1 then
              (if (List.mem v2 (cListMaker exp2)) = true then Minus(exp2, Id(newname ()))
               else Minus(exp2, x2))
            else
              (if (List.mem v1 (cListMaker exp2)) = true then Minus(Id(newname ()), exp2)
               else Minus(x1, exp2))
         | (_,_) -> exp1
        )
     | Times(x1,x2) ->
        (match (x1, x2) with
         | (Id(v1), Int(v2)) -> Times(exp2, x2)
         | (Int(v1), Id(v2)) -> Times(x1, exp2)
         | (Id(v1), Id(v2)) ->
            if str = v1 then
              (if (List.mem v2 (cListMaker exp2)) = true then Times(exp2, Id(newname ()))
               else Times(exp2, x2))
            else
              (if (List.mem v1 (cListMaker exp2)) = true then Times(Id(newname ()), exp2)
               else Times(x1, exp2))
         | (_,_) -> exp1
        )
     | Div(x1,x2) ->
        (match (x1, x2) with
         | (Id(v1), Int(v2)) -> Div(exp2, x2)
         | (Int(v1), Id(v2)) -> Div(x1, exp2)
         | (Id(v1), Id(v2)) ->
            if str = v1 then
              (if (List.mem v2 (cListMaker exp2)) = true then Div(exp2, Id(newname ()))
               else Div(exp2, x2))
            else
              (if (List.mem v1 (cListMaker exp2)) = true then Div(Id(newname ()), exp2)
               else Div(x1, exp2))
         | (_,_) -> exp1
        )
     | Let(s, x1, x2) ->
        if (List.mem s (cListMaker exp2)) = true then Let("var1", (subst x1 str exp2), (subst x2 str exp2))
        else Let(s, (subst x1 str exp2), (subst x2 str exp2))
     | Fun(s, x1) ->
        if (List.mem s (cListMaker exp2)) = true then Fun("var1", (subst x1 str exp2))
        else Fun(s, (subst x1 str exp2))
     | _ -> exp1
    )
  
  else exp1 
    
(* subst (Let ("x", Id "x", (Plus (Id "x", Id "z")))) "x" (Int 0) is not working, 2nd example in let case *)

(* Returns:  expr = Let ("x", Int 0, Plus (Int 0, Id "z")) - Make it so that if substitution occurs in exp1, substitution shouldn't occur in exp2 even if it technically matches *)

            
