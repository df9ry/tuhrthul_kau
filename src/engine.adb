package body Engine is

   procedure Find_Possibilities (Src_Cell : Cell_Access;
                                 Possibilities : in out Possibility_Vector_T)
   is
      P : Possibility;
   begin
      Possibilities.Clear;
      if Src_Cell /= null then
         for N of Src_Cell.Neighbours loop
            if N.Next /= null and then N.Next.State /= Empty_Cell and then
               N.Overnext /= null and then N.Overnext.State = Empty_Cell
            then
               P.Src_Cell := Src_Cell;
               P.Hit_Cell := N.Next;
               P.Tgt_Cell := N.Overnext;
               Possibilities.Append (P);
            end if;
         end loop;
      end if;
   end Find_Possibilities;

   function Move (The_Move : Possibility; Situation : Cell_Mask)
                  return Cell_Mask
   is
      Mask : Cell_Mask := Situation;
   begin
      Mask := (Mask and not (The_Move.Src_Cell.Mask or The_Move.Hit_Cell.Mask))
                    or The_Move.Tgt_Cell.Mask;
      return Mask;
   end Move;

end Engine;
