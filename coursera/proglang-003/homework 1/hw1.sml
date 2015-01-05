
fun is_older (x : (int*int*int), y : (int*int*int)) =
    if (#1 x) < (#1 y) then true
    else if (#1 x) = (#1 y) andalso (#2 x) < (#2 y) then true
    else if (#1 x) = (#1 y) andalso (#2 x) = (#2 y) andalso (#3 x) < (#3 y) then true
    else false

fun number_in_month (dates : (int*int*int) list, month) =
    case dates of
      [] => 0
    | x::xs' => 
        if (#2 x) = month
        then 1 + number_in_month(xs', month)
        else number_in_month(xs', month)

fun number_in_months (dates : (int*int*int) list, months: int list) =
    case months of
      [] => 0
    | x::xs' => number_in_month(dates, x) + number_in_months(dates, xs')
    
fun dates_in_month (dates : (int*int*int) list, month) =
    case dates of
      [] => []
    | x::xs' => 
        if (#2 x) = month
        then x :: dates_in_month(xs', month)
        else dates_in_month(xs', month)

fun append (xs: 'a list, ys: 'a list) =
    if null xs
    then ys
    else hd(xs) :: append(tl(xs), ys)


fun dates_in_months (dates : (int*int*int) list, months: int list) =
    case months of
      [] => []
    | x::xs' => append(dates_in_month(dates, x), dates_in_months(dates, xs'))

fun get_nth (strings : string list, index: int) =
    if index = 1
    then hd strings
    else get_nth(tl strings, index-1)

fun date_to_string (date : (int*int*int)) =
    let
        val month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        val (year, month, day) = date
    in
        get_nth(month_names, month) ^ " " ^ Int.toString day ^ ", " ^ Int.toString year
    end

(* compute sum of first n elements *)
fun sum_list (numbers: int list, n : int) =
    case n of
      0 => 0
    | _ => case numbers of
              [] => 0
            | x::xs' => x + sum_list(xs', n-1)

fun number_before_reaching_sum (sum: int, numbers: int list) =
    let
        fun helper (index: int, first_sum: int, numbers: int list) =
            if hd numbers >= first_sum
            then index - 1
            else (print (Int.toString first_sum ^ "\n"); helper (index + 1, first_sum - hd numbers, tl numbers))
    in
        helper (1, sum, numbers)
    end

fun what_month (day_of_year: int) =
    let
        val month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    in
        number_before_reaching_sum(day_of_year, month_days) + 1
    end

fun month_range (day1: int, day2: int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1+1, day2)

fun is_older_optional (x : (int*int*int), y : (int*int*int)) =
    if (#1 x) < (#1 y) then true
    else if (#1 x) = (#1 y) andalso (#2 x) < (#2 y) then true
    else if (#1 x) = (#1 y) andalso (#2 x) = (#2 y) andalso (#3 x) < (#3 y) then true
    else false

(* https://gist.github.com/dmalikov/4615885 *)
fun oldest (dates: (int*int*int) list) =
    if null dates then NONE
    else
        let
            val tl_oldest = oldest(tl dates)
        in
            if isSome(tl_oldest) andalso is_older(valOf(tl_oldest), (hd dates)) then tl_oldest
            else SOME (hd dates)
        end

fun oldest1 (dates: (int*int*int) list) =
    case dates of
      [] => NONE
    | _ => 
        let
            val tl_oldest = oldest(tl dates);
        in
            if (isSome tl_oldest) andalso is_older(valOf tl_oldest, hd dates) then tl_oldest
            else SOME (hd dates)
        end
