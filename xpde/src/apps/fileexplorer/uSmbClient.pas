{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Valery Gabrusev <valera@xpde.com>                           }
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

unit uSmbClient;

interface

uses Libc, SysUtils, Classes, QDialogs, uRegistry, uXPAPI, uSelectUser;

const
  smbclientpath = '/usr/bin/smbclient';
  nmblookuppath = '/usr/bin/nmblookup';
  mntsmb  = '/usr/bin/smbmount';
  umntsmb = '/usr/bin/smbumount';


procedure smbLoadUserData(var user: string; var pass: string);

// Samba resourse runtime
function smbmount(const SmbRes: string): integer;
function smbumount(const ResPath: string): integer;
procedure smbScanResourse(SrvName: string; var resCount: integer; var ResName: TStringList);

// Samba workgroup runtime
procedure smbScanWorkgroup(wgName: string; var srvCount: integer; var SrvName: TStringList);

// Samba Network  runtime
procedure smbScanNetwork(var wgCount: integer; var wgName: TStringList);
procedure smbLoadData(var wgroup: string; var user: string; var pass: string);



implementation

procedure smbLoadData(var wgroup: string; var user: string; var pass: string);
var
    reg:TRegistry;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('SmbNetwork',false) then begin
            wgroup :=reg.ReadString('Smbworkgroup');
            user := reg.ReadString('Smbuser');
            pass := reg.ReadString('Smbpassword');
        end
    finally
        reg.Free;
    end;
end;

procedure smbLoadUserData(var user: string; var pass: string);
var
    reg:TRegistry;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('SmbNetwork',false) then begin
            user := reg.ReadString('Smbuser');
            pass := reg.ReadString('Smbpassword');
        end
    finally
        reg.Free;
    end;
end;

procedure regLoadStr(regKey: string; regFild: string; var regData: string);
var
    reg:TRegistry;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey(regKey,false) then regData :=reg.ReadString(regFild);
    finally
        reg.Free;
    end;
end;

//******************************************************************************
//Must be rewrite for not use Libc.System and using pipe
//******************************************************************************
function runSmbClient(cmdstr: string; var dataStr: TStringList) : boolean;
var
 tempdata, tmpfile : string;
begin
 tempdata := XPAPI.getsysinfo(siTempDir);
 tmpfile := tempdata + 'smbtmp';
 cmdstr := smbclientpath+' '+ cmdstr+' > '+tmpfile;
 Libc.System(PChar(cmdstr));
 if not FileExists(tmpfile) then
     raise Exception.Create(
       'Error : Could not execute smbclient !'+#13#10+
       'Check your permissions in the current directory.');
 dataStr.LoadFromFile(tmpfile);
 DeleteFile(tmpfile);
end;

function getIpWorkgroup(wgroup : string) : string;
var
 tempdata, tmpfile : string;
 dataStr : TStringList;
 cmdstr : string;
begin
 tempdata := XPAPI.getsysinfo(siTempDir);
 tmpfile := tempdata + 'nmbtmp';
 cmdstr := nmblookuppath+' '+wgroup+' -M > '+tmpfile;
 dataStr := TStringList.Create;
 Libc.System(PChar(cmdstr));
 if not FileExists(tmpfile) then
     raise Exception.Create(
       'Error : Could not execute nmbclient !'+#13#10+
       'Check your permissions in the current directory.');
 dataStr.LoadFromFile(tmpfile);
 DeleteFile(tmpfile);
 result := copy(dataStr.Strings[1], 1,Pos(' ',dataStr.Strings[1]));
 dataStr.Free;
  { Please use right grammar for TStrings !
Do not call Destroy directly in an application.
Instead, call Free.
Free verifies that the TStrings reference is not nil,
and only then calls Destroy.
        zeljko@xpde.com
}
end;

function smbmount(const SmbRes : string): integer;
var
 cmdstr : string;
begin
// SmbRes must be contains full command string for smbmount
  cmdstr := mntsmb + ' ' + SmbRes;
  result := libc.System(PChar(cmdstr));
end;

function smbumount(const ResPath : string): integer;
var
 cmdstr : string;
begin
  ShowMessage(umntsmb+' '+ResPath);
  result := libc.System(PChar(umntsmb+' '+ResPath));
  ShowMessage(intToStr(result));
end;

//*****************************************************************************

function findkeyword(keyword : string; dataStr : TStringList) : integer;
 var
  i, j, res : integer;
  finish : boolean;
begin
 i := 0;
 j := 0;
 res := -1;
 finish := false;
 repeat
  j := Pos(keyword, dataStr.Strings[i]);
  if j <> 0 then begin
   res := i;
   finish := true;
  end;
  i := i+1;
 until finish OR (i = dataStr.Count);
 result := res;
end;

procedure smbScanResourse(srvName : string; var resCount : integer; var ResName : TStringList);
var
   i : integer;
   cmdstr, tempstr : string;
   smbString : TStringList;
   workgroup, smbuser, smbpassword : string;
begin
 smbString := TStringList.Create;
 smbLoadData(workgroup, smbuser, smbpassword);
 cmdstr := '-L '+ srvName+' -U '+smbuser+'%'+smbpassword+' -N';
 runSmbClient(cmdstr, smbString);
 resCount := 0;
 i := findkeyword('Sharename ', smbString);
 if i > -1 then begin
//  якщо наступний+1 не проб╕л то зчитати назви робочих груп поки не порожн╕й рядок
  while (Trim(smbString.Strings[i+2]) <> '')do begin
    tempstr := Trim(smbString.Strings[i+2]);
    tempstr := copy(tempstr,1,Pos(' ',tempstr));
    tempstr := Trim(tempstr);
    if tempstr[length(tempstr)] <> '$' then
     begin
      ResName.Add(tempstr);
      resCount := resCount + 1;
     end;
    i := i+1;
  end;
 end;
 smbString.Free;
  { Please use right grammar for TStrings !
Do not call Destroy directly in an application.
Instead, call Free.
Free verifies that the TStrings reference is not nil,
and only then calls Destroy.
        zeljko@xpde.com
}
end;

// Samba workgroup runtime
procedure smbScanWorkgroup(wgName : string; var srvCount : integer; var SrvName : TStringList);
 var
   i : integer;
   cmdstr, tempstr : string;
   smbString : TStringList;
   workgroup, smbuser, smbpassword : string;
begin
 smbString := TStringList.Create;
 smbLoadData(workgroup, smbuser, smbpassword);
// Визнначити IP сервер робочо╖ групи: nmblookup [name work group]
 cmdstr := '-L '+  getIpWorkgroup(wgName) +' -U '+smbuser+'%'+smbpassword+' -N';
 runSmbClient(cmdstr, smbString);
 srvCount := 0;
 i := findkeyword('Server ', smbString);
 if i > -1 then begin
//  якщо наступний+1 не проб╕л то зчитати назви робочих груп поки не порожн╕й рядок
  while (Trim(smbString.Strings[i+2]) <> '')do begin
    tempstr := Trim(smbString.Strings[i+2]);
    if Pos(' ',tempstr) <> 0 then tempstr := copy(tempstr,1,Pos(' ',tempstr));
    tempstr := Trim(tempstr);
    srvName.Add(tempstr);
    srvCount := srvCount + 1;
    i := i+1;
   end;
 end;
 smbString.Free;
  { Please use right grammar for TStrings !
Do not call Destroy directly in an application.
Instead, call Free.
Free verifies that the TStrings reference is not nil,
and only then calls Destroy.
        zeljko@xpde.com
}
end;

// Samba NETWORK workgroup runtime
procedure smbScanNetwork(var wgCount : integer; var wgName : TStringList);
 var
   i : integer;
   smbString : TStringList;
   cmdstr, tempstr : string;
   workgroup, smbuser, smbpassword : string;
begin
// Скану╓мо мережу починаючи ╕з сво╓╖ робочо╖ групи
 smbString := TStringList.Create;
 smbLoadData(workgroup, smbuser, smbpassword);
 if workgroup <> '' then begin
  cmdstr := '-L '+ getIpWorkgroup(workgroup)+' -U '+smbuser+'%'+smbpassword;
  runSmbclient(cmdstr, smbString);
  wgCount := 0;
  i := findkeyword('Workgroup', smbString);
  if i > -1 then begin
//  якщо наступний+1 не проб╕л то зчитати назви робочих груп поки не порожн╕й рядок
   while (i+2 < smbString.Count) AND (Trim(smbString.Strings[i+1]) <> '')do begin
     tempstr := Trim(smbString.Strings[i+2]);
     tempstr := copy(tempstr,1,Pos(' ',tempstr));
     tempstr := Trim(tempstr);
     wgName.Add(tempstr);
     wgCount := wgCount + 1;
     i := i+1;
   end;
  end;
 end;
//  else ShowMessage('Workgroup or domain not setting');
 smbString.Free;
  { Please use right grammar for TStrings !
Do not call Destroy directly in an application.
Instead, call Free.
Free verifies that the TStrings reference is not nil,
and only then calls Destroy.
        zeljko@xpde.com
}
end;

end.
