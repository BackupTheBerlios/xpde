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

unit uConnectionStatus;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls, uQXPComCtrls, uNetworkConnectionDetails,
  QTypes;

type
  TConnectionStatusDlg = class(TForm)
    btnRepair: TButton;
    btnDetails: TButton;
    lbGateway: TLabel;
        Label26:TLabel;
    lbMask: TLabel;
        Label24:TLabel;
    lbIP: TLabel;
        Label22:TLabel;
    lbType: TLabel;
        Label20:TLabel;
        GroupBox3:TGroupBox;
    btnDisable: TButton;
    btnProperties: TButton;
    lbReceive: TLabel;
    lbSent: TLabel;
        Label12:TLabel;
        Label11:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        Label8:TLabel;
        GroupBox2:TGroupBox;
    lbSpeed: TLabel;
        Label5:TLabel;
    lbDuration: TLabel;
        Label3:TLabel;
    lbStatus: TLabel;
        Label1:TLabel;
        GroupBox1:TGroupBox;
    tsSupport: TTabSheet;
    pcConnection: TPageControl;
        Button4:TButton;
        Button3:TButton;
    btnClose: TButton;
    btnOk: TButton;
    tsGeneral: TTabSheet;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Timer1: TTimer;
    procedure btnDetailsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type network_info = record
        // /proc/net/dev entries
        device:string;
        bytes_in:double;
        packets_in:double;
        errs_in:longint;
        drop_in:longint;
        fifo_in:longint;
        frame:longint;
        compr_in:longint;
        mcast:longint;
        bytes_out:double;
        packets_out:double;
        errs_out:longint;
        drop_out:longint;
        fifo_out:longint;
        colls:longint;
        carrier:longint;
        compr_out:longint;
        // /proc/net/arp entries
        ip_addr:string;
        hw_type:string;
        flags:string;
        hw_addr:string;
        mask_arp:string;
        device_kind:string; // my entry, just as an alias to look as XP ;)
        // /proc/net/route entries
        bcast:string;
        dest:string;
        mask:string;
        gw:string;
        mtu:string;
        // /etc/resolv.conf
        dns_server1:string;
        dns_server2:string;
        End;

var
  ConnectionStatusDlg: TConnectionStatusDlg;
    devs_matrix:Array[0..20,0..351] of longint; // width points of PB5
        // FIXME now we have max 21 net device ;)
    dev_names:Array[0..20] of string;
    diff_net:Array[0..20,0..0] of double;
    net_info:Array [0..20] of network_info; // we will take info dinamically
    device_number:integer; // global !!

   Procedure Read_Net(netfile:string); // later it'll go to common
   Procedure Fill_Net_Devices(device:string);
   Procedure Get_Info_From_Netstat(device:string);


implementation
uses Libc,StrUtils;
{$R *.xfm}

Procedure Read_Net(netfile:string);
var netstr_:TStrings;
    i,x,j,jj:integer;
    fi:TextFile;
    sbuf,ss:string;
    bytes_in,bytes_out,packets_in,packets_out:double;
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
        dev_names[i-2]:=copy(netstr_.Strings[i],1,j-1); // GOES OUT
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
                          // SO IT WILL BE EXCLUDED
                          // devs_matrix[i,du_y]:=trunc(bytes_in - diff_net[i,0]);
                          // diff_net[i,0]:=bytes_in;
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

 //                       sbuf:=copy(sbuf,j+1,length(sbuf));
                        Delete(sbuf,1,j);

        End;

        End; // jj

        End;

        finally
        netstr_.Free;
        End;
End;


Procedure Fill_Net_Devices(device:string);  // /proc/net/arp
var i:integer;
    res:TStrings;
    fi:TextFile;

Function Sign_Device(device__:string):string;
var ss:string;
Begin
        device:=trim(device__);
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

Procedure Fill_Route(device:string);
var res,res2:TStrings;
    i,ii,iii:integer;
    data_:Array[1..10] of string;

Function Find_Device_Route(device_:string):TStrings;
var s:String;
    sbuf:Array[1..20] of string;
    y,x,j,jj:integer;
    fi:TextFile;
Begin
        if device_<>'lo' then begin
        jj:=0;
        AssignFile(fi,'/proc/net/route');
        Reset(fi);
        while not eof(fi) do begin
        inc(jj);
        readln(fi,sbuf[jj]);
        sbuf[jj]:=trim(sbuf[jj]);
        sbuf[jj]:=sbuf[jj]+' ';
        j:=pos(' ',sbuf[jj]);
        if j<>0 then begin
        s:=copy(sbuf[jj],1,j-1);
        s:=trim(s);
        End;
        End;
        CloseFile(fi);

        for j:=2 to jj do begin
        for y:=1 to length(sbuf[j]) do begin
        x:=pos(' ',sbuf[j]);
        if x<>0 then begin
        s:=copy(sbuf[j],1,x-1);
        res.Add(s);
        Delete(sbuf[j],1,x);
//        sbuf:=copy(sbuf,x+1,length(sbuf));
        sbuf[j]:=trimleft(sbuf[j]);
        End;
        End;
        End;

        end else begin
                res.Add(device_);
                for j:=1 to 10 do
                res.Add('0');

        End;
Result:=res;
End;

Function ReverseString(s:string):string;
var ss,sss:string;
Begin
ss:='';
sss:=s;
repeat
ss:=ss+copy(sss,length(sss)-1,2);
Delete(sss,length(sss)-1,2);
until length(sss)=0;
Result:=ss;
End;

Function StrTo_IP(s:string):string;
var by:Array[1..4] of integer;
    ss:string;
    bi:integer;

function hex_val(hex: string) : integer;
var
  hex_out: integer;
  hex_temp: integer;
  hex_mas: string;
begin
  hex_mas := '0123456789ABCDEF';
  hex_out := 0;
  while length(hex) > 0 do begin
    hex_temp := Pos(hex[1],hex_mas);
    hex_out := hex_out * 16 + (hex_temp)-1;
    hex := copy(hex,2,255);
  end;
  Result := hex_out;
End;

Begin

ss:='';

for bi:=1 to 4 do begin
        case bi of
                1:by[bi]:=hex_val(copy(s,1,2));
                2:by[bi]:=hex_val(copy(s,3,2));
                3:by[bi]:=hex_val(copy(s,5,2));
                4:by[bi]:=hex_val(copy(s,7,2));
              End;
End;
ss:=IntToStr(by[1])+'.'+IntToStr(by[2])+'.'+IntToStr(by[3])+'.'+IntToStr(by[4]);
Result:=ss;
End;

Begin
        res:=TStringList.Create;
        res2:=TStringList.Create;
        try
        Find_Device_Route(device);
        for i:=0 to res.Count-1 do begin
        res.Strings[i]:=res.Strings[i]+#9;
        repeat
        ii:=pos(#9,res.Strings[i]);
        if ii<>0 then begin
        res2.Add(copy(res.Strings[i],1,ii-1));
        res.Strings[i]:=copy(res.Strings[i],ii+1,length(res.Strings[i]));
        res.Strings[i]:=trimleft(res.Strings[i]);
        End;
        until ii=0;
        End;
       // End;
        finally
        ii:=-1;
        repeat
        inc(ii,1);
// We have to do this since Mask and Gw are in different lines.
// so I decide to find entry for gw which is <> StrToInt(res2.strings)
        iii:=0;
        if res2.Strings[ii]=device then begin
        for i:=ii+1 to ii+10 do begin
        inc(iii);
        try
//      IP data is reversed and HEX so we have to reverse strings two by two
//      if length = 8 ffffffff
        if length(res2.Strings[i])=8 then begin
        data_[iii]:=StrTo_IP(ReverseString(res2.Strings[i]));
 //       writeln('iii ',iii,'  ',data_[iii]);
        end
        else begin
        data_[iii]:=res2.Strings[i];
 //       writeln('iii ',iii,'  ',data_[iii]);
        End;
        except
        data_[iii]:='';
        End;
        End;
        End;
        
        if data_[3]='0001' then net_info[device_number].mask:=data_[7]
        else
        if data_[3]='0003' then net_info[device_number].gw:=data_[2];
        inc(ii,10);
        until ii>=res2.Count-1;

        res2.Free;
        res.Free;
        End;
End;

Function Give_Device_Arp(device_:string):TStrings;
var sbuf,s:String;
    y,x:integer;
Begin
//        device:=trim(device);
        if device_<>'lo' then begin
        AssignFile(fi,'/proc/net/arp');
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        sbuf:=trim(sbuf);
        s:=copy(sbuf,length(sbuf)-(length(device_)-1),length(device));
        if s=device_ then
        break;
        End;
        CloseFile(fi);

        // HOPE THAT WE FOUND DEVICE :)
        // parse sbuf and each result add to TStringList
        sbuf:=sbuf+' ';
        for y:=1 to length(sbuf) do begin
        x:=pos(' ',sbuf);
        if x<>0 then begin
        s:=copy(sbuf,1,x-1);
        res.Add(s);
        sbuf:=copy(sbuf,x+1,length(sbuf));
        sbuf:=trimleft(sbuf);
        End;
End;

        end else begin
                res.Add('127.0.0.1');
                res.Add('0');
                res.Add('0');
                res.Add('0');
                res.Add('*');
                res.Add(device_);
        End;
Result:=res;
End;

// HERE WE START
Begin
                for i:=0 to 20 do
                        if net_info[i].device=device then begin
                        res:=TStringList.Create;
                        net_info[i].device_kind:=Sign_Device(net_info[i].device);
                        res:=Give_Device_Arp(net_info[i].device);
                        net_info[i].ip_addr:=res.Strings[0];
                        net_info[i].hw_type:=res.Strings[1];
                        net_info[i].flags:=res.Strings[2];
//                        net_info[i].hw_addr:=res.Strings[3];
                        net_info[i].mask_arp:=res.Strings[4];
                        res.Free;
                        End;
                        Fill_Route(device);
End;

// I'vE messed up things a bit ;( so I will parse netstat -ine output for now

function _get_tmp_fname:String;
begin
        Result:='/tmp/'+FormatDateTime('XPdeTaskManager.hh.mm.ss.ms',Now)+
        Format('.%d.%d.%d',[Random($FFFF),Random($FFFF),Random($FFFF)]);
end;

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
                        net_info[device_number].hw_addr:=trim(sbuf);
                        // hwaddr

                        inc(i);
                        sbuf:=tmps[i]+' ';
                        sbuf:=trimleft(sbuf);
                        j:=pos(' ',sbuf);
                        if j<>0 then
                        net_info[device_number].ip_addr:=copy(sbuf,1,j-1);
                        sbuf:=copy(sbuf,j+1,length(sbuf));
                        sbuf:=trimleft(sbuf);
                        j:=pos(' ',sbuf);
                        if j<>0 then
                        net_info[device_number].bcast:=copy(sbuf,1,j-1);
                        sbuf:=copy(sbuf,j+1,length(sbuf));
                        net_info[device_number].mask:=trim(sbuf);

                        End;
                End;
        End;
        inc(i);
        until i=tmps.Count-1;

     //   writeln(tmps.Text);
        finally
        DeleteFile(tmpfile_);
        tmps.Free;
        End;
End;



procedure TConnectionStatusDlg.btnDetailsClick(Sender: TObject);
begin
    with TNetworkConnectionDetailsDlg.create(application) do begin
        try
            showmodal;
        finally
            free;
        end;
    end;
end;

procedure TConnectionStatusDlg.btnCloseClick(Sender: TObject);
begin
    close;
end;

procedure TConnectionStatusDlg.FormCreate(Sender: TObject);
begin
    pcConnection.activepage:=tsGeneral;
end;

procedure TConnectionStatusDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action:=caFree;
end;

procedure TConnectionStatusDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
CanClose:=true;
end;

procedure TConnectionStatusDlg.FormShow(Sender: TObject);
begin
lbSent.Caption:=FloatToStrF(net_info[device_number].packets_out,ffFixed,12,0);
lbReceive.Caption:=FloatToStrF(net_info[device_number].packets_in,ffFixed,12,0);
if (net_info[device_number].bytes_in<>0) and (net_info[device_number].bytes_out<>0) then
        lbStatus.Caption:='Connected'
        else
        lbStatus.Caption:='Disconnected';
        lbDuration.Caption:=TimeToStr(now);

        if net_info[device_number].device='lo' then
        lbSpeed.Caption:='Loop' else
        if copy(net_info[device_number].device,1,3)='eth' then
        lbSpeed.Caption:='10/100Mbps' else
        if copy(net_info[device_number].device,1,3)='ppp' then
        lbSpeed.Caption:='56k' else
        if copy(net_info[device_number].device,1,3)='ipp' then
        lbSpeed.Caption:='128k' else
        lbSpeed.Caption:='Unknown';        


        lbType.Caption:=net_info[device_number].device_kind;
        lbIP.Caption:=net_info[device_number].ip_addr;
        lbMask.Caption:=net_info[device_number].mask;
        lbGateway.Caption:=net_info[device_number].gw;
end;

procedure TConnectionStatusDlg.Timer1Timer(Sender: TObject);
begin
Read_Net('/proc/net/dev');
Fill_Net_Devices(net_info[device_number].device);
        Get_Info_From_Netstat(net_info[device_number].device);
lbSent.Caption:=FloatToStrF(net_info[device_number].packets_out,ffFixed,12,0);
lbReceive.Caption:=FloatToStrF(net_info[device_number].packets_in,ffFixed,12,0);
if (net_info[device_number].bytes_in<>0) and (net_info[device_number].bytes_out<>0) then
        lbStatus.Caption:='Connected'
        else
        lbStatus.Caption:='Disconnected';
        lbDuration.Caption:=TimeToStr(now);
        if net_info[device_number].device='lo' then
        lbSpeed.Caption:='Loop' else
        if copy(net_info[device_number].device,1,3)='eth' then
        lbSpeed.Caption:='10/100Mbps' else
        if copy(net_info[device_number].device,1,3)='ppp' then
        lbSpeed.Caption:='56k' else
        if copy(net_info[device_number].device,1,3)='ipp' then
        lbSpeed.Caption:='128k' else
        lbSpeed.Caption:='Unknown';        



        lbType.Caption:=net_info[device_number].device_kind;
        lbIP.Caption:=net_info[device_number].ip_addr;
        lbMask.Caption:=net_info[device_number].mask;
        lbGateway.Caption:=net_info[device_number].gw;
end;

procedure TConnectionStatusDlg.FormResize(Sender: TObject);
begin
Height:=319;
Width:=338;
end;


end.
