.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD
INCLUDE Irvine32.inc

.data
	TRUE = 1
	FALSE = 0
	gradeAverage  DWORD ?	; test value
	credits       DWORD 12	; test value
	OkToRegister  BYTE ?

  welcomeMsg BYTE "Welcome to the Registration Eligibility Machine!", 0
  gpaPrompt BYTE "Enter your Grade Average: ", 0
  creditPrompt BYTE "Enter your Credit amount: ", 0
  canReg BYTE "You are eligible for registration!", 0
  canNotReg BYTE "You are not eligible for registration...", 0
  tooLargeInput BYTE "Your input was too large! Try something 1-30.", 0
  tooSmallInput BYTE "Your Input was too small! Try something 1-30.", 0

.code
main PROC

  MOV edx, OFFSET welcomeMsg    ;Welcomes user, then start on new line
  CALL WriteString
  CALL Crlf

  MOV edx, OFFSET gpaPrompt   ;Asks the user for their grade average
  call WriteString
  call ReadInt
  MOV gradeAverage, eax
  CALL Crlf

  MOV ebx, 350    ;compares the grade average to 350. If greater, they can register. Less, it jumps to different instructions.
  CMP eax, ebx
  JGE CanRegister
  JMP NeedCredits
  
  CanRegister:
    MOV edx, OFFSET canReg    ;Automatically allows them to register 
    CALL WriteString
    CALL Crlf
    jmp FinishLine

  NeedCredits:
    MOV edx, OFFSET creditPrompt    ;Asks the user for their credit amount and validates the amount.
    CALL WriteString
    CALL ReadInt
    CALL Crlf

    MOV credits, eax

    MOV ebx, 1    ;Credit input Below 1?
    CMP eax, ebx
    JL UnderInput 
    
    MOV ebx, 30   ;Credit input Above 30?
    CMP eax, ebx
    JG OverInput

    MOV ebx, 16     ;Are you trying to register for more than 16 credits?
    CMP eax, ebx
    JGE CannotRegister
    JMP PossiblyRegister

  OverInput:
    MOV edx, OFFSET tooLargeInput   ;Puts out a message that you put too high a number
    CALL WriteString
    CALL Crlf 
    
    JMP NeedCredits

  UnderInput:
    MOV edx, OFFSET tooSmallInput   ;Puts out a message that you put too low a number
    CALL WriteString
    CALL Crlf 

    JMP NeedCredits
    
  PossiblyRegister:
    MOV eax, gradeAverage   ;If you are within the 1-16 range of credits, AND you have a Grade Average 250+ You can register, otherwise it proceeds to CannotRegister
    MOV ebx, 250
    CMP eax, ebx
    JGE CanRegister
    JMP CannotRegister
  
  CannotRegister:
    MOV edx, OFFSET CannotReg
    CALL WriteString
    CALL Crlf

  FinishLine:
    

	;mov OkToRegister,FALSE

	;.IF gradeAverage > 350
	;   mov OkToRegister,TRUE
	;.ELSEIF (gradeAverage > 250) && (credits <= 16)
	;   mov OkToRegister,TRUE
	;.ELSEIF (credits <= 12)
	;  mov OkToRegister,TRUE
	;.ENDIF
  

	INVOKE ExitProcess, 0
main ENDP
END main 
