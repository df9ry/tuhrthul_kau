
with Glib;               use Glib;
with Glib.Error;         use Glib.Error;
with Glib.Object;        use Glib.Object;

with Gdk.Screen;

with Gtk.Builder;        use Gtk.Builder;
with Gtk.Button;         use Gtk.Button;
with Gtk.Css_Provider;   use Gtk.Css_Provider;
with Gtk.Grid;           use Gtk.Grid;
with Gtk.Main;
with Gtk.Style_Context;
with Gtk.Style_Provider; use Gtk.Style_Provider;
with Gtk.Widget;         use Gtk.Widget;
with Gtk.Window;         use Gtk.Window;

with Board;              use Board;
with Callbacks;          use Callbacks;
with Message_Dialog;

procedure Tuhrthul_Kau is

   procedure Create_Window is
      Builder        : constant Gtk_Builder := Gtk_Builder_New;
      Css_Provider   : constant Gtk_Css_Provider := Gtk_Css_Provider_New;
      Error          : aliased GError;
      Main_Window    : Gtk_Window;
      Grid           : Gtk_Grid;
      Button         : Gtk_Button;

   begin
      if Add_From_File (Builder  => Builder,
                        Filename => "etc/tuhrthul_kau.glade",
                        Error    => Error'Access) = 0
      then
         Message_Dialog.Fatal (Get_Message (Error));
      end if;

      --  ===========
      --  Main Window
      --  ===========
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

      --  =========
      --  CSS Style
      --  =========
      if not Load_From_Path (Self  => Css_Provider,
                             Path  => "etc/tuhrthul_kau.css",
                             Error => Error'Access)
      then
         Message_Dialog.Fatal (Get_Message (Error));
      end if;

      Gtk.Style_Context.Add_Provider_For_Screen
        (Screen   => Gdk.Screen.Get_Default,
         Provider => +Css_Provider,
         Priority => Gtk.Style_Provider.Priority_User);

      --  =============
      --  Connect board
      --  =============
      Board.Init;

      for row in Board.Row_Index loop
         for col in Board.Col_Index loop
            Button := Gtk_Button (Get_Child_At (Grid, Gint (row), Gint (col)));
            Board.Set_Cell_Button (Board.Get_Cell (row, col), Button);
            if Button /= null then
               Callback_With_Position.Connect
                 (Button, "clicked",
                  Callback_With_Position.To_Marshaller
                    (Cell_Click_Callback'Access),
                  Natural (8 * row) + Natural (col));
            end if;
         end loop;
      end loop;

      Board.Reset;

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
