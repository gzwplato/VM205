 {
    Copyright (C) 2014 Velleman NV

    This file is part of the software for the
    Velleman VM205 Oscilloscope shield for Raspberry Pi.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


Change History:
Rev	Date		Description	
1.0	30/6/2014	Initial release
1.1	10/11/2015	Added option to select background color (white or black).
1.2 19/1/2016   Modified to work on Raspberry Pi 2.
}

unit VM205_1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ComCtrls, rpi_hal;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Time6: TSpeedButton;
    Time7: TSpeedButton;
    Time8: TSpeedButton;
    TriggerLevel: TTrackBar;
    Stop: TSpeedButton;
    Time005: TSpeedButton;
    Volt5: TSpeedButton;
    Time200: TSpeedButton;
    Time100: TSpeedButton;
    Time50: TSpeedButton;
    Time20: TSpeedButton;
    Time10: TSpeedButton;
    Time5: TSpeedButton;
    Time2: TSpeedButton;
    Time1: TSpeedButton;
    Time05: TSpeedButton;
    Time02: TSpeedButton;
    Volt2: TSpeedButton;
    Time01: TSpeedButton;
    Run: TSpeedButton;
    Volt1: TSpeedButton;
    Volt05: TSpeedButton;
    Volt02: TSpeedButton;
    Volt01: TSpeedButton;
    CouplingAC: TSpeedButton;
    CouplingDC: TSpeedButton;
    Timer1: TTimer;
    PositionY: TTrackBar;
    Volt6: TSpeedButton;
    Volt7: TSpeedButton;
    Volt8: TSpeedButton;
    Volt9: TSpeedButton;
    procedure CheckBox11Change(Sender: TObject);
    procedure CouplingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PositionYChange(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure VoltClick(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure TimeClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TriggerClick(Sender: TObject);
    procedure TriggerLevelChange(Sender: TObject);
    procedure LogicAnalyzerChannels1Select(Sender: TObject);
    procedure TriggerMarkDraw;
    procedure DisplayADCData;
    procedure DispalyLogicAnalyzerData;
    procedure RefreshDisplay;
    procedure MouseDown1(x,y:integer);
    procedure MouseUp1(x,y:integer);
    procedure MouseMove1(x,y:integer);
    procedure CursorsUpdate;
    procedure CursorVolt;
    procedure CursorTime;

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  data:array[0..805] of byte;
  data2:array[0..805] of byte;
  data3:array[0..805] of byte;
  new, BlackScreen:boolean;
  trgLevel,volt,time:integer;
  LogicAnalyzerChannels:word;
  OldLogicAnalyzerChannels:word;
  old_x1,old_x2,old_y1,old_y2,xx,yy,cursor:integer;
  x_end,y1_end,y2_end,bottom:integer;
  m_down:boolean;
  x_increment,old_x_increment:real;


implementation
{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  trgLevel:=128;
  volt:=2;
  time:=8;
  LogicAnalyzerChannels:=1;
  bottom:=image1.height;
  y1_end:=image1.height;
  y2_end:=image2.height;
  x_end:=image1.width;
  old_x1:=16;
  old_x2:=800-16;
  old_y1:=16;
  old_y2:=256-16;
  x_increment:=1.0;
  old_x_increment:=1.0;
end;

procedure Tform1.CursorVolt;
var resolution,v:real;
begin
 case volt of
   1: resolution:=5.0/32;
   2: resolution:=2.0/32;
   3: resolution:=1.0/32;
   4: resolution:=0.5/32;
   5: resolution:=0.2/32;
   6: resolution:=0.1/32;
 end;
 v:=resolution*(old_y1-old_y2);
 if v<0 then v:=-v;
 Label6.Caption:='dV = '+FloatToStrF(v,ffFixed,0, 2)+'V';
end;

procedure Tform1.CursorTime;
var resolution,t1,t2,dt:real;
begin
 case time of
   1: resolution:=200.0/50;
   2: resolution:=100.0/50;
   3: resolution:=50.0/50;
   4: resolution:=20.0/50;
   5: resolution:=10.0/50;
   6: resolution:=5.0/50;
   7: resolution:=2.0/50;
   8: resolution:=1.0/50;
   9: resolution:=0.5/50;
   10: resolution:=0.2/50;
   11: resolution:=0.1/50;
   12: resolution:=0.05/50;
   13: resolution:=0.02/50;
   14: resolution:=0.01/50;
   15: resolution:=0.005/50;
 end;
 t1:=resolution*(old_x1);
 t2:=resolution*(old_x2);
 dt:=t2-t1;
 if dt<0 then dt:=-dt;

 if time < 12 then
 begin
   Label7.Caption:='T1 = '+FloatToStrF(t1,ffFixed,0, 2)+'ms';
   Label8.Caption:='T2 = '+FloatToStrF(t2,ffFixed,0, 2)+'ms';
   Label9.Caption:='dT = '+FloatToStrF(dt,ffFixed,0, 2)+'ms';
 end
 else
 begin
   Label7.Caption:='T1 = '+FloatToStrF(t1*1000,ffFixed,0, 2)+'us';
   Label8.Caption:='T2 = '+FloatToStrF(t2*1000,ffFixed,0, 2)+'us';
   Label9.Caption:='dT = '+FloatToStrF(dt*1000,ffFixed,0, 2)+'us';
 end;

 if dt > 0 then
 begin
   if dt < 1.0 then
     Label10.Caption:='1/dT = '+FloatToStrF(1/dt,ffFixed,0, 2)+'kHz'
   else
     Label10.Caption:='1/dT = '+FloatToStrF(1000/dt,ffFixed,0, 2)+'Hz';
 end
 else
   Label10.Caption:='1/dT = --Hz';
end;

procedure Tform1.CursorsUpdate;
begin
  Image1.Canvas.Pen.Style:=psDot;
  Image1.Canvas.MoveTo(1,old_y1);
  Image1.Canvas.LineTo(x_end,old_y1);
  Image1.Canvas.MoveTo(1,old_y2);
  Image1.Canvas.LineTo(x_end,old_y2);

  Image1.Canvas.MoveTo(old_x1,1);
  Image1.Canvas.LineTo(old_x1,y1_end);
  Image1.Canvas.MoveTo(old_x2,1);
  Image1.Canvas.LineTo(old_x2,y1_end);
  Image1.Canvas.Pen.Style:=psSolid;

  Image2.Canvas.Pen.Style:=psDot;
  Image2.Canvas.MoveTo(old_x1,1);
  Image2.Canvas.LineTo(old_x1,y2_end);
  Image2.Canvas.MoveTo(old_x2,1);
  Image2.Canvas.LineTo(old_x2,y2_end);
  Image2.Canvas.Pen.Style:=psSolid;
end;

procedure TForm1.MouseDown1(x,y:integer);
var diff_x,diff_y,diff1,diff2:integer;
begin
  m_down:=True;
  if x>old_x1 then diff1:= x - old_x1 else diff1:=old_x1 - x;
  if x>old_x2 then diff2:= x - old_x2 else diff2:=old_x2 - x;
  if diff1>diff2 then
  begin
    xx:=old_x2;
    cursor:=2;
  end
  else
  begin
    xx:=old_x1;
    cursor:=1;
  end;
  if diff1>diff2 then diff_x:=diff2 else diff_x:=diff1;
  if y>old_y1 then diff1:= y - old_y1 else diff1:=old_y1 - y;
  if y>old_y2 then diff2:= y - old_y2 else diff2:=old_y2 - y;
  if diff1>diff2 then diff_y:=diff2 else diff_y:=diff1;
  if diff_x>diff_y then
  begin
    if diff1>diff2 then
    begin
      yy:=old_y2;
      cursor:=4;
    end
    else
    begin
      yy:=old_y1;
      cursor:=3;
    end;
      Image1.Canvas.Pen.Style:=psDot;
      Image1.Canvas.MoveTo(1,yy);
      Image1.Canvas.LineTo(x_end,yy);
      Image1.Canvas.Pen.Style:=psSolid;
      Image1.Canvas.MoveTo(1,yy);
      Image1.Canvas.LineTo(x_end,yy);
  end
  else
  begin
    Image1.Canvas.Pen.Style:=psDot;
    Image1.Canvas.MoveTo(xx,1);
    Image1.Canvas.LineTo(xx,y1_end);
    Image1.Canvas.Pen.Style:=psSolid;
    Image1.Canvas.MoveTo(xx,1);
    Image1.Canvas.LineTo(xx,y1_end);

    Image2.Canvas.Pen.Style:=psDot;
    Image2.Canvas.MoveTo(xx,1);
    Image2.Canvas.LineTo(xx,y2_end);
    Image2.Canvas.Pen.Style:=psSolid;
    Image2.Canvas.MoveTo(xx,1);
    Image2.Canvas.LineTo(xx,y2_end);
  end;
end;

procedure TForm1.MouseMove1(x,y:integer);
var tmp:integer;
begin
  if (m_down) and ((cursor=1) or (cursor=2)) and (xx<>x) then
  begin
    Image1.Canvas.MoveTo(xx,1);
    Image1.Canvas.LineTo(xx,y1_end);
    tmp:=xx;
    xx:=x;
    Image1.Canvas.MoveTo(xx,1);
    Image1.Canvas.LineTo(xx,y1_end);

    Image2.Canvas.MoveTo(tmp,1);
    Image2.Canvas.LineTo(tmp,y1_end);
    Image2.Canvas.MoveTo(xx,1);
    Image2.Canvas.LineTo(xx,y1_end);

    if cursor=1 then old_x1:=xx else old_x2:=xx;
    CursorTime;
  end;
  if (m_down) and ((cursor=3) or (cursor=4)) and (yy<>y) then
  begin
    Image1.Canvas.MoveTo(1,yy);
    Image1.Canvas.LineTo(x_end,yy);
    yy:=y;
    Image1.Canvas.MoveTo(1,yy);
    Image1.Canvas.LineTo(x_end,yy);
    if cursor=3 then old_y1:=yy else old_y2:=yy;
    CursorVolt;
  end;
end;

procedure TForm1.MouseUp1(x,y:integer);
begin
  m_down:=False;
  if (cursor=1) or (cursor=2) then
  begin
    Image1.Canvas.MoveTo(xx,1);
    Image1.Canvas.LineTo(xx,y1_end);
    Image1.Canvas.Pen.Style:=psDot;
    Image1.Canvas.MoveTo(xx,1);
    Image1.Canvas.LineTo(xx,y1_end);
    Image1.Canvas.Pen.Style:=psSolid;

    Image2.Canvas.MoveTo(xx,1);
    Image2.Canvas.LineTo(xx,y2_end);
    Image2.Canvas.Pen.Style:=psDot;
    Image2.Canvas.MoveTo(xx,1);
    Image2.Canvas.LineTo(xx,y2_end);
    Image2.Canvas.Pen.Style:=psSolid;
    if cursor=1 then old_x1:=xx else old_x2:=xx;
  end;
  if (cursor=3) or (cursor=4) then
  begin
    Image1.Canvas.MoveTo(1,yy);
    Image1.Canvas.LineTo(x_end,yy);
    Image1.Canvas.Pen.Style:=psDot;
    Image1.Canvas.MoveTo(1,yy);
    Image1.Canvas.LineTo(x_end,yy);
    Image1.Canvas.Pen.Style:=psSolid;
    if cursor=3 then old_y1:=yy else old_y2:=yy;
  end;
 CursorVolt;
 CursorTime;
end;


procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=mbLeft then
    MouseDown1(x,y);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if m_down then
  begin
    if x<0 then x:=0;
    if y<0 then y:=0;
    if y>y1_end then y:=y1_end;
    if x>x_end then x:=x_end;
    MouseMove1(x,y);
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if m_down and (button=mbLeft) then
    MouseUp1(x,y);
end;

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button=mbLeft then
    MouseDown1(x,2000);
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if m_down then
    begin
    if x<0 then x:=0;
    if x>x_end then x:=x_end;
    MouseMove1(x,2000);
  end;

end;

procedure TForm1.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if m_down and (button=mbLeft) then
    MouseUp1(x,2000);
end;

procedure TForm1.StopClick(Sender: TObject);
begin
  Timer1.Enabled:=False;
end;

procedure TForm1.RefreshDisplay;
var i:integer;
begin
    Image1.Picture:=nil  ;
    if BlackScreen then
      Image1.Canvas.Brush.Color:=clBlack
    else
      Image1.Canvas.Brush.Color:=clWhite;
    Image1.Canvas.FillRect(0,0,800,256);
   // Image1.Canvas.Brush.Color:=clBlack;
   // Image1.Canvas.FloodFill(5,5,clBlack,fsBorder);
    Image1.Canvas.Pen.Mode:=pmCopy;
    if BlackScreen then
      Image1.Canvas.Pen.Color := $404040
    else
      Image1.Canvas.Pen.Color := clLtGray;
    for i:=0 to 8 do
    begin
      Image1.Canvas.MoveTo(0,i*32);
      Image1.Canvas.LineTo(800,i*32);
    end;
    for i:=0 to 16 do
    begin
      Image1.Canvas.MoveTo(i*50,0);
      Image1.Canvas.LineTo(i*50,255);
    end;

    Image2.Picture:=nil;
    if BlackScreen then
      Image2.Canvas.Brush.Color:=clBlack
    else
      Image2.Canvas.Brush.Color:=clWhite;
    Image2.Canvas.FillRect(0,0,800,201);
   // Image2.Canvas.Brush.Color:=clBlack;
   // Image2.Canvas.FloodFill(5,5,clBlack,fsBorder);
    Image2.Canvas.Pen.Mode:=pmCopy;
    if BlackScreen then
      Image2.Canvas.Pen.Color := $808080
    else
      Image2.Canvas.Pen.Color := clGray;
    for i:=0 to 10 do
    begin
      Image2.Canvas.MoveTo(0,i*20);
      Image2.Canvas.LineTo(800,i*20);
    end;
    if BlackScreen then
      Image2.Canvas.Pen.Color := $404040
    else
      Image2.Canvas.Pen.Color := clLtGray;
    for i:=0 to 16 do
    begin
      Image2.Canvas.MoveTo(i*50,0);
      Image2.Canvas.LineTo(i*50,200);
    end;
    Image1.Canvas.Pen.Mode:=pmNotXor;
    Image2.Canvas.Pen.Mode:=pmNotXor;
    Image1.Canvas.Brush.Color := clWhite;
    Image2.Canvas.Brush.Color := clWhite;
    if BlackScreen then
    begin
      Image1.Canvas.Pen.Color:=clMaroon;
      Image2.Canvas.Pen.Color:=clMaroon;
    end
    else
    begin
      Image1.Canvas.Pen.Color:=clBlue;
      Image2.Canvas.Pen.Color:=clRed;
    end;
    CursorsUpdate;
    TriggerMarkDraw;
    new:=true;
end;

procedure TForm1.RunClick(Sender: TObject);
begin
    SPI_Write(0,0,$81);       // reset and start acquisition
    RefreshDisplay;
    Timer1.Enabled:=True
end;

procedure TForm1.VoltClick(Sender: TObject);
begin
  SPI_Write(0,$91,(Sender as TSpeedButton).Tag);
  volt:=(Sender as TSpeedButton).Tag;
  CursorVolt;
end;

procedure TForm1.CouplingClick(Sender: TObject);
begin
  SPI_Write(0,$92,(Sender as TSpeedButton).Tag);
end;

procedure TForm1.CheckBox11Change(Sender: TObject);
begin
  if CheckBox11.Checked then BlackScreen:=true else BlackScreen:=false;
end;

procedure TForm1.TimeClick(Sender: TObject);
var tmp:integer;
begin
  tmp:=(Sender as TSpeedButton).Tag;
  if tmp<13 then
  begin
    SPI_Write(0,$93,tmp);
    x_increment:=1.0;
  end
  else
  begin
    SPI_Write(0,$93,12);
    case tmp of
      13: x_increment:=2.5;
      14: x_increment:=5.0;
      15: x_increment:=10.0;
    end;
  end;
  time:=tmp;
  CursorTime;
end;

procedure TForm1.TriggerClick(Sender: TObject);
begin
  SPI_Write(0,$94,(Sender as TSpeedButton).Tag);
end;

procedure TForm1.PositionYChange(Sender: TObject);
begin
  SPI_Write(0,$95,PositionY.Position);
end;

procedure TForm1.TriggerLevelChange(Sender: TObject);
begin
  TriggerMarkDraw;           // removes old trigger mark
  SPI_Write(0,$96,255-TriggerLevel.Position);
  trgLevel:=TriggerLevel.Position;
  TriggerMarkDraw;
end;

procedure TForm1.TriggerMarkDraw;
begin
  Image1.Canvas.MoveTo(0,trgLevel);
  Image1.Canvas.LineTo(5,trgLevel);
end;

procedure TForm1.LogicAnalyzerChannels1Select(Sender: TObject);
begin
  if (Sender as TCheckBox).Checked then
    LogicAnalyzerChannels:=LogicAnalyzerChannels or (Sender as TCheckBox).Tag
  else
    LogicAnalyzerChannels:=LogicAnalyzerChannels and (1023-(Sender as TCheckBox).Tag);
  RefreshDisplay;
end;

procedure TForm1.DisplayADCData;
var x,xp,i:longword;
x_position:real;
begin
 {
   for i:=0 to 800 do
     spi_buf[0].buf[i]:=1;

    spi_buf[0].endidx:=0;
    spi_buf[0].posidx:=spi_buf[0].endidx+1;
    SPI_BurstRead2Buffer (0,1,801);
  }
    if not new then
    begin
      x:=0;
      x_position:=0.0;
      Image1.Canvas.MoveTo(0, data[0]);
      repeat
        Inc(x);
        x_position:=x_position+old_x_increment;
        xp:=Round(x_position);
        Image1.Canvas.LineTo(xp, data[x]);
      until xp>=798;
    end;

//    for i:=0 to 799 do
//      data[i]:=255 - spi_buf[0].buf[i+1];
    SPI_Read(0,1);
    for i:=0 to 799 do
      data[i]:=255 - SPI_Read(0,1);

    x:=0;
    x_position:=0.0;
    Image1.Canvas.MoveTo(0, data[0]);
    repeat
      Inc(x);
      x_position:=x_position+x_increment;
      xp:=Round(x_position);
      Image1.Canvas.LineTo(xp, data[x]);
    until xp>=798;

    Image1.Canvas.Pen.Mode:=pmCopy;
    Image1.Canvas.Pen.Color := $404040;
    Image1.Canvas.MoveTo(0,0);
    Image1.Canvas.LineTo(800,0);
    Image1.Canvas.MoveTo(0,255);
    Image1.Canvas.LineTo(800,255);
    if BlackScreen then
      Image1.Canvas.Pen.Color:=clMaroon
    else
      Image1.Canvas.Pen.Color:=clBlue;
    Image1.Canvas.Pen.Mode:=pmNotXor;
end;

procedure TForm1.DispalyLogicAnalyzerData;
var x,xp,i,e,f:longword;
x_position:real;
begin
    if not new then
    begin
      e:=1;
      for i:=0 to 9 do
      begin
        if (OldLogicAnalyzerChannels and e)>0 then
        begin
          if i<8 then
          begin
            x:=0;
            x_position:=0.0;
            Image2.Canvas.MoveTo(0, (data2[0] and e)*15 div e + 20*i+4);
            repeat
              Inc(x);
              x_position:=x_position+old_x_increment;
              xp:=Round(x_position);
              if data2[x-1] <> data2[x] then
              begin
                Image2.Canvas.LineTo(xp, (data2[x-1] and e)*15 div e + 20*i+4);
                Image2.Canvas.LineTo(xp, (data2[x] and e)*15 div e + 20*i+4);
              end;
            until xp>=798;
            Image2.Canvas.LineTo(799, (data2[x] and e)*15 div e + 20*i+4);
          end
          else
          begin
            x:=0;
            x_position:=0.0;
            f:=e div 256;
            Image2.Canvas.MoveTo(0, (data3[0] and f)*15 div f + 20*i+4);
            repeat
              Inc(x);
              x_position:=x_position+old_x_increment;
              xp:=Round(x_position);
              if data3[x-1] <> data3[x] then
              begin
                Image2.Canvas.LineTo(xp, (data3[x-1] and f)*15 div f + 20*i+4);
                Image2.Canvas.LineTo(xp, (data3[x] and f)*15 div f + 20*i+4);
              end;
            until xp>=798;
            Image2.Canvas.LineTo(799, (data3[x] and f)*15 div f + 20*i+4);
          end
        end;
        e:=e*2;
       end;
    end;
{
    for i:=0 to 800 do
      spi_buf[0].buf[i]:=2;

    spi_buf[0].endidx:=0;
    spi_buf[0].posidx:=spi_buf[0].endidx+1;
    SPI_BurstRead2Buffer (0,2,801);

    for i:=0 to 799 do
      data2[i]:=spi_buf[0].buf[i+1];

    for i:=0 to 800 do
      spi_buf[0].buf[i]:=3;

    spi_buf[0].endidx:=0;
    spi_buf[0].posidx:=spi_buf[0].endidx+1;
    SPI_BurstRead2Buffer (0,3,801);

    for i:=0 to 799 do
      data3[i]:=spi_buf[0].buf[i+1];
}
    SPI_Read(0,2);
    for i:=0 to 799 do
      data2[i]:=SPI_Read(0,2);

    SPI_Read(0,3);
    for i:=0 to 799 do
      data3[i]:=SPI_Read(0,3);


    OldLogicAnalyzerChannels:=LogicAnalyzerChannels;
    e:=1;
    for i:=0 to 9 do
    begin
      if (OldLogicAnalyzerChannels and e)>0 then
      begin
        if i<8 then
          begin
            x:=0;
            x_position:=0.0;
            Image2.Canvas.MoveTo(0, (data2[0] and e)*15 div e + 20*i+4);
            repeat
              Inc(x);
              x_position:=x_position+x_increment;
              xp:=Round(x_position);
              if data2[x-1] <> data2[x] then
              begin
                Image2.Canvas.LineTo(xp, (data2[x-1] and e)*15 div e + 20*i+4);
                Image2.Canvas.LineTo(xp, (data2[x] and e)*15 div e + 20*i+4);
              end;
            until xp>=798;
            Image2.Canvas.LineTo(799, (data2[x] and e)*15 div e + 20*i+4);
          end
          else
          begin
            x:=0;
            x_position:=0.0;
            f:=e div 256;
            Image2.Canvas.MoveTo(0, (data3[0] and f)*15 div f + 20*i+4);
            repeat
              Inc(x);
              x_position:=x_position+x_increment;
              xp:=Round(x_position);
              if data3[x-1] <> data3[x] then
              begin
                Image2.Canvas.LineTo(xp, (data3[x-1] and f)*15 div f + 20*i+4);
                Image2.Canvas.LineTo(xp, (data3[x] and f)*15 div f + 20*i+4);
              end;
            until xp>=798;
            Image2.Canvas.LineTo(799, (data3[x] and f)*15 div f + 20*i+4);
          end
      end;
      e:=e*2;
     end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var a:byte;
begin
  Timer1.enabled:=false;
  a:=SPI_Read(0,$82);          // check if data ready
  if a=2 then
  begin
    DisplayADCData;
    DispalyLogicAnalyzerData;
    new:=false;
    old_x_increment:=x_increment;
    SPI_Write(0,0,$81);       // reset and start new acquisition
  end;
  Timer1.enabled:=true;
end;


end.
