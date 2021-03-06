unit pu_config_pictures;

{$MODE Delphi}{$H+}

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

interface

uses
  u_help, u_translation, u_constant, u_util, cu_fits, cu_database, UScaleDPI,
  fu_config_pictures, LCLIntf, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, FileUtil, StdCtrls, ComCtrls, ExtCtrls, Buttons, enhedits,
  LResources, EditBtn, LazHelpHTML_fix;

type

  { Tf_configpictures }

  Tf_configpictures = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    f_config_pictures1: Tf_config_pictures;
    Panel2: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang;
  end;

implementation

{$R *.lfm}

procedure Tf_configpictures.SetLang;
begin
  Caption := rsPictures;
  Button1.Caption := rsOK;
  Button2.Caption := rsApply;
  Button3.Caption := rsCancel;
  Button4.Caption := rsHelp;
  SetHelp(self, hlpCfgPict);
end;

procedure Tf_configpictures.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
end;

procedure Tf_configpictures.FormShow(Sender: TObject);
begin
  f_config_pictures1.init;
end;

procedure Tf_configpictures.Button2Click(Sender: TObject);
begin
  if assigned(f_config_pictures1.onApplyConfig) then
    f_config_pictures1.onApplyConfig(f_config_pictures1);
end;

procedure Tf_configpictures.Button4Click(Sender: TObject);
begin
  ShowHelp;
end;

procedure Tf_configpictures.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  f_config_pictures1.lock;
end;

end.
