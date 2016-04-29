program VM205;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,cmem,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, VM205_1, rpi_hal
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

