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
unit uCreateShortcut;

interface

uses
  SysUtils, Types, Classes,
  uSysListItem, QGraphics, QControls,
  QForms, uXPStyleConsts, QDialogs,
  IniFiles, QStdCtrls, uXPAPI_imp,
  QComCtrls, QExtCtrls, uXPAPI,
  uXPdeconsts;

type
  TCreateShortcutDlg = class(TForm)
        Label6:TLabel;
        Image3:TImage;
        Panel5:TPanel;
    edCaption: TEdit;
        Label5:TLabel;
        Label3:TLabel;
    btnBrowse: TButton;
    edLocation: TEdit;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel3:TPanel;
        Button5:TButton;
    btnCancel: TButton;
    btnNext: TButton;
        Button2:TButton;
    btnBack: TButton;
        Panel1:TPanel;
    pcControl: TPageControl;
        TabSheet3:TTabSheet;
        TabSheet1:TTabSheet;
    odItem: TOpenDialog;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure pcControlPageChanging(Sender: TObject; NewPage: TTabSheet;
      var AllowChange: Boolean);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ax,ay:integer;
  public
    { Public declarations }
  end;

var
  CreateShortcutDlg: TCreateShortcutDlg;

procedure CreateShortCut(x,y:integer);


implementation

uses uDesktopMain;

{$R *.xfm}

procedure CreateShortCut(x,y:integer);
begin
    with TCreateShortCutDlg.create(application) do begin
        ax:=x;
        ay:=y;
        visible:=true;
    end;
end;

procedure TCreateShortcutDlg.btnNextClick(Sender: TObject);
var
    ini:TIniFile;
    fullpath: string;
    d: TSysListItem;
begin
    if pcControl.ActivePageIndex=1 then begin
        fullpath:=XPAPI.getSysInfo(siDesktopDir)+edCaption.text+'.lnk';
        ini:=TIniFile.create(fullpath);
        try
            ini.WriteString('Shortcut','Caption',edCaption.text);
            ini.writeString('Shortcut','Command',edLocation.text);
            ini.writeString('Shortcut','Startin',extractfilepath(edLocation.text));
            d:=mainform.addIcon(edCaption.text,'',fullpath,true);
            if mainform.desktop.aligntogrid then begin
                mainform.desktop.GetAlignedCoords(ax,ay);
            end;
            d.left:=ax;
            d.top:=ay;
            ini.UpdateFile;
            d.savetoregistry;
        finally
            ini.free;
        end;
        close;
    end
    else begin
        edCaption.text:=extractfilename(edLocation.text);
        pcControl.SelectNextPage(true);
        edCaption.setfocus;
    end;
end;

procedure TCreateShortcutDlg.btnBackClick(Sender: TObject);
begin
    pcControl.SelectNextPage(false);
    edLocation.setfocus;
end;

procedure TCreateShortcutDlg.pcControlPageChanging(Sender: TObject;
  NewPage: TTabSheet; var AllowChange: Boolean);
begin
    allowchange:=true;
    case newpage.PageIndex of
        0: begin
            btnBack.enabled:=false;
            btnNext.Caption:=sNextStep;
            caption:=sCreateShortcut;
        end;
        1: begin
            btnBack.enabled:=true;
            btnNext.Caption:=sFinishWizard;
            caption:=sSelectaTitlefortheProgram;
        end;
    end;
end;
procedure TCreateShortcutDlg.btnBrowseClick(Sender: TObject);
begin
    if odItem.Execute then begin
        edLocation.text:=odItem.FileName;
        edCaption.text:=extractfilename(edLocation.text);
    end;
end;

procedure TCreateShortcutDlg.FormShow(Sender: TObject);
begin
    pcControl.ActivePageIndex:=0;
    edCaption.text:='';
    edLocation.text:='';
    edLocation.setfocus;
    left:=(screen.width-clientwidth) div 2;
    top:=(screen.height-clientheight) div 2;
end;

procedure TCreateShortcutDlg.btnCancelClick(Sender: TObject);
begin
    close;
end;

procedure TCreateShortcutDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    action:=caFree;
end;


procedure TCreateShortcutDlg.FormCreate(Sender: TObject);
begin
  image1.Picture.LoadFromFile(XPAPI.getSysInfo(siMiscDir)+gCREATESHORTCUTWIZARD);
  image3.Picture.LoadFromFile(XPAPI.getSysInfo(siMiscDir)+gCREATESHORTCUTWIZARD);
end;

end.
