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
unit hwinfo;
// {$DEFINE DEBUG_PCI}
interface
uses Libc,SysUtils,Classes,xpclasses;
{$WEAKPACKAGEUNIT ON}

type THostData = PHostEnt;

type _Media = (meFloppy,meDisk,meCDROM,meUnknown);
Const media_names :Array [0..3] of String=('floppy','disk','cdrom','unknown');

Function Is_CablePlugged(Const i_face:string):boolean;
function IsRouteFor(Interf: String):boolean;
Function IsValidNetDevice(device:string):boolean;
Function GetHardDiscs:PPci_Info_;
Function GetSCSIDiscs:PPci_Info_;
Function GetHdInfo(device:string):string;
Function ReadHW(hwfile:string):PPci_Info_;
Function InstalledRAM:cardinal;
Function CpuInfo_:TCpuInfo_;
Function GetHostname_:THostData;


implementation

Function GetBusValue(Data:String):Tbus_value;
var n,x,xx:integer;
    bvl:bus_value;
    s,ss:string;
Begin

        s:=Data+' ';

        for n:=1 to length(Data) do begin
        xx:=pos(',',s);
        if xx<>0 then Delete(s,xx,1);
        x:=pos(':',s);
        if x<>0 then Delete(s,x,1);
        End;

        for x:=0 to MAX_BUSVALUES do begin
        n:=SysUtils.AnsiPos(busvalues[x],s);
        if n<>0 then begin
                Delete(s,n,length(busvalues[x]));
                s:=trimleft(s);
                xx:=pos(' ',s);
                if xx<>0 then begin
                ss:=copy(s,1,xx-1);
                ss:=trim(ss);
                if ss='' then ss:='0';
                case x of
                        0:bvl.bus:=StrToInt(ss);
                        1:bvl.device:=StrToInt(ss);
                        2:bvl.func:=StrToInt(ss);
                End;
                Delete(s,1,xx);
                End;
        End;
        End;
        Result:=bvl;
End;

Function GetDeviceName(Data:String):String;
var n:integer;
Begin
     Result:='Unknown device';
     n:=pos(':',Data);
     if n<>0 then
     Result:=trimleft(copy(Data,n+1,length(data)));
End;

Function GetDeviceIO(Data:String):Tio_value;
var io_val:Tio_value;
    s,ss,sss:string;
    i,j:integer;
Begin
        s:=Data+' ';
        Delete(s,1,7); // delete "I/O at "
        ss:='0000';
        sss:='0000';
        for i:=1 to length(Data) do begin
                j:=Pos('[',s);
                if j<>0 then Delete(s,j,1);
                j:=Pos(']',s);
                if j<>0 then Delete(s,j,1);
                j:=Pos('.',s);
                if j<>0 then Delete(s,j,1);
        End;
        s:=trim(s);
        j:=Pos(' ',s);
        if j<>0 then begin
        ss:=copy(s,1,j-1);
        Delete(s,1,j);
        ss:=copy(ss,3,length(ss));
        sss:=copy(s,3,length(s));
        End;

        io_val.from_address:=ss;
        io_val.to_address:=sss;
        {$IFDEF DEBUG_PCI}
        writeln('IO FROM =',ss,'IO TO=',sss);
        {$ENDIF}
        Result:=io_val;
End;

Function GetDeviceIRQ(Data:String):integer;
var s:string;
    j:integer;
Begin
        s:=Data+' ';
        Delete(s,1,3); // IRQ
        j:=Pos('.',s);
        if j<>0 then Delete(s,j,1);
        s:=trim(s);
        {$IFDEF DEBUG_PCI}
        writeln('IRQ=',s);
        {$ENDIF}
        try
        Result:=StrToInt(s);
        except
        Result:=0;
        End;
End;


Function GetDeviceMasterCapable(Data:String):TPci_Add;
Const macap:Array[0..3] of String=('No bursts.','Latency=','Gnt=','Lat=');
var pa:TPci_Add;
     s,ss:string;
     j,i,x,xx:integer;
Begin
        s:=Data+' ';

        pa.master_capable:=true;
        pa.no_bursts:=false;
        pa.latency:=-1;
        pa.gnt:=-1;
        pa.lat:=-1;

        for j:=0 to 3 do begin
        i:=SysUtils.AnsiPos(macap[j],s);
        if i<>0 then begin
                case j of
                        0:Begin
                          pa.no_bursts:=true;
                          End;
                        1:Begin
                                ss:='';
                                for x:=i+Length(macap[j]) to length(s) do begin
                                if TryStrToInt(s[x],xx) then begin
                                ss:=ss+s[x];
                                End else begin
                                if ss='' then ss:='0';
                                pa.latency:=StrToInt(ss);
                                break;
                                End;
                                End;

                          End;
                        2:Begin
                                ss:='';
                                for x:=i+Length(macap[j]) to length(s) do begin
                                if TryStrToInt(s[x],xx) then begin
                                ss:=ss+s[x];
                                End else begin
                                if ss='' then ss:='0';
                                pa.gnt:=StrToInt(ss);
                                break;
                                End;
                                End;
                          End;
                        3:Begin
                                ss:='';
                                for x:=i+Length(macap[j]) to length(s) do begin
                                if TryStrToInt(s[x],xx) then begin
                                ss:=ss+s[x];
                                End else begin
                                if ss='' then ss:='0';
                                pa.lat:=StrToInt(ss);
                                break;
                                End;
                                End;
                          End;
                End;
        End;
        End;

        Result:=pa;
End;

Function GetDevicePrefetch(nonpref:boolean; Data:String):Tio_Value;
var ioval:Tio_Value;
    s,ss,sss:string;
    i,j:integer;
Begin
        s:=Data+' ';
        case nonpref of
        true:Delete(s,1,33); //29
        false:Delete(s,1,29);
        End;

        for i:=1 to length(Data) do begin
                j:=Pos('[',s);
                if j<>0 then Delete(s,j,1);
                j:=Pos(']',s);
                if j<>0 then Delete(s,j,1);
                j:=Pos('.',s);
                if j<>0 then Delete(s,j,1);
        End;
        s:=trim(s);
        j:=Pos(' ',s);
        if j<>0 then begin
        ss:=copy(s,1,j-1);
        Delete(s,1,j);
        ss:=copy(ss,3,length(ss));
        sss:=copy(s,3,length(s));
        End;

        ioval.from_address:=ss;
        ioval.to_address:=sss;
        {$IFDEF DEBUG_PCI}
        writeln('PREFETCH/NON-PREFETCH 32 bit FROM =',ss,'IO TO=',sss);
        {$ENDIF}

        Result:=ioval;
End;


Function ReadHW(hwfile:string):PPci_Info_;
// /proc/pci         // stavi var struct_info:Array of TPci_Info;
// save entries into registry as BUS ID's
var hwfile_:TextFile;
    strs:TStrings;
    s:string;
    i,j,y,x:integer;
    bus_pos:Array[0..255] of integer;
    bv:Tbus_value;
    iv:Tio_value;
    pa:Tpci_add;
    pinf:PPci_Info_;
    current_device,
    io_counter:byte;
Begin
// ok , we will save /proc/pci into registry in next way:
// BUS ID -> device id
//                |
//                -> device_data
//        -> device id
//                |
//                -> device data

        io_counter:=0;
        strs:=TStringList.Create;

        try
        AssignFile(hwfile_,hwfile);
        Reset(hwfile_);
        while not eof(hwfile_) do begin
        Readln(hwfile_,s);
        strs.Add(s);
        End;
        CloseFile(hwfile_);

        j:=0;

        for i:=0 to strs.Count-1 do begin
        strs[i]:=trimleft(strs[i]);

                if copy(strs[i],1,3)=busvalues[0] then begin
                        bus_pos[j]:=i;
                        inc(j);
                End;
        End;

        // j:=j+1;
        SetLength(pinf,j);

        for i:=0 to j-1 do begin
                pinf[i].bus_id:=254;
                pinf[i].device_id:=254;
                pinf[i].device_function:=254;
                pinf[i].device_type:='';
                pinf[i].device_info:='';
                pinf[i].device_irq:=254;
                pinf[i].device_add.master_capable:=false;
                pinf[i].device_add.no_bursts:=false;
                pinf[i].device_add.latency:=-1;
                pinf[i].device_add.gnt:=-1;
                pinf[i].device_add.lat:=-1;
                for x:=0 to 31 do begin
                pinf[i].device_io_from[x]:='';
                pinf[i].device_io_to[x]:='';
                End;
                pinf[i].non_prefetch_lo:='';
                pinf[i].non_prefetch_hi:='';
                pinf[i].prefetchable_lo:='';
                pinf[i].prefetchable_hi:='';
                pinf[i].sign:='';
                pinf[i].driver:='';
        End;

        for i:=0 to j-1 do begin

                if bus_pos[i+1]=0 then bus_pos[i+1]:=strs.Count;

                for y:=bus_pos[i] to bus_pos[i+1]-1 do begin

                        if copy(strs.Strings[y],1,3)=busvalues[0] then begin
                                bv:=GetBusValue(strs.Strings[y]);
                                pinf[i].bus_id:=bv.bus;
                                pinf[i].device_id:=bv.device;
                                current_device:=i;
                                io_counter:=0;
                                pinf[i].device_function:=bv.func;
                        End else begin
                                for x:=0 to MAX_DEVICE_EXP do begin
                                        if copy(strs.Strings[y],1,length(devices[x]))=devices[x] then begin
                                                pinf[i].device_type:=devices[x];
                                                pinf[i].device_info:=GetDeviceName(strs.Strings[y]);
                                                break;
                                        End;
                                End;

                                for x:=0 to MAX_KWORDS do begin
                                        if copy(strs.Strings[y],1,length(keywrds[x]))=keywrds[x] then begin

                                        case x of
                                                0:Begin
                                                  iv:=GetDeviceIO(strs.Strings[y]);
                                                  pinf[i].device_io_from[io_counter]:=iv.from_address;
                                                  pinf[i].device_io_to[io_counter]:=iv.to_address;
                                                  inc(io_counter);
                                                  End;
                                                1:Begin
                                                  pinf[i].device_irq:=GetDeviceIRQ(strs.Strings[y]);
                                                  End;
                                                2:Begin
                                                  pa:=GetDeviceMasterCapable(strs.Strings[y]);
                                                  {$IFDEF DEBUG_PCI}
                                                  writeln('Device ',pinf[i].device_info,' MACAP ',pa.latency,' ',pa.gnt,' ',pa.lat);
                                                  {$ENDIF}
                                                  End;
                                                3:Begin
                                                  iv:=GetDevicePrefetch(true,strs.Strings[y]);
                                                  pinf[i].non_prefetch_lo:=iv.from_address;
                                                  pinf[i].non_prefetch_hi:=iv.to_address;
                                                  End;
                                                4:Begin
                                                  iv:=GetDevicePrefetch(false,strs.Strings[y]);
                                                  pinf[i].prefetchable_lo:=iv.from_address;
                                                  pinf[i].prefetchable_hi:=iv.to_address;
                                                  End;
                                        End;

                                        break;
                                        End;
                                        //
                                End;
                        End;
                End;
        End;
        {$MESSAGE WARN 'FIXME -> implement driver name from /proc/ioports'}
        // /proc/ioports shows driver , but not for vga card
        // so I have to check Xlib...or write some binds to get driver name for VGA
        // because : if driver is nvidia then it can be found in /proc/driver, but
        // if driver exists in XFree then I can see its name only in /proc/dri..but
        // what if somebody turn off dri ?

        {$IFDEF DEBUG_PCI}
        strs.SaveToFile('/tmp/pciinfo.txt');
        {$ENDIF}

        finally
        strs.Free;
        End;
        Result:=pinf;
End;

function IsRouteFor(Interf: String):boolean;
// check is ppp0 or ippp0 UP
var F: TextFile;
    S: string;
    SL:TStrings;
begin
        Result:=false;
        SL:=TStringList.create;
        try
        AssignFile(F, '/proc/net/route');
        Reset(F);
                While Not Eof(F) do
                begin
                        Readln(F, S);
                        SL.CommaText := S; //Splits the entire line into the Stringlist.
                        if (SL[RT_IFACE]=Interf) then
                                begin
                                        Result:=true;
                                        break;
                                end;
                end;
        CloseFile(F);
        finally
        SL.free;
        End;
end;


Function Is_CablePlugged(Const i_face:string):boolean;
// this doesn't work on all ethernet drivers (chipsets)
// if IFF_RUNNING is not supported in chipset Result will be true !
var ifr:IFreq;
    proto:PProtoEnt;
    sock:TFileDescriptor;
    i:integer;
Begin
        Result:=false;
        strcpy(ifr.ifrn_name,PChar(i_face));
        proto:=getprotobyname('TCP');

        if proto<>Nil then begin

        sock:=socket(PF_INET,SOCK_STREAM,proto^.p_proto);

        i:=ioctl(sock,SIOCGIFFLAGS,@ifr);

        case i of
               0:Begin
                 if ifr.ifru_flags=IFF_RUNNING or IFF_UP or IFF_BROADCAST or IFF_MULTICAST then
                 Result:=true;
                 End;
               else
               writeln('IOCTL Error i=',i);
        End;

       End;
End;

Function IsValidNetDevice(device:string):boolean;
// just check is device variable ok.
var ifr:IFreq;
    proto:PProtoEnt;
    sock:TFileDescriptor;
    i:integer;
Begin
        Result:=false;
        strcpy(ifr.ifrn_name,PChar(device));
        proto:=getprotobyname('TCP');

        if proto<>Nil then begin
        sock:=socket(PF_INET,SOCK_STREAM,proto^.p_proto);
        i:=ioctl(sock,SIOCGIFMAP,@ifr);

        case i of
               0:Result:=true;
        End;
       End;
End;

Function GetMediaDeviceFunction(media:string):byte;
var i:integer;
Begin
        Result:=255;
        for i:=0 to 3 do
        if media=media_names[i] then
        Result:=i;
End;


Function GetDeviceTypeFromMedia(media:string):string;

Const OtherDevices:Array[0..MAX_OTHER_DEVICES] of string=('Unknown','Keyboard','Mice and other pointing devices',
       'Floppy disc controllers','Disk drives',
       'DVD/CDROM drives','Floppy disc drives','FireWire Controllers',
       'Ports (COM & LPT)','Processors','SCSI Controllers');
var i:integer;
Begin
        Result:=OtherDevices[0];
        for i:=0 to 3 do begin
                if media=media_names[i] then begin
                case i of
                        0:Result:=OtherDevices[6];
                        1:Result:=OtherDevices[4];
                        2:Result:=OtherDevices[5];
                        3:Result:=OtherDevices[0];
                End;
                End;
        End;
End;

Function GetMedia(path:string):string;
var s,ss:string;
    fil:TextFile;
    sta:_stat;
Begin
        Result:='unknown';
        ss:='';
        s:=path+'/media';
        if Libc.stat(PChar(s),sta)=0 then begin
        AssignFile(fil,s);
        Reset(fil);
        Readln(fil,ss);
        CloseFile(fil);
        if ss<>'' then Result:=ss;
        End;
End;

Function GetMediaDeviceInfo(path:string):string;
var s,ss:string;
    fil:TextFile;
    sta:_stat;
Begin
        Result:='No informations about device';
        ss:='';
        s:=path+'/model';
        if Libc.stat(PChar(s),sta)=0 then begin
        AssignFile(fil,s);
        Reset(fil);
        ReadLn(fil,ss);
        CloseFile(fil);
        if ss<>'' then Result:=ss;
        End;
End;

Function GetMediaDriver(path:string):string;
var s,ss:string;
    fil:TextFile;
    sta:_stat;
Begin
        Result:='(none)';
        ss:='';
        s:=path+'/driver';
        if Libc.stat(PChar(s),sta)=0 then begin
        AssignFile(fil,s);
        Reset(fil);
        ReadLn(fil,ss);
        CloseFile(fil);
        if ss<>'' then Result:=ss;
        End;

End;

Function GetValueInt(Const value,data:string):byte;
var ii,jj:integer;
    s,ss:string;
Begin
        ss:='255';
        ii:=AnsiPos(value,data);
        if ii<>0 then begin
        s:=data;
        s:=copy(data,ii+length(value),length(data));
        s:=trimleft(s);
        jj:=Pos(' ',s);
        if jj<>0 then begin
                ss:=Copy(s,1,jj-1);
        End;
        End;
        try
        Result:=StrToInt(ss);
        except
        Result:=255;
        End;
End;

Function GetValueStr(Const value,data:string):String;
var ii,jj:integer;
    s,s1,ss:string;
Begin
        ss:='';
        s1:=data+' ';
        ii:=AnsiPos(value,s1);
        if ii<>0 then begin
        s:=copy(s1,ii+length(value),length(s1));
        s:=trimleft(s);
        if (value<>usbinfobus[9]) and (value<>usbinfobus[10]) then
        jj:=Pos(' ',s)
        else
        jj:=length(s)+1;
        if jj<>0 then begin
                ss:=Copy(s,1,jj-1);
        End;
        End;
        Result:=ss;
End;


Function GetSCSIDiscs:PPci_Info_;
Const scsikeys:Array[0..8] of String=('Host:','Channel:','Id:','Lun:',
                'Vendor:','Model:','Rev:','Type:','ANSI SCSI revision:');
      OtherDevices:Array[0..MAX_OTHER_DEVICES] of string=('Unknown','Keyboard','Mice and other pointing devices',
       'Floppy disc controllers','Disk drives',
       'DVD/CDROM drives','Floppy disc drives','FireWire Controllers',
       'Ports (COM & LPT)','Processors','SCSI storage controller');
      ScsiClassDevices:Array[0..1] of String=('Direct-Access','CD-ROM');
var s,s1:string;
    st,stt:TStrings;
    fil:TextFile;
    sta:_stat;
    i,j,x,y:integer;
    sci:PPci_Info_;

Begin
        s:='/proc/scsi/scsi';
        SetLength(sci,0);
        if Libc.stat(PChar(s),sta)=0 then begin
                st:=TStringList.Create;
                try
                AssignFile(fil,s);
                Reset(fil);
                j:=0;
                while not eof(fil) do begin
                ReadLn(fil,s);
                st.Add(s);
                End;
                CloseFile(fil);

                x:=0;
                y:=0;
                i:=-1;
                j:=0;
                st.Strings[0]:='';
                for i:=0 to st.Count-1 do begin
                        if AnsiPos('Host:',st.Strings[i])<>0 then begin
                                inc(j);
                                st.Strings[i]:=st.Strings[i]+' '+st.Strings[i+1]+' '+st.Strings[i+2];
                                st.Strings[i+1]:='';
                                st.Strings[i+2]:='';
                        End;
                End;

                SetLength(sci,j);

                stt:=TStringList.Create;
                for i:=0 to st.Count-1 do
                if st.Strings[i]<>'' then
                stt.Add(st.Strings[i]);

                for i:=0 to length(sci)-1 do begin
                        sci[i].bus_id:=GetValueInt(scsikeys[1],stt.Strings[i]);
                        sci[i].device_id:=GetValueInt(scsikeys[2],stt.Strings[i]);
                        sci[i].device_function:=GetValueInt(scsikeys[3],stt.Strings[i]);
                        sci[i].device_type:='SCSI controllers';
                        sci[i].device_info:=GetValueStr(scsikeys[4],stt.Strings[i])+' '+GetValueStr(scsikeys[5],stt.Strings[i]);
                        sci[i].device_irq:=255;
                        sci[i].sign:='';
                        sci[i].driver:='scsi';
                        s1:=GetValueStr(scsikeys[7],stt.Strings[i]);
                        
                        if s1=ScsiClassDevices[0] then
                        sci[i].usbclass:=OtherDevices[4]
                        else
                        if s1=ScsiClassDevices[1] then
                        sci[i].usbclass:=OtherDevices[5]
                        else
                        sci[i].usbclass:=OtherDevices[10];
                        s1:=GetValueStr(scsikeys[0],stt.Strings[i]);
                        Delete(s1,1,4);
                        TryStrToInt(s1,sci[i].device_add.latency);
                End;
              (*
                for i:=0 to length(sci)-1 do
                writeln('BUS ',sci[i].bus_id,' ID ',sci[i].device_id,' FUNCTION ',sci[i].device_function,' INFO ',sci[i].device_info,' CLASS ',sci[i].usbclass,' scsiX ',sci[i].device_add.latency);
                *)
                stt.Free;
                finally
                st.Free;
                End;
        End;
        Result:=sci;
End;

Function GetHardDiscs:PPci_Info_;
Const hd='hd'; // a..z  97-122
var hin:PPci_Info_;
    fil:TextFile;
    i,j,x,recnos:integer;
    sta:_stat;
    cmd,dir,s:string;
    p:PChar;
    st,std:TStrings;
    hdsign:Array[0..64] of integer;
    // since we cannot get any useable info (as user) from GetHdInfo,we'll get it from /proc
Begin
           SetLength(hin,0);
           for i:=0 to 64 do
           hdsign[i]:=0;

           recnos:=0;
           std:=TStringList.Create;
           for i:=97 to 122 do begin
                cmd:='/proc/ide/'+hd+char(i);
                p:=StrAlloc(length(cmd)+1);
                StrPCopy(p,cmd);
                j:=Libc.stat(p,sta);
                StrDispose(p);

                if j=0 then begin
                        hdsign[recnos]:=i;
                        inc(recnos);
                        std.Add(cmd);
                End;
           End;

           if recnos > 0 then begin
           SetLength(hin,recnos);
                   for i:=0 to length(hin)-1 do begin
                        hin[i].bus_id:=0;
                        hin[i].device_id:=hdsign[i];
                        cmd:=std.Strings[i];
                        s:=GetMedia(cmd);
                        hin[i].device_function:=GetMediaDeviceFunction(s);
                        hin[i].device_type:='Other Devices';
                        hin[i].device_info:=GetMediaDeviceInfo(cmd);
                        hin[i].device_irq:=255;
                        hin[i].usbclass:=GetDeviceTypeFromMedia(s);
                        hin[i].sign:='';
                        hin[i].driver:=GetMediaDriver(cmd);
                   End;
          {$MESSAGE WARN 'FIXME -> now we can search for more infos in /proc/ide/ideXX'}
          {$IFDEF DEBUG}
           for i:=0 to length(hin)-1 do
           writeln(' TYPE ',hin[i].device_type,' FUNCTION ',hin[i].device_function,' INFO ',hin[i].device_info,' CLASS ',hin[i].usbclass,' DRIVER ',hin[i].driver);
          {$ENDIF}
           End; // recnos > 0
           std.Free;

           Result:=hin;
End;

Function GetHdInfo(device:string):string;
// WARNING ! this function be used only as root !
var fd,i,j:integer;
    hdi:hd_driveid;
    model:string;
Begin
        Result:='';
        fd:=Open(PChar(device),O_RDONLY OR O_NONBLOCK);

        i:=ioctl(fd,HDIO_GET_IDENTITY,@hdi);
        case i of
                0:Begin
                  model:='';

                  for j:=0 to 19 do
                  model:=model+','+IntToStr(byte(hdi.serial_no[j]));
                  writeln('HDD SERIAL = ',model);


                  writeln('HDI CAPABILITY ',hdi.major_rev_num,' HEADS ',hdi.heads,' CYLS ',hdi.cyls);
                  model:='';
                  for j:=0 to 21 do
                  model:=model+','+IntToStr(byte(hdi.word104_125[j]));

                  writeln('WORD104_125 ',model);

                  for j:=0 to 48 do
                  model:=model+','+IntToStr(byte(hdi.words206_254[j]));

                  writeln('WORD206_254 ',model);

                  End;
                else
                writeln('Error: GetHDInfo() bad ioctl result.');
        End;
        __close(fd);
End;

Function InstalledRAM:cardinal;
var sin:_sysinfo;
Begin
        Libc.sysinfo(sin);
        Result:=sin.totalram;
End;


Function CpuInfo_:TCpuInfo_;
Const cpu__:Array [0..7] of String=('processor','vendor_id',
                        'cpu family','model','model name',
                        'cpu MHz','cache size','bogomips');
var cpui:TCpuInfo_;
    s:string;
    rs:TStrings;
    fd:TextFile;
    i,j,x:integer;

Function GetCpuData(kind:string; data:String):String;
var jj:integer;
Begin
        jj:=AnsiPos(kind,data);
        if jj<>0 then
        Delete(data,jj,length(kind));
        jj:=Pos(':',data);
        if jj<>0 then
        Delete(data,jj,1);
        Result:=trim(data);
End;

Begin
        rs:=TStringList.Create;
        try
        AssignFile(fd,'/proc/cpuinfo');
        Reset(fd);
        while not eof(fd) do begin
        readln(fd,s);
        rs.Add(s);
        End;
        CloseFile(fd);

        for i:=0 to rs.Count-1 do begin

        for x:=0 to 7 do begin
        j:=AnsiPos(cpu__[x],rs.Strings[i]);
        if j<>0 then begin

                case x of
                        0:Begin
                          s:=GetCPUData(cpu__[x],rs.Strings[i]);
                          if s='' then s:='0';
                          cpui.processor:=StrToInt(s);
                          End;
                        1:Begin
                          cpui.vendor_id:=GetCPUData(cpu__[x],rs.Strings[i]);
                          End;
                        2:Begin
                          s:=GetCPUData(cpu__[x],rs.Strings[i]);
                          cpui.cpu_family:=s;
                          End;
                        3:Begin
                          s:=GetCPUData(cpu__[x],rs.Strings[i]);
                          cpui.model:=s;
                          End;
                        4:Begin
                          cpui.model_name:=GetCPUData(cpu__[x],rs.Strings[i]);
                          End;
                        5:Begin
                          s:=GetCPUData(cpu__[x],rs.Strings[i]);
                          cpui.cpu_mhz:=s;
                          End;
                        6:Begin
                          cpui.cpu_cache:=GetCPUData(cpu__[x],rs.Strings[i]);
                          End;
                        7:Begin
                          s:=GetCPUData(cpu__[x],rs.Strings[i]);
                          cpui.bogomips:=s;
                          End;
                End;
        End;
        End;
        End;

        finally
        rs.Free;
        End;

        Result:=cpui;
End;

Function GetHostname_:THostData;
Begin
   Result:=Libc.gethostent;
End;

end.
