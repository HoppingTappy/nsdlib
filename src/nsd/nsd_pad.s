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

	.include	"nes.inc"
	.include	"nsddef.inc"
	.include	"macro.inc"


.segment "PRG_AUDIO_CODE"
.proc nsd_pad_routine
	lda	__key1
	sta	__key1_rec
	lda	__key2
	sta	__key2_rec

	jsr	read_pad

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

.proc	nsd_pad_effect
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
