unit uSmartCardorotherCertificateProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, uQXPComCtrls;

type
  TSmartCardorotherCertificatePropertiesDlg = class(TForm)
        Label2:TLabel;
        GroupBox1:TGroupBox;
        Button2:TButton;
        Button1:TButton;
        CheckBox3:TCheckBox;
        ComboBox1:TComboBox;
        Label1:TLabel;
        Edit1:TEdit;
        CheckBox2:TCheckBox;
        CheckBox1:TCheckBox;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SmartCardorotherCertificatePropertiesDlg: TSmartCardorotherCertificatePropertiesDlg;

implementation

{$R *.xfm}

end.
