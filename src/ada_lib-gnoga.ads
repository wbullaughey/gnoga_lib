with Ada_Lib.Lock;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element.Form;
with Gnoga.Gui.View;
with Gnoga.Gui.Window;
with Gnoga.Types;
--with GNOGA_Ada_Lib;

package Ada_Lib.GNOGA is

   -- use for all types that create a GNOGA object
   type GNOGA_Interface    is limited interface;

   Create_Main_Description    : aliased constant String :=
                                 "create main window lock";
   package Create_Main_Window_Package is

      type Window_Lock_Type  is new Ada_Lib.Lock.Lock_Type (
                        Create_Main_Description'access) with private;

      procedure Clear_Main_Window (
         Lock     : in out Window_Lock_Type);

      procedure End_Create (
         Lock     : in out Window_Lock_Type
      ) with Pre  => Lock.Is_Window_Locked,
             Post=> not Lock.Is_Window_Locked;

      function Get_Main_Window (
         Lock     : in     Window_Lock_Type
      ) return Standard.Gnoga.Gui.Window.Pointer_To_Window_Class
      with Pre    => Lock.Has_Main_Window;

      function Has_Main_Window (
         Lock     : in     Window_Lock_Type
      ) return Boolean;

      function Is_Window_Locked(
         Lock     : in     Window_Lock_Type
      ) return Boolean;

      procedure Set_Main_Window (
         Lock     : in out Window_Lock_Type;
         Window   : in     Standard.Gnoga.Gui.Window.
                              Pointer_To_Window_Class
      ) with Pre => Is_Locked;

      procedure Start_Create (
         Lock     : in out Window_Lock_Type
      ) with Pre  => not Lock.Is_Window_Locked,
             Post=> Lock.Is_Window_Locked;

      procedure Clear_Main_Window;

      function Get_Main_Window
      return Standard.Gnoga.Gui.Window.Pointer_To_Window_Class;
--    with Pre => Has_Main_Window;

      function Has_Main_Window
      return Boolean;

      function Is_Locked
      return Boolean;

      procedure Lock_Create;

      procedure Set_Main_Window (
         Window    : in     Standard.Gnoga.Gui.Window.
                              Pointer_To_Window_Class
      ) with Pre => Is_Locked and then
                    not Has_Main_Window;

      procedure Unlock_Create;

   private

      type Window_Lock_Type is new Ada_Lib.Lock.Lock_Type (
                        Create_Main_Description'access) with record
         Creating_Main_Window    : Boolean := False;
         Main_Window             : Standard.Gnoga.Gui.Window.
                                    Pointer_To_Window_Class := Null;
      end record;

      Lock                       : Window_Lock_Type;

   end Create_Main_Window_Package;

-- Create_Main_Window_Lock
--             : Create_Main_Window_Package.Window_Lock_Type;

   type Connection_Data_Type is new Standard.Gnoga.Types.Connection_Data_Type with
                                    record
         Main_Window : Standard.Gnoga.Gui.Window.Pointer_To_Window_Class := Null;
         Main_Created: Boolean := False;
      end record;

   type Connection_Data_Access is access all Connection_Data_Type;
   type Connection_Data_Class_Access is access all Connection_Data_Type'class;

   function Main_Created (
      Connection_Data         : in     Connection_Data_Type
   ) return Boolean;

   procedure Set_Connection_Data_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Standard.Gnoga.Gui.Window.
                                          Pointer_To_Window_Class);

   procedure Set_Main_Created (
      Connection_Data         : in out Connection_Data_Type
   ) with Pre => Create_Main_Window_Package.Is_Locked;

   type Form_Connection_Type is new Connection_Data_Type with  record
      Button                     : Standard.Gnoga.Gui.Element.Common.Button_Type;
      Display_Window             : Standard.Gnoga.Gui.View.View_Type;
      Form                       : Standard.Gnoga.Gui.Element.Form.Form_Type;
   end record;

   type Form_Connection_Access        is access all Form_Connection_Type;
   type Form_Connection_Class_Access  is access all Form_Connection_Type'class;

   function Get_Window_Connection_Data
   return Connection_Data_Class_Access
   with Pre => Has_Main_Window,
        Post=> Get_Window_Connection_Data'Result /= Null;

   function Has_Main_Window
   return Boolean;

end Ada_Lib.GNOGA;
