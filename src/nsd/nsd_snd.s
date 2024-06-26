;=======================================================================
;
;	NES Sound Driver & library (NSD.lib)	Sound Device Driver
;
;-----------------------------------------------------------------------
;
;	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
;	For conditions of distribution and use, see copyright notice
;	  in "nsd.h" or "nsd.inc".
;
;=======================================================================

	.setcpu		"6502"

	.export		_nsd_snd_init
	.export		_nsd_snd_voice
	.export		_nsd_snd_volume
	.export		_nsd_snd_sweep
	.export		_nsd_snd_frequency
	.export		_nsd_snd_keyon
	.export		_nsd_snd_keyoff

	.export		_nsd_dpcm_calc

	.import		_nsd_div192

	.import		nsd_work
	.importzp	nsd_work_zp

.ifdef	DPCMBank
	.import		_nsd_ptr_bank
.endif

.if	.defined(VRC7) || .defined(OPLL)
	.export		_Wait42
.endif

	.include	"nes.inc"
	.include	"nsddef.inc"
	.include	"macro.inc"


.ifdef	FO_MOD
	.import		_nsd_mul
	
.ifdef	VOLUME_TABLE_MOD
	.import		_nsd_mul_already_a_or_x
.endif

.endif

.ifdef	DPCMBank
	.import		_nsd_bank_change
.endif

;=======================================================================
;	void	__fastcall__	nsd_snd_init(void);
;-----------------------------------------------------------------------
;<<Contents>>
;	Initaraize of the sound device
;<<Input>>
;	nothing
;<<Output>>
;	nothing
;=======================================================================
.segment "PRG_AUDIO_CODE"
.proc	_nsd_snd_init

	lda	#(nsd_flag::BGM+nsd_flag::SE)
	sta	__flag

	lda	#$00

	sta	APU_PULSE1CTRL		; Pulse #1 Control Register (W)
;	sta	APU_PULSE1FTUNE		; Pulse #1 Fine Tune (FT) Register (W)
;	sta	APU_PULSE1CTUNE		; Pulse #1 Coarse Tune (CT) Register (W)

	sta	APU_PULSE2CTRL		; Pulse #2 Control Register (W)
;	sta	APU_PULSE2FTUNE		; Pulse #2 Fine Tune Register (W)
;	sta	APU_PULSE2STUNE		; Pulse #2 Coarse Tune Register (W)

	sta	APU_TRICTRL1		; Triangle Control Register (W)
;	sta	APU_TRIFREQ1		; Triangle Frequency Register #1 (W)
;	sta	APU_TRIFREQ2		; Triangle Frequency Register #2 (W)

	sta	APU_NOISECTRL		; Noise Control Register #1 (W)
;	sta	APU_NOISEFREQ1		; Noise Frequency Register #1 (W)
;	sta	APU_NOISEFREQ2		; Noise Frequency Register #2 (W)

;	sta	APU_MODDA		; Delta Modulation D/A Register (W)
;	sta	APU_MODADDR		; Delta Modulation Address Register (W)
;	sta	APU_MODLEN		; Delta Modulation Data Length Register (W)

.ifdef	MASK
	ldx	#nsd::TR_BGM1
@loop:
	sta	__chflag,x
	inx
	inx
	cpx	#nsd::TR_BGM1 + nsd::Track * 2
	bcc	@loop
.endif

.ifdef	FDS
	sta	FDS_Sweep_Bias
.endif

.ifdef	MMC5
	sta	MMC5_Pulse1_CTRL
	sta	MMC5_Pulse2_CTRL
.endif

.ifdef	VRC6
	sta	VRC6_Frequency
	sta	VRC6_Pulse1_CTRL
	sta	VRC6_Pulse2_CTRL
	sta	VRC6_SAW_CTRL
	sta	VRC6_Pulse1_CTUNE
	sta	VRC6_Pulse2_CTUNE
	sta	VRC6_SAW_CTUNE
.endif

.ifdef	FDS
	lda	#$02
	sta	FDS_Control
.endif

.ifdef	MMC5
	lda	#$03
	sta	MMC5_CHANCTRL
.endif

	lda	#$08
	sta	APU_PULSE1RAMP		; Pulse #1 Ramp Control Register (W)
	sta	APU_PULSE2RAMP		; Pulse #2 Ramp Control Register (W)

	lda	#$0F			; 
	sta	APU_CHANCTRL		; Sound/Vertical Clock Signal Register (R)

	lda	#$10
	sta	APU_MODCTRL		; Delta Modulation Control Register (W)

	lda	#$40
	sta	APU_PAD2		; SOFTCLK (RW)

.ifdef	N163
;	lda	#$20
;	sta				; namco t163 sound enable
;	lda	#$70
;	sta	__n163_num
	lda	#$00
	ldy	#$80
	sty	N163_Resister
@initN163:
	sta	N163_Data
	dey
	bne	@initN163

.endif

.ifdef	FDS
	lda	#$80
	sta	FDS_Volume
	sta	FDS_Sweep_Envelope
.endif

	rts
.endproc

;=======================================================================
;	void	__fastcall__	_nsd_dpcm_calc(void);
;-----------------------------------------------------------------------
;<<Contents>>
;	dpcm info
;<<Input>>
;	nothing
;<<Output>>
;	__ptr	dpcm info address
;	y
;=======================================================================
.proc	_nsd_dpcm_calc
.ifdef DPCM_PITCH
	pha
.endif
	lda	#0
	sta	__tmp + 1
.ifdef DPCM_PITCH
	pla
.else
	lda	__note,x
.endif
	asl	a
	rol	__tmp + 1

.ifdef	DPCMBank
	;__ptr = a * 2
	sta	__ptr
	lda	__tmp + 1
	sta	__ptr + 1
	lda	__ptr
.endif

	asl	a
	rol	__tmp + 1	; __tmp + 1  <=  a の 上位2bit

.ifdef	DPCMBank
	add	__ptr
	tay			;y <- address
	lda	__tmp + 1
	adc	__ptr + 1
	sta	__tmp + 1
	tya
.endif

	add	__dpcm_info + 0
	sta	__ptr + 0
	lda	__dpcm_info + 1
	adc	__tmp + 1
	sta	__ptr + 1

	rts
.endproc

;=======================================================================
;	void	__fastcall__	_nsd_snd_keyon(void);
;-----------------------------------------------------------------------
;<<Contents>>
;	Key on the device
;<<Input>>
;	nothing
;<<Output>>
;	nothing
;=======================================================================
.proc	_nsd_snd_keyon
.segment "PRG_AUDIO_DATA"
JMPTBL:	.addr	_nsd_apu_ch1_keyon		;BGM ch1 Pulse
	.addr	_nsd_apu_ch2_keyon		;BGM ch2 Pulse
	.addr	_nsd_apu_ch3_keyon		;BGM ch3 Triangle
	.addr	_nsd_keyon_exit			;BGM ch4 Noize
	.addr	_nsd_apu_dpcm_keyon		;BGM ch5 DPCM
.ifdef	FDS
	.addr	_nsd_fds_keyon
.endif
.ifdef	VRC6
	.addr	_nsd_keyon_exit
	.addr	_nsd_keyon_exit
	.addr	_nsd_keyon_exit
.endif
.ifdef	VRC7
	.addr	_nsd_vrc7_keyon		;取りあえず、処理しない。
	.addr	_nsd_vrc7_keyon
	.addr	_nsd_vrc7_keyon
	.addr	_nsd_vrc7_keyon
	.addr	_nsd_vrc7_keyon
	.addr	_nsd_vrc7_keyon
.endif
.ifdef	OPLL
	.addr	_nsd_opll_keyon
	.addr	_nsd_opll_keyon
	.addr	_nsd_opll_keyon
	.addr	_nsd_opll_keyon
	.addr	_nsd_opll_keyon
	.addr	_nsd_opll_keyon
	.addr	_nsd_opll_keyon_R
	.addr	_nsd_opll_keyon_R
	.addr	_nsd_opll_keyon_R
	.addr	_nsd_opll_BD_keyon
	.addr	_nsd_opll_SD_keyon
	.addr	_nsd_opll_HH_keyon
	.addr	_nsd_opll_Cym_keyon
	.addr	_nsd_opll_Tom_keyon
.endif
.ifdef	MMC5
	.addr	_nsd_mmc5_ch1_keyon		;仕組みは同じ。
	.addr	_nsd_mmc5_ch2_keyon		;
.endif
.ifdef	N163
	.repeat ::nsd::N163_Track
		.addr	_nsd_keyon_exit
	.endrepeat
.endif
.ifdef	PSG
	.addr	_nsd_keyon_exit
	.addr	_nsd_keyon_exit
	.addr	_nsd_keyon_exit
.endif
.ifdef	NULL
	.addr	_nsd_keyon_exit
.endif
	;-------------------------------
	;SE
.ifdef	SE
	.addr	_nsd_apu_ch1_keyon_se		;SE  ch1 Pulse
.endif
	.addr	_nsd_apu_ch2_keyon_se		;SE  ch2 Pulse
.ifdef	SE
	.addr	_nsd_apu_ch3_keyon_se		;SE  ch3 Pulse
.endif
	.addr	_nsd_keyon_exit			;SE  ch4 Noize
.ifdef	SE
	.addr	_nsd_apu_dpcm_keyon_se		;BGM ch5 DPCM
.endif
.ifdef	SE_N163
	.repeat nsd::SE_N163_Track
		.addr	_nsd_keyon_exit
	.endrepeat
.endif
;---------------------------------------
.segment "PRG_AUDIO_CODE"
.ifdef	MASK
	lda	__chflag,x
	bmi	Exit
.endif
	ldy	JMPTBL,x		;
	sty	__ptr			;
	ldy	JMPTBL + 1,x		;
	sty	__ptr + 1		;
	jmp	(__ptr)			;[5]
.endproc
;---------------------------------------
.proc	_nsd_apu_ch1_keyon
	;For hardware Key on
	lda	#$00
	sta	__apu_frequency1
.endproc

.proc	_nsd_keyon_exit
Exit:
	rts
.endproc
;---------------------------------------
.ifdef	SE
.proc	_nsd_apu_ch1_keyon_se
	lda	#$00
	sta	__se_frequency1
	rts
.endproc
.endif

;---------------------------------------
.proc	_nsd_apu_ch2_keyon
	lda	#$00
	sta	__apu_frequency2
	rts
.endproc

;---------------------------------------
.proc	_nsd_apu_ch2_keyon_se
	;For hardware Key on
	lda	#$00
	sta	__se_frequency2
	rts
.endproc

;---------------------------------------
.proc	_nsd_apu_ch3_keyon

	lda	#$00
	sta	__apu_frequency3

	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Tri + 1
	bne	@L
.endif

.ifdef	FO_MOD
	ldy	__fo_value
	beq	@L
.endif

	;Hardware key on for ch3
	lda	__env_volume + 1,x
.ifdef	DPCMBank
	ora	__env_volume,x
.endif
	;音量エンベロープが有効な場合、エンベロープ処理に任す
	bne	@L
	lda	__apu_tri_time
	sta	APU_TRICTRL1
@L:
	rts
.endproc

;---------------------------------------
.ifdef	SE
.proc	_nsd_apu_ch3_keyon_se

	lda	#$00
	sta	__se_frequency3

	;Hardware key on for ch3
	lda	__env_volume + 1,x
.ifdef	DPCMBank
	ora	__env_volume,x
.endif
	;音量エンベロープが有効な場合、エンベロープ処理に任す
	bne	@L
	lda	__se_tri_time
	sta	APU_TRICTRL1
@L:
	rts
.endproc
.endif
;---------------------------------------
.proc	_nsd_apu_dpcm_keyon

.ifdef	FO_MOD
	ldy	__fo_value
	beq	_nsd_keyon_exit
.endif

	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Dpcm + 1
	bne	_nsd_keyon_exit
.endif
.endproc
.proc	_nsd_apu_dpcm_keyon_se

	lda	#nsd_flag::Jump
	bit	__flag
	bne	@E



	lda	#$0F
	sta	APU_CHANCTRL
.ifdef DPCM_PITCH
	lda	__note,x
	add	__trans,x
.endif
	jsr	_nsd_dpcm_calc

.ifdef	DPCMBank
	jsr	_nsd_ptr_bank
	;bank number
	ldy	#4
	lda	(__ptr),y
	jsr	_nsd_bank_change
.endif

	;Set the DPCM resister
	;CTRL (note etc..)
	ldy	#0
.ifndef DPCM_PITCH
	lda	(__ptr),y
	sta	APU_MODCTRL
.endif

	;volume
	iny
	lda	(__ptr),y
	bmi	@L			;if 0x80 >= a then skip
	sta	APU_MODDA
@L:
;.ifndef DPCM_PITCH
	;address
	iny
	lda	(__ptr),y
	sta	APU_MODADDR

	;length
	iny
	lda	(__ptr),y
	sta	APU_MODLEN
;.endif
	lda	#$1F
	sta	APU_CHANCTRL
@E:
	rts

.endproc
;---------------------------------------
.ifdef	FDS
.proc	_nsd_fds_keyon
.ifdef FDS_SYNC
	lda	__chflag,x
	and	#nsd_chflag::FdsSync
	beq	@noFdsSync

	lda	__fds_frequency
	ora	#$80
	sta	FDS_Mod_CTUNE
	lda	__fds_frequency
	sta	FDS_Mod_CTUNE
@noFdsSync:
.endif
	lda	__fds_sweepbias
	sta	FDS_Sweep_Bias

;.ifdef FDS_SYNC
;
;	lda	__chflag,x
;	and	#nsd_chflag::FdsSync
;	beq	@noFdsSync
;
;	lda	__mod_wav_ptr
;	sta	__ptr
;	lda	__mod_wav_ptr+1
;	sta	__ptr+1
;
;.ifdef	DPCMBank
;	jsr	_nsd_ptr_bank
;.endif
;	ldy	#0
;@L:
;	lda	(__ptr),y
;	sta	FDS_Mod_Append
;	iny
;	cpy	#32
;	bne	@L
;
;	lda	__fds_frequency
;	sta	FDS_Mod_CTUNE
;@noFdsSync:
;.endif
	rts
.endproc
.endif
;---------------------------------------
.ifdef	MMC5

.proc	_nsd_mmc5_ch1_keyon
	lda	#$00
	sta	__mmc5_frequency1
	rts
.endproc

.proc	_nsd_mmc5_ch2_keyon
	lda	#$00
	sta	__mmc5_frequency2
	rts

.endproc
.endif
;---------------------------------------
.ifdef	VRC7
.proc	_nsd_vrc7_keyon

	lda	__chflag,x		;[4]4
	and	#nsd_chflag::NoKeyOff
	beq	@exit

	;KeyOffしていないので、onする前に、offする。
	txa				;[2]12
	sub	#nsd::TR_VRC7		;[]
	shr	a, 1			;[2]
	tay				;[2]
	add	#VRC7_Octave		;[2]
	sta	VRC7_Resister		;レジスターをセット

	lda	__vrc7_freq_old,y	;[5]
	and	#$EF			;[2]
	sta	__vrc7_freq_old,y	;[5]
	sta	VRC7_Data		;


@exit:
	lda	__chflag,x
	ora	#nsd_chflag::KeyOn
	sta	__chflag,x

_nsd_vrc7_keyon_exit:
	rts
.endproc
.endif
;---------------------------------------
.ifdef	OPLL
.proc	_nsd_opll_keyon_R

	;OPLL_Rhythm check
	lda	__opll_ryhthm
	cmp	#$20
	bcs	_nsd_opll_keyon_exit
.endproc

.proc	_nsd_opll_keyon

	lda	__chflag,x		;[4]4
	and	#nsd_chflag::NoKeyOff
	beq	@exit

	;KeyOffしていないので、onする前に、offする。
	txa				;[2]12
	sub	#nsd::TR_OPLL		;[]
	shr	a, 1			;[2]
	tay				;[2]
	add	#OPLL_Octave		;[2]
	sta	OPLL_Resister		;レジスターをセット

	lda	__opll_freq_old,y	;[5]
	and	#$EF			;[2]
	sta	__opll_freq_old,y	;[5]
	sta	OPLL_Data		;

@exit:
	lda	__chflag,x
	ora	#nsd_chflag::KeyOn
	sta	__chflag,x
.endproc

.proc	_nsd_opll_keyon_exit
	rts
.endproc
.endif


;---------------------------------------
.ifdef	OPLL

.proc	_nsd_opll_BD_keyon
	lda	#$10
	bne	_nsd_opll_rhythm_set_or
.endproc

.proc	_nsd_opll_SD_keyon
	lda	#$08
	bne	_nsd_opll_rhythm_set_or
.endproc

.proc	_nsd_opll_HH_keyon
	lda	#$01
	bne	_nsd_opll_rhythm_set_or
.endproc

.proc	_nsd_opll_Cym_keyon
	lda	#$02
	bne	_nsd_opll_rhythm_set_or
.endproc

.proc	_nsd_opll_Tom_keyon
	lda	#$04
;	bne	_nsd_opll_rhythm_set_or
.endproc

.proc	_nsd_opll_rhythm_set_or
	ora	__opll_ryhthm
	bne	_nsd_opll_rhythm_set		;※必ず1以上
.endproc

.proc	_nsd_opll_BD_keyoff
	lda	#<~$10
	bne	_nsd_opll_rhythm_set_and
.endproc

.proc	_nsd_opll_SD_keyoff
	lda	#<~$08
	bne	_nsd_opll_rhythm_set_and
.endproc

.proc	_nsd_opll_HH_keyoff
	lda	#<~$01
	bne	_nsd_opll_rhythm_set_and
.endproc

.proc	_nsd_opll_Cym_keyoff
	lda	#<~$02
	bne	_nsd_opll_rhythm_set_and
.endproc

.proc	_nsd_opll_Tom_keyoff
	lda	#<~$04
;	bne	_nsd_opll_rhythm_set_and
.endproc

.proc	_nsd_opll_rhythm_set_and
	and	__opll_ryhthm
;	jmp	_nsd_opll_rhythm_set
.endproc

.proc	_nsd_opll_rhythm_set
	sta	__opll_ryhthm

	;OPLL_Rhythm check
	ldy	__opll_ryhthm
	cpy	#$20
	bcc	Exit

	ldy	#OPLL_RHYTHM
	sty	OPLL_Resister
	lda	__opll_ryhthm
	tay
	tay
	sta	OPLL_Data
Exit:
	rts
.endproc
.endif

;=======================================================================
;	void	__fastcall__	_nsd_snd_keyoff(void);
;-----------------------------------------------------------------------
;<<Contents>>
;	Key on the device
;<<Input>>
;	nothing
;<<Output>>
;	nothing
;=======================================================================
.proc	_nsd_snd_keyoff
.segment "PRG_AUDIO_DATA"
JMPTBL:	.addr	Exit			;BGM ch1 Pulse		-- no process --
	.addr	Exit			;BGM ch2 Pulse		-- no process --
	.addr	_nsd_apu_ch3_keyoff	;BGM ch3 Triangle
	.addr	Exit			;BGM ch4 Noize		-- no process --
	.addr	_nsd_apu_dpcm_keyoff	;BGM ch5 DPCM
.ifdef	FDS
	.addr	Exit
.endif
.ifdef	VRC6
	.addr	Exit
	.addr	Exit
	.addr	Exit
.endif
.ifdef	VRC7
	.addr	_nsd_vrc7_keyoff	;KeyOffを書き込んでおく。
	.addr	_nsd_vrc7_keyoff
	.addr	_nsd_vrc7_keyoff
	.addr	_nsd_vrc7_keyoff
	.addr	_nsd_vrc7_keyoff
	.addr	_nsd_vrc7_keyoff
.endif
.ifdef	OPLL
	.addr	_nsd_OPLL_keyoff
	.addr	_nsd_OPLL_keyoff
	.addr	_nsd_OPLL_keyoff
	.addr	_nsd_OPLL_keyoff
	.addr	_nsd_OPLL_keyoff
	.addr	_nsd_OPLL_keyoff
	.addr	_nsd_OPLL_keyoff_R
	.addr	_nsd_OPLL_keyoff_R
	.addr	_nsd_OPLL_keyoff_R
	.addr	_nsd_opll_BD_keyoff
	.addr	_nsd_opll_SD_keyoff
	.addr	_nsd_opll_HH_keyoff
	.addr	_nsd_opll_Cym_keyoff
	.addr	_nsd_opll_Tom_keyoff
.endif
.ifdef	MMC5
	.addr	Exit
	.addr	Exit
.endif
.ifdef	N163
	.repeat ::nsd::N163_Track
		.addr	Exit
	.endrepeat
.endif
.ifdef	PSG
	.addr	Exit
	.addr	Exit
	.addr	Exit
.endif
.ifdef	NULL
	.addr	Exit
.endif

.ifdef	SE
	.addr	Exit			;SE  ch1 Pulse		-- no process --
.endif
	.addr	Exit			;SE  ch2 Pulse		-- no process --
.ifdef	SE
	.addr	_nsd_apu_ch3_keyoff_se
.endif
	.addr	Exit
.ifdef	SE
	.addr	_nsd_apu_dpcm_keyoff_se
.endif
.ifdef	SE_N163
	.repeat nsd::SE_N163_Track
		.addr	Exit
	.endrepeat
.endif
;---------------------------------------
.segment "PRG_AUDIO_CODE"
	ldy	JMPTBL,x		;[]
	sty	__ptr			;[]
	ldy	JMPTBL + 1,x		;[]
	sty	__ptr + 1		;[]
	jmp	(__ptr)			;[5]

;---------------------------------------
_nsd_apu_ch3_keyoff:

	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Tri + 1
	bne	Exit
.endif

_nsd_apu_ch3_keyoff_se:

	;Hardware key off for ch3

	;音量エンベロープが無効？
	lda	__env_volume + 1,x
.ifdef	DPCMBank
	ora	__env_volume,x
.endif
	beq	@S

	;エンベロープが有効時
	;発音mode == 2 or 3 では無い？
	lda	__chflag,x
	and	#$02
	bne	Exit

@S:	;の条件を満たしていたら、設定。
	lda	#$80
	sta	APU_TRICTRL1
Exit:
	rts

;---------------------------------------
_nsd_apu_dpcm_keyoff:

	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Dpcm + 1
	bne	Exit
.endif

_nsd_apu_dpcm_keyoff_se:

	;r- ?
	lda	__chflag,x
	and	#nsd_chflag::KeyOff
	bne	Exit

	lda	#$0F
	sta	APU_CHANCTRL

	rts

;---------------------------------------
.ifdef	VRC7
_nsd_vrc7_keyoff:

	lda	__chflag,x		;[4]4
	and	#nsd_chflag::NoKeyOff
	bne	@exit

	;取りあえず、必ずKeyOffする。
	lda	__chflag,x		;[4]4
	and	#<~nsd_chflag::KeyOn	;[2]6
	sta	__chflag,x		;[4]10

	;書かれない可能性があるので、ここでレジスタに書く。
	txa				;[2]12
	sub	#nsd::TR_VRC7		;[]
	shr	a, 1			;[2]
	tay				;[2]
	add	#VRC7_Octave		;[2]
	sta	VRC7_Resister		;レジスターをセット

	lda	__vrc7_freq_old,y	;[5]
	and	#$EF			;[2]
	sta	__vrc7_freq_old,y	;[5]
	sta	VRC7_Data		;

@exit:
	rts				;[6]
.endif

;---------------------------------------
.ifdef	OPLL
_nsd_OPLL_keyoff_R:

	;OPLL_Rhythm check
	lda	__opll_ryhthm
	cmp	#$20
	bcs	_nsd_OPLL_keyoff_exit

_nsd_OPLL_keyoff:

	lda	__chflag,x		;[4]4
	and	#nsd_chflag::NoKeyOff
	bne	_nsd_OPLL_keyoff_exit

	;取りあえず、必ずKeyOffする。
	lda	__chflag,x		;[4]4
	and	#<~nsd_chflag::KeyOn	;[2]6
	sta	__chflag,x		;[4]10

	;書かれない可能性があるので、ここでレジスタに書く。
	txa				;[2]12
	sub	#nsd::TR_OPLL		;[]
	shr	a, 1			;[2]
	tay				;[2]
	add	#OPLL_Octave		;[2]
	sta	OPLL_Resister		;レジスターをセット

	lda	__opll_freq_old,y	;[5]
	and	#$EF			;[2]
	sta	__opll_freq_old,y	;[5]
	sta	OPLL_Data		;

_nsd_OPLL_keyoff_exit:
	rts
.endif
.endproc

;=======================================================================
;	void	__fastcall__	nsd_snd_voice(char voi);
;-----------------------------------------------------------------------
;<<Contents>>
;	Ser the voice (instruction)
;<<Input>>
;	a	voice number
;<<Output>>
;	nothing
;=======================================================================
.proc	_nsd_snd_voice
.segment "PRG_AUDIO_DATA"
JMPTBL:	.addr	_nsd_apu_ch1_voice	;BGM ch1 Pulse
	.addr	_nsd_apu_ch2_voice	;BGM ch2 Pulse
	.addr	Exit			;BGM ch3 Triangle	-- no process --
	.addr	_nsd_apu_noise_voice	;BGM ch4 Noize
	.addr	Exit			;BGM ch5 DPCM		-- no process --
.ifdef	FDS
	.addr	_nsd_fds_GainMod
.endif
.ifdef	VRC6
	.addr	_nsd_vrc6_ch1_voice
	.addr	_nsd_vrc6_ch2_voice
	.addr	Exit			;Saw
.endif
.ifdef	VRC7
	.addr	_nsd_vrc7_voice
	.addr	_nsd_vrc7_voice
	.addr	_nsd_vrc7_voice
	.addr	_nsd_vrc7_voice
	.addr	_nsd_vrc7_voice
	.addr	_nsd_vrc7_voice
.endif
.ifdef	OPLL
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	_nsd_opll_voice
	.addr	Exit
	.addr	Exit
	.addr	Exit
	.addr	Exit
	.addr	Exit
.endif
.ifdef	MMC5
	.addr	_nsd_mmc5_ch1_voice		;仕組みは同じ
	.addr	_nsd_mmc5_ch2_voice		;
.endif
.ifdef	N163
	.repeat ::nsd::N163_Track,cnt
		.addr	.ident(.concat("_nsd_n163_ch",.string(cnt+1),"_voice"))
	.endrepeat
.endif
.ifdef	PSG
	.addr	_nsd_psg_ch1_voice
	.addr	_nsd_psg_ch2_voice
	.addr	_nsd_psg_ch3_voice
.endif
.ifdef	NULL
	.addr	Exit
.endif

.ifdef	SE
	.addr	_nsd_apu_ch1_voice_se		;SE  ch1 Pulse
.endif
	.addr	_nsd_apu_ch2_voice_se		;SE  ch1 Pulse
.ifdef	SE
	.addr	Exit				;SE  ch3 Tri
.endif
	.addr	_nsd_apu_noise_voice_se		;SE  ch4 Noize
.ifdef	SE
	.addr	Exit				;SE  ch5 DPCM
.endif
.ifdef	SE_N163
	.repeat ::nsd::SE_N163_Track,cnt
		.addr	.ident(.concat("_nsd_n163_ch",.string(cnt+1),"_voice_se"))
	.endrepeat
.endif
;---------------------------------------
.segment "PRG_AUDIO_CODE"
	ldy	JMPTBL,x
	sty	__ptr
	ldy	JMPTBL + 1,x
	sty	__ptr + 1
	jmp	(__ptr)

;---------------------------------------
_nsd_apu_ch1_voice:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 6	;a <<= 6
	ror	a
	ror	a
	ror	a
	and	#$C0	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__apu_voice_set1

	;-------------------------------
	; *** Exit
Exit:
	rts

;---------------------------------------
.ifdef	SE
_nsd_apu_ch1_voice_se:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 6	;a <<= 6
	ror	a
	ror	a
	ror	a
	and	#$C0	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__se_voice_set1

	rts
.endif

;---------------------------------------
_nsd_apu_ch2_voice:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 6	;a <<= 6
	ror	a
	ror	a
	ror	a
	and	#$C0	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__apu_voice_set2

	rts

;---------------------------------------
_nsd_apu_ch2_voice_se:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 6	;a <<= 6
	ror	a
	ror	a
	ror	a
	and	#$C0	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__se_voice_set2

	rts

;---------------------------------------
_nsd_apu_noise_voice:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 7	;a <<= 7
	ror	a
	ror	a
	and	#$80	;a &= 0x80	;for OR to frequency(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__apu_voice_set4

	;-------------------------------
	; *** Exit

	lda	__frequency,x		;下位8bitだけあればいい。
	jmp	_nsd_apu_ch4_frequency

;	rts

;---------------------------------------
_nsd_apu_noise_voice_se:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 7	;a <<= 7
	ror	a
	ror	a
	and	#$80	;a &= 0x80	;for OR to frequency(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__se_voice_set4

	;-------------------------------
	; *** Exit

	lda	__frequency,x		;下位8bitだけあればいい。
	jmp	_nsd_apu_ch4_frequency_se

;	rts


;---------------------------------------
.ifdef	MMC5
_nsd_mmc5_ch1_voice:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 6	;a <<= 6
	ror	a
	ror	a
	ror	a
	and	#$C0	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__mmc5_voice_set1

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_mmc5_ch2_voice:

	;-------------------------------
	; *** Calculate the voice
;	shl	a, 6	;a <<= 6
	ror	a
	ror	a
	ror	a
	and	#$C0	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__mmc5_voice_set2

	;-------------------------------
	; *** Exit
	rts
.endif

;---------------------------------------
.ifdef	FDS
_nsd_fds_GainMod:
	;-------------------------------
	; *** Calculate the voice
	and	#$3F
	ora	#$80

	;-------------------------------
	; *** Set the voice to work
	sta	FDS_Sweep_Envelope

	;-------------------------------
	; *** Exit
	rts
.endif

;---------------------------------------
.ifdef	VRC6
_nsd_vrc6_ch1_voice:
	;-------------------------------
	; *** Calculate the voice
	shl	a, 4	;a <<= 6
	and	#$70	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__vrc6_voice_set1

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_vrc6_ch2_voice:
	;-------------------------------
	; *** Calculate the voice
	shl	a, 4	;a <<= 6
	and	#$70	;a &= 0xF0	;for OR to volume(lower 4bit)

	;-------------------------------
	; *** Set the voice to work
	sta	__vrc6_voice_set2

	;-------------------------------
	; *** Exit
	rts

.endif

;---------------------------------------
.ifdef	VRC7
_nsd_vrc7_voice:

;	 CSV
;	000x xxxx	val
;	0010 xxxx	ML(M)
;	0011 xxxx	ML(C)
;	01xx xxxx	TL

	ldy	__vrc7_reg
	sty	__ptr
	ldy	__vrc7_reg + 1
	sty	__ptr + 1

.ifdef	DPCMBank
	jsr	_nsd_ptr_bank
.endif

	sta	__tmp + 1
	asl	a
	asl	a
	bcs	@TL
	pha
	and	#%11110111	;Reset D
	ora	#%00000100	;Set   I
	pha
	plp
	pla
	bpl	@Voice
	bvs	@MLC

@MLM:
	ldy	#0
	sty	VRC7_Resister
	lda	(__ptr),y
	and	#$F0
	sta	__tmp
	lda	__tmp + 1
	and	#$0F
	ora	__tmp
	sta	VRC7_Data
	jmp	@Exit

@MLC:
	ldy	#1
	sty	VRC7_Resister
	lda	(__ptr),y
	and	#$F0
	sta	__tmp
	lda	__tmp + 1
	and	#$0F
	ora	__tmp
	sta	VRC7_Data
	jmp	@Exit

@TL:
	ldy	#2
	sty	VRC7_Resister
	lda	(__ptr),y
	and	#$C0
	sta	__tmp
	lda	__tmp + 1
	and	#$3F
	ora	__tmp
	sta	VRC7_Data
	jmp	@Exit

@Voice:	
	;-------------------------------
	; *** Set the voice to work
	;チャンネルの計算
	sta	__tmp
	txa				;[2]9
	sub	#nsd::TR_VRC7		;[3]12
	shr	a, 1			;[2]14
	tay				;[2]16

	;-------------------------------
	; *** Calculate the voice
	lda	__tmp
	shl	a, 2	;a <<= 4
	and	#$F0	;a &= 0xF0	;for OR to volume(lower 4bit)

	sta	__vrc7_voice_set,y

	;-------------------------------
	; *** Exit
@Exit:	rts
.endif

;---------------------------------------
.ifdef	OPLL
_nsd_opll_voice:

;	 CSV
;	000x xxxx	val
;	0010 xxxx	ML(M)
;	0011 xxxx	ML(C)
;	01xx xxxx	TL

	ldy	__opll_reg
	sty	__ptr
	ldy	__opll_reg + 1
	sty	__ptr + 1

.ifdef	DPCMBank
	jsr	_nsd_ptr_bank
.endif

	sta	__tmp + 1
	asl	a
	asl	a
	bcs	@TL
	pha
	and	#%11110111	;Reset D
	ora	#%00000100	;Set   I
	pha
	plp
	pla
	bpl	@Voice
	bvs	@MLC

@MLM:
	ldy	#0
	sty	OPLL_Resister
	lda	(__ptr),y
	and	#$F0
	sta	__tmp
	lda	__tmp + 1
	and	#$0F
	ora	__tmp
	sta	OPLL_Data
	jmp	@Exit

@MLC:
	ldy	#1
	sty	OPLL_Resister
	lda	(__ptr),y
	and	#$F0
	sta	__tmp
	lda	__tmp + 1
	and	#$0F
	ora	__tmp
	sta	OPLL_Data
	jmp	@Exit

@TL:
	ldy	#2
	sty	OPLL_Resister
	lda	(__ptr),y
	and	#$C0
	sta	__tmp
	lda	__tmp + 1
	and	#$3F
	ora	__tmp
	sta	OPLL_Data
	jmp	@Exit

@Voice:	
	;-------------------------------
	; *** Set the voice to work
	;チャンネルの計算
	sta	__tmp
	txa				;[2]9
	sub	#nsd::TR_OPLL		;[3]12
	shr	a, 1			;[2]14
	tay				;[2]16

	;-------------------------------
	; *** Calculate the voice
	lda	__tmp
	shl	a, 2	;a <<= 4
	and	#$F0	;a &= 0xF0	;for OR to volume(lower 4bit)

	sta	__opll_voice_set,y

	;-------------------------------
	; *** Exit
@Exit:	rts
.endif

;---------------------------------------
.ifdef	N163
_nsd_n163_ch1_voice:
	.if (nsd::SE_N163_Track>=1)
		ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + (0) * 2
		bne	_nsd_n163_ch1_voice_exit
	.endif
	ldy	#N163_Waveform - (8 * 0)

_nsd_n163_ch1_voice_set:
	sty	N163_Resister
	shl	a, 2
	sta	N163_Data
.ifdef	SE_N163
	sta	__n163_voice-nsd::TR_N163,x
.endif
_nsd_n163_ch1_voice_exit:
	rts

.repeat 7,cnt
	.ident( .concat("_nsd_n163_ch",.string(cnt+2),"_voice")):
	ldy	__n163_num
	cpy	#cnt*$10+$10
	bcc	_nsd_n163_ch1_voice_exit	;1未満だったら終了
	.if (nsd::SE_N163_Track>=cnt+2)
		ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + (cnt+1) * 2
		bne	_nsd_n163_ch1_voice_exit
	.endif
	ldy	#N163_Waveform - (8 * (cnt+1))
	bne	_nsd_n163_ch1_voice_set
.endrepeat

.ifdef	SE_N163
_nsd_n163_ch1_voice_se:
	ldy	#N163_Waveform - (8 * 0)

_nsd_n163_ch1_voice_set_se:
	sty	N163_Resister
	shl	a, 2
	sta	N163_Data

_nsd_n163_ch1_voice_exit_se:
	rts

.repeat 7,cnt
	.ident( .concat("_nsd_n163_ch",.string(cnt+2),"_voice_se")):
	ldy	__n163_num
	cpy	#cnt*$10+$10
	bcc	_nsd_n163_ch1_voice_exit_se	;1未満だったら終了
	ldy	#N163_Waveform - (8 * (cnt+1))
	bne	_nsd_n163_ch1_voice_set_se
.endrepeat
.endif
.endif

;---------------------------------------
.ifdef	PSG
;0ppn-nnnn
;	n nnnn	frequency
;	pp	00 noise	0-15
;		01 tone + noise	16-31
;		10 tone		32
;		11 none
_nsd_psg_ch1_voice:
	tay

	lda	__psg_switch
	and	#%00110110	;mask

	cpy	#$40
	bcs	@L40

	pha
	lda	#PSG_Noise_Frequency
	sta	PSG_Register
	tya
	and	#$1F
	sta	PSG_Data
	pla

	cpy	#$20
	bcc	@L60
	bcs	_nsd_psg_ch1_voice_SET

@L40:
	ora	#%00001000	;noise off
	cpy	#$60
	bcc	_nsd_psg_ch1_voice_SET
@L60:
	ora	#%00000001	;tone off

_nsd_psg_ch1_voice_SET:
	ldy	#PSG_Switch
	sty	PSG_Register
	sta	__psg_switch
	sta	PSG_Data
	rts

;---------------------------------------
_nsd_psg_ch2_voice:
	tay

	lda	__psg_switch
	and	#%00101101	;mask

	cpy	#$40
	bcs	@L40

	pha
	lda	#PSG_Noise_Frequency
	sta	PSG_Register
	tya
	and	#$1F
	sta	PSG_Data
	pla

	cpy	#$20
	bcc	@L60
	bcs	_nsd_psg_ch1_voice_SET

@L40:
	ora	#%00010000	;noise off
	cpy	#$60
	bcc	_nsd_psg_ch1_voice_SET
@L60:
	ora	#%00000010	;tone off
	jmp	_nsd_psg_ch1_voice_SET

;---------------------------------------
_nsd_psg_ch3_voice:
	tay

	lda	__psg_switch
	and	#%00011011	;mask

	cpy	#$40
	bcs	@L40

	pha
	lda	#PSG_Noise_Frequency
	sta	PSG_Register
	tya
	and	#$1F
	sta	PSG_Data
	pla

	cpy	#$20
	bcc	@L60
	bcs	_nsd_psg_ch1_voice_SET

@L40:
	ora	#%00100000	;noise off
	cpy	#$60
	bcc	_nsd_psg_ch1_voice_SET
@L60:
	ora	#%00000100	;tone off
	jmp	_nsd_psg_ch1_voice_SET

.endif

.endproc



;=======================================================================
;	void	__fastcall__	nsd_snd_volume(char vol);
;-----------------------------------------------------------------------
;<<Contents>>
;	Ser the volume
;<<Input>>
;	a	volume ( 0 to 255 )
;<<Output>>
;	nothing
;<<Note>>
;	■■■※最終的なレジスタの更新も行うので、毎フレーム必ず呼ぶこと！！
;=======================================================================
.proc	_nsd_snd_volume
.segment "PRG_AUDIO_DATA"
JMPTBL:	.addr	_nsd_apu_ch1_volume	;BGM ch1 Pulse
	.addr	_nsd_apu_ch2_volume	;BGM ch2 Pulse
	.addr	_nsd_apu_ch3_volume	;BGM ch3 Triangle
	.addr	_nsd_apu_ch4_volume	;BGM ch4 Noize
	.addr	Exit			;BGM ch5 DPCM		-- no process --
.ifdef	FDS
	.addr	_nsd_fds_volume
.endif
.ifdef	VRC6
	.addr	_nsd_vrc6_ch1_volume
	.addr	_nsd_vrc6_ch2_volume
	.addr	_nsd_vrc6_ch3_volume
.endif
.ifdef	VRC7
	.addr	_nsd_vrc7_volume
	.addr	_nsd_vrc7_volume
	.addr	_nsd_vrc7_volume
	.addr	_nsd_vrc7_volume
	.addr	_nsd_vrc7_volume
	.addr	_nsd_vrc7_volume
.endif
.ifdef	OPLL
	.addr	_nsd_OPLL_volume
	.addr	_nsd_OPLL_volume
	.addr	_nsd_OPLL_volume
	.addr	_nsd_OPLL_volume
	.addr	_nsd_OPLL_volume
	.addr	_nsd_OPLL_volume
	.addr	_nsd_OPLL_volume_R
	.addr	_nsd_OPLL_volume_R
	.addr	_nsd_OPLL_volume_R
	.addr	_nsd_opll_BD_volume
	.addr	_nsd_opll_SD_HH_volume
	.addr	_nsd_opll_SD_HH_volume
	.addr	_nsd_opll_Cym_Tom_volume
	.addr	_nsd_opll_Cym_Tom_volume
.endif
.ifdef	MMC5
	.addr	_nsd_mmc5_ch1_volume
	.addr	_nsd_mmc5_ch2_volume
.endif
.ifdef	N163
	.repeat ::nsd::N163_Track,cnt
		.addr	.ident(.concat("_nsd_n163_ch",.string(cnt+1),"_volume"))
	.endrepeat
.endif
.ifdef	PSG
	.addr	_nsd_psg_ch1_volume
	.addr	_nsd_psg_ch2_volume
	.addr	_nsd_psg_ch3_volume
.endif
.ifdef	NULL
	.addr	Exit
.endif

.ifdef	SE
	.addr	_nsd_apu_ch1_volume_se	;SE  ch1 Pulse
.endif
	.addr	_nsd_apu_ch2_volume_se	;SE  ch2 Pulse
.ifdef	SE
	.addr	_nsd_apu_ch3_volume_se	;SE  ch3 Tri
.endif
	.addr	_nsd_apu_ch4_volume_se	;SE  ch4 Noize
.ifdef	SE
	.addr	Exit
.endif
.ifdef	SE_N163
	.repeat nsd::SE_N163_Track,cnt
		.addr	.ident(.concat("_nsd_n163_ch",.string(cnt+1),"_volume_se"))
	.endrepeat
.endif
;---------------------------------------
.segment "PRG_AUDIO_CODE"
.ifdef	MASK
	tay
	lda	__chflag,x
	bpl	@PL
@MI:
	lda	#0
	beq	@LL
@PL:
	tya
@LL:
.endif


.ifdef	FO_MOD

	ldy	__channel
	cpy	#nsd::TR_SE
	bcs	@skipFade

	and	#$0f
	sta	__tmp

	lda	__fo_value
	and	#$0f
	asl
	asl
	asl
	asl
	ora	__tmp
	stx	__tmp + 1
	jsr	_nsd_mul_already_a_or_x
	ldx	__tmp + 1
@skipFade:
.endif


	ldy	JMPTBL,x		;
	sty	__ptr			;
	ldy	JMPTBL + 1,x		;
	sty	__ptr + 1		;
	jmp	(__ptr)			;[5]

;---------------------------------------
_nsd_apu_ch1_volume:
	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Pluse1 + 1
	bne	Exit
.endif

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off
	ora	__apu_voice_set1

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	APU_PULSE1CTRL

	;-------------------------------
	; *** Exit
Exit:
	rts

;---------------------------------------
.ifdef	SE
_nsd_apu_ch1_volume_se:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off
	ora	__se_voice_set1

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	APU_PULSE1CTRL

	;-------------------------------
	; *** Exit
	rts
.endif

;---------------------------------------
_nsd_apu_ch2_volume:
	;-------------------------------
	;SE check
	ldy	__Sequence_ptr + nsd::TR_SE_Pluse2 + 1
	bne	Exit

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off
	ora	__apu_voice_set2

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	APU_PULSE2CTRL

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_apu_ch2_volume_se:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off
	ora	__se_voice_set2

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	APU_PULSE2CTRL

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_apu_ch3_volume:

	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Tri + 1
	bne	Exit
.endif
	cmp	#0
	beq	_nsd_apu_ch3_Counter_Set
	cmp	#4
	bcc	@L
	lda	#$FF

@L:	sta	APU_TRICTRL1
	lda	__apu_frequency3
	sta	APU_TRIFREQ2
	rts

_nsd_apu_ch3_Counter_Set:
	lda	#$80
	sta	APU_TRICTRL1
	rts

;---------------------------------------
.ifdef	SE
_nsd_apu_ch3_volume_se:

	cmp	#0	; volume
	bne	@skip
	ldy	__Sequence_ptr + nsd::TR_BGM3 + 1
	bne	@end
	jmp	_nsd_apu_ch3_Counter_Set
@skip:
	cmp	#4
	bcc	@L
	lda	#$FF

@L:	sta	APU_TRICTRL1
	lda	__se_frequency3
	sta	APU_TRIFREQ2
	rts
@end:
.endif

;---------------------------------------
_nsd_apu_ch4_volume:
	;-------------------------------
	;SE check
	ldy	__Sequence_ptr + nsd::TR_SE_Noise + 1
	bne	Exit

_nsd_apu_ch4_volume_se:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	APU_NOISECTRL

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
.ifdef	FDS
_nsd_fds_volume:
	;-------------------------------
	; *** Calculate the voice
	and	#$3F
	ora	#$80

	;-------------------------------
	; *** Set the voice to work
	sta	FDS_Volume

	;-------------------------------
	; *** Exit
	rts
.endif

;---------------------------------------
.ifdef	VRC6
_nsd_vrc6_ch1_volume:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	__vrc6_voice_set1

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	VRC6_Pulse1_CTRL

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_vrc6_ch2_volume:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	__vrc6_voice_set2

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	VRC6_Pulse2_CTRL

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_vrc6_ch3_volume:
	and	#$3F
	sta	VRC6_SAW_CTRL
	rts

.endif

;---------------------------------------
.ifdef	VRC7
_nsd_vrc7_volume:


	eor	#$FF			;[2]2
	and	#$0F			;[2]4
	sta	__tmp			;[3]7	__tmp <- volume

	;チャンネルの計算
	txa				;[2]9
	sub	#nsd::TR_VRC7		;[3]12
	shr	a, 1			;[2]14
	tay				;[2]16
	pha				;[3]19

	;《音量・音色番号書き込み》
	;────────────────
	add	#VRC7_Volume		;[4]23
	sta	VRC7_Resister		;●Resister Write
	lda	__tmp			;[3]
	ora	__vrc7_voice_set,y	;[4]
	sta	VRC7_Data		;●Data Write

	;《周波数 下位byte 書き込み》
	;────────────────
	ldy	#0					;[2]2
	lda	__detune_fine,x				;[4]6
	bpl	@L					;[3] or [4]9	(Branch) or [4](not Branch)
	dey						;	ay = __detune_fine (sign expand)
@L:	add	__vrc7_frequency - nsd::TR_VRC7 + 0,x	;[6]15
	sta	__tmp					;[3]18
	tya						;[2]20
	adc	__vrc7_frequency - nsd::TR_VRC7 + 1,x	;[4]24
	and	#$0F					;[2]26
	sta	__tmp + 1				;[3]29	__tmp += (signed int)__detune_cent
	pla						;[4]33
	pha						;[3]36
	tay						;[2]38	y <- device channel
	add	#VRC7_Frequency				;[4]42 > 42 clock !! (VRC7のwait)
	sta	VRC7_Resister				;●Resister Write
	pla						;[4]
	lda	__tmp					;[2]6
	sta	VRC7_Data				;●Data Write

	;《フラグ・オクターブ・周波数上位byte書き込み》
	;────────────────
	lda	__chflag,x		;[4]
	and	#$30			;[2]6	 00XX 0000 <2>
	ora	__tmp + 1		;[3]9	flag と octave をマージ
	cmp	__vrc7_freq_old,y	;[4]13
	beq	@freq_exit		;[2]15	同じだったら書かない。
	sta	__vrc7_freq_old,y	;[5]20
	pha				;[3]23	*Wait
	pla				;[4]27	*Wait
	pha				;[3]30	*Wait
	pla				;[4]34	*Wait
	tya				;[2]36	*Wait
	tya				;[2]38
	add	#VRC7_Octave		;[4]42 > 42 clock !! (VRC7のwait)
	sta	VRC7_Resister		;●Resister Write
	tya				;[2]
	lda	__vrc7_freq_old,y	;[4]6 clock
	sta	VRC7_Data		;●Data Write

@freq_exit:

	rts				;[6]
.endif

;---------------------------------------
.ifdef	OPLL
_nsd_OPLL_volume_R:

	;OPLL_Rhythm check
	ldy	__opll_ryhthm
	cpy	#$20
	bcs	_nsd_OPLL_volume_exit

_nsd_OPLL_volume:

	eor	#$FF			;[2]2
	and	#$0F			;[2]4
	sta	__tmp			;[3]7	__tmp <- volume

	;チャンネルの計算
	txa				;[2]9
	sub	#nsd::TR_OPLL		;[3]12
	shr	a, 1			;[2]14
	tay				;[2]16
	pha				;[3]19

	;《音量・音色番号書き込み》
	;────────────────
	add	#OPLL_Volume		;[4]23
	sta	OPLL_Resister		;●Resister Write
	lda	__tmp			;[3]
	ora	__opll_voice_set,y	;[4]
	sta	OPLL_Data		;●Data Write

	;《周波数 下位byte 書き込み》
	;────────────────
	ldy	#0					;[2]2
	lda	__detune_fine,x				;[4]6
	bpl	@L					;[3] or [4]9	(Branch) or [4](not Branch)
	dey						;	ay = __detune_fine (sign expand)
@L:	add	__opll_frequency - nsd::TR_OPLL + 0,x	;[6]15
	sta	__tmp					;[3]18
	tya						;[2]20
	adc	__opll_frequency - nsd::TR_OPLL + 1,x	;[4]24
	and	#$0F					;[2]26
	sta	__tmp + 1				;[3]29	__tmp += (signed int)__detune_cent
	pla						;[4]33
	pha						;[3]36
	tay						;[2]38	y <- device channel
	add	#OPLL_Frequency				;[4]42 > 42 clock !! (OPLLのwait)
	sta	OPLL_Resister				;●Resister Write
	pla						;[4]
	lda	__tmp					;[2]6
	sta	OPLL_Data				;●Data Write

	;《フラグ・オクターブ・周波数上位byte書き込み》
	;────────────────
	lda	__chflag,x		;[4]
	and	#$30			;[2]6	 00XX 0000 <2>
	ora	__tmp + 1		;[3]9	flag と octave をマージ
	cmp	__opll_freq_old,y	;[4]13
	beq	@freq_exit		;[2]15	同じだったら書かない。
	sta	__opll_freq_old,y	;[5]20
	pha				;[3]23	*Wait
	pla				;[4]27	*Wait
	pha				;[3]30	*Wait
	pla				;[4]34	*Wait
	tya				;[2]36	*Wait
	tya				;[2]38
	add	#OPLL_Octave		;[4]42 > 42 clock !! (OPLLのwait)
	sta	OPLL_Resister		;●Resister Write
	tya				;[2]
	lda	__opll_freq_old,y	;[4]6 clock
	sta	OPLL_Data		;●Data Write

@freq_exit:
_nsd_OPLL_volume_exit:

	rts				;[6]
;---------------------------------------
_nsd_opll_BD_volume:
	lda	#$0F
	sta	__tmp
	lda	__volume + nsd::TR_OPLL + 18
	sta	__tmp + 1
	ldy	#OPLL_BD
	bne	_nsd_opll_DR_volume

_nsd_opll_SD_HH_volume:
	lda	__volume + nsd::TR_OPLL + 22
	sta	__tmp
	lda	__volume + nsd::TR_OPLL + 20
	sta	__tmp + 1
	ldy	#OPLL_HH_SD
	bne	_nsd_opll_DR_volume

_nsd_opll_Cym_Tom_volume:
	lda	__volume + nsd::TR_OPLL + 26
	sta	__tmp
	lda	__volume + nsd::TR_OPLL + 24
	sta	__tmp + 1
	ldy	#OPLL_TOM_CYM
;	bne	_nsd_opll_DR_volume

_nsd_opll_DR_volume:
	lda	__opll_ryhthm
	cmp	#$20
	bcc	@Exit

	sty	OPLL_Resister
	lda	__tmp
	shl	a, 4
	sta	__tmp
	lda	__tmp + 1
	and	#$0F
	ora	__tmp
	eor	#$FF
	sta	OPLL_Data
@Exit:
	rts

.endif

;---------------------------------------
.ifdef	MMC5
_nsd_mmc5_ch1_volume:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off
	ora	__mmc5_voice_set1

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	MMC5_Pulse1_CTRL

	;-------------------------------
	; *** Exit
	rts

;---------------------------------------
_nsd_mmc5_ch2_volume:

	;-------------------------------
	; *** Mix voice and volume
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	#$30	;a |= 0x30	;counter on / hard-envelop off
	ora	__mmc5_voice_set2

	;-------------------------------
	; *** Output to NES sound device
	;y = x << 1
	sta	MMC5_Pulse2_CTRL

	;-------------------------------
	; *** Exit
	rts
.endif

;---------------------------------------
.ifdef	N163
_nsd_n163_ch1_volume:
	.if (nsd::SE_N163_Track>=1)
		ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + 0 * 2
		bne	_nsd_n163_ch1_volume_Exit
	.endif
	ldy	#N163_Volume - (8 * 0)
.ifdef	SE_N163
	pha
	dey
	sty	N163_Resister
	lda	__n163_voice-nsd::TR_N163,x
	sta	N163_Data
	iny
	pla
.endif
	sty	N163_Resister
	and	#$0F
	ora	__n163_num
	sta	N163_Data
	rts

;---------------------------------------
_nsd_n163_ch2_volume:
	ldy	__n163_num
	cpy	#$10
	bcc	_nsd_n163_ch1_volume_Exit	;1未満だったら終了
	.if (nsd::SE_N163_Track>=2)
		ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + 1 * 2
		bne	_nsd_n163_ch1_volume_Exit
	.endif
	ldy	#N163_Volume - (8 * 1)

_nsd_n163_ch1_volume_Set:
.ifdef	SE_N163
	pha
	dey
	sty	N163_Resister
	lda	__n163_voice-nsd::TR_N163,x
	sta	N163_Data
	iny
	pla
.endif
@seTrack:
	sty	N163_Resister
	and	#$0F
	sta	N163_Data

_nsd_n163_ch1_volume_Exit:
	rts

.repeat 6,cnt
	.ident( .concat("_nsd_n163_ch",.string(cnt+3),"_volume")):
	ldy	__n163_num
	cpy	#cnt*$10+$20
	bcc	_nsd_n163_ch1_volume_Exit	;1未満だったら終了

	.if (nsd::SE_N163_Track>=cnt+3)
		ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + (cnt+2) * 2
		bne	_nsd_n163_ch1_volume_Exit
	.endif

	ldy	#N163_Volume - (8 * (cnt+2))
	bne	_nsd_n163_ch1_volume_Set

.endrepeat


.ifdef SE_N163

_nsd_n163_ch1_volume_se:
	ldy	#N163_Volume - (8 * 0)
	sty	N163_Resister
	and	#$0F
	ora	__n163_num
	sta	N163_Data
	rts

;---------------------------------------
_nsd_n163_ch2_volume_se:
	ldy	__n163_num
	cpy	#$10
	bcc	_nsd_n163_ch1_volume_Exit_se	;1未満だったら終了
	ldy	#N163_Volume - (8 * 1)

_nsd_n163_ch1_volume_Set_se:
	sty	N163_Resister
	and	#$0F
	sta	N163_Data

_nsd_n163_ch1_volume_Exit_se:
	rts


.repeat 6,cnt
	.ident( .concat("_nsd_n163_ch",.string(cnt+3),"_volume_se")):
	ldy	__n163_num
	cpy	#cnt*$10+$20
	bcc	_nsd_n163_ch1_volume_Exit_se	;1未満だったら終了

	ldy	#N163_Volume - (8 * (cnt+2))
	bne	_nsd_n163_ch1_volume_Set_se

.endrepeat

.endif
.endif

;---------------------------------------
.ifdef	PSG
_nsd_psg_ch1_volume:
	ldy	#PSG_1_Volume
	sty	PSG_Register

_nsd_psg_set_volume:
	and	#$0F
	sta	__tmp
	lda	__chflag,x
	and	#nsd_chflag::Envelop
	ora	__tmp
	sta	PSG_Data
	rts

_nsd_psg_ch2_volume:
	ldy	#PSG_2_Volume
	sty	PSG_Register
	bne	_nsd_psg_set_volume

_nsd_psg_ch3_volume:
	ldy	#PSG_3_Volume
	sty	PSG_Register
	bne	_nsd_psg_set_volume

.endif

.endproc



;=======================================================================
;	void	__fastcall__	nsd_snd_sweep(char vol);
;-----------------------------------------------------------------------
;<<Contents>>
;	Ser the volume
;<<Input>>
;	a	volume ( 0 to 255 )
;<<Output>>
;	nothing
;=======================================================================
.proc	_nsd_snd_sweep
.segment "PRG_AUDIO_DATA"
JMPTBL:	.addr	_nsd_apu_ch1_sweep	;BGM ch1 Pulse
	.addr	_nsd_apu_ch2_sweep	;BGM ch2 Pulse
	.addr	_nsd_apu_ch3_time	;BGM ch3 Triangle
	.addr	Exit			;BGM ch4 Noize		-- no process --
	.addr	Exit			;BGM ch5 DPCM		-- no process --
.ifdef	FDS
	.addr	_nsd_fds_sweep_bias
.endif
.ifdef	VRC6
	.addr	Exit
	.addr	Exit
	.addr	Exit
.endif
.ifdef	VRC7
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
.endif
.ifdef	OPLL
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_vrc7_sustain
	.addr	_nsd_OPLL_ryhthm
	.addr	_nsd_OPLL_ryhthm
	.addr	_nsd_OPLL_ryhthm
	.addr	_nsd_OPLL_ryhthm
	.addr	_nsd_OPLL_ryhthm
.endif
.ifdef	MMC5
	.addr	Exit
	.addr	Exit
.endif
.ifdef	N163
	.repeat ::nsd::N163_Track
		.addr	_nsd_n163_sample_length
	.endrepeat
.endif
.ifdef	PSG
	.addr	_nsd_psg_envelop
	.addr	_nsd_psg_envelop
	.addr	_nsd_psg_envelop
.endif
.ifdef	NULL
	.addr	Exit
.endif

.ifdef	SE
	.addr	_nsd_apu_ch1_sweep_se	;SE  ch1 Pulse
.endif
	.addr	_nsd_apu_ch2_sweep_se	;SE  ch2 Pulse
.ifdef	SE
	.addr	_nsd_apu_ch3_time_se	;SE  ch3 Tri
.endif
	.addr	Exit			;SE  ch4 Noize		-- no process --
.ifdef	SE
	.addr	Exit			;SE  ch5 DPCM		-- no process --
.endif

.ifdef	SE_N163
	.repeat nsd::SE_N163_Track
		.addr	_nsd_n163_sample_length_se
	.endrepeat
.endif


;---------------------------------------
.segment "PRG_AUDIO_CODE"
	ldy	JMPTBL,x
	sty	__ptr
	ldy	JMPTBL + 1,x
	sty	__ptr + 1
	jmp	(__ptr)

;---------------------------------------
_nsd_apu_ch1_sweep:

	sta	__sweep_ch1		;効果音からの復帰用

	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Pluse1 + 1
	bne	Exit
.endif

_nsd_apu_ch1_sweep_se:
	sta	APU_PULSE1RAMP
Exit:
	rts

;---------------------------------------
_nsd_apu_ch2_sweep:

	sta	__sweep_ch2		;効果音からの復帰用

	;-------------------------------
	;SE check
	ldy	__Sequence_ptr + nsd::TR_SE_Pluse2 + 1
	bne	Exit

_nsd_apu_ch2_sweep_se:
	sta	APU_PULSE2RAMP
	rts

;---------------------------------------
_nsd_apu_ch3_time:
	sta	__apu_tri_time
	rts

;---------------------------------------
.ifdef	SE
_nsd_apu_ch3_time_se:
	sta	__se_tri_time
	rts
.endif

.endproc
;---------------------------------------
.ifdef	FDS
.proc	_nsd_fds_sweep_bias
	and	#$7F
	sta	FDS_Sweep_Bias
	sta	__fds_sweepbias
	rts
.endproc
.endif

;---------------------------------------
.if	.defined(VRC7) || .defined(OPLL)
.proc	_nsd_vrc7_sustain

	ror	a		;c <= 0bit
	tay			;
	lda	__chflag,x

	bcc	@Sustain
	ora	#nsd_chflag::Sustain
	bne	@Sustain_E
@Sustain:
	and	#<~nsd_chflag::Sustain
@Sustain_E:

	cpy	#0
	beq	@NoKeyOff
	ora	#nsd_chflag::NoKeyOff
	bne	@NoKeyOff_E
@NoKeyOff:
	and	#<~nsd_chflag::NoKeyOff
@NoKeyOff_E:

@Set:	sta	__chflag,x

	rts
.endproc
.endif

.ifdef	OPLL
.proc	_nsd_OPLL_ryhthm

	shl	a, 5
	and	#$20
	sta	__tmp

	ldy	#OPLL_RHYTHM
	sty	OPLL_Resister

	lda	__opll_ryhthm
	and	#$1F
	ora	__tmp
	sta	__opll_ryhthm
	sta	OPLL_Data

	cmp	#$20
	bcc	Exit

L01:
	ldy	#$16
	sty	OPLL_Resister
	lda	#$20
	nop
	nop
	sta	OPLL_Data
	jsr	_Wait42

L02:
	ldy	#$17
	sty	OPLL_Resister
	lda	#$50
	nop
	nop
	sta	OPLL_Data
	jsr	_Wait42

L03:
	ldy	#$18
	sty	OPLL_Resister
	lda	#$C0
	nop
	nop
	sta	OPLL_Data
	jsr	_Wait42

L04:
	ldy	#$26
	sty	OPLL_Resister
	lda	#$05
	nop
	nop
	sta	OPLL_Data
	jsr	_Wait42

L05:
	ldy	#$27
	sty	OPLL_Resister
	lda	#$05
	nop
	nop
	sta	OPLL_Data
	jsr	_Wait42

L06:
	ldy	#$28
	sty	OPLL_Resister
	lda	#$01
	nop
	nop
	sta	OPLL_Data

Exit:
	rts
.endproc
.endif

;---------------------------------------
.ifdef	N163
.proc	_nsd_n163_sample_length
.if	0
	shl	a, 2
;	ora	#$E0
	sta	__tmp
	txa
	sub	#nsd::TR_N163
.ifndef	SE_N163
	shr	a, 1
.endif
	tay
	lda	__tmp
	sta	__n163_frequency,y
	rts
.else
	shl	a, 2
	sta	__n163_frequency-nsd::TR_N163,x
	rts

.endif

.endproc
.endif
.ifdef	SE_N163
.proc	_nsd_n163_sample_length_se
.if	0
	shl	a, 2
;	ora	#$E0
	sta	__tmp
	txa
	sub	#nsd::TR_SE_N163
.ifndef	SE_N163
	shr	a, 1
.endif
	tay
	lda	__tmp
	sta	__n163_frequency,y
	rts
.else
	shl	a, 2
	sta	__n163_frequency-nsd::TR_SE_N163,x
	rts

.endif

.endproc
.endif
;---------------------------------------
.ifdef	PSG
.proc	_nsd_psg_envelop
	cmp	#$10
	bcc	@L
	ldy	#PSG_Envelope_Form
	sty	PSG_Register
	tay
	and	#$0F
	sta	PSG_Data
	tya
@L:
	and	#nsd_chflag::Envelop
	sta	__tmp
	lda	__chflag,x
	and	#<~nsd_chflag::Envelop
	ora	__tmp
	sta	__chflag,x
	rts
.endproc
.endif
;=======================================================================
;	void	__fastcall__	nsd_snd_frequency(int freq);
;-----------------------------------------------------------------------
;<<Contents>>
;	Ser the voice (instruction)
;<<Input>>
;	ax	frequency (16 = 100 cent, o0c = 0x0000)
;<<Output>>
;	nothing
;=======================================================================
.segment "PRG_AUDIO_DATA"

;---------------------------------------
;APU, MMC5, VRC6, FME7 Frequency table
Freq:
.ifdef	PAL
;	.incbin	"freqTableApu.bin"
	.include	"freqTablePalApu.inc"
.else
	.include	"freqTableApu.inc"
.endif

;---------------------------------------
;FDS Frequency table
.ifdef	FDS
Freq_FDS:
	.include	"freqTableFds.inc"
.endif

;---------------------------------------
;SAW Frequency table
.ifdef	VRC6
Freq_SAW:
	.include	"freqTableVrc6.inc"
.endif

;---------------------------------------
;VRC7 Frequency table
.if	.defined(VRC7) || .defined(OPLL)
Freq_VRC7:
	.include	"freqTableVrc7.inc"
.endif

;---------------------------------------
;N163 Frequency table
.ifdef	N163
Freq_N163:
	.include	"freqTablen163.inc"

.endif

.segment "PRG_AUDIO_CODE"

.proc	_nsd_snd_frequency

.segment "PRG_AUDIO_DATA"

JMPTBL:	.addr	_nsd_apu_ch1_frequency		;BGM ch1 Pulse
	.addr	_nsd_apu_ch2_frequency		;BGM ch2 Pulse
	.addr	_nsd_apu_ch3_frequency		;BGM ch3 Triangle
	.addr	_nsd_apu_ch4_frequency		;BGM ch4 Noise
.ifdef	DPCM_PITCH
	.addr	_nsd_apu_ch5_frequency		;BGM ch5 DPCM
.else
	.addr	Exit				;BGM ch5 DPCM
.endif
.ifdef	FDS
	.addr	_nsd_fds_frequency
.endif
.ifdef	VRC6
	.addr	_nsd_vrc6_ch1_frequency
	.addr	_nsd_vrc6_ch2_frequency
	.addr	_nsd_vrc6_ch3_frequency
.endif
.ifdef	VRC7
	.addr	_nsd_vrc7_frequency
	.addr	_nsd_vrc7_frequency
	.addr	_nsd_vrc7_frequency
	.addr	_nsd_vrc7_frequency
	.addr	_nsd_vrc7_frequency
	.addr	_nsd_vrc7_frequency
.endif
.ifdef	OPLL
	.addr	_nsd_OPLL_frequency
	.addr	_nsd_OPLL_frequency
	.addr	_nsd_OPLL_frequency
	.addr	_nsd_OPLL_frequency
	.addr	_nsd_OPLL_frequency
	.addr	_nsd_OPLL_frequency
	.addr	_nsd_OPLL_frequency	;変数に書くだけは書いていい。
	.addr	_nsd_OPLL_frequency	;
	.addr	_nsd_OPLL_frequency	;
	.addr	_nsd_OPLL_frequency_BD
	.addr	_nsd_OPLL_frequency_HH_SD
	.addr	_nsd_OPLL_frequency_HH_SD
	.addr	_nsd_OPLL_frequency_TOM_CYM
	.addr	_nsd_OPLL_frequency_TOM_CYM
.endif
.ifdef	MMC5
	.addr	_nsd_mmc5_ch1_frequency
	.addr	_nsd_mmc5_ch2_frequency
.endif
.ifdef	N163
	.repeat ::nsd::N163_Track,cnt
		.addr	.ident(.concat("_nsd_n163_ch",.string(cnt+1),"_frequency"))
	.endrepeat
.endif
.ifdef	PSG
	.addr	_nsd_psg_ch1_frequency
	.addr	_nsd_psg_ch2_frequency
	.addr	_nsd_psg_ch3_frequency
.endif
.ifdef	NULL
	.addr	Exit
.endif

.ifdef	SE
	.addr	_nsd_apu_ch1_frequency_se	;SE  ch1 Pulse
.endif
	.addr	_nsd_apu_ch2_frequency_se	;SE  ch2 Pulse
.ifdef	SE
	.addr	_nsd_apu_ch3_frequency_se	;SE  ch3 Pulse
.endif
	.addr	_nsd_apu_ch4_frequency_se	;SE  ch4 Noise
.ifdef	SE
	.addr	Exit			;SE  ch5 Pulse
.endif
.ifdef	SE_N163
	.repeat ::nsd::SE_N163_Track,cnt
		.addr	.ident(.concat("_nsd_n163_ch",.string(cnt+1),"_frequency_se"))
	.endrepeat
.endif
;---------------------------------------
.segment "PRG_AUDIO_CODE"
	;-----------
	;check the old frequency
	ldy	__channel
	cmp	__frequency,y
	beq	@L
	sta	__frequency,y
	txa
	sta	__frequency + 1,y
	jmp	Set_Frequency
@L:	txa
	cmp	__frequency + 1,y
	beq	Exit
	sta	__frequency + 1,y

	;-----------
	;Jump
Set_Frequency:
	lda	JMPTBL,y
	sta	__ptr
	lda	JMPTBL + 1,y
	sta	__ptr + 1

	lda	__frequency,y		;ax ← __frequency
	jmp	(__ptr)
Exit:
;	ldx	__channel		;rts先で戻している。
	rts
.endproc

;---------------------------------------
.proc	_nsd_apu_ch1_frequency
	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Pluse1 + 1
	bne	Exit
.endif

	jsr	Normal_frequency

	lda	__tmp
	sta	APU_PULSE1FTUNE
	lda	__tmp + 1
	ora	#$08
	cmp	__apu_frequency1
	beq	Exit
	sta	APU_PULSE1CTUNE
	sta	__apu_frequency1

Exit:
	rts
.endproc

;---------------------------------------
.ifdef	SE
.proc	_nsd_apu_ch1_frequency_se

	jsr	Normal_frequency

	lda	__tmp
	sta	APU_PULSE1FTUNE
	lda	__tmp + 1
	ora	#$08
	cmp	__se_frequency1
	beq	Exit
	sta	APU_PULSE1CTUNE
	sta	__se_frequency1

Exit:
	rts
.endproc
.endif

;---------------------------------------
.proc	_nsd_apu_ch2_frequency
	;-------------------------------
	;SE check
	ldy	__Sequence_ptr + nsd::TR_SE_Pluse2 + 1
	bne	Exit

	jsr	Normal_frequency

	lda	__tmp
	sta	APU_PULSE2FTUNE
	lda	__tmp + 1
	ora	#$08
	cmp	__apu_frequency2
	beq	Exit
	sta	APU_PULSE2STUNE		;nes.inc 間違えてる。
	sta	__apu_frequency2
Exit:
	rts
.endproc

;---------------------------------------
.proc	_nsd_apu_ch2_frequency_se

	jsr	Normal_frequency

	lda	__tmp
	sta	APU_PULSE2FTUNE
	lda	__tmp + 1
	ora	#$08
	cmp	__se_frequency2
	beq	Exit
	sta	APU_PULSE2STUNE		;nes.inc 間違えてる。
	sta	__se_frequency2

Exit:
	rts
.endproc

;---------------------------------------
.proc	_nsd_apu_ch3_frequency
	;-------------------------------
	;SE check
.ifdef	SE
	ldy	__Sequence_ptr + nsd::TR_SE_Tri + 1
	bne	Exit
.endif
.ifdef	FO_MOD
	ldy	__fo_value
	beq	fadeOutZero
.endif
	jsr	Normal_frequency

.ifdef	SE
	;効果音から復帰したときの処理
	lda	#nsd_mode::RetSE
	bit	__gatemode + nsd::TR_BGM3
	beq	@L
	eor	#$FF
	and	__gatemode + nsd::TR_BGM3
	sta	__gatemode + nsd::TR_BGM3
	lda	__chflag + nsd::TR_BGM3
	and	#nsd_chflag::KeyOff
	cmp	#nsd_chflag::KeyOff
	bne	@L			;Key On(=3)の時のみ、処理。
	lda	__apu_tri_time
	sta	APU_TRICTRL1
@L:
.endif

	lda	__tmp
	sta	APU_TRIFREQ1
	lda	__tmp + 1
	ora	#$08
	cmp	__apu_frequency3
	beq	Exit
	sta	APU_TRIFREQ2
	sta	__apu_frequency3

Exit:
	rts
.ifdef	FO_MOD
fadeOutZero:
	lda	#$80
	sta	APU_TRICTRL1
	rts
.endif
.endproc

;---------------------------------------
.ifdef	SE
.proc	_nsd_apu_ch3_frequency_se

	jsr	Normal_frequency

	lda	__tmp
	sta	APU_TRIFREQ1
	lda	__tmp + 1
	ora	#$08
	cmp	__se_frequency3
	beq	Exit
	sta	APU_TRIFREQ2
	sta	__se_frequency3

Exit:
	rts
.endproc
.endif

;---------------------------------------
.proc	_nsd_apu_ch4_frequency
	;-------------------------------
	;SE check
	ldy	__Sequence_ptr + nsd::TR_SE_Noise + 1
	bne	Exit

	;-------------------------------
	; *** Get the note number lower 4bit
	;a >>= 4
	eor	#$FF
	shr	a,4

	;-------------------------------
	; *** Mix voice and frequency
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	__apu_voice_set4
	
	;-------------------------------
	; *** Output to NES sound device
	sta	APU_NOISEFREQ1
	; to do note on?
	lda	#$08
	sta	APU_NOISEFREQ2		;Length counter load (L) 

	;-------------------------------
	; *** Exit
Exit:
	rts

.endproc

;---------------------------------------
.proc	_nsd_apu_ch4_frequency_se

	;-------------------------------
	; *** Get the note number lower 4bit
	;a >>= 4
	eor	#$FF
	shr	a,4

	;-------------------------------
	; *** Mix voice and frequency
	;a = (a & 0x0F) | (nsd_word.Voice.voice_set & 0xF0)
	and	#$0F
	ora	__se_voice_set4
	
	;-------------------------------
	; *** Output to NES sound device
	sta	APU_NOISEFREQ1
	; to do note on?
	lda	#$08
	sta	APU_NOISEFREQ2		;Length counter load (L) 

	;-------------------------------
	; *** Exit
Exit:
	rts
.endproc
.ifdef DPCM_PITCH
;---------------------------------------
.proc	_nsd_apu_ch5_frequency
.ifdef	SE
	;-------------------------------
	;SE check
	ldy	__Sequence_ptr + nsd::TR_SE_Dpcm + 1
	bne	Exit
.endif
	txa
	ldx	__channel
	cmp	__tmp + 1
	beq	skipGetDpcmInfo
	sta	__tmp + 1

	lda	__chflag,x
	and	#nsd_chflag::KeyOff
	cmp	#nsd_chflag::KeyOff
	bne	Exit
	lda	__tmp + 1

	jsr	_nsd_dpcm_calc

.ifdef	DPCMBank
	jsr	_nsd_ptr_bank
	;bank number
	ldy	#4
	lda	(__ptr),y
	jsr	_nsd_bank_change
.endif

	lda	#$0F
	sta	APU_CHANCTRL

	;Set the DPCM resister
	;length
	ldy	#3
	lda	(__ptr),y
	sta	APU_MODLEN

	;address
	dey
	lda	(__ptr),y
	sta	APU_MODADDR

	dey
	dey

	;CTRL (note etc..)
;	ldy	#0
	lda	(__ptr),y
	sta	__dpcm_freq
writeCtrl:
	and	#$f0
	sta	__tmp + 1
	lda	(__ptr),y
	add	__tmp
	and	#$0f
	ora	__tmp + 1
	sta	APU_MODCTRL

	lda	#$1F
	sta	APU_CHANCTRL

Exit:
	rts
skipGetDpcmInfo:
	lda	__chflag,x
	and	#nsd_chflag::KeyOff
	cmp	#nsd_chflag::KeyOff
	bne	Exit

	lda	__dpcm_freq
	ldy	#0
	jmp	writeCtrl
.endproc
.endif
;---------------------------------------
.ifdef	FDS
.proc	_nsd_fds_frequency

	jsr	_nsd_div192		; 
;	and	#$FE			; x =  ax  /  192
	lsr	a
	bcc	@L
	ora	#$80
@L:	asl	a
	tay				; y = (ax mod 192) & 0xFE

	;-------------------------------
	; *** Get frequency from table
	; nsd_work_zp._tmp <- frequency
	lda	Freq_FDS + 1,y
	sta	__tmp + 1
	lda	Freq_FDS,y

	bcc	Octave_Proc

	;線形補完
	add	Freq_FDS + 2,y
	sta	__tmp
	lda	__tmp + 1
	adc	Freq_FDS + 3,y
	lsr	a
	sta	__tmp + 1
	lda	__tmp
	ror	a

	; *** Octave caluclate  and  overflow check
Octave_Proc:
	;if (octave == 0) {
	cpx	#7
	bcc	Octave_Loop
	bne	@Over
	sta	__tmp
	lda	__tmp + 1
	cmp	#$10				;if (frequency >= 0x1000) {
	bcc	Detune
@Over:	lda	#$0F
	sta	__tmp + 1
	lda	#$FF				;	frequency = 0x0FFF
	jmp	Octave_Exit			; } else {
	; } } else { while (octave > 0) {
Octave_Loop:
	lsr	__tmp + 1	; frequency >>= 1
	ror	a
	inx			; octave--;
	cpx	#7
	bne	Octave_Loop
	; } }
Octave_Exit:
	sta	__tmp

Detune:	
	ldx	__channel
	ldy	#$00
	lda	__detune_fine,x
	bpl	@L
	dey				; ay = __detune_fine (sign expand)
@L:	add	__tmp
	sta	FDS_FTUNE
.ifdef FDS_SYNC
	sta	__tmp
.endif
	tya
	adc	__tmp + 1
	and	#$0F
	sta	FDS_CTUNE		;__tmp += (signed int)__detune_cent
.ifdef FDS_SYNC
	sta	__fds_frequency

	lda	__chflag,x
	and	#nsd_chflag::FdsSync
	beq	@noFdsSync
	lda	__tmp
	sta	FDS_Mod_FTUNE
	lda	__fds_frequency
	sta	FDS_Mod_CTUNE
@noFdsSync:
.endif

	rts
.endproc
.endif

;---------------------------------------
.ifdef	VRC6
.proc	_nsd_vrc6_ch1_frequency
	jsr	Normal12_frequency

	lda	__tmp
	sta	VRC6_Pulse1_FTUNE
	lda	__tmp + 1
	ora	#$80
	sta	VRC6_Pulse1_CTUNE

	rts
.endproc

;---------------------------------------
.proc	_nsd_vrc6_ch2_frequency
	jsr	Normal12_frequency

	lda	__tmp
	sta	VRC6_Pulse2_FTUNE
	lda	__tmp + 1
	ora	#$80
	sta	VRC6_Pulse2_CTUNE

	rts
.endproc

;---------------------------------------
.proc	_nsd_vrc6_ch3_frequency

	jsr	_nsd_div192		; 
;	and	#$FE			; x =  ax  /  192
	lsr	a
	bcc	@L
	ora	#$80
@L:	asl	a
	tay				; y = (ax mod 192) & 0xFE

	;-------------------------------
	; *** Get frequency from table
	lda	Freq_SAW + 1,y
	sta	__tmp + 1
	lda	Freq_SAW,y

	bcc	Octave_Proc

	;線形補完
	add	Freq_SAW + 2,y
	sta	__tmp
	lda	__tmp + 1
	adc	Freq_SAW + 3,y
	lsr	a
	sta	__tmp + 1
	lda	__tmp
	ror	a

	;-------------------------------
	; *** Octave caluclate  and  overflow check
Octave_Proc:
	;if (octave == 0) {
	cpx	#0
	beq	DEC_Freq
Octave_Loop:
	lsr	__tmp + 1	; frequency >>= 1
	ror	a
	dex			; octave--;
	bne	Octave_Loop
	; } }
DEC_Freq:
	sub	#1
	bcs	Octave_Exit
	dec	__tmp + 1	; frequency -= 1
Octave_Exit:
	sta	__tmp

Detune:	
	ldx	__channel
	ldy	#$00
	lda	__detune_fine,x
	bpl	@L
	dey				; ay = __detune_fine (sign expand)
@L:	add	__tmp
	sta	__tmp
	tya
	adc	__tmp + 1
	sta	__tmp + 1		;__tmp += (signed int)__detune_cent

	lda	__tmp
	sta	VRC6_SAW_FTUNE
	lda	__tmp + 1
	ora	#$80
	sta	VRC6_SAW_CTUNE

	rts
.endproc
.endif

;---------------------------------------
.ifdef	VRC7
.proc	_nsd_vrc7_frequency

	;除算
	jsr	_nsd_div192		;Wait変わりに使える？
	stx	__tmp + 1
	cmp	#(Freq_VRC7_Carry_00 - Freq_VRC7) * 2
	rol	__tmp + 1		;__tmp + 1 = (Octave << 1) + Note_MSB

	shr	a, 1			;
	tay				;y = (ax mod 192) >> 1
	lda	Freq_VRC7,y		;
	adc	#0			;補完

	;チャンネルの計算
	ldx	__channel
	sta	__vrc7_frequency - nsd::TR_VRC7 + 0,x
	lda	__tmp + 1
	sta	__vrc7_frequency - nsd::TR_VRC7 + 1,x

	rts
.endproc
.endif

;---------------------------------------
.ifdef	OPLL
.proc	_nsd_OPLL_frequency

	;除算
	jsr	_nsd_div192		;Wait変わりに使える？
	stx	__tmp + 1
	cmp	#(Freq_VRC7_Carry_00 - Freq_VRC7) * 2
	rol	__tmp + 1		;__tmp + 1 = (Octave << 1) + Note_MSB

	shr	a, 1			;
	tay				;y = (ax mod 192) >> 1
	lda	Freq_VRC7,y		;
	adc	#0			;補完

	;チャンネルの計算
	ldx	__channel
	sta	__opll_frequency - nsd::TR_OPLL + 0,x
	lda	__tmp + 1
	sta	__opll_frequency - nsd::TR_OPLL + 1,x

	rts
.endproc

.proc	_nsd_OPLL_frequency_BD

	;除算
	jsr	_nsd_div192		;Wait変わりに使える？
	stx	__tmp + 1
	cmp	#(Freq_VRC7_Carry_00 - Freq_VRC7) * 2
	rol	__tmp + 1		;__tmp + 1 = (Octave << 1) + Note_MSB

	shr	a, 1			;
	tay				;y = (ax mod 192) >> 1
	lda	Freq_VRC7,y		;
	adc	#0			;補完
	sta	__tmp			;__tmp + 0 = Note_LSB

	ldx	__channel
	;オクターブ
	lda	#OPLL_Frequency_BD
	sta	OPLL_Resister		;●Resister Write

Detune:	
	ldy	#$00			;[2]
	lda	__detune_fine,x		;[4]6
	bpl	@L			;[2]8
	dey				;	ay = __detune_fine (sign expand)
@L:	add	__tmp			;[5]13	clock > 6 clock
	sta	OPLL_Data		;●Data Write
	tya				;[2]
	adc	__tmp + 1		;[3]5
	and	#$0F			;[2]7
	sta	__tmp + 1		;[3]10	__tmp += (signed int)__detune_cent
	lda	__chflag,x		;[4]14
	and	#$30			;[2]16	 00XX 0000 <2>
	ora	__tmp + 1		;[3]19	flag と octave をマージ
	sta	__tmp + 1		;[3]22

	lda	(__ptr,x)		;[6]28
	lda	(__ptr,x)		;[6]34
	lda	(__ptr,x)		;[6]40

	lda	#OPLL_Octave_BD		;[2]42

	sta	OPLL_Resister		;●Resister Write
	lda	__tmp + 1		;[3]3
	lda	__tmp + 1		;[3]3
	sta	OPLL_Data		;●Data Write

	rts
.endproc

.proc	_nsd_OPLL_frequency_HH_SD

	;除算
	jsr	_nsd_div192		;Wait変わりに使える？
	stx	__tmp + 1
	cmp	#(Freq_VRC7_Carry_00 - Freq_VRC7) * 2
	rol	__tmp + 1		;__tmp + 1 = (Octave << 1) + Note_MSB

	shr	a, 1			;
	tay				;y = (ax mod 192) >> 1
	lda	Freq_VRC7,y		;
	adc	#0			;補完
	sta	__tmp			;__tmp + 0 = Note_LSB

	ldx	__channel
	lda	__chflag,x
	and	#nsd_chflag::KeyOff
	cmp	#$03
	bne	Exit

	;オクターブ
	lda	#OPLL_Frequency_HH_SD
	sta	OPLL_Resister		;●Resister Write

Detune:	
	ldy	#$00			;[2]
	lda	__detune_fine,x		;[4]6
	bpl	@L			;[2]8
	dey				;	ay = __detune_fine (sign expand)
@L:	add	__tmp			;[5]13	clock > 6 clock
	sta	OPLL_Data		;●Data Write
	tya				;[2]
	adc	__tmp + 1		;[3]5
	and	#$0F			;[2]7
	sta	__tmp + 1		;[3]10	__tmp += (signed int)__detune_cent
	lda	__chflag,x		;[4]14
	and	#$30			;[2]16	 00XX 0000 <2>
	ora	__tmp + 1		;[3]19	flag と octave をマージ
	sta	__tmp + 1		;[3]22

	lda	(__ptr,x)		;[6]28
	lda	(__ptr,x)		;[6]34
	lda	(__ptr,x)		;[6]40

	lda	#OPLL_Octave_HH_SD	;[2]42

	sta	OPLL_Resister		;●Resister Write
	lda	__tmp + 1		;[3]3
	lda	__tmp + 1		;[3]3
	sta	OPLL_Data		;●Data Write
Exit:
	rts
.endproc

.proc	_nsd_OPLL_frequency_TOM_CYM

	;除算
	jsr	_nsd_div192		;Wait変わりに使える？
	stx	__tmp + 1
	cmp	#(Freq_VRC7_Carry_00 - Freq_VRC7) * 2
	rol	__tmp + 1		;__tmp + 1 = (Octave << 1) + Note_MSB

	shr	a, 1			;
	tay				;y = (ax mod 192) >> 1
	lda	Freq_VRC7,y		;
	adc	#0			;補完
	sta	__tmp			;__tmp + 0 = Note_LSB

	ldx	__channel
	lda	__chflag,x
	and	#nsd_chflag::KeyOff
	cmp	#$03
	bne	Exit

	;オクターブ
	lda	#OPLL_Frequency_TOM_CYM
	sta	OPLL_Resister		;●Resister Write

Detune:	
	ldy	#$00			;[2]
	lda	__detune_fine,x		;[4]6
	bpl	@L			;[2]8
	dey				;	ay = __detune_fine (sign expand)
@L:	add	__tmp			;[5]13	clock > 6 clock
	sta	OPLL_Data		;●Data Write
	tya				;[2]
	adc	__tmp + 1		;[3]5
	and	#$0F			;[2]7
	sta	__tmp + 1		;[3]10	__tmp += (signed int)__detune_cent
	lda	__chflag,x		;[4]14
	and	#$30			;[2]16	 00XX 0000 <2>
	ora	__tmp + 1		;[3]19	flag と octave をマージ
	sta	__tmp + 1		;[3]22

	lda	(__ptr,x)		;[6]28
	lda	(__ptr,x)		;[6]34
	lda	(__ptr,x)		;[6]40

	lda	#OPLL_Octave_TOM_CYM	;[2]42

	sta	OPLL_Resister		;●Resister Write
	lda	__tmp + 1		;[3]3
	lda	__tmp + 1		;[3]3
	sta	OPLL_Data		;●Data Write
Exit:
	rts
.endproc


.endif

;---------------------------------------
.ifdef	MMC5
.proc	_nsd_mmc5_ch1_frequency
	jsr	Normal_frequency

	lda	__tmp
	sta	MMC5_Pulse1_FTUNE
	lda	__tmp + 1
	ora	#$08
	cmp	__mmc5_frequency1
	beq	Exit
	sta	MMC5_Pulse1_CTUNE
	sta	__mmc5_frequency1

Exit:
	rts
.endproc

;---------------------------------------
.proc	_nsd_mmc5_ch2_frequency
	jsr	Normal_frequency

	lda	__tmp
	sta	MMC5_Pulse2_FTUNE
	lda	__tmp + 1
	ora	#$08
	cmp	__mmc5_frequency2
	beq	Exit
	sta	MMC5_Pulse2_CTUNE
	sta	__mmc5_frequency2

Exit:
	rts
.endproc
.endif

;---------------------------------------
.ifdef	N163

.proc	_nsd_n163_frequency_Exit
	rts
.endproc

.proc	_nsd_n163_ch1_frequency

	.if (nsd::SE_N163_Track>=1)
		ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + (0) * 2
		jne	_nsd_n163_frequency_Exit
	.endif

	jsr	N163_frequency
	ldy	#N163_Frequency_Low - (8 * 0)
	bne	_nsd_n163_frequency
.endproc


.repeat 7,cnt
	.proc	.ident( .concat("_nsd_n163_ch",.string(cnt+2),"_frequency"))
		ldy	__n163_num
		cpy	#cnt*$10+$10
		bcc	_nsd_n163_frequency_Exit	;1未満だったら終了

		.if (nsd::SE_N163_Track>=cnt+2)
			ldy	__Sequence_ptr + 1 + nsd::TR_SE_N163 + (cnt+1) * 2
			bne	_nsd_n163_frequency_Exit
		.endif

		jsr	N163_frequency
		ldy	#N163_Frequency_Low - (8 * (cnt+1))

		.if (cnt <= 5)
			bne	_nsd_n163_frequency
		.endif
	.endproc
.endrepeat

.proc	_nsd_n163_frequency
.if	0
	sty	N163_Resister
	lda	__tmp
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	lda	__tmp + 1
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	txa
	sub	#nsd::TR_N163
.ifndef	SE_N163
	shr	a, 1
.endif
	tay
	lda	__ptr
	ora	__n163_frequency,y
	sta	N163_Data
	rts

.else
	sty	N163_Resister
	lda	__tmp
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	lda	__tmp + 1
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	lda	__ptr
	ora	__n163_frequency-nsd::TR_N163,x
	sta	N163_Data
	rts
.endif

.endproc




.endif
.ifdef	SE_N163
.proc	_nsd_n163_frequency_Exit_se
	rts
.endproc
.proc	_nsd_n163_ch1_frequency_se

	jsr	N163_frequency
	ldy	#N163_Frequency_Low - (8 * 0)
	bne	_nsd_n163_frequency_se
.endproc

.repeat 7,cnt
	.proc	.ident( .concat("_nsd_n163_ch",.string(cnt+2),"_frequency_se"))
		ldy	__n163_num
		cpy	#cnt*$10+$10
		bcc	_nsd_n163_frequency_Exit_se	;1未満だったら終了

		jsr	N163_frequency
		ldy	#N163_Frequency_Low - (8 * (cnt+1))

		.if (cnt <= 5)
			bne	_nsd_n163_frequency_se
		.endif
	.endproc
.endrepeat

.proc	_nsd_n163_frequency_se
.if 0
	sty	N163_Resister
	lda	__tmp
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	lda	__tmp + 1
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	txa
	sub	#nsd::TR_SE_N163
.ifndef	SE_N163
	shr	a, 1
.endif
	tay
	lda	__ptr
	ora	__n163_frequency,y
	sta	N163_Data
	rts
.else
	sty	N163_Resister
	lda	__tmp
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	lda	__tmp + 1
	sta	N163_Data

	iny
	iny
	sty	N163_Resister
	lda	__ptr
	ora	__n163_frequency-nsd::TR_SE_N163,x
	sta	N163_Data
	rts
.endif
.endproc


.endif

;---------------------------------------
.ifdef	PSG
.proc	_nsd_psg_ch1_frequency
	jsr	Normal12_frequency
	ldy	#PSG_1_Frequency_Low
	beq	_nsd_psg_frequency	;これは、0
.endproc

.proc	_nsd_psg_ch2_frequency
	jsr	Normal12_frequency
	ldy	#PSG_2_Frequency_Low
	bne	_nsd_psg_frequency
.endproc

.proc	_nsd_psg_ch3_frequency
	jsr	Normal12_frequency
	ldy	#PSG_3_Frequency_Low
;	bne	_nsd_psg_frequency
.endproc

.proc	_nsd_psg_frequency
	sty	PSG_Register
	lda	__tmp
	sta	PSG_Data
	iny
	sty	PSG_Register
	lda	__tmp + 1
	sta	PSG_Data
Exit:
	rts
.endproc

.endif


;=======================================================================
;	void	__fastcall__	Normal_frequency(int freq);
;-----------------------------------------------------------------------
;<<Input>>
;	ax	frequency (Range : 0x008E - 0x07FF )	(16 = 100 cent)
;<<Output>>
;	__tmp + 1	frequency upper 3bit
;	__tmp		frequency lower 8bit	(total = 11bit)
;=======================================================================
.proc	Normal_frequency

	jsr	_nsd_div192		; 
;	and	#$FE			; x =  ax  /  192
	lsr	a
	bcc	@L
	ora	#$80
@L:	asl	a
	tay				; y = (ax mod 192) & 0xFE

	;-------------------------------
	; *** Get frequency from table
	; nsd_work_zp._tmp <- frequency
	lda	Freq + 1,y
	sta	__tmp + 1
	lda	Freq,y

	bcc	Octave_Proc

	;線形補完（次の音程を足して２で割る）
	add	Freq + 2,y
	sta	__tmp
	lda	__tmp + 1
	adc	Freq + 3,y
	lsr	a
	sta	__tmp + 1
	lda	__tmp
	ror	a

	;-------------------------------
	; *** Octave caluclate  and  overflow check
Octave_Proc:
	;if (octave == 0) {
	cpx	#0
	bne	Octave_Loop
	sta	__tmp
	lda	__tmp + 1
	cmp	#$08				;if (frequency >= 0x0800) {
	bcc	Detune
@Over:	lda	#$07
	sta	__tmp + 1
	lda	#$FF				;	frequency = 0x07FF
	jmp	Octave_Exit			; } else {
	; } } else { while (octave > 0) {
Octave_Loop:
	lsr	__tmp + 1	; frequency >>= 1
	ror	a
	dex			; octave--;
	bne	Octave_Loop
	; } }
DEC_Freq:
	sub	#1
	bcs	Octave_Exit
	dec	__tmp + 1	; frequency -= 1
Octave_Exit:
	sta	__tmp

Detune:	
	ldx	__channel
	ldy	#$00
	lda	__detune_fine,x
	bpl	@L
	dey				; ay = __detune_fine (sign expand)
@L:	add	__tmp
	sta	__tmp
	tya
	adc	__tmp + 1
	sta	__tmp + 1		;__tmp += (signed int)__detune_cent

	;-------------------------------
	; *** Exit
Exit:
	rts
.endproc



.if	.defined(VRC6) || .defined(PSG)
;=======================================================================
;	void	__fastcall__	Normal12_frequency(int freq);
;-----------------------------------------------------------------------
;<<Input>>
;	ax	frequency (Range : 0x0000 - 0x07FF )	(16 = 100 cent)
;<<Output>>
;	__tmp + 1	frequency upper 4bit
;	__tmp		frequency lower 8bit	(total = 12bit)
;=======================================================================
.proc	Normal12_frequency

	jsr	_nsd_div192		; 
;	and	#$FE			; x =  ax  /  192
	lsr	a
	bcc	@L
	ora	#$80
@L:	asl	a
	tay				; y = (ax mod 192) & 0xFE

	;-------------------------------
	; *** Get frequency from table
	; nsd_work_zp._tmp <- frequency
	lda	Freq + 1,y
	sta	__tmp + 1
	lda	Freq,y

	bcc	Octave_Proc

	;線形補完（次の音程を足して２で割る）
	add	Freq + 2,y
	sta	__tmp
	lda	__tmp + 1
	adc	Freq + 3,y
	lsr	a
	sta	__tmp + 1
	lda	__tmp
	ror	a

	;-------------------------------
	; *** Octave caluclate  and  overflow check
Octave_Proc:
	;if (octave == 0) {
	cpx	#0
	beq	DEC_Freq
Octave_Loop:
	lsr	__tmp + 1	; frequency >>= 1
	ror	a
	dex			; octave--;
	bne	Octave_Loop
	; } }
DEC_Freq:
	sub	#1
	bcs	Octave_Exit
	dec	__tmp + 1	; frequency -= 1
Octave_Exit:
	sta	__tmp

Detune:	
	ldx	__channel
	ldy	#$00
	lda	__detune_fine,x
	bpl	@L
	dey				; ay = __detune_fine (sign expand)
@L:	add	__tmp
	sta	__tmp
	tya
	adc	__tmp + 1
	sta	__tmp + 1		;__tmp += (signed int)__detune_cent

	;-------------------------------
	; *** Exit
Exit:
	rts
.endproc
.endif



.ifdef	N163
;=======================================================================
;	void	__fastcall__	N163_frequency(int freq);
;-----------------------------------------------------------------------
;<<Input>>
;	ax	frequency (Range : 0x008E - 0x07FF )	(16 = 100 cent)
;<<Output>>
;	__ptr		frequency HSB 8bit
;	__tmp + 1	frequency MSB 8bit
;	__tmp		frequency LSB 8bit
;=======================================================================
.proc	N163_frequency

	jsr	_nsd_div192		; 
	cmp	#(Freq_N163_Carry_00 - Freq_N163)/2
	bcc	@Lcarry00
	cmp	#(Freq_N163_Carry_01 - Freq_N163)/2
	bcc	@Lcarry01
	ldy	#4
	bne	@L
@Lcarry01:
	ldy	#3
@L:	sty	__ptr		;frequency HSB
	sub	#(Freq_N163_Carry_00 - Freq_N163)/2
	shl	a, 1
	tay
	lda	Freq_N163_Carry_00 + 1,y
	sta	__tmp + 1	;frequency MSB
	lda	Freq_N163_Carry_00,y	;frequency LSB
	jmp	@L2

@Lcarry00:
	ldy	#2
	sty	__ptr		;frequency HSB
	shl	a, 1
	tay
	lda	Freq_N163 + 1,y
	sta	__tmp + 1	;frequency MSB
	lda	Freq_N163,y	;frequency LSB
@L2:

	;-------------------------------
	; *** Octave caluclate  and  overflow check
Octave_Proc:
	;if (octave == 0) {
	cpx	#$08
	bcc	Octave_Loop
	bne	@Over
	sta	__tmp
	lda	__ptr
	cmp	#4		;if (frequency >= 0x040000) {
	bcc	Detune
@Over:	lda	#$3
	sta	__ptr
	lda	#$FF
	sta	__tmp + 1	;	frequency = 0x03FFFF;1
	bne	Octave_Exit	;
Octave_Loop:
	lsr	__ptr		;高速化のため、
	ror	__tmp + 1	;ゼロページとaレジスターで
	ror	a		;シフト演算する。
	inx
	cpx	#$08
	bne	Octave_Loop
Octave_Exit:
	sta	__tmp

Detune:	
	ldy	#$00
	ldx	__channel
	lda	__detune_fine,x
	bpl	@L
	dey			; ay = __detune_fine (sign expand)
@L:	sty	__ptr + 1
	add	__tmp
	sta	__tmp
	tya
	adc	__tmp + 1
	sta	__tmp + 1
	lda	__ptr + 1
	adc	__ptr
	sta	__ptr

	;-------------------------------
	; *** Exit
Exit:
	rts
.endproc
.endif

.if	.defined(VRC7) || .defined(OPLL)
.proc	_Wait42
				;[6]

	pha			;[4]
	pla			;[4]
	pha			;[4]
	pla			;[4]
	pha			;[4]
	pla			;[4]	24

	rts			;[6]	14+24	=38

.endproc
.endif
