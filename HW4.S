/* Bryan Dilks */
/* EECE.3170: Microprocessors 1 */
/* UMASS Lowell */
    
/* Template PortTest 3 */
    
.text		/* Text Contains Code */
.set noreorder	/* Disable Instructions */
.global main	/* Define Main Label as a global Entity */
.ent main	/* Entry Point */

#include <xc.h>	/* Allows use of SFR names, bit masks, etc. */

main:
    sw	zero, TRISA
    sw	zero, ANSELA
    not t0, zero
    sw	t0, TRISB
    sw	zero, ANSELB
    sw	zero, TRISC
    sw	zero, ANSELC
    
    li	t0, _PORTA_RA0_MASK
    li	t1, _PORTC_RC9_MASK
    li	t5, _PORTB_RB7_MASK
    li	t6, _PORTB_RB13_MASK
 
    
pollS1:
    lw	    t2, PORTB   /* Read Port B */
    andi    t3, t2, _PORTB_RB7_MASK /* Check S1 */
    bne	    t3, zero, copyS1
    nop
    beq	    t3, t5, pollS2
    nop
    jal	    delay
    nop
    lw	    t2, PORTB
    andi    t3, t2, _PORTB_RB7_MASK
    bne	    t3, zero, copyS1
    nop
    sw	    t0, LATAINV
    
copyS1:
    add	    t5, t3, zero
    
pollS2:
    andi    t4,t2, _PORTB_RB13_MASK
    bne	    t4, zero, copyS2
    nop
    beq	    t4, t6, pollS1
    nop
    jal	    delay
    nop
    lw	    t2, PORTB
    andi    t4, t2, _PORTB_RB13_MASK
    bne	    t4, zero, copyS2
    nop
    sw	    t1, LATCINV
    
copyS2:
    add	    t6, t4, zero
    j	    pollS1
    nop
    
    
spin:
    j	    spin
    nop
    
.end main
    
.ent delay
    
toggle:
    li	    t1, 0x001FFFFF	    
				    
delay:
    addi    t1, t1, -1		    
    bne	    t1, zero, delay	    
    nop
    
    sw	    t0, LATAINV
    sw	    t1, LATCINV
    j	    toggle		    
    nop

.end delay
