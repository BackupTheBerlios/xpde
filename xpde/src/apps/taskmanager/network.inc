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


// network.inc
// I'll include it to uTaskManager.pas after finish this part.
Procedure SRead_Net(netfile:string);
var netstr_:TStrings;
    i,x,j,jj:integer;
    fi:TextFile;
    sbuf,ss:string;
    bytes_in:double;
Begin
        netstr_:=TStringList.Create;
        try
        AssignFile(fi,netfile);
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        netstr_.Add(sbuf);
        End;
        CloseFile(fi);

        for i:=2 to netstr_.Count - 1 do begin
        x:=0;
        j:=pos(':',netstr_.Strings[i]);
        // Find dev names fo Listview
        if j<>0 then begin
   //     dev_names[i-2]:=copy(netstr_.Strings[i],1,j-1);
        netstr_.Strings[i]:=copy(netstr_.Strings[i],j+1,length(netstr_.Strings[i]));
        sbuf:=netstr_.Strings[i]+' ';
        End;

        // INTERESTING POSITIONS FOR US ARE BYTES_IN,BYTES_OUT
        // so we can paint graph with differences
        // Graph will change it's max values, depending of max_bytes_in & max_bytes_out
        for jj:=1 to length(netstr_.Strings[i]) do begin
        sbuf:=trimleft(sbuf);
        j:=pos(' ',sbuf);
        if j<>0 then begin
                inc(x);
                case x of
                        1:Begin
                          ss:=copy(sbuf,1,j-1);
                          sbuf:=copy(sbuf,j+1,length(sbuf));
                          // we fill bytes_in values for each device
                          try
                          bytes_in:=StrToFloat(ss);
                          except
                          bytes_in:=0;
                          End;
//                          writeln('BYTES_IN ',FloatToStrF(bytes_in,ffFixed,16,2),' DIFF NET ',FloatToStrF(diff_net[i,0],ffFixed,16,2));
//                          writeln('BYTES - DIFF ',FloatToStrF(bytes_in-diff_net[i,0],ffFixed,16,2));
                          devs_matrix[i,du_y]:=trunc(bytes_in - diff_net[i,0]);
//                          writeln('DEVICE ',dev_names[i-2],' DEVS_matrix up ',devs_matrix[i,du_y] div 1024);
                          diff_net[i,0]:=bytes_in;
                          End;

                          else
                          sbuf:=copy(sbuf,j+1,length(sbuf));

                        End; // CASE x

        sbuf:=copy(sbuf,j+1,length(sbuf));
        End;

        End; // jj

        End;

                        //  inc(du_y);
                         // if du_y > PB5.Width then
                        //  du_y:=0;


        finally
        netstr_.Free;
        End;
End;

Procedure TWindowsTaskManagerDlg.Read_Net(netfile:string);
var netstr_:TStrings;
    i,x,j,jj:integer;
    fi:TextFile;
    sbuf,ss:string;
    bytes_in,packets_in:double;
Begin
        netstr_:=TStringList.Create;
        try
        AssignFile(fi,netfile);
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        netstr_.Add(sbuf);
        End;
        CloseFile(fi);
        for i:=2 to netstr_.Count - 1 do begin
        // First two lines of /proc/net/dev are ascii text so jump
        // to devices line
        x:=0;
        j:=pos(':',netstr_.Strings[i]);
        // Find dev names fo Listview
        if j<>0 then begin
     //   dev_names[i-2]:=copy(netstr_.Strings[i],1,j-1); // GOES OUT
        net_info[i].device:=copy(netstr_.Strings[i],1,j-1);
        net_info[i].device:=trim(net_info[i].device);
        netstr_.Strings[i]:=copy(netstr_.Strings[i],j+1,length(netstr_.Strings[i])-(j-1));
        sbuf:=netstr_.Strings[i]+' ';
        End;

        for jj:=1 to length(netstr_.Strings[i]) do begin
        sbuf:=trimleft(sbuf);
        j:=pos(' ',sbuf);
        if j<>0 then begin
                inc(x);
                case x of
                        1:Begin
                          ss:=copy(sbuf,1,j-1);
                          ss:=trim(ss);
                          try
                          bytes_in:=StrToFloat(ss);
                          except
                          bytes_in:=0;
                          End;
                          net_info[i].bytes_in:=bytes_in;
                          // THIS IS JUST FOR POPULATING GRAPHS IN TASKMANAGER
                          devs_matrix[i,du_y]:=trunc(bytes_in - diff_net[i,0]);
                        //  writeln('DEVICE ',net_info[i].device,' DEVS_matrix up ',devs_matrix[i,du_y]);
                          diff_net[i,0]:=bytes_in;
                          End;
                        2:Begin
                          ss:=copy(sbuf,1,j-1);
                          ss:=trim(ss);
                          try
                          packets_in:=StrToInt(ss);
                          except
                          packets_in:=0;
                          End;
                          net_info[i].packets_in:=packets_in;
                          End;
                         3:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].errs_in:=StrToInt(ss);
                               except
                               net_info[i].errs_in:=-1;
                               End;
                           End;
                         4:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].drop_in:=StrToInt(ss);
                               except
                               net_info[i].drop_in:=-1;
                               End;
                           End;
                         5:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].fifo_in:=StrToInt(ss);
                               except
                               net_info[i].fifo_in:=-1;
                               End;
                           End;

                         6:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].frame:=StrToInt(ss);
                               except
                               net_info[i].frame:=-1;
                               End;
                           End;

                         7:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].compr_in:=StrToInt(ss);
                               except
                               net_info[i].compr_in:=-1;
                               End;
                           End;


                         8:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].mcast:=StrToInt(ss);
                               except
                               net_info[i].mcast:=-1;
                               End;
                           End;

                         9:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].bytes_out:=StrToFloat(ss);
                               except
                               net_info[i].bytes_out:=-1;
                               End;
                               devs_matrix_out[i,du_y]:=trunc(net_info[i].bytes_out - diff_net_out[i,0]);
//                               writeln('DEVICE ',net_info[i].device,' DEVS_matrix up ',devs_matrix_out[i,du_y]);
                               diff_net_out[i,0]:=net_info[i].bytes_out;
                           End;


                         10:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].packets_out:=StrToFloat(ss);
                               except
                               net_info[i].packets_out:=-1;
                               End;
                           End;

                         11:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].errs_out:=StrToInt(ss);
                               except
                               net_info[i].errs_out:=-1;
                               End;
                           End;

                         12:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].drop_out:=StrToInt(ss);
                               except
                               net_info[i].drop_out:=-1;
                               End;
                           End;

                         13:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].fifo_out:=StrToInt(ss);
                               except
                               net_info[i].fifo_out:=-1;
                               End;
                           End;

                         14:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].colls:=StrToInt(ss);
                               except
                               net_info[i].colls:=-1;
                               End;
                           End;

                         15:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].carrier:=StrToInt(ss);
                               except
                               net_info[i].carrier:=-1;
                               End;
                           End;

                         16:Begin
                               ss:=copy(sbuf,1,j-1);
                               ss:=trim(ss);
                               try
                               net_info[i].compr_out:=StrToInt(ss);
                               except
                               net_info[i].compr_out:=-1;
                               End;
                           End;
                        // else CREATE BUGTRACE !!

                        End; // CASE x

                        Delete(sbuf,1,j);

        End;

        End; // jj

        End;

                          inc(du_y);
                          if du_y > PB5.Width then
                          du_y:=0;
        finally
        netstr_.Free;
        End;
End;

Function Sign_Device(device__:string):string;
var ss:string;
Begin
        if device__='lo' then Result:='Loopback'
        else begin
        ss:=copy(device__,1,3);
        if ss='eth' then Result:='Local Area Network'
        else
        if ss='ppp' then Result:='Modem Connection'
        else
        if ss='ipp' then Result:='ISDN Connection'
        else
        Result:='Unknown Interface';
        End;
End;

Procedure Get_Info_From_Netstat(device:string);
var tmpfile_,cmd,s,sbuf:string;
    tmps:TStrings;
    i,j:integer;
Begin
        tmpfile_:=_get_tmp_fname;
        cmd:='netstat -ine > '+tmpfile_;
        if Libc.system(PChar(cmd))<>0 then
        writeln('ERROR Get_Info_From_Netstat');
        tmps:=TStringList.Create;
        try
        tmps.LoadFromFile(tmpfile_);
        tmps[0]:='';

        for i:=0 to tmps.Count-1 do begin
        tmps[i]:=StrUtils.AnsiReplaceStr(tmps[i],'Link encap:',' ');
        tmps[i]:=StrUtils.AnsiReplaceStr(tmps[i],'HWaddr',' ');
        tmps[i]:=StrUtils.AnsiReplaceStr(tmps[i],'inet addr:',' ');
        tmps[i]:=StrUtils.AnsiReplaceStr(tmps[i],'Bcast:',' ');
        tmps[i]:=StrUtils.AnsiReplaceStr(tmps[i],'Mask:',' ');
        End;

        i:=0;

        repeat
        if tmps[i]<>'' then begin
        j:=pos(' ',tmps[i]);
                if j<>0 then begin
                s:=copy(tmps[i],1,j-1);
                        if s=device then begin
                        // tmps[i] = device  type  hwaddr
                        sbuf:=copy(tmps[i],j+1,length(tmps[i]))+' ';
                        sbuf:=trimleft(sbuf);
                        j:=pos(' ',sbuf);
                        if j<>0 then sbuf:=copy(sbuf,j+1,length(sbuf));
                        net_info[device_number_].hw_addr:=trim(sbuf);
                        // hwaddr

                        inc(i);
                        sbuf:=tmps[i]+' ';
                        sbuf:=trimleft(sbuf);
                        j:=pos(' ',sbuf);
                        if j<>0 then
                        net_info[device_number_].ip_addr:=copy(sbuf,1,j-1);
                        sbuf:=copy(sbuf,j+1,length(sbuf));
                        sbuf:=trimleft(sbuf);
                        j:=pos(' ',sbuf);
                        if j<>0 then
                        net_info[device_number_].bcast:=copy(sbuf,1,j-1);
                        sbuf:=copy(sbuf,j+1,length(sbuf));
                        net_info[device_number_].mask:=trim(sbuf);

                        End;
                End;
        End;
        inc(i);
        until i=tmps.Count-1;
        finally
        DeleteFile(tmpfile_);
        tmps.Free;
        End;
End;
