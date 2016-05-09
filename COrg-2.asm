; Programmer:		Joe Waller
;
; Module:		COrg-2.asm
;
; Due Date:		Thursday, January 30, 2003
;
; Description:		This program demostrates the use of macros is NASM.
;			An expanation of each of the three macros
;			CONCAT, CLRREGS, SHOWINT is provided before
;			the macro code.  The main program demostrates a
;			use of each of these macros

%include "/home/class/csci2093/iomacros.inc"

;---------------------------------------------------------
; macro that will concatinate string parameters 1 and 2
; into parameter 3 || LOB stands for Low Order Byte
;---------------------------------------------------------

%macro CONCAT 3
			push	EDX		; to save context
			push	EDI
			push	ESI
			push	EBX
			push	ECX
			mov	ECX, 0		; counter for %2 array (j)
			mov	EDI, 0		; counter for %1 array (i)
			mov	ESI, 0		; counter for %3 array
			mov	EDX, 0		; char buffer
			mov	EBX, %3		; pointer to %3
	%%bloop:
			mov	DL, [%1+EDI]	  ; move str1[i] to EDX LOB
			mov	[EBX+ESI], DL	  ; move it to %3
			cmp	byte [EBX+ESI], 0 ; check if NULL
			je	%%bloopy	  ; if NULL start work on
			inc	ESI		  ; str2
			inc	EDI		  ; else continue processing
			jmp	%%bloop		  ; str1
	%%bloopy:
			mov	DL, [%2+ECX]	  ; move str2[j] to EDX LOB
			mov	[EBX+ESI], DL	  ; move it to %3
			cmp	byte [EBX+ESI], 0 ; if its NULL the we are done
			je	%%done		  ; else continue processing
			inc	ESI		  ; str2
			inc	ECX
			jmp	%%bloopy
	
	%%done:
			pop	ECX		  ; to save context
			pop	EBX
			pop	ESI
			pop	EDI
			pop	EDX
%endmacro					  ; end macro CONCAT

;---------------------------------------------------------
; macro that will clear the registers that are passed to it
;---------------------------------------------------------

%macro CLRREGS 1-*	; must have more than one parameter
  %if (%0 > 0)		; will throw error at compile time if it doesn't
    %rep %0		
      %ifidni		%1, EAX		; if param is EAX (case insensitive)
		mov	EAX, 0
      %elifidni		%1, EBX		; if param is EBX
		mov	EBX, 0
      %elifidni		%1, ECX		; and so on
		mov	ECX, 0
      %elifidni		%1, EDX		; and so forth
		mov	EDX, 0
      %elifidni		%1, EDI
		mov	EDI, 0
      %elifidni		%1, ESI
		mov	ESI, 0
      %else
        %error Invalid parameter(s)	; if it is not one of those 6 registers
      %endif
      %rotate 1				; rotate to next paramter
    %endrep
  %else
    %error Invalid number of parameters	; if there are no parameters
  %endif
%endmacro				; end macro CLRREGS

;---------------------------------------------------------
; macro that will accept parameters and display
; them as dword ints
;---------------------------------------------------------

%macro SHOWINT 1-*
  %if %0 == 0				; if params throw error
    %error Invalid number of parameters
  %else
    %rep %0
		put_i	%1		; display as int
		put_str endl
      %rotate 1				; shift params 1
    %endrep
  %endif
%endmacro				; end macro SHOWINT

;---------------------------------------------------------
; macro to do all that end program stuff
;---------------------------------------------------------

%macro ENDPROG 0
  mov	EBX,0
  mov	EAX,1
  int	80h
%endmacro

;---------------------------------------------------------
section .data

		demo_end	db	"------------------------------------",0
		str1_is		db	"str1 is: ",0
		str2_is		db	"str2 is: ",0
		strFinal_is	db	"str_final is: ",0
		endl		db	0AH,0
		str1		db	"I like to ",0
		str2		db	"concatenate strings.", 0
		eax_is		db	"EAX is: ",0
		ebx_is		db	"EBX is: ",0
		ecx_is		db	"ECX is: ",0
		edx_is		db	"EDX is: ",0
		edi_is		db	"EDI is: ",0
		esi_is		db	"ESI is: ",0
		concat_call	db	"CONCAT str1, str2, final_str",0
		clrreg_call	db	"CLRREGS EBX, ECX, EDI",0
		demo_1		db	"Macro #1 Demo.",0
		demo_2		db	"Macro #2 Demo.",0
		demo_3		db	"Macro #3 Demo.",0
showint_call	db	"SHOWINT EAX, EDI, [a], endl, EBX, ECX, ESI, EDX",0
		

;---------------------------------------------------------
section .bss

		a		resd	1
		final_str	resb	200

;---------------------------------------------------------
section .text

		global	main

main:
		put_str demo_1		; start the demo
		put_str	endl		; for macro #1
		put_str	endl
		put_str	str1_is
		put_str	str1
		put_str endl
		put_str str2_is
		put_str str2
		put_str endl
		put_str	endl
		put_str concat_call
		put_str endl
		put_str endl

		CONCAT	str1, str2, final_str

		put_str strFinal_is
		put_str final_str
		put_str	endl
		put_str endl
		put_str	demo_end
		put_str endl

		put_str demo_2		; start the demo
		put_str	endl		; for macro #2
		put_str endl
		mov	EBX, 124
		mov	ECX, 23
		mov	EDX, 17
		mov	EDI, 8
		mov	ESI, 25476

		put_str	ebx_is
		put_i	EBX
		put_str	endl
		put_str	ecx_is
		put_i	ECX
		put_str	endl
		put_str	edx_is
		put_i	EDX
		put_str	endl
		put_str	edi_is
		put_i	EDI
		put_str	endl
		put_str	esi_is
		put_i	ESI
		put_str	endl

		CLRREGS	EBX, ECX, EDI	; clear registers
		put_str endl		; EBX, ECX, EDI
		put_str clrreg_call	; didn't use EAX because
		put_str endl		; iomacros kept changing it
		put_str endl		; to 8 <-- length of str?

		put_str	ebx_is
		put_i	EBX
		put_str	endl
		put_str	ecx_is
		put_i	ECX
		put_str	endl
		put_str	edx_is
		put_i	EDX
		put_str	endl
		put_str	edi_is
		put_i	EDI
		put_str	endl
		put_str	esi_is
		put_i	ESI
		put_str	endl
		put_str endl
		put_str demo_end
		put_str endl

		put_str demo_3		; start the demo
		put_str endl		; for macro #3
		put_str endl
		mov 	dword [a], 5
		put_str	showint_call
		put_str endl
		put_str	endl
		SHOWINT EAX, EDI, [a], endl, EBX, ECX, ESI, EDX

		ENDPROG
end
