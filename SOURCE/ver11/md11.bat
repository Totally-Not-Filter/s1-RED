:=======================================================:
:	    $$$.BAT  (Sound Control Batch File)		:
:			ORG. MD11.BAT			:
:		'Sound-Source'				:
:		 for Mega Drive (68K)			:
:			Ver  1.1 / 1990.9.1		:
:				      By  H.Kubota	:
:=======================================================:

echo off

if "%1"=="A" goto asm
if "%1"=="a" goto asm
if "%1"=="B" goto bnk
if "%1"=="b" goto bnk
if "%1"=="v" goto voice
if "%1"=="V" goto voice
if "%1"=="Z" goto ice
if "%1"=="z" goto ice

if "%1"=="BL" goto bnklnk
if "%1"=="bl" goto bnklnk
if "%1"=="PRG" goto prg
if "%1"=="prg" goto prg
if "%1"=="BK" goto bkup
if "%1"=="bk" goto bkup

if "%1"=="c" goto loadcnt
if "%1"=="C" goto loadcnt
if "%1"=="S" goto loadsng
if "%1"=="s" goto loadsng
if "%1"=="SE" goto loadse
if "%1"=="se" goto loadse
if "%1"=="L" goto loadall
if "%1"=="l" goto loadall
if "%1"=="BS" goto loadbnk
if "%1"=="bs" goto loadbnk
if "%1"=="vs" goto loadvoice
if "%1"=="VS" goto loadvoice
if "%1"=="d" goto loaddrum
if "%1"=="D" goto loaddrum
	goto	usage

:asm
	make -f md11.MKF song
	goto end
:voice
	make -f md11.MKF voice
	goto end
:bnk
	make -f md11.MKF bank
:bnklnk
	echo/
	echo ****************  Link �� Bank S28 File Making  ****************
	l68 all
	echo *******************  Bank Event File Making  *******************
	cf -zb mdBNK11.sym mdBNK11.evt
:lib
	echo/
	echo ******************  Sound Address File Making  ******************
	grep -h sound mdBNK11.evt > temp
	grep -h pcm mdBNK11.evt >> temp
	sed -e s/.*:" "// -e s/" "/\tequ\t/ temp > mdSOUND.LIB
	del temp
	echo/
	echo/
	echo *****  mdSOUND.LIB  *****
	type	mdSOUND.lib
	goto end
:bkup
	ud -v *.asm B:\
	ud -v *.bat B:\
	ud -v *.def B:\
	ud -v *.doc B:\
	ud -v *.lib B:\
	ud -v *.lnk B:\
	ud -v *.mac B:\
	ud -v *.mcr B:\
	ud -v *.mkf B:\
	ud -v *.s B:\
	goto end
:prg
	echo/
	echo �@�v���O���}�[�ɓn���t�@�C�����a�h���C�u�փR�s�[���܂��B
	echo/
	echo *  mdBNK11.S28 �� B:\SOUND.S28
	copy  mdBNK11.S28 B:\SOUND.S28 > nul
	echo/
	echo *  mdSOUND.LIB �� B:\SOUND.LIB
	copy mdSOUND.LIB B:\SOUND.LIB > nul
	echo/
	echo *  md11.DOC    �� B:\SOUND.DOC
	copy md11.DOC B:\SOUND.DOC > nul
	echo/
	echo *  mdVDT11.S28 �� B:\VOICE.S28
	copy mdVDT11.S28 B:\VOICE.S28 > nul
	goto end
:loadcnt
	command /c icd_ldr mdCNT11.S28
	goto end
:loadsng
	command /c icd_ldr mdSNG11.S28
	goto end
:loadse
	command /c icd_ldr mdSE11.S28
	goto end
:loadall
	command /c icd_ldr mdCNT11.S28
	command /c icd_ldr mdSNG11.S28
	command /c icd_ldr mdSE11.S28
	goto end
:loadbnk
	command /c icd_ldr mdBNK11.S28
	goto end
:loadvoice
	command /c icd_ldr mdVDT11.S28
	goto end
:loaddrum
	command /c icd_ldr pcm\mdDR11.hex
	goto end
:ice
	erx68k z
	goto end
:usage
	echo %0 �R�}���h�̎g�p���@
	echo �@%0 [�I�v�V����]
	echo   �I�v�V�����̎�ނ͎��̒ʂ�ł��B�i�������ł��\���܂���j
	echo       A : �J���p�̃t�@�C�����쐬�imdCNT11.S28 mdSNG11.S28 mdSE11.S28�j
	echo       B : �v���O���}�[�p�̃t�@�C�����쐬�imdBNK11.S28�j
	echo       V : �u�n�h�b�d�̃t�@�C�����쐬�imdVDT11.S28�j
	echo       Z : �U�W�O�O�O�̂h�b�d���N��
	echo      BL : �v���O���}�[�p�̃t�@�C�����쐬�i�����N�̂ݍs���j
	echo     PRG : �v���O���}�[�p�̃t�@�C�����a�h���C�u�փR�s�[
	echo      BK : �a�h���C�u�Ƀo�b�N�A�b�v���Ƃ�
	echo       C : �R���g���[���t�@�C����]������
	echo       S : �r�n�m�f�t�@�C����]������
	echo      SE : �r�D�d�t�@�C����]������
	echo       L : �R���g���[���A�r�n�m�f�A�r�D�d�t�@�C����]������
	echo      BS : �v���O���}�[�p�t�@�C����]������
	echo      VS : �u�n�h�b�d�̃t�@�C����]������
	echo       D : �o�b�l�h�����t�@�C����]������

:end

