with Ada.Exceptions;
with Ada_Lib.Options;
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

   function Has_Parent (
      Object         : in out Gnoga.Gui.Base.Base_Type'Class
   ) return Boolean;

   procedure Program_Help (
      Help_Mode                  : in      Ada_Lib.Options.Help_Mode_Type);

   procedure Report_Exception (
      Window         : in out Gnoga.Gui.Window.Window_Type'class;
      Fault          : in     Ada.Exceptions.Exception_Occurrence;
      Message        : in     String;
      Where          : in     String := GNAT.Source_Info.Source_Location);

   procedure Set_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Gnoga.Gui.Window.
                                          Pointer_To_Window_Class);
   procedure Trace_Parse (
      Iterator       : in out Ada_Lib.Options.
                                 Command_Line_Iterator_Interface'class);

private
   GNOGA_Initialized             : Boolean := False;  -- can only be done once per program
   Main_Created                  : Boolean := False;

end Gnoga_Ada_Lib;
