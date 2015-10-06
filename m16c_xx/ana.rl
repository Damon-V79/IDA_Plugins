/*
 *
 * ana.cpp
 *  Created on: 07.06.2011
 *      Author: User
 */

#include "M16C_xx.h"
#include <ua.hpp>

//----------------------------------------------------------------------
// Instructions

/*
 *
 +-----------+-----------+------------+
 | 7 ..... 0 | 7 ..... 0 |            |
 +-----------+-----------+------------+
 0111 0110   1111 DEST                ABS.B          DEST
 0111 0111   1111 DEST                ABS.W          DEST
 0111 0110   0110 DEST   __#IMM8__    ADC.B          #IMM8,  DEST
 0111 0111   0110 DEST   __#IMM16_    ADC.W          #IMM16, DEST
 1011 0000   _SRC DEST                ADC.B          SRC, DEST
 1011 0001   _SRC DEST                ADC.W          SRC, DEST
 0111 0110   1110 DEST                ADCF.B         DEST
 0111 0111   1110 DEST                ADCF.W         DEST
 0111 0110   0100 DEST   __#IMM8__    ADD.B:G        #IMM8,  DEST
 0111 0111   0100 DEST   __#IMM16_    ADD.W:G        #IMM16, DEST
 1100 1000   #IMM DEST                ADD.B:Q        #IMM4, DEST
 1100 1001   #IMM DEST                ADD.W:Q        #IMM4, DEST
 1000 0DST   __#IMM8__                ADD.B:S        #IMM8, DEST
 1010 0000   _SRC DEST                ADD.B:G        SRC, DEST
 1010 0001   _SRC DEST                ADD.W:G        SRC, DEST
 0010 0DSR                            ADD.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
 0111 1100   1110 1011   __#IMM8__    ADD.B:G        #IMM8,  SP
 0111 1101   1110 1011   __#IMM16_    ADD.W:G        #IMM16, SP
 0111 1101   1011 #IMM                ADD.B:Q        #IMM4, SP
 1111 1000   #IMM DEST   __DSP8___    ADJNZ.B        #IMM4, DEST, LABEL
 1111 1001   #IMM DEST   __DSP8___    ADJNZ.W        #IMM4, DEST, LABEL
 0111 0110   0010 DEST   __#IMM8__    AND.B:G        #IMM8,  DEST
 0111 0111   0010 DEST   __#IMM16_    AND.W:G        #IMM16, DEST
 1001 0DST   __#IMM8__                AND.B:S        #IMM8, DEST
 1001 0000   _SRC DEST                AND.B:G        SRC, DEST
 1001 0001   _SRC DEST                AND.W:G        SRC, DEST
 0001 0DSR                            AND.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
 0111 1110   0100 _SRC                BAND           SRC
 0111 1110   1000 DEST                BCLR:G         DEST
 0100 0BIT                            BCLR:S         BIT, BASE:11[SB]
 0111 1110   0010 DEST   0000 0000    BMGEU / BMC    DEST
 0111 1110   0010 DEST   0000 0001    BMGTU          DEST
 0111 1110   0010 DEST   0000 0010    BMEQ  / BMZ    DEST
 0111 1110   0010 DEST   0000 0011    BMN            DEST
 0111 1110   0010 DEST   0000 0100    BMLE           DEST
 0111 1110   0010 DEST   0000 0101    BMO            DEST
 0111 1110   0010 DEST   0000 0110    BMGE           DEST
 0111 1110   0010 DEST   1111 1000    BMLTU / BMNC   DEST
 0111 1110   0010 DEST   1111 1001    BMLEU          DEST
 0111 1110   0010 DEST   1111 1010    BMNE  / BMNZ   DEST
 0111 1110   0010 DEST   1111 1011    BMPZ           DEST
 0111 1110   0010 DEST   1111 1100    BMGT           DEST
 0111 1110   0010 DEST   1111 1101    BMNO           DEST
 0111 1110   0010 DEST   1111 1110    BMLT           DEST
 0111 1101   1101 0000                BMGEU / BMC    C
 0111 1101   1101 0001                BMGTU          C
 0111 1101   1101 0010                BMEQ  / BMZ    C
 0111 1101   1101 0011                BMN            C
 0111 1101   1101 0100                BMLTU / BMNC   C
 0111 1101   1101 0101                BMLEU          C
 0111 1101   1101 0110                BMNE  / BMNZ   C
 0111 1101   1101 0111                BMPZ           C
 0111 1101   1101 1000                BMLE           C
 0111 1101   1101 1001                BMGO           C
 0111 1101   1101 1010                BMGE           C
 0111 1101   1101 1100                BMGT           C
 0111 1101   1101 1101                BMNO           C
 0111 1101   1101 1110                BMLT           C
 0111 1110   0101 _SRC                BNAND          SRC
 0111 1110   0111 _SRC                BNOR           SRC
 0111 1110   1010 DEST                BNOT:G         DEST
 0101 0BIT                            BNOT:S         BIT, BASE:11[SB]
 0111 1110   0011 _SRC                BNTST          SRC
 0111 1110   1101 _SRC                BNXOR          SRC
 0111 1110   0110 _SRC                BOR            SRC
 0000 0000                            BRK
 0111 1110   1001 DEST                BSET:G         DEST
 0100 1BIT                            BSET:S         BIT, BASE:11[SB]
 0111 1110   1011 _SRC                BTST:G         SRC
 0101 1BIT                            BTST:S         BIT, BASE:11[SB]
 0111 1110   0000 DEST                BTSTC          DEST
 0111 1110   0001 DEST                BTSTS          DEST
 0111 1110   1100 _SRC                BXOR           SRC
 0111 0110   1000 DEST   __#IMM8__    CMP.B:G        #IMM8,  DEST
 0111 0111   1000 DEST   __#IMM16_    CMP.W:G        #IMM16, DEST
 1101 0000   #IMM DEST                CMP.B:Q        #IMM4, DEST
 1101 0001   #IMM DEST                CMP.W:Q        #IMM4, DEST
 1110 0DST   __#IMM8__                CMP.B:S        #IMM8,  DEST
 1100 0000   _SRC DEST                CMP.B:G        SRC, DEST
 1100 0001   _SRC DEST                CMP.W:G        SRC, DEST
 0011 1DSR                            CMP.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
 0111 1100   1110 1110   __#IMM8__    DADC.B         #IMM8,  R0L
 0111 1101   1110 1110   __#IMM16_    DADC.W         #IMM16, R0
 0111 1100   1110 0110                DADC.B         R0H, R0L
 0111 1101   1110 0110                DADC.W         R1, R0
 0111 1100   1110 1100   __#IMM8__    DADD.B         #IMM8,  R0L
 0111 1101   1110 1100   __#IMM16_    DADD.W         #IMM16, R0
 0111 1100   1110 0100                DADD.B         R0H, R0L
 0111 1101   1110 0100                DADD.W         R1, R0
 1010 1DST                            DEC.B          DEST
 1111 0010                            DEC.W          A0
 1111 1010                            DEC.W          A1
 0111 1100   1110 0001   __#IMM8__    DIV.B          #IMM8
 0111 1101   1110 0001   __#IMM16_    DIV.W          #IMM16
 0111 0110   1101 _SRC                DIV.B          SRC
 0111 0111   1101 _SRC                DIV.W          SRC
 0111 1100   1110 0000   __#IMM8__    DIVU.B         #IMM8
 0111 1101   1110 0000   __#IMM16_    DIVU.W         #IMM16
 0111 0110   1100 _SRC                DIVU.B         SRC
 0111 0111   1100 _SRC                DIVU.W         SRC
 0111 1100   1110 0011   __#IMM8__    DIVX.B         #IMM8
 0111 1101   1110 0011   __#IMM16_    DIVX.W         #IMM8
 0111 0110   1001 _SRC                DIVX.B         SRC
 0111 0111   1001 _SRC                DIVX.W         SRC
 0111 1100   1110 1111   __#IMM8__    DSBB.B         #IMM8,  R0L
 0111 1101   1110 1111   __#IMM16_    DSBB.W         #IMM16, R0
 0111 1100   1110 0111                DSBB.B         R0H, R0L
 0111 1101   1110 0111                DSBB.W         R1,  R0
 0111 1100   1110 1101   __#IMM8__    DSUB.B         #IMM8,  R0L
 0111 1101   1110 1101   __#IMM16_    DSUB.W         #IMM16, R0
 0111 1100   1110 0101                DSUB.B         R0H, R0L
 0111 1101   1110 0101                DSUB.W         R1,  R0
 0111 1100   1111 0010   __#IMM8__    ENTER          #IMM8
 0111 1101   1111 0010                EXITD
 0111 1100   0110 DEST                EXTS.B         DEST
 0111 1100   1111 0011                EXTS.W         R0
 1110 1011   0000 0101                FCLR           C
 1110 1011   0001 0101                FCLR           D
 1110 1011   0010 0101                FCLR           Z
 1110 1011   0011 0101                FCLR           S
 1110 1011   0100 0101                FCLR           B
 1110 1011   0101 0101                FCLR           O
 1110 1011   0110 0101                FCLR           I
 1110 1011   0111 0101                FCLR           U
 1110 1011   0000 0100                FSET           C
 1110 1011   0001 0100                FSET           D
 1110 1011   0010 0100                FSET           Z
 1110 1011   0011 0100                FSET           S
 1110 1011   0100 0100                FSET           B
 1110 1011   0101 0100                FSET           O
 1110 1011   0110 0100                FSET           I
 1110 1011   0111 0100                FSET           U
 1010 0DST                            INC.B          DEST
 1011 0010                            INC.W          A0
 1011 1010                            INC.W          A1
 1110 1011   11__#IMM_                INT            #IMM
 1111 0110                            INTO
 0110 1000   __DSP8___                JGEU / JC      LABEL
 0110 1001   __DSP8___                JGTU           LABEL
 0110 1010   __DSP8___                JEQ  / JZ      LABEL
 0110 1011   __DSP8___                JN             LABEL
 0110 1100   __DSP8___                JLTU / JNC     LABEL
 0110 1101   __DSP8___                JLEU           LABEL
 0110 1110   __DSP8___                JNE  / JNZ     LABEL
 0110 1111   __DSP8___                JPZ            LABEL
 0111 1101   1100 1000   __DSP8___    JLE            LABEL
 0111 1101   1100 1001   __DSP8___    JO             LABEL
 0111 1101   1100 1010   __DSP8___    JGE            LABEL
 0111 1101   1100 1100   __DSP8___    JGT            LABEL
 0111 1101   1100 1101   __DSP8___    JNO            LABEL
 0111 1101   1100 1110   __DSP8___    JLT            LABEL
 0110 0DSP                            JMP.S          LABEL
 1111 1110   __DSP8___                JMP.B          LABEL
 1111 0100   __DSP16__                JMP.W          LABEL
 1111 1100   ________ABS20________    JMP.A          LABEL
 0111 1101   0010 _SRC                JMPI.W         SRC
 0111 1101   0000 _SRC                JMPI.A         SRC
 1110 1110   __#IMM8__                JMPS           #IMM8
 1111 0101   __DSP16__                JSR.W          LABEL
 1111 1101   ________ABS20________    JSR.A          LABEL
 0111 1101   0011 _SRC                JSRI.W         SRC
 0111 1101   0001 _SRC                JSRI.A         SRC
 1110 1111   __#IMM8__                JSRS           #IMM8
 1110 1011   0001 0000   __#IMM16_    LDC            #IMM16, INTBL
 1110 1011   0010 0000   __#IMM16_    LDC            #IMM16, INTBH
 1110 1011   0011 0000   __#IMM16_    LDC            #IMM16, FLG
 1110 1011   0100 0000   __#IMM16_    LDC            #IMM16, ISP
 1110 1011   0101 0000   __#IMM16_    LDC            #IMM16, SP
 1110 1011   0110 0000   __#IMM16_    LDC            #IMM16, SB
 1110 1011   0111 0000   __#IMM16_    LDC            #IMM16, FB
 0111 1010   1DST _SRC                LDC            SRC, DEST
 0111 1100   1111 0000   ABS16 ABS20  LDCTX          ABS16, ABS20
 0111 0100   1000 DEST   __ABS20__    LDE.B          ABS20, DEST
 0111 0101   1000 DEST   __ABS20__    LDE.W          ABS20, DEST
 0111 0100   1001 DEST   __DSP20__    LDE.B          DSP:20[A0], DEST
 0111 0101   1001 DEST   __DSP20__    LDE.W          DSP:20[A0], DEST
 0111 0100   1010 DEST                LDE.B          [A0A1], DEST
 0111 0101   1010 DEST                LDE.W          [A0A1], DEST

 1110 1011   0010 0000
 0000 #IMM1  0000 0000
 1110 1011   0001 0000
 _______#IMM2________                 LDINTB         #IMM1#IMM2

 0111 1101   1010 0#IMM               LDIPL          #IMM
 0111 0100   1100 DEST   __#IMM8__    MOV.B:G        #IMM8, DEST
 0111 0101   1100 DEST   __#IMM8__    MOV.W:G        #IMM8, DEST
 1101 1000   #IMM DEST                MOV.B:Q        #IMM4, DEST
 1101 1001   #IMM DEST                MOV.W:Q        #IMM4, DEST
 1100 0DST   __#IMM8__                MOV.B:S        #IMM8, DEST
 1010 0010   __#IMM8__                MOV.B:S        #IMM8, A0
 1010 1010   __#IMM8__                MOV.B:S        #IMM8, A1
 1110 0010   __#IMM8__                MOV.W:S        #IMM8, A0
 1110 1010   __#IMM8__                MOV.W:S        #IMM8, A1
 1011 0DST                            MOV.B:Z        #0,  DEST
 0111 0010   _SRC DEST                MOV.B:G        SRC, DEST
 0111 0011   _SRC DEST                MOV.W:G        SRC, DEST
 0011 00SR                            MOV.B:S        SRC, A0
 0011 01SR                            MOV.B:S        SRC, A1
 0000 00DS                            MOV.B:S        R0L, DEST
 0000 01DS                            MOV.B:S        R0H, DEST
 0000 10SR                            MOV.B:S        SRC, R0L
 0000 11SR                            MOV.B:S        SRC, R0H
 0111 1010   1011 DEST   __DSP8___    MOV.B:G        DSP:8[SP], DEST
 0111 1011   1011 DEST   __DSP8___    MOV.W:G        DSP:8[SP], DEST
 0111 0100   0011 _SRC   __DSP8___    MOV.B:G        SRC, DSP:8[SP]
 0111 0101   0011 _SRC   __DSP8___    MOV.W:G        SRC, DSP:8[SP]
 1110 1011   0DST _SRC                MOVA           SRC, DEST
 0111 1100   1000 DEST                MOVLL          R0L, DEST
 0111 1100   1010 DEST                MOVLH          R0L, DEST
 0111 1100   1001 DEST                MOVHL          R0L, DEST
 0111 1100   1011 DEST                MOVHH          R0L, DEST
 0111 1100   0000 DEST                MOVLL          DEST, R0L
 0111 1100   0010 DEST                MOVLH          DEST, R0L
 0111 1100   0001 DEST                MOVHL          DEST, R0L
 0111 1100   0011 DEST                MOVHH          DEST, R0L
 0111 1100   0101 DEST   __#IMM8__    MUL.B          #IMM8,  DEST
 0111 1101   0101 DEST   __#IMM16_    MUL.W          #IMM16, DEST
 0111 1000   _SRC DEST                MUL.B          SRC, DEST
 0111 1001   _SRC DEST                MUL.W          SRC, DEST
 0111 1100   0100 DEST   __#IMM8__    MULU.B         #IMM8,  DEST
 0111 1101   0100 DEST   __#IMM16_    MULU.W         #IMM16, DEST
 0111 0000   _SRC DEST                MULU.B         SRC, DEST
 0111 0001   _SRC DEST                MULU.W         SRC, DEST
 0111 0100   0101 DEST                NEG.B          DEST
 0111 0101   0101 DEST                NEG.W          DEST
 0000 0100                            NOP
 0111 0100   0111 DEST                NOT.B:G        DEST
 0111 0101   0111 DEST                NOT.W:G        DEST
 1011 1DST                            NOT.B:S        DEST
 0111 0110   0011 DEST   __#IMM8__    OR.B:G         #IMM8, DEST
 0111 0111   0011 DEST   __#IMM16_    OR.W:G         #IMM8, DEST
 1001 1DST   __#IMM8__                OR.B:S         #IMM8, DEST
 1001 1000   _SRC DEST                OR.B:G         SRC, DEST
 0001 1DSR                            OR.B:S         SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
 0111 0100   1101 DEST                POP.B:G        DEST
 0111 0101   1101 DEST                POP.W:G        DEST
 1001 D010                            POP.B:S        DEST (D - DEST)
 1101 D010                            POP.W:S        DEST (D - DEST)
 1110 1011   0DST 0011                POPC           DEST
 1110 1101   __DEST___                POPM           DEST
 0111 1100   1110 0010   __#IMM8__    PUSH.B:G       #IMM8
 0111 1101   1110 0010   __#IMM16_    PUSH.W:G       #IMM16
 0111 0100   0100 _SRC                PUSH.B:G       SRC
 0111 0101   0100 _SRC                PUSH.W:G       SRC
 1000 S010                            PUSH.B:S       SRC (S - SRC)
 1100 S010                            PUSH.W:S       SRC (S - SRC)
 0111 1101   1001 _SRC                PUSHA          SRC
 1110 1011   0SRC 0010                PUSHC          SRC
 1110 1100   ___SRC___                PUSHM          SRC
 1111 1011                            REIT
 0111 1100   1111 0001                RMPA.B
 0111 1101   1111 0001                RMPA.W
 0111 0110   1010 DEST                ROLC.B         DEST
 0111 0111   1010 DEST                ROLC.W         DEST
 0111 0110   1011 DEST                RORC.B         DEST
 0111 0111   1011 DEST                RORC.W         DEST
 1110 0000   #IMM DEST                ROT.B          #IMM4, DEST
 1110 0001   #IMM DEST                ROT.W          #IMM4, DEST
 0111 0100   0110 DEST                ROT.B          R1H, DEST
 0111 0101   0110 DEST                ROT.W          R1H, DEST
 1111 0011                            RTS
 0111 0110   0111 DEST   __#IMM8__    SBB.B          #IMM8,  DEST
 0111 0111   0111 DEST   __#IMM16_    SBB.W          #IMM16, DEST
 1011 1000   _SRC DEST                SBB.B          SRC. DEST
 1011 1001   _SRC DEST                SBB.W          SRC. DEST
 1111 1000   #IMM DEST   ___DSP8__    SBJNZ.B        #IMM4, DEST, LABEL
 1111 1001   #IMM DEST   ___DSP8__    SBJNZ.W        #IMM4, DEST, LABEL
 1111 0000   #IMM DEST                SHA.B          #IMM4, DEST
 1111 0001   #IMM DEST                SHA.W          #IMM4, DEST
 0111 0100   1111 DEST                SHA.B          R1H, DEST
 0111 0101   1111 DEST                SHA.W          R1H, DEST
 1110 1011   101D #IMM                SHA.L          #IMM4, DEST (D - DEST)
 1110 1011   001D 0001                SHA.L          R1H, DEST (D - DEST)
 1110 1000   #IMM DEST                SHL.B          #IMM4, DEST
 1110 1001   #IMM DEST                SHL.W          #IMM4, DEST
 0111 0100   1110 DEST                SHL.B          R1H, DEST
 0111 0101   1110 DEST                SHL.W          R1H, DEST
 1110 1011   100D #IMM                SHL.L          #IMM4, DEST (D - DEST)
 1110 1011   000D 0001                SHL.L          R1H, DEST (D - DEST)
 0111 1100   1110 1001                SMOVB.B
 0111 1101   1110 1001                SMOVB.W
 0111 1100   1110 1000                SMOVF.B
 0111 1101   1110 1000                SMOVF.W
 0111 1100   1110 1010                SSTR.B
 0111 1101   1110 1010                SSTR.W
 0111 1011   1SRC DEST                STC            SRC, DEST
 0111 1100   1100 DEST                STC            PC,  DEST
 0111 1101   1111 0000  ABS16  ABS20  STCTX          ABS16, ABS20
 0111 0100   0000 _SRC  ____ABS20___  STE.B          SRC, ABS20
 0111 0101   0000 _SRC  ____ABS20___  STE.W          SRC, ABS20
 0111 0100   0001 _SRC  ____DSP20___  STE.B          SRC, DSP:20[A0]
 0111 0101   0001 _SRC  ____DSP20___  STE.W          SRC, DSP:20[A0]
 0111 0100   0010 _SRC                STE.B          SRC, [A0A1]
 1101 0DST   __#IMM8__                STNZ           #IMM8, DEST
 1100 1DST   __#IMM8__                STZ            #IMM8, DEST
 1101 1DST   __#IMM81_  __#IMM82_     STZX           #IMM81, #IMM82, DEST
 0111 0110   0101 DEST  __#IMM8__     SUB.B:G        #IMM8,  DEST
 0111 0111   0101 DEST  __#IMM8__     SUB.W:G        #IMM16, DEST
 1000 1DST   __#IMM8__                SUB.B:S        #IMM8, DEST
 1010 1000   _SRC DEST                SUB.B:G        SRC, DEST
 1010 1001   _SRC DEST                SUB.W:G        SRC, DEST
 0010 1DSR                            SUB.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
 0111 0110   0000 DEST  __#IMM8__     TST.B          #IMM8,  DEST
 0111 0111   0000 DEST  __#IMM16_     TST.W          #IMM16, DEST
 1000 0000   _SRC DEST                TST.B          SRC, DEST
 1000 0001   _SRC DEST                TST.W          SRC, DEST
 1111 1111                            UND
 0111 1101   1111 0011                WAIT
 0111 1010   00SR DEST                XCHG.B         SRC, DEST (SR - SRC)
 0111 1011   00SR DEST                XCHG.W         SRC, DEST (SR - SRC)
 0111 0110   0001 DEST  __#IMM8__     XOR.B          #IMM8,  DEST
 0111 0111   0001 DEST  __#IMM16_     XOR.W          #IMM16, DEST
 1000 1000   _SRC DEST                XOR.B          SRC, DEST
 1000 1001   _SRC DEST                XOR.W          SRC, DEST


 *
 */

// 8 bit src/dest
#define SRC_DEST_R0L         0x00
#define SRC_DEST_R0H         0x01
#define SRC_DEST_R1L         0x02
#define SRC_DEST_R1H         0x03
#define SRC_DEST_A0          0x04
#define SRC_DEST_A1          0x05
#define SRC_DEST_A0_         0x06
#define SRC_DEST_A1_         0x07
#define SRC_DEST_DSP_8_A0_   0x08
#define SRC_DEST_DSP_8_A1_   0x09
#define SRC_DEST_DSP_8_SB_   0x0A
#define SRC_DEST_DSP_8_FB_   0x0B
#define SRC_DEST_DSP_20_A0_  0x0C
#define SRC_DEST_DSP_20_A1_  0x0D
#define SRC_DEST_DSP_16_SB_  0x0E
#define SRC_DEST_ABS16       0x0F
#define SRC_DEST_ABS20       0x10
#define SRC_DEST_8BIT_A1A0_  0x11
#define SRC_DEST_DSP_8_SP_   0x12

// 16 bit src/dest
#define SRC_DEST_R0          0x00
#define SRC_DEST_R1          0x01
#define SRC_DEST_R2          0x02
#define SRC_DEST_R3          0x03
#define SRC_DEST_16BIT_A1A0_ 0x11

// 32 bit src/dest
#define SRC_DEST_R2R0        0x00
#define SRC_DEST_R3R1        0x01
#define SRC_DEST_A1A0        0x04

// bits work src/dest
#define BITS_BIT_R0          0x00
#define BITS_BIT_R1          0x01
#define BITS_BIT_R2          0x02
#define BITS_BIT_R3          0x03
#define BITS_BIT_A0          0x04
#define BITS_BIT_A1          0x05
#define BITS_A0_             0x06
#define BITS_A1_             0x07
#define BITS_BASE_8_A0_      0x08
#define BITS_BASE_8_A1_      0x09
#define BITS_BIT_BASE_8_SB_  0x0A
#define BITS_BIT_BASE_8_FB_  0x0B
#define BITS_BASE_16_A0_     0x0C
#define BITS_BASE_16_A1_     0x0D
#define BITS_BIT_BASE_16_SB_ 0x0E
#define BITS_BIT_BASE_16     0x0F


%%{
  machine M16C;
  write data;

#//   0x00             0000 0000                            BRK
  M16C_BRK = 0x00 @ {
    cmd.itype = M16C_xx_BRK;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x01..0x03       0000 00DS                            MOV.B:S        R0L, DEST
  M16C_MOV_B_S_R0L_DEST = (0x01..0x03) @ {
      cmd.itype = M16C_xx_MOV_B_S_R0L_DEST;
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
      switch(*p & 0x03) {
        case 0x01:
          MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op2);
          break;
        case 0x02:
          MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op2);
          break;
        default:
          MakeSrcDest8(SRC_DEST_ABS16, cmd.Op2);
          break;
      }
    };

#//   0x04             0000 0100                            NOP
  M16C_NOP = 0x04 @ {
    cmd.itype = M16C_xx_NOP;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x05..0x07       0000 01DS                            MOV.B:S        R0H, DEST
  M16C_MOV_B_S_R0H_DEST = (0x05..0x07) @ {
      cmd.itype = M16C_xx_MOV_B_S_R0H_DEST;
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
      switch(*p & 0x03) {
        case 0x01:
          MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op2);
          break;
        case 0x02:
          MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op2);
          break;
        default:
          MakeSrcDest8(SRC_DEST_ABS16, cmd.Op2);
          break;
      }
    };

#//   0x08..0x0B       0000 10SR                            MOV.B:S        SRC, R0L
  M16C_MOV_B_S_SRC_R0L = (0x08..0x0B) @ {
    cmd.itype = M16C_xx_MOV_B_S_SRC_R0L;
    switch((*p & 0x03)) {
      case 0x00:
        MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x0C..0x0F       0000 11SR                            MOV.B:S        SRC, R0H
  M16C_MOV_B_S_SRC_R0H = (0x0C..0x0F) @ {
    cmd.itype = M16C_xx_MOV_B_S_SRC_R0H;
    switch((*p & 0x03)) {
      case 0x00:
        MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    MakeSrcDest8(SRC_DEST_R0H, cmd.Op2);
  };

#//   0x10..0x17       0001 0DSR                            AND.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
  M16C_AND_B_S_SRC_R0L_R0H = (0x10..0x17) @ {
    cmd.itype = M16C_xx_AND_B_S_SRC_R0L_R0H;
    switch((*p & 0x03)) {
      case 0x00:
        if((*p & 0x04) == 0)
          MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        else
          MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    if((*p & 0x04) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op2);
  };

#//   0x18..0x1F       0001 1DSR                            OR.B:S         SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
  M16C_OR_B_S_SRC_R0L_R0H = (0x18..0x1F) @ {
    cmd.itype = M16C_xx_OR_B_S_SRC_R0L_R0H;
    switch((*p & 0x03)) {
      case 0x00:
        if((*p & 0x04) == 0)
          MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        else
          MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    if((*p & 0x04) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op2);
  };

#//   0x20..0x27       0010 0DSR                            ADD.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
  M16C_ADD_B_S_SRC_R0L_R0H = (0x20..0x27) @ {
    cmd.itype = M16C_xx_ADD_B_S_SRC_R0L_R0H;
    switch((*p & 0x03)) {
      case 0x00:
        if((*p & 0x04) == 0)
          MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        else
          MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    if((*p & 0x04) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op2);
  };

#//   0x28..0x2F       0010 1DSR                            SUB.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
  M16C_SUB_B_S_SRC_R0L_R0H = (0x28..0x2F) @ {
    cmd.itype = M16C_xx_SUB_B_S_SRC_R0L_R0H;
    switch((*p & 0x03)) {
      case 0x00:
        if((*p & 0x04) == 0)
          MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        else
          MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    if((*p & 0x04) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op2);
  };

#//   0x30..0x33       0011 00SR                            MOV.B:S        SRC, A0
  M16C_MOV_B_S_SRC_A0 = (0x30..0x33) @ {
    cmd.itype = M16C_xx_MOV_B_S_SRC_A0;
    switch((*p & 0x03)) {
      case 0x00:
        MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    MakeSrcDest8(SRC_DEST_A0, cmd.Op2);
  };

#//   0x34..0x37       0011 01SR                            MOV.B:S        SRC, A1
  M16C_MOV_B_S_SRC_A1 = (0x34..0x37) @ {
    cmd.itype = M16C_xx_MOV_B_S_SRC_A1;
    switch((*p & 0x03)) {
      case 0x00:
        MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    MakeSrcDest8(SRC_DEST_A1, cmd.Op2);
  };

#//   0x38..0x3F       0011 1DSR                            CMP.B:S        SRC, R0L/R0H (D - DEST [R0L/R0H], SR - SRC)
  M16C_CMP_B_S_SRC_R0L_R0H = (0x38..0x3F) @ {
    cmd.itype = M16C_xx_CMP_B_S_SRC_R0L_R0H;
    switch((*p & 0x03)) {
      case 0x00:
        if((*p & 0x04) == 0)
          MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        else
          MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x01:
        MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op1);
        break;
      case 0x02:
        MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmd.Op1);
        break;
      case 0x03:
        MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
        break;
    }
    if((*p & 0x04) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op2);
  };

#//   0x40..0x47       0100 0BIT                            BCLR:S         BIT, BASE:11[SB]
  M16C_BCLR_S_BIT_BASE_11_SB = (0x40..0x47) @ {
    cmd.itype = M16C_xx_BCLR_S_BIT_BASE_11_SB;
    MakeImm4(*p & 0x07, cmd.Op1);
    MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op2);
  };

#//   0x48..0x4F       0100 1BIT                            BSET:S         BIT, BASE:11[SB]
  M16C_BSET_S_BIT_BASE_11_SB = (0x48..0x4F) @ {
    cmd.itype = M16C_xx_BSET_S_BIT_BASE_11_SB;
    MakeImm4(*p & 0x07, cmd.Op1);
    MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op2);
  };

#//   0x50..0x57       0101 0BIT                            BNOT:S         BIT, BASE:11[SB]
  M16C_BNOT_S_BIT_BASE_11_SB = (0x50..0x57) @ {
    cmd.itype = M16C_xx_BNOT_S_BIT_BASE_11_SB;
    MakeImm4(*p & 0x07, cmd.Op1);
    MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op2);
  };

#//   0x58..0x5F       0101 1BIT                            BTST:S         BIT, BASE:11[SB]
  M16C_BTST_S_BIT_BASE_11_SB = (0x58..0x5F) @ {
    cmd.itype = M16C_xx_BTST_S_BIT_BASE_11_SB;
    MakeImm4(*p & 0x07, cmd.Op1);
    MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmd.Op2);
  };

#//   0x60..0x67       0110 0DSP                            JMP.S          LABEL
  M16C_JMP_S_LABEL = (0x60..0x67) @ {
    cmd.itype = M16C_xx_JMP_S_LABEL;
    int32_t dsp = (*p & 0x07);
    if((dsp & 0x04) > 0)
      dsp |= 0xFFFFFFF8;
    MakeNearOffset(dsp + 2, cmd.Op1);
  };

#//   0x68             0110 1000   __DSP8___                JGEU / JC      LABEL
  M16C_JC_LABEL = (0x68) @ {
    cmd.itype = M16C_xx_JC_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x69             0110 1001   __DSP8___                JGTU           LABEL
  M16C_JGTU_LABEL = (0x69) @ {
    cmd.itype = M16C_xx_JGTU_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x6A             0110 1010   __DSP8___                JEQ  / JZ      LABEL
  M16C_JZ_LABEL = (0x6A) @ {
    cmd.itype = M16C_xx_JZ_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x6B             0110 1011   __DSP8___                JN             LABEL
  M16C_JN_LABEL = (0x6B) @ {
    cmd.itype = M16C_xx_JN_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x6C             0110 1100   __DSP8___                JLTU / JNC     LABEL
  M16C_JNC_LABEL = (0x6C) @ {
    cmd.itype = M16C_xx_JNC_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x6D             0110 1101   __DSP8___                JLEU           LABEL
  M16C_JLEU_LABEL = (0x6D) @ {
    cmd.itype = M16C_xx_JLEU_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x6E             0110 1110   __DSP8___                JNE  / JNZ     LABEL
  M16C_JNZ_LABEL = (0x6E) @ {
    cmd.itype = M16C_xx_JNZ_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x6F             0110 1111   __DSP8___                JPZ            LABEL
  M16C_JPZ_LABEL = (0x6F) @ {
    cmd.itype = M16C_xx_JPZ_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0x70             0111 0000   _SRC DEST                MULU.B         SRC, DEST
  M16C_MULU_B_SRC_DEST = 0x70 any @ {
    cmd.itype = M16C_xx_MULU_B_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0x71             0111 0001   _SRC DEST                MULU.W         SRC, DEST
  M16C_MULU_W_SRC_DEST = (0x71) any @ {
    cmd.itype = M16C_xx_MULU_W_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0x72             0111 0010   _SRC DEST                MOV.B:G        SRC, DEST
  M16C_MOV_B_G_SRC_DEST = (0x72) any @ {
    cmd.itype = M16C_xx_MOV_B_G_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0x73             0111 0010   _SRC DEST                MOV.W:G        SRC, DEST
  M16C_MOV_W_G_SRC_DEST = (0x73) any @ {
    cmd.itype = M16C_xx_MOV_W_G_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0x74 0x00..0x0F  0111 0100   0000 _SRC  ____ABS20___  STE.B          SRC, ABS20
  M16C_STE_B_SRC_ABS20 = (0x74 0x00..0x0F) @ {
    cmd.itype = M16C_xx_STE_B_SRC_ABS20;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
    MakeSrcDest8(SRC_DEST_ABS20, cmd.Op2);
  };

#//   0x74 0x10..0x1F  0111 0100   0001 _SRC  ____DSP20___  STE.B          SRC, DSP:20[A0]
  M16C_STE_B_SRC_DSP_20_A0 = (0x74 0x10..0x1F) @ {
    cmd.itype = M16C_xx_STE_B_SRC_DSP_20_A0;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
    MakeSrcDest8(SRC_DEST_DSP_20_A0_, cmd.Op2);
  };

#//   0x74 0x20..0x2F  0111 0100   0010 _SRC                STE.B          SRC, [A0A1]
  M16C_STE_B_SRC_A0A1 = (0x74 0x20..0x2F) @ {
    cmd.itype = M16C_xx_STE_B_SRC_A0A1;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
    MakeSrcDest8(SRC_DEST_8BIT_A1A0_, cmd.Op2);
  };

#//   0x74 0x30..0x3F  0111 0100   0011 _SRC   __DSP8___    MOV.B:G        SRC, DSP:8[SP]
  M16C_MOV_B_G_SRC_DSP_8_SP = (0x74 0x30..0x3F) @ {
    cmd.itype = M16C_xx_MOV_B_G_SRC_DSP_8_SP;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
    MakeSrcDest8(SRC_DEST_DSP_8_SP_, cmd.Op2);
  };

#//   0x74 0x40..0x4F  0111 0100   0100 _SRC                PUSH.B:G       SRC
  M16C_PUSH_B_G_SRC = (0x74 0x40..0x4F) @ {
    cmd.itype = M16C_xx_PUSH_B_G_SRC;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x74 0x50..0x5F  0111 0100   0101 DEST                NEG.B          DEST
  M16C_NEG_B_DEST = (0x74 0x50..0x5F) @ {
    cmd.itype = M16C_xx_NEG_B_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x74 0x60..0x6F  0111 0100   0110 DEST                ROT.B          R1H, DEST
  M16C_ROT_B_R1H_DEST = (0x74 0x60..0x6F) @ {
    cmd.itype = M16C_xx_ROT_B_R1H_DEST;
    MakeSrcDest8(SRC_DEST_R1H, cmd.Op1);
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
  };

#//   0x74 0x70..0x7F  0111 0100   0111 DEST                NOT.B:G        DEST
  M16C_NOT_B_G_DEST = (0x74 0x70..0x7F) @ {
    cmd.itype = M16C_xx_NOT_B_G_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x74 0x80..0x8F  0111 0100   1000 DEST   __ABS20__    LDE.B          ABS20, DEST
  M16C_LDE_B_ABS20_DEST = (0x74 0x80..0x8F) @ {
    cmd.itype = M16C_xx_LDE_B_ABS20_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeSrcDest8(SRC_DEST_ABS20, cmd.Op1);
  };

#//   0x74 0x90..0x9F  0111 0100   1001 DEST   __DSP20__    LDE.B          DSP:20[A0], DEST
  M16C_LDE_B_DSP_20_A0_DEST = (0x74 0x90..0x9F) @ {
    cmd.itype = M16C_xx_LDE_B_DSP_20_A0_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeSrcDest8(SRC_DEST_DSP_20_A0_, cmd.Op1);
  };

#//   0x74 0xA0..0xAF  0111 0100   1010 DEST                LDE.B          [A0A1], DEST
  M16C_LDE_B_A0A1_DEST = (0x74 0xA0..0xAF) @ {
    cmd.itype = M16C_xx_LDE_B_A0A1_DEST;
    MakeSrcDest8(SRC_DEST_8BIT_A1A0_, cmd.Op1);
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
  };

#//   0x74 0xB0..0xBF  0111 0101   1010 DEST                MOV.B:G        dsp:8[SP], DEST
  M16C_MOV_B_G_DSP_8_SP_DEST = (0x74 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_MOV_B_G_DSP_8_SP_DEST;
    MakeSrcDest8(SRC_DEST_DSP_8_SP_, cmd.Op1);
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    };

#//   0x74 0xC0..0xCF  0111 0100   1100 DEST   __#IMM8__    MOV.B:G        #IMM8, DEST
  M16C_MOV_B_G_IMM8_DEST = (0x74 0xC0..0xCF) @ {
    cmd.itype = M16C_xx_MOV_B_G_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x74 0xD0..0xDF  0111 0100   1101 DEST                POP.B:G        DEST
  M16C_POP_B_G_DEST = (0x74 0xD0..0xDF) @ {
    cmd.itype = M16C_xx_POP_B_G_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x74 0xE0..0xEF  0111 0100   1110 DEST                SHL.B          R1H, DEST
  M16C_SHL_B_R1H_DEST = (0x74 0xE0..0xEF) @ {
    cmd.itype = M16C_xx_SHL_B_R1H_DEST;
    MakeSrcDest8(SRC_DEST_R1H, cmd.Op1);
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
  };

#//   0x74 0xF0..0xFF  0111 0100   1111 DEST                SHA.B          R1H, DEST
  M16C_SHA_B_R1H_DEST = (0x74 0xF0..0xFF) @ {
    cmd.itype = M16C_xx_SHA_B_R1H_DEST;
    MakeSrcDest8(SRC_DEST_R1H, cmd.Op1);
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
  };

#//   0x75 0x00..0x0F  0111 0101   0000 _SRC  ____ABS20___  STE.W          SRC, ABS20
  M16C_STE_W_SRC_ABS20 = (0x75 0x00..0x0F) @ {
    cmd.itype = M16C_xx_STE_W_SRC_ABS20;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
    MakeSrcDest16(SRC_DEST_ABS20, cmd.Op2);
  };

#//   0x75 0x10..0x1F  0111 0101   0001 _SRC  ____DSP20___  STE.W          SRC, DSP:20[A0]
  M16C_STE_W_SRC_DSP_20_A0 = (0x75 0x10..0x1F) @ {
    cmd.itype = M16C_xx_STE_W_SRC_DSP_20_A0;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
    MakeSrcDest16(SRC_DEST_DSP_20_A0_, cmd.Op2);
  };

#//   0x75 0x20..0x2F  0111 0100   0010 _SRC                STE.W          SRC, [A0A1]
  M16C_STE_W_SRC_A0A1 = (0x75 0x20..0x2F) @ {
    cmd.itype = M16C_xx_STE_W_SRC_A0A1;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
    MakeSrcDest16(SRC_DEST_8BIT_A1A0_, cmd.Op2);
  };

#//   0x75 0x30..0x3F  0111 0101   0011 _SRC   __DSP8___    MOV.W:G        SRC, DSP:8[SP]
  M16C_MOV_W_G_SRC_DSP_8_SP = (0x75 0x30..0x3F) @ {
    cmd.itype = M16C_xx_MOV_W_G_SRC_DSP_8_SP;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
    MakeSrcDest16(SRC_DEST_DSP_8_SP_, cmd.Op2);
  };

#//   0x75 0x40..0x4F  0111 0101   0100 _SRC                PUSH.W:G       SRC
  M16C_PUSH_W_G_SRC = (0x75 0x40..0x4F) @ {
    cmd.itype = M16C_xx_PUSH_W_G_SRC;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x75 0x50..0x5F  0111 0101   0101 DEST                NEG.W          DEST
  M16C_NEG_W_DEST = (0x75 0x50..0x5F) @ {
    cmd.itype = M16C_xx_NEG_W_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x75 0x60..0x6F  0111 0101   0110 DEST                ROT.W          R1H, DEST
  M16C_ROT_W_R1H_DEST = (0x75 0x60..0x6F) @ {
    cmd.itype = M16C_xx_ROT_W_R1H_DEST;
    MakeSrcDest16(SRC_DEST_R1H, cmd.Op1);
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
  };

#//   0x75 0x70..0x7F  0111 0101   0111 DEST                NOT.W:G        DEST
  M16C_NOT_W_G_DEST = (0x75 0x70..0x7F) @ {
    cmd.itype = M16C_xx_NOT_W_G_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x75 0x80..0x8F  0111 0101   1000 DEST   __ABS20__    LDE.W          ABS20, DEST
  M16C_LDE_W_ABS20_DEST = (0x75 0x80..0x8F) @ {
    cmd.itype = M16C_xx_LDE_W_ABS20_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeSrcDest16(SRC_DEST_ABS20, cmd.Op1);
  };

#//   0x75 0x90..0x9F  0111 0101   1001 DEST   __DSP20__    LDE.W          DSP:20[A0], DEST
  M16C_LDE_W_DSP_20_A0_DEST = (0x75 0x90..0x9F) @ {
    cmd.itype = M16C_xx_LDE_W_DSP_20_A0_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeSrcDest16(SRC_DEST_DSP_20_A0_, cmd.Op1);
  };

#//   0x75 0xA0..0xAF  0111 0101   1010 DEST                LDE.W          [A0A1], DEST
  M16C_LDE_W_A0A1_DEST = (0x75 0xA0..0xAF) @ {
    cmd.itype = M16C_xx_LDE_W_A0A1_DEST;
    MakeSrcDest16(SRC_DEST_16BIT_A1A0_, cmd.Op1);
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    };

#//   0x75 0xB0..0xBF  0111 0101   1010 DEST                MOV.W:G        dsp:8[SP], DEST
  M16C_MOV_W_G_DSP_8_SP_DEST = (0x75 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_MOV_W_G_DSP_8_SP_DEST;
    MakeSrcDest16(SRC_DEST_DSP_8_SP_, cmd.Op1);
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    };

#//   0x75 0xC0..0xCF  0111 0101   1100 DEST   __#IMM8__    MOV.W:G        #IMM8, DEST
  M16C_MOV_W_G_IMM8_DEST = (0x75 0xC0..0xCF) @ {
    cmd.itype = M16C_xx_MOV_W_G_IMM8_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x75 0xD0..0xDF  0111 0101   1101 DEST                POP.W:G        DEST
  M16C_POP_W_G_DEST = (0x75 0xD0..0xDF) @ {
    cmd.itype = M16C_xx_POP_W_G_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x75 0xE0..0xEF  0111 0101   1110 DEST                SHL.W          R1H, DEST
  M16C_SHL_W_R1H_DEST = (0x75 0xE0..0xEF) @ {
    cmd.itype = M16C_xx_SHL_W_R1H_DEST;
    MakeSrcDest16(SRC_DEST_R1H, cmd.Op1);
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
  };

#//   0x75 0xF0..0xFF  0111 0101   1111 DEST                SHA.W          R1H, DEST
  M16C_SHA_W_R1H_DEST = (0x75 0xF0..0xFF) @ {
    cmd.itype = M16C_xx_SHA_W_R1H_DEST;
    MakeSrcDest16(SRC_DEST_R1H, cmd.Op1);
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
  };

#//   0x76 0x00..0x0F  0111 0110   0000 DEST  __#IMM8__     TST.B          #IMM8,  DEST
  M16C_TST_B_IMM8_DEST = (0x76 0x00..0x0F) @ {
    cmd.itype = M16C_xx_TST_B_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x10..0x1F  0111 0110   0001 DEST  __#IMM8__     XOR.B          #IMM8,  DEST
  M16C_XOR_B_IMM8_DEST = (0x76 0x10..0x1F) @ {
    cmd.itype = M16C_xx_XOR_B_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x20..0x2F  0111 0110   0010 DEST   __#IMM8__    AND.B:G        #IMM8,  DEST
  M16C_AND_B_G_IMM8_DEST = (0x76 0x20..0x2F) @ {
    cmd.itype = M16C_xx_AND_B_G_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x30..0x3F  0111 0110   0011 DEST   __#IMM8__    OR.B:G         #IMM8, DEST
  M16C_OR_B_G_IMM8_DEST = (0x76 0x30..0x3F) @ {
    cmd.itype = M16C_xx_OR_B_G_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x40..0x4F  0111 0110   0100 DEST   __#IMM8__    ADD.B:G        #IMM8,  DEST
  M16C_ADD_B_G_IMM8_DEST = (0x76 0x40..0x4F) @ {
    cmd.itype = M16C_xx_ADD_B_G_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x50..0x5F  0111 0110   0101 DEST  __#IMM8__     SUB.B:G        #IMM8,  DEST
  M16C_SUB_B_G_IMM8_DEST = (0x76 0x50..0x5F) @ {
    cmd.itype = M16C_xx_SUB_B_G_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x60..0x6F  0111 0110   0110 DEST   __#IMM8__    ADC.B          #IMM8,  DEST
  M16C_ADC_B_IMM8_DEST = (0x76 0x60..0x6F) @ {
    cmd.itype = M16C_xx_ADC_B_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x70..0x7F  0111 0110   0111 DEST   __#IMM8__    SBB.B          #IMM8,  DEST
  M16C_SBB_B_IMM8_DEST = (0x76 0x70..0x7F) @ {
    cmd.itype = M16C_xx_SBB_B_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x80..0x8F  0111 0110   1000 DEST   __#IMM8__    CMP.B:G        #IMM8,  DEST
  M16C_CMP_B_G_IMM8_DEST = (0x76 0x80..0x8F) @ {
    cmd.itype = M16C_xx_CMP_B_G_IMM8_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x76 0x90..0x9F  0111 0110   1001 _SRC                DIVX.B         SRC
  M16C_DIVX_B_SRC = (0x76 0x90..0x9F) @ {
    cmd.itype = M16C_xx_DIVX_B_SRC;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x76 0xA0..0xAF  0111 0110   1010 DEST                ROLC.B         DEST
  M16C_ROLC_B_DEST = (0x76 0xA0..0xAF) @ {
    cmd.itype = M16C_xx_ROLC_B_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x76 0xB0..0xBF  0111 0110   1011 DEST                RORC.B         DEST
  M16C_RORC_B_DEST = (0x76 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_RORC_B_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x76 0xC0..0xCF  0111 0110   1100 _SRC                DIVU.B         SRC
  M16C_DIVU_B_SRC = (0x76 0xC0..0xCF) @ {
    cmd.itype = M16C_xx_DIVU_B_SRC;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x76 0xD0..0xDF  0111 0110   1101 _SRC                DIV.B          SRC
  M16C_DIV_B_SRC = (0x76 0xD0..0xDF) @ {
    cmd.itype = M16C_xx_DIV_B_SRC;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x76 0xE0..0xEF  0111 0110   1110 DEST                ADCF.B         DEST
  M16C_ADCF_B_DEST = (0x76 0xE0..0xEF) @ {
    cmd.itype = M16C_xx_ADCF_B_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x76 0xF0..0xFF  0111 0110   1111 DEST                ABS.B          DEST
  M16C_ABS_B_DEST = (0x76 0xF0..0xFF) @ {
    cmd.itype = M16C_xx_ABS_B_DEST;
    MakeSrcDest8((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0x00..0x0F  0111 0111   0000 DEST  __#IMM16_     TST.W          #IMM16, DEST
  M16C_TST_W_IMM16_DEST = (0x77 0x00..0x0F) @ {
    cmd.itype = M16C_xx_TST_W_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x10..0x1F  0111 0111   0001 DEST  __#IMM16_     XOR.W          #IMM16, DEST
  M16C_XOR_W_IMM16_DEST = (0x77 0x10..0x1F) @ {
    cmd.itype = M16C_xx_XOR_W_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x20..0x2F  0111 0111   0010 DEST   __#IMM16_    AND.W:G        #IMM16, DEST
  M16C_AND_W_G_IMM16_DEST = (0x77 0x20..0x2F) @ {
    cmd.itype = M16C_xx_AND_W_G_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x30..0x3F  0111 0111   0011 DEST   __#IMM16_    OR.W:G         #IMM16, DEST
  M16C_OR_W_G_IMM8_DEST = (0x77 0x30..0x3F) @ {
    cmd.itype = M16C_xx_OR_W_G_IMM8_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x40..0x4F  0111 0111   0100 DEST   __#IMM16_    ADD.W:G        #IMM16, DEST
  M16C_ADD_W_G_IMM16_DEST = (0x77 0x40..0x4F) @ {
    cmd.itype = M16C_xx_ADD_W_G_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x50..0x5F  0111 0111   0101 DEST  __#IMM8__     SUB.W:G        #IMM16, DEST
  M16C_SUB_W_G_IMM16_DEST = (0x77 0x50..0x5F) @ {
    cmd.itype = M16C_xx_SUB_W_G_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x60..0x6F  0111 0111   0110 DEST   __#IMM16_    ADC.W          #IMM16, DEST
  M16C_ADC_W_IMM16_DEST = (0x77 0x60..0x6F) @ {
    cmd.itype = M16C_xx_ADC_W_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x70..0x7F  0111 0111   0111 DEST   __#IMM16_    SBB.W          #IMM16, DEST
  M16C_SBB_W_IMM16_DEST = (0x77 0x70..0x7F) @ {
    cmd.itype = M16C_xx_SBB_W_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x80..0x8F  0111 0111   1000 DEST   __#IMM16_    CMP.W:G        #IMM16, DEST
  M16C_CMP_W_G_IMM16_DEST = (0x77 0x80..0x8F) @ {
    cmd.itype = M16C_xx_CMP_W_G_IMM16_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x77 0x90..0x9F  0111 0111   1001 _SRC                DIVX.W         SRC
  M16C_DIVX_W_SRC = (0x77 0x90..0x9F) @ {
    cmd.itype = M16C_xx_DIVX_W_SRC;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0xA0..0xAF  0111 0111   1010 DEST                ROLC.W         DEST
  M16C_ROLC_W_DEST = (0x77 0xA0..0xAF) @ {
    cmd.itype = M16C_xx_ROLC_W_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0xB0..0xBF  0111 0111   1011 DEST                RORC.W         DEST
  M16C_RORC_W_DEST = (0x77 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_RORC_W_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0xC0..0xCF  0111 0111   1100 _SRC                DIVU.W         SRC
  M16C_DIVU_W_SRC = (0x77 0xC0..0xCF) @ {
    cmd.itype = M16C_xx_DIVU_W_SRC;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0xD0..0xDF  0111 0111   1101 _SRC                DIV.W          SRC
  M16C_DIV_W_SRC = (0x77 0xD0..0xDF) @ {
    cmd.itype = M16C_xx_DIV_W_SRC;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0xE0..0xEF  0111 0111   1110 DEST                ADCF.W         DEST
  M16C_ADCF_W_DEST = (0x77 0xE0..0xEF) @ {
    cmd.itype = M16C_xx_ADCF_W_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x77 0xF0..0xFF  0111 0111   1111 DEST                ABS.W          DEST
  M16C_ABS_W_DEST = (0x77 0xF0..0xFF) @ {
    cmd.itype = M16C_xx_ABS_W_DEST;
    MakeSrcDest16((*p & 0x0F), cmd.Op1);
  };

#//   0x78             0111 1000   _SRC DEST                MUL.B          SRC, DEST
  M16C_MUL_B_SRC_DEST = (0x78 any) @ {
    cmd.itype = M16C_xx_MUL_B_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
  };

#//   0x79             0111 1001   _SRC DEST                MUL.W          SRC, DEST
  M16C_MUL_W_SRC_DEST = (0x79 any) @ {
    cmd.itype = M16C_xx_MUL_W_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
  };

#//   0x7A 0x00..0x3F  0111 1010   00SR DEST                XCHG.B         SRC, DEST (SR - SRC)
  M16C_XCHG_B_SRC_DEST = (0x7A 0x00..0x3F) @ {
    cmd.itype = M16C_xx_XCHG_B_SRC_DEST;
    switch(*p & 0x30) {
      case 0x00:
        MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x10:
        MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
        break;
      case 0x20:
        MakeSrcDest8(SRC_DEST_R1L, cmd.Op1);
        break;
      default:
        MakeSrcDest8(SRC_DEST_R1H, cmd.Op1);
        break;
    }
    MakeSrcDest8((*p & 0x0F), cmd.Op2);
  };

#//   0x7A 0x80..0xFF  0111 1010   1DST _SRC                LDC            SRC, DEST
  M16C_LDC_SRC_DEST = (0x7A 0x80..0xFF) @ {
    cmd.itype = M16C_xx_LDC_SRC_DEST;
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    switch(*p & 0x70){
      case 0x10:
        cmd.Op2.reg = rINTBL;
        break;
      case 0x20:
        cmd.Op2.dtyp = dt_byte;
        cmd.Op2.reg = rINTBH;
        break;
      case 0x30:
        cmd.Op2.reg = rFLG;
        break;
      case 0x40:
        cmd.Op2.reg = rISP;
        break;
      case 0x50:
        cmd.Op2.reg = rSP;
        break;
      case 0x60:
        cmd.Op2.reg = rSB;
        break;
      case 0x70:
        cmd.Op2.reg = rFB;
        break;
    }
    if(cmd.Op2.dtyp == dt_byte)
      MakeSrcDest8(*p & 0x0F, cmd.Op1);
    else
      MakeSrcDest16(*p & 0x0F, cmd.Op1);
  };

#//   0x7B 0x30..0x3F  0111 1011   00SR DEST                XCHG.W         SRC, DEST (SR - SRC)
  M16C_XCHG_W_SRC_DEST = (0x7B 0x00..0x3F) @ {
    cmd.itype = M16C_xx_XCHG_W_SRC_DEST;
    switch(*p & 0x30) {
      case 0x00:
        MakeSrcDest16(SRC_DEST_R0L, cmd.Op1);
        break;
      case 0x10:
        MakeSrcDest16(SRC_DEST_R0H, cmd.Op1);
        break;
      case 0x20:
        MakeSrcDest16(SRC_DEST_R1L, cmd.Op1);
        break;
      default:
        MakeSrcDest16(SRC_DEST_R1H, cmd.Op1);
        break;
    }
    MakeSrcDest16((*p & 0x0F), cmd.Op2);
  };

#//   0x7B 0x80..0x8F  0111 1011   1SRC DEST                STC            SRC, DEST
  M16C_STC_SRC_DEST = (0x7B 0x80..0xFF) @ {
    cmd.itype = M16C_xx_STC_SRC_DEST;
    cmd.Op1.dtyp = dt_word;
    cmd.Op1.type = o_reg;
    switch(*p & 0x70){
      case 0x10:
        cmd.Op1.reg = rINTBL;
        break;
      case 0x20:
        cmd.Op1.dtyp = dt_byte;
        cmd.Op1.reg = rINTBH;
        break;
      case 0x30:
        cmd.Op1.reg = rFLG;
        break;
      case 0x40:
        cmd.Op1.reg = rISP;
        break;
      case 0x50:
        cmd.Op1.reg = rSP;
        break;
      case 0x60:
        cmd.Op1.reg = rSB;
        break;
      case 0x70:
        cmd.Op1.reg = rFB;
        break;
    }
    if(cmd.Op1.dtyp == dt_byte)
      MakeSrcDest8(*p & 0x0F, cmd.Op2);
    else
      MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0x7C 0x00..0x0F  0111 1100   0000 DEST                MOVLL          DEST, R0L
  M16C_MOVLL_DEST_R0L = (0x7C 0x00..0x0F) @ {
    cmd.itype = M16C_xx_MOVLL_DEST_R0L;
    MakeSrcDest8(*p & 0x0F, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0x10..0x1F  0111 1100   0001 DEST                MOVHL          DEST, R0L
  M16C_MOVHL_DEST_R0L = (0x7C 0x10..0x1F) @ {
    cmd.itype = M16C_xx_MOVHL_DEST_R0L;
    MakeSrcDest8(*p & 0x0F, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0x20..0x2F  0111 1100   0010 DEST                MOVLH          DEST, R0L
  M16C_MOVLH_DEST_R0L = (0x7C 0x20..0x2F) @ {
    cmd.itype = M16C_xx_MOVLH_DEST_R0L;
    MakeSrcDest8(*p & 0x0F, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0x30..0x3F  0111 1100   0011 DEST                MOVHH          DEST, R0L
  M16C_MOVHH_DEST_R0L = (0x7C 0x30..0x3F) @ {
    cmd.itype = M16C_xx_MOVHH_DEST_R0L;
    MakeSrcDest8(*p & 0x0F, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0x40..0x4F  0111 1100   0100 DEST   __#IMM8__    MULU.B         #IMM8,  DEST
  M16C_MULU_B_IMM8_DEST = (0x7C 0x40..0x4F) @ {
    cmd.itype = M16C_xx_MULU_B_IMM8_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0x50..0x5F  0111 1100   0101 DEST   __#IMM8__    MUL.B          #IMM8,  DEST
  M16C_MUL_B_IMM8_DEST = (0x7C 0x50..0x5F) @ {
    cmd.itype = M16C_xx_MUL_B_IMM8_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0x60..0x6F  0111 1100   0110 DEST                EXTS.B         DEST
  M16C_EXTS_B_DEST = (0x7C 0x60..0x6F) @ {
    cmd.itype = M16C_xx_EXTS_B_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op1);
  };

#//   0x7C 0x80..0x8F  0111 1100   1000 DEST                MOVLL          R0L, DEST
  M16C_MOVLL_R0L_DEST = (0x7C 0x80..0x8F) @ {
    cmd.itype = M16C_xx_MOVLL_R0L_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
  };

#//   0x7C 0x90..0x9F  0111 1100   1001 DEST                MOVHL          R0L, DEST
  M16C_MOVHL_R0L_DEST = (0x7C 0x90..0x9F) @ {
    cmd.itype = M16C_xx_MOVHL_R0L_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
  };

#//   0x7C 0xA0..0xAF  0111 1100   1010 DEST                MOVLH          R0L, DEST
  M16C_MOVLH_R0L_DEST = (0x7C 0xA0..0xAF) @ {
    cmd.itype = M16C_xx_MOVLH_R0L_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
  };

#//   0x7C 0xB0..0xBF  0111 1100   1011 DEST                MOVHH          R0L, DEST
  M16C_MOVHH_R0L_DEST = (0x7C 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_MOVHH_R0L_DEST;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
  };

#//   0x7C 0xC0..0xCF  0111 1100   1100 DEST                STC            PC,  DEST
  M16C_STC_PC_DEST = (0x7C 0xC0..0xCF) @ {
    cmd.itype = M16C_xx_STC_PC_DEST;
    cmd.Op1.dtyp = dt_dword;
    cmd.Op1.type = o_reg;
    cmd.Op1.reg = rPC;
    MakeSrcDest32(*p & 0x0F, cmd.Op2);
  };

#//   0x7C 0xE0        0111 1100   1110 0000   __#IMM8__    DIVU.B         #IMM8
  M16C_DIVU_B_IMM8 = (0x7C 0xE0) @ {
    cmd.itype = M16C_xx_DIVU_B_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xE1        0111 1100   1110 0001   __#IMM8__    DIV.B          #IMM8
  M16C_DIV_B_IMM8 = (0x7C 0xE1) @ {
    cmd.itype = M16C_xx_DIV_B_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xE2        0111 1100   1110 0010   __#IMM8__    PUSH.B:G       #IMM8
  M16C_PUSH_B_G_IMM8 = (0x7C 0xE2) @ {
    cmd.itype = M16C_xx_PUSH_B_G_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xE3        0111 1100   1110 0011   __#IMM8__    DIVX.B         #IMM8
  M16C_DIVX_B_IMM8 = (0x7C 0xE3) @ {
    cmd.itype = M16C_xx_DIVX_B_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xE4        0111 1100   1110 0100                DADD.B         R0H, R0L
  M16C_DADD_B_R0H_R0L = (0x7C 0xE4) @ {
    cmd.itype = M16C_xx_DADD_B_R0H_R0L;
    MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0xE5        0111 1100   1110 0101                DSUB.B         R0H, R0L
  M16C_DSUB_B_R0H_R0L = (0x7C 0xE5) @ {
    cmd.itype = M16C_xx_DSUB_B_R0H_R0L;
    MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0xE6        0111 1100   1110 0110                DADC.B         R0H, R0L
  M16C_DADC_B_R0H_R0L = (0x7C 0xE6) @ {
    cmd.itype = M16C_xx_DADC_B_R0H_R0L;
    MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0xE7        0111 1100   1110 0111                DSBB.B         R0H, R0L
  M16C_DSBB_B_R0H_R0L = (0x7C 0xE7) @ {
    cmd.itype = M16C_xx_DSBB_B_R0H_R0L;
    MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
  };

#//   0x7C 0xE8        0111 1100   1110 1000                SMOVF.B
  M16C_SMOVF_B = (0x7C 0xE8) @ {
    cmd.itype = M16C_xx_SMOVF_B;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7C 0xE9        0111 1100   1110 1001                SMOVB.B
  M16C_SMOVB_B = (0x7C 0xE9) @ {
    cmd.itype = M16C_xx_SMOVB_B;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7C 0xEA        0111 1100   1110 1010                SSTR.B
  M16C_SSTR_B = (0x7C 0xEA) @ {
    cmd.itype = M16C_xx_SSTR_B;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7C 0xEB        0111 1100   1110 1011   __#IMM8__    ADD.B:G        #IMM8,  SP
  M16C_ADD_B_G_IMM8_SP = (0x7C 0xEB) @ {
    cmd.itype = M16C_xx_ADD_B_G_IMM8_SP;
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rSP;
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xEC        0111 1100   1110 1100   __#IMM8__    DADD.B         #IMM8,  R0L
  M16C_DADD_B_IMM8_R0L = (0x7C 0xEC) @ {
    cmd.itype = M16C_xx_DADD_B_IMM8_R0L;
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xED        0111 1100   1110 1101   __#IMM8__    DSUB.B         #IMM8,  R0L
  M16C_DSUB_B_IMM8_R0L = (0x7C 0xED) @ {
    cmd.itype = M16C_xx_DSUB_B_IMM8_R0L;
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xEE        0111 1100   1110 1110   __#IMM8__    DADC.B         #IMM8,  R0L
  M16C_DADC_B_IMM8_R0L = (0x7C 0xEE) @ {
    cmd.itype = M16C_xx_DADC_B_IMM8_R0L;
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xEF        0111 1100   1110 1111   __#IMM8__    DSBB.B         #IMM8,  R0L
  M16C_DSBB_B_IMM8_R0L = (0x7C 0xEF) @ {
    cmd.itype = M16C_xx_DSBB_B_IMM8_R0L;
    MakeSrcDest8(SRC_DEST_R0L, cmd.Op2);
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xF0        0111 1100   1111 0000   ABS16 ABS20  LDCTX          ABS16, ABS20
  M16C_LDCTX_ABS16_ABS20 = (0x7C 0xF0) @ {
    cmd.itype = M16C_xx_LDCTX_ABS16_ABS20;
    MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
    MakeSrcDest8(SRC_DEST_ABS20, cmd.Op2);
  };

#//   0x7C 0xF1        0111 1100   1111 0001                RMPA.B
  M16C_RMPA_B = (0x7C 0xF1) @ {
    cmd.itype = M16C_xx_RMPA_B;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7C 0xF2        0111 1100   1111 0010   __#IMM8__    ENTER          #IMM8
  M16C_ENTER_IMM8 = (0x7C 0xF2) @ {
    cmd.itype = M16C_xx_ENTER_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0x7C 0xF3        0111 1100   1111 0011                EXTS.W         R0
  M16C_EXTS_W_R0 = (0x7C 0xF3) @ {
    cmd.itype = M16C_xx_EXTS_W_R0;
    MakeSrcDest16(SRC_DEST_R0, cmd.Op1);
  };

#//   0x7D 0x00..0x0F  0111 1101   0000 _SRC                JMPI.A         SRC
  M16C_JMPI_A_SRC = (0x7D 0x00..0x0F) @ {
    cmd.itype = M16C_xx_JMPI_A_SRC;
    MakeSrcDest32(*p & 0x0F, cmd.Op1);
  };

#//   0x7D 0x10..0x1F  0111 1101   0001 _SRC                JSRI.A         SRC
  M16C_JSRI_A_SRC = (0x7D 0x10..0x1F) @ {
    cmd.itype = M16C_xx_JSRI_A_SRC;
    MakeSrcDest32(*p & 0x0F, cmd.Op1);
  };

#//   0x7D 0x20..0x2F  0111 1101   0010 _SRC                JMPI.W         SRC
  M16C_JMPI_W_SRC = (0x7D 0x20..0x2F) @ {
    cmd.itype = M16C_xx_JMPI_W_SRC;
    MakeSrcDest16(*p & 0x0F, cmd.Op1);
  };

#//   0x7D 0x30..0x3F  0111 1101   0011 _SRC                JSRI.W         SRC
  M16C_JSRI_W_SRC = (0x7D 0x30..0x3F) @ {
    cmd.itype = M16C_xx_JSRI_W_SRC;
    MakeSrcDest16(*p & 0x0F, cmd.Op1);
  };

#//   0x7D 0x40..0x4F  0111 1101   0100 DEST   __#IMM16_    MULU.W         #IMM16, DEST
  M16C_MULU_W_IMM16_DEST = (0x7D 0x40..0x4F) @ {
    cmd.itype = M16C_xx_MULU_W_IMM16_DEST;
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0x50..0x5F  0111 1101   0101 DEST   __#IMM16_    MUL.W          #IMM16, DEST
  M16C_MUL_W_IMM16_DEST = (0x7D 0x50..0x5F) @ {
    cmd.itype = M16C_xx_MUL_W_IMM16_DEST;
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0x90..0x9F  0111 1101   1001 _SRC                PUSHA          SRC
  M16C_PUSHA_SRC = (0x7D 0x90..0x9F) @ {
    cmd.itype = M16C_xx_PUSHA_SRC;
    MakeSrcDest8(*p & 0x0F, cmd.Op1);
  };

#//   0x7D 0xA0..0xAF  0111 1101   1010 0#IM                LDIPL          #IMM
  M16C_LDIPL_IMM = (0x7D 0xA0..0xA7) @ {
    cmd.itype = M16C_xx_LDIPL_IMM;
    MakeImm4(*p & 0x07, cmd.Op1);
  };

#//   0x7D 0xB0..0xBF  0111 1101   1011 #IMM                ADD.B:Q        #IMM4, SP
  M16C_ADD_B_Q_IMM4_SP = (0x7D 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_ADD_B_Q_IMM4_SP;
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rSP;
    MakeImm4(*p & 0x0F, cmd.Op1);
  };

#//   0x7D 0xC8        0111 1101   1100 1000   __DSP8___    JLE            LABEL
  M16C_JLE_LABEL = (0x7D 0xC8) @ {
    cmd.itype = M16C_xx_JLE_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op1);
  };

#//   0x7D 0xC9        0111 1101   1100 1001   __DSP8___    JO             LABEL
  M16C_JO_LABEL = (0x7D 0xC9) @ {
    cmd.itype = M16C_xx_JO_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op1);
  };

#//   0x7D 0xCA        0111 1101   1100 1010   __DSP8___    JGE            LABEL
  M16C_JGE_LABEL = (0x7D 0xCA) @ {
    cmd.itype = M16C_xx_JGE_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op1);
  };

#//   0x7D 0xCC        0111 1101   1100 1100   __DSP8___    JGT            LABEL
  M16C_JGT_LABEL = (0x7D 0xCC) @ {
    cmd.itype = M16C_xx_JGT_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op1);
  };

#//   0x7D 0xCD        0111 1101   1100 1101   __DSP8___    JNO            LABEL
  M16C_JNO_LABEL = (0x7D 0xCD) @ {
    cmd.itype = M16C_xx_JNO_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op1);
  };

#//   0x7D 0xCE        0111 1101   1100 1110   __DSP8___    JLT            LABEL
  M16C_JLT_LABEL = (0x7D 0xCE) @ {
    cmd.itype = M16C_xx_JLT_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op1);
  };

#//   0x7D 0xD0        0111 1101   1101 0000                BMGEU / BMC    C
  M16C_BMC_C = (0x7D 0xD0) @ {
    cmd.itype = M16C_xx_BMC_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD1        0111 1101   1101 0001                BMGTU          C
  M16C_BMGTU_C = (0x7D 0xD1) @ {
    cmd.itype = M16C_xx_BMGTU_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD2        0111 1101   1101 0010                BMEQ  / BMZ    C
  M16C_BMZ_C = (0x7D 0xD2) @ {
    cmd.itype = M16C_xx_BMZ_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD3        0111 1101   1101 0011                BMN            C
  M16C_BMN_C = (0x7D 0xD3) @ {
    cmd.itype = M16C_xx_BMN_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD4        0111 1101   1101 0100                BMLTU / BMNC   C
  M16C_BMNC_C = (0x7D 0xD4) @ {
    cmd.itype = M16C_xx_BMNC_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD5        0111 1101   1101 0101                BMLEU          C
  M16C_BMLEU_C = (0x7D 0xD5) @ {
    cmd.itype = M16C_xx_BMLEU_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD6        0111 1101   1101 0110                BMNE  / BMNZ   C
  M16C_BMNZ_C = (0x7D 0xD6) @ {
    cmd.itype = M16C_xx_BMNZ_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD7        0111 1101   1101 0111                BMPZ           C
  M16C_BMPZ_C = (0x7D 0xD7) @ {
    cmd.itype = M16C_xx_BMPZ_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD8        0111 1101   1101 1000                BMLE           C
  M16C_BMLE_C = (0x7D 0xD8) @ {
    cmd.itype = M16C_xx_BMLE_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xD9        0111 1101   1101 1001                BMGO           C
  M16C_BMGO_C = (0x7D 0xD9) @ {
    cmd.itype = M16C_xx_BMGO_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xDA        0111 1101   1101 1010                BMGE           C
  M16C_BMGE_C = (0x7D 0xDA) @ {
    cmd.itype = M16C_xx_BMGE_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xDC        0111 1101   1101 1100                BMGT           C
  M16C_BMGT_C = (0x7D 0xDC) @ {
    cmd.itype = M16C_xx_BMGT_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xDD        0111 1101   1101 1101                BMNO           C
  M16C_BMNO_C = (0x7D 0xDD) @ {
    cmd.itype = M16C_xx_BMNO_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xDE        0111 1101   1101 1110                BMLT           C
  M16C_BMLT_C = (0x7D 0xDE) @ {
    cmd.itype = M16C_xx_BMLT_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xE0        0111 1101   1110 0000   __#IMM16_    DIVU.W         #IMM16
  M16C_DIVU_W_IMM16 = (0x7D 0xE0) @ {
    cmd.itype = M16C_xx_DIVU_W_IMM16;
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0xE1        0111 1101   1110 0001   __#IMM16_    DIV.W          #IMM16
  M16C_DIV_W_IMM16 = (0x7D 0xE1) @ {
    cmd.itype = M16C_xx_DIV_W_IMM16;
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0xE2        0111 1101   1110 0010   __#IMM16_    PUSH.W:G       #IMM16
  M16C_PUSH_W_G_IMM16 = (0x7D 0xE2) @ {
    cmd.itype = M16C_xx_PUSH_W_G_IMM16;
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0xE3        0111 1101   1110 0011   __#IMM16_    DIVX.W         #IMM16
  M16C_DIVX_W_IMM8 = (0x7D 0xE3) @ {
    cmd.itype = M16C_xx_DIVX_W_IMM8;
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0xE4        0111 1101   1110 0100                DADD.W         R1, R0
  M16C_DADD_W_R1_R0 = (0x7D 0xE4) @ {
    cmd.itype = M16C_xx_DADD_W_R1_R0;
    MakeSrcDest16(SRC_DEST_R1, cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xE5        0111 1101   1110 0101                DSUB.W         R1,  R0
  M16C_DSUB_W_R1_R0 = (0x7D 0xE5) @ {
    cmd.itype = M16C_xx_DSUB_W_R1_R0;
    MakeSrcDest16(SRC_DEST_R1, cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xE6        0111 1101   1110 0110                DADC.W         R1, R0
  M16C_DADC_W_R1_R0 = (0x7D 0xE6) @ {
    cmd.itype = M16C_xx_DADC_W_R1_R0;
    MakeSrcDest16(SRC_DEST_R1, cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xE7        0111 1101   1110 0111                DSBB.W         R1,  R0
  M16C_DSBB_W_R1_R0 = (0x7D 0xE7) @ {
    cmd.itype = M16C_xx_DSBB_W_R1_R0;
    MakeSrcDest16(SRC_DEST_R1, cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xE8        0111 1101   1110 1000                SMOVF.W
  M16C_SMOVF_W = (0x7D 0xE8) @ {
    cmd.itype = M16C_xx_SMOVF_W;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xE9        0111 1101   1110 1001                SMOVB.W
  M16C_SMOVB_W = (0x7D 0xE9) @ {
    cmd.itype = M16C_xx_SMOVB_W;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xEA        0111 1101   1110 1010                SSTR.W
  M16C_SSTR_W = (0x7D 0xEA) @ {
    cmd.itype = M16C_xx_SSTR_W;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xEB        0111 1101   1110 1011   __#IMM16_    ADD.W:G        #IMM16, SP
  M16C_ADD_W_G_IMM16_SP = (0x7D 0xEB) @ {
    cmd.itype = M16C_xx_ADD_W_G_IMM16_SP;
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rSP;
    MakeImm16(cmd.Op1);
  };

#//   0x7D 0xEC        0111 1101   1110 1100   __#IMM16_    DADD.W         #IMM16, R0
  M16C_DADD_W_IMM16_R0 = (0x7D 0xEC) @ {
    cmd.itype = M16C_xx_DADD_W_IMM16_R0;
    MakeImm16(cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xED        0111 1101   1110 1101   __#IMM16_    DSUB.W         #IMM16, R0
  M16C_DSUB_W_IMM16_R0 = (0x7D 0xED) @ {
    cmd.itype = M16C_xx_DSUB_W_IMM16_R0;
    MakeImm16(cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xEE        0111 1101   1110 1110   __#IMM16_    DADC.W         #IMM16, R0
  M16C_DADC_W_IMM16_R0 = (0x7D 0xEE) @ {
    cmd.itype = M16C_xx_DADC_W_IMM16_R0;
    MakeImm16(cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xEF        0111 1101   1110 1111   __#IMM16_    DSBB.W         #IMM16, R0
  M16C_DSBB_W_IMM16_R0 = (0x7D 0xEF) @ {
    cmd.itype = M16C_xx_DSBB_W_IMM16_R0;
    MakeImm16(cmd.Op1);
    MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
  };

#//   0x7D 0xF0        0111 1101   1111 0000  ABS16  ABS20  STCTX          ABS16, ABS20
  M16C_STCTX_ABS16_ABS20 = (0x7D 0xF0) @ {
    cmd.itype = M16C_xx_STCTX_ABS16_ABS20;
    MakeSrcDest8(SRC_DEST_ABS16, cmd.Op1);
    MakeSrcDest8(SRC_DEST_ABS20, cmd.Op2);
  };

#//   0x7D 0xF1        0111 1101   1111 0001                RMPA.W
  M16C_RMPA_W = (0x7D 0xF1) @ {
    cmd.itype = M16C_xx_RMPA_W;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xF2        0111 1101   1111 0010                EXITD
  M16C_EXITD = (0x7D 0xF2) @ {
    cmd.itype = M16C_xx_EXITD;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7D 0xF3        0111 1101   1111 0011                WAIT
  M16C_WAIT = (0x7D 0xF3) @ {
    cmd.itype = M16C_xx_WAIT;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0x7E 0x00..0x0F   0111 1110   0000 DEST                BTSTC          DEST
  M16C_BTSTC_DEST = (0x7E 0x00..0x0F) @ {
    cmd.itype = M16C_xx_BTSTC_DEST;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x10..0x1F   0111 1110   0001 DEST                BTSTS          DEST
  M16C_BTSTS_DEST = (0x7E 0x10..0x1F) @ {
    cmd.itype = M16C_xx_BTSTS_DEST;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//+   0x7E 0x20..0x2F 0x00  0111 1110   0010 DEST   0000 0000    BMGEU / BMC    DEST
# M16C_BMC_DEST = (0x7E 0x20..0x2F 0x00) @ {
#   cmd.itype = M16C_xx_BMC_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0x01  0111 1110   0010 DEST   0000 0001    BMGTU          DEST
# M16C_BMGTU_DEST = (0x7E 0x20..0x2F 0x01) @ {
#   cmd.itype = M16C_xx_BMGTU_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0x02  0111 1110   0010 DEST   0000 0010    BMEQ  / BMZ    DEST
# M16C_BMZ_DEST = (0x7E 0x20..0x2F 0x02) @ {
#   cmd.itype = M16C_xx_BMZ_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0x03  0111 1110   0010 DEST   0000 0011    BMN            DEST
# M16C_BMN_DEST = (0x7E 0x20..0x2F 0x03) @ {
#   cmd.itype = M16C_xx_BMN_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0x04  0111 1110   0010 DEST   0000 0100    BMLE           DEST
# M16C_BMLE_DEST = (0x7E 0x20..0x2F 0x04) @ {
#   cmd.itype = M16C_xx_BMLE_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0x05  0111 1110   0010 DEST   0000 0101    BMO            DEST
# M16C_BMO_DEST = (0x7E 0x20..0x2F 0x05) @ {
#   cmd.itype = M16C_xx_BMO_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0x06  0111 1110   0010 DEST   0000 0110    BMGE           DEST
# M16C_BMGE_DEST = (0x7E 0x20..0x2F 0x06) @ {
#   cmd.itype = M16C_xx_BMGE_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xF8  0111 1110   0010 DEST   1111 1000    BMLTU / BMNC   DEST
# M16C_BMNC_DEST = (0x7E 0x20..0x2F 0xF8) @ {
#   cmd.itype = M16C_xx_BMNC_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xF9  0111 1110   0010 DEST   1111 1001    BMLEU          DEST
# M16C_BMLEU_DEST = (0x7E 0x20..0x2F 0xF9) @ {
#   cmd.itype = M16C_xx_BMLEU_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xFA  0111 1110   0010 DEST   1111 1010    BMNE  / BMNZ   DEST
# M16C_BMNZ_DEST = (0x7E 0x20..0x2F 0xFA) @ {
#   cmd.itype = M16C_xx_BMNZ_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xFB  0111 1110   0010 DEST   1111 1011    BMPZ           DEST
# M16C_BMPZ_DEST = (0x7E 0x20..0x2F 0xFB) @ {
#   cmd.itype = M16C_xx_BMPZ_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xFC  0111 1110   0010 DEST   1111 1100    BMGT           DEST
# M16C_BMGT_DEST = (0x7E 0x20..0x2F 0xFC) @ {
#   cmd.itype = M16C_xx_BMGT_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xFD  0111 1110   0010 DEST   1111 1101    BMNO           DEST
# M16C_BMNO_DEST = (0x7E 0x20..0x2F 0xFD) @ {
#   cmd.itype = M16C_xx_BMNO_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//+   0x7E 0x20..0x2F 0xFE  0111 1110   0010 DEST   1111 1110    BMLT           DEST
# M16C_BMLT_DEST = (0x7E 0x20..0x2F 0xFE) @ {
#   cmd.itype = M16C_xx_BMLT_DEST;
#   MakeSrcDest16(*p & 0x0F, cmd.Op1);
# };
#
#//   0x7E 0x20..0x2F 0111 1110  0010 DEST __VAL__  __Cnd__      BMCnd          DEST
  M16C_BMCnd_DEST = (0x7E 0x20..0x2F) @ {
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
    switch(ua_next_byte()) {
      case 0x00:
        cmd.itype = M16C_xx_BMC_DEST;
        break;
      case 0x01:
        cmd.itype = M16C_xx_BMGTU_DEST;
        break;
      case 0x02:
        cmd.itype = M16C_xx_BMZ_DEST;
        break;
      case 0x03:
        cmd.itype = M16C_xx_BMN_DEST;
        break;
      case 0x04:
        cmd.itype = M16C_xx_BMLE_DEST;
        break;
      case 0x05:
        cmd.itype = M16C_xx_BMO_DEST;
        break;
      case 0x06:
        cmd.itype = M16C_xx_BMGE_DEST;
        break;
      case 0xF8:
        cmd.itype = M16C_xx_BMNC_DEST;
        break;
      case 0xF9:
        cmd.itype = M16C_xx_BMLEU_DEST;
        break;
      case 0xFA:
        cmd.itype = M16C_xx_BMNZ_DEST;
        break;
      case 0xFB:
        cmd.itype = M16C_xx_BMPZ_DEST;
        break;
      case 0xFC:
        cmd.itype = M16C_xx_BMGT_DEST;
        break;
      case 0xFD:
        cmd.itype = M16C_xx_BMNO_DEST;
        break;
      case 0xFE:
        cmd.itype = M16C_xx_BMLT_DEST;
        break;
    }
  };

#//   0x7E 0x30..0x3F   0111 1110   0011 _SRC                BNTST          SRC
  M16C_BNTST_SRC = (0x7E 0x30..0x3F) @ {
    cmd.itype = M16C_xx_BNTST_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x40..0x4F   0111 1110   0100 _SRC                BAND           SRC
  M16C_BAND_SRC = (0x7E 0x40..0x4F) @ {
    cmd.itype = M16C_xx_BAND_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x50..0x5F   0111 1110   0101 _SRC                BNAND          SRC
  M16C_BNAND_SRC = (0x7E 0x50..0x5F) @ {
    cmd.itype = M16C_xx_BNAND_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x60..0x6F   0111 1110   0110 _SRC                BOR            SRC
  M16C_BOR_SRC = (0x7E 0x60..0x6F) @ {
    cmd.itype = M16C_xx_BOR_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x70..0x7F   0111 1110   0111 _SRC                BNOR           SRC
  M16C_BNOR_SRC = (0x7E 0x70..0x7F) @ {
    cmd.itype = M16C_xx_BNOR_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x80..0x8F   0111 1110   1000 DEST                BCLR:G         DEST
  M16C_BCLR_G_DEST = (0x7E 0x80..0x8F) @ {
    cmd.itype = M16C_xx_BCLR_G_DEST;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0x90..0x9F   0111 1110   1001 DEST                BSET:G         DEST
  M16C_BSET_G_DEST = (0x7E 0x90..0x9F) @ {
    cmd.itype = M16C_xx_BSET_G_DEST;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0xA0..0xAF   0111 1110   1010 DEST                BNOT:G         DEST
  M16C_BNOT_G_DEST = (0x7E 0xA0..0xAF) @ {
    cmd.itype = M16C_xx_BNOT_G_DEST;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0xB0..0xBF   0111 1110   1011 _SRC                BTST:G         SRC
  M16C_BTST_G_SRC = (0x7E 0xB0..0xBF) @ {
    cmd.itype = M16C_xx_BTST_G_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0xC0..0xCF   0111 1110   1100 _SRC                BXOR           SRC
  M16C_BXOR_SRC = (0x7E 0xC0..0xCF) @ {
    cmd.itype = M16C_xx_BXOR_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x7E 0xD0..0xDF   0111 1110   1101 _SRC                BNXOR          SRC
  M16C_BNXOR_SRC = (0x7E 0xD0..0xDF) @ {
    cmd.itype = M16C_xx_BNXOR_SRC;
    MakeBitsSrcDest(*p & 0x0F, cmd.Op1, cmd.Op2);
  };

#//   0x80             1000 0000   _SRC DEST                TST.B          SRC, DEST
  M16C_TST_B_SRC_DEST = (0x80) @ {
    cmd.itype = M16C_xx_TST_B_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0x81             1000 0001   _SRC DEST                TST.W          SRC, DEST
  M16C_TST_W_SRC_DEST = (0x81) @ {
    cmd.itype = M16C_xx_TST_W_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0x83..0x87       1000 0DST   __#IMM8__                ADD.B:S        #IMM8, DEST
  M16C_ADD_B_S_IMM8_DEST = (0x83..0x87) @ {
    cmd.itype = M16C_xx_ADD_B_S_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0x88             1000 1000   _SRC DEST                XOR.B          SRC, DEST
  M16C_XOR_B_SRC_DEST = (0x88 any) @ {
    cmd.itype = M16C_xx_XOR_B_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0x89             1000 1001   _SRC DEST                XOR.W          SRC, DEST
  M16C_XOR_W_SRC_DEST = (0x89) @ {
    cmd.itype = M16C_xx_XOR_W_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0x82|0x8A        1000 S010                            PUSH.B:S       SRC (S - SRC)
  M16C_PUSH_B_S_SRC = (0x82|0x8A) @ {
    cmd.itype = M16C_xx_PUSH_B_S_SRC;
    if((*p & 0x08) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
  };

#//   0x8B..0x8F       1000 1DST   __#IMM8__                SUB.B:S        #IMM8, DEST
  M16C_SUB_B_S_IMM8_DEST = (0x8B..0x8F) @ {
    cmd.itype = M16C_xx_SUB_B_S_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0x90             1001 0000   _SRC DEST                AND.B:G        SRC, DEST
  M16C_AND_B_G_SRC_DEST = (0x90 any) @ {
    cmd.itype = M16C_xx_AND_B_G_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0x91             1001 0001   _SRC DEST                AND.W:G        SRC, DEST
  M16C_AND_W_G_SRC_DEST = (0x91) @ {
    cmd.itype = M16C_xx_AND_W_G_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0x93..0x97       1001 0DST   __#IMM8__                AND.B:S        #IMM8, DEST
  M16C_AND_B_S_IMM8_DEST = (0x93..0x97) @ {
    cmd.itype = M16C_xx_AND_B_S_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0x98             1001 1000   _SRC DEST                OR.B:G         SRC, DEST
  M16C_OR_B_G_SRC_DEST = (0x98 any) @ {
    cmd.itype = M16C_xx_OR_B_G_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0x92|0x9A        1001 D010                            POP.B:S        DEST (D - DEST)
  M16C_POP_B_S_DEST = (0x92|0x9A) @ {
    cmd.itype = M16C_xx_POP_B_S_DEST;
    if((*p & 0x08) == 0)
      MakeSrcDest8(SRC_DEST_R0L, cmd.Op1);
    else
      MakeSrcDest8(SRC_DEST_R0H, cmd.Op1);
  };

#//   0x9B..0x9F       1001 1DST   __#IMM8__                OR.B:S         #IMM8, DEST
  M16C_OR_B_S_IMM8_DEST = (0x98..0x9F) @ {
    cmd.itype = M16C_xx_OR_B_S_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0xA0             1010 0000   _SRC DEST                ADD.B:G        SRC, DEST
  M16C_ADD_B_G_SRC_DEST = (0xA0 any) @ {
    cmd.itype = M16C_xx_ADD_B_G_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xA1             1010 0001   _SRC DEST                ADD.W:G        SRC, DEST
  M16C_ADD_W_G_SRC_DEST = (0xA1 any) @ {
    cmd.itype = M16C_xx_ADD_W_G_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xA2             1010 0010   __#IMM8__                MOV.W:S        #IMM16, A0
  M16C_MOV_W_S_IMM16_A0 = (0xA2) @ {
    cmd.itype = M16C_xx_MOV_W_S_IMM16_A0;
    MakeImm16(cmd.Op1);
    MakeSrcDest16(SRC_DEST_A0, cmd.Op2);
  };

#//   0xA0..0xA7       1010 0DST                            INC.B          DEST
  M16C_INC_B_DEST = (0xA3..0xA7) @ {
    cmd.itype = M16C_xx_INC_B_DEST;
    MakeSrcDest3bit(*p & 0x07, cmd.Op1);
  };

#//   0xA8             1010 1000   _SRC DEST                SUB.B:G        SRC, DEST
  M16C_SUB_B_G_SRC_DEST = (0xA8 any) @ {
    cmd.itype = M16C_xx_SUB_B_G_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xA9             1010 1001   _SRC DEST                SUB.W:G        SRC, DEST
  M16C_SUB_W_G_SRC_DEST = (0xA9 any) @ {
    cmd.itype = M16C_xx_SUB_W_G_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xAA             1010 1010   __#IMM8__                MOV.W:S        #IMM16, A1
  M16C_MOV_W_S_IMM16_A1 = (0xAA) @ {
    cmd.itype = M16C_xx_MOV_W_S_IMM16_A1;
    MakeImm16(cmd.Op1);
    MakeSrcDest16(SRC_DEST_A1, cmd.Op2);
  };

#//   0xAB..0xAF       1010 1DST                            DEC.B          DEST
  M16C_DEC_B_DEST = (0xAB..0xAF) @ {
    cmd.itype = M16C_xx_DEC_B_DEST;
    MakeSrcDest3bit(*p & 0x07, cmd.Op1);
  };

#//   0xB0             1011 0000   _SRC DEST                ADC.B          SRC, DEST
  M16C_ADC_B_SRC_DEST = (0xB0 any) @ {
    cmd.itype = M16C_xx_ADC_B_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xB1             1011 0001   _SRC DEST                ADC.W          SRC, DEST
  M16C_ADC_W_SRC_DEST = (0xB1 any) @ {
    cmd.itype = M16C_xx_ADC_W_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xB2             1011 0010                            INC.W          A0
  M16C_INC_W_A0 = (0xB2) @ {
    cmd.itype = M16C_xx_INC_W_A0;
    MakeSrcDest16(SRC_DEST_A0, cmd.Op1);
  };

#//   0xB3..0xB7       1011 0DST                            MOV.B:Z        #0,  DEST
  M16C_MOV_B_Z_0_DEST = (0xB3..0xB7) @ {
    cmd.itype = M16C_xx_MOV_B_Z_0_DEST;
    MakeImm4(0, cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0xB8             1011 1000   _SRC DEST                SBB.B          SRC. DEST
  M16C_SBB_B_SRC_DEST = (0xB8 any) @ {
    cmd.itype = M16C_xx_SBB_B_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xB9             1011 1001   _SRC DEST                SBB.W          SRC. DEST
  M16C_SBB_W_SRC_DEST = (0xB9 any) @ {
    cmd.itype = M16C_xx_SBB_W_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xBA             1011 1010                            INC.W          A1
  M16C_INC_W_A1 = (0xBA) @ {
    cmd.itype = M16C_xx_INC_W_A1;
    MakeSrcDest16(SRC_DEST_A1, cmd.Op1);
  };

#//   0xBB..0xBF       1011 1DST                            NOT.B:S        DEST
  M16C_NOT_B_S_DEST = (0xBB..0xBF) @ {
    cmd.itype = M16C_xx_NOT_B_S_DEST;
    MakeSrcDest3bit(*p & 0x07, cmd.Op1);
  };

#//   0xC0             1100 0000   _SRC DEST                CMP.B:G        SRC, DEST
  M16C_CMP_B_G_SRC_DEST = (0xC0 any) @ {
    cmd.itype = M16C_xx_CMP_B_G_SRC_DEST;
    MakeSrcDest8((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xC1             1100 0001   _SRC DEST                CMP.W:G        SRC, DEST
  M16C_CMP_W_G_SRC_DEST = (0xC1 any) @ {
    cmd.itype = M16C_xx_CMP_W_G_SRC_DEST;
    MakeSrcDest16((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xC3..0xC7       1100 0DST   __#IMM8__                MOV.B:S        #IMM8, DEST
  M16C_MOV_B_S_IMM8_DEST = (0xC3..0xC7) @ {
    cmd.itype = M16C_xx_MOV_B_S_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0xC8             1100 1000   #IMM DEST                ADD.B:Q        #IMM4, DEST
  M16C_ADD_B_Q_IMM4_DEST = (0xC8 any) @ {
    cmd.itype = M16C_xx_ADD_B_Q_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xC9             1100 1001   #IMM DEST                ADD.W:Q        #IMM4, DEST
  M16C_ADD_W_Q_IMM4_DEST = (0xC9 any) @ {
    cmd.itype = M16C_xx_ADD_W_Q_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xC2|0xCA        1100 S010                            PUSH.W:S       SRC (S - SRC)
  M16C_PUSH_W_S_SRC = (0xC2|0xCA) @ {
    cmd.itype = M16C_xx_PUSH_W_S_SRC;
    if((*p & 0x08) == 0)
      MakeSrcDest16(SRC_DEST_A0, cmd.Op1);
    else
      MakeSrcDest16(SRC_DEST_A1, cmd.Op1);
  };

#//   0xCB..0xCF       1100 1DST   __#IMM8__                STZ            #IMM8, DEST
  M16C_STZ_IMM8_DEST = (0xCB..0xCF) @ {
    cmd.itype = M16C_xx_STZ_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0xD0             1101 0000   #IMM DEST                CMP.B:Q        #IMM4, DEST
  M16C_CMP_B_Q_IMM4_DEST = (0xD0 any) @ {
    cmd.itype = M16C_xx_CMP_B_Q_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xD1             1101 0001   #IMM DEST                CMP.W:Q        #IMM4, DEST
  M16C_CMP_W_Q_IMM4_DEST = (0xD1 any) @ {
    cmd.itype = M16C_xx_CMP_W_Q_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xD3..0xD7       1101 0DST   __#IMM8__                STNZ           #IMM8, DEST
  M16C_STNZ_IMM8_DEST = (0xD3..0xD7) @ {
    cmd.itype = M16C_xx_STNZ_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0xD8             1101 1000   #IMM DEST                MOV.B:Q        #IMM4, DEST
  M16C_MOV_B_Q_IMM4_DEST = (0xD8 any) @ {
    cmd.itype = M16C_xx_MOV_B_Q_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xD9             1101 1001   #IMM DEST                MOV.W:Q        #IMM4, DEST
  M16C_MOV_W_Q_IMM4_DEST = (0xD9 any) @ {
    cmd.itype = M16C_xx_MOV_W_Q_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xD2|0xDA        1101 D010                            POP.W:S        DEST (D - DEST)
  M16C_POP_W_S_DEST = (0xD2|0xDA) @ {
    cmd.itype = M16C_xx_POP_W_S_DEST;
    if((*p & 0x08) == 0)
      MakeSrcDest16(SRC_DEST_A0, cmd.Op1);
    else
      MakeSrcDest16(SRC_DEST_A1, cmd.Op1);
  };

#//   0xDB..0xDF       1101 1DST   __#IMM81_  __#IMM82_     STZX           #IMM81, #IMM82, DEST
  M16C_STZX_IMM81_IMM82_DEST = (0xDB..0xDF) @ {
    cmd.itype = M16C_xx_STZX_IMM81_IMM82_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op3);
    MakeImm8(cmd.Op2);
  };

#//   0xE0             1110 0000   #IMM DEST                ROT.B          #IMM4, DEST
  M16C_ROT_B_IMM4_DEST = (0xE0 any) @ {
    cmd.itype = M16C_xx_ROT_B_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xE1             1110 0001   #IMM DEST                ROT.W          #IMM4, DEST
  M16C_ROT_W_IMM4_DEST = (0xE1) @ {
    cmd.itype = M16C_xx_ROT_W_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xE2             1110 0010   __#IMM8__                MOV.B:S        #IMM8, A0
  M16C_MOV_B_S_IMM8_A0 = (0xE2) @ {
    cmd.itype = M16C_xx_MOV_B_S_IMM8_A0;
    MakeImm8(cmd.Op1);
    MakeSrcDest16(SRC_DEST_A0, cmd.Op2);
  };

#//   0xE3..0xE7       1110 0DST   __#IMM8__                CMP.B:S        #IMM8,  DEST
  M16C_CMP_B_S_IMM8_DEST = (0xE3..0xE7) @ {
    cmd.itype = M16C_xx_CMP_B_S_IMM8_DEST;
    MakeImm8(cmd.Op1);
    MakeSrcDest3bit(*p & 0x07, cmd.Op2);
  };

#//   0xE8             1110 1000   #IMM DEST                SHL.B          #IMM4, DEST
  M16C_SHL_B_IMM4_DEST = (0xE8 any) @ {
    cmd.itype = M16C_xx_SHL_B_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xE9             1110 1001   #IMM DEST                SHL.W          #IMM4, DEST
  M16C_SHL_W_IMM4_DEST = (0xE9 any) @ {
    cmd.itype = M16C_xx_SHL_W_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xEA             1110 1010   __#IMM8__                MOV.B:S        #IMM8, A1
  M16C_MOV_B_S_IMM8_A1 = (0xEA) @ {
    cmd.itype = M16C_xx_MOV_B_S_IMM8_A1;
    MakeImm8(cmd.Op1);
    MakeSrcDest16(SRC_DEST_A1, cmd.Op2);
  };

#//   0xEB 0x04         1110 1011   0000 0100                FSET           C
  M16C_FSET_C = (0xEB 0x04) @ {
    cmd.itype = M16C_xx_FSET_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x05         1110 1011   0000 0101                FCLR           C
  M16C_FCLR_C = (0xEB 0x05) @ {
    cmd.itype = M16C_xx_FCLR_C;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x10         1110 1011   0001 0000   __#IMM16_    LDC            #IMM16, INTBL
  M16C_LDC_IMM16_INTBL = (0xEB 0x10) @ {
    cmd.itype = M16C_xx_LDC_IMM16_INTBL;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rINTBL;
  };

#//   0xEB 0x01|0x11    1110 1011   000D 0001                SHL.L          R1H, DEST (D - DEST)
  M16C_SHL_L_R1H_DEST = (0xEB 0x01|0x11) @ {
    cmd.itype = M16C_xx_SHL_L_R1H_DEST;
    MakeSrcDest8(SRC_DEST_R1H, cmd.Op1);
    if((*p & 0x10) == 0)
      MakeSrcDest32(SRC_DEST_R2R0, cmd.Op2);
    else
      MakeSrcDest32(SRC_DEST_R3R1, cmd.Op2);
  };

#//   0xEB 0x14         1110 1011   0001 0100                FSET           D
  M16C_FSET_D = (0xEB 0x14) @ {
    cmd.itype = M16C_xx_FSET_D;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x15         1110 1011   0001 0101                FCLR           D
  M16C_FCLR_D = (0xEB 0x15) @ {
    cmd.itype = M16C_xx_FCLR_D;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x20         1110 1011   0010 0000   __#IMM16_    LDC            #IMM16, INTBH
  M16C_LDC_IMM16_INTBH = (0xEB 0x20) @ {
    cmd.itype = M16C_xx_LDC_IMM16_INTBH;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rINTBH;
  };

#//   0xEB 0x24         1110 1011   0010 0100                FSET           Z
  M16C_FSET_Z = (0xEB 0x24) @ {
    cmd.itype = M16C_xx_FSET_Z;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x25         1110 1011   0010 0101                FCLR           Z
  M16C_FCLR_Z = (0xEB 0x25) @ {
    cmd.itype = M16C_xx_FCLR_Z;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x30         1110 1011   0011 0000   __#IMM16_    LDC            #IMM16, FLG
  M16C_LDC_IMM16_FLG = (0xEB 0x30) @ {
    cmd.itype = M16C_xx_LDC_IMM16_FLG;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rFLG;
  };

#//   0xEB 0x21|0x31    1110 1011   001D 0001                SHA.L          R1H, DEST (D - DEST)
  M16C_SHA_L_R1H_DEST = (0xEB 0x21|0x31) @ {
    cmd.itype = M16C_xx_SHA_L_R1H_DEST;
    MakeSrcDest8(SRC_DEST_R1H, cmd.Op1);
    if((*p & 0x10) == 0)
      MakeSrcDest32(SRC_DEST_R2R0, cmd.Op2);
    else
      MakeSrcDest32(SRC_DEST_R3R1, cmd.Op2);
  };

#//   0xEB 0x34         1110 1011   0011 0100                FSET           S
  M16C_FSET_S = (0xEB 0x34) @ {
    cmd.itype = M16C_xx_FSET_S;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x35         1110 1011   0011 0101                FCLR           S
  M16C_FCLR_S = (0xEB 0x35) @ {
    cmd.itype = M16C_xx_FCLR_S;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x40         1110 1011   0100 0000   __#IMM16_    LDC            #IMM16, ISP
  M16C_LDC_IMM16_ISP = (0xEB 0x40) @ {
    cmd.itype = M16C_xx_LDC_IMM16_ISP;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rISP;
  };

#//   0xEB 0x44         1110 1011   0100 0100                FSET           B
  M16C_FSET_B = (0xEB 0x44) @ {
    cmd.itype = M16C_xx_FSET_B;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x45         1110 1011   0100 0101                FCLR           B
  M16C_FCLR_B = (0xEB 0x45) @ {
    cmd.itype = M16C_xx_FCLR_B;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x50         1110 1011   0101 0000   __#IMM16_    LDC            #IMM16, SP
  M16C_LDC_IMM16_SP = (0xEB 0x50) @ {
    cmd.itype = M16C_xx_LDC_IMM16_SP;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rSP;
  };

#//   0xEB 0x54         1110 1011   0101 0100                FSET           O
  M16C_FSET_O = (0xEB 0x54) @ {
    cmd.itype = M16C_xx_FSET_O;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x55         1110 1011   0101 0101                FCLR           O
  M16C_FCLR_O = (0xEB 0x55) @ {
    cmd.itype = M16C_xx_FCLR_O;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x60         1110 1011   0110 0000   __#IMM16_    LDC            #IMM16, SB
  M16C_LDC_IMM16_SB = (0xEB 0x60) @ {
    cmd.itype = M16C_xx_LDC_IMM16_SB;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rSB;
  };

#//   0xEB 0x64         1110 1011   0110 0100                FSET           I
  M16C_FSET_I = (0xEB 0x64) @ {
    cmd.itype = M16C_xx_FSET_I;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x65         1110 1011   0110 0101                FCLR           I
  M16C_FCLR_I = (0xEB 0x65) @ {
    cmd.itype = M16C_xx_FCLR_I;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x70         1110 1011   0111 0000   __#IMM16_    LDC            #IMM16, FB
  M16C_LDC_IMM16_FB = (0xEB 0x70) @ {
    cmd.itype = M16C_xx_LDC_IMM16_FB;
    MakeImm16(cmd.Op1);
    cmd.Op2.dtyp = dt_word;
    cmd.Op2.type = o_reg;
    cmd.Op2.reg = rFB;
  };

#//   0xEB 0x12|0x22|0x32|0x42|0x52|0x62|0x72   1110 1011   0SRC 0010                PUSHC          SRC
  M16C_PUSHC_SRC = 0xEB (0x12|0x22|0x32|0x42|0x52|0x62|0x72) @ {
    cmd.itype = M16C_xx_PUSHC_SRC;
    cmd.Op1.dtyp = dt_word;
    cmd.Op1.type = o_reg;
    switch(*p & 0x70) {
      case 0x10:
        cmd.Op1.reg = rINTBL;
        break;
      case 0x20:
        cmd.Op1.dtyp = dt_byte;
        cmd.Op1.reg = rINTBH;
        break;
      case 0x30:
        cmd.Op1.reg = rFLG;
        break;
      case 0x40:
        cmd.Op1.reg = rISP;
        break;
      case 0x50:
        cmd.Op1.reg = rSP;
        break;
      case 0x60:
        cmd.Op1.reg = rSB;
        break;
      case 0x70:
        cmd.Op1.reg = rFB;
        break;
    }
  };

#//   0xEB 0x13|0x23|0x33|0x43|0x53|0x63|0x73   1110 1011   0DST 0011                POPC           DEST
  M16C_POPC_DEST = 0xEB (0x13|0x23|0x33|0x43|0x53|0x63|0x73) @ {
    cmd.itype = M16C_xx_POPC_DEST;
    cmd.Op1.dtyp = dt_word;
    cmd.Op1.type = o_reg;
    switch(*p & 0x70) {
      case 0x10:
        cmd.Op1.reg = rINTBL;
        break;
      case 0x20:
        cmd.Op1.dtyp = dt_byte;
        cmd.Op1.reg = rINTBH;
        break;
      case 0x30:
        cmd.Op1.reg = rFLG;
        break;
      case 0x40:
        cmd.Op1.reg = rISP;
        break;
      case 0x50:
        cmd.Op1.reg = rSP;
        break;
      case 0x60:
        cmd.Op1.reg = rSB;
        break;
      case 0x70:
        cmd.Op1.reg = rFB;
        break;
    }
  };

#//   0xEB 0x74         1110 1011   0111 0100                FSET           U
  M16C_FSET_U = (0xEB 0x74) @ {
    cmd.itype = M16C_xx_FSET_U;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB 0x75         1110 1011   0111 0101                FCLR           U
  M16C_FCLR_U = (0xEB 0x75) @ {
    cmd.itype = M16C_xx_FCLR_U;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xEB ((0x08..0x0F)|(0x18..0x1F)|(0x28..0x2F)|(0x38..0x3F)|(0x48..0x4F)|(0x58..0x5F))   1110 1011   0DST _SRC                MOVA           SRC, DEST
  M16C_MOVA_SRC_DEST = (0xEB ((0x08..0x0F)|(0x18..0x1F)|(0x28..0x2F)|(0x38..0x3F)|(0x48..0x4F)|(0x58..0x5F))) @ {
    cmd.itype = M16C_xx_MOVA_SRC_DEST;
    MakeSrcDest16(*p & 0x0F, cmd.Op1);
    switch(*p & 0x70) {
      case 0x00:
        MakeSrcDest16(SRC_DEST_R0, cmd.Op2);
        break;
      case 0x10:
        MakeSrcDest16(SRC_DEST_R1, cmd.Op2);
        break;
      case 0x20:
        MakeSrcDest16(SRC_DEST_R2, cmd.Op2);
        break;
      case 0x30:
        MakeSrcDest16(SRC_DEST_R3, cmd.Op2);
        break;
      case 0x40:
        MakeSrcDest16(SRC_DEST_A0, cmd.Op2);
        break;
      case 0x50:
        MakeSrcDest16(SRC_DEST_A1, cmd.Op2);
        break;
    }
  };

#//   0xEB 0x80..0x9F   1110 1011   100D #IMM                SHL.L          #IMM4, DEST (D - DEST)
  M16C_SHL_L_IMM4_DEST = (0xEB 0x80..0x9F) @ {
    cmd.itype = M16C_xx_SHL_L_IMM4_DEST;
    MakeImm4(*p & 0x0F, cmd.Op1);
    if((*p & 0x10) == 0)
      MakeSrcDest32(SRC_DEST_R2R0, cmd.Op2);
    else
      MakeSrcDest32(SRC_DEST_R3R1, cmd.Op2);
  };

#//   0xEB 0xA0..0xBF   1110 1011   101D #IMM                SHA.L          #IMM4, DEST (D - DEST)
  M16C_SHA_L_IMM4_DEST = (0xEB 0xA0..0xBF) @ {
    cmd.itype = M16C_xx_SHA_L_IMM4_DEST;
    MakeImm4(*p & 0x0F, cmd.Op1);
    if((*p & 0x10) == 0)
      MakeSrcDest32(SRC_DEST_R2R0, cmd.Op2);
    else
      MakeSrcDest32(SRC_DEST_R3R1, cmd.Op2);
  };

#//   0xEB 0xC0..0xFF   1110 1011   11__#IMM_                INT            #IMM
  M16C_INT_IMM = (0xEB 0xC0..0xFF) @ {
    cmd.itype = M16C_xx_INT_IMM;
    MakeImm4(*p & 0x7F, cmd.Op1);
  };

#//   0xEC              1110 1100   ___SRC___                PUSHM          SRC
  M16C_PUSHM_SRC = (0xEC) @ {
    cmd.itype = M16C_xx_PUSHM_SRC;
    MakeImm8(cmd.Op1);
  };

#//   0xED              1110 1101   __DEST___                POPM           DEST
  M16C_POPM_DEST = (0xED) @ {
    cmd.itype = M16C_xx_POPM_DEST;
    MakeImm8(cmd.Op1);
  };

#//   0xEE              1110 1110   __#IMM8__                JMPS           #IMM8
  M16C_JMPS_IMM8 = (0xEE) @ {
    cmd.itype = M16C_xx_JMPS_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0xEF              1110 1111   __#IMM8__                JSRS           #IMM8
  M16C_JSRS_IMM8 = (0xEF) @ {
    cmd.itype = M16C_xx_JSRS_IMM8;
    MakeImm8(cmd.Op1);
  };

#//   0xF0              1111 0000   #IMM DEST                SHA.B          #IMM4, DEST
  M16C_SHA_B_IMM4_DEST = (0xF0 any) @ {
    cmd.itype = M16C_xx_SHA_B_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
  };

#//   0xF1              1111 0001   #IMM DEST                SHA.W          #IMM4, DEST
  M16C_SHA_W_IMM4_DEST = (0xF1 any) @ {
    cmd.itype = M16C_xx_SHA_W_IMM4_DEST;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
  };

#//   0xF2              1111 0010                            DEC.W          A0
  M16C_DEC_W_A0 = (0xF2) @ {
    cmd.itype = M16C_xx_DEC_W_A0;
    MakeSrcDest16(SRC_DEST_A0, cmd.Op1);
  };

#//   0xF3              1111 0011                            RTS
  M16C_RTS = (0xF3) @ {
    cmd.itype = M16C_xx_RTS;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xF4              1111 0100   __DSP16__                JMP.W          LABEL
  M16C_JMP_W_LABEL = (0xF4) @ {
    cmd.itype = M16C_xx_JMP_W_LABEL;
    int16_t dsp16 = ua_next_byte();
    dsp16 |= ua_next_byte() << 8;
    MakeNearOffset(dsp16 + 1, cmd.Op1);
  };

#//   0xF5              1111 0101   __DSP16__                JSR.W          LABEL
  M16C_JSR_W_LABEL = (0xF5) @ {
    cmd.itype = M16C_xx_JSR_W_LABEL;
    int16_t dsp16 = ua_next_byte();
    dsp16 |= ua_next_byte() << 8;
    MakeNearOffset(dsp16 + 1, cmd.Op1);
  };

#//   0xF6              1111 0110                            INTO
  M16C_INTO = (0xF6) @ {
    cmd.itype = M16C_xx_INTO;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xF8              1111 1000   #IMM DEST   ___DSP8__    ADJNZ.B        #IMM4, DEST, LABEL
  M16C_ADJNZ_B_IMM4_DEST_LABEL = (0xF8 any) @ {
    cmd.itype = M16C_xx_ADJNZ_B_IMM4_DEST_LABEL;
    cmd.Op1.dtyp = dt_byte;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    if((cmd.Op1.value & 0x08) > 0)
      cmd.Op1.value |= 0xFFFFFFF0;
    MakeSrcDest8(*p & 0x0F, cmd.Op2);
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op3);
  };

#//   0xF9              1111 1001   #IMM DEST   __DSP8___    ADJNZ.W        #IMM4, DEST, LABEL
  M16C_ADJNZ_W_IMM4_DEST_LABEL = (0xF9 any) @ {
    cmd.itype = M16C_xx_ADJNZ_W_IMM4_DEST_LABEL;
    MakeImm4((*p & 0xF0) >> 4, cmd.Op1);
    cmd.Op1.dtyp = dt_byte;
    if((cmd.Op1.value & 0x08) > 0)
      cmd.Op1.value |= 0xFFFFFFF0;
    MakeSrcDest16(*p & 0x0F, cmd.Op2);
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 2, cmd.Op3);
  };

#//   0xFA              1111 1010                            DEC.W          A1
  M16C_DEC_W_A1 = (0xFA) @ {
    cmd.itype = M16C_xx_DEC_W_A1;
    MakeSrcDest16(SRC_DEST_A1, cmd.Op1);
  };

#//   0xFB              1111 1011                            REIT
  M16C_REIT = (0xFB) @ {
    cmd.itype = M16C_xx_REIT;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };

#//   0xFC              1111 1100   ________ABS20________    JMP.A          LABEL
  M16C_JMP_A_LABEL = (0xFC) @ {
    cmd.itype = M16C_xx_JMP_A_LABEL;
    MakeNearAbs20(cmd.Op1);
  };

#//   0xFD              1111 1101   ________ABS20________    JSR.A          LABEL
  M16C_JSR_A_LABEL = (0xFD) @ {
    cmd.itype = M16C_xx_JSR_A_LABEL;
    MakeNearAbs20(cmd.Op1);
  };

#//   0xFE              1111 1110   __DSP8___                JMP.B          LABEL
  M16C_JMP_B_LABEL = (0xFE) @ {
    cmd.itype = M16C_xx_JMP_B_LABEL;
    int8_t label = ua_next_byte();
    MakeNearOffset(label + 1, cmd.Op1);
  };

#//   0xFF              1111 1111                            UND
  M16C_UND = (0xFF) @ {
    cmd.itype = M16C_xx_UND;
    cmd.Op1.type = o_void;
    cmd.Op1.dtyp = dt_void;
  };


  instr := ( M16C_BRK
      | M16C_MOV_B_S_R0L_DEST
      | M16C_NOP
      | M16C_MOV_B_S_R0H_DEST
      | M16C_MOV_B_S_SRC_R0L
      | M16C_MOV_B_S_SRC_R0H
      | M16C_AND_B_S_SRC_R0L_R0H
      | M16C_OR_B_S_SRC_R0L_R0H
      | M16C_ADD_B_S_SRC_R0L_R0H
      | M16C_SUB_B_S_SRC_R0L_R0H
      | M16C_MOV_B_S_SRC_A0
      | M16C_MOV_B_S_SRC_A1
      | M16C_CMP_B_S_SRC_R0L_R0H
      | M16C_BCLR_S_BIT_BASE_11_SB
      | M16C_BSET_S_BIT_BASE_11_SB
      | M16C_BNOT_S_BIT_BASE_11_SB
      | M16C_BTST_S_BIT_BASE_11_SB
      | M16C_JMP_S_LABEL
      | M16C_JC_LABEL
      | M16C_JGTU_LABEL
      | M16C_JZ_LABEL
      | M16C_JN_LABEL
      | M16C_JNC_LABEL
      | M16C_JLEU_LABEL
      | M16C_JNZ_LABEL
      | M16C_JPZ_LABEL
      | M16C_MULU_B_SRC_DEST
      | M16C_MULU_W_SRC_DEST
      | M16C_MOV_B_G_SRC_DEST
      | M16C_MOV_W_G_SRC_DEST
      | M16C_STE_B_SRC_ABS20
      | M16C_STE_B_SRC_DSP_20_A0
      | M16C_STE_B_SRC_A0A1
      | M16C_MOV_B_G_SRC_DSP_8_SP
      | M16C_PUSH_B_G_SRC
      | M16C_NEG_B_DEST
      | M16C_ROT_B_R1H_DEST
      | M16C_NOT_B_G_DEST
      | M16C_LDE_B_ABS20_DEST
      | M16C_LDE_B_DSP_20_A0_DEST
      | M16C_LDE_B_A0A1_DEST
      | M16C_MOV_B_G_IMM8_DEST
      | M16C_POP_B_G_DEST
      | M16C_SHL_B_R1H_DEST
      | M16C_SHA_B_R1H_DEST
      | M16C_STE_W_SRC_ABS20
      | M16C_STE_W_SRC_DSP_20_A0
      | M16C_STE_W_SRC_A0A1
      | M16C_MOV_W_G_SRC_DSP_8_SP
      | M16C_PUSH_W_G_SRC
      | M16C_NEG_W_DEST
      | M16C_ROT_W_R1H_DEST
      | M16C_NOT_W_G_DEST
      | M16C_LDE_W_ABS20_DEST
      | M16C_LDE_W_DSP_20_A0_DEST
      | M16C_LDE_W_A0A1_DEST
      | M16C_MOV_W_G_IMM8_DEST
      | M16C_POP_W_G_DEST
      | M16C_SHL_W_R1H_DEST
      | M16C_SHA_W_R1H_DEST
      | M16C_TST_B_IMM8_DEST
      | M16C_XOR_B_IMM8_DEST
      | M16C_AND_B_G_IMM8_DEST
      | M16C_OR_B_G_IMM8_DEST
      | M16C_ADD_B_G_IMM8_DEST
      | M16C_SUB_B_G_IMM8_DEST
      | M16C_ADC_B_IMM8_DEST
      | M16C_SBB_B_IMM8_DEST
      | M16C_CMP_B_G_IMM8_DEST
      | M16C_DIVX_B_SRC
      | M16C_ROLC_B_DEST
      | M16C_RORC_B_DEST
      | M16C_DIVU_B_SRC
      | M16C_DIV_B_SRC
      | M16C_ADCF_B_DEST
      | M16C_ABS_B_DEST
      | M16C_TST_W_IMM16_DEST
      | M16C_XOR_W_IMM16_DEST
      | M16C_AND_W_G_IMM16_DEST
      | M16C_OR_W_G_IMM8_DEST
      | M16C_ADD_W_G_IMM16_DEST
      | M16C_SUB_W_G_IMM16_DEST
      | M16C_ADC_W_IMM16_DEST
      | M16C_SBB_W_IMM16_DEST
      | M16C_CMP_W_G_IMM16_DEST
      | M16C_DIVX_W_SRC
      | M16C_ROLC_W_DEST
      | M16C_RORC_W_DEST
      | M16C_DIVU_W_SRC
      | M16C_DIV_W_SRC
      | M16C_ADCF_W_DEST
      | M16C_ABS_W_DEST
      | M16C_MUL_B_SRC_DEST
      | M16C_MUL_W_SRC_DEST
      | M16C_XCHG_B_SRC_DEST
      | M16C_MOV_B_G_DSP_8_SP_DEST
      | M16C_LDC_SRC_DEST
      | M16C_XCHG_W_SRC_DEST
      | M16C_MOV_W_G_DSP_8_SP_DEST
      | M16C_STC_SRC_DEST
      | M16C_MOVLL_DEST_R0L
      | M16C_MOVHL_DEST_R0L
      | M16C_MOVLH_DEST_R0L
      | M16C_MOVHH_DEST_R0L
      | M16C_MULU_B_IMM8_DEST
      | M16C_MUL_B_IMM8_DEST
      | M16C_EXTS_B_DEST
      | M16C_MOVLL_R0L_DEST
      | M16C_MOVHL_R0L_DEST
      | M16C_MOVLH_R0L_DEST
      | M16C_MOVHH_R0L_DEST
      | M16C_STC_PC_DEST
      | M16C_DIVU_B_IMM8
      | M16C_DIV_B_IMM8
      | M16C_PUSH_B_G_IMM8
      | M16C_DIVX_B_IMM8
      | M16C_DADD_B_R0H_R0L
      | M16C_DSUB_B_R0H_R0L
      | M16C_DADC_B_R0H_R0L
      | M16C_DSBB_B_R0H_R0L
      | M16C_SMOVF_B
      | M16C_SMOVB_B
      | M16C_SSTR_B
      | M16C_ADD_B_G_IMM8_SP
      | M16C_DADD_B_IMM8_R0L
      | M16C_DSUB_B_IMM8_R0L
      | M16C_DADC_B_IMM8_R0L
      | M16C_DSBB_B_IMM8_R0L
      | M16C_LDCTX_ABS16_ABS20
      | M16C_RMPA_B
      | M16C_ENTER_IMM8
      | M16C_EXTS_W_R0
      | M16C_JMPI_A_SRC
      | M16C_JSRI_A_SRC
      | M16C_JMPI_W_SRC
      | M16C_JSRI_W_SRC
      | M16C_MULU_W_IMM16_DEST
      | M16C_MUL_W_IMM16_DEST
      | M16C_PUSHA_SRC
      | M16C_LDIPL_IMM
      | M16C_ADD_B_Q_IMM4_SP
      | M16C_JLE_LABEL
      | M16C_JO_LABEL
      | M16C_JGE_LABEL
      | M16C_JGT_LABEL
      | M16C_JNO_LABEL
      | M16C_JLT_LABEL
      | M16C_BMC_C
      | M16C_BMGTU_C
      | M16C_BMZ_C
      | M16C_BMN_C
      | M16C_BMNC_C
      | M16C_BMLEU_C
      | M16C_BMNZ_C
      | M16C_BMPZ_C
      | M16C_BMLE_C
      | M16C_BMGO_C
      | M16C_BMGE_C
      | M16C_BMGT_C
      | M16C_BMNO_C
      | M16C_BMLT_C
      | M16C_DIVU_W_IMM16
      | M16C_DIV_W_IMM16
      | M16C_PUSH_W_G_IMM16
      | M16C_DIVX_W_IMM8
      | M16C_DADD_W_R1_R0
      | M16C_DSUB_W_R1_R0
      | M16C_DADC_W_R1_R0
      | M16C_DSBB_W_R1_R0
      | M16C_SMOVF_W
      | M16C_SMOVB_W
      | M16C_SSTR_W
      | M16C_ADD_W_G_IMM16_SP
      | M16C_DADD_W_IMM16_R0
      | M16C_DSUB_W_IMM16_R0
      | M16C_DADC_W_IMM16_R0
      | M16C_DSBB_W_IMM16_R0
      | M16C_STCTX_ABS16_ABS20
      | M16C_RMPA_W
      | M16C_EXITD
      | M16C_WAIT
      | M16C_BTSTC_DEST
      | M16C_BTSTS_DEST
      | M16C_BMCnd_DEST
      | M16C_BNTST_SRC
      | M16C_BAND_SRC
      | M16C_BNAND_SRC
      | M16C_BOR_SRC
      | M16C_BNOR_SRC
      | M16C_BCLR_G_DEST
      | M16C_BSET_G_DEST
      | M16C_BNOT_G_DEST
      | M16C_BTST_G_SRC
      | M16C_BXOR_SRC
      | M16C_BNXOR_SRC
      | M16C_TST_B_SRC_DEST
      | M16C_TST_W_SRC_DEST
      | M16C_ADD_B_S_IMM8_DEST
      | M16C_XOR_B_SRC_DEST
      | M16C_XOR_W_SRC_DEST
      | M16C_PUSH_B_S_SRC
      | M16C_SUB_B_S_IMM8_DEST
      | M16C_AND_B_G_SRC_DEST
      | M16C_AND_W_G_SRC_DEST
      | M16C_AND_B_S_IMM8_DEST
      | M16C_OR_B_G_SRC_DEST
      | M16C_POP_B_S_DEST
      | M16C_OR_B_S_IMM8_DEST
      | M16C_ADD_B_G_SRC_DEST
      | M16C_ADD_W_G_SRC_DEST
      | M16C_MOV_B_S_IMM8_A0
      | M16C_INC_B_DEST
      | M16C_SUB_B_G_SRC_DEST
      | M16C_SUB_W_G_SRC_DEST
      | M16C_MOV_B_S_IMM8_A1
      | M16C_DEC_B_DEST
      | M16C_ADC_B_SRC_DEST
      | M16C_ADC_W_SRC_DEST
      | M16C_INC_W_A0
      | M16C_MOV_B_Z_0_DEST
      | M16C_SBB_B_SRC_DEST
      | M16C_SBB_W_SRC_DEST
      | M16C_INC_W_A1
      | M16C_NOT_B_S_DEST
      | M16C_CMP_B_G_SRC_DEST
      | M16C_CMP_W_G_SRC_DEST
      | M16C_MOV_B_S_IMM8_DEST
      | M16C_ADD_B_Q_IMM4_DEST
      | M16C_ADD_W_Q_IMM4_DEST
      | M16C_PUSH_W_S_SRC
      | M16C_STZ_IMM8_DEST
      | M16C_CMP_B_Q_IMM4_DEST
      | M16C_CMP_W_Q_IMM4_DEST
      | M16C_STNZ_IMM8_DEST
      | M16C_MOV_B_Q_IMM4_DEST
      | M16C_MOV_W_Q_IMM4_DEST
      | M16C_POP_W_S_DEST
      | M16C_STZX_IMM81_IMM82_DEST
      | M16C_ROT_B_IMM4_DEST
      | M16C_ROT_W_IMM4_DEST
      | M16C_MOV_W_S_IMM16_A0
      | M16C_CMP_B_S_IMM8_DEST
      | M16C_SHL_B_IMM4_DEST
      | M16C_SHL_W_IMM4_DEST
      | M16C_MOV_W_S_IMM16_A1
      | M16C_FSET_C
      | M16C_FCLR_C
      | M16C_LDC_IMM16_INTBL
      | M16C_SHL_L_R1H_DEST
      | M16C_FSET_D
      | M16C_FCLR_D
      | M16C_LDC_IMM16_INTBH
      | M16C_FSET_Z
      | M16C_FCLR_Z
      | M16C_LDC_IMM16_FLG
      | M16C_SHA_L_R1H_DEST
      | M16C_FSET_S
      | M16C_FCLR_S
      | M16C_LDC_IMM16_ISP
      | M16C_FSET_B
      | M16C_FCLR_B
      | M16C_LDC_IMM16_SP
      | M16C_FSET_O
      | M16C_FCLR_O
      | M16C_LDC_IMM16_SB
      | M16C_FSET_I
      | M16C_FCLR_I
      | M16C_LDC_IMM16_FB
      | M16C_PUSHC_SRC
      | M16C_POPC_DEST
      | M16C_FSET_U
      | M16C_FCLR_U
      | M16C_MOVA_SRC_DEST
      | M16C_SHL_L_IMM4_DEST
      | M16C_SHA_L_IMM4_DEST
      | M16C_INT_IMM
      | M16C_PUSHM_SRC
      | M16C_POPM_DEST
      | M16C_JMPS_IMM8
      | M16C_JSRS_IMM8
      | M16C_SHA_B_IMM4_DEST
      | M16C_SHA_W_IMM4_DEST
      | M16C_DEC_W_A0
      | M16C_RTS
      | M16C_JMP_W_LABEL
      | M16C_JSR_W_LABEL
      | M16C_INTO
      | M16C_ADJNZ_B_IMM4_DEST_LABEL
      | M16C_ADJNZ_W_IMM4_DEST_LABEL
      | M16C_DEC_W_A1
      | M16C_REIT
      | M16C_JMP_A_LABEL
      | M16C_JSR_A_LABEL
      | M16C_JMP_B_LABEL
      | M16C_UND
  )
  @err {
    cmd.itype = M16C_xx_null;
    cmd.Op1 = op_t();
    cmd.Op2 = op_t();
    cmd.Op3 = op_t();
    EOI = true;
  }
  @ {EOI = true;};
}%%

//------------------------------------------------------------------------
inline uchar ua_next_byte(void) {
  return (uchar) get_full_byte(cmd.ea + cmd.size++);
}

void MakeSrcDest8(uint8_t op, op_t &cmdOp) {
  cmdOp.dtyp = dt_byte;
  switch (op) {
    case SRC_DEST_R0L:    // R0L
      cmdOp.type = o_reg;
      cmdOp.reg = rR0L;
      break;
    case SRC_DEST_R0H:    // R0H
      cmdOp.type = o_reg;
      cmdOp.reg = rR0H;
      break;
    case SRC_DEST_R1L:    // R1L
      cmdOp.type = o_reg;
      cmdOp.reg = rR1L;
      break;
    case SRC_DEST_R1H:    // R1H
      cmdOp.type = o_reg;
      cmdOp.reg = rR1H;
      break;
    case SRC_DEST_A0:   // A0
      cmdOp.type = o_reg;
      cmdOp.reg = rA0;
      break;
    case SRC_DEST_A1:   // A1
      cmdOp.type = o_reg;
      cmdOp.reg = rA1;
      break;
    case SRC_DEST_A0_:    // [A0]
      cmdOp.type = o_phrase;
      cmdOp.reg = rA0;
      break;
    case SRC_DEST_A1_:    // [A1]
      cmdOp.type = o_phrase;
      cmdOp.reg = rA1;
      break;
    case SRC_DEST_DSP_8_A0_:    // dsp:8[A0]
      cmdOp.type = o_displ;
      cmdOp.reg = rA0;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_A1_:    // dsp:8[A1]
      cmdOp.type = o_displ;
      cmdOp.reg = rA1;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_SB_:    // dsp:8[SB]
      cmdOp.type = o_displ;
      cmdOp.reg = rSB;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_FB_:    // dsp:8[FB]
      cmdOp.type = o_displ;
      cmdOp.reg = rFB;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_20_A0_:   // dsp:16[A0]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_dword;
      cmdOp.reg = rA0;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_DSP_20_A1_:   // dsp:16[A1]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_dword;
      cmdOp.reg = rA1;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_DSP_16_SB_:   // dsp:16[SB]
      cmdOp.type = o_displ;
      cmdOp.reg = rSB;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_ABS16:    // abs16
      cmdOp.type = o_mem;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_ABS20:
      cmdOp.type = o_mem;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      cmdOp.addr |= ua_next_byte() << 16;
      break;
    case SRC_DEST_8BIT_A1A0_:
      cmdOp.type = o_reg;
      cmdOp.reg = rA1A0;
      break;
    case SRC_DEST_DSP_8_SP_:
      cmdOp.type = o_displ;
      cmdOp.reg = rISP;
      cmdOp.value = ua_next_byte();
      break;
    default:
      break;
  }
}

void MakeSrcDest3bit(uint8_t op, op_t &cmdOp) {
  switch(op) {
    case 0x03:
      MakeSrcDest8(SRC_DEST_R0H, cmdOp);
      break;
    case 0x04:
      MakeSrcDest8(SRC_DEST_R0L, cmdOp);
      break;
    case 0x05:
      MakeSrcDest8(SRC_DEST_DSP_8_SB_, cmdOp);
      break;
    case 0x06:
      MakeSrcDest8(SRC_DEST_DSP_8_FB_, cmdOp);
      break;
    case 0x07:
      MakeSrcDest8(SRC_DEST_ABS16, cmdOp);
      break;
  }
}

void MakeSrcDest16(uint8_t op, op_t &cmdOp) {
  cmdOp.dtyp = dt_word;
  switch (op) {
    case SRC_DEST_R0:   // R0
      cmdOp.type = o_reg;
      cmdOp.reg = rR0;
      break;
    case SRC_DEST_R1:   // R1
      cmdOp.type = o_reg;
      cmdOp.reg = rR1;
      break;
    case SRC_DEST_R2:   // R2
      cmdOp.type = o_reg;
      cmdOp.reg = rR2;
      break;
    case SRC_DEST_R3:   // R3
      cmdOp.type = o_reg;
      cmdOp.reg = rR3;
      break;
    case SRC_DEST_A0:   // A0
      cmdOp.type = o_reg;
      cmdOp.reg = rA0;
      break;
    case SRC_DEST_A1:   // A1
      cmdOp.type = o_reg;
      cmdOp.reg = rA1;
      break;
    case SRC_DEST_A0_:    // [A0]
      cmdOp.type = o_phrase;
      cmdOp.reg = rA0;
      break;
    case SRC_DEST_A1_:    // [A1]
      cmdOp.type = o_phrase;
      cmdOp.reg = rA1;
      break;
    case SRC_DEST_DSP_8_A0_:    // dsp:8[A0]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rA0;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_A1_:    // dsp:8[A1]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rA1;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_SB_:    // dsp:8[SB]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rSB;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_FB_:    // dsp:8[FB]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rFB;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_20_A0_:   // dsp:16[A0]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_dword;
      cmdOp.reg = rA0;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_DSP_20_A1_:   // dsp:16[A1]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_dword;
      cmdOp.reg = rA1;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_DSP_16_SB_:   // dsp:16[SB]
      cmdOp.type = o_displ;
      cmdOp.reg = rSB;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_ABS16:    // abs16
      cmdOp.type = o_mem;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_ABS20:
      cmdOp.type = o_mem;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      cmdOp.addr |= ua_next_byte() << 16;
      break;
    case SRC_DEST_16BIT_A1A0_:
      cmdOp.type = o_reg;
      cmdOp.reg = rA1A0;
      break;
    case SRC_DEST_DSP_8_SP_:
      cmdOp.type = o_displ;
      cmdOp.reg = rISP;
      cmdOp.value = ua_next_byte();
      break;
    default:
      break;
  }
}

void MakeSrcDest32(uint8_t op, op_t &cmdOp) {
  cmdOp.dtyp = dt_dword;
  switch (op) {
    case SRC_DEST_R2R0:   // R2R0
      cmdOp.type = o_reg;
      cmdOp.reg = rR2R0;
      break;
    case SRC_DEST_R3R1:   // R3R1
      cmdOp.type = o_reg;
      cmdOp.reg = rR3R1;
      break;
    case SRC_DEST_A1A0:   // A1A0
      cmdOp.type = o_reg;
      cmdOp.reg = rA1A0;
      break;
    case SRC_DEST_A0_:    // [A0]
      cmdOp.type = o_phrase;
      cmdOp.reg = rA0;
      break;
    case SRC_DEST_A1_:    // [A1]
      cmdOp.type = o_phrase;
      cmdOp.reg = rA1;
      break;
    case SRC_DEST_DSP_8_A0_:    // dsp:8[A0]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rA0;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_A1_:    // dsp:8[A1]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rA1;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_SB_:    // dsp:8[SB]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rSB;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_8_FB_:    // dsp:8[FB]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_byte;
      cmdOp.reg = rFB;
      cmdOp.value = ua_next_byte();
      break;
    case SRC_DEST_DSP_20_A0_:   // dsp:16[A0]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_dword;
      cmdOp.reg = rA0;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_DSP_20_A1_:   // dsp:16[A1]
      cmdOp.type = o_displ;
      cmdOp.dtyp = dt_dword;
      cmdOp.reg = rA1;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_DSP_16_SB_:   // dsp:16[SB]
      cmdOp.type = o_displ;
      cmdOp.reg = rSB;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_ABS16:    // abs16
      cmdOp.type = o_mem;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      break;
    case SRC_DEST_ABS20:
      cmdOp.type = o_mem;
      cmdOp.addr = ua_next_byte();
      cmdOp.addr |= ua_next_byte() << 8;
      cmdOp.addr |= ua_next_byte() << 16;
      break;
    case SRC_DEST_DSP_8_SP_:
      cmdOp.type = o_displ;
      cmdOp.reg = rISP;
      cmdOp.value = ua_next_byte();
      break;
    default:
      break;
  }
}

void MakeImm4(uint32_t imm, op_t &cmdOp) {
  cmdOp.dtyp = dt_byte;
  cmdOp.type = o_imm;
  cmdOp.value = imm;
}

void MakeImm8(op_t &cmdOp) {
  cmdOp.dtyp = dt_byte;
  cmdOp.type = o_imm;
  cmdOp.value = ua_next_byte();
}

void MakeImm16(op_t &cmdOp) {
  cmdOp.dtyp = dt_word;
  cmdOp.type = o_imm;
  cmdOp.value = ua_next_byte();
  cmdOp.value |= ua_next_byte() << 8;
}

void MakeImm32(op_t &cmdOp) {
  cmdOp.dtyp = dt_dword;
  cmdOp.type = o_imm;
  cmdOp.value = ua_next_byte();
  cmdOp.value |= ua_next_byte() << 8;
  cmdOp.value |= ua_next_byte() << 16;
}

void MakeNear(uint32_t addr, op_t &cmdOp) {
  cmdOp.type = o_near;
  cmdOp.dtyp = dt_dword;
  cmdOp.addr = addr;
}

void MakeNearAbs20(op_t &cmdOp) {
  cmdOp.type = o_near;
  cmdOp.dtyp = dt_dword;
  cmdOp.addr = ua_next_byte();
  cmdOp.addr |= ua_next_byte() << 8;
  cmdOp.addr |= ua_next_byte() << 16;
}

void MakeNearOffset(int32_t offs, op_t &cmdOp) {
  cmdOp.type = o_near;
  cmdOp.dtyp = dt_dword;
  cmdOp.addr = cmd.ea + offs;
}

void MakeBitsSrcDest(uint8_t op, op_t &cmdOp1, op_t &cmdOp2) {
  switch (op) {
    case BITS_BIT_R0:   // bit,R0
      cmdOp1.dtyp = dt_byte;
      cmdOp1.type = o_imm;
      cmdOp1.value = ua_next_byte();
      cmdOp2.type = o_reg;
      cmdOp2.reg = rR0;
      break;
    case BITS_BIT_R1:   // bit,R1
      cmdOp1.dtyp = dt_byte;
      cmdOp1.type = o_imm;
      cmdOp1.value = ua_next_byte();
      cmdOp2.type = o_reg;
      cmdOp2.reg = rR1;
      break;
    case BITS_BIT_R2:   // bit,R2
      cmdOp1.dtyp = dt_byte;
      cmdOp1.type = o_imm;
      cmdOp1.value = ua_next_byte();
      cmdOp2.type = o_reg;
      cmdOp2.reg = rR2;
      break;
    case BITS_BIT_R3:   // bit,R3
      cmdOp1.dtyp = dt_byte;
      cmdOp1.type = o_imm;
      cmdOp1.value = ua_next_byte();
      cmdOp2.type = o_reg;
      cmdOp2.reg = rR3;
      break;
    case BITS_BIT_A0:   // bit,A0
      cmdOp1.dtyp = dt_byte;
      cmdOp1.type = o_imm;
      cmdOp1.value = ua_next_byte();
      cmdOp2.type = o_reg;
      cmdOp2.reg = rA0;
      break;
    case BITS_BIT_A1:   // bit,A1
      cmdOp1.dtyp = dt_byte;
      cmdOp1.type = o_imm;
      cmdOp1.value = ua_next_byte();
      cmdOp2.type = o_reg;
      cmdOp2.reg = rA1;
      break;
    case BITS_A0_:    // [A0]
      cmdOp1.type = o_phrase;
      cmdOp1.reg = rA0;
      break;
    case BITS_A1_:    // [A1]
      cmdOp1.type = o_phrase;
      cmdOp1.reg = rA1;
      break;
    case BITS_BASE_8_A0_:   // base:8[A0]+
      cmdOp1.type = o_displ;
      cmdOp1.dtyp = dt_byte;
      cmdOp1.reg = rA0;
      cmdOp2.value = ua_next_byte();
      break;
    case BITS_BASE_8_A1_:   // base:8[A1]+
      cmdOp1.type = o_displ;
      cmdOp1.dtyp = dt_byte;
      cmdOp1.reg = rA1;
      cmdOp2.value = ua_next_byte();
      break;
    case BITS_BIT_BASE_8_SB_:   // bit,base:8[SB]+
      {
      cmdOp2.dtyp = dt_byte;
      cmdOp2.type = o_displ;
      cmdOp2.reg = rSB;
      int8_t val = ua_next_byte();
      cmdOp1.type = o_imm;
      cmdOp1.value = val & 0x07;
      cmdOp2.value = val >> 3;
      }
      break;
    case BITS_BIT_BASE_8_FB_:   // bit,base:8[FB]+
      {
      cmdOp2.type = o_displ;
      cmdOp2.reg = rFB;
      int8_t val = ua_next_byte();
      cmdOp1.type = o_imm;
      cmdOp1.value = val & 0x07;
      cmdOp2.value = val >> 3;
      }
      break;
    case BITS_BASE_16_A0_:    // base:16[A0]+
      cmdOp1.type = o_displ;
      cmdOp1.dtyp = dt_dword;
      cmdOp1.reg = rA0;
      cmdOp1.value = ua_next_byte();
      cmdOp1.value |= ua_next_byte() << 8;
      break;
    case BITS_BASE_16_A1_:    // base:16[A1]+
      cmdOp1.type = o_displ;
      cmdOp1.dtyp = dt_dword;
      cmdOp1.reg = rA1;
      cmdOp1.value = ua_next_byte();
      cmdOp1.value |= ua_next_byte() << 8;
      break;
    case BITS_BIT_BASE_16_SB_:    // bit,base:16[SB]+
      {
      cmdOp2.type = o_displ;
      cmdOp2.reg = rSB;
      uint8_t val = ua_next_byte();
      cmdOp1.type = o_imm;
      cmdOp1.value = val & 0x07;
      cmdOp2.value = val >> 3;
      cmdOp2.value |= ua_next_byte() << 5;
      }
      break;
    case BITS_BIT_BASE_16:    // bit,base:16
      {
      cmdOp2.type = o_mem;
      uint8_t val = ua_next_byte();
      cmdOp1.type = o_imm;
      cmdOp1.value = val & 0x07;
      cmdOp2.addr = val >> 3;
      cmdOp2.addr |= ua_next_byte() << 8;
      }
      break;
    default:
      break;
  }
}

int ana() {
  int cs;
  bool EOI = false;

  cmd.itype = M16C_xx_null;
  cmd.Op1 = op_t();
  cmd.Op2 = op_t();
  cmd.Op3 = op_t();

  %%{
    write init;
  }%%

  while(!EOI) {
    char code = ua_next_byte();
    char *p = &code;
    char *pe = p + 1;
    char *eof = 0;

    %%{
      write exec;
    }%%
  }

  return cmd.size;
}
