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
typedef	struct{

	//�ݒ萔�l
	unsigned	int		iVoi;		//
				size_t	iEvoi;		//
				size_t	iEvol;		//
				size_t	iEm;		//
				size_t	iEn;		//
	unsigned	int		iKey;		//KeyShift
	unsigned	char	iSweep;		//
				size_t	iSub;		//
	unsigned	int		iGate_q;	//
	unsigned	int		iGate_u;	//
	unsigned	int		iSign;

	//�ݒ肷�邩�ǂ����idefailt = false�j
				bool	fVoi;		//
				bool	fEvoi;		//
				bool	fEvol;		//
				bool	fEm;		//
				bool	fEn;		//
				bool	fKey;		//
				bool	fSweep;		//
				bool	fSub;		//
				bool	fSub_opt;	//true�ōœK������
				bool	fGate_q;	//
				bool	fGate_u;	//
				bool	fSign;

	//�G���x���[�v��sw�i�L��ꍇ true�j
				bool	sw_Evoi;	//
				bool	sw_Evol;	//
				bool	sw_Em;		//
				bool	sw_En;		//

} patch_scrap;

/****************************************************************/
/*																*/
/*			�N���X��`											*/
/*																*/
/****************************************************************/
class Patch
{
//�����o�[�ϐ�
protected:

					size_t		m_id;			//�p�b�`�ԍ�
	map<size_t, patch_scrap*>	m_Patch;		//�p�b�`�̏��
					size_t		m_kn;			//�������̃m�[�g�ԍ�

		patch_scrap*			m_now_Patch;	//�������̃p�b�`�̃|�C���^
					bool		f_error;		//�G���[�����̗L��

//�����o�[�֐�
public:
						Patch(	MMLfile* MML, size_t _id);		
						~Patch(void);					

	//Patch �I�u�W�F�N�g������
				void	setKey(	MMLfile* MML, int key);
				void	setN(	MMLfile* MML, int note);

				void	DebugMsg(void);

	//�V�[�P���X�L�q�u���b�N����ĂԊ֐��Q
				void	setNote(int i);		//�m�[�g�ԍ��̃Z�b�g

	unsigned	int		get_iVoi(void){		return(m_now_Patch->iVoi);};
				size_t	get_iEvoi(void){	return(m_now_Patch->iEvoi);};
				size_t	get_iEvol(void){	return(m_now_Patch->iEvol);};
				size_t	get_iEm(void){		return(m_now_Patch->iEm);};
				size_t	get_iEn(void){		return(m_now_Patch->iEn);};
	unsigned	int		get_iKey(void){		return(m_now_Patch->iKey);};
	unsigned	char	get_iSweep(void){	return(m_now_Patch->iSweep);};
				size_t	get_iSub(void){		return(m_now_Patch->iSub);};
	unsigned	int		get_iGate_q(void){	return(m_now_Patch->iGate_q);};
	unsigned	int		get_iGate_u(void){	return(m_now_Patch->iGate_u);};
	unsigned	int		get_iSign(void){	return(m_now_Patch->iSign);};

				bool	get_fVoi(void){		return(m_now_Patch->fVoi);};
				bool	get_fEvoi(void){	return(m_now_Patch->fEvoi);};
				bool	get_fEvol(void){	return(m_now_Patch->fEvol);};
				bool	get_fEm(void){		return(m_now_Patch->fEm);};
				bool	get_fEn(void){		return(m_now_Patch->fEn);};
				bool	get_fKey(void){		return(m_now_Patch->fKey);};
				bool	get_fSweep(void){	return(m_now_Patch->fSweep);};
				bool	get_fSub(void){		return(m_now_Patch->fSub);};
				bool	get_fSub_opt(void){	return(m_now_Patch->fSub_opt);};
				bool	get_fGate_q(void){	return(m_now_Patch->fGate_q);};
				bool	get_fGate_u(void){	return(m_now_Patch->fGate_u);};
				bool	get_fSign(void) {	return(m_now_Patch->fSign); };

				bool	get_sw_Evoi(void){	return(m_now_Patch->sw_Evoi);};
				bool	get_sw_Evol(void){	return(m_now_Patch->sw_Evol);};
				bool	get_sw_Em(void){	return(m_now_Patch->sw_Em);};
				bool	get_sw_En(void){	return(m_now_Patch->sw_En);};

				bool	isError(){return(f_error);};
};
