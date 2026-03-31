with Ada.Text_IO;use Ada.Text_IO;
with Ada_Lib.Help;
with Ada_Lib.Options.Create;
with Ada_Lib.Options.Runstring;
with Ada_Lib.String_Quote; use Ada_Lib.String_Quote;
with Ada_Lib.Trace; use Ada_Lib.Trace;

package body GNOGA_Ada_Lib is

   use type Gnoga.Gui.Base.Pointer_To_Base_Class;

   -- options for the Ada_Lib.GNOGA library
   Debug    : Boolean renames Ada_Lib.Options.Ada_Lib_GNOGA.Debug;
   Trace_Option               : constant Character := 'G';
   Options_With_Parameters    : aliased constant
                                 Ada_Lib.Options.Flag_List_Type :=
                                    Ada_Lib.Options.Create.Create_One (
                                       Trace_Option,
                                       Ada_Lib.Help.Modifier);

   ----------------------------------------------------------------------------
   procedure Display_Help (            -- common for all programs that use GNOGA_Options
                              -- prints full help, aborts program
     Options                     : in     GNOGA_Ada_Lib_Options_Type;  -- only used for dispatch
     Message                     : in     String := "";   -- leave blank no error help
     Halt                        : in     Boolean := True) is
   ----------------------------------------------------------------------------

   begin
not_implemented;
   end Display_Help;

--   ----------------------------------------------------------------
--   function Get_GNOGA_Ada_Lib_Read_Only_Options (
--      From                       : in     String := Ada_Lib.Trace.Here
--   ) return GNOGA_Ada_Lib_Options_Constant_Class_Access is
--   pragma Unreferenced (From);
--   ----------------------------------------------------------------
--
--   begin
--      Log_Here (Trace_Conversions, "from " & From);
--not_implemented;
--return null;
--   end Get_GNOGA_Ada_Lib_Read_Only_Options;
--
   ----------------------------------------------------------------
   function Get_HTTP_Port (
     Options                     : in     GNOGA_Ada_Lib_Options_Type
   ) return Ada_Lib.Socket_IO.Port_Type is
   ----------------------------------------------------------------

   begin
      return Options.HTTP_Port;
   end Get_HTTP_Port;

   ----------------------------------------------------------------
   function Has_Parent (
      Object         : in out Gnoga.Gui.Base.Base_Type'Class
   ) return Boolean is
   ----------------------------------------------------------------

   begin
      return Object.Parent /= Null;
   end Has_Parent;

   ----------------------------------------------------------------------------
   function Image (
     Options                     : in     GNOGA_Ada_Lib_Options_Type
   ) return String is
   ----------------------------------------------------------------------------

   begin
Not_Implemented;
return "";
   end Image;

   ----------------------------------------------------------------------------
   function Initialize (
     Options                     : in out GNOGA_Ada_Lib_Options_Type;
     From                        : in     String := Ada_Lib.Trace.Here
   ) return Boolean is
   ----------------------------------------------------------------------------

   begin
      Log_In (Debug or Trace_Options, Tag_Name ("Options",
         GNOGA_Ada_Lib_Options_Type'class (Options)'tag));

      Ada_Lib.Options.Runstring.Options.Register (
         Ada_Lib.Options.Runstring.With_Parameters,
         Options_With_Parameters, From);

      return Log_Out (Ada_Lib.Options.Verification.
         Verification_Nested_Options_Type (
            Options).Initialize, Debug or Trace_Options);
   end Initialize;

   ----------------------------------------------------------------------------
   function Process_Option (  -- process one option
     Options   : in out GNOGA_Ada_Lib_Options_Type;
     Iterator  : in out Ada_Lib.Options.Command_Line_Iterator_Interface'class;
     Option    : in     Ada_Lib.Options.Base_Flag_Option_Type'class
   ) return Boolean is
   ----------------------------------------------------------------------------

   begin
      Log_In (Trace_Options or Debug, Option.Image &
         Quote (" option", Option.Option));

      if Ada_Lib.Options.Has_Option (Option, Options_With_Parameters,
            Ada_Lib.Options.Null_Flag_List) then
         case Option.Kind is

            when Ada_Lib.Options.Modified =>

               case Option.Option is

                  when Trace_Option =>    -- G
                     Options.Trace_Parse (Iterator);

                  when Others =>
                     Log_Exception (Trace_Options or Debug,
                        " other option" & Option.Image);
                     raise Failed with "Has_Option incorrectly passed " &
                        Option.Image;
               end case;

            when Ada_Lib.Options.Plain =>

               Log_Exception (Trace_Options or Debug, " other option" &
                  Option.Image);
               raise Failed with "Has_Option incorrectly passed " &
                  Option.Image;

            when Ada_Lib.Options.Nil_Option =>
               pragma Assert (False, "unexpected kind");

         end case;

         return Log_Out (True, Trace_Options or Debug, " " & Option.Image);
      else
         return Log_Out (False, Trace_Options or Debug,
            "other option" & " Option " & Option.Image);
      end if;
   end Process_Option;

   ----------------------------------------------------------------------------
   procedure Program_Help (
      Options     : in     GNOGA_Ada_Lib_Options_Type;
      Help_Mode   : in     Ada_Lib.Options.Help_Mode_Type) is
   ----------------------------------------------------------------------------

      Component                  : constant String := "GNOGA_Ada_Lib";

   begin
      Log_In (Debug or Trace_Options, "mode " & Help_Mode'img);

      case Help_Mode is

      when Ada_Lib.Options.Program_Mode =>
         -- options without modifier
         Ada_Lib.Help.Create_Option (Trace_Option, "<TRACE OPTIONS>",
            "trace flags.", Component, Ada_Lib.Help.Modifier);

      when Ada_Lib.Options.Trace_Mode =>
         Put_Line ("GNOGA_Ada_Lib trace options (-" &
            Ada_Lib.Help.Modifier & Trace_Option & ")");
         Put_Line ("      a               all");
--       Put_Line ("      b               Ada_Lib_GNOGA.Base_Debug");
         Put_Line ("      d               Ada_Lib_GNOGA.Debug");

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
   procedure Trace_Parse (
      Iterator    : in out Ada_Lib.Options.
                              Command_Line_Iterator_Interface'class) is
   ---------------------------------------------------------------

      Parameter                  : constant String := Iterator.Get_Parameter;

   begin
      Log_In (Trace_Options or Debug,  Quote ("parameter", Parameter));
      for Trace of Parameter loop

         case Trace is

            when 'a' =>
--             Ada_Lib.Options.Ada_Lib_GNOGA.Base_Debug := True;
               Debug := True;

--          when 'b' =>
--             Ada_Lib.Options.Ada_Lib_GNOGA.Base_Debug := True;

            when 'd' =>
               Ada_Lib.Options.Ada_Lib_GNOGA.Debug := True;

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
--Trace_Options := True;
   Log_Here (Debug);

end GNOGA_Ada_Lib;


