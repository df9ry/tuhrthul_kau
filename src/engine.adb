package body Engine is

   procedure Find_Possibilities (Src_Cell : Cell_Access;
                                 Possibilities : in out Possibility_Vector_T;
                                 Clear : Boolean := True)
   is
      P : Possibility;
   begin
      if Clear then
         Possibilities.Clear;
      end if;
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

   function Game_Over return Boolean is
      Possibilities : Possibility_Vector_T;
      The_Cell      : Cell_Access;
   begin
      Possibilities.Clear;
      for I_Row in Row_Index loop
         for I_Col in Col_Index loop
            The_Cell := Get_Cell (I_Row, I_Col);
            if The_Cell.State = Full_Cell or else
              The_Cell.State = Highlighted_Cell
            then
               Find_Possibilities (The_Cell, Possibilities, Clear => False);
            end if;
         end loop;
      end loop;
      return Possibilities.Length = 0;
   end Game_Over;

end Engine;
