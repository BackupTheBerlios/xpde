unit usb;
interface

Type
    PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^LongWord;
    PDouble   = ^Double;
    u_int8_t  = byte;
    u_int16_t = word;
    dword = longword;
    size_t = cardinal;
    Pusb_dev_handle= PLongint;

  {
     USB spec information

     This is all stuff grabbed from various USB specs and is pretty much
     not subject to change
    }
  {
     Device and/or Interface Class codes
    }
  { for DeviceClass  }

  const
     PATH_MAX=1024;
     USB_CLASS_PER_INTERFACE = 0;
     USB_CLASS_AUDIO = 1;
     USB_CLASS_COMM = 2;
     USB_CLASS_HID = 3;
     USB_CLASS_PRINTER = 7;
     USB_CLASS_MASS_STORAGE = 8;
     USB_CLASS_HUB = 9;
     USB_CLASS_DATA = 10;
     USB_CLASS_VENDOR_SPEC = $ff;
  {
     Descriptor types
    }
     USB_DT_DEVICE = $01;
     USB_DT_CONFIG = $02;
     USB_DT_STRING = $03;
     USB_DT_INTERFACE = $04;
     USB_DT_ENDPOINT = $05;
     USB_DT_HID = $21;
     USB_DT_REPORT = $22;
     USB_DT_PHYSICAL = $23;
     USB_DT_HUB = $29;
  {
     Descriptor sizes per descriptor type
    }
     USB_DT_DEVICE_SIZE = 18;
     USB_DT_CONFIG_SIZE = 9;
     USB_DT_INTERFACE_SIZE = 9;
     USB_DT_ENDPOINT_SIZE = 7;
  { Audio extension  }
     USB_DT_ENDPOINT_AUDIO_SIZE = 9;
     USB_DT_HUB_NONVAR_SIZE = 7;
  { All standard descriptors have these 2 fields in common  }

  type
     Pusb_descriptor_header = ^usb_descriptor_header;
     usb_descriptor_header = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
       end;

  { String descriptor  }
     Pusb_string_descriptor = ^usb_string_descriptor;
     usb_string_descriptor = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
          wData : array[0..0] of u_int16_t;
       end;

  { HID descriptor  }
     Pusb_hid_descriptor = ^usb_hid_descriptor;
     usb_hid_descriptor = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
          bcdHID : u_int16_t;
          bCountryCode : u_int8_t;
          bNumDescriptors : u_int8_t;
       end;

  { Endpoint descriptor  }

  const
     USB_MAXENDPOINTS = 32;
  { Extra descriptors  }

  type
     Pusb_endpoint_descriptor = ^usb_endpoint_descriptor;
     usb_endpoint_descriptor = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
          bEndpointAddress : u_int8_t;
          bmAttributes : u_int8_t;
          wMaxPacketSize : u_int16_t;
          bInterval : u_int8_t;
          bRefresh : u_int8_t;
          bSynchAddress : u_int8_t;
          extra : Pbyte;
          extralen : longint;
       end;

  { in bEndpointAddress  }

  const
     USB_ENDPOINT_ADDRESS_MASK = $0f;
     USB_ENDPOINT_DIR_MASK = $80;
  { in bmAttributes  }
     USB_ENDPOINT_TYPE_MASK = $03;
     USB_ENDPOINT_TYPE_CONTROL = 0;
     USB_ENDPOINT_TYPE_ISOCHRONOUS = 1;
     USB_ENDPOINT_TYPE_BULK = 2;
     USB_ENDPOINT_TYPE_INTERRUPT = 3;
  { Interface descriptor  }
     USB_MAXINTERFACES = 32;
  { Extra descriptors  }

  type
     Pusb_interface_descriptor = ^usb_interface_descriptor;
     usb_interface_descriptor = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
          bInterfaceNumber : u_int8_t;
          bAlternateSetting : u_int8_t;
          bNumEndpoints : u_int8_t;
          bInterfaceClass : u_int8_t;
          bInterfaceSubClass : u_int8_t;
          bInterfaceProtocol : u_int8_t;
          iInterface : u_int8_t;
          endpoint : Pusb_endpoint_descriptor;
          extra : Pbyte;
          extralen : longint;
       end;

  { Hard limit  }

  const
     USB_MAXALTSETTING = 128;

  type
     Pusb_interface = ^usb_interface;
     usb_interface = record
          altsetting : Pusb_interface_descriptor;
          num_altsetting : longint;
       end;

  { Configuration descriptor information..  }

  const
     USB_MAXCONFIG = 8;
  { Extra descriptors  }

  type
     Pusb_config_descriptor = ^usb_config_descriptor;
     usb_config_descriptor = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
          wTotalLength : u_int16_t;
          bNumInterfaces : u_int8_t;
          bConfigurationValue : u_int8_t;
          iConfiguration : u_int8_t;
          bmAttributes : u_int8_t;
          MaxPower : u_int8_t;
          uinterface : Pusb_interface;
          extra : Pbyte;
          extralen : longint;
       end;

  { Device descriptor  }
     Pusb_device_descriptor = ^usb_device_descriptor;
     usb_device_descriptor = record
          bLength : u_int8_t;
          bDescriptorType : u_int8_t;
          bcdUSB : u_int16_t;
          bDeviceClass : u_int8_t;
          bDeviceSubClass : u_int8_t;
          bDeviceProtocol : u_int8_t;
          bMaxPacketSize0 : u_int8_t;
          idVendor : u_int16_t;
          idProduct : u_int16_t;
          bcdDevice : u_int16_t;
          iManufacturer : u_int8_t;
          iProduct : u_int8_t;
          iSerialNumber : u_int8_t;
          bNumConfigurations : u_int8_t;
       end;

  {
     Standard requests
    }

  const
     USB_REQ_GET_STATUS = $00;
     USB_REQ_CLEAR_FEATURE = $01;
  { 0x02 is reserved  }
     USB_REQ_SET_FEATURE = $03;
  { 0x04 is reserved  }
     USB_REQ_SET_ADDRESS = $05;
     USB_REQ_GET_DESCRIPTOR = $06;
     USB_REQ_SET_DESCRIPTOR = $07;
     USB_REQ_GET_CONFIGURATION = $08;
     USB_REQ_SET_CONFIGURATION = $09;
     USB_REQ_GET_INTERFACE = $0A;
     USB_REQ_SET_INTERFACE = $0B;
     USB_REQ_SYNCH_FRAME = $0C;
     USB_TYPE_STANDARD = $00 shl 5;
     USB_TYPE_CLASS = $01 shl 5;
     USB_TYPE_VENDOR = $02 shl 5;
     USB_TYPE_RESERVED = $03 shl 5;
     USB_RECIP_DEVICE = $00;
     USB_RECIP_INTERFACE = $01;
     USB_RECIP_ENDPOINT = $02;
     USB_RECIP_OTHER = $03;
  {
     Various libusb API related stuff
    }
     USB_ENDPOINT_IN = $80;
     USB_ENDPOINT_OUT = $00;
  { Error codes  }
     USB_ERROR_BEGIN = 500000;
  { Darwin support  }

  type
     Pusb_device = ^usb_device;
     Pusb_bus = ^usb_bus;
     usb_bus = record
          next : Pusb_bus;
          prev : Pusb_bus;
          dirname : array[0..(PATH_MAX + 1)-1] of char;
          devices : Pusb_device;
       end;


     usb_device = record
          next : Pusb_device;
          prev : Pusb_device;
          filename : array[0..(PATH_MAX + 1)-1] of char;
          bus : Pusb_bus;
          descriptor : usb_device_descriptor;
          config : Pusb_config_descriptor;
          dev : pointer;
       end;



  function usb_open(dev:Pusb_device):Pusb_dev_handle;

  function usb_close(dev:Pusb_dev_handle):longint;

  function usb_bulk_write(dev:Pusb_dev_handle; ep:longint; bytes:Pchar; size:longint; timeout:longint):longint;

  function usb_bulk_read(dev:Pusb_dev_handle; ep:longint; bytes:Pchar; size:longint; timeout:longint):longint;

  function usb_control_msg(dev:Pusb_dev_handle; requesttype:longint; request:longint; value:longint; index:longint; 
             bytes:Pchar; size:longint; timeout:longint):longint;

  function usb_set_configuration(dev:Pusb_dev_handle; configuration:longint):longint;

  function usb_claim_interface(dev:Pusb_dev_handle; uinterface:longint):longint;

  function usb_release_interface(dev:Pusb_dev_handle; uinterface:longint):longint;

  function usb_set_altinterface(dev:Pusb_dev_handle; alternate:longint):longint;

  function usb_resetep(dev:Pusb_dev_handle; ep:dword):longint;

  function usb_clear_halt(dev:Pusb_dev_handle; ep:dword):longint;

  function usb_reset(dev:Pusb_dev_handle):longint;

  function usb_get_string(dev:Pusb_dev_handle; index:longint; langid:longint; buf:Pchar; buflen:size_t):longint;

  function usb_get_string_simple(dev:Pusb_dev_handle; index:longint; buf:Pchar; buflen:size_t):longint;

  function usb_strerror:Pchar;

  procedure usb_init;

  procedure usb_set_debug(level:longint);

  function usb_find_busses:longint;

  function usb_find_devices:longint;


implementation

  function usb_open(dev:Pusb_device):Pusb_dev_handle;
  begin
    { You must implemented this function }
  end;
  function usb_close(dev:Pusb_dev_handle):longint;
  begin
    { You must implemented this function }
  end;
  function usb_bulk_write(dev:Pusb_dev_handle; ep:longint; bytes:Pchar; size:longint; timeout:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_bulk_read(dev:Pusb_dev_handle; ep:longint; bytes:Pchar; size:longint; timeout:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_control_msg(dev:Pusb_dev_handle; requesttype:longint; request:longint; value:longint; index:longint; 
             bytes:Pchar; size:longint; timeout:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_set_configuration(dev:Pusb_dev_handle; configuration:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_claim_interface(dev:Pusb_dev_handle; uinterface:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_release_interface(dev:Pusb_dev_handle; uinterface:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_set_altinterface(dev:Pusb_dev_handle; alternate:longint):longint;
  begin
    { You must implemented this function }
  end;
  function usb_resetep(dev:Pusb_dev_handle; ep:dword):longint;
  begin
    { You must implemented this function }
  end;
  function usb_clear_halt(dev:Pusb_dev_handle; ep:dword):longint;
  begin
    { You must implemented this function }
  end;
  function usb_reset(dev:Pusb_dev_handle):longint;
  begin
    { You must implemented this function }
  end;
  function usb_get_string(dev:Pusb_dev_handle; index:longint; langid:longint; buf:Pchar; buflen:size_t):longint;
  begin
    { You must implemented this function }
  end;
  function usb_get_string_simple(dev:Pusb_dev_handle; index:longint; buf:Pchar; buflen:size_t):longint;
  begin
    { You must implemented this function }
  end;
  function usb_strerror:Pchar;
  begin
    { You must implemented this function }
  end;
  procedure usb_init;
  begin
    { You must implemented this function }
  end;
  procedure usb_set_debug(level:longint);
  begin
    { You must implemented this function }
  end;
  function usb_find_busses:longint;
  begin
    { You must implemented this function }
  end;
  function usb_find_devices:longint;
  begin
    { You must implemented this function }
  end;

end.
