.data
	prmpt1:		.asciiz "How many inputs"
	prmptQ1: 	.asciiz "Enter the String: "
	prmptInput:	.asciiz "Input: "
	prmptOutput:.asciiz "Output: "
	menuText: 	.asciiz "\nWelcome to our MIPS project!\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\n"
	deneme: 	.asciiz "\nhello, "
	q3Text:		.asciiz "\nPlease enter an integer number for num_prime(N):\n"
	q3Out1:		.asciiz "prime("
	q3Out2:		.asciiz ") is "
	# string: 	.space 100
	userInput: 	.space 20
	exitText: 	.asciiz "\nProgram ends. Bye :)\n"
	buffer: 	.space 100
	bufferSmaller: .space 100
	spaceChar: 	.asciiz " "
	newLine: 	.asciiz "\n"
	nullChar: 	.byte '\0'
	int_array:  .word   0:26
	myArray: 	.space 104	# array of size 26*4
    tabChar:    .asciiz "\t"
	intAsStr:	.space 11
	primeArray: .word  0:80000

.text
menu:
	li		$v0, 4 		# print a string
	la		$a0, menuText	# setting string
	syscall

	#Get the user's input
	li		$v0, 5 		# $v0  -> to get input in menu 
	syscall

	# Store the result in $t0
	move 	$t0, $v0	# $t0 = v0

	beq		$t0, 1, question1			# if $t0 == $t1  target
	beq		$t0, 2, question2			# if $t0 =2 $t1 then target
	beq		$t0, 3, question3			# if $t0 =2 $t1 then target
	beq		$t0, 4, question4			# if $t0 =2 $t1 then target
	beq		$t0, 5, goodbye		# if $t0 =2 $t1 then target
	j		menu				# jump to menu
	

question1:
	li		$v0, 4 		# print a string
	la		$a0, prmptQ1	# setting string
	syscall

	jal     convert		# make all letters lowercase
    
	la 		$t0, bufferSmaller
	la 		$t7, nullChar
	lb 		$t7, 0($t7)
	li		$t1, 97


	jal     countCharLoop
    li      $t4, 0      # counter for PrintQ1Loop
    jal     loopPrintQ1
	
loopPrintQ1:
    beq     $t4, 26, goToMenu     # loop until end of alphabet
    li      $t0, 0
	li      $t3, 0               # int max = 0
    li      $t8, 0              # decimal number of char
    jal     findMaxChar

    sll     $t6, $t8, 2     
    sw      $zero, int_array($t6)

    addi     $t8, $t8, 97

	beq		$t3, 0, goToMenu
    
    li 		$v0, 11
	la 		$a0, ($t8)
	syscall

    li		$v0, 4 		# $t1 = 
    la      $a0, tabChar
    syscall

    li 		$v0, 1
	la 		$a0, ($t3)
	syscall

    li 		$v0, 4
	la 		$a0, newLine
	syscall

    addi    $t4, $t4, 1  # increments the index
    j 		loopPrintQ1

findMaxChar:
	beq     $t0, 104, loopEnd  # checks if index is at the end of the loop

	lw      $t2, int_array($t0)  # puts the array value at index $t0 to $t2

    bgt		$t2, $t3, updateValue	# if $t0 > $t1 then target

returnFindMaxChar:	
	addi    $t0, $t0, 4  # increments the index
	j       findMaxChar

updateValue:
    addi    $t3, $t2, 0
    sra     $t1, $t0, 2
    addi    $t8, $t1, 0  
    j       returnFindMaxChar

countCharLoop:
	lb		$t2, 0($t0)
	beq		$t2, $t7, loopEnd

	sub		$t4, $t2, $t1      # t4 = char - 'a'
	mul		$t5, $t4, 4         # &intarray[t4]
    lw      $t6, int_array($t5)

	addi	$t6, $t6, 1
	sw		$t6, int_array($t5)
	addi 	$t0, $t0, 1
	j 		countCharLoop

convert:
	la		$t0, buffer
	la 		$t1, spaceChar
	lb		$t1, 0($t1)
	la 		$t7, newLine
	lb 		$t7, 0($t7)

	li 		$v0, 8
	la		$a0, buffer
	li		$a1, 100
	syscall

	la 		$t3, bufferSmaller
	add 	$t4, $0, $0
	li 		$s0, 90

convertLoop:
	lb		$t2, 0($t0)
	beq		$t2, $t7, loopEnd 	# if $t0 == $t1 then target
	add		$t0, $t0, 1	
	ori 	$t4, $t2, 0x20
	sb 		$t4, 0($t3)
	add 	$t3, $t3, 1  #tbd how is this working
	j 		convertLoop



question2:
   	li		$v0, 4 		# print a string
	la		$a0, prmptInput	# setting string
	syscall

	li 		$v0, 8		# read input
	la		$a0, buffer	# buffer stores input string
	li		$a1, 100
	syscall
	
	li 		$t3, 0  	# index for buffer
	la		$t5, newLine 
	la 		$t6, spaceChar
	li		$s0, 0		# flag for end of input string
	li		$s1, 0		# flag for '-'
	li		$s2, 0		# for calculations
	li 		$s3, 10
	li		$s4, 0		# counter for int_array position
	li 		$t8, 0		# counter for intAsStr position
	jal 	loopForQ2Input
	

	li		$v0, 4 		# print a string
	la		$a0, int_array($zero)	# setting string
	syscall


	li 		$t4, 0
	# TODO call outerloopforq2
	jal		outerLoopForQ2
	
	j menu

loopForQ2Input:
	lb 		$t4, buffer($t3)			# load char of input
	beq 	$t4, $t5, setStrEndFlag		# if newline end loop
continueQ2InputLoop:
	li 		$t9, 0					# counter for intAsString
	beq 	$t4, $t6, calcIntVal 	# if space then calc int val
	beq		$t4, $t5, calcIntVal	
	sb 		$t4, intAsStr($t8)		# store char in intAsStr for calculations
	addi 	$t3, $t3, 1
	addi 	$t8, $t8, 1
	j 		loopForQ2Input
	

calcIntVal:
	# calculate integer value and store to int array
	# if flag = 1 => jr $ra 
	beq		$t8, 0,	endCalcIntVal
	lb		$t4, intAsStr($t9)
	beq 	$t4, 34, setNegFlag  # if the char is negative (-) set flag
	
	sub 	$t4, $t4, 48	# to get decimal value of int in str form
	lw		$t0, 0($t8)		# counter for mult by 10
	addi 	$t0, $t0, -1	# decrease by 1 becasue we look from the backside
	bne		$t0, $zero,	loopMult10	# if more than 1 digit mult by 10 n amount of times
continueCalcIntVal:
	addi	$s2, $t4, 0		# add result to calculations register
	addi	$t9, $t9, 1		# increment substring counter
	addi	$t8, $t8, -1
	j 		calcIntVal
	
endCalcIntVal:
	beq		$s1, 1, makeNegative  	# if negFlag = True adjust result
	sw		$s2, int_array($s4)		# store result in int array
	addi 	$s4, $s4, 1				# increment int array position counter
	beq		$s0, 1, loopEnd			# if at end go back to main func
	j 		loopForQ2Input

loopMult10:
	beq		$t0, $zero, continueCalcIntVal	# check if n is reached
	mul 	$t4, $t4, $s3	# mult $t4 by 10
	addi 	$t0, $t0, -1	# decrement mult counter
	j 		loopMult10

makeNegative:
	sub		$s2, $zero, $s2	# value = 0 - value
	li		$s1, 0	# reset negFalg
	j		endCalcIntVal

setStrEndFlag:
	li 		$s0, 1
	j 		continueQ2InputLoop

setNegFlag:
	li		$s1, 1
	addi	$t9, $t9, 1
	# j		continueCalcIntVal
	j 		calcIntVal

outerLoopForQ2:
	# make sure t4 is 0 at first !
    beq     $t4, 26, goToMenu     # loop until end of the array
	li		$t0, 0
	j		loopForQ2
 
    addi    $t4, $t4, 1  # increments the index
    j 		outerLoopForQ2


loopForQ2:
	
	# t0 -> address of int array 
	# t1 -> value in that address
	# t7 null char
	# we assume that $t0 is already initialized in q2
	lw      $t1, int_array($t0) # t1 = int_arr[t0]
	addi	$t2, $t0, 4			
    lw      $t2, int_array($t2)
	beq		$t2, $t7, loopEnd 	# if $t0 == $t1 then target
	# arr[t1] > arr[t2] => swap 
	bgt		$t1, $t2, swap

continueLoopForQ2:
	addi	$t0, $t0, 4
	j loopForQ2

swap:
	lw      $t3, int_array($t2) # temp register
	sw      $t1, int_array($t2) # adding t1 to t2
	sw      $t3, int_array($t1) # storing temp to t1s memory 

	j continueLoopForQ2

question3:
	# Q3 Display question  
	li		$v0, 4 		# print a string
	la		$a0, q3Text	# setting string
	syscall
	# Take integer input
	#t4 is user input integer
	li 		$v0, 5
	syscall
	move	$t4, $v0

	li		$t1, 2
	la 		$t7, nullChar
	j		outerLoopForQ3
displayOutput:

	# Display final output
	li		$v0, 4 		# print a string
	la		$a0, q3Out1	# setting string
	syscall

	li		$v0, 1 		# print a int
	la		$a0, ($t4)	# setting int user input
	syscall

	li		$v0, 4 		# print a string
	la		$a0, q3Out2	# setting string
	syscall

	li		$v0, 1 		# print a int
	la		$a0, ($t8)	# setting int !! assuming t8 is total counter of prime numbers!!
	syscall
	

   	j 		goToMenu

outerLoopForQ3: 
	beq		$t4, $t1, displayOutput
	li		$t0, 0
	j		loopForQ3

returnOuterLoop:
	addi	$t1, $t1, 1
	j		outerLoopForQ3

loopForQ3:
	lw      $t3, primeArray($t0) # t1 = int_arr[t0]

	beq		$t3, 0, addPrime 	# if $t0 == $t1 then target

	# test that divisible by $t3
	divu 		$t1, $t3    #Divides $t1/$t3
	mfhi 		$t5
	beq 		$t5, 0, returnOuterLoop

	addi	$t0, $t0, 4
	j loopForQ3
	
addPrime:
	sw      $t1, primeArray($t0) # t1 = int_arr[t0]
	addi    $t8, $t8, 1
	j		returnOuterLoop

question4:
   	j 		exit

goodbye:
	li		$v0, 4				# $v0 = 4
	la		$a0, exitText		# 
	syscall
	j		exit				# jump to exit
	
	
exit:
   	li      $v0, 10              # terminate program run and
    syscall

loopEnd:
	jr 		$ra		# go back to caller


goToMenu:
    j      menu
