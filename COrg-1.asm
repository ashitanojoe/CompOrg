; Due date:	Thursday, January 23, 2003

; Description:	this program calculates the value of an expression 
;		(ignoring customary order of operations) taken from
;		an input file (arithmetic.in).  this file contains
;		one of more (max 100) lines each consisting of an
;		arithmetic expression composed of positive integers
;		and binary arithmetic operators (+ * /).
;		stores the answers in an array and then displays each
;		result.

; Example line: 10 + 5 * 18 / 9
;		(num op num op num ... op num)



%include "/home/class/csci2093/iomacros.inc"
%define		CH_ADD		'+'
%define		CH_DIV		'/'
%define		CH_MULT		'*'

;-----------------------------------------------------------------
section .data

	fname		db	"/home/class/csci3043/arithmetic.in",0
	fileerror	db	"Error opening input file.",0
	endl		db	0AH

;-----------------------------------------------------------------
section .bss

	ch_buff		resb	1		; buffer to hold sign
	f		resd	1		; file pointer
	nums		resd	100		; array of integers

;-----------------------------------------------------------------
section .text

		global	main

main:
		fopenr	[f], fname		; open fname to read
		cmp	EAX, 0			; check if successful
		jne	continue
		jmp	failed			; exit if failed

continue:
		mov	EDI, 0			; index counter for array
						; will hold the number of
						; elements

readfile:
		fget_i	[f], ESI		; grab first int of line
		cmp	ESI, -1			; if -1 then found the
		je	endoffile		; end of file

lineread:	
		fget_ch	[f], [ch_buff]		; grab the next character
		cmp	byte [ch_buff], 0AH	; if its an eol char
		je	endofline		; then process eol
						; if not eol, then it is a
						; space and the next
		fget_ch	[f], [ch_buff]		; character is a symbol

		fget_i	[f], ECX		; grab the next int 

		cmp	byte [ch_buff], CH_ADD	; if '+'
		je	do_add
		cmp	byte [ch_buff], CH_MULT	; if '*'
		je	do_mult
		cmp	byte [ch_buff], CH_DIV	; if '/'
		je	do_div

do_add:		
		add	ESI, ECX		; add the int
		jmp	lineread		; continue reading line

do_mult:	
		imul	ESI, ECX		; multiply the int
		jmp	lineread		; continue reading line

do_div:		
		mov	EAX, ESI		; divide the int
		mov	EBX, 1
		imul	EBX
		idiv	ECX			; who came up with this
		mov	ESI, EAX		; idea???
		jmp	lineread		; continue reading line

endofline:	
		mov	[nums+4*EDI], ESI	; store the answer in
		inc	EDI			; the array.
		jmp	readfile		; start processing next
						; line
endoffile:
		fclose	[f]			; done processing file

		push	dword EDI		; pass the # of elements
		push	dword nums		; and pointer to int array

		call	output			; call to function "output"
		add	ESP, 8
		jmp	done			; all done

failed:
		put_str	fileerror		; output file error message
		put_str endl

done:
		mov	EBX,0			; return 0
		mov	EAX,1			; on
		int	80h			; exit
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
		push	EBX		; preserve original data
		push	ECX
		push	EDX		

		mov	EDX, 0		; array index i
		mov	EBX, [EBP+12]	; EBX is number of elements
		mov	ECX, [EBP+8]	; ECX is pointer to array

bloop:		cmp	EBX, EDX	; if equal then we are done
		je	return
		put_i	[ECX+4*EDX]	; output the nums[i]
		put_str	endl
		inc	EDX		; increment i
		jmp	bloop

return:
		pop	EDX
		pop	ECX		; to preserve original data
		pop	EBX
		pop	EBP
		ret
