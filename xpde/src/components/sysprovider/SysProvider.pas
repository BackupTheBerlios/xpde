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
  
  (* DON'T DELETE THIS !!
        IMAGES FOR DEVICES :
        sys=0,hdd=1,usb=2,vga=3,net=4,modem=5,mass=6,audio=7,unknown=8,
        computer=9,keyboard=10,mouse=11,hid=12,floppy=13,cdrom=14,
        ports=15,cpu=16,scsi=17,camera=18,scanner=19
  *)

Const _MAX_FUNCS=255;
//      SysPictures:Array [0..MAX_DEVICE_EXP] of string=('tux.png');
//      TODO: List of pictures for system
       DevicesSigns:Array[0..MAX_DEVICE_EXP] of string=('System devices','System devices',
       'System devices','IDE ATA/ATAPI controllers','System devices',
       'Universal Serial Bus controllers','Display adapters','Network adapters',
       'Modems','Mass Storage controllers','Sound,video and game controllers',
       'Sound,video and game controllers');

       DeviceShortSign:Array[0..MAX_SIGN_SHORT] of string=('System devices','IDE ATA/ATAPI controllers',
       'Universal Serial Bus controllers','Display adapters','Network adapters',
        'Modems','Mass Storage controllers','Sound,video and game controllers','USB Devices','Other Devices','SCSI controllers');

       devicePics:Array[0..MAX_SIGN_SHORT] of integer=(0,1,2,3,4,5,6,7,2,8,17);

       OtherDevices:Array[0..MAX_OTHER_DEVICES] of string=('Unknown','Keyboard','Mice and other pointing devices',
       'Floppy disc controllers','Disk drives',
       'DVD/CDROM drives','Floppy disc drives','FireWire Controllers',
       'Ports (COM & LPT)','Processors','SCSI storage controller');
       OdevicePics:Array[0..MAX_OTHER_DEVICES] of integer=(8,10,11,13,1,14,13,17,15,16,17);

       // Storage volumes
       UsbClassDevices:Array[0..MAX_USB_CLASSES] of string=('USB Interface',
       'USB Sound,video and game controllers','USB Communication Controller',
       'Human Interface Devices','USB Physical devices',
       'USB Imaging Devices','USB Printer','Storage volumes',
       'USB HUB','USB Cdc Data','USB Smart Cards',
       'USB Content Security','USB App_Spec','USB Vendor_spec',
       'USB Unknown Device');

       UsbClassDevicesPics:Array[0..MAX_USB_CLASSES] of integer=(2,7,5,12,2,19,2,1,2,2,2,2,2,2,8);
        // need more scai classes
       ScsiClassDevices:Array[0..1] of String=('Direct-Access','CD-ROM');

type PUsbInfo=PUsbInfo_;
     TUsbClasses=TUsb_Classes;   
     PPci_Info=PPci_Info_;
     PNoDupsPciInfo=PNoDups_Pci_Info;
     TCpuInfo=TCpuInfo_;
     TDevicesList=devices_list;
     TUname=T_Uname;
     TDistClass=(diiUnknown,diiRedhat,diiMandrake,diiSuse,diiDebian,diiCaldera,diiiTurboLinux,diiConectiva,diiLindows,diiSlackware,dFreeBSD);

type struct_iomem=record
        lo_:string;
        hi_:string;
        name:string;
     End;
     TIoMem=struct_iomem;
     PIoMem=Array of TIoMem;


type
  TSysProvider = class(TObject)
  private
  FValidNetDevice:boolean;
  FCableOn:boolean;
  UsC:TUsbClasses;
    { Private declarations }
//  Function ProvideRegistryAll:PPci_Info;
// back in private later.


  Procedure AddUSBToPci(var pin:PPci_Info);
  Procedure AddCPUToPci(var pin:PPci_Info);
  Procedure AddKBDToPci(var pin:PPci_Info);
  Procedure AddHHDsToPci(var pin:PPci_Info);


  Function GetMaxDeviceExp:integer;
  Function GetMaxShortSign:integer;
  Function GetMaxUsbClasses:integer;
  Function GetMaxOtherDevices:integer;
  Function ProvideDistroInfo:TUname;
  Function MemoryInfo:cardinal;
  Function CPU_Info:TCpuInfo;
  Function GetHostName:string;
  Function GetUsbInfo:PUsbInfo;
  Procedure ProvideNetDeviceInfo(device:string);
  Function GetIoMem:PIoMem;

  protected
    { Protected declarations }
  public
  DevList:Array[0..MAX_DEVICE_EXP] of String;

  constructor Create;
  destructor Destroy; Override;

  Procedure WriteDistroInfo;
  Procedure WriteHwInfo;

  Function ProvideRegistryAll:PPci_Info;
  // just for testing, back it to private later
  Function GuessManufacturer(manu:string):string;
  Function CreateLocation(pin:PPCi_Info; recno:integer):string;
  Function FindDriver(var pin:PPci_Info; recno:integer):boolean;

  Procedure ChangeDeviceInfo(var pin:PPCi_Info);
  Function  ReorganizeInfo(Const pin:PPCi_Info):PNoDupsPciInfo;

  Property MaxDeviceExp:integer read GetMaxDeviceExp;
  Property MaxOtherDevices:integer read GetMaxOtherDevices;
  Property MaxShortSign:integer read GetMaxShortSign;
  Property MaxUsbClasses:integer read GetMaxUsbClasses;
  Property usbclass:TUsbClasses read Usc;
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
var i:integer;
Begin
        for i:=0 to MAX_DEVICE_EXP do
        DevList[i]:=devices[i];

        usc[0].class_:=USB_CLASS_PER_INTERFACE;
        usc[0].name:='>ifc ';
        usc[1].class_:=USB_CLASS_AUDIO;
        usc[1].name:='audio';
        usc[2].class_:=USB_CLASS_COMM;
        usc[2].name:='comm.';
        usc[3].class_:=USB_CLASS_HID;
        usc[3].name:='HID  ';
        usc[4].class_:=USB_CLASS_PHYSICAL;
        usc[4].name:='PID  ';
        usc[5].class_:=USB_CLASS_STILL_IMAGE;
        usc[5].name:='still';
        usc[6].class_:=USB_CLASS_PRINTER;
        usc[6].name:='print';
        usc[7].class_:=USB_CLASS_MASS_STORAGE;
        usc[7].name:='stor.';
        usc[8].class_:=USB_CLASS_HUB;
        usc[8].name:='hub  ';
        usc[9].class_:=USB_CLASS_CDC_DATA;
        usc[9].name:='data ';
        usc[10].class_:=USB_CLASS_CSCID;
        usc[10].name:='scard';
        usc[11].class_:=USB_CLASS_CONTENT_SEC;
        usc[11].name:='c-sec';
        usc[12].class_:=USB_CLASS_APP_SPEC;
        usc[12].name:='app. ';
        usc[13].class_:=USB_CLASS_VENDOR_SPEC;
        usc[13].name:='vend.';
        usc[14].class_:=USB_CLASS_UNKNOWN;
        usc[14].name:='unk. ';

        for i:=0 to MAX_USB_CLASSES do
        usc[i].cheat:=UsbClassDevices[i];
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
           // reg.DeleteKey;
            reg.Writeinteger(dist_reg[0],struct_Data.dist);
            reg.Writestring(dist_reg[1],struct_Data.name);
            reg.Writestring(dist_reg[2],struct_Data.sys);
            reg.Writestring(dist_reg[3],struct_Data.version);
            reg.Writestring(dist_reg[4],struct_Data.kernel);
            reg.Writestring(dist_reg[5],struct_Data.machine);
            reg.Writestring(dist_reg[6],struct_Data.krnl_date);

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
                una.krnl_date:=reg.Readstring(dist_reg[6]);
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
    counter,i,j,x,bus_id:integer;
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

Function GetUsbValueClassStr(Const value,data:string):String;
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
        ss:=trim(ss);
        if copy(ss,1,2)='00' then ss:='';
        // it's some device so find it ;)
        Result:=ss;
End;



Procedure CheckForClass(var s:string);
var ii,jj:integer;
    ss,sss1:string;
Begin
        ss:=s;
        sss1:=copy(ss,1,2);

        if sss1='ff' then sss1:='255'
        else
        if sss1='fe' then sss1:='254'
        else
        if sss1='0d' then sss1:='13'
        else
        if sss1='0b' then sss1:='11'
        else
        if sss1='0a' then sss1:='10';


        if TryStrToInt(sss1,ii) then begin
                for jj:=0 to MAX_USB_CLASSES do
                if usc[jj].class_=ii then begin
                s:=usc[jj].cheat;
                break;
                End;
        End;
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

                if uusb[bus_id].cls='' then
                uusb[bus_id].cls:=GetUsbValueClassStr(usbinfobus[11],strs.Strings[i]);

                if uusb[bus_id].cls<>'' then begin
                        for x:=0 to MAX_USB_CLASSES do
                        CheckForClass(uusb[bus_id].cls);
                End;

                if uusb[bus_id].driver='' then
                uusb[bus_id].driver:=GetUsbValueStr(usbinfobus[12],strs.Strings[i]);

                if uusb[bus_id].driver<>'' then busfounded:=false;
               End;
        End;

        {$IFDEF DEBUG}
        for i:=0 to Length(uusb)-1 do
        // if manufacturer='' and vendor<>'0000' then search_manufacturer
        writeln('UUSB BUS ',uusb[i].bus,' LEV ',uusb[i].lev,' PRNT ',uusb[i].prnt,' PORT ',uusb[i].port,' DEVICE ',uusb[i].device,' SPD ',uusb[i].spd,' VER ',uusb[i].ver,' VEND ',uusb[i].vendor,' PROD_ID ',uusb[i].prod_id,' MANUF ',uusb[i].manufacturer,' PROD ',uusb[i].product,' Driver=',uusb[i].driver,' CLS ',uusb[i].cls);
        {$ENDIF}
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

Procedure TSysProvider.ChangeDeviceInfo(var pin:PPCi_Info);
var i,j:integer;
Begin
        for i:=0 to length(pin)-1 do begin
                if pin[i].device_type<>'' then begin
                        for j:=0 to MAX_DEVICE_EXP do
                        if pin[i].device_type=devices[j] then
                        pin[i].device_type:=DevicesSigns[j];
                End;
        End;

        AddUSBToPci(pin);
        AddCPUToPci(pin);
        AddKBDToPci(pin);
        AddHHDsToPci(pin);
End;

Function TSysProvider.ReorganizeInfo(Const pin:PPCi_Info):PNoDupsPciInfo;
var pno:PNoDupSPciInfo;
    i,j,x:integer;
    pinn:Array[0..MAX_SIGN_SHORT] of integer;
    idup:Array[0..1024] of integer; // be sure to have enough room for PPci_Info
    st:TStrings;
Begin
        for i:=0 to MAX_SIGN_SHORT do
        pinn[i]:=-1;

        SetLength(pno,MAX_SIGN_SHORT+1);

        for j:=0 to MAX_SIGN_SHORT do begin
                pno[j].kind:=DeviceShortSign[j];
                pno[j].device_type:=DeviceShortSign[j];
                        for x:=0 to 64 do
                        pno[j].device_point[x]:=-1;
        End;

        st:=TStringList.Create;
        try
        for i:=0 to 1024 do
        idup[i]:=0;
        for i:=0 to length(pin)-1 do begin
                if i=0 then
                st.Add(pin[i].device_info)
                else
                begin
                        for j:=0 to St.Count-1 do begin
                                if st.Strings[j]=pin[i].device_info then begin

                                inc(idup[j]); // inc copy of device name
                                pin[i].device_info:=pin[i].device_info+' #'+IntToStr(idup[j]);
                                break;
                                End;
                        End;
                st.Add(pin[i].device_info);
                End;
        // check dups
        End;
        finally
        st.Free;
        End;


        for i:=0 to MAX_SIGN_SHORT do begin
                for j:=0 to length(pin)-1 do begin

                  if (pin[j].device_type=pno[i].kind) and (pin[j].device_info<>'') then begin
                        inc(pinn[i]);
                        pno[i].device_info[pinn[i]]:=pin[j].device_info;

                        if i=8 then begin
                        pno[i].usbclass:=pin[j].usbclass;
                        pno[i].device_class[pinn[i]]:=pin[j].usbclass;
                        pno[i].device_point[pinn[i]]:=j;
                        End;
                        if i=9 then begin
                        pno[i].usbclass:=pin[j].usbclass;
                        pno[i].otherdevice:=pin[j].usbclass;
                        pno[i].device_class[pinn[i]]:=pin[j].usbclass;
                        pno[i].device_point[pinn[i]]:=j;
                        End;
                        if i=10 then begin
                        pno[i].usbclass:=pin[j].usbclass;
                        pno[i].otherdevice:=pin[j].usbclass;
                        pno[i].device_class[pinn[i]]:=pin[j].usbclass;
                        pno[i].device_point[pinn[i]]:=j;
                        End;

                  End;
                End;
        End;



        for i:=0 to MAX_SIGN_SHORT do
        if pinn[i]=-1 then pno[i].device_type:='';

        Result:=pno;
End;

Function TSysProvider.GetMaxDeviceExp:integer;
Begin
        Result:=MAX_DEVICE_EXP;
End;

Function TSysProvider.GetMaxShortSign:integer;
Begin
        Result:=MAX_SIGN_SHORT;
End;

Function TSysProvider.GetMaxUsbClasses:integer;
Begin
        Result:=MAX_USB_CLASSES;
End;

Function TSysProvider.GetMaxOtherDevices:integer;
Begin
        Result:=MAX_OTHER_DEVICES;
End;


Function TSysProvider.GuessManufacturer(manu:string):string;
var j:integer;
    s:string;
Begin
        Result:='Unknown';
        s:=manu;
        s:=trim(s);
        j:=pos(' ',s);
        if j<>0 then begin
        Result:=copy(s,1,j-1);
        End;
End;

Function TSysProvider.CreateLocation(pin:PPCi_Info; recno:integer):string;
Const infos:Array[0..5] of String=('PCI bus','device','function','USB bus','Block Device','SCSI Host');
var i:integer;
    s1,s2:string;
Begin
        Result:=pin[recno].device_info;

        if pin[recno].device_type=DeviceShortSign[8] then begin
                s1:=infos[3];
                s1:=s1+' '+IntToStr(pin[recno].bus_id)+',';
                s1:=s1+infos[1]+' '+IntToStr(pin[recno].device_id)+','+infos[2]+' '+IntToStr(pin[recno].device_function);
        end else
        if pin[recno].device_type=DeviceShortSign[9] then begin
                s1:=infos[0];
                s1:=s1+' '+IntToStr(pin[recno].bus_id)+',';
                if (pin[recno].usbclass=OtherDevices[4]) or (pin[recno].usbclass=OtherDevices[5]) or (pin[recno].usbclass=OtherDevices[6])
                then
                s1:=s1+infos[1]+' /dev/hd'+char(pin[recno].device_id)+','+infos[2]+' '+IntToStr(pin[recno].device_function)
                else
                s1:=s1+infos[1]+' '+IntToStr(pin[recno].device_id)+','+infos[2]+' '+IntToStr(pin[recno].device_function);
        end else
        if pin[recno].device_type=DeviceShortSign[10] then begin
                s1:=infos[5];
                s1:=s1+' Ch: '+IntToStr(pin[recno].bus_id)+',';
                (* bug with recno ?!?
                writeln('RECNO=',recno,' FUNCTION=',pin[recno].device_function);
                *)
                s1:=s1+' Id: '+' '+IntToStr(pin[recno].device_id)+','+' Lun: '+' '+IntToStr(pin[recno].device_function);

        End else begin
                s1:=infos[0];
                s1:=s1+' '+IntToStr(pin[recno].bus_id)+',';
                s1:=s1+infos[1]+' '+IntToStr(pin[recno].device_id)+','+infos[2]+' '+IntToStr(pin[recno].device_function);
        End;
        Result:=s1;
End;


Procedure TSysProvider.AddUSBToPci(var pin:PPci_Info);
var i,j,x,ar_len,us_len:integer;
    usbi:PUsbInfo;
    
Function FindUSBProduct(prod:string):string;
Const keywrds:Array[0..5] of String=('SCANNER','CAMERA','DISC','CDROM','PRINTER','FLOPPY');
var s:string;
    ii:integer;
Begin
        s:=UsbClassDevices[MAX_USB_CLASSES];
        prod:=UpperCase(prod);
        for ii:=0 to 5 do begin
                if AnsiPos(keywrds[ii],prod)<>0 then begin
                        case ii of
                                0,1:s:=UsbClassDevices[5];
                                2,3,4:s:=UsbClassDevices[7];
                                5:s:=UsbClassDevices[6];
                        End; // case ii
                End;
        End;
        Result:=s;
End;

Begin
        ar_len:=length(pin);
        usbi:=GetUsbInfo;
        us_len:=length(usbi);
        SetLength(pin,ar_len+us_len);
        x:=-1;
        for i:=ar_len to length(pin)-1 do begin
                        inc(x);
                        if x<=us_len-1 then begin
                        {$IFDEF DEBUG}
                        writeln('BUS=',usbi[x].bus,' PORT=',usbi[x].port,' VEN ',usbi[x].vendor,' PROD_ID ',usbi[x].prod_id,' MANUF ',usbi[x].manufacturer,' PRODUCT ',usbi[x].product,' CLS ',usbi[x].cls,' DRV ',usbi[x].driver);
                        {$ENDIF}

                        if usbi[x].prod_id='0000' then begin
                        pin[i].bus_id:=usbi[x].bus;
                        pin[i].device_id:=usbi[x].device;
                        pin[i].device_function:=usbi[x].port;
                        pin[i].device_type:=DeviceShortSign[2];
                        pin[i].device_irq:=255;
                        pin[i].device_info:=usbi[x].product;
                        pin[i].sign:=usbi[x].vendor;
                        pin[i].driver:=usbi[x].driver;
                        End else begin
                        pin[i].bus_id:=usbi[x].bus;
                        pin[i].device_id:=usbi[x].device;
                        pin[i].device_function:=usbi[x].port;
                        pin[i].device_type:=DeviceShortSign[8];
                        pin[i].device_irq:=255;
                        if (usbi[x].product<>'') and (usbi[x].cls='') then usbi[x].cls:=FindUsbProduct(usbi[x].product);
                        // ugly
                        if usbi[x].cls='' then usbi[x].cls:=UsbClassDevices[MAX_USB_CLASSES];
                        pin[i].usbclass:=usbi[x].cls;

                        pin[i].device_info:=usbi[x].product;
                        if pin[i].device_info='' then pin[i].device_info:='Unknown USB '+usbi[x].driver+' product';
                        pin[i].sign:=usbi[x].manufacturer;
                        pin[i].driver:=usbi[x].driver;
                        End;
                        End;
        End;
End;

Procedure TSysProvider.AddCPUToPci(var pin:PPci_Info);
var ci:TCpuInfo;
    i:integer;
Begin
        ci:=Cpu_Info;
        i:=length(pin)+1;
        SetLength(pin,i);
        i:=i-1;
        pin[i].bus_id:=ci.processor;
        pin[i].device_id:=ci.processor;
        pin[i].device_function:=ci.processor;
        pin[i].device_type:=DeviceShortSign[9];
        pin[i].device_info:=ci.model_name;
        pin[i].sign:=ci.vendor_id;
        pin[i].device_irq:=255;
        pin[i].usbclass:=OtherDevices[9];
End;

Procedure TSysProvider.AddKBDToPci(var pin:PPci_Info);
var s,s1,s2,io1,io2:string;
    st:TStrings;
    fil:TextFile;
    i,j,x,y:integer;
    founded:boolean;
Begin
        st:=TStringList.Create;
        j:=-1;
        founded:=false;
        try
        AssignFile(fil,'/proc/ioports');
        Reset(fil);
        while not eof(fil) do begin
                readln(fil,s);
                st.Add(s);
        End;
        CloseFile(fil);
        for i:=0 to st.Count-1 do
        if AnsiPos('keyboard',st.Strings[i])<>0 then begin
        j:=i;
        break;
        End;

        if j<>-1 then begin
        x:=Pos(':',st.Strings[j]);
                if x<>0 then begin
                        s:=copy(st.Strings[j],1,x-1);
                        y:=Pos('-',s);
                        if y<>0 then begin
                                io1:=copy(s,1,y-1);
                                io2:=copy(s,y+1,length(s)-(y-1));
                                founded:=true;
                        End;
                End;
        End;

        if founded then begin
        i:=length(pin)+1;
        SetLength(pin,i);
        i:=i-1;
        pin[i].bus_id:=0;
        pin[i].device_id:=0;
        pin[i].device_function:=0;
        pin[i].device_type:=DeviceShortSign[9];
        pin[i].device_info:='Standard 101/102-Key or Linux Natural PS/2 Keyboard';
        pin[i].device_irq:=1;
        pin[i].device_io_from[0]:=io1;
        pin[i].device_io_to[0]:=io2;
        pin[i].sign:='keyboard';
        pin[i].driver:='keyboard';
        pin[i].usbclass:=OtherDevices[1];
        End;

        finally
        st.Free;
        End;
End;

Procedure TSysProvider.AddHHDsToPci(var pin:PPci_Info);
label scsii;
var hdi:PPCi_Info;
    i,j,x,y:integer;
Begin

        hdi:=GetHardDiscs;
        if length(hdi)=0 then goto scsii;

        i:=length(hdi);
        x:=length(pin);
        j:=x+i;
        SetLength(pin,j);
        i:=0;
        for y:=x to length(pin)-1 do begin
                pin[y].bus_id:=hdi[i].bus_id;
                pin[y].device_id:=hdi[i].device_id;
                pin[y].device_function:=hdi[i].device_function;
                pin[y].device_type:=hdi[i].device_type;
                pin[y].device_info:=hdi[i].device_info;
                pin[y].device_irq:=hdi[i].device_irq;
                pin[y].usbclass:=hdi[i].usbclass;
                pin[y].sign:=hdi[i].sign;
                pin[y].driver:=hdi[i].driver;
                inc(i);
        End;

        SetLength(hdi,0);
scsii:
        hdi:=GetScsiDiscs;
        if length(hdi)=0 then exit;

        i:=length(hdi);
        x:=length(pin);
        j:=x+i;
        SetLength(pin,j);
        i:=0;
        for y:=x to length(pin)-1 do begin
                pin[y].bus_id:=hdi[i].bus_id;
                pin[y].device_id:=hdi[i].device_id;
                pin[y].device_function:=hdi[i].device_function;
                pin[y].device_type:=hdi[i].device_type;
                pin[y].device_info:=hdi[i].device_info;
                pin[y].device_irq:=hdi[i].device_irq;
                pin[y].usbclass:=hdi[i].usbclass;
                pin[y].sign:=hdi[i].sign;
                pin[y].driver:=hdi[i].driver;
                inc(i);
        End;

End;

Function TSysProvider.GetIoMem:PIoMem;
var i,j,x,y:integer;
    st:TStrings;
    pm:PioMem;
    fil:TextFile;
    s,s1,s2:string;
Begin
        SetLength(pm,0);
        st:=TStringList.Create;
        try
                AssignFile(fil,'/proc/iomem');
                Reset(fil);
                while not eof(fil) do begin
                        readln(fil,s);
                        st.Add(s);
                End;
                CloseFile(fil);
        SetLength(pm,st.Count+1);

        for i:=0 to st.Count-1 do begin
        st.Strings[i]:=trim(st.Strings[i]);
                j:=Pos(':',st.Strings[i]);
                if j<>0 then begin
                        s1:=copy(st.Strings[i],1,j-1);
                        s1:=trim(s1);
                        x:=Pos('-',s1);
                        if x<>0 then begin
                        pm[i].lo_:=copy(s1,1,x-1);
                        pm[i].hi_:=copy(s1,x+1,length(s1)-(x-1));
                        pm[i].name:=copy(st.Strings[i],j+1,length(st.Strings[i])-(j-1));
                        pm[i].name:=trim(pm[i].name);
                        End;
                End;
        End;

        finally
        st.Free;
        End;
        Result:=pm;
End;

Function TSysProvider.FindDriver(var pin:PPci_Info; recno:integer):boolean;
var i,j,x,y:integer;
    s1,s2:string;
    pmi:PIoMem;

Begin
        Result:=false;
        y:=-1;
        pmi:=GetIOMem;
        {$IFDEF DEBUG}
        for i:=0 to length(pmi)-1 do begin
        writeln('LO ',pmi[i].lo_,' HI ',pmi[i].hi_,' Name ',pmi[i].name);
        End;
        {$ENDIF}

        if recno=-1 then begin // search for all pci devices
        for i:=0 to length(pin)-1 do begin
                if pin[i].usbclass='' then begin

                End;
        End;
        End else begin
                if pin[recno].usbclass='' then begin
                        for j:=0 to length(pmi)-1 do begin
                                if (pmi[j].lo_=pin[recno].non_prefetch_lo) or (pmi[j].lo_=pin[recno].prefetchable_lo) then begin
                                {$IFDEF DEBUG}
                                writeln('Founded driver ',pmi[j].name,' Y=',y);
                                {$ENDIF}
                                Result:=true;
                                if length(pmi[j].name)>2 then
                                y:=j;
                                End;
                        End;
                End;
                if y<>-1 then pin[recno].driver:=pmi[y].name;
        End;
End;


end.
