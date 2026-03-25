with Ada.Exceptions;
with Ada_Lib.Options.Verification;
with Ada_Lib.Socket_IO;
with Ada_Lib.Trace;
with Gnoga.Gui.Base;
with Gnoga.Gui.Window;
with GNAT.Source_Info;
--with GNOGA_Options;
--with Gnoga.Types;

package Gnoga_Ada_Lib is

   Failed   : exception;

   type GNOGA_Ada_Lib_Options_Type is new Ada_Lib.Options.Verification.
      Verification_Nested_Options_Type with private;

   type GNOGA_Ada_Lib_Options_Constant_Class_Access
      is access constant GNOGA_Ada_Lib_Options_Type'class;

   procedure Display_Help (            -- common for all programs that use GNOGA_Options
                              -- prints full help, aborts program
     Options                     : in     GNOGA_Ada_Lib_Options_Type;  -- only used for dispatch
     Message                     : in     String := "";   -- leave blank no error help
     Halt                        : in     Boolean := True);

   function Get_GNOGA_Ada_Lib_Read_Only_Options (
      From                       : in     String := Ada_Lib.Trace.Here
   ) return GNOGA_Ada_Lib_Options_Constant_Class_Access
   with Pre    => Ada_Lib.Options.Verification.Have_Ada_Lib_Program_Options;

   function Get_HTTP_Port (
     Options                     : in     GNOGA_Ada_Lib_Options_Type
   ) return Ada_Lib.Socket_IO.Port_Type
   with Pre => Ada_Lib.Options.Verification.Have_Ada_Lib_Program_Options;

   function Image (
     Options                     : in     GNOGA_Ada_Lib_Options_Type
   ) return String;

   function Initialize (
     Options                     : in out GNOGA_Ada_Lib_Options_Type;
     From                        : in     String := Ada_Lib.Trace.Here
   ) return Boolean
   with pre    => Options.Verify_Preinitialize,
        post   => Options.Verify_Initialized;

   function Process_Option (  -- process one option
     Options   : in out GNOGA_Ada_Lib_Options_Type;
     Iterator  : in out Ada_Lib.Options.Command_Line_Iterator_Interface'class;
     Option    : in     Ada_Lib.Options.Base_Flag_Option_Type'class
   ) return Boolean;

   procedure Program_Help (
      Options     : in     GNOGA_Ada_Lib_Options_Type;
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
   type GNOGA_Ada_Lib_Options_Type is new Ada_Lib.Options.Verification.
         Verification_Nested_Options_Type with record
      HTTP_Port            : Ada_Lib.Socket_IO.Port_Type := 8080;
   end record;

   GNOGA_Initialized             : Boolean := False;  -- can only be done once per program
   Main_Created                  : Boolean := False;

end Gnoga_Ada_Lib;
