(* Jeremy Skalla - Homework 1 *)

(* Solution to Problem 1 *)

(* 
1. Well-Typed, int = -4
2. Not Well-Typed, it's using the integer addition operator with a float and an integer
3. Not Well-Typed, it's using the float multiplication operator with a float and an integer
4. Well-Typed, int = 7
5. Not Well-Typed, as one of the possible return options is a string which doesn't match with the first return
option, an int
6. Not Well-Typed, as there's no case for if 3 != 2, which it doesn't
7. Well-Typed, string "helloworld"
8. Well-Typed, function (string -> string) * string = (<fun>, "hello")
 *)

(* Solution to Problem 2 *)

(*
1. Not legal, because y is not defined
2. Legal, int = 2
3. Not Legal, as the x in y = x + 1 is not defined, because it's the keyword "and" not "in"
4. Legal, int = 3
5. Legal, int = 5
 *)

(* Solution to Problem 3 *)

let rec gcd x y =
  if x == 0 || x == y then x
  else if y == 0 then y
  else if x > y then gcd (x-y) y else gcd x (y-x)

(* Solution to Problem 4 *)

let reduced_form (x, y) =
  if x == 0 || y == 0 then (x, y)  else (x / (gcd x y), y / (gcd x y))

(* Solution to Problem 5 *)

let rec fromMtoN x y =
  if x == y then [x]
  else if x < y then []                     
  else x :: (fromMtoN (x - 1) y)

(* Solution to Problem 6 *)

let rec everyOdd list =
  match list with
  | [] -> []
  | [x] -> [x]
  | (h::f::t) -> h :: (everyOdd (t))
     

(* TODO: Solution to Problem 7 *)
    
let everyNth list i =
  let rec helper n =
    function
    | [] -> []
    | h::t -> if n == i then h :: helper 1 t else helper (n+1) t in
  helper 1 list

let everyThird list =
  everyNth list 3
    
(*Solution to Problem 8*)                                                                                
                                               
let rec find_salary list name =
  match list with
  | [] -> raise (Failure "find_salary")
  | _ -> (match List.hd list with
          | ((x : string), (y : string), (z : float)) ->
             if x = name then z else find_salary (List.tl list) name)

let rec find_phno list name =
  match list with
  | [] -> raise (Failure "find_phno")
  | _ -> (match List.hd list with
          | ((x : string), (y : string), (z : float)) ->
             if x = name then y else find_phno (List.tl list) name)

(* Solution to Problem 9 *)

(* For a list of lists to be an accurate representation of a matrix, all the sublists need to be the same length *)

(* This is a helper function *)
       
let rec is_matrix_helper list prev =
  match list with
  | [] -> true
  | (h::t) -> if (List.length h) != prev then false else is_matrix_helper t prev
       
let is_matrix list =
  match list with
  | [] -> true
  | (h::t) -> is_matrix_helper t (List.length h)

(* This is a helper function *)
              
let rec matrix_multiply_helper list i =
  match list with
  | [] -> []
  | (h::t) -> (h * i) :: (matrix_multiply_helper t i)

let rec matrix_scalar_multiply list i =
  match list with
  | [] -> []
  | (h::t) -> (matrix_multiply_helper h i) :: (matrix_scalar_multiply t i)
