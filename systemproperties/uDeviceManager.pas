unit uDeviceManager;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QMenus,QComCtrls, QExtCtrls, SysProvider,
  QImgList, uXPPopupMenu, uHWProperties;

type
  TfrmSystem = class(TForm)
    Menu: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Action1: TMenuItem;
    Help1: TMenuItem;
    View1: TMenuItem;
    Devicesbytype1: TMenuItem;
    Devicesbyconnection1: TMenuItem;
    Resourcesbytype1: TMenuItem;
    Resourcesbyconnection1: TMenuItem;
    N2: TMenuItem;
    Showhiddendevices1: TMenuItem;
    N3: TMenuItem;
    Customize1: TMenuItem;
    Help2: TMenuItem;
    HelpTopics1: TMenuItem;
    N4: TMenuItem;
    AboutXPdeManagementConsole1: TMenuItem;
    AboutDeviceManager1: TMenuItem;
    PA1: TPanel;
    TV1: TTreeView;
    Imgl1: TImageList;
    XPPopup1: TXPPopupMenu;
    UpdateDriver1: TMenuItem;
    Disable1: TMenuItem;
    Uninstall1: TMenuItem;
    N5: TMenuItem;
    Scanforhardwarechanges1: TMenuItem;
    N6: TMenuItem;
    Properties1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TV1DblClick(Sender: TObject);
  private
    Function  CallProperties(Sender: TfrmProp; devinfo:string; fi:PPci_Info; sp:TSysProvider; absindex:integer):boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSystem: TfrmSystem;
  tv2:TTreeView;
  fi:PPci_Info;
  sp:TSysProvider;

implementation


{$R *.xfm}

procedure TfrmSystem.FormShow(Sender: TObject);
var i,j,x,xx,ui,fde:integer;
    no,no1:TTreeNode;
    pnd:PNoDupSPciInfo;
    isdupdev:boolean;
    stusb,stoth:TStrings; // check for duplicates in devices
begin
        isdupdev:=false;
        ui:=-1;
        stusb:=TStringList.Create;
        stoth:=TStringList.Create;

        sp:=TSysProvider.Create;
        fi:=sp.ProvideRegistryAll;

        sp.ChangeDeviceInfo(fi);


        pnd:=sp.ReorganizeInfo(fi);
        tv1.ReadOnly:=true;


        no:=tv1.Items.Add(Nil,sp.Hostname);
        no.ImageIndex:=9;


        for i:=0 to sp.MaxShortSign do begin
             if pnd[i].device_type<>'' then begin
             if pnd[i].kind=DeviceShortSign[i] then begin

                case i of
             0..7,10:Begin
                  no1:=tv1.Items.AddChild(no,pnd[i].kind);
                  no.Item[no.GetLastChild.Index].ImageIndex:=devicePics[i];
                          case i of
                          0..7:for x:=0 to 64 do begin
                                if (pnd[i].device_info[x]<>'') and (pnd[i].device_class[x]='') then begin
                                        tv1.Items.AddChild(no1,pnd[i].device_info[x]);
                                        no1.Item[no1.GetLastChild.Index].ImageIndex:=devicePics[i];
                                End;
                                End;
                          10:for x:=0 to 64 do begin
                                if (pnd[i].device_info[x]<>'') and (pnd[i].device_class[x]<>'') then begin
                                        tv1.Items.AddChild(no1,pnd[i].device_info[x]);
                                        for j:=0 to sp.MaxOtherDevices do
                                        if pnd[i].device_class[x]=OtherDevices[j] then
                                        no1.Item[no1.GetLastChild.Index].ImageIndex:=oDevicePics[j];
                                End;
                             End;
                          End; //case

                      End;
                8:for j:=0 to sp.MaxUsbClasses do begin
                        for x:=0 to 64 do begin
                                if pnd[i].device_class[x]=UsbClassDevices[j] then begin
                                        for xx:=0 to stusb.Count-1 do
                                        if stusb.Strings[xx]=pnd[i].device_class[x] then begin
                                        isdupdev:=true;
                                        End;
                                if not isdupdev then begin
                                stusb.Add(pnd[i].device_class[x]);
                                no1:=tv1.Items.AddChild(no,pnd[i].device_class[x]);
                                no.Item[no.GetLastChild.Index].ImageIndex:=UsbClassDevicesPics[j];
                                End;
                                isdupdev:=false;
                                tv1.Items.AddChild(no1,pnd[i].device_info[x]);
                                no1.Item[no1.GetLastChild.Index].ImageIndex:=UsbClassDevicesPics[j];
                                End;
                        End;
                  End;

                9:for j:=0 to sp.MaxOtherDevices do begin
                        for x:=0 to 64 do begin
                                if pnd[i].device_class[x]=OtherDevices[j] then begin
                                        for xx:=0 to stoth.Count-1 do
                                        if stoth.Strings[xx]=pnd[i].device_class[x] then begin
                                        isdupdev:=true;
                                        End;
                                if not isdupdev then begin
                                stoth.Add(pnd[i].device_class[x]);
                                no1:=tv1.Items.AddChild(no,pnd[i].device_class[x]);
                                no.Item[no.GetLastChild.Index].ImageIndex:=oDevicePics[j];
                                End;
                                isdupdev:=false;
                                tv1.Items.AddChild(no1,pnd[i].device_info[x]);
                                no1.Item[no1.GetLastChild.Index].ImageIndex:=oDevicePics[j];
                                End;
                        End;
                  End;
                End; // case i
             End;
             End;
        End;


        stusb.Free;
        stoth.Free;

        tv1.Sorted:=true;


end;

procedure TfrmSystem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        SetLength(fi,0);
        sp.Free;
end;

procedure TfrmSystem.Exit1Click(Sender: TObject);
begin
        Close;
end;

Function TfrmSystem.CallProperties(Sender: TfrmProp; devinfo:string; fi:PPci_Info; sp:TSysProvider; absindex:integer):boolean;
// call hwProperties via this function.
var frmProps:TfrmProp;
    s,s1:string;
    i,j,x:integer;
    founded:boolean;
    bmp:TBitmap;
Begin
        Result:=false;
        if Sender is TfrmProp then begin
        frmProps:=Sender as TfrmProp;
        s:=devinfo;

        for i:=0 to length(fi)-1 do begin
                if fi[i].device_info=s then begin
                sp.FindDriver(fi,i);
                frmProps.devrecno:=i;
                frmProps.drvname:=fi[i].driver;
                frmProps.Caption:=fi[i].device_type+' Properties';

                for x:=0 to sp.MaxShortSign do begin
                        if fi[i].device_type=DeviceShortSign[x] then begin
                            bmp:=TBitmap.Create;
                            bmp.Width:=48;
                            bmp.Height:=48;
                            bmp.Transparent:=true;
                            frmProps.ImgList.GetBitmap(devicePics[x],bmp);
                            bmp.SaveToFile('/tmp/xpbmptemp.png');
                            frmProps.Image1.Picture.LoadFromFile('/tmp/xpbmp.png');
                            frmProps.Image1.Transparent:=true;
                            bmp.Free;
                            DeleteFile('/tmp/xpbmptemp.png');
                            break;
                        End;
                End;
                if fi[i].device_type=DeviceShortSign[8] then
                frmProps.lbDev.Caption:=fi[i].usbclass
                else
                frmProps.lbDev.Caption:=fi[i].device_type;

                if fi[i].device_type=DeviceShortSign[9] then
                frmProps.lbDev.Caption:=fi[i].usbclass
                else
                frmProps.lbDev.Caption:=fi[i].device_type;


                if fi[i].sign='' then fi[i].sign:=sp.GuessManufacturer(fi[i].device_info);
                frmProps.lbManuf.Caption:=fi[i].sign;
                frmProps.lbType.Caption:=fi[i].device_info;// fi[i].sign+' '+fi[i].device_type;
                frmProps.lbLoc.Caption:=sp.CreateLocation(fi,i);
                frmProps.CB1.Text:=frmProps.CB1.Items.Strings[1];
                Result:=true;
                break;
                End;
        End;
        End; // frmProp


End;

procedure TfrmSystem.Properties1Click(Sender: TObject);
var no:TTreeNode;
begin
        no:=tv1.Selected;

        if not no.HasChildren then begin
        frmProp:=TFrmProp.Create(Nil);
        try
        if CallProperties(frmProp,tv1.Selected.Text,fi,sp,0) then
        frmProp.ShowModal;
        finally
        frmProp.Free;
        End;
        End;
end;

procedure TfrmSystem.FormCreate(Sender: TObject);
begin
    //These lines are here to set the font of the menubar
    font.name:='';
    parentfont:=true;
end;

procedure TfrmSystem.TV1DblClick(Sender: TObject);
begin
        Properties1Click(Sender);
end;

end.
