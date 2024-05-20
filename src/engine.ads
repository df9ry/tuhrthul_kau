
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

with Ada.Containers.Vectors; use Ada.Containers;

with Board;                  use Board;

package Engine is

   type Possibility is record
      Src_Cell : Cell_Access;
      Hit_Cell : Cell_Access;
      Tgt_Cell : Cell_Access;
   end record;
   type Possibility_Access is access all Possibility;

   package Possibility_Vector is new Vectors (Natural, Possibility);
   subtype Possibility_Vector_T is Possibility_Vector.Vector;

   Selected_Cell : Cell_Access := null;

   procedure Find_Possibilities (Src_Cell : Cell_Access;
                                 Possibilities : in out Possibility_Vector_T;
                                 Clear : Boolean := True);

   function Move (The_Move : Possibility; Situation : Cell_Mask)
                  return Cell_Mask;

   function Game_Over return Boolean;

end Engine;
