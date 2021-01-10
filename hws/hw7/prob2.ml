   (* Solution to Problem 2, Homework 7, CSci 2041, Spring 2020 *)

(* First, some declarations providing the stream abstraction *)

type 'a stream =
   Stream of (unit -> 'a * 'a stream)

let mkStream f = Stream f
let nextStream (Stream f) = f ()

(* Next some definitions that provide a natural number stream *)

let rec fromNStream n = mkStream (fun () -> (n, fromNStream (n+1)))

let natStream = (fromNStream 0)


(* Solution to Part 1, Problem 2 *)

let rec mapStream fn s =
  match (nextStream s) with
  | (x, rst) -> mkStream (fun () -> ((fn x), (mapStream fn rst)))


(* Solution to Part 2, Problem 2 *)

let squareStream = (mapStream (fun x -> x * x) natStream)       

let cubeStream = (mapStream (fun x -> x * x * x) natStream)
   
(* Solution to Part 3, Problem 2 *)

let rec streamMatcher ss cs =
  match (nextStream ss) with
  | (sx, srst) ->
     (match (nextStream cs) with
      | (cx, crst) -> if cx = sx then (mkStream (fun () -> cx, (streamMatcher srst crst)))
                      else if cx > sx then (streamMatcher srst cs)
                      else (streamMatcher ss crst)
     )
  

let squarecubeStream = (streamMatcher squareStream cubeStream)
