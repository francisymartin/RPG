000100171011     H/TITLE SOURCE CONTROL
000200171011     F*
000201171011     FSRCH      UF   E           K DISK
000300171011     FSRCD      UF   E           K DISK
000400171011     FSRCTYPE   IF   E           K DISK
000500171011     C**********************************
000600171011     C* MAIN
000700171011     C*
000800171011     C                   EXSR      S999
000900171011     C*
001000171011B1   C     *INLR         DOWEQ     *OFF
001100171011E1   C                   ENDDO
001101171011     C*
001102171011     C                   SETON                                            LR
001200171011     C*
001300171011     CSR   S999          BEGSR
001301171011     C*
001302171011     CSR   KSRCH         KLIST
001303171011     CSR                 KFLD                    $NAMEH
001304171011     C*
001305171011     CSR   KSRCD         KLIST
001306171011     CSR                 KFLD                    $NAMED
001307171011     C*
001308171011     CSR   *LIKE         DEFINE    RNAME         $NAMED
001309171011     CSR   *LIKE         DEFINE    RNAME         $NAMEH
001310171011     C*
001311171011     CSR                 TIME                    $WRK12           12 0
001312171011     CSR                 MOVE      $WRK12        $$EDT             6 0
001313171011     CSR                 MOVEL     $WRK12        $SYST             6 0
001400171011     CSR   END999        ENDSR
