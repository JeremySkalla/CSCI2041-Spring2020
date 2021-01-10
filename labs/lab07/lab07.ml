(* Lab 07 *)

(* let rec map2 f l1 l2 =
  match l1 with *)

let rec map2 f a b =
  match a, b with
  | [], _ -> []
  | _, [] -> []
  | (h1::t1), (h2::t2) -> (f h1 h2) :: (map2 f t1 t2)

let rec append l =
  match l with
  | [] -> (fun l2 -> l2)
  | (h::t) ->
      let tail_appender = append t in
      (fun l2 -> h :: tail_appender l2)

(* Accumulate: Fold Left *)

let rec accumulate f lst u =
  match lst with
  | [] -> u
  | (h::t) -> accumulate f t (f h u)

(* Reduce: Fold Right *)
let rec reduce f lst u =
  match lst with
  | [] -> u
  | (h::t) -> f h (reduce f t u)

let union l1 l2 =
  accumulate (fun 
                  
let unzip l =
  reduce (fun (x1, x2) (y1, y2) -> (x1::y1, x2::y2)) l ([], [])
                     
