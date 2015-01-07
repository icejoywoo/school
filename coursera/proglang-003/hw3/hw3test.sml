(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]

val test2 = longest_string1 ["A","bc","C"] = "bc"
val test2a = longest_string1 ["A","bc","bC"] = "bc"
val test2b = longest_string1 ["aA","bc","C"] = "aA"

val test3 = longest_string2 ["A","bc","C"] = "bc"
val test3a = longest_string2 ["A","bc","bC"] = "bC"
val test3b = longest_string2 ["aA","bc","C"] = "bc"

val test4a= longest_string3 ["A","bc","C"] = "bc"
val test4a1 = longest_string3 ["A","bc","bC"] = "bc"
val test4a2 = longest_string3 ["aA","bc","C"] = "aA"

val test4b= longest_string4 ["A","B","C"] = "C"
val test4b1 = longest_string2 ["A","bc","bC"] = "bC"
val test4b2 = longest_string2 ["aA","bc","C"] = "bc"

val test5 = longest_capitalized ["A","bc","C"] = "A"
val test5a = longest_capitalized ["A","bc","CC"] = "CC"
val test5b = longest_capitalized ["A","bc","Cd", "Cc"] = "Cd"

val test6 = rev_string "abc" = "cba";

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test7a = first_answer (fn x => if x > 4 then SOME x else NONE) [1,2,3,4,5] = 5
val test7b = ((first_answer (fn x => if x > 10 then SOME x else NONE) [1,2,3,4,5]; false)
				handle NoAnswer => true)

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8a = all_answers (fn x => if x > 1 then SOME [x] else NONE) [2,3,4,5,6,7] = SOME [2,3,4,5,6,7]
val test8b = all_answers (fn x => if x > 4 then SOME [x] else NONE) [2,3,4,5,6,7] = SOME [5,6,7]
val test8c = all_answers (fn x => if x > 4 then SOME [x] else NONE) [] = SOME []

val test9a = count_wildcards Wildcard = 1
val test9a1 = count_wildcards (TupleP [Wildcard, Wildcard]) = 2

val test9b = count_wild_and_variable_lengths (Variable("a")) = 1

val test9c = count_some_var ("x", Variable("x")) = 1

val test10 = check_pat (Variable("x")) = true
val test10a = check_pat (ConstructorP ("hi",TupleP[Variable "x",Variable "x"])) = false
val test10b = check_pat (ConstructorP ("hi",TupleP[Variable "x",ConstructorP ("yo",TupleP[Variable "x",UnitP])])) = false

val test11 = match (Const(1), UnitP) = NONE
val test11a = match (Const(1), ConstP(1)) = SOME []
val test11b = match (Const(1), Variable("xx")) = SOME [("xx",Const 1)]
val test11c = match (Tuple[Const 17,Unit,Const 4,Constructor ("egg",Const 4),Constructor ("egg",Constructor ("egg",Const 4))],TupleP[Wildcard,Wildcard]) = NONE

val test12 = first_match Unit [UnitP] = SOME []

