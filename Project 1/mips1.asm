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
	#nullChar: 	.asciiz NULL
	int_array:  .word   0:26
	myArray: 	.space 104	# array of size 26*4

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

	# # Display the int input
	# li		$v0, 1		# $v0 =1 
	# move 	$a0, $t0 
	# syscall

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

	# li 		$v0,8 		#take in input
	# la 		$a0, string #load byte space into address
	# li 		$a1, 100 	# allocate the byte space for string
	# syscall
	# move 	$t0, $v0	

	# li		$v0, 4 		# print a string
	# la		$a0, string	# setting string
	# syscall

	jal convert		# make all letters lowercase

	la 		$t0, bufferSmaller
	la 		$t7, newLine
	lb 		$t7, 0($t7)
	li		$t1, 97
	la		$t3, int_array
	
	jal loop1
	

	# lb		$t2, 0($t0)
	# # we should add it to list
	# addi 	$t0, $t0, 1

   	j menu
	
loop1:
	# la 		$t0, bufferSmaller  
	lb		$t2, 0($t0)
	beq		$t2, $t7, loop1end
	
	li 		$v0, 11
	la 		$a0, ($t2)
	syscall
	
	#li		$t4, 4
	# abcde
	# decimal of $t0 - decimal of 'a'


	# we should add it to list
	

	addi 	$t0, $t0, 1
	j loop1

loop1end:
	li 		$v0, 4
	la 		$a0, int_array
	syscall

	jr 		$ra		# go back to caller

question2:
   	j exit


question3:
   	j exit


question4:
   	j exit


goodbye:
	li		$v0, 4				# $v0 = 4
	la		$a0, exitText		# 
	syscall
	j		exit				# jump to exit
	
	
exit:
   	li      $v0, 10              # terminate program run and
    syscall


# PS CODE

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
	beq		$t2, $t7, convertEnd 	# if $t0 == $t1 then target
	add		$t0, $t0, 1	
	ori 	$t4, $t2, 0x20
	sb 		$t4, 0($t3)
	add 	$t3, $t3, 1
	j 		convertLoop

convertEnd:
	li 		$v0, 4
	la 		$a0, bufferSmaller
	syscall

	jr 		$ra		# go back to caller
	
	