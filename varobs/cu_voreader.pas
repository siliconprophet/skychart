unit cu_voreader;

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
{
 Virtual Observatory XML data reader
}

{$mode objfpc}{$H+}

interface

uses DOM, XMLRead, Classes, SysUtils;

type
  TUseField = array of boolean;

  TVO_Reader = class(TComponent)
  private
    oDoc: TXMLDocument;
    oRESOURCE, CurrentRow: TDOMNode;
    FResourceDescription, FTableDescription: string;
    Ffieldname, Ffielducd, Ffielddatatype, Ffieldunit, Ffieldref, Ffielddesc: TStringList;
    FFieldcount: integer;
    FUseField: array of boolean;
    Feof: boolean;
    procedure OpenTable(TABLE: TDOMNode);
    procedure OpenData(Data: TDOMNode);
  protected
  public
    function OpenVO(vofile: string; tablename: string = ''): boolean;
    procedure CloseVO;
    function ReadVORow(row: TStringList): boolean;
    property ResourceDescription: string read FResourceDescription;
    property TableDescription: string read FTableDescription;
    property Fieldcount: integer read FFieldcount;
    property UseField: TUseField read FUseField write FUseField;
    property FieldName: TStringList read FFieldName;
    property FieldUCD: TStringList read FFieldUCD;
    property FieldDataType: TStringList read FFieldDataType;
    property FieldUnit: TStringList read FFieldUnit;
    property FieldRef: TStringList read FFieldRef;
    property FieldDesc: TStringList read FFieldDesc;
    property EOF: boolean read FEOF;
  published
  end;

implementation

function TVO_Reader.OpenVO(vofile: string; tablename: string = ''): boolean;
var
  i: integer;
begin
  feof := True;
  FFieldcount := 0;
  ReadXMLFile(oDoc, vofile);
  ffieldname := TStringList.Create;
  ffielducd := TStringList.Create;
  ffielddatatype := TStringList.Create;
  ffieldunit := TStringList.Create;
  ffieldref := TStringList.Create;
  ffielddesc := TStringList.Create;
  oRESOURCE := oDoc.DocumentElement.FirstChild;
  while Assigned(oRESOURCE) do
  begin
    with oRESOURCE.ChildNodes do
      try
        for i := 0 to (Count - 1) do
        begin
          if Item[i].NodeName = 'DESCRIPTION' then
            fResourceDescription := string(Item[i].TextContent);
          if Item[i].NodeName = 'TABLE' then
          begin
            if (tablename = '') or
              (string(Item[i].Attributes.GetNamedItem('name').NodeValue) = tablename) then
            begin
              OpenTable(Item[i]);
              break;
            end;
          end;
        end;
      finally
        Free;
      end;
    if not feof then
      break;
    oRESOURCE := oRESOURCE.NextSibling;
  end;
  Result := not feof;
  SetLength(FUseField, FFieldcount);
  for i := 0 to FFieldcount - 1 do
    FUseField[i] := True;
end;

procedure TVO_Reader.CloseVO;
begin
  feof := True;
  FFieldcount := 0;
  CurrentRow.Free;
  oRESOURCE.Free;
  oDoc.Free;
  ffieldname.Free;
  ffielducd.Free;
  ffielddatatype.Free;
  ffieldunit.Free;
  ffieldref.Free;
  ffielddesc.Free;
end;

procedure TVO_Reader.OpenTable(TABLE: TDOMNode);
var
  i: integer;
begin
  with TABLE.ChildNodes do
    try
      for i := 0 to (Count - 1) do
      begin
        if Item[i].NodeName = 'DESCRIPTION' then
          fTableDescription := string(Item[i].TextContent);
        if Item[i].NodeName = 'FIELD' then
        begin
          Inc(FFieldcount);
          if Item[i].Attributes.GetNamedItem('name') = nil then
            ffieldname.Add('')
          else
            ffieldname.Add(string(Item[i].Attributes.GetNamedItem('name').NodeValue));
          if Item[i].Attributes.GetNamedItem('ucd') = nil then
            ffielducd.Add('')
          else
            ffielducd.Add(string(Item[i].Attributes.GetNamedItem('ucd').NodeValue));
          if Item[i].Attributes.GetNamedItem('datatype') = nil then
            ffielddatatype.Add('')
          else
            ffielddatatype.Add(string(Item[i].Attributes.GetNamedItem(
              'datatype').NodeValue));
          if Item[i].Attributes.GetNamedItem('unit') = nil then
            ffieldunit.Add('')
          else
            ffieldunit.Add(string(Item[i].Attributes.GetNamedItem('unit').NodeValue));
          if Item[i].Attributes.GetNamedItem('ref') = nil then
            ffieldref.Add('')
          else
            ffieldref.Add(string(Item[i].Attributes.GetNamedItem('ref').NodeValue));
          if Item[i].FindNode('DESCRIPTION') = nil then
            ffielddesc.Add('')
          else
            ffielddesc.Add(string(Item[i].FindNode('DESCRIPTION').TextContent));
        end;
        if Item[i].NodeName = 'DATA' then
        begin
          OpenData(Item[i]);
          break;
        end;
      end;
    finally
      Free;
    end;
end;

procedure TVO_Reader.OpenData(Data: TDOMNode);
var
  i: integer;
begin
  with Data.ChildNodes do
    try
      for i := 0 to (Count - 1) do
      begin
        if Item[i].NodeName = 'TABLEDATA' then
          CurrentRow := Item[i].FirstChild;
        feof := (CurrentRow = nil);
        break;
      end;
    finally
      Free;
    end;
end;

function TVO_Reader.ReadVORow(row: TStringList): boolean;
var
  i: integer;
begin
  row.Clear;
  if CurrentRow = nil then
  begin
    Result := False;
    feof := True;
  end
  else
  begin
    with CurrentRow.ChildNodes do
      try
        for i := 0 to (Count - 1) do
        begin
          if FUseField[i] then
            row.Add(string(Item[i].TextContent));
        end;
      finally
        Free;
      end;
    CurrentRow := CurrentRow.NextSibling;
    Result := row.Count > 0;
  end;
end;

end.
