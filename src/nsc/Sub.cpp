// 静的モデル
#include "StdAfx.h"
#include "Sub.h"

//==============================================================
//		コンストラクタ
//--------------------------------------------------------------
//	●引数
//		MMLfile*	MML
//	●返値
//					無し
//==============================================================
Sub::Sub(MMLfile* MML, unsigned int _id, wchar_t _strName[]/* = "==== [ Sub ]===="*/):
	TrackSet(MML, _id, true, _strName)
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
Sub::~Sub()
{
	
}
//==============================================================
//		コードの取得
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//				無し
//==============================================================
void	Sub::getAsm(MusicFile* MUS)
{
	*MUS << MUS->Header.Label.c_str() << "SUB" << m_id << ":" << endl;
	TrackSet::getAsm(MUS);
}
