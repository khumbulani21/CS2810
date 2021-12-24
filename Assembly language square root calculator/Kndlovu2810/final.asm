.ORIG x3000
;prompt user to input a number
LEA R0, PROMPT 
PUTS
;;;;;;;;;
GET_INPUT
GETC
OUT
ADD R5, R0, #-10 ;Check if user hit enter
BRz LOOP
JSR STORE_INPUT
BR GET_INPUT
;;;;; store input and count the number of digits
STORE_INPUT
LD R1, NUMBER_OF_CHAR
ADD R1, R1,#1
ST R1, NUMBER_OF_CHAR
AND R5, R7, #0
LD R5, STRING_POINTER
STI R0, STRING_POINTER
ADD  R5,R5,#1
ST R5, STRING_POINTER
RET 

; get a value from the string 
; convert to a  2's complement number 
;store the value in array 2
AND R1,R1, #0
ST R1, NUMBER_OF_CHAR
LOOP 
LD R0, ARRAY; Memory address for the second array
LD R2, STRING_HEAD;  MEMORY location is loaded into R2
AND R6, R6, #0; Counter int i=0
LOOP_START
LD R3, NUMBER_OF_CHAR
;Convert number of char to a negative value
NOT R3,R3
ADD R3,R3,#1
ADD R1, R6, R3 ; R1 is just a temp storage for comparizon i<R3
BRzp LOOP_END

ADD R1, R2, R6; Start of array + counter array[i]
ADD R4, R0, R6; R4 holds the memory address of array[i]
; convert each character  into a  2's complement number 
AND R5,R5,#0
LDR R5, R1,#0; R1 is the memory location 
;;;;;;;
LD R3, OFFSET
ADD R5, R5, R3 ; convert to decimal
STR R5, R4, #0 
;R5 has a 2's complement number
ADD R6, R6, #1 ; Increment the counter
LEA R1, LOOP_START
JMP R1
LOOP_END

;CONVERT TO A 2'S COMPLEMENT NUMBER
LEA R0, MULTIPLES_OF_TEN 
LD R1, NUMBER_OF_CHAR
ADD R7, R1, #-5
BRz TenThousand
ADD R7, R1, #-4
BRz Thousand
ADD R7, R1, #-3
BRz Hundred
ADD R7, R1, #-2
BRz Ten
ADD R7, R1, #-1
BRz One

TenThousand
LD R1, TEN_THOUSAND 
STR R1, R0, #0
ADD  R0, R0, #1

Thousand
LD R1, THOUSAND 
STR R1, R0, #0
ADD  R0, R0, #1

Hundred
LD R1, HUNDRED
STR R1, R0, #0
ADD  R0, R0, #1

Ten
AND R1, R1, #0
ADD R1, R1, #10
STR R1, R0, #0
;AND  R1, R1, #0
ADD  R0, R0, #1

One
AND R1, R1, #0
ADD R1, R1, #1
STR R1, R0, #0

LEA R0, MULTIPLES_OF_TEN 
LEA R7, SUM
LEA R2, ARRAY;
LD R3, NUMBER_OF_CHAR 
NOT R3,R3
ADD R3,R3,#1
; R5 is our sum 
AND R5, R5, #0 ; set R5 to zero 

LOOP2 
AND R6, R6, #0; Counter int i=0
LOOP2_START
ADD R1,  R6, R3 ; R1 is just a temp storage for comparizon i<5
BRzp LOOP2_END
LDR R1, R2, #0
ADD R1, R1, R6; Start of array + counter array[i]

LDR R1, R1, #0
;if r4 is 0 continue
BRz CONTINUE
;ADD R0, R0, #1 ; INCREASE THE POWER OF TEN
LDR R4, R0, #0
; enter loop 
MULTIPLY ADD R5, R5, R4 ; add to sum 
ADD R1, R1, #-1 ; decrement our counter 
BRp MULTIPLY ; continue until the 2nd num is 0
STR R5, R7, #0 ;Store i in array[i]=i
CONTINUE
ADD R6, R6, #1 ; Increment the counter
ADD R0, R0, #1 
LEA R1, LOOP2_START
JMP R1
LOOP2_END
;R5 has the value that we need

;square root calculation
AND R2,R2,#0
ADD R2,R2, R5
AND R3, R3,#0;
ADD R3, R3,#1;SQRT IS R3
AND R4, R4,#0; r4 IS SQUARE
;2  Initialize variables  value and square root. Value is the value that we get from the user and sqrt is a counter. Set sqrt to 1,  value=0
;3 Check if value ==1 return sqrt as 1
;R3 SQRT, R4 SQUARE,  R2 VALUE
NOT R6, R2
ADD R6,R6,#1; r6 stores -value
ST R6, NEGATIVE_VALUE
;R3 SQRT, R4 SQUARE,  R2 VALUE, R6 -VALUE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AND R0,R0,#0 ;LOOP COUNTER  I=0
FOR_LOOP3
ADD R5, R0, R6; I< value
BRzp LOOP3_END  ; if i> value end loop
;;;;;;;;;;;;;;;;;;;;;;;
;TAKE IN SQRT R3
; -VALUE    R6
; Convert  r3 to a negative value

CALCULATE_SQUARE
AND R4, R4,#0; r4 IS SQUARE
NOT R7 , R3
ADD R7 , R7, #1 ; R7 NEGATIVE SQRT
AND R1,R1,#0 ;LOOP COUNTER
ST R7, NEGATIVE_SQRT
FOR_LOOP4

ADD R5, R1, R7; I< sqrt
BRzp LOOP4_END 
ADD R4,R4,R3 ; CALCULATE THE SUM 

ADD R1,R1,#1 ; increment the counter
LEA R5, FOR_LOOP4
JMP R5
LOOP4_END
; check if square is equal to value
ADD R5, R4, R6
BRz LOOP3_END

ADD R5, R4, R6
;check if square is greater than value
BRp SUBTRACT_ONE


ADD R5, R4, R6
;check if square is greater than value
BRn CONTINUE1

SUBTRACT_ONE
ADD R3,R3,#-1
BRnzp LOOP3_END

CONTINUE1
ADD R0,R0,#1 ; increment the counter
ADD R3,R3,#1 ; increment the sqrt
LEA R5, FOR_LOOP3
JMP R5
LOOP3_END
ST R4, SQUARE
;;;;;;;;
ST R3, SQRT
LD R0,SQRT
LD R1, HUNDRED 
LD R6, POFFSET
LEA R4, OUTPUTARRAY ; Address of Array
LD R2, TEN

NOT R1, R1
ADD R1,R1,#1 ; R1=-100

NOT R2,R2
ADD R2,R2,#1 ; convert into -10
ADD R3, R0, R2; value-10
BRn LESS_TEN
BRz EqualTen

;IF greater than 10 r1 = -100
ADD R3, R0, R1;
BRz EqualHundred
BRp GREATER100 ; positive if greater than 100

ADD R3,R0,#0
BRnzp TEN_TO_HUNDRED

GREATER100
ADD R5, R6,#1
ST R5, OUTPUTARRAY 
ADD R4,R4,#1 ; increment the array
;r4 has array[2]

;R3 has a remainder
TEN_TO_HUNDRED
AND R5,R5,#0 ;LOOP COUNTER
AND R7, R7,#0
ADD R7,R3,#0
FOR_LOOP5
ADD R7, R7, #-10; I< 10
BRn LOOP5_END 
ADD R5,R5,#1 ; increment the counter
LEA R1, FOR_LOOP5
JMP R1
LOOP5_END
ADD R5,R5,R6
STR R5, R4,#0
ADD R7,R7,#10
ADD R0, R7,#0 
ADD R4,R4,#1
;;;;
;R5 has to have the ones digit

LESS_TEN
ADD R5, R6,R0
STR R5, R4,#0
BRnzp exit

EqualHundred
ADD R5, R6,#1
ST R5, OUTPUTARRAY 
ADD R4,R4,#1 ; increment the array
STR R6, R4,#0 ;store ascii 0 ie 48
ADD R4,R4,#1 ; increment the array
STR R6, R4,#0 ; store 0
ADD R4,R4,#1 ; increment the array
BRnzp exit
EqualTen
ADD R5, R6,#1
ST R5, OUTPUTARRAY 
ADD R4,R4,#1 ; increment the array
STR R6, R4,#0 ;store ascii 0 ie 48

exit

LEA R0, OUTPUTARRAY 
PUTS

HALT
;LABELS
PROMPT .stringz "insert a numberto calculate the square root \n"
STRING_POINTER .FILL X3100
STRING_HEAD .FILL X3100
OFFSET .FILL #-48
TEMP .BLKW 1
ARRAY  .FILL X3106
ARRAY2 .BLKW 5
VALUE .FILL #5
NUMBER_OF_CHAR .FILL #0
MULTIPLES_OF_TEN .BLKW 5
TEN_THOUSAND .FILL #10000
THOUSAND .FILL #1000
HUNDRED .FILL #100
SUM .BLKW 1
;SQUARE ROOT VARIABLES
NEGATIVE_SQRT .BLKW 1
NEGATIVE_VALUE .BLKW 1
SQ .BLKW 1
SQRT .BLKW 1
TEMP2 .BLKW 1
SQUARE .BLKW 1
TEN .FILL #10
OUTPUTARRAY .BLKW 4
POFFSET .FILL #48

.END