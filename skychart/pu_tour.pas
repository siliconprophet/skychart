unit pu_tour;

{
Copyright (C) 2015 Patrick Chevalley

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

{$mode objfpc}{$H+}

interface

uses
  u_translation, LCLType, UScaleDPI, u_speech,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tf_tour }

  Tf_tour = class(TForm)
    BtnPrev: TButton;
    BtnNext: TButton;
    BtnEnd: TButton;
    BtnFirst: TButton;
    BtnLast: TButton;
    BtnSlew: TButton;
    Sound: TCheckBox;
    TourName: TLabel;
    ObjectName: TLabel;
    procedure BtnEndClick(Sender: TObject);
    procedure BtnFirstClick(Sender: TObject);
    procedure BtnLastClick(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnPrevClick(Sender: TObject);
    procedure BtnSlewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    { private declarations }
    FClosing: boolean;
    FFirst, FLast, Fprev, Fnext, Fslew: TNotifyEvent;
    procedure SetLang;
  public
    { public declarations }
    property onFirst: TNotifyEvent read FFirst write FFirst;
    property onLast: TNotifyEvent read FLast write FLast;
    property onPrev: TNotifyEvent read Fprev write Fprev;
    property onNext: TNotifyEvent read Fnext write Fnext;
    property onSlew: TNotifyEvent read Fslew write Fslew;
  end;

var
  f_tour: Tf_tour;

implementation

{$R *.lfm}

{ Tf_tour }

procedure Tf_tour.SetLang;
begin
  Caption := rsTour;
  Sound.Caption := rsActivateVoic;
  BtnEnd.Caption := rsEnd;
  BtnFirst.Caption := rsFirst;
  BtnLast.Caption := rsLast;
  BtnSlew.Caption := rsSlew;
  u_speech.setlang;
end;

procedure Tf_tour.FormCreate(Sender: TObject);
begin
  ScaleDPI(Self);
  SetLang;
  FClosing:=false;
end;

procedure Tf_tour.BtnFirstClick(Sender: TObject);
begin
  if Assigned(FFirst) then
    FFirst(self);
  if Sound.Checked then
    speak(ObjectName.Caption);
end;

procedure Tf_tour.BtnEndClick(Sender: TObject);
begin
  Close;
end;

procedure Tf_tour.BtnLastClick(Sender: TObject);
begin
  if Assigned(FLast) then
    FLast(self);
  if Sound.Checked then
    speak(ObjectName.Caption);
end;

procedure Tf_tour.BtnNextClick(Sender: TObject);
begin
  if Assigned(Fnext) then
    Fnext(self);
  if Sound.Checked then
    speak(ObjectName.Caption);
end;

procedure Tf_tour.BtnPrevClick(Sender: TObject);
begin
  if Assigned(Fprev) then
    Fprev(self);
  if Sound.Checked then
    speak(ObjectName.Caption);
end;

procedure Tf_tour.BtnSlewClick(Sender: TObject);
begin
  if Assigned(Fslew) then
    Fslew(self);
  if Sound.Checked then
    speak(rsSlew);
end;

procedure Tf_tour.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=true;
  FClosing:=true;
end;

procedure Tf_tour.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  case Key of
    VK_F, VK_HOME: BtnFirstClick(nil);
    VK_L, VK_END: BtnLastClick(nil);
    VK_I: if Sound.Checked then
        speak(ObjectName.Caption);
    VK_N, VK_RIGHT, VK_DOWN, VK_NEXT:
    begin
      BtnNextClick(nil);
      if Shift = [ssCtrl] then
        BtnSlewClick(nil);
    end;
    VK_P, VK_LEFT, VK_UP, VK_PRIOR:
    begin
      BtnPrevClick(nil);
      if Shift = [ssCtrl] then
        BtnSlewClick(nil);
    end;
    VK_S:
    begin
      if Shift = [ssCtrl] then
        BtnSlewClick(nil);
    end;
    VK_TAB: BtnSlewClick(nil);
  end;
end;

procedure Tf_tour.FormDeactivate(Sender: TObject);
begin
  if not FClosing then begin
   // try to keep form focused to react to keyboard command
   SetFocus;
   BringToFront;
  end;
end;

end.
