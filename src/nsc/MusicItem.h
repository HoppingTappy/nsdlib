/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#pragma once

/****************************************************************/
/*			�v���g�^�C�v										*/
/****************************************************************/
class	MusicFile;


/****************************************************************/
/*																*/
/*			�N���X��`											*/
/*																*/
/****************************************************************/
class MusicItem
{
//�����o�[�ϐ�
protected:
	const		_CHAR*		strName;		//�I�u�W�F�N�g�̖���
	list<MusicItem*>		ptcItem;		//�\����
				string		code;
				size_t		iSize;			//���̃I�u�W�F�N�g�̃o�C�i���T�C�Y
				size_t		iOffset;		//SND�t�@�C���|�C���^

				size_t		m_id;			//ID�ԍ�
				bool		f_id;			//ID�ԍ����Z�b�g���ꂽ��������flag

				bool		f_necessary;	//�œK���t���O
				string		label;

//�����o�[�֐�
public:
	MusicItem(const _CHAR _strName[]=_T(""));
	MusicItem(size_t _id, const _CHAR _strName[]=_T(""));
	~MusicItem(void);

				void	clear(void);
				void	clear_Optimize();
				size_t	getSize();
				size_t	getOffset();
				size_t	SetOffset(size_t _offset);

	unsigned	char	getCode(size_t n);
	virtual		void	getCode(string* _str);
	virtual		void	setCode(string* _str);
	virtual		void	getAsm(MusicFile* MUS);

				void	set_id(size_t _id);
				size_t	get_id(void);
				bool	get_flag(void);

				void	setUse(void){f_necessary = true;};	//�œK���F�s��
				bool	chkUse(void){return(f_necessary);};	//�œK���t���O�̎擾
};
