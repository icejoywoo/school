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
fun all_answers f l =
	let
		fun helper answers =
			case answers of
				  NONE::[] => []
				| NONE::xs' => helper xs'
				| SOME x::[] => x
				| SOME x::xs' => x @ (helper xs')
	in
		case l of
			  [] => SOME []
			| _ => let
						val v = helper (map f l)
					in
						case v of
							  [] => NONE
							| _ => SOME v
					end
	end

(* 9 *)
val count_wildcards = g (fn x => 1) (fn y => 0)

val count_wild_and_variable_lengths = g (fn x => 1) (fn y => String.size y)

fun count_some_var (x, p) =
	g (fn x => 0) (fn y => if x = y then 1 else 0) p

(* 10 *)
fun check_pat p =
	let
		fun vars p = 
			case p of
			    Variable x        => [x]
			  | TupleP ps         => List.foldl (fn (p,i) => (vars p) @ i) [] ps
			  | ConstructorP(_,p) => vars p
			  | _                 => []

		fun repeat lst =
			case lst of
				  [] => true
				| x::xs' => if List.exists (fn y => x = y) xs' then false
							else repeat xs'
	in
		repeat (vars p)
	end

(* 11 *)
fun match (v, p) =
	let
		fun match_pattern (v, p) =
			case (v, p) of
				  (_, Wildcard) => SOME []
				| (v', Variable s) => SOME [(s, v')]
				| (Unit, UnitP) => SOME []
				| (Const x1, ConstP x2) => if x1 = x2 then SOME [] else NONE
				| (Tuple vs, TupleP ps) => if List.length vs = List.length ps 
										   then SOME (List.foldl (fn (p,i) => valOf(match_pattern p) @ i) [] (ListPair.zip(vs, ps)))
										   else NONE
				| (Constructor(s1,v), ConstructorP(s2,p)) => if s1 = s2 then match_pattern (v, p) else NONE
				| _ => NONE
	in
		match_pattern (v, p)
	end
	
(* 12 *)
fun first_match x y = SOME []

