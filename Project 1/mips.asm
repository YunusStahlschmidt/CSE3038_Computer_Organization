.data
	prmpt1:		.asciiz "How many inputs"
	prmptQ1: 	.asciiz "Enter the String: "
	prmptInput:	.asciiz "Input: "
	prmptOutput:.asciiz "Output: "
	welcomeText: .asciiz "\nWelcome to our MIPS project!"
	menuText: 	.asciiz "\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\n"
	deneme: 	.asciiz "\nhello, "
	q3Text:		.asciiz "\nPlease enter an integer number for num_prime(N):\n"
	q3Out1:		.asciiz "prime("
	q3Out2:		.asciiz ") is "
	userInput: 	.space 20
	exitText: 	.asciiz "\nProgram ends. Bye :)\n"
	buffer: 	.space 100
	bufferSmaller: .space 100
	spaceChar: 	.asciiz " "
	minusChar: 	.asciiz "-"
	newLine: 	.asciiz "\n"
	nullChar: 	.byte '\0'
	int_array:  .word   0:26
	myArray: 	.space 104	# array of size 26*4
    tabChar:    .asciiz "\t"
	intAsStr:	.space 11
	primeArray: .word  0:80000

.text
	li		$v0, 4 		# print a string
	la		$a0, welcomeText	# setting string
	syscall
menu:
	jal 	clearRegisters
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

    li		$v0, 4 		
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
	
	li 		$v0, 8
	la		$a0, buffer
	li		$a1, 100
	syscall

	li		$t0, 0
	li		$t2, 0			# sub string counter
	li		$s1, 0			# result register
	li		$s2, 0			# minus flag
	li		$s3, 0
	li		$s4, 0			# end flag
	li		$s5, 0			# number of elements
	la		$t9, minusChar
	la 		$t6, newLine
	la 		$t7, spaceChar
	lb 		$t6, 0($t6)
	lb 		$t7, 0($t7)
	lb 		$t9, 0($t9)

	j		loopInsideBuffer				# jump to target
	
continueQ2:
	li 		$t4, 0
	addi	$s6, $s5, -1
	# TODO call outerloopforq2
	jal		outerLoopForQ2
	j menu

loopInsideBuffer:  # 123 5 13
	lb      $t1, buffer($t0)
	# if space
	li 		$t3, 0	# reset sub string counter for calculations
	beq		$t1, $t7, calculateSubString	# if t1 == $t7 (space char) then calculateSubString
	# if null or new line
	beq		$t1, $t6, printQ2Result	# if $t0 == $t1 then target   3 5 2
	li 		$s1, 0	# reset result value
	# if minus
	beq		$t1, $t9, setMinusFlag	# if $t1 == $t9 ('-') then setMinusFlag
	sb		$t1, intAsStr($t2)
	addi	$t2, $t2, 1
	
continueLoopInsideBuffer:
	addi	$t0, $t0, 1
	j		loopInsideBuffer

calculateSubString:		#123
	beq		$t2, 0, addIntoIntArray	# if $t2 == 0 then target
	lb      $t4, intAsStr($t3)

	# convert char to decimal
	addi	$t4, $t4, -48			# $t4 => find int value of char 

	# multiply by 10**$t3
	addi	$t8, $t2, -1		# since t2 is 3, t8 will be 2 for 123
	j		multiplyByTen

continueCalculateSubString:
	add		$s1, $s1, $t4		# $s1 = $s1 + $t4
	addi	$t2, $t2, -1
	addi	$t3, $t3, 1
	j		calculateSubString
	
multiplyByTen:
	beq		$t8, 0, continueCalculateSubString	# if t8 == $t1 then continueCalculateSubString
	mul		$t4, $t4, 10
	addi	$t8, $t8, -1
	j		multiplyByTen		# jump to multiplyByTen
	
setMinusFlag:
	li		$s2, 1
	addi	$t0, $t0, 1
	j		loopInsideBuffer

addIntoIntArray:
	addi	$s5, $s5, 1
	beq		$s2, 1, subFromZero	# if $t0 == $t1 then target
continueAddIntoArray:
	sw		$s1, int_array($s3)
	addi 	$s3, $s3, 4
	beq		$s4, 1, continueQ2	# if $s4 == $t1 then target  # TODO asagi cekilecek
	li		$t2, 0
	j		resetIntAsStr				# jump to target
continueAddIntoArray2:
	li		$t2, 0
	
	j		continueLoopInsideBuffer				# jump to target

subFromZero:
	sub		$s1, $zero, $s1
	li		$s2, 0
	j		continueAddIntoArray				# jump to target

resetIntAsStr:
	beq		$t2, $t3, continueAddIntoArray2
	sb		$t6, intAsStr($t2)
	addi	$t2, $t2, 1
	j		resetIntAsStr				# jump to resetIntAsStr

printQ2Result:
	li		$s4, 1
	j	calculateSubString

outerLoopForQ2:
	# make sure t4 is 0 at first !
    beq     $t4, $s5, printSortedArray     # loop until end of the array
	li		$t0, 0
	li		$t2, 0
	li		$t5, 0
	j		loopForQ2
continueOuterLoopForQ2:
 
    addi    $t4, $t4, 1  # increments the index
    j 		outerLoopForQ2


loopForQ2:
	# t5 -> 0 at the begining 
	# s5 -> length of array
	# t7 null char
	# we assume that $t0 is already initialized in q2
	
	beq		$t5, $s6, continueOuterLoopForQ2	# if $t0 == $t1 then target # arr + index

	lw      $t1, int_array($t0) # t1 = int_arr[t0]
	addi	$t2, $t0, 4			
    lw      $t7, int_array($t2)
	# beq		$t2, $t7, loopEnd 	# if $t0 == $t1 then target
	# arr[t1] > arr[t2] => swap 
	# [...t1,t2....]
	bgt		$t1, $t7, swap

continueLoopForQ2:
	addi	$t0, $t0, 4
	addi	$t5, $t5, 1
	j loopForQ2

swap:
	# address of integer array -> 
	# index of element ->

	lw      $t3, int_array($t2) # temp register
	sw      $t1, int_array($t2) # replacing t2 with t1
	sw      $t3, int_array($t0) # storing temp to t1s memory 

	j continueLoopForQ2

printSortedArray:
	li		$t0, 0
	li		$t1, 0
	li      $t3, 0

printSortedArrayContinue:
	beq		$t0, $s5, menu	# if $t0 == $t1 then target
	mul		$t1, $t0, 4
	
	lw 		$t3, int_array($t1)

	li		$v0, 1 		# print a int
	la		$a0, ($t3)	# setting int !! assuming t8 is total counter of prime numbers!!
	syscall

	li		$v0, 4 		# $t1 = 
    la      $a0, spaceChar
    syscall
	

	addi	$t0, $t0, 1
	j printSortedArrayContinue

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

clearRegisters:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0

	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0

clearData:
	beq		$t0, 320000, clearBuffer	# if $t0 == $t1 then target
	sw		$zero, primeArray($t0)

	addi	$t0, $t0, 4
	j		clearData

clearBuffer:
	li 		$t0, 0
	j		clearIntArray				# jump to target

clearIntArray:
	beq		$t0, 104, clearBuffer2	# if $t0 == $t1 then target
	sw		$zero, int_array($t0)
	
	addi	$t0, $t0, 4
	j 		clearIntArray	

clearBuffer2:
	li 		$t0, 0
	j		continueClearRegisters				# jump to target

continueClearRegisters:
	beq		$t0, 100, loopEnd	# if $t0 == $t1 then target
	sb		$zero, buffer($t0)
	sb		$zero, bufferSmaller($t0)
	
	addi	$t0, $t0, 1
	j		continueClearRegisters