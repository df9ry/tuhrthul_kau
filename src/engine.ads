
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
                                 Possibilities : in out Possibility_Vector_T);

   function Move (The_Move : Possibility; Situation : Cell_Mask)
     return Cell_Mask;

end Engine;
