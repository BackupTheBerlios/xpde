unit uAskPassword;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, Libc,
  QDialogs, QStdCtrls, QExtCtrls;

type
  TAskPasswordDlg = class(TForm)
    imKeys: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edPassword: TEdit;
    cbUsername: TComboBox;
    rbCustom: TRadioButton;
    rbCurrentUser: TRadioButton;
    cbProtect: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);  private
    { Private declarations }
  public
    { Public declarations }
    names: TStringList;
  end;

var
  AskPasswordDlg: TAskPasswordDlg;

implementation

{$R *.xfm}

procedure getUserList(strings: TStrings;names: TStrings);
var
    pw: PPasswordRecord;
begin
    pw:=getpwent;
    try
        while assigned(pw) do begin
            strings.add(pw^.pw_name);
            names.add(pw^.pw_gecos);
            pw:=getpwent;
        end;
    finally
        endpwent;
    end;
end;


procedure TAskPasswordDlg.FormCreate(Sender: TObject);
begin
    names:=TStringList.create;
    getUserList(cbUsername.items,names);
end;

procedure TAskPasswordDlg.FormDestroy(Sender: TObject);
begin
    names.free;
end;

end.
