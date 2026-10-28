/* Label for the program's entry point */
ENTRY( reset_handler )


/* _estack specifies the address where the RAM segments ends */
/* SRAM1: 0x30000000 to 0x3001FFFF */
/* SRAM2: 0x30020000 to 0x3003FFFF */
/* SRAM3: 0x30040000 to 0x30047FFF */
_estack = 0x30048000;


/* Set minimum size for stack and dynamic memory */
/* (The linker will generate an error if less RAM is left over) */
_Min_Leftover_RAM = 0x800;		/* 2 KB */


MEMORY
{
    /* Flash Location and Length */
	/* For STM32H755KI */
    /* ARM Cortex-M7 (CPU0): 0x08000000 */
    /* ARM Cortex-M4 (CPU1): 0x08100000 */
	FLASH ( rx ): ORIGIN = 0x08000000, LENGTH = 1024K
	
	/* RAM Location and Length */
	RAM ( rxw )    : ORIGIN = 0x30000000, LENGTH = 288K
}


SECTIONS
{
    /* Vector table goes at the start of the Flash section */
    .vector_table :
    {
        . = ALIGN(4);
        KEEP (*(.vector_table))
        . = ALIGN(4);
    } >FLASH

    /* ‘text’ section contains the main program code */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        . = ALIGN(4);
    } >FLASH

    /* ‘rodata’ section contains Read-Only Data */
    /* constants, strings -> information that will not change */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } >FLASH

    /* ‘data’ section is space set aside in RAM for things that will change */
    /* during the execution of the application, like veriables */
    _sidata = .;
    .data : AT(_sidata)
    {
        . = ALIGN(4);
        /* Mark start/end locations for the ‘data’ section */
        _sdata = .;
        *(.data)
        *(.data*)
        _edata = .;
        . = ALIGN(4);
    } >RAM

    /* ‘bss’ section is similar to the ‘data’ section */
    /* space is initialized to all 0’s at the start of the program */
    .bss :
    {
        . = ALIGN(4);
        /* Mark start/end locations of the BSS section */
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >RAM

    /* Space set aside for the application heap/stack */
    .dynamic_allocations :
    {
        . = ALIGN(4);
        /* Mark start/end locations of heap */
        _ssystem_ram = .;
        . = . + _Min_Leftover_RAM;
        . = ALIGN(4);
        _esystem_ram = .;
    } >RAM
}
