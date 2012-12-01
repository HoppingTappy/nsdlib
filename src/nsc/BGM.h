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
	BGM(MMLfile* MML, unsigned int _id, const wchar_t _strName[] = L"==== [ BGM ]====");
	~BGM(void);
	void	getAsm(MusicFile* MUS);
};
