with Ada_Lib.Socket_IO;
with Gnoga.Application.Multi_Connect;

package GNOGA_Ada_Lib.Base is

   Failed                        : exception;

   protected Message_Loop_Signal is

      procedure Completed;
      entry Wait;

   private
      Done                       : Boolean := False;

   end Message_Loop_Signal;

   procedure Initialize_GNOGA (   -- makes sure only done once
      Handler                    : in     Standard.Gnoga.Application.Multi_Connect.Application_Connect_Event;
      Application_Title          : in     String;
      Port                       : in     Standard.Ada_Lib.Socket_IO.Port_Type;
      Wait_For_Message_Loop_Exit        : in     Boolean;
      Handler_Path               : in     String := "default";
      Verbose                    : in     Boolean := False);

   procedure Set_Main_Created (
      Value                      : in     Boolean);

   procedure Run (
      Handler                    : in     Gnoga.Application.Multi_Connect.
                                             Application_Connect_Event;
      Directory                  : in     String;
      Port                       : in     Ada_Lib.Socket_IO.Port_Type;
      Verbose                    : in     Boolean;
      Wait_For_Message_Loop_Exit        : in     Boolean);   -- should be false for
                                                      -- multiple unit tests

   procedure Wait_For_Message_Loop_Exit;

end GNOGA_Ada_Lib.Base;

