with Gtk.Main;

with Glib;        use Glib;
with Glib.Error;  use Glib.Error;
with Gtk.Builder; use Gtk.Builder;

with Message_Dialog;

--  with Callbacks;

procedure Tuhrthul_Kau is

   procedure Create_Window is
      --  Main_Window : Gtk.Window.Gtk_Window;
      Builder : constant Gtk_Builder := Gtk_Builder_New;
      Error : aliased GError;
   begin
      --  From Gtk.Widget:
      --  Gtk.Window.Set_Title
      --  (Window => Main_Window, Title  => "Tuhrthul Kau");

      --  Construct the window and connect various callbacks

      --  ...
      --  Gtk.Window.Show_All (Main_Window);

      if Add_From_File (Builder  => Builder,
                        Filename => "tuhrthul_kau.glade",
                        Error    => Error'Access) = 0
      then
         Message_Dialog.Fatal (Get_Message (Error));
      end if;

   end Create_Window;

begin --  Tuhrthul_Kau
   --  Initializes GtkAda
   Gtk.Main.Init;

   --  Create the main window
   Create_Window;

   --  Signal handling loop
   Gtk.Main.Main;
end Tuhrthul_Kau;
