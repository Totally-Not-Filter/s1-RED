;=======================================================;
;	    $$$PCM.ASM  (Sound PCM 68K File)		;
;  			ORG. MDPCM11.ASM		;
;		'Sound-Source'				;
;		 for Mega Drive (68K)			;
;			Ver  1.1 / 1990.9.1		;
;				      By  H.Kubota	;
;=======================================================;

	public	pcm_top,pcm_end

;=======================================;
;	      INCLUDE FILE		;
;=======================================;
pcm_top	equ	$
	include	pcm\mdDR11.HHH
pcm_end	equ	$

