unit uExplorerUtil;

interface

uses
    Libc, SysUtils, QGraphics,uXPAPI,uExplorerAPI,uXPStyleConsts;

var
    imDESKTOP: integer=-1;
    imHOME: integer=-1;
    imMYDOCUMENTS: integer=-1;
    imMYCOMPUTER: integer=-1;
    imMYNETWORKPLACES: integer=-1;
    imRECYCLEBIN: integer=-1;
    imFLOPPY: integer=-1;
    imCLOSEDFOLDER: integer=-1;
    imHARDDISK: integer=-1;
    imCDDRIVE: integer=-1;
    imCONTROLPANEL: integer=-1;
    imNOICON: integer=-1;
    imLOCALNETWORK: integer=-1;
    imNETWORKRESOURCE: integer=-1;


function formatfilesize(size:extended):string;
function formatsize(size:extended):string;
function registerBitmap(const path:string):integer;
function getTickCount:integer;
function removeTrailingSlash(const str:string):string;
function extractdirname(const str:string):string;
function extractdirpart(const str:string):string;
function addTrailingSlash(const str:string):string;
function getnewdir(const path:string; const basepath:string):string;


implementation

var
    bmp: TBitmap;

function formatfilesize(size:extended):string;
begin
 result:=formatfloat('###,###,###,###,###,##0',trunc(size));
end;

function formatsize(size:extended):string;
 var
   kfs:extended;
begin
 if size>1024 then begin
   if (size>1024*1024) then begin
      kfs:=size / (1024*1024);
      result:=formatfilesize(kfs)+' MB';
   end
    else begin
      kfs:=size / 1024;
      result:=formatfilesize(kfs)+' KB';
    end;
   end
     else begin
        result:=formatfilesize(size)+' bytes';
     end;
end;

function registerBitmap(const path:string):integer;
begin
    bmp:=TBitmap.create;
    try
        bmp.loadfromfile(path);
        result:=XPExplorer.registerImage(bmp);
    finally
        bmp.free;
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

function removeTrailingSlash(const str:string):string;
begin
    result:=str;
    if result<>'/' then begin
        if result[length(result)]='/' then result:=copy(result,1,length(result)-1);
    end;
end;

function extractdirname(const str:string):string;
var
    i:longint;
begin
    result:=removetrailingslash(str);
    for i:=length(str)-1 downto 1 do begin
        if (str[i]='/') then begin
            result:=copy(result,i+1,length(result));
            break;
        end;
    end;
end;

function extractdirpart(const str:string):string;
var
    i:longint;
begin
    result:=removetrailingslash(str);
    for i:=length(str)-1 downto 1 do begin
        if (str[i]='/') then begin
            result:=copy(result,1,i);
            break;
        end;
    end;
end;

function addTrailingSlash(const str:string):string;
begin
    result:=str;
    if result<>'' then begin
        if result[length(result)]<>'/' then result:=result+'/';
    end;
end;

function getnewdir(const path:string; const basepath:string):string;
var
    spath:string;
    rightpath: string;
    k: integer;
begin
    result:='';
    spath:=extractfilepath(path);
    rightpath:=copy(spath,length(basepath)+1,length(spath));

    rightpath:=addTrailingSlash(rightpath);
    k:=pos('/',rightpath);
    if k<>0 then begin
        result:=copy(rightpath,1,k-1);
    end;
end;


initialization

 bmp:=TBitmap.create;
  try
   bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'desktop.png');
   imDESKTOP:=XPExplorer.registerImage(bmp);

   bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder_home.png');
   imHOME:=XPExplorer.registerImage(bmp);

   bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'fileopen.png');
   imMYDOCUMENTS:=XPExplorer.registerImage(bmp);

   bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'mycomputer.png');
   imMYCOMPUTER:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'network.png');
    imMYNETWORKPLACES:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'trashcan_empty.png');
    imRECYCLEBIN:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'3floppy_unmount.png');
    imFLOPPY:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder.png');
    imCLOSEDFOLDER:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'hdd_unmount.png');
    imHARDDISK:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'cdrom_unmount.png');
    imCDDRIVE:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'package_settings.png');
    imCONTROLPANEL:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+gNOICON);
    imNOICON:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'network_local.png');
    imLOCALNETWORK:=XPExplorer.registerImage(bmp);

    bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder.png');
    imNETWORKRESOURCE:=XPExplorer.registerImage(bmp);
   finally
     bmp.free;
   end;
end.
