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
	BGM(MMLfile* MML, const char _strName[] = "==== [ BGM ]====");
	~BGM(void);
};
