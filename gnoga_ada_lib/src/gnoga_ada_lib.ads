with Ada.Exceptions;
with Ada_Lib.Options.Nested;
with Ada_Lib.Trace;
with Gnoga.Gui.Base;
with Gnoga.Gui.Window;
with GNAT.Source_Info;
with Gnoga.Types;

package Gnoga_Ada_Lib is

   Failed   : exception;

   type Connection_Data_Type is new Gnoga.Types.Connection_Data_Type with
                                    record
         Main_Window : Gnoga.Gui.Window.Pointer_To_Window_Class := Null;
      end record;

   type Connection_Data_Access is access all Connection_Data_Type;
   type Connection_Data_Class_Access is access all Connection_Data_Type'class;

   procedure Set_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Gnoga.Gui.Window.
                                          Pointer_To_Window_Class);

   type GNOGA_Ada_Lib_Option_Type is new Ada_Lib.Options.Nested.
                     Nested_Options_Type with null record;

   procedure Display_Help (            -- common for all programs that use GNOGA_Options
                              -- prints full help, aborts program
     Options                     : in     GNOGA_Ada_Lib_Option_Type;  -- only used for dispatch
     Message                     : in     String := "";   -- leave blank no error help
     Halt                        : in     Boolean := True);

   function Image (
     Options                     : in     GNOGA_Ada_Lib_Option_Type
   ) return String;

   function Initialize (
     Options                     : in out GNOGA_Ada_Lib_Option_Type;
     From                        : in     String := Ada_Lib.Trace.Here
   ) return Boolean;

   function Process_Option (  -- process one option
     Options   : in out GNOGA_Ada_Lib_Option_Type;
     Iterator  : in out Ada_Lib.Options.Command_Line_Iterator_Interface'class;
     Option    : in     Ada_Lib.Options.Base_Flag_Option_Type'class
   ) return Boolean;

   procedure Program_Help (
      Options     : in     GNOGA_Ada_Lib_Option_Type;
      Help_Mode   : in     Ada_Lib.Options.Help_Mode_Type);

   function Has_Parent (
      Object         : in out Gnoga.Gui.Base.Base_Type'Class
   ) return Boolean;

   procedure Report_Exception (
      Window         : in out Gnoga.Gui.Window.Window_Type'class;
      Fault          : in     Ada.Exceptions.Exception_Occurrence;
      Message        : in     String;
      Where          : in     String := GNAT.Source_Info.Source_Location);

   procedure Trace_Parse (
      Iterator       : in out Ada_Lib.Options.
                                 Command_Line_Iterator_Interface'class);

private
   GNOGA_Initialized             : Boolean := False;  -- can only be done once per program
   Main_Created                  : Boolean := False;

end Gnoga_Ada_Lib;
