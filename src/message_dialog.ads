with Glib;               use Glib;
with Gtk.Dialog;         use Gtk.Dialog;
with Gtk.Message_Dialog; use Gtk.Message_Dialog;

package Message_Dialog is

   function Message (Message_Type : Gtk_Message_Type;
                     Buttons_Type : Gtk_Buttons_Type;
                     Text : UTF8_String) return Gtk_Response_Type;

   procedure Fatal   (Text : UTF8_String);
   procedure Error   (Text : UTF8_String);
   procedure Warning (Text : UTF8_String);
   procedure Info    (Text : UTF8_String);

end Message_Dialog;
