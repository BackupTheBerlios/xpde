unit uHWProperties;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, SysProvider, QComCtrls, QExtCtrls, QImgList;

type
  TfrmProp = class(TForm)
    PC1: TPageControl;
    shGen: TTabSheet;
    shDrv: TTabSheet;
    shRes: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    Image1: TImage;
    lbType: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GB1: TGroupBox;
    Button1: TButton;
    Memo1: TMemo;
    Label4: TLabel;
    CB1: TComboBox;
    lbDev: TLabel;
    lbManuf: TLabel;
    lbLoc: TLabel;
    ImgList: TImageList;
    Image2: TImage;
    lbName: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label9: TLabel;
    Label10: TLabel;
    lbDrvProvider: TLabel;
    lbDriverDate: TLabel;
    lbDriverVersion: TLabel;
    lbDigital: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Image3: TImage;
    lbResName: TLabel;
    Label13: TLabel;
    PA1: TPanel;
    Label14: TLabel;
    CB2: TComboBox;
    CheckBox1: TCheckBox;
    Button6: TButton;
    Label15: TLabel;
    Memo2: TMemo;
    Image4: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure shDrvShow(Sender: TObject);
    procedure shResShow(Sender: TObject);
    procedure shResHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Procedure CreateXPList;
    { Private declarations }
  public
    devrecno:integer;
    drvname:string;
    { Public declarations }
  end;

var
  frmProp: TfrmProp;
implementation
uses xpclasses,uXPImageList,uXPListview,uDeviceManager;
var     xpl:TXPListView;
        xpi:TXPImageList;
{$R *.xfm}

procedure TfrmProp.btnCancelClick(Sender: TObject);
begin
        Close;
end;

procedure TfrmProp.btnOKClick(Sender: TObject);
begin
        // apply new properties ...
        Close;
end;

procedure TfrmProp.shDrvShow(Sender: TObject);
var dis_:TUname;
    spp:TSysProvider;
begin
        spp:=TSysProvider.Create;
        dis_:=spp.DistInfo;
        Image2.Picture:=Image1.Picture;
        lbName.Caption:=lbType.Caption;

        lbDrvProvider.Caption:=dis_.name+' '+dis_.version;
        lbDriverDate.Caption:=dis_.krnl_date;
        lbDriverVersion.Caption:=dis_.kernel;
        if drvname<>'' then
        lbDigital.Caption:=drvname
        else
        lbDigital.Caption:=dis_.sys+' kernel';
        spp.Free;
end;

Procedure TfrmProp.CreateXPList;
var hs: THeaderSection;
    grf:TGraphic;
begin
        xpl:=TXPListView.Create(self);
        xpi:=TXPImageList.Create(self);
        xpl.ImageList:=xpi;

            hs:=xpl.HeaderControl.Sections.Add;
            hs.Text:='Resource type';
            hs:=xpl.HeaderControl.Sections.Add;
            hs.Text:='Setting';
        xpl.parent:=PA1;
        xpl.Align:=alClient;
        xpl.ViewStyle:=vsDetail;
        xpl.HeaderControl.Clickable:=false;
        xpl.HeaderControl.Sections.Items[0].Width:=xpl.HeaderControl.Width div 3;
        xpl.HeaderControl.Sections.Items[1].Width:=xpl.HeaderControl.Width - (xpl.HeaderControl.Width div 3);
        xpl.HeaderControl.Height:=xpl.HeaderControl.Height+4;
        xpl.SendToBack;

        grf:=Image4.Picture.Graphic;
        // grf.Transparent:=true;
        // BUG ?
        xpi.AddImage(grf);
        xpl.SmallImageList:=xpi;
End;

procedure TfrmProp.shResShow(Sender: TObject);
Const restypes:Array[0..2] of String=('Memory Range','I/O Range','IRQ');
var ix: TXPListItem;
     i:integer;
begin
        Image3.Picture:=Image1.Picture;
        lbResName.Caption:=lbType.Caption;

        CreateXPList;
        // BUG ?
        if fi[devrecno].non_prefetch_lo<>'' then begin
        ix:=xpl.Items.Add;
        ix.ImageIndex:=0;
        ix.Caption:=restypes[0];
        ix.Subitems.Add(fi[devrecno].non_prefetch_lo+'-'+fi[devrecno].non_prefetch_hi);
        End;
        for i:=0 to 31 do
        if fi[devrecno].device_io_from[i]<>'' then begin
        ix:=xpl.Items.Add;
        ix.ImageIndex:=0;
        ix.Caption:=restypes[1];
        ix.Subitems.Add(fi[devrecno].device_io_from[i]+'-'+fi[devrecno].device_io_to[i]);
        End;

        if fi[devrecno].device_irq in [0..15] then begin
        ix:=xpl.Items.Add;
        ix.ImageIndex:=0;
        ix.Caption:=restypes[2];
        ix.Subitems.Add(IntToStr(fi[devrecno].device_irq));
        End;

        if fi[devrecno].prefetchable_lo<>'' then begin
        ix:=xpl.Items.Add;
        ix.ImageIndex:=0;
        ix.Caption:=restypes[0];
        ix.Subitems.Add(fi[devrecno].prefetchable_lo+'-'+fi[devrecno].prefetchable_hi);
        End;
end;

procedure TfrmProp.shResHide(Sender: TObject);
begin
        xpi.Free;
        xpl.Free;
end;

procedure TfrmProp.FormShow(Sender: TObject);
begin
        PC1.ActivePageIndex:=0;
        PC1.Pages[2].TabVisible:=fi[devrecno].device_irq in [0..15];
end;

end.
