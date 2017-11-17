000100000000     H DFTACTGRP(*NO) DATFMT(*ISO) OPTION(*SRCSTMT:*NODEBUGIO)
000200000000      *?---------------------------------------------------
000300000000      *?Files
000400000000      *?---------------------------------------------------
000500000000     FTESTD2    CF   E             WORKSTN INFDS(INFDS)
000600000000     F                                     SFILE(SFLRCD001:RRN1)
000700000000      *?---------------------------------------------------
000800000000      *? Prototypes for message handling
000900000000      *?---------------------------------------------------
001000000000     DSendMessage      PR                  ExtPgm('QMHSNDPM')
001100000000     D S_MessageID                         Like(MessageID)   Const
001200000000     D S_MessageFile                       Like(MessageFile) Const
001300000000     D S_MessageData                       Like(MessageData) Const
001400000000     D S_MessageLen                        Like(MessageLen)  Const
001500000000     D S_MessageType                       Like(MessageType) Const
001600000000     D S_CallStack                         Like(CallStack)   Const
001700000000     D S_CallStackC                        Like(CallStackC)  Const
001800000000     D S_MessageKey                        Like(MessageKey)
001900000000     D S_MessageErr                        Like(MessageErr)
002000000000      *?Remove program message API...
002100000000     DRemoveMessage    PR                  ExtPgm('QMHRMVPM')
002200000000     D R_CallStack                         Like(CallStack)  Const
002300000000     D R_CallStackC                        Like(CallStackC) Const
002400000000     D R_MessageKey                        Like(MessageKey) Const
002500000000     D R_RemoveCode                        Like(RemoveCode) Const
002600000000     D R_MessageErr                        Like(MessageErr)
002700000000      *?Message API Variables........
002800000000     D MessageID       S              7A   INZ
002900000000     D MessageType     S             10A   INZ('*INFO')
003000000000     D CallStack       S             10    INZ('*')
003100000000     D CallStackC      S             10i 0 INZ
003200000000     D MessageKey      S              4    INZ
003300000000     D RMessageKey     S              4    INZ
003400000000     D MessageErr      S            256    INZ VARYING
003500000000     D RemoveCode      S             10    INZ('*ALL')
003600000000     D MessageData     S             80    INZ
003700000000     D MessageLen      S             10i 0 INZ
003800000000     D MessageFile     S             20A   INZ('QCPFMSG   *LIBL  ')
003900000000     D ProgramQ        S             10A   INZ('TESTR2')
004000000000      *?---------------------------------------------------------
004100000000      *?Information DS
004200000000      *?---------------------------------------------------------
004300000000      * Indicators
004400000000     D PIndicators     S               *   Inz(%Addr(*In))
004500000000     D Indicators      DS                  Based(PIndicators)
004600000000     D  ExitKey                        N   Overlay(Indicators:03)
004700000000     D  PromptKey                      N   Overlay(Indicators:04)
004800000000     D  RefreshKey                     N   Overlay(Indicators:05)
004900000000     D  CancelKey                      N   Overlay(Indicators:12)
005000000000     D  ProcessKey                     N   Overlay(Indicators:10)
005100000000     D  DisplaySubfileRecord...
005200000000     D                                 N   Overlay(Indicators:40)
005300000000     D  DisplaySubfileControl...
005400000000     D                                 N   Overlay(Indicators:41)
005500000000     D  ClearSubfile                   N   Overlay(Indicators:42)
005600000000     D  InzSubfile                     N   Overlay(Indicators:43)
005700000000     D  EndSubfile                     N   Overlay(Indicators:44)
005800000000     D  SFLNextChange                  N   Overlay(Indicators:99)
005900000000     D  DropSubfile                    N   Overlay(Indicators:13)
006000000000     D  AddKey                         N   Overlay(Indicators:06)
006100000000     D
006200000000     D  ErrInRNAME                     N   Overlay(Indicators:61)
006300000000     D  ErrInRDESC                     N   Overlay(Indicators:62)
006400000000     D  ErrInRTYPE                     N   Overlay(Indicators:63)
006500000000      *?--------------------------------------------------
006600000000      *?Information DS
006700000000      *?--------------------------------------------------
006800000000     D Infds           DS
006900000000     D KeyPressed            369    369
007000000000      *?-------------------------------------------------------------
007100000000      *?  Main DS for SQL
007200000000      *?-------------------------------------------------------------
007300000000     DMainDS           DS                  Qualified INZ
007400000000     D RNAME                         10A
007500000000     D RDESC                         50A
007600000000     D RTYPE                         10A
007700000000      *?-------------------------------------------------------------
007800000000      *?  DS to track search field
007900000000      *?-------------------------------------------------------------
008000000000     DSearchDS         DS                  Qualified INZ
008100000000     D OLDRNAME                      10A
008200000000     D OLDRDESC                      50A
008300000000     D OLDRTYPE                      10A
008400000000      *?---------------------------------------------------
008500000000      *?Constants
008600000000      *?---------------------------------------------------
008700000000     D EnterKey        C                   CONST(x'F1')
008800000000     D PageUp          C                   CONST(X'F4')
008900000000     D PageDown        C                   CONST(X'F5')
009000000000     D Pressed         C                   CONST('1')
009100000000     D NotPressed      C                   CONST('0')
009200000000     D YES             C                   CONST('1')
009300000000     D NO              C                   CONST('0')
009400000000     D TRUE            C                   CONST('1')
009500000000     D FALSE           C                   CONST('0')
009600000000      *?---------------------------------------------------
009700000000      *? Standalons
009800000000      *?---------------------------------------------------
009900000000     D Error           S               N   INZ
010000000000     D ExitNow         S               N   INZ
010100000000     D Refresh         S               N   INZ
010200000000     D UpdateSubF      S               N   INZ
010300000000 ?    *
010400000000     D RRN1            S              4  0 INZ
010500000000     D SavedRRN        S              4  0 INZ(1)
010600000000 ?    *
010700000000     D SqlString       S           2000    Inz Varying
010800000000     D #Where          S            500    Inz Varying
010900000000     D #OrderBy        S            500    Inz Varying
011000000000     D #And            S              5    Inz
011100000000     D #Coma           S              3    Inz
011200000000     D SearchChanged   S               N   Inz
011300000000      *?---------------------------------------------------
011400000000      *?Main Logic
011500000000      *?---------------------------------------------------
011600000000      /Free
011700000000         Exec SQL
011800000000           Set Option  Commit = *NONE,  CLOSQLCSR = *ENDMOD,
011900000000            DATFMT    = *ISO;
012000000000         Refresh = YES;
012100000000         DoW ExitKey = NotPressed ;
012200000000           If Refresh = YES;
012300000000              ExSr InitilizeSubfile;
012400000000              ExSr LoadSubFile   ;
012500000000              Refresh = NO;
012600000000           EndIf ;
012700000000           ExSr DisplaySubFile ;
012800000000           ExSr CheckKeyPressed;
012900000000         EndDo;
013000000000         *InLR = *ON;
013100000000      /End-Free
013200000000      *?--------------?End Of Main Logic?----------------
013300000000      *?-------------------------------------------------------------
013400000000      *?  Declare Cursor
013500000000      *?-------------------------------------------------------------
013600000000      /Free
013700000000        BegSr DeclareCursor ;
013800000000              #Where  = *Blanks;
013900000000              #OrderBy= *Blanks;
014000000000              #And    = *Blanks;
014100000000              #Coma   = *Blanks;
014200000000              If %TRIM(S1RNAME)> *LOVAL;
014300000000                 #Where   = %Trim(#Where) +  #AND +'UPPER(RNAME)>=UPPER(''' +
014400000000                 %TRIM(S1RNAME)+''')';
014500000000                 #OrderBy =  %Trim(#OrderBy) + #COMA +'UPPER(RNAME)';
014600000000                 #And     = ' AND ' ;
014700000000                 #Coma    = ' , ';
014800000000              EndIf;
014900000000              If %TRIM(S1RDESC)> *LOVAL;
015000000000                 #Where   = %Trim(#Where) +  #AND +'UPPER(RDESC)>=UPPER(''' +
015100000000                 %TRIM(S1RDESC)+''')';
015200000000                 #OrderBy =  %Trim(#OrderBy) + #COMA +'UPPER(RDESC)';
015300000000                 #And     = ' AND ' ;
015400000000                 #Coma    = ' , ';
015500000000              EndIf;
015600000000              If %TRIM(S1RTYPE)> *LOVAL;
015700000000                 #Where   = %Trim(#Where) +  #AND +'UPPER(RTYPE)>=UPPER(''' +
015800000000                 %TRIM(S1RTYPE)+''')';
015900000000                 #OrderBy =  %Trim(#OrderBy) + #COMA +'UPPER(RTYPE)';
016000000000                 #And     = ' AND ' ;
016100000000                 #Coma    = ' , ';
016200000000              EndIf;
016300000000              //?Check WHERE and ORDER BY
016400000000              If #Where <> *Blanks;
016500000000                 #Where = 'Where '+ %Trim(#Where) ;
016600000000                 EndIf;
016700000000              If #OrderBy <> *Blanks;
016800000000                 #OrderBy = 'Order By '+ %Trim(#OrderBy) ;
016900000000              EndIf;
017000000000              //?Make final SQLString
017100000000              SQLString = 'SELECT * FROM SRCH  '+%Trim(#Where)+ '   ' +
017200000000              %Trim(#OrderBy);
017300000000              //?PREPARE and DECLARE CURSOR
017400000000              Exec SQL PREPARE SQLStmt from :SQLSTRING;
017500000000              Exec SQL DECLARE #Main Cursor for SQLStmt;
017600000000        EndSr;
017700000000      /End-Free
017800000000      *?---------------------------------------------------
017900000000      *?Initilize Subfile
018000000000      *?---------------------------------------------------
018100000000      /Free
018200000000         BegSr InitilizeSubfile;
018300000000             ExSr ResetCursor;
018400000000             EndSubfile            = NO;
018500000000             DisplaySubfileControl = NO;
018600000000             ClearSubfile          = YES;
018700000000              Write SFLCTL001    ;
018800000000             ClearSubfile          = NO ;
018900000000             RRN1=0;
019000000000         EndSr;
019100000000      /End-Free
019200000000      *?-------------------------------------------------------------
019300000000      *?  Reset Cursor
019400000000      *?-------------------------------------------------------------
019500000000      /Free
019600000000        BegSr ResetCursor ;
019700000000             Exec SQL  Close #MAIN;
019800000000                ExSr DeclareCursor;
019900000000             Exec SQL  Open  #MAIN;
020000000000        EndSr;
020100000000      /End-Free
020200000000      *?-------------------------------------------------------------
020300000000      *?  Load Subfile
020400000000      *?-------------------------------------------------------------
020500000000      /Free
020600000000        BegSr LoadSubfile ;
020700000000            SavedRRN    = RRN1 + 1;
020800000000            Exec SQL Fetch  #Main into :MainDS;
020900000000            DoW SQLCODE = 0;
021000000000              //? Maximum 9998 records allowed
021100000000              If RRN1>= 9998 ;
021200000000                Leave;
021300000000              EndIf;
021400000000              //?Move DB fields to Subfile
021500000000              ExSr MoveCorrsponding;
021600000000              RRN1 += 1 ;
021700000000              Write SFLRCD001     ;
021800000000              Exec SQL Fetch  #Main into :MainDS;
021900000000            EndDo;
022000000000            //? END LOOP
022100000000            //? Check If last record is alread read
022200000000            If SQLCODE = 100;
022300000000              EndSubfile  = YES;
022400000000            EndIf;
022500000000        EndSr;
022600000000      /End-Free
022700000000      *?-------------------------------------------------------------
022800000000      *?  Move Data from Table to SFL
022900000000      *?-------------------------------------------------------------
023000000000      /Free
023100000000        BegSr MoveCorrsponding ;
023200000000            DSFLOPTION  =  *LOVAL;
023300000000            DRNAME      =  MainDs.RNAME;
023400000000            DRDESC      =  MainDs.RDESC;
023500000000            DRTYPE      =  MainDs.RTYPE;
023600000000        EndSr;
023700000000      /End-Free
023800000000      *?---------------------------------------------------
023900000000      *?Display subfile
024000000000      *?---------------------------------------------------
024100000000      /Free
024200000000        BegSr DisplaySubfile;
024300000000           If RRN1 = 0 ;
024400000000              Write EmptySfl;
024500000000           Else;
024600000000              DisplaySubfileRecord = YES;
024700000000           EndIf;
024800000000           //? Check SavedRRN for Record to display
024900000000           Select;
025000000000              When SavedRRN > RRN1;
025100000000                   SavedRRN = RRN1;
025200000000              When SavedRRN = 0   ;
025300000000                   SavedRRN = 1   ;
025400000000           EndSL;
025500000000           DSPRCDNBR  = SavedRRN;
025600000000           DisplaySubfileControl = YES;
025700000000           Write HEADER;
025800000000           Write FOOTER;
025900000000           Write MSGCTL01    ;
026000000000           ExFmt SFLCTL001    ;
026100000000           ExSr  RemoveMessageFromProgramQ;
026200000000           DisplaySubfileControl = NO;
026300000000           DisplaySubfileRecord = NO;
026400000000        EndSr;
026500000000      /End-Free
026600000000      *?-------------------------------------------------------------
026700000000      *?  Check Key Pressed
026800000000      *?-------------------------------------------------------------
026900000000      /Free
027000000000        BegSr CheckKeyPressed ;
027100000000            Select;
027200000000                When  ExitKey = Pressed;
027300000000                      //?EXIT Program
027400000000                When  CancelKey = Pressed;
027500000000                      ExitKey = YES;
027600000000                When  RefreshKey = Pressed;
027700000000                      Refresh = YES;
027800000000                      ExSr ClearSearchValues;
027900000000                When  AddKey    = Pressed;
028000000000                      ExSR  DisplayAddScreen;
028100000000                Other ;
028200000000                      SearchChanged = NO;
028300000000                      If KeyPressed = EnterKey;
028400000000                         ExSr CheckSearchValues;
028500000000                      EndIf;
028600000000                      If SearchChanged = NO;
028700000000                         ExSR  ReadSubFile ;
028800000000                      Else ;
028900000000                         Refresh = YES;
029000000000                      EndIf;
029100000000            EndSl;
029200000000        EndSr;
029300000000      /End-Free
029400000000      *?-------------------------------------------------------------
029500000000      *?  Clear Search Fields
029600000000      *?-------------------------------------------------------------
029700000000      /Free
029800000000        BegSr ClearSearchValues ;
029900000000            Clear SearchDS;
030000000000            S1RNAME = *LOVAL;
030100000000            S1RDESC = *LOVAL;
030200000000            S1RTYPE = *LOVAL;
030300000000        EndSr;
030400000000      /End-Free
030500000000      *?-------------------------------------------------------------
030600000000      *?  Check if search is changed
030700000000      *?-------------------------------------------------------------
030800000000      /Free
030900000000        BegSr CheckSearchValues ;
031000000000            SearchChanged = ( SearchDS.OLDRNAME <> S1RNAME OR
031100000000                               SearchDS.OLDRDESC <> S1RDESC OR
031200000000                               SearchDS.OLDRTYPE <> S1RTYPE );
031300000000            If SearchChanged = YES;
031400000000               SearchDS.OLDRNAME = S1RNAME   ;
031500000000               SearchDS.OLDRDESC = S1RDESC   ;
031600000000               SearchDS.OLDRTYPE = S1RTYPE   ;
031700000000            EndIf;
031800000000        EndSr;
031900000000      /End-Free
032000000000      *?-------------------------------------------------------------
032100000000      *?  Read Subfile
032200000000      *?-------------------------------------------------------------
032300000000      /Free
032400000000        BegSr ReadSubFile ;
032500000000            If RRN1 <=0 ;
032600000000              LeaveSr;
032700000000            EndIf;
032800000000            ReadC SFLRCD001    ;
032900000000            DoW Not %EOF(TESTD2    );
033000000000              If DSFLOption <> *Blanks;
033100000000                 SavedRRN = RRN1;
033200000000              EndIf;
033300000000              Select;
033400000000                When  DSFLOption = 'X' And KeyPressed = EnterKey;
033500000000                      ExSR DisplayChangeScreen;
033600000000                When  DSFLOption = 'D' And KeyPressed = EnterKey;
033700000000                      ExSR DisplayDeleteScreen;
033800000000                When  DSFLOption = 'I' And KeyPressed = EnterKey;
033900000000                      ExSR DisplayInquiryScreen;
034000000000              EndSl;
034100000000              If UpdateSubF = YES;
034200000000                 SflNextChange = YES;
034300000000                 Update SFLRCD001    ;
034400000000                 SflNextChange = NO;
034500000000                 UpdateSubF    = NO;
034600000000              EndIf;
034700000000              ReadC SFLRCD001    ;
034800000000            EndDo;
034900000000        EndSr;
035000000000      /End-Free
035100000000      *?-------------------------------------------------------------
035200000000      *?  Clear Error Indicators
035300000000      *?-------------------------------------------------------------
035400000000      /Free
035500000000        BegSr ClearErrorIndicators ;
035600000000            Error           = FALSE;
035700000000            ErrInRNAME      = FALSE;
035800000000            ErrInRDESC      = FALSE;
035900000000            ErrInRTYPE      = FALSE;
036000000000        EndSr;
036100000000      /End-Free
036200000000      *?-------------------------------------------------------------
036300000000      *?  Display ADD Screen
036400000000      *?-------------------------------------------------------------
036500000000      /Free
036600000000        BegSr DisplayADDScreen ;
036700000000            ExSr ClearErrorIndicators;
036800000000            X1RNAME    = *LOVAL;
036900000000            X1RDESC    = *LOVAL;
037000000000            X1RTYPE    = *LOVAL;
037100000000            ExitNow = No;
037200000000          DoW ExitNow = No;
037300000000            Write HEADER;
037400000000            Write FOOTER2;
037500000000            Write MSGCTL01    ;
037600000000              ExFmt ADDRECORD;
037700000000            ExSr RemoveMessageFromProgramQ;
037800000000            ExSr CheckKeyPressed_ADDScreen;
037900000000          EndDo;
038000000000        EndSr;
038100000000      /End-Free
038200000000      *?-------------------------------------------------------------
038300000000      *?  Check Key Pressed on ADD screen
038400000000      *?-------------------------------------------------------------
038500000000      /Free
038600000000        BegSr CheckKeyPressed_ADDScreen ;
038700000000            Select;
038800000000                When  ExitKey = Pressed;
038900000000                      ExitNow = YES;
039000000000                When  CancelKey = Pressed;
039100000000                      ExitNow = YES;
039200000000                      CancelKey = YES;
039300000000                When  KeyPressed= EnterKey;
039400000000                      ExSr ValidateADDScreen;
039500000000                When  ProcessKey= Pressed;
039600000000                      ExSr ValidateADDScreen;
039700000000                      If Error = NO;
039800000000                        ExSr ADDRecordCode;
039900000000                        ExitNow = YES;
040000000000                      EndIf;
040100000000            EndSl;
040200000000        EndSr;
040300000000      /End-Free
040400000000      *?-------------------------------------------------------------
040500000000      *?  Validate Add Screen
040600000000      *?-------------------------------------------------------------
040700000000      /Free
040800000000        BegSr ValidateAddScreen ;
040900000000            ExSR ClearErrorIndicators;
041000000000            //?Add Field Level Validations START
041100000000            ErrInRNAME      = (X1RNAME = *LOVAL);
041200000000            ErrInRDESC      = (X1RDESC = *LOVAL);
041300000000            ErrInRTYPE      = (X1RTYPE = *LOVAL);
041400000000            //?Add Field Level Validations END
041500000000            If ErrINRNAME;
041600000000               Error = True;
041700000000               MessageID   = 'CPF9898';
041800000000               MessageData = 'Invalid RNAME';
041900000000               ExSr  SendMessageToProgramQ;
042000000000            EndIf;
042100000000            If ErrINRDESC;
042200000000               Error = True;
042300000000               MessageID   = 'CPF9898';
042400000000               MessageData = 'Invalid RDESC';
042500000000               ExSr  SendMessageToProgramQ;
042600000000            EndIf;
042700000000            If ErrINRTYPE;
042800000000               Error = True;
042900000000               MessageID   = 'CPF9898';
043000000000               MessageData = 'Invalid RTYPE';
043100000000               ExSr  SendMessageToProgramQ;
043200000000            EndIf;
043300000000        EndSr;
043400000000      /End-Free
043500000000      *?-------------------------------------------------------------
043600000000      *?  Add records to DB
043700000000      *?-------------------------------------------------------------
043800000000      /Free
043900000000        BegSr AddRecordCode ;
044000000000            Exec SQL
044100000000                Insert Into SRCH(
044200000000                          RNAME,
044300000000                          RDESC,
044400000000                          RTYPE) Values (
044500000000                          :X1RNAME,
044600000000                          :X1RDESC,
044700000000                          :X1RTYPE) ;
044800000000            Select;
044900000000               When SQLCODE < 0 ;
045000000000                    Error     = True;
045100000000                    MessageID ='CPF9898';
045200000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
045300000000                             :MessageData = MESSAGE_TEXT;
045400000000               Other;
045500000000                    MessageID   ='CPF9898';
045600000000                    MessageData = 'Record Added successfully';
045700000000                    Refresh = YES;
045800000000            EndSL;
045900000000            ExSr  SendMessageToProgramQ;
046000000000        EndSr;
046100000000      /End-Free
046200000000      *?-------------------------------------------------------------
046300000000      *?  Display CHANGE Screen
046400000000      *?-------------------------------------------------------------
046500000000      /Free
046600000000        BegSr DisplayCHANGEScreen ;
046700000000            ExSr ClearErrorIndicators;
046800000000            C1RNAME    = DRNAME;
046900000000            C1RDESC    = DRDESC;
047000000000            C1RTYPE    = DRTYPE;
047100000000            ExitNow = No;
047200000000          DoW ExitNow = No;
047300000000            Write HEADER;
047400000000            Write FOOTER2;
047500000000            Write MSGCTL01    ;
047600000000              ExFmt CHGRECORD;
047700000000            ExSr RemoveMessageFromProgramQ;
047800000000            ExSr CheckKeyPressed_CHANGEScreen;
047900000000          EndDo;
048000000000        EndSr;
048100000000      /End-Free
048200000000      *?-------------------------------------------------------------
048300000000      *?  Check Key Pressed on CHANGE screen
048400000000      *?-------------------------------------------------------------
048500000000      /Free
048600000000        BegSr CheckKeyPressed_CHANGEScreen ;
048700000000            Select;
048800000000                When  ExitKey = Pressed;
048900000000                      ExitNow = YES;
049000000000                When  CancelKey = Pressed;
049100000000                      ExitNow = YES;
049200000000                      CancelKey = YES;
049300000000                      UpdateSubF= YES;
049400000000                When  KeyPressed= EnterKey;
049500000000                      ExSr ValidateCHANGEScreen;
049600000000                When  ProcessKey= Pressed;
049700000000                      ExSr ValidateCHANGEScreen;
049800000000                      If Error = NO;
049900000000                        ExSr CHANGERecordCode;
050000000000                        ExitNow = YES;
050100000000                      EndIf;
050200000000            EndSl;
050300000000        EndSr;
050400000000      /End-Free
050500000000      *?-------------------------------------------------------------
050600000000      *?  Validate Change Screen
050700000000      *?-------------------------------------------------------------
050800000000      /Free
050900000000        BegSr ValidateChangeScreen ;
051000000000            ExSR ClearErrorIndicators;
051100000000            //?Add Field Level Validations START
051200000000            ErrInRNAME      = (C1RNAME = *LOVAL);
051300000000            ErrInRDESC      = (C1RDESC = *LOVAL);
051400000000            ErrInRTYPE      = (C1RTYPE = *LOVAL);
051500000000            //?Add Field Level Validations END
051600000000            If ErrINRNAME;
051700000000               Error = True;
051800000000               MessageID   = 'CPF9898';
051900000000               MessageData = 'Invalid RNAME';
052000000000               ExSr  SendMessageToProgramQ;
052100000000            EndIf;
052200000000            If ErrINRDESC;
052300000000               Error = True;
052400000000               MessageID   = 'CPF9898';
052500000000               MessageData = 'Invalid RDESC';
052600000000               ExSr  SendMessageToProgramQ;
052700000000            EndIf;
052800000000            If ErrINRTYPE;
052900000000               Error = True;
053000000000               MessageID   = 'CPF9898';
053100000000               MessageData = 'Invalid RTYPE';
053200000000               ExSr  SendMessageToProgramQ;
053300000000            EndIf;
053400000000        EndSr;
053500000000      /End-Free
053600000000      *?-------------------------------------------------------------
053700000000      *?  Change records to DB
053800000000      *?-------------------------------------------------------------
053900000000      /Free
054000000000        BegSr ChangeRecordCode ;
054100000000            Exec SQL
054200000000                Update SRCH SET
054300000000                          RNAME = :C1RNAME,
054400000000                          RDESC = :C1RDESC,
054500000000                          RTYPE = :C1RTYPE
054600000000                      Where (
054700000000                          RNAME = :DRNAME AND
054800000000                          RDESC = :DRDESC AND
054900000000                          RTYPE = :DRTYPE );
055000000000            Select;
055100000000               When SQLCODE < 0 ;
055200000000                    Error     = True;
055300000000                    MessageID ='CPF9898';
055400000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
055500000000                             :MessageData = MESSAGE_TEXT;
055600000000               When SQLCODE = 100 ;
055700000000                    Error     = True;
055800000000                    MessageID ='CPF9898';
055900000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
056000000000                             :MessageData = MESSAGE_TEXT;
056100000000               Other;
056200000000                    MessageID   ='CPF9898';
056300000000                    MessageData = 'Record Updated successfully';
056400000000                    Refresh = YES;
056500000000            EndSL;
056600000000            ExSr  SendMessageToProgramQ;
056700000000        EndSr;
056800000000      /End-Free
056900000000      *?-------------------------------------------------------------
057000000000      *?  Display DELETE Screen
057100000000      *?-------------------------------------------------------------
057200000000      /Free
057300000000        BegSr DisplayDELETEScreen ;
057400000000            ExSr ClearErrorIndicators;
057500000000            D1RNAME    = DRNAME;
057600000000            D1RDESC    = DRDESC;
057700000000            D1RTYPE    = DRTYPE;
057800000000            ExitNow = No;
057900000000          DoW ExitNow = No;
058000000000            Write HEADER;
058100000000            Write FOOTER2;
058200000000            Write MSGCTL01    ;
058300000000              ExFmt DLTRECORD;
058400000000            ExSr RemoveMessageFromProgramQ;
058500000000            ExSr CheckKeyPressed_DELETEScreen;
058600000000          EndDo;
058700000000        EndSr;
058800000000      /End-Free
058900000000      *?-------------------------------------------------------------
059000000000      *?  Check Key Pressed on DELETE screen
059100000000      *?-------------------------------------------------------------
059200000000      /Free
059300000000        BegSr CheckKeyPressed_DELETEScreen ;
059400000000            Select;
059500000000                When  ExitKey = Pressed;
059600000000                      ExitNow = YES;
059700000000                When  CancelKey = Pressed;
059800000000                      ExitNow = YES;
059900000000                      CancelKey = YES;
060000000000                      UpdateSubF= YES;
060100000000                When  KeyPressed= EnterKey;
060200000000                      ExSr ValidateDELETEScreen;
060300000000                When  ProcessKey= Pressed;
060400000000                      ExSr ValidateDELETEScreen;
060500000000                      If Error = NO;
060600000000                        ExSr DELETERecordCode;
060700000000                        ExitNow = YES;
060800000000                      EndIf;
060900000000            EndSl;
061000000000        EndSr;
061100000000      /End-Free
061200000000      *?-------------------------------------------------------------
061300000000      *?  Validate Delete Screen
061400000000      *?-------------------------------------------------------------
061500000000      /Free
061600000000        BegSr ValidateDeleteScreen ;
061700000000            ExSR ClearErrorIndicators;
061800000000            //?Add Field Level Validations START
061900000000            //?Add Field Level Validations END
062000000000        EndSr;
062100000000      /End-Free
062200000000      *?-------------------------------------------------------------
062300000000      *?  Delete Record from DB
062400000000      *?-------------------------------------------------------------
062500000000      /Free
062600000000        BegSr DeleteRecordCode ;
062700000000            Exec SQL
062800000000                DELETE FROM SRCH WHERE(
062900000000                          RNAME = :DRNAME AND
063000000000                          RDESC = :DRDESC AND
063100000000                          RTYPE = :DRTYPE );
063200000000            Select;
063300000000               When SQLCODE < 0 ;
063400000000                    Error     = True;
063500000000                    MessageID ='CPF9898';
063600000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
063700000000                             :MessageData = MESSAGE_TEXT;
063800000000               Other;
063900000000                    MessageID   ='CPF9898';
064000000000                    MessageData = 'Record Deleted successfully';
064100000000                    Refresh = YES;
064200000000            EndSL;
064300000000            ExSr  SendMessageToProgramQ;
064400000000        EndSr;
064500000000      /End-Free
064600000000      *?-------------------------------------------------------------
064700000000      *?  Display INQUIRY Screen
064800000000      *?-------------------------------------------------------------
064900000000      /Free
065000000000        BegSr DisplayINQUIRYScreen ;
065100000000            I1RNAME    = DRNAME;
065200000000            I1RDESC    = DRDESC;
065300000000            I1RTYPE    = DRTYPE;
065400000000            ExitNow = No;
065500000000          DoW ExitNow = No;
065600000000            Write HEADER;
065700000000            Write FOOTER3;
065800000000            Write MSGCTL01    ;
065900000000              ExFmt INQRECORD;
066000000000            ExSr RemoveMessageFromProgramQ;
066100000000            ExSr CheckKeyPressed_INQUIRYScreen;
066200000000          EndDo;
066300000000        EndSr;
066400000000      /End-Free
066500000000      *?-------------------------------------------------------------
066600000000      *?  Check Key Pressed on INQUIRY screen
066700000000      *?-------------------------------------------------------------
066800000000      /Free
066900000000        BegSr CheckKeyPressed_INQUIRYScreen ;
067000000000            Select;
067100000000                When  ExitKey = Pressed;
067200000000                      ExitNow = YES;
067300000000                When  CancelKey = Pressed;
067400000000                      ExitNow = YES;
067500000000                      CancelKey = YES;
067600000000                When  KeyPressed= EnterKey;
067700000000                      ExitNow = YES;
067800000000            EndSl;
067900000000        EndSr;
068000000000      /End-Free
068100000000      *?---------------------------------------------------
068200000000      *?Send message to program Q
068300000000      *?---------------------------------------------------
068400000000      /Free
068500000000        BegSr SendMessageToProgramQ;
068600000000           MessageLen = %Len(%Trim(MessageData));
068700000000           CallP  SendMessage(MessageID
068800000000                              :MessageFile
068900000000                              :MessageData
069000000000                              :MessageLen
069100000000                              :MessageType
069200000000                              :CallStack
069300000000                              :CallStackC
069400000000                              :MessageKey
069500000000                              :MessageErr);
069600000000           MessageID   = '';
069700000000           MessageData = '';
069800000000        EndSr;
069900000000      /End-Free
070000000000      *?---------------------------------------------------
070100000000      *?Remove message from program Q
070200000000      *?---------------------------------------------------
070300000000      /Free
070400000000        BegSr RemoveMessageFromProgramQ;
070500000000           CallP  RemoveMessage(CallStack
070600000000                                :CallStackC
070700000000                                :RMessageKey
070800000000                                :RemoveCode
070900000000                                :MessageErr);
071000000000        EndSr;
071100000000      /End-Free
