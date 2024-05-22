
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

with Gdk.Event;        use Gdk.Event;

with Gtk.Handlers;
with Gtk.Widget;       use Gtk.Widget;

with Board;            use Board;

package Callbacks is

   package Callback_With_Position is new Gtk.Handlers.User_Callback
     (Gtk_Widget_Record, Board.Position);

   procedure Cell_Click_Callback
     (Button : access Gtk_Widget_Record'Class; Pos : Board.Position);

   function Exit_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Play_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Undo_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Redo_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Hint_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Help_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function About_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Settings_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event_Button) return Boolean;

   function Main_Window_Delete_Handler
     (Self  : access Gtk_Widget_Record'Class;
      Event : Gdk_Event) return Boolean;

end Callbacks;
