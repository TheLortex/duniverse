module Color : sig
  type t =
    | Default
    | Black
    | Red
    | Green
    | Yellow
    | Blue
    | Magenta
    | Cyan
    | White
    | Bright_black
    | Bright_red
    | Bright_green
    | Bright_yellow
    | Bright_blue
    | Bright_magenta
    | Bright_cyan
    | Bright_white
end

module Style : sig
  type t = Fg of Color.t | Bg of Color.t | Bold | Dim | Underlined

  val escape_sequence : t list -> string
  (** Ansi escape sequence that set the terminal style to exactly
      these styles *)
end

module Render : Pp.Renderer.S with type Tag.t = Style.t list

val strip : string -> string
(** Filter out escape sequences in a string *)
