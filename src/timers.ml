(**********)
(* Timers *)
(**********)

type t = string*(float ref)*(float option ref)

let newtimer s = 
  let timed   = ref 0. in
  let ongoing = ref None in
  (s,timed,ongoing)

let name (s,_,_) = s

let is_running (_s,_timed,ongoing) =
  match !ongoing with 
  | Some _ -> true
  | None   -> false

let start (s,_timed,ongoing) =
  match !ongoing with
  | Some _last -> failwith("Trying to start timer "^s^" but it is already started")
  | None       -> ongoing := Some(Sys.time())

let stop (s,timed,ongoing) =
  match !ongoing with
  | Some last -> let span = Sys.time()-.last in
                 timed := !timed+.span;ongoing := None
  | None -> failwith("Trying to stop timer "^s^" but it is already stopped")

let watch (_s,timed,ongoing) =
  match !ongoing with
  | Some last -> let span = Sys.time()-.last in !timed+.span
  | None -> !timed

let reset (_s,timed,ongoing) =
  match !ongoing with
  | Some _last -> timed:=0.;ongoing:=Some(Sys.time())
  | None -> timed:=0.

let transfer t t' = stop t; start t'


(* let fromPlugin() = Timer.transfer ptimer ktimer
 * let toPlugin  () = Timer.transfer ktimer ptimer
 * 
 * let fromTheory() = Timer.transfer ttimer ktimer
 * let toTheory  () = Timer.transfer ktimer ttimer
 * 
 * let init() =
 *   Timer.reset gtimer;Timer.start gtimer;
 *   Timer.reset ltimer;Timer.start ltimer;
 *   Timer.reset ktimer;Timer.start ktimer
 * 
 * (\* Print Kernel's timely report *\)
 * let print_time() =
 *     (Timer.reset ltimer;
 *      print_endline(string_of_int (int_of_float(Timer.watch gtimer))^" seconds");
 *      print_endline(print_state 1))
 * 
 * (\* Print Kernel's final report *\)
 * let report w = 
 *   Timer.stop gtimer;
 *   Timer.stop ltimer;
 *   Timer.stop ktimer;
 *   print_endline("   Kernel's report:");
 *   print_endline(w
 * 		^", in "
 * 		^string_of_float (Timer.watch gtimer)
 * 		^" seconds ("
 * 		^string_of_int(int_of_float(100.*.(Timer.watch ktimer)/.(Timer.watch gtimer)))
 *                 ^"% in kernel, "
 * 		^string_of_int(int_of_float(100.*.(Timer.watch ptimer)/.(Timer.watch gtimer)))
 *                 ^"% in plugin, "
 * 		^string_of_int(int_of_float(100.*.(Timer.watch ttimer)/.(Timer.watch gtimer)))
 *                 ^"% in theory).");
 *   print_endline(print_state 0) *)
