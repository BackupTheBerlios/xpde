unit uProgressDlg;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls,
  uQXPComCtrls;

type
  TProgressDlg = class(TForm)
    Image2: TImage;
    lbFile: TLabel;
    lbStatus: TLabel;
    pbProgress: TProgressBar;
    Button1: TButton;
    lbETA: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure updateDialog(const progress, max: integer; const str, status, eta: string);
  end;

var
  ProgressDlg: TProgressDlg;

implementation

{$R *.xfm}

{ TProgressDlg }

procedure TProgressDlg.updateDialog(const progress, max: integer;
  const str, status, eta: string);
begin
    lbFile.caption:=str;
    lbStatus.caption:=status;
    lbETA.caption:=eta;
    pbProgress.Max:=max;
    pbProgress.Position:=progress;
end;

end.
