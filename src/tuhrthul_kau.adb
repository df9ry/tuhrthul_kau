
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
      Pos            : Position;
      The_Cell       : Cell_Access;

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
            Pos.I_Row := row;
            Pos.I_Col := col;
            Board.Set_Cell_Button (Board.Get_Cell (Pos), Button);
            if Button /= null then
               Callback_With_Position.Connect
                 (Button, "clicked",
                  Callback_With_Position.To_Marshaller
                    (Cell_Click_Callback'Access),
                  Pos);
            end if;
         end loop;
      end loop;
      Board.Reset;

      --  ======================
      --  Discover neighbourhood
      --  ======================
      for row in Board.Row_Index loop
         for col in Board.Col_Index loop
            The_Cell := Get_Cell (row, col);
            if The_Cell.State /= No_Cell then
               --  North:
               if row > 1 then
                  The_Cell.Neighbours (North).Next :=
                    Get_Cell (row - 1, col);
                  if row > 2 then
                     The_Cell.Neighbours (North).Overnext :=
                       Get_Cell (row - 2, col);
                  end if;
               end if;
               --  North East:
               if row > 1 and then col < 7 then
                  The_Cell.Neighbours (North_East).Next :=
                    Get_Cell (row - 1, col + 1);
                  if row > 2 and then col < 6 then
                     The_Cell.Neighbours (North_East).Overnext :=
                       Get_Cell (row - 2, col + 2);
                  end if;
               end if;
               --  East:
               if col < 7 then
                  The_Cell.Neighbours (East).Next :=
                    Get_Cell (row, col + 1);
                  if col < 6 then
                     The_Cell.Neighbours (East).Overnext :=
                       Get_Cell (row, col + 2);
                  end if;
               end if;
               --  South East:
               if row < 7 and then col < 7 then
                  The_Cell.Neighbours (South_East).Next :=
                    Get_Cell (row + 1, col + 1);
                  if row < 6 and then col < 6 then
                     The_Cell.Neighbours (South_East).Overnext :=
                       Get_Cell (row + 2, col + 2);
                  end if;
               end if;
               --  South:
               if row < 7 then
                  The_Cell.Neighbours (South).Next :=
                    Get_Cell (row + 1, col);
                  if row < 6 then
                     The_Cell.Neighbours (South).Overnext :=
                       Get_Cell (row + 2, col);
                  end if;
               end if;
               --  South West:
               if row < 7 and then col > 1 then
                  The_Cell.Neighbours (South_West).Next :=
                    Get_Cell (row + 1, col - 1);
                  if row < 6 and then col > 2 then
                     The_Cell.Neighbours (South_West).Overnext :=
                       Get_Cell (row + 2, col - 2);
                  end if;
               end if;
               --  West:
               if col > 1 then
                  The_Cell.Neighbours (West).Next :=
                    Get_Cell (row, col - 1);
                  if col > 2 then
                     The_Cell.Neighbours (West).Overnext :=
                       Get_Cell (row, col - 2);
                  end if;
               end if;
               --  North West:
               if row > 1 and then col > 1 then
                  The_Cell.Neighbours (North_West).Next :=
                    Get_Cell (row - 1, col - 1);
                  if row > 2 and then col > 2 then
                     The_Cell.Neighbours (North_West).Overnext :=
                       Get_Cell (row - 2, col - 2);
                  end if;
               end if;
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
