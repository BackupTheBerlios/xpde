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
unit xpclasses;

interface
        // used by distro.pas
Const diUnknown=0;
      diRedHat=1;
      diMandrake=2;
      diSuse=3;
      diDebian=4;
      diCaldera=5;
      diTurboLinux=6;
      diConectiva=7;
      diLindows=8;
      diSlackware=9;
      FreeBSD=10; // ;) just a hope ....
      dist_reg:Array[0..6] of string=('distribution_enum','distribution_name','distribution_sys','distribution_version','distribution_kernel','distribution_machine','distribution_kernel_date');

Const
      RT_IFACE=0;
      RT_DESTINATION=1;
      RT_GATEWAY=2;
      RT_FLAGS=3;
      RT_REFCNT=4;
      RT_USE=5;
      RT_METRIC=6;
      RT_MASK=7;
      RT_MTU=8;
      RT_WINDOW=9;
      RT_IRTT=10;



type  uname_r = record
        dist   : integer;
        name   :string;
        sys    :string;
        version :string;
        kernel :string;
        machine:string;
        krnl_date:string;
        End;

       T_Uname=uname_r;

      needed_info = record
        net_conf:string;
        ppp_conf:string;
        ifconfig:string;
        route   :string;
        netstat :string;
        End;

        TConfInfo = needed_info;

        // used by hwinfo.pas

Const   MAX_DEVICE_EXP=11;
        MAX_SIGN_SHORT=10;
        MAX_OTHER_DEVICES=10;
        MAX_USB_CLASSES=14;
        MAX_BUSVALUES=2;
        MAX_KWORDS=4;
        MAX_USB_INFO=12;
        devices:Array[0..MAX_DEVICE_EXP] of string=('Host bridge:','PCI bridge:',
        'ISA bridge:','IDE interface:','SMBus:','USB Controller:',
        'VGA compatible controller:','Ethernet controller:',
        'Network controller:','Unknown mass storage controller:',
        'Multimedia audio controller:','Input device controller:');

        busvalues:Array [0..MAX_BUSVALUES] of String=('Bus','device','function');
        keywrds:Array[0..MAX_KWORDS] of string=('I/O','IRQ','Master Capable.','Non-prefetchable','Prefetchable');

        usbinfobus:Array[0..MAX_USB_INFO] of String=('Bus=','Lev=','Prnt=',
                'Port=','Dev#=','Spd=','Ver=','Vendor=','ProdID=',
                'Manufacturer=','Product=','Cls=','Driver=');

      HDIO_GET_IDENTITY=$00000307;

type devices_list=(dlHostBridge,dlISABridge,dlIDEInterface,dlSMBus,
                   dlUSBController,dlVGA,dlEth,dlNet,dlUnknownMassStorage,
                   dlMMAudio,dlInputDevice);                                   
(*
type usb_devices=(USB_NULL,USB_CLASS_PER_INTERFACE,USB_CLASS_AUDIO,
USB_CLASS_COMM,USB_CLASS_HID,USB_CLASS_HUB,USB_CLASS_PHYSICAL,
USB_CLASS_PRINTER,USB_CLASS_MASS_STORAGE,USB_CLASS_CDC_DATA,
USB_CLASS_APP_SPEC,USB_VENDOR_SPEC,USB_CLASS_STILL_IMAGE,
USB_CLASS_CSCID,USB_CLASS_CONTENT_SEC);
*)

type usb_classes=record
        class_:integer;
        name:string(.5.);
        cheat:string; // ;)
        End;
        TUsb_Classes=Array[0..MAX_USB_CLASSES] of usb_classes;
(*
{				     max. 5 chars. per name string
	{USB_CLASS_PER_INTERFACE,	">ifc"},
	{USB_CLASS_AUDIO,		"audio"},
	{USB_CLASS_COMM,		"comm."},
	{USB_CLASS_HID,			"HID"},
	{USB_CLASS_HUB,			"hub"},
	{USB_CLASS_PHYSICAL,		"PID"},
	{USB_CLASS_PRINTER,		"print"},
	{USB_CLASS_MASS_STORAGE,	"stor."},
	{USB_CLASS_CDC_DATA,		"data"},
	{USB_CLASS_APP_SPEC,		"app."},
	{USB_CLASS_VENDOR_SPEC,		"vend."},
	{USB_CLASS_STILL_IMAGE,		"still"},
	{USB_CLASS_CSCID,		"scard"},
	{USB_CLASS_CONTENT_SEC,		"c-sec"},
	{-1,				"unk."}
}
  *)
type usb_info_bus=record
        bus:integer;
        lev:integer;
        prnt:integer;
        port:integer;
        device:integer;
        spd:integer;
        ver:string;
        vendor:string;
        prod_id:string;
        manufacturer:string;
        product:string;
        cls:string; // TUsbClasses connection !
        driver:string;
        End;
        TUsbInfo=usb_info_bus;
        PUsbInfo_=Array of TUsbInfo;

type pci_additional_info=record
        master_capable:boolean;
        no_bursts:boolean;
        latency:integer;
        gnt:integer;
        lat:integer;
        End;
        Tpci_add=pci_additional_info;

        // registry entries
Const pci_reg:Array[0..14] of string=('device_type',
        'device_info','device_irq',
        'master_capable','no_bursts','latency','gnt','lat',
        'device_io_from','device_io_to','non_prefetch_lo',
        'non_prefetch_hi','prefetchable_lo','prefetchable_hi','driver');

type pci_info_=record
        bus_id:byte; // BUS NUM
        device_id:byte; // id
        device_function:byte; // function 0..X -> device tree
        device_type:String; // type -> from devices[n]
        device_info:String; // manufacturer,chipset name
        device_irq:byte; // irq
        device_add:Tpci_add; // additional info
        device_io_from:Array[0..31] of string; // IO
        device_io_to:Array[0..31] of string; // IO
        non_prefetch_lo:string;
        non_prefetch_hi:string;
        prefetchable_lo:string;
        prefetchable_hi:string;
        usbclass:string;
        sign:string; // eth0,ippp0,sb..etc
        driver:string;
        End;
        Tpci_info=pci_info_;
        Ppci_info_=Array of TPci_Info;

type nodups_pci_info=record
        kind:string;
        device_type:string;
        usbclass:string;
        otherdevice:string;
        device_point:Array[0..64] of integer;
        device_class:Array[0..64] of string;
        device_info:Array[0..64] of string;
        End;
        TNoDups_Pci_Info=nodups_pci_info;
        PNoDups_Pci_Info=Array of TNoDups_Pci_Info;

type bus_value=record
        bus:integer;
        device:integer;
        func:integer;
        End;
        Tbus_Value=bus_value;

type io_value=record
        from_address:string;
        to_address:string;
        End;
        Tio_value=io_value;


        // usb informations
type hd_driveiid=record
        config:integer;
        cyls:integer;
        reserved2:integer;
        heads:integer;
        track_bytes:integer;
        sector_bytes:integer;
        sectors:integer;
        vendor0:integer;
        vendor1:integer;
        vendor2:integer;
        serial_no:Array[0..19] of char;
        buf_type:integer;
        buf_size:integer;
        ecc_bytes:integer;
        fw_rev:Array[0..7] of char;
        model:Array[0..39] of char;
        max_multsect:Word;
        vendor3:Word;
        dword_io:integer;
        vendor4:Word;
        capability:Word;
        reserved50:integer;
        vendor5:Word;
        tPIO:Word;
        vendor6:Word;
        tDMA:Word;
        field_valid:integer;
        cur_cyls:integer;
        cur_heads:integer;
        cur_sectors:integer;
        cur_capacity0:integer;
        cur_capacity1:integer;
        multsect:Word;
        multsect_valid:Word;
        lba_capacity:longint;
        dma_1word:Word;
        dma_mword:Word;
        eide_pio_modes:Word;
        eide_dma_min:Word;
        eide_dma_time:Word;
        eide_pio:Word;
        eide_pio_iordy:Word;
        words69_70:Array [0..1] of char;
        words71_74:Array [0..3] of char;
        queue_depth:Word;
        words76_79:Array [0..3] of char;
        major_rev_num:Word;
        minor_rev_num:Word;
        command_set_1:Word;
        command_set_2:Word;
        cfsse:Word;
        cfs_enable_1:Word;
        cfs_enable_2:Word;
        cfs_default:Word;
        dma_ultra:Word;
        trseuc:Word;
        trsEuc_:Word;
        CurAPMValues:Word;
        mprc:Word;
        hw_config:Word;
        acoustic:Word;
        msrqs:Word;
        sxfert:Word;
        sal:Word;
        spg:Integer;
        lba_capacity_2:cardinal;
        word104_125:Array[0..21] of char;
        last_lun:word;
        word127:word;
        dlf:word;
        csfo:word;
        words130_155:Array[0..25] of char;
        word156:word;
        words157_159:Array[0..2] of char;
        cfa_power:word;
        words161_175:Array[0..14] of char;
        words176_205:Array[0..29] of char;
        words206_254:Array[0..48] of char;
        integrity_word:word;
     End;
     hd_driveid=hd_driveiid;
//	unsigned char	serial_no[20];	/* 0 = not_specified */
//	unsigned char	capability;	/* (upper byte of word 49)
//					 *  3:	IORDYsup
//					 *  2:	IORDYsw
//					 *  1:	LBA
//             				 *  0:	DMA

type cpu_info=record
        processor:byte;
        vendor_id:string;
        cpu_family:string;
        model:string;
        model_name:string;
        cpu_mhz:string;
        cpu_cache:string;
        bogomips:string;
        End;
        TCpuInfo_=cpu_info;

implementation

end.
