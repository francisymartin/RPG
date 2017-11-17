000100171012     H/TITLE SOURCE CONTROL MAIN
000200171013     H OPTION(*NODEBUGIO:*SRCSTMT:*showcpy)
000201171013     H DEBUG(*yes)
000300171011     F*
000400171011     FSRCH      UF   E           K DISK
000500171011     FSRCTYPE   IF   E           K DISK
000600171012     FSRCMAIN   CF   E             WORKSTN INFDS(SRVFDS)
000601171013     F                                     SFILE(RECORD:I1)
000700171012     D*
000800171013     DP_INDDS1         S               *   INZ(%ADDR(*IN))
000900171013     D$RESET           DS                  BASED(P_INDDS1)
001000171013     D I00                           99A   OVERLAY($RESET:01)
001100171013     D*
001200171012     DSRVFDS           ds
001300171012     D FILE              *FILE                                                  * File name
001400171012     D OPEN_IND                9      9N                                        * File open?
001500171012     D EOF_IND                10     10N                                        * File at eof?
001600171012     D STATUS            *STATUS                                                * Status code
001700171012     D OPCODE            *OPCODE                                                * Last opcode
001800171012     D ROUTINE           *ROUTINE                                               * RPG Routine
001900171012     D LIST_NUM               30     37                                         * Listing line
002000171012     D SPCL_STAT              38     42S 0                                      * SPECIAL status
002100171012     D RECORDS           *RECORD                                                * Record name
002200171012     D MSGID                  46     52                                         * Error MSGID
002300171012     D SCREEN            *SIZE                                                  * Screen size
002400171012     D NLS_IN            *INP                                                   * NLS Input?
002500171012     D NLS_OUT           *OUT                                                   * NLS Output?
002600171012     D NLS_MODE          *MODE                                                  * NLS Mode?
002601171013     D dsp_rrn               376    377i 0
002602171013     D dsp_min_rrn           378    379i 0
002603171013     D dsp_num_rcds          380    381i 0
002700171012     D*
002800171012     D Date_ymd        S             10A
002900171012     D Time_HMS        S              8A
003000171013     D*I1              S              5S 0  INZ(0)
003100171013     D $SVI1           S              5S 0  INZ(0)
003200171013     D $PG             S              3S 0  INZ(0)
003300171013     D #G              S              3S 0  INZ(0)
003400171013     D $SEND           S              1A    INZ('0')
003401171013     D @@SCRN          S              5S 0  INZ(0)
003500171011     C**********************************
003600171011     C* MAIN
003700171011     C*
003800171011     C                   EXSR      S999
003900171013     C*
004000171013     C                   EXSR      ILOAD
004100171011     C*
004200171011B1   C     *INLR         DOWEQ     *OFF
004300171013     C*
004400171012     C     #SFRNO        IFLE      0
004500171012     C                   Z-ADD     1             #SFRNO
004600171012     C                   END
004700171012     C*
004800171012     C     I1            IFLE      0
004900171012     C                   SETOFF                                           12
005000171012     C                   ELSE
005100171012     C                   SETON                                            12
005200171012     C                   END
005300171012     C*
005301171013     C                   WRITE     HEADER
005400171012     C                   WRITE     FOOTER
005401171013     C                   WRITE     RECORDCTL
005700171013     C                   READ      HEADER                               9998
005800171013     C                   Z-ADD     0             ###RROW
005900171013     C                   Z-ADD     0             ###RCOL
005901171013     C*                  Z-ADD     @@SCRN        #SFRNO
006000171013     C     *IN99         CABEQ     '1'           EOJ                      LR
006100171013     C     *IN17         IFEQ      '1'
006200171013     C                   EXSR      EX
006201171013     C                   END
006202171013     C*    *IN16         IFEQ      '1'
006203171013     C*                  EXSR      RDOWN
006204171013     C*                  END
006205171013     C     *IN17         IFEQ      '1'
006206171013     C                   EXSR      RUP
006207171013     C                   END
006300171013     C     *INLR         CABEQ     '1'           EOJ
006400171013     C     *IN18         CABEQ     '1'           EOJ
006601171013     C     END           TAG
006700171011E1   C                   ENDDO
006800171011     C*
007000171013     C     EOJ           TAG
007100171011     C                   SETON                                            LR
007200171013     C*
007300171013     CSR   EX            BEGSR
007400171013     CSR   ENDEX         ENDSR
007401171013     C*
007402171013     CSR   RDOWN         BEGSR
007403171013     CSR                 SETOFF                                           16
007404171013     CSR                 MOVE      $SVI1         #SFRNO
007405171013     CSR                 WRITE     RECORDCTL                            99
007406171013     CSR   ENDRDOWN      ENDSR
007407171013     C*
007408171013     CSR   RUP           BEGSR
007409171013     CSR                 SETOFF                                           17
007410171013     CSR   $SEND         IFNE      '1'
007411171013     CSR                 EXSR      SLOAD
007412171013     CSR                 END
007418171105     CSR   ENDRUP        ENDSR
007500171011     C*
007600171013     CSR   ILOAD         BEGSR
008000171013     CSR                 Z-ADD     0             I1
008100171013     CSR                 Z-ADD     0             #SFRNO
008200171013     CSR                 MOVE      '0'           $SEND
008300171013     CSR   *LOVAL        SETLL     RSRCH                                9998
008400171013     CSR                 WRITE     RECORDCTL                            99
008500171013     CSR                 EXSR      SLOAD
008600171013     CSR   I1            IFEQ      0
008700171013     CSR                 END
008800171013     CSR   ENDILOAD      ENDSR
008900171013     C*
009000171013     CSR   SLOAD         BEGSR
009100171013     CSR   $SEND         IFEQ      '1'
009200171013     CSR                 Z-ADD     0             #SFRNO
009300171013     CSR                 GOTO      ENDSLOAD
009400171013     CSR                 END
009500171013     C*
009600171013     CSR                 Z-ADD     0             $PG
009700171013     CSR                 Z-ADD     0             #SFRNO
009800171013     CSR                 Z-ADD     $SVI1         I1
009900171013     C*
010000171013     CSR                 SETOFF                                           96
010100171013     CSR   *IN96         DOWEQ     '0'
010200171013     CSR   $PG           ANDLT     10
010300171013     CSR                 READ      RSRCH                                9996
010400171013     CSR                 MOVE      '1'           $SEL              1
010500171013     CSR   *IN96         IFEQ      '1'
010600171013     CSR                 MOVE      '1'           $SEND
010700171013     CSR                 MOVE      '0'           $SEL
010800171013     CSR                 END
010900171013     CSR   *IN99         IFEQ      '1'
011000171013     CSR                 MOVE      '0'           $SEL
011100171013     CSR                 END
011200171013     CSR   $SEL          IFEQ      '1'
011300171013     CSR                 MOVE      RNAME         SNAME
011400171013     CSR                 MOVE      RTYPE         STYPE
011500171013     CSR                 MOVE      RDESC         SDESC
011600171013     CSR                 ADD       1             $PG
011700171013     CSR                 ADD       1             I1
011800171013     CSR   #SFRNO        IFEQ      0
011900171013     CSR                 Z-ADD     I1            #SFRNO
012000171013     CSR                 END
012100171013     CSR                 WRITE     RECORD                               99
012200171013     CSR                 Z-ADD     I1            $SVI1
012300171013     CSR                 END
012400171013     CSR                 END
012500171013     C*
012600171013     CSR   $PG           IFLT      1
012700171013     CSR   10            SUB       $PG           #G
012800171013     CSR                 MOVE      *BLANK        SNAME
012900171013     CSR                 MOVE      *BLANK        STYPE
013000171013     CSR                 MOVE      *BLANK        SDESC
013100171013     CSR                 DO        #G
013200171013     CSR                 ADD       1             I1
013300171013     CSR                 WRITE     RECORD                               99
013400171013     CSR                 END
013500171013     CSR                 Z-ADD     I1            $SVI1
013600171013     CSR   #SFRNO        IFEQ      0
013700171013     CSR                 Z-ADD     I1            #SFRNO
013800171013     CSR                 END
013900171013     CSR                 END
014000171013     CSR   ENDSLOAD      ENDSR
014100171013     C*
014200171011     CSR   S999          BEGSR
014300171011     CSR   KSRCH         KLIST
014400171011     CSR                 KFLD                    $NAMEH
014500171011     C*
014600171011     CSR   *LIKE         DEFINE    RNAME         $NAMED
014700171011     CSR   *LIKE         DEFINE    RNAME         $NAMEH
014800171011     C*
014900171012     CSR                 eval      Date_ymd = %char(%date())
015000171012     CSR                 eval      Time_hms = %char(%time())
015100171011     CSR   END999        ENDSR
