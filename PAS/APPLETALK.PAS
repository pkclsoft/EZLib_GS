{$keep 'appletalk'}

unit appletalk;

interface
uses common;

TYPE
String32 = PACKED ARRAY[0..32] OF CHAR;
String100 = PACKED ARRAY[0..100] OF CHAR;

AtlkBuffer = PACKED ARRAY [1..1024] OF CHAR;


Atgetinfo       = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        ThisNet         : INTEGER;
        ABridge         : BYTE;
        HardwareID      : BYTE;
        ROMVersion      : INTEGER;
        NodeNumber      : BYTE;
END;

AtReadBuffer    = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        RequestCount    : INTEGER;
        BufferPointer   : PTR;
        Purgeflag       : BYTE;
        Amountread      : INTEGER;
END;

AtOpenSocket    = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Socket          : BYTE;
        ClientAddress   : PTR;
END;

AtCloseSocket   = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Socket          : BYTE;
END;

AtRegisterName  = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        NameStructure   : PTR;
        RetryInterval   : BYTE;
        RetryCount      : BYTE;
        Reserved        : INTEGER;
        Socket          : BYTE;
        Checkflag       : BYTE;
END;


AtNBPNameStructure = RECORD
        Reserved : PACKED ARRAY [1..9] OF CHAR;
        Name     : String100;
END;


AtLookupName = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        NamePointer     : PTR;
        RetryInterval   : BYTE;
        RetryCount      : BYTE;
        Reserved        : INTEGER;
        BufferLength    : INTEGER;
        BufferPointer   : PTR;
        MaxMatches      : BYTE;
        ActualMatches   : BYTE;
END;


AtConfirmName = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        NamePointer     : PTR;
        RetryInterval   : BYTE;
        RetryCounter    : BYTE;
        Reserved        : INTEGER;
        Network         : INTEGER;
        Node            : BYTE;
        Socket          : BYTE;
        ActualSocket    : BYTE;
END;


AtSendATPReq = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        DynamicSocket   : BYTE;
        DestNetwork     : INTEGER;
        DestNode        : BYTE;
        DestSocket      : BYTE;
        ATPID           : INTEGER;
        ReqBufferLength : INTEGER;
        ReqBufferPointer: PTR;
        UserBytes       : PACKED ARRAY [1..4] OF CHAR;
        NumRespBuffers  : BYTE;
        RespBDSPointer  : PTR;
        ATPFlags        : BYTE;
        RetryInterval   : BYTE;
        RetryCount      : BYTE;
        CurrentBitMap   : BYTE;
        RespRecvd       : BYTE;
        Reserved        : PACKED ARRAY [1..6] OF CHAR;
END;


AtCancelATPReq  = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        ATPID           : INTEGER;
END;


AtOpenATPSocket = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Socket          : BYTE;
END;


AtCloseATPSocket = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Socket          : BYTE;
END;


AtGetATPReq = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        ResponseSocket  : BYTE;
        SourceNetwork   : INTEGER;
        SourceNode      : BYTE;
        SourceSocket    : BYTE;
        ATPID           : INTEGER;
        ReqBufferLength : INTEGER;
        ReqBufferPointer: PTR;
        UserBytes       : PACKED ARRAY [1..4] OF CHAR;
        ReqLength       : INTEGER;
        ATPFlags        : BYTE;
        Bitmap          : BYTE;
        Reserved        : LONGINT;
END;


AtSendATPResp = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        ResponseSocket  : BYTE;
        DestNetwork     : INTEGER;
        DestNode        : BYTE;
        DestSocket      : BYTE;
        ATPID           : INTEGER;
        NumRespBuffers  : BYTE;
        TotalATPPackets : BYTE;
        RespBDSPointer  : PTR;
        ATPFlags        : BYTE;
        CurrentBitmap   : BYTE;
        AddRoutinePtr   : PTR;
        AddBitmap       : BYTE;
END;


{
 AddATPReq not currently supported
}


AtRelATPCB = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        ResponseSocket  : BYTE;
        DestNetwork     : INTEGER;
        DestNode        : BYTE;
        DestSocket      : BYTE;
        ATPID           : INTEGER;
END;


AtGetMyZone = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        BufferPointer   : PTR;
        RetryInterval   : BYTE;
        RetryCount      : BYTE;
        Reserved        : INTEGER;
END;


AtGetZoneList = RECORD
        Flag            : INTEGER;
        Result          : INTEGER;
        Completion      : PTR;
        BufferLength    : INTEGER;
        BufferPointer   : PTR;
        BridgeNodeNum   : BYTE;
        StartIndex      : INTEGER;
        RetryInterval   : BYTE;
        RetryCount      : BYTE;
        Zones           : INTEGER;
        Reserved        : LONGINT;
END;


SocketRec = RECORD
        Active          : BOOLEAN;
        Network         : INTEGER;
        Node            : BYTE;
        Socket          : BYTE;
        Enumerator      : BYTE;
        Object          : String32;
        Tiep            : String32;
        Zone            : String32;
END;


ZoneRec = RECORD
        Active          : BOOLEAN;
        Name            : String32;
END;




{
 external appletalk functions and procedures
}

PROCEDURE Completion;                                           EXTERN;

{
 misc
}
PROCEDURE AtlkGetInfo (a : AtGetInfo);                          EXTERN;

{
 link access protocol
}
PROCEDURE AtlkReadBuffer (a : AtReadBuffer);                    EXTERN;

{
 datagram delivery protocol
}
PROCEDURE AtlkOpenSocket (a : AtOpenSocket);                    EXTERN;
PROCEDURE AtlkCloseSocket (a : AtOpenSocket);                   EXTERN;

{
 name binding protocol
}
PROCEDURE AtlkRegisterName (a : AtRegisterName);                EXTERN;
PROCEDURE AtlkRemoveName (a : AtRegisterName);                  EXTERN;
PROCEDURE AtlkLookupName (a : AtLookupName);                    EXTERN;
PROCEDURE AtlkConfirmName (a : AtConfirmName);                  EXTERN;

{
 appletalk transaction protocol
}
PROCEDURE AtlkSendATPReq (a : AtSendATPReq);                    EXTERN;
PROCEDURE AtlkCancelATPReq (a : AtCancelATPReq);                EXTERN;
PROCEDURE AtlkOpenATPSocket (a : AtOpenATPSocket);              EXTERN;
PROCEDURE AtlkCloseATPSocket (a : AtOpenATPSocket);             EXTERN;
PROCEDURE AtlkGetATPReq (a : AtGetATPReq);                      EXTERN;
PROCEDURE AtlkSendATPResp (a : AtSendATPResp);                  EXTERN;
{
PROCEDURE AtlkAddATPResp not currently supported
}
PROCEDURE AtlkRelATPCB (a : AtRelATPCB);                        EXTERN;


{
 zone information protocol
}
PROCEDURE AtlkGetMyZone (a : AtGetMyZone);                      EXTERN;
PROCEDURE AtlkGetZoneList (a : AtGetZoneList);                  EXTERN;

implementation
end.
