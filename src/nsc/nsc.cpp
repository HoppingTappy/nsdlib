// nsc.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include "stdafx.h"

/****************************************************************/
/*					グローバル									*/
/****************************************************************/
		OPSW*			cOptionSW;	//どっからでもアクセスする。

//==============================================================
//		メイン関数
//--------------------------------------------------------------
//	●引数
//		int		argc	コマンドライン引数	
//		_TCHAR*	argv[]	コマンドライン引数
//	●返値
//		int			エラーコード
//==============================================================
int	__cdecl	_tmain(int argc, _TCHAR* argv[])
{
	unsigned	int	i;

	//==================================
	//クラスの作成
	cOptionSW	= new OPSW(argc,argv);							//オプション処理
	if(cOptionSW->cDebug & 0x01){
		cout << "\n============ [ 1st phase : Create Object ] ============\n" << endl;
	}
	MMLfile*	cMML		= new MMLfile(cOptionSW->strMMLname.c_str());
	MusicFile*	cSND		= new MusicFile(cMML, cOptionSW->strCodeName);

	//==================================
	//アドレスの解決
	if(cOptionSW->cDebug & 0x02){
		cout << "\n============ [ 2nd phase : Address Setting ] ============\n" << endl;
	}
	i = cSND->SetOffset(0);
	cout << "Music Size = " << i << endl;
	i = cSND->SetDPCMOffset();
	cout << "DPCM Size = " << i << endl;

	cSND->Fix_Address();

	//==================================
	//保存
	if(cOptionSW->saveNSF == true){
		cSND->saveNSF(cOptionSW->strNSFname.c_str(), cOptionSW->opt);
	}

	if(cOptionSW->saveASM == true){
		cSND->saveASM(cOptionSW->strASMname.c_str());
	}


	//==================================
	//クラスの削除
	delete	cSND;
	delete	cMML;
	delete	cOptionSW;

	return(0);
}
