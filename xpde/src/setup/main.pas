unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls,
  Libc;

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
    startTimer: TTimer;
    procedure imLogoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure tmStarsTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmTextsTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure startTimerTimer(Sender: TObject);
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
    procedure installscript;
    procedure installindm;
  end;

var
  BackForm: TBackForm;

implementation

uses uPersonalizeDlg, uStartInstallation;

{$R *.xfm}

procedure TBackForm.imLogoClick(Sender: TObject);
begin
    close;
end;

procedure TBackForm.FormCreate(Sender: TObject);
begin
    if (getuid<>0) then begin
        showmessage('This application must be executed as root!');
        application.terminate;
    end;
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

procedure TBackForm.FormShow(Sender: TObject);
begin
    startTimer.enabled:=true;
end;

procedure TBackForm.startTimerTimer(Sender: TObject);
var
    rs: TModalResult;
begin
    //Check here if the user is root or not
    startTimer.enabled:=false;
    with tStartInstallationDlg.create(application) do begin
        try
            rs:=showmodal;
            if rs=mrCancel then begin
                application.terminate;
            end;
            if rs=mrOk then begin
                tmTexts.Enabled:=true;
                tmStars.Enabled:=true;
                installscript;
            end;
            inc(curstep);
            setCurrentStep(curstep);
            installindm;
            tmTexts.Enabled:=false;
            tmStars.Enabled:=false;
            showmessage('Installation finished');
            application.terminate;
        finally
            free;
        end;
    end;
end;

function getTickCount:integer;
var
    tv: timeval;
    tz: timezone;
begin
    gettimeofday(tv,tz);
    result:=tv.tv_sec;
end;

procedure TBackForm.installscript;
var
    script: string;
    lines: TStringList;
    i: integer;
    line: string;
    init: integer;
    cur: integer;
    eta: integer;
    lasteta: integer;
    st: integer;
begin
    inc(curstep);
    setCurrentStep(curstep);
    inc(curstep);
    setCurrentStep(curstep);
    inc(curstep);
    setCurrentStep(curstep);
            
    init:=getTickCount;
    script:=extractfilepath(application.exename)+'install.sh';
    if fileexists(script) then begin
        lines:=TStringList.create;
        try
            lines.LoadFromFile(script);
            pbProgress.Max:=lines.count-1;
            lbOperation.caption:='Copying files...';
            lasteta:=65535;
            for i:=0 to lines.count-1 do begin
                line:=lines[i];
                pbProgress.position:=i;
                application.processmessages;
                st:=libc.system(PChar(line));
                {
                if st<>0 then begin
                    showmessage('Script error [Line '+inttostr(i)+']: ' + line);
                end;
                }
                cur:=getTickCount;
                if ((cur-init)>5) then begin
                    eta:=(lines.count*(cur-init));
                    eta:=eta div (i+1);
                    eta:=eta - (cur-init);
                    if lasteta>eta then begin
                        lasteta:=eta;
                    end;
                    lbEta.Caption:=inttostr(lasteta)+' seconds';
                end
                else lbEta.caption:='Calculating...';
            end;
        finally
            lines.free;
        end;
    end
    else begin
        showmessage('Cannot find install script: '+script);
        application.terminate;
    end;
end;

procedure TBackForm.installindm;
var
    kdm: string;
    thefile:TStringList;
    i: integer;
    line: string;
    wmsession: string;
    gdm:string;
begin
    kdm:='/etc/opt/kde3/share/config/kdm/kdmrc';  //SuSE 8.2

    if fileexists(kdm) then begin
        writeln('SuSE 8.2 - kdmrc found!');
        thefile:=TStringList.create;
        try
            thefile.LoadFromFile(kdm);
            for i:=0 to thefile.Count-1 do begin
                line:=thefile[i];
                if pos(ansilowercase('SessionTypes='),ansilowercase(line))<>0 then begin
                    writeln('SessionTypes line found!');
                    if (pos(ansilowercase('XPde'),ansilowercase(line))=0) then begin
                        writeln('Adding XPde to the SessionTypes list!');
                        line:=line+',XPde';
                        thefile[i]:=line;
                        thefile.SaveToFile(kdm);
                    end
                    else begin
                        writeln('SessionTypes already contained XPde!');
                    end;
                    break;
                end;
            end;
        finally
            thefile.free;
        end;
    end
    else writeln ('kdmrc not found!');

    wmsession:='/etc/X11/wmsession.d';      //Mandrake 9.1

    if directoryexists(wmsession) then begin
        writeln('Mandrake 9.1 - wmsession dir found!');
        thefile:=TStringList.create;
        try
            thefile.add('NAME=XPde');
            thefile.add('EXEC=/usr/local/bin/XPde');
            thefile.add('DESC=XPde Desktop Environment');
            thefile.add('SCRIPT:');
            thefile.add('exec /usr/local/bin/XPde');

            if fileexists(wmsession+'/08XPde') then begin
                writeln('Session file (08XPde) already exists, created new one!');
            end;

            thefile.SaveToFile(wmsession+'/08XPde');
        finally
            thefile.free;
        end;
    end
    else writeln ('wmsession dir not found!');

    gdm:='/etc/X11/gdm/Sessions';           //RedHat 9.0

    if directoryexists(gdm) then begin
        writeln('RedHat 9.0 - gdm sessions dir found!');
        thefile:=TStringList.create;
        try
            thefile.add('/usr/local/bin/XPde');

            if fileexists(gdm+'/XPde') then begin
                writeln('Session file (XPde) already exists, created new one!');
            end;

            thefile.SaveToFile(gdm+'/XPde');
            libc.system('chmod +x /etc/X11/gdm/Sessions/XPde')
        finally
            thefile.free;
        end;
    end
    else writeln ('gdm sessions dir not found!');
    
end;

end.
