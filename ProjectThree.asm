;  Nicholas Wojcik
;  17 June 2018

;  R0: I/O
;  R1: Guess total 
;  R2: Continue flag (1=cont, 0=stop)
;  R3: Negated Guesses allowed
;  R4: Negated Correct number
;  R5: Active Guess
;  R6: Used for comparison flags
;  R7: Used internally by JSR to store PC


;;;;;;;;;;;; START ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.orig x3000        ;start at x3000


;;;;;;;;;; MAIN PROGRAM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GAMESTART
	;;;;;CLEAR ALL REGISTERS
	JSR ClearRegs

	;;;;;INITIAL PROMPT WITH 1 GUESS
	LEA R0, GUESSES
	PUTS
	GETC
	OUT

	ADD R3, R0, #-1
	JSR asciiToBinR3
	NOT R3, R3

	LEA R0, INPUTNUM
	PUTS
	GETC

	ADD R4, R0, #0
	JSR asciiToBinR4
	NOT R4, R4         ;Negate correct num for comparisons
	ADD R4, R4, #1

	LEA R0, PTWOGUESS
	PUTS
	GETC
	OUT

	ADD R5, R0, #0
	JSR asciiToBinR5
	ADD R1, R1, #1
	ADD R6, R4, R5      ;Init comparison flag

	BRn GUESSUNDER
	BRp GUESSOVER
	BRz GUESSCORRECT

	;;;;;GUESSING LOOP, ENTERED AFTER INITIAL GUESS
	CONT
	ADD R6, R3, R1

	BRzp GAMEOVER

	LEA R0, PTWOAGAIN
	PUTS
	GETC
	OUT

	ADD R5, R0, #0
	JSR asciiToBinR5
	ADD R1, R1, #1
	ADD R6, R4, R5      ;Init comparison flag

	BRn GUESSUNDER
	BRp GUESSOVER
	BRz GUESSCORRECT
	
	;;;;;ENTERED WHEN THE GAME FINISHES AND PROMPTS TO PLAY AGAIN
	GOVER
	LEA R0, AGAIN
	PUTS
	GETC
	OUT
	JSR convertR0ToCheckCont
	BRz GAMESTART
HALT



;;;;;;;;;; CONDITIONALS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GUESSOVER                  ;Entered when guess is to big
	LEA R0, TOOBIG
	PUTS
	BRnzp CONT

GUESSUNDER                 ;Entered when guess is to small
	LEA R0, TOOSMALL
	PUTS
	BRnzp CONT

GUESSCORRECT               ;Entered when guess is correct
	LEA R0, CORRECT
	PUTS
	ADD R0, R1, #0
	JSR binToAsciiR0
	OUT
	LEA R0, CORRECTCONT
	PUTS
	BRnzp GOVER
GAMEOVER                   ;Entered when game is over
	LEA R0, LOSE
	PUTS
	NOT R4, R4
	ADD R0, R4, #0
	JSR binToAsciiR0
	ADD R0, R0, #1
	OUT
	BRnzp GOVER

;;;;;;;;;;; VARIABLES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AGAIN .STRINGZ "\nContinue? ('y' / any key to quit)"
GUESSES .STRINGZ "\nEnter allowed number of guesses: "
INPUTNUM .STRINGZ "\nPlayer 1, Enter a number between [0-9]: "
PTWOGUESS .STRINGZ "\n\nPlayer 2, Guess a number: "
PTWOAGAIN .STRINGZ "\n\nPlayer 2, Guess again: "
TOOSMALL .STRINGZ "\nToo small."
TOOBIG .STRINGZ "\nToo big."
CORRECT .STRINGZ "\n\nYour guess is correct. You win! You took "
CORRECTCONT .STRINGZ " guess(es)"
LOSE .STRINGZ "\n\nYou lose! Too many guesses. The number was "


;;;;;;;;;; SUBROUTINES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearRegs:
	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	RET
asciiToBinR3:
	ADD R3, R3, #-12
	ADD R3, R3, #-12
	ADD R3, R3, #-12
	ADD R3, R3, #-12
	RET
asciiToBinR4:
	ADD R4, R4, #-12
	ADD R4, R4, #-12
	ADD R4, R4, #-12
	ADD R4, R4, #-12
	RET
asciiToBinR5:
	ADD R5, R5, #-12
	ADD R5, R5, #-12
	ADD R5, R5, #-12
	ADD R5, R5, #-12
	RET
binToAsciiR0:
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R0, R0, #12
	RET
convertR0ToCheckCont:
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-1
	RET

;;;;;;;;;;;;;; END ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.end