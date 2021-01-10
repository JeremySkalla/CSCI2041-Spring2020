(* Solution to Problem 2, Homework 2, CSci 2041, Spring 2020 *)

(* Write comment here  *)

let rec fib' n i fib1 fib2 temp =
  if n = i then fib1 else fib' n (i+1) fib2 (fib2+temp) fib2

let fib n =
  if n = 1 then 1 else fib' n 1 1 1 1
