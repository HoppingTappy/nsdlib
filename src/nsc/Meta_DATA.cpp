/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "Meta_DATA.h"

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//					string* nsf_data	NSF�f�[�^
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
Meta_DATA::Meta_DATA(string* nsf_data, const char _strName[]):
	MetaItem(_strName)
{
	setMetaData(nsf_data);
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
Meta_DATA::~Meta_DATA(void)
{
}
