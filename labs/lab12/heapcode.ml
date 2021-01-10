                  (* Copyright (c) Gopalan Nadathur *)

         type item = Item.item

        let leq(p, q) : bool = Item.leq(p,q)

        let max(p,q) = if leq(p,q) then q else p
        and min(p,q) = if leq(p,q) then p else q

        let intmax((p : int),q) = if p <= q then q else p

        type tree =
          | L of item
          | N of item * tree * tree

       exception InitHeap

       let rec initHeap n =
           if (n < 1) then raise InitHeap
           else if n = 1 then L Item.initial
                else let t = initHeap(n - 1)
                     in N (Item.initial, t, t)

        let rec top t =
          match t with
          | (L i) -> i
          | N (i,_,_) -> i


        let rec isHeap t =
          match t with
          | (L _) -> true
          | (N(i,l,r)) ->
            leq(i,top l) && leq(i,top r) && isHeap l && isHeap r

        let rec depth t =
          match t with
          | (L _) -> 1
          | N(i,l,r) -> 1 + intmax(depth l,depth r)

       let rec replace (i,h) = (top h, insert(i,h))
       and insert (i, h) =
         match h with
         | L _ -> L i
         | N (_,l,r) ->
           if leq(i,min(top l,top r))
           then N(i,l,r)
           else if leq((top l),(top r))
                then N(top l,insert(i,l),r)
                else N(top r,l,insert(i,r))

       let rec size h =
         match h with
         | L _ -> 1
         | N (_,l,r) -> 1 + size l + size r

       let rec maxHeap h =
         match h with
         | (L i) -> i
         | N (_,l,r) -> max(maxHeap l, maxHeap r)
