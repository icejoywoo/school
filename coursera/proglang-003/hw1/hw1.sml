(* author: Eric email: icejoywoo at gmail dot com *)
(* coursera proglang-003 hw1 *)

(* 1 *)
fun is_older (x : (int*int*int), y : (int*int*int)) =
    if (#1 x) < (#1 y) then true
    else if (#1 x) = (#1 y) andalso (#2 x) < (#2 y) then true
    else if (#1 x) = (#1 y) andalso (#2 x) = (#2 y) andalso (#3 x) < (#3 y) then true
    else false

(* 2 *)
fun number_in_month (dates : (int*int*int) list, month) =
    if null dates then 0
    else
        if #2 (hd dates) = month
        then 1 + number_in_month(tl dates, month)
        else number_in_month(tl dates, month)

(* 3 *)
fun number_in_months (dates : (int*int*int) list, months: int list) =
    if null months then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)

(* 4 *)
fun dates_in_month (dates : (int*int*int) list, month) =
    if null dates then []
    else
        if #2 (hd dates) = month
        then hd dates :: dates_in_month(tl dates, month)
        else dates_in_month(tl dates, month)

(* 5 *)
fun append (xs: 'a list, ys: 'a list) =
    if null xs
    then ys
    else hd(xs) :: append(tl(xs), ys)

fun dates_in_months (dates : (int*int*int) list, months: int list) =
    if null months then []
    else append(dates_in_month(dates, hd months), dates_in_months(dates, tl months))

(* 6 *)
fun get_nth (strings : string list, index: int) =
    if index = 1
    then hd strings
    else get_nth(tl strings, index-1)

(* 7 *)
fun date_to_string (date : (int*int*int)) =
    let
        val month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        val (year, month, day) = date
    in
        get_nth(month_names, month) ^ " " ^ Int.toString day ^ ", " ^ Int.toString year
    end

(* 8 *)
(* compute sum of first n elements *)
fun sum_list (numbers: int list, n : int) =
    if n = 0 then 0
    else if null numbers then 0
    else hd numbers + sum_list(tl numbers, n-1)

fun number_before_reaching_sum (sum: int, numbers: int list) =
    let
        fun helper (index: int, first_sum: int, numbers: int list) =
            if hd numbers >= first_sum
            then index - 1
            else helper (index + 1, first_sum - hd numbers, tl numbers)
    in
        helper (1, sum, numbers)
    end

(* 9 *)
fun what_month (day_of_year: int) =
    let
        val month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    in
        number_before_reaching_sum(day_of_year, month_days) + 1
    end

(* 10 *)
fun month_range (day1: int, day2: int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1+1, day2)

(* 11 *)
fun oldest (dates: (int*int*int) list) =
    if null dates then NONE
    else
        let
            val tl_oldest = oldest(tl dates)
        in
            if isSome(tl_oldest) andalso is_older(valOf(tl_oldest), (hd dates)) then tl_oldest
            else SOME (hd dates)
        end

(* 12  *)
fun in_list (x: int, l: int list) =
    if null l
    then false
    else
        if x = hd l then true
        else in_list(x, tl l)

fun remove_duplicates (l: int list) =
    if null l then []
    else
        if in_list(hd l, tl l) then remove_duplicates(tl l)
        else hd l :: remove_duplicates(tl l)

fun number_in_months_chanllenge (dates : (int*int*int) list, months : int list) =
    number_in_months(dates, remove_duplicates(months))

fun dates_in_months_chanllenge (dates : (int*int*int) list, months : int list) =
    dates_in_months(dates, remove_duplicates(months))

(* 13 *)
fun reasonable_date(date : int*int*int) =
    let
        val (year, month, day) = date
    in
        year > 0
        andalso month >= 1
        andalso month <= 12
        andalso day > 0
        andalso (
            (in_list(month, [1,3,5,7,8,10,12]) andalso day <= 31)
            orelse (in_list(month, [4,6,9,11]) andalso day <= 30)
            orelse (month = 2) andalso (
                if year mod 400 = 0 then day <= 29
                else if (year mod 4 = 0) andalso (year mod 100 <> 0) then day <= 29
                else day <= 28
            )
        )
    end
