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

unit uXPuserUtils;

interface

uses Libc, SysUtils, Classes, QDialogs,uXPAPI, uXPAPI_imp, uExplorerUtil;

const
  PasswdFile = '/etc/passwd';
  GroupFile  = '/etc/group';
  Min_Uid = 500; {Min user id, /etc/login.defs }
  RootID = 0;

  AddUserCom ='/usr/sbin/adduser';
  PasswdCom  ='/usr/bin/passwd';
  UserDelCom ='/usr/sbin/userdel';
  UserModCom = '/usr/sbin/usermod';

  ChownCom = '/bin/chown';


  DefaultShell_1 = '/bin/bash';
  DefaultShell_2 = '/bin/nologin';
  DefaultGroup_1 = 'user';
  DefaultGroup_2 = 'nobody';
  HomeDir = '/home';
  SceletonDir = '/etc/skel';


procedure ReadFromPipe(CmdStr: string; DataString:TStringList);

function GetLastUid :integer;

function CommandAddUser(user_name, group_id, def_shell : string) : integer;
function CommandDelUser(user_name : string) : integer;
function ChangeUserPassword(user: string; passtr : string) : integer;
procedure MakeUserList(var UserList :TStringList; flUser :boolean);

function CommandAddGroup(group_id : string) : integer;
function CommandDelGroup(group_id : string) : integer;
function AddUserToGroup(GroupName, UserName : string)  :integer;
function RemoveUserFromGroup(GroupName, UserName: string)  : integer;
procedure MakeGroupList(var GroupList : TStringList);
procedure MakeGroupListForUser(var GroupList :TStringList; UserName : string);


function CommandChown(PathObject :string; NewOwner :string; flRecursive : boolean) :integer;


implementation


procedure ReadFromPipe(CmdStr: string; DataString:TStringList);

const
 LF = ^J; { ASCII linefeed/newline }
 READ_IOMode = 'r'; { read mode from pipe }

 var
 StrArr : array[0..1024] of char;
 F : PIOFile;
 pPipeStr : Pointer;
 s : String;

begin
 DataString.Clear;
// Open a pipe for reading from commands  output
 F := popen(PChar(CmdStr), READ_IOMode);
 if assigned(F)then begin
  repeat
// Read a complete line from the ps output stream
    pPipeStr := fgets(StrArr, 1024, F);
    if Assigned(pPipeStr)then begin
     s := StrPas(pPipeStr);
     if pos(LF, s) > 0 then delete(s, pos(LF, s), 1);
     DataString.Add(s);
    end;
   until not Assigned(pPipeStr);
  pclose(F);
// need read exit error
 end;
end;


//User util ********************************************************************

function ChangeUserPassword(user: string; passtr : string) : integer;
var
 InputStr, OutputStr, ErrOutputStr : string;
begin
 Result := -1;
 Result:= Libc.System(PChar('echo '+passtr+' | '+ PasswdCom + ' --stdin ' + user));
end;


//adduser **********************************************************************

function GetLastUid :integer;
 var
   max_uid : integer;
   Passwd  : PPasswordRecord;
begin
 setpwent();
 max_uid := 0;
 Passwd := nil;
 repeat
  Passwd := getpwent();
  if Passwd <> nil then
    if Passwd^.pw_uid > max_uid then max_uid := Passwd^.pw_uid;
 until Passwd = nil;
 Result := max_uid;
 endpwent();
end;

function CommandAddUser(user_name, group_id, def_shell : string) : integer;
var
 InputStr, OutputStr, ErrOutputStr : string;
begin
 Result := - 1;
 Result:= XPAPI.ShellExecute(AddUserCom +' '+ user_name+' -g ' + group_id + ' -s ' + def_shell, false);
end;

//userdel **********************************************************************

function CommandDelUser(user_name : string) : integer;
var
 OutputStr, ErrOutputStr : string;
begin
 Result := -1;
 Result:= XPAPI.ShellExecute(UserDelCom + ' ' + user_name, false);
end;

procedure MakeUserList(var UserList :TStringList; flUser :boolean);
var
   PasswdItem   : PPasswordRecord;
begin
 setpwent();
 PasswdItem := nil;
 repeat
  PasswdItem := getpwent();
  if PasswdItem <> nil then
   if flUser then UserList.Add(PasswdItem^.pw_name)
      else
       if PasswdItem^.pw_uid >= Min_Uid then UserList.Add(PasswdItem^.pw_name)
 until PasswdItem = nil;
 endpwent();
end;

// Group util ******************************************************************
function CommandAddGroup(group_id : string) : integer;
begin
 Result := -1
end;

//groupdel**********************************************************************
function CommandDelGroup(group_id : string) : integer;
begin
 Result := -1;
// Result:= Libc.system(Pchar());
end;

function AddUserToGroup(GroupName, UserName: string)  : integer;
 var
  GroupList :TStringList;
  GroupStr, commnd : string;
  i : integer;
begin
 Result := -1;
 GroupStr := '';
 GroupList := TStringList.Create;
 MakeGroupListForUser(GroupList, UserName);
 for i:= 0 to GroupList.Count-1 do
  GroupStr := GroupStr+GroupList.Strings[i]+ ',';
 GroupList.Free;
 GroupStr := GroupStr+ GroupName;
 Result:= Libc.system(Pchar(UserModCom +' -G '+GroupStr+' '+ UserName))
end;

function RemoveUserFromGroup(GroupName, UserName: string)  : integer;
 var
  GroupList :TStringList;
  GroupStr, commnd : string;
  i : integer;
begin
 Result := -1;
 GroupStr := '';
 GroupList := TStringList.Create;
 MakeGroupListForUser(GroupList, UserName);
 for i:= 0 to GroupList.Count-1 do begin
  if GroupName <> GroupList.Strings[i] then
       GroupStr := GroupStr+GroupList.Strings[i]+ ',';
 end;
 GroupList.Free;
 GroupStr := Copy(GroupStr, 1, Length(GroupStr)-1);
 Result:= Libc.system(Pchar(UserModCom +' -G '+GroupStr+' '+ UserName))
end;

procedure MakeGroupList(var GroupList : TStringList);
 var
  GroupItem    : PGroup;
begin
 setgrent();
 GroupItem := nil;
 repeat
  GroupItem := getgrent();
  if GroupItem <> nil then GroupList.Add(GroupItem.gr_name)
 until GroupItem = nil;
 endgrent();
end;

procedure MakeGroupListForUser(var GroupList :TStringList; UserName : string);
 var
  GroupItem : PGroup;
begin
 setgrent();
 GroupItem := getgrent();
 repeat
  if GroupItem.gr_name = UserName then GroupList.Add(GroupItem.gr_name);
  while GroupItem.gr_mem^ <> nil do begin
    if (UserName = GroupItem.gr_mem^) AND (GroupItem.gr_name <> UserName)
         then GroupList.Add(GroupItem.gr_name);
    Inc(GroupItem^.gr_mem);
  end;
  GroupItem := getgrent();
 until GroupItem = nil;
 endgrent();
end;

//******************************************************************************

{function CommandChown(PathObject :string; NewOwner :string; flRecursive : boolean) :integer;
 var
  commnd : string;
  OutStr : TStringList;
begin
 Result := -1;
 if not fileExists(ChownCom) then begin
   ShowMessage('Command Chown not fount');
   exit;
 end;
// if OutStr <> nil then OutStr.Free;
// OutStr := TStringList.Create;
 PathObject := removeTrailingSlash(PathObject);
// if not fileExists(ChownCom) then ShowMessage('Command Chown not fount');
 if flRecursive then commnd := ChownCom+' -R '+NewOwner+' '+PathObject
    else commnd := ChownCom+' -R '+NewOwner+' '+PathObject;
 result := Libc.system(PChar(commnd));
// ReadFromPipe(commnd,OutStr);
// ShowMessage(OutStr.Text);
end; }

function CommandChown(PathObject :string; NewOwner :string; flRecursive : boolean) :integer;
 var
  NewOwner_id, Owner_id : cardinal;
  Group_id : cardinal;
  StatBuf  : TStatBuf;
  PassRec  : PPasswordRecord;
  rv : integer;
begin
 Result := -1;
 PathObject := removeTrailingSlash(PathObject);
 rv := lstat(PChar(PathObject), StatBuf);
 setpwent();
 PassRec := getpwuid(StatBuf.st_uid);
 NewOwner_id := getpwnam(PChar(NewOwner)).pw_uid;
 endpwent();

 if (rv = -1) then begin
    ShowMessage( 'Unable to stat file.' );
    exit;
 end;

 Owner_id := StatBuf.st_uid;
 Group_id := StatBuf.st_gid;
 Result := Libc.chown(PChar(PathObject),NewOwner_id,Group_id);
end;

end.
