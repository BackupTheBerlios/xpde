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
unit SysProvider;

interface

uses
  SysUtils, Classes,xpclasses,uRegistry,distro,hwinfo,usb;

Const _MAX_FUNCS=255;

type PUsbInfo=PUsbInfo_;
     PPci_Info=PPci_Info_;
     TCpuInfo=TCpuInfo_;

type
  TSysProvider = class(TObject)
  private
  FValidNetDevice:boolean;
  FCableOn:boolean;
    { Private declarations }
//  Function ProvideRegistryAll:PPci_Info;
// back in private later.
  Function ProvideDistroInfo:TUname;
  Function MemoryInfo:cardinal;
  Function CPU_Info:TCpuInfo;
  Function GetHostName:string;
  Function GetUsbInfo:PUsbInfo;
  Procedure ProvideNetDeviceInfo(device:string);

  protected
    { Protected declarations }
  public
  constructor Create;
  destructor Destroy; Override;

  Procedure WriteDistroInfo;
  Procedure WriteHwInfo;

  Function ProvideRegistryAll:PPci_Info;
  // just for testing, back it to private later
  Property PCIInfo:PPci_Info read ProvideRegistryAll;
  Property DistInfo:TUname read ProvideDistroInfo;
  Property CpuInfo:TCpuInfo read Cpu_Info;
  Property MemInfo:cardinal read MemoryInfo;
  Property UsbInfo:PUsbInfo read GetUsbInfo;
  Property HostName:String read GetHostName;


  Property NetDeviceValid:boolean read FValidNetDevice;
  Property NetDeviceCableOn:boolean read FCableOn;
    { Public declarations }
  published
    { Published declarations }
  end;

implementation

constructor TSysProvider.Create;
Begin
        //
End;

destructor TSysProvider.Destroy;
Begin
  inherited;
End;

Procedure TSysProvider.WriteDistroInfo;
var  reg: TRegistry;
     Struct_Data:TUname;
Begin
        Struct_Data:=Get_Distro_Version;
        reg:=TRegistry.create;
        try
        if reg.OpenKey('Software/XPde/System',true) then begin

            reg.Writeinteger(dist_reg[0],struct_Data.dist);
            reg.Writestring(dist_reg[1],struct_Data.name);
            reg.Writestring(dist_reg[2],struct_Data.sys);
            reg.Writestring(dist_reg[3],struct_Data.version);
            reg.Writestring(dist_reg[4],struct_Data.kernel);
            reg.Writestring(dist_reg[5],struct_Data.machine);

        end;
        finally
        reg.free;
    end;
End;

Procedure TSysProvider.WriteHwInfo;
var  reg: TRegistry;
     pcinf:PPCi_Info;
     i,x:integer;
Begin

    reg:=TRegistry.create;
    try
        pcinf:=ReadHW('/proc/pci');
        for i:=0 to length(pcinf)-1 do begin

        if reg.OpenKey('Hardware/XPde/'+IntToStr(pcinf[i].bus_id)+'/'+IntToStr(pcinf[i].device_id)+'/'+IntToStr(pcinf[i].device_function),true) then begin

        
                reg.Writestring(pci_reg[0],pcinf[i].device_type);
                reg.Writestring(pci_reg[1],pcinf[i].device_info);
                reg.Writeinteger(pci_reg[2],pcinf[i].device_irq);
                reg.Writebool(pci_reg[3],pcinf[i].device_add.master_capable);
                reg.Writebool(pci_reg[4],pcinf[i].device_add.no_bursts);
                reg.Writeinteger(pci_reg[5],pcinf[i].device_add.latency);
                reg.Writeinteger(pci_reg[6],pcinf[i].device_add.gnt);
                reg.Writeinteger(pci_reg[7],pcinf[i].device_add.lat);

                for x:=0 to 31 do begin
                        if pcinf[i].device_io_from[x]<>'' then begin
                        reg.Writestring(pci_reg[8]+IntToStr(x),pcinf[i].device_io_from[x]);
                        reg.Writestring(pci_reg[9]+IntToStr(x),pcinf[i].device_io_to[x]);
                        End;
                End;
                reg.Writestring(pci_reg[10],pcinf[i].non_prefetch_lo);
                reg.Writestring(pci_reg[11],pcinf[i].non_prefetch_hi);
                reg.Writestring(pci_reg[12],pcinf[i].prefetchable_lo);
                reg.Writestring(pci_reg[13],pcinf[i].prefetchable_hi);
                reg.Writestring(pci_reg[14],pcinf[i].driver);
                reg.CloseKey;
        end;
        End;
    finally
        reg.free;
    end;
End;

Function TSysProvider.ProvideRegistryAll:PPci_Info;
// provides all hw informations for ControlPanel->System
var pin:PPci_Info;
    sr,sr1,sr2:TSearchRec;
    x,fat,i,bus,j,jj,jjj:integer;
    busses:Array[0..1023] of integer;
    deviids:Array[0..1023] of integer;
    devfuncs:Array[0..1023] of integer;
    reg:TRegistry;
Begin
        for bus:=0 to 1023 do begin
        busses[bus]:=-1;
        deviids[bus]:=-1;
        devfuncs[bus]:=-1;
        End;

        SetLength(pin,_MAX_FUNCS);
        reg:=TRegistry.Create;
        Fat:=faDirectory;
        i:=0;
        j:=0;
        jj:=0;
        jjj:=0;

        if FindFirst(reg.RootKey+'/Hardware/XPde/*',Fat,sr)=0 then
        repeat
        if (sr.Attr and Fat)=sr.Attr then begin

        if TryStrToInt(sr.Name,busses[j]) then begin
        busses[j]:=StrToInt(sr.Name);
        inc(j);

                if FindFirst(reg.RootKey+'/Hardware/XPde/'+sr.Name+'/*',Fat,sr1)=0 then
                repeat
                        if (sr1.Attr and Fat)=sr1.Attr then begin
                                if TryStrToInt(sr1.Name,deviids[jj]) then begin
                                {$IFDEF DEBUG}
                                writeln('Bus ',busses[j-1],' sr1.Name ',sr1.Name);
                                {$ENDIF}
                                deviids[jj]:=StrToInt(sr1.Name);
                                inc(jj);

                                        if FindFirst(reg.RootKey+'/Hardware/XPde/'+sr.Name+'/'+sr1.Name+'/*',Fat,sr2)=0 then
                                        repeat
                                                if (sr2.Attr and Fat)=sr2.Attr then begin

                                                if TryStrToInt(sr2.Name,devfuncs[jjj]) then begin
                                                pin[jjj].bus_id:=StrToInt(sr.Name);
                                                pin[jjj].device_id:=StrToInt(sr1.Name);
                                                pin[jjj].device_function:=StrToInt(sr2.Name);

                                                if reg.OpenKey('Hardware/XPde/'+sr.Name+'/'+sr1.Name+'/'+sr2.Name,false) then begin
                                                pin[jjj].device_type:=reg.Readstring(pci_reg[0]);
                                                pin[jjj].device_info:=reg.Readstring(pci_reg[1]);
                                                pin[jjj].device_irq:=reg.Readinteger(pci_reg[2]);
                                                pin[jjj].device_add.master_capable:=reg.Readbool(pci_reg[3]);
                                                pin[jjj].device_add.no_bursts:=reg.Readbool(pci_reg[4]);
                                                pin[jjj].device_add.latency:=reg.Readinteger(pci_reg[5]);
                                                pin[jjj].device_add.gnt:=reg.Readinteger(pci_reg[6]);
                                                pin[jjj].device_add.lat:=reg.Readinteger(pci_reg[7]);

                                                for x:=0 to 31 do begin
                                                pin[jjj].device_io_from[x]:=reg.Readstring(pci_reg[8]+IntToStr(x));
                                                pin[jjj].device_io_to[x]:=reg.Readstring(pci_reg[9]+IntToStr(x));
                                                End;

                                                pin[jjj].non_prefetch_lo:=reg.Readstring(pci_reg[10]);
                                                pin[jjj].non_prefetch_hi:=reg.Readstring(pci_reg[11]);
                                                pin[jjj].prefetchable_lo:=reg.Readstring(pci_reg[12]);
                                                pin[jjj].prefetchable_hi:=reg.Readstring(pci_reg[13]);
                                                pin[jjj].driver:=reg.Readstring(pci_reg[14]);



                                                End;
                                                {$IFDEF DEBUG}
                                                writeln('Bus ',busses[j-1],' sr1.Name ',sr1.Name,' sr2.Name ',sr2.Name);
                                                {$ENDIF}
                                                // here we fill up registry struct for pciinfo
                                                devfuncs[jjj]:=StrToInt(sr2.Name);
                                                inc(jjj);
                                                End;

                                                End;

                                        until FindNext(sr2)<>0; // functions loop

                                End;
                        End;

                until FindNext(sr1)<>0;


        End;  // end find busses
        inc(i);
        End; // founded attr

        until FindNext(sr)<>0;
        FindClose(sr);
        reg.Free;

        SetLength(pin,jjj+1);
        // Set real length for pin array
       Result:=pin;
End;

Function TSysProvider.ProvideDistroInfo:TUname;
// provides distro information via TUName
var una:TUname;
    reg: TRegistry;
Begin
    reg:=TRegistry.Create;
    try
        if reg.OpenKey('Software/XPde/System',false) then begin
                una.dist:=reg.Readinteger(dist_reg[0]);
                una.name:=reg.Readstring(dist_reg[1]);
                una.sys:=reg.Readstring(dist_reg[2]);
                una.version:=reg.Readstring(dist_reg[3]);
                una.kernel:=reg.Readstring(dist_reg[4]);
                una.machine:=reg.Readstring(dist_reg[5]);
        End;

    finally
    reg.Free;
    End;
    Result:=una;
End;

Function TSysProvider.GetUsbInfo:PUsbInfo;
// this will be abandoned as soon as  possible with libusb port !
var uusb:PUsbInfo;
    fd:TextFile;
    strs:TStrings;
    s:string;
    buspos:Array[0..1023] of integer;
    counter,i,j,bus_id:integer;
    busfounded:boolean;

Function GetUsbValueInt(Const value,data:string):integer;
var ii,jj:integer;
    s,ss:string;
Begin
        ss:='-1';
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
        Result:=-1;
        End;
End;

Function GetUsbValueStr(Const value,data:string):String;
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


Begin
        for i:=0 to 1023 do
        buspos[i]:=-1;
        busfounded:=true;

        SetLength(uusb,0);
        if FileExists('/proc/bus/usb/devices') then begin
        strs:=TStringList.Create;
        try
        AssignFile(fd,'/proc/bus/usb/devices');
        Reset(fd);
        while not eof(fd) do begin
        readln(fd,s);
        strs.Add(s);
        End;
        CloseFile(fd);
        counter:=0;
                for i:=0 to strs.Count-1 do begin
                        if AnsiPos(usbinfobus[0],strs.Strings[i])<>0 then begin
                        inc(counter);
                        buspos[counter-1]:=i;
                        End;
                End;

        SetLength(uusb,counter);

        for i:=0 to strs.Count-1 do begin

               for j:=0 to counter-1 do begin
               if i=buspos[j] then begin
               uusb[j].bus:=GetUsbValueInt(usbinfobus[0],strs.Strings[i]);
               uusb[j].lev:=GetUsbValueInt(usbinfobus[1],strs.Strings[i]);
               uusb[j].prnt:=GetUsbValueInt(usbinfobus[2],strs.Strings[i]);
               uusb[j].port:=GetUsbValueInt(usbinfobus[3],strs.Strings[i]);
               uusb[j].device:=GetUsbValueInt(usbinfobus[4],strs.Strings[i]);
               uusb[j].spd:=GetUsbValueInt(usbinfobus[5],strs.Strings[i]);
               uusb[j].driver:='';
               bus_id:=j;
               busfounded:=true;
               End;
               End;


               if busfounded then begin
                if uusb[bus_id].ver='' then
                uusb[bus_id].ver:=GetUsbValueStr(usbinfobus[6],strs.Strings[i]);
                if uusb[bus_id].vendor='' then
                uusb[bus_id].vendor:=GetUsbValueStr(usbinfobus[7],strs.Strings[i]);
                {$MESSAGE WARN 'FIXME vendor can be obtained from usb vendors list and translated into Manufacturer name if uusb[n].manufacturer is empty'}
                if uusb[bus_id].prod_id='' then
                uusb[bus_id].prod_id:=GetUsbValueStr(usbinfobus[8],strs.Strings[i]);
                if uusb[bus_id].manufacturer='' then
                uusb[bus_id].manufacturer:=GetUsbValueStr(usbinfobus[9],strs.Strings[i]);
                if uusb[bus_id].product='' then
                uusb[bus_id].product:=GetUsbValueStr(usbinfobus[10],strs.Strings[i]);
                if uusb[bus_id].driver='' then
                uusb[bus_id].driver:=GetUsbValueStr(usbinfobus[11],strs.Strings[i]);

                if uusb[bus_id].driver<>'' then busfounded:=false;
               End;
        End;


        for i:=0 to Length(uusb)-1 do
        // if manufacturer='' and vendor<>'0000' then search_manufacturer
        writeln('UUSB BUS ',uusb[i].bus,' ',uusb[i].lev,' ',uusb[i].prnt,' ',uusb[i].port,' ',uusb[i].device,' ',uusb[i].spd,' ',uusb[i].ver,' ',uusb[i].vendor,' ',uusb[i].prod_id,' ',uusb[i].manufacturer,' ',uusb[i].product,' Driver=',uusb[i].driver);

        // read /proc/bus/usb
        finally
        strs.Free;
        End;
        End;
        Result:=uusb;
End;

Procedure TSysProvider.ProvideNetDeviceInfo(device:string);
// provides net device info eg. ip address,mask,HW addr,connection etc...
Begin
//
End;

Function TSysProvider.MemoryInfo:cardinal;
Begin
        Result:=InstalledRam;
End;

Function TSysProvider.CPU_Info:TCpuInfo;
Begin
        Result:=CpuInfo_;
End;

Function TSysProvider.GetHostName:String;
var hd:THostData;
Begin
        hd:=GetHostName_;
        // Strange...on Debian 3.0 I cannot get hostname via
        // GetEnvironmentVariable('HOSTNAME') but I can see it via
        // $echo $HOSTNAME ?!?!?
        // so ugly workaround is
        // to get record from Libc.PHostEnt
        if ProvideDistroInfo.dist=diDebian then
        Result:=String(hd^.h_name)
        else
        Result:=SysUtils.GetEnvironmentVariable('HOSTNAME');
End;



end.
 