/*
 * fibonacci.s
 *
 *  Created on: Oct 28, 2020
 *      Author: Kaiqi Chee
 *		Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 */

 .text
 .global main
 .extern printf
 .data
 .equ input, 2			//input number n


 main:
	 mov x0, input		//put input in x0, so x0=n
	 bl start			//branch to start function

 string:
	.asciz "%d\n"

 start:
 	sub SP, SP, #32		//create space on the stack
 	str x3, [SP, #24]	//store the temporary variable in x3 on the stack
 	str x0, [SP, #16]	//store n in x0 on the stack
 	str x1, [SP, #8]	//store x1=fibonacci current on stack
 	str x2, [SP, #0]	//store x2=fibibonacci previous on stack
 	add x1, xzr, xzr	//set x1=0
 	add x1, x1, #1		//set x1=1
 	add x2, xzr, xzr	//set x2=0
 	add x3, xzr, xzr	//set x3=0
 	cmp x0, #1			//compare n value to 1
 	b.gt fibo		    //if n is greater than 1, go to fibo function
 	mov x0, x1			//if not, move the fibonacci current to x0
 	ldr x0, =string
 	bl printf			//print the result
	add SP, SP, #32		//restore the stack
	br x30				//branch to link register x30

 fibo:
	add x3, xzr, x2 	//let x3=x2 which holds fibonacci previous
 	add x2, xzr, x1 	//fibonacci prev=fibonacci current
 	add x1, x1, x3		//fibonacci current+=fibonacci prev
 	sub x0, x0, #1		//n-=1
 	cmp x0, #1			//compare n value to 1
 	b.gt fibo			//if n>1 recurse back to fibo function
 	mov x0, x1			//else, move fibonacci current to x0
 	add SP, SP, #32		//restore the stack
 	ldr x0, =string
 	bl printf			//print the result
	br x30				//branch to link register x30

 .end
