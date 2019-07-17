(** Pretty printers *)

(** A document that is not yet rendered. The argument is the type of
    tags in the document. For instance tags might be used for
    styles. *)
type +'tag t

(** {1 Basic combinators} *)

val nop : _ t
(** A pretty printer that prints nothing *)

val seq : 'a t -> 'a t -> 'a t
(** [seq x y] prints [x] and then [y] *)

val concat : ?sep:'a t -> 'a t list -> 'a t
(** [concat ?sep l] prints elements in [l] separated by [sep]. [sep]
    defaults to [nop]. *)

val concat_map : ?sep:'a t -> 'b list -> f:('b -> 'a t) -> 'a t
(** Convenience function for [List.map] followed by [concat] *)

val verbatim : string -> _ t
(** An indivisible block of text *)

val char : char -> _ t
(** A single character *)

val text : string -> _ t
(** Print a bunch of text. The line may be broken at any spaces in the
    text. *)

val textf : ('a, unit, string, _ t) format4 -> 'a
(** Same as [text] but take a format string as argument. *)

val tag : 'a t -> tag:'a -> 'a t
(** [tag t ~tag] Tag the material printed by [t] with [tag] *)

(** {1 Break hints} *)

val space : _ t
(** Either a newline or a space, depending on whether the line is
    broken at this point. *)

val cut : _ t
(** Either a newline or nothing, depending on whether the line is
    broken at this point. *)

val break : nspaces:int -> shift:int -> _ t
(** Either a newline or [nspaces] spaces. If it is a newline, [shift]
    is added to the indentation level. *)

val newline : _ t
(** Force a newline to be printed *)

(** {1 Boxes} *)

(** Boxes are the basic components to control the layout of the text.
    Break hints such as [space] and [cut] may cause the line to be
    broken, depending on the splitting rules.  Whenever a line is
    split, the rest of the material printed in the box is indented with
    [indent].

    All functions take a list as argument for convenience.  Elements
    are printed one by one. *)

val box : ?indent:int -> 'a t list -> 'a t
(** Try to put as much as possible on each line.  Additionally, a
    break hint always break the line if the breaking would reduce the
    indentation level ([break] with negative [shift] value). *)

val vbox : ?indent:int -> 'a t list -> 'a t
(** Always break the line when encountering a break hint. *)

val hbox : 'a t list -> 'a t
(** Print everything on one line, no matter what *)

val hvbox : ?indent:int -> 'a t list -> 'a t
(** If possible, print everything on one line. Otherwise, behave as a
    [vbox] *)

val hovbox : ?indent:int -> 'a t list -> 'a t
(** Try to put as much as possible on each line. *)

(** {1 Rendering} *)

module type Tag = sig
  type t

  module Handler :
    sig
      type tag = t

      type t

      val init : t
      (** Initial tag handler *)

      val handle : t -> tag -> string * t * string
      (** Handle a tag: return the string that enables the tag, the
        handler while the tag is active and the string to disable the
        tag. *)
    end
    with type tag := t
end

module Renderer : sig
  module type S = sig
    module Tag : Tag

    val string : unit -> (?margin:int -> ?tag_handler:Tag.Handler.t -> Tag.t t -> string) Staged.t

    val channel :
      out_channel -> (?margin:int -> ?tag_handler:Tag.Handler.t -> Tag.t t -> unit) Staged.t
  end

  module Make (Tag : Tag) : S with module Tag = Tag
end

(** A simple renderer that doesn't take tags *)
module Render : Renderer.S with type Tag.t = unit with type Tag.Handler.t = unit

val pp : Format.formatter -> unit t -> unit
(** Render to a formatter *)
