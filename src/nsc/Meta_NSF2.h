/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#pragma once
#include "MetaItem.h"

/****************************************************************/
/*																*/
/*			�N���X��`											*/
/*																*/
/****************************************************************/
class Meta_NSF2 :
	public MetaItem
{
//�����o�[�ϐ�
private:

//�����o�[�֐�
public:
	Meta_NSF2(NSF_Header* _nsf_hed, const char _strName[] = "NSF2");
	~Meta_NSF2(void);
};
