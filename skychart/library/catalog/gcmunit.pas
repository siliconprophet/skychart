unit gcmunit;
{
Copyright (C) 2000 Patrick Chevalley

http://www.astrosurf.com/astropc
pch@freesurf.ch

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
  skylibcat, sysutils;
type
GCMrec = record ar,de :longint ;
                Rsun,Vt,B_Vt,c,Rc,Rh,muV : smallint;
                id   : array[1..9] of char;
                name : array[1..11] of char;
                SpT  : array[1..4] of char;
                end;
Function IsGCMpath(path : string) : Boolean;
procedure SetGCMpath(path : string);
Procedure OpenGCM(ar1,ar2,de1,de2: double ; var ok : boolean);
Procedure OpenGCMwin(var ok : boolean);
Procedure ReadGCM(var lin : GCMrec; var ok : boolean);
procedure CloseGCM ;

var
  GCMpath : string;

implementation

var
   fgcm : file of GCMrec ;
   curSM : integer;
   SMname : string;
   Sm,nSM : integer;
   SMlst : array[1..2] of integer;
   FileIsOpen : Boolean = false;

Function IsGCMpath(path : string) : Boolean;
begin
result:= FileExists(slash(path)+'01.dat');
end;

procedure SetGCMpath(path : string);
begin
GCMpath:=noslash(path);
end;

Procedure CloseRegion;
begin
{$I-}
if fileisopen then begin
FileisOpen:=false;
closefile(fgcm);
end;
{$I+}
end;

Procedure OpenRegion(S : integer ; var ok:boolean);
var nomreg,nomfich :string;
begin
str(S:2,nomreg);
nomfich:=GCMpath+slashchar+padzeros(nomreg,2)+'.dat';
if not FileExists(nomfich) then begin ; ok:=false ; exit; end;
if fileisopen then CloseRegion;
AssignFile(fgcm,nomfich);
FileisOpen:=true;
SMname:=nomreg;
FileMode:=0;
reset(fgcm);
ok:=true ;
end;

Procedure OpenGCM(ar1,ar2,de1,de2: double ; var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
nSM:=1;
SMlst[1]:=1;
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;

Procedure ReadGCM(var lin : GCMrec; var ok : boolean);
begin
ok:=true;
if eof(fgcm) then begin
  CloseRegion;
  ok:=false
end;
if ok then  Read(fgcm,lin);
end;

procedure CloseGCM ;
begin
curSM:=nSM;
CloseRegion;
end;

Procedure OpenGCMwin(var ok : boolean);
begin
JDCatalog:=jd2000;
curSM:=1;
nSM:=1;
SMlst[1]:=1;
Sm := Smlst[curSM];
OpenRegion(Sm,ok);
end;


end.

 
