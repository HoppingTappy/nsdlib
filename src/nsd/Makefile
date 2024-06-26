#==============================================================================
#	NES Sound Driver Libraly
#		Make file
#				A.Waranabe (S.W.)
#==============================================================================

export

TOOL_PASS =	../../tools/cc65/
INC_PASS =	../../include/
LIB_PASS =	../../lib/

include	$(INC_PASS)makefile.mk

########################################
#;	Source files list
########################################

FILES =		nsd_init.s		\
		nsd_set_dpcm.s		\
		nsd_main.s		\
		nsd_main_bgm.s		\
		nsd_main_se.s		\
		nsd_play_bgm.s		\
		nsd_stop_bgm.s		\
		nsd_pause_bgm.s		\
		nsd_resume_bgm.s	\
		nsd_save.s		\
		nsd_load.s		\
		nsd_play_se.s		\
		nsd_stop_se.s		\
		nsd_sequence.s		\
		nsd_envelope.s		\
		nsd_snd.s		\
		nsd_math.s		\
		nsd_work.s		\
		nsd_irq.s		

OFILES =	$(FILES:.s=.o)



#---------------------------------------
#;	Header files
#---------------------------------------

INC_FILES =	nsd.inc



########################################
#;	Project list
########################################

PROJ      =	NSD
PROJ_PAL  =	NSD_PAL
PROJ_SE   =	NSD_SE
PROJ_FDS  =	NSD_FDS
PROJ_VRC6 =	NSD_VRC6
PROJ_VRC7 =	NSD_VRC7
PROJ_OPLL =	NSD_OPLL
PROJ_MMC5 =	NSD_MMC5
PROJ_N163 =	NSD_N163
PROJ_PSG  =	NSD_s5b
PROJ_ALL  =	NSD_ALL
PROJ_ALL2 =	NSD_ALL2
PROJ_OALL =	NSD_OALL
PROJ_HFE4 =	NSD_HFE4
PROJ_HFX4 =	NSD_HFX4

PROJ_LIST =	$(PROJ).lib		\
		$(PROJ_PAL).lib		\
		$(PROJ_SE).lib		\
		$(PROJ_FDS).lib		\
		$(PROJ_VRC6).lib	\
		$(PROJ_VRC7).lib	\
		$(PROJ_OPLL).lib	\
		$(PROJ_MMC5).lib	\
		$(PROJ_N163).lib	\
		$(PROJ_PSG).lib		\
		$(PROJ_ALL).lib		\
		$(PROJ_ALL2).lib	\
		$(PROJ_OALL).lib	\
		$(PROJ_HFX4).lib	\
		$(PROJ_HFE4).lib



#---------------------------------------
#;	Define option
#---------------------------------------

AMOD  = -D AUTO_GROOVE -D ENV_NOTE_ABS -D ENVELOPE_MODE -D FDS_SYNC -D SEND_SIGNAL -D DPCM_PITCH
APAL  = -D PAL $(AMOD)
ASE   = -D SE $(AMOD)
AFDS  = -D FDS $(AMOD)
AVRC6 = -D VRC6 $(AMOD)
AVRC7 = -D VRC7 $(AMOD)
AOPLL = -D OPLL $(AMOD)
AMMC5 = -D MMC5 $(AMOD)
AN163 = -D N163=8 $(AMOD)
APSG  = -D PSG $(AMOD)

AHFE4 =         -D VRC6         -D VRC7 -D MMC5 -D N163=8 -D PSG -D NULL -D DPCMBank -D HFE4 $(AMOD)
AALL  =         -D VRC6         -D VRC7 -D MMC5 -D N163=8 -D PSG -D NULL -D DPCMBank $(AMOD)
AOALL =         -D VRC6 -D OPLL         -D MMC5 -D N163=8 -D PSG -D NULL -D DPCMBank $(AMOD)
AALL2 = -D FDS  -D VRC6         -D VRC7 -D MMC5 -D N163=8 -D PSG -D NULL -D DPCMBank $(AMOD)
AHFX4 = -D FDS  -D VRC6 -D OPLL -D VRC7 -D MMC5 -D N163=8 -D PSG -D NULL -D DPCMBank -D HFX4 $(AMOD)


$(PROJ).lib :		ASFLAGS += $(AMOD)
$(PROJ_PAL).lib :	ASFLAGS += $(APAL)
$(PROJ_SE).lib :	ASFLAGS += $(ASE)
$(PROJ_FDS).lib :	ASFLAGS += $(AFDS)
$(PROJ_VRC6).lib :	ASFLAGS += $(AVRC6)
$(PROJ_VRC7).lib :	ASFLAGS += $(AVRC7)
$(PROJ_OPLL).lib :	ASFLAGS += $(AOPLL)
$(PROJ_MMC5).lib :	ASFLAGS += $(AMMC5)
$(PROJ_N163).lib :	ASFLAGS += $(AN163)
$(PROJ_PSG).lib :	ASFLAGS += $(APSG)
$(PROJ_ALL).lib :	ASFLAGS += $(AALL)
$(PROJ_ALL2).lib :	ASFLAGS += $(AALL2)
$(PROJ_OALL).lib :	ASFLAGS += $(AOALL)
$(PROJ_HFX4).lib :	ASFLAGS += $(AHFX4)
$(PROJ_HFE4).lib :	ASFLAGS += $(AHFE4)



########################################
#;	Build process
########################################

.PHONY: all clean


all:	$(PROJ_LIST)


%.lib :	$(FILES)
	$(MAKE) -f MAKEFILE.inc $@


clean:
	@$(RM) *.bak
	@$(RM) *.o
	@$(RM) *.lst
	@$(RM) *.lib

	@$(RM) $(LOG_FILE)
	@$(RM) $(ERRLOG_FILE)
	@$(RM) $(BLDLOG_FILE)
