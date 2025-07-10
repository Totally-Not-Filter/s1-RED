;---------------------------------------------------------------------------
; Sprite
;
; Sonic
;---------------------------------------------------------------------------
play00:
		tst.w	editmode
		beq.b	?jump
		jmp	edit
?jump:
		moveq	#0,d0
		move.b	r_no0(a0),d0
		move.w	play00_move_tbl(pc,d0.w),d1
		jmp	play00_move_tbl(pc,d1.w)
play00_move_tbl:
		dc.w play00init-play00_move_tbl
		dc.w play00move-play00_move_tbl
		dc.w loc_137F2-play00_move_tbl
		dc.w loc_13862-play00_move_tbl
		dc.w loc_13902-play00_move_tbl
play00init:
		addq.b	#word,r_no0(a0)
		move.b	#19,sprvsize(a0)
		move.b	#9,sprhsize(a0)
		move.l	#playpat,patbase(a0)
		move.w	#$0780,sproffset(a0)
		move.b	#2,sprpri(a0)
		move.b	#$18,sprhs(a0)
		move.b	#4,actflg(a0)
		move.w	#$600,plmaxspdwk
		move.w	#$C,pladdspdwk
		move.w	#$80,plretspdwk
play00move:
		tst.w	debugflag
		beq.b	?jump5
		btst.b	#4,swdata1+1
		beq.b	?jump5
		move.w	#1,editmode
		clr.b	$FFFFF7CC
		rts
?jump5:
		tst.b	$FFFFF7CC
		bne.b	loc_12C64
		move.w	swdata1,swdata
loc_12C64:
		btst.b	#0,$FFFFF7C8
		bne.b	loc_12C7E
		moveq	#0,d0
		move.b	cddat(a0),d0
		andi.w	#6,d0
		move.w	play00move_tbl(pc,d0.w),d1
		jsr	play00move_tbl(pc,d1.w)
loc_12C7E:
		bsr.b	sub_12CCE
		bsr.w	sub_12D5E
		bsr.w	sub_12D78
		move.b	$FFFFF768,$36(a0)
		move.b	$FFFFF76A,$37(a0)
		tst.b	$FFFFF7C7
		beq.b	loc_12CA6
		tst.b	mstno(a0)
		bne.b	loc_12CA6
		move.b	$1D(a0),mstno(a0)
loc_12CA6:
		bsr.w	sub_139C4
		tst.b	$FFFFF7C8
		bmi.b	loc_12CB6
		jsr	pcol
loc_12CB6:
		bsr.w	sub_13916
		bsr.w	playwrt
		rts
play00move_tbl:
		dc.w play00walk-play00move_tbl
		dc.w play00jump-play00move_tbl
		dc.w loc_12E66-play00move_tbl
		dc.w loc_12E86-play00move_tbl
bgmtbl2:
		dc.b $81
		dc.b $82
		dc.b $83
		dc.b $84
		dc.b $85
		dc.b $86
		even
sub_12CCE:
		move.w	$30(a0),d0
		beq.b	loc_12CDC
		subq.w	#1,$30(a0)
		lsr.w	#3,d0
		bcc.b	loc_12CE2
loc_12CDC:
		jsr	actionsub
loc_12CE2:
		tst.b	$FFFFFE2D
		beq.b	loc_12D28
		tst.w	$32(a0)
		beq.b	loc_12D28
		subq.w	#1,$32(a0)
		bne.b	loc_12D28
		tst.b	$FFFFF7AA
		bne.b	loc_12D22
		cmpi.w	#12,$FFFFFE14
		bcs.b	loc_12D22
		moveq	#0,d0
		move.b	stageno,d0
		cmpi.w	#$103,stageno
		bne.b	loc_12D12
		moveq	#5,d0
loc_12D12:
		lea	bgmtbl2,a1
		move.b	(a1,d0.w),d0
		jsr	bgmset.l
loc_12D22:
		move.b	#0,$FFFFFE2D
loc_12D28:
		tst.b	$FFFFFE2E
		beq.b	locret_12D5C
		tst.w	speeduptimer(a0)
		beq.b	locret_12D5C
		subq.w	#1,speeduptimer(a0)
		bne.b	locret_12D5C
		move.w	#$600,plmaxspdwk
		move.w	#$C,pladdspdwk
		move.w	#$80,plretspdwk
		move.b	#0,$FFFFFE2E
		move.w	#$E3,d0
		jmp	bgmset.l
locret_12D5C:
		rts
sub_12D5E:
		move.w	$FFFFF7A8,d0
		lea	$FFFFCB00,a1
		lea	(a1,d0.w),a1
		move.w	xposi(a0),(a1)+
		move.w	yposi(a0),(a1)+
		addq.b	#4,$FFFFF7A9
		rts
sub_12D78:
		cmpi.b	#1,stageno
		beq.b	Sonic_Underwater
locret_12D80:
		rts
Sonic_Underwater:
		move.w	waterposi,d0
		cmp.w	yposi(a0),d0
		bge.b	loc_12DD4
		bset.b	#6,cddat(a0)
		bne.b	locret_12D80
		bsr.w	sub_1408E
		move.b	#plawa_act,$FFFFD000+$340+actno
		move.b	#$81,$FFFFD000+$340+userflag
		move.w	#$300,plmaxspdwk
		move.w	#6,pladdspdwk
		move.w	#$40,plretspdwk
		asr.w	xspeed(a0)
		asr.w	yspeed(a0)
		asr.w	yspeed(a0)
		beq.b	locret_12D80
		move.b	#exit2_act,$FFFFD000+$300+actno
		move.w	#$AA,d0
		jmp	soundset.l
loc_12DD4:
		bclr.b	#6,cddat(a0)
		beq.b	locret_12D80
		bsr.w	sub_1408E
		move.w	#$600,plmaxspdwk
		move.w	#$C,pladdspdwk
		move.w	#$80,plretspdwk
		asl.w	yspeed(a0)
		beq.w	locret_12D80
		move.b	#exit2_act,$FFFFD000+$300+actno
		cmpi.w	#-$1000,yspeed(a0)
		bgt.b	loc_12E0E
		move.w	#-$1000,yspeed(a0)
loc_12E0E:
		move.w	#$AA,d0
		jmp	soundset.l
play00walk:
		bsr.w	Sonic_Jump
		bsr.w	sub_134D4
		bsr.w	sub_12EB0
		bsr.w	sub_13384
		bsr.w	sub_13304
		jsr	speedset2
		bsr.w	sub_145EE
		bsr.w	sub_13546
		rts
play00jump:
		bsr.w	sub_13498
		bsr.w	sub_13248
		bsr.w	sub_13304
		jsr	speedset
		btst.b	#6,cddat(a0)
		beq.b	loc_12E5C
		subi.w	#$28,yspeed(a0)
loc_12E5C:
		bsr.w	sub_13588
		bsr.w	sub_135A4
		rts
loc_12E66:
		bsr.w	Sonic_Jump
		bsr.w	sub_1350A
		bsr.w	sub_13150
		bsr.w	sub_13304
		jsr	speedset2
		bsr.w	sub_145EE
		bsr.w	sub_13546
		rts
loc_12E86:
		bsr.w	sub_13498
		bsr.w	sub_13248
		bsr.w	sub_13304
		jsr	speedset
		btst.b	#6,cddat(a0)
		beq.b	loc_12EA6
		subi.w	#$28,yspeed(a0)
loc_12EA6:
		bsr.w	sub_13588
		bsr.w	sub_135A4
		rts
sub_12EB0:
		move.w	plmaxspdwk,d6
		move.w	pladdspdwk,d5
		move.w	plretspdwk,d4
		tst.b	$FFFFF7CA
		bne.w	loc_12FEE
		tst.w	$3E(a0)
		bne.w	loc_12FB0
		btst.b	#2,swdata
		beq.b	loc_12ED8
		bsr.w	Sonic_MoveLeft
loc_12ED8:
		btst.b	#3,swdata
		beq.b	loc_12EE4
		bsr.w	Sonic_MoveRight
loc_12EE4:
		move.b	direc(a0),d0
		addi.b	#$20,d0
		andi.b	#$c0,d0
		bne.w	loc_12FB0
		tst.w	mspeed(a0)
		bne.w	loc_12FB0
		bclr.b	#5,cddat(a0)
		move.b	#5,mstno(a0)
		btst.b	#3,cddat(a0)
		beq.b	loc_12F46
		moveq	#0,d0
		move.b	$3D(a0),d0
		lsl.w	#6,d0	; 2^6 (0x40)
		lea	playerwk,a1
		lea	(a1,d0.w),a1
		tst.b	cddat(a1)
		bmi.b	loc_12F78
		moveq	#0,d1
		move.b	sprhs(a1),d1
		move.w	d1,d2
		add.w	d2,d2
		subq.w	#4,d2
		add.w	xposi(a0),d1
		sub.w	xposi(a1),d1
		cmpi.w	#4,d1
		blt.b	loc_12F6A
		cmp.w	d2,d1
		bge.b	loc_12F5A
		bra.b	loc_12F78
loc_12F46:
		jsr	sub_14E18
		cmpi.w	#$C,d1
		blt.b	loc_12F78
		cmpi.b	#3,footdir(a0)
		bne.b	loc_12F62
loc_12F5A:
		bclr.b	#0,cddat(a0)
		bra.b	loc_12F70
loc_12F62:
		cmpi.b	#3,$37(a0)
		bne.b	loc_12F78
loc_12F6A:
		bset.b	#0,cddat(a0)
loc_12F70:
		move.b	#6,mstno(a0)
		bra.b	loc_12FB0
loc_12F78:
		btst.b	#0,swdata
		beq.b	loc_12F94

Sonic_MoveUp:
		move.b	#7,mstno(a0)
		cmpi.w	#$C8,$FFFFF73E
		beq.b	loc_12FC2
		addq.w	#2,$FFFFF73E
		bra.b	loc_12FC2
loc_12F94:
		btst.b	#1,swdata
		beq.b	loc_12FB0
Sonic_MoveDown:
		move.b	#8,mstno(a0)
		cmpi.w	#8,$FFFFF73E
		beq.b	loc_12FC2
		subq.w	#2,$FFFFF73E
		bra.b	loc_12FC2
loc_12FB0:
		cmpi.w	#$60,$FFFFF73E
		beq.b	loc_12FC2
		bcc.b	loc_12FBE
		addq.w	#4,$FFFFF73E
loc_12FBE:
		subq.w	#2,$FFFFF73E
loc_12FC2:
		move.b	swdata,d0
		andi.b	#$C,d0
		bne.b	loc_12FEE
		move.w	mspeed(a0),d0
		beq.b	loc_12FEE
		bmi.b	loc_12FE2
		sub.w	d5,d0
		bcc.b	loc_12FDC
		move.w	#0,d0
loc_12FDC:
		move.w	d0,mspeed(a0)
		bra.b	loc_12FEE
loc_12FE2:
		add.w	d5,d0
		bcc.b	loc_12FEA
		move.w	#0,d0
loc_12FEA:
		move.w	d0,mspeed(a0)
loc_12FEE:
		move.b	direc(a0),d0
		jsr	sinset.l
		muls.w	mspeed(a0),d1
		asr.l	#8,d1
		move.w	d1,xspeed(a0)
		muls.w	mspeed(a0),d0
		asr.l	#8,d0
		move.w	d0,yspeed(a0)
loc_1300C:
		move.b	direc(a0),d0
		addi.b	#$40,d0
		bmi.b	locret_1307C
		move.b	#$40,d1
		tst.w	mspeed(a0)
		beq.b	locret_1307C
		bmi.b	loc_13024
		neg.w	d1
loc_13024:
		move.b	direc(a0),d0
		add.b	d1,d0
		move.w	d0,-(sp)
		bsr.w	sub_14CDE
		move.w	(sp)+,d0
		tst.w	d1
		bpl.b	locret_1307C
		asl.w	#8,d1
		addi.b	#$20,d0
		andi.b	#$c0,d0
		beq.b	loc_13078
		cmpi.b	#$40,d0
		beq.b	loc_13066
		cmpi.b	#$80,d0
		beq.b	loc_13060
		add.w	d1,xspeed(a0)
		bset.b	#5,cddat(a0)
		move.w	#0,mspeed(a0)
		rts
loc_13060:
		sub.w	d1,yspeed(a0)
		rts
loc_13066:
		sub.w	d1,xspeed(a0)
		bset.b	#5,cddat(a0)
		move.w	#0,mspeed(a0)
		rts
loc_13078:
		add.w	d1,yspeed(a0)
locret_1307C:
		rts
Sonic_MoveLeft:
		move.w	mspeed(a0),d0
		beq.b	loc_13086
		bpl.b	loc_130B2
loc_13086:
		bset.b	#0,cddat(a0)
		bne.b	loc_1309A
		bclr.b	#5,cddat(a0)
		move.b	#1,$1D(a0)
loc_1309A:
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.b	loc_130A6
		move.w	d1,d0
loc_130A6:
		move.w	d0,mspeed(a0)
		move.b	#0,mstno(a0)
		rts
loc_130B2:
		sub.w	d4,d0
		bcc.b	loc_130BA
		move.w	#-$80,d0
loc_130BA:
		move.w	d0,mspeed(a0)
		move.b	direc(a0),d0
		addi.b	#$20,d0
		andi.b	#$c0,d0
		bne.b	locret_130E8
		cmpi.w	#$400,d0
		blt.b	locret_130E8
		move.b	#$D,mstno(a0)
		bclr.b	#0,cddat(a0)
		move.w	#$A4,d0
		jsr	soundset.l
locret_130E8:
		rts
Sonic_MoveRight:
		move.w	mspeed(a0),d0
		bmi.b	loc_13118
		bclr.b	#0,cddat(a0)
		beq.b	loc_13104
		bclr.b	#5,cddat(a0)
		move.b	#1,$1D(a0)
loc_13104:
		add.w	d5,d0
		cmp.w	d6,d0
		blt.b	loc_1310C
		move.w	d6,d0
loc_1310C:
		move.w	d0,mspeed(a0)
		move.b	#0,mstno(a0)
		rts
loc_13118:
		add.w	d4,d0
		bcc.b	loc_13120
		move.w	#$80,d0
loc_13120:
		move.w	d0,mspeed(a0)
		move.b	direc(a0),d0
		addi.b	#$20,d0
		andi.b	#$c0,d0
		bne.b	locret_1314E
		cmpi.w	#-$400,d0
		bgt.b	locret_1314E
		move.b	#$D,mstno(a0)
		bset.b	#0,cddat(a0)
		move.w	#$A4,d0
		jsr	soundset.l
locret_1314E:
		rts
sub_13150:
		move.w	plmaxspdwk,d6
		asl.w	#1,d6
		move.w	pladdspdwk,d5
		asr.w	#1,d5
		move.w	plretspdwk,d4
		asr.w	#2,d4
		tst.b	$FFFFF7CA
		bne.w	loc_131CC
		tst.w	$3E(a0)
		bne.b	loc_13188
		btst.b	#2,swdata
		beq.b	loc_1317C
		bsr.w	sub_13202
loc_1317C:
		btst.b	#3,swdata
		beq.b	loc_13188
		bsr.w	sub_13226
loc_13188:
		move.w	mspeed(a0),d0
		beq.b	loc_131AA
		bmi.b	loc_1319E
		sub.w	d5,d0
		bcc.b	loc_13198
		move.w	#0,d0
loc_13198:
		move.w	d0,mspeed(a0)
		bra.b	loc_131AA
loc_1319E:
		add.w	d5,d0
		bcc.b	loc_131A6
		move.w	#0,d0
loc_131A6:
		move.w	d0,mspeed(a0)
loc_131AA:
		tst.w	mspeed(a0)
		bne.b	loc_131CC
		bclr.b	#2,cddat(a0)
		move.b	#19,sprvsize(a0)
		move.b	#9,sprhsize(a0)
		move.b	#5,mstno(a0)
		subq.w	#5,yposi(a0)
loc_131CC:
		move.b	direc(a0),d0
		jsr	sinset.l
		muls.w	mspeed(a0),d0
		asr.l	#8,d0
		move.w	d0,yspeed(a0)
		muls.w	mspeed(a0),d1
		asr.l	#8,d1
		cmpi.w	#$1000,d1
		ble.b	loc_131F0
		move.w	#$1000,d1
loc_131F0:
		cmpi.w	#-$1000,d1
		bge.b	loc_131FA
		move.w	#-$1000,d1
loc_131FA:
		move.w	d1,xspeed(a0)
		bra.w	loc_1300C
sub_13202:
		move.w	mspeed(a0),d0
		beq.b	loc_1320A
		bpl.b	loc_13218
loc_1320A:
		bset.b	#0,cddat(a0)
		move.b	#2,mstno(a0)
		rts
loc_13218:
		sub.w	d4,d0
		bcc.b	loc_13220
		move.w	#-$80,d0
loc_13220:
		move.w	d0,mspeed(a0)
		rts
sub_13226:
		move.w	mspeed(a0),d0
		bmi.b	loc_1323A
		bclr.b	#0,cddat(a0)
		move.b	#2,mstno(a0)
		rts
loc_1323A:
		add.w	d4,d0
		bcc.b	loc_13242
		move.w	#$80,d0
loc_13242:
		move.w	d0,mspeed(a0)
		rts
sub_13248:
		move.w	plmaxspdwk,d6
		move.w	pladdspdwk,d5
		asl.w	#1,d5
		btst.b	#4,cddat(a0)
		bne.b	loc_13292
		move.w	xspeed(a0),d0
		btst.b	#2,swdata
		beq.b	loc_13278
		bset.b	#0,cddat(a0)
		sub.w	d5,d0
		move.w	d6,d1
		neg.w	d1
		cmp.w	d1,d0
		bgt.b	loc_13278
		move.w	d1,d0
loc_13278:
		btst.b	#3,swdata
		beq.b	loc_1328E
		bclr.b	#0,cddat(a0)
		add.w	d5,d0
		cmp.w	d6,d0
		blt.b	loc_1328E
		move.w	d6,d0
loc_1328E:
		move.w	d0,xspeed(a0)
loc_13292:
		cmpi.w	#$60,$FFFFF73E
		beq.b	loc_132A4
		bcc.b	loc_132A0
		addq.w	#4,$FFFFF73E
loc_132A0:
		subq.w	#2,$FFFFF73E
loc_132A4:
		cmpi.w	#-$400,yspeed(a0)
		bcs.b	locret_132D2
		move.w	xspeed(a0),d0
		move.w	d0,d1
		asr.w	#5,d1
		beq.b	locret_132D2
		bmi.b	loc_132C6
		sub.w	d1,d0
		bcc.b	loc_132C0
		move.w	#0,d0
loc_132C0:
		move.w	d0,xspeed(a0)
		rts
loc_132C6:
		sub.w	d1,d0
		bcs.b	loc_132CE
		move.w	#0,d0
loc_132CE:
		move.w	d0,xspeed(a0)
locret_132D2:
		rts
		move.b	direc(a0),d0
		addi.b	#$20,d0
		andi.b	#$c0,d0
		bne.b	locret_13302
		bsr.w	sub_14F08
		tst.w	d1
		bpl.b	locret_13302
		move.w	#0,mspeed(a0)
		move.w	#0,xspeed(a0)
		move.w	#0,yspeed(a0)
		move.b	#$B,mstno(a0)
locret_13302:
		rts
sub_13304:
		move.l	xposi(a0),d1
		move.w	xspeed(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d1
		swap	d1
		move.w	$FFFFF728,d0
		addi.w	#$10,d0
		cmp.w	d1,d0
		bhi.b	loc_1336C
		move.w	$FFFFF72A,d0
		addi.w	#$128,d0
		tst.b	$FFFFF7AA
		bne.b	loc_13332
		addi.w	#$40,d0
loc_13332:
		cmp.w	d1,d0
		bls.b	loc_1336C
loc_13336:
		move.w	$FFFFF72E,d0
		addi.w	#224,d0
		cmp.w	yposi(a0),d0
		blt.b	loc_13346
		rts
loc_13346:
		cmpi.w	#$501,stageno
		bne.w	sub_1B098
		cmpi.w	#$2000,playerwk+xposi
		bcs.w	sub_1B098
		clr.b	$FFFFFE30
		move.w	#1,$FFFFFE02
		move.w	#$103,stageno
		rts
loc_1336C:
		move.w	d0,xposi(a0)
		move.w	#0,xposi+2(a0)
		move.w	#0,xspeed(a0)
		move.w	#0,mspeed(a0)
		bra.b	loc_13336
sub_13384:
		tst.b	$FFFFF7CA
		bne.b	locret_133AA
		move.w	mspeed(a0),d0
		bpl.b	loc_13392
		neg.w	d0
loc_13392:
		cmpi.w	#$80,d0
		bcs.b	locret_133AA
		move.b	swdata,d0
		andi.b	#$C,d0
		bne.b	locret_133AA
		btst.b	#1,swdata
		bne.b	loc_133AC
locret_133AA:
		rts
loc_133AC:
		btst.b	#2,cddat(a0)
		beq.b	loc_133B6
		rts
loc_133B6:
		bset.b	#2,cddat(a0)
		move.b	#14,sprvsize(a0)
		move.b	#7,sprhsize(a0)
		move.b	#2,mstno(a0)
		addq.w	#5,yposi(a0)
		move.w	#$BE,d0
		jsr	soundset.l
		tst.w	mspeed(a0)
		bne.b	locret_133E8
		move.w	#$200,mspeed(a0)
locret_133E8:
		rts
Sonic_Jump:
		move.b	swdata+1,d0
		andi.b	#$70,d0
		beq.w	locret_1348E
		moveq	#0,d0
		move.b	direc(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_14D48
		cmpi.w	#6,d1
		blt.w	locret_1348E
		move.w	#$680,d2
		btst.b	#6,cddat(a0)
		beq.b	loc_1341C
		move.w	#$380,d2
loc_1341C:
		moveq	#0,d0
		move.b	direc(a0),d0
		subi.b	#$40,d0
		jsr	sinset.l
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,xspeed(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,yspeed(a0)
		bset.b	#1,cddat(a0)
		bclr.b	#5,cddat(a0)
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		clr.b	$38(a0)
		move.w	#$A0,d0
		jsr	soundset.l
		move.b	#19,sprvsize(a0)
		move.b	#9,sprhsize(a0)
		btst.b	#2,cddat(a0)
		bne.b	loc_13490
		move.b	#14,sprvsize(a0)
		move.b	#7,sprhsize(a0)
		move.b	#2,mstno(a0)
		bset.b	#2,cddat(a0)
		addq.w	#5,yposi(a0)
locret_1348E:
		rts
loc_13490:
		bset.b	#4,cddat(a0)
		rts
sub_13498:
		tst.b	$3C(a0)
		beq.b	loc_134C4
		move.w	#-$400,d1
		btst.b	#6,cddat(a0)
		beq.b	loc_134AE
		move.w	#-$200,d1
loc_134AE:
		cmp.w	yspeed(a0),d1
		ble.b	locret_134C2
		move.b	swdata,d0
		andi.b	#$70,d0
		bne.b	locret_134C2
		move.w	d1,yspeed(a0)
locret_134C2:
		rts
loc_134C4:
		cmpi.w	#-$FC0,yspeed(a0)
		bge.b	locret_134D2
		move.w	#-$FC0,yspeed(a0)
locret_134D2:
		rts
sub_134D4:
		move.b	direc(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$c0,d0
		bcc.b	locret_13508
		move.b	direc(a0),d0
		jsr	sinset.l
		muls.w	#$20,d0
		asr.l	#8,d0
		tst.w	mspeed(a0)
		beq.b	locret_13508
		bmi.b	loc_13504
		tst.w	d0
		beq.b	locret_13502
		add.w	d0,mspeed(a0)
locret_13502:
		rts
loc_13504:
		add.w	d0,mspeed(a0)
locret_13508:
		rts
sub_1350A:
		move.b	direc(a0),d0
		addi.b	#$60,d0
		cmpi.b	#$c0,d0
		bcc.b	locret_13544
		move.b	direc(a0),d0
		jsr	sinset.l
		muls.w	#$50,d0
		asr.l	#8,d0
		tst.w	mspeed(a0)
		bmi.b	loc_1353A
		tst.w	d0
		bpl.b	loc_13534
		asr.l	#2,d0
loc_13534:
		add.w	d0,mspeed(a0)
		rts
loc_1353A:
		tst.w	d0
		bmi.b	loc_13540
		asr.l	#2,d0
loc_13540:
		add.w	d0,mspeed(a0)
locret_13544:
		rts
sub_13546:
		nop	
		tst.b	$38(a0)
		bne.b	locret_13580
		tst.w	$3E(a0)
		bne.b	loc_13582
		move.b	direc(a0),d0
		addi.b	#$20,d0
		andi.b	#$c0,d0
		beq.b	locret_13580
		move.w	mspeed(a0),d0
		bpl.b	loc_1356A
		neg.w	d0
loc_1356A:
		cmpi.w	#$280,d0
		bcc.b	locret_13580
		clr.w	mspeed(a0)
		bset.b	#1,cddat(a0)
		move.w	#$1E,$3E(a0)
locret_13580:
		rts
loc_13582:
		subq.w	#1,$3E(a0)
		rts
sub_13588:
		move.b	direc(a0),d0
		beq.b	locret_135A2
		bpl.b	loc_13598
		addq.b	#2,d0
		bcc.b	loc_13596
		moveq	#0,d0
loc_13596:
		bra.b	loc_1359E
loc_13598:
		subq.b	#2,d0
		bcc.b	loc_1359E
		moveq	#0,d0
loc_1359E:
		move.b	d0,direc(a0)
locret_135A2:
		rts
sub_135A4:
		move.w	xspeed(a0),d1
		move.w	yspeed(a0),d2
		jsr	atan.l
		move.b	d0,$FFFFFFEC
		subi.b	#$20,d0
		move.b	d0,$FFFFFFED
		andi.b	#$c0,d0
		move.b	d0,$FFFFFFEE
		cmpi.b	#$40,d0
		beq.w	loc_13680
		cmpi.b	#$80,d0
		beq.w	loc_136E2
		cmpi.b	#$c0,d0
		beq.w	loc_1373E
		bsr.w	sub_15042
		tst.w	d1
		bpl.b	loc_135F0
		sub.w	d1,xposi(a0)
		move.w	#0,xspeed(a0)
loc_135F0:
		bsr.w	sub_14EB4
		tst.w	d1
		bpl.b	loc_13602
		add.w	d1,xposi(a0)
		move.w	#0,xspeed(a0)
loc_13602:
		bsr.w	sub_14D70
		move.b	d1,$FFFFFFEF
		tst.w	d1
		bpl.b	locret_1367E
		move.b	yspeed(a0),d2
		addq.b	#8,d2
		neg.b	d2
		cmp.b	d2,d1
		bge.b	loc_1361E
		cmp.b	d2,d0
		blt.b	locret_1367E
loc_1361E:
		add.w	d1,yposi(a0)
		move.b	d3,direc(a0)
		bsr.w	sub_137A0
		move.b	#0,mstno(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.b	loc_1365C
		move.b	d3,d0
		addi.b	#$10,d0
		andi.b	#$20,d0
		beq.b	loc_1364E
		asr.w	yspeed(a0)
		bra.b	loc_13670
loc_1364E:
		move.w	#0,yspeed(a0)
		move.w	xspeed(a0),mspeed(a0)
		rts
loc_1365C:
		move.w	#0,xspeed(a0)
		cmpi.w	#$FC0,yspeed(a0)
		ble.b	loc_13670
		move.w	#$FC0,yspeed(a0)
loc_13670:
		move.w	yspeed(a0),mspeed(a0)
		tst.b	d3
		bpl.b	locret_1367E
		neg.w	mspeed(a0)
locret_1367E:
		rts
loc_13680:
		bsr.w	sub_15042
		tst.w	d1
		bpl.b	loc_1369A
		sub.w	d1,xposi(a0)
		move.w	#0,xspeed(a0)
		move.w	yspeed(a0),mspeed(a0)
		rts
loc_1369A:
		bsr.w	sub_14F08
		tst.w	d1
		bpl.b	loc_136B4
		sub.w	d1,yposi(a0)
		tst.w	yspeed(a0)
		bpl.b	locret_136B2
		move.w	#0,yspeed(a0)
locret_136B2:
		rts
loc_136B4:
		tst.w	yspeed(a0)
		bmi.b	locret_136E0
		bsr.w	sub_14D70
		tst.w	d1
		bpl.b	locret_136E0
		add.w	d1,yposi(a0)
		move.b	d3,direc(a0)
		bsr.w	sub_137A0
		move.b	#0,mstno(a0)
		move.w	#0,yspeed(a0)
		move.w	xspeed(a0),mspeed(a0)
locret_136E0:
		rts
loc_136E2:
		bsr.w	sub_15042
		tst.w	d1
		bpl.b	loc_136F4
		sub.w	d1,xposi(a0)
		move.w	#0,xspeed(a0)
loc_136F4:
		bsr.w	sub_14EB4
		tst.w	d1
		bpl.b	loc_13706
		add.w	d1,xposi(a0)
		move.w	#0,xspeed(a0)
loc_13706:
		bsr.w	sub_14F08
		tst.w	d1
		bpl.b	locret_1373C
		sub.w	d1,yposi(a0)
		move.b	d3,d0
		addi.b	#$20,d0
		andi.b	#$40,d0
		bne.b	loc_13726
		move.w	#0,yspeed(a0)
		rts
loc_13726:
		move.b	d3,direc(a0)
		bsr.w	sub_137A0
		move.w	yspeed(a0),mspeed(a0)
		tst.b	d3
		bpl.b	locret_1373C
		neg.w	mspeed(a0)
locret_1373C:
		rts
loc_1373E:
		bsr.w	sub_14EB4
		tst.w	d1
		bpl.b	loc_13758
		add.w	d1,xposi(a0)
		move.w	#0,xspeed(a0)
		move.w	yspeed(a0),mspeed(a0)
		rts
loc_13758:
		bsr.w	sub_14F08
		tst.w	d1
		bpl.b	loc_13772
		sub.w	d1,yposi(a0)
		tst.w	yspeed(a0)
		bpl.b	locret_13770
		move.w	#0,yspeed(a0)
locret_13770:
		rts
loc_13772:
		tst.w	yspeed(a0)
		bmi.b	locret_1379E
		bsr.w	sub_14D70
		tst.w	d1
		bpl.b	locret_1379E
		add.w	d1,yposi(a0)
		move.b	d3,direc(a0)
		bsr.w	sub_137A0
		move.b	#0,mstno(a0)
		move.w	#0,yspeed(a0)
		move.w	xspeed(a0),mspeed(a0)
locret_1379E:
		rts
sub_137A0:
		btst.b	#4,cddat(a0)
		beq.b	loc_137AE
		nop
		nop
		nop
loc_137AE:
		bclr.b	#5,cddat(a0)
		bclr.b	#1,cddat(a0)
		bclr.b	#4,cddat(a0)
		btst.b	#2,cddat(a0)
		beq.b	loc_137E4
		bclr.b	#2,cddat(a0)
		move.b	#19,sprvsize(a0)
		move.b	#9,sprhsize(a0)
		move.b	#0,mstno(a0)
		subq.w	#5,yposi(a0)
loc_137E4:
		move.b	#0,$3C(a0)
		move.w	#0,$FFFFF7D0
		rts
loc_137F2:
		jsr	speedset2
		addi.w	#$30,yspeed(a0)
		btst.b	#6,cddat(a0)
		beq.b	loc_1380C
		subi.w	#$20,yspeed(a0)
loc_1380C:
		bsr.w	loc_13826
		bsr.w	sub_13304
		bsr.w	sub_12D5E
		bsr.w	sub_139C4
		bsr.w	playwrt
		jmp	actionsub
loc_13826:
		move.w	$FFFFF72E,d0
		addi.w	#224,d0
		cmp.w	yposi(a0),d0
		bcs.w	sub_1B098
		bsr.w	sub_135A4
		btst.b	#1,cddat(a0)
		bne.b	locret_13860
		moveq	#0,d0
		move.w	d0,yspeed(a0)
		move.w	d0,xspeed(a0)
		move.w	d0,mspeed(a0)
		move.b	#0,mstno(a0)
		subq.b	#2,r_no0(a0)
		move.w	#120,$30(a0)
locret_13860:
		rts
loc_13862:
		bsr.w	loc_1387E
		jsr	speedset
		bsr.w	sub_12D5E
		bsr.w	sub_139C4
		bsr.w	playwrt
		jmp	actionsub
loc_1387E:
		move.w	$FFFFF72E,d0
		addi.w	#256,d0
		cmp.w	yposi(a0),d0
		bcc.w	locret_13900
		move.w	#-$38,yspeed(a0)
		addq.b	#2,r_no0(a0)
		clr.b	$FFFFFE1E
		addq.b	#1,$FFFFFE1C
		subq.b	#1,$FFFFFE12
		bne.b	loc_138D4
		move.w	#0,$3A(a0)
		move.b	#over_act,$FFFFD000+$80+actno
		move.b	#over_act,$FFFFD000+$C0+actno
		move.b	#1,$FFFFD000+$C0+patno
		clr.b	$FFFFFE1A
loc_138C2:
		move.w	#$8F,d0
		jsr	bgmset.l
		moveq	#3,d0
		jmp	PlcLoad_1580.l
loc_138D4:
		move.w	#60,$3A(a0)
		tst.b	$FFFFFE1A
		beq.b	locret_13900
		move.w	#0,$3A(a0)
		move.b	#over_act,$FFFFD000+$80+actno
		move.b	#over_act,$FFFFD000+$C0+actno
		move.b	#2,$FFFFD000+$80+patno
		move.b	#3,$FFFFD000+$C0+patno
		bra.b	loc_138C2
locret_13900:
		rts
loc_13902:
		tst.w	$3A(a0)
		beq.b	locret_13914
		subq.w	#1,$3A(a0)
		bne.b	locret_13914
		move.w	#1,$FFFFFE02
locret_13914:
		rts
sub_13916:
		cmpi.b	#3,stageno
		beq.b	loc_13926
		tst.b	stageno
		bne.w	locret_139C2
loc_13926:
		move.w	yposi(a0),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		move.b	xposi(a0),d1
		andi.w	#$7f,d1
		add.w	d1,d0
		lea	mapwka,a1
		move.b	(a1,d0.w),d1
		cmp.b	$FFFFF7AE,d1
		beq.w	loc_133AC
		cmp.b	$FFFFF7AF,d1
		beq.w	loc_133AC
		cmp.b	$FFFFF7AC,d1
		beq.b	loc_13976
		cmp.b	$FFFFF7AD,d1
		beq.b	loc_13966
		bclr.b	#6,actflg(a0)
		rts
loc_13966:
		btst.b	#1,cddat(a0)
		beq.b	loc_13976
		bclr.b	#6,actflg(a0)
		rts
loc_13976:
		move.w	xposi(a0),d2
		cmpi.b	#$2c,d2
		bcc.b	loc_13988
		bclr.b	#6,actflg(a0)
		rts
loc_13988:
		cmpi.b	#$e0,d2
		bcs.b	loc_13996
		bset.b	#6,actflg(a0)
		rts
loc_13996:
		btst.b	#6,actflg(a0)
		bne.b	loc_139B2
		move.b	direc(a0),d1
		beq.b	locret_139C2
		cmpi.b	#$80,d1
		bhi.b	locret_139C2
		bset.b	#6,actflg(a0)
		rts
loc_139B2:
		move.b	direc(a0),d1
		cmpi.b	#$80,d1
		bls.b	locret_139C2
		bclr.b	#6,actflg(a0)
locret_139C2:
		rts
sub_139C4:
		lea	off_13B48,a1
		moveq	#0,d0
		move.b	mstno(a0),d0
		cmp.b	$1D(a0),d0
		beq.b	loc_139E6
		move.b	d0,$1D(a0)
		move.b	#0,patcnt(a0)
		move.b	#0,pattim(a0)
loc_139E6:
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		move.b	(a1),d0
		bmi.b	loc_13A52
		move.b	cddat(a0),d1
		andi.b	#1,d1
		andi.b	#-4,actflg(a0)
		or.b	d1,actflg(a0)
		subq.b	#1,pattim(a0)
		bpl.b	locret_13A20
		move.b	d0,pattim(a0)
sub_13A0C:
		moveq	#0,d1
		move.b	patcnt(a0),d1
		move.b	1(a1,d1.w),d0
		bmi.b	loc_13A22
loc_13A18:
		move.b	d0,patno(a0)
		addq.b	#1,patcnt(a0)
locret_13A20:
		rts
loc_13A22:
		addq.b	#1,d0
		bne.b	loc_13A32
		move.b	#0,patcnt(a0)
		move.b	1(a1),d0
		bra.b	loc_13A18
loc_13A32:
		addq.b	#1,d0
		bne.b	loc_13A46
		move.b	2(a1,d1.w),d0
		sub.b	d0,patcnt(a0)
		sub.b	d0,d1
		move.b	1(a1,d1.w),d0
		bra.b	loc_13A18
loc_13A46:
		addq.b	#1,d0
		bne.b	locret_13A50
		move.b	2(a1,d1.w),mstno(a0)
locret_13A50:
		rts
loc_13A52:
		subq.b	#1,pattim(a0)
		bpl.b	locret_13A20
		addq.b	#1,d0
		bne.w	loc_13AD2
		moveq	#0,d1
		move.b	direc(a0),d0
		move.b	cddat(a0),d2
		andi.b	#1,d2
		bne.b	loc_13A70
		not.b	d0
loc_13A70:
		addi.b	#$10,d0
		bpl.b	loc_13A78
		moveq	#3,d1
loc_13A78:
		andi.b	#-4,actflg(a0)
		eor.b	d1,d2
		or.b	d2,actflg(a0)
		btst.b	#5,cddat(a0)
		bne.w	loc_13B16
		lsr.b	#4,d0
		andi.b	#6,d0
		move.w	mspeed(a0),d2
		bpl.b	loc_13A9C
		neg.w	d2
loc_13A9C:
		lea	byte_13B8E,a1
		cmpi.w	#$600,d2
		bcc.b	loc_13AB4
		lea	byte_13B86,a1
		move.b	d0,d1
		lsr.b	#1,d1
		add.b	d1,d0
loc_13AB4:
		add.b	d0,d0
		move.b	d0,d3
		neg.w	d2
		addi.w	#$800,d2
		bpl.b	loc_13AC2
		moveq	#0,d2
loc_13AC2:
		lsr.w	#8,d2
		move.b	d2,pattim(a0)
		bsr.w	sub_13A0C
		add.b	d3,patno(a0)
		rts
loc_13AD2:
		addq.b	#1,d0
		bne.b	loc_13B16
		move.w	mspeed(a0),d2
		bpl.b	loc_13ADE
		neg.w	d2
loc_13ADE:
		lea	byte_13B9E,a1
		cmpi.w	#$600,d2
		bcc.b	loc_13AF0
		lea	byte_13B96,a1
loc_13AF0:
		neg.w	d2
		addi.w	#$400,d2
		bpl.b	loc_13AFA
		moveq	#0,d2
loc_13AFA:
		lsr.w	#8,d2
		move.b	d2,pattim(a0)
		move.b	cddat(a0),d1
		andi.b	#1,d1
		andi.b	#-4,actflg(a0)
		or.b	d1,actflg(a0)
		bra.w	sub_13A0C
loc_13B16:
		move.w	mspeed(a0),d2
		bmi.b	loc_13B1E
		neg.w	d2
loc_13B1E:
		addi.w	#$800,d2
		bpl.b	loc_13B26
		moveq	#0,d2
loc_13B26:
		lsr.w	#6,d2
		move.b	d2,pattim(a0)
		lea	byte_13BA6,a1
		move.b	cddat(a0),d1
		andi.b	#1,d1
		andi.b	#-4,actflg(a0)
		or.b	d1,actflg(a0)
		bra.w	sub_13A0C
off_13B48:
		dc.w byte_13B86-off_13B48; 0
		dc.w byte_13B8E-off_13B48; 1
		dc.w byte_13B96-off_13B48; 2
		dc.w byte_13B9E-off_13B48; 3
		dc.w byte_13BA6-off_13B48; 4
		dc.w byte_13BAE-off_13B48; 5
		dc.w byte_13BC4-off_13B48; 6
		dc.w byte_13BC8-off_13B48; 7
		dc.w byte_13BCC-off_13B48; 8
		dc.w byte_13BD0-off_13B48; 9
		dc.w byte_13BD4-off_13B48; 10
		dc.w byte_13BD8-off_13B48; 11
		dc.w byte_13BDC-off_13B48; 12
		dc.w byte_13BE0-off_13B48; 13
		dc.w byte_13BE4-off_13B48; 14
		dc.w byte_13BE8-off_13B48; 15
		dc.w byte_13BF0-off_13B48; 16
		dc.w byte_13BF4-off_13B48; 17
		dc.w byte_13BF8-off_13B48; 18
		dc.w byte_13BFE-off_13B48; 19
		dc.w byte_13C04-off_13B48; 20
		dc.w byte_13C08-off_13B48; 21
		dc.w byte_13C10-off_13B48; 22
		dc.w byte_13C14-off_13B48; 23
		dc.w byte_13C18-off_13B48; 24
		dc.w byte_13C1C-off_13B48; 25
		dc.w byte_13C26-off_13B48; 26
		dc.w byte_13C2A-off_13B48; 27
		dc.w byte_13C2E-off_13B48; 28
		dc.w byte_13C32-off_13B48; 29
		dc.w byte_13C3A-off_13B48; 30
byte_13B86:
		dc.b $FF,  8,  9, $A, $B,  6,  7,$FF
		even
byte_13B8E:
		dc.b $FF,$1E,$1F,$20,$21,$FF,$FF,$FF
		even
byte_13B96:
		dc.b $FE,$2E,$2F,$30,$31,$32,$FF,$FF
		even
byte_13B9E:
		dc.b $FE,$2E,$2F,$32,$30,$31,$32,$FF
		even
byte_13BA6:
		dc.b $FD,$45,$46,$47,$48,$FF,$FF,$FF
		even
byte_13BAE:
		dc.b $17,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  2,  2
		dc.b   2,  3,  4,$FE,  2
		even
byte_13BC4:
		dc.b $1F,$3A,$3B,$FF
		even
byte_13BC8:
		dc.b $3F,  5,$FF
		even
byte_13BCC:
		dc.b $3F,$39,$FF
		even
byte_13BD0:
		dc.b $3F,$33,$FF
		even
byte_13BD4:
		dc.b $3F,$34,$FF
		even
byte_13BD8:
		dc.b $3F,$35,$FF
		even
byte_13BDC:
		dc.b $3F,$36,$FF
		even
byte_13BE0:
		dc.b   7,$37,$38,$FF
		even
byte_13BE4:
		dc.b   7,$3C,$3F,$FF
		even
byte_13BE8:
		dc.b   7,$3C,$3D,$53,$3E,$54,$FF
		even
byte_13BF0:
		dc.b $2F,$40,$FD,  0
		even
byte_13BF4:
		dc.b   4,$41,$42,$FF
		even
byte_13BF8:
		dc.b  $F,$43,$43,$43,$FE,  1
		even
byte_13BFE:
		dc.b  $F,$43,$44,$FE,  1
		even
byte_13C04:
		dc.b $3F,$49,$FF
		even
byte_13C08:
		dc.b  $B,$56,$56, $A, $B,$FD,  0
		even
byte_13C10:
		dc.b $20,$4B,$FF
		even
byte_13C14:
		dc.b $2F,$4C,$FF
		even
byte_13C18:
		dc.b   3,$4D,$FF
		even
byte_13C1C:
		dc.b   3,$4E,$4F,$50,$51,$52,  0,$FE,  1
		even
byte_13C26:
		dc.b   3,$55,$FF
		even
byte_13C2A:
		dc.b   7,$55,$57,$FF
		even
byte_13C2E:
		dc.b $77,  0,$FD,  0
		even
byte_13C32:
		dc.b   3,$3C,$3D,$53,$3E,$54,$FF
		even
byte_13C3A:
		dc.b   3,$3C,$FD,  0
		even
playwrt:
		moveq	#0,d0
		move.b	patno(a0),d0
		cmp.b	plpatno,d0
		beq.b	locret_13C96
		move.b	d0,plpatno
		lea	Off_SonicLoadCues,a2
		add.w	d0,d0
		adda.w	(a2,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.b	#1,d1
		bmi.b	locret_13C96
		lea	$FFFFC800,a3
		move.b	#1,playwrtflag
Sonic_PatternLoad:
		moveq	#0,d2
		move.b	(a2)+,d2
		move.w	d2,d0
		lsr.b	#4,d0
		lsl.w	#8,d2
		move.b	(a2)+,d2
		lsl.w	#5,d2
		lea	ArtUnc_Sonic,a1
		adda.l	d2,a1
loc_13C82:
		movem.l	(a1)+,d2-d6/a4-a6
		movem.l	d2-d6/a4-a6,(a3)
		lea	$20(a3),a3
		dbf	d0,loc_13C82
		dbf	d1,Sonic_PatternLoad
locret_13C96:
		rts