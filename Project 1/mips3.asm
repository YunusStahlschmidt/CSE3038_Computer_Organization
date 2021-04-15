 .data
	prmpt1:		.asciiz "How many inputs"
	prmptQ1: 	.asciiz "Enter the String: "
	menuText: 	.asciiz "\nWelcome to our MIPS project!\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\n"
	deneme: 	.asciiz "\nhello, "
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
	add 	$t3, $t3, 1
	j 		convertLoop



question2:
   	j 		exit

question3:
   	j 		exit


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
