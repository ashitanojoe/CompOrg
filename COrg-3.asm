;; Programmer	;	Joe Waller
;; Due Date	:	February 11, 2002
;; Descrption	:	Program will take two parameters from the
;;			command line (file names) and copy to first
;;			parameter (source) into the second parameter
;;			(destination).  Program uses system calls to
;;			accomplish this.
;;
;; Example Usage:	./a.out myfile.txt newfile.txt
;;			./a.out (source) (destination)
;;


%define	stdout		1
%define	stdin		2
%define missargs_len	18
%define	manyargs_len	19
%define	usage_len	51
%define	buf_size	1
%define fileerror_len	25
%define writeerror_len	31

;---------------------------------------------------------
; macro to close program ---------------------------------
;---------------------------------------------------------
%macro	ENDPROG		1
	mov	ebx, %1		; return (%1)
	mov	eax, 1		; exit sys call
	int	80h
%endmacro

;---------------------------------------------------------
; macro to output a string -------------------------------
;---------------------------------------------------------
%macro	OUTPUT	2-3
	mov	eax, 4		; write sys call
	mov	ebx, stdout	; to standard out
	mov	ecx, %1		; the string
	mov	edx, %2		; the number of characters
	int	80h
  %if %0 == 3			; if one more parameter is
	mov	eax, 4		; present then add eol
	mov	ebx, stdout
	mov	ecx, endl
	mov	edx, 1
	int	80h
  %endif
%endmacro	

;---------------------------------------------------------
section .data

	endl		db	0AH, 0
	missargs	db	"Missing arguments",0
	manyargs	db	"Too many arguments",0
	usage		db	"Please use the format a.out (source) (destination)",0
	fileerror	db	"Error opening input file",0
	writeerror	db	"Error opening file for writing",0
	prob		db	"Error copying file",0

;---------------------------------------------------------
section .bss
	source		resb	120
	dest		resb	120
	infile		resd	1
	outfile		resd	1
	rights		resd	1
	stats		resd	14
	buffer		resb	buf_size

;---------------------------------------------------------
; start the main prog
;---------------------------------------------------------
section .text

		global	_start
_start:
		cmp	dword [esp], 3	; check for 3 params
		je	copy		; if 3
		jg	greater		; if greater
					; else less

less:
		OUTPUT	missargs, missargs_len, 1
		OUTPUT	usage, usage_len, 1
		jmp	done

greater:
		OUTPUT	manyargs, manyargs_len, 1
		OUTPUT	usage, usage_len, 1
		jmp	done

;---------------------------------------------------------
; begin copying file
;---------------------------------------------------------
copy:
		mov	eax, 5		; the open sys call
		mov	ebx, [esp+2*4]	; open the input file
		mov	ecx, 0		; read only
		int	80h
		mov	[infile], eax
		test	eax, eax	 	    ; if no error
		jns	write_file	 	    ; jmp to open file for writing
		OUTPUT	fileerror, fileerror_len, 1 ; else output error
		jmp	done		 	    ; and exit

write_file:
		mov	eax, 108	 ; the fstat sys call
		mov	ebx, [infile]	 ; get fstat from infile
		mov	ecx, stats	 ; store in stats struct
		int	80h

		mov	eax, dword [stats+2*4] ; the rights are stored in
		mov	[rights], eax	       ; stats[2]. move to rights

		mov	eax, 5		; the open sys call
		mov	ebx, [esp+3*4]	; open the output file
		mov	ecx, 1		; for reading
		or	ecx, 100	; create if it isn't there
		or	ecx, 200	; if it is then error
		int	80h

		mov	[outfile], eax
		test	eax, eax	  	      ; was open successfule
		jns	continue	  	      ; if so start copying
		OUTPUT	writeerror, writeerror_len, 1 ; else show error
		jmp	done		  	      ; and exit

continue:
		mov	eax, 3		; the read sys call
		mov	ebx, [infile]	; the file descriptor
		mov	ecx, buffer	; point to my buffer
		mov	edx, buf_size	; the size of my buffer
		int	80h

		test	eax, eax	; everything go ok?
		jz	endcopy		; if zero then eof
		js	problem		; uh oh...

		mov	eax, 4		; the write sys call
		mov	ebx, [outfile]	; the file descriptor
		mov	ecx, buffer	; the buffer to write
		mov	edx, buf_size	; the size of buffer
		int	80h

		jmp	continue	; keep processing

problem:
		OUTPUT	prob, 19, 1	; output copy error
		jmp	done

;---------------------------------------------------------
; finished copying the file, now set the rights and close
; the files
;---------------------------------------------------------
endcopy:
		mov	eax, 94		; the fchmod sys call
		mov	ebx, [outfile]	; set the rights for outfile
		mov	ecx, [rights]	; here are the rights
		int	80h

		mov	eax, 6		; the close sys call
		mov	ebx, [infile]	; close the input file
		int	80h

		mov	eax, 6		; the close sys cal;
		mov	ebx, [outfile]	; close the output file
		int	80h

done:
		ENDPROG	1		; All done
end
