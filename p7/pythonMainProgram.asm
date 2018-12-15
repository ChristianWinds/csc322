; Christian Winds
; CSC 322 Fall 2018
; Program 7: Happy Python
; This program runs a game until the player wins or collides with a wall.
; Friday, December 14, 2018

; A macro for clearing the screen
%macro ClearTheScreen 0
        pusha
        mov     eax,4
        mov     ebx,1
        mov     ecx,cls
        mov     edx,4
        int     80h
        popa
%endmacro

; A macro for printing strings
%macro PrintString 2
        pusha
        mov     eax,4
        mov     ebx,1
        mov     ecx,%1
        mov     edx,[%2]
        int     80h
        popa
%endmacro

; A macro for setting the cursor's position
%macro SetCursorPosition 2
        push    eax
        mov     ah,%1
        mov     al,%2
        call    _setCursor
        pop     eax
%endmacro

; A macro for ending the child process
%macro EndChildProcess 1
	mov     eax,37
        mov     ebx,[%1]
        mov     ecx,9  ; kill signal
        int     80h
%endmacro

; A macro for ending the program
%macro NormalTermination 0
        mov     eax,1
        mov     ebx,0
        int     80h
%endmacro

; Create a struct to handle the python's body characters
STRUC pStruct
        .esc    RESB 2  ; space for <esc>[
        .row:   RESB 2  ; two digit number (characters)
        .semi   RESB 1  ; space for ;
        .col:   RESB 2  ; two digit number (characters)
        .H      RESB 1  ; space for the H
        .char:  RESB 1  ; space for THE character
        .size:
ENDSTRUC

SECTION .data
pythonBody:	db	'@> '; Holds the python's body
pythonLen:	dd	$-pythonBody; Holds the python's length
direction:	dd	'a' ; Maintains the python's direction

fileName:       db      './inputFile.txt',0
fileDescriptor: dd      0

; Clear Screen control characters
cls:    db      1bh, '[2J'

; Set cursor position control characters for the _setCursor function
pos:    db      1bh, '['
row:    db      '00'
        db      ';'
col:    db      '00'
        db      'H'

; Hold the program's maze
screen: db      "********************************************************************************",0ah
        db      "*                          *                           *                       *",0ah
        db      "*      *************       *        *************      *       *********       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                                                                              *",0ah
        db      "*           **************************        ***********************          *",0ah
        db      "*                                *               *                             *",0ah
        db      "*                                *     ***********                             *",0ah
        db      "*                          *     *               *     *                       *",0ah
        db      "*                          *     **********      *     *                       *",0ah
        db      "*                          *     *               *     *                       *",0ah
        db      "*                          *     *      **********     *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                                                                              *",0ah
        db      "*           ***   ***   ***   ***   ***   ***   ***   ***   ***   ***          *",0ah
        db      "*                                                                              *",0ah
        db      "*            *     *     *     *     *     *     *     *     *     *           *",0ah
        db      "*               *     *     *     *     *     *     *     *     *              *",0ah
        db      "*            *     *     *     *     *  W  *     *     *     *     *           *",0ah
        db      "*               *     *     *     *     *     *     *     *     *              *",0ah
        db      "*            *     *     *     *     *     *     *     *     *     *           *",0ah
        db      "*               *     *     *     *     *     *     *     *     *              *",0ah
        db      "********************************************************************************",0ah
screenSize:     dd $-screen ; Holds the number of characters in the maze

lossScreen: db      "********************************************************************************",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                Try Again...                                  *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "*                                                                              *",0ah
            db      "********************************************************************************",0ah
lossScreenSize:	 dd $-lossScreen ; Holds the number of characters in the loss screen

winScreen: db      "********************************************************************************",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                               Congratulations!                               *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "*                                                                              *",0ah
           db      "********************************************************************************",0ah
winScreenSize:   dd $-winScreen ; Holds the number of characters in the win screen


; Set a delay time for movement
seconds: dd     1,0  ;;;  seconds, nanoseconds

; Move the cursor below the maze
moveCursor:     ISTRUC pStruct
                AT pStruct.esc,  db 1bh,'['
                AT pStruct.row,  db '26'
                AT pStruct.semi, db ';'
                AT pStruct.col,  db '00'
                AT pStruct.H,    db 'H'
                AT pStruct.char, db ' '
                IEND


SECTION .bss
python:        RESB pStruct.size*(pythonLen-pythonBody)
childProcessID:	RESD 1

pythonHeadAsciiRow:	RESW 1
pythonHeadAsciiColumn:	RESW 1
heldAsciiValue:		RESW 1 ; Used to temporarily store ASCII number data from pythonHeadAsciiRow and  pythonHeadAsciiColumn
toIntResult:		RESW 1 ; Used to hold the integer conversion result of _toInt
pythonHeadIntRow:	RESW 1 ; Used to hold the integer version of the python's head's row coordinate
pythonHeadIntColumn:	RESW 1 ; Used to hold the integer version of the python's head's column coordinate
collidedTile:		RESB 1

LEN     equ     1024
inputBuffer     RESB LEN

SECTION .text
global _main, _pythonConversionPreparation 
_main:

; Prepare the input file for beginning input reading
        ;; Open a file for communication
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,101h
        mov     edx,777h
        int     80h

        mov     [fileDescriptor],eax

        ;;; write  something to inputFile.txt
        mov     eax,4
        mov     ebx,[fileDescriptor]
        mov     ecx,direction
        mov     edx,1
        int     80h

        ;;;  close the file
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h

	; Clear the screen to prepare the maze's placement.
	ClearTheScreen

	; Print the maze
	SetCursorPosition 1, 1
	PrintString screen, screenSize
	

        ;;;;   FORK 2 PROCS
        mov     eax,2
        int     80h

        ;;;;;;;;;;;;;;;;;;;;;;  Creates two processes, same code,
        ;;;;;;;;;;;;;;;;;;;;;;   but returns zero to new proc, and the procID of child to parent
        cmp     eax,0
        je      childProcess
	; Save the child process's process ID.
	mov [childProcessID], eax


parentProcess:
	;;;;;;;;; LOAD python from pythonBody
        	mov     ax,80-(pythonLen-pythonBody) ;;;; Column on screen for first char when right justified
		shr	ax,1 ; Divides the maze width and python length difference by 2
	        mov     ebx,python               ;;;; pointer in python array of structs
	        mov     ecx,[pythonLen]             ;;;; loop count of characters in string
	        mov     edx,pythonBody            ;;;; pointer into the original python
	loadTop:
	        mov     BYTE [ebx],1bh
	        mov     BYTE [ebx+1],'['
	        mov     WORD [ebx+2],"07"  ;;;; ROW might need to swap these ; This sets the python's starting row.
	        mov     BYTE [ebx+4],';'
	        push    eax                ;;;; Save this for next loop
	        call    _toAscii           ;;;  Pass in int in ax, returns two ascii digits in ax ;
	        mov     WORD [ebx+5],ax
	        pop     eax                ;;;; Restore the screen col number
	        mov     BYTE [ebx+7],'H'
	        push    ecx
	        mov     cl,[edx]           ;;;; Get next char from string
	        mov     [ebx+8],cl
	        pop     ecx
	        add     ebx,pStruct.size
	        inc     edx
	        inc     ax
	        loop loadTop

	; Demonstrate function calls which uses an array of structs
	        mov     ecx,80-(pythonLen-pythonBody)

	; Handle the movement of the python.
	top:	; Determine if the python has collided with any items
	preError:
		call	_pythonConversionPreparation
	postError:
		push edx
		mov dx, [pythonHeadAsciiRow]
		mov [heldAsciiValue], dx
		call	_toInt
		mov dx, [toIntResult]
		mov [pythonHeadIntRow], dx
		mov dx, [pythonHeadAsciiColumn]
		mov [heldAsciiValue], dx
		call	_toInt
		mov dx, [toIntResult]
		mov [pythonHeadIntColumn], dx
		pop edx
	pre_collisionCheckCall:
		call	_collisionCheck
	post_collisionCheckPrelossCheckCall:
		; Determine if the player lost the game.
		lossCheck:
		cmp BYTE [collidedTile], '*'
		jne winCheck
	enteredlossCheck:
		; Print the loss screen.
	        SetCursorPosition 1, 1
	        PrintString lossScreen, lossScreenSize
		jmp quit
		; Determine if the player won the game.
		winCheck:
		cmp BYTE [collidedTile], 'W'
		jne noLossNorWin
		; Print the win screen.
	        SetCursorPosition 1, 1
	        PrintString winScreen, winScreenSize
		jmp quit

		noLossNorWin:
		call    _displayPython

		; Move cursor below the maze
	        mov     eax,4
	        mov     ebx,1
	        mov     ecx,moveCursor
	        mov     edx,9
	        int     80h

		; Pause the python's movement.
	        call    _pause

        ;; Open a file for communication
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,0  ; read only
        mov     edx,777h  ;;; guess at 777o
        int     80h

        mov     [fileDescriptor],eax

        ;;; read  something from inputFile.txt
        mov     eax,3
        mov     ebx,[fileDescriptor]
        mov     ecx,inputBuffer
        mov     edx,2
        int     80h

        ;;;  close the file
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h

        ; Process the keyboard input.
	push eax
	mov eax, [inputBuffer]
	inputQ:
	cmp eax, 'q'
	je quit
	; Determine whether to change the python's speed
	input1:
	cmp eax, '1'
	jne input2
        mov DWORD [seconds], 1
        mov DWORD [seconds + 4], 0
	jmp endOfMotionChanges
	input2:
	cmp eax, '2'
	jne input3
        mov DWORD [seconds], 0
        mov DWORD [seconds + 4], 500000000
	jmp endOfMotionChanges
	input3:
	cmp eax, '3'
	jne input4
        mov DWORD [seconds], 0
        mov DWORD [seconds + 4], 333333333
	jmp endOfMotionChanges
	input4:
	cmp eax, '4'
	jne inputW
        mov DWORD [seconds], 0
        mov DWORD [seconds + 4], 250000000
	jmp endOfMotionChanges
	; Determine whether to change the python's direction
	inputW:
	cmp eax, 'w'
	jne inputA
	mov [direction], eax
	jmp endOfMotionChanges
	inputA:
	cmp eax, 'a'
        jne inputS
        mov [direction], eax
        jmp endOfMotionChanges
	inputS:
	cmp eax, 's'
        jne inputD
        mov [direction], eax
        jmp endOfMotionChanges
	inputD:
	cmp eax, 'd'
        jne endOfMotionChanges
        mov [direction], eax
        jmp endOfMotionChanges


	endOfMotionChanges:

	        call    _adjustPython
        	jmp    top

; Read input from the keyboard.
childProcess:
        ; read  keypress
        mov     eax,3 ;sys read
        mov     ebx,0   ;stdin
        mov     ecx,inputBuffer
        mov     edx,LEN
        int     80h


        ;; Open a file for communication
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,101h
        mov     edx,777h
        int     80h

        mov     [fileDescriptor],eax

        ;;; write  something to  bob.txt
        mov     eax,4
        mov     ebx,[fileDescriptor]
        mov     ecx,inputBuffer
        mov     edx,1
        int     80h

        ;;;  close the file
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h

        jmp childProcess

quit:
	; End the child process.
	EndChildProcess childProcessID

	; Normal termination code
	NormalTermination

; A function for converting a two digit int to an ASCII string
_toAscii:
        push    ebx

        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'

        pop     ebx
        ret

; A function for converting a two digit, whole number ASCII string number to an int through parameter passing with the ax register.
_toInt:
	push eax
	push ebx
	push ecx
	push edx
	mov ebx, heldAsciiValue
	; Convert the ones ASCII digit from ASCII to an int
	sub BYTE [ebx + 1], '0'
	; Move the converted ones value to the cl register.
	xor ecx, ecx
	mov cl, BYTE [ebx + 1]

	; Convert the tens ASCII digit from ASCII to an int

	sub BYTE [ebx], '0'
	; Move the converted tens value to the ah register.
	mov ah, BYTE [ebx]
	; Multiply the converted tens value by ten.
	mov al, 10
	mul ah

	; Create a sum of the converted tens and ones integer values.
	add ax, cx

	mov [toIntResult], ax
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

; A function for moving the python
_adjustPython:
        pusha

        mov     ecx,[pythonLen]
        dec     ecx
        mov     ebx,python+((pythonLen-pythonBody)-1)*pStruct.size

_apTop: mov     dx,[ebx - pStruct.size + pStruct.row]   ;; get row above
        mov     [ebx + pStruct.row],dx                  ;; copy to this row

        mov     dx,[ebx - pStruct.size + pStruct.col]   ;; get col above
        mov     [ebx + pStruct.col],dx                  ;; copy to this col

        sub     ebx,pStruct.size
        loop    _apTop

; Determine which direction the python should move
	mov eax, [direction]
	cmp eax, 'w'
	je up
	cmp eax, 'a'
	je left
	cmp eax, 's'
	je down
	cmp eax, 'd'
	je right

; Move the python head left
left:
;;;;;;  Adjust first character to move one space to the left
        cmp     BYTE [ebx + pStruct.col + 1],'0'
        je      decreaseColCarry
        dec     BYTE [ebx + pStruct.col + 1]            ;; move first char to left
        jmp     adjustEnd
; Move the python head right
right:
;;;;;;  Adjust first character to move one space to the right
        cmp     BYTE [ebx + pStruct.col + 1],'9'
        je      increaseColCarry
        inc     BYTE [ebx + pStruct.col + 1]            ;; move first char to right	
	jmp adjustEnd
; Move the python head upward
up:
;;;;;;  Adjust first character to move one space upward
        cmp     BYTE [ebx + pStruct.row + 1],'0'
        je      decreaseRowCarry
        dec     BYTE [ebx + pStruct.row + 1]            ;; move first char upward
        jmp     adjustEnd
; Move the python head downward
down:
;;;;;;  Adjust first character to move one space downward
        cmp     BYTE [ebx + pStruct.row + 1],'9'
        je      increaseRowCarry
        inc     BYTE [ebx + pStruct.row + 1]            ;; move first char downward
        jmp adjustEnd

; Reduce the column coordinate to the next value
decreaseColCarry:
        dec     BYTE [ebx + pStruct.col]
        mov     BYTE [ebx + pStruct.col + 1],'9'
	jmp adjustEnd
; Increase the column coordinate to the next value
increaseColCarry:
        inc     BYTE [ebx + pStruct.col]
        mov     BYTE [ebx + pStruct.col + 1],'0'
        jmp adjustEnd
; Reduce the row coordinate to the next value
decreaseRowCarry:
        dec     BYTE [ebx + pStruct.row]
        mov     BYTE [ebx + pStruct.row + 1],'9'
        jmp adjustEnd
; Increase the row coordinate to the next value
increaseRowCarry:
        inc     BYTE [ebx + pStruct.row]
        mov     BYTE [ebx + pStruct.row + 1],'0'
        jmp adjustEnd

adjustEnd:
        popa
        ret

; A function for printing python's array structs
_displayPython:
        pusha
        mov     ebx,python
        mov     ecx,[pythonLen]

_dmTop: push    ecx
        push    ebx
        mov     eax,4  ; system print
        mov     ecx,ebx ; points to string to print
        mov     ebx,1   ; standard out
        mov     edx,9   ; num chars to print
        int     80h

        pop     ebx
        add     ebx,pStruct.size
        pop     ecx
        loop    _dmTop
        popa
        ret

_pythonConversionPreparation:
	stop0:
	pusha
	stop1:
        mov     ebx,python
	stop2:

	; Access the python's head's row data.
	mov	dx, [ebx + pStruct.row]
	; Store the python's head's row data
	stop3:
	mov	[pythonHeadAsciiRow], dx
	stop4:
	; Access the python's head's column data.
	mov	dx, [ebx + pStruct.col]
	stop5:
	; Store the python head's column data
	mov	[pythonHeadAsciiColumn], dx
	stop6:

	popa
	ret

; A function to determine the content of the tile the python collided
_collisionCheck:
	pusha
	xor eax, eax
	xor ebx, ebx
	; Calculate the offset to use for the screen variable.
	mov bx, [pythonHeadIntRow]
	mov al, 81
	mul bl

	add ax, [pythonHeadIntColumn]

	add eax, screen
	
        mov cl, BYTE [eax]
        mov [collidedTile], cl
        popa
        ret

; A function to briefly sleep
_pause:
        pusha
        mov     eax,162
        mov     ebx,seconds
        mov     ecx,0
        int     80h
        popa
        ret

; _setcursor expects AH = row, AL = col
_setCursor:
        pusha
;;; save original to get col later
        push    eax
;;;;;; process row
        shr     ax,8    ;; shift row to right
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [row],al 
        mov     BYTE [row+1],ah
;;;; process col
        pop     eax     ;; restore original parms
        and     ax,0FFh ;; erase row, leave col
        mov     bl,10
        div     bl      ;; puts ax/10 in al, remainder in ah
        add     ah,'0'
        add     al,'0'
        mov     BYTE [col],al
        mov     BYTE [col+1],ah

        ;;;;; now print the set cursor codes
        mov     eax,4
        mov     ebx,1
        mov     ecx,pos
        mov     edx,8
        int     80h

        popa
        ret

