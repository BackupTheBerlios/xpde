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
unit uLNKProperties;

interface

uses
  SysUtils, QStdCtrls, QControls,
  uXPAPI, uXPAPI_imp,Math,
  QGraphics, QExtCtrls, QComCtrls,
  uLNKFile, uQXPComCtrls, uXPStyleConsts,
  Classes, QForms, QDialogs,
  uChangeIcon, uSysListItem, Libc,
  uXPdeconsts;

type
  TLNKPropertiesDlg = class(TForm)
    edComment: TEdit;
        Label24:TLabel;
        ComboBox1:TComboBox;
        Label23:TLabel;
        Label22:TLabel;
    edStartin: TEdit;
        Label21:TLabel;
    edTargetLocation: TEdit;
    edTarget: TEdit;
        Label19:TLabel;
        Label18:TLabel;
        Label17:TLabel;
        Label16:TLabel;
    edFilename: TEdit;
    imgIcon: TImage;
        Panel3:TPanel;
        Button6:TButton;
        CheckBox2:TCheckBox;
        CheckBox1:TCheckBox;
        Label14:TLabel;
        Label13:TLabel;
    edAccessed: TEdit;
        Label12:TLabel;
    edModified: TEdit;
        Label11:TLabel;
    edCreated: TEdit;
        Label10:TLabel;
        Label9:TLabel;
    edSizeOnDisk: TEdit;
        Label8:TLabel;
    edSize: TEdit;
        Label7:TLabel;
    edLocation: TEdit;
        Label6:TLabel;
        Label5:TLabel;
        Button5:TButton;
    edDescription: TEdit;
        Label4:TLabel;
        Image2:TImage;
        Panel2:TPanel;
    edTypeOfFile: TEdit;
        Label3:TLabel;
        Label2:TLabel;
    edCaption: TEdit;
        Label1:TLabel;
    imgShort: TImage;
        Panel1:TPanel;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
    btnCancel: TButton;
    btnOk: TButton;
        TabSheet1:TTabSheet;
    Button10: TButton;
    btnChangeIcon: TButton;
    Button12: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    procedure btnOkClick(Sender: TObject);
    procedure btnChangeIconClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    filename:string;
    iconfile:string;
    selected:TSysListItem;
    procedure fillproperties(const linkfile:string);
    procedure saveproperties;
  end;

var
  LNKPropertiesDlg: TLNKPropertiesDlg;

procedure ShowLinkProperties(const linkfile:string;aselected:TSysListItem);

implementation

uses uDesktopMain;

{$R *.xfm}

procedure ShowLinkProperties(const linkfile:string;aselected:TSysListItem);
begin
    with TLNKPropertiesDlg.create(application) do begin
            selected:=aselected;
            imgIcon.picture.assign(aselected.original);
            imgShort.picture.assign(aselected.original);
            pagecontrol1.ActivePageIndex:=1;
            fillproperties(linkfile);
            show;
    end;
end;

{ TLNKPropertiesDlg }
procedure TLNKPropertiesDlg.fillproperties(const linkfile: string);
var
    lnk: TLNKFile;
    a1: extended;
    a2: extended;
    buf: TStatBuf;
    st: string;
    function formatfilesize(size:extended):string;
    begin
        result:=formatfloat('###,###,###,###,###,###',trunc(size));
    end;
    function formatsize(size:extended):string;
    var
        kfs:extended;
    begin
        if size>1024 then begin
            if (size>1024*1024) then begin
                kfs:=size / (1024*1024);
                result:=formatfilesize(kfs)+' MB';
            end
            else begin
                kfs:=size / 1024;
                result:=formatfilesize(kfs)+' KB';
            end;
        end
        else begin
            result:=formatfilesize(size)+' bytes';
        end;
        result:=result+' ('+formatfilesize(size)+' bytes)';
    end;
begin
    ThousandSeparator:=',';
    DecimalSeparator:='.';
    lnk:=TLNKFile.create(nil);
    try
        filename:=linkfile;
        lnk.loadfromfile(linkfile);
        iconfile:=lnk.Icon;
        edFilename.Text:=changefileext(extractfilename(linkfile),'');
        edTargetLocation.text:=extractfilepath(lnk.Command);
        if edTargetLocation.text='' then begin
            edTargetLocation.text:=lnk.startin;
        end;
        edTarget.text:=lnk.command;
        edStartin.text:=lnk.startin;
        edComment.text:=lnk.comment;
        //**************************************
        edTypeOfFile.text:=gShortCut;
        edLocation.text:=extractfilepath(linkfile);
        stat(PChar(linkfile),buf);
        //**********************************
        a1:=buf.st_size;
        a2:=buf.st_blksize;
        edSize.text:=formatsize(a1);
        edSizeOnDisk.text:=formatsize(ceil(a1/a2)*a2);

        st:=ctime(@buf.st_ctime);
        st:=copy(st,1,length(st)-1);
        edCreated.text:=st;

        st:=ctime(@buf.st_mtime);
        st:=copy(st,1,length(st)-1);
        edModified.text:=st;

        st:=ctime(@buf.st_atime);
        st:=copy(st,1,length(st)-1);
        edAccessed.text:=st;
        //**********************************
    finally
        lnk.free;
    end;
end;

procedure TLNKPropertiesDlg.btnOkClick(Sender: TObject);
begin
    saveProperties;
    close;
end;


procedure TLNKPropertiesDlg.saveproperties;
var
    lnk: TLNKFile;
begin
    lnk:=TLNKFile.create(nil);
    try
        lnk.loadfromfile(filename);
        lnk.icon:=iconfile;
        lnk.command:=edTarget.text;
        lnk.startin:=edStartin.text;
        lnk.comment:=edComment.text;
        lnk.savetofile(filename);
        selected.loadImageFromFile(lnk.icon);
        selected.invalidate;
    finally
        lnk.free;
    end;
end;
procedure TLNKPropertiesDlg.btnChangeIconClick(Sender: TObject);
var
    f:TPicture;
    b:TBitmap;
begin
    with TChangeIconDlg.create(application) do begin
        try
            iconfilename:=iconfile;
            icondir:=extractfilepath(iconfile);
            if showmodal=mrOk then begin
                iconfile:=iconfilename;

                f:=TPicture.create;
                try
                   f.LoadFromFile(iconfile);
                   f.Graphic.Width:=32;
                   f.Graphic.Height:=32;
                   imgicon.height:=33;
                   imgshort.height:=33;
                   imgicon.Picture.Bitmap.width:=32;
                   imgicon.Picture.Bitmap.height:=33;
                   imgshort.Picture.Bitmap.width:=32;
                   imgshort.Picture.Bitmap.height:=33;

                   imgicon.Picture.Bitmap.Canvas.Brush.Color:=clFuchsia;
                   imgicon.Picture.Bitmap.Canvas.pen.Color:=clFuchsia;
                   imgicon.Picture.Bitmap.Canvas.rectangle(0,0,32,33);
                   imgicon.Transparent:=false;
                   imgicon.Picture.Bitmap.Canvas.Draw(0,0,f.graphic);

                   b:=TBitmap.create;
                   try
                       b.loadfromfile(XPAPI.getSysInfo(siSystemDir)+gSHORTCUT);
                       b.transparent:=false;
                       imgicon.picture.bitmap.canvas.draw(0,imgicon.picture.bitmap.height-b.height-1,b);
                   finally
                       b.free;
                   end;

                   imgicon.Transparent:=true;
                finally
                    f.free;
                end;
                imgshort.Picture.assign(imgicon.Picture.Bitmap);
            end;
        finally
            free;
        end;
    end;
end;
procedure TLNKPropertiesDlg.FormShow(Sender: TObject);
begin
    left:=(screen.width-clientwidth) div 2;
    top:=(screen.height-clientheight) div 2;
end;

procedure TLNKPropertiesDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    action:=cafree;
end;

procedure TLNKPropertiesDlg.btnCancelClick(Sender: TObject);
begin
    close;
end;

end.
