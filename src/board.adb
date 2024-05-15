
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
            The_Cell.I_Row  := I_Row;
            The_Cell.I_Col  := I_Col;
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
                  if The_Cell.I_Row = 4 and then The_Cell.I_Col = 4 then
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

   function Get_Cell (I_Row : Row_Index; I_Col : Col_Index)
                      return Cell_Access is
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

end Board;
