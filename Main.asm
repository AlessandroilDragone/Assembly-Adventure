
.data
Newline: .asciiz "\n"
IDiag1: .asciiz "Ron costrui` una macchina del tempo, ma non aveva calcolato che, una volta utilizzata, si sarebbe incontrato con i suoi cloni, provenienti da universi paralleli"
IDiag2: .asciiz "Inserisci un numero intero per i vari campi del videogioco"

#ALL -1
BufferInput: .byte 3
.eqv MaxPlayers 21
.eqv MaxTeams 21
.eqv MaxMatch 21
.eqv MaxInit 21
.eqv MaxPlayersInTeam 6
.eqv NumberIDDgit 5
#Max Init deve corrispondere al numero massimo tra le costanti qua sopra. Al momento si puo` modificare fino a 25 elementi per gli array

PBufferNickname: .byte 14
.eqv PNicknameChars 14

BufferID: .byte 5

TBufferNickname: .byte 7
.eqv TNicknameChars 7


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
jal InitializationArrays

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

	InitializationArrays:
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
#beq $t0, 0, Database
beq $t0, 1, InsertPlayer
#beq $t0, 2, InsertTeam
#beq $t0, 3, AssignPlayer
#beq $t0, 4, PrintPlayers
#beq $t0, 5, PrintTeams
#beq $t0, 6, SearchPlayerID
#beq $t0, 7, SearchTeamName
#beq $t0, 8, DuelSim
#beq $t0, 9, MatchSim
#beq $t0, 10, RegisterMatch
#beq $t0, 11, PrintMatchHistory
#beq $t0, 12, PrintRankPlayerScore
#beq $t0, 13, PrintRankTeamWins
#beq $t0, 14, PrintStrongestPlayerScore
#beq $t0, 15, PrintStrongestTeamAttack
#beq $t0, 16, PrintMatchesWonTeam
#beq $t0, 17, PrintPlayerNotAssignedTeam
#beq $t0, 18, LogicalDeletionTeam
#beq $t0, 19, RecursiveSearchTeamRoaster

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
	li $a1, 14
	syscall
	
	li $t0, 0
	la $t4, PBufferNickname
	j LoopInsertNickname
	
	LoopInsertNickname:
	slti $t2, $t0,PNicknameChars
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
InsertTeam:
jal IT
addi $sp, $sp, 4
j InputSection

IT: 
addi $sp, $sp, -4
sw $ra, 0($sp)

li $t0, 0
la $t1, ArrayTeam
j LoopCercaSpazioTeam

LoopCercaSpazioTeam:
slti $t2, $t0, MaxTeams
beq $t2, $zero, ELoopCercaSpazioTeam

mul $t2, $t0, TOff
add $t2, $t2, $t1
lw $t3, 0($t2)
beq $t3, $zero, FLoopCercaSpazioTeam

addi $t0, $t0, 1
j LoopCercaSpazioTeam

ELoopCercaSpazioTeam:
	jr $ra

FLoopCercaSpazioTeam:
	move $s0, $t3

	li $v0, 42
	li $a1, 8999
	syscall
	move $t0, $a0
	addi $t0, $t0, 1000
	sw $t0, 0($s0)

	sw $zero, TOffWin($s0)
	sw $zero, TOffLos($s0)
	sw $zero, TOffFlag($s0)

	li $t0, 0
	j LoopInsertIDs

	LoopInsertIDs:
	slti $t1, $t0, MaxPlayersInTeam
	beq $t1, $zero, FLoopInsertIDs.InsertTeamNickname

	li $v0, 5
	syscall
	move $s1, $v0

	beq $v0, $zero, VerifyOnePlayerInTeam

	li $t1, 0
	la $t2, ArrayPlayer
	jal CercaIDGiocatorePerTeam	

	addi $t0, $t0, 1
	j LoopInsertIDs

	CercaIDGiocatorePerTeam:
	slti $t3, $t1, MaxPlayers
	beq $t3, $zero, LoopInsertIDs

	mul $t3, $t1, POff
	add $t3, $t3, $t2

	lw $t4, 0($t3)
	beq $s1, $t4, InserisciIDGiocatoreInTeam
	
	addi $t1, $t1, 1
	j CercaIDGiocatore

VerifyOnePlayerInTeam:
	beq $t0, 0, LoopInsertIDs
	j FLoopInsertIDs.InsertTeamNickname
	

InserisciIDGiocatoreInTeam:
	lw $t2, TOffID1($s0)
	beq $t2, $zero, InserisciIDGiocatoreInTeam1

	lw $t2, TOffID2($s0)
	beq $t2, $zero, InserisciIDGiocatoreInTeam2

	lw $t2, TOffID3($s0)
	beq $t2, $zero, InserisciIDGiocatoreInTeam3

	lw $t2, TOffID4($s0)
	beq $t2, $zero, InserisciIDGiocatoreInTeam4

	lw $t2, TOffID5($s0)
	beq $t2, $zero, InserisciIDGiocatoreInTeam5

InserisciIDGiocatoreInTeam1:
	sw $s1, TOffID1($s0)
	jr $ra

InserisciIDGiocatoreInTeam2:
	sw $s1, TOffID2($s0)
	jr $ra

InserisciIDGiocatoreInTeam3:
	sw $s1, TOffID3($s0)
	jr $ra

InserisciIDGiocatoreInTeam4:
	sw $s1, TOffID4($s0)
	jr $ra

InserisciIDGiocatoreInTeam5:
	sw $s1, TOffID5($s0)
	jr $ra


FLoopInsertIDs.InsertTeamNickname:
	li $v0, 8
	la $a0, TBufferNickname
	li $a1, 7

	li $t0, 0
	la $t1, ArrayTeam	
	la $t2, TBufferNickname
	j LoopInsertTeamNickname

InsertTeamNickname:
	slti $t3, $t0, TNicknameChars
	beq $t3, $zero, FInsertTeamNickname

	add $t3, $t1, $t0
	add $t4, $t2, $t0
	lb $t5, 0($t4)

	sb $t5, 0($t3)
	
	addi $t0, $t0, 1
	j InsertTeamNickname


FInsertTeamNickname:
	lw $ra, 0($sp)
	jr $ra
#========================================================================================

#========================================================================================
.data
APDiag1: .asciiz "Inserisci il codice del giocatore da inserire (numero intero)"
APDiag2: .asciiz "Inserisci il codice del team in cui inserirlo (numero intero)"
APDiag3: .asciiz "Eseguito con Successo"
AssignPlayer:
	jal AP
	addi $sp, $sp, 4
	j InputSection

AP:
	addi $sp, $Sp, -4
	sw $ra, 0($sp)

	li $v0, 4
	la $a0, APDiag1
	syscall


	li $v0, 5
	syscall
	move $s0, $v0

	li $t0, 0
	la $t1, ArrayPlayer
	jal APloopCercaGiocatore

	li $v0, 4
	la $a0, APDiag2
	syscall


	li $V0, 5
	syscall
	move $s1, $v0

	li $t0, 0
	la $t1, ArrayTeam
	jal APloopCercaTeam

	lw $t0, TOffID1($s2)
	beq $t0, $zero, InsertPlayerSlot1

	lw $t0, TOffID2($s2)
	beq $t0, $zero, InsertPlayerSlot2

	lw $t0, TOffID3($s2)
	beq $t0, $zero, InsertPlayerSlot3

	lw $t0, TOffID4($s2)
	beq $t0, $zero, InsertPlayerSlot4

	lw $t0, TOffID5($s2)
	beq $t0, $zero, InsertPlayerSlot5

	APloopCercaGiocatore:
	slti $t2, $t0, MaxPlayers
	beq $t2, $zero, EAPloopCercaGiocatore

	mul $t2, $t0, POff
	add $t2, $t2, $t1
	lw $t3, 0($t2)
	beq $t3, $s0, FAPloopCercaGiocatore
	
	addi $t0, $t0, 1
	j APloopCercaGiocatore

	FAPloopCercaGiocatore:
	jr $ra

	EAPloopCercaGiocatore:
	j AP
	

	APloopCercaTeam:
	slti $t2, $t0, MaxTeams
	beq $t2, $zero, EAPloopCercaTeam

	mul $t2, $t0, TOff
	add $t2, $t2, $t1
	lw $t3, 0($t2)

	beq $t3, $s1, FAPloopCercaTeam
	
	FAPloopCercaTeam:
	move $s2, $t2
	jr $ra

	EAPloopCercaTeam:
	j AP
	
	InsertPlayerSlot1:
	sw $s0, TOffID1($s2)
	j AP1

	InsertPlayerSlot2:
	sw $s0, TOffID2($s2)
	j AP1

	InsertPlayerSlot3:
	sw $s0, TOffID3($s2)
	j AP1

	InsertPlayerSlot4:
	sw $s0, TOffID4($s2)
	j AP1

	InsertPlayerSlot5:
	sw $s0, TOffID5($s2)
	j AP1


	AP1:
	li $v0, 4
	la $a0, APDiag3
	syscall

	lw $ra, 0($sp)
	jr $ra
#========================================================================================

	

	
