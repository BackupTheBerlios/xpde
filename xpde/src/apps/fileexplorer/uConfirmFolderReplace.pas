unit uConfirmFolderReplace;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls;

type
  TConfirmFolderReplaceDlg = class(TForm)
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfirmFolderReplaceDlg: TConfirmFolderReplaceDlg;

function ReplaceDir(const dirname:string):TModalResult;

implementation

{$R *.xfm}

function ReplaceDir(const dirname:string):TModalResult;
begin
    with TConfirmFolderReplaceDlg.create(application) do begin
        try
            { TODO : Process the Yes to all answer }
            Label1.caption:=format(label1.caption,[dirname]);
            result:=showmodal;
        finally
            free;
        end;
    end;
end;

end.
