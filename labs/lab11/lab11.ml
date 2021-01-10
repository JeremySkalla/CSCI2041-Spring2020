                 (* Copyright (c) Gopalan Nadathur *)

(* Problem 1 *)

exception Search_Failure

(* ask_user : ('a -> unit) -> 'a -> unit
   A function for displaying a configuration using a configuration
   printer and then interacting with the user to determine if search
   should continue *)
let ask_user (printer : 'a -> unit) config =
   printer config;
   Printf.printf "More solutions (y/n)? ";
   if (read_line () = "y")
   then (raise Search_Failure)
   else ()

(* printlist : ('a -> unit) -> 'a list -> unit
   This function takes an function printing items and lifts it
   into a function for printing a list of such items *)
let printlist (item_printer : 'a -> unit) l =
   let rec printlist_aux l =
     match l with
     | [] -> Printf.printf "%c" ']'
     | (h::t) -> Printf.printf "%s" ", ";
                 item_printer h;
                 printlist_aux t
   in (Printf.printf "%c" '[';
       match l with
       | (h::t) -> item_printer h; printlist_aux t
       | _ -> printlist_aux l)


(* int_printer : int -> unit
   A printer for integer items *)
let int_printer i = Printf.printf "%d" i

(* sumlist : int list -> int
   sums up the items in the integer list *)
let sumlist l =
   let rec sumlist_aux l acc =
     match l with
     | [] -> acc
     | (h::t) -> sumlist_aux t (h + acc)
  in sumlist_aux l 0

(* show_solution : int -> int list -> unit
   A function for printing a solution to the task of finding
   a list of numbers that add up to a given number. The first
   argument is the number and the second argument is the
   solution to be printed. *)
let show_solution s =
   fun l ->
      Printf.printf "A list that sums to %d: " s;
      printlist int_printer l;
      Printf.printf "\n"

let rec find_list l x =
    match l with
    | [] -> Printf.printf "No more Solutions\n";
            ()
    | (h::t) -> if (sumlist h) != x then (find_list t x)
                else
                  (show_solution x h;
                   Printf.printf "More solutions (y/n)? ";
                   (if (read_line () = "y")
                    then (find_list t x)
                    else ()))


(* Problem 2 *)

(* ask_user_cont : ('a -> unit) -> 'a -> (unit -> 'b) -> (unit -> 'b) -> 'b
   (ask_user_cont p c sc fc) prints configuration c using configuration
   printer p and then continues the computation with either sc or fc
   based on an interaction with the user *)
let ask_user_cont (printer : 'a -> unit) config succ fail =
   printer config;
   Printf.printf "More solutions (y/n)? ";
   if (read_line () = "y") then (fail ()) else (succ ())

let find_list_cont l x succ fail =
  match l with
    | [] -> (fail ())
    | (h::t) -> if (sumlist h) != x then (find_list_cont t x (succ ()) (fail ()))
                else
                  (show_solution x h;
                   Printf.printf "More solutions (y/n)? ";
                   (if (read_line () = "y")
                    then (find_list_cont t x (succ ()) (fail ()))
                    else ()))
