		 (* Copyright (c) Gopalan Nadathur *)

(* Problem 2 *)

(* A type for lists with a mutable representation of the tail. Note that
   for mutations to be to the tail, rather than to the list that is
   the tail, the tail should be a reference to a reference to a list; if
   it were only a reference to a list, then the update will change that
   list *)

type 'a mylist = 'a listcell ref
and  'a listcell = Nil | Cons of 'a * ('a mylist) ref

(* Replace this comment with a definition of reverse as described in the
lab writeup. To be clear, reverse would have the following type
    reverse : 'a mylist -> 'a mylist -> 'a mylist
*)

let rec reverse l acc =
  match !l with
  | Nil -> acc
  | Cons(item,next) -> reverse (next, l)


(* Problem 3 *)

(* a function for reading a number from the input channel infile *)
let readnum infile =
  let rec skip_space () =
    let ch = input_char infile
    in if (ch = ' ') then skip_space ()
       else ch in
  let is_digit ch = (ch >= '0' && ch <= '9') in
  let rec getnum num =
       let ch2 = input_char infile
       if (is_digit ch2) then (getnum ((10 * num) + (int_of_char ch2 - int_of_char '0')))
       else num
   in let ch = skip_space ()
      in if (is_digit ch)
         then Some (getnum (int_of_char ch - int_of_char '0'))
         else None

(* a function to test readnum *)
let get_num_from_user () =
  (Printf.printf "Enter a number: "; flush stdout;
   match (readnum stdin) with
   | None -> Printf.printf "Bad input\n"
   | (Some n) -> Printf.printf "Your input: %d\n" n)
