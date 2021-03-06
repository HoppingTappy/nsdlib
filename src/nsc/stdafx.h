/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

// stdafx.h : 標準のシステム インクルード ファイルのインクルード ファイル、または
// 参照回数が多く、かつあまり変更されない、プロジェクト専用のインクルード ファイル
// を記述します。
//

#pragma once
//#define		segmentOutput
#define _CRT_SECURE_NO_WARNINGS

#ifdef	_UNICODE
	#define	_CHAR	wchar_t
	#define _T(x)	L ## x
	#define _EOF	WEOF
	#define	_COUT	wcout
	#define	_CERR	wcerr
#else
	#define	_CHAR	char
	#define _T(x)	x
	#define _EOF	EOF
	#define	_COUT	cout
	#define	_CERR	cerr
#endif

#ifdef	_WIN32
	#include <locale>
	#define _PATH_SPLIT	';'	// MS系は ;
#else
	#include <locale.h>
	#define _PATH_SPLIT	':'	// UNIX系は :
#endif


#include <errno.h>
#include <stdlib.h>
#include <string.h>
//#include <tchar.h>

#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <list>
#include <map>

#include <iomanip>

/****************************************************************/
/*			プロトタイプ										*/
/****************************************************************/

void nsc_exit(int no);

using namespace std;

class	MusicHeader;
class	MusicFile;
class	MMLfile;
class	Sub;

typedef struct {
	const char*	str;
	int			id;
} Command_Info;

#include "SearchPass.h"			//検索パス

#include "FileInput.h"			//ファイル入力用
#include "FileOutput.h"			//ファイル出力用

#include "Option.h"				//オプション

#include "MusicItem.h"

#include "Patch.h"

#include "FDSC.h"
#include "FDSM.h"
#include "VRC7.h"
#include "N163.h"

#include "DPCM.h"
#include "DPCMinfo.h"

#include "Envelop.h"

#include "MusicEvent.h"			//各イベント
#include "mml_general.h"		//汎用
#include "mml_repeat.h"			//汎用
#include "mml_poke.h"			//メモリ書き込み
#include "mml_note.h"			//音符・休符
#include "mml_Address.h"
#include "mml_CallSub.h"

#include "NSF_Header.h"			//ヘッダー

#include "MetaItem.h"
#include "Meta_INFO.h"			//2.1	INFO	NSFe MUST
#include "Meta_DATA.h"			//2.2	DATA	NSFe MUST
#include "Meta_NEND.h"			//2.3	NEND	NSFe MUST
#include "Meta_BANK.h"			//2.4	BANK	NSFe optional / NSF MUSTNOT
#include "Meta_NSF2.h"			//2.6	NSF2	NSFe optional /  NSF MUSTNOT
#include "Meta_VRC7.h"			//2.7	VRC7
#include "Meta_plst.h"			//2.8	plst
#include "Meta_psfx.h"			//2.9	psfx
#include "Meta_time.h"			//2.10	time
#include "Meta_fade.h"			//2.11	fade
#include "Meta_tlbl.h"			//2.12	tlbl
#include "Meta_taut.h"			//2.13	taut
#include "Meta_auth.h"			//2.14	auth
#include "Meta_text.h"			//2.15	text
#include "Meta_mixe.h"			//2.16	mixe

#include "MusicHeader.h"		//ヘッダー

#include "nsd_work.h"
#include "MusicNote.h"
#include "MusicTrack.h"			//トラック情報
#include "TrackSet.h"
#include "BGM.h"
#include "SE.h"
#include "Sub.h"

#include "MMLfile.h"		//MMLファイル
#include "MusicFile.h"		//SNDファイル

// TODO: プログラムに必要な追加ヘッダーをここで参照してください。
