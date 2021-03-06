unit aavsochart;

{$MODE Delphi}

{
Copyright (C) 2008 Patrick Chevalley

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

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms, UScaleDPI,
  Dialogs, StdCtrls, LResources, u_param, ExtCtrls, u_util2;

type

  { Tchartform }

  Tchartform = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CdromPanel: TPanel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LabelNorth: TLabel;
    LabelMag: TLabel;
    Labelfov: TLabel;
    StarLabel: TLabel;
    ListBox1: TListBox;
    OnlinePanel: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    chartlist: string;
    chartdir: string;
    starname: string;
    chartsource: integer;
    { Public declarations }
  end;

var
  chartform: Tchartform;

implementation

{$R *.lfm}

uses Variables1, settingUnit;

procedure Tchartform.FormShow(Sender: TObject);
var
  i: integer;
  buf1, buf2: string;
begin
  if chartsource = 0 then
  begin // online
    CdromPanel.Visible := False;
    OnlinePanel.Visible := True;
    StarLabel.Caption := starname;
    ComboBox1Change(Sender);
  end
  else
  begin     //cdrom
    OnlinePanel.Visible := False;
    CdromPanel.Visible := True;
    chartdir := slash(chartdir);
    label1.Caption := chartdir;
    Listbox1.Clear;
    buf1 := chartlist;
    i := pos(',', buf1);
    while i > 0 do
    begin
      buf2 := trim(copy(buf1, 1, i - 1));
      buf2 := stringreplace(buf2, '/', PathDelim, [rfReplaceAll]);
      Delete(buf1, 1, i);
      if (copy(buf2, length(buf2) - 3, length(buf2)) <> '.ZIP') then
        Listbox1.items.add(buf2);
      i := pos(',', buf1);
    end;
  end;
end;

procedure Tchartform.ComboBox1Change(Sender: TObject);
begin
  labelfov.Caption := aavsochartfov[ComboBox1.ItemIndex];
  labelmag.Caption := aavsochartmag[ComboBox1.ItemIndex];
  labelnorth.Caption := aavsochartnorth[ComboBox1.ItemIndex];
end;

procedure Tchartform.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
end;

procedure Tchartform.Button2Click(Sender: TObject);
var
  buf: string;
begin
  buf := OptForm.charturl.Text;
  buf := StringReplace(buf, '$star', starname, []);
  buf := StringReplace(buf, '$scale', aavsochartscale[ComboBox1.ItemIndex], []);
  buf := StringReplace(buf, '$fov', aavsochartfov[ComboBox1.ItemIndex], []);
  buf := StringReplace(buf, '$mag', aavsochartmag[ComboBox1.ItemIndex], []);
  buf := StringReplace(buf, '$north', aavsochartnorth[ComboBox1.ItemIndex], []);
  buf := StringReplace(buf, '$east', aavsocharteast[ComboBox2.ItemIndex], []);
  ExecuteFile(buf);
end;

procedure Tchartform.ListBox1Click(Sender: TObject);
begin
  ExecuteFile(chartdir + ListBox1.Items[ListBox1.ItemIndex]);
end;

end.
