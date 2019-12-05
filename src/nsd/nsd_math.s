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

	.setcpu		"6502"

	.export		_nsd_div192
	.export		_nsd_mul

	.importzp	nsd_work_zp
	.import		nsd_work

	.include	"nes.inc"
	.include	"nsddef.inc"
	.include	"macro.inc"

.segment "PRG_AUDIO_CODE"
;=======================================================================
;	void	__fastcall__	_nsd_div192(unsigned int ax);
;-----------------------------------------------------------------------
;<<Contents>>
;	Divide `ax' by 192 (0xC0) = 16 * 12
;	âÒïúñ@Ç…ÇÊÇÈ192å≈íËèúéZ
;<<Input>>
;	ax	value
;<<Output>>
;	a =	ax mod 192
;	x =	ax  /  192
;=======================================================================
.proc	_nsd_div192

	pha		; save a
	txa
	tay		; y = x
	lda	#0	; a = octave

	;if (ax > 0x0600) then
	cpy	#$06
	bcc	Div_8
	tya
	sbc	#6	;cy = `H'
	tay		; y -= 6
	lda	#8

Div_8:	;if (ax > 0x0300) then
	cpy	#$03
	bcc	Div_4
	adc	#3	; + cy = 4
	dey
	dey
	dey	; y -= 3

Div_4:	
	tax		; x = octave
	pla		; restore a

	;if (ax > 0x0180) then
	cpy	#$01
	bcc	Div_2
	bne	@L2
	cmp	#$80
	bcc	Div_2
@L2:	sub	#$80
	bcs	@L
	dey
@L:	dey
	inx
	inx	; x += 2

Div_2:	;if (ax > 0x00C0) then
	cpy	#$00
	bne	@L2
	cmp	#$C0
	bcc	exit
@L2:	sub	#$C0
	bcs	@L
	dey
@L:	inx

exit:
	rts
.endproc

;=======================================================================
;	void	__fastcall__	_nsd_mul(unsigned char a, unsigned char x);
;-----------------------------------------------------------------------
;<<Contents>>
;	multiplication	8bit = 4bit * 6bit
;<<Input>>
;	a	value 1 (lower 4bit)	volume side	(0 - 15)
;	x	value 2 (lower 6bit)	envelope	(0 - 63)
;<<Output>>
;	a =	a Å~ (x Å{ 1) ÅÄ 16
;=======================================================================
.proc	_nsd_mul
.ifndef	VOLUME_TABLE_MOD
	and	#$0F
	eor	#$FF
	sta	__tmp

	inx
	txa
	sta	__tmp + 1		; = ^ (envelop+1)

	lda	#0
	lsr	__tmp
	bcs	@L1
	adc	__tmp + 1
@L1:
	lsr	a
	lsr	__tmp
	bcs	@L2
	adc	__tmp + 1
@L2:
	lsr	a
	lsr	__tmp
	bcs	@L3
	adc	__tmp + 1
@L3:
	lsr	a
	lsr	__tmp
	bcs	@L4
	adc	__tmp + 1
@L4:
	lsr	a
;	lsr	__tmp
;	bcs	@L5
;	adc	__tmp + 1
;@L5:
exit:
	rts

.else
;	and	#$0F
	stx	__tmp
_tmp_a:
	shl	a, 4
	ora	__tmp
_already_a_or_x:
	tax
	lda	_nsd_volume_table,x
	rts

.segment	"PRG_AUDIO_DATA"
_nsd_volume_table:
; env	      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; volume  0
	.byte 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1	; volume  1
	.byte 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2	; volume  2
	.byte 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3	; volume  3
	.byte 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4	; volume  4
	.byte 0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5	; volume  5
	.byte 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6	; volume  6
	.byte 0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7	; volume  7
	.byte 0, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8	; volume  8
	.byte 0, 1, 1, 1, 2, 3, 3, 4, 4, 5, 6, 6, 7, 7, 8, 9	; volume  9
	.byte 0, 1, 1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 8, 9,10	; volume 10
	.byte 0, 1, 1, 2, 2, 3, 4, 5, 5, 6, 7, 8, 8, 9,10,11	; volume 11
	.byte 0, 1, 1, 2, 3, 4, 4, 5, 6, 7, 8, 8, 9,10,11,12	; volume 12
	.byte 0, 1, 1, 2, 3, 4, 5, 6, 6, 7, 8, 9,10,11,12,13	; volume 13
	.byte 0, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14	; volume 14
	.byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15	; volume 15

_nsd_mul_already_a_or_x = _nsd_mul::_already_a_or_x
.export	_nsd_mul_already_a_or_x
.endif
.endproc
