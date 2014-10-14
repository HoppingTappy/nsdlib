#pragma once
#include "trackset.h"

/****************************************************************/
/*																*/
/*			クラス定義											*/
/*																*/
/****************************************************************/
class BGM :
	public TrackSet
{
public:
	BGM(MMLfile* MML, unsigned int _id, const _CHAR _strName[] = _T("BGM"));
	~BGM(void);
	void	getAsm(MusicFile* MUS);
};
