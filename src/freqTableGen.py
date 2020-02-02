from pathlib import Path
import argparse
import re


def tableTxtGen(freqA,freqType,outPath):

	clock = 1789773

	freqC = 1.189206818181 * freqA

	tableTxt = ""

	if freqType=="apu":
		octDiv = 96
		for i in range(octDiv+1):
			freq = round( clock / freqCalc(freqC,octDiv,i) )
			tableTxt += "	.word	"+"$"+f"{freq:04x}" + "\n"


	elif freqType=="fds":
		octDiv = 96
		mod = 0
		for i in range(octDiv+1):
			freq = round( (freqCalc(freqC,octDiv,i) * 65536 / clock) * 128 )
			tableTxt += "	.word	"+"$"+f"{freq:04x}" + "\n"

	elif freqType=="vrc6":
		octDiv = 96
		for i in range(octDiv+1):
			freq = round( (clock / (14 * (freqCalc(freqC,octDiv,i))) -1) * 16)
			tableTxt += "	.word	"+"$"+f"{freq:04x}" + "\n"


	elif freqType=="vrc7":
		octDiv = 96
		mod = 0
		for i in range(octDiv+1):
			freq = round((freqCalc(freqC,octDiv,i)* 2 ** 19 / (49716*32)))
			modRec = mod
			mod = freq // 0x100
			if mod!=modRec:
				tableTxt += f"Freq_VRC7_Carry_{mod-1:02}:\n"

			tableTxt += "	.byte	"+"$"+f"{freq&0xff:02x}" + "\n"


	elif freqType=="n163":
		octDiv = 192
		mod = 0
		for i in range(octDiv):
			freq = round(( (freqCalc(freqC,octDiv,i) * (15 * 65536 )) / clock) * 512 )
			modRec = mod
			mod = freq // 0x10000 - 2
			if mod!=modRec:
				tableTxt += f"Freq_N163_Carry_{mod-1:02}:\n"

			tableTxt += "	.word	"+"$"+f"{freq&0xffff:04x}" + "\n"




	with open(outPath, mode='w') as f:
		f.write(tableTxt)


def freqCalc(baseFreq,div,offset):
	return baseFreq * (2 ** (offset/div))

def main():
	# パーサーを作る
	parser =	argparse.ArgumentParser(
				prog=__file__, # プログラム名
				usage="%(prog)s [options]", # プログラムの利用方法
#				formatter_class=argparse.ArgumentDefaultsHelpFormatter,
#				description='description', # 引数のヘルプの前に表示
#				epilog='end', # 引数のヘルプの後で表示
				add_help=True, # -h/–help オプションの追加
				)

	# 引数の追加
	parser.add_argument(	'-o', '--outFile', #help='output file name',
							required=True)

	parser.add_argument(	'-f', '--freq', #help='output file name',
							required=True, type=float)


	# 引数を解析する
	args = parser.parse_args()

	outDir = Path(args.outFile)

	freqA = args.freq

	dictOfFileName = {	"apu":"freqTableApu.inc",
						"fds":"freqTableFds.inc",
						"vrc6":"freqTableVrc6.inc",
						"vrc7":"freqTableVrc7.inc",
						"n163":"freqTableN163.inc",
	}


	for i in dictOfFileName.items():
		tableTxtGen(freqA,i[0],outDir / Path(i[1]))

	return


if __name__ == "__main__":
	main()
