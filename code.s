.data
    .align 2
prompt:  .asciiz "Enter the value of n: "
result:  .asciiz "Fibonacci(n) = "
a:   .word   1, 2, 3, 4    
bb:  .word   5, 6, 7, 8 
mat: .word   1, 1, 1, 0
temp: .word   1, 1, 1, 0

.text
.globl main
.globl output
.globl matrixPower
.globl multiply

# matrixPower(int mat[], int n)

matrixPower_exit:
    # This function is used to exit the matrixPower function
    lw $ra, ($sp)
    lw $s6, 4($sp)
    add $sp, $sp, 8
    jr $ra

matrixPower:
    # Base case: if n <= 1, return
    # $a1 contains n
    sub $sp, $sp, 8
    sw $ra, ($sp)
    sw $s6, 4($sp)

    li $s3, 1
    ble $t0, $s3, matrixPower_exit

    # Calculate n / 2 and call matrixPower(mat, n / 2)
    div $t0, $t0, 2    # n = n / 2
    # Check if n % 2 == 1 and call multiply(mat, temp)
    # andi $t0, $a1, 1   # Check if n % 2 == 1
    mfhi $s6

    #mflo $t0
    # Call multiply(mat, mat)
    jal matrixPower

    move $a0, $t0      # Restore the pointer to mat[]
    lw $s1, mat      # Load a[0] into $t0
    lw $s2, mat+4    # Load a[1] into $t1
    lw $s3, mat+8    # Load a[2] into $t2
    lw $s4, mat+12   # Load a[3] into $t3
    sw $s1, bb      # Store result[0] back into a[0]
    sw $s2, bb+4  
    sw $s3, bb+8  
    sw $s4, bb+12 
    jal multiply 

    beq $s6, 0, matrixPower_exit  # If n % 2 == 0, exit

    lw $t4, temp      # Load mat[0]
    lw $t5, temp+4    # Load mat[1]
    lw $t6, temp+8    # Load mat[2]
    lw $t7, temp+12   # Load mat[3]

    sw $t4, bb   
    sw $t5, bb+4  
    sw $t6, bb+8  
    sw $t7, bb+12 
    
    jal multiply

    # Exit program
    jal matrixPower_exit

output:
    # Print result
    li   $v0, 4
    la   $a0, result
    syscall

    # Output the fibonacci value
    move $a0, $t2
    li   $v0, 1
    syscall

    # Exit program
    li   $v0, 10
    syscall

multiply:
    # Load the values of a into registers
    lw $t0, mat      # Load a[0] into $t0
    lw $t1, mat+4    # Load a[1] into $t1
    lw $t2, mat+8    # Load a[2] into $t2
    lw $t3, mat+12   # Load a[3] into $t3
    
    # Load the values of bb into registers
    lw $t4, bb     # Load bb[0] into $t4
    lw $t5, bb+4   # Load bb[1] into $t5
    lw $t6, bb+8   # Load bb[2] into $t6
    lw $t7, bb+12  # Load bb[3] into $t7
    
    # Perform multiplication for result[0]
    mul $s0, $t0, $t4  # Multiply a[0] and bb[0], store result in $s0
    mul $s1, $t1, $t6  # Multiply a[1] and bb[2], store result in $s1
    add $s2, $s0, $s1  # Sum the two previous results, store in $s2 (result[0])

    # Perform multiplication for result[1]
    mul $s0, $t0, $t5  # Multiply a[0] and bb[1], store result in $s0
    mul $s1, $t1, $t7  # Multiply a[1] and bb[3], store result in $s1
    add $s3, $s0, $s1  # Sum the two previous results, store in $s3 (result[1])

    # Perform multiplication for result[2]
    mul $s0, $t2, $t4  # Multiply a[2] and bb[0], store result in $s0
    mul $s1, $t3, $t6  # Multiply a[3] and bb[2], store result in $s1
    add $s4, $s0, $s1  # Sum the two previous results, store in $s4 (result[2])

    # Perform multiplication for result[3]
    mul $s0, $t2, $t5  # Multiply a[2] and bb[1], store result in $s0
    mul $s1, $t3, $t7  # Multiply a[3] and bb[3], store result in $s1
    add $s5, $s0, $s1  # Sum the two previous results, store in $s5 (result[3])

    # Store the resulting matrix back into a
    sw $s2, mat      # Store result[0] back into a[0]
    sw $s3, mat+4  
    sw $s4, mat+8  
    sw $s5, mat+12  

    # Return to the calling function
    jr $ra 

main:
    # Print prompt for the user input
    li   $v0, 4
    la   $a0, prompt
    syscall

    # Read n from user
    li   $v0, 5
    syscall

    # Move the value read into $t0
    move $t0, $v0    # n value

    # Handle base cases
    li   $t1, 0      # fib(0)
    li   $t2, 1      # fib(1)
    li   $t3, 1      # counter

    # Check if n == 0 or n == 1
    beq  $t0, $zero, output
    beq  $t0, $t3, output

    #intializing the mat matrix
    lw $t4, mat      # Load mat[0]
    lw $t5, mat+4    # Load mat[1]
    lw $t6, mat+8    # Load mat[2]
    lw $t7, mat+12   # Load mat[3]

    # Call matrixPower(mat, n - 1)
    sub $t0, $t0, $t3
    jal matrixPower

    # Return Fibonacci(n) from mat[0]
    lw  $a0, mat                    #STORING THR RETURN VAL IN V1 
    li  $v0, 1
    syscall

    li $v0, 10
    syscall 
    .end main

