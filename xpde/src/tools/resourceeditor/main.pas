{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 José León Serna <ttm@xpde.com>                           }
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
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OpenFile(const filename:string);
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

uses uResourceFileFrm;

{$R *.xfm}

procedure TMainForm.Open1Click(Sender: TObject);
begin
    if OpenDialog.execute then begin
        OpenFile(OpenDialog.filename);
   end;
end;

procedure TMainForm.OpenFile(const filename: string);
begin
    with TResourceFileFrm.create(application) do begin
        loadfromfile(filename);
    end;
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
