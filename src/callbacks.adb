
with Gtk.Main;

package body Callbacks is

   function Main_Window_Delete_Handler
     (Self : access Gtk_Widget_Record'Class; Event : Gdk_Event) return Boolean
   is
      pragma Unreferenced (Self, Event);
   begin
      Gtk.Main.Main_Quit;
      return True;
   end Main_Window_Delete_Handler;

end Callbacks;
