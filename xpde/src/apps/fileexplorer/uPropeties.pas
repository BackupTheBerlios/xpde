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

unit uPropeties;

interface

uses
  Libc, SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls,
  QForms,QDialogs, QStdCtrls, QComCtrls, QExtCtrls, QCheckLst, QImgList,
  uExplorerAPI, uXPAPI, uExplorerUtil;

type
  TPropetiesDlg = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl: TPageControl;
    tbshGeneralFolder: TTabSheet;
    tbshSharingSimpl: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    chbxPrivate: TCheckBox;
    chbxShareFolder: TCheckBox;
    chbxAllowUse: TCheckBox;
    edShareName: TEdit;
    Label1: TLabel;
    tbshSharing: TTabSheet;
    tbshSecurity: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    imgFolder: TImage;
    edPathFolder: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbType: TLabel;
    lbLocation: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    chbReadOnlyFolder: TCheckBox;
    chbHiddenFolder: TCheckBox;
    btnAdvancedFolder: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    btnAdvanced: TButton;
    lvUserList: TListView;
    btnAddUserGroup: TButton;
    btnRemoveUserGroup: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Image2: TImage;
    rbtnDoNotShare: TRadioButton;
    pnShareFolder: TPanel;
    rbtnShareFolderRadioButton2: TRadioButton;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edComment: TEdit;
    rbtnMaximum: TRadioButton;
    rbtnAllowNumber: TRadioButton;
    spedNumAllow: TSpinEdit;
    Label19: TLabel;
    Label20: TLabel;
    btnPermission: TButton;
    btnCaching: TButton;
    Label22: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    lbCreated: TLabel;
    cbxShareName: TComboBox;
    Panel5: TPanel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    chbxAllAllow: TCheckBox;
    chbxReadAllow: TCheckBox;
    chbxWriteAllow: TCheckBox;
    chbxExecAllow: TCheckBox;
    chbxAllDeny: TCheckBox;
    chbxReadDeny: TCheckBox;
    chbxWriteDeny: TCheckBox;
    chbxExecDeny: TCheckBox;
    tbshGeneralFile: TTabSheet;
    edPathFile: TEdit;
    Panel6: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    lbModifiedFile: TLabel;
    lbSizeOnDiskFile: TLabel;
    lbSizeFile: TLabel;
    lbLocationFile: TLabel;
    lbTypeFile: TLabel;
    Panel7: TPanel;
    Label38: TLabel;
    lbCreatedFile: TLabel;
    Label40: TLabel;
    chbxReadOnlyFile: TCheckBox;
    chbxHiddenFile: TCheckBox;
    btnAdvancedFile: TButton;
    Panel8: TPanel;
    Panel9: TPanel;
    imgFileImage: TImage;
    Label41: TLabel;
    lbOpenWith: TLabel;
    Label33: TLabel;
    lbAccessedFile: TLabel;
    imgOpenWith: TImage;
    btnChangeOpen: TButton;
    lbSize: TLabel;
    lbSizeOndisk: TLabel;
    lbContains: TLabel;

    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnChangeOpenClick(Sender: TObject);
    procedure rbtnShareFolderRadioButton2Click(Sender: TObject);
    procedure rbtnDoNotShareClick(Sender: TObject);
    procedure rbtnAllowNumberClick(Sender: TObject);
    procedure rbtnMaximumClick(Sender: TObject);
    procedure chbxShareFolderClick(Sender: TObject);
    procedure chbxReadAllowClick(Sender: TObject);
    procedure chbxReadDenyClick(Sender: TObject);
    procedure chbxWriteAllowClick(Sender: TObject);
    procedure chbxWriteDenyClick(Sender: TObject);
    procedure chbxExecAllowClick(Sender: TObject);
    procedure chbxExecDenyClick(Sender: TObject);
    procedure chbxAllAllowClick(Sender: TObject);
    procedure chbxAllDenyClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure lvUserListItemClick(Sender: TObject; Button: TMouseButton;
      Item: TListItem; const Pt: TPoint; ColIndex: Integer);
    procedure btnAddUserGroupClick(Sender: TObject);
    procedure btnRemoveUserGroupClick(Sender: TObject);
    procedure chbxReadOnlyFileClick(Sender: TObject);
    procedure chbxHiddenFileClick(Sender: TObject);
    procedure btnAdvancedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
     { Private declarations }
    StatBuf: TStatBuf;
    DataName: String;
    OwnerStr, GroupStr : string;
    GroupId : integer;
    flMode : boolean;
    IconIndex : integer;
    OpenIconIndex : integer;

 //real permissions selected object
    atHidden, atSetUID, atSetGID, atSticky : boolean;
    atUserReadOnly, atUserWrite, atUserExecute : boolean;
    atGroupReadOnly, atGroupWrite, atGroupExecute : boolean;
    atOtherReadOnly, atOtherWrite, atOtherExecute : boolean;

    CurSelectOwner, CurSelectGroup, CurSelectOther : boolean;
    DirSize : extended;
    DirCount : longint;

//variable for control change permissions
     mdfHidden, mdfPermission : boolean;

    flAddUserToGroup, flDelUserFromGroup : boolean;

    procedure GetUserGroup;
    procedure GetPermissions;
    function  SetPermissions  : boolean;
    procedure FillProperties;
    procedure FillShareSecurity;
    procedure FillUserList;
    procedure FillPermissions;
    procedure GetOwnerGroup;
    procedure GetDirSize(DataPath :string);
    procedure GetStatInfo;
    procedure AllCheckBox;
    procedure ApplyChange;
    procedure StorePermission;
  public
    { Public declarations }
  end;


//****************************************************************************
// Show propeties dialog ....

procedure RunPropertiesDlg(DataPath : string; IconItem: integer; flFile : boolean);
procedure RunSharingSecurityDlg(DataPath : string);

//****************************************************************************


var
  PropetiesDlg: TPropetiesDlg;
  TempStrList : TStringList;

implementation

uses uOpenWith, uXPuserUtils, uGroupAndUser, uSelectObj,uSecurityAdv, uGroupUserResourse;

{$R *.xfm}


// for File Propeties dialog DataType := true,
// for Folder  Propeties dialog - DataType := False;

procedure RunPropertiesDlg(DataPath : string; IconItem: integer; flFile : boolean);
begin
 with TPropetiesDlg.Create(Application) do begin
   DataName := DataPath;
   flMode := flFile;
   IconIndex := IconItem;
   flAddUserToGroup := False;
   flDelUserFromGroup := False;
   GetStatInfo;
   FillProperties;
   ShowModal;
 end;
end;

procedure RunSharingSecurityDlg(DataPath : string);
begin
 with TPropetiesDlg.Create(Application) do begin
   DataName := DataPath;
   flMode := false;
   FillShareSecurity;
   ShowModal;
 end;
end;


//******************************************************************************

procedure TPropetiesDlg.FillShareSecurity;
var
 PassRec: PPasswordRecord;
 GrpRec: PGroup;
begin
 GetPermissions;
 GetOwnerGroup;
 FillUserList;
 FillPermissions;
                                                                     // for file
 if not flMode then begin
  tbshGeneralFile.TabVisible := False;
  tbshGeneralFolder.TabVisible := False;
  tbshSharingSimpl.TabVisible := True;
  tbshSharing.TabVisible  := False;
  tbshSecurity.TabVisible := True;
  PageControl.ActivePage := tbshGeneralFolder;
  if atUserReadOnly then chbxReadAllow.Checked := true else chbxReadDeny.Checked := true;
  if atUserWrite then chbxWriteAllow.Checked := true else chbxWriteDeny.Checked := true;
  if atUserExecute then chbxExecAllow.Checked := true else chbxExecDeny.Checked := true;
  if chbxReadAllow.Checked AND chbxWriteAllow.Checked AND chbxExecAllow.Checked
   then chbxAllAllow.Checked := true;
  if chbxReadDeny.Checked AND chbxWriteDeny.Checked AND chbxExecDeny.Checked
   then chbxAllDeny.Checked := true;
  mdfPermission := false;
  FillUserList;
 end;
end;

procedure TPropetiesDlg.FillProperties;
var
 Image : TImageList;
 i : integer;
begin
 GetPermissions;
 GetOwnerGroup;
 FillUserList;
 FillPermissions;

//  ReadOlnly and Hidden attributes
//  Attr := SysUtils.FileGetAttr(DataName);
//  if Attr and faHidden <> 0 then  chbxHiddenFile := atHidden
//  chbxHiddenFolder :=
//  chbxReadOnlyFile.Checked  := atUserReadOnly;
                                                                    // for file
 if flMode then begin
   tbshGeneralFile.TabVisible := True;
   tbshGeneralFolder.TabVisible := False;
   tbshSharingSimpl.TabVisible := False;
   tbshSharing.TabVisible  := False;
   tbshSecurity.TabVisible := True;
   PageControl.ActivePage := tbshGeneralFile;

   Image := XPExplorer.getImageList;
   Image.GetBitmap(IconIndex, imgFileImage.Picture.Bitmap);

   edPathFile.Text := ExtractFileName(DataName);
   edPathFile.Modified := False;

   lbLocationFile.Caption := DataName;

// lbOpenWith
// Image.GetBitmap(OpenIconIndex, imgOpenWith.Picture.Bitmap);

 // get the mode (type) of the file or folder
  if (S_ISCHR(StatBuf.st_mode) = true) then lbTypeFile.Caption := 'Character device'
   else if (S_ISBLK(StatBuf.st_mode) = true) then lbTypeFile.Caption := 'Block device'
   else if (S_ISREG(StatBuf.st_mode) = true) then lbTypeFile.Caption := 'Regular file'
   else if (S_ISFIFO(StatBuf.st_mode) = true) then lbTypeFile.Caption := 'FIFO'
   else if (S_ISLNK(StatBuf.st_mode) = true) then lbTypeFile.Caption := 'Symbolic link'
   else if (S_ISSOCK(StatBuf.st_mode ) = true) then lbTypeFile.Caption := 'Socket'
     else lbTypeFile.Caption := 'Unknown...';

// get the time modification, create ... time of the file
   lbModifiedFile.Caption := ctime(Addr(StatBuf.st_mtime));
   lbCreatedFile.Caption := ctime(Addr(StatBuf.st_ctime));
   lbAccessedFile.Caption := ctime(Addr(StatBuf.st_atime));
// get the file size
   lbSizeFile.Caption := IntToStr(StatBuf.st_size);
   lbSizeOnDiskFile.Caption := IntToStr(StatBuf.st_blocks);
  end
   else begin                                                      // for folder
    tbshGeneralFile.TabVisible := False;
    tbshGeneralFolder.TabVisible := True;
    tbshSharingSimpl.TabVisible := True;
    tbshSharing.TabVisible  := False;
    tbshSecurity.TabVisible := True;
    PageControl.ActivePage := tbshGeneralFolder;

    Image := XPExplorer.getImageList;
    Image.GetBitmap(IconIndex, imgFolder.Picture.Bitmap);

    edPathFolder.Text := DataName;
    edPathFolder.Modified := False;

    lbLocation.Caption := DataName;

    if (S_ISDIR(statBuf.st_mode) = true) then lbType.Caption := 'Folder'
          else lbType.Caption := 'Unknown...';

// get the create time of the folder
    lbCreated.Caption := ctime(Addr(statBuf.st_ctime));

//   ShowMessage('');
// get the folder size and count objects
    GetDirSize(DataName);
   end;
end;

//*****************************************************************************

procedure TPropetiesDlg.GetStatInfo;
 var
  rv : integer;
begin
 // get stat info
 rv := lstat(PChar(DataName), StatBuf );
 if (rv = -1) then begin
    ShowMessage( 'Unable to stat file.' );
    exit;
 end;
end;

procedure TPropetiesDlg.GetOwnerGroup;
 var
  PassRec: PPasswordRecord;
  GrpRec: PGroup;

begin
// get the Owner, Group of the file
 setpwent();
 setgrent();
 PassRec := getpwuid(StatBuf.st_uid);
 OwnerStr := passrec.pw_name;
 GrpRec := getgrgid(StatBuf.st_gid);
 GroupStr := grprec.gr_name;
 endgrent();
 endpwent();
end;

procedure TPropetiesDlg.GetPermissions;
var
 perms: Cardinal;
begin
 perms := StatBuf.st_mode;
 if ( perms And S_ISUID <> 0 ) then atSetUID := true;
 if ( perms And S_ISGID <> 0 ) then atSetGID := true;
 if ( perms And S_ISVTX <> 0 ) then atSticky := true;
 if ( perms And S_IRUSR <> 0 ) then atUserReadOnly := true;
 if ( perms And S_IWUSR <> 0 ) then atUserWrite := true;
 if ( perms And S_IXUSR <> 0 ) then atUserExecute := true;
 if ( perms And S_IRGRP <> 0 ) then atGroupReadOnly := true;
 if ( perms And S_IWGRP <> 0 ) then atGroupWrite := true;
 if ( perms And S_IXGRP <> 0 ) then atGroupExecute := true;
 if ( perms And S_IROTH <> 0 ) then atOtherReadOnly := true;
 if ( perms And S_IWOTH <> 0 ) then atOtherWrite := true;
 if ( perms And S_IXOTH <> 0 ) then atOtherExecute := true;
end;

procedure TPropetiesDlg.GetDirSize(DataPath :string);
var
    f: TSearchRec;
begin
 DirSize := 0;
 if Findfirst(DataPath +'*', faHidden or faAnyFile or faSysFile or faDirectory, f) = 0 then begin
  try
   repeat
    if (f.name='.') or (f.name='..') then continue;
    if ((faDirectory and f.Attr)=faDirectory) then begin
     DirCount := DirCount +1;
     GetDirSize(DataPath+f.Name+'/');
    end;
    DirSize := DirSize + f.Size;
    DirCount := DirCount +1;
    lbSize.Caption := formatsize(DirSize);
    lbContains.Caption := IntToStr(DirCount);
    lbSizeOnDisk.Caption := IntToStr(statBuf.st_size);
   until findnext(f) <> 0;
  finally
   findclose(f);
  end;
 end;
end;

procedure TPropetiesDlg.GetUserGroup;
var
  GroupRec : PGroup;
  StrTmp : string;
begin
 setgrent();
 GroupRec := getgrnam(PChar(GroupStr));
 if GroupRec <> nil then begin
  while GroupRec.gr_mem^ <> nil do begin
    StrTmp := GroupRec.gr_mem^;
    Inc(GroupRec^.gr_mem);
    if StrTmp <> OwnerStr then
      with  lvUserList.Items.Add do begin
       Caption := StrTmp;
       SubItems.Add('Group Member '+'('+ GroupStr +')');
      end;
  end;
 end;
 endgrent();
end;

//******************************************************************************

procedure TPropetiesDlg.FillPermissions;
begin
 if  CurSelectOwner then begin
   if atUserReadOnly then chbxReadAllow.Checked := true else chbxReadDeny.Checked := true;
   if atUserWrite then chbxWriteAllow.Checked := true else chbxWriteDeny.Checked := true;
   if atUserExecute then chbxExecAllow.Checked := true else chbxExecDeny.Checked := true;
 end;

 if  CurSelectGroup then begin
   if atGroupReadOnly then chbxReadAllow.Checked := true else chbxReadDeny.Checked := true;
   if atGroupWrite then chbxWriteAllow.Checked := true else chbxWriteDeny.Checked := true;
   if atGroupExecute then chbxExecAllow.Checked := true else chbxExecDeny.Checked := true;
 end;

 if  CurSelectOther then begin
   if atOtherReadOnly then chbxReadAllow.Checked := true else chbxReadDeny.Checked := true;
   if atOtherWrite then chbxWriteAllow.Checked := true else chbxWriteDeny.Checked := true;
   if atOtherExecute then chbxExecAllow.Checked := true else chbxExecDeny.Checked := true;
 end;

 AllCheckBox;
 mdfPermission := false;
end;

procedure TPropetiesDlg.FillUserList;
begin
 lvUserList.Items.Clear;
 with lvUserList.Items.Add do begin
   Caption := OwnerStr;
   SubItems.Add('Owner');
 end;
 GetUserGroup;
 with lvUserList.Items.Add do begin
   Caption := 'Other';
   SubItems.Add('Other users');
 end;
// Selected  Owner
 lvUserList.Items.Item[0].Selected := true;
 CurSelectOwner := True;
 CurSelectGroup := False;
 CurSelectOther := False;
end;

//******************************************************************************

procedure TPropetiesDlg.btnChangeOpenClick(Sender: TObject);
begin
 OpenWithDlg := TOpenWithDlg.create(application);
 OpenWithDlg.Show;
end;

procedure TPropetiesDlg.rbtnShareFolderRadioButton2Click(Sender: TObject);
begin
 pnShareFolder.Enabled := True;
end;

procedure TPropetiesDlg.rbtnDoNotShareClick(Sender: TObject);
begin
 pnShareFolder.Enabled := False;
end;

procedure TPropetiesDlg.rbtnAllowNumberClick(Sender: TObject);
begin
 spedNumAllow.Enabled := True;
end;

procedure TPropetiesDlg.rbtnMaximumClick(Sender: TObject);
begin
 spedNumAllow.Enabled := False;
end;

procedure TPropetiesDlg.chbxShareFolderClick(Sender: TObject);
begin
 if chbxShareFolder.Checked then begin
   edShareName.Enabled  := True;
   chbxAllowUse.Enabled := True;
 end
  else begin
   edShareName.Enabled  := False;
   chbxAllowUse.Enabled := False;
  end;
end;

//****************** Permissions**********************************************

procedure TPropetiesDlg.chbxReadAllowClick(Sender: TObject);
begin
 if chbxReadAllow.Checked then chbxReadDeny.Checked := false
     else chbxReadDeny.Checked := true;
 AllCheckBox;
 mdfPermission := true;
end;

procedure TPropetiesDlg.chbxReadDenyClick(Sender: TObject);
begin
 if chbxReadDeny.Checked then chbxReadAllow.Checked := false
     else chbxReadAllow.Checked := true;
 AllCheckBox;
 mdfPermission := true;
end;

procedure TPropetiesDlg.chbxWriteAllowClick(Sender: TObject);
begin
 if chbxWriteAllow.Checked then chbxWriteDeny.Checked := false
      else chbxWriteDeny.Checked := true;
 AllCheckBox;
 mdfPermission := true;
end;

procedure TPropetiesDlg.chbxWriteDenyClick(Sender: TObject);
begin
 if chbxWriteDeny.Checked then chbxWriteAllow.Checked := false
      else chbxWriteAllow.Checked := true;
 AllCheckBox;
 mdfPermission := true;
end;

procedure TPropetiesDlg.chbxExecAllowClick(Sender: TObject);
begin
 if chbxExecAllow.Checked then chbxExecDeny.Checked := false
      else chbxExecDeny.Checked := true;
 AllCheckBox;
 mdfPermission := true;
end;

procedure TPropetiesDlg.chbxExecDenyClick(Sender: TObject);
begin
 if chbxExecDeny.Checked then chbxExecAllow.Checked := false
      else chbxExecAllow.Checked := true;
 AllCheckBox;
 mdfPermission := true;
end;


procedure TPropetiesDlg.AllCheckBox;
begin
  if chbxExecAllow.Checked AND chbxWriteAllow.Checked AND chbxReadAllow.Checked
    then begin
     chbxAllAllow.Checked := true;
     chbxAllDeny.Checked := false;
    end
      else begin
       chbxAllAllow.Checked := false;
      end;
  if chbxExecDeny.Checked AND chbxWriteDeny.Checked AND chbxReadDeny.Checked
    then begin
     chbxAllAllow.Checked := false;
     chbxAllDeny.Checked  := true;
    end
      else begin
        chbxAllDeny.Checked := false;
      end;
end;

procedure TPropetiesDlg.chbxAllAllowClick(Sender: TObject);
begin
 if  chbxAllAllow.Checked then begin
   chbxReadAllow.Checked := true;
   chbxWriteAllow.Checked := true;
   chbxExecAllow.Checked := true;
   chbxAllDeny.Checked := false;
 end;
end;

procedure TPropetiesDlg.chbxAllDenyClick(Sender: TObject);
begin
 if chbxAllDeny.Checked then begin
    chbxReadDeny.Checked := true;
    chbxWriteDeny.Checked := true;
    chbxExecDeny.Checked := true;
    chbxAllAllow.Checked := false;
 end;
end;

procedure TPropetiesDlg.chbxHiddenFileClick(Sender: TObject);
begin
 chbxHiddenFile.Checked := atHidden;
 mdfHidden := true;
end;

procedure TPropetiesDlg.chbxReadOnlyFileClick(Sender: TObject);
begin
 atUserReadOnly := chbxReadOnlyFile.Checked;
 mdfPermission  := true;
end;

function TPropetiesDlg.SetPermissions : boolean;
var
  perms: Cardinal;
  rv: Integer;
begin
 perms := 0;
 StorePermission;
 if atSetUID then perms := perms Or S_ISUID;
 if atSetGID then perms := perms Or S_ISGID;
 if atSticky then perms := perms Or S_ISVTX;
 if atUserReadOnly then perms := perms Or S_IRUSR;
 if atUserWrite then perms := perms Or S_IWUSR;
 if atUserExecute then perms := perms Or S_IXUSR;
 if atGroupReadOnly then perms := perms Or S_IRGRP;
 if atGroupWrite then perms := perms Or S_IWGRP;
 if atGroupExecute then perms := perms Or S_IXGRP;
 if atOtherReadOnly then perms := perms Or S_IROTH;
 if atOtherWrite then perms := perms Or S_IWOTH;
 if atOtherExecute then perms := perms Or S_IXOTH;
 rv := chmod( PChar(DataName), perms );
 if ( rv = -1 ) then begin
   ShowMessage( 'Unable to chmod file.' );
   Result := False;
 end
  else    Result := True;
end;

procedure TPropetiesDlg.StorePermission;
begin
  if CurSelectOwner then begin
   atUserReadOnly := chbxReadAllow.Checked;
   atUserWrite    := chbxWriteAllow.Checked;
   atUserExecute  := chbxExecAllow.Checked;
  end;
  if CurSelectGroup then begin
   atGroupReadOnly := chbxReadAllow.Checked;
   atGroupWrite    := chbxWriteAllow.Checked;
   atGroupExecute  := chbxExecAllow.Checked;
  end;
  if CurSelectOther then begin
   atOtherReadOnly := chbxReadAllow.Checked;
   atOtherWrite    := chbxWriteAllow.Checked;
   atOtherExecute  := chbxExecAllow.Checked;
  end;
end;

procedure TPropetiesDlg.lvUserListItemClick(Sender: TObject; Button: TMouseButton;
          Item: TListItem; const Pt: TPoint; ColIndex: Integer);
begin
  StorePermission;
  if lvUserList.Selected.Caption = OwnerStr then begin
   chbxReadAllow.Checked  := atUserReadOnly;
   chbxWriteAllow.Checked := atUserWrite;
   chbxExecAllow.Checked  := atUserExecute;
   CurSelectOwner := True;
   CurSelectGroup := False;
   CurSelectOther := False;
  end;

  if ((lvUserList.Selected.Caption <> OwnerStr)  AND (lvUserList.Selected.Caption <> 'Other')) then begin
   chbxReadAllow.Checked := atGroupReadOnly;
   chbxWriteAllow.Checked := atGroupWrite;
   chbxExecAllow.Checked := atGroupExecute;
   CurSelectOwner := False;
   CurSelectGroup := True;
   CurSelectOther := False;
  end;

  if lvUserList.Selected.Caption = 'Other' then begin
   chbxReadAllow.Checked := atOtherReadOnly;
   chbxWriteAllow.Checked := atOtherWrite;
   chbxExecAllow.Checked := atOtherExecute;
   CurSelectOwner := False;
   CurSelectGroup := False;
   CurSelectOther := True;
  end;
  AllCheckBox;
end;


//*****************************************************************************

procedure TPropetiesDlg.btnAddUserGroupClick(Sender: TObject);
var
 i : byte;
 ObjType : string;
begin
 ObjType := objtypestr1;
 RunSelectObjDlg(ObjType, MemberListStr);
  if MemberListStr.Count <> 0 then begin
   for i := 0 to MemberListStr.Count-1 do begin
    if lvUserList.FindCaption(0, MemberListStr.Strings[i], false, true, false) = nil then  begin
      with lvUserList.Items.Add do begin
        Caption := MemberListStr.Strings[i];
        SubItems.Add('New Group Member '+'('+ GroupStr +')');
      end;
      flAddUserToGroup := True;
    end;
   end;
  end;
end;

procedure TPropetiesDlg.btnRemoveUserGroupClick(Sender: TObject);
begin
 if (lvUserList.Selected.Caption <> OwnerStr)
  AND (lvUserList.Selected.Caption <> 'Other') then begin
    if RemoveUserFromGroup(GroupStr, lvUserList.Selected.Caption) <> 0 then begin
     ShowMessage('ERROR Remove User from Group');
     flDelUserFromGroup := False;
    end
     else flDelUserFromGroup := True;
    FillUserList;
 end;
end;

procedure TPropetiesDlg.btnOkClick(Sender: TObject);
begin
 ApplyChange;
 Close;
end;

procedure TPropetiesDlg.btnApplyClick(Sender: TObject);
begin
 ApplyChange;
end;

procedure TPropetiesDlg.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TPropetiesDlg.btnAdvancedClick(Sender: TObject);
 var
  rv: Integer;
  statbuf: TStatBuf;
  PassRec: PPasswordRecord;
  GrpRec: PGroup;
begin
 if RunSecurityAdvDlg(OwnerStr, DataName) then begin
  GetStatInfo;
  GetOwnerGroup;
  FillUserList;
 end;
end;

procedure TPropetiesDlg.ApplyChange;
 var
  i : integer;
begin
// change permission
 if mdfPermission then begin
   if SetPermissions then begin
     GetStatInfo;
     GetPermissions;
     FillPermissions;
     mdfPermission := false;
   end
    else begin
     GetStatInfo;
     GetPermissions;
     FillPermissions;
     mdfPermission := false;
    end;
 end;

// Rename File
 if edPathFile.Modified then begin
  if RenameFile(DataName, ExtractFilePath(DataName)+ edPathFile.Text) then begin
    DataName := ExtractFilePath(DataName)+ edPathFile.Text;
  end
    else ShowMessage('Do not have permission to modify file name');
 end;

// Rename Folder
// if edPathFolder.Modified then


// if mdfHidden then setHiddenPropeties(chbxHiddenFile.Checked);

// Add or remove member Group
  if flAddUserToGroup then begin
    for i := 0 to MemberListStr.Count-1 do begin
      if AddUserToGroup(GroupStr , MemberListStr.Strings[i]) <> 0 then
         ShowMessage('ERROR Add New Member''s into Group');
    end;
    FillUserList;
    flAddUserToGroup := False;
  end;

//   if flDelUserFromGroup then begin
//    RemoveUserFromGroup(GroupStr , MemberListStr.Strings[i]);;
//    flDelUserFromGroup := False;
//    FillUserList;
//  end;
end;

procedure TPropetiesDlg.FormCreate(Sender: TObject);
begin
 MemberListStr := TStringList.Create;
end;

procedure TPropetiesDlg.FormDestroy(Sender: TObject);
begin
  MemberListStr.Free;
end;

end.
