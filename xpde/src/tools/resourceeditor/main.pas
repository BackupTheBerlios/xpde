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
  QDialogs, QStdCtrls, QMenus, uNew,
  QComCtrls, QExtCtrls, uResources;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog: TOpenDialog;
    StatusBar1: TStatusBar;
    SaveAsItem: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog: TSaveDialog;
    SaveItem: TMenuItem;
    New1: TMenuItem;
    Generatesharedresources: TMenuItem;
    N2: TMenuItem;
    Info1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveAsItemClick(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure GeneratesharedresourcesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Info1Click(Sender: TObject);
  private
    { Private declarations }
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

uses
  uGenerateSharedRes, uRegistry, uGlobals, uAboutDialog;

const
  strREGKEY = 'Software/XPde/ResourceEditor';

procedure TMainForm.FormShow(Sender: TObject);
begin
   with TRegistry.create do begin
       if openkey(strREGKEY, false) then begin
          if valueexists('resbind') then
             g_strResbind := readstring('resbind');
       end;
       free;
   end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   with TRegistry.create do begin
       if openkey(strREGKEY, true) then begin
          writestring('resbind', g_strResbind);
       end;
       free;
   end;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
    if OpenDialog.execute then begin
        with TResourceFileFrm.create(application) do begin
            loadfromfile(OpenDialog.filename);
        end;
   end;
end;

procedure TMainForm.SaveAsItemClick(Sender: TObject);
begin
    if ActiveMDIChild is TResourceFileFrm then begin
       SaveDialog.FileName   := extractFilename((ActiveMDIChild as TResourceFileFrm).filename);
       if SaveDialog.execute then begin
           (ActiveMDIChild as TResourceFileFrm).savetofile(SaveDialog.filename);
       end;
    end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
   close;
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


procedure TMainForm.SaveItemClick(Sender: TObject);
begin
    if ActiveMDIChild is TResourceFileFrm then begin
        (ActiveMDIChild as TResourceFileFrm).save;
    end;
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
    with TNewTranslationDlg.create(application) do begin
        try
            if showmodal = mrOk then
              with TResourceFileFrm.create(application) do begin
                 loadfromfile(ResourceFileName);
              end;

        finally
            free;
        end;
    end;
end;

procedure TMainForm.GeneratesharedresourcesClick(Sender: TObject);
begin
   if self.ActiveMDIChild is TResourceFileFrm and
     (ActiveMDIChild as TResourceFileFrm).resourceFile.IsModified
   then
        showmessage('Resource is not saved!');
   with TGenerateSharedResourcesDlg.create(self) do begin
      if self.ActiveMDIChild is TResourceFileFrm then begin
        edResFile.Text := (self.ActiveMDIChild as TResourceFileFrm).filename;
      end;
      showmodal;
      free;
   end;
end;

procedure TMainForm.Info1Click(Sender: TObject);
begin
   with TAboutDlg.Create(self) do begin
      showmodal;
      free;
   end;
end;

initialization
    ResourceAPI:=TResourceAPI.create;
end.
