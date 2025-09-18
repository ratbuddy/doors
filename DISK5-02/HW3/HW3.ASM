TITLE   HOMEWORK [I]

COMMENT  *  This program will ask the user to input a number
            as to how many seconds have gone by in a day.
            THe program will then tell exactly what time it is.
         *

         EXTRN  GETDC32$:far
         EXTRN  PUTDEC$ :far
LF       EQU  10
CR       EQU  13

stack SEGMENT STACK
          db 64 dup (?)  ; setup stack
stack ends

_data SEGMENT WORD PUBLIC 'DATA'
  LNOON   DB 32,'AM $'  ; less than noon
  ANOON   DB 32,'PM $'  ; afternoon
  PROMPT  DB 'ENTER THE NUMBER OF SECONDS : $'
  BADINP  DB 'THAT NUMBER IS TOO BIG!$'
  LFCR    DB  LF,LF,CR,'$'
  HEADER  DB 'PROGRAM WRITTEN BY EDDIE GAUL $'
  TIMER   DB 'The Time is: $'
  hours   dw  3600
  minutes db  60
  cutoff  dw  12
_data ends

_TEXT   SEGMENT byte public 'CODE'
        ASSUME CS:_TEXT,  DS:_data,  SS:stack, ES:_data
start:
         MOV AX,_DATA
         MOV DS,AX                  ;SET UP DATA SEGMENT
         MOV ES,AX
         MOV DX, OFFSET HEADER
         MOV AH,9
         INT 21H
         MOV DX, OFFSET LFCR        ; PRINT UP SOME CARRIAGE RETURNS
         INT 21H
         MOV DX, OFFSET PROMPT      ; SETUP PROMPT
         INT 21H
         sub dx,dx          ; DX=0
         sub ax,ax          ; AX=0
         CALL GETDC32$      ; GET NUMBER
        push dx                    ; SAVE REGS FOR QUIT OF PRINTING
        push ax
         MOV DX, OFFSET LFCR
         MOV AH,09
         INT 21H
         MOV DX, OFFSET TIMER
         INT 21H
        pop ax                    ; RESTORE REGS
        pop dx
         CMP DX,1           ; COMPARE high INPUT to see if higher than 1
         JB PASS_TEST
         JA QUITTER
         CMP AX,20864       ; If dx=1 then see if AX>20864
         JBE PASS_TEST      ; Quit if higher else jump to start
QUITTER: MOV DX, OFFSET BADINP      ; PRINT OUT ROTTEN MESSAGE
         MOV AH,09
         INT 21H
         MOV AX,4C00h               ; AND QUIT
         INT 21H
PASS_TEST:
         DIV HOURS        ; Divide Number of seconds in an hour
         CMP AX, CUTOFF   ; comp the quotient with 12 (noon)
         JAE AFTERNOON    ; jump if after noon
         MOV Bl,0         ; Put Bl=0 to signify its morning
         CMP AX,0         ; Check for 12 AM
         JNE Q_MORN       ; If then go to Q_MORN
         MOV AX,12
 Q_MORN: JMP BLOCK2
AFTERNOON:
         MOV Bl,1               ; Put a 1 in Bl to mean it is Afternoon
         sub ax,12              ; subtract 12 to get hours correct
         CMP AX,0
         JNE block2
         MOV ax,12
BLOCK2:  MOV BH,0        ; RANDOM POSITIVE NUMBER TO SEND TO PUTDeC$
         CALL PUTDEC$
         CALL COLONS     ; put some ':' in there
         mov AX,dX       ; Now move the Remainder into AX
         cmp ax,0
         jz  next
         DIV MINUTES     ; now divide by minutes, quot in al
    next:mov cx,ax       ; save it so we can get remainder later
         cbw             ; put the AL quotient into the AX, so we can print it
         MOV BH,0
         CALL ZEROS
         CALL PUTDEC$    ; printout minutes
         CALL COLONS     ; get some colons
         MOV AX,CX
         MOV Al,ah       ; mov the ah into the al
         cbw             ; put al into ax
         MOV BH,0
         CALL ZEROS
         CALL PUTDEC$    ; print out seconds
         CMP BL,0
         JE  MORN2
         MOV DX, OFFSET ANOON  ; Print PM if Applicable from BL's Compare
         JMP PAST2
MORN2:   MOV DX, OFFSET LNOON  ; Print AM if Applicable from BL's Compare
PAST2:   MOV AH,09
         INT 21h
         mov aX,4c00h      ; quit
         int 21h

ZEROS  PROC NEAR
         CMP AX,9
         JAE BACKER     ; If a Zero's not needed the RET(urn)
         PUSH AX        ; Save REGS
         PUSH DX
           mov dl,48    ;put a zero on the screen
           mov ah,02
           int 21h
         pop dx         ; Restore REGS
         pop ax
 BACKER:    RET
ZEROS ENDP

COLONS proc NEAR
            PUSH AX     ; SAVE REGS
            PUSH DX
            MOV DL,58   ; Print a ':'
            MOV AH,02
            INT 21H
            POP DX      ; RESTORE REGS
            POP AX
            RET
 colons endp

_TEXT ENDS
      END start