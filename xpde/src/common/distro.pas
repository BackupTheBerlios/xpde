{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Zeljan Rikalo <zeljko@xpde.com>                          }
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
unit distro;
// FUNCTIONS TO RECOGNIZE DISTRIBUTION AND LOCATE NETWORK CONFIG FILES
interface
uses Libc,SysUtils,xpclasses;

        Function Get_Distro_Version:TUname;
        Function Get_Config_Paths(dist_:integer):TConfInfo;

implementation

function Return_Kernel_Machine(kind:integer):string; // kind 0=kernel version 1=machine
var sis:utsname;
Begin
        Libc.uname(sis);
        case kind of
                0:Result:=sis.release;
                1:Result:=sis.machine;
                else Result:=sis.release;
                End;
End;

function Check_Number(s:string;i:integer;r:single):boolean;
Begin
        if not (TryStrToInt(s,i)) and not (TryStrToFloat(s,r)) then
        Result:=false else
        Result:=true;
End;

Function Get_From_Release(dist_:integer):TUname;
var uname__:TUName;
    fi_rel:TextFile;
    lines:Array[0..50] of string;
    i,j,x,ii,jj:integer;
    ss:string;
    dec_sep:char;
    sis:TUtsName;
Begin
        dec_sep:=DecimalSeparator;
        DecimalSeparator:='.';
        Libc.uname(sis);
        i:=-1;
        case dist_ of
                diRedHat:Begin
                                uname__.dist:=diRedHat;
                                uname__.name:='RedHat';
                                uname__.sys:='Linux';

                                AssignFile(fi_rel,'/etc/redhat-release');
                                Reset(fi_rel);
                                        while not eof(fi_rel) do begin
                                                inc(i);
                                                readln(fi_rel,lines[i]);
                                        End;
                                CloseFile(fi_rel);

                         for j:=0 to i do begin
                                lines[j]:=lines[j]+' ';
                                jj:=length(lines[j]);
                                        for ii:=0 to jj+1 do begin
                                                x:=Pos(' ',lines[j]);
                                                if x <> 0 then begin
                                                ss:=copy(lines[j],1,x-1);
                                                ss:=trim(ss);

                                                lines[j]:=copy(lines[j],x+1,length(lines[j]));
                                                        if Check_Number(ss,0,0) then begin
                                                                uname__.version:=ss;
                                                                break;
                                                        End;
                                                End;
                                        End;
                         End;
                      End; // diRedHat

                diDebian:Begin
                                uname__.dist:=diDebian;
                                uname__.name:='Debian';
                                uname__.sys:='Linux';


                                AssignFile(fi_rel,'/etc/debian_version');
                                Reset(fi_rel);
                                        while not eof(fi_rel) do begin
                                                inc(i);
                                                readln(fi_rel,lines[i]);
                                        End;
                                CloseFile(fi_rel);

                         for j:=0 to i do begin
                                lines[j]:=lines[j]+' ';
                                jj:=length(lines[j]);
                                        for ii:=0 to jj+1 do begin
                                                x:=Pos(' ',lines[j]);
                                                if x <> 0 then begin
                                                ss:=copy(lines[j],1,x-1);
                                                ss:=trim(ss);

                                                lines[j]:=copy(lines[j],x+1,length(lines[j]));
                                                        if Check_Number(ss,0,0) then begin
                                                                uname__.version:=ss;
                                                                break;
                                                        End;
                                                End;
                                        End;
                         End;
                      End; // diDebian

                diLindows:Begin
                                uname__.dist:=diLindows;
                                uname__.name:='Lindows';
                                uname__.sys:='Linux';


                                AssignFile(fi_rel,'/etc/lindowsos-version');
                                Reset(fi_rel);
                                        while not eof(fi_rel) do begin
                                                inc(i);
                                                readln(fi_rel,lines[i]);
                                        End;
                                CloseFile(fi_rel);

                         for j:=0 to i do begin
                                lines[j]:=lines[j]+' ';
                                jj:=length(lines[j]);
                                        for ii:=0 to jj+1 do begin
                                                x:=Pos(' ',lines[j]);
                                                if x <> 0 then begin
                                                ss:=copy(lines[j],1,x-1);
                                                ss:=trim(ss);

                                                lines[j]:=copy(lines[j],x+1,length(lines[j]));
                                                        if Check_Number(ss,0,0) then begin
                                                                uname__.version:=ss;
                                                                break;
                                                        End;
                                                End;
                                        End;
                          End;
                      End; // diLindows

                diSuse:Begin
                                uname__.dist:=diSuse;
                                uname__.name:='Suse';
                                uname__.sys:='Linux';


                                AssignFile(fi_rel,'/etc/SuSE-release');
                                Reset(fi_rel);
                                        while not eof(fi_rel) do begin
                                                inc(i);
                                                readln(fi_rel,lines[i]);
                                        End;
                                CloseFile(fi_rel);

                         for j:=0 to i do begin
                                lines[j]:=lines[j]+' ';
                                jj:=length(lines[j]);
                                        for ii:=0 to jj+1 do begin
                                                x:=Pos(' ',lines[j]);
                                                if x <> 0 then begin
                                                ss:=copy(lines[j],1,x-1);
                                                ss:=trim(ss);

                                                lines[j]:=copy(lines[j],x+1,length(lines[j]));
                                                        if Check_Number(ss,0,0) then begin
                                                                uname__.version:=ss;
                                                                break;
                                                        End;
                                                End;
                                        End;
                          End;
                      End; // diSuse

                diMandrake:Begin
                                uname__.dist:=diMandrake;
                                uname__.name:='Mandrake';
                                uname__.sys:='Linux';

                                AssignFile(fi_rel,'/etc/mandrake-release');
                                Reset(fi_rel);
                                        while not eof(fi_rel) do begin
                                                inc(i);
                                                readln(fi_rel,lines[i]);
                                        End;
                                CloseFile(fi_rel);

                         for j:=0 to i do begin
                                lines[j]:=lines[j]+' ';
                                jj:=length(lines[j]);
                                        for ii:=0 to jj+1 do begin
                                                x:=Pos(' ',lines[j]);
                                                if x <> 0 then begin
                                                ss:=copy(lines[j],1,x-1);
                                                ss:=trim(ss);

                                                lines[j]:=copy(lines[j],x+1,length(lines[j]));
                                                        if Check_Number(ss,0,0) then begin
                                                                uname__.version:=ss;
                                                                break;
                                                        End;
                                                End;
                                        End;
                         End;
                      End; // diMandrake



                 else
                 uname__.dist:=diUnknown;
                End;// Case
                DecimalSeparator:=dec_sep;
                uname__.kernel:=Return_Kernel_Machine(0);
                uname__.machine:=Return_Kernel_Machine(1);
                uname__.krnl_date:=sis.version;
Result:=uname__;
End;


Function Get_Distro:integer;
Begin
    if FileExists('/etc/redhat-release') then
    Result:=diRedHat else
    if FileExists('/etc/SuSE-release') then
    Result:=diSuse else
    if FileExists('/etc/mandrake-release') then
    Result:=diMandrake else
    if FileExists('/etc/debian_version') then
    Result:=diDebian else
    if FileExists('/etc/lindowsos-version') then
    Result:=diLindows else
    Result:=diUnknown;
End;

Function Get_From_Uname(dist_:integer):TUname;
var uname__:TUName;
    sis:Utsname;
Begin
        Libc.uname(sis);
        uname__.dist:=diUnknown;
        uname__.sys:=sis.sysname;
        uname__.version:=sis.version;
        uname__.kernel:=sis.release;
        uname__.machine:=sis.machine;
        uname__.krnl_date:='Unknown';
Result:=uname__;
End;

Function Get_Distro_Version:TUname;
var uname__:TUname;
Begin
        case Get_Distro of
                diUnknown :Begin
                           Result:=Get_From_Uname(diUnknown);
                           // Get info from uname -a
                           End;
                diRedHat  :Begin
                           Result:=Get_From_Release(diRedHat);
                           End;
                diMandrake:Begin
                           End;
                diSuse    :Begin
                           Result:=Get_From_Release(diSuse);
                           End;
                diDebian  :Begin
                           Result:=Get_From_Release(diDebian);
                           End;
                diLindows :Begin
                           Result:=Get_From_Release(diLindows);
                           End;
                diCaldera :Begin
                           uname__.dist:=diUnknown;
                           End;
               diConectiva:Begin
                           uname__.dist:=diUnknown;
                           End;
               diSlackware:Begin
                           uname__.dist:=diUnknown;
                           End;
                else  Result:=uname__;
                End;
End;

Function Get_Config_Paths(dist_:integer):TConfInfo;
var myconfinfo:TConfInfo;
Begin
        case dist_ of
              diRedHat  :Begin
                         myconfinfo.net_conf:='/etc/sysconfig/network_scripts';
                         myconfinfo.ppp_conf:='/etc/ppp';
                         myconfinfo.ifconfig:='/sbin/ifconfig';
                         myconfinfo.route:='/sbin/route';
                         myconfinfo.netstat:='/bin/netstat';
                         End;
              diMandrake:Begin
                         myconfinfo.net_conf:='/etc/sysconfig/network_scripts';
                         myconfinfo.ppp_conf:='/etc/ppp';
                         myconfinfo.ifconfig:='/sbin/ifconfig';
                         myconfinfo.route:='/sbin/route';
                         myconfinfo.netstat:='/bin/netstat';
                         End;

              diSuse    :Begin
                         myconfinfo.net_conf:='/etc/sysconfig/network';
                         myconfinfo.ppp_conf:='/etc/ppp';
                         myconfinfo.ifconfig:='/sbin/ifconfig';
                         myconfinfo.route:='/sbin/route';
                         myconfinfo.netstat:='/bin/netstat';
                         End;

              diLindows :Begin
                         myconfinfo.net_conf:='/etc/network/interfaces';
                         myconfinfo.ppp_conf:='/etc/ppp';
                         myconfinfo.ifconfig:='/sbin/ifconfig';
                         myconfinfo.route:='/sbin/route';
                         myconfinfo.netstat:='/bin/netstat';
                         End;

              diDebian  :Begin
                         myconfinfo.net_conf:='/etc/network/interfaces';
                         myconfinfo.ppp_conf:='/etc/ppp';
                         myconfinfo.ifconfig:='/sbin/ifconfig';
                         myconfinfo.route:='/sbin/route';
                         myconfinfo.netstat:='/bin/netstat';
                         End;

              // else diUnknown -> Set manually paths via some dialog.

        End;
Result:=myconfinfo;
End;

end.
