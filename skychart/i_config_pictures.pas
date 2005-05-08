{
Copyright (C) 2005 Patrick Chevalley

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
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
}

constructor Tf_config_pictures.Create(AOwner:TComponent);
begin
 csc:=@mycsc;
 ccat:=@myccat;
 cshr:=@mycshr;
 cplot:=@mycplot;
 cmain:=@mycmain;
 inherited Create(AOwner);
end;

procedure Tf_config_pictures.FormShow(Sender: TObject);
begin
ShowImages;
end;

procedure Tf_config_pictures.ShowImages;
var save:boolean;
begin
imgpath.text:=cmain.ImagePath;
ImgLumBar.position:=-round(10*cmain.ImageLuminosity);
ImgContrastBar.position:=round(10*cmain.ImageContrast);
ShowImagesBox.checked:=csc.ShowImages;
nimages.caption:=inttostr(cdb.CountImages);
save:=csc.ShowBackgroundImage;
backimg.text:=csc.BackgroundImage;
ShowBackImg.checked:=save;
cmain.NewBackgroundImage:=false;
end;

procedure Tf_config_pictures.imgpathChange(Sender: TObject);
begin
cmain.ImagePath:=imgpath.text;
end;

procedure Tf_config_pictures.BitBtn3Click(Sender: TObject);
begin
{$ifdef mswindows}
  FolderDialog1.Directory:=imgpath.text;
  if FolderDialog1.execute then
     imgpath.text:=FolderDialog1.Directory;
{$endif}
{$ifdef linux }
  f_directory.DirectoryTreeView1.Directory:=imgpath.text;
  f_directory.showmodal;
  if f_directory.modalresult=mrOK then
     imgpath.text:=f_directory.DirectoryTreeView1.Directory;
{$endif}
end;



procedure Tf_config_pictures.ScanImagesClick(Sender: TObject);
begin
screen.cursor:=crHourGlass;
ProgressPanel.visible:=true;
Cdb.ScanImagesDirectory(cmain.ImagePath,ProgressCat,ProgressBar1 );
ShowImagesBox.checked:=true;
screen.cursor:=crDefault;
ProgressPanel.visible:=false;
nimages.caption:=inttostr(cdb.CountImages);
end;

procedure Tf_config_pictures.ImgLumBarChange(Sender: TObject);
begin
cmain.ImageLuminosity:=-ImgLumBar.position/10;
end;

procedure Tf_config_pictures.ImgContrastBarChange(Sender: TObject);
begin
cmain.ImageContrast:=ImgContrastBar.position/10;
end;

procedure Tf_config_pictures.ShowImagesBoxClick(Sender: TObject);
begin
csc.ShowImages:=ShowImagesBox.checked;
end;

procedure Tf_config_pictures.backimgChange(Sender: TObject);
begin
csc.BackgroundImage:=backimg.text;
Ffits.filename:=csc.BackgroundImage;
if Ffits.header.coordinate_valid then begin
  cmain.NewBackgroundImage:=true;
  ShowBackImg.checked:=true;
  backimginfo.caption:=extractfilename(csc.BackgroundImage)+' RA:'+ARtoStr(Ffits.center_ra*rad2deg/15)+' DEC:'+DEtoStr(Ffits.center_de*rad2deg)+' FOV:'+DEtoStr(Ffits.img_width*rad2deg);
end
else begin
  backimginfo.caption:='No picture';
  ShowBackImg.checked:=false;
end;
end;

procedure Tf_config_pictures.BitBtn5Click(Sender: TObject);
var f : string;
begin
f:=expandfilename(backimg.text);
opendialog1.InitialDir:=extractfilepath(f);
opendialog1.filename:=extractfilename(f);
opendialog1.Filter:='FITS Files|*.fit';
opendialog1.DefaultExt:='';
try
if opendialog1.execute then begin
   backimg.text:=opendialog1.FileName;
end;
finally
 chdir(appdir);
end;
end;

procedure Tf_config_pictures.ShowBackImgClick(Sender: TObject);
begin
csc.ShowBackgroundImage:=ShowBackImg.checked;
cmain.NewBackgroundImage:=csc.ShowBackgroundImage;
end;

