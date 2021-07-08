*                              EZASM.ASM
*
* This unit contains routines for the manipulation of strings.
*
* Copyright 1989...End Of Time
* EZ-Soft
*
* Written by: P.C. Easdown

         absaddr on
         keep EZAsm

         mload asm/EZAsm.Macros
         copy 13/ainclude/e16.quickdraw
         copy 13/ainclude/e16.resources

ULongAdd start

result   equ    0

         subroutine (4:val1,4:val2),4
         
         longa  on
         clc
         lda    val1
         adc    val2
         sta    result
         lda    val1+2
         adc    val2+2
         sta    result+2
         
         return 4:result
         
         end

ULongSub start

result   equ    0

         subroutine (4:val1,4:val2),4
         
         longa  on
         
         sec
         lda    val1
         sbc    val2
         sta    result
         lda    val1+2
         sbc    val2+2
         sta    result+2
         
         return 4:result
         
         end
         
         
Upper    start

         subroutine (2:InChar),2

OutChar  equ   0

         lda   #$0000

         shortm

         lda   InChar
         cmp   #'a'
         bmi   Done
         cmp   #'z'+1
         bpl   Done
         and   #$5f

Done     sta   OutChar

         longm

         Return 2:OutChar

         end

; Will convert a pascal type string to uppercase.

UpperStr start

         subroutine (4:StrPtr),0

         lda   #$0000

         shortm

         lda   [StrPtr]
         beq   Done
         tay

DoChar   lda   [StrPtr],y
         cmp   #'a'
         bmi   NextChar
         cmp   #'z'+1
         bpl   NextChar
         and   #$5f
         sta   [StrPtr],y

NextChar dey
         bne   DoChar

Done     longm

         Return

         end

Lower    start

         subroutine (2:InChar),2

OutChar  equ   0

         lda   #$0000

         shortm

         lda   InChar
         cmp   #'A'
         bmi   Done
         cmp   #'Z'+1
         bpl   Done
         ora   #$20

Done     sta   OutChar

         longm

         Return 2:OutChar

         end

; Will convert a pascal type string to lowercase.

LowerStr start

         subroutine (4:StrPtr),0

         lda   #$0000

         shortm

         lda   [StrPtr]
         beq   Done
         tay

DoChar   lda   [StrPtr],y
         cmp   #'A'
         bmi   NextChar
         cmp   #'Z'+1
         bpl   NextChar
         ora   #$20
         sta   [StrPtr],y

NextChar dey
         bne   DoChar

Done     longm

         Return

         end

FixUserId start

         pea    0
         _MMStartUp
         sta    ~ToolError
         pla
         sta    ~User_Id

         rtl

         end

FixToolError start
    
         subroutine (2:InError),0

         lda    InError
         sta    ~ToolError

         return

         end

EZListCompare start
;                                     A case insensitive compare routine for
;                                     use with the list manager.

memberA  equ    4                   ; The members are pointed to by values
memberB  equ    memberA+4           ; supplied on the stack by the system.

         tsc
         phd
         tcd

         lda    [memberA]
         tax
         ldy    #$02
         lda    [memberA],y
         sta    memberA+2
         stx    memberA

         lda    [memberB]
         tax
         ldy    #$02
         lda    [memberB],y
         sta    memberB+2
         stx    memberB

         lda   #$0000

         shortm

         lda   [memberB]            ; We must first take a copy of member B,
         tay                        ; converting it to all uppercase at the
;                                     time.
DoChar1  lda   [memberB],y
         cmp   #'a'
         bmi   NextChr1
         cmp   #'z'+1
         bpl   NextChr1
         and   #$5f

NextChr1 sta   memcop,y
         dey
         bne   DoChar1

         ldy   #$01                 ; Now we convert each character of member
;                                     A, and compare the result of each
;                                     conversion against the character found
DoChar2  lda   [memberA],y          ; in the member B copy.
         cmp   #'a'
         bmi   NextChr2
         cmp   #'z'+1
         bpl   NextChr2
         and   #$5f

NextChr2 cmp   memcop,y
         bmi   ALessB
         bne   BLessA
         iny
         tya
         cmp   [memberA]
         beq   BLessA
         cmp   [memberB]
         bne   DoChar2

BLessA   longm
         sec
         bra   Done

ALessB   longm
         clc

Done     pld
         lda    0,s
         sta    8,s
         lda    2,s
         sta    10,s
         pla
         pla
         pla
         pla
         rtl

memcop   ds     256

         end

EZMessageBox start

            subroutine (4:inString),12

DialogRect  equ     0
v1          equ     0
h1          equ     2
v2          equ     4
h2          equ     6
Width       equ     8
ScreenWidth equ     10

            lda     #$0000

            shortm

            lda     [inString]
            tay
            sty     Width

cloop       lda     [inString],y
            sta     theString,y
            dey
            bpl     cloop
   
            longm

            pea     0
            _GetMasterSCB
            pla

            and     #scbColorMode
            cmp     #mode640
            bne     ModeIs320
            lda     #3
            sta     BackColor
            lda     #640
            bra     gotMode
ModeIs320   lda     #15
            sta     BackColor
            lda     #320

gotMode     sta     ScreenWidth

            ldy     Width
            tya
            asl     a
            asl     a
            asl     a
            sta     Width
            tya
            asl     a
            clc
            adc     Width
            adc     #40
            sta     Width

            lda     ScreenWidth
            sec
            sbc     Width
            lsr     a
            sta     h1
            clc
            adc     Width
            sta     h2
            lda     #90
            sta     v1
            lda     #110
            sta     v2

            pea     0
            phd
            pushlong    #EZDrwString
            jsl     startupEZDialog
            sta     DPtr
            stx     DPtr+2

            jsl     EZDrwString

            Return  4:DPtr

EZDrwString pushlong    DPtr
            _SetPort
            pea     20
            pea     15
            _MoveTo
            pea     0
            _SetForeColor
            lda     BackColor
            pha
            _SetBackColor

            pushlong    #theString
            _DrawString

            rtl

DPtr        ds      4
BackColor   ds      2
theString   ds      256

            end

EZUpdateWindow start

            subroutine (4:grafPort),12

            pushlong    grafPort
            _setPort

            pushlong    grafPort
            _beginUpdate

            pushlong    0
            pushlong    grafPort
            _getContentDraw
            pla
            sta     jumpAddress+1
            pla
            shortm
            sta     jumpAddress+3
            longm
            ora     jumpAddress+1
            beq     noRoutine
jumpAddress jsl     endOfRoutine

noRoutine   pushlong    grafPort
            _endUpdate

endOfRoutine Return

            end

EZDrawMember        start

fileType            equ         0       ; 4
markChar            equ         4       ; 2
icon                equ         6       ; 4
memberStringRect    equ         10      ; 8
drawMode            equ         18      ; 2
dimPattern          equ         20      ; 4
textMode            equ         24      ; 2
penMode             equ         26      ; 2
foreColor           equ         28      ; 2
backColor           equ         30      ; 2

returnAddress       equ         32      ; 3
listHandle          equ         35      ; 4
memberPtr           equ         39      ; 4
memberRect          equ         43      ; 4

                    tsc
                    sec
                    sbc         #32
                    tcs
                    inc         a
                    phd
                    tcd

                    pushlong    #0
                    pushword    #rListPattern
                    pushlong    #1
                    _LoadResource
                    pla
                    sta         dimPattern
                    pla
                    sta         dimPattern+2

                    ldy         #5              ; Get the file type
                    lda         [memberPtr],y
                    inc         a
                    sta         fileType
                    stz         fileType+2

                    ldy         #7              ; Get the mark character
                    lda         [memberPtr],y
                    sta         markChar
                    stz         markChar+2

                    pushlong    #0               ; Get icons handle
                    pushWord    #rListIcon
                    pushLong    fileType
                    _LoadResource
                    sta         ~ToolError
                    tay
                    pla
                    sta         icon
                    pla
                    sta         icon+2

                    cpy         #resNotFound
                    bne         gotIcon
                    pushlong    #0
                    pushWord    #rListIcon
                    pushLong    #unknownFileType+1
                    _LoadResource
                    sta         ~ToolError
                    pla
                    sta         icon
                    pla
                    sta         icon+2

gotIcon             lda         [memberRect]        ; Adjust text rectangle
                    sta         memberStringRect
                    ldy         #2
                    tyx
                    lda         [memberRect],y
                    clc
                    adc         #30
                    sta         memberStringRect,x
                    iny
                    iny
                    tyx
                    lda         [memberRect],y
                    sta         memberStringRect,x
                    iny
                    iny
                    tyx
                    lda         [memberRect],y
                    sta         memberStringRect,x

                    pushWord    #0             ; Adjust text to fit rect.
                    tdc
                    clc
                    adc         #memberStringRect
                    pha
                    ldy         #2
                    lda         [memberPtr],y
                    pha
                    lda         [memberPtr]
                    pha
                    pushLong    #memberString
                    pea         addToEnd
                    jsl         EZFixStringToRect

                    pha                             ; Preserve the current 
                    _getPenMode                     ; drawing modes
                    pla
                    sta         penMode
                    pha
                    _getTextMode
                    pla
                    sta         textMode
                    pha
                    _getForeColor
                    pla
                    sta         foreColor
                    pha
                    _getBackColor
                    pla
                    sta         backColor

                    ldy         #4                  ; Set the drawing modes to
                    lda         [memberPtr],y       ; suit the members current
                    and         #$ff                ; state.
                    cmp         #$80
                    bne         notNormalImage
                    lda         #$f000              ; Member has not been
                    sta         drawMode            ; selected.
                    pea         15
                    _setForeColor
                    pea         0
                    _setBackColor
                    pea         0
                    _setSolidPenPat
                    pushLong    memberRect
                    _paintRect
                    bra         modesSet
notNormalImage      and         #$40                ; Member is dimmed.
                    beq         notGrayImage
                    lda         #$f004
                    sta         drawMode
                    pea         0
                    _setForeColor
                    pea         15
                    _setBackColor
                    pea         modeOR
                    _setPenMode
                    ldy         #2
                    lda         [dimPattern],y
                    pha
                    lda         [dimPattern]
                    pha
                    _setPenPat
                    pea         modeForeCopy
                    _setTextMode
                    bra         modesSet
notGrayImage        lda         #$f001              ; Member is selected.
                    sta         drawMode
                    pea         0
                    _setForeColor
                    pea         15
                    _setBackColor
                    pea         15
                    _setSolidPenPat
                    pushLong    memberRect
                    _paintRect

modesSet            lda         [memberRect]        ; Drawing modes are set,
                    clc                             ; now position pen for
                    adc         #8                  ; drawing the mark character
                    tax
                    ldy         #2
                    lda         [memberRect],y
                    clc
                    adc         #2
                    pha
                    phx
                    _moveTo

                    lda         markChar            ; Draw the mark character
                    beq         noMarkChar
                    pha
                    _drawChar

noMarkChar          ldy         #2                  ; Draw the icon
                    lda         [icon],y
                    pha
                    lda         [icon]
                    pha
                    lda         drawMode
                    pha
                    lda         [memberRect],y
                    clc
                    adc         #12
                    pha
                    lda         [memberRect]
                    pha
                    _drawIcon

                    lda         [memberRect]        ; Move the cursor before 
                    clc                             ; drawing the string.
                    adc         #8
                    tax
                    ldy         #2
                    lda         [memberRect],y
                    clc
                    adc         #32
                    pha
                    phx
                    _moveTo

;                   ldy         #2
;                   lda         [memberPtr],y
;                   pha
;                   lda         [memberPtr]
;                   pha
                    pushLong    #memberString        ; Draw the string.
                    _drawString

                    ldy         #4                  ; If dimmed, then paint over
                    lda         [memberPtr],y       ; the area with the dimmed
                    and         #$40                ; pattern.
                    beq         done
                    pushLong    memberRect
                    _paintRect

done                pushWord    foreColor           ; Restore the drawing modes
                    _setForeColor
                    pushWord    backColor
                    _setBackColor
                    pushWord    penMode
                    _setPenMode
                    pushWord    textMode
                    _setTextMode

                    lda         returnAddress
                    sta         memberRect+1
                    lda         returnAddress+1
                    sta         memberRect+2

                    pld
                    tsc
                    clc
                    adc         #44
                    tcs
                    
                    rtl

memberString        ds          256

         end
