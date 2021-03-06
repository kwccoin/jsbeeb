1REM Thanks to Tom Seddon!
10REM>NOPS
20MODE1
30PRINX%=0:PRINY%=0:COLWIDTH%=0
40CODESIZE%=1000:DIMCODE%CODESIZE%
50:
60FORPASS%=0TO2STEP2:P%=CODE%:[OPTPASS%
70LDA&60:PHA
80LDA#0:STA&60
90JSRSMBTEST
100LDA&60:STA&70
110PLA:STA&60
120RTS
130:
140.SMBTEST
150EQUB&87:EQUB&60:\SMB0 &60
160RTS
170]
180NEXT
190CALLCODE%
200ROCKWELL%=?&70<>0
210IFROCKWELL%:PROCPRINT(3,0,"ROCKWELL/WDC CPU"):ELSE:PROCPRINT(3,0,"CMOS CPU")
220PROCPRINT(0,1,"2 CYCLES")
230T2C%=FNTIME(1,&EA,1,-1)
240PROCPRINT(0,1,"3 CYCLES")
250T3C%=FNTIME(1,&A5,2,-1)
260PROCPRINT(0,1,"4 CYCLES")
270T4C%=FNTIME(1,&AD,3,-1)
271PROCPRINT(0,1,"8 CYCLES")
272T8C%=FNTIME(2,&AD,3,-1)
273PROCPRINT(0,1,"1 CYCLES")
274T1C%=T2C%-INT(((T3C%-T2C%)+(T4C%-T2C%)/2+(T8C%-T2C%)/6)/3)
275PROCPRINT(0,3,"GUESS: "+STR$T1C%)
280RESTORE560:PROCMULTI(T2C%,2,2)
290RESTORE580:PROCMULTI(T3C%,3,2)
300RESTORE620:PROCMULTI(T4C%,4,2)
310RESTORE680:PROCMULTI(T8C%,8,3)
320RESTORE410:PROCMULTI(-1,1,1)
330IFNOTROCKWELL%:RESTORE440:PROCMULTI(-1,1,1)
340RESTORE470:PROCMULTI(-1,1,1)
350IFNOTROCKWELL%:RESTORE500:PROCMULTI(-1,1,1)
360IFNOTROCKWELL%:RESTORE530:PROCMULTI(-1,1,1)
370END
380:
390:
400REM 1 CYCLES, 1 BYTES
410DATA &03,&13,&23,&33,&43,&53,&63,&73,&83,&93,&A3,&B3,&C3,&D3,&E3,&F3,-1
420:
430REM 1 CYCLES, 1 BYTES (NOT ROCKWELL)
440DATA &07,&17,&27,&37,&47,&57,&67,&77,&87,&97,&A7,&B7,&C7,&D7,&E7,&F7,-1
450:
460REM 1 CYCLES, 1 BYTES
470DATA &0B,&1B,&2B,&3B,&4B,&5B,&6B,&7B,&8B,&9B,&AB,&BB,&EB,&FB,-1
480:
490REM 1 CYCLES, 1 BYTES (NOT WDC)
500DATA &CB,&DB,-1
510:
520REM 1 CYCLES, 1 BYTES (NOT ROCKWELL)
530DATA &0F,&1F,&2F,&3F,&4F,&5F,&6F,&7F,&8F,&9F,&AF,&BF,&CF,&DF,&EF,&FF,-1
540:
550REM 2 CYCLES, 2 BYTES
560DATA &02,&22,&42,&62,&82,&C2,&E2,-1
570:
580REM 3 CYCLES, 2 BYTES
590DATA &44,-1
600:
610REM 4 CYCLES, 2 BYTES
620DATA &54,&D4,&F4,-1
630:
640REM 4 CYCLES, 3 BYTES
650DATA &DC,&FC,-1
660:
670REM 8 CYCLES, 3 BYTES
680DATA &5C,-1
690:
700DEFPROCMULTI(TEXPECTED%,NC%,NB%)
710PROCPRINT(0,2,STR$NC%+" CYCLES")
720REPEAT
730READNOP%:IFNOP%=-1:GOTO750
740T%=FNTIME(1,NOP%,NB%,TEXPECTED%)
750UNTILNOP%=-1
760ENDPROC
770:
780DEFFNTIME(NCOPIES%,NOP%,N%,TEXPECTED%)
790IFN%<1ORN%>3:STOP
800FORPASS%=0TO2STEP2:P%=CODE%:[OPTPASS%
810.START
820LDX#0
830.XLOOP
840LDY#0
850.YLOOP
860]
870FORI%=1TONCOPIES%*10
880[OPTPASS%:EQUBNOP%:]
890IFN%>=2:[OPTPASS%:EQUB0:]
900IFN%>=3:[OPTPASS%:EQUB0:]
910NEXT
920[OPTPASS%
930DEY:BNEYLOOP
940DEX:BNEXLOOP
950RTS
960]IFP%>CODE%+CODESIZE%:STOP
970NEXT
980TIME=0
990REMPRINTFNHEX2(NOP%)" (";N%"): ";
1000CALLSTART
1010T%=TIME
1020IFTEXPECTED%>=0ANDABS(TIME-TEXPECTED%)>2:B%=1:ELSE:B%=0
1030PROCPRINT(B%,3,FNHEX2(NOP%)+" ("+STR$N%+"): "+STR$T%)
1040=T%
1050DEFFNHEX2(X%)=RIGHT$("0"+STR$~X%,2)
1060DEFPROCPRINT(B%,F%,MSG$)
1070COLOUR128+B%:COLOURF%
1080PRINTTAB(PRINX%,PRINY%);MSG$;
1090COLOUR128:COLOUR7
1100IFLENMSG$>COLWIDTH%:COLWIDTH%=LENMSG$
1110PRINY%=PRINY%+1
1120IFPRINY%=32:PRINY%=0:PRINX%=PRINX%+COLWIDTH%+1:COLWIDTH%=0
1130ENDPROC
