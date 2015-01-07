val t1 = only_capitals [] = []
val t2 = only_capitals ["hello", "bye"] = []
val t3 = only_capitals ["Anal", "hello", "bye"] = ["Anal"]
val t4 = only_capitals ["hello", "Pemis", "bye"] = ["Pemis"]
val t5 = only_capitals ["hello", "bye", "Eblo"] = ["Eblo"]
 
val t6 = longest_string1 [] = ""
val t7 = longest_string1 ["pemis"] = "pemis"
val t8 = longest_string1 ["pemis", "hello"] = "pemis"
val t9 = longest_string1 ["eblo", "hello"] = "hello"
val t10 = longest_string1 ["hello", "eblo"] = "hello"
 
val t11 = longest_string2 [] = ""
val t12 = longest_string2 ["pemis"] = "pemis"
val t13 = longest_string2 ["pemis", "hello"] = "hello"
val t14 = longest_string2 ["eblo", "hello"] = "hello"
val t15 = longest_string2 ["hello", "eblo"] = "hello"
 
val t16 = longest_string3 [] = ""
val t17 = longest_string3 ["pemis"] = "pemis"
val t18 = longest_string3 ["pemis", "hello"] = "pemis"
val t19 = longest_string3 ["eblo", "hello"] = "hello"
val t20 = longest_string3 ["hello", "eblo"] = "hello"
 
val t21 = longest_string4 [] = ""
val t22 = longest_string4 ["pemis"] = "pemis"
val t23 = longest_string4 ["pemis", "hello"] = "hello"
val t24 = longest_string4 ["eblo", "hello"] = "hello"
val t25 = longest_string4 ["hello", "eblo"] = "hello"
 
val t26 = longest_capitalized [] = ""
val t27 = longest_capitalized ["hello", "bye"] = ""
val t28 = longest_capitalized ["Anal", "hello", "bye"] = "Anal"
val t29 = longest_capitalized ["Anal", "hello", "Pemis", "bye"] = "Pemis"
 
val t30 = rev_string "" = ""
val t31 = rev_string "M" = "M"
val t32 = rev_string "hello" = "olleh"
val t33 = rev_string "ebLo" = "oLbe"
 
val t34 = first_answer (fn x => if x = 3 then SOME "hi" else NONE) [1,2] = "M" handle NoAnswer => true
val t35 = first_answer (fn x => if x = 3 then SOME "hi" else NONE) [1,2,3] = "hi"
 
val t36 = all_answers (fn x => NONE) [] = SOME []
val t37 = all_answers (fn x => NONE) [1] = NONE
val t38 = all_answers (fn x => if x < 3 then SOME ["hi","hello"] else NONE) [1,2] =
  SOME ["hi", "hello", "hi", "hello"]
 
val t39 = count_wildcards UnitP = 0
val t40 = count_wildcards Wildcard = 1
val t41 = count_wildcards (ConstructorP ("M", Wildcard)) = 1
val t42 = count_wildcards (TupleP [Wildcard, UnitP, Wildcard]) = 2
 
val t43 = count_wild_and_variable_lengths UnitP = 0
val t44 = count_wild_and_variable_lengths Wildcard = 1
val t45 = count_wild_and_variable_lengths (Variable "pemis") = 5
val t46 = count_wild_and_variable_lengths (ConstructorP ("M", Wildcard)) = 1
val t47 = count_wild_and_variable_lengths (TupleP [Wildcard, Variable "pemis", UnitP, Wildcard]) = 7
 
val t48 = count_some_var ("pemis", UnitP) = 0
val t49 = count_some_var ("pemis", Wildcard) = 0
val t50 = count_some_var
    ("pemis", TupleP [Variable "pemis", UnitP, Variable "pemis", Variable "eblo"]) = 2
 
val t51 = check_pat UnitP = true
val t52 = check_pat (TupleP [Variable "pemis", Variable "pemis", Variable "eblo"]) = false
val t53 = check_pat (TupleP [Variable "pemis", Variable "eblo"]) = true