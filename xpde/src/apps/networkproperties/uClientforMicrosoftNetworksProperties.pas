unit uClientforMicrosoftNetworksProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TClientforMicrosoftNetworksPropertiesDlg = class(TForm)
        Edit1:TEdit;
        Label3:TLabel;
        ComboBox1:TComboBox;
        Label2:TLabel;
        Label1:TLabel;
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
  ClientforMicrosoftNetworksPropertiesDlg: TClientforMicrosoftNetworksPropertiesDlg;

implementation

{$R *.xfm}

end.
