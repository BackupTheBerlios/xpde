unit uResources;

interface

uses SysUtils, Classes, QDialogs;

type
    TResourceType=(rtCursor, rtBitmap, rtIcon, rtMenu, rtDialog, rtString, rtFontdir, rtFont, rtAccelerator, rtRCData, rtGroupCursor, rtGroupIcon, rtMessageTable, rtVersion, rtDLGInclude, rtPlugPlay, rtVXD, rtAnicursor, rtNone);

    //A resource entry
    TResourceEntry=class(TObject)
        public
            //Just 32 byte resources, 16 bit not supported
            datasize:integer;
            headersize: integer;
            resourcetype: TResourceType;
            sresourcetype: string;
            //If first two are $FFFF, the subsequent two bytes are numeric value
            //else, the first two are the first Unicode in a zs
            resourcename: string;
            dataversion: integer;
            flags: word;
            language: word;
            version:integer;
            characteristics: integer;
            data: TMemoryStream;
            procedure ReadFromStream(stream:TStream);
            function GetFormresAsText : string;
            procedure GetStringListRes( strings : TStrings );
            constructor Create;
            destructor Destroy;override;
    end;

    //A resource file, just a list of resource entries
    TResourceFile=class(TComponent)
    private
        procedure destroyresources;
    public
        resources: TList;
        procedure getResourceNames(strings: TStrings);
        procedure loadfromfile(const filename:string);
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
    end;

function ResourceTypeToString(const rt: TResourceType):string;

implementation

function ResourceTypeToString(const rt: TResourceType):string;
begin
    result:='(none)';
    case rt of
        rtCursor: result:='Cursor';
        rtBitmap: result:='Bitmap';
        rtIcon: result:='Icon';
        rtMenu: result:='Menu';
        rtDialog: result:='Dialog';
        rtString: result:='String';
        rtFontdir: result:='Fontdir';
        rtFont: result:='Font';
        rtAccelerator: result:='Accelerator';
        rtRCData: result:='RCData';
        rtGroupCursor: result:='GroupCursor';
        rtGroupIcon: result:='GroupIcon';
        rtMessageTable: result:='MessageTable';
        rtVersion: result:='Version';
        rtDLGInclude: result:='DLGInclude';
        rtPlugPlay: result:='PlugPlay';
        rtVXD: result:='VXD';
        rtAnicursor: result:='Anicursor';
        rtNone: result:='None';
    end;
end;


{ TResourceFile }

constructor TResourceFile.Create(AOwner: TComponent);
begin
  inherited;
  resources:=TList.create;
end;

destructor TResourceFile.Destroy;
begin
  resources.free;
  inherited;
end;

procedure TResourceFile.destroyresources;
var
    i:longint;
    r: TResourceEntry;
begin
    for i:=resources.count-1 downto 0 do begin
        r:=resources[i];
        r.free;
        resources.Delete(i);
    end;
end;

//Return all the resource names in strings
procedure TResourceFile.getResourceNames(strings: TStrings);
var
    i:longint;
    r: TResourceEntry;
begin
    for i:=0 to resources.count-1 do begin
        r:=resources[i];
        strings.add(r.resourcename);
    end;
end;

//Loads a resource file
procedure TResourceFile.loadfromfile(const filename:string);
var
    f: TFileStream;
    r: TResourceEntry;
begin
    destroyresources;
    f:=TFileStream.create(filename,fmOpenRead);
    try
        //Skip first 32 bytes
        f.Position:=32;

        while f.Position<f.size do begin
            r:=TResourceEntry.create;
            try
                r.ReadFromStream(f);
                resources.add(r);
            except
                r.free;
                raise;
            end;
        end;
    finally
        f.free;
    end;
end;

{ TResourceEntry }

constructor TResourceEntry.Create;
begin
    inherited;
    data:=TMemoryStream.create;
    resourceType:=rtNone;
end;

destructor TResourceEntry.Destroy;
begin
  data.free;
  inherited;
end;

procedure TResourceEntry.ReadFromStream(stream: TStream);
var
    w: word;
    //Aligns a integer to a dword
    function dwordalign(const value:integer):integer;
    begin
        result:=value;
        if (result mod 2)<>0 then result:=result+1;
        if (result mod 4)<>0 then result:=result+2;
    end;
begin
    stream.Read(datasize,4);
    stream.Read(headersize,4);

    //Reads the resource type
    stream.Read(w,2);
    if (w=$FFFF) then begin
        stream.Read(w,2);
        resourceType:=TResourceType(w-1);
    end
    else begin
        sresourcetype:='';
        while (w<>0) do begin
            sresourcetype:=sresourcetype+chr(w);
            stream.Read(w,2);
        end;
    end;

    //Reads the resource name
    stream.Read(w,2);
    if (w=$FFFF) then begin
        stream.Read(w,2);
        resourcename:=inttostr(w);
    end
    else begin
        resourcename:='';
        while (w<>0) do begin
            resourcename:=resourcename+chr(w);
            stream.Read(w,2);
        end;
    end;

    //Align dword boundaries
    stream.position:=dwordalign(stream.position);

    stream.Read(dataversion,4);
    stream.Read(flags,2);
    stream.Read(language,2);
    stream.Read(version,4);
    stream.Read(characteristics,4);

    //Stores the resource data in the stream
    data.CopyFrom(stream,datasize);

    //Align dword boundaries for next resource entry
    stream.position:=dwordalign(stream.position);
end;

function TResourceEntry.GetFormResAsText : string;
var
  streamOut : TStringStream;
  i : integer;
  len : word;
  w : word;
begin
   //only resourcetype RCData
   //all forms begin with TFilerSignature signature TPF0 (Turbo-Pascal-Filer)

   result := '';
   if resourceType = rtRCData then begin
     data.Position := 0;
     streamOut := TStringStream.Create('');

     objectBinaryToText( data, streamOut );
     result := streamOut.DataString;
     streamOut.Free;
   end;
end;

procedure TResourceEntry.GetStringListRes( strings : TStrings );
var
  len, w : word;
  i : integer;
  str : string;
begin
  //one stringlist resource can hold up to 16 strings
  //2 byte for length, string with n 2byte-chars
  //2 byte for length, string with n 2byte-chars
  //...
  strings.clear;
  if resourceType = rtString then begin
     data.Position := 0;
     while (data.Read(len, 2) = 2) and (len > 0) do begin
        str := '';
        for i := 1 to len do begin
          data.ReadBuffer(w, 2);
          str := str + chr(w);
        end;
        strings.Add(str)
     end;
  end;
end;


end.
