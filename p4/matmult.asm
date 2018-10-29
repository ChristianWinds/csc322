; Christian Winds
; CSC 322 Fall 2018
; Program 4 - Matrix Multiplication
; This program creates a matrix product from two existing matrices.
; Monday, October 29th, 2018

X        EQU    4    ;Rows for Mat1 and Mat3
Y        EQU    3    ;Cols for Mat1 and Rows for Mat2
Z        EQU    2    ;Cols for Mat2 and Mat3

;X        EQU    2
;Y        EQU    3
;Z        EQU    3

SECTION .data
M1        dd     1, 2, 2
        dd     3, 2, 1
        dd     1, 2, 3
        dd     2, 2, 2    

M2        dd     2, 4
        dd     3, 3
        dd     4, 6

;M1        dd        7, 6, 3
;          dd        5, 3, 2

;M2        dd        5, 2, 5
;          dd        2, 7, 4
;          dd        1, 7, 3

M3CellValue	dd 0
M1Offset	dd 0
M2Offset	dd 0
M3Offset	dd 0
; Provide an index variable that temporarily holds M1's changing multiplicand starting position during runtime
M1RunPauseIndex	dd 0
; Provide an index variable to manage M2 index resets and placement changes
M2RunPauseIndex	dd 0

SECTION .bss
M3        RESD     X*Z
;M3        RESD     X*Z

SECTION .text
global _main
_main:

; Prepare the selection of M3's row.
mov ecx, X
M3RowSelection:
	push ecx
	; Prepare the selection of M3's column.
	mov ecx, Z
	M3ColumnSelection:
		push ecx
		; Construct the current cell for M3.
		; Prepare the number of products to be added in one M3 cell
		mov ecx, Y
		M3CellCreation:
			push ecx
			; Access the proper value to multiply from the M1 matrix
			mov eax, [M1Offset]
			mov ecx, DWORD [M1 + eax]
			M1Multiplier:
				push ecx
				; Access the proper value to multiply from the M2 matrix
				mov eax, [M2Offset]
				mov ecx, DWORD [M2 + eax]
				; Multiply the current M1 and M2 cell values together
				M2Multiplier:
					inc DWORD [M3CellValue]
					; Continue multiplying with M2's value if needed
					loop M2Multiplier
				pop ecx
				; Continue multiplying with M1's value if needed
				loop M1Multiplier
				; Move one cell rightward in M1
				add DWORD [M1Offset], 4
				; Move one cell downward in M2
				add DWORD [M2Offset], 4 * Z
			pop ecx
			; Continue adding new products to the current M3 cell, or end the summation process for the current M3 cell
			loop M3CellCreation
		pop ecx
		; As an M3 cell has been fully created, reset the M1 offset to the M1 run pause index
		mov eax, [M1RunPauseIndex]
		mov [M1Offset], eax
		; As an M3 cell has been fully created, set the M2 offset to the beginning of the next M2 column
		add DWORD [M2RunPauseIndex], 4
		mov eax, [M2RunPauseIndex]
		mov [M2Offset], eax
		; Place the M3 cell value into the current M3 cell
		mov eax, [M3CellValue]
		mov ebx, [M3Offset]
		mov [M3 + ebx], eax
		; Reset the M3 cell value variable
		mov DWORD [M3CellValue], 0
		; Move to the current M3 row's next cell if any more row cells remain uncalculated, or move to the next M3 row
		add DWORD [M3Offset], 4
		loop M3ColumnSelection
	pop ecx
	; As the end of an M3 row was reached, reset the M2 offset
	mov DWORD [M2Offset], 0
	; As the end of an M3 row was reached, update the M1 offset to the next M1 row and update the M1 run pause index
	add DWORD [M1Offset], 4 * Y
	mov eax, [M1Offset]
	mov [M1RunPauseIndex], eax
	; As the end of an M3 row was reached, reset the M2 run pause index to zero and reset the M2 index offset to zero
	mov DWORD [M2RunPauseIndex], 0
	mov DWORD [M2Offset], 0
	; Select the next cell of M3.
	dec ecx
	cmp ecx, 0
	jz NoM3RowSelectionLoop
	jmp M3RowSelection
	NoM3RowSelectionLoop:

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
