{$ keep 'testtrans' }
program testtrans(input,output);

uses common, controlmgr, toollocator, menumgr, ezmisc, ezconst, ezstring;

var
    Translation         :   pString;
    inName              :   GSOSInString;
    theName             :   pString;
    fileSystem          :   integer;

    Procedure TranslateName;
    var
        inCount         :   integer;
        outCount        :   integer;
        maxLength       :   integer;
        lastChar        :   char;
        wordSeparator   :   char;

        Function charNotValid(theChar   :   char) : boolean;
        begin
            charNotValid := True;

            case fileSystem of
                fsProDOS        :   If theChar in ['0'..'9','A'..'Z','a'..'z','.'] then
                                        charNotValid := False;
                fsAppleShare    :   If theChar in [' '..'9',';'..'~'] then
                                        charNotValid := False;
                fsHighSierra    :   If theChar in ['0'..'9','A'..'Z','_'] then
                                        charNotValid := False;
                otherwise       :   If theChar in ['0'..'9','A'..'Z','a'..'z','.'] then
                                        charNotValid := False;
            end;
        end;
    begin
        inCount := 1;
        outCount := 1;
        lastChar := char(1);

        case fileSystem of
            fsProDOS        :   begin
                                    maxLength := 15;
                                    wordSeparator := '.';
                                end;
            fsAppleShare    :   begin
                                    maxLength := 31;
                                    wordSeparator := '.';
                                end;
            fsHighSierra    :   begin
                                    maxLength := 28;
                                    wordSeparator := '_';
                                end;
            otherwise       :   begin
                                    maxLength := 15;
                                    wordSeparator := '.';
                                end;
        end;

        while (inCount <= inName.SLength) and
              (outCount <= maxLength)     do
        begin
            If fileSystem = fsHighSierra then
                inName.SText[inCount] := Upper(inName.SText[inCount]);

            If charNotValid(inName.SText[inCount])
            then
                Translation[outCount] := wordSeparator
            else
                Translation[outCount] := inName.SText[inCount];

            If (Translation[outCount] <> lastChar)
            then
                outCount := outCount + 1
            else
                If lastChar <> wordSeparator then
                    outCount := outCount + 1;

            lastChar := Translation[outCount - 1];

            inCount := inCount + 1;
        end;

        if outCount > maxLength then
            outCount := maxLength;

        Translation[0] := chr(outCount);

        if fileSystem = fsHighSierra then
            insert('.;1', Translation, length(Translation) + 1);
    end;

begin
    write('enter the name to translate : ');
    read(theName);

    write('enter the file system : ');
    readln(fileSystem);

    inName.stext := copy(theName,1,length(theName));
    inName.slength := length(theName);

    TranslateName;

    writeln('translated name is <',translation,'>');
end.
