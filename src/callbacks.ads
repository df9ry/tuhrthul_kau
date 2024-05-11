
with Gtk.Widget;  use Gtk.Widget;
with Gdk.Event;   use Gdk.Event;

package Callbacks is

   function Main_Window_Delete_Handler
     (Self : access Gtk_Widget_Record'Class; Event : Gdk_Event) return Boolean;

end Callbacks;
