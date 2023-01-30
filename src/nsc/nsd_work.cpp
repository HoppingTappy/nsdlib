/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "stdafx.h"
#include "nsd_work.h"

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//					����
//	���Ԓl
//					����
//==============================================================
NSD_WORK::NSD_WORK(void) {

	init();
};

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//					����
//	���Ԓl
//					����
//==============================================================
NSD_WORK::~NSD_WORK(void) {};

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//					����
//	���Ԓl
//					����
//==============================================================
void	NSD_WORK::init(void) {

	//�����h���C�o�����l��ݒ�
	gatemode		= -1;
	length			= 24;
	gate_q			= 0;
	gate_u			= 0;
	octave			= 3;
	octave1			= 0;
	detune_cent		= 0;
	detune_reg		= 0;
	trans			= 0;
	voice			= -1;
	voice_rel		= -1;
	volume			= 15;
	volume_rel		= 2;
	sw_Evoi			= false;
	sw_Evol			= false;
	sw_Em			= false;
	sw_En			= false;
	sweep			= -1;
	sw_fds_career	= false;
	sw_fds_modlator	= false;
	fds_volume		= -1;
	fds_frequency	= -1;
	sw_vrc7_voice	= false;
	sw_n163_voice	= false;
	psg_switch		= -1;
	psg_frequency	= -1;
}
