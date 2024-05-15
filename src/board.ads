
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

   type Cell is record
      Pos    : Position;
      Mask   : Cell_Mask;
      State  : Cell_State;
      Button : Gtk_Button;
   end record;

   type Cell_Access is access Cell;

   type Row   is array (Col_Index) of Cell_Access;
   type Row_Access is access Row;
   type Board is array (Row_Index) of Row_Access;
   type Board_Access is access Board;

   procedure Init;

   function Get_Cell (Pos : Position) return Cell_Access;

   procedure Set_Cell_Button (The_Cell : Cell_Access; Button : Gtk_Button);

   procedure Update_Cell (The_Cell : Cell_Access);

   procedure Reset;

   function Get_Mask return Cell_Mask;

   procedure Set_Mask (Mask : Cell_Mask);

end Board;
