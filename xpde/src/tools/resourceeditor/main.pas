{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002                                                          }
{ José León Serna <ttm@xpde.com>                                              }
{ Jens Kühner <jens@xpde.com>                                                 }
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

unit main;

interface

uses
  uResourceFileFrm,
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, uResourceAPI,
  QDialogs, QStdCtrls, QMenus,
  QComCtrls, QExtCtrls, uResources;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog: TOpenDialog;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog: TSaveDialog;
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
  private
    { Private declarations }
    ResourceFileFrm : TResourceFileFrm;
    procedure OpenFile(const filename:string);
    procedure SaveFile(const filename:string);
  public
    { Public declarations }
  end;

  //Framework API
  TResourceAPI=class(TInterfacedObject,IResourceAPI)
  private
        editors:TStringList;
  public
        //Register a resource editor to be used
        procedure registerEditor(const resourcetype:string;const editorclass:TResourceEditorClass);
        //Calls a registered editor for an entry
        function callEditor(const entry:TResourceEntry): TResourceEditor;

        constructor Create;
        destructor Destroy;override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.xfm}

procedure TMainForm.Open1Click(Sender: TObject);
begin
    if OpenDialog.execute then begin
        OpenFile(OpenDialog.filename);
   end;
end;

procedure TMainForm.Saveas1Click(Sender: TObject);
var
  strFileName : string;
begin
    if assigned(ResourceFileFrm) then begin
       strFileName := OpenDialog.filename;
       SaveDialog.InitialDir := extractFilePath(strFileName);
       SaveDialog.FileName   := '_'+extractFilename(strFileName);
       if SaveDialog.execute then
          SaveFile(SaveDialog.filename);
    end else begin
       application.messagebox('No resource file opened!');
   end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
   close;
end;

procedure TMainForm.OpenFile(const filename: string);
var
  i : integer;
begin
    ResourceFileFrm.free;

    ResourceFileFrm := TResourceFileFrm.create(application);
    ResourceFileFrm.loadfromfile(filename);
end;

procedure TMainForm.SaveFile(const filename: string);
begin
    ResourceFileFrm.savetofile(filename);
end;

{ TResourceAPI }

function TResourceAPI.callEditor(const entry: TResourceEntry): TResourceEditor;
var
    restype: string;
    edclass: TResourceEditorClass;
    index: integer;
begin
    result:=nil;

    //Get the resource type
    restype:=entry.sresourcetype;
    if restype='' then restype:=ResourceTypeToString(entry.resourcetype);

    //Finds the editor class
    index:=editors.IndexOf(ansilowercase(restype));
    if index<>-1 then begin
        //Creates the editor
        edclass:=TResourceEditorClass(editors.objects[index]);
        result:=edclass.create;

        //Calls the editor
        result.edit(entry);
    end;
end;

constructor TResourceAPI.Create;
begin
    inherited;
    editors:=TStringList.create;
end;

destructor TResourceAPI.Destroy;
begin
    editors.free;
    inherited;
end;

procedure TResourceAPI.registerEditor(const resourcetype: string; const editorclass: TResourceEditorClass);
begin
    editors.addobject(ansilowercase(resourcetype),TObject(editorclass));
end;


initialization
    ResourceAPI:=TResourceAPI.create;

end.
