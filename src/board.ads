
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

with Gtk;
with Gtk.Button; use Gtk.Button;

package Board is

   type Orientation is (North, North_East, East, South_East,
                        South, South_West, West, North_West);

   type Row_Index is new Natural range 1 .. 7;
   type Col_Index is new Natural range 1 .. 7;

   type Position is record
      I_Row : Row_Index;
      I_Col : Col_Index;
   end record;

   type Cell_State is (No_Cell, Empty_Cell, Full_Cell, Highlighted_Cell);

   type Cell_Mask is mod 2**64;

   type Cell;

   type Cell_Access is access Cell;

   type Neighbour is record
      Next     : Cell_Access := null;
      Overnext : Cell_Access := null;
   end record;

   type Neighbourhood is array (Orientation) of Neighbour;

   type Cell is record
      Pos        : Position;
      Mask       : Cell_Mask;
      State      : Cell_State;
      Button     : Gtk_Button;
      Neighbours : Neighbourhood;
   end record;

   type Row   is array (Col_Index) of Cell_Access;
   type Row_Access is access Row;
   type Board is array (Row_Index) of Row_Access;
   type Board_Access is access Board;

   procedure Init;

   function Get_Cell (Pos : Position) return Cell_Access;
   function Get_Cell (I_Row : Row_Index; I_Col : Col_Index) return Cell_Access;

   procedure Set_Cell_Button (The_Cell : Cell_Access; Button : Gtk_Button);

   procedure Update_Cell (The_Cell : Cell_Access);

   procedure Update;

   procedure Reset;

   function Get_Mask return Cell_Mask;

   procedure Set_Mask (Mask : Cell_Mask);

end Board;
