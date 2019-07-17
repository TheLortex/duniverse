(** Forward declarations *)

type 'a t

val create : unit -> 'a t
(** [create ()] creates a forward declaration. *)

val set : 'a t -> 'a -> unit
(** [set t x] set's the value that is returned by [get t] to [x].
    Raise if [set] was already called *)

val get : 'a t -> 'a
(** [get t] returns the [x] if [set comp x] was called.
    Raise if [set] has not been called yet. *)
