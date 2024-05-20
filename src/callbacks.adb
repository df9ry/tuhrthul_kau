
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

with Gdk.Display;

with Gtk.Main;

with Engine;         use Engine;
with Message_Dialog; use Message_Dialog;

package body Callbacks is

   procedure Cell_Click_Callback
     (Button : access Gtk_Widget_Record'Class; Pos : Board.Position) is
      The_Cell        : constant Board.Cell_Access := Board.Get_Cell (Pos);
      The_Possibility : Possibility;

      function Find_Possibility (Target : out Possibility) return Boolean is
         Possibilities : Possibility_Vector_T;
      begin
         Find_Possibilities (Selected_Cell, Possibilities);
         for P of Possibilities loop
            if P.Tgt_Cell.Mask = The_Cell.Mask then
               Target := P;
               return True;
            end if;
         end loop;
         return False;
      end Find_Possibility;

   begin
      if Game_Over then
         Board.Reset;
         Selected_Cell := null;
         return;
      end if;
      if Button /= null then
         if Selected_Cell /= null then
            --  There is a cell selected:
            if The_Cell.State = Board.Empty_Cell then
               --  Check if this is a target:
               if Find_Possibility (The_Possibility) then
                  Board.Set_Mask (Move (The_Possibility, Board.Get_Mask));
                  Selected_Cell := null;
               else
               --  Unable to move to there:
                  Gdk.Display.Beep (Gdk.Display.Get_Default);
               end if;
            else
               if Selected_Cell.Mask = The_Cell.Mask then
                  --  Click on the same cell:
                  Selected_Cell := null;
                  The_Cell.State := Full_Cell;
               else
                  --  Change selection:
                  Selected_Cell.State := Board.Full_Cell;
                  The_Cell.State := Board.Highlighted_Cell;
                  Selected_Cell := The_Cell;
               end if;
            end if;
         else
            --  No cell selected:
            if The_Cell.State /= Empty_Cell then
               The_Cell.State := Board.Highlighted_Cell;
               Selected_Cell := The_Cell;
            else
               --  Unable to select empty cell:
               Gdk.Display.Beep (Gdk.Display.Get_Default);
            end if;
         end if;
      end if;
      Board.Update;
      if Game_Over then
         Info ("Game over!");
      end if;
   end Cell_Click_Callback;

   function Main_Window_Delete_Handler
     (Self : access Gtk_Widget_Record'Class; Event : Gdk_Event) return Boolean
   is
      pragma Unreferenced (Self, Event);
   begin
      Gtk.Main.Main_Quit;
      return True;
   end Main_Window_Delete_Handler;

end Callbacks;
