unit uConnectionProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls;

type
  TConnectionPropertiesDlg = class(TForm)
        CheckBox7:TCheckBox;
        CheckBox6:TCheckBox;
        Label7:TLabel;
        Button10:TButton;
        ComboBox2:TComboBox;
        Label6:TLabel;
        CheckBox5:TCheckBox;
        Button9:TButton;
        CheckBox2:TCheckBox;
        GroupBox2:TGroupBox;
        CheckBox1:TCheckBox;
        Label3:TLabel;
        GroupBox1:TGroupBox;
        Button8:TButton;
        Button7:TButton;
        Button6:TButton;
        ListView1:TListView;
        Label2:TLabel;
        Button5:TButton;
        Panel1:TPanel;
        Edit2:TEdit;
        Edit1:TEdit;
        Label1:TLabel;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
    Panel2: TPanel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConnectionPropertiesDlg: TConnectionPropertiesDlg;

implementation

{$R *.xfm}

end.
