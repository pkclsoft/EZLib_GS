{$ keep 'TestCtl'}
Program TestCtl(erroroutput);

Uses Common, QuickDrawII, ControlMgr, WindowMgr, ListMgr, LineEdit,
     MenuMgr, ToolLocator, DeskMgr, TextEdit;
     
{$ libprefix 'int/' }
USES EZConst, EZMisc, EZControls, EZTools,
     EZWindows, EZDisk;

Const
   aOkItem                  = 1;
   aCancelItem              = 2;
   aCheckBoxItem            = 3;
   aIconButtonItem          = 4;
   aLineEditItem            = 5;
   aListItem                = 6;
   aPopupItem               = 7;
   aRadioButton1Item        = 8;
   aRadioButton2Item        = 9;
   aScrollBarItem           = 10;
   aStaticTextItem          = 11;
   aTextEditItem            = 12;
   aNullItem                = 13;

   eTextEditItem            = 1;
   eNullItem                = 2;

   mList1Item               = 1;
   mList2Item               = 2;
   mList3Item               = 3;
   mList4Item               = 4;
   mNullItem                = 5;

   AboutMenuItem            = 257;
   AllMenuItem              = 401;
   EditMenuItem             = 402;
   ManyMenuItem             = 403;
   TranslateMenuItem        = 404;
   QuitItem                 = 499;

   TestMenuDefault          = 262;

   WindWidth                = 600;
   WindHeight               = 165;

type
   TesticonRec = record
       iconType:   integer;
       iconSize:   integer;
       iconHeight: integer;
       iconWidth:  integer;
       iconImage:  array [1..128] of byte;
       iconMask:   array [1..128] of byte;
       end;
   TesticonRecPtr = ^TesticonRec;

var
   TestPort            : grafPortPtr;
   TestRect            : rect;

   ERec                : eventRecord;
   ERec2               : eventRecord;

   NewControl2Junk     : ctlRecHndl;

   ssrec               : startStopRecPtr;

   ctlList             : array [1..aNullItem] of ptr;

   NumOfClicks         : integer;
   itemHit             : longint;

   TestIcon            : testiconrec;
   TestList            : memberList;
   TestList1           : memberList;
   TestList2           : memberList;
   TestList3           : memberList;
   TestList4           : memberList;
   TestPopupMenu       : textPtr;
   TestPopupMenuPtr    : Ptr;
   TestStaticText      : textBlock;
   TestIndentRect      : rect;
   TestTextRef         : pString;
   TestCreateScrollBar : ctlRecHndl;
   TestWindowRecord    : paramList;

   Handled             : boolean;

Procedure CreateMenus;
{ Will initialise all of the menus to appear in the menu bar. }
var
   Height       : Integer;
   MenuHand     : MenuHandle;
   MenuString   : TextPtr;

begin
    new(MenuString);
    MenuString^ := concat('>>   Edit \N2', chr(Return));
    MenuString^ := concat(MenuString^, '--Undo\N250V*Zz', chr(Return));
    MenuString^ := concat(MenuString^, '--Cut\N251*Xx', chr(Return));
    MenuString^ := concat(MenuString^, '--Copy\N252*Cc', chr(Return));
    MenuString^ := concat(MenuString^, '--Paste\N253*Vv', chr(Return));
    MenuString^ := concat(MenuString^, '--Clear\N254', chr(Return));
    MenuString^ := concat(MenuString^, '.',chr(Return));
    MenuHand    := NewMenu(MenuString);
    InsertMenu(MenuHand,0);

    new(MenuString);
    MenuString^ := concat('>>   File \N1', chr(Return));
    MenuString^ := concat(MenuString^, '--All Controls...\N401*Aa', chr(Return));
    MenuString^ := concat(MenuString^, '--Edit Control...\N402V*Ee', chr(Return));
    MenuString^ := concat(MenuString^, '--Many Lists...\N403V*Mm', chr(Return));
    MenuString^ := concat(MenuString^, '--Test Translation...\N404V*Mm', chr(Return));
    MenuString^ := concat(MenuString^, '--Quit\N499*Qq', chr(Return));
    MenuString^ := concat(MenuString^, '.', chr(Return));
    MenuHand    := NewMenu(MenuString);
    InsertMenu(MenuHand,0);

    new(MenuString);
    MenuString^ := concat('>>@\XN0', chr(Return));
    MenuString^ := concat(MenuString^, '--About ShowControls...\N257V*?/',chr(Return));
    MenuString^ := concat(MenuString^, '.',chr(Return));
    MenuHand    := NewMenu(MenuString);
    InsertMenu(MenuHand,0);
    FixAppleMenu(0);

    Height := FixMenuBar;
    DrawMenuBar;
end;

Procedure CreateAllControls;
var
   tmpRect     : rect;
   i           : integer;
begin
   with TmpRect do
   begin
       h1 := 5;
       h2 := 0;
       v1 := 5;
       v2 := 0;
   end;

   ctlList[aOkItem]  := newButtonTemplate(aOkItem,
                                         TmpRect,
                                         1,
                                         0,
                                         0,
                                         @'Ok',
                                         Nil,
                                         Nil);

   with TmpRect do
   begin
       h1 := 60;
       h2 := 0;
       v1 := 5;
       v2 := 0;
   end;

   ctlList[aCancelItem]  := newButtonTemplate(aCancelItem,
                                             TmpRect,
                                             0,
                                             0,
                                             0,
                                             @'Cancel',
                                             Nil,
                                             Nil);

   with TmpRect do
   begin
       h1 := 60;
       h2 := 0;
       v1 := 50;
       v2 := 0;
   end;

   ctlList[aCheckBoxItem]  := newCheckBoxTemplate(aCheckBoxItem,
                                                 TmpRect,
                                                 0,
                                                 0,
                                                 0,
                                                 @'A new checkbox.',
                                                 Off,
                                                 Nil,
                                                 Nil);

   with TmpRect do
   begin
       h1 := 60;
       h2 := 0;
       v1 := 60;
       v2 := 0;
   end;

   with TestIcon do
   begin
       iconType := $8000;
       iconSize := 128;
       iconHeight := 16;
       iconWidth := 16;
       for i := 1 to 128 do
           iconImage[i]  := $55;
       for i := 1 to 128 do
           iconMask[i]  := $ff;
   end;

   ctlList[aIconButtonItem]  := newIconButtonTemplate(aIconButtonItem,
                                                     TmpRect,
                                                     $0004,
                                                     0,
                                                     0,
                                                     @TestIcon,
                                                     @'Icon Control',
                                                     $0f00,
                                                     Nil,
                                                     Nil);

   with TmpRect do
   begin
       h1 := 5;
       h2 := 190;
       v1 := 115;
       v2 := 128;
   end;

   ctlList[aLineEditItem]  := newLineEditTemplate(aLineEditItem,
                                                 TmpRect,
                                                 0,
                                                 0,
                                                 0,
                                                 20,
                                                 @'This is an Edit Line');

   with TmpRect do
   begin
       h1 := 200;
       h2 := 571;
       v1 := 98;
       v2 := 149;
   end;

   TestList[1].memPtr := @'The first member';
   TestList[1].memFlag := 0;
   TestList[2].memPtr := @'is before the second';
   TestList[2].memFlag := 0;
   TestList[3].memPtr := @'but the third comes';
   TestList[3].memFlag := 0;
   TestList[4].memPtr := @'after the second, as';
   TestList[4].memFlag := 0;
   TestList[5].memPtr := @'do most others.';
   TestList[5].memFlag := 0;
   TestList[6].memPtr := @'This is a list control';
   TestList[6].memFlag := 0;

   ctlList[aListItem]  := newListTemplate(aListItem,
                                         TmpRect,
                                         0,
                                         0,
                                         0,
                                         6,
                                         5,
                                         2,
                                         1,
                                         Nil,
                                         10,
                                         5,
                                         @TestList,
                                         Nil);

   with TmpRect do
   begin
       h1 := 5;
       h2 := 0;
       v1 := 100;
       v2 := 0;
   end;

   new(TestPopupMenu);
   TestPopupMenu^ := concat('$$Popup:\N6', chr(Return),
                            '--Popup Option 1\N259', chr(Return),
                            '--Popup Option 2\N260', chr(Return),
                            '--Popup Option 3\N261', chr(Return),
                            '--Popup Option 4\N262', chr(Return),
                            '.',chr(Return));

   TestPopupMenuPtr := ptr(TestPopupMenu);

   ctlList[aPopupItem]  := newPopUpTemplate(aPopupItem,
                                           TmpRect,
                                           $0000,
                                           $0004,
                                           0,
                                           0,
                                           TestPopupMenuPtr,
                                           TestMenuDefault,
                                           Nil);

   with TmpRect do
   begin
       h1 := 60;
       h2 := 0;
       v1 := 30;
       v2 := 0;
   end;

   ctlList[aRadioButton1Item]  := newRadioButtonTemplate(aRadioButton1Item,
                                                        TmpRect,
                                                        1,
                                                        0,
                                                        0,
                                                        @'Radio Button 1',
                                                        On,
                                                        Nil,
                                                        Nil);

   with TmpRect do
   begin
       h1 := 60;
       h2 := 0;
       v1 := 40;
       v2 := 0;
   end;

   ctlList[aRadioButton2Item]  := newRadioButtonTemplate(aRadioButton2Item,
                                                        TmpRect,
                                                        1,
                                                        0,
                                                        0,
                                                        @'Radio Button 2',
                                                        Off,
                                                        Nil,
                                                        Nil);

   with TmpRect do
   begin
       h1 := 5;
       h2 := 50;
       v1 := 30;
       v2 := 95;
   end;

   ctlList[aScrollBarItem]  := newScrollBarTemplate(aScrollBarItem,
                                                   TmpRect,
                                                   3,
                                                   0,
                                                   0,
                                                   10,
                                                   4,
                                                   4,
                                                   Nil);

   with TmpRect do
   begin
       h1 := 5;
       h2 := 190;
       v1 := 130;
       v2 := 165;
   end;

   TestStaticText := concat('This text is within a static text control ',
                            'and is fully justified.');

   ctlList[aStaticTextItem]  := newStatTextTemplate(aStaticTextItem,
                                                   TmpRect,
                                                   0,
                                                   0,
                                                   0,
                                                   @TestStaticText,
                                                   length(TestStaticText),
                                                   2);

   with TmpRect do
   begin
       h1 := 200;
       h2 := 595;
       v1 := 5;
       v2 := 95;
   end;

   with TestIndentRect do
   begin
       h1 := $FFFF;
       h2 := $FFFF;
       v1 := $FFFF;
       v2 := $FFFF;
   end;

   TestTextRef := concat('This is one of the new Text Edit controls. ',
                         'capable of doing virtually any editing you ',
                         'would ever want, and without the hassle of ',
                         'writing your own word processor.');


   TestCreateScrollBar := ctlRecHndl(-1);

   ctlList[aTextEditItem]  := newEditTextTemplate(aTextEditItem,
                                                 TmpRect,
                                                 0,
                                                 0,
                                                 0,
                                                 $20a80000,
                                                 TestIndentRect,
                                                 TestCreateScrollBar,
                                                 0,
                                                 Nil,
                                                 0,
                                                 @TestTextRef,
                                                 length(TestTextRef),
                                                 0,
                                                 Nil,
                                                 0,
                                                 Nil);

   ctlList[aNullItem]  := Nil;
end;

Procedure CreateManyLists;
var
   TmpRect     : rect;
begin
   with TmpRect do
   begin
       h1 := 5;
       h2 := 275;
       v1 := 5;
       v2 := 57;
   end;

   TestList1[1].memPtr := @'List 1 - Line 1';
   TestList1[1].memFlag := 0;
   TestList1[2].memPtr := @'List 1 - Line 2';
   TestList1[2].memFlag := 0;
   TestList1[3].memPtr := @'List 1 - Line 3';
   TestList1[3].memFlag := 0;
   TestList1[4].memPtr := @'List 1 - Line 4';
   TestList1[4].memFlag := 0;
   TestList1[5].memPtr := @'List 1 - Line 5';
   TestList1[5].memFlag := 0;
   TestList1[6].memPtr := @'This is list control 1';
   TestList1[6].memFlag := 0;

   ctlList[mList1Item]  := newListTemplate(mList1Item,
                                           TmpRect,
                                           0,
                                           0,
                                           0,
                                           6,
                                           5,
                                           2,
                                           1,
                                           Nil,
                                           10,
                                           5,
                                           @TestList1,
                                           Nil);

   with TmpRect do
   begin
       h1 := 305;
       h2 := 572;
       v1 := 5;
       v2 := 57;
   end;

   TestList2[1].memPtr := @'List 2 - Line 1';
   TestList2[1].memFlag := 0;
   TestList2[2].memPtr := @'List 2 - Line 2';
   TestList2[2].memFlag := 0;
   TestList2[3].memPtr := @'List 2 - Line 3';
   TestList2[3].memFlag := 0;
   TestList2[4].memPtr := @'List 2 - Line 4';
   TestList2[4].memFlag := 0;
   TestList2[5].memPtr := @'List 2 - Line 5';
   TestList2[5].memFlag := 0;
   TestList2[6].memPtr := @'This is list control 2';
   TestList2[6].memFlag := 0;

   ctlList[mList2Item]  := newListTemplate(mList2Item,
                                           TmpRect,
                                           0,
                                           0,
                                           0,
                                           6,
                                           5,
                                           2,
                                           1,
                                           Nil,
                                           10,
                                           5,
                                           @TestList2,
                                           Nil);

   with TmpRect do
   begin
       h1 := 5;
       h2 := 275;
       v1 := 80;
       v2 := 132;
   end;

   TestList3[1].memPtr := @'List 3 - Line 1';
   TestList3[1].memFlag := 0;
   TestList3[2].memPtr := @'List 3 - Line 2';
   TestList3[2].memFlag := 0;
   TestList3[3].memPtr := @'List 3 - Line 3';
   TestList3[3].memFlag := 0;
   TestList3[4].memPtr := @'List 3 - Line 4';
   TestList3[4].memFlag := 0;
   TestList3[5].memPtr := @'List 3 - Line 5';
   TestList3[5].memFlag := 0;
   TestList3[6].memPtr := @'This is list control 3';
   TestList3[6].memFlag := 0;

   ctlList[mList3Item]  := newListTemplate(mList3Item,
                                           TmpRect,
                                           0,
                                           0,
                                           0,
                                           6,
                                           5,
                                           2,
                                           1,
                                           Nil,
                                           10,
                                           5,
                                           @TestList3,
                                           Nil);

   with TmpRect do
   begin
       h1 := 305;
       h2 := 572;
       v1 := 80;
       v2 := 132;
   end;

   TestList4[1].memPtr := @'List 4 - Line 1';
   TestList4[1].memFlag := 0;
   TestList4[2].memPtr := @'List 4 - Line 2';
   TestList4[2].memFlag := 0;
   TestList4[3].memPtr := @'List 4 - Line 3';
   TestList4[3].memFlag := 0;
   TestList4[4].memPtr := @'List 4 - Line 4';
   TestList4[4].memFlag := 0;
   TestList4[5].memPtr := @'List 4 - Line 5';
   TestList4[5].memFlag := 0;
   TestList4[6].memPtr := @'This is list control 4';
   TestList4[6].memFlag := 0;

   ctlList[mList4Item]  := newListTemplate(mList4Item,
                                           TmpRect,
                                           0,
                                           0,
                                           0,
                                           6,
                                           5,
                                           2,
                                           1,
                                           Nil,
                                           10,
                                           5,
                                           @TestList4,
                                           Nil);

    ctlList[mNullItem] := Nil;
end;

Procedure DoAllControls;
begin
   with TestRect do
   begin
       h1 := 20;
       v1 := 25;
       h2 := h1 + WindWidth;
       v2 := v1 + WindHeight;
   end;

   TestPort := startupEZDialog(TestRect, @EZDrawControls);

   CreateAllControls;

   NewControl2Junk := NewControl2(TestPort, 3, @ctlList);

   DrawControls(TestPort);

   InitCursor;

   Repeat
       itemHit := EZDialogEvent(NumOfClicks);
   Until itemHit = aOkItem;

   CloseWindow(TestPort);

   HilIteMenu(False,ConvL2I(ERec.TaskData).msw);
end;

Procedure DoManyLists;
begin
   with TestRect do
   begin
       h1 := 20;
       v1 := 25;
       h2 := h1 + WindWidth;
       v2 := v1 + WindHeight;
   end;

   With TestWindowRecord do
   begin
       paramLength := 78;
       wFrameBits := $c0a9;  { 1100 0000 1010 1001 }
       wTitle := @'Many Lists in one Window';
       wRefCon := 0;
       wZoom.h1 := 0;
       wZoom.h2 := 0;
       wZoom.v1 := 0;
       wZoom.v2 := 0;
       wColor := Nil;
       wYOrigin := 0;
       wXOrigin := 0;
       wScrollVer := 0;
       wScrollHor := 0;
       wPageVer := 0;
       wPageHor := 0;
       wInfoRefCon := 0;
       wInfoHeight := 0;
       wFrameDefProc := nil;
       wInfoDefProc := nil;
       wPlane := pointer(topMost);
       wStorage := nil;
   end;

   TestPort := startupEZWindow(TestRect, @TestWindowRecord, @EZDrawControls);

   CreateManyLists;

   NewControl2Junk := NewControl2(TestPort, 3, @ctlList);

   DrawControls(TestPort);

   InitCursor;

   Repeat
       itemHit := EZAnyEvent(ERec2, Handled, False);
   Until itemHit = wInGoAway;

   CloseWindow(TestPort);
end;

Procedure CreateEditControl;
begin
   with TestRect do
   begin
       h1 := 0;
       h2 := 0;
       v1 := 0;
       v2 := 0;
   end;

   with TestIndentRect do
   begin
       h1 := $FFFF;
       h2 := $FFFF;
       v1 := $FFFF;
       v2 := $FFFF;
   end;

   TestTextRef := concat('This is one of the new Text Edit controls. ',
                         'capable of doing virtually any editing you ',
                         'would ever want, and without the hassle of ',
                         'writing your own word processor.');

   TestCreateScrollBar := ctlRecHndl(-1);

   ctlList[eTextEditItem]  := newEditTextTemplate(eTextEditItem,
                                                 TestRect,
                                                 0,
                                                 $0800,
                                                 0,
                                                 $20a80000,
                                                 TestIndentRect,
                                                 TestCreateScrollBar,
                                                 0,
                                                 Nil,
                                                 0,
                                                 @TestTextRef,
                                                 length(TestTextRef),
                                                 0,
                                                 Nil,
                                                 0,
                                                 Nil);

   ctlList[eNullItem]  := Nil;
end;

Procedure DoEditControl;
begin
   with TestRect do
   begin
       h1 := 20;
       v1 := 25;
       h2 := h1 + WindWidth;
       v2 := v1 + WindHeight;
   end;

   With TestWindowRecord do
   begin
       paramLength := 78;
       wFrameBits := $c0a9;  { 1100 0000 1010 1001 }
       wTitle := @'Edit Text Control';
       wRefCon := 0;
       wZoom.h1 := 0;
       wZoom.h2 := 0;
       wZoom.v1 := 0;
       wZoom.v2 := 0;
       wColor := Nil;
       wYOrigin := 0;
       wXOrigin := 0;
       wScrollVer := 0;
       wScrollHor := 0;
       wPageVer := 0;
       wPageHor := 0;
       wInfoRefCon := 0;
       wInfoHeight := 0;
       wFrameDefProc := nil;
       wInfoDefProc := nil;
       wPlane := pointer(topMost);
       wStorage := nil;
   end;

   TestPort := startupEZWindow(TestRect, @TestWindowRecord, @EZDrawControls);

   CreateEditControl;

   NewControl2Junk := NewControl2(TestPort, 3, @ctlList);

   DrawControls(TestPort);

   Repeat
       itemHit := EZAnyEvent(ERec2, Handled, False);
   Until itemHit = wInGoAway;

   CloseWindow(TestPort);
end;

Procedure DoAboutItem;
var
   Msg  : textBlock;                {alert Message}
   Junk : Integer;
begin
   Msg := concat('73:',
                 'Extended Controls / EZ Library Demonstration', chr(Return),
                 'Copyright 1989, Powerup Technology', chr(Return),
                 'By Peter Easdown:^#0');
   Junk := AlertWindow(0,Nil,@Msg);
end;

Procedure TryTranslation;
var
    inName      :   FileNameString;
    fileSystem  :   integer;

    junk        :   Boolean;
begin
    inName.SText := '1 Strange f#$!name';
    inName.SLength := 18;
    fileSystem := fsProDOS;

    junk := EZTranslateName(inName, fileSystem);
end;

begin
   ssrec := EZStartDesk(mode640);

   CreateMenus;

   InitCursor;

   Repeat
       itemHit := EZAnyEvent(ERec, Handled, True);

       case ord(itemHit) of

           AboutMenuItem        : DoAboutItem;
           AllMenuItem          : DoAllControls;
           EditMenuItem         : DoEditControl;
           ManyMenuItem         : DoManyLists;
           TranslateMenuItem    : TryTranslation;
           otherwise       ;
       end;

       If (itemHit > 400) and (itemHit < QuitItem) then
           HilIteMenu(False,ConvL2I(ERec.TaskData).msw);
   Until itemHit = QuitItem;

   EZEndDesk(ssrec);
end.
