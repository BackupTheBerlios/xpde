{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003, Valeriy Gabrusev <g_valery@ukr.net>                              }
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
  Libc, SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls, QImgList, uXPStyle;

type
  TxpdUser = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label1: TLabel;
    btnChpswd: TButton;
    Image2: TImage;
    Label2: TLabel;
    UserListView: TListView;
    btnAdd: TButton;
    btnRem: TButton;
    btnProp: TButton;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    ImageList1: TImageList;
    Image3: TImage;
    Image4: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Image5: TImage;
    Label5: TLabel;
    btnSmbUser: TButton;
    XPStyle1: TXPStyle;
    cbxAllUser: TCheckBox;
    procedure btnPropClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure UserListViewItemDoubleClick(Sender: TObject;
      Item: TListItem);
    procedure btnRemClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnChpswdClick(Sender: TObject);
    procedure btnSmbUserClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UserListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure cbxAllUserClick(Sender: TObject);
  private
    Modify : boolean;
    procedure MakeUserList;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  xpdUser : TxpdUser;

implementation

uses uAddUserWizard, uPropeties, uChangePassw, uXPuserUtils,  uResString;

{$R *.xfm}

procedure TxpdUser.FormShow(Sender: TObject);
begin
  Modify := false;
  MakeUserList;
end;

procedure TxpdUser.MakeUserList;
begin
 setpwent();
 PasswdItem := nil;
 repeat
  PasswdItem := getpwent();
  if PasswdItem <> nil then
   if cbxAllUser.Checked then
    with UserListView.Items.Add do begin
      ImageIndex := 0;
      Caption := PasswdItem^.pw_name;
      SubItems.Add(PasswdItem^.pw_shell);
      SubItems.Add(getgrgid(PasswdItem^.pw_gid)^.gr_name);
    end
      else begin
       if PasswdItem^.pw_uid >= Min_Uid then
         with UserListView.Items.Add do begin
          ImageIndex := 0;
          Caption := PasswdItem^.pw_name;
          SubItems.Add(PasswdItem^.pw_shell);
          SubItems.Add(getgrgid(PasswdItem^.pw_gid)^.gr_name);
         end;
      end;
 until PasswdItem = nil;
 endpwent();
 if UserListView.Items.Count <> 0 then UserListView.Items.Item[0].Selected := true;
end;

procedure TxpdUser.btnAddClick(Sender: TObject);
begin
  NewUser.ShowModal;
  if NewUser.Added then begin
   UserListView.Items.Clear;
   MakeUserList;
  end;
end;

procedure TxpdUser.btnRemClick(Sender: TObject);
var
 index : integer;
begin
 if UserListView.SelCount <> 0 then begin
   if MessageDlg(sMsg1 + UserListView.ItemFocused.Caption,
      mtWarning, [mbYes,mbNo],0, mbNo) = mrYes then begin
       if CommandDelUser(UserListView.ItemFocused.Caption) = 0 then begin
        UserListView.Items.Clear;
        MakeUserList;
      end
       else MessageDlg(sMsg2 + UserListView.ItemFocused.Caption,
            mtError, [mbOk],0, mbOk);
   end;
  end;
end;

procedure TxpdUser.btnPropClick(Sender: TObject);
begin
  if UserListView.SelCount <> 0 then
      RunPropeties(UserListView.ItemFocused.Caption);
end;

procedure TxpdUser.UserListViewItemDoubleClick(Sender: TObject;
  Item: TListItem);
begin
  RunPropeties(UserListView.ItemFocused.Caption);
end;


procedure TxpdUser.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TxpdUser.btnOkClick(Sender: TObject);
begin
//  if   Modify then PasswdList.SavePasswd;
  Close;
end;

procedure TxpdUser.btnApplyClick(Sender: TObject);
begin
 Modify := true;
end;

procedure TxpdUser.btnChpswdClick(Sender: TObject);
begin
  if UserListView.SelCount <> 0 then
    RunChangeUserPasswd(UserListView.ItemFocused.Caption);
end;

procedure TxpdUser.btnSmbUserClick(Sender: TObject);
begin
 // uSmbUsers.ShowModal;
end;


procedure TxpdUser.UserListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  GroupBox1.Caption := sMsg3 + UserListView.ItemFocused.Caption;
end;

procedure TxpdUser.cbxAllUserClick(Sender: TObject);
begin
 UserListView.Items.Clear;
 MakeUserList;
end;

end.
