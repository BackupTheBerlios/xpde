unit gt;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls;

type
  TfrmGoTo = class(TForm)
    lblLine: TLabel;
    spnLine: TSpinEdit;
    btnOK: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGoTo: TfrmGoTo;

implementation

{$R *.xfm}

end.
