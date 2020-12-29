/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "mml_Address.h"

/****************************************************************/
/*					�O���[�o���ϐ��i�N���X�����ǁE�E�E�j		*/
/****************************************************************/
extern	OPSW*			cOptionSW;	//�I�v�V�������ւ̃|�C���^�ϐ�

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		unsigned	char 	_code		�R�[�h
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
mml_Address::mml_Address(unsigned char _code, const _CHAR _strName[]):
	MusicEvent(_strName)
{

	iSize = 3;
	code.resize(iSize);
	code[0] = _code;
	code[1] = 0;
	code[2] = 0;
	label = "_OFF_";
}

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		unsigned	char 	_code		�R�[�h
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
mml_Address::mml_Address(size_t _id, unsigned char _code, const _CHAR _strName[]):
	MusicEvent(_id, _strName)
{
	iSize = 3;
	code.resize(iSize);
	code[0] = _code;
	code[1] = 0;
	code[2] = 0;
	label = "_OFF_";
}

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		unsigned	char 	_code		�R�[�h
//		unsigned	char 	_data		����1
//		const		char	_strName[]	�N���X�̖��O
//	���Ԓl
//				����
//==============================================================
mml_Address::mml_Address(size_t _id, unsigned char _code, unsigned char _data, const _CHAR _strName[]):
	MusicEvent(_id, _strName)
{
	iSize = 4;
	code.resize(iSize);
	code[0] = _code;
	code[1] = _data;
	code[2] = 0;
	code[3] = 0;
	label = "";
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
mml_Address::~mml_Address(void)
{
}

//==============================================================
//		�A�h���X�̐ݒ�
//--------------------------------------------------------------
//	������
//		unsigned	int		_addr	�A�h���X
//	���Ԓl
//				����
//==============================================================
void	mml_Address::set_Address(size_t _addr)
{
	switch(iSize){
		case(0):
			if(cOptionSW->iDebug & DEBUG_Optimize){
				_COUT << _T("This Object has cleared : ") << strName;
				if(f_id == true){
					_COUT	<< _T("(") << m_id << _T(")");
				}
				_COUT << endl;
			}
		case(3):
			code[1] = (unsigned char)((_addr     ) & 0xFF);
			code[2] = (unsigned char)((_addr >> 8) & 0xFF);
			break;
		case(4):
			code[2] = (unsigned char)((_addr     ) & 0xFF);
			code[3] = (unsigned char)((_addr >> 8) & 0xFF);
			break;
		default:
			_CERR << _T("mml_Address::set_Address()�֐��ŃG���[���������܂����B") << endl;
			nsc_exit(EXIT_FAILURE);
			break;
	}
	

}
void	mml_Address::set_AddressLabel( string _label)
{
	label = _label;

}
//==============================================================
//		�A�h���X�̎擾
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
/*
size_t	mml_Address::get_Address(void)
{
	size_t	i;

	switch(iSize){
		case(3):
			i = (unsigned char)code[1] + ((unsigned char)code[2]<<8);
			break;
		case(4):
			i = (unsigned char)code[2] + ((unsigned char)code[3]<<8);
			break;
		default:
			_CERR << _T("mml_Address::set_Address()�֐��ŃG���[���������܂����B") << endl;
			nsc_exit(EXIT_FAILURE);
			break;
	}
	if (i & 0x8000){
		i |= 0xFFFF0000;
	}
	return(i);
}
*/



