{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Theo Lustenberger                                        }
{                                                                             }
{ This program is free software; you can redistribute it and/or               }
{ modify it under the terms of the GNU General Public                         }
{ License as published by the Free Software Foundation; either                }
{ version 2 of the License, or (at your option) any later version.            }
{                                                                             }
{ This program is distributed in the hope that it will be useful,             }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of              }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
{ General Public License for more details.                                    }
{                                                                             }
{ You should have received a copy of the GNU General Public License           }
{ along with this program; see the file COPYING.  If not, write to            }
{ the Free Software Foundation, Inc., 59 Temple Place - Suite 330,            }
{ Boston, MA 02111-1307, USA.                                                 }
{                                                                             }
{ *************************************************************************** }

unit uFileFinder;

interface

uses Classes, Sysutils;

type TFindOptions = (foDir, foName, foContents);
  TFindOptionsSet = set of TFindOptions;

type TFoundEvent = procedure(Sender: TObject; Directory: string; SearchRec: TSearchRec) of object;

type TFoundFiles = class
    Directory: string;
    FileData: TSearchRec;
  end;

type
  TFileFinder = class
  private
    fFindOptions: TFindOptionsSet;
    fStartpath: string;
    fSearch: string;
    fOnFound: TFoundEvent;
    fMemStr: TMemoryStream;

    fNextCount: integer;
  protected

  public
    fFoundList: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    function GetNext(var Path: string; var SearchRec: TSearchRec): boolean;
    procedure FindFiles(Path: string);
    procedure SetSearch(Value: string);
    property FindOptions: TFindOptionsSet read fFindOptions write fFindOptions;
    property Startpath: string read fStartpath write fStartpath;
    property Search: string read fSearch write SetSearch;
    property OnFound: TFoundEvent read fOnFound write fOnFound;
  published
  end;


implementation
uses  Math;

constructor TFileFinder.Create;
begin
  fMemStr := TMemoryStream.Create;
  fFoundList := TStringList.create;
  fFoundList.Sorted := true;
  fFoundList.CaseSensitive := false;
end;

destructor TFileFinder.Destroy;
begin
  fFoundList.Free;
  fMemStr.free;
  inherited;
end;

procedure TFileFinder.Start;
begin
  fFoundList.Clear;
  fNextCount := 0;
  FindFiles(fStartPath);
end;

procedure TFileFinder.SetSearch(Value: string);
begin
  fSearch := Lowercase(Value);
end;

function TFileFinder.GetNext(var Path: string; var SearchRec: TSearchRec): boolean;
begin
  if fNextCount < fFoundList.Count then
  begin
    Path := TFoundFiles(fFoundList.Objects[fNextCount]).Directory;
    SearchRec := TFoundFiles(fFoundList.Objects[fNextCount]).FileData;
  end;
  inc(fNextCount);
  if fNextCount > fFoundList.Count then result := false else result := true;
end;

procedure TFileFinder.FindFiles(Path: string);
var SearchRec: TSearchRec;
  Found: Integer;
  Data: Pchar;
  TempFoundFiles: TFoundFiles;
begin
  if IsPathDelimiter(Path, length(Path)) then Path := copy(Path, 1, length(Path) - 1);
  Found := FindFirst(Path + PathDelim + '*', faAnyFile, SearchRec);
  if Found = 0 then
  begin
    while Found = 0 do
    begin
      if (SearchRec.Attr and faDirectory) = faDirectory then
      begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if Pos(fSearch, LowerCase(SearchRec.Name)) > 0 then
          begin
            if foDir in fFindOptions then
            begin
              TempFoundFiles := TFoundFiles.Create;
              TempFoundFiles.Directory := Path;
              TempFoundFiles.FileData := SearchRec;
              fFoundList.AddObject(Path + PathDelim + SearchRec.Name, TempFoundFiles);
              if assigned(fOnFound) then fOnFound(self, Path, SearchRec);
            end;
          end;
          FindFiles(Path + PathDelim + SearchRec.Name);
        end;
      end
      else
      begin
        if foContents in fFindOptions then
        begin
          fMemStr.LoadFromFile(Path + PathDelim + SearchRec.Name);
          Data := fMemStr.Memory;
        end else Data := nil;
        if ((Pos(fSearch, LowerCase(SearchRec.Name)) > 0) and (foName in fFindOptions)) or
          ((Pos(fSearch, Data) > 0) and (foContents in fFindOptions)) then
        begin
          TempFoundFiles := TFoundFiles.Create;
          TempFoundFiles.Directory := Path;
          TempFoundFiles.FileData := SearchRec;
          fFoundList.AddObject(Path + PathDelim + SearchRec.Name, TempFoundFiles);
          if assigned(fOnFound) then fOnFound(self, Path, SearchRec);
        end;
      end;
      Found := FindNext(SearchRec);
    end;
    FindClose(SearchRec);
  end;

end;

end.

