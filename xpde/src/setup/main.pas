unit main;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls, QComCtrls;

type
  TBackForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Image2: TImage;
    Panel3: TPanel;
    imLogo: TImage;
    Panel4: TPanel;
    Image4: TImage;
    lbFinish: TLabel;
    lbOperation: TLabel;
    lbETA: TLabel;
    lbStep1: TLabel;
    lbStep2: TLabel;
    lbStep3: TLabel;
    lbStep4: TLabel;
    lbStep5: TLabel;
    lbTitle: TLabel;
    lbDarktitle: TLabel;
    lbText: TLabel;
    imStep1: TImage;
    imStep2: TImage;
    imStep3: TImage;
    imStep4: TImage;
    imStep5: TImage;
    pbProgress: TProgressBar;
    Button1: TButton;
    imCurrent1: TImage;
    imCurrent2: TImage;
    imCurrent3: TImage;
    imCurrent4: TImage;
    imCurrent5: TImage;
    Panel5: TPanel;
    star4: TImage;
    star5: TImage;
    star3: TImage;
    star2: TImage;
    star1: TImage;
    inactiveStar: TImage;
    activeStar: TImage;
    tmStars: TTimer;
    tmTexts: TTimer;
    procedure imLogoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tmStarsTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmTextsTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    curstep: integer;
    star: integer;
    texts: TStringList;
    curtext: integer;
    procedure fillTexts;
    procedure setCurrentStep(const step:integer);
  end;

var
  BackForm: TBackForm;

implementation

{$R *.xfm}

procedure TBackForm.imLogoClick(Sender: TObject);
begin
    close;
end;

procedure TBackForm.FormCreate(Sender: TObject);
begin
    texts:=TStringList.create;
    curtext:=0;
    filltexts;
    star:=1;
    curstep:=1;
    boundsrect:=rect(0,0,screen.width,screen.height);
    setCurrentStep(curstep);
    tmTextsTimer(tmTexts);
end;

procedure TBackForm.setCurrentStep(const step: integer);
var
    curstep: integer;
    donestep: integer;
    im: TImage;
    lb: TLabel;
begin
    curstep:=step;
    donestep:=0;
    if curstep>1 then donestep:=curstep-1;

    if donestep<>0 then begin
        im:=findcomponent('imStep'+inttostr(donestep)) as TImage;
        if assigned(im) then im.visible:=true;

        lb:=findcomponent('lbStep'+inttostr(donestep)) as TLabel;
        if assigned(lb) then begin
            lb.font.Color:=clWhite;
        end;

        im:=findcomponent('imCurrent'+inttostr(donestep)) as TImage;
        if assigned(im) then begin
            im.visible:=false;
            panel1.invalidate;
        end;
    end;



    im:=findcomponent('imCurrent'+inttostr(curstep)) as TImage;
    if assigned(im) then im.visible:=true;

    lb:=findcomponent('lbStep'+inttostr(curstep)) as TLabel;
    if assigned(lb) then begin
        lb.font.Color:=$0099ff;
        lb.font.style:=[fsBold];
    end;
end;

procedure TBackForm.Button1Click(Sender: TObject);
begin
    inc(curstep);
    setCurrentStep(curstep);
end;

procedure TBackForm.tmStarsTimer(Sender: TObject);
var
    st: TImage;
begin
    st:=findcomponent('star'+inttostr(star)) as TImage;
    if assigned(st) then st.picture.Assign(inactiveStar.picture);
    
    inc(star);
    if (star>5) then star:=1;

    st:=findcomponent('star'+inttostr(star)) as TImage;
    if assigned(st) then st.picture.Assign(activeStar.picture);

end;

procedure TBackForm.FormDestroy(Sender: TObject);
begin
    texts.free;
end;

procedure TBackForm.fillTexts;
begin
    with texts do begin
        add('This is a test title=I''ve got to get to you first. Before they do It''s just a question of time Before they lay their hands on you And make you just like the rest I''ve got to get to you first It''s just a question of time');
        add('Yet another test!!!!=Let''s have a black celebration Black Celebration Tonight To celebrate the fact That we''ve seen the back Of another black day');
        add('Boring tests ;-)=Welcome to the wonderful world of XPde');
        add('Probably this text won''t appear=Welcome to the wonderful world of XPde');
        add('Are you sid vicious?=Welcome to the wonderful world of XPde');
        add('Follow the white rabbit=Welcome to the wonderful world of XPde');
        add('Painkiller=Welcome to the wonderful world of XPde');
        add('Just for fun=Welcome to the wonderful world of XPde');
        add('Try me!!!=Welcome to the wonderful world of XPde');
    end;
end;

procedure TBackForm.tmTextsTimer(Sender: TObject);
var
    title: string;
    text:string;
begin
    title:=texts.Names[curtext];
    text:=texts.values[title];
    lbTitle.Caption:=title;
    lbDarktitle.Caption:=title;
    lbText.caption:=text;
    inc(curtext);
end;

end.
