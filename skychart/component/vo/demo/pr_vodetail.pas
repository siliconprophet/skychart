unit pr_vodetail;

{$MODE Delphi}

{                                        
Copyright (C) 2005 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}
{
 Detail of catalog for the Virtual Observatory interface.
}

interface

uses 
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, cu_radec, LResources, Buttons;

type

  { Tf_vodetail }

  Tf_vodetail = class(TForm)
    DefSize: TEdit;
    DefMag: TEdit;
    Grid: TStringGrid;
    Label10: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    MainPanel: TPanel;
    RadioGroup1: TRadioGroup;
    Table: TLabel;
    Rows: TLabel;
    tn: TEdit;
    tr: TEdit;
    desc: TMemo;
    ep: TEdit;
    sys: TEdit;
    eq: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    co: TCheckBox;
    Button1: TButton;
    RaDec1: TRaDec;
    RaDec2: TRaDec;
    Label4: TLabel;
    Label5: TLabel;
    RaDec3: TRaDec;
    Label6: TLabel;
    maxrow: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    FirstRow: TEdit;
    procedure GetData(Sender: TObject);
    procedure coClick(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FGetData: TNotifyEvent ;
  public
    { Public declarations }
    SelectAll: boolean;
    property onGetData: TNotifyEvent read FGetData write FGetData;
  end;

implementation



procedure Tf_vodetail.GetData(Sender: TObject);
begin
if assigned(FGetData) then FGetData(self);
end;

procedure Tf_vodetail.coClick(Sender: TObject);
begin
   co.checked:=radec1.enabled;
end;

procedure Tf_vodetail.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Column,Row,i : integer;
    mark : string;
begin
grid.MouseToCell(X, Y, Column, Row);
if (row>0)and(Column=0) then begin
   if grid.Cells[Column,Row]='' then mark:='x'
      else mark:='';
   grid.Cells[Column,Row]:=mark;
end;
if (row=0)and(Column=0) then begin
   SelectAll:=not SelectAll;
   if SelectAll then mark:='x'
      else mark:='';
   for i:=1 to grid.RowCount-1 do
      grid.Cells[0,i]:=mark;
end;
end;

initialization
  {$i pr_vodetail.lrs}

end.
