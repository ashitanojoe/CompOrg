%include "/home/class/csci2093/iomacros.inc"
%define		CH_ADD		'+'
%define		CH_DIV		'/'
%define		CH_MULT		'*'

;-----------------------------------------------------------------
section .data

	fname		db	"/home/class/csci3043/arithmetic.in",0
	adding		db	"Adding...",0
	multiply	db	"Multiplying...",0
	dividing	db	"Dividing...",0
	fileerror	db	"Error opening input file.",0
	filegood	db	"File successfully opened.",0
	fileend		db	"Reached end of file.",0
	good		db	"Here.",0
	endl		db	0AH

;-----------------------------------------------------------------
section .bss

	i_buff		resd	1		; integer buffer
	ch_buff		resb	1		; buffer to hold sign
	n		resd	1		; # of ints in array
	f		resd	1		; file pointer
	nums		resd	100		; array of integers

;-----------------------------------------------------------------
section .text

		global	main

main:
		fopenr	[f], fname	
		cmp	EAX, 0
		jne	continue
		jmp	failed

continue:
		put_str	filegood
		put_str endl
		mov	EDI, 0

readfile:
		fget_i	[f], ESI
		cmp	ESI, -1
		je	endoffile

lineread:	fget_ch	[f], [ch_buff]
		cmp	byte [ch_buff], 0AH
		je	endofline
		fget_ch	[f], [ch_buff]
		fget_i	[f], ECX
		cmp	byte [ch_buff], CH_ADD
		je	do_add
		cmp	byte [ch_buff], CH_MULT
		je	do_mult
		cmp	byte [ch_buff], CH_DIV
		je	do_div

do_add:		add	ESI, ECX
		;put_str	adding
		;put_str endl
		jmp	lineread

do_mult:	imul	ESI, ECX
		;put_str	multiply
		;put_str endl
		jmp	lineread

do_div:		mov	EAX, ESI
		mov	EBX, 1
		imul	EBX
		idiv	ECX
		mov	ESI, EAX
		;put_str	dividing
		;put_str	endl
		jmp	lineread

endofline:	mov	[nums+4*EDI], ESI
		inc	EDI
		put_i	ESI
		put_str endl
		jmp	readfile

endoffile:
		put_str	fileend
		put_str	endl
		fclose	[f]
		mov	[n], EDI
		push	dword [n]
		push	dword nums
		call	output
		add	ESP, 8
		jmp	done

failed:
		put_str	fileerror
		put_str endl

done:
		mov	EBX,0
		mov	EAX,1
		int	80h
end


;-----------------------------------------------------------------
; Function to display the results


;-----------------------------------------------------------------
section .data


;-----------------------------------------------------------------
section .bss


;-----------------------------------------------------------------
section .text

output:
		push	EBP
		mov	EBP, ESP
		push	EBX
		push	ECX
		push	EDX		

		mov	EDX, 0
		mov	EBX, [EBP+12]	; EBX is number of elements
		mov	ECX, [EBP+8]	; ECX is pointer to array

bloop:		cmp	EBX, EDX
		je	return
		put_i	[ECX+4*EDX]
		put_str	endl
		inc	EDX
		jmp	bloop

return:
		pop	EDX
		pop	ECX
		pop	EBX
		pop	EBP
		ret
