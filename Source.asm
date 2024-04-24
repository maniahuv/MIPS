.data 
	Mess1: 	.asciiz "Nhap so luong chuoi: "
	Mess2: 	.asciiz "Cac chuoi doi xung la:\n"
	A: 	.space 20
	Aend: 	.word
.text
#--------------------------------------------------------------------------------------------
# @brief	Nhập số lượng chuỗi, số lượng chuỗi phải khác 0 
#--------------------------------------------------------------------------------------------
	li $v0, 4		# Hiển thị: Mess1
	la $a0, Mess1
	syscall
	li $v0, 5		# Nhập n
	syscall
	addu $s0, $v0, $0  	
	la $s4, Aend 		# địa chỉ lưu các chuỗi palindrome 
	
#--------------------------------------------------------------------------------------------
# @brief	Nhập và kiểm tra từng chuỗi palindrome
#--------------------------------------------------------------------------------------------
main:
	li $v0, 8		# Nhập chuỗi A
	la $a0, A
	li $a1, 19
	syscall

	li $t0, '\n'		# gán t0 = '\n'
	
#--------------------------------------------------------------------------------------------
# @brief		Trả về địa chỉ cuối cùng chuỗi A
# @param[in]	$a0	Địa chỉ chuỗi A
# @param[out]	$a0	Địa chỉ kí tự kết thúc của chuỗi A
#--------------------------------------------------------------------------------------------
findEndString:
	lb $t1, 0($a0)			 # load giá trị kí tự 
	beq $t1, $t0, end_findEndString  # nếu A[i]='\n' thì end 
	addi $a0, $a0, 1		 # tăng địa chỉ load
	j findEndString
end_findEndString:
	
	addu $s3, $zero, $a0		 # $s3 lưu địa chỉ kết thúc chuỗi A
	la $a1, A 			 # $a1 = địa chỉ chuỗi A 
	li $t7, 1			 # $t7 = giá trị bool cho hàm kiểm tra chuỗi Palindrome (1 = true)

#--------------------------------------------------------------------------------------------
# @brief		Kiểm tra chuỗi palindrome
# @param[in]	$a1	Địa chỉ kí tự đầu chuỗi A
# @param[in]	$a0	Địa chỉ kí tự cuối chuỗi A
# @param[out]	$t7	[Bool] 1 - true: là chuỗi palindrome
#			       0 - false: không là chuỗi palindrome
#--------------------------------------------------------------------------------------------
isPalindrome:
	slt $t8, $a1, $a0		 # so sánh địa chỉ đầu và cuối
	beq $t8, $zero, end_isPalindrome # nếu đầu >= cuối thì end_isPalindrome
	lb $t1, 0($a1)			 # $t1 = kí tự phần đầu A
	lb $t2, -1($a0)			 # $t2 = kí tự phần cuối A 
	beq $t1, $t2, continue		 # nếu kí tự đầu và cuối giống nhau thì tiếp tục
 	li $t7, 0			 # không thì t7 = 0 (không là chuỗi palindrome) -> thoát
 	j end_isPalindrome
continue: addi $a1, $a1, 1		# tiếp tục kiểm tra các kí tự còn lại
	  addi $a0, $a0, -1  		
	  j isPalindrome	
end_isPalindrome:			# kiem tra xong 
	la $a1, A
	bne $t7, $zero, storeString	# Nếu $t7 = 1 -> storeString
	
#--------------------------------------------------------------------------------------------
# @brief		Lưu chuỗi Palindrome vào bộ nhớ
# @param[in]	$t7	giá trị hàm isPalindrome
# @param[in]	$a1	Địa chỉ kí tự đầu chuỗi A
# @param[in]	$s3	Địa chỉ kí tự cuối chuỗi A
# @param[in]	$s4	Địa chỉ kí tự cuối chuỗi Aend (lưu các chuỗi palindrome)
#--------------------------------------------------------------------------------------------
end_storeString:
	beq $t7, $zero, next		# Nếu $t7 = 0 (chuỗi không là palindrome) -> next
	sb $t0, 0($s4)			# Còn không thì thêm kí tự '\n' vào Aend để ngăn cách
	addi $s4, $s4, 1		# Tăng địa chỉ kết thúc Aend
next:	
	addi $s0, $s0, -1		# n--
	beq $s0, $zero, end_main	# Nếu n = 0 thì kết thúc, -> end_main
	j main				 
storeString:    
	lb $t8, 0($a1) 			# lưu từ A vào Aend
	sb $t8, 0($s4)
	addi $a1, $a1, 1
	addi $s4, $s4, 1
	slt $t8, $a1, $s3		
	beq $t8, $zero, end_storeString # Nếu $a1 >= $s3 (địa chỉ phần tử cuối A) -> end_storeString
	j storeString			# không thì tiếp tục lưu các phần tử còn lại
					
end_main:
#--------------------------------------------------------------------------------------------
# @brief		In các chuỗi palindrome
#--------------------------------------------------------------------------------------------
printPalindrome:				
	  la $t1, Aend			# Hiển thị: Mess2
	  li $v0, 4
	  la $a0, Mess2
	  syscall
	  
	  li $v0, 4			# Hiển thị: Aend
	  la $a0, Aend
	  syscall
end_printPalindrome:
