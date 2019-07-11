open Bos
open Rresult
open Astring

let valid_remote_name = String.map (function '/' | '@' | ':' -> '-' | x -> x)

let git_remote_exists_or_create ~repo ~remotes ~remote =
  let remote_name = valid_remote_name remote in
  match String.Set.mem remote_name remotes with
  | true -> Ok ()
  | false -> Exec.git_remote_add ~repo ~remote_url:remote ~remote_name

let git_branch_exists_or_create ~remotes ~branch ~remote ~tag cache_dir =
  let repo = cache_dir in
  let remote_name = valid_remote_name remote in
  if Exec.git_branch_exists ~repo ~branch
  then Ok ()
  else begin
  git_remote_exists_or_create ~repo ~remotes ~remote >>=
  Exec.git_fetch_to ~repo ~remote_name ~tag ~branch
  end

let home () =
  try
    Sys.getenv "HOME"
  with Not_found ->
    try
      (Unix.getpwuid (Unix.getuid ())).Unix.pw_dir
    with Unix.Unix_error _ | Not_found ->
      if Sys.win32 then
        try
          Sys.getenv "AppData"
        with Not_found ->
          ""
      else
  ""

(* Get the location of the duniverse cache repository *)
let get_cache_directory () =
  let ( / ) = Filename.concat in
  let default_cache_dir () =
    let os_cache_dir = if Sys.win32 then "Local Settings" / "Cache" else ".cache" in
    home () / os_cache_dir
  in
  let xdg_cache_dir () =
    match Bos.OS.Env.var "XDG_CACHE_HOME" with Some x -> x | None -> default_cache_dir ()
  in
  let cache_dir () = match Bos.OS.Env.var "DUNIVERSE_CACHE" with Some x -> x | None -> xdg_cache_dir ()
  in
  Fpath.of_string (cache_dir () / "duniverse")

(* Check if the cache repository is initialized and if not, initialize it *)
let check_duniverse_cache_directory cache_location =
  (OS.Dir.exists cache_location >>= function
   | true -> Ok ()
   | false -> Exec.git_init ~repo:cache_location)

(* Check if a remote with a given tag exists in the cache as a branch, and clone to cache if it doesn't exist *)
let check_package_cache_branch ~cache_location ~remote ~tag () =
  let cache_branch_name = valid_remote_name remote ^ "-" ^ tag in
  Exec.git_remotes ~repo:cache_location >>= fun remotes ->
  git_branch_exists_or_create ~remotes:(String.Set.of_list remotes) ~branch:cache_branch_name ~remote ~tag
    cache_location
  >>| fun () -> cache_branch_name

(* Clone to output_dir using the cache *)
let clone_from_cache ~output_dir ~cache_location cache_branch_name =
  OS.Dir.delete ~recurse:true output_dir >>= fun () ->
  Exec.git_clone ~branch:cache_branch_name ~remote:(Fpath.to_string cache_location) ~output_dir

(* Setup usable remotes in the cloned directory *)
let setup_remote ~output_dir ~remote ~tag () =
  Exec.git_rename_branch_to ~repo:output_dir ~branch:tag >>= fun () ->
  Exec.git_remote_add ~repo:output_dir ~remote_name:"upstream" ~remote_url:remote >>= fun () ->
  Exec.git_remote_remove ~repo:output_dir ~remote_name:"origin"

let git_get ~output_dir ~remote ~tag () =
      get_cache_directory ()
  >>= fun cache_location ->
    check_duniverse_cache_directory cache_location
  >>= check_package_cache_branch ~cache_location ~remote ~tag
  >>= clone_from_cache ~output_dir ~cache_location
  >>= setup_remote ~output_dir ~remote ~tag
