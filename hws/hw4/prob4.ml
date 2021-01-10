(* Jeremy Skalla *)

(* Problem 4 in Homework 4, CSci 2041, Spring 2020 *)

(* Definitions of statement forms seen in class and in the lab *)
let seq stat1 stat2 =
        fun s -> (stat2 (stat1 s))

let ifstat exp stat1 stat2 =
    fun s -> if (exp s) then (stat1 s)
             else (stat2 s)

let rec whilestat exp stat =
   fun s ->
      ifstat exp
             (seq stat (whilestat exp stat))
             (fun x -> x) s

(* Part 1a *)

(* ((state1 -> state2) -> bool) -> (state1 -> state1) -> (state1 -> state2) -> state1 -> state2 *)
(* I think this is what you want but not sure (???)*)

(* Part 1b *)

let rec dostat exp stat =
  fun s -> seq stat (ifstat exp (dostat exp stat) (fun x -> x)) s

(* Part 2a *)

(* I think it's state * state * state -> int * int * int *)

(* Part 2b *)

let getI (i, sum, n) = i

let getSum (i, sum, n) = sum

let getN (i, sum, n) = n

let putI exp = fun s -> let (i, sum, n) = s in (exp s, sum, n)

let putSum exp = fun s -> let (i, sum, n) = s in (i, exp s, n)

let putN exp = fun s -> let (i, sum, n) = s in (i, sum, exp s)

let zero = fun s -> 0

(* Part 2c *)

let i_less_n = (fun s -> (getI s) < (getN s))

let i_plus_one = (fun s -> (getI s) + 1)

let sum_plus_i  = (fun s -> (getSum s) + (getI s))

let sumup =
  seq (putSum zero)
    (seq (putI zero)
       (dostat i_less_n
          (seq (putI i_plus_one) (putSum sum_plus_i))))

(* Part 3 *)

let sumToN i =
  match sumup (0,0,i) with
  | (a,b,c) -> b
