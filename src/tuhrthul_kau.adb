--  predefined units of the library
with Gtk.Main;
with Gtk.Enums;
with Gtk.Window;

--  My units
--  with Callbacks;

procedure Tuhrthul_Kau is

   procedure Create_Window is
      Main_Window : Gtk.Window.Gtk_Window;
   begin
      Gtk.Window.Gtk_New
        (Window   => Main_Window,
         The_Type => Gtk.Enums.Window_Toplevel);

      --  From Gtk.Widget:
      Gtk.Window.Set_Title (Window => Main_Window, Title  => "Tuhrthul Kau");

      --  Construct the window and connect various callbacks

      --  ...
      Gtk.Window.Show_All (Main_Window);
   end Create_Window;

begin --  Tuhrthul_Kau
   --  Initializes GtkAda
   Gtk.Main.Init;

   --  Create the main window
   Create_Window;

   --  Signal handling loop
   Gtk.Main.Main;
end Tuhrthul_Kau;
