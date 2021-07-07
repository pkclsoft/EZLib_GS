{$ keep 'ctest' }
program ctest (input, output, erroroutput);

uses common, controlmgr, menumgr, toollocator, gsos, ezconst, ezmisc, ezcrypt;

var
    instr       :   pstring;
    inkeystr    :   pstring;
    junk        :   boolean;

procedure disphex;
var
    charindex   :   integer;
    tmpstr      :   pString;
    column      :   integer;
    line        :   integer;
begin
    column := 1;
    line := 0;
    hex(ord4(line),4,tmpstr);
    write('$',tmpstr,' | ');

    for charindex := 0 to length(instr) do
    begin
        hex(ord4(instr[charindex]),2,tmpstr);
        write(tmpstr);
        column := column + 1;
        if column = 17 then
        begin
            column := 1;
            line := line + 16;
            writeln;
            hex(ord4(line),4,tmpstr);
            write('$',tmpstr,' | ');
        end;
    end;

    writeln;
    writeln;
end;

begin
    write('enter the string to be encrypted : ');
    readln(instr);

    write('enter the key : ');
    readln(inkeystr);

    ezcrypt(@instr[1], length(instr), inkeystr);

    disphex;

    ezcrypt(@instr[1], length(instr), inkeystr);

    disphex;

    writeln('result of double crypt = <',instr,'>');

    ezcreateserialnumber('EZB',inkeystr,1,instr);

    disphex;
end.

