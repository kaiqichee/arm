/*
 * taylor.s
 *
 *  Created on: Dec 2, 2020
 *      Author: Kaiqi Chee
 *	Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 */
 .text
 .global main
 .extern printf


main:
   ldr x2, =doubleVal	//set double input value to d1
   ldr d1, [x2]

   ldr x7, =integerVal  //set integer input value to x0
   ldr x0, [x7]

   ldr x2, =c
   ldr d0, [x2]
   ldr x2, =a
   ldr d2, [x2]

   bl start


start:
	sub SP, SP, #48
	str x0, [SP, #0]
 	str x1, [SP, #8]
 	str x2, [SP, #16]
 	str x3, [SP, #32]
 	str x4, [SP, #40]
 	str x5, [SP, #48]

	add x1, xzr, xzr	//set x1=0, x1 will be the iterator

 	cmp x1, x0			//input integer to i
 	b.lt taylor		    //if x1 is less than than x0, go to taylor function

 	ldr d0, =string
 	add SP, SP, #48		//restore the stack
 	bl printf			//print the result
	br x30

taylor:
	ldr d3, [x2] 		//set d3=1, d3 represents the numerator
	ldr d4, [x2] 		//set d4=1, d4 represents the denominator

	bl power			//solve for the numerator
	bl factorial		//solve for the denominator

	fdiv d5, d3, d4		//d5=d3/d4, term=power/factorial
 	fadd d0, d0, d5  	//add d5 to the result in d0

 	add x1, x1, #1		//increase the iterator x1 by 1
 	cmp x1, x0  		//compare x1 to x0
 	b.lt taylor			//if x1<x0 recurse back to taylor function

	add SP, SP, #48		//restore the stack
	ldr x2, =c			//let x2=0
	ldr d7, [x2]		//set d7=0
	fadd d7, d7, d0		//add the result to d7
	mov x0, #1			//set x=1
	scvtf d0, x0		//convert x0 from an into into a double, store in d0
	fmul d0, d0, d7		//d0=d0*d7
 	ldr x0, =string
 	bl printf			//print the result
	br x30				//branch to link register x30

power:
	add x4, xzr, xzr
	add x4, x4, x1    	//use x4 as the bound
	add x5, xzr, xzr	//use x5 as an iterator
	cmp x5, x4
	b.lt powerH
	br x30

powerH:
	fmul d3, d3, d1		//multiply the result by the user input double
	add x5, x5, #1		//increase the iterator by 1
	cmp x5, x4			//compare x5 to x4
	b.lt powerH			//if x5<x4, branch to powerH again
	br x30

factorial:
	add x4, xzr, xzr
	add x4, x4, x1    	//use x4 as the loop bound
	add x5, xzr, xzr	//use x5 as the iterator
	cmp x5, x4
	ldr x6, =a			//set x6=1
	ldr d6, [x6]		//set d6=1, let d6 be a type double iterator
	b.lt factorialH
	br x30

factorialH:
	fmul d4, d4, d6		//d4=d4*d6
	fadd d6, d6, d2		//increase d6 by 1
	add x5, x5, #1		//increase x5 by 1
	cmp x5, x4			//compare x5 and x4
	b.lt factorialH		//if x5<x4 branch to factorialH again
	br x30

.data

//input
 doubleVal:
   .double 2
 integerVal:
   .quad 2

//constants
 c:
   .double 0.0
 a:
   .double 1.0

//print string
 string:
   .ascii "The approximation is %f\n "

 .end

