unit uServiceSettings;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, uQXPComCtrls;

type
  TServiceSettingsDlg = class(TForm)
        Button2:TButton;
        Button1:TButton;
        Edit4:TEdit;
        Label4:TLabel;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        Edit3:TEdit;
        Label3:TLabel;
        Edit2:TEdit;
        Label2:TLabel;
        Edit1:TEdit;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServiceSettingsDlg: TServiceSettingsDlg;

implementation

{$R *.xfm}

end.
