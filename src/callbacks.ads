
--  with Glib.Values;     use Glib.Values;

with Gdk.Event;       use Gdk.Event;

with Gtk.Handlers;
with Gtk.Widget;      use Gtk.Widget;

package Callbacks is

   package Callback_With_Position is new Gtk.Handlers.User_Callback
     (Gtk_Widget_Record, Natural);

   procedure Cell_Click_Callback
     (Button : access Gtk_Widget_Record'Class; Position : Natural);

   function Main_Window_Delete_Handler
     (Self : access Gtk_Widget_Record'Class; Event : Gdk_Event) return Boolean;

end Callbacks;
