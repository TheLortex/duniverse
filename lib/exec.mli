(* Copyright (c) 2018 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

val map : ('a -> ('b, 'c) result) -> 'a list -> ('b list, 'c) result

val iter : ('a -> (unit, 'b) result) -> 'a list -> (unit, 'b) result

val git_default_branch : remote:string -> unit -> (string, [> Rresult.R.msg ]) result
(** Return the default branch for the given remote name by running git remote show [remote] and
    parsing the output looking for HEAD branch: <branch_name> *)

val git_add_and_commit :
  repo:Fpath.t -> message:string -> Bos.Cmd.t -> (unit, [> Rresult.R.msg ]) result
(** [git_add_and_commit ~repo ~message files] adds [files] to [repo] and commits them with
    [message]. *)

val is_git_repo_clean : repo:Fpath.t -> unit -> (bool, [> Rresult.R.msg ]) result
(** Return whether the given repo is clean, ie return true if there is no uncommitted changes *)

val git_checkout : ?args:Bos.Cmd.t -> repo:Fpath.t -> string -> (unit, [> Rresult.R.msg ]) result
(** [git_checkout ~args ~repo branch] checks out the git repository in [repo] to branch [branch]
    with the extra arguments [args]. *)

val git_checkout_or_branch : repo:Fpath.t -> string -> (unit, [> Rresult.R.msg ]) result
(** [git_checkout ~repo branch] checks out the git repository in [repo] to branch [branch] creating
    it if it doesn't exist yet. *)

val git_add_all_and_commit :
  repo:Fpath.t -> message:string -> unit -> (unit, [> Rresult.R.msg ]) result
(** [git_add_all_and_commit ~repo ~message ()] runs git add -am [message] in [repo]. *)

val git_merge :
  ?args:Bos.Cmd.t -> from:string -> repo:Fpath.t -> unit -> (unit, [> Rresult.R.msg ]) result
(** [git_merge ~args ~repo branch] merges [from] into [repo]'s current active branch with the extra
    arguments [args]. *)

val run_opam_package_deps : root:Fpath.t -> string list -> (string list, [> Rresult.R.msg ]) result
(** [run_opam_packages_deps ~root packages] returns a list of versioned constrained packages that
    resolves the transitive dependencies of [packages]. *)

val run_opam_show :
  root:Fpath.t ->
  fields:string list ->
  packages:Types.Opam.package list ->
  (string list, [> Rresult.R.msg ]) result
(** [run_opam_show ~root ~fields ~packages] runs opam show to get [fields] for each package in [packages].*)

val init_opam_and_remotes :
  root:Fpath.t -> remotes:Types.Opam.Remote.t list -> unit -> (unit, [> Rresult.R.msg ]) result
(** [init_opam_and_remotes ~root ~remotes ()] creates a fresh opam state with a single
    switch using [root] as OPAMROOT and adds the [remotes] opam repositories to it. *)

val add_opam_dev_pin : root:Fpath.t -> Types.Opam.pin -> (unit, [> Rresult.R.msg ]) result
(** [add_opam_dev_pin ~root pin] pins [pin] in the active switch using [root] as OPAMROOT. *)

val add_opam_local_pin : root:Fpath.t -> string -> (unit, [> Rresult.R.msg ]) result
(** [add_opam_local_pin ~root package] pins the package in the current working dir under
    [package ^ ".dev"] in the active switch using [root] as OPAMROOT. *)

val run_opam_install : yes:bool -> Duniverse.Deps.Opam.t list -> (unit, [> Rresult.R.msg ]) result
(** [run_opam_install ~yes packages] launch an opam command to install the given packages. If yes is
    set to true, it doesn't prompt the user for confirmation. *)

val git_remote_add : repo:Fpath.t -> remote_url:string -> remote_name:string -> (unit, [> Rresult.R.msg ]) result
(** Uses git remote add in repo **)

val git_remote_remove : repo:Fpath.t -> remote_name:string -> (unit, [> Rresult.R.msg ]) result
(** Uses git remote remove in repo **)

val git_fetch_to :
  repo:Fpath.t -> remote_name:string -> tag:string -> branch:string -> unit -> (unit, [> Rresult.R.msg ]) result
(** [git_fetch_to ~remote_name ~tag ~branch] Fetches tag from remote_name into a given branch **)

val git_init : repo:Fpath.t -> (unit, [> Rresult.R.msg ]) result
(** [git_init path] Initialize Git in given path **)

val git_clone :
  branch:string -> remote:string -> output_dir:Fpath.t -> (unit, [> Rresult.R.msg ]) result
(** [git_clone ~branch ~remote ~output_dir] Git clone branch from remote in output_dir **)

val git_rename_branch_to : repo:Fpath.t -> branch:string -> (unit, [> Rresult.R.msg ]) result
(** [git_rename_branch_to ~branch] Sets repo's branch name to branch. **)

val git_remotes : repo:Fpath.t -> (string list, [> Rresult.R.msg ]) result
(** [git_remotes repo] List remotes of the git project located in repo. **)

val git_branch_exists : repo:Fpath.t -> branch:string -> bool
(** [git_branch_exists repo branch] Returns true if branch exists in repo. **)