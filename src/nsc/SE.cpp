// 静的モデル
#include "StdAfx.h"
#include "SE.h"

//==============================================================
//		コンストラクタ
//--------------------------------------------------------------
//	●引数
//		MMLfile*	MML
//	●返値
//					無し
//==============================================================
SE::SE(MMLfile* MML, char _strName[]/* = "==== [ SE ]===="*/):
	TrackSet(MML, false, _strName)
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
SE::~SE()
{
	
}
