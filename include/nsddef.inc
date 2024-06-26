;=======================================================================
;
;	NES Sound Driver & library (NSD.lib)	Define file
;
;-----------------------------------------------------------------------
;
;	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
;	For conditions of distribution and use, see copyright notice
;	  in "nsd.h" or "nsd.inc".
;
;=======================================================================

.ifdef	ALL_ADDING_MOD
	DIET_ZP			= 0
	FO_MOD			= 0
	ENV_NOTE_ABS		= 0
	VOLUME_TABLE_MOD	= 0
;	MMC3_BANK		= 1
	AUTO_GROOVE		= 0
	ENVELOPE_MODE		= 0
	.ifdef FDS
		FDS_SYNC		= 0
	.endif
	DPCM_PITCH		= 0
;	Sequence_ptr_bss = 1
.endif
.if	.defined(MMC3_BANK) .or .defined(VRC6_BANK) .or .defined(N163_BANK)
	BANK_SWITCH = 0
.endif

;	PRIORITY_EXTEND		= 0
;	TRACK_PRIORITY		= 0
;	SE_NO_POR		= 0
;	SE_STOP_NUM		= 0

;****************************************************************
;*	NTSC / PAL						*
;****************************************************************

.ifndef PAL
Tempo_Sub		= 150
.else
Tempo_Sub		= 125
.endif

Tempo_Cmp		= 256 - Tempo_Sub

;****************************************************************
;*	Sound I/O Device address defines			*
;****************************************************************

;---------------------------------------
;FDS define

FDS_Control		= $4023
FDS_Wave_Table		= $4040		; to $407F
FDS_Volume		= $4080
FDS_FTUNE		= $4082
FDS_CTUNE		= $4083
FDS_Sweep_Envelope	= $4084
FDS_Sweep_Bias		= $4085
FDS_Mod_FTUNE		= $4086
FDS_Mod_CTUNE		= $4087
FDS_Mod_Append		= $4088
FDS_Write_Enable	= $4089
FDS_Envelope_Speed	= $408A
FDS_Volume_Gain		= $4090		;$4080's value
FDS_Sweep_Gain		= $4092		;$4084's value

;---------------------------------------
;VRC6 define

VRC6_Frequency		= $9003		;.... .ABH	Normally you should write $00 to this register on startup to initialize it.
VRC6_Pulse1_CTRL	= $9000		;MDDD vvvv	mode DT vol
VRC6_Pulse1_FTUNE	= $9001		;FFFF FFFF
VRC6_Pulse1_CTUNE	= $9002		;E... FFFF
VRC6_Pulse2_CTRL	= $A000
VRC6_Pulse2_FTUNE	= $A001
VRC6_Pulse2_CTUNE	= $A002
VRC6_SAW_CTRL		= $B000		;..AA AAAA	volume
VRC6_SAW_FTUNE		= $B001		;FFFF FFFF
VRC6_SAW_CTUNE		= $B002		;E... FFFF

;---------------------------------------
;VRC7 define

VRC7_Resister		= $9010		;wait  6 clk
VRC7_Data		= $9030		;wait 42 clk

VRC7_Patch0		= $00
VRC7_Patch1		= $01
VRC7_Patch2		= $02
VRC7_Patch3		= $03
VRC7_Patch4		= $04
VRC7_Patch5		= $05
VRC7_Patch6		= $06
VRC7_Patch7		= $07

VRC7_Frequency		= $10
VRC7_Octave		= $20
VRC7_Volume		= $30

;---------------------------------------
;OPLL define

.ifdef	HFX4
OPLL_Resister		= $5F90		;wait  6 clk
OPLL_Data		= $5FB0		;wait 42 clk
.else
OPLL_Resister		= $9010		;wait  6 clk
OPLL_Data		= $9030		;wait 42 clk
.endif

OPLL_Patch0		= $00
OPLL_Patch1		= $01
OPLL_Patch2		= $02
OPLL_Patch3		= $03
OPLL_Patch4		= $04
OPLL_Patch5		= $05
OPLL_Patch6		= $06
OPLL_Patch7		= $07

OPLL_RHYTHM		= $0E
OPLL_Frequency		= $10
OPLL_Octave		= $20
OPLL_Volume		= $30

OPLL_Frequency_BD	= $16
OPLL_Frequency_HH_SD	= $17
OPLL_Frequency_TOM_CYM	= $18

OPLL_Octave_BD		= $26
OPLL_Octave_HH_SD	= $27
OPLL_Octave_TOM_CYM	= $28

OPLL_BD			= $36
OPLL_HH_SD		= $37
OPLL_TOM_CYM		= $38


;---------------------------------------
;MMC5 define

MMC5_Pulse1_CTRL	= $5000         ; Pulse_ #1 Control Register (W)
MMC5_Pulse1_FTUNE	= $5002         ; Pulse_ #1 Fine Tune (FT) Register (W)
MMC5_Pulse1_CTUNE	= $5003         ; Pulse_ #1 Coarse Tune (CT) Register (W)
MMC5_Pulse2_CTRL	= $5004         ; Pulse_ #2 Control Register (W)
MMC5_Pulse2_FTUNE	= $5006         ; Pulse_ #2 Fine Tune Register (W)
MMC5_Pulse2_CTUNE	= $5007         ; Pulse_ #2 Coarse Tune Register (W)
MMC5_CHANCTRL		= $5015         ;

;---------------------------------------
;N163 define

N163_Resister		= $F800
N163_Data		= $4800

N163_Frequency_Low	= $78
N163_Frequency_Middle	= $7A
N163_Frequency_High	= $7C
N163_Waveform		= $7E
N163_Volume		= $7F

;---------------------------------------
;PSG define

.ifdef	HFE4
PSG_Register		= $5FE0
PSG_Data		= $5FE1
.else
PSG_Register		= $C000
PSG_Data		= $E000
.endif

PSG_1_Frequency_Low	= $00
PSG_1_Frequency_High	= $01
PSG_2_Frequency_Low	= $02
PSG_2_Frequency_High	= $03
PSG_3_Frequency_Low	= $04
PSG_3_Frequency_High	= $05
PSG_Noise_Frequency	= $06
PSG_Switch		= $07	;00ABCabc
PSG_1_Volume		= $08
PSG_2_Volume		= $09
PSG_3_Volume		= $0A
PSG_Envelope_Low	= $0B
PSG_Envelope_High	= $0C
PSG_Envelope_Form	= $0D





;****************************************************************
;*	NSD.lib General Define					*
;****************************************************************

.scope	nsd
	APU_Track	= 5			;

	TR_FDS		= APU_Track * 2
	.ifdef	FDS
		FDS_Track	= 1		;
	.else
		FDS_Track	= 0		;
	.endif

	TR_VRC6		= TR_FDS + FDS_Track * 2
	.ifdef	VRC6
		VRC6_Track	= 3		;
	.else
		VRC6_Track	= 0		;
	.endif

	TR_VRC7		= TR_VRC6 + VRC6_Track * 2
	.ifdef	VRC7
		VRC7_Track	= 6		;
	.else
		VRC7_Track	= 0		;
	.endif

	TR_OPLL		= TR_VRC7 + VRC7_Track * 2
	.ifdef	OPLL
		OPLL_Track_FM		= 9
		OPLL_Track_Rhythm	= 5
		OPLL_Track	= OPLL_Track_FM + OPLL_Track_Rhythm
	.else
		OPLL_Track	= 0		;
	.endif

	TR_MMC5		= TR_OPLL + OPLL_Track * 2
	.ifdef	MMC5
		MMC5_Track	= 2		; (without DPCM)
	.else
		MMC5_Track	= 0		;
	.endif

	TR_N163		= TR_MMC5 + MMC5_Track * 2
	.ifdef	N163
		.if	::N163 = 0
			N163	= 8
		.endif
		N163_Track	= ::N163		;
;		.out .sprintf("N163=%d",::N163)
	.else
		N163_Track	= 0		;
	.endif

	TR_PSG		= TR_N163 + N163_Track * 2
	.ifdef	PSG
		PSG_Track	= 3		;
	.else
		PSG_Track	= 0		;
	.endif

	TR_NULL		= TR_PSG + PSG_Track * 2
	.ifdef	NULL
		NULL_Track	= 1		;
	.else
		NULL_Track	= 0		;
	.endif

	BGM_Track	= APU_Track + FDS_Track + VRC6_Track + VRC7_Track + OPLL_Track + MMC5_Track + N163_Track + PSG_Track + NULL_Track
	.ifdef	SE
		SE_Track	.set 5		;
	.else
		SE_Track	.set 2		;
	.endif

	.ifdef	SE_N163
		SE_APU_Track	= SE_Track
		SE_Track	.set(SE_Track + ::SE_N163)
		SE_N163_Track	= ::SE_N163
	.else
		SE_N163_Track	= 0
	.endif

	Track		= BGM_Track + SE_Track

	TR_BGM1		= 0
	TR_BGM2		= 2
	TR_BGM3		= 4
	TR_BGM4		= 6
	TR_BGM5		= 8
	TR_SE		= BGM_Track * 2
	.ifdef	SE
	TR_SE_Pluse1	= TR_SE + 0
	TR_SE_Pluse2	= TR_SE + 2
	TR_SE_Tri	= TR_SE + 4
	TR_SE_Noise	= TR_SE + 6
	TR_SE_Dpcm	= TR_SE + 8
	TR_SE_N163	= TR_SE_Dpcm +2
	.else
	TR_SE_Pluse2	= TR_SE + 0
	TR_SE_Noise	= TR_SE + 2
	TR_SE_N163	= TR_SE_Noise + 2
	.endif

.endscope





;****************************************************************
;*	Struct Define						*
;****************************************************************

;=======================================================================
;	Working Struct define in Zero-page area
;-----------------------------------------------------------------------

.Struct		NSD_Envelop
	V		.byte		;Volume & Voice (ch3:Tempo / ch5:Tempo_ctr)
	F		.byte		;Frequency & Note
.Endstruct

.Struct		NSD_Length_Cnt
	counter		.byte		;now length of note
	gate		.byte		;length - u
.Endstruct

.Struct		NSD_work_zp
	_ptr		.word					;00 General pointer value
	_tmp		.word					;02 General value
	channel		.byte					;04 channel (x resister)
	flag		.byte					;05 flag
.ifndef	Sequence_ptr_bss
	Sequence_ptr	.word			nsd::Track	;06 Address of playing sequence
.endif
.if	.defined(HFX4) .or .defined(DIET_ZP)
.else
	LengthCnt	.tag	NSD_Length_Cnt	nsd::Track	;16 Length Counter
.endif
.ifndef	DIET_ZP
	Envelop		.tag	NSD_Envelop	nsd::Track	;26 Envelop counter
.ifdef DPCM_PITCH
	Tempo		.byte
	TempoCtr	.byte
.endif
.endif

.Endstruct

; 6 + ( 6 [Byte] * 28 [ch] ) = 174

;---------------------------------------
;	Defines for work structures

.scope	nsd_flag
	BGM		= $01	;Playing BGM
	SE		= $02	;Playing SE
	Jump		= $10	;
.ifndef PRIORITY_EXTEND
	Priority	= $0C	;Priority of now SE
.endif
	Disable		= $80	;Disable of sound driver
.ifdef	FO_MOD
	Fade		= $40
.endif

.endscope

.ifdef	ENVELOPE_MODE
.scope	env_flag
	volume		= $04
	note		= $02
	freq		= $01
	voice		= $08
.endscope
.endif

;Zero Page Works
		__ptr	=		nsd_work_zp + NSD_work_zp::_ptr
		__tmp	=		nsd_work_zp + NSD_work_zp::_tmp
		__flag	=		nsd_work_zp + NSD_work_zp::flag
		__channel	=	nsd_work_zp + NSD_work_zp::channel
.ifndef	Sequence_ptr_bss
		__Sequence_ptr	=	nsd_work_zp + NSD_work_zp::Sequence_ptr
.endif
.ifndef	DIET_ZP
		__Envelop_V	=	nsd_work_zp + NSD_work_zp::Envelop + NSD_Envelop::V	;upper 4bit Voice / lower 4bit:Volume
		__Envelop_F	=	nsd_work_zp + NSD_work_zp::Envelop + NSD_Envelop::F	;upper 4bit:Note  / lower 4bit:Frequency
;		__flag	=		nsd_work_zp + NSD_work_zp::Envelop + NSD_Envelop::V + nsd::TR_BGM3
.ifdef DPCM_PITCH
		__Tempo	=		nsd_work_zp + NSD_work_zp::Tempo
		__Tempo_ctr	=	nsd_work_zp + NSD_work_zp::TempoCtr
.else
		__Tempo	=		nsd_work_zp + NSD_work_zp::Envelop + NSD_Envelop::F + nsd::TR_BGM5
		__Tempo_ctr	=	nsd_work_zp + NSD_work_zp::Envelop + NSD_Envelop::V + nsd::TR_BGM5
.endif
.endif





;=======================================================================
;	Working  Struct define in RAM area
;-----------------------------------------------------------------------

.Struct		NSD_Flag
	flag		.byte		;flag
	gatemode	.byte		;gate mode
.Endstruct

.Struct		NSD_length
	length		.byte		;`l' command value
	tai		.byte		;flag of Tai & Slur
.Endstruct

.Struct		NSD_gatetime
	q		.byte		;`q' command value
	u		.byte		;`u' command value
.Endstruct

.Struct		NSD_note
	note		.byte		;`note' command value (bit 7 = `H' : rest)
	octave		.byte		;`o' command value
.Endstruct

.Struct		NSD_Detune
	cent		.byte		;`D' command value
	fine		.byte		;`D%' command value
.Endstruct

.Struct		NSD_Por_Lv		;(ch5 : BGM1 & BGM2 Frequency)
	target		.byte		;`P' target
	depth		.byte		;`P' add value
.Endstruct

.Struct		NSD_Por_Co		;(ch5 : BGM3 & SE  Frequency)
	count		.byte		;rate control
	rate		.byte		;now depth
.Endstruct

.Struct		NSD_Trans
	trans		.byte		;`_' command value
	onetime		.byte		;`'', `"' command value
.Endstruct

.Struct		NSD_Repeat
	count1		.byte		;counter of repeat(A)
	count2		.byte		;counter of repeat(B)
.Endstruct

.Struct		NSD_volume
	volume		.byte		;`v' & `vR' command value
	volume_env	.byte		;now envelop volume	(ch3,5 : sweep value of ch1,2)
.Endstruct

;.Struct		NSD_voice
;	voice		.byte		;`@R' command value (upper 4bit)	;※廃止
;	voice_set	.byte		;deveice setting value
;.Endstruct

.Struct		NSD_Env_V_Ptr		;(ch5 : pointer of �儕CM information)
	Volume		.byte		;Volume
	Voice		.byte		;Voice
.Endstruct

.Struct		NSD_Env_F_Ptr
	Frequency	.byte		;Freeuqncy
	Note		.byte		;Note
.Endstruct

.Struct		NSD_Env_F_Now
	Frequency	.byte		;now envelop Freeuqncy
	Note		.byte		;now envelop Note
.Endstruct

.if	.defined(ENVELOPE_MODE) .or .defined(TRACK_PRIORITY)
	.Struct		NSD_Env_Flag
		Env_flag	.byte		;
		Priority	.byte		;
	.Endstruct
.endif

.ifdef	SE_N163
	.Struct		NSD_N163_Freq
		Freq	.byte		;
		Voice	.byte		;
	.Endstruct
.endif


.Struct		NSD_work
.ifdef PRIORITY_EXTEND
	Priority_Value	.byte
.endif
.ifdef	SEND_SIGNAL
	Signal		.byte
.endif
.ifdef	FO_MOD
	Fo_Value	.word
	Fo_Add		.byte
.endif
.ifdef	AUTO_GROOVE
	GRV_Value	.byte
	GRV_Length	.byte
	GRV_Counter	.byte
.endif
.ifdef	FDS_SYNC
	ModWavPtr	.word
.endif
	Flag		.tag	NSD_Flag	nsd::Track	;flag
.if	.defined(HFX4) .or .defined(DIET_ZP)
	LengthCnt	.tag	NSD_Length_Cnt	nsd::Track	;16 Length Counter
.endif
.ifdef	Sequence_ptr_bss
	Sequence_ptr	.word			nsd::Track	;06 Address of playing sequence
.endif
.ifdef	DIET_ZP
	Envelop		.tag	NSD_Envelop	nsd::Track	;26 Envelop counter
.ifdef DPCM_PITCH
	Tempo		.byte
	TempoCtr	.byte
.endif
.endif
.ifdef DPCM_PITCH
	VoiceSet	.byte			8
	ApuFreq		.byte			6
.endif
	Length		.tag	NSD_length	nsd::Track	;note length [tick]
	Gatetime	.tag	NSD_gatetime	nsd::Track	;gate time [tick]
	Note		.tag	NSD_note	nsd::Track	;octave and note command
	Detune		.tag	NSD_Detune	nsd::Track	;detune
.ifdef	SE_NO_POR
	Por_Lv		.tag	NSD_Por_Lv	nsd::BGM_Track	;Portamento / TR5: BGM1 & BGM2 frequency
	Por_Co		.tag	NSD_Por_Co	nsd::BGM_Track	;Portamento / TR5: BGM3 & SE1  frequency
	Por_now		.word			nsd::BGM_Track	;Portamento / TR5: SE2  & SE3  frequency
.else
	Por_Lv		.tag	NSD_Por_Lv	nsd::Track	;Portamento / TR5: BGM1 & BGM2 frequency
	Por_Co		.tag	NSD_Por_Co	nsd::Track	;Portamento / TR5: BGM3 & SE1  frequency
	Por_now		.word			nsd::Track	;Portamento / TR5: SE2  & SE3  frequency
.endif
	Trans		.tag	NSD_Trans	nsd::Track	;Transpose
	Repeat		.tag	NSD_Repeat	nsd::Track	;Repeat
	Volume		.tag	NSD_volume	nsd::Track	;volume	/ TR3: BGM1 sweep / TR5: BGM2 sweep
.ifdef	SE_NO_ENV
	Env_F_Now	.tag	NSD_Env_F_Now	nsd::BGM_Track	;Now value of envelop
	Env_V_Ptr	.tag	NSD_Env_V_Ptr	nsd::BGM_Track	;Address of envelop / TR5:DPCM info
	Env_F_Ptr	.tag	NSD_Env_F_Ptr	nsd::BGM_Track	;Address of envelop
.if	.defined(ENVELOPE_MODE) .or .defined(TRACK_PRIORITY)
	Env_Flag	.tag	NSD_Env_Flag	nsd::BGM_Track
.endif
	Envelop_Volume	.word			nsd::BGM_Track	;Pointer of envelop
	Envelop_Voice	.word			nsd::BGM_Track	;Pointer of envelop
	Envelop_Freq	.word			nsd::BGM_Track	;Pointer of envelop
	Envelop_Note	.word			nsd::BGM_Track	;Pointer of envelop

.else
	Env_F_Now	.tag	NSD_Env_F_Now	nsd::Track	;Now value of envelop
	Env_V_Ptr	.tag	NSD_Env_V_Ptr	nsd::Track	;Address of envelop / TR5:DPCM info
	Env_F_Ptr	.tag	NSD_Env_F_Ptr	nsd::Track	;Address of envelop
.if	.defined(ENVELOPE_MODE) .or .defined(TRACK_PRIORITY)
	Env_Flag	.tag	NSD_Env_Flag	nsd::Track
.endif
	Envelop_Volume	.word			nsd::Track	;Pointer of envelop
	Envelop_Voice	.word			nsd::Track	;Pointer of envelop
	Envelop_Freq	.word			nsd::Track	;Pointer of envelop
	Envelop_Note	.word			nsd::Track	;Pointer of envelop
.endif
	Frequency	.word			nsd::Track	;Setting frequency
	SubRoutine	.word			nsd::Track	;Pointer of sub-routine return address
	Repeat2		.word			nsd::Track	;Pointer of repeat2 goto point
.ifdef	ENV_NOTE_ABS
;	Envelop_Mode	.byte			nsd::Track
;	Abs_Note	.word			nsd::Track
.endif

;.ifdef	MMC5
;	MMC5_Frequency	.byte			nsd::MMC5_Track	;MMC5 frequency
;.endif

.ifdef	FDS
	FDS_Frequency	.byte					;FDS frequency
	FDS_SweepBias	.byte					;FDS Sweep bias
.endif

.ifdef	MMC5
	MMC5_VoiceSet	.byte			nsd::MMC5_Track
	MMC5_Frequency	.byte			nsd::MMC5_Track	;MMC5 frequecny
.endif

.ifdef DPCM_PITCH
.ifdef	VRC6
	VRC6_VoiceSet	.byte			nsd::VRC6_Track-1
.endif
.endif

.ifdef	VRC7
	VRC7_VoiceSet	.byte			nsd::VRC7_Track
	VRC7_Freq_old	.byte			nsd::VRC7_Track
	VRC7_Frequency	.word			nsd::VRC7_Track	;VRC7 frequecny
	VRC7_Reg	.word					;
.endif

.ifdef	OPLL
	OPLL_VoiceSet	.byte			nsd::OPLL_Track_FM
	OPLL_Freq_old	.byte			nsd::OPLL_Track_FM
	OPLL_Frequency	.word			nsd::OPLL_Track_FM	;OPLL frequency (FM)
	OPLL_Reg	.word		
	OPLL_Rhythm	.byte						;OPLL Rhythm
.endif

.ifdef	N163
	N163_num	.byte					;N163 ch number
	.ifdef	SE_N163
		N163_Frequency	.tag	NSD_N163_Freq	nsd::N163_Track	;N163 frequency
;		N163_Voice	.byte			nsd::N163_Track
	.else
		N163_Frequency	.byte			nsd::N163_Track		;N163 frequency
	.endif
.endif

.ifdef	PSG
	PSG_switch	.byte					;PSG switch
.endif

.ifdef	SE_STOP_NUM
	SE_Stop_num	.byte
	Req_num		.byte			nsd::SE_Track
.endif

.Endstruct



;---------------------------------------
;	Defines for work structures

.scope	nsd_chflag
.ifdef	MASK
	Mask	= $80
.endif
	Sustain	= $20		;for VRC7
.ifdef	FDS_SYNC
	FdsSync	= $10		;for FDS
.endif
	KeyOn	= $10		;for VRC7
	Envelop	= $10		;for PSG
	FDSVOL	= $0C
	NoKeyOff= $04		;for VRC7
	KeyOff	= $03		;00	Key Off	: Vol = 0
				;01	Key Off	: Release command
				;10	Key Off	:  envelop
				;11	Note On	: (envelop)
.ifdef	ENV_NOTE_ABS
	EnvelopNoteAbs = $40
.endif
.endscope

.scope	nsd_mode
	voiceR		= $F0	;1111 0000	Release Volume
	voice		= $08	;0000 1000	
	RetSE		= $04	;0000 0100	Key On (Ch.3)
	gatemode	= $03	;0000 0011	Gate mode
.endscope


;RAM Works
.ifdef	PRIORITY_EXTEND
		__priority_value	=	nsd_work + NSD_work::Priority_Value
.endif
.ifdef	SEND_SIGNAL
		__signal		=	nsd_work + NSD_work::Signal
.endif
.ifdef	FO_MOD
		__fo_value		=	nsd_work + NSD_work::Fo_Value
		__fo_add		=	nsd_work + NSD_work::Fo_Add
.endif
.ifdef	AUTO_GROOVE
		__grv_value		=	nsd_work + NSD_work::GRV_Value
		__grv_length		=	nsd_work + NSD_work::GRV_Length
		__grv_ctr		=	nsd_work + NSD_work::GRV_Counter
.endif

.ifdef	FDS_SYNC
		__mod_wav_ptr		=	nsd_work + NSD_work::ModWavPtr
.endif

.if	.defined(HFX4) .or .defined(DIET_ZP)
		__Length_ctr		=	nsd_work + NSD_work::LengthCnt + NSD_Length_Cnt::counter
		__Gate			=	nsd_work + NSD_work::LengthCnt + NSD_Length_Cnt::gate
.else
		__Length_ctr		=	nsd_work_zp + NSD_work_zp::LengthCnt + NSD_Length_Cnt::counter
		__Gate			=	nsd_work_zp + NSD_work_zp::LengthCnt + NSD_Length_Cnt::gate
.endif
.ifdef Sequence_ptr_bss
		__Sequence_ptr		=	nsd_work + NSD_work::Sequence_ptr
.endif
.ifdef DIET_ZP
		__Envelop_V		=	nsd_work + NSD_work::Envelop + NSD_Envelop::V	;upper 4bit Voice / lower 4bit:Volume
		__Envelop_F		=	nsd_work + NSD_work::Envelop + NSD_Envelop::F	;upper 4bit:Note  / lower 4bit:Frequency
;		__flag			=	nsd_work_zp + NSD_work_zp::Envelop + NSD_Envelop::V + nsd::TR_BGM3
.ifdef DPCM_PITCH
		__Tempo			=	nsd_work + NSD_work::Tempo
		__Tempo_ctr		=	nsd_work + NSD_work::TempoCtr
.else
		__Tempo			=	nsd_work + NSD_work::Envelop + NSD_Envelop::F + nsd::TR_BGM5
		__Tempo_ctr		=	nsd_work + NSD_work::Envelop + NSD_Envelop::V + nsd::TR_BGM5
.endif
.endif
		__chflag		=	nsd_work + NSD_work::Flag + NSD_Flag::flag
		__gatemode		=	nsd_work + NSD_work::Flag + NSD_Flag::gatemode
		__tai	=			nsd_work + NSD_work::Length + NSD_length::tai
		__length		=	nsd_work + NSD_work::Length + NSD_length::length
		__gate_q		=	nsd_work + NSD_work::Gatetime + NSD_gatetime::q
		__gate_u		=	nsd_work + NSD_work::Gatetime + NSD_gatetime::u
		__note			=	nsd_work + NSD_work::Note + NSD_note::note
		__octave		=	nsd_work + NSD_work::Note + NSD_note::octave
		__detune_cent		=	nsd_work + NSD_work::Detune + NSD_Detune::cent
		__detune_fine		=	nsd_work + NSD_work::Detune + NSD_Detune::fine
		__por_target		=	nsd_work + NSD_work::Por_Lv + NSD_Por_Lv::target
		__por_depth		=	nsd_work + NSD_work::Por_Lv + NSD_Por_Lv::depth
		__por_ctr		=	nsd_work + NSD_work::Por_Co + NSD_Por_Co::count
		__por_rate		=	nsd_work + NSD_work::Por_Co + NSD_Por_Co::rate
		__por_now		=	nsd_work + NSD_work::Por_now
		__trans			=	nsd_work + NSD_work::Trans + NSD_Trans::trans
		__trans_one		=	nsd_work + NSD_work::Trans + NSD_Trans::onetime
		__repeat_ctr		=	nsd_work + NSD_work::Repeat + NSD_Repeat::count1
		__repeat_ctr2		=	nsd_work + NSD_work::Repeat + NSD_Repeat::count2
		__volume		=	nsd_work + NSD_work::Volume + NSD_volume::volume
		__frequency		=	nsd_work + NSD_work::Frequency
		__subroutine		=	nsd_work + NSD_work::SubRoutine
		__repeat2		=	nsd_work + NSD_work::Repeat2
		__env_volume		=	nsd_work + NSD_work::Envelop_Volume
		__env_voice		=	nsd_work + NSD_work::Envelop_Voice
		__env_frequency		=	nsd_work + NSD_work::Envelop_Freq
		__env_note		=	nsd_work + NSD_work::Envelop_Note
		__env_vol_ptr		=	nsd_work + NSD_work::Env_V_Ptr + NSD_Env_V_Ptr::Volume
		__env_voi_ptr		=	nsd_work + NSD_work::Env_V_Ptr + NSD_Env_V_Ptr::Voice
		__env_freq_ptr		=	nsd_work + NSD_work::Env_F_Ptr + NSD_Env_F_Ptr::Frequency
		__env_note_ptr		=	nsd_work + NSD_work::Env_F_Ptr + NSD_Env_F_Ptr::Note
;	voiceに関しては、その後の演算は無いので、更新されない場合はエンベロープ処理を終了する。
		__env_vol_now		=	nsd_work + NSD_work::Volume + NSD_volume::volume_env
		__env_freq_now		=	nsd_work + NSD_work::Env_F_Now + NSD_Env_F_Now::Frequency
		__env_note_now		=	nsd_work + NSD_work::Env_F_Now + NSD_Env_F_Now::Note
.ifdef ENV_NOTE_ABS
;		__env_mode		=	nsd_work + NSD_work::Envelop_Mode
;		__abs_note		=	nsd_work + NSD_work::Abs_Note
.endif
.if	.defined(ENVELOPE_MODE) .or .defined(TRACK_PRIORITY)
		__env_flag		=	nsd_work + NSD_work::Env_Flag + NSD_Env_Flag::Env_flag
		__priority		=	nsd_work + NSD_work::Env_Flag + NSD_Env_Flag::Priority
.endif
;---------------
;�儕CM
		__dpcm_info		=	nsd_work + NSD_work::Env_V_Ptr + nsd::TR_BGM5		;.word
.ifdef DPCM_PITCH
		__dpcm_freq		=	nsd_work + NSD_work::Envelop_Volume + nsd::TR_BGM5
.endif
;Sweep
		__sweep_ch1		=	nsd_work + NSD_work::Envelop_Voice  + nsd::TR_BGM3
		__sweep_ch2		=	nsd_work + NSD_work::Envelop_Voice  + nsd::TR_BGM3 + 1
;		__sweep_ch1	=		nsd_work + NSD_work::Volume + NSD_volume::volume     + nsd::TR_BGM5
;		__sweep_ch2	=		nsd_work + NSD_work::Volume + NSD_volume::volume_env + nsd::TR_BGM5


;Voice
;		__apu_tri_time	=		nsd_work + NSD_work::Envelop_Voice  + nsd::TR_BGM5
;		__apu_voice_set4	=	nsd_work + NSD_work::Envelop_Voice  + nsd::TR_BGM5 + 1
;		__se_voice_set1	=		nsd_work + NSD_work::Env_F_Ptr + NSD_Env_F_Ptr::Frequency  + nsd::TR_BGM5
;		__se_voice_set2	=		nsd_work + NSD_work::Env_F_Ptr + NSD_Env_F_Ptr::Note       + nsd::TR_BGM5
.ifdef DPCM_PITCH
		__apu_voice_set1	=	nsd_work + NSD_work::VoiceSet + 0
		__apu_voice_set2	=	nsd_work + NSD_work::VoiceSet + 1
		__apu_tri_time		=	nsd_work + NSD_work::VoiceSet + 2
		__apu_voice_set4	=	nsd_work + NSD_work::VoiceSet + 3
.else
		__apu_voice_set1	=	nsd_work + NSD_work::Envelop_Volume + nsd::TR_BGM5
		__apu_voice_set2	=	nsd_work + NSD_work::Envelop_Volume + nsd::TR_BGM5 + 1
		__apu_tri_time		=	nsd_work + NSD_work::Envelop_Freq   + nsd::TR_BGM5
		__apu_voice_set4	=	nsd_work + NSD_work::Envelop_Freq   + nsd::TR_BGM5 + 1
.endif

.ifdef DPCM_PITCH
.ifdef	SE
		__se_voice_set1		=	nsd_work + NSD_work::VoiceSet + 4
.endif
		__se_voice_set2		=	nsd_work + NSD_work::VoiceSet + 5
.ifdef	SE
		__se_tri_time		=	nsd_work + NSD_work::VoiceSet + 6
.endif
		__se_voice_set4		=	nsd_work + NSD_work::VoiceSet + 7
.else
.ifdef	SE
		__se_voice_set1		=	nsd_work + NSD_work::Frequency      + nsd::TR_BGM5
.endif
		__se_voice_set2		=	nsd_work + NSD_work::Frequency      + nsd::TR_BGM5 + 1
.ifdef	SE
		__se_tri_time		=	nsd_work + NSD_work::Envelop_Voice  + nsd::TR_BGM5
.endif
		__se_voice_set4		=	nsd_work + NSD_work::Envelop_Voice  + nsd::TR_BGM5 + 1
.endif

;Frequency	（プチノイズ防止）
.ifdef DPCM_PITCH
		__apu_frequency1	=	nsd_work + NSD_work::ApuFreq + 0		;.byte
		__apu_frequency2	=	nsd_work + NSD_work::ApuFreq + 1		;.byte
		__apu_frequency3	=	nsd_work + NSD_work::ApuFreq + 2		;.byte
.ifdef	SE
		__se_frequency1		=	nsd_work + NSD_work::ApuFreq + 3		;.byte
.endif
		__se_frequency2		=	nsd_work + NSD_work::ApuFreq + 4		;.byte
.ifdef	SE
		__se_frequency3		=	nsd_work + NSD_work::ApuFreq + 5		;.byte
.endif
.else
		__apu_frequency1	=	nsd_work + NSD_work::Por_Lv    + nsd::TR_BGM5		;.byte
		__apu_frequency2	=	nsd_work + NSD_work::Por_Lv    + nsd::TR_BGM5 + 1	;.byte
		__apu_frequency3	=	nsd_work + NSD_work::Por_Co    + nsd::TR_BGM5		;.byte
.ifdef	SE
		__se_frequency1		=	nsd_work + NSD_work::Por_Co    + nsd::TR_BGM5 + 1	;.byte
.endif
		__se_frequency2		=	nsd_work + NSD_work::Por_now   + nsd::TR_BGM5		;.byte
.ifdef	SE
		__se_frequency3		=	nsd_work + NSD_work::Por_now   + nsd::TR_BGM5 + 1	;.byte
.endif
.endif
.ifdef	FDS
		__fds_frequency		=	nsd_work + NSD_work::FDS_Frequency
		__fds_sweepbias		=	nsd_work + NSD_work::FDS_SweepBias
.endif

.ifdef	MMC5
;		__mmc5_voice_set1	=	nsd_work + NSD_work::Envelop_Freq   + nsd::TR_BGM5	;.byte
;		__mmc5_voice_set2	=	nsd_work + NSD_work::Envelop_Freq   + nsd::TR_BGM5 + 1	;.byte
		__mmc5_voice_set1	=	nsd_work + NSD_work::MMC5_VoiceSet
		__mmc5_voice_set2	=	nsd_work + NSD_work::MMC5_VoiceSet + 1
		__mmc5_frequency1	=	nsd_work + NSD_work::MMC5_Frequency
		__mmc5_frequency2	=	nsd_work + NSD_work::MMC5_Frequency + 1
.endif

.ifdef	VRC6
.ifdef DPCM_PITCH
		__vrc6_voice_set1	=	nsd_work + NSD_work::VRC6_VoiceSet		;.byte
		__vrc6_voice_set2	=	nsd_work + NSD_work::VRC6_VoiceSet + 1		;.byte
.else
		__vrc6_voice_set1	=	nsd_work + NSD_work::Envelop_Note   + nsd::TR_BGM5	;.byte
		__vrc6_voice_set2	=	nsd_work + NSD_work::Envelop_Note   + nsd::TR_BGM5 + 1	;.byte
.endif
.endif

.ifdef	VRC7
		__vrc7_voice_set	=	nsd_work + NSD_work::VRC7_VoiceSet
		__vrc7_frequency	=	nsd_work + NSD_work::VRC7_Frequency
		__vrc7_freq_old	=		nsd_work + NSD_work::VRC7_Freq_old
		__vrc7_reg	=		nsd_work + NSD_work::VRC7_Reg
.endif

.ifdef	OPLL
		__opll_voice_set	=	nsd_work + NSD_work::OPLL_VoiceSet
		__opll_frequency	=	nsd_work + NSD_work::OPLL_Frequency
		__opll_freq_old		=	nsd_work + NSD_work::OPLL_Freq_old
		__opll_reg		=	nsd_work + NSD_work::OPLL_Reg
		__opll_ryhthm		=	nsd_work + NSD_work::OPLL_Rhythm
.endif

.ifdef	N163
	.ifdef	SE_N163
		__n163_num		=	nsd_work + NSD_work::N163_num
		__n163_frequency	=	nsd_work + NSD_work::N163_Frequency + NSD_N163_Freq::Freq
		__n163_voice		=	nsd_work + NSD_work::N163_Frequency + NSD_N163_Freq::Voice

	.else
		__n163_num		=	nsd_work + NSD_work::N163_num
		__n163_frequency	=	nsd_work + NSD_work::N163_Frequency
	.endif
.endif

.ifdef	PSG
		__psg_switch		=	nsd_work + NSD_work::PSG_switch
.endif

.ifdef	SE_STOP_NUM
		__se_stop_num		=	nsd_work + NSD_work::SE_Stop_num
		__req_num		=	nsd_work + NSD_work::Req_num
.endif


;=======================================================================
;		Struct of DPCM						
;-----------------------------------------------------------------------
.Struct		nsd_dpcm
	Control		.byte		;I/O 0x4010
	DA		.byte		;I/O 0x4011
	Address		.byte		;I/O 0x4012
	Size		.byte		;I/O 0x4013
.ifdef	DPCMBank
	Bank		.byte		;Bank number
	Next		.byte		;Next number(note)
.endif
.Endstruct





;****************************************************************
;*	Macros							*
;****************************************************************

;=======================================================================
;	void	NSD_MAIN_BGM()
;-----------------------------------------------------------------------
;<<Contents>>
;	BGM main routine
;<<Input>>
;	none
;<<Output>>
;	none
;=======================================================================
.macro	NSD_MAIN_BGM
	.local	BGM_Begin
	.local	BGM_SEQ_Exit
	.local	BGM_Exit

	lda	#nsd_flag::BGM
	bit	__flag
	jne	BGM_Exit		;BGM disable ?

	;-------------------------------
	;Tempo
	lda	__Tempo_ctr
	add	__Tempo
	sta	__Tempo_ctr
	jcc	BGM_SEQ_Exit

	;-------------------------------
	;BGM
BGM_Begin:
	.repeat	nsd::BGM_Track, I
		ldx	#I*2 + nsd::TR_BGM1
		jsr	nsd_sequence
	.endrepeat
.ifdef	FO_MOD
	lda	__fo_add
;	lda	__flag
;	and	#(nsd_flag::Fade)
	beq	@foSkip

	; Standard low byte addition
	clc
	adc	__fo_value+1
	sta	__fo_value+1
	
	; Sign extend the high byte
	lda	__fo_add
	and	#$80    ; Extract the sign bit
	beq	:+      ; If zero, add #$00 (+ carry)
	lda	#$ff    ; Else, add $ff (+ carry)
:
	adc	__fo_value
	sta	__fo_value

	bne	:+
	ldx	__fo_add
	bpl	@foSkip
	lda	#$00
	sta	__fo_value+1
	jmp	@fadeStop
:
	and	#$10
	; #$10
	beq	@foSkip
	lda	#$ff
	sta	__fo_value+1
	dec	__fo_value

@fadeStop:

	lda	#$00
	sta	__fo_add

@foSkip:
.endif

.ifdef	AUTO_GROOVE
	lda	__grv_value
	beq	@end

	dec	__grv_ctr
	bne	@nzero

	lda	__grv_value
	eor	#$FF
	add	#1
	sta	__grv_value

	add	__Tempo
	sta	__Tempo

	lda	__grv_length
	sta	__grv_ctr

@nzero:
@end:
.endif

	lda	#nsd_flag::Jump
	bit	__flag
	jne	BGM_Begin

	lda	__Tempo_ctr
	sub	#Tempo_Sub
	sta	__Tempo_ctr
	cmp	#Tempo_Cmp
	jcc	BGM_Begin

BGM_SEQ_Exit:

	;-------
	;Envelop
	.repeat	nsd::BGM_Track, I
.ifdef DPCM_PITCH
	ldx	#I*2 + nsd::TR_BGM1
	jsr	nsd_envelop
.else
	  ;No envelope: DPCM, NULL
	  .if	(I <> 4) && (!(.defined(NULL) && (I = (nsd::TR_NULL / 2))))
		ldx	#I*2 + nsd::TR_BGM1
		jsr	nsd_envelop
	  .endif
.endif
	.endrepeat

.ifdef FO_MOD
	lda	__fo_value
	bne	@end
	lda	#$0F
	sta	APU_CHANCTRL
@end:
.endif
BGM_Exit:

.endmacro

;=======================================================================
;	void	NSD_MAIN_SE()
;-----------------------------------------------------------------------
;<<Contents>>
;	SE main routine
;<<Input>>
;	none
;<<Output>>
;	none
;=======================================================================
.macro	NSD_MAIN_SE
	.local	SE1
	.local	SE2
	.local	SE3
	.local	SE4
	.local	SE5
	.local	SE_Exit

	lda	#nsd_flag::SE
	bit	__flag
	bne	SE_Exit			;SE disable ?

;---------------------------------------
.ifdef	SE
SE1:
	ldx	#nsd::TR_SE_Pluse1
	lda	__Sequence_ptr + 1,x
.ifdef	DPCMBank
	ora	__Sequence_ptr,x
.endif
	beq	@L
	jsr	nsd_sequence
	jsr	nsd_envelop
@L:
.endif

;---------------------------------------
SE2:
	ldx	#nsd::TR_SE_Pluse2
	lda	__Sequence_ptr + 1,x
.ifdef	DPCMBank
	ora	__Sequence_ptr,x
.endif
	beq	@L
	jsr	nsd_sequence
	jsr	nsd_envelop
@L:

;---------------------------------------
.ifdef	SE
SE3:
	ldx	#nsd::TR_SE_Tri
	lda	__Sequence_ptr + 1,x
.ifdef	DPCMBank
	ora	__Sequence_ptr,x
.endif
	beq	@L
	jsr	nsd_sequence
	jsr	nsd_envelop
@L:
.endif

;---------------------------------------
SE4:
	ldx	#nsd::TR_SE_Noise
	lda	__Sequence_ptr + 1,x
.ifdef	DPCMBank
	ora	__Sequence_ptr,x
.endif
	beq	@L
	jsr	nsd_sequence
.ifndef	SE_NO_ENV
	jsr	nsd_envelop
.endif
@L:

;---------------------------------------
.ifdef	SE
SE5:
	ldx	#nsd::TR_SE_Dpcm
	lda	__Sequence_ptr + 1,x
.ifdef	DPCMBank
	ora	__Sequence_ptr,x
.endif
	beq	@L
	jsr	nsd_sequence
@L:
.endif
;---------------------------------------
.ifdef	SE_N163
	.repeat	nsd::SE_N163_Track,cnt
		ldx	#nsd::TR_SE_N163 + cnt*2
		lda	__Sequence_ptr + 1,x
	.ifdef	DPCMBank
		ora	__Sequence_ptr,x
	.endif
		beq	:+
		jsr	nsd_sequence
.ifndef	SE_NO_ENV
		jsr	nsd_envelop
.endif
	:
	.endrepeat
.endif
;---------------------------------------
;	lda	__Sequence_ptr + 1 + nsd::TR_SE_Pluse2
;	ora	__Sequence_ptr + 1 + nsd::TR_SE_Noise
;.ifdef	SE
;	ora	__Sequence_ptr + 1 + nsd::TR_SE_Pluse1
;	ora	__Sequence_ptr + 1 + nsd::TR_SE_Tri
;	ora	__Sequence_ptr + 1 + nsd::TR_SE_Dpcm
;.endif
;.ifdef	DPCMBank
;	ora	__Sequence_ptr + nsd::TR_SE_Pluse2
;	ora	__Sequence_ptr + nsd::TR_SE_Noise
;.ifdef	SE
;	ora	__Sequence_ptr + nsd::TR_SE_Pluse1
;	ora	__Sequence_ptr + nsd::TR_SE_Tri
;	ora	__Sequence_ptr + nsd::TR_SE_Dpcm
;.endif
;.endif
;
;	bne	SE_Exit

;-----------------------------------------------------------
;
;	ldx	#nsd::TR_SE_Pluse2
;	lda	__Sequence_ptr + 1,x
;.ifdef	DPCMBank
;	ora	__Sequence_ptr,x
;.endif
;	beq	SE0
;	jsr	nsd_sequence
;	jsr	nsd_envelop
;SE0:
;	ldx	#nsd::TR_SE_Noise
;	lda	__Sequence_ptr + 1,x
;.ifdef	DPCMBank
;	ora	__Sequence_ptr,x
;.endif
;	beq	SE1
;	jsr	nsd_sequence
;	jsr	nsd_envelop
;	jmp	SE_Exit
;SE1:
;	ora	__Sequence_ptr + nsd::TR_SE_Pluse2 + 1
;.ifdef	DPCMBank
;	ora	__Sequence_ptr + nsd::TR_SE_Pluse2
;.endif
;	bne	SE_Exit
;
;-----------------------------------------------------------

	;SE Disable
;	lda	#nsd_flag::SE
;	ora	__flag
;	sta	__flag
SE_Exit:

.endmacro
