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
class Meta_mixe :
	public MetaItem
{
//�����o�[�ϐ�
private:
	map<unsigned char, short>	m_volume;	//���ʂ̋L��

//�����o�[�֐�
public:
	Meta_mixe(const char _strName[] = "mixe");
	~Meta_mixe(void);

	void	append(unsigned char _id, signed int _vol, MMLfile* MML);
};
