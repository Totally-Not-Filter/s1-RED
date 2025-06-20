;=======================================================;
;	    $$$TB.ASM  (Sound Adddress & Data Table)	;
;  			ORG. MDTB11.ASM			;
;		'Sound-Source'				;
;		 for Mega Drive (68K)			;
;			Ver  1.1 / 1990.9.1		;
;				      By  H.Kubota	;
;=======================================================;

	include sound/ver11/mdEQ11.lib
	include sound/ver11/mdMCR11.lib
	include sound/ver11/mdTB11.lib

;=======================================;
;					;
;	     TABLE.ASM START		;
;					;
;=======================================;


;=======================================;
;					;
;	      ADDRESS TABLE		;
;					;
;=======================================;

adrtb:
	dc.l	prtb			; priority
	dc.l	backtb			; back se
	dc.l	bgmtb			; bgm
	dc.l	setb			; s.e
*	dc.l	prtb			; dmy (vibr)
	dc.l	speeduptb		; speed up
	dc.l	envetb			; envelope
*	dc.l	sestrt			; se start no.
*	dc.l    sound			; 7th fix (for sound editor)

;=======================================;
;					;
;	      ENVELOPE TABLE		;
;					;
;=======================================;
envetb:
	DC.L	EV1,EV2,EV3,EV4,EV5,EV6
	DC.L	EV7,EV8,EV9

EV1
	DC.B	0,0,0,1,1,1,2,2,2,3,3,3
	DC.B	4,4,4,5,5,5,6,6,6
	DC.B	7,TBEND
EV2
	DC.B	0,2,4,6,8,$10,TBEND
EV3
	DC.B	0,0,1,1,2,2,3,3,4,4,5,5
	DC.B	6,6,7,7,TBEND
EV4
	DC.B	0,0,2,3,4,4,5,5,5
	DC.B	6,TBEND			;HIHAT(THEN CMGATE,3)
EV6
	DC.B	3,3,3,2,2,2,2,1,1,1
	DC.B	0,0,0,0,TBEND
EV5
	DC.B	0,0,0,0,0,0,0,0,0,0
	DC.B	1,1,1,1,1,1,1,1,1,1
	DC.B	1,1,1,1,2,2,2,2,2,2
	DC.B	2,2,3,3,3,3,3,3,3,3
	DC.B	4,TBEND
EV7
	DC.B	0,0,0,0,0,0,1,1,1,1
	DC.B	1,2,2,2,2,2,3,3,3,4
	DC.B	4,4,5,5,5,6,7,TBEND			;HIHAT
EV8
	DC.B	0,0,0,0,0,1,1,1,1,1
	DC.B	2,2,2,2,2,2,3,3,3,3,3
	DC.B	4,4,4,4,4,5,5,5,5,5
	DC.B	6,6,6,6,6,7,7,7,TBEND
EV9
	DC.B	0,1,2,3,4,5,6,7,8,9
	DC.B	$A,$B,$C,$D,$E,$F,TBEND
	
speeduptb:
	DC.B	$07
	DC.B	$72
	DC.B	$73
	DC.B	$26
	DC.B	$15
	DC.B	$08
	DC.B	$FF
	DC.B	$05

;=======================================;
;					;
;	    SONG ADDRESS TABLE		;
;					;
;=======================================;
bgmtb:
	DC.L	S81			; 81
	DC.L	S82			; 82
	DC.L	S83			; 83
	DC.L	S84			; 84
	DC.L	S85			; 85
	DC.L	S86			; 86
	DC.L	S87			; 87
	DC.L	S88			; 88
	DC.L	S89			; 89
	DC.L	S8A			; 8A
	DC.L	S8B			; 8B
	DC.L	S8C			; 8C
	DC.L	S8D			; 8D
	DC.L	S8E			; 8E
	DC.L	S8F			; 8F
	DC.L	S90			; 90
	DC.L	S91			; 91
	DC.L	S92			; 92
	DC.L	S93			; 93

;=======================================;
;					;
;	      PRIORITY TABLE		;
;					;
;=======================================;
prtb:
	if	lstno>$081-1
		DC.B	PR81
	endif
	if	lstno>$082-1
		DC.B	PR82
	endif
	if	lstno>$083-1
		DC.B	PR83
	endif
	if	lstno>$084-1
		DC.B	PR84
	endif
	if	lstno>$085-1
		DC.B	PR85
	endif
	if	lstno>$086-1
		DC.B	PR86
	endif
	if	lstno>$087-1
		DC.B	PR87
	endif
	if	lstno>$088-1
		DC.B	PR88
	endif
	if	lstno>$089-1
		DC.B	PR89
	endif
	if	lstno>$08A-1
		DC.B	PR8A
	endif
	if	lstno>$08B-1
		DC.B	PR8B
	endif
	if	lstno>$08C-1
		DC.B	PR8C
	endif
	if	lstno>$08D-1
		DC.B	PR8D
	endif
	if	lstno>$08E-1
		DC.B	PR8E
	endif
	if	lstno>$08F-1
		DC.B	PR8F
	endif
	if	lstno>$090-1
		DC.B	PR90
	endif
	if	lstno>$091-1
		DC.B	PR91
	endif
	if	lstno>$092-1
		DC.B	PR92
	endif
	if	lstno>$093-1
		DC.B	PR93
	endif
	if	lstno>$094-1
		DC.B	PR94
	endif
	if	lstno>$095-1
		DC.B	PR95
	endif
	if	lstno>$096-1
		DC.B	PR96
	endif
	if	lstno>$097-1
		DC.B	PR97
	endif
	if	lstno>$098-1
		DC.B	PR98
	endif
	if	lstno>$099-1
		DC.B	PR99
	endif
	if	lstno>$09A-1
		DC.B	PR9A
	endif
	if	lstno>$09B-1
		DC.B	PR9B
	endif
	if	lstno>$09C-1
		DC.B	PR9C
	endif
	if	lstno>$09D-1
		DC.B	PR9D
	endif
	if	lstno>$09E-1
		DC.B	PR9E
	endif
	if	lstno>$09F-1
		DC.B	PR9F
	endif
	if	lstno>$0A0-1
		DC.B	PRA0
	endif
	if	lstno>$0A1-1
		DC.B	PRA1
	endif
	if	lstno>$0A2-1
		DC.B	PRA2
	endif
	if	lstno>$0A3-1
		DC.B	PRA3
	endif
	if	lstno>$0A4-1
		DC.B	PRA4
	endif
	if	lstno>$0A5-1
		DC.B	PRA5
	endif
	if	lstno>$0A6-1
		DC.B	PRA6
	endif
	if	lstno>$0A7-1
		DC.B	PRA7
	endif
	if	lstno>$0A8-1
		DC.B	PRA8
	endif
	if	lstno>$0A9-1
		DC.B	PRA9
	endif
	if	lstno>$0AA-1
		DC.B	PRAA
	endif
	if	lstno>$0AB-1
		DC.B	PRAB
	endif
	if	lstno>$0AC-1
		DC.B	PRAC
	endif
	if	lstno>$0AD-1
		DC.B	PRAD
	endif
	if	lstno>$0AE-1
		DC.B	PRAE
	endif
	if	lstno>$0AF-1
		DC.B	PRAF
	endif
	if	lstno>$0B0-1
		DC.B	PRB0
	endif
	if	lstno>$0B1-1
		DC.B	PRB1
	endif
	if	lstno>$0B2-1
		DC.B	PRB2
	endif
	if	lstno>$0B3-1
		DC.B	PRB3
	endif
	if	lstno>$0B4-1
		DC.B	PRB4
	endif
	if	lstno>$0B5-1
		DC.B	PRB5
	endif
	if	lstno>$0B6-1
		DC.B	PRB6
	endif
	if	lstno>$0B7-1
		DC.B	PRB7
	endif
	if	lstno>$0B8-1
		DC.B	PRB8
	endif
	if	lstno>$0B9-1
		DC.B	PRB9
	endif
	if	lstno>$0BA-1
		DC.B	PRBA
	endif
	if	lstno>$0BB-1
		DC.B	PRBB
	endif
	if	lstno>$0BC-1
		DC.B	PRBC
	endif
	if	lstno>$0BD-1
		DC.B	PRBD
	endif
	if	lstno>$0BE-1
		DC.B	PRBE
	endif
	if	lstno>$0BF-1
		DC.B	PRBF
	endif
	if	lstno>$0C0-1
		DC.B	PRC0
	endif
	if	lstno>$0C1-1
		DC.B	PRC1
	endif
	if	lstno>$0C2-1
		DC.B	PRC2
	endif
	if	lstno>$0C3-1
		DC.B	PRC3
	endif
	if	lstno>$0C4-1
		DC.B	PRC4
	endif
	if	lstno>$0C5-1
		DC.B	PRC5
	endif
	if	lstno>$0C6-1
		DC.B	PRC6
	endif
	if	lstno>$0C7-1
		DC.B	PRC7
	endif
	if	lstno>$0C8-1
		DC.B	PRC8
	endif
	if	lstno>$0C9-1
		DC.B	PRC9
	endif
	if	lstno>$0CA-1
		DC.B	PRCA
	endif
	if	lstno>$0CB-1
		DC.B	PRCB
	endif
	if	lstno>$0CC-1
		DC.B	PRCC
	endif
	if	lstno>$0CD-1
		DC.B	PRCD
	endif
	if	lstno>$0CE-1
		DC.B	PRCE
	endif
	if	lstno>$0CF-1
		DC.B	PRCF
	endif
	if	lstno>$0D0-1
		DC.B	PRD0
	endif
	if	lstno>$0D1-1
		DC.B	PRD1
	endif
	if	lstno>$0D2-1
		DC.B	PRD2
	endif
	if	lstno>$0D3-1
		DC.B	PRD3
	endif
	if	lstno>$0D4-1
		DC.B	PRD4
	endif
	if	lstno>$0D5-1
		DC.B	PRD5
	endif
	if	lstno>$0D6-1
		DC.B	PRD6
	endif
	if	lstno>$0D7-1
		DC.B	PRD7
	endif
	if	lstno>$0D8-1
		DC.B	PRD8
	endif
	if	lstno>$0D9-1
		DC.B	PRD9
	endif
	if	lstno>$0DA-1
		DC.B	PRDA
	endif
	if	lstno>$0DB-1
		DC.B	PRDB
	endif
	if	lstno>$0DC-1
		DC.B	PRDC
	endif
	if	lstno>$0DD-1
		DC.B	PRDD
	endif
	if	lstno>$0DE-1
		DC.B	PRDE
	endif
	if	lstno>$0DF-1
		DC.B	PRDF
	endif
	if	lstno>$0E0-1
		DC.B	PRE0
	endif
	if	lstno>$0E1-1
		DC.B	PRE1
	endif
	if	lstno>$0E2-1
		DC.B	PRE2
	endif
	if	lstno>$0E3-1
		DC.B	PRE3
	endif
	if	lstno>$0E4-1
		DC.B	PRE4
	endif
	if	lstno>$0E5-1
		DC.B	PRE5
	endif
	if	lstno>$0E6-1
		DC.B	PRE6
	endif
	if	lstno>$0E7-1
		DC.B	PRE7
	endif
	if	lstno>$0E8-1
		DC.B	PRE8
	endif
	if	lstno>$0E9-1
		DC.B	PRE9
	endif
	if	lstno>$0EA-1
		DC.B	PREA
	endif
	if	lstno>$0EB-1
		DC.B	PREB
	endif
	if	lstno>$0EC-1
		DC.B	PREC
	endif
	if	lstno>$0ED-1
		DC.B	PRED
	endif
	if	lstno>$0EE-1
		DC.B	PREE
	endif
	if	lstno>$0EF-1
		DC.B	PREF
	endif

;=======================================;
;	      END OF FILE		;
;=======================================;

