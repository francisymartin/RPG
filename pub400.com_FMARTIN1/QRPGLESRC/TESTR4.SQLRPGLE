000100000000     H DFTACTGRP(*NO) DATFMT(*ISO) OPTION(*SRCSTMT:*NODEBUGIO)
000200000000      *?---------------------------------------------------
000300000000      *?Files
000400000000      *?---------------------------------------------------
000500000000     FTESTD4    CF   E             WORKSTN INFDS(INFDS)
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
003900000000     D ProgramQ        S             10A   INZ('TESTR4')
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
010600000000     D PageSize        C                   11
010700000000     D ReloadData      S               N   INZ
010800000000     D MoveBy          S             10I 0 INZ
010900000000 ?    *
011000000000     D SqlString       S           2000    Inz Varying
011100000000     D #Where          S            500    Inz Varying
011200000000     D #OrderBy        S            500    Inz Varying
011300000000     D #And            S              5    Inz
011400000000     D #Coma           S              3    Inz
011500000000     D SearchChanged   S               N   Inz
011600000000      *?---------------------------------------------------
011700000000      *?Main Logic
011800000000      *?---------------------------------------------------
011900000000      /Free
012000000000         Exec SQL
012100000000           Set Option  Commit = *NONE,  CLOSQLCSR = *ENDMOD,
012200000000            DATFMT    = *ISO;
012300000000         ReloadData = YES;
012400000000         Refresh = YES;
012500000000         DoW ExitKey = NotPressed ;
012600000000           If Refresh = YES or ReloadData = YES ;
012700000000              ExSr InitilizeSubfile;
012800000000              ExSr LoadSubFile   ;
012900000000              Refresh = NO;
013000000000              ReloadData = NO;
013100000000           EndIf ;
013200000000           ExSr DisplaySubFile ;
013300000000           ExSr CheckKeyPressed;
013400000000         EndDo;
013500000000         *InLR = *ON;
013600000000      /End-Free
013700000000      *?--------------?End Of Main Logic?----------------
013800000000      *?-------------------------------------------------------------
013900000000      *?  Declare Cursor
014000000000      *?-------------------------------------------------------------
014100000000      /Free
014200000000        BegSr DeclareCursor ;
014300000000              #Where  = *Blanks;
014400000000              #OrderBy= *Blanks;
014500000000              #And    = *Blanks;
014600000000              #Coma   = *Blanks;
014700000000              If %TRIM(S1RNAME)> *LOVAL;
014800000000                 #Where   = %Trim(#Where) +  #AND +'UPPER(RNAME)>=UPPER(''' +
014900000000                 %TRIM(S1RNAME)+''')';
015000000000                 #OrderBy =  %Trim(#OrderBy) + #COMA +'UPPER(RNAME)';
015100000000                 #And     = ' AND ' ;
015200000000                 #Coma    = ' , ';
015300000000              EndIf;
015400000000              If %TRIM(S1RDESC)> *LOVAL;
015500000000                 #Where   = %Trim(#Where) +  #AND +'UPPER(RDESC)>=UPPER(''' +
015600000000                 %TRIM(S1RDESC)+''')';
015700000000                 #OrderBy =  %Trim(#OrderBy) + #COMA +'UPPER(RDESC)';
015800000000                 #And     = ' AND ' ;
015900000000                 #Coma    = ' , ';
016000000000              EndIf;
016100000000              If %TRIM(S1RTYPE)> *LOVAL;
016200000000                 #Where   = %Trim(#Where) +  #AND +'UPPER(RTYPE)>=UPPER(''' +
016300000000                 %TRIM(S1RTYPE)+''')';
016400000000                 #OrderBy =  %Trim(#OrderBy) + #COMA +'UPPER(RTYPE)';
016500000000                 #And     = ' AND ' ;
016600000000                 #Coma    = ' , ';
016700000000              EndIf;
016800000000              //?Check WHERE and ORDER BY
016900000000              If #Where <> *Blanks;
017000000000                 #Where = 'Where '+ %Trim(#Where) ;
017100000000                 EndIf;
017200000000              If #OrderBy <> *Blanks;
017300000000                 #OrderBy = 'Order By '+ %Trim(#OrderBy) ;
017400000000              EndIf;
017500000000              //?Make final SQLString
017600000000              SQLString = 'SELECT * FROM SRCH  '+%Trim(#Where)+ '   ' +
017700000000              %Trim(#OrderBy);
017800000000              //?PREPARE and DECLARE CURSOR
017900000000              Exec SQL PREPARE SQLStmt from :SQLSTRING;
018000000000              Exec SQL DECLARE #Main Dynamic Scroll Cursor for SQLStmt;
018100000000        EndSr;
018200000000      /End-Free
018300000000      *?---------------------------------------------------
018400000000      *?Initilize Subfile
018500000000      *?---------------------------------------------------
018600000000      /Free
018700000000         BegSr InitilizeSubfile;
018800000000             ExSr ResetCursor;
018900000000             EndSubfile            = NO;
019000000000             DisplaySubfileControl = NO;
019100000000             ClearSubfile          = YES;
019200000000              Write SFLCTL001    ;
019300000000             ClearSubfile          = NO ;
019400000000             RRN1=0;
019500000000         EndSr;
019600000000      /End-Free
019700000000      *?-------------------------------------------------------------
019800000000      *?  Reset Cursor
019900000000      *?-------------------------------------------------------------
020000000000      /Free
020100000000        BegSr ResetCursor ;
020200000000             If Refresh <> Yes;
020300000000                LeaveSr;
020400000000             EndIf;
020500000000             Exec SQL  Close #MAIN;
020600000000                ExSr DeclareCursor;
020700000000             Exec SQL  Open  #MAIN;
020800000000        EndSr;
020900000000      /End-Free
021000000000      *?-------------------------------------------------------------
021100000000      *?  Load Subfile
021200000000      *?-------------------------------------------------------------
021300000000      /Free
021400000000        BegSr LoadSubfile ;
021500000000            SavedRRN    = RRN1 + 1;
021600000000            Exec SQL Fetch  #Main into :MainDS;
021700000000            DoW SQLCODE = 0;
021800000000              ExSr MoveCorrsponding;
021900000000              RRN1 += 1 ;
022000000000              Write SFLRCD001     ;
022100000000              //? Load only 1 page at a time
022200000000              If RRN1>= PageSize ;
022300000000                Leave;
022400000000              EndIf;
022500000000              Exec SQL Fetch  #Main into :MainDS;
022600000000            EndDo;
022700000000            //? END LOOP
022800000000            //? Check If last record is alread read
022900000000            If SQLCODE = 100;
023000000000              EndSubfile  = YES;
023100000000            Else;
023200000000              Exec SQL Fetch  #Main into :MainDS;
023300000000              If SQLCODE = 100;
023400000000                EndSubfile  = YES;
023500000000              EndIf;
023600000000              Exec SQL Fetch Relative -1 FROM #Main into :MainDS;
023700000000            EndIf;
023800000000        EndSr;
023900000000      /End-Free
024000000000      *?-------------------------------------------------------------
024100000000      *?  Move Data from Table to SFL
024200000000      *?-------------------------------------------------------------
024300000000      /Free
024400000000        BegSr MoveCorrsponding ;
024500000000            DSFLOPTION  =  *LOVAL;
024600000000            DRNAME      =  MainDs.RNAME;
024700000000            DRDESC      =  MainDs.RDESC;
024800000000            DRTYPE      =  MainDs.RTYPE;
024900000000        EndSr;
025000000000      /End-Free
025100000000      *?---------------------------------------------------
025200000000      *?Display subfile
025300000000      *?---------------------------------------------------
025400000000      /Free
025500000000        BegSr DisplaySubfile;
025600000000           If RRN1 = 0 ;
025700000000              Write EmptySfl;
025800000000           Else;
025900000000              DisplaySubfileRecord = YES;
026000000000           EndIf;
026100000000           //? Check SavedRRN for Record to display
026200000000           Select;
026300000000              When SavedRRN > RRN1;
026400000000                   SavedRRN = RRN1;
026500000000              When SavedRRN = 0   ;
026600000000                   SavedRRN = 1   ;
026700000000           EndSL;
026800000000           DSPRCDNBR  = SavedRRN;
026900000000           DisplaySubfileControl = YES;
027000000000           Write HEADER;
027100000000           Write FOOTER;
027200000000           Write MSGCTL01    ;
027300000000           ExFmt SFLCTL001    ;
027400000000           ExSr  RemoveMessageFromProgramQ;
027500000000           DisplaySubfileControl = NO;
027600000000           DisplaySubfileRecord = NO;
027700000000        EndSr;
027800000000      /End-Free
027900000000      *?-------------------------------------------------------------
028000000000      *?  Check Key Pressed
028100000000      *?-------------------------------------------------------------
028200000000      /Free
028300000000        BegSr CheckKeyPressed ;
028400000000            Select;
028500000000                When  ExitKey = Pressed;
028600000000                      //?EXIT Program
028700000000                When  CancelKey = Pressed;
028800000000                      ExitKey = YES;
028900000000                When  RefreshKey = Pressed;
029000000000                      Refresh = YES;
029100000000                      ExSr ClearSearchValues;
029200000000                When  KeyPressed= PageUp;
029300000000                      ReloadData = YES;
029400000000                      MoveBy    = -1 * (RRN1 + PageSize + 1);
029500000000                      Exec SQL Fetch Relative :MoveBy FROM #Main into :MainDS;
029600000000                When  KeyPressed= PageDown;
029700000000                      If EndSubfile = NO;
029800000000                         ReloadData = YES;
029900000000                      EndIf;
030000000000                When  AddKey    = Pressed;
030100000000                      ExSR  DisplayAddScreen;
030200000000                Other ;
030300000000                      SearchChanged = NO;
030400000000                      If KeyPressed = EnterKey;
030500000000                         ExSr CheckSearchValues;
030600000000                      EndIf;
030700000000                      If SearchChanged = NO;
030800000000                         ExSR  ReadSubFile ;
030900000000                      Else ;
031000000000                         Refresh = YES;
031100000000                      EndIf;
031200000000            EndSl;
031300000000        EndSr;
031400000000      /End-Free
031500000000      *?-------------------------------------------------------------
031600000000      *?  Clear Search Fields
031700000000      *?-------------------------------------------------------------
031800000000      /Free
031900000000        BegSr ClearSearchValues ;
032000000000            Clear SearchDS;
032100000000            S1RNAME = *LOVAL;
032200000000            S1RDESC = *LOVAL;
032300000000            S1RTYPE = *LOVAL;
032400000000        EndSr;
032500000000      /End-Free
032600000000      *?-------------------------------------------------------------
032700000000      *?  Check if search is changed
032800000000      *?-------------------------------------------------------------
032900000000      /Free
033000000000        BegSr CheckSearchValues ;
033100000000            SearchChanged = ( SearchDS.OLDRNAME <> S1RNAME OR
033200000000                               SearchDS.OLDRDESC <> S1RDESC OR
033300000000                               SearchDS.OLDRTYPE <> S1RTYPE );
033400000000            If SearchChanged = YES;
033500000000               SearchDS.OLDRNAME = S1RNAME   ;
033600000000               SearchDS.OLDRDESC = S1RDESC   ;
033700000000               SearchDS.OLDRTYPE = S1RTYPE   ;
033800000000            EndIf;
033900000000        EndSr;
034000000000      /End-Free
034100000000      *?-------------------------------------------------------------
034200000000      *?  Read Subfile
034300000000      *?-------------------------------------------------------------
034400000000      /Free
034500000000        BegSr ReadSubFile ;
034600000000            If RRN1 <=0 ;
034700000000              LeaveSr;
034800000000            EndIf;
034900000000            ReadC SFLRCD001    ;
035000000000            DoW Not %EOF(TESTD4    );
035100000000              If DSFLOption <> *Blanks;
035200000000                 SavedRRN = RRN1;
035300000000              EndIf;
035400000000              Select;
035500000000                When  DSFLOption = 'X' And KeyPressed = EnterKey;
035600000000                      ExSR DisplayChangeScreen;
035700000000                When  DSFLOption = 'D' And KeyPressed = EnterKey;
035800000000                      ExSR DisplayDeleteScreen;
035900000000                When  DSFLOption = 'I' And KeyPressed = EnterKey;
036000000000                      ExSR DisplayInquiryScreen;
036100000000              EndSl;
036200000000              If UpdateSubF = YES;
036300000000                 SflNextChange = YES;
036400000000                 Update SFLRCD001    ;
036500000000                 SflNextChange = NO;
036600000000                 UpdateSubF    = NO;
036700000000              EndIf;
036800000000              ReadC SFLRCD001    ;
036900000000            EndDo;
037000000000        EndSr;
037100000000      /End-Free
037200000000      *?-------------------------------------------------------------
037300000000      *?  Clear Error Indicators
037400000000      *?-------------------------------------------------------------
037500000000      /Free
037600000000        BegSr ClearErrorIndicators ;
037700000000            Error           = FALSE;
037800000000            ErrInRNAME      = FALSE;
037900000000            ErrInRDESC      = FALSE;
038000000000            ErrInRTYPE      = FALSE;
038100000000        EndSr;
038200000000      /End-Free
038300000000      *?-------------------------------------------------------------
038400000000      *?  Display ADD Screen
038500000000      *?-------------------------------------------------------------
038600000000      /Free
038700000000        BegSr DisplayADDScreen ;
038800000000            ExSr ClearErrorIndicators;
038900000000            X1RNAME    = *LOVAL;
039000000000            X1RDESC    = *LOVAL;
039100000000            X1RTYPE    = *LOVAL;
039200000000            ExitNow = No;
039300000000          DoW ExitNow = No;
039400000000            Write HEADER;
039500000000            Write FOOTER2;
039600000000            Write MSGCTL01    ;
039700000000              ExFmt ADDRECORD;
039800000000            ExSr RemoveMessageFromProgramQ;
039900000000            ExSr CheckKeyPressed_ADDScreen;
040000000000          EndDo;
040100000000        EndSr;
040200000000      /End-Free
040300000000      *?-------------------------------------------------------------
040400000000      *?  Check Key Pressed on ADD screen
040500000000      *?-------------------------------------------------------------
040600000000      /Free
040700000000        BegSr CheckKeyPressed_ADDScreen ;
040800000000            Select;
040900000000                When  ExitKey = Pressed;
041000000000                      ExitNow = YES;
041100000000                When  CancelKey = Pressed;
041200000000                      ExitNow = YES;
041300000000                      CancelKey = YES;
041400000000                When  KeyPressed= EnterKey;
041500000000                      ExSr ValidateADDScreen;
041600000000                When  ProcessKey= Pressed;
041700000000                      ExSr ValidateADDScreen;
041800000000                      If Error = NO;
041900000000                        ExSr ADDRecordCode;
042000000000                        ExitNow = YES;
042100000000                      EndIf;
042200000000            EndSl;
042300000000        EndSr;
042400000000      /End-Free
042500000000      *?-------------------------------------------------------------
042600000000      *?  Validate Add Screen
042700000000      *?-------------------------------------------------------------
042800000000      /Free
042900000000        BegSr ValidateAddScreen ;
043000000000            ExSR ClearErrorIndicators;
043100000000            //?Add Field Level Validations START
043200000000            ErrInRNAME      = (X1RNAME = *LOVAL);
043300000000            ErrInRDESC      = (X1RDESC = *LOVAL);
043400000000            ErrInRTYPE      = (X1RTYPE = *LOVAL);
043500000000            //?Add Field Level Validations END
043600000000            If ErrINRNAME;
043700000000               Error = True;
043800000000               MessageID   = 'CPF9898';
043900000000               MessageData = 'Invalid RNAME';
044000000000               ExSr  SendMessageToProgramQ;
044100000000            EndIf;
044200000000            If ErrINRDESC;
044300000000               Error = True;
044400000000               MessageID   = 'CPF9898';
044500000000               MessageData = 'Invalid RDESC';
044600000000               ExSr  SendMessageToProgramQ;
044700000000            EndIf;
044800000000            If ErrINRTYPE;
044900000000               Error = True;
045000000000               MessageID   = 'CPF9898';
045100000000               MessageData = 'Invalid RTYPE';
045200000000               ExSr  SendMessageToProgramQ;
045300000000            EndIf;
045400000000        EndSr;
045500000000      /End-Free
045600000000      *?-------------------------------------------------------------
045700000000      *?  Add records to DB
045800000000      *?-------------------------------------------------------------
045900000000      /Free
046000000000        BegSr AddRecordCode ;
046100000000            Exec SQL
046200000000                Insert Into SRCH(
046300000000                          RNAME,
046400000000                          RDESC,
046500000000                          RTYPE) Values (
046600000000                          :X1RNAME,
046700000000                          :X1RDESC,
046800000000                          :X1RTYPE) ;
046900000000            Select;
047000000000               When SQLCODE < 0 ;
047100000000                    Error     = True;
047200000000                    MessageID ='CPF9898';
047300000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
047400000000                             :MessageData = MESSAGE_TEXT;
047500000000               Other;
047600000000                    MessageID   ='CPF9898';
047700000000                    MessageData = 'Record Added successfully';
047800000000                    Refresh = YES;
047900000000                    Exec SQL  Close #MAIN;
048000000000                    Exec SQL  Open  #MAIN;
048100000000            EndSL;
048200000000            ExSr  SendMessageToProgramQ;
048300000000        EndSr;
048400000000      /End-Free
048500000000      *?-------------------------------------------------------------
048600000000      *?  Display CHANGE Screen
048700000000      *?-------------------------------------------------------------
048800000000      /Free
048900000000        BegSr DisplayCHANGEScreen ;
049000000000            ExSr ClearErrorIndicators;
049100000000            C1RNAME    = DRNAME;
049200000000            C1RDESC    = DRDESC;
049300000000            C1RTYPE    = DRTYPE;
049400000000            ExitNow = No;
049500000000          DoW ExitNow = No;
049600000000            Write HEADER;
049700000000            Write FOOTER2;
049800000000            Write MSGCTL01    ;
049900000000              ExFmt CHGRECORD;
050000000000            ExSr RemoveMessageFromProgramQ;
050100000000            ExSr CheckKeyPressed_CHANGEScreen;
050200000000          EndDo;
050300000000        EndSr;
050400000000      /End-Free
050500000000      *?-------------------------------------------------------------
050600000000      *?  Check Key Pressed on CHANGE screen
050700000000      *?-------------------------------------------------------------
050800000000      /Free
050900000000        BegSr CheckKeyPressed_CHANGEScreen ;
051000000000            Select;
051100000000                When  ExitKey = Pressed;
051200000000                      ExitNow = YES;
051300000000                When  CancelKey = Pressed;
051400000000                      ExitNow = YES;
051500000000                      CancelKey = YES;
051600000000                      UpdateSubF= YES;
051700000000                When  KeyPressed= EnterKey;
051800000000                      ExSr ValidateCHANGEScreen;
051900000000                When  ProcessKey= Pressed;
052000000000                      ExSr ValidateCHANGEScreen;
052100000000                      If Error = NO;
052200000000                        ExSr CHANGERecordCode;
052300000000                        ExitNow = YES;
052400000000                      EndIf;
052500000000            EndSl;
052600000000        EndSr;
052700000000      /End-Free
052800000000      *?-------------------------------------------------------------
052900000000      *?  Validate Change Screen
053000000000      *?-------------------------------------------------------------
053100000000      /Free
053200000000        BegSr ValidateChangeScreen ;
053300000000            ExSR ClearErrorIndicators;
053400000000            //?Add Field Level Validations START
053500000000            ErrInRNAME      = (C1RNAME = *LOVAL);
053600000000            ErrInRDESC      = (C1RDESC = *LOVAL);
053700000000            ErrInRTYPE      = (C1RTYPE = *LOVAL);
053800000000            //?Add Field Level Validations END
053900000000            If ErrINRNAME;
054000000000               Error = True;
054100000000               MessageID   = 'CPF9898';
054200000000               MessageData = 'Invalid RNAME';
054300000000               ExSr  SendMessageToProgramQ;
054400000000            EndIf;
054500000000            If ErrINRDESC;
054600000000               Error = True;
054700000000               MessageID   = 'CPF9898';
054800000000               MessageData = 'Invalid RDESC';
054900000000               ExSr  SendMessageToProgramQ;
055000000000            EndIf;
055100000000            If ErrINRTYPE;
055200000000               Error = True;
055300000000               MessageID   = 'CPF9898';
055400000000               MessageData = 'Invalid RTYPE';
055500000000               ExSr  SendMessageToProgramQ;
055600000000            EndIf;
055700000000        EndSr;
055800000000      /End-Free
055900000000      *?-------------------------------------------------------------
056000000000      *?  Change records to DB
056100000000      *?-------------------------------------------------------------
056200000000      /Free
056300000000        BegSr ChangeRecordCode ;
056400000000            Exec SQL
056500000000                Update SRCH SET
056600000000                          RNAME = :C1RNAME,
056700000000                          RDESC = :C1RDESC,
056800000000                          RTYPE = :C1RTYPE
056900000000                      Where (
057000000000                          RNAME = :DRNAME AND
057100000000                          RDESC = :DRDESC AND
057200000000                          RTYPE = :DRTYPE );
057300000000            Select;
057400000000               When SQLCODE < 0 ;
057500000000                    Error     = True;
057600000000                    MessageID ='CPF9898';
057700000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
057800000000                             :MessageData = MESSAGE_TEXT;
057900000000               When SQLCODE = 100 ;
058000000000                    Error     = True;
058100000000                    MessageID ='CPF9898';
058200000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
058300000000                             :MessageData = MESSAGE_TEXT;
058400000000               Other;
058500000000                    MessageID   ='CPF9898';
058600000000                    MessageData = 'Record Updated successfully';
058700000000                    Refresh = YES;
058800000000                    Exec SQL  Close #MAIN;
058900000000                    Exec SQL  Open  #MAIN;
059000000000            EndSL;
059100000000            ExSr  SendMessageToProgramQ;
059200000000        EndSr;
059300000000      /End-Free
059400000000      *?-------------------------------------------------------------
059500000000      *?  Display DELETE Screen
059600000000      *?-------------------------------------------------------------
059700000000      /Free
059800000000        BegSr DisplayDELETEScreen ;
059900000000            ExSr ClearErrorIndicators;
060000000000            D1RNAME    = DRNAME;
060100000000            D1RDESC    = DRDESC;
060200000000            D1RTYPE    = DRTYPE;
060300000000            ExitNow = No;
060400000000          DoW ExitNow = No;
060500000000            Write HEADER;
060600000000            Write FOOTER2;
060700000000            Write MSGCTL01    ;
060800000000              ExFmt DLTRECORD;
060900000000            ExSr RemoveMessageFromProgramQ;
061000000000            ExSr CheckKeyPressed_DELETEScreen;
061100000000          EndDo;
061200000000        EndSr;
061300000000      /End-Free
061400000000      *?-------------------------------------------------------------
061500000000      *?  Check Key Pressed on DELETE screen
061600000000      *?-------------------------------------------------------------
061700000000      /Free
061800000000        BegSr CheckKeyPressed_DELETEScreen ;
061900000000            Select;
062000000000                When  ExitKey = Pressed;
062100000000                      ExitNow = YES;
062200000000                When  CancelKey = Pressed;
062300000000                      ExitNow = YES;
062400000000                      CancelKey = YES;
062500000000                      UpdateSubF= YES;
062600000000                When  KeyPressed= EnterKey;
062700000000                      ExSr ValidateDELETEScreen;
062800000000                When  ProcessKey= Pressed;
062900000000                      ExSr ValidateDELETEScreen;
063000000000                      If Error = NO;
063100000000                        ExSr DELETERecordCode;
063200000000                        ExitNow = YES;
063300000000                      EndIf;
063400000000            EndSl;
063500000000        EndSr;
063600000000      /End-Free
063700000000      *?-------------------------------------------------------------
063800000000      *?  Validate Delete Screen
063900000000      *?-------------------------------------------------------------
064000000000      /Free
064100000000        BegSr ValidateDeleteScreen ;
064200000000            ExSR ClearErrorIndicators;
064300000000            //?Add Field Level Validations START
064400000000            //?Add Field Level Validations END
064500000000        EndSr;
064600000000      /End-Free
064700000000      *?-------------------------------------------------------------
064800000000      *?  Delete Record from DB
064900000000      *?-------------------------------------------------------------
065000000000      /Free
065100000000        BegSr DeleteRecordCode ;
065200000000            Exec SQL
065300000000                DELETE FROM SRCH WHERE(
065400000000                          RNAME = :DRNAME AND
065500000000                          RDESC = :DRDESC AND
065600000000                          RTYPE = :DRTYPE );
065700000000            Select;
065800000000               When SQLCODE < 0 ;
065900000000                    Error     = True;
066000000000                    MessageID ='CPF9898';
066100000000                    Exec SQL GET DIAGNOSTICS EXCEPTION 1
066200000000                             :MessageData = MESSAGE_TEXT;
066300000000               Other;
066400000000                    MessageID   ='CPF9898';
066500000000                    MessageData = 'Record Deleted successfully';
066600000000                    Refresh = YES;
066700000000                    Exec SQL  Close #MAIN;
066800000000                    Exec SQL  Open  #MAIN;
066900000000            EndSL;
067000000000            ExSr  SendMessageToProgramQ;
067100000000        EndSr;
067200000000      /End-Free
067300000000      *?-------------------------------------------------------------
067400000000      *?  Display INQUIRY Screen
067500000000      *?-------------------------------------------------------------
067600000000      /Free
067700000000        BegSr DisplayINQUIRYScreen ;
067800000000            I1RNAME    = DRNAME;
067900000000            I1RDESC    = DRDESC;
068000000000            I1RTYPE    = DRTYPE;
068100000000            ExitNow = No;
068200000000          DoW ExitNow = No;
068300000000            Write HEADER;
068400000000            Write FOOTER3;
068500000000            Write MSGCTL01    ;
068600000000              ExFmt INQRECORD;
068700000000            ExSr RemoveMessageFromProgramQ;
068800000000            ExSr CheckKeyPressed_INQUIRYScreen;
068900000000          EndDo;
069000000000        EndSr;
069100000000      /End-Free
069200000000      *?-------------------------------------------------------------
069300000000      *?  Check Key Pressed on INQUIRY screen
069400000000      *?-------------------------------------------------------------
069500000000      /Free
069600000000        BegSr CheckKeyPressed_INQUIRYScreen ;
069700000000            Select;
069800000000                When  ExitKey = Pressed;
069900000000                      ExitNow = YES;
070000000000                When  CancelKey = Pressed;
070100000000                      ExitNow = YES;
070200000000                      CancelKey = YES;
070300000000                When  KeyPressed= EnterKey;
070400000000                      ExitNow = YES;
070500000000            EndSl;
070600000000        EndSr;
070700000000      /End-Free
070800000000      *?---------------------------------------------------
070900000000      *?Send message to program Q
071000000000      *?---------------------------------------------------
071100000000      /Free
071200000000        BegSr SendMessageToProgramQ;
071300000000           MessageLen = %Len(%Trim(MessageData));
071400000000           CallP  SendMessage(MessageID
071500000000                              :MessageFile
071600000000                              :MessageData
071700000000                              :MessageLen
071800000000                              :MessageType
071900000000                              :CallStack
072000000000                              :CallStackC
072100000000                              :MessageKey
072200000000                              :MessageErr);
072300000000           MessageID   = '';
072400000000           MessageData = '';
072500000000        EndSr;
072600000000      /End-Free
072700000000      *?---------------------------------------------------
072800000000      *?Remove message from program Q
072900000000      *?---------------------------------------------------
073000000000      /Free
073100000000        BegSr RemoveMessageFromProgramQ;
073200000000           CallP  RemoveMessage(CallStack
073300000000                                :CallStackC
073400000000                                :RMessageKey
073500000000                                :RemoveCode
073600000000                                :MessageErr);
073700000000        EndSr;
073800000000      /End-Free
