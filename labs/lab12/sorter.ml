(* Red-black tree implementation. Used here to store a list of numbers
   provided by the user so that they can be printed in sorted order *)

type color = R | B

type 'a rbtree =
    Empty
  | Node of color * 'a * 'a rbtree * 'a rbtree

(* Precondition: t is a tree that satisfies all the properties of being
                 a red-black tree except that some one red child may
                 have a red child
   Invariant: (balance t) returns a new tree with the same black height as
              t that may either have one red-red conflict between the root
              and a child or may have a root whose color has changed from
              red to black; these conditions are exclusive *)
let balance t =
  match t with
  | ( Node(B,z,Node(R,x,Node(R,y,a,b),c),d) |
      Node(B,z,Node(R,y,a,Node(R,x,b,c)),d) |
      Node(B,y,a,Node(R,z,Node(R,x,b,c),d)) |
      Node(B,y,a,Node(R,x,b,Node(R,z,c,d))) ) ->
        Node(R,x,Node(B,y,a,b),Node(B,z,c,d))
  |  _ -> t

(* Precondition: t is assumed to be a red-black tree
   Invariant: (insert t d) returns a new red-black tree that
               contains all the data in t plus the additional item d *)
let insert t d =

   (* Precondition: t is a red black tree
      Invariant: (ins t) returns a tree with all the data in t plus d
                 that additionally satisfies the properties of being a
                 red-black tree except that there may be a violation of
                 the no red child for a red parent constraint at the root.
                 Also, the black height of t is preserved. *)
   let rec ins t =
     match t with
     | Empty -> Node (R, d, Empty, Empty)
     | Node (c,d',l,r) ->
         if (d < d') then balance (Node (c,d',ins l, r))
         else balance (Node (c,d', l,ins r))
   in match (ins t) with
      | Node (_,d,l,r) -> Node (B,d,l,r)
      | Empty -> raise (Invalid_argument "insert")

let rec keylist =
   function
     | Empty -> []
     | Node (_,k,l,r) -> (keylist l) @ [k] @ (keylist r)


(* Function for printing a list; must be given an item printer. *)
let printlist item_printer l =
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

(* A printer for integer items *)
let int_printer i = Printf.printf "%d" i

(* The main function for this program *)
let get_and_sort_numbers () =
  let print_banner () =
     (Printf.printf "Hello, I will sort numbers for you. Give me a \n";
      Printf.printf "sequence of positive numbers, one on each line.\n";
      Printf.printf "Terminate the sequence with a negative number.\n"
     ) in
  let rec assimilate_numbers t =
    let n = read_int () in
      if n < 0 then t
      else assimilate_numbers (insert t n) in
  let print_numbers l =
     (Printf.printf "The sorted list of numbers: ";
      printlist int_printer l)
  in
    (print_banner ();
     print_numbers (keylist (assimilate_numbers Empty));
     Printf.printf "\n";);;

get_and_sort_numbers ()
