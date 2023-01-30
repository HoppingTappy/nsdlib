from pathlib import Path
import argparse
import re


def tableTxtGen(freqA,freqType,outPath,isPal=False):

	clock = 1789773

	if isPal:
		clock = 1662607

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
	parser = argparse.ArgumentParser()
	parser.add_argument(	"-o", "--outDir", required=True)
	parser.add_argument(	"-f", "--freq", required=True, type=float)
	args = parser.parse_args()

	outDir = Path(args.outDir)

	freqA = args.freq

	dataList = [
		["apu",  "freqTableApu.inc",  False],
		["fds",  "freqTableFds.inc",  False],
		["vrc6", "freqTableVrc6.inc", False],
		["vrc7", "freqTableVrc7.inc", False],
		["n163", "freqTableN163.inc", False],
		["apu",  "freqTablePalApu.inc",  True],
#		["fds",  "freqTablePalFds.inc",  True],
#		["vrc6", "freqTablePalVrc6.inc", True],
#		["vrc7", "freqTablePalVrc7.inc", True],
#		["n163", "freqTablePalN163.inc", True],
	]


	for data in dataList:
		tableTxtGen(freqA,data[0],outDir / Path(data[1]), data[2])
		tableTxtGen(freqA,data[0],outDir / Path(data[1]), data[2])

	return


if __name__ == "__main__":
	main()
