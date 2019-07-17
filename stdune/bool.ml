let compare x y =
  match (x, y) with
  | true, true | false, false -> Ordering.Eq
  | true, false -> Gt
  | false, true -> Lt

include Comparable.Operators (struct
  type nonrec t = bool

  let compare = compare
end)

let to_string = string_of_bool

let of_string s = Option.try_with (fun () -> bool_of_string s)

let to_dyn t = Dyn0.Bool t

let to_sexp t = Sexp0.Atom (to_string t)
