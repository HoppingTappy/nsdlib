;=======================================================================
;
;	NES Sound Driver & library (NSD.lib)	Math Calculator
;
;-----------------------------------------------------------------------
;
;	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
;	For conditions of distribution and use, see copyright notice
;	  in "nsd.h" or "nsd.inc".
;
;=======================================================================

.ifdef ENABLE_PAD

	.setcpu		"6502"

	.export		nsd_pad_routine
	.export		nsd_pad_effect

	.importzp	nsd_work_zp
	.import		nsd_work
	.import		_nsd_snd_keyoff

	.include	"nes.inc"
	.include	"nsddef.inc"
	.include	"macro.inc"


.segment "PRG_AUDIO_CODE"
.proc nsd_pad_routine
	lda	__key1
	sta	__key1_rec
	lda	__key2
	sta	__key2_rec

@retry:
	jsr	read_pad

	lda	__key1
	sta	__tmp + 0
	lda	__key2
	sta	__tmp + 1

	jsr	read_pad

	lda	__key1
	cmp	__tmp + 0
	bne	@retry

	lda	__key2
	cmp	__tmp + 1
	bne	@retry

	; PAD1 trigger
	lda	__key1
	eor	__key1_rec
	and	__key1
	sta	__key1_trg

	; PAD2 trigger
	lda	__key2
	eor	__key2_rec
	and	__key2
	sta	__key2_trg

	; キーリピート処理
	lda	__key1
	and	#(PAD_1_U | PAD_1_D | PAD_1_L | PAD_1_R)
	beq	@clrRpt

	dec	__key1_rpt_timer
	beq	@setRpt

	lda	__key1_trg
	beq	@clrRptFlag

	lda	#KEY_REPEAT_WAIT_FIRST
	bne	@reloadTimer     ; bra

@setRpt:
	lda	#KEY_REPEAT_WAIT_SECOND

@reloadTimer:
	sta	__key1_rpt_timer
	lda	__key1
	and	#(PAD_1_U | PAD_1_D | PAD_1_L | PAD_1_R)
	sta	__key1_rpt
	rts

@clrRpt:
	lda	#0
	sta	__key1_rpt_timer
@clrRptFlag:
	lda	#0
	sta	__key1_rpt
	rts

read_pad:
	lda	#1
	sta	__key1
	sta	__key2
	sta	APU_PAD1
	lsr	a
	sta	APU_PAD1
@lp:
	lda	APU_PAD1
	and	#3
	cmp	#1
	rol	__key1
	lda	APU_PAD2
	and	#3
	cmp	#1
	rol	__key2
	bcc	@lp

	rts

.endproc

.proc muteClearAll
	ldx	#nsd::BGM_Track * 2
@loop:
	lda	__chflag,x
	and	#<~nsd_chflag::Mask
	sta	__chflag,x
	dex
	dex
	bpl	@loop
	rts
.endproc

.proc solo
	txa
	sta	__tmp
	ldx	#nsd::BGM_Track * 2
@loop:
	lda	__chflag,x
	ora	#nsd_chflag::Mask
	cpx	__tmp
	bne	:+
	and	#<~nsd_chflag::Mask
:
	sta	__chflag,x
	dex
	dex
	bpl	@loop
	rts
.endproc

.proc toggleMask
		lda	__chflag,x
		eor	#nsd_chflag::Mask
		sta	__chflag,x
		bpl	:+
		jsr	_nsd_snd_keyoff
:
		rts
.endproc

.proc	nsd_pad_effect
	lda	__key1
	and	#PAD_1_SELECT
	jeq	@skipHoldSelect
		lda	__key1_trg
		and	#PAD_1_U
		beq	:+
		ldx	#nsd::TR_BGM1
		jmp	solo
	:
		lda	__key1_trg
		and	#PAD_1_R
		beq	:+
		ldx	#nsd::TR_BGM2
		jmp	solo
	:
		lda	__key1_trg
		and	#PAD_1_D
		beq	:+
		ldx	#nsd::TR_BGM3
		jmp	solo
	:
		lda	__key1_trg
		and	#PAD_1_L
		beq	:+
		ldx	#nsd::TR_BGM4
		jmp	solo
	:
		lda	__key1_trg
		and	#PAD_1_A
		beq	:+
		ldx	#nsd::TR_BGM5
		jmp	solo
	:
.if (nsd::BGM_Track > 5)
		lda	__key2_trg
		and	#PAD_1_U
		beq	:+
		ldx	#10
		jmp	solo
	:
		lda	__key2_trg
		and	#PAD_1_R
		beq	:+
		ldx	#12
		jmp	solo
	:
		lda	__key2_trg
		and	#PAD_1_D
		beq	:+
		ldx	#14
		jmp	solo
	:
		lda	__key2_trg
		and	#PAD_1_L
		beq	:+
		ldx	#16
		jmp	solo
	:
		lda	__key2_trg
		and	#PAD_1_A
		beq	:+
		ldx	#18
		jmp	solo
	:
		lda	__key2_trg
		and	#PAD_1_B
		beq	:+
		ldx	#20
		jmp	solo
	:
.endif
		lda	__key1_trg
		and	#PAD_1_START
		beq	:+
		jmp	muteClearAll
	:
@skipHoldSelect:
	lda	__key1
	and	#PAD_1_START
	jeq	@skipHoldStart
		lda	__key1_trg
		and	#PAD_1_U
		beq	:+
		ldx	#nsd::TR_BGM1
		jmp	toggleMask
	:
		lda	__key1_trg
		and	#PAD_1_R
		beq	:+
		ldx	#nsd::TR_BGM2
		jmp	toggleMask
	:
		lda	__key1_trg
		and	#PAD_1_D
		beq	:+
		ldx	#nsd::TR_BGM3
		jmp	toggleMask
	:
		lda	__key1_trg
		and	#PAD_1_L
		beq	:+
		ldx	#nsd::TR_BGM4
		jmp	toggleMask
	:
		lda	__key1_trg
		and	#PAD_1_A
		beq	:+
		ldx	#nsd::TR_BGM5
		jmp	toggleMask
	:
.if (nsd::BGM_Track > 5)
		lda	__key2_trg
		and	#PAD_1_U
		beq	:+
		ldx	#10
		jmp	toggleMask
	:
		lda	__key2_trg
		and	#PAD_1_R
		beq	:+
		ldx	#12
		jmp	toggleMask
	:
		lda	__key2_trg
		and	#PAD_1_D
		beq	:+
		ldx	#14
		jmp	toggleMask
	:
		lda	__key2_trg
		and	#PAD_1_L
		beq	:+
		ldx	#16
		jmp	toggleMask
	:
		lda	__key2_trg
		and	#PAD_1_A
		beq	:+
		ldx	#18
		jmp	toggleMask
	:
		lda	__key2_trg
		and	#PAD_1_B
		beq	:+
		ldx	#20
		jmp	toggleMask
	:
.endif
		lda	__key1_trg
		and	#PAD_1_SELECT
		beq	:+
		jmp	muteClearAll
	:

@skipHoldStart:
	lda	__key1
	and	#PAD_1_A
	beq	@skipHoldA
		lda	__key1_rpt
		and	#PAD_1_R
		beq	:+
		lda	__Tempo
		clc
		adc	__Tempo_add
		cmp	#$FF
		bcs	:+
		inc	__Tempo_add
	:
		lda	__key1_rpt
		and	#PAD_1_L
		beq	:+
		lda	__Tempo
		clc
		adc	__Tempo_add
		beq	:+
		dec	__Tempo_add
	:
		lda	__key1
		and	#PAD_1_START
		beq	:+
		lda	#0
		sta	__Tempo_add
	:

@skipHoldA:
	lda	__key1
	and	#PAD_1_B
	beq	@skipHoldB
		lda	__key1_rpt
		and	#PAD_1_U
		beq	:+
		inc	__note_add
	:
		lda	__key1_rpt
		and	#PAD_1_D
		beq	:+
		dec	__note_add
	:
		lda	__key1_rpt
		and	#PAD_1_R
		beq	:+
		lda	__note_add
		clc
		adc	#12
		sta	__note_add
	:
		lda	__key1_rpt
		and	#PAD_1_L
		beq	:+
		lda	__note_add
		sec
		sbc	#12
		sta	__note_add
	:
		lda	__key1
		and	#PAD_1_START
		beq	:+
		lda	#0
		sta	__note_add
	:
@skipHoldB:
	rts
.endproc

.endif
