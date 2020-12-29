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
class MetaItem
{
//�����o�[�ϐ�
protected:
	const		char*		m_identifier;		//�I�u�W�F�N�g�̖���
				size_t		m_size;				//Chunk�̃T�C�Y
				string		m_data;				//����
	list<MetaItem*>			ptcItem;			//�\����
				size_t		m_offset;			//SND�t�@�C���|�C���^

//�����o�[�֐�
public:
				MetaItem(const char m_identifier[]="");
	virtual		~MetaItem(void);

				void	clear(void);
				size_t	getSize();
				size_t	getOffset();
				size_t	SetOffset(size_t _offset);

				void	setItem(MetaItem* _item);
				void	setItem_front(MetaItem* _item);

	unsigned	char	getData(size_t n);
	virtual		size_t	getData(string* _str);
	virtual		void	getMetaData(string* _str);
	virtual		void	setMetaData(string* _str);
				void	push_back(char _ch);
				void	append(string* _str);
				void	append(int _i);
};
