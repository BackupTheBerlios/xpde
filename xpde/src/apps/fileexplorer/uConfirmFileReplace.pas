unit uConfirmFileReplace;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls;

type
  TConfirmFileReplaceDlg = class(TForm)
        Image3:TImage;
        Panel3:TPanel;
        Label7:TLabel;
        Label6:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        Label5:TLabel;
        Label4:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        Button2:TButton;
        Button1:TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfirmFileReplaceDlg: TConfirmFileReplaceDlg;

function ReplaceFile(const afile:string;const modified1,modified2:string):boolean;

implementation

{$R *.xfm}

function ReplaceFile(const afile:string;const modified1,modified2:string):boolean;
begin
    with TConfirmFileReplaceDlg.create(application) do begin
        try
            label3.Caption:=Format(label3.caption,[extractfilename(afile)]);
            label5.caption:=modified1;
            label7.caption:=modified2;
            result:=(showmodal=mrOk);
        finally
            free;
        end;
    end;
end;

end.
