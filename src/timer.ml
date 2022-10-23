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

let time no_sys_call =
  if no_sys_call then !last_time
  else 
    let r = Unix.gettimeofday() in
    last_time := r;
    r
        
let transfer ?(no_sys_call=false) t t' =
  let time = time no_sys_call in
  stop time t;
  start time t'

let start ?(no_sys_call=false) t = start (time no_sys_call) t
let stop  ?(no_sys_call=false) t = stop  (time no_sys_call) t

let read ?(no_sys_call=false) (_s,timed,ongoing) =
  match !ongoing with
  | Some last ->
     let span = time no_sys_call -. last in
     !timed+.span
  | None -> !timed

let reset ?(no_sys_call=false) (_s,timed,ongoing) =
  match !ongoing with
  | Some _last -> timed:=0.; ongoing:=Some(time no_sys_call)
  | None -> timed := 0.

let last_time () = !last_time
