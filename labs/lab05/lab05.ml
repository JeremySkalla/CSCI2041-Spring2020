(* Jeremy Skalla Lab 5 *)

type 'a btree =
  | Empty
  | Node of ('a * 'a btree * 'a btree)

let rec maxTree btree =
  let rec maxTree' btree x =
    match btree with
    | Empty -> Some x
    | Node(y, l, r) -> maxTree' r y in
  match btree with
  | Empty -> None
  | Node(x, l, r) -> maxTree' r x

let rec minTree btree =
  let rec minTree' btree x =
    match btree with
    | Empty -> Some x
    | Node(y, l, r) -> minTree' l y in
  match btree with
  | Empty -> None
  | Node(x, l, r) -> minTree' l x

let rec isSearchTree t =
   let bigger i j =
     match j with
     | None -> true
     | (Some j') -> i >= j' in
   let smaller i j =
     match j with
     | None -> true
     | Some j' -> j' >= i in
   match t with
   | Empty -> true
   | Node (i,l,r) ->
         isSearchTree l && isSearchTree r &&
           (bigger i (maxTree l)) && (smaller i (minTree r))

let t1 = Empty
let t2 = Node(3, Node(2, Empty, Empty), Node(4, Empty, Empty))
let t3 = Node(3, Empty, Node(4, Empty, Node(6, Empty, Empty)))

type  expr =
  Int of int | True | False
| Plus of expr * expr | Minus of expr * expr
| Lss of expr * expr | Gtr of expr * expr
| And of expr * expr | Or of expr * expr
| Cond of expr * expr * expr

type ty = IntTy | BoolTy

let rec typeOf ex =
  match ex with
  | (Int _) -> Some IntTy
  | True | False -> Some BoolTy
  | Plus (x, y) | Minus (x, y) ->
     if (typeof(x) == Some IntTy && typeof(y) == Some IntTy) then Some IntTy else None
  | Lss (x, y) | Gtr (x, y) | And (x, y) | Or (x, y)





 let e1 = Cond (Lss (Int 10, Plus (Int 5, Int 7)),
                  Int 5, Int 7)

 let e2 = Cond (Lss (Int 10, Plus (Int 5, Int 7)),
                  Int 5, True)

 let e3 = Cond (And (Lss (Int 10, Plus (Int 5, Int 7)), True),
                  False, True)
