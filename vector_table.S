.syntax unified 
.cpu cortex-m7
.fpu softvfp 
.thumb 

// Global variables
.global vtable 
.global default_interrupt_handler 

// The vector table.
.type vtable, %object 
.section .vector_table,"a",%progbits 
vtable: 
.word _estack                 
.word reset_handler          // 0x0000 0004: Reset        
.word NMI_handler            // 0x0000 0008: NMI          
.word hard_fault_handler     // 0x0000 000C: HardFault    
.word 0                      // 0x0000 0010: MemManage    
.word 0                      // 0x0000 0014: BusFault     
.word 0                      // 0x0000 0018: UsageFault   
.word 0                      // 0x0000 001C: Reserved     
.word 0                      // 0x0000 0020: Reserved     
.word 0                      // 0x0000 0024: Reserved     
.word 0                      // 0x0000 0028: Reserved     
.word 0                      // 0x0000 002C: SVCall       
.word 0                      // 0x0000 0030: DebugMonitor 
.word 0                      // 0x0000 0034: Reserved     
.word 0                      // 0x0000 0038: PendSV       
.word SysTick_handler        // 0x0000 003C: Systick      


// Location to Boot from RAM startup
#define boot_ram_base 0xF108F85F
.word boot_ram_base

// Set up weak aliases for each exception handler
.weak NMI_handler
.thumb_set NMI_handler,default_interrupt_handler

.weak hard_fault_handler
.thumb_set hard_fault_handler,default_interrupt_handler

.weak SysTick_handler
.thumb_set SysTick_handler,default_interrupt_handler

.size vtable, .-vtable

// Default interrupt handler, for interrupts not defined
.section .text.default_interrupt_handler,"ax",%progbits

default_interrupt_handler:
  default_interrupt_loop:
    B default_interrupt_loop

.size default_interrupt_handler, .-default_interrupt_handler

