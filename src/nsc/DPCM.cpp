#include "StdAfx.h"
#include "DPCM.h"

/****************************************************************/
/*					グローバル変数（クラスだけど・・・）		*/
/****************************************************************/
extern	OPSW*			cOptionSW;	//オプション情報へのポインタ変数

//==============================================================
//		コンストラクタ
//--------------------------------------------------------------
//	●引数
//		FileInput*			DPCMfile	�儕CM（*.dmc）のファイル名
//		unsigned	int		_id			番号
//		const		_CHAR	_strName[]	このオブジェクトの名前
//	●返値
//					無し
//==============================================================
DPCM::DPCM(MMLfile* MML, const char* dmcfile, unsigned int _id, const _CHAR _strName[]):
	MusicItem(_strName),
	f_Use(false),
	m_id(_id)
{
	//----------------------
	//Local変数
	unsigned	int		_size;
	unsigned	int		i = 0;

	fileopen(dmcfile, &cOptionSW->m_pass_dmc);
	_size = GetSize();
	if(_size > 4081){
		MML->Err(_T("�儕CMは4081Byte以下にしてください。"));
	}

	if((_size & 0x000F) != 0x01){
		iSize = (_size & 0x0FF0) + 0x0011;
	} else {
		iSize = _size;
	}
	_DPCM_size = (char)(iSize >> 4);

	code.resize(iSize);

	//�儕CM実体を転送
	while(i < _size){
		code[i] = cRead();
		i++;
	}
	//Padding
	while(i < iSize){
		code[i] = (unsigned char)0xAA;
		i++;
	}

	close();
}

//==============================================================
//		デストラクタ
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//				無し
//==============================================================
DPCM::~DPCM(void)
{
}
//==============================================================
//		コードの取得
//--------------------------------------------------------------
//	●引数
//		MusicFile*	MUS		コードを出力する曲データファイル・オブジェクト
//	●返値
//				無し
//==============================================================
void	DPCM::getAsm(MusicFile* MUS)
{
	*MUS << ".align	$40\n" << MUS->Header.Label.c_str() << "DPCM" << m_id << ":" << endl;
	MusicItem::getAsm(MUS);
}
