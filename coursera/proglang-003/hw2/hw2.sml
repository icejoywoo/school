(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun all_except_option (e : string, l : string list) =
    let
        fun remove (s, lst) =
            case lst of
                  [] => []
                | x::xs' => if same_string(x, s) then remove(s, xs')
                            else x :: remove(s, xs')
        val removed_list = remove(e, l)
    in
        if removed_list = l then NONE
        else SOME removed_list
    end

fun get_substitutions1 (strings : string list list, s: string) =
    case strings of
          [] => []
        | x::xs' => case all_except_option(s, x) of
                          NONE => get_substitutions1(xs', s)
                        | SOME y => y @ get_substitutions1(xs', s)

fun get_substitutions2 (strings : string list list, s: string) =
    let
        fun helper (strings : string list list, s: string, ret: string list) =
            case strings of
                  [] => ret
                | x::xs' => case all_except_option(s, x) of
                                  NONE => helper(xs', s, ret)
                                | SOME y => helper(xs', s, ret @ y)
    in
        helper (strings, s, [])
    end

fun similar_names (strings : string list list, name : {first: string, middle: string, last: string}) =
    let
        fun helper (lst : string list, name : {first: string, middle: string, last: string}) =
            case lst of
                  [] => [name]
                | x::xs' => name :: helper(xs', {first = x, middle = #middle name, last = #last name})
        
        val similar_first_names = get_substitutions2 (strings, #first name)
    in
        helper (similar_first_names, name)
    end

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color (c : card) =
    case c of
          (Spades, _) => Black
        | (Clubs, _) => Black
        | (Diamonds, _) => Red
        | (Hearts, _) => Red

fun card_value (c : card) =
    case c of
          (_, Ace) => 11
        | (_, Num x) => x
        | _ => 10

(* more clear *)
fun remove_card (cs : card list, c : card, e : exn) =
    let
        fun helper (cs, c, flag) =
            case (flag, cs) of
                  (false, []) => raise e
                | (true, []) => []
                | (true, x::xs') => x :: helper(xs', c, flag)
                | (false, x::xs') => if x = c then helper(xs', c, true)
                                     else x :: helper(xs', c, flag)
    in
        helper (cs, c, false)
    end

fun all_same_color (cs : card list) =
    case cs of
          [] => true
        | _::[] => true
        | head::(neck::rest) => card_color(head) = card_color(neck) andalso all_same_color(neck::rest)

fun sum_cards (cs : card list) =
    let
        fun helper (cs : card list, acc : int) =
            case cs of
                  [] => acc
                | x::xs' => helper(xs', card_value(x) + acc)
    in
        helper (cs, 0)
    end

fun score (cs : card list, goal : int) =
    let
        val sum = sum_cards(cs)
        val pre_score = if (sum > goal) then 3 * (sum - goal) else (goal - sum)
    in
        if all_same_color(cs) then pre_score div 2
        else pre_score
    end

fun officiate (cs : card list, mvs : move list, goal : int) =
    let
        fun helper (cs : card list, mvs : move list, goal : int, held_cards: card list) =
            case mvs of
                  [] =>  score(held_cards, goal)
                | x::xs' => case (x, cs) of
                              (Discard c, _) => helper(cs, xs', goal, remove_card(held_cards, c, IllegalMove))
                            | (Draw, []) => score(held_cards, goal)
                            | (Draw, c::cs') => let
                                                    val current_score = score(c :: held_cards, goal)
                                                in
                                                    if current_score > goal then current_score
                                                    else helper(cs', xs', goal, c :: held_cards)
                                                end
    in
        helper (cs, mvs, goal, [])
    end

fun score_challenge (cs : card list, goal : int) =
    let
        fun card_value (c : card, ace : int) =
            case #2 c of
                  Ace => ace
                | Num x => x
                | _ => 10

        fun sum_cards (cs : card list, ace : int) =
            let
                fun helper (cs : card list, acc : int) =
                    case cs of
                          [] => acc
                        | x::xs' => helper(xs', card_value(x, ace) + acc)
            in
                helper (cs, 0)
            end

        val sum_ace1 = sum_cards(cs, 1)
        val sum_ace11 = sum_cards(cs, 11)

        val pre_score_ace1 = if (sum_ace1 > goal) then 3 * (sum_ace1 - goal) else (goal - sum_ace1)
        val pre_score_ace11 = if (sum_ace11 > goal) then 3 * (sum_ace11 - goal) else (goal - sum_ace11)

        val min_pre_score = if pre_score_ace1 > pre_score_ace11 then pre_score_ace11
                            else pre_score_ace1
    in
        if all_same_color(cs) then min_pre_score div 2
        else min_pre_score
    end

fun officiate_challenge (cs : card list, mvs : move list, goal : int) =
    let
        fun helper (cs : card list, mvs : move list, goal : int, held_cards: card list) =
            case mvs of
                  [] =>  score_challenge(held_cards, goal)
                | x::xs' => case (x, cs) of
                              (Discard c, _) => helper(cs, xs', goal, remove_card(held_cards, c, IllegalMove))
                            | (Draw, []) => score_challenge(held_cards, goal)
                            | (Draw, c::cs') => let
                                                    val current_score = score_challenge(c :: held_cards, goal)
                                                in
                                                    if current_score > goal then current_score
                                                    else helper(cs', xs', goal, c :: held_cards)
                                                end
    in
        helper (cs, mvs, goal, [])
    end

(*
fun careful_player (cs : card list, goal : int) =
    let
        fun helper (cs : card list, goal : int, held_cards : card list) =
            case cs of
                  [] => []
                | head::(neck::rest) => 
    in
        helper (cs, goal, [])
    end
*)  

