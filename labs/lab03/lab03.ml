(* Jeremy Skalla - Lab 03 *)

let rec sumup x =
  if x == 0 then 0 else x + sumup (x-1)

let flip_pair =
  function
  | (h,t) -> (t, h)

let rec flip_list =
  function
  | [] -> []
  | (x::y) -> flip_pair x::flip_list y

let rec destutter =
  function
  | [] -> []
  | (x::y) -> if (x=y) then x else (x::y)
  | (x::y::l) -> if (x=l) then destutter x else (x::y) :: destutter (y::1)

let sum_diffs =
  function
  | [] -> 0
  | [x] -> 0
  | (x::y) -> (x-y)
  | (x::y::l) = (x-y) + (y-l)

let rec unzip =
  function
  | 
