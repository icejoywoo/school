(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* 1 *)
fun only_capitals l =
	List.filter (fn x => Char.isUpper(String.sub(x, 0))) l

(* 2 *)
fun longest_string1 l =
	foldl (fn (a, b) => if String.size(a) > String.size(b) then a else b) "" l

(* 3 *)
fun longest_string2 l =
	foldl (fn (a, b) => if String.size(a) >= String.size(b) then a else b) "" l


(* 4 *)
fun longest_string_helper f l =
	foldl (fn (a, b) => if f (String.size(a), String.size(b)) then a else b) "" l

fun longest_string3 l =
	longest_string_helper (fn (a, b) => a > b) l

fun longest_string4 l =
	longest_string_helper (fn (a, b) => a >= b) l

(* 5 *)
fun longest_capitalized l =
	longest_string1 (only_capitals l)

(* 6 *)
fun rev_string l : string =
	String.implode (rev (String.explode l))

(* 7 *)
fun first_answer f l =
	let
		fun helper answers =
			case answers of
				  NONE::[] => raise NoAnswer
				| NONE::xs' => helper xs'
				| SOME x::_ => x
	in
		helper (map f l)
	end

(* 8 *)
(* https://github.com/turingman111/proglang/blob/master/ass-03.sml *)
fun all_answers f l =
	let
		fun helper answers =
			case answers of
				  NONE::[] => NONE
				| NONE::xs' => helper xs'
				| SOME x::[] => x
				| SOME x::xs' => x :: (helper xs')

		fun transfer lst =
			case lst of
				  [] => []
				| SOME x:: xs' => x @ transfer xs'
				| NONE::xs'  => transfer xs'
	in
		case l of
			  [] => SOME []
			| _ =>
		SOME (transfer (helper (map f l)))
	end
