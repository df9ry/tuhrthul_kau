with Glib;        use Glib;
with Glib.Error;  use Glib.Error;
with Glib.Object; use Glib.Object;

with Gtk.Builder; use Gtk.Builder;
with Gtk.Button;  use Gtk.Button;
with Gtk.Grid;    use Gtk.Grid;
with Gtk.Main;
with Gtk.Window;  use Gtk.Window;

with Message_Dialog;
with Callbacks;

procedure Tuhrthul_Kau is

   procedure Create_Window is
      Builder     : constant Gtk_Builder := Gtk_Builder_New;
      Error       : aliased GError;
      Main_Window : Gtk_Window;
      Grid        : Gtk_Grid;
      Button      : Gtk_Button;

   begin
      if Add_From_File (Builder  => Builder,
                        Filename => "tuhrthul_kau.glade",
                        Error    => Error'Access) = 0
      then
         Message_Dialog.Fatal (Get_Message (Error));
      end if;

      Main_Window := Gtk_Window (Get_Object (Builder, "main_window"));
      if Main_Window = null
      then
         Message_Dialog.Fatal ("Unable to fetch main window");
      end if;
      Set_Title (Main_Window, "Thurthul Kau");
      On_Delete_Event (Self => Main_Window,
                       Call => Callbacks.Main_Window_Delete_Handler'Access);

      Grid := Gtk_Grid (Get_Object (Builder, "center_grid"));
      if Grid = null
      then
         Message_Dialog.Fatal ("Unable to fetch center grid");
      end if;

      for row in 1 .. 6 loop
         for col in 1 .. 6 loop
            Button := Gtk_Button (Get_Child_At (Grid, Gint (row), Gint (col)));
            if Button /= null then
               null;
            end if;
         end loop;
      end loop;

      Show_All (Main_Window);
   end Create_Window;

begin --  Tuhrthul_Kau
   --  Initializes GtkAda
   Gtk.Main.Init;

   --  Create the main window
   Create_Window;

   --  Signal handling loop
   Gtk.Main.Main;
end Tuhrthul_Kau;
