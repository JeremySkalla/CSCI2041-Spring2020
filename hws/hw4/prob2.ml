(* Jeremy Skalla *)

(* Problem 2 in Homework 4, CSci 2041, Spring 2020 *)

(* Part 1: feel like records is easier*)

type 'a olist =
  {
    list : 'a list;
    func : 'a -> 'a -> bool;

  }


(* Part 2 *)

let initOList ord = {list = []; func = ord}


(* Part 3 *)

let list1 = {list = [1; 5; 69; 420; 999]; func = (fun x y -> x < y)}
let list2 = {list = [700; 420; 200; 69; 6]; func = (fun x y -> x > y)}
let list3 = {list = ["computer"; "keyboard"; "mouse"]; func = (fun x y -> x < y)}
let list4 = {list = [7; 11; 13; 17; 19]; func = (fun x y -> x > y)}

(* Part 4 *)

let isOrderedList ol =
  let rec olTest l f =
    match l with
    |[] -> true
    |_::[] -> true
    |a::b::t -> if (f a b = true) then (olTest (b::t) f) else false
  in olTest ol.list ol.func

(* Part 5 *)

let rec insertOList v ol =
  match ol.list with
    |[] -> {list = [v]; func = ol.func}
    |x::[] -> if ol.func x v then {list = [x; v]; func = ol.func} else {list = [v; x]; func = ol.func}
    |a::b::t ->
      if (ol.func v a = true)
      then {list = v::a::b::t; func = ol.func}
      else if ((ol.func a v = true) && (ol.func v b = true))
      then {list = a::v::b::t; func =  ol.func}
      else
        {list = a::(insertOList v {list = b::t; func = ol.func}).list; func = ol.func}

(* Part 6 *)

let olistToList ol =
 ol.list
