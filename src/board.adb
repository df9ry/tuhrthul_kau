
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

with Gtk.Style_Context;

package body Board is

   The_Board : Board;

   procedure Init is
      The_Row : Row_Access;
      The_Cell : Cell_Access;
   begin
      for I_Row in Row_Index'Range loop
         The_Row := new Row;
         The_Board (I_Row) := The_Row;
         for I_Col in Col_Index'Range loop
            The_Cell := new Cell;
            The_Row (I_Col) := The_Cell;
            The_Cell.Pos.I_Row  := I_Row;
            The_Cell.Pos.I_Col  := I_Col;
            The_Cell.Mask :=
              Cell_Mask (2 ** (Natural (I_Row) * 8 + Natural (I_Col)));
         end loop;
      end loop;
   end Init;

   procedure Set_Cell_Button (The_Cell : Cell_Access; Button : Gtk_Button) is
      Style_Context : Gtk.Style_Context.Gtk_Style_Context;
   begin
      begin
         The_Cell.Button := Button;
         if Button /= null then
            Style_Context := Gtk.Style_Context.Get_Style_Context
              (Widget => The_Cell.Button);
            Gtk.Style_Context.Add_Class
              (Self => Style_Context, Class_Name => "cell");
         end if;
      end;
   end Set_Cell_Button;

   procedure Reset is
   begin
      for I_Row in Row_Index'Range loop
         for I_Col in Col_Index'Range loop
            declare The_Cell : Cell_Access renames The_Board (I_Row) (I_Col);
            begin
               if The_Cell.Button /= null then
                  if The_Cell.Pos.I_Row = 4 and then The_Cell.Pos.I_Col = 4
                  then
                     The_Cell.State := Empty_Cell;
                  else
                     The_Cell.State := Full_Cell;
                  end if;
                  Update_Cell (The_Cell);
               else
                  The_Cell.State := No_Cell;
               end if;
            end;
         end loop;
      end loop;
   end Reset;

   procedure Update is
   begin
      for I_Row in Row_Index'Range loop
         for I_Col in Col_Index'Range loop
            Update_Cell (The_Board (I_Row) (I_Col));
         end loop;
      end loop;
   end Update;

   function Get_Cell (Pos : Position) return Cell_Access is
   begin
      return The_Board (Pos.I_Row) (Pos.I_Col);
   end Get_Cell;

   function Get_Cell (I_Row : Row_Index; I_Col : Col_Index) return Cell_Access
   is
   begin
      return The_Board (I_Row) (I_Col);
   end Get_Cell;

   procedure Update_Cell (The_Cell : Cell_Access) is
      Style_Context : Gtk.Style_Context.Gtk_Style_Context;
   begin
      if The_Cell.Button /= null then
         Style_Context := Gtk.Style_Context.Get_Style_Context
           (Widget => The_Cell.Button);
         case The_Cell.State is
            when No_Cell =>
               null;
            when Empty_Cell =>
               Gtk.Style_Context.Remove_Class
                 (Self => Style_Context, Class_Name => "cell_full");
               Gtk.Style_Context.Remove_Class
                 (Self => Style_Context, Class_Name => "cell_highlighted");
               Gtk.Style_Context.Add_Class
                 (Self => Style_Context, Class_Name => "cell_empty");
            when Full_Cell =>
               Gtk.Style_Context.Remove_Class
                 (Self => Style_Context, Class_Name => "cell_empty");
               Gtk.Style_Context.Remove_Class
                 (Self => Style_Context, Class_Name => "cell_highlighted");
               Gtk.Style_Context.Add_Class
                 (Self => Style_Context, Class_Name => "cell_full");
            when Highlighted_Cell =>
               Gtk.Style_Context.Remove_Class
                 (Self => Style_Context, Class_Name => "cell_full");
               Gtk.Style_Context.Remove_Class
                 (Self => Style_Context, Class_Name => "cell_empty");
               Gtk.Style_Context.Add_Class
                 (Self => Style_Context, Class_Name => "cell_highlighted");
         end case;
      end if;
   end Update_Cell;

   function Get_Mask return Cell_Mask is
      Mask : Cell_Mask := 0;
   begin
      for I_Row in Row_Index'Range loop
         for I_Col in Col_Index'Range loop
            declare The_Cell : Cell_Access renames The_Board (I_Row) (I_Col);
            begin
               if The_Cell.State /= No_Cell and then
                  The_Cell.State /= Empty_Cell
               then
                  Mask := Mask or The_Cell.Mask;
               end if;
            end;
         end loop;
      end loop;
      return Mask;
   end Get_Mask;

   procedure Set_Mask (Mask : Cell_Mask) is
   begin
      for I_Row in Row_Index'Range loop
         for I_Col in Col_Index'Range loop
            declare The_Cell : Cell_Access renames The_Board (I_Row) (I_Col);
            begin
               if (Mask and The_Cell.Mask) /= 0 then
                  The_Cell.State := Full_Cell;
               else
                  The_Cell.State := Empty_Cell;
               end if;
               Update_Cell (The_Cell);
            end;
         end loop;
      end loop;
   end Set_Mask;

end Board;
