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
unit uXPPopupMenu;

interface

uses
  SysUtils, Types, Classes,
  QGraphics, QControls, QForms,
  QDialogs, QTypes, QMenus, Qt;


type
  TXPPopupMenu = class(TPopupMenu)
  private
//    f:TForm;
    FBackBitmap: TBitmap;
    FOnHide: TNotifyEvent;
    procedure PopupEvent(Sender: TObject);
    procedure SetBackBitmap(const Value: TBitmap);
    procedure SetOnHide(const Value: TNotifyEvent);
    { Private declarations }
  protected
    { Protected declarations }
    procedure HideHook; cdecl;
    procedure HookEvents;override;
  public
    { Public declarations }
    px,py:integer;
    procedure Popup(X, Y: Integer); override;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    { Published declarations }
    property BackBitmap:TBitmap read FBackBitmap write SetBackBitmap;
    property OnHide:TNotifyEvent read FOnHide write SetOnHide;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('XPde', [TXPPopupMenu]);
end;

{ TXPPopupMenu }

{
function TXPPopupMenu.WidgetFlags: Integer;
begin
  Result := inherited WidgetFlags or Integer(WidgetFlags_WRepaintNoErase);
end;
}

constructor TXPPopupMenu.Create(AOwner: TComponent);
begin
  inherited;
  FBackBitmap:=TBitmap.create;
  QFrame_setFrameStyle(handle,Integer(QFrameShape_StyledPanel) or Integer(QFrameShadow_Raised));
end;

destructor TXPPopupMenu.Destroy;
begin
  FBackBitmap.free;
  inherited;
end;

procedure TXPPopupMenu.HideHook;
begin
    if assigned(FOnHide) then FOnHide(self);    
end;

procedure TXPPopupMenu.HookEvents;
var
  Method: TMethod;
begin
  QPopupMenu_aboutToHide_Event(Method) := HideHook;
  QPopupMenu_hook_hook_aboutToHide(QPopupMenu_hookH(Hooks), Method);
  inherited;
end;

procedure TXPPopupMenu.Popup(X, Y: Integer);
begin
  px:=x;
  py:=y;
  OnPopup:=PopupEvent;
//  QWidget_setCursor(self.handle,XPAPI.defaultcursor);
  inherited;
//  f.free;
end;

procedure TXPPopupMenu.PopupEvent(Sender: TObject);
(*
var
    widget: TBitmap;
    back:TBitmap;
    i:integer;
*)
begin
//This code is to produce the fade effect when the menu it's shown, but it has some
//flickering I couldn't remove 
(*
    widget:=TBitmap.create;
    back:=TBitmap.create;
    f:=TForm.create(nil);
    try
        QPopupMenu_updateItem(self.handle,0);
        widget.width:=QWidget_width(self.handle);
        widget.height:=QWidget_height(self.handle);
        back.width:=widget.width;
        back.height:=widget.height;
        QPixmap_grabWidget(widget.handle,self.Handle,0,0,widget.width,widget.height);
        QPixmap_grabWindow(back.handle,QWidget_winId(application.Desktop),px,py,back.Width,back.Height);
        f.BorderIcons:=[];
        f.FormStyle:=fsStayOnTop;
        f.BorderStyle:=fbsNone;
        f.Left:=px;
        f.top:=py;
        f.width:=widget.width;
        f.height:=widget.height;
        f.bitmap.assign(back);
        f.show;
        i:=30;
        while i>1 do begin
            MergeBitmaps(widget,back,f.bitmap,i);
            f.Repaint;
            dec(i,4);
        end;
        f.Bitmap.assign(widget);
        f.Repaint;
    finally
        back.free;
        widget.free;
    end;
*)
end;

procedure TXPPopupMenu.SetBackBitmap(const Value: TBitmap);
begin
  FBackBitmap.assign(Value);
end;

procedure TXPPopupMenu.SetOnHide(const Value: TNotifyEvent);
begin
  FOnHide := Value;
end;

end.
