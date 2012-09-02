#include "StdAfx.h"
#include ".\mml_note.h"

//==============================================================
//		コンストラクタ
//--------------------------------------------------------------
//	●引数
//		unsigned	int		code
//		unsigned	int		length
//		unsigned	int		gatetime
//					bool	slur
//		const		char	_strName[]	クラスの名前
//	●返値
//				無し
//==============================================================
mml_note::mml_note(int _code, int length, int gatetime, bool slur, const char _strName[]):
	MusicEvent(_strName)
{
	unsigned	char	opcode = nsd_Note | _code;
	unsigned	int		i = 0;

	if((_code<0) || (_code>15) || (_code==12)){
		cout << "mml_note::mml_note()関数で、エラーが発生しました。" << endl;
		exit(-1);
	}

	iSize = 1;

	if(slur == true){
		opcode |= nsd_Note_Slur;
	}

	if(length > 0){
		opcode |= nsd_Note_Length;
		iSize++;
	}

	if(gatetime > 0){
		opcode |= nsd_Note_Gate;
		iSize++;
	}

	code.resize(iSize);
	code[i] = opcode;
	i++;

	if(length > 0){
		code[i] = length;
		i++;
	}
	if(gatetime > 0){
		code[i] = gatetime;
		i++;
	}

}

//==============================================================
//		デストラクタ
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//				無し
//==============================================================
mml_note::~mml_note(void)
{
}

//==============================================================
//		タイ
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//				無し
//==============================================================
void	mml_note::SetTai(void)
{
	code[0] |= nsd_Note_Slur;
}
