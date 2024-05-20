
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
