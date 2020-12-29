/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "Meta_mixe.h"

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
Meta_mixe::Meta_mixe(const char _strName[]):
	MetaItem(_strName)
{
	m_size = 0;
	m_data.clear();
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
Meta_mixe::~Meta_mixe(void)
{
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				unsigned char	_id		������ID
//				MMLfile*		MML		MML�t�@�C��
//	���Ԓl
//				����
//==============================================================
void	Meta_mixe::append(unsigned char _id, signed int _vol, MMLfile* MML)
{
	//�G���[����
	if(m_volume.count(_id) > 0){
		MML->Warning(_T("#mixe�ɂĉ����w�肪�d�����Ă��܂��B"));
	} else {
		if((_vol<-32768) || (_vol>32767)){
			MML->Warning(_T("#mixe�̉��ʂ́A-32768�`32767�Ŏw�肵�Ă��������B"));
		}
		m_volume[_id] = (short)_vol & 0xFFFF;
		m_data.push_back(_id);
		m_data.push_back((char)( _vol     & 0xFF));
		m_data.push_back((char)((_vol>>8) & 0xFF));
		m_size += 3;
	}
}
