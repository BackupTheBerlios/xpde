unit uProgressDlg;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls, QComCtrls;

type
  TProgressDlg = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgressDlg: TProgressDlg;

implementation

{$R *.xfm}

end.
