#Alejandro Godinez Rodriguez 714181
#Ricardo Salas Venegas 716159
.data

.text
#N(discs) constant is initialized with 8 (max hanoi size tower)
addi $s0, $zero, 8
#function base: movHanoi(N,origin,destiny,auxiliar) 
MAIN:
	#Assign pointers to arrays
	addi $s1, $zero, 0x10010000 #First tower goes to 0x10010000
	ori $s2, $s1, 0x20 #Second towe goes to 0x10010020
	ori $s3, $s1, 0x40 #Third tower goes to 0x10010040
	addi $a0, $zero, 1
	
	#on the location stored on $s0 we need to store de 4 disks
	add $t2,$s0,$zero
	jal INIT_T
	
	#apply hanoi tower algorithm
	jal MOV_HANOI
	
	#End Algorithm
	j EXIT

INIT_T:
	#on the location x10010000 we need to store 4 3 2 1 on each space on memory
	sw $t2, 0($s1)
	
	#update the data stored in the tower array
	addi $t2,$t2,-1
	
	#uodate the location of the pointer of the tower
	addi $s1,$s1,4
	
	#update iterator
	addi $t1,$t1,1
	#add data on the addresses
	bne $t1,$s0,INIT_T
	jr $ra 
	
MOV_HANOI:
	#If base case, stack will save ra and n
	bne $s0, $a0, MOV_STACK
	
	#Take out disk from originT to destinyT
	#Update memory pointer on both towers
	addi $s1, $s1, -4
	lw $t7, 0($s1)   
	sw $zero, 0($s1)
	sw $t7, 0($s3)  
	addi $s3, $s3, 4 	
	jr $ra
	
	
	
MOV_STACK:
	#Save ra and n on stack
	addi $sp ,$sp, -8 
	sw $ra, 4($sp)
	sw $s0, 0($sp)  
	
	#Swap s2 and s3 and update (origin, destiny, auxiliary)
	jal SWAP_S2_S3
	jr $ra

SWAP_S1_S2:
	#Swap origin-auxiliar tower
	add $t7, $zero, $s1 
	add $s1, $zero, $s2  
	add $s2, $zero, $t7  
	jr $ra


SWAP_S2_S3:	
	
	#Swap auxiliar-destiny tower	
	add $t7, $zero, $s3 
	add $s3, $zero, $s2 
	add $s2, $zero, $t7  	
	
	#Go back into the recursive call
	bne  $t4, $zero, EXIT_HANOI 
	
	#Update N to keep up with recursivity
	addi $s0, $s0, -1	
	
	#Go back to recursive call
	jal MOV_HANOI 
	
	#Recursive flag in stop
	addi $t4, $zero, 1
	
	#Swap auxiliar-destiny tower
	j SWAP_S2_S3
 	
 			
EXIT_HANOI: 
	#Trace back stack recusive call	
	#Flag on continue with recursivity
	add  $t4, $zero, $zero
	lw   $s0, 0($sp)	
	lw   $ra, 4($sp)	
	addi $sp, $sp, 8


BASE_CASE:
	#Load disk from origin tower
	addi $s1, $s1, -4	
	
	#Erase disk from origin tower
	lw $t3, 0($s1)   
	sw $zero, 0($s1)
	
	#N disk goes into destiny tower 
	sw $t3, 0($s3)
	
	#Update memory space pointer
	addi $s3, $s3, 4 	
	
	#Update on the stack recursive calls
	addi $sp, $sp, -8 
	sw $ra, 4($sp)   
	sw $s0, 0($sp)   
	
	#Swap from origin-auxiliar tower	
	add $t7, $zero, $s1 
	add $s1, $zero, $s2
	add $s2, $zero, $t7
	addi $s0, $s0, -1
	
	#Keep on with the recursivity
	jal MOV_HANOI	
	
	#Trace back recursive call data from stack
	lw   $ra, 4($sp)	
	addi $sp, $sp, 8
	
	#Swap origin-auxiliar tower
	j SWAP_S1_S2
	
	jr $ra
		
EXIT: 			#END OF PROGRAM 'EXIT SUCCESS'