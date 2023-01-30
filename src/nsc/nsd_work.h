/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#pragma once

/****************************************************************/
/*																*/
/*			�\���̒�`											*/
/*																*/
/****************************************************************/
class NSD_WORK {

//�����o�[�ϐ�
public:
	int		gatemode;
	int		length;
	int		gate_q;
	int		gate_u;

	int		octave;
	int		octave1;		//One time octave
	int		detune_cent;
	int		detune_reg;

	int		trans;

	int		voice;
	int		voice_rel;
	int		volume;
	int		volume_rel;

	size_t	env_volume;
	size_t	env_voice;
	size_t	env_frequency;
	size_t	env_note;

	//���݂̏�ԁi�G���x���[�v��sw�j
	bool	sw_Evoi;		//
	bool	sw_Evol;		//
	bool	sw_Em;			//
	bool	sw_En;			//
	bool	sw_EN;			//

	//APU
	int	sweep;

	//FDS
	size_t	fds_career;
	size_t	fds_modlator;
	bool	sw_fds_career;
	bool	sw_fds_modlator;
	int		fds_volume;
	int		fds_frequency;

	//VRC7
	size_t	vrc7_voice;
	bool	sw_vrc7_voice;

	//N163
	size_t	n163_voice;
	bool	sw_n163_voice;

	//PSG
	int		psg_switch;
	int		psg_frequency;


//�����o�[�֐�
			NSD_WORK(void);
			~NSD_WORK(void);
	void	init(void);
};
