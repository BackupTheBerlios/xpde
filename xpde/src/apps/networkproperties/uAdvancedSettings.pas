unit uAdvancedSettings;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TAdvancedSettingsDlg = class(TForm)
        Label7:TLabel;
        GroupBox3:TGroupBox;
        ListView2:TListView;
        Label6:TLabel;
        Button9:TButton;
        Label5:TLabel;
        Edit2:TEdit;
        Label4:TLabel;
        Button8:TButton;
        Edit1:TEdit;
        Label3:TLabel;
        GroupBox2:TGroupBox;
        CheckBox2:TCheckBox;
        CheckBox1:TCheckBox;
        GroupBox1:TGroupBox;
        Button7:TButton;
        Button6:TButton;
        Button5:TButton;
        ListView1:TListView;
        Label2:TLabel;
        Label1:TLabel;
        TabSheet3:TTabSheet;
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
  AdvancedSettingsDlg: TAdvancedSettingsDlg;

implementation

{$R *.xfm}

end.
