unit uMouseProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls, uQXPComCtrls;

type
  TMousePropertiesDlg = class(TForm)
        TabSheet6:TTabSheet;
        Edit1:TEdit;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        Label13:TLabel;
        Image8:TImage;
        Panel8:TPanel;
        GroupBox8:TGroupBox;
        CheckBox8:TCheckBox;
        CheckBox7:TCheckBox;
        Image7:TImage;
        Panel7:TPanel;
        Image6:TImage;
        Panel6:TPanel;
        TrackBar3:TTrackBar;
        Label12:TLabel;
        Label11:TLabel;
        Image5:TImage;
        Panel5:TPanel;
        CheckBox6:TCheckBox;
        GroupBox7:TGroupBox;
        Image4:TImage;
        Panel4:TPanel;
        CheckBox5:TCheckBox;
        GroupBox6:TGroupBox;
        CheckBox4:TCheckBox;
        TrackBar2:TTrackBar;
        Label10:TLabel;
        Label9:TLabel;
        Label8:TLabel;
        Image3:TImage;
        Panel3:TPanel;
        GroupBox5:TGroupBox;
        Button9:TButton;
        Button8:TButton;
        CheckBox3:TCheckBox;
        ListBox1:TListBox;
        Label7:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        Button7:TButton;
        Button6:TButton;
        ComboBox1:TComboBox;
        GroupBox4:TGroupBox;
        Button5:TButton;
        Label6:TLabel;
        CheckBox2:TCheckBox;
        GroupBox3:TGroupBox;
    imOpen: TImage;
        Panel1:TPanel;
        Label5:TLabel;
        TrackBar1:TTrackBar;
        Label4:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        GroupBox2:TGroupBox;
        Label1:TLabel;
    cbSwitch: TCheckBox;
        GroupBox1:TGroupBox;
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
    imLeft: TImage;
    imRight: TImage;
    imClosed: TImage;
    procedure cbSwitchClick(Sender: TObject);
    procedure imClosedDblClick(Sender: TObject);
    procedure imOpenDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MousePropertiesDlg: TMousePropertiesDlg;

implementation

{$R *.xfm}

procedure TMousePropertiesDlg.cbSwitchClick(Sender: TObject);
begin
    if cbSwitch.Checked then imRight.bringtofront
    else imLeft.BringToFront;
end;

procedure TMousePropertiesDlg.imClosedDblClick(Sender: TObject);
begin
    imClosed.visible:=false;
    imOpen.visible:=true;
end;

procedure TMousePropertiesDlg.imOpenDblClick(Sender: TObject);
begin
    imOpen.visible:=false;
    imClosed.visible:=true;
end;

end.
