(** Element ordering *)

type t = Lt  (** Lesser than  *) | Eq  (** Equal        *) | Gt  (** Greater than *)

val of_int : int -> t

val to_int : t -> int

val to_string : t -> string
(** returns the string representation. one of: "<", "=", ">" *)

val neq : t -> bool

val is_eq : t -> bool
