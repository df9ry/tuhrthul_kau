
with Gtk.Main;

package body Callbacks is

   procedure Cell_Click_Callback
     (Button : access Gtk_Widget_Record'Class; Pos : Board.Position) is
      The_Cell : constant Board.Cell_Access :=
        Board.Get_Cell (Pos);
   begin
      if Button /= null then
         case The_Cell.State is
         when Board.Empty_Cell =>
            The_Cell.State := Board.Full_Cell;
         when Board.Full_Cell =>
            The_Cell.State := Board.Highlighted_Cell;
         when Board.Highlighted_Cell =>
            The_Cell.State := Board.Empty_Cell;
         when others =>
            null;
         end case;
         Board.Update_Cell (The_Cell);
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
