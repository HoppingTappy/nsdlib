#pragma once
#include "MusicItem.h"

/****************************************************************/
/*																*/
/*			�N���X��`											*/
/*																*/
/****************************************************************/
class DPCM :
	public MusicItem
{
//�����o�[�ϐ�
private:
	unsigned	int		m_id;
	unsigned	char	_DPCM_size;
//static	const	Command_Info	Command[];	//�R�}���h�̏��

//�����o�[�֐�
public:
				DPCM(FileInput* DPCMfile, unsigned int _id, const char _strName[] = "==== [ DPCM ]====");
				~DPCM(void);
	unsigned	char	getDPCMsize(void){return(_DPCM_size);};
				void	getAsm(MusicFile* MUS);
};