with Ada.Text_IO;use Ada.Text_IO;
with Ada_Lib.Help;
--with Ada_Lib.Options.Create;
with Ada_Lib.String_Quote; use Ada_Lib.String_Quote;
with Ada_Lib.Trace; use Ada_Lib.Trace;

package body GNOGA_Ada_Lib is

   use type Gnoga.Gui.Base.Pointer_To_Base_Class;

   -- options for the Ada_Lib.GNOGA library
   Debug    : Boolean renames Ada_Lib.Options.Ada_Lib_GNOGA.Debug;
   Trace_Option               : constant Character := 'u';
-- Options_With_Parameters    : aliased constant
--                               Ada_Lib.Options.Flag_List_Type :=
--                                  Ada_Lib.Options.Create.Create_One (
--                                     Trace_Option,
--                                     Ada_Lib.Options.Unmodified_flag);

   ----------------------------------------------------------------
   function Has_Parent (
      Object         : in out Gnoga.Gui.Base.Base_Type'Class
   ) return Boolean is
   ----------------------------------------------------------------

   begin
      return Object.Parent /= Null;
   end Has_Parent;

   ----------------------------------------------------------------------------
   procedure Program_Help (
      Help_Mode                  : in      Ada_Lib.Options.Help_Mode_Type) is
   ----------------------------------------------------------------------------

      Component                  : constant String := "Ada_Lib.GNOGA";

   begin
      Log_In (Debug or Trace_Options, "mode " & Help_Mode'img);

      case Help_Mode is

      when Ada_Lib.Options.Program_Mode =>
         -- options without modifier
         Ada_Lib.Help.Create_Option (Trace_Option, "<TRACE OPTIONS>",
            "trace flags.", Component, Ada_Lib.Help.Unmodified_Flag);

      when Ada_Lib.Options.Trace_Mode =>
         Put_Line ("Ada_Lib GNOGA library trace options (-" &
            Trace_Option & ")");
         Put_Line ("      a               all");
         Put_Line ("      d               Ada_Lib.GNOGA.Debug");

      end case;

      Log_Out (Debug or Trace_Options);
   end Program_Help;

   ----------------------------------------------------------------
   procedure Report_Exception (
      Window                     : in out Gnoga.Gui.Window.Window_Type'class;
      Fault                      : in     Ada.Exceptions.Exception_Occurrence;
      Message                    : in     String;
      Where                      : in     String := GNAT.Source_Info.Source_Location) is
   ----------------------------------------------------------------

      Error_Message              : constant String :=
                                    Ada.Exceptions.Exception_Message (Fault) &
                                    ". " & Message & (if Debug then
                                          " raised at " & Where
                                       else
                                          "");
   begin
      Window.Alert (Error_Message);
   end Report_Exception;

   ---------------------------------------------------------------
   procedure Set_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Standard.Gnoga.Gui.Window.
                                          Pointer_To_Window_Class) is
   ---------------------------------------------------------------

   begin
      Log_Here (Debug);
      Connection_Data.Main_Window := Main_Window;
   end Set_Main_Window;

   ---------------------------------------------------------------
   procedure Trace_Parse (
      Iterator    : in out Ada_Lib.Options.
                              Command_Line_Iterator_Interface'class) is
   ---------------------------------------------------------------

      Parameter                  : constant String := Iterator.Get_Parameter;

   begin
      Log_In (Trace_Options or Debug,  Quote ("parameter", Parameter));
      for Trace of Parameter loop
         Log_Here (Trace_Options or Debug, Quote ("trace", Trace));

         case Trace is

            when 'a' =>
               Debug := True;

            when 'd' =>
               Debug := True;

            when others =>
               declare
                  Message        : constant String :=
                                    Quote ("unexpected trace option", Trace) &
                                    " for 'U'";

               begin
                  Log_Exception (Trace_Options or Debug, Message);
                  raise Failed with Message;
               end;

         end case;
      end loop;
      Log_Out (Debug or Trace_Options);

   end Trace_Parse;
   ---------------------------------------------------------------
begin
--debug := True;
   Log_Here (Debug);

end GNOGA_Ada_Lib;


