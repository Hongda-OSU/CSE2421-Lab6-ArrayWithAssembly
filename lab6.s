/* Name: Hongda Lin */
/* Date: 10/4/2021 */
.file "lab6.s"
.section	.rodata

/* grader could add more/less strings here, string are label with str(i) */
str1:
	.string "I'm big fan of small world. No like big word or good grammar. Grammar too hard."
str2:
	.string "I really hate how nice the weather is getting."
str3:
	.string "What"
str4:
	.string "Amazing, isn't it? With just the slightest touch the material warps around the skin effortlessly."
str5:
	.string "Can you believe how much ligma is going around this year?"


Info1:
	.string "The longest string in myArr[] is:\n%s\n"
Info2:
	.string "***The strings in myArr[], printed by order from longest to shortest, separate by newline***\n"
Info3:
	.string "\n%s\n"
Info4:
	.string "\nThe wordest string in myArr[] is:\nWords %d: %s\n\n"
Info5:
	.string "\n***The strings in myArr[], printed by most wordest to least wordest***\n"
Info6:
	.string "\nWords %d: %s\n"
Info7:
	.string "The first string in myArr[], followed by lexicographical order, is:\n%s\n"
Info8:
	.string "\n***The strings in myArr[], printed by lexicographical order***\n"

.align 8

/* Data sections */
.data

/* create an array of pointers myArr, grader could change how many strings stored in myArr[] */
myArr:	/* char *myArr[5] = {str1, str2, str3, str4, str5}; */
	.quad	str1
	.quad	str2
	.quad	str3
	.quad	str4
	.quad	str5

/* size is determined by how many strings in myArr[], default as 5 */
size:
	.long 5
/* grader choice for Part1, 0 as default, other as bonus */
choiceP1:
	.long 0
/* grader choice for Part2, 0 as default, other as bonus */
choiceP2:
	.long 0
/* grader choice for Part3, 0 as default, other as bonus */
choiceP3:
	.long 0

/* Linker section */

.global sortByLength
	.type sortByLength, @function
.global printByOrder
	.type printByOrder, @function

.global sortByWords
	.type sortByWords, @function
.global wordCounter
	.type wordCounter, @function
.global printByWords
	.type printByWords, @function

.global sortByLexi
	.type sortByLexi, @function
.global printByLexi
	.type printByLexi, @function

.global main
	.type main, @function
.text

main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$myArr, %rbx /* %rbx now have the address value of myArr, myArr[] is an array of char pointers, the first string is accessed by *myArr, second is *(myArr+1)... , %rbx will not be modified the whole program */
	movq	%rbx, %rdi /* %rdi is a pointer that contains the value of %rbx (address of myArr) */
        movl	size, %esi /* %esi is 5 */
        call 	sortByLength /* the strings in %rbx are now sorted by length */

	movl	choiceP1, %ecx /* store choice for Part1 to %ecx */
	cmpl	$0, %ecx /* if %ecx - 0 != 0, jump to BP1 (Bonus Part 1), else, default Part 1 */
	jne	BP1
	movq	$Info1, %rdi 
	movq	(%rbx), %rsi /* %rsi = *myArr, which is the address of str1 */
	movq	$0, %rax
	call	printf
	jmp	Part2 /* default Part 1 complete, jump to Part 2 */

BP1:
	movq	%rbx, %rdi 
	movl	size, %esi
	call	printByOrder /* print each strings in myArr[] by its length (longest to shortest) */

Part2:
  	movq	%rbx, %rdi 
	movl	size, %esi
	call	sortByWords /* the strings in %rbx are now sorted by words */

	movl	choiceP2, %ecx /* store choice for Part2 to %ecx */
	cmpl	$0, %ecx /* if %ecx - 0 != 0, jump to BP2 (Bonus Part 2), else, default Part 2 */
	jne	BP2
	movq	(%rbx), %rdi /* get the address of the wordest string in myArr[], which is *myArr, store in %rdi */
	call	wordCounter /* get the count of words, store in %esi */
	movl	%eax, %esi
	movq	$Info4, %rdi
	movq	(%rbx), %rdx /* get the address of the wordest string in myArr[], store in %rdx */
	movq	$0, %rax
	call	printf
	jmp	Part3 /* default Part 2 complete, jump to Part 3 */

BP2:
	movq	%rbx, %rdi 
	movl	size, %esi
	call	printByWords /* print each strings in myArr[] by its words (most wordest to least wordest) */

Part3:
	movq	%rbx, %rdi 
	movl	size, %esi
	call	sortByLexi /* the strings in %rbx are now sorted by lexicographical order */

	movl	choiceP3, %ecx /* store choice for Part3 to %ecx */
	cmpl	$0, %ecx /* if %ecx - 0 != 0, jump to BP3 (Bonus Part 3), else, default Part 3 */
	jne	BP3
	movq	$Info7, %rdi 
	movq	(%rbx), %rsi /* %rsi = *myArr, which is the address of str1 */
	movq	$0, %rax
	call	printf
	jmp	exit /* default Part 3 complete, jump to exit */

BP3:
	movq	%rbx, %rdi 
	movl	size, %esi
	call	printByLexi /* print each strings in myArr[] by lexicographical order */
	
exit:
	movq	$0, %rax
	leave
	ret
	.size main, .-main

/* function sort the elements in myArr[] by its length (long to short), %rdi is myArr, %esi is 5 */
sortByLength:
	pushq	%rbp	
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice */
	movq	%rdi, %rbx /* %rbx is the address value of myArr, need to update the strings stored in myArr[] by length */
	movl	%esi, %r12d /* %r12d is 5 */
	movl	$1, %r13d /* counter i: %r13d is 1 */
loopSBL1:
	cmpl	%r12d, %r13d /* if i-5 == 0, sorting complete, jump to exitSBL1 */
	je	exitSBL1
	movslq	%r13d, %rdx /* %rdx is the 64 bits extension of %r13d: i */
	movq	(%rbx, %rdx, 8), %r14 /* char *str(i) = *(ptr_myArr + i), store str(i) in %r14 */
	decq	%rdx /* j = i-1, %r13d not change */
	movl	%edx, %r15d /* counter j: %r15d = %edx, enter loopSBL2 */
loopSBL2:
	cmpl	$0, %r15d /* if j - 0 < 0, insertion complete, jump to exitSBL2 */
	jl	exitSBL2
	movq	%r14, %rdi /* store str(i) in %rdi */
	movq	$0, %rax
	call	strlen /* get the length of str(i) */
	movl	%eax, %esi /* store the return value from strlen to %esi */
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of %r15d: j */
	movq	(%rbx, %rdx, 8), %rdi /* char *str(j) = *(ptr_myArr+j), store str(j) in %rdi, str(j) in inner loop is not const */
	movq	$0, %rax
	call	strlen /* get the length of str(j) */
	movl	%eax, %edx /* store the return value from strlen to %edx */
	cmpl	%edx, %esi /* if %esi (length of str(i)) - %edx (length of str(j)) < 0, insertion complete, jump to exitSBL2 */
	jl	exitSBL2
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of %r15d: j */
	movq	(%rbx, %rdx, 8), %rdi /* store str(j) at %rdi */
	movq	%rdi, 8(%rbx, %rdx, 8) /* swap, str(j+1) = str(j) */
	decl	%r15d /* j-- */
	jmp	loopSBL2 /* continue loopSBL2 until insertion complete */
	
exitSBL2:
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of updated %r15d: j */
	movq	%r14, 8(%rbx, %rdx, 8) /* swap, str(j+1) = str(i) */
	incl	%r13d /* i++ */
	jmp	loopSBL1 /* continue loopSBL1 until sorting complete */

exitSBL1:
	popq	%rbx /* restore callee saved regiser */
	leave
	ret
	.size sortByLength, .-sortByLength

/* function that print all the strings in myArr[], by length, %rdi is myArr, %esi is 5 */
printByOrder:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice */
	movq	%rdi, %r12 /* %r12 contains the address value of myArr */
	movl	%esi, %r13d /* r13d is 5 */
	movl	$0, %r14d /* counter i: %r14d = 0 */
	movq	$Info2, %rdi 
	movq	$0, %rax
	call	printf
loopPBO:
	cmpl	%r13d, %r14d /* if i-5 == 0, print complete, jump to exitPBO */
	je	exitPBO
	movq	$Info3, %rdi 
	movslq	%r14d, %rdx /* %rdx is the 64 bits extension of updated %r14d: i */
	movq	(%r12, %rdx, 8), %rsi /* get the string at *(myArr+i) */
	movq	$0, %rax
	call	printf /* print string */
	incl	%r14d /* i++ */
	jmp	loopPBO /* continue loopPBO until printing complete */
exitPBO:
	popq	%rbx /* restore callee saved regiser */
	leave
	ret
	.size printByOrder, .-printByOrder

/* function sort the elements in myArr[] by the number of its composition of words, %rdi is myArr (sorted by length), %esi is 5 */
sortByWords:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice  */
	movq	%rdi, %rbx /* %rbx is the address value of myArr, need to update the strings stored in myArr[] by words */
	movl	%esi, %r12d /* %r12d is 5 */
	movl	$1, %r13d /* counter i: %r13d is 1 */
loopSBW1:
	cmpl	%r12d, %r13d /* if i-5 == 0, sorting complete, jump to exitSBW1 */
	je	exitSBW1
	movslq	%r13d, %rdx /* %rdx is the 64 bits extension of %r13d: i */
	movq	(%rbx, %rdx, 8), %r14 /* char *str(i) = *(ptr_myArr + i), store str(i) in %r14 */
	decq	%rdx /* j = i-1, %r13d not change */
	movl	%edx, %r15d /* counter j: %r15d = %edx, enter loopSBW2 */
loopSBW2:
	cmpl	$0, %r15d /* if j - 0 < 0, insertion complete, jump to exitSBW2 */
	jl	exitSBW2
	movq	%r14, %rdi /* store str(i) in %rdi */
	call	wordCounter /* get the number of words in str(i) */
	movl	%eax, %esi /* store the return value from wordCounter to %esi */
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of %r15d: j */
	movq	(%rbx, %rdx, 8), %rdi /* char *str(j) = *(ptr_myArr+j), store str(j) in %rdi, str(j) in inner loop is not const */
	call	wordCounter /* get the number of words in str(j) */
	movl	%eax, %edx /* store the return value from wordCounter to %edx */
	cmpl	%edx, %esi /* if %esi (words in str(i)) - %edx (words in str(j)) < 0, insertion complete, jump to exitSBW2 */
	jl	exitSBW2
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of %r15d: j */
	movq	(%rbx, %rdx, 8), %rdi /* store str(j) at %rdi */
	movq	%rdi, 8(%rbx, %rdx, 8) /* swap, str(j+1) = str(j) */
	decl	%r15d /* j-- */
	jmp	loopSBW2 /* continue loopSBW2 until insertion complete */
	
exitSBW2:
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of updated %r15d: j */
	movq	%r14, 8(%rbx, %rdx, 8) /* swap, str(j+1) = str(i) */
	incl	%r13d /* i++ */
	jmp	loopSBW1 /* continue loopSBW1 until sorting complete */

exitSBW1:
	popq	%rbx /* restore callee saved regiser */
	leave
	ret
	.size sortByWords, .-sortByWords

/* Return the number of words in current string, %rdi is the string address */
wordCounter:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice  */
	pushq	%r12 /* need to save %r12d, which is 5 in sortByWords */
	pushq	%r13 /* need to save %r13d, which is i in sortByWords */
	pushq	%r14 /* need to save %r14, which is str(i) in sortByWords */
	pushq	%r15 /* need to save %r15d, which is j in sortByWords */
	movq	%rdi, %r12 /* %r12 now contains the address of str */
       	movl	$0, %edi /* set %edi as count */
	movl	$0, %r14d /* set %r14d to 0 as determinator, %r14d = 0 means not in a word, %r14d = 1 means in a word */
	movl	$0, %r15d /* set %r15d as counter i to track the character */
loopWC:
	movslq	%r15d, %rdx
	movb	(%r12, %rdx), %r13b /* get each character (char ch = *(myArr + i)) from str, store in %r13b */
	cmpl	$0, %r13d /* %r13d is the ASCII value of %r13b, if %r13d - 0 = 0, '\0' detected, jump to exitWC */ 
	je	exitWC
	cmpl	$32, %r13d /* if %r13d - 32 = 0, whitespace detected, not in word, jump to isInWordCheck */
	jne	isInWordCheck
	movl	$0, %r14d /* if *str == ' ', not in word, set isInWord = 0 */
	jmp	incrAddress /* jump to incrAddress */

isInWordCheck:
	cmpl	$0, %r14d /* check the value of determinator, ch here is not ' ' */
	jne	incrAddress /* if isInWord is true (=1), then we are in a word, %edi is already incremented, search for the next ' ', jump to incrAddress */
	movl	$1, %r14d /* if isInWord is false (=0) and ch is not ' ', which means we found a word, set the determinator to 1 as we are in a word, increment %edi */
	incl	%edi /* count++ */

incrAddress:
	incl	%r15d /* i++ */
	jmp	loopWC /* continue loopWC until counting complete */
exitWC:
	movl	%edi, %eax /* %eax is the return value store count */
	popq	%r15 /* restore registers */
	popq	%r14 /* restore registers */
	popq	%r13 /* restore registers */
	popq	%r12 /* restore registers */
	popq	%rbx /* restore callee saved regiser */
	leave
	ret
	.size wordCounter, .-wordCounter

/* function that print all the strings in myArr[], by wordest, %rdi is myArr, %esi is 5 */
printByWords:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice */
	movq	%rdi, %r12 /* %r12 contains the address value of myArr */
	movl	%esi, %r13d /* r13d is 5 */
	movl	$0, %r14d /* counter i: %r14d = 0 */
	movq	$Info5, %rdi 
	movq	$0, %rax
	call	printf
loopPBW:
	cmpl	%r13d, %r14d /* if i-5 == 0, print complete, jump to exitPBW */
	je	exitPBW
	movslq	%r14d, %rdx /* %rdx is the 64 bits extension of updated %r14d: i */
	movq	(%r12, %rdx, 8), %rdi /* get the string at *(myArr+i) */
	call	wordCounter /* get the count of words of *(myArr+i) */
	movl	%eax, %esi /* store the value in %esi */
	movq	$Info6, %rdi
	movslq	%r14d, %rcx /* %rcx is the 64 bits extension of updated %r14d: i */
	movq	(%r12, %rcx, 8), %rdx /* get the string at *(myArr+i). store in %rdx */
	movq	$0, %rax
	call	printf /* print string */
	incl	%r14d /* i++ */
	jmp	loopPBW /* continue loopPBW until printing complete */
exitPBW:
	popq 	%rbx /* restore callee saved regiser */
	leave
	ret
	.size printByWords, .-printByWords	

/* function sort the elements in myArr[] by lexicographical order , %rdi is myArr (sorted by words), %esi is 5 */
sortByLexi:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice  */
	movq	%rdi, %rbx /* %rbx is the address value of myArr, need to update the strings stored in myArr[] by lexicographical order */
	movl	%esi, %r12d /* %r12d is 5 */
	movl	$1, %r13d /* counter i: %r13d is 1 */
loopSBI1:
	cmpl	%r12d, %r13d /* if i-5 == 0, sorting complete, jump to exitSBI1 */
	je	exitSBI1
	movslq	%r13d, %rdx /* %rdx is the 64 bits extension of %r13d: i */
	movq	(%rbx, %rdx, 8), %r14 /* char *str(i) = *(ptr_myArr + i), store str(i) in %r14 */
	decq	%rdx /* j = i-1, %r13d not change */
	movl	%edx, %r15d /* counter j: %r15d = %edx, enter loopSBI2 */
loopSBI2:
	cmpl	$0, %r15d /* if j - 0 < 0, insertion complete, jump to exitSBI2 */
	jl	exitSBI2
	movq	%r14, %rdi /* save str(i) in %rdi */
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of %r15d: j */
	movq	(%rbx, %rdx, 8), %rsi /* char *str(j) = *(ptr_myArr+j), store str(j) in %rsi, str(j) in inner loop is not const */
	call	strcmp
	cmpl	$0, %eax /* if %eax - 0 > 0, insertion complete, jump to exitSBI2 */
	jg	exitSBI2
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of %r15d: j */
	movq	(%rbx, %rdx, 8), %rdi /* store str(j) at %rdi */
	movq	%rdi, 8(%rbx, %rdx, 8) /* swap, str(j+1) = str(j) */
	decl	%r15d /* j-- */
	jmp	loopSBI2 /* continue loopSBI2 until insertion complete */
	
exitSBI2:
	movslq	%r15d, %rdx /* %rdx is the 64 bits extension of updated %r15d: j */
	movq	%r14, 8(%rbx, %rdx, 8) /* swap, str(j+1) = str(i) */
	incl	%r13d /* i++ */
	jmp	loopSBI1 /* continue loopSBI1 until sorting complete */

exitSBI1:
	popq	%rbx /* restore callee saved regiser */
	leave
	ret
	.size sortByLexi, .-sortByLexi

/* function that print all the strings in myArr[] by lexicographical order, %rdi is myArr, %esi is 5 */
printByLexi:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx /* save callee saved regiser %rbx as good practice */
	movq	%rdi, %r12 /* %r12 contains the address value of myArr */
	movl	%esi, %r13d /* r13d is 5 */
	movl	$0, %r14d /* counter i: %r14d = 0 */
	movq	$Info8, %rdi 
	movq	$0, %rax
	call	printf
loopPBI:
	cmpl	%r13d, %r14d /* if i-5 == 0, print complete, jump to exitPBI */
	je	exitPBI
	movq	$Info3, %rdi 
	movslq	%r14d, %rdx /* %rdx is the 64 bits extension of updated %r14d: i */
	movq	(%r12, %rdx, 8), %rsi /* get the string at *(myArr+i) */
	movq	$0, %rax
	call	printf /* print string */
	incl	%r14d /* i++ */
	jmp	loopPBI /* continue loopPBO until printing complete */
exitPBI:
	popq	%rbx /* restore callee saved regiser */
	leave
	ret
	.size printByLexi, .-printByLexi	
