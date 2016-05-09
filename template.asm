%include "/home/class/csci2093/iomacros.inc"

;---------------------------------------------------------
; macro to close program ---------------------------------
;---------------------------------------------------------
%macro	ENDPROG		1
	mov	ebx, %1
	mov	eax, 1
	int	80h
%endmacro

;---------------------------------------------------------
section .data

	yo		db	"Yoyoyo",0

;---------------------------------------------------------
section .bss

;---------------------------------------------------------
section .text

		global	_start

_start:
		cmp	esp, 3
		je	hello
		jmp	done

hello:		
		put_str	yo
done:
		ENDPROG	1
