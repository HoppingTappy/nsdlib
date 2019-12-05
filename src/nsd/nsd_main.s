;=======================================================================
;
;	NES Sound Driver & library (NSD.lib)	Main Routine
;
;-----------------------------------------------------------------------
;
;	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
;	For conditions of distribution and use, see copyright notice
;	  in "nsd.h" or "nsd.inc".
;
;=======================================================================

	.setcpu		"6502"

	.export		_nsd_main

	.importzp	nsd_work_zp
	.import		nsd_work

	.import		nsd_sequence
	.import		nsd_envelop

	.include	"nes.inc"
	.include	"nsddef.inc"
	.include	"macro.inc"

.ifdef	MMC3_BANK
	.export		_nsd_bank_switch
.endif


.segment "PRG_AUDIO_CODE"

;=======================================================================
;	void    __fastcall__    nsd_main(void );
;-----------------------------------------------------------------------
;<<Contents>>
;	main process of BGM and SE
;<<Input>>
;	nothing
;<<Output>>
;	nothing
;=======================================================================
.proc	_nsd_main: near

	lda	__flag		;�����̏ꍇ�́A�Ă΂Ȃ��B
	jmi	Exit		;�i�ŏ�� 1bit = `H'�̏ꍇ�A�I���j

.ifdef	DPCMBank
	sei

	;register push
	lda	__tmp
	pha
	lda	__tmp + 1
	pha
	lda	__ptr
	pha
	lda	__ptr + 1
	pha
.endif

	NSD_MAIN_SE
	NSD_MAIN_BGM

.ifdef	DPCMBank
	;register pop back
	pla
	sta	__ptr + 1
	pla
	sta	__ptr
	pla
	sta	__tmp + 1
	pla
	sta	__tmp

	cli
.endif

	;-------------------------------
	;Exit
Exit:	rts
.endproc


.ifdef	MMC3_BANK
; ------------------------------------------------------------------------
; _nsd_bank_switch
; ------------------------------------------------------------------------
.segment "PRG_AUDIO_CODE"
.proc	_nsd_bank_switch
	lda	#( %01000000 | $6)	; $C000~DFFF
	sta	$8000
	stx	$8001
	rts
.endproc
.endif