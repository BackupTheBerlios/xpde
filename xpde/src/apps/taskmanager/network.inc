// network.inc
// I'll include it to uTaskManager.pas after finish this part.
Procedure TWindowsTaskManagerDlg.Read_Net(netfile:string);
var netstr_:TStrings;
    i,x,j,jj:integer;
    fi:TextFile;
    sbuf,ss:string;
    bytes_in,bytes_out:double;
Begin
        netstr_:=TStringList.Create;
        try
        AssignFile(fi,netfile);
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        netstr_.Add(sbuf);
        End;
        CloseFile(fi);

        for i:=2 to netstr_.Count - 1 do begin
        x:=0;
        j:=pos(':',netstr_.Strings[i]);
        // Find dev names fo Listview
        if j<>0 then begin
        dev_names[i-2]:=copy(netstr_.Strings[i],1,j-1);
        netstr_.Strings[i]:=copy(netstr_.Strings[i],j+1,length(netstr_.Strings[i]));
        sbuf:=netstr_.Strings[i]+' ';
        End;

        // INTERESTING POSITIONS FOR US ARE BYTES_IN,BYTES_OUT
        // so we can paint graph with differences
        // Graph will change it's max values, depending of max_bytes_in & max_bytes_out
        for jj:=1 to length(netstr_.Strings[i]) do begin
        sbuf:=trimleft(sbuf);
        j:=pos(' ',sbuf);
        if j<>0 then begin
                inc(x);
                case x of
                        1:Begin
                          ss:=copy(sbuf,1,j-1);
                          sbuf:=copy(sbuf,j+1,length(sbuf));
                          // we fill bytes_in values for each device
                          try
                          bytes_in:=StrToFloat(ss);
                          except
                          bytes_in:=0;
                          End;
//                          writeln('BYTES_IN ',FloatToStrF(bytes_in,ffFixed,16,2),' DIFF NET ',FloatToStrF(diff_net[i,0],ffFixed,16,2));
//                          writeln('BYTES - DIFF ',FloatToStrF(bytes_in-diff_net[i,0],ffFixed,16,2));
                          devs_matrix[i,du_y]:=trunc(bytes_in - diff_net[i,0]);
//                          writeln('DEVICE ',dev_names[i-2],' DEVS_matrix up ',devs_matrix[i,du_y] div 1024);
                          diff_net[i,0]:=bytes_in;
                          End;

                          else
                          sbuf:=copy(sbuf,j+1,length(sbuf));

                        End; // CASE x

        sbuf:=copy(sbuf,j+1,length(sbuf));
        End;

        End; // jj

        End;

                          inc(du_y);
                          if du_y > PB5.Width then
                          du_y:=0;


        finally
        netstr_.Free;
        End;
End;

