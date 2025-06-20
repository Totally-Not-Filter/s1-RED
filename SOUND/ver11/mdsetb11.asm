;=======================================================;
;	    $$$SETB.ASM  (Sound S.E. Address Table)	;
;  			ORG. MDSETB11.ASM		;
;		'Sound-Source'				;
;		 for Mega Drive (68K)			;
;			Ver  1.1 / 1990.9.1		;
;				      By  H.Kubota	;
;=======================================================;

;=======================================;
;					;
;	    S.E. ADDRESS TABLE		;
;					;
;=======================================;
setb:
	if	seend>$0A0-1
		DC.L	SA0
	endif
	if	seend>$0A1-1
		DC.L	SA1
	endif
	if	seend>$0A2-1
		DC.L	SA2
	endif
	if	seend>$0A3-1
		DC.L	SA3
	endif
	if	seend>$0A4-1
		DC.L	SA4
	endif
	if	seend>$0A5-1
		DC.L	SA5
	endif
	if	seend>$0A6-1
		DC.L	SA6
	endif
	if	seend>$0A7-1
		DC.L	SA7
	endif
	if	seend>$0A8-1
		DC.L	SA8
	endif
	if	seend>$0A9-1
		DC.L	SA9
	endif
	if	seend>$0AA-1
		DC.L	SAA
	endif
	if	seend>$0AB-1
		DC.L	SAB
	endif
	if	seend>$0AC-1
		DC.L	SAC
	endif
	if	seend>$0AD-1
		DC.L	SAD
	endif
	if	seend>$0AE-1
		DC.L	SAE
	endif
	if	seend>$0AF-1
		DC.L	SAF
	endif
	if	seend>$0B0-1
		DC.L	SB0
	endif
	if	seend>$0B1-1
		DC.L	SB1
	endif
	if	seend>$0B2-1
		DC.L	SB2
	endif
	if	seend>$0B3-1
		DC.L	SB3
	endif
	if	seend>$0B4-1
		DC.L	SB4
	endif
	if	seend>$0B5-1
		DC.L	SB5
	endif
	if	seend>$0B6-1
		DC.L	SB6
	endif
	if	seend>$0B7-1
		DC.L	SB7
	endif
	if	seend>$0B8-1
		DC.L	SB8
	endif
	if	seend>$0B9-1
		DC.L	SB9
	endif
	if	seend>$0BA-1
		DC.L	SBA
	endif
	if	seend>$0BB-1
		DC.L	SBB
	endif
	if	seend>$0BC-1
		DC.L	SBC
	endif
	if	seend>$0BD-1
		DC.L	SBD
	endif
	if	seend>$0BE-1
		DC.L	SBE
	endif
	if	seend>$0BF-1
		DC.L	SBF
	endif
	if	seend>$0C0-1
		DC.L	SC0
	endif
	if	seend>$0C1-1
		DC.L	SC1
	endif
	if	seend>$0C2-1
		DC.L	SC2
	endif
	if	seend>$0C3-1
		DC.L	SC3
	endif
	if	seend>$0C4-1
		DC.L	SC4
	endif
	if	seend>$0C5-1
		DC.L	SC5
	endif
	if	seend>$0C6-1
		DC.L	SC6
	endif
	if	seend>$0C7-1
		DC.L	SC7
	endif
	if	seend>$0C8-1
		DC.L	SC8
	endif
	if	seend>$0C9-1
		DC.L	SC9
	endif
	if	seend>$0CA-1
		DC.L	SCA
	endif
	if	seend>$0CB-1
		DC.L	SCB
	endif
	if	seend>$0CC-1
		DC.L	SCC
	endif
	if	seend>$0CD-1
		DC.L	SCD
	endif
	if	seend>$0CE-1
		DC.L	SCE
	endif
	if	seend>$0CF-1
		DC.L	SCF
	endif

backtb:
		DC.L	SD0

