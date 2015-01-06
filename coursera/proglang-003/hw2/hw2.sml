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
        case removed_list of
              [] => NONE
            | _ => if removed_list = l then NONE
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
    case #1 c of
          Spades => Black
        | Clubs => Black
        | Diamonds => Red
        | Hearts => Red

fun card_value (c : card) =
    case #2 c of
          Ace => 11
        | Num x => x
        | _ => 10

fun remove_card_old (cs : card list, c : card, e : exn) =
    let
        fun helper (cs, c, flag) =
            case cs of
                  [] => if flag then [] else raise e
                | x::xs' => if flag then x :: helper(xs', c, flag)
                            else if x = c then helper(xs', c, true)
                            else x :: helper(xs', c, flag)
    in
        helper (cs, c, false)
    end

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

fun all_same_color_old (cs : card list) =
    let
        fun helper (cs : card list, color : color option) =
            let
                fun inner (cs) =
                    case cs of
                          [] => true
                        | x::xs' => helper (xs', SOME(card_color x))
            in
                case color of
                  NONE => inner(cs)
                | SOME c => case cs of
                                  [] => true
                                | x::xs' => if card_color(x) = c then helper (xs', SOME(card_color x))
                                            else false
            end
            
    in
        helper (cs, NONE)
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
    10

