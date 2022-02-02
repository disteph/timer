(**********)
(* Timers *)
(**********)

type t = string*(float ref)*(float option ref)

exception TimerException of string
        
let create s = 
  let timed   = ref 0. in
  let ongoing = ref None in
  (s,timed,ongoing)

let name (s,_,_) = s

let is_running (_s,_timed,ongoing) =
  match !ongoing with 
  | Some _ -> true
  | None   -> false

let start time (s,_timed,ongoing) =
  match !ongoing with
  | Some _last -> raise (TimerException ("Trying to start timer "^s^" but it is already started"))
  | None       -> ongoing := Some time

let stop time (s,timed,ongoing) =
  match !ongoing with
  | Some last -> let span = time -. last in
                 timed   := !timed +. span;
                 ongoing := None
  | None -> raise (TimerException ("Trying to stop timer "^s^" but it is already stopped"))

let last_time = ref 0.

let sys_time () =
  let r = Sys.time() in
  last_time := r;
  r
        
let transfer t t' =
  let time = sys_time() in
  stop time t;
  start time t'

let start t = start (sys_time()) t
let stop t  = stop  (sys_time()) t

let read (_s,timed,ongoing) =
  match !ongoing with
  | Some last -> let span = Sys.time() -. last in !timed+.span
  | None -> !timed

let reset (_s,timed,ongoing) =
  match !ongoing with
  | Some _last -> timed:=0.; ongoing:=Some(Sys.time())
  | None -> timed := 0.

let last_time () = !last_time
