unit uSystemProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls,SysProvider;

type
  TSystemPropertiesDlg = class(TForm)
        Label37:TLabel;
        GroupBox12:TGroupBox;
        Label35:TLabel;
        Label34:TLabel;
        Label33:TLabel;
        TrackBar1:TTrackBar;
        Label32:TLabel;
        Label31:TLabel;
        GroupBox11:TGroupBox;
        CheckBox3:TCheckBox;
        Label30:TLabel;
        Image10:TImage;
        Panel10:TPanel;
    lbFullName: TLabel;
        Label28:TLabel;
        GroupBox10:TGroupBox;
        Label27:TLabel;
        GroupBox9:TGroupBox;
        Image9:TImage;
        Panel9:TPanel;
        Button19:TButton;
        CheckBox2:TCheckBox;
        Button18:TButton;
        CheckBox1:TCheckBox;
        Image8:TImage;
        Panel8:TPanel;
        Button17:TButton;
        Label26:TLabel;
        GroupBox8:TGroupBox;
        Label25:TLabel;
        RadioButton3:TRadioButton;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        GroupBox7:TGroupBox;
        Button16:TButton;
        Button15:TButton;
        Button14:TButton;
        Label24:TLabel;
        GroupBox6:TGroupBox;
        Button13:TButton;
        Label23:TLabel;
        GroupBox5:TGroupBox;
        Button12:TButton;
        Label22:TLabel;
        GroupBox4:TGroupBox;
        Label21:TLabel;
        Button11:TButton;
        Label20:TLabel;
        Image7:TImage;
        Panel7:TPanel;
        GroupBox3:TGroupBox;
        Button10:TButton;
        Button9:TButton;
        Label19:TLabel;
        Image6:TImage;
        Panel6:TPanel;
        GroupBox2:TGroupBox;
        Button8:TButton;
        Label18:TLabel;
        Image5:TImage;
        Panel5:TPanel;
        GroupBox1:TGroupBox;
        Label17:TLabel;
        Image4:TImage;
        Panel4:TPanel;
        Label16:TLabel;
        Image3:TImage;
        Panel3:TPanel;
        Label15:TLabel;
        Button7:TButton;
        Label14:TLabel;
        Button6:TButton;
        Label13:TLabel;
        Edit7:TEdit;
        Label12:TLabel;
        Label11:TLabel;
        Label10:TLabel;
        Edit5:TEdit;
        Label9:TLabel;
        Label8:TLabel;
        Label6:TLabel;
        Label5:TLabel;
        Label4:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        TabSheet7:TTabSheet;
        TabSheet6:TTabSheet;
        TabSheet5:TTabSheet;
        TabSheet4:TTabSheet;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
    Image2: TImage;
    lbManuf: TLabel;
    lbCPU: TLabel;
    lbRam: TLabel;
    lbLicence: TLabel;
    lbCompName: TLabel;
    lbWorkGroup: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Procedure FillTabs;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SystemPropertiesDlg: TSystemPropertiesDlg;

implementation
{$R *.xfm}

procedure TSystemPropertiesDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:=caFree;
        Application.Terminate;
end;

procedure TSystemPropertiesDlg.Button1Click(Sender: TObject);
begin
        Close;
end;

procedure TSystemPropertiesDlg.Button2Click(Sender: TObject);
begin
        Close;
end;

Procedure TSystemPropertiesDlg.FillTabs;
var sp:TSysProvider;
    cc:double;
    hna:String;
Begin
      sp:=TSysProvider.Create;
      Label2.Caption:=sp.DistInfo.sys+' '+sp.DistInfo.kernel;
      Label3.Caption:=sp.DistInfo.name;
      Label4.Caption:='Version '+sp.DistInfo.version;
      lbLicence.Caption:=GetEnvironmentVariable('USER');
      lbManuf.Caption:=sp.CpuInfo.vendor_id;
      lbCPU.Caption:=sp.CpuInfo.model_name;
      cc:=sp.MemInfo;
      cc:=(cc/1024)/1024;
      lbRAM.Caption:=FloatToStrF(cc,ffFixed,8,0)+' Mb of RAM';
      hna:=sp.HostName;
      Edit5.Text:=hna;
      lbCompName.Caption:=hna;
      lbFullName.Caption:=hna;
      lbWorkGroup.Caption:=GetEnvironmentVariable('WORKGROUP');
      RadioButton3.Checked:=true;
      sp.UsbInfo;
      sp.Free;
End;

procedure TSystemPropertiesDlg.FormShow(Sender: TObject);
begin
      FillTabs;
end;

end.
