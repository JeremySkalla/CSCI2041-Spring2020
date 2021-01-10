(* Jeremy Skalla *)

(* Problem 1 in Homework 4, CSci 2041, Spring 2020 *)

let orderTuple a =
  match a with
  | (x, y) -> if x > y then (y, x) else (x, y)

let makePairLists p fl = List.map (fun x -> (orderTuple (p,x)), fl) fl

let makeAllPairLists l = List.map (fun (x,y) -> makePairLists x y) l

let intersect l1 l2 = List.fold_right (fun x a -> if (List.mem x l2) = true then x::a  else a  ) l1 []

let rec addOnePair one total =
  match one with
  | ((x,y)) -> (
    match total with
    | ((a,b)::t) -> if a = x then ((a, (intersect y b))::t) else (a,b)::(addOnePair one t)
    | [] -> [one]
  )
  | _ -> []


let addAllPairs ppls l = List.fold_left (fun x y -> addOnePair y x) l ppls


let commonFriends l = List.fold_right addAllPairs (makeAllPairLists l) []


(* The example friends list used in the problem writeup is provided via the
   let binding below *)


let friendsList =
   [ ("a", ["b"; "c"; "d"]);
     ("b", ["a"; "c"; "d"; "e"]);
     ("c", ["a"; "b"; "d"; "e"]);
     ("d", ["a"; "b"; "c"; "e"]);
     ("e", ["b"; "c"; "d"]) ]
