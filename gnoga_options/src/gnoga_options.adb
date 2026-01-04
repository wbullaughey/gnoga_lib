with Ada.Text_IO; use Ada.Text_IO;
with Ada_Lib.Help;
with Ada_Lib.String_Quote; use Ada_Lib.String_Quote;
with Ada_Lib.Trace; use Ada_Lib.Trace;
with Ada_Lib.Options.Create;
with Ada_Lib.Options.Runstring;

-- options for the GNOGA Library
package body GNOGA_Options is

   Debug          : Boolean renames Ada_Lib.Options.GNOGA.Options_Debug;
   Trace_Option   : constant Character := 'G';
   Options_With_Parameters
                  : aliased constant
                     Ada_Lib.Options.Flag_List_Type :=
                        Ada_Lib.Options.Create.Create_One (
                           Trace_Option,
                           Ada_Lib.Options.Unmodified_flag);

   ----------------------------------------------------------------------------
   overriding
   function Initialize (
     Options                     : in out GNOGA_Options_Type;
     From                        : in     String := Ada_Lib.Trace.Here
   ) return Boolean is
   ----------------------------------------------------------------------------

   begin
      Log_In (Debug or Trace_Options);
      GNOGA_Options := Options'unchecked_access;
--    Ada_Lib.Options.Runstring.Options.Register (
--       Ada_Lib.Options.Runstring.With_Parameters,
--       Options_With_Parameters);
      Ada_Lib.Options.Runstring.Options.Register (
         Ada_Lib.Options.Runstring.With_Parameters, Options_With_Parameters);
      return Log_Out (Ada_Lib.Options.Nested.Nested_Options_Type (
         Options).Initialize, Debug or Trace_Options);
   end Initialize;

   ----------------------------------------------------------------------------
   overriding
   function Process_Option (
      Options                    : in out GNOGA_Options_Type;
      Iterator                   : in out Ada_Lib.Options.
                                             Command_Line_Iterator_Interface'class;
      Option                     : in     Ada_Lib.Options.Base_Flag_Option_Type'class
   ) return Boolean is
   ----------------------------------------------------------------------------

   begin
      Log_In (Debug or Trace_Options, " option " & Option.Image);
      if Ada_Lib.Options.Has_Option (Option, Options_With_Parameters,
            Ada_Lib.Options.Null_Flag_List) then
         case Option.Kind is

         when Ada_Lib.Options.Plain =>
            case Option.Option is

               when 'G' =>   -- options for GNOGA
                  Options.Trace_Parse (Iterator);

               when 'w' =>   -- browser port number
                  Options.HTTP_Port := Ada_Lib.Socket_IO.Port_Type (
                     Iterator.Get_Integer);

               when Others =>
                  raise Failed with Quote ("Has_Option incorrectly passed ",
                     Option.Option);

            end case;

         when Ada_Lib.Options.Nil_Option |
              Ada_Lib.Options.Modified =>
            raise Failed with "Has_Option incorrectly passed " & Option.Image;

         end case;
      else
         return Log_Out (False, Debug or Trace_Options); -- derived from Interface_Options_Type
      end if;

      return Log_Out (True, Debug or Trace_Options, " option" & Option.Image &
         " handled");
   end Process_Option;

   ----------------------------------------------------------------------------
   overriding
   procedure Program_Help (
      Options                    : in      GNOGA_Options_Type;
      Help_Mode                  : in      Ada_Lib.Options.Help_Mode_Type) is
   ----------------------------------------------------------------------------

--    use Ada_Lib.Options;

   begin
      Log_In (Debug or Trace_Options);
      case Help_Mode is

      when Ada_Lib.Options.Program_Mode =>
            Ada_Lib.Help.Create_Option (Trace_Option,
               "trace options", "GNOGA traces", "GNOGA library",
               Ada_Lib.Help.Unmodified_Flag);
            Ada_Lib.Help.Create_Option (
               'w', "port number", "Web server port", "GNOGA library",
               Ada_Lib.Help.Unmodified_Flag);

      when Ada_Lib.Options.Trace_Mode =>
         Put_Line ("GNOGA library trace options (-" & Trace_Option & ")");
         Put_Line ("      a               all");
         Put_Line ("      d               GNOGA Library Debug");
--       Put_Line ("      l               GNOGA_Ada_Lib Debug");
         Put_Line ("      s               GNOGA Server Debug");
--       Put_Line ("      o               GNOGA options");
--       Put_Line ("      u               GNOGA Unit Test");
         New_Line;

      end case;

      Log_Out (Debug or Trace_Options);
   end Program_Help;

   ----------------------------------------------------------------------------
   overriding
   procedure Trace_Parse (
      Options                    : in out GNOGA_Options_Type;
      Iterator                   : in out Ada_Lib.Options.
                                             Command_Line_Iterator_Interface'class) is
   ----------------------------------------------------------------------------

      Parameter                  : constant String := Iterator.Get_Parameter;

   begin
      for Index in Parameter'range  loop
         declare
            Trace    : constant Character := Parameter (Index);

         begin
            case Trace is

               when 'a' =>
                  Ada_Lib.Options.GNOGA.Debug := True;
--                Ada_Lib.Options.GNOGA.Ada_Lib_Debug := True;
                  Ada_Lib.Options.GNOGA.Options_Debug := True;
                  Ada_Lib.Options.GNOGA.Server_Debug := True;

               when 'd' =>
                  Ada_Lib.Options.GNOGA.Debug := True;

--             when 'l' =>
--                Ada_Lib.Options.GNOGA.Ada_Lib_Debug := True;

--             when 'o' =>
                  Ada_Lib.Options.GNOGA.Options_Debug := True;

               when 's' =>
                  Ada_Lib.Options.GNOGA.Server_Debug := True;

               when others =>
                  Options.Bad_Trace_Option (Trace_Option, Trace);

            end case;


         end;
      end loop;
   end Trace_Parse;

begin
--   Debug := Debug or Ada_Lib.Options.Ada_Lib_Options.Debug_All;
--Debug := True;
--Trace_Options := True;
   Log_Here (Elaborate);
end GNOGA_Options;
