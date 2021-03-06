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

FILES =		crt0.s

OFILES =	$(FILES:.s=.o)



#---------------------------------------
#;	Header files
#---------------------------------------

INC_FILES =	



########################################
#;	Project list
########################################

PROJ      =	nsd
PROJ_PAL  =	nsd_pal
PROJ_SE   =	nsd_se
PROJ_FDS  =	nsd_fds
PROJ_VRC6 =	nsd_vrc6
PROJ_VRC7 =	nsd_vrc7
PROJ_OPLL =	nsd_opll
PROJ_MMC5 =	nsd_mmc5
PROJ_N163 =	nsd_n163
PROJ_PSG  =	nsd_s5b
PROJ_ALL  =	nsd_all
PROJ_ALL2 =	nsd_all2
PROJ_OALL =	nsd_oall
PROJ_HFE4 =	nsd_hfe4
PROJ_HFX4 =	nsd_hfx4

PROJ_LIST =	$(PROJ).bin		\
		$(PROJ_PAL).bin		\
		$(PROJ_SE).bin		\
		$(PROJ_FDS).bin		\
		$(PROJ_VRC6).bin	\
		$(PROJ_VRC7).bin	\
		$(PROJ_OPLL).bin	\
		$(PROJ_MMC5).bin	\
		$(PROJ_N163).bin	\
		$(PROJ_PSG).bin		\
		$(PROJ_ALL).bin		\
		$(PROJ_ALL2).bin	\
		$(PROJ_OALL).bin	\
		$(PROJ_HFX4).bin	\
		$(PROJ_HFE4).bin



#---------------------------------------
#;	Define option
#---------------------------------------

#---------------
#; アセンブラの設定
AMOD  = -D AUTO_GROOVE -D ENV_NOTE_ABS -D ENVELOPE_MODE -D FDS_SYNC -D SEND_SIGNAL

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


$(PROJ_PAL).bin :	ASFLAGS += $(APAL)
$(PROJ_SE).bin :	ASFLAGS += $(ASE)
$(PROJ_FDS).bin :	ASFLAGS += $(AFDS)
$(PROJ_VRC6).bin :	ASFLAGS += $(AVRC6)
$(PROJ_VRC7).bin :	ASFLAGS += $(AVRC7)
$(PROJ_OPLL).bin :	ASFLAGS += $(AOPLL)
$(PROJ_MMC5).bin :	ASFLAGS += $(AMMC5)
$(PROJ_N163).bin :	ASFLAGS += $(AN163)
$(PROJ_PSG).bin :	ASFLAGS += $(APSG)
$(PROJ_ALL).bin :	ASFLAGS += $(AALL)
$(PROJ_ALL2).bin :	ASFLAGS += $(AALL2)
$(PROJ_OALL).bin :	ASFLAGS += $(AOALL)
$(PROJ_HFX4).bin :	ASFLAGS += $(AHFX4)
$(PROJ_HFE4).bin :	ASFLAGS += $(AHFE4)

$(PROJ).bin :		CFG_FILE = default.cfg
$(PROJ_PAL).bin :	CFG_FILE = default.cfg
$(PROJ_SE).bin :	CFG_FILE = default.cfg
$(PROJ_FDS).bin :	CFG_FILE = default.cfg
$(PROJ_VRC6).bin :	CFG_FILE = default.cfg
$(PROJ_VRC7).bin :	CFG_FILE = default.cfg
$(PROJ_OPLL).bin :	CFG_FILE = default.cfg
$(PROJ_MMC5).bin :	CFG_FILE = default.cfg
$(PROJ_N163).bin :	CFG_FILE = default.cfg
$(PROJ_PSG).bin :	CFG_FILE = default.cfg
$(PROJ_ALL).bin :	CFG_FILE = all.cfg
$(PROJ_ALL2).bin :	CFG_FILE = all.cfg
$(PROJ_HFE4).bin :	CFG_FILE = all.cfg
$(PROJ_OALL).bin :	CFG_FILE = opllall.cfg
$(PROJ_HFX4).bin :	CFG_FILE = opllall.cfg

#---------------
#; リンカーの設定
MAP_FILE   =	$*.map
DBG_FILE   =	$*.dbg


########################################
#;	Build process
########################################

.PHONY: all clean

all:	$(PROJ_LIST)


%.bin :	$(FILES)
	$(MAKE) -f MAKEFILE.inc $@


clean:
	@$(RM) *.bak
	@$(RM) *.o
	@$(RM) *.dbg
	@$(RM) *.map
	@$(RM) *.lst
	@$(RM) *.bin

	@$(RM) $(LOG_FILE)
	@$(RM) $(ERRLOG_FILE)
	@$(RM) $(BLDLOG_FILE)
