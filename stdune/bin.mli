(** Binaries from the PATH *)

val path_sep : char
(** Character used to separate entries in [PATH] and similar
    environment variables *)

val parse_path : ?sep:char -> string -> Path.t list
(** Parse a [PATH] like variable *)

val cons_path : Path.t -> _PATH:string option -> string
(** Add an entry to the contents of a [PATH] variable. *)

val exe : string
(** Extension to append to executable filenames *)

val which : path:Path.t list -> string -> Path.t option
(** Look for a program in the PATH *)

val best_prog : Path.t -> string -> Path.t option
(** Return the .opt version of a tool if available. If the tool is not available
    at all in the given directory, returns [None]. *)

val make : path:Path.t list -> Path.t option
(** "make" program *)
