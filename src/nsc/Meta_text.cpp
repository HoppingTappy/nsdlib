/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "Meta_text.h"

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//					string*	text		�e�L�X�g
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
Meta_text::Meta_text(string* text, const char _strName[]):
	MetaItem(_strName)
{
	m_data.clear();
	m_size = 0;

	append(text);
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
Meta_text::~Meta_text(void)
{
}
