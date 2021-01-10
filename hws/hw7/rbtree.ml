type item = Data.item

type color = R | B

type btree =
    Empty
  | Node of color * item * btree * btree

let balance t =
  match t with
  | ( Node(B,z,Node(R,x,Node(R,y,a,b),c),d) |
      Node(B,z,Node(R,y,a,Node(R,x,b,c)),d) |
      Node(B,y,a,Node(R,z,Node(R,x,b,c),d)) |
      Node(B,y,a,Node(R,x,b,Node(R,z,c,d))) ) ->
        Node(R,x,Node(B,y,a,b),Node(B,z,c,d))
  |  _ -> t

let insert (d,t) =
   let rec ins t =
     match t with
     | Empty -> Node (R, d, Empty, Empty)
     | Node (c,d',l,r) ->
         if Data.leq (d,d') then balance (Node (c,d',ins l, r))
         else balance (Node (c,d', l,ins r))
   in match (ins t) with
      | Node (_,d,l,r) -> Node (B,d,l,r)
      | Empty -> raise (Invalid_argument "insert")

let initTree () = Empty

let rec find =
  function
  | (Empty,i) -> false
  | (Node(_,i',l,r),i) ->
       if Data.eq(i,i') then true
       else if Data.leq(i,i')
            then find (l,i)
            else find (r,i)


let print outfile bt =
  let rec indent n =
    match n with
    | 0 -> ()
    | n -> (Printf.fprintf outfile "  "; indent (n-1)) in
  let rec print_aux n =
    function
    | Empty -> ()
    | Node (_,i,l,r) ->
       (print_aux (n+1) l;
        indent n; Data.print outfile i; Printf.fprintf outfile "\n";
        print_aux (n+1) r
       )
  in print_aux 0 bt
