(** Type for timers *)
type t

(** Exception raised when starting a started timer or stopping a stopped timer *)
exception TimerException of string

(** Create new timer *)
val create     : string->t

(** Get timer name *)
val name       : t->string

(** Whether a timer is running *)
val is_running : t->bool

(** Gives the last result of a system call to Sys.time(),
    as typically happens during a start, stop, transfer, read and reset. *)
val last_time  : unit -> float


(** The next functions typically make a system call to get the system time.
    This can be costly if many calls are made, so giving those functions
    the optional argument ~no_sys_call:true skips the system call and uses
    its last output, as given by last_time(). Of course, that value is outdated,
    i.e. further in the past than a new call to Sys.time() would give. *)
  
(** Start timer *)
val start      : ?no_sys_call:bool -> t -> unit

(** Stop timer *)
val stop       : ?no_sys_call:bool -> t -> unit

(** Reset timer *)
val reset      : ?no_sys_call:bool -> t -> unit

(** Read timer *)
val read       : ?no_sys_call:bool -> t -> float

(** Like stopping one timer and starting another,
    but making sure that the timestamp for both actions is the same *)
val transfer   : ?no_sys_call:bool -> t -> t -> unit

