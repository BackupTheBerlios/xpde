{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003, Valeriy Gabrusev <g_valery@ukr.net>                           }
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

unit uAddUserWizard;

interface

uses
  Libc, SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QExtCtrls, QComCtrls, uXPStyle, uXPPNG;

type
  TNewUser = class(TForm)
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    Panel2: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    InpUser: TEdit;
    Label2: TLabel;
    TabSheet2: TTabSheet;
    RadioGroup1: TRadioGroup;
    rbtnStdUser: TRadioButton;
    rbtnGuestUser: TRadioButton;
    rbtnOtherUser: TRadioButton;
    grpComboBox: TComboBox;
    Image1: TImage;
    XPStyle1: TXPStyle;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbtnOtherUserClick(Sender: TObject);
    procedure rbtnGuestUserClick(Sender: TObject);
    procedure InpUserChange(Sender: TObject);
  private
    { Private declarations }
    DefaultShell : string;
    DefaultGroup : string;
    procedure MakeGroupList;
  public
    { Public declarations }
    Added : boolean;
//    NewUserRecord : PPasswordRecord;
  end;

var
  NewUser: TNewUser;

implementation

uses uXPuserUtils, uResString;
{$R *.xfm}

procedure TNewUser.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TNewUser.btnNextClick(Sender: TObject);
begin
  if PageControl.ActivePageIndex = 0 then
    if getpwnam(PChar(InpUser.Text)) = nil then begin
     PageControl.SelectNextPage(True);
     btnBack.Enabled := True;
     btnNext.Caption := sMsg4;
    end
    else ShowMessage(sMsg5)
  else begin

   if rbtnStdUser.Checked then begin
      DefaultShell := DefaultShell_1;
      DefaultGroup := DefaultGroup_1;
   end;

   if rbtnGuestUser.Checked then begin
       DefaultShell := DefaultShell_2;
       DefaultGroup := DefaultGroup_2;
   end;

   if rbtnOtherUser.Checked  then begin
       DefaultShell := DefaultShell_1;
       DefaultGroup := grpComboBox.Text;
   end;

   if InpUser.Text <> '' then
        if CommandAddUser(InpUser.Text, IntToStr(getgrnam(PChar(DefaultGroup))^.gr_gid),
            DefaultShell) = 0 then begin
          Added := true;
          Close;
        end
           else ShowMessage(sMsg6);
  end;
end;

procedure TNewUser.btnBackClick(Sender: TObject);
begin
  if PageControl.ActivePageIndex = 1 then begin
     PageControl.SelectNextPage(False);
     btnBack.Enabled := False;
     btnNext.Caption := sMsg7;
  end;
end;


procedure TNewUser.MakeGroupList;

var
  GroupItem : PGroup;
  i : byte;
begin
 setgrent();
 i := 1;
 GroupItem := nil;
 repeat
  GroupItem := getgrent();
  if getgrent <> nil then  grpComboBox.Items.Add(GroupItem.gr_name);
 until GroupItem = nil;
 grpComboBox.Text := grpComboBox.Items.Strings[0];
 endgrent();
end;

procedure TNewUser.FormShow(Sender: TObject);
begin
 PageControl.ActivePageIndex := 0;
 InpUser.Text := '';
 btnBack.Enabled := False;
 btnNext.Caption := sMsg7;
 btnNext.Enabled := False;
 MakeGroupList;
 grpComboBox.Enabled := False;
 Added := false;
 ActiveControl := InpUser;
end;

procedure TNewUser.rbtnOtherUserClick(Sender: TObject);
begin
  grpComboBox.Enabled := True;
end;

procedure TNewUser.rbtnGuestUserClick(Sender: TObject);
begin
  grpComboBox.Enabled := False;
end;

procedure TNewUser.InpUserChange(Sender: TObject);
begin
  if InpUser.Text <> '' then
       btnNext.Enabled := True
    else
       btnNext.Enabled := False;
end;


end.
