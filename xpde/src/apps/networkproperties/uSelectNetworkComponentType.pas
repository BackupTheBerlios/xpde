unit uSelectNetworkComponentType;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TSelectNetworkComponentTypeDlg = class(TForm)
        Label2:TLabel;
        GroupBox1:TGroupBox;
        Label1:TLabel;
        Button2:TButton;
        Button1:TButton;
        ListView1:TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectNetworkComponentTypeDlg: TSelectNetworkComponentTypeDlg;

implementation

{$R *.xfm}

end.
