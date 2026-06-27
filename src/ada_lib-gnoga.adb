with Ada_Lib.Options;
with Ada_Lib.Trace; use Ada_Lib.Trace;
with Gnoga.Gui.Base;

package body Ada_Lib.GNOGA is

   use type Standard.Gnoga.Gui.Window.Pointer_To_Window_Class;
   use type Standard.Gnoga.Types.Pointer_to_Connection_Data_Class;

   Debug       : Boolean renames Ada_Lib.Options.Ada_Lib_GNOGA.Ada_Lib_Debug;
-- Main_Window_Created
--             : Boolean := False;

   ---------------------------------------------------------------
   function Get_Window_Connection_Data
   return Connection_Data_Class_Access is
   ---------------------------------------------------------------

      Result   : constant Standard.Gnoga.Types.
                  Pointer_to_Connection_Data_Class :=
                     Standard.Gnoga.Gui.Base.Connection_Data (
                        Standard.Gnoga.Gui.Base.Base_Type (
                           Create_Main_Window_Package.Get_Main_Window.all));
   begin
      return Connection_Data_Class_Access (Result);
   end Get_Window_Connection_Data;

   ---------------------------------------------------------------
   function Has_Main_Window
   return Boolean is
   ---------------------------------------------------------------

      Result   : constant Boolean := Create_Main_Window_Package.Has_Main_Window;

   begin
      return Log_Here (Result, Debug or else Trace_Pre_Post_Conditions or else
         (Trace_Pre_Post_False and not Result));
   end Has_Main_Window;

   ---------------------------------------------------------------
   function Main_Created (
      Connection_Data         : in     Connection_Data_Type
   ) return Boolean is
   ---------------------------------------------------------------

   begin
      return Connection_Data.Main_Created and then
             Connection_Data.Main_Window /= Null;
   end Main_Created;

   ---------------------------------------------------------------
   procedure Set_Connection_Data_Main_Window (
      Connection_Data         : in out Connection_Data_Type;
      Main_Window             : in     Standard.Gnoga.Gui.Window.
                                          Pointer_To_Window_Class) is
   ---------------------------------------------------------------

   begin
      Log_Here (Debug);
      Connection_Data.Main_Window := Main_Window;
   end Set_Connection_Data_Main_Window;

   ---------------------------------------------------------------
   procedure Set_Main_Created (
      Connection_Data          : in out Connection_Data_Type) is
   ---------------------------------------------------------------

   begin
      Log_Here (Debug);
      Connection_Data.Main_Created := True;
--    Set_Main_Created.Set_Main_Created;
   end Set_Main_Created;

   package body Create_Main_Window_Package is

      ---------------------------------------------------------------
      procedure Clear_Main_Window is
      ---------------------------------------------------------------

      begin
         Lock.Clear_Main_Window;
      end Clear_Main_Window;

      ---------------------------------------------------------------
      procedure Clear_Main_Window (
         Lock     : in out Window_Lock_Type) is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         Lock.Main_Window := Null;
      end Clear_Main_Window;

   ---------------------------------------------------------------
      procedure End_Create (
         Lock     : in out Window_Lock_Type) is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         Lock.Creating_Main_Window := False;
         Lock.Unlock;
      end End_Create;

      ---------------------------------------------------------------
      function Get_Main_Window
      return Standard.Gnoga.Gui.Window.Pointer_To_Window_Class is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         return Lock.Get_Main_Window;
      end Get_Main_Window;

      ---------------------------------------------------------------
      function Get_Main_Window(
         Lock     : in     Window_Lock_Type
      ) return Standard.Gnoga.Gui.Window.Pointer_To_Window_Class is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         return Lock.Main_Window;
      end Get_Main_Window;

      ---------------------------------------------------------------
      function Has_Main_Window
      return Boolean is
      ---------------------------------------------------------------

         Has_Main_Window   : constant Boolean :=Lock.Has_Main_Window;

      begin
         Log_In (Debug, "Has_Main_Window " & Has_Main_Window'img);
         if Has_Main_Window then
            declare
               Connection_Data   : constant Standard.Gnoga.Types.
                                    Pointer_to_Connection_Data_Class :=
                                       Standard.Gnoga.Gui.Base.Connection_Data (
                                          Standard.Gnoga.Gui.Base.Base_Type (
                                             Get_Main_Window.all));
               Result            : constant Boolean := Connection_Data /= Null;

            begin
               return Log_Out (Result, Debug);
            end;
         end if;
         return Log_Out (False, Debug);
      end Has_Main_Window;

      ---------------------------------------------------------------
      function Has_Main_Window (
         Lock     : in     Window_Lock_Type
      ) return Boolean is
      ---------------------------------------------------------------


         Result   : constant Boolean := Lock.Main_Window /= Null;

      begin
         Log_Here (Debug or Trace_Pre_Post_Conditions, Result'img);
         return Result;
      end Has_Main_Window;

      ---------------------------------------------------------------
      function Is_Locked
      return Boolean is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug, "is locked " & Lock.Is_Locked'img);
         return Lock.Is_Locked;
      end Is_Locked;

      ---------------------------------------------------------------
      function Is_Window_Locked(
         Lock     : in     Window_Lock_Type
      ) return Boolean is
      ---------------------------------------------------------------

         Result   : constant Boolean := Ada_Lib.Lock.Lock_Type (Lock).Is_Locked;

      begin
         Log_Here (Debug or Trace_Pre_Post_Conditions,
            "window locked  " & Result'img);
         return Result;
      end Is_Window_Locked;

      ---------------------------------------------------------------
      procedure Lock_Create is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         Lock.Lock;
      end Lock_Create;

      ---------------------------------------------------------------
      procedure Set_Main_Window (
         Window    : in     Standard.Gnoga.Gui.Window.Pointer_To_Window_Class) is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         Lock.Set_Main_Window (Window);
      end Set_Main_Window;

      ---------------------------------------------------------------
      procedure Set_Main_Window (
         Lock     : in out Window_Lock_Type;
         Window   : in     Standard.Gnoga.Gui.Window.
                              Pointer_To_Window_Class) is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         Lock.Main_Window := Window;
      end Set_Main_Window;

      ---------------------------------------------------------------
      procedure Start_Create (
         Lock     : in out Window_Lock_Type) is
      ---------------------------------------------------------------

      begin
         Log_In (Debug);
         Lock.Lock;
         Lock.Creating_Main_Window := True;
         Log_Out (Debug);
      end Start_Create;

      ---------------------------------------------------------------
      procedure Unlock_Create is
      ---------------------------------------------------------------

      begin
         Log_Here (Debug);
         Lock.Unlock;
      end Unlock_Create;

   end Create_Main_Window_Package;

end Ada_Lib.GNOGA;
