/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "Meta_BANK.h"

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		NSF_Header*			_nsf_hed	NSF�w�b�_�[
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
Meta_BANK::Meta_BANK(NSF_Header* _nsf_hed, const char _strName[]):
	MetaItem(_strName)
{
	m_size = 8;
	m_data.resize(m_size);

	memcpy((void *)m_data.c_str(), &_nsf_hed->Bank, m_size);
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
Meta_BANK::~Meta_BANK(void)
{
}
