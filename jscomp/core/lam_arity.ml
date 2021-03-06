(* Copyright (C) Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


type t = 
  | Determin of bool * (int * Ident.t list option) list  * bool
    (**
      when the first argument is true, it is for sure 
      the last one means it can take any params later, 
      for an exception: it is (Determin (true,[], true))
      1. approximation sound but not complete 
      
   *)
  | NA 

let pp = Format.fprintf

let print (fmt : Format.formatter) (x : t) = 
  match x with 
  | NA -> pp fmt "?"
  | Determin (b,ls,tail) -> 
    begin 
      pp fmt "@[";
      (if not b 
       then 
         pp fmt "~");
      pp fmt "[";
      Format.pp_print_list ~pp_sep:(fun fmt () -> pp fmt ",")
        (fun fmt  (x,_) -> Format.pp_print_int fmt x)
        fmt ls ;
      if tail 
      then pp fmt "@ *";
      pp fmt "]@]";
    end
  
  let print_arities_tbl 
    (fmt : Format.formatter) 
    (arities_tbl : (Ident.t, t ref) Hashtbl.t) = 
  Hashtbl.fold (fun (i:Ident.t) (v : t ref) _ -> 
      pp Format.err_formatter "@[%s -> %a@]@."i.name print !v ) arities_tbl ()
