
--  Tuhrthur Kau Game
--  Copyright (C) 2024  Reiner Tania Hagn
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.

with Ada.Text_IO;        use Ada.Text_IO;
with Ada.Assertions;     use Ada.Assertions;
with Gtkada.Intl;        use Gtkada.Intl;

with Glib;               use Glib;
with Glib.Error;         use Glib.Error;
with Glib.Object;        use Glib.Object;

with Gdk.Screen;

with Gtk.Builder;        use Gtk.Builder;
with Gtk.Button;         use Gtk.Button;
with Gtk.Css_Provider;   use Gtk.Css_Provider;
with Gtk.Event_Box;      use Gtk.Event_Box;
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
   Exit_Button     : Gtk_Event_Box;
   Play_Button     : Gtk_Event_Box;
   Undo_Button     : Gtk_Event_Box;
   Redo_Button     : Gtk_Event_Box;
   Hint_Button     : Gtk_Event_Box;
   Help_Button     : Gtk_Event_Box;
   About_Button    : Gtk_Event_Box;
   Settings_Button : Gtk_Event_Box;

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
      Assert (Main_Window /= null);
      Set_Title (Main_Window, "Thurthul Kau");
      Assert (Set_Default_Icon_From_File ("share/icons/tuhrthul_kau.ico"));
      On_Delete_Event (Self => Main_Window,
                       Call => Callbacks.Main_Window_Delete_Handler'Access);

      Grid := Gtk_Grid (Get_Object (Builder, "center_grid"));
      Assert (Grid /= null, -"Unable to fetch center grid");

      Exit_Button := Gtk_Event_Box (Get_Object (Builder, "btn_exit"));
      Assert (Exit_Button /= null, -"Unable to fetch exit button");
      On_Button_Press_Event (Self => Exit_Button,
                             Call => Callbacks.Exit_Handler'Access);

      Play_Button := Gtk_Event_Box (Get_Object (Builder, "btn_play"));
      Assert (Play_Button /= null, -"Unable to fetch play button");
      On_Button_Press_Event (Self => Play_Button,
                             Call => Callbacks.Play_Handler'Access);

      Undo_Button := Gtk_Event_Box (Get_Object (Builder, "btn_undo"));
      Assert (Undo_Button /= null, -"Unable to fetch undo button");
      On_Button_Press_Event (Self => Undo_Button,
                             Call => Callbacks.Undo_Handler'Access);

      Redo_Button := Gtk_Event_Box (Get_Object (Builder, "btn_redo"));
      Assert (Redo_Button /= null, -"Unable to fetch redo button");
      On_Button_Press_Event (Self => Redo_Button,
                             Call => Callbacks.Redo_Handler'Access);

      Hint_Button := Gtk_Event_Box (Get_Object (Builder, "btn_hint"));
      Assert (Hint_Button /= null, -"Unable to fetch hint button");
      On_Button_Press_Event (Self => Hint_Button,
                             Call => Callbacks.Hint_Handler'Access);

      Help_Button := Gtk_Event_Box (Get_Object (Builder, "btn_help"));
      Assert (Help_Button /= null, -"Unable to fetch help button");
      On_Button_Press_Event (Self => Help_Button,
                             Call => Callbacks.Help_Handler'Access);

      About_Button := Gtk_Event_Box (Get_Object (Builder, "btn_about"));
      Assert (About_Button /= null, -"Unable to fetch about button");
      On_Button_Press_Event (Self => About_Button,
                             Call => Callbacks.About_Handler'Access);

      Settings_Button := Gtk_Event_Box (Get_Object (Builder, "btn_settings"));
      Assert (Settings_Button /= null, -"Unable to fetch settings button");
      On_Button_Press_Event (Self => Settings_Button,
                             Call => Callbacks.Settings_Handler'Access);

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
            if (row > 2 and then row < 6) or else (col > 2 and then col < 6)
            then
               Button := Gtk_Button (Get_Child_At
                                     (Grid, Gint (row), Gint (col)));
            else
               Button := null;
            end if;
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
   Put_Line ("Running with locale: " & Gtkada.Intl.Getlocale);

   --  Create the main window
   Create_Window;

   --  Signal handling loop
   Gtk.Main.Main;
end Tuhrthul_Kau;
