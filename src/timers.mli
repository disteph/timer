(** Type for timers *)
type t

(** Exception raised when starting a started timer or stopping a stopped timer *)
exception TimerException of string

(** Create new timer *)
val create     : string->t

(** Start timer *)
val start      : t->unit

(** Stop timer *)
val stop       : t->unit

(** Reset timer *)
val reset      : t->unit

(** Read timer *)
val read       : t->float

(** Get timer name *)
val name       : t->string

(** Like stopping one timer and starting another,
    but making sure that the timestamp for both actions is the same *)
val transfer   : t->t->unit

(** Whether a timer is running *)
val is_running : t->bool
