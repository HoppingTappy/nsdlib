/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#include "StdAfx.h"
#include "MusicItem.h"

/****************************************************************/
/*					�O���[�o���ϐ��i�N���X�����ǁE�E�E�j		*/
/****************************************************************/
extern	OPSW*			cOptionSW;	//�I�v�V�������ւ̃|�C���^�ϐ�

//==============================================================
//		�R���X�g���N�^
//--------------------------------------------------------------
//	������
//		const		_CHAR	_strName[]	�I�u�W�F�N�g��
//	���Ԓl
//				����
//==============================================================
MusicItem::MusicItem(const _CHAR _strName[]):
	strName(_strName),
	iSize(0),
	iOffset(0),
	f_id(false),
	f_necessary(false)
{
	//Debug message�@�i���������o�͂���̂Œ��ӁB�j
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
	//Debug message�@�i���������o�͂���̂Œ��ӁB�j
	if(cOptionSW->iDebug & DEBUG_Create){
		_COUT << _T("Create Music Object : ") << strName << _T("(");
		cout << m_id;
		_COUT << _T(")") << endl;
	}
}

//==============================================================
//		�f�X�g���N�^
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
MusicItem::~MusicItem(void)
{
	clear();

	//Debug message�@�i���������o�͂���̂Œ��ӁB�j
	if(cOptionSW->iDebug & DEBUG_Delete){
		_COUT << _T("Delete Music Object : ") << strName;
		if(f_id == true){
			_COUT << _T("(") << m_id << _T(")");
		}
		_COUT << endl;
	}
}

//==============================================================
//		�N���A
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//				����
//==============================================================
void	MusicItem::clear(void)
{
	//----------------------
	//Local�ϐ�
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
	//Local�ϐ�
	list<	MusicItem*>::iterator	itItem;

	if(chkUse() == false){
		//----------------------
		//���̃I�u�W�F�N�g���ƁA��������N���A����B
		//Debug message�@�i���������o�͂���̂Œ��ӁB�j
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
		//�q�I�u�W�F�N�g���œK�����邩�]������B
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
//		�R�[�h�T�C�Y�̎擾
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//		size_t
//==============================================================
size_t		MusicItem::getSize()
{
	return(iSize);
}

//==============================================================
//		�R�[�h�̃I�t�Z�b�g�A�h���X�̎擾
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//		unsigned	int	
//==============================================================
size_t	MusicItem::getOffset()
{
	return(iOffset);
}

//==============================================================
//		�I�t�Z�b�g�A�h���X�̐ݒ�
//--------------------------------------------------------------
//	������
//		size_t	_offset
//	���Ԓl
//				����
//==============================================================
size_t	MusicItem::SetOffset(size_t _offset)
{
	//----------------------
	//Local�ϐ�
	list<	MusicItem*>::iterator	itItem;
	size_t	i = 0;

	//Debug message�@�i���������o�͂���̂Œ��ӁB�j
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

	//���̃I�u�W�F�N�g�̃T�C�Y�i�œK����j
	iSize = _offset - iOffset;

	return(_offset);
}

//==============================================================
//		�R�[�h�̎擾
//--------------------------------------------------------------
//	������
//		unsigned	int	n	�Y����
//	���Ԓl
//		unsigned	char	���e
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
//		�R�[�h�̎擾
//--------------------------------------------------------------
//	������
//		string*		_str
//	���Ԓl
//				����
//==============================================================
void	MusicItem::getCode(string* _str)
{
	//----------------------
	//Local�ϐ�
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
//		�R�[�h�̐ݒ�
//--------------------------------------------------------------
//	������
//		string*		_str
//	���Ԓl
//				����
//==============================================================
void	MusicItem::setCode(string* _str)
{
	code.clear();
	code.assign(*_str);
	iSize = code.size();
}

//==============================================================
//		�R�[�h�̎擾
//--------------------------------------------------------------
//	������
//		MusicFile*	MUS		�R�[�h���o�͂���ȃf�[�^�t�@�C���E�I�u�W�F�N�g
//	���Ԓl
//				����
//==============================================================
void	MusicItem::getAsm(MusicFile* MUS)
{
	//----------------------
	//Local�ϐ�
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
//		id�̐ݒ�
//--------------------------------------------------------------
//	������
//		size_t	_id		�ԍ�
//	���Ԓl
//				����
//==============================================================
void	MusicItem::set_id(size_t _id)
{
	f_id = true;
	m_id = _id;
}

//==============================================================
//		id�̎擾
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//		unsigned	int		�ԍ�
//==============================================================
size_t	MusicItem::get_id(void)
{
	return(m_id);
}
//==============================================================
//		flag�̎擾
//--------------------------------------------------------------
//	������
//				����
//	���Ԓl
//		unsigned	int		�ԍ�
//==============================================================
bool	MusicItem::get_flag(void)
{
	return(f_id);
}
