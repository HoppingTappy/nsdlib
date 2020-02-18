;=======================================================================
;
;	NES Sound Driver & library (NSD.lib)	Library Functions
;
;-----------------------------------------------------------------------
;
;	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
;	For conditions of distribution and use, see copyright notice
;	  in "nsd.h" or "nsd.inc".
;
;=======================================================================

	.setcpu		"6502"

	.export		_nsd_stop_se

	.import		_nsd_stop

	.import		_nsd_snd_init
	.import		_nsd_snd_sweep
	.import		_nsd_snd_volume
	.import		_nsd_snd_keyoff

	.import		nsd_work
	.importzp	nsd_work_zp

	.include	"nes.inc"
	.include	"nsddef.inc"
	.include	"macro.inc"


.segment "PRG_AUDIO_CODE"
;=======================================================================
;	void	__fastcall__	nsd_stop_se(void );
;-----------------------------------------------------------------------
;<<Contents>>
;	Stop the SE
;<<Input>>
;	nothing
;<<Output>>
;	nothing
;=======================================================================
.proc	_nsd_stop_se: near
.ifdef	SE_STOP_NUM
	sty	__se_stop_num

	;-----------------------
	;common
	lda	#nsd_flag::SE
	ora	__flag
	sta	__flag			;SE Disable

	;-----------------------
	;Init the channel structure
	ldx	#nsd::TR_SE
Loop:
	stx	__channel
;	jsr	_nsd_stop

	lda	__se_stop_num
	cmp	#$ff
	beq	@allSeStop

	lda	__Sequence_ptr + 1,x
	ora	__Sequence_ptr,x
	beq	@skip

	lda	#<~nsd_flag::SE
	and	__flag
	sta	__flag			;SE Enable

	txa
	lsr	a
	tay	
	lda	__req_num-nsd::TR_SE/2,y
	cmp	__se_stop_num
	bne	@skip
@allSeStop:
	lda	__Sequence_ptr + 1,x	;[4]
	beq	@L

	jsr	_nsd_snd_keyoff		;[6]
;	jsr	_nsd_snd_volume		;[6]
@L:
	lda	#$00			;[2]
	sta	__Sequence_ptr,x	;[4]
	sta	__Sequence_ptr + 1,x	;[4]

	jsr	_nsd_snd_volume		;[6]

	;to do VRC7
	lda	#$FF			;[2]
	sta	__note,x		;[5]
@skip:
	inx
	inx
	cpx	#nsd::TR_SE + nsd::SE_Track * 2
	bcc	Loop

	rts
.else
	;-----------------------
	;common
	lda	#nsd_flag::SE
	ora	__flag
	sta	__flag			;SE Disable

	;-----------------------
	;Init the channel structure
	ldx	#nsd::TR_SE
Loop:
	stx	__channel
;	jsr	_nsd_stop

	lda	__Sequence_ptr + 1,x	;[4]
	beq	@L

	jsr	_nsd_snd_keyoff		;[6]
;	jsr	_nsd_snd_volume		;[6]
@L:
	lda	#$00			;[2]
	sta	__Sequence_ptr,x	;[4]
	sta	__Sequence_ptr + 1,x	;[4]

	jsr	_nsd_snd_volume		;[6]

	;to do VRC7
	lda	#$FF			;[2]
	sta	__note,x		;[5]

	inx
	inx
	cpx	#nsd::TR_SE + nsd::SE_Track * 2
	bcc	Loop

	rts
.endif

.endproc
