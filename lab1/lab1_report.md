Report of Lab1
【练习１】
1.1、操作系统镜像文件(ucore.img)是如何一步一步生成的?
通过查看Makefile可以看出生成ucore.img的代码为:
\# create ucore.img
UCOREIMG	:= $(call totarget,ucore.img)
$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc
$(call create_target,ucore.img)
从上述代码可以看出,在生成ucore.img之前必须有kernel和bootblock
我们首先看kernel的生成代码:
\# create kernel target
kernel = $(call totarget,kernel)

$(kernel): tools/kernel.ld

$(kernel): $(KOBJS)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)

$(call create_target,kernel)
从上述代码可以看出,生成kernel需要kernel.ld,还需要kdebug.o,kmonitor.o,panic.o,clock.o,console.o,intr.o,picirq.o,init.o,readline.o,stdio.o,pmm.o,trap.o,trapentry.o,vectors.o,printfmt.o,string.o
而kernel.ld已经存在，不需要生成，其他的*.o文件需要编译生成
我们可以看出这些*.o都存在于*/lab1/obj/kern/*/中;生成这些*.o需要相应的*.c文件;在Makefile中相对应的操作代码为:
$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))
首先我们从Makefile中找出kdebug.o的编译生成具体代码:
gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 \
	-gstabs -nostdinc  -fno-stack-protector \
	-Ilibs/ -Ikern/debug/ -Ikern/driver/ \
	-Ikern/trap/ -Ikern/mm/ -c kern/debug/kdebug.c \
	-o obj/kern/debug/kdebug.o
其他的*.o的编译生成代码只用将上述代码中的路径替换为对应的路径即可;
编译生成kernel的代码为:
ld -m elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel \
	obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o \
	obj/kern/init/init.o obj/kern/libs/readline.o \
	obj/kern/libs/stdio.o obj/kern/debug/panic.o \
	obj/kern/driver/clock.o obj/kern/driver/console.o \
	obj/kern/driver/intr.o obj/kern/driver/picirq.o \
	obj/kern/trap/trap.o obj/kern/trap/trapentry.o \
	obj/kern/trap/vectors.o obj/kern/mm/pmm.o \
	obj/libs/printfmt.o obj/libs/string.o
接下来我们看bootblock的编译生成代码:
\# create bootblock
bootfiles = $(call listf_cc,boot)
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))

bootblock = $(call totarget,bootblock)

$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
	@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)

$(call create_target,bootblock)
同样的,生成bootblock需要bootasm.o,bootmain.o,sign
我们知道bootasm.o,bootmain.o的编译生成代码是类似的,在Makefile中找到相关代码为:
bootfiles = $(call listf_cc,boot)
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))
从Makefile中我们可以解析处具体处理代码为(以bootasm.o为例):
gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs \
	-nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc \
	-c boot/bootasm.S -o obj/boot/bootasm.o
而bootmain的处理代码跟bootasm类似,只是改了响应的路径和名称;
再者我们看生成sign的Makefile代码为:
\# create 'sign' tools
$(call add_files_host,tools/sign.c,sign,sign)
$(call create_target_host,sign,sign)
解析后生成sign的具体命令为:
gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
有了bootasm.o,bootmain.o,sign生成bootblock的具体命令为:
ld -m elf_i386 -nostdlib -N -e start -Ttext 0x7C00 \
	obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
有了kernel和bootblock后,生成ucore.img的具体命令为:
1、dd if=/dev/zero of=$@ count=10000(生成一个1000块文件,用zero填充,默认为512字节)
2、dd if=$(bootblock) of=$@ conv=notrunc(将bootblock写到刚刚生成的文件中的第一块)
3、dd if=$(kernel) of=$@ seek=1 conv=notrunc(从第2块开始写kernel)
相关的命令参数含义有以下几点:
gcc:启用gcc编译器;
-I<dir>:添加搜索头文件的路径;
-ggdb:生成可供gdb使用的调试信息;
-m32:生成适用于32位环境的代码;
-gstabs:生成stabs格式的调试信息;
-nostdinc:不使用标准库;
-fno-stack-protector:不生成用于检测缓冲区溢出的代码;
-fno-builtin:除非用__builtin_前缀,否则不进行builtin函数的优化
-Os:为减小代码大小而进行优化
-m elf_i386:模拟为i386连接器;
-N:设置代码段和数据段均可读写;
-e <entry>:指定入口;
-Ttext:制定代码段开始位置;
-S:移除所有符号和重定位信息;
-o:生成最终文件格式;
-T:指定使用的脚本文件;
1.2、一个被系统认为是符合规范的硬盘主引导扇区的特征是什么?
我们观察sign.c代码:
char buf[512];
    memset(buf, 0, sizeof(buf));
    FILE *ifp = fopen(argv[1], "rb");
    int size = fread(buf, 1, st.st_size, ifp);
    if (size != st.st_size) {
        fprintf(stderr, "read '%s' error, size is %d.\n", argv[1], size);
        return -1;
    }
    fclose(ifp);
    buf[510] = 0x55;
    buf[511] = 0xAA;
我们可以看出,主引导扇区占512字节,只有对最后两个字节有要求,要求为最后两字节为"55AA"，查阅资料知道这是标准主引导扇区(MBR)的结束标志。
【练习2】
2.1、从CPU加电后执行的第一条指令开始,单步跟踪BIOS的执行
我们需要将跟踪到的BIOS执行指令记录下来,所以我们进行如下操作:
改写Makefile文件的第219行:
$(V)$(TERMINAL) -e "$(QEMU) -S -s -d in_asm -D trail.txt -parallel stdio -hda $< -serial null"
按照上述方法改变Makefile文件后就能在运行make debug之后在当前目录底下找到trail.txt文件,其中就记录了BIOS执行的指令;
2.2、在初始化位置0x7c00设置实地址断点,测试断点正常
我们在*/tools目录底下找到gdbinit文件,在其文件末尾加上如下代码:
set architecture i8086
break *0x7c00
continue
examine /10i $pc
set architecture i386
上述代码意思为:
第一行将当前CPU设置为8086,第二行在0x7c00处设置断点,第三行继续执行指令,第四行显示10条程序指令,第五行将当前CPU设置为80386.
然后我们执行make debug,continue后我们可以看到如下:
Breakpoint 2, 0x00007c00 in ?? ()
=> 0x7c00:      cli    
   0x7c01:      cld    
   0x7c02:      xor    %ax,%ax
   0x7c04:      mov    %ax,%ds
   0x7c06:      mov    %ax,%es
   0x7c08:      mov    %ax,%ss
   0x7c06:      mov    %ax,%es
   0x7c08:      mov    %ax,%ss
   0x7c0a:      in     $0x64,%al
   0x7c0c:      test   $0x2,%al
   0x7c0e:      jne    0x7c0a
   0x7c10:      mov    $0xd1,%al
当我们改变上述添加进gdbinit末尾的代码中第四行中的数字,就能得到不同条数从0x7c00之后执行的指令.
2.3、从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和	bootblock.asm进行比较
在做练习2.1时我们已经将BIOS执行的指令全部记录在trail.txt文件中,我们从文件中找到从0x7c00开始执行的指令,如下:
----------------
IN: 
0x00007c00:  cli    
0x00007c01:  cld    
0x00007c02:  xor    %ax,%ax
0x00007c04:  mov    %ax,%ds
0x00007c06:  mov    %ax,%es
0x00007c08:  mov    %ax,%ss

----------------
IN: 
0x00007c0a:  in     $0x64,%al

----------------
IN: 
0x00007c0c:  test   $0x2,%al
0x00007c0e:  jne    0x7c0a

----------------
IN: 
0x00007c10:  mov    $0xd1,%al
0x00007c12:  out    %al,$0x64
0x00007c14:  in     $0x64,%al
0x00007c16:  test   $0x2,%al
0x00007c18:  jne    0x7c14

----------------
IN: 
0x00007c1a:  mov    $0xdf,%al
0x00007c1c:  out    %al,$0x60
0x00007c1e:  lgdtw  0x7c6c
0x00007c23:  mov    %cr0,%eax
0x00007c26:  or     $0x1,%eax
0x00007c2a:  mov    %eax,%cr0

----------------
IN: 
0x00007c2d:  ljmp   $0x8,$0x7c32

----------------
IN: 
0x00007c32:  mov    $0x10,%ax
0x00007c36:  mov    %eax,%ds

----------------
IN: 
0x00007c38:  mov    %eax,%es

----------------
IN: 
0x00007c3a:  mov    %eax,%fs
0x00007c3c:  mov    %eax,%gs
0x00007c3e:  mov    %eax,%ss

----------------
IN: 
0x00007c40:  mov    $0x0,%ebp

----------------
IN: 
0x00007c45:  mov    $0x7c00,%esp
0x00007c4a:  call   0x7cd1

----------------
通过比对知道这些指令与bootasm.S和bootblock.asm中的代码一样,说明执行的指令跟编写的代码是一致的,合乎常理.
2.4、自己找一个bootloader或内核中的代码位置,设置断点并进行测试
操作过程如上述一样,只需改变一下断点设置的位置即可.
【练习3】BIOS将通过读取硬盘主引导扇区到内存,并转跳到对应内存中的位置执行bootloader。请分析bootloader是如何完成从实模
式进入保护模式的
我们需要分析bootasm.S代码从而分析bootloader使如何完成从实模式进入保护模式:
开始时:
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment
进行了disable中断,将重要的数据段寄存器包括DS,ES,SS都置成0。
接下来:
\# Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1
这段代码主要做的事情就是开启A20,从注释我们可以看出其通过将A20线置于高电位使得32位地址线都可用,为进入保护模式做准备.
然后:
lgdt gdtdesc
这里主要是初始化GDT表,通过载入存储在引导区的GDT及其描述符表即可.
最后:
movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg
将cr0寄存器PE位置成1就开启了保护模式，再更新cs的基地址即完成所有工作，此时进入保护模式.
【练习4】分析bootloader加载ELF格式的OS的过程
我们需要分析bootmain.c:
/* readsect - read a single sector at @secno into @dst */
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}
这是函数readsect,从代码及注释我们可以看出readsect的作用就是读取第secno扇区的数据内容;

/* *
 * readseg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked.
 * */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
这是readseg函数,从代码及注释我们可以看出其主要作用就是调用readsect函数使得其本身可以读取任意长度的数据;

/* bootmain - the entry of bootloader */
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
这是主函数bootmain,从代码和注释我们可以看出第一步是读取ELF的头部,然后判断读取的ELF头部是否合法,接着加载每个程序段(忽略pH标志),最后根据ELF头部存储的信息找到内核入口.
【练习5】实现函数调用堆栈跟踪函数
代码见提交的源代码(~/kern/debug/kdebug.c)代码完全按照所给提示的注释完成.
输出与题中所给的例子基本相似,最后一行输出为:
ebp:0x7bf8 eip:0x7d68  args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
<unknow>: -- 0x00007d67 --
对应的是bootmain.c中的bootmain函数,因为bootloader设置的函数堆栈地址从0x7c00开始,当call bootmain即调用bootmain函数时,相应的ebp为0x7d68.
【练习6】完善中断初始化和处理
6.1、中断描述符表(也可简称为保护模式下的中断向量表)中一个表项占多少字节?其中哪几位代表中断处理代码的入口?
一个表项占8个字节,0-1和6-7位拼成位移,2-3位是段选择子,结合起来就是中断处理的入口地址.
6.2、请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中,依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏,填充idt数组内容。每个中断的入口由tools/vectors.c生成,使用trap.c中声明的vectors数组即可。
见源代码(~/kern/trap/trap.c)
6.3、请编程完善trap.c中的中断处理函数trap,在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分,使操作系统每遇到100次时钟中断后,调用print_ticks子程序,向屏幕上打印一行文字"100 ticks"。
见源代码(~/kern/trap/trap.c)
