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
class Meta_psfx :
	public MetaItem
{
//�����o�[�ϐ�
private:

//�����o�[�֐�
public:
	Meta_psfx(const char _strName[] = "psfx");
	~Meta_psfx(void);
};
