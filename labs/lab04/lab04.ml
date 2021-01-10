(* Jeremy Skalla, Lab 4 *)

(* 1 has no error: 'a -> 'b list -> ('a * 'b) list = <fun> *)

(* 2 has an error because addN in the last line should have two inputs (a list and a num, I assume) and it's only recieving the list *)

(* 3 has an error and I think that it's because it's giving addN 2 inputs instead of 1 in the recursion *)

(* 4 has no error: ('a * string) list -> 'a -> string = <fun>*)

(* 5 has an error because h is just the first element rather than a list, so you're trying to use a' when you should be trying to use a' list *)

let sameFstAndSnd =
    function
      | ([] | [_]) -> false
      | (h::x::_) -> if h = x then true else false

let sumList l =
  let rec sumList' x l =
    match l with
    | [] -> x
    | (h::t) -> sumList' (x + h) t
  in match l with
     | [] -> 0
     | (h::t) -> sumList' h t

let rec drop (n, l) =
    match (n, l) with
    | (_, []) -> []
    | (x, (h::t)) -> if (n = 0) then l else drop (n-1, t)

let pi = 4.0 *. atan 1.0

let distance =
    function
      |	((x1,y1),(x2,y2)) ->
            let xdiff = x1 -. x2 in
            let ydiff = y1 -. y2 in
              sqrt (xdiff *. xdiff +. ydiff *. ydiff)
                   
let perimeter sh =
  match sh with
  | 
