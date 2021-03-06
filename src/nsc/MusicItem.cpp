/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "MusicItem.h"

/****************************************************************/
/*					グローバル変数（クラスだけど・・・）		*/
/****************************************************************/
extern	OPSW*			cOptionSW;	//オプション情報へのポインタ変数

//==============================================================
//		コンストラクタ
//--------------------------------------------------------------
//	●引数
//		const		_CHAR	_strName[]	オブジェクト名
//	●返値
//				無し
//==============================================================
MusicItem::MusicItem(const _CHAR _strName[]):
	strName(_strName),
	iSize(0),
	iOffset(0),
	f_id(false),
	f_necessary(false)
{
	//Debug message　（うざい程出力するので注意。）
	if(cOptionSW->iDebug & DEBUG_Create){
		_COUT << _T("Create Music Object : ") << strName << endl;
	}
}

MusicItem::MusicItem(size_t _id, const _CHAR _strName[]):
	strName(_strName),
	iSize(0),
	iOffset(0),
	m_id(_id),
	f_id(true),
	f_necessary(false)
{
	//Debug message　（うざい程出力するので注意。）
	if(cOptionSW->iDebug & DEBUG_Create){
		_COUT << _T("Create Music Object : ") << strName << _T("(");
		cout << m_id;
		_COUT << _T(")") << endl;
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
MusicItem::~MusicItem(void)
{
	clear();

	//Debug message　（うざい程出力するので注意。）
	if(cOptionSW->iDebug & DEBUG_Delete){
		_COUT << _T("Delete Music Object : ") << strName;
		if(f_id == true){
			_COUT << _T("(") << m_id << _T(")");
		}
		_COUT << endl;
	}
}

//==============================================================
//		クリア
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//				無し
//==============================================================
void	MusicItem::clear(void)
{
	//----------------------
	//Local変数
	list<	MusicItem*>::iterator	itItem;

	//----------------------
	//clear
	code.clear();

	//----------------------
	//Delete Class
	if(!ptcItem.empty()){
		itItem = ptcItem.begin();
		while(itItem != ptcItem.end()){
			delete *itItem;
			itItem++;
		}
		ptcItem.clear();
	}

	iSize = 0;
}

void	MusicItem::clear_Optimize()
{
	//----------------------
	//Local変数
	list<	MusicItem*>::iterator	itItem;

	if(chkUse() == false){
		//----------------------
		//このオブジェクトごと、ごっそりクリアする。
		//Debug message　（うざい程出力するので注意。）
		if(cOptionSW->iDebug & DEBUG_Optimize){
			_COUT << _T("Optimizing : ") << strName;
			if(f_id == true){
				_COUT	<< _T("(") << m_id << _T(")");
			}
			_COUT << endl;
		}
		clear();
	} else {
		//----------------------
		//子オブジェクトを最適化するか評価する。
		if(!ptcItem.empty()){
			itItem = ptcItem.begin();
			while(itItem != ptcItem.end()){
				(*itItem)->clear_Optimize();
				itItem++;
			}
		}
	}
}

//==============================================================
//		コードサイズの取得
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//		size_t
//==============================================================
size_t		MusicItem::getSize()
{
	return(iSize);
}

//==============================================================
//		コードのオフセットアドレスの取得
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//		unsigned	int	
//==============================================================
size_t	MusicItem::getOffset()
{
	return(iOffset);
}

//==============================================================
//		オフセットアドレスの設定
//--------------------------------------------------------------
//	●引数
//		size_t	_offset
//	●返値
//				無し
//==============================================================
size_t	MusicItem::SetOffset(size_t _offset)
{
	//----------------------
	//Local変数
	list<	MusicItem*>::iterator	itItem;
	size_t	i = 0;

	//Debug message　（うざい程出力するので注意。）
	if(cOptionSW->iDebug & DEBUG_SetAddress){
		_COUT << _T("Object Address [0x") << hex << setw(4) << setfill(_T('0')) << _offset << _T("]: ");
		while(i < code.size()){
			_COUT	<<	hex	<<	setw(2)	<<	setfill(_T('0'))	<<	(unsigned int)(code[i] & 0xFF)	<<	_T(" ");
			i++;
		}
		_COUT  << dec	<< _T(": ") << strName;
		if(f_id == true){
			_COUT	<< _T("(") << m_id << _T(")");
		}
		_COUT << endl;
	}

	iOffset = _offset;
	_offset	+= code.size();

	if(!ptcItem.empty()){
		itItem = ptcItem.begin();
		while(itItem != ptcItem.end()){
			_offset = (*itItem)->SetOffset(_offset);
			itItem++;
		}
	}

	//このオブジェクトのサイズ（最適化後）
	iSize = _offset - iOffset;

	return(_offset);
}

//==============================================================
//		コードの取得
//--------------------------------------------------------------
//	●引数
//		unsigned	int	n	添え字
//	●返値
//		unsigned	char	内容
//==============================================================
unsigned	char	MusicItem::getCode(size_t n)
{
	unsigned	char	iCode;
	
	if((n<0) || (n>=iSize)){
		iCode = 0xFF;
	} else {
		iCode = code[n];
	}

	return(iCode);
}

//==============================================================
//		コードの取得
//--------------------------------------------------------------
//	●引数
//		string*		_str
//	●返値
//				無し
//==============================================================
void	MusicItem::getCode(string* _str)
{
	//----------------------
	//Local変数
	list<	MusicItem*>::iterator	itItem;

	_str->append(code);

	if(!ptcItem.empty()){
		itItem = ptcItem.begin();
		while(itItem != ptcItem.end()){
			(*itItem)->getCode(_str);
			itItem++;
		}
	}
}

//==============================================================
//		コードの設定
//--------------------------------------------------------------
//	●引数
//		string*		_str
//	●返値
//				無し
//==============================================================
void	MusicItem::setCode(string* _str)
{
	code.clear();
	code.assign(*_str);
	iSize = code.size();
}

//==============================================================
//		コードの取得
//--------------------------------------------------------------
//	●引数
//		MusicFile*	MUS		コードを出力する曲データファイル・オブジェクト
//	●返値
//				無し
//==============================================================
void	MusicItem::getAsm(MusicFile* MUS)
{
	//----------------------
	//Local変数
	size_t	i = 0;
	list<	MusicItem*>::iterator	itItem;
	bool	_flag;




	if(code.size() > 0){
		while(i < code.size()){
			_flag = false;
			if(i==0){
				*MUS << "	.byte	$";
			}
			else
			{
				if ( (label != "") && (label != "_OFF_") )
				{
					switch (code[0]) 
					{
						case 0x02:
						case 0x06:
						case 0x10:
						case 0x11:
						case 0x12:	// Frequency envelop. 
						case 0x13:
						case 0x27:
							*MUS << " ," << "<(" << label << " - *), >(" << label << " - (*-1))";
							_flag = true;
							i++;
							break;
						default:
							*MUS << " ,$";
							_flag = false;
					}
				
				}
				else 
				{
					*MUS << " ,$"; 
				}
			}
			if (_flag == false) {
				*MUS << hex << setw(2) << setfill('0') << (int)(code[i] & 0xFF);
			}
			i++;
		}
		*MUS << dec << endl;
	}

	if(!ptcItem.empty()){
		itItem = ptcItem.begin();
		while(itItem != ptcItem.end()){
			(*itItem)->getAsm(MUS);
			itItem++;
		}
	}
}

//==============================================================
//		idの設定
//--------------------------------------------------------------
//	●引数
//		size_t	_id		番号
//	●返値
//				無し
//==============================================================
void	MusicItem::set_id(size_t _id)
{
	f_id = true;
	m_id = _id;
}

//==============================================================
//		idの取得
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//		unsigned	int		番号
//==============================================================
size_t	MusicItem::get_id(void)
{
	return(m_id);
}
//==============================================================
//		flagの取得
//--------------------------------------------------------------
//	●引数
//				無し
//	●返値
//		unsigned	int		番号
//==============================================================
bool	MusicItem::get_flag(void)
{
	return(f_id);
}
