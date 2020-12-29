/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "Meta_auth.h"

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		MusicHeader*		Header		�w�b�_�[���
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
Meta_auth::Meta_auth(MusicHeader* Header, const char _strName[]):
	MetaItem(_strName)
{
	m_data.clear();
	m_size = 0;

	append(&Header->title);
	append(&Header->composer);
	append(&Header->copyright);
	append(&Header->maker);
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
Meta_auth::~Meta_auth(void)
{
}
