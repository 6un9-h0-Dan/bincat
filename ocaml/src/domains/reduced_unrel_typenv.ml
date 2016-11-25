(** reduced product Unrel x TypEnv *)
(** signature is of type Domain.T *)

module Make(D: Unrel.T) =
(struct
  module U = Unrel.Make(D)
  module T = Typenv

  type t = U.t * T.t

  let init () = U.init (), T.init ()

  let bot = U.BOT, T.BOT

  let forget (uenv, tenv) = U.forget uenv, T.forget tenv

  let is_bot (uenv, _tenv) = U.is_bot uenv

  let subset (uenv1, tenv1) (uenv2, tenv2) = U.subset uenv1 uenv2 && T.subset tenv1 tenv2

  let remove_register r (uenv, tenv) = U.remove_register r uenv, T.remove_register r tenv

  let forget_lval lv (uenv, tenv) =
    let tenv' =
      match lv with
      | Asm.V (Asm.T r)  | Asm.V (Asm.P (r, _, _)) -> T.remove_register r tenv
      | _ -> let addrs, _ = U.mem_to_addresses uenv (Asm.Lval lv) in
	     T.remove_addresses addrs tenv 
    in
    U.forget_lval lv uenv, tenv'

  let add_register r (uenv, tenv) = U.add_register r uenv, T.add_register r tenv

  let to_string (uenv, _tenv) = U.to_string uenv

  let value_of_register (uenv, _tenv) r = U.value_of_register uenv r

  let value_of_exp (uenv, _tenv) e = U.value_of_exp uenv e

  let set lv e (uenv, tenv) =
    let uenv', b = U.set lv e uenv in
    (uenv', T.forget tenv), b

  let join (uenv1, tenv1) (uenv2, tenv2) = U.join uenv1 uenv2, T.join tenv1 tenv2

  let meet (uenv1, tenv1) (uenv2, tenv2) = U.meet uenv1 uenv2, T.meet tenv1 tenv2

  let widen (uenv1, tenv1) (uenv2, tenv2) = U.widen uenv1 uenv2, T.widen tenv1 tenv2

  let set_memory_from_config a r c n (uenv, tenv) =
    U.set_memory_from_config a r c n uenv, tenv

  let set_register_from_config register region c  (uenv, tenv) =
    U.set_register_from_config register region c uenv, tenv

  let taint_register_mask r c (uenv, tenv) = U.taint_register_mask r c uenv, tenv

  let compare (uenv, tenv) e1 cmp e2 =
    let uenv', b = U.compare uenv e1 cmp e2 in
    (uenv', tenv), b

  let mem_to_addresses (uenv, _tenv) e = U.mem_to_addresses uenv e

    let is_tainted e (uenv, _tenv) = U.is_tainted e uenv
       
  let set_type _lv _typ (uenv, tenv) = uenv, T.forget tenv
   
 end:
   Domain.T)