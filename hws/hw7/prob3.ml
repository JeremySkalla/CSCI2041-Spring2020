   (* Solution to Problem 3, Homework 7, CSci 2041, Spring 2020 *)

(* First some definitions that realize the new stream abstraction *)

type 'a stream = Stream of 'a stream_aux ref
and  'a stream_aux =
       | Evald of ('a * 'a stream)
       | UnEvald of (unit -> 'a * 'a stream)

(* Problem 3, Part 1 *)

let mkStream f = Stream (ref (UnEvald f))

let rec nextStream (Stream f) =
  match !f with
  | Evald (x, rst) -> (x, rst)
  | UnEvald fn -> let temp = fn () in f := Evald (temp);
                                      temp
                             
  
(* Problem 3, Part 2 *)

(* Replace this comment with a definition of the identifier

      natStream : int stream

   that behaves the way described in the problem writeup.
 *)

let rec fromNStream n = mkStream (fun () -> (n, fromNStream (n+1)))

let natStream = fromNStream 0
