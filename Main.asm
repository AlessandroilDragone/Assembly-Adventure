
.data
Newline: .asciiz "\n"
IDiag1: .asciiz "Ron costrui` una macchina del tempo, ma non aveva calcolato che, una volta utilizzata, si sarebbe incontrato con i suoi cloni, provenienti da universi paralleli"
IDiag2: .asciiz "Inserisci un numero intero per i vari campi del videogioco"

BufferInput: .byte 3
.eqv MaxPlayers 20
.eqv MaxTeams 20
.eqv MaxMatch 20
.eqv MaxInit 20 
#Max Init deve corrispondere al numero massimo tra le costanti qua sopra. Al momento si puo` modificare fino a 25 elementi per gli array

PBufferNickname: .byte 14
.eqv NicknameChars 13

ArrayPlayer: .space 1000 #lascio 200 byte di margine per un incremento di elementi da poter inserire 
.eqv POffID 0
.eqv POffFlag 4
.eqv POffLev 5
.eqv POffDef 6
.eqv POffAtk 10
.eqv POffEne 14
.eqv POffWin 18
.eqv POffLos 22
.eqv POffNick 26
#nick: 14 byte totali, 13 di lettere. 40 byte per player

ArrayTeam: .space 1000
.eqv TOffID 0
.eqv TOffID1 4
.eqv TOffID2 8
.eqv TOffID3 12
.eqv TOffID4 16
.eqv TOffID5 20
.eqv TOffWin 24
.eqv TOffLos 28
.eqv TOffFlag 32
.eqv TOffNick 33
# 7 byte totali per nickname. 6 lettere totali. 40 byte per team

ArrayMatch: .space 525
.eqv MOffID 0
.eqv MOffID1 4
.eqv MOffID2 8
.eqv MOffIDW 12
.eqv MOffRounds 16
.eqv MOffFlag 20
#1 byte per flag. 21 byte totali per match

.eqv POff 40
.eqv TOff 40
.eqv MOff 21

.text
.globl main
main:
jal InitialyzationArrays

li $v0, 4
la $a0, IDiag1
syscall

la $a0, Newline
syscall

la $a0, IDiag2
syscall

la $a0, Newline
syscall

j InputSection

	InitialyzationArrays:
	li $t0, 0
	la $t1, ArrayPlayer
	la $t2, ArrayTeam
	la $t3, ArrayMatch
	j InitialyzationArrays1

	InitialyzationArrays1:
	slti $t4, $t0, MaxInit
	beq $t4, $zero, FInitialyzationArrays
	
	mul $t4, $t0, POff
	add $t4, $t4, $t1
	sb $zero, 0($t4)
	
	mul $t4, $t0, TOff
	add $t4, $t4, $t2
	sb $zero, 0($t4)
	
	mul $t4, $t0, MOff
	add $t4, $t4, $t3
	sb $zero, 0($t4)
	
	addi $t0, $t0, 1
	j InitialyzationArrays1

	FInitialyzationArrays:
	jr $ra

InputSection:
li $t0, 0

li $v0, 8
la $a0, BufferInput
li $a1, 3
syscall

lb $t1, 0($a0)
beq $t1, $zero, Sections
blt $t1, 48, InputSection
bgt $t1, 59, InputSection
sub $t1, $t1, 48

sb $t1, 0($t0)

lb $t2, 1($a0)
beq $t2, $zero, Sections
blt $t2, 48, InputSection
bgt $t2, 59, InputSection
sub $t2, $t2, 48

sb $t2, 1($t0)
j Sections
 

Sections:
#beq, $t0, 0, Database
beq, $t0, 1, InsertPlayer
#beq, $t0, 2, InsertTeam
#beq, $t0, 3, AssignPlayer
#beq, $t0, 4, PrintPlayers
#beq, $t0, 5, PrintTeams
#beq, $t0, 6, SearchPlayerID
#beq, $t0, 7, SearchTeamName
#beq, $t0, 8, DuelSim
#beq, $t0, 9, MatchSim
#beq, $t0, 10, RegisterMatch
#beq, $t0, 11, PrintMatchHistory
#beq, $t0, 12, PrintRankPlayerScore
#beq, $t0, 13, PrintRankTeamWins
#beq, $t0, 14, PrintStrongestPlayerScore
#beq, $t0, 15, PrintStrongestTeamAttack
#beq, $t0, 16, PrintMatchesWonTeam
#beq, $t0, 17, PrintPlayerNotAssignedTeam
#beq, $t0, 18, LogicalDeletionTeam
#beq, $t0, 19, RecursiveSearchTeamRoaster

#========================================================================================
InsertPlayer:
jal IP
j InputSection

IP:
li $t0, 0
la $t1, ArrayPlayer

j LoopCercaSpazioGiocatore
LoopCercaSpazioGiocatore:
	slti $t3, $t0, MaxPlayers
	beq $t3, $zero, ELoopCercaSpazioGiocatore
	
	mul $t2, $t0, POff
	add $t2, $t2, $t1
	
	lb $t3, 0($t2)
	beq $t3, $zero, FLoopCercaSpazioGiocatore
	
	addi $t0, $t0, 1
	j LoopCercaSpazioGiocatore

ELoopCercaSpazioGiocatore:
	jr $ra
	

FLoopCercaSpazioGiocatore:
	move $s0, $t2
	
	li $v0, 42
	li $a1, 8999
	syscall
	move $t0, $a0
	addi $t0, $t0, 1000
	sw $t0, 0($s0)
	
	sw $zero, POffFlag($s0)
	
	sw $zero, POffLev($s0)
	
	sw $zero, POffWin($s0)
	
	sw $zero, POffLos($s0)
	
	li $v0, 42
	li $a1, 100
	syscall
	move $t0, $a0
	addi $t0, $t0, 50
	sw $t0, POffAtk($s0)
	
	li $v0, 42
	li $a1, 100
	syscall
	move $t0, $a0
	addi $t0, $t0, 50
	sw $t0, POffAtk($s0)
	
	li $v0, 42
	li $a1, 500
	syscall
	move $t0, $a0
	addi $t0, $t0, 100
	sw $t0, POffDef($s0)
	
	li $v0, 42
	li $a1, 10
	syscall
	move $t0, $a0
	addi $t0, $t0, 5
	sw $t0, POffEne($s0)
	
	li $v0, 8
	la $a0, PBufferNickname
	la $a1, 13
	syscall
	
	li $t0, 0
	la $t4, PBufferNickname
	j LoopInsertNickname
	
	LoopInsertNickname:
	slti $t2, $t0, NicknameChars
	beq $t2, $zero, FLoopInsertNickname
	
	lb $t2, 0($t4)
	add $t3, $s0, $t0
	addi $t3, $t3, POffNick
	sb $t2, 0($t3)
	
	addi $t0, $t0, 1
	j LoopInsertNickname
	
	FLoopInsertNickname:
		jr $ra
#========================================================================================

#========================================================================================
		

	
	
	
	
	
	

	
