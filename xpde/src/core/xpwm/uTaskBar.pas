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
unit uTaskBar;

interface

uses
  Xlib,SysUtils, Types, 
  Classes, Variants, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QMenus,
  QTypes, Libc, QExtCtrls,
  uSpecial, QComCtrls, QImgList,
  uXPStyleConsts, Qt, QActnList,
  uQXPComCtrls, uXPPopupMenu, uRun,
  uXPAPI, uLNKFile, uXPStyle,
  uXPLocalizator, uXPDictionary;

type
  TTaskBar = class(TForm)
    pnTimer: TPanel;
    Timer: TTimer;
    btnTimer: TTimer;
    tbTasks: TToolBar;
    Panel1: TPanel;
    btnStart: TBitBtn;
    topPanel: TPanel;
    pbLine: TPaintBox;
    Timer1: TTimer;
    startmenu: TXPPopupMenu;
    Programs1: TMenuItem;
    Documents1: TMenuItem;
    Settings1: TMenuItem;
    Search1: TMenuItem;
    HelpandSupport1: TMenuItem;
    Run1: TMenuItem;
    N7: TMenuItem;
    LogOffAdministrator1: TMenuItem;
    TurnOffComputer1: TMenuItem;
    imgProgramFolder: TImage;
    ImageList1: TImageList;
    XPDictionary1: TXPDictionary;
    XPLocalizator1: TXPLocalizator;
    propertiesmenu: TXPPopupMenu;
    Toolbars1: TMenuItem;
    N1: TMenuItem;
    CascadeWindows1: TMenuItem;
    TileWindowsHorizontally1: TMenuItem;
    TileWindowsVertically1: TMenuItem;
    ShowtheDesktop1: TMenuItem;
    N2: TMenuItem;
    TaskManager1: TMenuItem;
    N3: TMenuItem;
    LocktheTaskbar1: TMenuItem;
    Properties1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btnStartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnTimerTimer(Sender: TObject);
    procedure pbLinePaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure startmenuHide(Sender: TObject);
    procedure LogOffAdministrator1Click(Sender: TObject);
    procedure Run1Click(Sender: TObject);
    procedure TaskManager1Click(Sender: TObject);
  private
    menupaths: TStringList;
    procedure OnMenuItemClick(Sender: TObject);
    procedure populateMenu(item: TMenuItem; dir: string);
    { Private declarations }
  public
    { Public declarations }
    activetasks:TList;                                                          //TToolButton list for active tasks    
    //Menu related functions
    procedure ShowMenu;
    procedure createTask(w:TWindow;title:string);
  end;

  TXPTaskBar=class(TInterfacedObject, IXPTaskBar)
        procedure addtask(task:IWMClient);
        procedure removetask(task:IWMClient);
  end;

var
  TaskBar: TTaskBar;
  lastevent: integer=0;
  lastw:TWindow=0;
  inupdate: boolean=false;

implementation

{$R *.xfm}

function GetTickCount:integer;
var
  T: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  T := TV.tv_sec;
  localtime_r(@T, UT);
  Result := UT.tm_sec;
end;

procedure TTaskBar.FormCreate(Sender: TObject);
var
    b:TBitmap;
begin
    XPAPI.setdefaultcursor;

    //*****************************************************
    btnStart.Glyph.LoadFromFile(XPAPI.getsysinfo(siSystemDir)+sSTARTBUTTON);
    imgProgramFolder.picture.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sPROGRAMFOLDER);
    startmenu.backbitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sSTARTMENU);
    //*****************************************************
    Programs1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sPROGRAMS);
    Documents1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sDOCUMENTS);
    b:=TBitmap.create;
    try
        b.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sSETTINGS);
        Settings1.bitmap.assign(b);
    finally
        b.free;
    end;
    Search1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sSEARCH);
    HelpandSupport1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sHELPANDSUPPORT);
    Run1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sRUN);
    LogOffAdministrator1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sLOGOFF);
    TurnOffComputer1.bitmap.loadfromfile(XPAPI.getsysinfo(siSystemDir)+sTURNOFF);
    //*****************************************************


    menuPaths:=TStringList.create;
    LogOffAdministrator1.caption:=LogOffAdministrator1.caption+' '+XPAPI.getsysinfo(siUserName)+'...';

    populatemenu(programs1,XPAPI.getsysinfo(siUserDir)+'/.xpde/Start Menu/Programs');

    activetasks:=TList.create;
    tbTasks.buttonheight:=22;
    tbTasks.buttonwidth:=163;


    //Shows the current time
    TimerTimer(Timer);

    //Initial Taskbar Position
    left:=0;
    height:=28;
    top:=screen.Height-height;
    width:=screen.width;

end;

procedure TTaskBar.FormPaint(Sender: TObject);
begin
    with canvas do begin
        //Taskbar's top line
        pen.color:=dclBtnHighlight;
        moveto(0,1);
        lineto(clientwidth,1);
    end;
end;

procedure TTaskBar.TimerTimer(Sender: TObject);
begin
    pnTimer.Caption:=formatdatetime(sTimeFormat,now)+'     ';
end;

procedure TTaskBar.btnStartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i:integer;
begin
    for I := 0 to tbTasks.ControlCount - 1 do begin
        if (tbTasks.Controls[I] is TToolButton) then begin
            (tbTasks.Controls[I] as TToolButton).Down:=false;
        end;
    end;
    showmenu;
end;

procedure TTaskBar.ShowMenu;
var
    p: TPoint;
begin
        QPopupMenu_updateItem(startmenu.handle,0);
        p:=btnStart.BoundsRect.TopLeft;
        p:=btnStart.ClientToScreen(p);
        p.Y:=p.Y-QWidget_height(startmenu.handle);
        startmenu.popup(p.x-2,p.y-2);
end;


procedure TTaskBar.btnTimerTimer(Sender: TObject);
begin
    QButton_setDown(btnStart.handle,false);
    application.processmessages;
    btnTimer.enabled:=false;
end;

procedure TTaskBar.pbLinePaint(Sender: TObject);
begin
    with pbLine.canvas do begin
        //Taskbar's top line
        pen.color:=dclBtnHighlight;
        moveto(0,1);
        lineto(clientwidth,1);
    end;
end;

procedure TTaskBar.createTask(w:TWindow;title:string);
{
var
    t: TToolButton;
    found: boolean;
    i:integer;
    hints: PXWMHints;
    rr: TWindow;
    xr,yr:integer;
    res:integer;
    wr,hr,br,dr:cardinal;
    b: TBitmap;

    par: TWindow;
}
begin
(*
    found:=false;
    for i := 0 to tbTasks.ControlCount - 1 do begin
        if (tbTasks.Controls[I] is TToolButton) then begin
            t:=(tbTasks.Controls[I] as TToolButton);
            if cardinal(t.tag)=w then begin
                t.caption:=title;
                t.hint:=title;
                activetasks.add(t);
                found:=true;
                break;
            end;
        end;
    end;
    if not found then begin
        t:=TToolButton.create(tbTasks);
        t.Caption:=title;
        t.Hint:=title;
        {
        hints := XGetWMHints (application.display, w);
        if hints<>nil then begin
            if (hints^.icon_window<>0) and (hints^.icon_pixmap<>0) then begin
                b:=TBitmap.create;
                try
                    res:=XGetGeometry(application.Display,hints^.icon_pixmap,@rr,@xr,@yr,@wr,@hr,@br,@dr);
                    if res<>0 then begin
                        wr:=wr+(br*2);
                        hr:=hr+(br*2);
                        b.width:=wr;
                        b.height:=hr;
                        case dr of
                            1: b.Pixelformat:=pf1bit;
                            8: b.Pixelformat:=pf8bit;
                            16: b.PixelFormat:=pf16bit;
                            32: b.PixelFormat:=pf32bit;
                            else b.PixelFormat:=pf32bit;
                        end;
                        QPixmap_grabWindow(b.handle,hints^.icon_pixmap,0,0,wr,hr);
                        t.bitmap.Canvas.StretchDraw(rect(0,0,17,17),b);
                        t.bitmap.transparent:=true;
                        t.bitmap.transparentcolor:=t.Bitmap.canvas.pixels[0,0];
                     end;
                finally
                    b.free;
                end;
            end;
            XFree(hints);
        end;
        }

        t.showhint:=true;
        t.Tag:=w;
        t.allowallup:=true;
        t.grouped:=true;
        t.style:=tbsCheck;
        t.Parent:=tbTasks;
        activetasks.add(t);

    end;
*)    
end;

procedure TTaskBar.FormDestroy(Sender: TObject);
begin
    activetasks.free;
    menuPaths.free;
end;

procedure TTaskBar.ToolButton1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    w:TWindow;
begin
    w:=(Sender as TToolButton).tag;
    XSetInputFocus(application.display,w,RevertToNone,CurrentTime);
    XRaiseWindow(application.display,w);
end;

procedure TTaskBar.startmenuHide(Sender: TObject);
begin
    QButton_setDown(btnStart.handle,false);
    application.processmessages;
end;

procedure TTaskBar.LogOffAdministrator1Click(Sender: TObject);
begin
    application.terminate;
end;

procedure TTaskBar.Run1Click(Sender: TObject);
begin
    showRunDlg;
end;

procedure TTaskBar.OnMenuItemClick(Sender: TObject);
var
    path:string;
begin
    path:=menupaths[(sender as TMenuItem).tag];
    XPAPI.ShellDocument(path);
end;

procedure TTaskBar.populateMenu(item: TMenuItem; dir: string);
var
    sr:TSearchRec;
    d: TMenuItem;
    folders:TStringList;
    files:TStringList;
    i:integer;
    l: TLNKFile;
    iconfile:string;
    ext: string;
    f: TPicture;
begin
    item.Clear;
    folders:=TStringList.create;
    files:=TStringList.create;
    try
        files.sorted:=true;
        folders.sorted:=true;
    if findfirst(dir+'/*',faAnyFile,sr)=0 then begin
        repeat
            if (sr.Attr and faDirectory)=faDirectory then begin
                if (sr.name<>'.') and (sr.name<>'..') then begin
                    folders.add(sr.name);
                end;
            end
            else begin
                    files.add(sr.name);
            end;
        until findnext(sr)<>0;
    end;
    findclose(sr);
        for i:=0 to folders.count-1 do begin
            d:=TMenuItem.create(item);
            d.caption:=folders[i];
            d.Bitmap:=imgProgramFolder.picture.bitmap;
            item.add(d);
            d.Tag:=menupaths.add(dir+'/'+folders[i]);
            populateMenu(d,dir+'/'+folders[i]);
        end;
        for i:=0 to files.count-1 do begin
            d:=TMenuItem.create(item);
            ext:=ansilowercase(extractfileext(files[i]));
            if ext='.lnk' then begin
                l:=TLNKFile.create(nil);
                f:=TPicture.create;
                try
                    l.loadfromfile(dir+'/'+files[i]);
                    if trim(l.caption)<>'' then d.caption:=l.Caption
                    else d.caption:=changefileext(files[i],'');

                    iconfile:=XPAPI.getsysinfo(siSystemDir)+sNOICONSMALL;
                    if trim(l.icon)<>'' then begin
                        if (fileexists(l.icon)) then iconfile:=l.icon
                        else begin
                            if (fileexists(XPAPI.getsysinfo(siSystemDir)+l.Icon)) then begin
                                iconfile:=XPAPI.getsysinfo(siSystemDir)+l.Icon;
                            end
                            else iconfile:=XPAPI.getsysinfo(siSystemDir)+sNOICONSMALL;
                        end;
                    end
                    else begin
                        iconfile:=XPAPI.getsysinfo(siSystemDir)+changefileext(files[i],'.ico');
                        if not fileexists(iconfile) then begin
                            iconfile:=XPAPI.getsysinfo(siSystemDir)+sNOICONSMALL;
                        end;
                    end;
                    
                    try
                        f.LoadFromFile(iconfile);
                        f.graphic.width:=16;
                        f.graphic.height:=16;
                    except
                        iconfile:=XPAPI.getsysinfo(siSystemDir)+sNOICONSMALL;
                        f.LoadFromFile(iconfile);
                        f.graphic.width:=16;
                        f.graphic.height:=16;
                    end;

                    d.bitmap.canvas.brush.color:=clFuchsia;
                    d.bitmap.canvas.pen.color:=clFuchsia;
                    d.Bitmap.width:=16;
                    d.Bitmap.height:=16;
                    if f.graphic.Width>16 then begin
                        d.bitmap.canvas.stretchdraw(rect(0,0,16,16),f.graphic);
                    end
                    else begin
                        d.bitmap.canvas.draw(0,0,f.graphic);
                    end;
                    d.bitmap.transparent:=true;

                finally
                    f.free;
                    l.free;
                end;
            end
            else begin
                d.caption:=changefileext(files[i],'');
            end;
            d.Tag:=menupaths.add(dir+'/'+files[i]);
            d.onclick:=onmenuitemclick;
            item.add(d);
        end;
    finally
        files.free;
        folders.free;
    end;
end;

procedure TTaskBar.TaskManager1Click(Sender: TObject);
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppdir)+'/taskmanager',false);
end;


{ TXPTaskBar }

procedure TXPTaskBar.addtask(task: IWMClient);
begin
    taskbar.createTask(task.getWindow,task.getTitle);
end;

procedure TXPTaskBar.removetask(task: IWMClient);
begin

end;

initialization
  XPTaskBar:=TXPTaskbar.create;
  Application.CreateForm(TTaskBar, TaskBar);
  Application.CreateForm(TRunDlg, RunDlg);


end.
