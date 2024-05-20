
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

with Ada.Task_Identification;  use Ada.Task_Identification;

package body Message_Dialog is

   function Message (Message_Type : Gtk_Message_Type;
                     Buttons_Type : Gtk_Buttons_Type;
                     Text : UTF8_String) return Gtk_Response_Type is
      Dialog : Gtk_Message_Dialog;
      Result : Gtk_Response_Type;
   begin
      Dialog := Gtk_Message_Dialog_New (null, Modal,
                                        Message_Type, Buttons_Type, Text);
      Result := Run (Dialog);
      Destroy (Dialog);
      return Result;
   end Message;

   procedure Fatal   (Text : UTF8_String) is
      Result : Gtk_Response_Type;
      pragma Unreferenced (Result);
   begin
      Result := Message (Message_Error, Buttons_Ok, "Fatal error: " & Text);
      Abort_Task (Current_Task);
   end Fatal;

   procedure Error   (Text : UTF8_String) is
      Result : Gtk_Response_Type;
      pragma Unreferenced (Result);
   begin
      Result := Message (Message_Error, Buttons_Ok_Cancel, "Error: " & Text);
   end Error;

   procedure Warning (Text : UTF8_String) is
      Result : Gtk_Response_Type;
      pragma Unreferenced (Result);
   begin
      Result := Message (Message_Error, Buttons_Ok, "Warning: " & Text);
   end Warning;

   procedure Info    (Text : UTF8_String) is
      Result : Gtk_Response_Type;
      pragma Unreferenced (Result);
   begin
      Result := Message (Message_Error, Buttons_Ok, "Info: " & Text);
   end Info;

end Message_Dialog;
