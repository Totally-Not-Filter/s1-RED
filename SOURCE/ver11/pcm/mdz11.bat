:=======================================================:
:	    $$$Z.BAT  (Sound PCM Control Batch File)	:
:  			ORG. MDDR11.SRC			:
:		'Sound-Source'				:
:		 for Mega Drive (68K)			:
:			Ver  1.1 / 1990.9.1		:
:				      By  H.Kubota	:
:=======================================================:

echo off

if "%1"=="a" goto asm
if "%1"=="A" goto asm
if "%1"=="z" goto ice
if "%1"=="Z" goto ice
if "%1"=="d" goto loaddrum
if "%1"=="D" goto loaddrum
if "%1"=="v" goto loadvoice
if "%1"=="V" goto loadvoice
	goto usage

:asm
	make -f mdZ11.MKF pcm
	goto end
:hhh
	echo/
	echo ***************  mdDR11.HEX �� mdDR11.HHH  ***************
	chrx mdDR11.hex
	echo/
	echo ***************  mdVT11.HEX �� mdVT11.HHH  ***************
	chrx mdVT11.hex
	goto end
:ice
:	ZICE mdZZ11.BAT -C A:\SYS\Z80\ZICEZ80
:	ICEZM
	goto end
:loaddrum
	icd_ldr mdDR11.hex
	goto end
:loadvoice
	icd_ldr mdVT11.hex
	goto end
:usage
	echo %0 �R�}���h�̎g�p���@
	echo �@%0 [�I�v�V����]
	echo   �I�v�V�����̎�ނ͎��̒ʂ�ł��B�i�������ł��\���܂���j
	echo       A : �o�b�l�̃t�@�C�����쐬
	echo       Z : �y�W�O�̂h�b�d���N��
	echo       D : �o�b�l�h�����t�@�C����]������
	echo       V : �o�b�l�u���������t�@�C����]������

:end
