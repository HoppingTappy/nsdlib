/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "mml_CallSub.h"

/****************************************************************/
/*					グローバル変数（クラスだけど・・・）		*/
/****************************************************************/
extern	OPSW*			cOptionSW;	//オプション情報へのポインタ変数

//==============================================================
//		コンストラクタ
//--------------------------------------------------------------
//	●引数
//		unsigned	char 	_code		コード
//		const		char	_strName[]	クラスの名前
//	●返値
//				無し
//==============================================================
mml_CallSub::mml_CallSub(size_t _id, const _CHAR _strName[]):
	mml_Address(_id, nsd_Call, _strName),
	by_Patch(false)
{
}

//==============================================================
//		デストラクタ
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//				無し
//==============================================================
mml_CallSub::~mml_CallSub(void)
{
}

