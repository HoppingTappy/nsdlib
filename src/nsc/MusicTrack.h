/*******************************************************************************

			NES Sound Driver & Library	(NSD.lib)	MML Compiler

	Copyright (c) 2012 A.Watanabe (S.W.), All rights reserved.
	 For conditions of distribution and use, see copyright notice in "nsc.cpp".

*******************************************************************************/

#pragma once

/****************************************************************/
/*																*/
/*			クラス定義											*/
/*																*/
/****************************************************************/
class MusicTrack :
	public MusicItem
{
//メンバー変数
public:
	//----------------------------------
	//音源ドライバ　シミュレート用WORK
	NSD_WORK	nsd;

private:
	//----------------------------------
	//Tick カウント用
				int		iTickTotal;
				int		iTickLoop;

	//----------------------------------
	//コンパイル制御
				size_t	offset_now;				//現在のオフセット
				bool	compile_flag;			//現在コンパイル中？

				bool	jump_flag;				// J

	//----------------------------------
	//音長
				int		opt_DefaultLength;		//音長省略時の処理用

	//----------------------------------
	//クオンタイズ
				int		QMax;					//QMax
				int		gatetime_q;				//q
				int		gatetime_Q;				//Q

	//----------------------------------
	//ノート
	mml_note*			_old_note;

	//----------------------------------
	//調号制御用
				char	KeySignature[8];		//調号(c,d,e,f,g,a,b,r)
				char	nowKey;					//現在の調
				char	nowScale;				//現在のスケール（モード）
				
	//----------------------------------
	//移調
				int		iKeyShift;				//k (コンパイラレベル)

	//----------------------------------
	//疑似エコー
				bool	echo_already;			//既に生成したか？
				bool	echo_vol_ret;			//エコーの音量を元に戻したか？

				bool	echo_flag;				//疑似エコー フラグ
				bool	echo_slur;				//疑似エコー スラーでつなげる？
				int		echo_length;			//疑似エコー 長さ
	unsigned	char	echo_volume;			//疑似エコー 音量
	unsigned	char	echo_value;				//疑似エコー 何前？
				char	oldNote[256];			//疑似エコー用リングバッファ
	unsigned	char	pt_oldNote;				//疑似エコー用リングバッファ　ポインタ

	//----------------------------------
	//
				bool	disableKeyOn;			//キーオン無効状態

	//----------------------------------
	//パッチ
				bool	f_Patch;				//パッチ処理中？
	unsigned	int		i_Patch;

	//----------------------------------
	//無限ループ・リピート関係

				bool	is_loop;				//	L	コマンド出現したか？
				bool	is_repeat_a_s;			//	[	コマンドが出現したか？
				bool	is_repeat_a_b;			//	:	コマンドが出現したか？
				bool	is_repeat_b_s;			//	|:	コマンドが出現したか？
				bool	is_repeat_b_b;			//	\	コマンドが出現したか？
				int		count_repeat_a;
	mml_repeat*			_old_repeat;

			vector<	int			>			repeat_type;		//どのリピートを使っているか？
			vector<	int			>::iterator	it_repeat_type;

	//To control of the Repert(C)
			unsigned	int								sp_repeat_c;		//スタックポインタ（ネスト）
	list<	unsigned	int				>				st_ct_repeat_c;		//リピート回数
	list<	list<	MusicItem*>::iterator>				st_it_repeat_c_s;	//リピート開始点
	list<	list<	MusicItem*>::iterator>				st_it_repeat_c_b;	//リピート分岐点
	list<	list<	MusicItem*>::iterator>				st_it_repeat_c_e;	//リピート終了点
	list<	unsigned	int				>::iterator		it_ct_repeat_c;
	list<	list<	MusicItem*>::iterator>::iterator	it_it_repeat_c_s;
	list<	list<	MusicItem*>::iterator>::iterator	it_it_repeat_c_b;
	list<	list<	MusicItem*>::iterator>::iterator	it_it_repeat_c_e;

	//----------------------------------
	//オブジェクト

	//アドレス情報を持つイベントオブジェクトのポインタの一覧
	vector<	mml_Address*	>	vec_ptc_FDSC;		//FDS Carrer
	vector<	mml_Address*	>	vec_ptc_FDSM;		//FDS Modlator
	vector<	mml_Address*	>	vec_ptc_OPLL;		//VRC7, OPLL
	vector<	mml_Address*	>	vec_ptc_Wave;		//N163
	vector<	mml_Address*	>	vec_ptc_SE;			//効果音コマンド一覧
	vector<	mml_Address*	>	vec_ptc_Sub;		//サブルーチンコマンド一覧
	vector<	mml_Address*	>	vec_ptc_Env;		//エンベロープコマンド一覧

	vector<	mml_Address*	>	vec_ptc_Loop_End;			//End of Track with LOOP
	vector<	mml_Address*	>	vec_ptc_Repert_A_End;		//Repert(A) End    poiont
	vector<	mml_Address*	>	vec_ptc_Repert_A_Branch;	//Repert(A) Branch poiont
	vector<	mml_Address*	>	vec_ptc_Repert_B_End;		//Repert(B) End    poiont

	//各ID番号毎の参照先するイベントオブジェクトのポインタの一覧
	map<	size_t, MusicEvent*	>	ptc_Loop;		//Loop
	map<	size_t, mml_repeat*	>	ptc_Repert_A;	//Repert(A) Start poiont
	map<	size_t, mml_Address*>	ptc_Repert_A_E;	//Repert(A) End   point
	map<	size_t, mml_repeat*	>	ptc_Repert_B;	//Repert(B) Start poiont

	//ID番号をどこまでふったか
			size_t	cnt_Loop;						// L コマンド
			size_t	cnt_Repert_A;					// [ コマンド
			size_t	cnt_Repert_B;					// |:コマンド


//メンバー関数
public:
			MusicTrack(size_t _id, MMLfile* MML, const _CHAR _strName[] = _T("---- [ Music Track ] ----"));
			~MusicTrack(void);

				int		TickCount(MusicFile* MUS, NSD_WORK* work);
				int		TickCount(MusicFile* MUS);
				void	TickCount_Envelope(MusicFile* MUS, mml_Address* adrObj, size_t _no);
				int		GetTickTotal(void){	return(iTickTotal);};
				int		GetTickLoop(void){	return(iTickLoop);};

				void	Fix_Address(MusicFile* MUS);
				void	SetEvent(MusicItem* _item);			//イベントの追加
				void	SetEvent_front(MusicItem* _item);	//イベントの追加

				//このトラックをコンパイルするかどうか
				bool	GetCompileFlag(void){return(compile_flag);};
				void	SetCompileFlag(bool _flag){compile_flag = _flag;};

				//----------------------------------
				//このトラックにだけ効くＭＭＬコマンド
				void	SetEnd(MMLfile* MML);			//記述ブロック終了
				void	SetLoop(MMLfile* MML);			//無限ループ

				void	SetRepeat_B_Start();
				void	SetRepeat_B_Branch(MMLfile* MML);
				void	SetRepeat_B_End(MMLfile* MML);

				void	SetEvent_Repeat_B_Start();
				void	SetEvent_Repeat_B_Branch();
				void	SetEvent_Repeat_B_End();

				void	SetRepeat_Start(MMLfile* MML);
				void	SetRepeat_End(MMLfile* MML);
				void	SetRepeat_Branch(MMLfile* MML);

				void	SetRepeat_A_Start(MMLfile* MML);
				void	SetRepeat_A_End(MMLfile* MML);

				void	SetEvent_Repeat_A_Start(unsigned char _cnt);
				void	SetEvent_Repeat_A_Branch();
				void	SetEvent_Repeat_A_End();

				void	SetRepeat_C_Start(MMLfile* MML);
				void	SetRepeat_C_End(MMLfile* MML);

				void	SetSE(MMLfile* MML);
				void	SetSubroutine(size_t _no);
				void	SetSubWithParch(size_t _no,bool _f);

				void	SetPatch(MMLfile* MML);	
				void	SetPatch();				//@P off
				void	CallPatch(MMLfile* MML, char _note);

				void	SetEnvelop_Evoi(size_t _no);
				void	SetEnvelop_Evol(size_t _no);
				void	SetEnvelop_Em(size_t _no);
				void	SetEnvelop_En(size_t _no);
				void	SetEnvelop_EN(size_t _no);
				void	SetVoice(int _no);				//E@ off
				void	SetEnvelop_Evol();				//Ev off
				void	SetEnvelop_Em();				//Em off
				void	SetEnvelop_En();				//En off
				void	SetEnvelop_EN();				//EN off

				void	SetEnvelop_Flag(MMLfile * MML);

				void	SetEnvelop_No_Sync_Evoi();
				void	SetEnvelop_No_Sync_Evol();
				void	SetEnvelop_No_Sync_En();
				void	SetEnvelop_No_Sync_Em();

				void	SetEnvelop_No_Sync_Off_Evoi();
				void	SetEnvelop_No_Sync_Off_Evol();
				void	SetEnvelop_No_Sync_Off_En();
				void	SetEnvelop_No_Sync_Off_Em();

				void	SetSweep(MMLfile* MML);
				void	SetSweep(unsigned char _c);

				void	SetGroove(MMLfile * MML, unsigned char iTempo);

				void	SetFDSC(MMLfile* MML);			//@FC
				void	SetFDSM(MMLfile* MML);			//@FM
				void	SetVRC7(MMLfile* MML);			//@V
				void	SetN163(MMLfile* MML);			//@N
				void	SetN163_Load(MMLfile* MML);		//@NL
				void	SetN163_Set(MMLfile* MML);		//@NS

				void	SetJump(MMLfile* MML);			//ジャンプ

				void	Set_q(int i);
				void	Set_u(int i);
				void	SetGatetime_Q(MMLfile* MML);
				void	SetGatetime(MMLfile* MML);
				void	SetGatetime_u(MMLfile* MML);

				void	SetReleaseMode(MMLfile* MML);
				void	SetReleaseVoice(MMLfile* MML);
				void	SetReleaseVolume(MMLfile* MML);

				void	SetKeyFlag(char _c, char _d, char _e, char _f, char _g, char _a, char _b);
				void	SetKey(int _key, int _scale);

				void	SetMajor();
				void	SetMinor();
				void	SetHMinor(MMLfile* MML);
				void	SetMMinor(MMLfile* MML);
				void	SetScale(MMLfile* MML);
				void	SetKeySignature(MMLfile* MML);	//調号の設定

				void	SetEcho(void);
				void	SetEcho(MMLfile* MML);
				void	SetEchoBuffer(MMLfile* MML,int note);
				void	ResetEcho();
				void	EchoVolRet();
				void	GenerateEcho(MMLfile* MML, int Length, int GateTime, bool	Slur);
				void	SetEnableKeyOn();
				void	SetDisableKeyOn();
				char	calc_note(MMLfile*	MML,int note);
				int		calc_length(MMLfile* MML);
				int		calc_gate(MMLfile* MML);
				bool	calc_slur(MMLfile* MML);
				void	SetNote(MMLfile* MML, int _key, int Length, int GateTime, bool Slur);
				void	SetNote(MMLfile* MML, int note);
				void	SetRest(MMLfile* MML, int mode);
				void	SetTai(MMLfile* MML);
				void	SetLength(MMLfile* MML);

				void	SetProtament(MMLfile* MML);
				void	SetProtament(MMLfile* MML, unsigned char iTempo);

				void	SetKeyShift(MMLfile* MML);
				void	SetKeyShift_Relative(MMLfile* MML);

				void	SetTranspose(int _no);
				void	SetTranspose_Relative(int _no);

				void	SetOctave(MMLfile* MML);
				void	SetOctaveInc();
				void	SetOctaveDec();
				void	SetOctaveOne_Inc();
				void	SetOctaveOne_Dec();
		
				void	SetVolume(MMLfile* MML);
				void	SetVolumeInc(MMLfile* MML);
				void	SetVolumeDec(MMLfile* MML);

				void	Set_Sign(MMLfile* MML);
				void	Set_Sign(int i);

				void	Reset_opt(void){
					//リピート終了時に、デフォルト音長情報をリセットする
					//分岐時に l コマンドがあった場合、その値から色々と計算してしまうため。
					opt_DefaultLength	= -1;
				}
};
