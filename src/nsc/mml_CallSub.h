/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#pragma once
#include "mml_Address.h"

/****************************************************************/
/*																*/
/*			�N���X��`											*/
/*																*/
/****************************************************************/
class mml_CallSub :
	public mml_Address
{
//�����o�[�ϐ�
	bool	by_Patch;			//Patch�@�\�ɂ��
	bool	f_disable_opt;		//�œK�������H

//�����o�[�֐�
public:
	mml_CallSub(size_t _id, const _CHAR _strName[]=_T("Call Subroutine"));
	~mml_CallSub(void);

	void	setPatch(bool _f){
								by_Patch		= true;
								f_disable_opt	= _f;
							};
	bool	isPatch(){			return(by_Patch); };
	bool	isDisableOptimize(){return(f_disable_opt);	};
};
