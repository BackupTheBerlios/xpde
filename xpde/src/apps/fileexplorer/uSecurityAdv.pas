{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003, Valeriy Gabrusev <valery@xpde.com>                      }
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

unit uSecurityAdv;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QComCtrls, uXPuserUtils, QImgList;

type
  TSecurityDlg = class(TForm)
    btnCancel: TButton;
    btnApply: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edOwner: TEdit;
    lstUser: TListView;
    chRecursive: TCheckBox;
    btnOk: TButton;
    ImageList1: TImageList;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstUserItemClick(Sender: TObject; Button: TMouseButton;
      Item: TListItem; const Pt: TPoint; ColIndex: Integer);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private declarations }
    DataPath : string;
    ChownResult : boolean;
    procedure ChangeOwner;
  public
    { Public declarations }
  end;

var
  SecurityDlg: TSecurityDlg;

function RunSecurityAdvDlg(CurOwner :string; PathToChange :string) : boolean;

implementation

{$R *.xfm}

function RunSecurityAdvDlg(CurOwner :string; PathToChange :string) : boolean;
begin
 with TSecurityDlg.Create(Application) do begin
  ChownResult := False;
  DataPath := PathToChange;
  edOwner.Text := CurOwner;
  Showmodal;
  Result := ChownResult;
 end;
end;

//******************************************************************************


procedure TSecurityDlg.FormCreate(Sender: TObject);
 var
   i : integer;
   TempUserStr : TStringList;
begin
 TempUserStr := TStringList.Create;
 lstUser.Items.BeginUpdate;
 lstUser.Items.Clear;
 MakeUserList(TempUserStr, true);
 for i:=0 to  TempUserStr.Count -1 do
  with lstUser.Items.Add do begin
  ImageIndex := 0;
  Caption := TempUserStr.Strings[i];
  end;
 lstUser.Items.EndUpdate;
 TempUserStr.Free;
end;

procedure TSecurityDlg.lstUserItemClick(Sender: TObject;
  Button: TMouseButton; Item: TListItem; const Pt: TPoint;
  ColIndex: Integer);
begin
  edOwner.Text := lstUser.Selected.Caption;
  btnApply.Enabled := True;
end;

//******************************************************************************

procedure TSecurityDlg.ChangeOwner;
 var
  NewOwner : string;
  commstr : string;
begin
 NewOwner := edOwner.Text;
 if CommandChown(DataPath, NewOwner, chRecursive.Checked) <> 0 then begin
      ChownResult := false;
      ShowMessage('Error Change Owner for ' + DataPath);
      btnApply.Enabled := False;
 end
    else ChownResult := true;

{ may be rewrite later
   setpwent();
   PasswdItem := nil;
   PasswdItem := getpwnam(PChar(OwnerStr));
   endpwent();
   if chown(PChar(DataName), PasswdItem^.pw_uid, PasswdItem^.pw_gid) <> 0 then
      ShowMessage('Error Change Owner for ' + DataName);
 end }

end;

procedure TSecurityDlg.btnOkClick(Sender: TObject);
begin
 if btnApply.Enabled then ChangeOwner;
 Close;
end;

procedure TSecurityDlg.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TSecurityDlg.btnApplyClick(Sender: TObject);
begin
 ChangeOwner;
end;

end.
