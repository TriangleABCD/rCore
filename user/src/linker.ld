OUTPUT_ARCH(riscv)
ENTRY(_start)

BASE_ADDRESS = 0x80400000;
SECTIONS
{
    /* 先定一个“文件指针” */
    . = BASE_ADDRESS;
    __lma = 0x1000;

    .text : ALIGN(0x1000) {
        *(.text.entry)
        *(.text .text.*)
    } :text
    __lma = ALIGN(0x1000);

    .rodata : AT(__lma) ALIGN(0x1000) {
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
    } :rodata
    __lma = ALIGN(0x1000);

    .data : AT(__lma) ALIGN(0x1000) {
        *(.data .data.*)
        *(.sdata .sdata.*)
    } :data
    __lma = ALIGN(0x1000);

    .bss : ALIGN(0x1000) {
        start_bss = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        end_bss = .;
    } :bss

    /DISCARD/ : {
        *(.eh_frame)
        *(.debug*)
    }
}
