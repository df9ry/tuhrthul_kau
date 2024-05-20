
--  Tuhrthur Kau Game
--  Copyright (C) 2024  Reiner Tania Hagn
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
