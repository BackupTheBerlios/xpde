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

uses Libc, SysUtils, QDialogs;

const
  PasswdFile = '/etc/passwd';
  GroupFile  = '/etc/group';
  Min_Uid = 500; {Min user id, /etc/login.defs }
  RootID = 0;

  AddUserCom ='/usr/sbin/adduser';
  PasswdCom  ='/usr/bin/passwd';
  UserDelCom ='/usr/sbin/userdel';


  DefaultShell_1 = '/bin/bash';
  DefaultShell_2 = '/bin/nologin';
  DefaultGroup_1 = 'user';
  DefaultGroup_2 = 'nobody';
  HomeDir = '/home';
  SceletonDir = '/etc/skel';



function GetLastUid :integer;
function CommandAddUser(user_name, group_id, def_shell : string) : integer;
function CommandDelUser(user_name : string) : integer;
function ChangeUserPassword(user: string; passtr : string) : integer;
function CommandAddGroup(group_id : string) : integer;
function CommandDelGroup(group_id : string) : integer;

var
  PasswdItem   : PPasswordRecord;
  GroupItem    : PGroup;
  UserSelected : string;

implementation

//passwd ***********************************************************************

function ChangeUserPassword(user: string; passtr : string) : integer;
var
 InputStr, OutputStr, ErrOutputStr : string;
begin
 Result := -1;
 Result:= Libc.system(PChar('echo '+passtr+' | '+ PasswdCom + ' --stdin ' + user));
end;


//adduser **********************************************************************

function GetLastUid :integer;
 var
   max_uid : integer;
   Passwd : PPasswordRecord;
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
 Result:= Libc.system(Pchar(AddUserCom +' '+ user_name+' -g ' + group_id + ' -s ' + def_shell));
end;

//userdel **********************************************************************

function CommandDelUser(user_name : string) : integer;
var
 OutputStr, ErrOutputStr : string;
begin
 Result := -1;
 Result:= Libc.system(Pchar(UserDelCom + ' ' + user_name));
end;


//addgroup**********************************************************************
function CommandAddGroup(group_id : string) : integer;
begin
 Result := -1
end;

//groupdel**********************************************************************
function CommandDelGroup(group_id : string) : integer;
begin
 Result := -1;
end;


begin
end.
