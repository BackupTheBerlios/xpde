unit uKeyboardProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls;

type
  TKeyboardPropertiesDlg = class(TForm)
        TabSheet3:TTabSheet;
        TrackBar3:TTrackBar;
        Label11:TLabel;
        Label10:TLabel;
        Label9:TLabel;
        Label8:TLabel;
        GroupBox2:TGroupBox;
        Edit1:TEdit;
        Label7:TLabel;
        TrackBar2:TTrackBar;
        Label6:TLabel;
        Label5:TLabel;
        Label4:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        TrackBar1:TTrackBar;
        Label3:TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        GroupBox1:TGroupBox;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KeyboardPropertiesDlg: TKeyboardPropertiesDlg;

implementation

{$R *.xfm}

end.
