with Ada_Lib.Options.Actual;
--with Ada_Lib.Command_Line_Iterator;
with Ada_Lib.Socket_IO;
with Ada_Lib.Trace;

--pragma Warnings (On, "GNOGA");
-- needs to bin in ada_lib directory so gnoga can include it
package GNOGA_Options is

   Failed                  : exception;

   type GNOGA_Options_Type is limited new Ada_Lib.Options.Actual.
                              Nested_Options_Type with record
      HTTP_Port            : Ada_Lib.Socket_IO.Port_Type := 8080;
   end record;

   type GNOGA_Options_Access           is access GNOGA_Options_Type;
   type GNOGA_Options_Class_Access     is access all GNOGA_Options_Type'class;
   type GNOGA_Options_Constant_Class_Access
                                       is access constant GNOGA_Options_Type'class;

   overriding
   function Initialize (
     Options                     : in out GNOGA_Options_Type;
     From                        : in     String := Ada_Lib.Trace.Here
   ) return Boolean
   with pre => Options.Verify_Preinitialize;

   type String_Access            is access constant String;

   overriding
   function Process_Option (
      Options                    : in out GNOGA_Options_Type;
      Iterator                   : in out Ada_Lib.Options.
                                             Command_Line_Iterator_Interface'class;
      Option                     : in     Ada_Lib.Options.Option_Type'class
   ) return Boolean;

   Debug                         : aliased Boolean := False;
   GNOGA_Ada_Lib_Debug           : aliased Boolean := False;
   Debug_Options                 : aliased Boolean := False;
   GNOGA_Options                 : GNOGA_Options_Constant_Class_Access := Null;

private
-- overriding
-- function Set_Options (
--    Options                    : in out GNOGA_Options_Type
-- ) return Boolean;  -- options only used for dispatch

   overriding
   procedure Program_Help (      -- common for all programs that use GNOGA_Options
      Options                    : in     GNOGA_Options_Type;  -- only used for dispatch
      Help_Mode                  : in     Ada_Lib.Options.Help_Mode_Type);


   overriding
   procedure Trace_Parse (
      Options              : in out GNOGA_Options_Type;
      Iterator             : in out Ada_Lib.Options.
                                       Command_Line_Iterator_Interface'class);

end GNOGA_Options;
