
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 00 12 00 	lgdtl  0x120018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b0 1b 12 c0       	mov    $0xc0121bb0,%edx
c0100035:	b8 68 0a 12 c0       	mov    $0xc0120a68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 0a 12 c0 	movl   $0xc0120a68,(%esp)
c0100051:	e8 89 8a 00 00       	call   c0108adf <memset>

    cons_init();                // init the console
c0100056:	e8 9b 15 00 00       	call   c01015f6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 8c 10 c0 	movl   $0xc0108c80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 8c 10 c0 	movl   $0xc0108c9c,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 fc 4c 00 00       	call   c0104d80 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 4b 1f 00 00       	call   c0101fd4 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 c3 20 00 00       	call   c0102151 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 df 74 00 00       	call   c0107572 <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 8f 16 00 00       	call   c0101727 <ide_init>
    swap_init();                // init swap
c0100098:	e8 b4 60 00 00       	call   c0106151 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 0a 0d 00 00       	call   c0100dac <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 9b 1e 00 00       	call   c0101f42 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 13 0c 00 00       	call   c0100cde <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 a1 8c 10 c0 	movl   $0xc0108ca1,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 af 8c 10 c0 	movl   $0xc0108caf,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 bd 8c 10 c0 	movl   $0xc0108cbd,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 cb 8c 10 c0 	movl   $0xc0108ccb,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 d9 8c 10 c0 	movl   $0xc0108cd9,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 0a 12 c0       	mov    %eax,0xc0120a80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 e8 8c 10 c0 	movl   $0xc0108ce8,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 08 8d 10 c0 	movl   $0xc0108d08,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 27 8d 10 c0 	movl   $0xc0108d27,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 0a 12 c0    	mov    %dl,-0x3fedf560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 0a 12 c0       	add    $0xc0120aa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 0a 12 c0       	mov    $0xc0120aa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 19 13 00 00       	call   c0101622 <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 da 7e 00 00       	call   c0108220 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 a0 12 00 00       	call   c0101622 <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 80 12 00 00       	call   c010165e <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 2c 8d 10 c0    	movl   $0xc0108d2c,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 2c 8d 10 c0 	movl   $0xc0108d2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 bc ab 10 c0 	movl   $0xc010abbc,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 f4 99 11 c0 	movl   $0xc01199f4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec f5 99 11 c0 	movl   $0xc01199f5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 ad d2 11 c0 	movl   $0xc011d2ad,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 58 82 00 00       	call   c0108953 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 36 8d 10 c0 	movl   $0xc0108d36,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 4f 8d 10 c0 	movl   $0xc0108d4f,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 68 8c 10 	movl   $0xc0108c68,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 67 8d 10 c0 	movl   $0xc0108d67,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 0a 12 	movl   $0xc0120a68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 7f 8d 10 c0 	movl   $0xc0108d7f,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 1b 12 	movl   $0xc0121bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 97 8d 10 c0 	movl   $0xc0108d97,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 b0 8d 10 c0 	movl   $0xc0108db0,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 da 8d 10 c0 	movl   $0xc0108dda,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 f6 8d 10 c0 	movl   $0xc0108df6,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i=0, j=0;
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
c01009f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f7:	e9 94 00 00 00       	jmp    c0100a90 <print_stackframe+0xc7>
	{
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c01009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0a:	c7 04 24 08 8e 10 c0 	movl   $0xc0108e08,(%esp)
c0100a11:	e8 35 f9 ff ff       	call   c010034b <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a19:	83 c0 08             	add    $0x8,%eax
c0100a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//print arguments;
		cprintf("args:");
c0100a1f:	c7 04 24 1f 8e 10 c0 	movl   $0xc0108e1f,(%esp)
c0100a26:	e8 20 f9 ff ff       	call   c010034b <cprintf>
		for(j=0; j<4; j++)
c0100a2b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a32:	eb 25                	jmp    c0100a59 <print_stackframe+0x90>
			cprintf("0x%08x ", args[j]);
c0100a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a41:	01 d0                	add    %edx,%eax
c0100a43:	8b 00                	mov    (%eax),%eax
c0100a45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a49:	c7 04 24 25 8e 10 c0 	movl   $0xc0108e25,(%esp)
c0100a50:	e8 f6 f8 ff ff       	call   c010034b <cprintf>
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		//print arguments;
		cprintf("args:");
		for(j=0; j<4; j++)
c0100a55:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a59:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a5d:	7e d5                	jle    c0100a34 <print_stackframe+0x6b>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100a5f:	c7 04 24 2d 8e 10 c0 	movl   $0xc0108e2d,(%esp)
c0100a66:	e8 e0 f8 ff ff       	call   c010034b <cprintf>
		//call print_debuginfo(eip-1)
		print_debuginfo(eip-1);
c0100a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a6e:	83 e8 01             	sub    $0x1,%eax
c0100a71:	89 04 24             	mov    %eax,(%esp)
c0100a74:	e8 9c fe ff ff       	call   c0100915 <print_debuginfo>
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
c0100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7c:	83 c0 04             	add    $0x4,%eax
c0100a7f:	8b 00                	mov    (%eax),%eax
c0100a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a87:	8b 00                	mov    (%eax),%eax
c0100a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i=0, j=0;
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
c0100a8c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a90:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a94:	7f 0a                	jg     c0100aa0 <print_stackframe+0xd7>
c0100a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a9a:	0f 85 5c ff ff ff    	jne    c01009fc <print_stackframe+0x33>
		print_debuginfo(eip-1);
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
	return;
c0100aa0:	90                   	nop
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100aa1:	c9                   	leave  
c0100aa2:	c3                   	ret    

c0100aa3 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aa3:	55                   	push   %ebp
c0100aa4:	89 e5                	mov    %esp,%ebp
c0100aa6:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100aa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ab0:	eb 0c                	jmp    c0100abe <parse+0x1b>
            *buf ++ = '\0';
c0100ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab5:	8d 50 01             	lea    0x1(%eax),%edx
c0100ab8:	89 55 08             	mov    %edx,0x8(%ebp)
c0100abb:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac1:	0f b6 00             	movzbl (%eax),%eax
c0100ac4:	84 c0                	test   %al,%al
c0100ac6:	74 1d                	je     c0100ae5 <parse+0x42>
c0100ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acb:	0f b6 00             	movzbl (%eax),%eax
c0100ace:	0f be c0             	movsbl %al,%eax
c0100ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad5:	c7 04 24 b0 8e 10 c0 	movl   $0xc0108eb0,(%esp)
c0100adc:	e8 3f 7e 00 00       	call   c0108920 <strchr>
c0100ae1:	85 c0                	test   %eax,%eax
c0100ae3:	75 cd                	jne    c0100ab2 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae8:	0f b6 00             	movzbl (%eax),%eax
c0100aeb:	84 c0                	test   %al,%al
c0100aed:	75 02                	jne    c0100af1 <parse+0x4e>
            break;
c0100aef:	eb 67                	jmp    c0100b58 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100af1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100af5:	75 14                	jne    c0100b0b <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100af7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100afe:	00 
c0100aff:	c7 04 24 b5 8e 10 c0 	movl   $0xc0108eb5,(%esp)
c0100b06:	e8 40 f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0e:	8d 50 01             	lea    0x1(%eax),%edx
c0100b11:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b14:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b1e:	01 c2                	add    %eax,%edx
c0100b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b23:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b25:	eb 04                	jmp    c0100b2b <parse+0x88>
            buf ++;
c0100b27:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2e:	0f b6 00             	movzbl (%eax),%eax
c0100b31:	84 c0                	test   %al,%al
c0100b33:	74 1d                	je     c0100b52 <parse+0xaf>
c0100b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b38:	0f b6 00             	movzbl (%eax),%eax
c0100b3b:	0f be c0             	movsbl %al,%eax
c0100b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b42:	c7 04 24 b0 8e 10 c0 	movl   $0xc0108eb0,(%esp)
c0100b49:	e8 d2 7d 00 00       	call   c0108920 <strchr>
c0100b4e:	85 c0                	test   %eax,%eax
c0100b50:	74 d5                	je     c0100b27 <parse+0x84>
            buf ++;
        }
    }
c0100b52:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b53:	e9 66 ff ff ff       	jmp    c0100abe <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b5b:	c9                   	leave  
c0100b5c:	c3                   	ret    

c0100b5d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b5d:	55                   	push   %ebp
c0100b5e:	89 e5                	mov    %esp,%ebp
c0100b60:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b63:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6d:	89 04 24             	mov    %eax,(%esp)
c0100b70:	e8 2e ff ff ff       	call   c0100aa3 <parse>
c0100b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b7c:	75 0a                	jne    c0100b88 <runcmd+0x2b>
        return 0;
c0100b7e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b83:	e9 85 00 00 00       	jmp    c0100c0d <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b8f:	eb 5c                	jmp    c0100bed <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b91:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b97:	89 d0                	mov    %edx,%eax
c0100b99:	01 c0                	add    %eax,%eax
c0100b9b:	01 d0                	add    %edx,%eax
c0100b9d:	c1 e0 02             	shl    $0x2,%eax
c0100ba0:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100ba5:	8b 00                	mov    (%eax),%eax
c0100ba7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100bab:	89 04 24             	mov    %eax,(%esp)
c0100bae:	e8 ce 7c 00 00       	call   c0108881 <strcmp>
c0100bb3:	85 c0                	test   %eax,%eax
c0100bb5:	75 32                	jne    c0100be9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bba:	89 d0                	mov    %edx,%eax
c0100bbc:	01 c0                	add    %eax,%eax
c0100bbe:	01 d0                	add    %edx,%eax
c0100bc0:	c1 e0 02             	shl    $0x2,%eax
c0100bc3:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100bc8:	8b 40 08             	mov    0x8(%eax),%eax
c0100bcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bce:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bd4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bd8:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bdb:	83 c2 04             	add    $0x4,%edx
c0100bde:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100be2:	89 0c 24             	mov    %ecx,(%esp)
c0100be5:	ff d0                	call   *%eax
c0100be7:	eb 24                	jmp    c0100c0d <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf0:	83 f8 02             	cmp    $0x2,%eax
c0100bf3:	76 9c                	jbe    c0100b91 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bf5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bfc:	c7 04 24 d3 8e 10 c0 	movl   $0xc0108ed3,(%esp)
c0100c03:	e8 43 f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c0d:	c9                   	leave  
c0100c0e:	c3                   	ret    

c0100c0f <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c0f:	55                   	push   %ebp
c0100c10:	89 e5                	mov    %esp,%ebp
c0100c12:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c15:	c7 04 24 ec 8e 10 c0 	movl   $0xc0108eec,(%esp)
c0100c1c:	e8 2a f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c21:	c7 04 24 14 8f 10 c0 	movl   $0xc0108f14,(%esp)
c0100c28:	e8 1e f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c31:	74 0b                	je     c0100c3e <kmonitor+0x2f>
        print_trapframe(tf);
c0100c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c36:	89 04 24             	mov    %eax,(%esp)
c0100c39:	e8 d8 16 00 00       	call   c0102316 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c3e:	c7 04 24 39 8f 10 c0 	movl   $0xc0108f39,(%esp)
c0100c45:	e8 f8 f5 ff ff       	call   c0100242 <readline>
c0100c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c51:	74 18                	je     c0100c6b <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5d:	89 04 24             	mov    %eax,(%esp)
c0100c60:	e8 f8 fe ff ff       	call   c0100b5d <runcmd>
c0100c65:	85 c0                	test   %eax,%eax
c0100c67:	79 02                	jns    c0100c6b <kmonitor+0x5c>
                break;
c0100c69:	eb 02                	jmp    c0100c6d <kmonitor+0x5e>
            }
        }
    }
c0100c6b:	eb d1                	jmp    c0100c3e <kmonitor+0x2f>
}
c0100c6d:	c9                   	leave  
c0100c6e:	c3                   	ret    

c0100c6f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c6f:	55                   	push   %ebp
c0100c70:	89 e5                	mov    %esp,%ebp
c0100c72:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c7c:	eb 3f                	jmp    c0100cbd <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c81:	89 d0                	mov    %edx,%eax
c0100c83:	01 c0                	add    %eax,%eax
c0100c85:	01 d0                	add    %edx,%eax
c0100c87:	c1 e0 02             	shl    $0x2,%eax
c0100c8a:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c8f:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c95:	89 d0                	mov    %edx,%eax
c0100c97:	01 c0                	add    %eax,%eax
c0100c99:	01 d0                	add    %edx,%eax
c0100c9b:	c1 e0 02             	shl    $0x2,%eax
c0100c9e:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100ca3:	8b 00                	mov    (%eax),%eax
c0100ca5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cad:	c7 04 24 3d 8f 10 c0 	movl   $0xc0108f3d,(%esp)
c0100cb4:	e8 92 f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc0:	83 f8 02             	cmp    $0x2,%eax
c0100cc3:	76 b9                	jbe    c0100c7e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cca:	c9                   	leave  
c0100ccb:	c3                   	ret    

c0100ccc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ccc:	55                   	push   %ebp
c0100ccd:	89 e5                	mov    %esp,%ebp
c0100ccf:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cd2:	e8 a8 fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdc:	c9                   	leave  
c0100cdd:	c3                   	ret    

c0100cde <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cde:	55                   	push   %ebp
c0100cdf:	89 e5                	mov    %esp,%ebp
c0100ce1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ce4:	e8 e0 fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cee:	c9                   	leave  
c0100cef:	c3                   	ret    

c0100cf0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cf0:	55                   	push   %ebp
c0100cf1:	89 e5                	mov    %esp,%ebp
c0100cf3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cf6:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
c0100cfb:	85 c0                	test   %eax,%eax
c0100cfd:	74 02                	je     c0100d01 <__panic+0x11>
        goto panic_dead;
c0100cff:	eb 48                	jmp    c0100d49 <__panic+0x59>
    }
    is_panic = 1;
c0100d01:	c7 05 a0 0e 12 c0 01 	movl   $0x1,0xc0120ea0
c0100d08:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d0b:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d14:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1f:	c7 04 24 46 8f 10 c0 	movl   $0xc0108f46,(%esp)
c0100d26:	e8 20 f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d32:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d35:	89 04 24             	mov    %eax,(%esp)
c0100d38:	e8 db f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d3d:	c7 04 24 62 8f 10 c0 	movl   $0xc0108f62,(%esp)
c0100d44:	e8 02 f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d49:	e8 fa 11 00 00       	call   c0101f48 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d55:	e8 b5 fe ff ff       	call   c0100c0f <kmonitor>
    }
c0100d5a:	eb f2                	jmp    c0100d4e <__panic+0x5e>

c0100d5c <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d5c:	55                   	push   %ebp
c0100d5d:	89 e5                	mov    %esp,%ebp
c0100d5f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d62:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	c7 04 24 64 8f 10 c0 	movl   $0xc0108f64,(%esp)
c0100d7d:	e8 c9 f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d89:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d8c:	89 04 24             	mov    %eax,(%esp)
c0100d8f:	e8 84 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d94:	c7 04 24 62 8f 10 c0 	movl   $0xc0108f62,(%esp)
c0100d9b:	e8 ab f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100da0:	c9                   	leave  
c0100da1:	c3                   	ret    

c0100da2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100da2:	55                   	push   %ebp
c0100da3:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100da5:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
}
c0100daa:	5d                   	pop    %ebp
c0100dab:	c3                   	ret    

c0100dac <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dac:	55                   	push   %ebp
c0100dad:	89 e5                	mov    %esp,%ebp
c0100daf:	83 ec 28             	sub    $0x28,%esp
c0100db2:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100db8:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dbc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dc0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
c0100dc5:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dcb:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dcf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd7:	ee                   	out    %al,(%dx)
c0100dd8:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dde:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100de2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100de6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dea:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100deb:	c7 05 bc 1a 12 c0 00 	movl   $0x0,0xc0121abc
c0100df2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df5:	c7 04 24 82 8f 10 c0 	movl   $0xc0108f82,(%esp)
c0100dfc:	e8 4a f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100e01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e08:	e8 99 11 00 00       	call   c0101fa6 <pic_enable>
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e15:	9c                   	pushf  
c0100e16:	58                   	pop    %eax
c0100e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e1d:	25 00 02 00 00       	and    $0x200,%eax
c0100e22:	85 c0                	test   %eax,%eax
c0100e24:	74 0c                	je     c0100e32 <__intr_save+0x23>
        intr_disable();
c0100e26:	e8 1d 11 00 00       	call   c0101f48 <intr_disable>
        return 1;
c0100e2b:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e30:	eb 05                	jmp    c0100e37 <__intr_save+0x28>
    }
    return 0;
c0100e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e37:	c9                   	leave  
c0100e38:	c3                   	ret    

c0100e39 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e39:	55                   	push   %ebp
c0100e3a:	89 e5                	mov    %esp,%ebp
c0100e3c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e43:	74 05                	je     c0100e4a <__intr_restore+0x11>
        intr_enable();
c0100e45:	e8 f8 10 00 00       	call   c0101f42 <intr_enable>
    }
}
c0100e4a:	c9                   	leave  
c0100e4b:	c3                   	ret    

c0100e4c <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e4c:	55                   	push   %ebp
c0100e4d:	89 e5                	mov    %esp,%ebp
c0100e4f:	83 ec 10             	sub    $0x10,%esp
c0100e52:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e58:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5c:	89 c2                	mov    %eax,%edx
c0100e5e:	ec                   	in     (%dx),%al
c0100e5f:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e62:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e68:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e6c:	89 c2                	mov    %eax,%edx
c0100e6e:	ec                   	in     (%dx),%al
c0100e6f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e72:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e78:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e7c:	89 c2                	mov    %eax,%edx
c0100e7e:	ec                   	in     (%dx),%al
c0100e7f:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e82:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e88:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e8c:	89 c2                	mov    %eax,%edx
c0100e8e:	ec                   	in     (%dx),%al
c0100e8f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e92:	c9                   	leave  
c0100e93:	c3                   	ret    

c0100e94 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e94:	55                   	push   %ebp
c0100e95:	89 e5                	mov    %esp,%ebp
c0100e97:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e9a:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea4:	0f b7 00             	movzwl (%eax),%eax
c0100ea7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eae:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb6:	0f b7 00             	movzwl (%eax),%eax
c0100eb9:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ebd:	74 12                	je     c0100ed1 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ebf:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ec6:	66 c7 05 c6 0e 12 c0 	movw   $0x3b4,0xc0120ec6
c0100ecd:	b4 03 
c0100ecf:	eb 13                	jmp    c0100ee4 <cga_init+0x50>
    } else {
        *cp = was;
c0100ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ed8:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edb:	66 c7 05 c6 0e 12 c0 	movw   $0x3d4,0xc0120ec6
c0100ee2:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee4:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100eeb:	0f b7 c0             	movzwl %ax,%eax
c0100eee:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ef2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100efa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100efe:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eff:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f06:	83 c0 01             	add    $0x1,%eax
c0100f09:	0f b7 c0             	movzwl %ax,%eax
c0100f0c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f10:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f14:	89 c2                	mov    %eax,%edx
c0100f16:	ec                   	in     (%dx),%al
c0100f17:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f1a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f1e:	0f b6 c0             	movzbl %al,%eax
c0100f21:	c1 e0 08             	shl    $0x8,%eax
c0100f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f27:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f2e:	0f b7 c0             	movzwl %ax,%eax
c0100f31:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f35:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f39:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f41:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f42:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f49:	83 c0 01             	add    $0x1,%eax
c0100f4c:	0f b7 c0             	movzwl %ax,%eax
c0100f4f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f53:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f57:	89 c2                	mov    %eax,%edx
c0100f59:	ec                   	in     (%dx),%al
c0100f5a:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f5d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f61:	0f b6 c0             	movzbl %al,%eax
c0100f64:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f6a:	a3 c0 0e 12 c0       	mov    %eax,0xc0120ec0
    crt_pos = pos;
c0100f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f72:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
}
c0100f78:	c9                   	leave  
c0100f79:	c3                   	ret    

c0100f7a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f7a:	55                   	push   %ebp
c0100f7b:	89 e5                	mov    %esp,%ebp
c0100f7d:	83 ec 48             	sub    $0x48,%esp
c0100f80:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f86:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f8e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f92:	ee                   	out    %al,(%dx)
c0100f93:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f99:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f9d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fa1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fa5:	ee                   	out    %al,(%dx)
c0100fa6:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fac:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fb0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fb4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
c0100fb9:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fbf:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fc3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
c0100fcc:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fd2:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fd6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fda:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
c0100fdf:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fe5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fe9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fed:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
c0100ff2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ff8:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ffc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101000:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101004:	ee                   	out    %al,(%dx)
c0101005:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100b:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c010100f:	89 c2                	mov    %eax,%edx
c0101011:	ec                   	in     (%dx),%al
c0101012:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101019:	3c ff                	cmp    $0xff,%al
c010101b:	0f 95 c0             	setne  %al
c010101e:	0f b6 c0             	movzbl %al,%eax
c0101021:	a3 c8 0e 12 c0       	mov    %eax,0xc0120ec8
c0101026:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010102c:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101030:	89 c2                	mov    %eax,%edx
c0101032:	ec                   	in     (%dx),%al
c0101033:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101036:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010103c:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101040:	89 c2                	mov    %eax,%edx
c0101042:	ec                   	in     (%dx),%al
c0101043:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101046:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c010104b:	85 c0                	test   %eax,%eax
c010104d:	74 0c                	je     c010105b <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010104f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101056:	e8 4b 0f 00 00       	call   c0101fa6 <pic_enable>
    }
}
c010105b:	c9                   	leave  
c010105c:	c3                   	ret    

c010105d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010105d:	55                   	push   %ebp
c010105e:	89 e5                	mov    %esp,%ebp
c0101060:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010106a:	eb 09                	jmp    c0101075 <lpt_putc_sub+0x18>
        delay();
c010106c:	e8 db fd ff ff       	call   c0100e4c <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101071:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101075:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010107b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010107f:	89 c2                	mov    %eax,%edx
c0101081:	ec                   	in     (%dx),%al
c0101082:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101085:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101089:	84 c0                	test   %al,%al
c010108b:	78 09                	js     c0101096 <lpt_putc_sub+0x39>
c010108d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101094:	7e d6                	jle    c010106c <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101096:	8b 45 08             	mov    0x8(%ebp),%eax
c0101099:	0f b6 c0             	movzbl %al,%eax
c010109c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010a2:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010a5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ad:	ee                   	out    %al,(%dx)
c01010ae:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010b4:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010b8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010bc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010c0:	ee                   	out    %al,(%dx)
c01010c1:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010c7:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010cb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010cf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d3:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010d4:	c9                   	leave  
c01010d5:	c3                   	ret    

c01010d6 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010d6:	55                   	push   %ebp
c01010d7:	89 e5                	mov    %esp,%ebp
c01010d9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010dc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010e0:	74 0d                	je     c01010ef <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e5:	89 04 24             	mov    %eax,(%esp)
c01010e8:	e8 70 ff ff ff       	call   c010105d <lpt_putc_sub>
c01010ed:	eb 24                	jmp    c0101113 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f6:	e8 62 ff ff ff       	call   c010105d <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101102:	e8 56 ff ff ff       	call   c010105d <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101107:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010110e:	e8 4a ff ff ff       	call   c010105d <lpt_putc_sub>
    }
}
c0101113:	c9                   	leave  
c0101114:	c3                   	ret    

c0101115 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101115:	55                   	push   %ebp
c0101116:	89 e5                	mov    %esp,%ebp
c0101118:	53                   	push   %ebx
c0101119:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010111c:	8b 45 08             	mov    0x8(%ebp),%eax
c010111f:	b0 00                	mov    $0x0,%al
c0101121:	85 c0                	test   %eax,%eax
c0101123:	75 07                	jne    c010112c <cga_putc+0x17>
        c |= 0x0700;
c0101125:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010112c:	8b 45 08             	mov    0x8(%ebp),%eax
c010112f:	0f b6 c0             	movzbl %al,%eax
c0101132:	83 f8 0a             	cmp    $0xa,%eax
c0101135:	74 4c                	je     c0101183 <cga_putc+0x6e>
c0101137:	83 f8 0d             	cmp    $0xd,%eax
c010113a:	74 57                	je     c0101193 <cga_putc+0x7e>
c010113c:	83 f8 08             	cmp    $0x8,%eax
c010113f:	0f 85 88 00 00 00    	jne    c01011cd <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101145:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010114c:	66 85 c0             	test   %ax,%ax
c010114f:	74 30                	je     c0101181 <cga_putc+0x6c>
            crt_pos --;
c0101151:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101158:	83 e8 01             	sub    $0x1,%eax
c010115b:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101161:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101166:	0f b7 15 c4 0e 12 c0 	movzwl 0xc0120ec4,%edx
c010116d:	0f b7 d2             	movzwl %dx,%edx
c0101170:	01 d2                	add    %edx,%edx
c0101172:	01 c2                	add    %eax,%edx
c0101174:	8b 45 08             	mov    0x8(%ebp),%eax
c0101177:	b0 00                	mov    $0x0,%al
c0101179:	83 c8 20             	or     $0x20,%eax
c010117c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010117f:	eb 72                	jmp    c01011f3 <cga_putc+0xde>
c0101181:	eb 70                	jmp    c01011f3 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101183:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010118a:	83 c0 50             	add    $0x50,%eax
c010118d:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101193:	0f b7 1d c4 0e 12 c0 	movzwl 0xc0120ec4,%ebx
c010119a:	0f b7 0d c4 0e 12 c0 	movzwl 0xc0120ec4,%ecx
c01011a1:	0f b7 c1             	movzwl %cx,%eax
c01011a4:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011aa:	c1 e8 10             	shr    $0x10,%eax
c01011ad:	89 c2                	mov    %eax,%edx
c01011af:	66 c1 ea 06          	shr    $0x6,%dx
c01011b3:	89 d0                	mov    %edx,%eax
c01011b5:	c1 e0 02             	shl    $0x2,%eax
c01011b8:	01 d0                	add    %edx,%eax
c01011ba:	c1 e0 04             	shl    $0x4,%eax
c01011bd:	29 c1                	sub    %eax,%ecx
c01011bf:	89 ca                	mov    %ecx,%edx
c01011c1:	89 d8                	mov    %ebx,%eax
c01011c3:	29 d0                	sub    %edx,%eax
c01011c5:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
        break;
c01011cb:	eb 26                	jmp    c01011f3 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011cd:	8b 0d c0 0e 12 c0    	mov    0xc0120ec0,%ecx
c01011d3:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011da:	8d 50 01             	lea    0x1(%eax),%edx
c01011dd:	66 89 15 c4 0e 12 c0 	mov    %dx,0xc0120ec4
c01011e4:	0f b7 c0             	movzwl %ax,%eax
c01011e7:	01 c0                	add    %eax,%eax
c01011e9:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ef:	66 89 02             	mov    %ax,(%edx)
        break;
c01011f2:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f3:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011fa:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011fe:	76 5b                	jbe    c010125b <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101200:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101205:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010120b:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101210:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101217:	00 
c0101218:	89 54 24 04          	mov    %edx,0x4(%esp)
c010121c:	89 04 24             	mov    %eax,(%esp)
c010121f:	e8 fa 78 00 00       	call   c0108b1e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101224:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010122b:	eb 15                	jmp    c0101242 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010122d:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101232:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101235:	01 d2                	add    %edx,%edx
c0101237:	01 d0                	add    %edx,%eax
c0101239:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010123e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101242:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101249:	7e e2                	jle    c010122d <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010124b:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101252:	83 e8 50             	sub    $0x50,%eax
c0101255:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010125b:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0101262:	0f b7 c0             	movzwl %ax,%eax
c0101265:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101269:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010126d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101271:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101275:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101276:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010127d:	66 c1 e8 08          	shr    $0x8,%ax
c0101281:	0f b6 c0             	movzbl %al,%eax
c0101284:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c010128b:	83 c2 01             	add    $0x1,%edx
c010128e:	0f b7 d2             	movzwl %dx,%edx
c0101291:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101295:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101298:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010129c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012a0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a1:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c01012a8:	0f b7 c0             	movzwl %ax,%eax
c01012ab:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012af:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012bb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012bc:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01012c3:	0f b6 c0             	movzbl %al,%eax
c01012c6:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c01012cd:	83 c2 01             	add    $0x1,%edx
c01012d0:	0f b7 d2             	movzwl %dx,%edx
c01012d3:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012d7:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012da:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012de:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e2:	ee                   	out    %al,(%dx)
}
c01012e3:	83 c4 34             	add    $0x34,%esp
c01012e6:	5b                   	pop    %ebx
c01012e7:	5d                   	pop    %ebp
c01012e8:	c3                   	ret    

c01012e9 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012e9:	55                   	push   %ebp
c01012ea:	89 e5                	mov    %esp,%ebp
c01012ec:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f6:	eb 09                	jmp    c0101301 <serial_putc_sub+0x18>
        delay();
c01012f8:	e8 4f fb ff ff       	call   c0100e4c <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101301:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101307:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010130b:	89 c2                	mov    %eax,%edx
c010130d:	ec                   	in     (%dx),%al
c010130e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101311:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101315:	0f b6 c0             	movzbl %al,%eax
c0101318:	83 e0 20             	and    $0x20,%eax
c010131b:	85 c0                	test   %eax,%eax
c010131d:	75 09                	jne    c0101328 <serial_putc_sub+0x3f>
c010131f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101326:	7e d0                	jle    c01012f8 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101328:	8b 45 08             	mov    0x8(%ebp),%eax
c010132b:	0f b6 c0             	movzbl %al,%eax
c010132e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101334:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101337:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010133b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010133f:	ee                   	out    %al,(%dx)
}
c0101340:	c9                   	leave  
c0101341:	c3                   	ret    

c0101342 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101342:	55                   	push   %ebp
c0101343:	89 e5                	mov    %esp,%ebp
c0101345:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101348:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010134c:	74 0d                	je     c010135b <serial_putc+0x19>
        serial_putc_sub(c);
c010134e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101351:	89 04 24             	mov    %eax,(%esp)
c0101354:	e8 90 ff ff ff       	call   c01012e9 <serial_putc_sub>
c0101359:	eb 24                	jmp    c010137f <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010135b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101362:	e8 82 ff ff ff       	call   c01012e9 <serial_putc_sub>
        serial_putc_sub(' ');
c0101367:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010136e:	e8 76 ff ff ff       	call   c01012e9 <serial_putc_sub>
        serial_putc_sub('\b');
c0101373:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010137a:	e8 6a ff ff ff       	call   c01012e9 <serial_putc_sub>
    }
}
c010137f:	c9                   	leave  
c0101380:	c3                   	ret    

c0101381 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101381:	55                   	push   %ebp
c0101382:	89 e5                	mov    %esp,%ebp
c0101384:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101387:	eb 33                	jmp    c01013bc <cons_intr+0x3b>
        if (c != 0) {
c0101389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010138d:	74 2d                	je     c01013bc <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010138f:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101394:	8d 50 01             	lea    0x1(%eax),%edx
c0101397:	89 15 e4 10 12 c0    	mov    %edx,0xc01210e4
c010139d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a0:	88 90 e0 0e 12 c0    	mov    %dl,-0x3fedf120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a6:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c01013ab:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b0:	75 0a                	jne    c01013bc <cons_intr+0x3b>
                cons.wpos = 0;
c01013b2:	c7 05 e4 10 12 c0 00 	movl   $0x0,0xc01210e4
c01013b9:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01013bf:	ff d0                	call   *%eax
c01013c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013c8:	75 bf                	jne    c0101389 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013ca:	c9                   	leave  
c01013cb:	c3                   	ret    

c01013cc <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013cc:	55                   	push   %ebp
c01013cd:	89 e5                	mov    %esp,%ebp
c01013cf:	83 ec 10             	sub    $0x10,%esp
c01013d2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013dc:	89 c2                	mov    %eax,%edx
c01013de:	ec                   	in     (%dx),%al
c01013df:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013e2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e6:	0f b6 c0             	movzbl %al,%eax
c01013e9:	83 e0 01             	and    $0x1,%eax
c01013ec:	85 c0                	test   %eax,%eax
c01013ee:	75 07                	jne    c01013f7 <serial_proc_data+0x2b>
        return -1;
c01013f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f5:	eb 2a                	jmp    c0101421 <serial_proc_data+0x55>
c01013f7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013fd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101401:	89 c2                	mov    %eax,%edx
c0101403:	ec                   	in     (%dx),%al
c0101404:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101407:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010140b:	0f b6 c0             	movzbl %al,%eax
c010140e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101411:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101415:	75 07                	jne    c010141e <serial_proc_data+0x52>
        c = '\b';
c0101417:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010141e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101421:	c9                   	leave  
c0101422:	c3                   	ret    

c0101423 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101423:	55                   	push   %ebp
c0101424:	89 e5                	mov    %esp,%ebp
c0101426:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101429:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c010142e:	85 c0                	test   %eax,%eax
c0101430:	74 0c                	je     c010143e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101432:	c7 04 24 cc 13 10 c0 	movl   $0xc01013cc,(%esp)
c0101439:	e8 43 ff ff ff       	call   c0101381 <cons_intr>
    }
}
c010143e:	c9                   	leave  
c010143f:	c3                   	ret    

c0101440 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101440:	55                   	push   %ebp
c0101441:	89 e5                	mov    %esp,%ebp
c0101443:	83 ec 38             	sub    $0x38,%esp
c0101446:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101450:	89 c2                	mov    %eax,%edx
c0101452:	ec                   	in     (%dx),%al
c0101453:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101456:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010145a:	0f b6 c0             	movzbl %al,%eax
c010145d:	83 e0 01             	and    $0x1,%eax
c0101460:	85 c0                	test   %eax,%eax
c0101462:	75 0a                	jne    c010146e <kbd_proc_data+0x2e>
        return -1;
c0101464:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101469:	e9 59 01 00 00       	jmp    c01015c7 <kbd_proc_data+0x187>
c010146e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101474:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101478:	89 c2                	mov    %eax,%edx
c010147a:	ec                   	in     (%dx),%al
c010147b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010147e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101482:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101485:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101489:	75 17                	jne    c01014a2 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010148b:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101490:	83 c8 40             	or     $0x40,%eax
c0101493:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c0101498:	b8 00 00 00 00       	mov    $0x0,%eax
c010149d:	e9 25 01 00 00       	jmp    c01015c7 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a6:	84 c0                	test   %al,%al
c01014a8:	79 47                	jns    c01014f1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014aa:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014af:	83 e0 40             	and    $0x40,%eax
c01014b2:	85 c0                	test   %eax,%eax
c01014b4:	75 09                	jne    c01014bf <kbd_proc_data+0x7f>
c01014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ba:	83 e0 7f             	and    $0x7f,%eax
c01014bd:	eb 04                	jmp    c01014c3 <kbd_proc_data+0x83>
c01014bf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c3:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ca:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c01014d1:	83 c8 40             	or     $0x40,%eax
c01014d4:	0f b6 c0             	movzbl %al,%eax
c01014d7:	f7 d0                	not    %eax
c01014d9:	89 c2                	mov    %eax,%edx
c01014db:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014e0:	21 d0                	and    %edx,%eax
c01014e2:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c01014e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ec:	e9 d6 00 00 00       	jmp    c01015c7 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014f1:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01014f6:	83 e0 40             	and    $0x40,%eax
c01014f9:	85 c0                	test   %eax,%eax
c01014fb:	74 11                	je     c010150e <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014fd:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101501:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101506:	83 e0 bf             	and    $0xffffffbf,%eax
c0101509:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    }

    shift |= shiftcode[data];
c010150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101512:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c0101519:	0f b6 d0             	movzbl %al,%edx
c010151c:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101521:	09 d0                	or     %edx,%eax
c0101523:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    shift ^= togglecode[data];
c0101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152c:	0f b6 80 60 01 12 c0 	movzbl -0x3fedfea0(%eax),%eax
c0101533:	0f b6 d0             	movzbl %al,%edx
c0101536:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c010153b:	31 d0                	xor    %edx,%eax
c010153d:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101542:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101547:	83 e0 03             	and    $0x3,%eax
c010154a:	8b 14 85 60 05 12 c0 	mov    -0x3fedfaa0(,%eax,4),%edx
c0101551:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101555:	01 d0                	add    %edx,%eax
c0101557:	0f b6 00             	movzbl (%eax),%eax
c010155a:	0f b6 c0             	movzbl %al,%eax
c010155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101560:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101565:	83 e0 08             	and    $0x8,%eax
c0101568:	85 c0                	test   %eax,%eax
c010156a:	74 22                	je     c010158e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010156c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101570:	7e 0c                	jle    c010157e <kbd_proc_data+0x13e>
c0101572:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101576:	7f 06                	jg     c010157e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101578:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010157c:	eb 10                	jmp    c010158e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010157e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101582:	7e 0a                	jle    c010158e <kbd_proc_data+0x14e>
c0101584:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101588:	7f 04                	jg     c010158e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010158a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010158e:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101593:	f7 d0                	not    %eax
c0101595:	83 e0 06             	and    $0x6,%eax
c0101598:	85 c0                	test   %eax,%eax
c010159a:	75 28                	jne    c01015c4 <kbd_proc_data+0x184>
c010159c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a3:	75 1f                	jne    c01015c4 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015a5:	c7 04 24 9d 8f 10 c0 	movl   $0xc0108f9d,(%esp)
c01015ac:	e8 9a ed ff ff       	call   c010034b <cprintf>
c01015b1:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b7:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015bb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015bf:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015c3:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c7:	c9                   	leave  
c01015c8:	c3                   	ret    

c01015c9 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015c9:	55                   	push   %ebp
c01015ca:	89 e5                	mov    %esp,%ebp
c01015cc:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015cf:	c7 04 24 40 14 10 c0 	movl   $0xc0101440,(%esp)
c01015d6:	e8 a6 fd ff ff       	call   c0101381 <cons_intr>
}
c01015db:	c9                   	leave  
c01015dc:	c3                   	ret    

c01015dd <kbd_init>:

static void
kbd_init(void) {
c01015dd:	55                   	push   %ebp
c01015de:	89 e5                	mov    %esp,%ebp
c01015e0:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015e3:	e8 e1 ff ff ff       	call   c01015c9 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ef:	e8 b2 09 00 00       	call   c0101fa6 <pic_enable>
}
c01015f4:	c9                   	leave  
c01015f5:	c3                   	ret    

c01015f6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f6:	55                   	push   %ebp
c01015f7:	89 e5                	mov    %esp,%ebp
c01015f9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015fc:	e8 93 f8 ff ff       	call   c0100e94 <cga_init>
    serial_init();
c0101601:	e8 74 f9 ff ff       	call   c0100f7a <serial_init>
    kbd_init();
c0101606:	e8 d2 ff ff ff       	call   c01015dd <kbd_init>
    if (!serial_exists) {
c010160b:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c0101610:	85 c0                	test   %eax,%eax
c0101612:	75 0c                	jne    c0101620 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101614:	c7 04 24 a9 8f 10 c0 	movl   $0xc0108fa9,(%esp)
c010161b:	e8 2b ed ff ff       	call   c010034b <cprintf>
    }
}
c0101620:	c9                   	leave  
c0101621:	c3                   	ret    

c0101622 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101622:	55                   	push   %ebp
c0101623:	89 e5                	mov    %esp,%ebp
c0101625:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101628:	e8 e2 f7 ff ff       	call   c0100e0f <__intr_save>
c010162d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101630:	8b 45 08             	mov    0x8(%ebp),%eax
c0101633:	89 04 24             	mov    %eax,(%esp)
c0101636:	e8 9b fa ff ff       	call   c01010d6 <lpt_putc>
        cga_putc(c);
c010163b:	8b 45 08             	mov    0x8(%ebp),%eax
c010163e:	89 04 24             	mov    %eax,(%esp)
c0101641:	e8 cf fa ff ff       	call   c0101115 <cga_putc>
        serial_putc(c);
c0101646:	8b 45 08             	mov    0x8(%ebp),%eax
c0101649:	89 04 24             	mov    %eax,(%esp)
c010164c:	e8 f1 fc ff ff       	call   c0101342 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101654:	89 04 24             	mov    %eax,(%esp)
c0101657:	e8 dd f7 ff ff       	call   c0100e39 <__intr_restore>
}
c010165c:	c9                   	leave  
c010165d:	c3                   	ret    

c010165e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010165e:	55                   	push   %ebp
c010165f:	89 e5                	mov    %esp,%ebp
c0101661:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101664:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010166b:	e8 9f f7 ff ff       	call   c0100e0f <__intr_save>
c0101670:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101673:	e8 ab fd ff ff       	call   c0101423 <serial_intr>
        kbd_intr();
c0101678:	e8 4c ff ff ff       	call   c01015c9 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167d:	8b 15 e0 10 12 c0    	mov    0xc01210e0,%edx
c0101683:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c0101688:	39 c2                	cmp    %eax,%edx
c010168a:	74 31                	je     c01016bd <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168c:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101691:	8d 50 01             	lea    0x1(%eax),%edx
c0101694:	89 15 e0 10 12 c0    	mov    %edx,0xc01210e0
c010169a:	0f b6 80 e0 0e 12 c0 	movzbl -0x3fedf120(%eax),%eax
c01016a1:	0f b6 c0             	movzbl %al,%eax
c01016a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a7:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c01016ac:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b1:	75 0a                	jne    c01016bd <cons_getc+0x5f>
                cons.rpos = 0;
c01016b3:	c7 05 e0 10 12 c0 00 	movl   $0x0,0xc01210e0
c01016ba:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016c0:	89 04 24             	mov    %eax,(%esp)
c01016c3:	e8 71 f7 ff ff       	call   c0100e39 <__intr_restore>
    return c;
c01016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016cb:	c9                   	leave  
c01016cc:	c3                   	ret    

c01016cd <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016cd:	55                   	push   %ebp
c01016ce:	89 e5                	mov    %esp,%ebp
c01016d0:	83 ec 14             	sub    $0x14,%esp
c01016d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016da:	90                   	nop
c01016db:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016df:	83 c0 07             	add    $0x7,%eax
c01016e2:	0f b7 c0             	movzwl %ax,%eax
c01016e5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016ed:	89 c2                	mov    %eax,%edx
c01016ef:	ec                   	in     (%dx),%al
c01016f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f7:	0f b6 c0             	movzbl %al,%eax
c01016fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101700:	25 80 00 00 00       	and    $0x80,%eax
c0101705:	85 c0                	test   %eax,%eax
c0101707:	75 d2                	jne    c01016db <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010170d:	74 11                	je     c0101720 <ide_wait_ready+0x53>
c010170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101712:	83 e0 21             	and    $0x21,%eax
c0101715:	85 c0                	test   %eax,%eax
c0101717:	74 07                	je     c0101720 <ide_wait_ready+0x53>
        return -1;
c0101719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010171e:	eb 05                	jmp    c0101725 <ide_wait_ready+0x58>
    }
    return 0;
c0101720:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101725:	c9                   	leave  
c0101726:	c3                   	ret    

c0101727 <ide_init>:

void
ide_init(void) {
c0101727:	55                   	push   %ebp
c0101728:	89 e5                	mov    %esp,%ebp
c010172a:	57                   	push   %edi
c010172b:	53                   	push   %ebx
c010172c:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101732:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101738:	e9 d6 02 00 00       	jmp    c0101a13 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010173d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101741:	c1 e0 03             	shl    $0x3,%eax
c0101744:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010174b:	29 c2                	sub    %eax,%edx
c010174d:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101753:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101756:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010175a:	66 d1 e8             	shr    %ax
c010175d:	0f b7 c0             	movzwl %ax,%eax
c0101760:	0f b7 04 85 c8 8f 10 	movzwl -0x3fef7038(,%eax,4),%eax
c0101767:	c0 
c0101768:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c010176c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101770:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101777:	00 
c0101778:	89 04 24             	mov    %eax,(%esp)
c010177b:	e8 4d ff ff ff       	call   c01016cd <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101780:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101784:	83 e0 01             	and    $0x1,%eax
c0101787:	c1 e0 04             	shl    $0x4,%eax
c010178a:	83 c8 e0             	or     $0xffffffe0,%eax
c010178d:	0f b6 c0             	movzbl %al,%eax
c0101790:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101794:	83 c2 06             	add    $0x6,%edx
c0101797:	0f b7 d2             	movzwl %dx,%edx
c010179a:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010179e:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017a5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017a9:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017aa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017b5:	00 
c01017b6:	89 04 24             	mov    %eax,(%esp)
c01017b9:	e8 0f ff ff ff       	call   c01016cd <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c2:	83 c0 07             	add    $0x7,%eax
c01017c5:	0f b7 c0             	movzwl %ax,%eax
c01017c8:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017cc:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017d0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017d4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017d8:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017d9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017e4:	00 
c01017e5:	89 04 24             	mov    %eax,(%esp)
c01017e8:	e8 e0 fe ff ff       	call   c01016cd <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017ed:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017f1:	83 c0 07             	add    $0x7,%eax
c01017f4:	0f b7 c0             	movzwl %ax,%eax
c01017f7:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017fb:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017ff:	89 c2                	mov    %eax,%edx
c0101801:	ec                   	in     (%dx),%al
c0101802:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0101805:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101809:	84 c0                	test   %al,%al
c010180b:	0f 84 f7 01 00 00    	je     c0101a08 <ide_init+0x2e1>
c0101811:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101815:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010181c:	00 
c010181d:	89 04 24             	mov    %eax,(%esp)
c0101820:	e8 a8 fe ff ff       	call   c01016cd <ide_wait_ready>
c0101825:	85 c0                	test   %eax,%eax
c0101827:	0f 85 db 01 00 00    	jne    c0101a08 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010182d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101831:	c1 e0 03             	shl    $0x3,%eax
c0101834:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010183b:	29 c2                	sub    %eax,%edx
c010183d:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101843:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101846:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010184a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010184d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101853:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101856:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010185d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101860:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101863:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101866:	89 cb                	mov    %ecx,%ebx
c0101868:	89 df                	mov    %ebx,%edi
c010186a:	89 c1                	mov    %eax,%ecx
c010186c:	fc                   	cld    
c010186d:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010186f:	89 c8                	mov    %ecx,%eax
c0101871:	89 fb                	mov    %edi,%ebx
c0101873:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101876:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101879:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010187f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101885:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010188b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010188e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101891:	25 00 00 00 04       	and    $0x4000000,%eax
c0101896:	85 c0                	test   %eax,%eax
c0101898:	74 0e                	je     c01018a8 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010189a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010189d:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c01018a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01018a6:	eb 09                	jmp    c01018b1 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c01018a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ab:	8b 40 78             	mov    0x78(%eax),%eax
c01018ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c01018b1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b5:	c1 e0 03             	shl    $0x3,%eax
c01018b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018bf:	29 c2                	sub    %eax,%edx
c01018c1:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018ca:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018cd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018d1:	c1 e0 03             	shl    $0x3,%eax
c01018d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018db:	29 c2                	sub    %eax,%edx
c01018dd:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c01018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018e6:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ec:	83 c0 62             	add    $0x62,%eax
c01018ef:	0f b7 00             	movzwl (%eax),%eax
c01018f2:	0f b7 c0             	movzwl %ax,%eax
c01018f5:	25 00 02 00 00       	and    $0x200,%eax
c01018fa:	85 c0                	test   %eax,%eax
c01018fc:	75 24                	jne    c0101922 <ide_init+0x1fb>
c01018fe:	c7 44 24 0c d0 8f 10 	movl   $0xc0108fd0,0xc(%esp)
c0101905:	c0 
c0101906:	c7 44 24 08 13 90 10 	movl   $0xc0109013,0x8(%esp)
c010190d:	c0 
c010190e:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101915:	00 
c0101916:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c010191d:	e8 ce f3 ff ff       	call   c0100cf0 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101922:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101926:	c1 e0 03             	shl    $0x3,%eax
c0101929:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101930:	29 c2                	sub    %eax,%edx
c0101932:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101938:	83 c0 0c             	add    $0xc,%eax
c010193b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010193e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101941:	83 c0 36             	add    $0x36,%eax
c0101944:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101947:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010194e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101955:	eb 34                	jmp    c010198b <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101957:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010195d:	01 c2                	add    %eax,%edx
c010195f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101962:	8d 48 01             	lea    0x1(%eax),%ecx
c0101965:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101968:	01 c8                	add    %ecx,%eax
c010196a:	0f b6 00             	movzbl (%eax),%eax
c010196d:	88 02                	mov    %al,(%edx)
c010196f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101972:	8d 50 01             	lea    0x1(%eax),%edx
c0101975:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101978:	01 c2                	add    %eax,%edx
c010197a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101980:	01 c8                	add    %ecx,%eax
c0101982:	0f b6 00             	movzbl (%eax),%eax
c0101985:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101987:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101991:	72 c4                	jb     c0101957 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101993:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101996:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101999:	01 d0                	add    %edx,%eax
c010199b:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010199e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019a1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01019a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01019a7:	85 c0                	test   %eax,%eax
c01019a9:	74 0f                	je     c01019ba <ide_init+0x293>
c01019ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019b1:	01 d0                	add    %edx,%eax
c01019b3:	0f b6 00             	movzbl (%eax),%eax
c01019b6:	3c 20                	cmp    $0x20,%al
c01019b8:	74 d9                	je     c0101993 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019be:	c1 e0 03             	shl    $0x3,%eax
c01019c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c8:	29 c2                	sub    %eax,%edx
c01019ca:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019d0:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d7:	c1 e0 03             	shl    $0x3,%eax
c01019da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019e1:	29 c2                	sub    %eax,%edx
c01019e3:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019e9:	8b 50 08             	mov    0x8(%eax),%edx
c01019ec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019f4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fc:	c7 04 24 3a 90 10 c0 	movl   $0xc010903a,(%esp)
c0101a03:	e8 43 e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101a08:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0c:	83 c0 01             	add    $0x1,%eax
c0101a0f:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a13:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a18:	0f 86 1f fd ff ff    	jbe    c010173d <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a1e:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a25:	e8 7c 05 00 00       	call   c0101fa6 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a2a:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a31:	e8 70 05 00 00       	call   c0101fa6 <pic_enable>
}
c0101a36:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a3c:	5b                   	pop    %ebx
c0101a3d:	5f                   	pop    %edi
c0101a3e:	5d                   	pop    %ebp
c0101a3f:	c3                   	ret    

c0101a40 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a40:	55                   	push   %ebp
c0101a41:	89 e5                	mov    %esp,%ebp
c0101a43:	83 ec 04             	sub    $0x4,%esp
c0101a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a49:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a4d:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a52:	77 24                	ja     c0101a78 <ide_device_valid+0x38>
c0101a54:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a58:	c1 e0 03             	shl    $0x3,%eax
c0101a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a62:	29 c2                	sub    %eax,%edx
c0101a64:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a6a:	0f b6 00             	movzbl (%eax),%eax
c0101a6d:	84 c0                	test   %al,%al
c0101a6f:	74 07                	je     c0101a78 <ide_device_valid+0x38>
c0101a71:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a76:	eb 05                	jmp    c0101a7d <ide_device_valid+0x3d>
c0101a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a7d:	c9                   	leave  
c0101a7e:	c3                   	ret    

c0101a7f <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a7f:	55                   	push   %ebp
c0101a80:	89 e5                	mov    %esp,%ebp
c0101a82:	83 ec 08             	sub    $0x8,%esp
c0101a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a88:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a8c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a90:	89 04 24             	mov    %eax,(%esp)
c0101a93:	e8 a8 ff ff ff       	call   c0101a40 <ide_device_valid>
c0101a98:	85 c0                	test   %eax,%eax
c0101a9a:	74 1b                	je     c0101ab7 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a9c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aa0:	c1 e0 03             	shl    $0x3,%eax
c0101aa3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aaa:	29 c2                	sub    %eax,%edx
c0101aac:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101ab2:	8b 40 08             	mov    0x8(%eax),%eax
c0101ab5:	eb 05                	jmp    c0101abc <ide_device_size+0x3d>
    }
    return 0;
c0101ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101abc:	c9                   	leave  
c0101abd:	c3                   	ret    

c0101abe <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101abe:	55                   	push   %ebp
c0101abf:	89 e5                	mov    %esp,%ebp
c0101ac1:	57                   	push   %edi
c0101ac2:	53                   	push   %ebx
c0101ac3:	83 ec 50             	sub    $0x50,%esp
c0101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac9:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101acd:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ad4:	77 24                	ja     c0101afa <ide_read_secs+0x3c>
c0101ad6:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101adb:	77 1d                	ja     c0101afa <ide_read_secs+0x3c>
c0101add:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ae1:	c1 e0 03             	shl    $0x3,%eax
c0101ae4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aeb:	29 c2                	sub    %eax,%edx
c0101aed:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101af3:	0f b6 00             	movzbl (%eax),%eax
c0101af6:	84 c0                	test   %al,%al
c0101af8:	75 24                	jne    c0101b1e <ide_read_secs+0x60>
c0101afa:	c7 44 24 0c 58 90 10 	movl   $0xc0109058,0xc(%esp)
c0101b01:	c0 
c0101b02:	c7 44 24 08 13 90 10 	movl   $0xc0109013,0x8(%esp)
c0101b09:	c0 
c0101b0a:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101b11:	00 
c0101b12:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c0101b19:	e8 d2 f1 ff ff       	call   c0100cf0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b1e:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b25:	77 0f                	ja     c0101b36 <ide_read_secs+0x78>
c0101b27:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b2d:	01 d0                	add    %edx,%eax
c0101b2f:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b34:	76 24                	jbe    c0101b5a <ide_read_secs+0x9c>
c0101b36:	c7 44 24 0c 80 90 10 	movl   $0xc0109080,0xc(%esp)
c0101b3d:	c0 
c0101b3e:	c7 44 24 08 13 90 10 	movl   $0xc0109013,0x8(%esp)
c0101b45:	c0 
c0101b46:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b4d:	00 
c0101b4e:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c0101b55:	e8 96 f1 ff ff       	call   c0100cf0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b5a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b5e:	66 d1 e8             	shr    %ax
c0101b61:	0f b7 c0             	movzwl %ax,%eax
c0101b64:	0f b7 04 85 c8 8f 10 	movzwl -0x3fef7038(,%eax,4),%eax
c0101b6b:	c0 
c0101b6c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b70:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b74:	66 d1 e8             	shr    %ax
c0101b77:	0f b7 c0             	movzwl %ax,%eax
c0101b7a:	0f b7 04 85 ca 8f 10 	movzwl -0x3fef7036(,%eax,4),%eax
c0101b81:	c0 
c0101b82:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b86:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b8a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b91:	00 
c0101b92:	89 04 24             	mov    %eax,(%esp)
c0101b95:	e8 33 fb ff ff       	call   c01016cd <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b9a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b9e:	83 c0 02             	add    $0x2,%eax
c0101ba1:	0f b7 c0             	movzwl %ax,%eax
c0101ba4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ba8:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101bb0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101bb4:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101bb5:	8b 45 14             	mov    0x14(%ebp),%eax
c0101bb8:	0f b6 c0             	movzbl %al,%eax
c0101bbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bbf:	83 c2 02             	add    $0x2,%edx
c0101bc2:	0f b7 d2             	movzwl %dx,%edx
c0101bc5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bc9:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bcc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bd0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bd4:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bd8:	0f b6 c0             	movzbl %al,%eax
c0101bdb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bdf:	83 c2 03             	add    $0x3,%edx
c0101be2:	0f b7 d2             	movzwl %dx,%edx
c0101be5:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101be9:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bec:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bf0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bf4:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bf8:	c1 e8 08             	shr    $0x8,%eax
c0101bfb:	0f b6 c0             	movzbl %al,%eax
c0101bfe:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c02:	83 c2 04             	add    $0x4,%edx
c0101c05:	0f b7 d2             	movzwl %dx,%edx
c0101c08:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101c0c:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101c0f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c13:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c17:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c1b:	c1 e8 10             	shr    $0x10,%eax
c0101c1e:	0f b6 c0             	movzbl %al,%eax
c0101c21:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c25:	83 c2 05             	add    $0x5,%edx
c0101c28:	0f b7 d2             	movzwl %dx,%edx
c0101c2b:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c2f:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c32:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c36:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c3a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c3b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c3f:	83 e0 01             	and    $0x1,%eax
c0101c42:	c1 e0 04             	shl    $0x4,%eax
c0101c45:	89 c2                	mov    %eax,%edx
c0101c47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c4a:	c1 e8 18             	shr    $0x18,%eax
c0101c4d:	83 e0 0f             	and    $0xf,%eax
c0101c50:	09 d0                	or     %edx,%eax
c0101c52:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c55:	0f b6 c0             	movzbl %al,%eax
c0101c58:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c5c:	83 c2 06             	add    $0x6,%edx
c0101c5f:	0f b7 d2             	movzwl %dx,%edx
c0101c62:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c66:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c69:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c6d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c71:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c76:	83 c0 07             	add    $0x7,%eax
c0101c79:	0f b7 c0             	movzwl %ax,%eax
c0101c7c:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c80:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c84:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c88:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c8c:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c94:	eb 5a                	jmp    c0101cf0 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c96:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ca1:	00 
c0101ca2:	89 04 24             	mov    %eax,(%esp)
c0101ca5:	e8 23 fa ff ff       	call   c01016cd <ide_wait_ready>
c0101caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101cb1:	74 02                	je     c0101cb5 <ide_read_secs+0x1f7>
            goto out;
c0101cb3:	eb 41                	jmp    c0101cf6 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101cb5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cb9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101cbc:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cbf:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cc2:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cc9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ccc:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cd2:	89 cb                	mov    %ecx,%ebx
c0101cd4:	89 df                	mov    %ebx,%edi
c0101cd6:	89 c1                	mov    %eax,%ecx
c0101cd8:	fc                   	cld    
c0101cd9:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cdb:	89 c8                	mov    %ecx,%eax
c0101cdd:	89 fb                	mov    %edi,%ebx
c0101cdf:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ce2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101ce5:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101ce9:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cf0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cf4:	75 a0                	jne    c0101c96 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cf9:	83 c4 50             	add    $0x50,%esp
c0101cfc:	5b                   	pop    %ebx
c0101cfd:	5f                   	pop    %edi
c0101cfe:	5d                   	pop    %ebp
c0101cff:	c3                   	ret    

c0101d00 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d00:	55                   	push   %ebp
c0101d01:	89 e5                	mov    %esp,%ebp
c0101d03:	56                   	push   %esi
c0101d04:	53                   	push   %ebx
c0101d05:	83 ec 50             	sub    $0x50,%esp
c0101d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0b:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101d0f:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d16:	77 24                	ja     c0101d3c <ide_write_secs+0x3c>
c0101d18:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d1d:	77 1d                	ja     c0101d3c <ide_write_secs+0x3c>
c0101d1f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d23:	c1 e0 03             	shl    $0x3,%eax
c0101d26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d2d:	29 c2                	sub    %eax,%edx
c0101d2f:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101d35:	0f b6 00             	movzbl (%eax),%eax
c0101d38:	84 c0                	test   %al,%al
c0101d3a:	75 24                	jne    c0101d60 <ide_write_secs+0x60>
c0101d3c:	c7 44 24 0c 58 90 10 	movl   $0xc0109058,0xc(%esp)
c0101d43:	c0 
c0101d44:	c7 44 24 08 13 90 10 	movl   $0xc0109013,0x8(%esp)
c0101d4b:	c0 
c0101d4c:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d53:	00 
c0101d54:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c0101d5b:	e8 90 ef ff ff       	call   c0100cf0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d60:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d67:	77 0f                	ja     c0101d78 <ide_write_secs+0x78>
c0101d69:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d6f:	01 d0                	add    %edx,%eax
c0101d71:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d76:	76 24                	jbe    c0101d9c <ide_write_secs+0x9c>
c0101d78:	c7 44 24 0c 80 90 10 	movl   $0xc0109080,0xc(%esp)
c0101d7f:	c0 
c0101d80:	c7 44 24 08 13 90 10 	movl   $0xc0109013,0x8(%esp)
c0101d87:	c0 
c0101d88:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d8f:	00 
c0101d90:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c0101d97:	e8 54 ef ff ff       	call   c0100cf0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d9c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da0:	66 d1 e8             	shr    %ax
c0101da3:	0f b7 c0             	movzwl %ax,%eax
c0101da6:	0f b7 04 85 c8 8f 10 	movzwl -0x3fef7038(,%eax,4),%eax
c0101dad:	c0 
c0101dae:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101db2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101db6:	66 d1 e8             	shr    %ax
c0101db9:	0f b7 c0             	movzwl %ax,%eax
c0101dbc:	0f b7 04 85 ca 8f 10 	movzwl -0x3fef7036(,%eax,4),%eax
c0101dc3:	c0 
c0101dc4:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dc8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101dcc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dd3:	00 
c0101dd4:	89 04 24             	mov    %eax,(%esp)
c0101dd7:	e8 f1 f8 ff ff       	call   c01016cd <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ddc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101de0:	83 c0 02             	add    $0x2,%eax
c0101de3:	0f b7 c0             	movzwl %ax,%eax
c0101de6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dea:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101df2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101df6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101df7:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dfa:	0f b6 c0             	movzbl %al,%eax
c0101dfd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e01:	83 c2 02             	add    $0x2,%edx
c0101e04:	0f b7 d2             	movzwl %dx,%edx
c0101e07:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101e0b:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101e0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e12:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e16:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1a:	0f b6 c0             	movzbl %al,%eax
c0101e1d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e21:	83 c2 03             	add    $0x3,%edx
c0101e24:	0f b7 d2             	movzwl %dx,%edx
c0101e27:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e2b:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e2e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e32:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e36:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e3a:	c1 e8 08             	shr    $0x8,%eax
c0101e3d:	0f b6 c0             	movzbl %al,%eax
c0101e40:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e44:	83 c2 04             	add    $0x4,%edx
c0101e47:	0f b7 d2             	movzwl %dx,%edx
c0101e4a:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e4e:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e51:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e55:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e59:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e5d:	c1 e8 10             	shr    $0x10,%eax
c0101e60:	0f b6 c0             	movzbl %al,%eax
c0101e63:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e67:	83 c2 05             	add    $0x5,%edx
c0101e6a:	0f b7 d2             	movzwl %dx,%edx
c0101e6d:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e71:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e74:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e78:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e7c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e7d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e81:	83 e0 01             	and    $0x1,%eax
c0101e84:	c1 e0 04             	shl    $0x4,%eax
c0101e87:	89 c2                	mov    %eax,%edx
c0101e89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e8c:	c1 e8 18             	shr    $0x18,%eax
c0101e8f:	83 e0 0f             	and    $0xf,%eax
c0101e92:	09 d0                	or     %edx,%eax
c0101e94:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e97:	0f b6 c0             	movzbl %al,%eax
c0101e9a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e9e:	83 c2 06             	add    $0x6,%edx
c0101ea1:	0f b7 d2             	movzwl %dx,%edx
c0101ea4:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101ea8:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101eab:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101eaf:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101eb3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101eb4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eb8:	83 c0 07             	add    $0x7,%eax
c0101ebb:	0f b7 c0             	movzwl %ax,%eax
c0101ebe:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ec2:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101ec6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eca:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ece:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ecf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ed6:	eb 5a                	jmp    c0101f32 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ed8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101edc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ee3:	00 
c0101ee4:	89 04 24             	mov    %eax,(%esp)
c0101ee7:	e8 e1 f7 ff ff       	call   c01016cd <ide_wait_ready>
c0101eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101eef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ef3:	74 02                	je     c0101ef7 <ide_write_secs+0x1f7>
            goto out;
c0101ef5:	eb 41                	jmp    c0101f38 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ef7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101efb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101efe:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f01:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f04:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101f0b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101f0e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101f11:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f14:	89 cb                	mov    %ecx,%ebx
c0101f16:	89 de                	mov    %ebx,%esi
c0101f18:	89 c1                	mov    %eax,%ecx
c0101f1a:	fc                   	cld    
c0101f1b:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f1d:	89 c8                	mov    %ecx,%eax
c0101f1f:	89 f3                	mov    %esi,%ebx
c0101f21:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f24:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f27:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f2b:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f32:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f36:	75 a0                	jne    c0101ed8 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f3b:	83 c4 50             	add    $0x50,%esp
c0101f3e:	5b                   	pop    %ebx
c0101f3f:	5e                   	pop    %esi
c0101f40:	5d                   	pop    %ebp
c0101f41:	c3                   	ret    

c0101f42 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f42:	55                   	push   %ebp
c0101f43:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f45:	fb                   	sti    
    sti();
}
c0101f46:	5d                   	pop    %ebp
c0101f47:	c3                   	ret    

c0101f48 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f48:	55                   	push   %ebp
c0101f49:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f4b:	fa                   	cli    
    cli();
}
c0101f4c:	5d                   	pop    %ebp
c0101f4d:	c3                   	ret    

c0101f4e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f4e:	55                   	push   %ebp
c0101f4f:	89 e5                	mov    %esp,%ebp
c0101f51:	83 ec 14             	sub    $0x14,%esp
c0101f54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f57:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5f:	66 a3 70 05 12 c0    	mov    %ax,0xc0120570
    if (did_init) {
c0101f65:	a1 e0 11 12 c0       	mov    0xc01211e0,%eax
c0101f6a:	85 c0                	test   %eax,%eax
c0101f6c:	74 36                	je     c0101fa4 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f6e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f72:	0f b6 c0             	movzbl %al,%eax
c0101f75:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f7b:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f7e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f82:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f86:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f87:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f8b:	66 c1 e8 08          	shr    $0x8,%ax
c0101f8f:	0f b6 c0             	movzbl %al,%eax
c0101f92:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f98:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f9b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f9f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fa3:	ee                   	out    %al,(%dx)
    }
}
c0101fa4:	c9                   	leave  
c0101fa5:	c3                   	ret    

c0101fa6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101fa6:	55                   	push   %ebp
c0101fa7:	89 e5                	mov    %esp,%ebp
c0101fa9:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101faf:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fb4:	89 c1                	mov    %eax,%ecx
c0101fb6:	d3 e2                	shl    %cl,%edx
c0101fb8:	89 d0                	mov    %edx,%eax
c0101fba:	f7 d0                	not    %eax
c0101fbc:	89 c2                	mov    %eax,%edx
c0101fbe:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c0101fc5:	21 d0                	and    %edx,%eax
c0101fc7:	0f b7 c0             	movzwl %ax,%eax
c0101fca:	89 04 24             	mov    %eax,(%esp)
c0101fcd:	e8 7c ff ff ff       	call   c0101f4e <pic_setmask>
}
c0101fd2:	c9                   	leave  
c0101fd3:	c3                   	ret    

c0101fd4 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fd4:	55                   	push   %ebp
c0101fd5:	89 e5                	mov    %esp,%ebp
c0101fd7:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fda:	c7 05 e0 11 12 c0 01 	movl   $0x1,0xc01211e0
c0101fe1:	00 00 00 
c0101fe4:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fea:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fee:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101ff2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101ff6:	ee                   	out    %al,(%dx)
c0101ff7:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101ffd:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0102001:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102005:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102009:	ee                   	out    %al,(%dx)
c010200a:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102010:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102014:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102018:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010201c:	ee                   	out    %al,(%dx)
c010201d:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102023:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102027:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010202b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010202f:	ee                   	out    %al,(%dx)
c0102030:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102036:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010203a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010203e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102042:	ee                   	out    %al,(%dx)
c0102043:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102049:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010204d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102051:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102055:	ee                   	out    %al,(%dx)
c0102056:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010205c:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102060:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102064:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102068:	ee                   	out    %al,(%dx)
c0102069:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010206f:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102073:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102077:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010207b:	ee                   	out    %al,(%dx)
c010207c:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102082:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102086:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010208a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010208e:	ee                   	out    %al,(%dx)
c010208f:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102095:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102099:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010209d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01020a1:	ee                   	out    %al,(%dx)
c01020a2:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01020a8:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01020ac:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01020b0:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020b4:	ee                   	out    %al,(%dx)
c01020b5:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020bb:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020bf:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020c3:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020c7:	ee                   	out    %al,(%dx)
c01020c8:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020ce:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020d2:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020d6:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020da:	ee                   	out    %al,(%dx)
c01020db:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020e1:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020e5:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020e9:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020ed:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020ee:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01020f5:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020f9:	74 12                	je     c010210d <pic_init+0x139>
        pic_setmask(irq_mask);
c01020fb:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c0102102:	0f b7 c0             	movzwl %ax,%eax
c0102105:	89 04 24             	mov    %eax,(%esp)
c0102108:	e8 41 fe ff ff       	call   c0101f4e <pic_setmask>
    }
}
c010210d:	c9                   	leave  
c010210e:	c3                   	ret    

c010210f <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010210f:	55                   	push   %ebp
c0102110:	89 e5                	mov    %esp,%ebp
c0102112:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102115:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010211c:	00 
c010211d:	c7 04 24 c0 90 10 c0 	movl   $0xc01090c0,(%esp)
c0102124:	e8 22 e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102129:	c7 04 24 ca 90 10 c0 	movl   $0xc01090ca,(%esp)
c0102130:	e8 16 e2 ff ff       	call   c010034b <cprintf>
    panic("EOT: kernel seems ok.");
c0102135:	c7 44 24 08 d8 90 10 	movl   $0xc01090d8,0x8(%esp)
c010213c:	c0 
c010213d:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0102144:	00 
c0102145:	c7 04 24 ee 90 10 c0 	movl   $0xc01090ee,(%esp)
c010214c:	e8 9f eb ff ff       	call   c0100cf0 <__panic>

c0102151 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102151:	55                   	push   %ebp
c0102152:	89 e5                	mov    %esp,%ebp
c0102154:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
c0102157:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i=0;
c010215e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//setup each item of IDT;
	for(i=0; i<len; i++)
c0102165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010216c:	e9 c3 00 00 00       	jmp    c0102234 <idt_init+0xe3>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102171:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102174:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c010217b:	89 c2                	mov    %eax,%edx
c010217d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102180:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c0102187:	c0 
c0102188:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218b:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c0102192:	c0 08 00 
c0102195:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102198:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c010219f:	c0 
c01021a0:	83 e2 e0             	and    $0xffffffe0,%edx
c01021a3:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c01021aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ad:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c01021b4:	c0 
c01021b5:	83 e2 1f             	and    $0x1f,%edx
c01021b8:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c01021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c2:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021c9:	c0 
c01021ca:	83 e2 f0             	and    $0xfffffff0,%edx
c01021cd:	83 ca 0e             	or     $0xe,%edx
c01021d0:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021da:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021e1:	c0 
c01021e2:	83 e2 ef             	and    $0xffffffef,%edx
c01021e5:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01021ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ef:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01021f6:	c0 
c01021f7:	83 e2 9f             	and    $0xffffff9f,%edx
c01021fa:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102201:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102204:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c010220b:	c0 
c010220c:	83 ca 80             	or     $0xffffff80,%edx
c010220f:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102216:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102219:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c0102220:	c1 e8 10             	shr    $0x10,%eax
c0102223:	89 c2                	mov    %eax,%edx
c0102225:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102228:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c010222f:	c0 
idt_init(void) {
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
	int i=0;
	//setup each item of IDT;
	for(i=0; i<len; i++)
c0102230:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102234:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102237:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010223a:	0f 8c 31 ff ff ff    	jl     c0102171 <idt_init+0x20>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
c0102240:	a1 e4 07 12 c0       	mov    0xc01207e4,%eax
c0102245:	66 a3 c8 15 12 c0    	mov    %ax,0xc01215c8
c010224b:	66 c7 05 ca 15 12 c0 	movw   $0x8,0xc01215ca
c0102252:	08 00 
c0102254:	0f b6 05 cc 15 12 c0 	movzbl 0xc01215cc,%eax
c010225b:	83 e0 e0             	and    $0xffffffe0,%eax
c010225e:	a2 cc 15 12 c0       	mov    %al,0xc01215cc
c0102263:	0f b6 05 cc 15 12 c0 	movzbl 0xc01215cc,%eax
c010226a:	83 e0 1f             	and    $0x1f,%eax
c010226d:	a2 cc 15 12 c0       	mov    %al,0xc01215cc
c0102272:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102279:	83 e0 f0             	and    $0xfffffff0,%eax
c010227c:	83 c8 0e             	or     $0xe,%eax
c010227f:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c0102284:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c010228b:	83 e0 ef             	and    $0xffffffef,%eax
c010228e:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c0102293:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c010229a:	83 e0 9f             	and    $0xffffff9f,%eax
c010229d:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c01022a2:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c01022a9:	83 c8 80             	or     $0xffffff80,%eax
c01022ac:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c01022b1:	a1 e4 07 12 c0       	mov    0xc01207e4,%eax
c01022b6:	c1 e8 10             	shr    $0x10,%eax
c01022b9:	66 a3 ce 15 12 c0    	mov    %ax,0xc01215ce
c01022bf:	c7 45 f4 80 05 12 c0 	movl   $0xc0120580,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01022c9:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);//载入IDT;
	return;
c01022cc:	90                   	nop
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c01022cd:	c9                   	leave  
c01022ce:	c3                   	ret    

c01022cf <trapname>:

static const char *
trapname(int trapno) {
c01022cf:	55                   	push   %ebp
c01022d0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d5:	83 f8 13             	cmp    $0x13,%eax
c01022d8:	77 0c                	ja     c01022e6 <trapname+0x17>
        return excnames[trapno];
c01022da:	8b 45 08             	mov    0x8(%ebp),%eax
c01022dd:	8b 04 85 c0 94 10 c0 	mov    -0x3fef6b40(,%eax,4),%eax
c01022e4:	eb 18                	jmp    c01022fe <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022e6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022ea:	7e 0d                	jle    c01022f9 <trapname+0x2a>
c01022ec:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022f0:	7f 07                	jg     c01022f9 <trapname+0x2a>
        return "Hardware Interrupt";
c01022f2:	b8 ff 90 10 c0       	mov    $0xc01090ff,%eax
c01022f7:	eb 05                	jmp    c01022fe <trapname+0x2f>
    }
    return "(unknown trap)";
c01022f9:	b8 12 91 10 c0       	mov    $0xc0109112,%eax
}
c01022fe:	5d                   	pop    %ebp
c01022ff:	c3                   	ret    

c0102300 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102300:	55                   	push   %ebp
c0102301:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102303:	8b 45 08             	mov    0x8(%ebp),%eax
c0102306:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010230a:	66 83 f8 08          	cmp    $0x8,%ax
c010230e:	0f 94 c0             	sete   %al
c0102311:	0f b6 c0             	movzbl %al,%eax
}
c0102314:	5d                   	pop    %ebp
c0102315:	c3                   	ret    

c0102316 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102316:	55                   	push   %ebp
c0102317:	89 e5                	mov    %esp,%ebp
c0102319:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010231c:	8b 45 08             	mov    0x8(%ebp),%eax
c010231f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102323:	c7 04 24 53 91 10 c0 	movl   $0xc0109153,(%esp)
c010232a:	e8 1c e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c010232f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102332:	89 04 24             	mov    %eax,(%esp)
c0102335:	e8 a1 01 00 00       	call   c01024db <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010233a:	8b 45 08             	mov    0x8(%ebp),%eax
c010233d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102341:	0f b7 c0             	movzwl %ax,%eax
c0102344:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102348:	c7 04 24 64 91 10 c0 	movl   $0xc0109164,(%esp)
c010234f:	e8 f7 df ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102354:	8b 45 08             	mov    0x8(%ebp),%eax
c0102357:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010235b:	0f b7 c0             	movzwl %ax,%eax
c010235e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102362:	c7 04 24 77 91 10 c0 	movl   $0xc0109177,(%esp)
c0102369:	e8 dd df ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010236e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102371:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102375:	0f b7 c0             	movzwl %ax,%eax
c0102378:	89 44 24 04          	mov    %eax,0x4(%esp)
c010237c:	c7 04 24 8a 91 10 c0 	movl   $0xc010918a,(%esp)
c0102383:	e8 c3 df ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102388:	8b 45 08             	mov    0x8(%ebp),%eax
c010238b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010238f:	0f b7 c0             	movzwl %ax,%eax
c0102392:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102396:	c7 04 24 9d 91 10 c0 	movl   $0xc010919d,(%esp)
c010239d:	e8 a9 df ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01023a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a5:	8b 40 30             	mov    0x30(%eax),%eax
c01023a8:	89 04 24             	mov    %eax,(%esp)
c01023ab:	e8 1f ff ff ff       	call   c01022cf <trapname>
c01023b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01023b3:	8b 52 30             	mov    0x30(%edx),%edx
c01023b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01023ba:	89 54 24 04          	mov    %edx,0x4(%esp)
c01023be:	c7 04 24 b0 91 10 c0 	movl   $0xc01091b0,(%esp)
c01023c5:	e8 81 df ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cd:	8b 40 34             	mov    0x34(%eax),%eax
c01023d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d4:	c7 04 24 c2 91 10 c0 	movl   $0xc01091c2,(%esp)
c01023db:	e8 6b df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e3:	8b 40 38             	mov    0x38(%eax),%eax
c01023e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023ea:	c7 04 24 d1 91 10 c0 	movl   $0xc01091d1,(%esp)
c01023f1:	e8 55 df ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023fd:	0f b7 c0             	movzwl %ax,%eax
c0102400:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102404:	c7 04 24 e0 91 10 c0 	movl   $0xc01091e0,(%esp)
c010240b:	e8 3b df ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102410:	8b 45 08             	mov    0x8(%ebp),%eax
c0102413:	8b 40 40             	mov    0x40(%eax),%eax
c0102416:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241a:	c7 04 24 f3 91 10 c0 	movl   $0xc01091f3,(%esp)
c0102421:	e8 25 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010242d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102434:	eb 3e                	jmp    c0102474 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102436:	8b 45 08             	mov    0x8(%ebp),%eax
c0102439:	8b 50 40             	mov    0x40(%eax),%edx
c010243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010243f:	21 d0                	and    %edx,%eax
c0102441:	85 c0                	test   %eax,%eax
c0102443:	74 28                	je     c010246d <print_trapframe+0x157>
c0102445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102448:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c010244f:	85 c0                	test   %eax,%eax
c0102451:	74 1a                	je     c010246d <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102453:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102456:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c010245d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102461:	c7 04 24 02 92 10 c0 	movl   $0xc0109202,(%esp)
c0102468:	e8 de de ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010246d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102471:	d1 65 f0             	shll   -0x10(%ebp)
c0102474:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102477:	83 f8 17             	cmp    $0x17,%eax
c010247a:	76 ba                	jbe    c0102436 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010247c:	8b 45 08             	mov    0x8(%ebp),%eax
c010247f:	8b 40 40             	mov    0x40(%eax),%eax
c0102482:	25 00 30 00 00       	and    $0x3000,%eax
c0102487:	c1 e8 0c             	shr    $0xc,%eax
c010248a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248e:	c7 04 24 06 92 10 c0 	movl   $0xc0109206,(%esp)
c0102495:	e8 b1 de ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c010249a:	8b 45 08             	mov    0x8(%ebp),%eax
c010249d:	89 04 24             	mov    %eax,(%esp)
c01024a0:	e8 5b fe ff ff       	call   c0102300 <trap_in_kernel>
c01024a5:	85 c0                	test   %eax,%eax
c01024a7:	75 30                	jne    c01024d9 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01024a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ac:	8b 40 44             	mov    0x44(%eax),%eax
c01024af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b3:	c7 04 24 0f 92 10 c0 	movl   $0xc010920f,(%esp)
c01024ba:	e8 8c de ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01024bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c2:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024c6:	0f b7 c0             	movzwl %ax,%eax
c01024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024cd:	c7 04 24 1e 92 10 c0 	movl   $0xc010921e,(%esp)
c01024d4:	e8 72 de ff ff       	call   c010034b <cprintf>
    }
}
c01024d9:	c9                   	leave  
c01024da:	c3                   	ret    

c01024db <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024db:	55                   	push   %ebp
c01024dc:	89 e5                	mov    %esp,%ebp
c01024de:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e4:	8b 00                	mov    (%eax),%eax
c01024e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ea:	c7 04 24 31 92 10 c0 	movl   $0xc0109231,(%esp)
c01024f1:	e8 55 de ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f9:	8b 40 04             	mov    0x4(%eax),%eax
c01024fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102500:	c7 04 24 40 92 10 c0 	movl   $0xc0109240,(%esp)
c0102507:	e8 3f de ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010250c:	8b 45 08             	mov    0x8(%ebp),%eax
c010250f:	8b 40 08             	mov    0x8(%eax),%eax
c0102512:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102516:	c7 04 24 4f 92 10 c0 	movl   $0xc010924f,(%esp)
c010251d:	e8 29 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102522:	8b 45 08             	mov    0x8(%ebp),%eax
c0102525:	8b 40 0c             	mov    0xc(%eax),%eax
c0102528:	89 44 24 04          	mov    %eax,0x4(%esp)
c010252c:	c7 04 24 5e 92 10 c0 	movl   $0xc010925e,(%esp)
c0102533:	e8 13 de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102538:	8b 45 08             	mov    0x8(%ebp),%eax
c010253b:	8b 40 10             	mov    0x10(%eax),%eax
c010253e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102542:	c7 04 24 6d 92 10 c0 	movl   $0xc010926d,(%esp)
c0102549:	e8 fd dd ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010254e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102551:	8b 40 14             	mov    0x14(%eax),%eax
c0102554:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102558:	c7 04 24 7c 92 10 c0 	movl   $0xc010927c,(%esp)
c010255f:	e8 e7 dd ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102564:	8b 45 08             	mov    0x8(%ebp),%eax
c0102567:	8b 40 18             	mov    0x18(%eax),%eax
c010256a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010256e:	c7 04 24 8b 92 10 c0 	movl   $0xc010928b,(%esp)
c0102575:	e8 d1 dd ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010257a:	8b 45 08             	mov    0x8(%ebp),%eax
c010257d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102580:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102584:	c7 04 24 9a 92 10 c0 	movl   $0xc010929a,(%esp)
c010258b:	e8 bb dd ff ff       	call   c010034b <cprintf>
}
c0102590:	c9                   	leave  
c0102591:	c3                   	ret    

c0102592 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102592:	55                   	push   %ebp
c0102593:	89 e5                	mov    %esp,%ebp
c0102595:	53                   	push   %ebx
c0102596:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102599:	8b 45 08             	mov    0x8(%ebp),%eax
c010259c:	8b 40 34             	mov    0x34(%eax),%eax
c010259f:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025a2:	85 c0                	test   %eax,%eax
c01025a4:	74 07                	je     c01025ad <print_pgfault+0x1b>
c01025a6:	b9 a9 92 10 c0       	mov    $0xc01092a9,%ecx
c01025ab:	eb 05                	jmp    c01025b2 <print_pgfault+0x20>
c01025ad:	b9 ba 92 10 c0       	mov    $0xc01092ba,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01025b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b5:	8b 40 34             	mov    0x34(%eax),%eax
c01025b8:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025bb:	85 c0                	test   %eax,%eax
c01025bd:	74 07                	je     c01025c6 <print_pgfault+0x34>
c01025bf:	ba 57 00 00 00       	mov    $0x57,%edx
c01025c4:	eb 05                	jmp    c01025cb <print_pgfault+0x39>
c01025c6:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ce:	8b 40 34             	mov    0x34(%eax),%eax
c01025d1:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025d4:	85 c0                	test   %eax,%eax
c01025d6:	74 07                	je     c01025df <print_pgfault+0x4d>
c01025d8:	b8 55 00 00 00       	mov    $0x55,%eax
c01025dd:	eb 05                	jmp    c01025e4 <print_pgfault+0x52>
c01025df:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025e4:	0f 20 d3             	mov    %cr2,%ebx
c01025e7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01025ea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025ed:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025f5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01025f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01025fd:	c7 04 24 c8 92 10 c0 	movl   $0xc01092c8,(%esp)
c0102604:	e8 42 dd ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102609:	83 c4 34             	add    $0x34,%esp
c010260c:	5b                   	pop    %ebx
c010260d:	5d                   	pop    %ebp
c010260e:	c3                   	ret    

c010260f <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010260f:	55                   	push   %ebp
c0102610:	89 e5                	mov    %esp,%ebp
c0102612:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102615:	8b 45 08             	mov    0x8(%ebp),%eax
c0102618:	89 04 24             	mov    %eax,(%esp)
c010261b:	e8 72 ff ff ff       	call   c0102592 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102620:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0102625:	85 c0                	test   %eax,%eax
c0102627:	74 28                	je     c0102651 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102629:	0f 20 d0             	mov    %cr2,%eax
c010262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102632:	89 c1                	mov    %eax,%ecx
c0102634:	8b 45 08             	mov    0x8(%ebp),%eax
c0102637:	8b 50 34             	mov    0x34(%eax),%edx
c010263a:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010263f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102643:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102647:	89 04 24             	mov    %eax,(%esp)
c010264a:	e8 90 56 00 00       	call   c0107cdf <do_pgfault>
c010264f:	eb 1c                	jmp    c010266d <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102651:	c7 44 24 08 eb 92 10 	movl   $0xc01092eb,0x8(%esp)
c0102658:	c0 
c0102659:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102660:	00 
c0102661:	c7 04 24 ee 90 10 c0 	movl   $0xc01090ee,(%esp)
c0102668:	e8 83 e6 ff ff       	call   c0100cf0 <__panic>
}
c010266d:	c9                   	leave  
c010266e:	c3                   	ret    

c010266f <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010266f:	55                   	push   %ebp
c0102670:	89 e5                	mov    %esp,%ebp
c0102672:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102675:	8b 45 08             	mov    0x8(%ebp),%eax
c0102678:	8b 40 30             	mov    0x30(%eax),%eax
c010267b:	83 f8 24             	cmp    $0x24,%eax
c010267e:	0f 84 c2 00 00 00    	je     c0102746 <trap_dispatch+0xd7>
c0102684:	83 f8 24             	cmp    $0x24,%eax
c0102687:	77 18                	ja     c01026a1 <trap_dispatch+0x32>
c0102689:	83 f8 20             	cmp    $0x20,%eax
c010268c:	74 7d                	je     c010270b <trap_dispatch+0x9c>
c010268e:	83 f8 21             	cmp    $0x21,%eax
c0102691:	0f 84 d5 00 00 00    	je     c010276c <trap_dispatch+0xfd>
c0102697:	83 f8 0e             	cmp    $0xe,%eax
c010269a:	74 28                	je     c01026c4 <trap_dispatch+0x55>
c010269c:	e9 0d 01 00 00       	jmp    c01027ae <trap_dispatch+0x13f>
c01026a1:	83 f8 2e             	cmp    $0x2e,%eax
c01026a4:	0f 82 04 01 00 00    	jb     c01027ae <trap_dispatch+0x13f>
c01026aa:	83 f8 2f             	cmp    $0x2f,%eax
c01026ad:	0f 86 33 01 00 00    	jbe    c01027e6 <trap_dispatch+0x177>
c01026b3:	83 e8 78             	sub    $0x78,%eax
c01026b6:	83 f8 01             	cmp    $0x1,%eax
c01026b9:	0f 87 ef 00 00 00    	ja     c01027ae <trap_dispatch+0x13f>
c01026bf:	e9 ce 00 00 00       	jmp    c0102792 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01026c7:	89 04 24             	mov    %eax,(%esp)
c01026ca:	e8 40 ff ff ff       	call   c010260f <pgfault_handler>
c01026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026d6:	74 2e                	je     c0102706 <trap_dispatch+0x97>
            print_trapframe(tf);
c01026d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01026db:	89 04 24             	mov    %eax,(%esp)
c01026de:	e8 33 fc ff ff       	call   c0102316 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026ea:	c7 44 24 08 02 93 10 	movl   $0xc0109302,0x8(%esp)
c01026f1:	c0 
c01026f2:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01026f9:	00 
c01026fa:	c7 04 24 ee 90 10 c0 	movl   $0xc01090ee,(%esp)
c0102701:	e8 ea e5 ff ff       	call   c0100cf0 <__panic>
        }
        break;
c0102706:	e9 dc 00 00 00       	jmp    c01027e7 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_TIMER:
#if 0
    LAB3 : If some page replacement algorithm(such as CLOCK PRA) need tick to change the priority of pages, 
    then you can add code here. 
#endif
		ticks++;//in clock.h(extern volatile size_t ticks;);
c010270b:	a1 bc 1a 12 c0       	mov    0xc0121abc,%eax
c0102710:	83 c0 01             	add    $0x1,%eax
c0102713:	a3 bc 1a 12 c0       	mov    %eax,0xc0121abc
    	if(ticks % TICK_NUM == 0)
c0102718:	8b 0d bc 1a 12 c0    	mov    0xc0121abc,%ecx
c010271e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102723:	89 c8                	mov    %ecx,%eax
c0102725:	f7 e2                	mul    %edx
c0102727:	89 d0                	mov    %edx,%eax
c0102729:	c1 e8 05             	shr    $0x5,%eax
c010272c:	6b c0 64             	imul   $0x64,%eax,%eax
c010272f:	29 c1                	sub    %eax,%ecx
c0102731:	89 c8                	mov    %ecx,%eax
c0102733:	85 c0                	test   %eax,%eax
c0102735:	75 0a                	jne    c0102741 <trap_dispatch+0xd2>
    	{
    		print_ticks();//打印"100	ticks";
c0102737:	e8 d3 f9 ff ff       	call   c010210f <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c010273c:	e9 a6 00 00 00       	jmp    c01027e7 <trap_dispatch+0x178>
c0102741:	e9 a1 00 00 00       	jmp    c01027e7 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102746:	e8 13 ef ff ff       	call   c010165e <cons_getc>
c010274b:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010274e:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102752:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102756:	89 54 24 08          	mov    %edx,0x8(%esp)
c010275a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010275e:	c7 04 24 1d 93 10 c0 	movl   $0xc010931d,(%esp)
c0102765:	e8 e1 db ff ff       	call   c010034b <cprintf>
        break;
c010276a:	eb 7b                	jmp    c01027e7 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010276c:	e8 ed ee ff ff       	call   c010165e <cons_getc>
c0102771:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102774:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102778:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010277c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102780:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102784:	c7 04 24 2f 93 10 c0 	movl   $0xc010932f,(%esp)
c010278b:	e8 bb db ff ff       	call   c010034b <cprintf>
        break;
c0102790:	eb 55                	jmp    c01027e7 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102792:	c7 44 24 08 3e 93 10 	movl   $0xc010933e,0x8(%esp)
c0102799:	c0 
c010279a:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c01027a1:	00 
c01027a2:	c7 04 24 ee 90 10 c0 	movl   $0xc01090ee,(%esp)
c01027a9:	e8 42 e5 ff ff       	call   c0100cf0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01027b5:	0f b7 c0             	movzwl %ax,%eax
c01027b8:	83 e0 03             	and    $0x3,%eax
c01027bb:	85 c0                	test   %eax,%eax
c01027bd:	75 28                	jne    c01027e7 <trap_dispatch+0x178>
            print_trapframe(tf);
c01027bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c2:	89 04 24             	mov    %eax,(%esp)
c01027c5:	e8 4c fb ff ff       	call   c0102316 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01027ca:	c7 44 24 08 4e 93 10 	movl   $0xc010934e,0x8(%esp)
c01027d1:	c0 
c01027d2:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01027d9:	00 
c01027da:	c7 04 24 ee 90 10 c0 	movl   $0xc01090ee,(%esp)
c01027e1:	e8 0a e5 ff ff       	call   c0100cf0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01027e6:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c01027e7:	c9                   	leave  
c01027e8:	c3                   	ret    

c01027e9 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01027e9:	55                   	push   %ebp
c01027ea:	89 e5                	mov    %esp,%ebp
c01027ec:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01027f2:	89 04 24             	mov    %eax,(%esp)
c01027f5:	e8 75 fe ff ff       	call   c010266f <trap_dispatch>
}
c01027fa:	c9                   	leave  
c01027fb:	c3                   	ret    

c01027fc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01027fc:	1e                   	push   %ds
    pushl %es
c01027fd:	06                   	push   %es
    pushl %fs
c01027fe:	0f a0                	push   %fs
    pushl %gs
c0102800:	0f a8                	push   %gs
    pushal
c0102802:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102803:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102808:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010280a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010280c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010280d:	e8 d7 ff ff ff       	call   c01027e9 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102812:	5c                   	pop    %esp

c0102813 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102813:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102814:	0f a9                	pop    %gs
    popl %fs
c0102816:	0f a1                	pop    %fs
    popl %es
c0102818:	07                   	pop    %es
    popl %ds
c0102819:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010281a:	83 c4 08             	add    $0x8,%esp
    iret
c010281d:	cf                   	iret   

c010281e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $0
c0102820:	6a 00                	push   $0x0
  jmp __alltraps
c0102822:	e9 d5 ff ff ff       	jmp    c01027fc <__alltraps>

c0102827 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $1
c0102829:	6a 01                	push   $0x1
  jmp __alltraps
c010282b:	e9 cc ff ff ff       	jmp    c01027fc <__alltraps>

c0102830 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $2
c0102832:	6a 02                	push   $0x2
  jmp __alltraps
c0102834:	e9 c3 ff ff ff       	jmp    c01027fc <__alltraps>

c0102839 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $3
c010283b:	6a 03                	push   $0x3
  jmp __alltraps
c010283d:	e9 ba ff ff ff       	jmp    c01027fc <__alltraps>

c0102842 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $4
c0102844:	6a 04                	push   $0x4
  jmp __alltraps
c0102846:	e9 b1 ff ff ff       	jmp    c01027fc <__alltraps>

c010284b <vector5>:
.globl vector5
vector5:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $5
c010284d:	6a 05                	push   $0x5
  jmp __alltraps
c010284f:	e9 a8 ff ff ff       	jmp    c01027fc <__alltraps>

c0102854 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $6
c0102856:	6a 06                	push   $0x6
  jmp __alltraps
c0102858:	e9 9f ff ff ff       	jmp    c01027fc <__alltraps>

c010285d <vector7>:
.globl vector7
vector7:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $7
c010285f:	6a 07                	push   $0x7
  jmp __alltraps
c0102861:	e9 96 ff ff ff       	jmp    c01027fc <__alltraps>

c0102866 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102866:	6a 08                	push   $0x8
  jmp __alltraps
c0102868:	e9 8f ff ff ff       	jmp    c01027fc <__alltraps>

c010286d <vector9>:
.globl vector9
vector9:
  pushl $9
c010286d:	6a 09                	push   $0x9
  jmp __alltraps
c010286f:	e9 88 ff ff ff       	jmp    c01027fc <__alltraps>

c0102874 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102874:	6a 0a                	push   $0xa
  jmp __alltraps
c0102876:	e9 81 ff ff ff       	jmp    c01027fc <__alltraps>

c010287b <vector11>:
.globl vector11
vector11:
  pushl $11
c010287b:	6a 0b                	push   $0xb
  jmp __alltraps
c010287d:	e9 7a ff ff ff       	jmp    c01027fc <__alltraps>

c0102882 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102882:	6a 0c                	push   $0xc
  jmp __alltraps
c0102884:	e9 73 ff ff ff       	jmp    c01027fc <__alltraps>

c0102889 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102889:	6a 0d                	push   $0xd
  jmp __alltraps
c010288b:	e9 6c ff ff ff       	jmp    c01027fc <__alltraps>

c0102890 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102890:	6a 0e                	push   $0xe
  jmp __alltraps
c0102892:	e9 65 ff ff ff       	jmp    c01027fc <__alltraps>

c0102897 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $15
c0102899:	6a 0f                	push   $0xf
  jmp __alltraps
c010289b:	e9 5c ff ff ff       	jmp    c01027fc <__alltraps>

c01028a0 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $16
c01028a2:	6a 10                	push   $0x10
  jmp __alltraps
c01028a4:	e9 53 ff ff ff       	jmp    c01027fc <__alltraps>

c01028a9 <vector17>:
.globl vector17
vector17:
  pushl $17
c01028a9:	6a 11                	push   $0x11
  jmp __alltraps
c01028ab:	e9 4c ff ff ff       	jmp    c01027fc <__alltraps>

c01028b0 <vector18>:
.globl vector18
vector18:
  pushl $0
c01028b0:	6a 00                	push   $0x0
  pushl $18
c01028b2:	6a 12                	push   $0x12
  jmp __alltraps
c01028b4:	e9 43 ff ff ff       	jmp    c01027fc <__alltraps>

c01028b9 <vector19>:
.globl vector19
vector19:
  pushl $0
c01028b9:	6a 00                	push   $0x0
  pushl $19
c01028bb:	6a 13                	push   $0x13
  jmp __alltraps
c01028bd:	e9 3a ff ff ff       	jmp    c01027fc <__alltraps>

c01028c2 <vector20>:
.globl vector20
vector20:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $20
c01028c4:	6a 14                	push   $0x14
  jmp __alltraps
c01028c6:	e9 31 ff ff ff       	jmp    c01027fc <__alltraps>

c01028cb <vector21>:
.globl vector21
vector21:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $21
c01028cd:	6a 15                	push   $0x15
  jmp __alltraps
c01028cf:	e9 28 ff ff ff       	jmp    c01027fc <__alltraps>

c01028d4 <vector22>:
.globl vector22
vector22:
  pushl $0
c01028d4:	6a 00                	push   $0x0
  pushl $22
c01028d6:	6a 16                	push   $0x16
  jmp __alltraps
c01028d8:	e9 1f ff ff ff       	jmp    c01027fc <__alltraps>

c01028dd <vector23>:
.globl vector23
vector23:
  pushl $0
c01028dd:	6a 00                	push   $0x0
  pushl $23
c01028df:	6a 17                	push   $0x17
  jmp __alltraps
c01028e1:	e9 16 ff ff ff       	jmp    c01027fc <__alltraps>

c01028e6 <vector24>:
.globl vector24
vector24:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $24
c01028e8:	6a 18                	push   $0x18
  jmp __alltraps
c01028ea:	e9 0d ff ff ff       	jmp    c01027fc <__alltraps>

c01028ef <vector25>:
.globl vector25
vector25:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $25
c01028f1:	6a 19                	push   $0x19
  jmp __alltraps
c01028f3:	e9 04 ff ff ff       	jmp    c01027fc <__alltraps>

c01028f8 <vector26>:
.globl vector26
vector26:
  pushl $0
c01028f8:	6a 00                	push   $0x0
  pushl $26
c01028fa:	6a 1a                	push   $0x1a
  jmp __alltraps
c01028fc:	e9 fb fe ff ff       	jmp    c01027fc <__alltraps>

c0102901 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102901:	6a 00                	push   $0x0
  pushl $27
c0102903:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102905:	e9 f2 fe ff ff       	jmp    c01027fc <__alltraps>

c010290a <vector28>:
.globl vector28
vector28:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $28
c010290c:	6a 1c                	push   $0x1c
  jmp __alltraps
c010290e:	e9 e9 fe ff ff       	jmp    c01027fc <__alltraps>

c0102913 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $29
c0102915:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102917:	e9 e0 fe ff ff       	jmp    c01027fc <__alltraps>

c010291c <vector30>:
.globl vector30
vector30:
  pushl $0
c010291c:	6a 00                	push   $0x0
  pushl $30
c010291e:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102920:	e9 d7 fe ff ff       	jmp    c01027fc <__alltraps>

c0102925 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102925:	6a 00                	push   $0x0
  pushl $31
c0102927:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102929:	e9 ce fe ff ff       	jmp    c01027fc <__alltraps>

c010292e <vector32>:
.globl vector32
vector32:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $32
c0102930:	6a 20                	push   $0x20
  jmp __alltraps
c0102932:	e9 c5 fe ff ff       	jmp    c01027fc <__alltraps>

c0102937 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $33
c0102939:	6a 21                	push   $0x21
  jmp __alltraps
c010293b:	e9 bc fe ff ff       	jmp    c01027fc <__alltraps>

c0102940 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102940:	6a 00                	push   $0x0
  pushl $34
c0102942:	6a 22                	push   $0x22
  jmp __alltraps
c0102944:	e9 b3 fe ff ff       	jmp    c01027fc <__alltraps>

c0102949 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102949:	6a 00                	push   $0x0
  pushl $35
c010294b:	6a 23                	push   $0x23
  jmp __alltraps
c010294d:	e9 aa fe ff ff       	jmp    c01027fc <__alltraps>

c0102952 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $36
c0102954:	6a 24                	push   $0x24
  jmp __alltraps
c0102956:	e9 a1 fe ff ff       	jmp    c01027fc <__alltraps>

c010295b <vector37>:
.globl vector37
vector37:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $37
c010295d:	6a 25                	push   $0x25
  jmp __alltraps
c010295f:	e9 98 fe ff ff       	jmp    c01027fc <__alltraps>

c0102964 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102964:	6a 00                	push   $0x0
  pushl $38
c0102966:	6a 26                	push   $0x26
  jmp __alltraps
c0102968:	e9 8f fe ff ff       	jmp    c01027fc <__alltraps>

c010296d <vector39>:
.globl vector39
vector39:
  pushl $0
c010296d:	6a 00                	push   $0x0
  pushl $39
c010296f:	6a 27                	push   $0x27
  jmp __alltraps
c0102971:	e9 86 fe ff ff       	jmp    c01027fc <__alltraps>

c0102976 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $40
c0102978:	6a 28                	push   $0x28
  jmp __alltraps
c010297a:	e9 7d fe ff ff       	jmp    c01027fc <__alltraps>

c010297f <vector41>:
.globl vector41
vector41:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $41
c0102981:	6a 29                	push   $0x29
  jmp __alltraps
c0102983:	e9 74 fe ff ff       	jmp    c01027fc <__alltraps>

c0102988 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102988:	6a 00                	push   $0x0
  pushl $42
c010298a:	6a 2a                	push   $0x2a
  jmp __alltraps
c010298c:	e9 6b fe ff ff       	jmp    c01027fc <__alltraps>

c0102991 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102991:	6a 00                	push   $0x0
  pushl $43
c0102993:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102995:	e9 62 fe ff ff       	jmp    c01027fc <__alltraps>

c010299a <vector44>:
.globl vector44
vector44:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $44
c010299c:	6a 2c                	push   $0x2c
  jmp __alltraps
c010299e:	e9 59 fe ff ff       	jmp    c01027fc <__alltraps>

c01029a3 <vector45>:
.globl vector45
vector45:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $45
c01029a5:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029a7:	e9 50 fe ff ff       	jmp    c01027fc <__alltraps>

c01029ac <vector46>:
.globl vector46
vector46:
  pushl $0
c01029ac:	6a 00                	push   $0x0
  pushl $46
c01029ae:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029b0:	e9 47 fe ff ff       	jmp    c01027fc <__alltraps>

c01029b5 <vector47>:
.globl vector47
vector47:
  pushl $0
c01029b5:	6a 00                	push   $0x0
  pushl $47
c01029b7:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029b9:	e9 3e fe ff ff       	jmp    c01027fc <__alltraps>

c01029be <vector48>:
.globl vector48
vector48:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $48
c01029c0:	6a 30                	push   $0x30
  jmp __alltraps
c01029c2:	e9 35 fe ff ff       	jmp    c01027fc <__alltraps>

c01029c7 <vector49>:
.globl vector49
vector49:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $49
c01029c9:	6a 31                	push   $0x31
  jmp __alltraps
c01029cb:	e9 2c fe ff ff       	jmp    c01027fc <__alltraps>

c01029d0 <vector50>:
.globl vector50
vector50:
  pushl $0
c01029d0:	6a 00                	push   $0x0
  pushl $50
c01029d2:	6a 32                	push   $0x32
  jmp __alltraps
c01029d4:	e9 23 fe ff ff       	jmp    c01027fc <__alltraps>

c01029d9 <vector51>:
.globl vector51
vector51:
  pushl $0
c01029d9:	6a 00                	push   $0x0
  pushl $51
c01029db:	6a 33                	push   $0x33
  jmp __alltraps
c01029dd:	e9 1a fe ff ff       	jmp    c01027fc <__alltraps>

c01029e2 <vector52>:
.globl vector52
vector52:
  pushl $0
c01029e2:	6a 00                	push   $0x0
  pushl $52
c01029e4:	6a 34                	push   $0x34
  jmp __alltraps
c01029e6:	e9 11 fe ff ff       	jmp    c01027fc <__alltraps>

c01029eb <vector53>:
.globl vector53
vector53:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $53
c01029ed:	6a 35                	push   $0x35
  jmp __alltraps
c01029ef:	e9 08 fe ff ff       	jmp    c01027fc <__alltraps>

c01029f4 <vector54>:
.globl vector54
vector54:
  pushl $0
c01029f4:	6a 00                	push   $0x0
  pushl $54
c01029f6:	6a 36                	push   $0x36
  jmp __alltraps
c01029f8:	e9 ff fd ff ff       	jmp    c01027fc <__alltraps>

c01029fd <vector55>:
.globl vector55
vector55:
  pushl $0
c01029fd:	6a 00                	push   $0x0
  pushl $55
c01029ff:	6a 37                	push   $0x37
  jmp __alltraps
c0102a01:	e9 f6 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a06 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a06:	6a 00                	push   $0x0
  pushl $56
c0102a08:	6a 38                	push   $0x38
  jmp __alltraps
c0102a0a:	e9 ed fd ff ff       	jmp    c01027fc <__alltraps>

c0102a0f <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a0f:	6a 00                	push   $0x0
  pushl $57
c0102a11:	6a 39                	push   $0x39
  jmp __alltraps
c0102a13:	e9 e4 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a18 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a18:	6a 00                	push   $0x0
  pushl $58
c0102a1a:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a1c:	e9 db fd ff ff       	jmp    c01027fc <__alltraps>

c0102a21 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a21:	6a 00                	push   $0x0
  pushl $59
c0102a23:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a25:	e9 d2 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a2a <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a2a:	6a 00                	push   $0x0
  pushl $60
c0102a2c:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a2e:	e9 c9 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a33 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a33:	6a 00                	push   $0x0
  pushl $61
c0102a35:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a37:	e9 c0 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a3c <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a3c:	6a 00                	push   $0x0
  pushl $62
c0102a3e:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a40:	e9 b7 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a45 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a45:	6a 00                	push   $0x0
  pushl $63
c0102a47:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a49:	e9 ae fd ff ff       	jmp    c01027fc <__alltraps>

c0102a4e <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a4e:	6a 00                	push   $0x0
  pushl $64
c0102a50:	6a 40                	push   $0x40
  jmp __alltraps
c0102a52:	e9 a5 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a57 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a57:	6a 00                	push   $0x0
  pushl $65
c0102a59:	6a 41                	push   $0x41
  jmp __alltraps
c0102a5b:	e9 9c fd ff ff       	jmp    c01027fc <__alltraps>

c0102a60 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a60:	6a 00                	push   $0x0
  pushl $66
c0102a62:	6a 42                	push   $0x42
  jmp __alltraps
c0102a64:	e9 93 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a69 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a69:	6a 00                	push   $0x0
  pushl $67
c0102a6b:	6a 43                	push   $0x43
  jmp __alltraps
c0102a6d:	e9 8a fd ff ff       	jmp    c01027fc <__alltraps>

c0102a72 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a72:	6a 00                	push   $0x0
  pushl $68
c0102a74:	6a 44                	push   $0x44
  jmp __alltraps
c0102a76:	e9 81 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a7b <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a7b:	6a 00                	push   $0x0
  pushl $69
c0102a7d:	6a 45                	push   $0x45
  jmp __alltraps
c0102a7f:	e9 78 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a84 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a84:	6a 00                	push   $0x0
  pushl $70
c0102a86:	6a 46                	push   $0x46
  jmp __alltraps
c0102a88:	e9 6f fd ff ff       	jmp    c01027fc <__alltraps>

c0102a8d <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a8d:	6a 00                	push   $0x0
  pushl $71
c0102a8f:	6a 47                	push   $0x47
  jmp __alltraps
c0102a91:	e9 66 fd ff ff       	jmp    c01027fc <__alltraps>

c0102a96 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a96:	6a 00                	push   $0x0
  pushl $72
c0102a98:	6a 48                	push   $0x48
  jmp __alltraps
c0102a9a:	e9 5d fd ff ff       	jmp    c01027fc <__alltraps>

c0102a9f <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a9f:	6a 00                	push   $0x0
  pushl $73
c0102aa1:	6a 49                	push   $0x49
  jmp __alltraps
c0102aa3:	e9 54 fd ff ff       	jmp    c01027fc <__alltraps>

c0102aa8 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102aa8:	6a 00                	push   $0x0
  pushl $74
c0102aaa:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102aac:	e9 4b fd ff ff       	jmp    c01027fc <__alltraps>

c0102ab1 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ab1:	6a 00                	push   $0x0
  pushl $75
c0102ab3:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ab5:	e9 42 fd ff ff       	jmp    c01027fc <__alltraps>

c0102aba <vector76>:
.globl vector76
vector76:
  pushl $0
c0102aba:	6a 00                	push   $0x0
  pushl $76
c0102abc:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102abe:	e9 39 fd ff ff       	jmp    c01027fc <__alltraps>

c0102ac3 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102ac3:	6a 00                	push   $0x0
  pushl $77
c0102ac5:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102ac7:	e9 30 fd ff ff       	jmp    c01027fc <__alltraps>

c0102acc <vector78>:
.globl vector78
vector78:
  pushl $0
c0102acc:	6a 00                	push   $0x0
  pushl $78
c0102ace:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102ad0:	e9 27 fd ff ff       	jmp    c01027fc <__alltraps>

c0102ad5 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102ad5:	6a 00                	push   $0x0
  pushl $79
c0102ad7:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102ad9:	e9 1e fd ff ff       	jmp    c01027fc <__alltraps>

c0102ade <vector80>:
.globl vector80
vector80:
  pushl $0
c0102ade:	6a 00                	push   $0x0
  pushl $80
c0102ae0:	6a 50                	push   $0x50
  jmp __alltraps
c0102ae2:	e9 15 fd ff ff       	jmp    c01027fc <__alltraps>

c0102ae7 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102ae7:	6a 00                	push   $0x0
  pushl $81
c0102ae9:	6a 51                	push   $0x51
  jmp __alltraps
c0102aeb:	e9 0c fd ff ff       	jmp    c01027fc <__alltraps>

c0102af0 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102af0:	6a 00                	push   $0x0
  pushl $82
c0102af2:	6a 52                	push   $0x52
  jmp __alltraps
c0102af4:	e9 03 fd ff ff       	jmp    c01027fc <__alltraps>

c0102af9 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102af9:	6a 00                	push   $0x0
  pushl $83
c0102afb:	6a 53                	push   $0x53
  jmp __alltraps
c0102afd:	e9 fa fc ff ff       	jmp    c01027fc <__alltraps>

c0102b02 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b02:	6a 00                	push   $0x0
  pushl $84
c0102b04:	6a 54                	push   $0x54
  jmp __alltraps
c0102b06:	e9 f1 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b0b <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b0b:	6a 00                	push   $0x0
  pushl $85
c0102b0d:	6a 55                	push   $0x55
  jmp __alltraps
c0102b0f:	e9 e8 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b14 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b14:	6a 00                	push   $0x0
  pushl $86
c0102b16:	6a 56                	push   $0x56
  jmp __alltraps
c0102b18:	e9 df fc ff ff       	jmp    c01027fc <__alltraps>

c0102b1d <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b1d:	6a 00                	push   $0x0
  pushl $87
c0102b1f:	6a 57                	push   $0x57
  jmp __alltraps
c0102b21:	e9 d6 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b26 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b26:	6a 00                	push   $0x0
  pushl $88
c0102b28:	6a 58                	push   $0x58
  jmp __alltraps
c0102b2a:	e9 cd fc ff ff       	jmp    c01027fc <__alltraps>

c0102b2f <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b2f:	6a 00                	push   $0x0
  pushl $89
c0102b31:	6a 59                	push   $0x59
  jmp __alltraps
c0102b33:	e9 c4 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b38 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b38:	6a 00                	push   $0x0
  pushl $90
c0102b3a:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b3c:	e9 bb fc ff ff       	jmp    c01027fc <__alltraps>

c0102b41 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b41:	6a 00                	push   $0x0
  pushl $91
c0102b43:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b45:	e9 b2 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b4a <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b4a:	6a 00                	push   $0x0
  pushl $92
c0102b4c:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b4e:	e9 a9 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b53 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b53:	6a 00                	push   $0x0
  pushl $93
c0102b55:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b57:	e9 a0 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b5c <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b5c:	6a 00                	push   $0x0
  pushl $94
c0102b5e:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b60:	e9 97 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b65 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b65:	6a 00                	push   $0x0
  pushl $95
c0102b67:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b69:	e9 8e fc ff ff       	jmp    c01027fc <__alltraps>

c0102b6e <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b6e:	6a 00                	push   $0x0
  pushl $96
c0102b70:	6a 60                	push   $0x60
  jmp __alltraps
c0102b72:	e9 85 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b77 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b77:	6a 00                	push   $0x0
  pushl $97
c0102b79:	6a 61                	push   $0x61
  jmp __alltraps
c0102b7b:	e9 7c fc ff ff       	jmp    c01027fc <__alltraps>

c0102b80 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b80:	6a 00                	push   $0x0
  pushl $98
c0102b82:	6a 62                	push   $0x62
  jmp __alltraps
c0102b84:	e9 73 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b89 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b89:	6a 00                	push   $0x0
  pushl $99
c0102b8b:	6a 63                	push   $0x63
  jmp __alltraps
c0102b8d:	e9 6a fc ff ff       	jmp    c01027fc <__alltraps>

c0102b92 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b92:	6a 00                	push   $0x0
  pushl $100
c0102b94:	6a 64                	push   $0x64
  jmp __alltraps
c0102b96:	e9 61 fc ff ff       	jmp    c01027fc <__alltraps>

c0102b9b <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b9b:	6a 00                	push   $0x0
  pushl $101
c0102b9d:	6a 65                	push   $0x65
  jmp __alltraps
c0102b9f:	e9 58 fc ff ff       	jmp    c01027fc <__alltraps>

c0102ba4 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ba4:	6a 00                	push   $0x0
  pushl $102
c0102ba6:	6a 66                	push   $0x66
  jmp __alltraps
c0102ba8:	e9 4f fc ff ff       	jmp    c01027fc <__alltraps>

c0102bad <vector103>:
.globl vector103
vector103:
  pushl $0
c0102bad:	6a 00                	push   $0x0
  pushl $103
c0102baf:	6a 67                	push   $0x67
  jmp __alltraps
c0102bb1:	e9 46 fc ff ff       	jmp    c01027fc <__alltraps>

c0102bb6 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102bb6:	6a 00                	push   $0x0
  pushl $104
c0102bb8:	6a 68                	push   $0x68
  jmp __alltraps
c0102bba:	e9 3d fc ff ff       	jmp    c01027fc <__alltraps>

c0102bbf <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bbf:	6a 00                	push   $0x0
  pushl $105
c0102bc1:	6a 69                	push   $0x69
  jmp __alltraps
c0102bc3:	e9 34 fc ff ff       	jmp    c01027fc <__alltraps>

c0102bc8 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102bc8:	6a 00                	push   $0x0
  pushl $106
c0102bca:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102bcc:	e9 2b fc ff ff       	jmp    c01027fc <__alltraps>

c0102bd1 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102bd1:	6a 00                	push   $0x0
  pushl $107
c0102bd3:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102bd5:	e9 22 fc ff ff       	jmp    c01027fc <__alltraps>

c0102bda <vector108>:
.globl vector108
vector108:
  pushl $0
c0102bda:	6a 00                	push   $0x0
  pushl $108
c0102bdc:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bde:	e9 19 fc ff ff       	jmp    c01027fc <__alltraps>

c0102be3 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102be3:	6a 00                	push   $0x0
  pushl $109
c0102be5:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102be7:	e9 10 fc ff ff       	jmp    c01027fc <__alltraps>

c0102bec <vector110>:
.globl vector110
vector110:
  pushl $0
c0102bec:	6a 00                	push   $0x0
  pushl $110
c0102bee:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102bf0:	e9 07 fc ff ff       	jmp    c01027fc <__alltraps>

c0102bf5 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102bf5:	6a 00                	push   $0x0
  pushl $111
c0102bf7:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102bf9:	e9 fe fb ff ff       	jmp    c01027fc <__alltraps>

c0102bfe <vector112>:
.globl vector112
vector112:
  pushl $0
c0102bfe:	6a 00                	push   $0x0
  pushl $112
c0102c00:	6a 70                	push   $0x70
  jmp __alltraps
c0102c02:	e9 f5 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c07 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c07:	6a 00                	push   $0x0
  pushl $113
c0102c09:	6a 71                	push   $0x71
  jmp __alltraps
c0102c0b:	e9 ec fb ff ff       	jmp    c01027fc <__alltraps>

c0102c10 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $114
c0102c12:	6a 72                	push   $0x72
  jmp __alltraps
c0102c14:	e9 e3 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c19 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c19:	6a 00                	push   $0x0
  pushl $115
c0102c1b:	6a 73                	push   $0x73
  jmp __alltraps
c0102c1d:	e9 da fb ff ff       	jmp    c01027fc <__alltraps>

c0102c22 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c22:	6a 00                	push   $0x0
  pushl $116
c0102c24:	6a 74                	push   $0x74
  jmp __alltraps
c0102c26:	e9 d1 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c2b <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c2b:	6a 00                	push   $0x0
  pushl $117
c0102c2d:	6a 75                	push   $0x75
  jmp __alltraps
c0102c2f:	e9 c8 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c34 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $118
c0102c36:	6a 76                	push   $0x76
  jmp __alltraps
c0102c38:	e9 bf fb ff ff       	jmp    c01027fc <__alltraps>

c0102c3d <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c3d:	6a 00                	push   $0x0
  pushl $119
c0102c3f:	6a 77                	push   $0x77
  jmp __alltraps
c0102c41:	e9 b6 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c46 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c46:	6a 00                	push   $0x0
  pushl $120
c0102c48:	6a 78                	push   $0x78
  jmp __alltraps
c0102c4a:	e9 ad fb ff ff       	jmp    c01027fc <__alltraps>

c0102c4f <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c4f:	6a 00                	push   $0x0
  pushl $121
c0102c51:	6a 79                	push   $0x79
  jmp __alltraps
c0102c53:	e9 a4 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c58 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $122
c0102c5a:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c5c:	e9 9b fb ff ff       	jmp    c01027fc <__alltraps>

c0102c61 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c61:	6a 00                	push   $0x0
  pushl $123
c0102c63:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c65:	e9 92 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c6a <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c6a:	6a 00                	push   $0x0
  pushl $124
c0102c6c:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c6e:	e9 89 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c73 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c73:	6a 00                	push   $0x0
  pushl $125
c0102c75:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c77:	e9 80 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c7c <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $126
c0102c7e:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c80:	e9 77 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c85 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c85:	6a 00                	push   $0x0
  pushl $127
c0102c87:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c89:	e9 6e fb ff ff       	jmp    c01027fc <__alltraps>

c0102c8e <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c8e:	6a 00                	push   $0x0
  pushl $128
c0102c90:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c95:	e9 62 fb ff ff       	jmp    c01027fc <__alltraps>

c0102c9a <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c9a:	6a 00                	push   $0x0
  pushl $129
c0102c9c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102ca1:	e9 56 fb ff ff       	jmp    c01027fc <__alltraps>

c0102ca6 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102ca6:	6a 00                	push   $0x0
  pushl $130
c0102ca8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102cad:	e9 4a fb ff ff       	jmp    c01027fc <__alltraps>

c0102cb2 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102cb2:	6a 00                	push   $0x0
  pushl $131
c0102cb4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102cb9:	e9 3e fb ff ff       	jmp    c01027fc <__alltraps>

c0102cbe <vector132>:
.globl vector132
vector132:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $132
c0102cc0:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cc5:	e9 32 fb ff ff       	jmp    c01027fc <__alltraps>

c0102cca <vector133>:
.globl vector133
vector133:
  pushl $0
c0102cca:	6a 00                	push   $0x0
  pushl $133
c0102ccc:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102cd1:	e9 26 fb ff ff       	jmp    c01027fc <__alltraps>

c0102cd6 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102cd6:	6a 00                	push   $0x0
  pushl $134
c0102cd8:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102cdd:	e9 1a fb ff ff       	jmp    c01027fc <__alltraps>

c0102ce2 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102ce2:	6a 00                	push   $0x0
  pushl $135
c0102ce4:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102ce9:	e9 0e fb ff ff       	jmp    c01027fc <__alltraps>

c0102cee <vector136>:
.globl vector136
vector136:
  pushl $0
c0102cee:	6a 00                	push   $0x0
  pushl $136
c0102cf0:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102cf5:	e9 02 fb ff ff       	jmp    c01027fc <__alltraps>

c0102cfa <vector137>:
.globl vector137
vector137:
  pushl $0
c0102cfa:	6a 00                	push   $0x0
  pushl $137
c0102cfc:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d01:	e9 f6 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d06 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d06:	6a 00                	push   $0x0
  pushl $138
c0102d08:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d0d:	e9 ea fa ff ff       	jmp    c01027fc <__alltraps>

c0102d12 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d12:	6a 00                	push   $0x0
  pushl $139
c0102d14:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d19:	e9 de fa ff ff       	jmp    c01027fc <__alltraps>

c0102d1e <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d1e:	6a 00                	push   $0x0
  pushl $140
c0102d20:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d25:	e9 d2 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d2a <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d2a:	6a 00                	push   $0x0
  pushl $141
c0102d2c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d31:	e9 c6 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d36 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d36:	6a 00                	push   $0x0
  pushl $142
c0102d38:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d3d:	e9 ba fa ff ff       	jmp    c01027fc <__alltraps>

c0102d42 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d42:	6a 00                	push   $0x0
  pushl $143
c0102d44:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d49:	e9 ae fa ff ff       	jmp    c01027fc <__alltraps>

c0102d4e <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d4e:	6a 00                	push   $0x0
  pushl $144
c0102d50:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d55:	e9 a2 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d5a <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d5a:	6a 00                	push   $0x0
  pushl $145
c0102d5c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d61:	e9 96 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d66 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d66:	6a 00                	push   $0x0
  pushl $146
c0102d68:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d6d:	e9 8a fa ff ff       	jmp    c01027fc <__alltraps>

c0102d72 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d72:	6a 00                	push   $0x0
  pushl $147
c0102d74:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d79:	e9 7e fa ff ff       	jmp    c01027fc <__alltraps>

c0102d7e <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d7e:	6a 00                	push   $0x0
  pushl $148
c0102d80:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d85:	e9 72 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d8a <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d8a:	6a 00                	push   $0x0
  pushl $149
c0102d8c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d91:	e9 66 fa ff ff       	jmp    c01027fc <__alltraps>

c0102d96 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d96:	6a 00                	push   $0x0
  pushl $150
c0102d98:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d9d:	e9 5a fa ff ff       	jmp    c01027fc <__alltraps>

c0102da2 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102da2:	6a 00                	push   $0x0
  pushl $151
c0102da4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102da9:	e9 4e fa ff ff       	jmp    c01027fc <__alltraps>

c0102dae <vector152>:
.globl vector152
vector152:
  pushl $0
c0102dae:	6a 00                	push   $0x0
  pushl $152
c0102db0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102db5:	e9 42 fa ff ff       	jmp    c01027fc <__alltraps>

c0102dba <vector153>:
.globl vector153
vector153:
  pushl $0
c0102dba:	6a 00                	push   $0x0
  pushl $153
c0102dbc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102dc1:	e9 36 fa ff ff       	jmp    c01027fc <__alltraps>

c0102dc6 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dc6:	6a 00                	push   $0x0
  pushl $154
c0102dc8:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102dcd:	e9 2a fa ff ff       	jmp    c01027fc <__alltraps>

c0102dd2 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102dd2:	6a 00                	push   $0x0
  pushl $155
c0102dd4:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102dd9:	e9 1e fa ff ff       	jmp    c01027fc <__alltraps>

c0102dde <vector156>:
.globl vector156
vector156:
  pushl $0
c0102dde:	6a 00                	push   $0x0
  pushl $156
c0102de0:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102de5:	e9 12 fa ff ff       	jmp    c01027fc <__alltraps>

c0102dea <vector157>:
.globl vector157
vector157:
  pushl $0
c0102dea:	6a 00                	push   $0x0
  pushl $157
c0102dec:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102df1:	e9 06 fa ff ff       	jmp    c01027fc <__alltraps>

c0102df6 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102df6:	6a 00                	push   $0x0
  pushl $158
c0102df8:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102dfd:	e9 fa f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e02 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e02:	6a 00                	push   $0x0
  pushl $159
c0102e04:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e09:	e9 ee f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e0e <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e0e:	6a 00                	push   $0x0
  pushl $160
c0102e10:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e15:	e9 e2 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e1a <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e1a:	6a 00                	push   $0x0
  pushl $161
c0102e1c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e21:	e9 d6 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e26 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e26:	6a 00                	push   $0x0
  pushl $162
c0102e28:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e2d:	e9 ca f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e32 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e32:	6a 00                	push   $0x0
  pushl $163
c0102e34:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e39:	e9 be f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e3e <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e3e:	6a 00                	push   $0x0
  pushl $164
c0102e40:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e45:	e9 b2 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e4a <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e4a:	6a 00                	push   $0x0
  pushl $165
c0102e4c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e51:	e9 a6 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e56 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e56:	6a 00                	push   $0x0
  pushl $166
c0102e58:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e5d:	e9 9a f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e62 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e62:	6a 00                	push   $0x0
  pushl $167
c0102e64:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e69:	e9 8e f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e6e <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e6e:	6a 00                	push   $0x0
  pushl $168
c0102e70:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e75:	e9 82 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e7a <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e7a:	6a 00                	push   $0x0
  pushl $169
c0102e7c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e81:	e9 76 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e86 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e86:	6a 00                	push   $0x0
  pushl $170
c0102e88:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e8d:	e9 6a f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e92 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e92:	6a 00                	push   $0x0
  pushl $171
c0102e94:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e99:	e9 5e f9 ff ff       	jmp    c01027fc <__alltraps>

c0102e9e <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e9e:	6a 00                	push   $0x0
  pushl $172
c0102ea0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102ea5:	e9 52 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102eaa <vector173>:
.globl vector173
vector173:
  pushl $0
c0102eaa:	6a 00                	push   $0x0
  pushl $173
c0102eac:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102eb1:	e9 46 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102eb6 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102eb6:	6a 00                	push   $0x0
  pushl $174
c0102eb8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102ebd:	e9 3a f9 ff ff       	jmp    c01027fc <__alltraps>

c0102ec2 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102ec2:	6a 00                	push   $0x0
  pushl $175
c0102ec4:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102ec9:	e9 2e f9 ff ff       	jmp    c01027fc <__alltraps>

c0102ece <vector176>:
.globl vector176
vector176:
  pushl $0
c0102ece:	6a 00                	push   $0x0
  pushl $176
c0102ed0:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102ed5:	e9 22 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102eda <vector177>:
.globl vector177
vector177:
  pushl $0
c0102eda:	6a 00                	push   $0x0
  pushl $177
c0102edc:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102ee1:	e9 16 f9 ff ff       	jmp    c01027fc <__alltraps>

c0102ee6 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102ee6:	6a 00                	push   $0x0
  pushl $178
c0102ee8:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102eed:	e9 0a f9 ff ff       	jmp    c01027fc <__alltraps>

c0102ef2 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102ef2:	6a 00                	push   $0x0
  pushl $179
c0102ef4:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102ef9:	e9 fe f8 ff ff       	jmp    c01027fc <__alltraps>

c0102efe <vector180>:
.globl vector180
vector180:
  pushl $0
c0102efe:	6a 00                	push   $0x0
  pushl $180
c0102f00:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f05:	e9 f2 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f0a <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f0a:	6a 00                	push   $0x0
  pushl $181
c0102f0c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f11:	e9 e6 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f16 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f16:	6a 00                	push   $0x0
  pushl $182
c0102f18:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f1d:	e9 da f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f22 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f22:	6a 00                	push   $0x0
  pushl $183
c0102f24:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f29:	e9 ce f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f2e <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f2e:	6a 00                	push   $0x0
  pushl $184
c0102f30:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f35:	e9 c2 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f3a <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f3a:	6a 00                	push   $0x0
  pushl $185
c0102f3c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f41:	e9 b6 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f46 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f46:	6a 00                	push   $0x0
  pushl $186
c0102f48:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f4d:	e9 aa f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f52 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f52:	6a 00                	push   $0x0
  pushl $187
c0102f54:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f59:	e9 9e f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f5e <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f5e:	6a 00                	push   $0x0
  pushl $188
c0102f60:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f65:	e9 92 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f6a <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f6a:	6a 00                	push   $0x0
  pushl $189
c0102f6c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f71:	e9 86 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f76 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f76:	6a 00                	push   $0x0
  pushl $190
c0102f78:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f7d:	e9 7a f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f82 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f82:	6a 00                	push   $0x0
  pushl $191
c0102f84:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f89:	e9 6e f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f8e <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f8e:	6a 00                	push   $0x0
  pushl $192
c0102f90:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f95:	e9 62 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102f9a <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f9a:	6a 00                	push   $0x0
  pushl $193
c0102f9c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102fa1:	e9 56 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fa6 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fa6:	6a 00                	push   $0x0
  pushl $194
c0102fa8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fad:	e9 4a f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fb2 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102fb2:	6a 00                	push   $0x0
  pushl $195
c0102fb4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102fb9:	e9 3e f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fbe <vector196>:
.globl vector196
vector196:
  pushl $0
c0102fbe:	6a 00                	push   $0x0
  pushl $196
c0102fc0:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102fc5:	e9 32 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fca <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fca:	6a 00                	push   $0x0
  pushl $197
c0102fcc:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102fd1:	e9 26 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fd6 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fd6:	6a 00                	push   $0x0
  pushl $198
c0102fd8:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102fdd:	e9 1a f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fe2 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102fe2:	6a 00                	push   $0x0
  pushl $199
c0102fe4:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102fe9:	e9 0e f8 ff ff       	jmp    c01027fc <__alltraps>

c0102fee <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fee:	6a 00                	push   $0x0
  pushl $200
c0102ff0:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102ff5:	e9 02 f8 ff ff       	jmp    c01027fc <__alltraps>

c0102ffa <vector201>:
.globl vector201
vector201:
  pushl $0
c0102ffa:	6a 00                	push   $0x0
  pushl $201
c0102ffc:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103001:	e9 f6 f7 ff ff       	jmp    c01027fc <__alltraps>

c0103006 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103006:	6a 00                	push   $0x0
  pushl $202
c0103008:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010300d:	e9 ea f7 ff ff       	jmp    c01027fc <__alltraps>

c0103012 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103012:	6a 00                	push   $0x0
  pushl $203
c0103014:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103019:	e9 de f7 ff ff       	jmp    c01027fc <__alltraps>

c010301e <vector204>:
.globl vector204
vector204:
  pushl $0
c010301e:	6a 00                	push   $0x0
  pushl $204
c0103020:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103025:	e9 d2 f7 ff ff       	jmp    c01027fc <__alltraps>

c010302a <vector205>:
.globl vector205
vector205:
  pushl $0
c010302a:	6a 00                	push   $0x0
  pushl $205
c010302c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103031:	e9 c6 f7 ff ff       	jmp    c01027fc <__alltraps>

c0103036 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103036:	6a 00                	push   $0x0
  pushl $206
c0103038:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010303d:	e9 ba f7 ff ff       	jmp    c01027fc <__alltraps>

c0103042 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103042:	6a 00                	push   $0x0
  pushl $207
c0103044:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103049:	e9 ae f7 ff ff       	jmp    c01027fc <__alltraps>

c010304e <vector208>:
.globl vector208
vector208:
  pushl $0
c010304e:	6a 00                	push   $0x0
  pushl $208
c0103050:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103055:	e9 a2 f7 ff ff       	jmp    c01027fc <__alltraps>

c010305a <vector209>:
.globl vector209
vector209:
  pushl $0
c010305a:	6a 00                	push   $0x0
  pushl $209
c010305c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103061:	e9 96 f7 ff ff       	jmp    c01027fc <__alltraps>

c0103066 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103066:	6a 00                	push   $0x0
  pushl $210
c0103068:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010306d:	e9 8a f7 ff ff       	jmp    c01027fc <__alltraps>

c0103072 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103072:	6a 00                	push   $0x0
  pushl $211
c0103074:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103079:	e9 7e f7 ff ff       	jmp    c01027fc <__alltraps>

c010307e <vector212>:
.globl vector212
vector212:
  pushl $0
c010307e:	6a 00                	push   $0x0
  pushl $212
c0103080:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103085:	e9 72 f7 ff ff       	jmp    c01027fc <__alltraps>

c010308a <vector213>:
.globl vector213
vector213:
  pushl $0
c010308a:	6a 00                	push   $0x0
  pushl $213
c010308c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103091:	e9 66 f7 ff ff       	jmp    c01027fc <__alltraps>

c0103096 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103096:	6a 00                	push   $0x0
  pushl $214
c0103098:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010309d:	e9 5a f7 ff ff       	jmp    c01027fc <__alltraps>

c01030a2 <vector215>:
.globl vector215
vector215:
  pushl $0
c01030a2:	6a 00                	push   $0x0
  pushl $215
c01030a4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030a9:	e9 4e f7 ff ff       	jmp    c01027fc <__alltraps>

c01030ae <vector216>:
.globl vector216
vector216:
  pushl $0
c01030ae:	6a 00                	push   $0x0
  pushl $216
c01030b0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030b5:	e9 42 f7 ff ff       	jmp    c01027fc <__alltraps>

c01030ba <vector217>:
.globl vector217
vector217:
  pushl $0
c01030ba:	6a 00                	push   $0x0
  pushl $217
c01030bc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030c1:	e9 36 f7 ff ff       	jmp    c01027fc <__alltraps>

c01030c6 <vector218>:
.globl vector218
vector218:
  pushl $0
c01030c6:	6a 00                	push   $0x0
  pushl $218
c01030c8:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01030cd:	e9 2a f7 ff ff       	jmp    c01027fc <__alltraps>

c01030d2 <vector219>:
.globl vector219
vector219:
  pushl $0
c01030d2:	6a 00                	push   $0x0
  pushl $219
c01030d4:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030d9:	e9 1e f7 ff ff       	jmp    c01027fc <__alltraps>

c01030de <vector220>:
.globl vector220
vector220:
  pushl $0
c01030de:	6a 00                	push   $0x0
  pushl $220
c01030e0:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030e5:	e9 12 f7 ff ff       	jmp    c01027fc <__alltraps>

c01030ea <vector221>:
.globl vector221
vector221:
  pushl $0
c01030ea:	6a 00                	push   $0x0
  pushl $221
c01030ec:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01030f1:	e9 06 f7 ff ff       	jmp    c01027fc <__alltraps>

c01030f6 <vector222>:
.globl vector222
vector222:
  pushl $0
c01030f6:	6a 00                	push   $0x0
  pushl $222
c01030f8:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01030fd:	e9 fa f6 ff ff       	jmp    c01027fc <__alltraps>

c0103102 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103102:	6a 00                	push   $0x0
  pushl $223
c0103104:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103109:	e9 ee f6 ff ff       	jmp    c01027fc <__alltraps>

c010310e <vector224>:
.globl vector224
vector224:
  pushl $0
c010310e:	6a 00                	push   $0x0
  pushl $224
c0103110:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103115:	e9 e2 f6 ff ff       	jmp    c01027fc <__alltraps>

c010311a <vector225>:
.globl vector225
vector225:
  pushl $0
c010311a:	6a 00                	push   $0x0
  pushl $225
c010311c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103121:	e9 d6 f6 ff ff       	jmp    c01027fc <__alltraps>

c0103126 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103126:	6a 00                	push   $0x0
  pushl $226
c0103128:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010312d:	e9 ca f6 ff ff       	jmp    c01027fc <__alltraps>

c0103132 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103132:	6a 00                	push   $0x0
  pushl $227
c0103134:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103139:	e9 be f6 ff ff       	jmp    c01027fc <__alltraps>

c010313e <vector228>:
.globl vector228
vector228:
  pushl $0
c010313e:	6a 00                	push   $0x0
  pushl $228
c0103140:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103145:	e9 b2 f6 ff ff       	jmp    c01027fc <__alltraps>

c010314a <vector229>:
.globl vector229
vector229:
  pushl $0
c010314a:	6a 00                	push   $0x0
  pushl $229
c010314c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103151:	e9 a6 f6 ff ff       	jmp    c01027fc <__alltraps>

c0103156 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103156:	6a 00                	push   $0x0
  pushl $230
c0103158:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010315d:	e9 9a f6 ff ff       	jmp    c01027fc <__alltraps>

c0103162 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103162:	6a 00                	push   $0x0
  pushl $231
c0103164:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103169:	e9 8e f6 ff ff       	jmp    c01027fc <__alltraps>

c010316e <vector232>:
.globl vector232
vector232:
  pushl $0
c010316e:	6a 00                	push   $0x0
  pushl $232
c0103170:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103175:	e9 82 f6 ff ff       	jmp    c01027fc <__alltraps>

c010317a <vector233>:
.globl vector233
vector233:
  pushl $0
c010317a:	6a 00                	push   $0x0
  pushl $233
c010317c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103181:	e9 76 f6 ff ff       	jmp    c01027fc <__alltraps>

c0103186 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103186:	6a 00                	push   $0x0
  pushl $234
c0103188:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010318d:	e9 6a f6 ff ff       	jmp    c01027fc <__alltraps>

c0103192 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103192:	6a 00                	push   $0x0
  pushl $235
c0103194:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103199:	e9 5e f6 ff ff       	jmp    c01027fc <__alltraps>

c010319e <vector236>:
.globl vector236
vector236:
  pushl $0
c010319e:	6a 00                	push   $0x0
  pushl $236
c01031a0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031a5:	e9 52 f6 ff ff       	jmp    c01027fc <__alltraps>

c01031aa <vector237>:
.globl vector237
vector237:
  pushl $0
c01031aa:	6a 00                	push   $0x0
  pushl $237
c01031ac:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031b1:	e9 46 f6 ff ff       	jmp    c01027fc <__alltraps>

c01031b6 <vector238>:
.globl vector238
vector238:
  pushl $0
c01031b6:	6a 00                	push   $0x0
  pushl $238
c01031b8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031bd:	e9 3a f6 ff ff       	jmp    c01027fc <__alltraps>

c01031c2 <vector239>:
.globl vector239
vector239:
  pushl $0
c01031c2:	6a 00                	push   $0x0
  pushl $239
c01031c4:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031c9:	e9 2e f6 ff ff       	jmp    c01027fc <__alltraps>

c01031ce <vector240>:
.globl vector240
vector240:
  pushl $0
c01031ce:	6a 00                	push   $0x0
  pushl $240
c01031d0:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031d5:	e9 22 f6 ff ff       	jmp    c01027fc <__alltraps>

c01031da <vector241>:
.globl vector241
vector241:
  pushl $0
c01031da:	6a 00                	push   $0x0
  pushl $241
c01031dc:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031e1:	e9 16 f6 ff ff       	jmp    c01027fc <__alltraps>

c01031e6 <vector242>:
.globl vector242
vector242:
  pushl $0
c01031e6:	6a 00                	push   $0x0
  pushl $242
c01031e8:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031ed:	e9 0a f6 ff ff       	jmp    c01027fc <__alltraps>

c01031f2 <vector243>:
.globl vector243
vector243:
  pushl $0
c01031f2:	6a 00                	push   $0x0
  pushl $243
c01031f4:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01031f9:	e9 fe f5 ff ff       	jmp    c01027fc <__alltraps>

c01031fe <vector244>:
.globl vector244
vector244:
  pushl $0
c01031fe:	6a 00                	push   $0x0
  pushl $244
c0103200:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103205:	e9 f2 f5 ff ff       	jmp    c01027fc <__alltraps>

c010320a <vector245>:
.globl vector245
vector245:
  pushl $0
c010320a:	6a 00                	push   $0x0
  pushl $245
c010320c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103211:	e9 e6 f5 ff ff       	jmp    c01027fc <__alltraps>

c0103216 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103216:	6a 00                	push   $0x0
  pushl $246
c0103218:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010321d:	e9 da f5 ff ff       	jmp    c01027fc <__alltraps>

c0103222 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103222:	6a 00                	push   $0x0
  pushl $247
c0103224:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103229:	e9 ce f5 ff ff       	jmp    c01027fc <__alltraps>

c010322e <vector248>:
.globl vector248
vector248:
  pushl $0
c010322e:	6a 00                	push   $0x0
  pushl $248
c0103230:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103235:	e9 c2 f5 ff ff       	jmp    c01027fc <__alltraps>

c010323a <vector249>:
.globl vector249
vector249:
  pushl $0
c010323a:	6a 00                	push   $0x0
  pushl $249
c010323c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103241:	e9 b6 f5 ff ff       	jmp    c01027fc <__alltraps>

c0103246 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103246:	6a 00                	push   $0x0
  pushl $250
c0103248:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010324d:	e9 aa f5 ff ff       	jmp    c01027fc <__alltraps>

c0103252 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103252:	6a 00                	push   $0x0
  pushl $251
c0103254:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103259:	e9 9e f5 ff ff       	jmp    c01027fc <__alltraps>

c010325e <vector252>:
.globl vector252
vector252:
  pushl $0
c010325e:	6a 00                	push   $0x0
  pushl $252
c0103260:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103265:	e9 92 f5 ff ff       	jmp    c01027fc <__alltraps>

c010326a <vector253>:
.globl vector253
vector253:
  pushl $0
c010326a:	6a 00                	push   $0x0
  pushl $253
c010326c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103271:	e9 86 f5 ff ff       	jmp    c01027fc <__alltraps>

c0103276 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103276:	6a 00                	push   $0x0
  pushl $254
c0103278:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010327d:	e9 7a f5 ff ff       	jmp    c01027fc <__alltraps>

c0103282 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103282:	6a 00                	push   $0x0
  pushl $255
c0103284:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103289:	e9 6e f5 ff ff       	jmp    c01027fc <__alltraps>

c010328e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010328e:	55                   	push   %ebp
c010328f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103291:	8b 55 08             	mov    0x8(%ebp),%edx
c0103294:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0103299:	29 c2                	sub    %eax,%edx
c010329b:	89 d0                	mov    %edx,%eax
c010329d:	c1 f8 05             	sar    $0x5,%eax
}
c01032a0:	5d                   	pop    %ebp
c01032a1:	c3                   	ret    

c01032a2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01032a2:	55                   	push   %ebp
c01032a3:	89 e5                	mov    %esp,%ebp
c01032a5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01032a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01032ab:	89 04 24             	mov    %eax,(%esp)
c01032ae:	e8 db ff ff ff       	call   c010328e <page2ppn>
c01032b3:	c1 e0 0c             	shl    $0xc,%eax
}
c01032b6:	c9                   	leave  
c01032b7:	c3                   	ret    

c01032b8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01032b8:	55                   	push   %ebp
c01032b9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01032bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01032be:	8b 00                	mov    (%eax),%eax
}
c01032c0:	5d                   	pop    %ebp
c01032c1:	c3                   	ret    

c01032c2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01032c2:	55                   	push   %ebp
c01032c3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01032c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01032c8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032cb:	89 10                	mov    %edx,(%eax)
}
c01032cd:	5d                   	pop    %ebp
c01032ce:	c3                   	ret    

c01032cf <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01032cf:	55                   	push   %ebp
c01032d0:	89 e5                	mov    %esp,%ebp
c01032d2:	83 ec 10             	sub    $0x10,%esp
c01032d5:	c7 45 fc c0 1a 12 c0 	movl   $0xc0121ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032df:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032e2:	89 50 04             	mov    %edx,0x4(%eax)
c01032e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032e8:	8b 50 04             	mov    0x4(%eax),%edx
c01032eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032ee:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01032f0:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c01032f7:	00 00 00 
}
c01032fa:	c9                   	leave  
c01032fb:	c3                   	ret    

c01032fc <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01032fc:	55                   	push   %ebp
c01032fd:	89 e5                	mov    %esp,%ebp
c01032ff:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103306:	75 24                	jne    c010332c <default_init_memmap+0x30>
c0103308:	c7 44 24 0c 10 95 10 	movl   $0xc0109510,0xc(%esp)
c010330f:	c0 
c0103310:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103317:	c0 
c0103318:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010331f:	00 
c0103320:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103327:	e8 c4 d9 ff ff       	call   c0100cf0 <__panic>
    struct Page *p = base;
c010332c:	8b 45 08             	mov    0x8(%ebp),%eax
c010332f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103332:	eb 7d                	jmp    c01033b1 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103334:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103337:	83 c0 04             	add    $0x4,%eax
c010333a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103341:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103344:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103347:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010334a:	0f a3 10             	bt     %edx,(%eax)
c010334d:	19 c0                	sbb    %eax,%eax
c010334f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103352:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103356:	0f 95 c0             	setne  %al
c0103359:	0f b6 c0             	movzbl %al,%eax
c010335c:	85 c0                	test   %eax,%eax
c010335e:	75 24                	jne    c0103384 <default_init_memmap+0x88>
c0103360:	c7 44 24 0c 41 95 10 	movl   $0xc0109541,0xc(%esp)
c0103367:	c0 
c0103368:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c010336f:	c0 
c0103370:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103377:	00 
c0103378:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c010337f:	e8 6c d9 ff ff       	call   c0100cf0 <__panic>
        p->flags = p->property = 0;
c0103384:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103387:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103391:	8b 50 08             	mov    0x8(%eax),%edx
c0103394:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103397:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010339a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01033a1:	00 
c01033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a5:	89 04 24             	mov    %eax,(%esp)
c01033a8:	e8 15 ff ff ff       	call   c01032c2 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01033ad:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01033b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033b4:	c1 e0 05             	shl    $0x5,%eax
c01033b7:	89 c2                	mov    %eax,%edx
c01033b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01033bc:	01 d0                	add    %edx,%eax
c01033be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01033c1:	0f 85 6d ff ff ff    	jne    c0103334 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01033c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01033ca:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033cd:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01033d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d3:	83 c0 04             	add    $0x4,%eax
c01033d6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01033dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01033e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01033e6:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01033e9:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c01033ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033f2:	01 d0                	add    %edx,%eax
c01033f4:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
    list_add(&free_list, &(base->page_link));
c01033f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01033fc:	83 c0 0c             	add    $0xc,%eax
c01033ff:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
c0103406:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103409:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010340c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010340f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103412:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103415:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103418:	8b 40 04             	mov    0x4(%eax),%eax
c010341b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010341e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103421:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103424:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103427:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010342a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010342d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103430:	89 10                	mov    %edx,(%eax)
c0103432:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103435:	8b 10                	mov    (%eax),%edx
c0103437:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010343a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010343d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103440:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103443:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103446:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103449:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010344c:	89 10                	mov    %edx,(%eax)
}
c010344e:	c9                   	leave  
c010344f:	c3                   	ret    

c0103450 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103450:	55                   	push   %ebp
c0103451:	89 e5                	mov    %esp,%ebp
c0103453:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103456:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010345a:	75 24                	jne    c0103480 <default_alloc_pages+0x30>
c010345c:	c7 44 24 0c 10 95 10 	movl   $0xc0109510,0xc(%esp)
c0103463:	c0 
c0103464:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c010346b:	c0 
c010346c:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0103473:	00 
c0103474:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c010347b:	e8 70 d8 ff ff       	call   c0100cf0 <__panic>
    if (n > nr_free) {
c0103480:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103485:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103488:	73 0a                	jae    c0103494 <default_alloc_pages+0x44>
        return NULL;
c010348a:	b8 00 00 00 00       	mov    $0x0,%eax
c010348f:	e9 4d 01 00 00       	jmp    c01035e1 <default_alloc_pages+0x191>
    }
    struct Page *page = NULL;
c0103494:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010349b:	c7 45 f0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01034a2:	eb 1c                	jmp    c01034c0 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01034a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034a7:	83 e8 0c             	sub    $0xc,%eax
c01034aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01034ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034b0:	8b 40 08             	mov    0x8(%eax),%eax
c01034b3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034b6:	72 08                	jb     c01034c0 <default_alloc_pages+0x70>
            page = p;
c01034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01034be:	eb 18                	jmp    c01034d8 <default_alloc_pages+0x88>
c01034c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c9:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01034cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034cf:	81 7d f0 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x10(%ebp)
c01034d6:	75 cc                	jne    c01034a4 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if(page != NULL){
c01034d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034dc:	0f 84 fc 00 00 00    	je     c01035de <default_alloc_pages+0x18e>
c01034e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01034e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034eb:	8b 00                	mov    (%eax),%eax
        le = list_prev(le);
c01034ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(page->property > n){
c01034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f3:	8b 40 08             	mov    0x8(%eax),%eax
c01034f6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034f9:	0f 86 8e 00 00 00    	jbe    c010358d <default_alloc_pages+0x13d>
            struct Page *p = page + n;
c01034ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103502:	c1 e0 05             	shl    $0x5,%eax
c0103505:	89 c2                	mov    %eax,%edx
c0103507:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010350a:	01 d0                	add    %edx,%eax
c010350c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            SetPageProperty(p);
c010350f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103512:	83 c0 04             	add    $0x4,%eax
c0103515:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c010351c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010351f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103522:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103525:	0f ab 10             	bts    %edx,(%eax)
            p->property = page->property - n;
c0103528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352b:	8b 40 08             	mov    0x8(%eax),%eax
c010352e:	2b 45 08             	sub    0x8(%ebp),%eax
c0103531:	89 c2                	mov    %eax,%edx
c0103533:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103536:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(le, &(p->page_link));
c0103539:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010353c:	8d 50 0c             	lea    0xc(%eax),%edx
c010353f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103542:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103545:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103548:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010354b:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010354e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103551:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103554:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103557:	8b 40 04             	mov    0x4(%eax),%eax
c010355a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010355d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0103560:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103563:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103566:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103569:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010356c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010356f:	89 10                	mov    %edx,(%eax)
c0103571:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103574:	8b 10                	mov    (%eax),%edx
c0103576:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103579:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010357c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010357f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103582:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103585:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103588:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010358b:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c010358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103590:	83 c0 0c             	add    $0xc,%eax
c0103593:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103596:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103599:	8b 40 04             	mov    0x4(%eax),%eax
c010359c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010359f:	8b 12                	mov    (%edx),%edx
c01035a1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01035a4:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01035ad:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035b3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01035b6:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01035b8:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01035bd:	2b 45 08             	sub    0x8(%ebp),%eax
c01035c0:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
        ClearPageProperty(page);
c01035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c8:	83 c0 04             	add    $0x4,%eax
c01035cb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035d2:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035d5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035d8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035db:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c01035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01035e1:	c9                   	leave  
c01035e2:	c3                   	ret    

c01035e3 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01035e3:	55                   	push   %ebp
c01035e4:	89 e5                	mov    %esp,%ebp
c01035e6:	81 ec 88 00 00 00    	sub    $0x88,%esp
    struct Page *p = base;
c01035ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01035f2:	e9 9d 00 00 00       	jmp    c0103694 <default_free_pages+0xb1>
        assert(!PageReserved(p) && !PageProperty(p));
c01035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fa:	83 c0 04             	add    $0x4,%eax
c01035fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103604:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103607:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010360a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010360d:	0f a3 10             	bt     %edx,(%eax)
c0103610:	19 c0                	sbb    %eax,%eax
c0103612:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103615:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103619:	0f 95 c0             	setne  %al
c010361c:	0f b6 c0             	movzbl %al,%eax
c010361f:	85 c0                	test   %eax,%eax
c0103621:	75 2c                	jne    c010364f <default_free_pages+0x6c>
c0103623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103626:	83 c0 04             	add    $0x4,%eax
c0103629:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103630:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103633:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103636:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103639:	0f a3 10             	bt     %edx,(%eax)
c010363c:	19 c0                	sbb    %eax,%eax
c010363e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0103641:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103645:	0f 95 c0             	setne  %al
c0103648:	0f b6 c0             	movzbl %al,%eax
c010364b:	85 c0                	test   %eax,%eax
c010364d:	74 24                	je     c0103673 <default_free_pages+0x90>
c010364f:	c7 44 24 0c 54 95 10 	movl   $0xc0109554,0xc(%esp)
c0103656:	c0 
c0103657:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c010365e:	c0 
c010365f:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0103666:	00 
c0103667:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c010366e:	e8 7d d6 ff ff       	call   c0100cf0 <__panic>
        p->flags = 0;
c0103673:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010367d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103684:	00 
c0103685:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103688:	89 04 24             	mov    %eax,(%esp)
c010368b:	e8 32 fc ff ff       	call   c01032c2 <set_page_ref>
}

static void
default_free_pages(struct Page *base, size_t n) {
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103690:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103694:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103697:	c1 e0 05             	shl    $0x5,%eax
c010369a:	89 c2                	mov    %eax,%edx
c010369c:	8b 45 08             	mov    0x8(%ebp),%eax
c010369f:	01 d0                	add    %edx,%eax
c01036a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036a4:	0f 85 4d ff ff ff    	jne    c01035f7 <default_free_pages+0x14>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01036aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036b0:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01036b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b6:	83 c0 04             	add    $0x4,%eax
c01036b9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01036c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036c9:	0f ab 10             	bts    %edx,(%eax)
c01036cc:	c7 45 cc c0 1a 12 c0 	movl   $0xc0121ac0,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01036d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01036d6:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01036d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01036dc:	e9 18 01 00 00       	jmp    c01037f9 <default_free_pages+0x216>
        p = le2page(le, page_link);
c01036e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e4:	83 e8 0c             	sub    $0xc,%eax
c01036e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c01036ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ed:	8b 40 08             	mov    0x8(%eax),%eax
c01036f0:	c1 e0 05             	shl    $0x5,%eax
c01036f3:	89 c2                	mov    %eax,%edx
c01036f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f8:	01 d0                	add    %edx,%eax
c01036fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036fd:	75 6c                	jne    c010376b <default_free_pages+0x188>
            base->property += p->property;
c01036ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103702:	8b 50 08             	mov    0x8(%eax),%edx
c0103705:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103708:	8b 40 08             	mov    0x8(%eax),%eax
c010370b:	01 c2                	add    %eax,%edx
c010370d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103710:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0103713:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103716:	83 c0 04             	add    $0x4,%eax
c0103719:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103720:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103723:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103726:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103729:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c010372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010372f:	83 c0 0c             	add    $0xc,%eax
c0103732:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103735:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103738:	8b 40 04             	mov    0x4(%eax),%eax
c010373b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010373e:	8b 12                	mov    (%edx),%edx
c0103740:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103743:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103746:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103749:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010374c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010374f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103752:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103755:	89 10                	mov    %edx,(%eax)
c0103757:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010375d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103760:	8b 40 04             	mov    0x4(%eax),%eax
            le = list_next(le);
c0103763:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
c0103766:	e9 9b 00 00 00       	jmp    c0103806 <default_free_pages+0x223>
        }
        else if (p + p->property == base) {
c010376b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010376e:	8b 40 08             	mov    0x8(%eax),%eax
c0103771:	c1 e0 05             	shl    $0x5,%eax
c0103774:	89 c2                	mov    %eax,%edx
c0103776:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103779:	01 d0                	add    %edx,%eax
c010377b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010377e:	75 60                	jne    c01037e0 <default_free_pages+0x1fd>
            p->property += base->property;
c0103780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103783:	8b 50 08             	mov    0x8(%eax),%edx
c0103786:	8b 45 08             	mov    0x8(%ebp),%eax
c0103789:	8b 40 08             	mov    0x8(%eax),%eax
c010378c:	01 c2                	add    %eax,%edx
c010378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103791:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103794:	8b 45 08             	mov    0x8(%ebp),%eax
c0103797:	83 c0 04             	add    $0x4,%eax
c010379a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01037a1:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01037a4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01037a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01037aa:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037b0:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037b6:	83 c0 0c             	add    $0xc,%eax
c01037b9:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01037bc:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037bf:	8b 40 04             	mov    0x4(%eax),%eax
c01037c2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01037c5:	8b 12                	mov    (%edx),%edx
c01037c7:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01037ca:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01037cd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01037d0:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037d3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01037d9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01037dc:	89 10                	mov    %edx,(%eax)
c01037de:	eb 0a                	jmp    c01037ea <default_free_pages+0x207>
        }
        else if(p > base){
c01037e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037e6:	76 02                	jbe    c01037ea <default_free_pages+0x207>
            break;
c01037e8:	eb 1c                	jmp    c0103806 <default_free_pages+0x223>
c01037ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037ed:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01037f0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037f3:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c01037f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01037f9:	81 7d f0 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x10(%ebp)
c0103800:	0f 85 db fe ff ff    	jne    c01036e1 <default_free_pages+0xfe>
        else if(p > base){
            break;
        }
        le = list_next(le);
    }
    nr_free += n;
c0103806:	8b 15 c8 1a 12 c0    	mov    0xc0121ac8,%edx
c010380c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010380f:	01 d0                	add    %edx,%eax
c0103811:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
    list_add_before(le, &(base->page_link));
c0103816:	8b 45 08             	mov    0x8(%ebp),%eax
c0103819:	8d 50 0c             	lea    0xc(%eax),%edx
c010381c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010381f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103822:	89 55 94             	mov    %edx,-0x6c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103825:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103828:	8b 00                	mov    (%eax),%eax
c010382a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010382d:	89 55 90             	mov    %edx,-0x70(%ebp)
c0103830:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0103833:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103836:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103839:	8b 45 88             	mov    -0x78(%ebp),%eax
c010383c:	8b 55 90             	mov    -0x70(%ebp),%edx
c010383f:	89 10                	mov    %edx,(%eax)
c0103841:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103844:	8b 10                	mov    (%eax),%edx
c0103846:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103849:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010384c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010384f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103852:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103855:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103858:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010385b:	89 10                	mov    %edx,(%eax)
}
c010385d:	c9                   	leave  
c010385e:	c3                   	ret    

c010385f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010385f:	55                   	push   %ebp
c0103860:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103862:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
}
c0103867:	5d                   	pop    %ebp
c0103868:	c3                   	ret    

c0103869 <basic_check>:

static void
basic_check(void) {
c0103869:	55                   	push   %ebp
c010386a:	89 e5                	mov    %esp,%ebp
c010386c:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010386f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103876:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103879:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010387c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010387f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103882:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103889:	e8 bf 0e 00 00       	call   c010474d <alloc_pages>
c010388e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103891:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103895:	75 24                	jne    c01038bb <basic_check+0x52>
c0103897:	c7 44 24 0c 79 95 10 	movl   $0xc0109579,0xc(%esp)
c010389e:	c0 
c010389f:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01038a6:	c0 
c01038a7:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c01038ae:	00 
c01038af:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01038b6:	e8 35 d4 ff ff       	call   c0100cf0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01038bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038c2:	e8 86 0e 00 00       	call   c010474d <alloc_pages>
c01038c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038ce:	75 24                	jne    c01038f4 <basic_check+0x8b>
c01038d0:	c7 44 24 0c 95 95 10 	movl   $0xc0109595,0xc(%esp)
c01038d7:	c0 
c01038d8:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01038df:	c0 
c01038e0:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01038e7:	00 
c01038e8:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01038ef:	e8 fc d3 ff ff       	call   c0100cf0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038fb:	e8 4d 0e 00 00       	call   c010474d <alloc_pages>
c0103900:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103907:	75 24                	jne    c010392d <basic_check+0xc4>
c0103909:	c7 44 24 0c b1 95 10 	movl   $0xc01095b1,0xc(%esp)
c0103910:	c0 
c0103911:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103918:	c0 
c0103919:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0103920:	00 
c0103921:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103928:	e8 c3 d3 ff ff       	call   c0100cf0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010392d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103930:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103933:	74 10                	je     c0103945 <basic_check+0xdc>
c0103935:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010393b:	74 08                	je     c0103945 <basic_check+0xdc>
c010393d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103940:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103943:	75 24                	jne    c0103969 <basic_check+0x100>
c0103945:	c7 44 24 0c d0 95 10 	movl   $0xc01095d0,0xc(%esp)
c010394c:	c0 
c010394d:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103954:	c0 
c0103955:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c010395c:	00 
c010395d:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103964:	e8 87 d3 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103969:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010396c:	89 04 24             	mov    %eax,(%esp)
c010396f:	e8 44 f9 ff ff       	call   c01032b8 <page_ref>
c0103974:	85 c0                	test   %eax,%eax
c0103976:	75 1e                	jne    c0103996 <basic_check+0x12d>
c0103978:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010397b:	89 04 24             	mov    %eax,(%esp)
c010397e:	e8 35 f9 ff ff       	call   c01032b8 <page_ref>
c0103983:	85 c0                	test   %eax,%eax
c0103985:	75 0f                	jne    c0103996 <basic_check+0x12d>
c0103987:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010398a:	89 04 24             	mov    %eax,(%esp)
c010398d:	e8 26 f9 ff ff       	call   c01032b8 <page_ref>
c0103992:	85 c0                	test   %eax,%eax
c0103994:	74 24                	je     c01039ba <basic_check+0x151>
c0103996:	c7 44 24 0c f4 95 10 	movl   $0xc01095f4,0xc(%esp)
c010399d:	c0 
c010399e:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01039a5:	c0 
c01039a6:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c01039ad:	00 
c01039ae:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01039b5:	e8 36 d3 ff ff       	call   c0100cf0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01039ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039bd:	89 04 24             	mov    %eax,(%esp)
c01039c0:	e8 dd f8 ff ff       	call   c01032a2 <page2pa>
c01039c5:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c01039cb:	c1 e2 0c             	shl    $0xc,%edx
c01039ce:	39 d0                	cmp    %edx,%eax
c01039d0:	72 24                	jb     c01039f6 <basic_check+0x18d>
c01039d2:	c7 44 24 0c 30 96 10 	movl   $0xc0109630,0xc(%esp)
c01039d9:	c0 
c01039da:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01039e1:	c0 
c01039e2:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01039e9:	00 
c01039ea:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01039f1:	e8 fa d2 ff ff       	call   c0100cf0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01039f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039f9:	89 04 24             	mov    %eax,(%esp)
c01039fc:	e8 a1 f8 ff ff       	call   c01032a2 <page2pa>
c0103a01:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103a07:	c1 e2 0c             	shl    $0xc,%edx
c0103a0a:	39 d0                	cmp    %edx,%eax
c0103a0c:	72 24                	jb     c0103a32 <basic_check+0x1c9>
c0103a0e:	c7 44 24 0c 4d 96 10 	movl   $0xc010964d,0xc(%esp)
c0103a15:	c0 
c0103a16:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103a1d:	c0 
c0103a1e:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0103a25:	00 
c0103a26:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103a2d:	e8 be d2 ff ff       	call   c0100cf0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a35:	89 04 24             	mov    %eax,(%esp)
c0103a38:	e8 65 f8 ff ff       	call   c01032a2 <page2pa>
c0103a3d:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103a43:	c1 e2 0c             	shl    $0xc,%edx
c0103a46:	39 d0                	cmp    %edx,%eax
c0103a48:	72 24                	jb     c0103a6e <basic_check+0x205>
c0103a4a:	c7 44 24 0c 6a 96 10 	movl   $0xc010966a,0xc(%esp)
c0103a51:	c0 
c0103a52:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103a59:	c0 
c0103a5a:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103a61:	00 
c0103a62:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103a69:	e8 82 d2 ff ff       	call   c0100cf0 <__panic>

    list_entry_t free_list_store = free_list;
c0103a6e:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103a73:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103a79:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a7c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a7f:	c7 45 e0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a89:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a8c:	89 50 04             	mov    %edx,0x4(%eax)
c0103a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a92:	8b 50 04             	mov    0x4(%eax),%edx
c0103a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a98:	89 10                	mov    %edx,(%eax)
c0103a9a:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103aa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103aa4:	8b 40 04             	mov    0x4(%eax),%eax
c0103aa7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103aaa:	0f 94 c0             	sete   %al
c0103aad:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ab0:	85 c0                	test   %eax,%eax
c0103ab2:	75 24                	jne    c0103ad8 <basic_check+0x26f>
c0103ab4:	c7 44 24 0c 87 96 10 	movl   $0xc0109687,0xc(%esp)
c0103abb:	c0 
c0103abc:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103ac3:	c0 
c0103ac4:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0103acb:	00 
c0103acc:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103ad3:	e8 18 d2 ff ff       	call   c0100cf0 <__panic>

    unsigned int nr_free_store = nr_free;
c0103ad8:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103add:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103ae0:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103ae7:	00 00 00 

    assert(alloc_page() == NULL);
c0103aea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103af1:	e8 57 0c 00 00       	call   c010474d <alloc_pages>
c0103af6:	85 c0                	test   %eax,%eax
c0103af8:	74 24                	je     c0103b1e <basic_check+0x2b5>
c0103afa:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c0103b01:	c0 
c0103b02:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103b09:	c0 
c0103b0a:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0103b11:	00 
c0103b12:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103b19:	e8 d2 d1 ff ff       	call   c0100cf0 <__panic>

    free_page(p0);
c0103b1e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b25:	00 
c0103b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b29:	89 04 24             	mov    %eax,(%esp)
c0103b2c:	e8 87 0c 00 00       	call   c01047b8 <free_pages>
    free_page(p1);
c0103b31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b38:	00 
c0103b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b3c:	89 04 24             	mov    %eax,(%esp)
c0103b3f:	e8 74 0c 00 00       	call   c01047b8 <free_pages>
    free_page(p2);
c0103b44:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b4b:	00 
c0103b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b4f:	89 04 24             	mov    %eax,(%esp)
c0103b52:	e8 61 0c 00 00       	call   c01047b8 <free_pages>
    assert(nr_free == 3);
c0103b57:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103b5c:	83 f8 03             	cmp    $0x3,%eax
c0103b5f:	74 24                	je     c0103b85 <basic_check+0x31c>
c0103b61:	c7 44 24 0c b3 96 10 	movl   $0xc01096b3,0xc(%esp)
c0103b68:	c0 
c0103b69:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103b70:	c0 
c0103b71:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103b78:	00 
c0103b79:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103b80:	e8 6b d1 ff ff       	call   c0100cf0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b8c:	e8 bc 0b 00 00       	call   c010474d <alloc_pages>
c0103b91:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b98:	75 24                	jne    c0103bbe <basic_check+0x355>
c0103b9a:	c7 44 24 0c 79 95 10 	movl   $0xc0109579,0xc(%esp)
c0103ba1:	c0 
c0103ba2:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103ba9:	c0 
c0103baa:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103bb1:	00 
c0103bb2:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103bb9:	e8 32 d1 ff ff       	call   c0100cf0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103bbe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bc5:	e8 83 0b 00 00       	call   c010474d <alloc_pages>
c0103bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bd1:	75 24                	jne    c0103bf7 <basic_check+0x38e>
c0103bd3:	c7 44 24 0c 95 95 10 	movl   $0xc0109595,0xc(%esp)
c0103bda:	c0 
c0103bdb:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103be2:	c0 
c0103be3:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103bea:	00 
c0103beb:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103bf2:	e8 f9 d0 ff ff       	call   c0100cf0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103bf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bfe:	e8 4a 0b 00 00       	call   c010474d <alloc_pages>
c0103c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c0a:	75 24                	jne    c0103c30 <basic_check+0x3c7>
c0103c0c:	c7 44 24 0c b1 95 10 	movl   $0xc01095b1,0xc(%esp)
c0103c13:	c0 
c0103c14:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103c1b:	c0 
c0103c1c:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103c23:	00 
c0103c24:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103c2b:	e8 c0 d0 ff ff       	call   c0100cf0 <__panic>

    assert(alloc_page() == NULL);
c0103c30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c37:	e8 11 0b 00 00       	call   c010474d <alloc_pages>
c0103c3c:	85 c0                	test   %eax,%eax
c0103c3e:	74 24                	je     c0103c64 <basic_check+0x3fb>
c0103c40:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c0103c47:	c0 
c0103c48:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103c4f:	c0 
c0103c50:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103c57:	00 
c0103c58:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103c5f:	e8 8c d0 ff ff       	call   c0100cf0 <__panic>

    free_page(p0);
c0103c64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c6b:	00 
c0103c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c6f:	89 04 24             	mov    %eax,(%esp)
c0103c72:	e8 41 0b 00 00       	call   c01047b8 <free_pages>
c0103c77:	c7 45 d8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x28(%ebp)
c0103c7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c81:	8b 40 04             	mov    0x4(%eax),%eax
c0103c84:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c87:	0f 94 c0             	sete   %al
c0103c8a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c8d:	85 c0                	test   %eax,%eax
c0103c8f:	74 24                	je     c0103cb5 <basic_check+0x44c>
c0103c91:	c7 44 24 0c c0 96 10 	movl   $0xc01096c0,0xc(%esp)
c0103c98:	c0 
c0103c99:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103ca0:	c0 
c0103ca1:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103ca8:	00 
c0103ca9:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103cb0:	e8 3b d0 ff ff       	call   c0100cf0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103cb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cbc:	e8 8c 0a 00 00       	call   c010474d <alloc_pages>
c0103cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cc7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cca:	74 24                	je     c0103cf0 <basic_check+0x487>
c0103ccc:	c7 44 24 0c d8 96 10 	movl   $0xc01096d8,0xc(%esp)
c0103cd3:	c0 
c0103cd4:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103cdb:	c0 
c0103cdc:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103ce3:	00 
c0103ce4:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103ceb:	e8 00 d0 ff ff       	call   c0100cf0 <__panic>
    assert(alloc_page() == NULL);
c0103cf0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cf7:	e8 51 0a 00 00       	call   c010474d <alloc_pages>
c0103cfc:	85 c0                	test   %eax,%eax
c0103cfe:	74 24                	je     c0103d24 <basic_check+0x4bb>
c0103d00:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c0103d07:	c0 
c0103d08:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103d0f:	c0 
c0103d10:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0103d17:	00 
c0103d18:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103d1f:	e8 cc cf ff ff       	call   c0100cf0 <__panic>

    assert(nr_free == 0);
c0103d24:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103d29:	85 c0                	test   %eax,%eax
c0103d2b:	74 24                	je     c0103d51 <basic_check+0x4e8>
c0103d2d:	c7 44 24 0c f1 96 10 	movl   $0xc01096f1,0xc(%esp)
c0103d34:	c0 
c0103d35:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103d3c:	c0 
c0103d3d:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103d44:	00 
c0103d45:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103d4c:	e8 9f cf ff ff       	call   c0100cf0 <__panic>
    free_list = free_list_store;
c0103d51:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d54:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d57:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0103d5c:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    nr_free = nr_free_store;
c0103d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d65:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_page(p);
c0103d6a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d71:	00 
c0103d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d75:	89 04 24             	mov    %eax,(%esp)
c0103d78:	e8 3b 0a 00 00       	call   c01047b8 <free_pages>
    free_page(p1);
c0103d7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d84:	00 
c0103d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d88:	89 04 24             	mov    %eax,(%esp)
c0103d8b:	e8 28 0a 00 00       	call   c01047b8 <free_pages>
    free_page(p2);
c0103d90:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d97:	00 
c0103d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d9b:	89 04 24             	mov    %eax,(%esp)
c0103d9e:	e8 15 0a 00 00       	call   c01047b8 <free_pages>
}
c0103da3:	c9                   	leave  
c0103da4:	c3                   	ret    

c0103da5 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103da5:	55                   	push   %ebp
c0103da6:	89 e5                	mov    %esp,%ebp
c0103da8:	53                   	push   %ebx
c0103da9:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103daf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103db6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103dbd:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103dc4:	eb 6b                	jmp    c0103e31 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dc9:	83 e8 0c             	sub    $0xc,%eax
c0103dcc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dd2:	83 c0 04             	add    $0x4,%eax
c0103dd5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103ddc:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ddf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103de2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103de5:	0f a3 10             	bt     %edx,(%eax)
c0103de8:	19 c0                	sbb    %eax,%eax
c0103dea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103ded:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103df1:	0f 95 c0             	setne  %al
c0103df4:	0f b6 c0             	movzbl %al,%eax
c0103df7:	85 c0                	test   %eax,%eax
c0103df9:	75 24                	jne    c0103e1f <default_check+0x7a>
c0103dfb:	c7 44 24 0c fe 96 10 	movl   $0xc01096fe,0xc(%esp)
c0103e02:	c0 
c0103e03:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103e0a:	c0 
c0103e0b:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103e12:	00 
c0103e13:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103e1a:	e8 d1 ce ff ff       	call   c0100cf0 <__panic>
        count ++, total += p->property;
c0103e1f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e23:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e26:	8b 50 08             	mov    0x8(%eax),%edx
c0103e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e2c:	01 d0                	add    %edx,%eax
c0103e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e34:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e3a:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e40:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c0103e47:	0f 85 79 ff ff ff    	jne    c0103dc6 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e4d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e50:	e8 95 09 00 00       	call   c01047ea <nr_free_pages>
c0103e55:	39 c3                	cmp    %eax,%ebx
c0103e57:	74 24                	je     c0103e7d <default_check+0xd8>
c0103e59:	c7 44 24 0c 0e 97 10 	movl   $0xc010970e,0xc(%esp)
c0103e60:	c0 
c0103e61:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103e68:	c0 
c0103e69:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103e70:	00 
c0103e71:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103e78:	e8 73 ce ff ff       	call   c0100cf0 <__panic>

    basic_check();
c0103e7d:	e8 e7 f9 ff ff       	call   c0103869 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e82:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e89:	e8 bf 08 00 00       	call   c010474d <alloc_pages>
c0103e8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103e91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e95:	75 24                	jne    c0103ebb <default_check+0x116>
c0103e97:	c7 44 24 0c 27 97 10 	movl   $0xc0109727,0xc(%esp)
c0103e9e:	c0 
c0103e9f:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103ea6:	c0 
c0103ea7:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103eae:	00 
c0103eaf:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103eb6:	e8 35 ce ff ff       	call   c0100cf0 <__panic>
    assert(!PageProperty(p0));
c0103ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ebe:	83 c0 04             	add    $0x4,%eax
c0103ec1:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103ec8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ecb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ece:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103ed1:	0f a3 10             	bt     %edx,(%eax)
c0103ed4:	19 c0                	sbb    %eax,%eax
c0103ed6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103ed9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103edd:	0f 95 c0             	setne  %al
c0103ee0:	0f b6 c0             	movzbl %al,%eax
c0103ee3:	85 c0                	test   %eax,%eax
c0103ee5:	74 24                	je     c0103f0b <default_check+0x166>
c0103ee7:	c7 44 24 0c 32 97 10 	movl   $0xc0109732,0xc(%esp)
c0103eee:	c0 
c0103eef:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103ef6:	c0 
c0103ef7:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103efe:	00 
c0103eff:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103f06:	e8 e5 cd ff ff       	call   c0100cf0 <__panic>

    list_entry_t free_list_store = free_list;
c0103f0b:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103f10:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103f16:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103f19:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103f1c:	c7 45 b4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f23:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f26:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f29:	89 50 04             	mov    %edx,0x4(%eax)
c0103f2c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f2f:	8b 50 04             	mov    0x4(%eax),%edx
c0103f32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f35:	89 10                	mov    %edx,(%eax)
c0103f37:	c7 45 b0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103f3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f41:	8b 40 04             	mov    0x4(%eax),%eax
c0103f44:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f47:	0f 94 c0             	sete   %al
c0103f4a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f4d:	85 c0                	test   %eax,%eax
c0103f4f:	75 24                	jne    c0103f75 <default_check+0x1d0>
c0103f51:	c7 44 24 0c 87 96 10 	movl   $0xc0109687,0xc(%esp)
c0103f58:	c0 
c0103f59:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103f60:	c0 
c0103f61:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103f68:	00 
c0103f69:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103f70:	e8 7b cd ff ff       	call   c0100cf0 <__panic>
    assert(alloc_page() == NULL);
c0103f75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f7c:	e8 cc 07 00 00       	call   c010474d <alloc_pages>
c0103f81:	85 c0                	test   %eax,%eax
c0103f83:	74 24                	je     c0103fa9 <default_check+0x204>
c0103f85:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c0103f8c:	c0 
c0103f8d:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103f94:	c0 
c0103f95:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103f9c:	00 
c0103f9d:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0103fa4:	e8 47 cd ff ff       	call   c0100cf0 <__panic>

    unsigned int nr_free_store = nr_free;
c0103fa9:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103fae:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103fb1:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103fb8:	00 00 00 

    free_pages(p0 + 2, 3);
c0103fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fbe:	83 c0 40             	add    $0x40,%eax
c0103fc1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103fc8:	00 
c0103fc9:	89 04 24             	mov    %eax,(%esp)
c0103fcc:	e8 e7 07 00 00       	call   c01047b8 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103fd1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103fd8:	e8 70 07 00 00       	call   c010474d <alloc_pages>
c0103fdd:	85 c0                	test   %eax,%eax
c0103fdf:	74 24                	je     c0104005 <default_check+0x260>
c0103fe1:	c7 44 24 0c 44 97 10 	movl   $0xc0109744,0xc(%esp)
c0103fe8:	c0 
c0103fe9:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0103ff0:	c0 
c0103ff1:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103ff8:	00 
c0103ff9:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104000:	e8 eb cc ff ff       	call   c0100cf0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104008:	83 c0 40             	add    $0x40,%eax
c010400b:	83 c0 04             	add    $0x4,%eax
c010400e:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104015:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104018:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010401b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010401e:	0f a3 10             	bt     %edx,(%eax)
c0104021:	19 c0                	sbb    %eax,%eax
c0104023:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104026:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010402a:	0f 95 c0             	setne  %al
c010402d:	0f b6 c0             	movzbl %al,%eax
c0104030:	85 c0                	test   %eax,%eax
c0104032:	74 0e                	je     c0104042 <default_check+0x29d>
c0104034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104037:	83 c0 40             	add    $0x40,%eax
c010403a:	8b 40 08             	mov    0x8(%eax),%eax
c010403d:	83 f8 03             	cmp    $0x3,%eax
c0104040:	74 24                	je     c0104066 <default_check+0x2c1>
c0104042:	c7 44 24 0c 5c 97 10 	movl   $0xc010975c,0xc(%esp)
c0104049:	c0 
c010404a:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0104051:	c0 
c0104052:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104059:	00 
c010405a:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104061:	e8 8a cc ff ff       	call   c0100cf0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104066:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010406d:	e8 db 06 00 00       	call   c010474d <alloc_pages>
c0104072:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104075:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104079:	75 24                	jne    c010409f <default_check+0x2fa>
c010407b:	c7 44 24 0c 88 97 10 	movl   $0xc0109788,0xc(%esp)
c0104082:	c0 
c0104083:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c010408a:	c0 
c010408b:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104092:	00 
c0104093:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c010409a:	e8 51 cc ff ff       	call   c0100cf0 <__panic>
    assert(alloc_page() == NULL);
c010409f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040a6:	e8 a2 06 00 00       	call   c010474d <alloc_pages>
c01040ab:	85 c0                	test   %eax,%eax
c01040ad:	74 24                	je     c01040d3 <default_check+0x32e>
c01040af:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c01040b6:	c0 
c01040b7:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01040be:	c0 
c01040bf:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c01040c6:	00 
c01040c7:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01040ce:	e8 1d cc ff ff       	call   c0100cf0 <__panic>
    assert(p0 + 2 == p1);
c01040d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040d6:	83 c0 40             	add    $0x40,%eax
c01040d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040dc:	74 24                	je     c0104102 <default_check+0x35d>
c01040de:	c7 44 24 0c a6 97 10 	movl   $0xc01097a6,0xc(%esp)
c01040e5:	c0 
c01040e6:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01040ed:	c0 
c01040ee:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01040f5:	00 
c01040f6:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01040fd:	e8 ee cb ff ff       	call   c0100cf0 <__panic>

    p2 = p0 + 1;
c0104102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104105:	83 c0 20             	add    $0x20,%eax
c0104108:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010410b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104112:	00 
c0104113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104116:	89 04 24             	mov    %eax,(%esp)
c0104119:	e8 9a 06 00 00       	call   c01047b8 <free_pages>
    free_pages(p1, 3);
c010411e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104125:	00 
c0104126:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104129:	89 04 24             	mov    %eax,(%esp)
c010412c:	e8 87 06 00 00       	call   c01047b8 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104134:	83 c0 04             	add    $0x4,%eax
c0104137:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010413e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104141:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104144:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104147:	0f a3 10             	bt     %edx,(%eax)
c010414a:	19 c0                	sbb    %eax,%eax
c010414c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010414f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104153:	0f 95 c0             	setne  %al
c0104156:	0f b6 c0             	movzbl %al,%eax
c0104159:	85 c0                	test   %eax,%eax
c010415b:	74 0b                	je     c0104168 <default_check+0x3c3>
c010415d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104160:	8b 40 08             	mov    0x8(%eax),%eax
c0104163:	83 f8 01             	cmp    $0x1,%eax
c0104166:	74 24                	je     c010418c <default_check+0x3e7>
c0104168:	c7 44 24 0c b4 97 10 	movl   $0xc01097b4,0xc(%esp)
c010416f:	c0 
c0104170:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0104177:	c0 
c0104178:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c010417f:	00 
c0104180:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104187:	e8 64 cb ff ff       	call   c0100cf0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010418c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010418f:	83 c0 04             	add    $0x4,%eax
c0104192:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104199:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010419c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010419f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041a2:	0f a3 10             	bt     %edx,(%eax)
c01041a5:	19 c0                	sbb    %eax,%eax
c01041a7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01041aa:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01041ae:	0f 95 c0             	setne  %al
c01041b1:	0f b6 c0             	movzbl %al,%eax
c01041b4:	85 c0                	test   %eax,%eax
c01041b6:	74 0b                	je     c01041c3 <default_check+0x41e>
c01041b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041bb:	8b 40 08             	mov    0x8(%eax),%eax
c01041be:	83 f8 03             	cmp    $0x3,%eax
c01041c1:	74 24                	je     c01041e7 <default_check+0x442>
c01041c3:	c7 44 24 0c dc 97 10 	movl   $0xc01097dc,0xc(%esp)
c01041ca:	c0 
c01041cb:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01041d2:	c0 
c01041d3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01041da:	00 
c01041db:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01041e2:	e8 09 cb ff ff       	call   c0100cf0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01041e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ee:	e8 5a 05 00 00       	call   c010474d <alloc_pages>
c01041f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041f9:	83 e8 20             	sub    $0x20,%eax
c01041fc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041ff:	74 24                	je     c0104225 <default_check+0x480>
c0104201:	c7 44 24 0c 02 98 10 	movl   $0xc0109802,0xc(%esp)
c0104208:	c0 
c0104209:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0104210:	c0 
c0104211:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0104218:	00 
c0104219:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104220:	e8 cb ca ff ff       	call   c0100cf0 <__panic>
    free_page(p0);
c0104225:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010422c:	00 
c010422d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104230:	89 04 24             	mov    %eax,(%esp)
c0104233:	e8 80 05 00 00       	call   c01047b8 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104238:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010423f:	e8 09 05 00 00       	call   c010474d <alloc_pages>
c0104244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104247:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010424a:	83 c0 20             	add    $0x20,%eax
c010424d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104250:	74 24                	je     c0104276 <default_check+0x4d1>
c0104252:	c7 44 24 0c 20 98 10 	movl   $0xc0109820,0xc(%esp)
c0104259:	c0 
c010425a:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0104261:	c0 
c0104262:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0104269:	00 
c010426a:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104271:	e8 7a ca ff ff       	call   c0100cf0 <__panic>

    free_pages(p0, 2);
c0104276:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010427d:	00 
c010427e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104281:	89 04 24             	mov    %eax,(%esp)
c0104284:	e8 2f 05 00 00       	call   c01047b8 <free_pages>
    free_page(p2);
c0104289:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104290:	00 
c0104291:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104294:	89 04 24             	mov    %eax,(%esp)
c0104297:	e8 1c 05 00 00       	call   c01047b8 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010429c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01042a3:	e8 a5 04 00 00       	call   c010474d <alloc_pages>
c01042a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042af:	75 24                	jne    c01042d5 <default_check+0x530>
c01042b1:	c7 44 24 0c 40 98 10 	movl   $0xc0109840,0xc(%esp)
c01042b8:	c0 
c01042b9:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01042c0:	c0 
c01042c1:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01042c8:	00 
c01042c9:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01042d0:	e8 1b ca ff ff       	call   c0100cf0 <__panic>
    assert(alloc_page() == NULL);
c01042d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042dc:	e8 6c 04 00 00       	call   c010474d <alloc_pages>
c01042e1:	85 c0                	test   %eax,%eax
c01042e3:	74 24                	je     c0104309 <default_check+0x564>
c01042e5:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c01042ec:	c0 
c01042ed:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01042f4:	c0 
c01042f5:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01042fc:	00 
c01042fd:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104304:	e8 e7 c9 ff ff       	call   c0100cf0 <__panic>

    assert(nr_free == 0);
c0104309:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c010430e:	85 c0                	test   %eax,%eax
c0104310:	74 24                	je     c0104336 <default_check+0x591>
c0104312:	c7 44 24 0c f1 96 10 	movl   $0xc01096f1,0xc(%esp)
c0104319:	c0 
c010431a:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c0104321:	c0 
c0104322:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104329:	00 
c010432a:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c0104331:	e8 ba c9 ff ff       	call   c0100cf0 <__panic>
    nr_free = nr_free_store;
c0104336:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104339:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_list = free_list_store;
c010433e:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104341:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104344:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0104349:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    free_pages(p0, 5);
c010434f:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104356:	00 
c0104357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010435a:	89 04 24             	mov    %eax,(%esp)
c010435d:	e8 56 04 00 00       	call   c01047b8 <free_pages>

    le = &free_list;
c0104362:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104369:	eb 1d                	jmp    c0104388 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010436b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010436e:	83 e8 0c             	sub    $0xc,%eax
c0104371:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104374:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104378:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010437b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010437e:	8b 40 08             	mov    0x8(%eax),%eax
c0104381:	29 c2                	sub    %eax,%edx
c0104383:	89 d0                	mov    %edx,%eax
c0104385:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104388:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010438b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010438e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104391:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104394:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104397:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c010439e:	75 cb                	jne    c010436b <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01043a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043a4:	74 24                	je     c01043ca <default_check+0x625>
c01043a6:	c7 44 24 0c 5e 98 10 	movl   $0xc010985e,0xc(%esp)
c01043ad:	c0 
c01043ae:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01043b5:	c0 
c01043b6:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01043bd:	00 
c01043be:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01043c5:	e8 26 c9 ff ff       	call   c0100cf0 <__panic>
    assert(total == 0);
c01043ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043ce:	74 24                	je     c01043f4 <default_check+0x64f>
c01043d0:	c7 44 24 0c 69 98 10 	movl   $0xc0109869,0xc(%esp)
c01043d7:	c0 
c01043d8:	c7 44 24 08 16 95 10 	movl   $0xc0109516,0x8(%esp)
c01043df:	c0 
c01043e0:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01043e7:	00 
c01043e8:	c7 04 24 2b 95 10 c0 	movl   $0xc010952b,(%esp)
c01043ef:	e8 fc c8 ff ff       	call   c0100cf0 <__panic>
}
c01043f4:	81 c4 94 00 00 00    	add    $0x94,%esp
c01043fa:	5b                   	pop    %ebx
c01043fb:	5d                   	pop    %ebp
c01043fc:	c3                   	ret    

c01043fd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01043fd:	55                   	push   %ebp
c01043fe:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104400:	8b 55 08             	mov    0x8(%ebp),%edx
c0104403:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104408:	29 c2                	sub    %eax,%edx
c010440a:	89 d0                	mov    %edx,%eax
c010440c:	c1 f8 05             	sar    $0x5,%eax
}
c010440f:	5d                   	pop    %ebp
c0104410:	c3                   	ret    

c0104411 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104411:	55                   	push   %ebp
c0104412:	89 e5                	mov    %esp,%ebp
c0104414:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104417:	8b 45 08             	mov    0x8(%ebp),%eax
c010441a:	89 04 24             	mov    %eax,(%esp)
c010441d:	e8 db ff ff ff       	call   c01043fd <page2ppn>
c0104422:	c1 e0 0c             	shl    $0xc,%eax
}
c0104425:	c9                   	leave  
c0104426:	c3                   	ret    

c0104427 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104427:	55                   	push   %ebp
c0104428:	89 e5                	mov    %esp,%ebp
c010442a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010442d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104430:	c1 e8 0c             	shr    $0xc,%eax
c0104433:	89 c2                	mov    %eax,%edx
c0104435:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010443a:	39 c2                	cmp    %eax,%edx
c010443c:	72 1c                	jb     c010445a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010443e:	c7 44 24 08 a4 98 10 	movl   $0xc01098a4,0x8(%esp)
c0104445:	c0 
c0104446:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010444d:	00 
c010444e:	c7 04 24 c3 98 10 c0 	movl   $0xc01098c3,(%esp)
c0104455:	e8 96 c8 ff ff       	call   c0100cf0 <__panic>
    }
    return &pages[PPN(pa)];
c010445a:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010445f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104462:	c1 ea 0c             	shr    $0xc,%edx
c0104465:	c1 e2 05             	shl    $0x5,%edx
c0104468:	01 d0                	add    %edx,%eax
}
c010446a:	c9                   	leave  
c010446b:	c3                   	ret    

c010446c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010446c:	55                   	push   %ebp
c010446d:	89 e5                	mov    %esp,%ebp
c010446f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104472:	8b 45 08             	mov    0x8(%ebp),%eax
c0104475:	89 04 24             	mov    %eax,(%esp)
c0104478:	e8 94 ff ff ff       	call   c0104411 <page2pa>
c010447d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104483:	c1 e8 0c             	shr    $0xc,%eax
c0104486:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104489:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010448e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104491:	72 23                	jb     c01044b6 <page2kva+0x4a>
c0104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104496:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010449a:	c7 44 24 08 d4 98 10 	movl   $0xc01098d4,0x8(%esp)
c01044a1:	c0 
c01044a2:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01044a9:	00 
c01044aa:	c7 04 24 c3 98 10 c0 	movl   $0xc01098c3,(%esp)
c01044b1:	e8 3a c8 ff ff       	call   c0100cf0 <__panic>
c01044b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044b9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01044be:	c9                   	leave  
c01044bf:	c3                   	ret    

c01044c0 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01044c0:	55                   	push   %ebp
c01044c1:	89 e5                	mov    %esp,%ebp
c01044c3:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01044c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044cc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044d3:	77 23                	ja     c01044f8 <kva2page+0x38>
c01044d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044dc:	c7 44 24 08 f8 98 10 	movl   $0xc01098f8,0x8(%esp)
c01044e3:	c0 
c01044e4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01044eb:	00 
c01044ec:	c7 04 24 c3 98 10 c0 	movl   $0xc01098c3,(%esp)
c01044f3:	e8 f8 c7 ff ff       	call   c0100cf0 <__panic>
c01044f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fb:	05 00 00 00 40       	add    $0x40000000,%eax
c0104500:	89 04 24             	mov    %eax,(%esp)
c0104503:	e8 1f ff ff ff       	call   c0104427 <pa2page>
}
c0104508:	c9                   	leave  
c0104509:	c3                   	ret    

c010450a <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c010450a:	55                   	push   %ebp
c010450b:	89 e5                	mov    %esp,%ebp
c010450d:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104510:	8b 45 08             	mov    0x8(%ebp),%eax
c0104513:	83 e0 01             	and    $0x1,%eax
c0104516:	85 c0                	test   %eax,%eax
c0104518:	75 1c                	jne    c0104536 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010451a:	c7 44 24 08 1c 99 10 	movl   $0xc010991c,0x8(%esp)
c0104521:	c0 
c0104522:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104529:	00 
c010452a:	c7 04 24 c3 98 10 c0 	movl   $0xc01098c3,(%esp)
c0104531:	e8 ba c7 ff ff       	call   c0100cf0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104536:	8b 45 08             	mov    0x8(%ebp),%eax
c0104539:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010453e:	89 04 24             	mov    %eax,(%esp)
c0104541:	e8 e1 fe ff ff       	call   c0104427 <pa2page>
}
c0104546:	c9                   	leave  
c0104547:	c3                   	ret    

c0104548 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104548:	55                   	push   %ebp
c0104549:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010454b:	8b 45 08             	mov    0x8(%ebp),%eax
c010454e:	8b 00                	mov    (%eax),%eax
}
c0104550:	5d                   	pop    %ebp
c0104551:	c3                   	ret    

c0104552 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104552:	55                   	push   %ebp
c0104553:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104555:	8b 45 08             	mov    0x8(%ebp),%eax
c0104558:	8b 55 0c             	mov    0xc(%ebp),%edx
c010455b:	89 10                	mov    %edx,(%eax)
}
c010455d:	5d                   	pop    %ebp
c010455e:	c3                   	ret    

c010455f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010455f:	55                   	push   %ebp
c0104560:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104562:	8b 45 08             	mov    0x8(%ebp),%eax
c0104565:	8b 00                	mov    (%eax),%eax
c0104567:	8d 50 01             	lea    0x1(%eax),%edx
c010456a:	8b 45 08             	mov    0x8(%ebp),%eax
c010456d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010456f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104572:	8b 00                	mov    (%eax),%eax
}
c0104574:	5d                   	pop    %ebp
c0104575:	c3                   	ret    

c0104576 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104576:	55                   	push   %ebp
c0104577:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104579:	8b 45 08             	mov    0x8(%ebp),%eax
c010457c:	8b 00                	mov    (%eax),%eax
c010457e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104581:	8b 45 08             	mov    0x8(%ebp),%eax
c0104584:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104586:	8b 45 08             	mov    0x8(%ebp),%eax
c0104589:	8b 00                	mov    (%eax),%eax
}
c010458b:	5d                   	pop    %ebp
c010458c:	c3                   	ret    

c010458d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010458d:	55                   	push   %ebp
c010458e:	89 e5                	mov    %esp,%ebp
c0104590:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104593:	9c                   	pushf  
c0104594:	58                   	pop    %eax
c0104595:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104598:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010459b:	25 00 02 00 00       	and    $0x200,%eax
c01045a0:	85 c0                	test   %eax,%eax
c01045a2:	74 0c                	je     c01045b0 <__intr_save+0x23>
        intr_disable();
c01045a4:	e8 9f d9 ff ff       	call   c0101f48 <intr_disable>
        return 1;
c01045a9:	b8 01 00 00 00       	mov    $0x1,%eax
c01045ae:	eb 05                	jmp    c01045b5 <__intr_save+0x28>
    }
    return 0;
c01045b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045b5:	c9                   	leave  
c01045b6:	c3                   	ret    

c01045b7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01045b7:	55                   	push   %ebp
c01045b8:	89 e5                	mov    %esp,%ebp
c01045ba:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01045bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01045c1:	74 05                	je     c01045c8 <__intr_restore+0x11>
        intr_enable();
c01045c3:	e8 7a d9 ff ff       	call   c0101f42 <intr_enable>
    }
}
c01045c8:	c9                   	leave  
c01045c9:	c3                   	ret    

c01045ca <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01045ca:	55                   	push   %ebp
c01045cb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01045cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01045d3:	b8 23 00 00 00       	mov    $0x23,%eax
c01045d8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01045da:	b8 23 00 00 00       	mov    $0x23,%eax
c01045df:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01045e1:	b8 10 00 00 00       	mov    $0x10,%eax
c01045e6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01045e8:	b8 10 00 00 00       	mov    $0x10,%eax
c01045ed:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01045ef:	b8 10 00 00 00       	mov    $0x10,%eax
c01045f4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01045f6:	ea fd 45 10 c0 08 00 	ljmp   $0x8,$0xc01045fd
}
c01045fd:	5d                   	pop    %ebp
c01045fe:	c3                   	ret    

c01045ff <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01045ff:	55                   	push   %ebp
c0104600:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104602:	8b 45 08             	mov    0x8(%ebp),%eax
c0104605:	a3 44 1a 12 c0       	mov    %eax,0xc0121a44
}
c010460a:	5d                   	pop    %ebp
c010460b:	c3                   	ret    

c010460c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c010460c:	55                   	push   %ebp
c010460d:	89 e5                	mov    %esp,%ebp
c010460f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104612:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c0104617:	89 04 24             	mov    %eax,(%esp)
c010461a:	e8 e0 ff ff ff       	call   c01045ff <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c010461f:	66 c7 05 48 1a 12 c0 	movw   $0x10,0xc0121a48
c0104626:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104628:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c010462f:	68 00 
c0104631:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104636:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c010463c:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104641:	c1 e8 10             	shr    $0x10,%eax
c0104644:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c0104649:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104650:	83 e0 f0             	and    $0xfffffff0,%eax
c0104653:	83 c8 09             	or     $0x9,%eax
c0104656:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010465b:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104662:	83 e0 ef             	and    $0xffffffef,%eax
c0104665:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010466a:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104671:	83 e0 9f             	and    $0xffffff9f,%eax
c0104674:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104679:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104680:	83 c8 80             	or     $0xffffff80,%eax
c0104683:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104688:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010468f:	83 e0 f0             	and    $0xfffffff0,%eax
c0104692:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104697:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010469e:	83 e0 ef             	and    $0xffffffef,%eax
c01046a1:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01046a6:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01046ad:	83 e0 df             	and    $0xffffffdf,%eax
c01046b0:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01046b5:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01046bc:	83 c8 40             	or     $0x40,%eax
c01046bf:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01046c4:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01046cb:	83 e0 7f             	and    $0x7f,%eax
c01046ce:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01046d3:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c01046d8:	c1 e8 18             	shr    $0x18,%eax
c01046db:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01046e0:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c01046e7:	e8 de fe ff ff       	call   c01045ca <lgdt>
c01046ec:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01046f2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01046f6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01046f9:	c9                   	leave  
c01046fa:	c3                   	ret    

c01046fb <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01046fb:	55                   	push   %ebp
c01046fc:	89 e5                	mov    %esp,%ebp
c01046fe:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104701:	c7 05 cc 1a 12 c0 88 	movl   $0xc0109888,0xc0121acc
c0104708:	98 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010470b:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104710:	8b 00                	mov    (%eax),%eax
c0104712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104716:	c7 04 24 48 99 10 c0 	movl   $0xc0109948,(%esp)
c010471d:	e8 29 bc ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c0104722:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104727:	8b 40 04             	mov    0x4(%eax),%eax
c010472a:	ff d0                	call   *%eax
}
c010472c:	c9                   	leave  
c010472d:	c3                   	ret    

c010472e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010472e:	55                   	push   %ebp
c010472f:	89 e5                	mov    %esp,%ebp
c0104731:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104734:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104739:	8b 40 08             	mov    0x8(%eax),%eax
c010473c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010473f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104743:	8b 55 08             	mov    0x8(%ebp),%edx
c0104746:	89 14 24             	mov    %edx,(%esp)
c0104749:	ff d0                	call   *%eax
}
c010474b:	c9                   	leave  
c010474c:	c3                   	ret    

c010474d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010474d:	55                   	push   %ebp
c010474e:	89 e5                	mov    %esp,%ebp
c0104750:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010475a:	e8 2e fe ff ff       	call   c010458d <__intr_save>
c010475f:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104762:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104767:	8b 40 0c             	mov    0xc(%eax),%eax
c010476a:	8b 55 08             	mov    0x8(%ebp),%edx
c010476d:	89 14 24             	mov    %edx,(%esp)
c0104770:	ff d0                	call   *%eax
c0104772:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104775:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104778:	89 04 24             	mov    %eax,(%esp)
c010477b:	e8 37 fe ff ff       	call   c01045b7 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104784:	75 2d                	jne    c01047b3 <alloc_pages+0x66>
c0104786:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010478a:	77 27                	ja     c01047b3 <alloc_pages+0x66>
c010478c:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0104791:	85 c0                	test   %eax,%eax
c0104793:	74 1e                	je     c01047b3 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104795:	8b 55 08             	mov    0x8(%ebp),%edx
c0104798:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010479d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047a4:	00 
c01047a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047a9:	89 04 24             	mov    %eax,(%esp)
c01047ac:	e8 ac 1a 00 00       	call   c010625d <swap_out>
    }
c01047b1:	eb a7                	jmp    c010475a <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01047b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01047b6:	c9                   	leave  
c01047b7:	c3                   	ret    

c01047b8 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01047b8:	55                   	push   %ebp
c01047b9:	89 e5                	mov    %esp,%ebp
c01047bb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01047be:	e8 ca fd ff ff       	call   c010458d <__intr_save>
c01047c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01047c6:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01047cb:	8b 40 10             	mov    0x10(%eax),%eax
c01047ce:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047d1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01047d8:	89 14 24             	mov    %edx,(%esp)
c01047db:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01047dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e0:	89 04 24             	mov    %eax,(%esp)
c01047e3:	e8 cf fd ff ff       	call   c01045b7 <__intr_restore>
}
c01047e8:	c9                   	leave  
c01047e9:	c3                   	ret    

c01047ea <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01047ea:	55                   	push   %ebp
c01047eb:	89 e5                	mov    %esp,%ebp
c01047ed:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01047f0:	e8 98 fd ff ff       	call   c010458d <__intr_save>
c01047f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01047f8:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01047fd:	8b 40 14             	mov    0x14(%eax),%eax
c0104800:	ff d0                	call   *%eax
c0104802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104808:	89 04 24             	mov    %eax,(%esp)
c010480b:	e8 a7 fd ff ff       	call   c01045b7 <__intr_restore>
    return ret;
c0104810:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104813:	c9                   	leave  
c0104814:	c3                   	ret    

c0104815 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104815:	55                   	push   %ebp
c0104816:	89 e5                	mov    %esp,%ebp
c0104818:	57                   	push   %edi
c0104819:	56                   	push   %esi
c010481a:	53                   	push   %ebx
c010481b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104821:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104828:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010482f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104836:	c7 04 24 5f 99 10 c0 	movl   $0xc010995f,(%esp)
c010483d:	e8 09 bb ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104842:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104849:	e9 15 01 00 00       	jmp    c0104963 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010484e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104851:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104854:	89 d0                	mov    %edx,%eax
c0104856:	c1 e0 02             	shl    $0x2,%eax
c0104859:	01 d0                	add    %edx,%eax
c010485b:	c1 e0 02             	shl    $0x2,%eax
c010485e:	01 c8                	add    %ecx,%eax
c0104860:	8b 50 08             	mov    0x8(%eax),%edx
c0104863:	8b 40 04             	mov    0x4(%eax),%eax
c0104866:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104869:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010486c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010486f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104872:	89 d0                	mov    %edx,%eax
c0104874:	c1 e0 02             	shl    $0x2,%eax
c0104877:	01 d0                	add    %edx,%eax
c0104879:	c1 e0 02             	shl    $0x2,%eax
c010487c:	01 c8                	add    %ecx,%eax
c010487e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104881:	8b 58 10             	mov    0x10(%eax),%ebx
c0104884:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104887:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010488a:	01 c8                	add    %ecx,%eax
c010488c:	11 da                	adc    %ebx,%edx
c010488e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104891:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104894:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104897:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010489a:	89 d0                	mov    %edx,%eax
c010489c:	c1 e0 02             	shl    $0x2,%eax
c010489f:	01 d0                	add    %edx,%eax
c01048a1:	c1 e0 02             	shl    $0x2,%eax
c01048a4:	01 c8                	add    %ecx,%eax
c01048a6:	83 c0 14             	add    $0x14,%eax
c01048a9:	8b 00                	mov    (%eax),%eax
c01048ab:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01048b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01048b4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01048b7:	83 c0 ff             	add    $0xffffffff,%eax
c01048ba:	83 d2 ff             	adc    $0xffffffff,%edx
c01048bd:	89 c6                	mov    %eax,%esi
c01048bf:	89 d7                	mov    %edx,%edi
c01048c1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048c7:	89 d0                	mov    %edx,%eax
c01048c9:	c1 e0 02             	shl    $0x2,%eax
c01048cc:	01 d0                	add    %edx,%eax
c01048ce:	c1 e0 02             	shl    $0x2,%eax
c01048d1:	01 c8                	add    %ecx,%eax
c01048d3:	8b 48 0c             	mov    0xc(%eax),%ecx
c01048d6:	8b 58 10             	mov    0x10(%eax),%ebx
c01048d9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01048df:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01048e3:	89 74 24 14          	mov    %esi,0x14(%esp)
c01048e7:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01048eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01048ee:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048f5:	89 54 24 10          	mov    %edx,0x10(%esp)
c01048f9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01048fd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104901:	c7 04 24 6c 99 10 c0 	movl   $0xc010996c,(%esp)
c0104908:	e8 3e ba ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010490d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104910:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104913:	89 d0                	mov    %edx,%eax
c0104915:	c1 e0 02             	shl    $0x2,%eax
c0104918:	01 d0                	add    %edx,%eax
c010491a:	c1 e0 02             	shl    $0x2,%eax
c010491d:	01 c8                	add    %ecx,%eax
c010491f:	83 c0 14             	add    $0x14,%eax
c0104922:	8b 00                	mov    (%eax),%eax
c0104924:	83 f8 01             	cmp    $0x1,%eax
c0104927:	75 36                	jne    c010495f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104929:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010492c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010492f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104932:	77 2b                	ja     c010495f <page_init+0x14a>
c0104934:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104937:	72 05                	jb     c010493e <page_init+0x129>
c0104939:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010493c:	73 21                	jae    c010495f <page_init+0x14a>
c010493e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104942:	77 1b                	ja     c010495f <page_init+0x14a>
c0104944:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104948:	72 09                	jb     c0104953 <page_init+0x13e>
c010494a:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104951:	77 0c                	ja     c010495f <page_init+0x14a>
                maxpa = end;
c0104953:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104956:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104959:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010495c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010495f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104963:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104966:	8b 00                	mov    (%eax),%eax
c0104968:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010496b:	0f 8f dd fe ff ff    	jg     c010484e <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104971:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104975:	72 1d                	jb     c0104994 <page_init+0x17f>
c0104977:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010497b:	77 09                	ja     c0104986 <page_init+0x171>
c010497d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104984:	76 0e                	jbe    c0104994 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104986:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010498d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104994:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104997:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010499a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010499e:	c1 ea 0c             	shr    $0xc,%edx
c01049a1:	a3 20 1a 12 c0       	mov    %eax,0xc0121a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01049a6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01049ad:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c01049b2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01049b5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01049b8:	01 d0                	add    %edx,%eax
c01049ba:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01049bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01049c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01049c5:	f7 75 ac             	divl   -0x54(%ebp)
c01049c8:	89 d0                	mov    %edx,%eax
c01049ca:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01049cd:	29 c2                	sub    %eax,%edx
c01049cf:	89 d0                	mov    %edx,%eax
c01049d1:	a3 d4 1a 12 c0       	mov    %eax,0xc0121ad4

    for (i = 0; i < npage; i ++) {
c01049d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01049dd:	eb 27                	jmp    c0104a06 <page_init+0x1f1>
        SetPageReserved(pages + i);
c01049df:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01049e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049e7:	c1 e2 05             	shl    $0x5,%edx
c01049ea:	01 d0                	add    %edx,%eax
c01049ec:	83 c0 04             	add    $0x4,%eax
c01049ef:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01049f6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01049f9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01049fc:	8b 55 90             	mov    -0x70(%ebp),%edx
c01049ff:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104a02:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104a06:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a09:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104a0e:	39 c2                	cmp    %eax,%edx
c0104a10:	72 cd                	jb     c01049df <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104a12:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104a17:	c1 e0 05             	shl    $0x5,%eax
c0104a1a:	89 c2                	mov    %eax,%edx
c0104a1c:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104a21:	01 d0                	add    %edx,%eax
c0104a23:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104a26:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104a2d:	77 23                	ja     c0104a52 <page_init+0x23d>
c0104a2f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a32:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a36:	c7 44 24 08 f8 98 10 	movl   $0xc01098f8,0x8(%esp)
c0104a3d:	c0 
c0104a3e:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104a45:	00 
c0104a46:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104a4d:	e8 9e c2 ff ff       	call   c0100cf0 <__panic>
c0104a52:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a55:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a5a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104a5d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104a64:	e9 74 01 00 00       	jmp    c0104bdd <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104a69:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a6f:	89 d0                	mov    %edx,%eax
c0104a71:	c1 e0 02             	shl    $0x2,%eax
c0104a74:	01 d0                	add    %edx,%eax
c0104a76:	c1 e0 02             	shl    $0x2,%eax
c0104a79:	01 c8                	add    %ecx,%eax
c0104a7b:	8b 50 08             	mov    0x8(%eax),%edx
c0104a7e:	8b 40 04             	mov    0x4(%eax),%eax
c0104a81:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a87:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a8d:	89 d0                	mov    %edx,%eax
c0104a8f:	c1 e0 02             	shl    $0x2,%eax
c0104a92:	01 d0                	add    %edx,%eax
c0104a94:	c1 e0 02             	shl    $0x2,%eax
c0104a97:	01 c8                	add    %ecx,%eax
c0104a99:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104a9c:	8b 58 10             	mov    0x10(%eax),%ebx
c0104a9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104aa2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104aa5:	01 c8                	add    %ecx,%eax
c0104aa7:	11 da                	adc    %ebx,%edx
c0104aa9:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104aac:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104aaf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ab2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ab5:	89 d0                	mov    %edx,%eax
c0104ab7:	c1 e0 02             	shl    $0x2,%eax
c0104aba:	01 d0                	add    %edx,%eax
c0104abc:	c1 e0 02             	shl    $0x2,%eax
c0104abf:	01 c8                	add    %ecx,%eax
c0104ac1:	83 c0 14             	add    $0x14,%eax
c0104ac4:	8b 00                	mov    (%eax),%eax
c0104ac6:	83 f8 01             	cmp    $0x1,%eax
c0104ac9:	0f 85 0a 01 00 00    	jne    c0104bd9 <page_init+0x3c4>
            if (begin < freemem) {
c0104acf:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104ad2:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ad7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104ada:	72 17                	jb     c0104af3 <page_init+0x2de>
c0104adc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104adf:	77 05                	ja     c0104ae6 <page_init+0x2d1>
c0104ae1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104ae4:	76 0d                	jbe    c0104af3 <page_init+0x2de>
                begin = freemem;
c0104ae6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104ae9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104aec:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104af3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104af7:	72 1d                	jb     c0104b16 <page_init+0x301>
c0104af9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104afd:	77 09                	ja     c0104b08 <page_init+0x2f3>
c0104aff:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104b06:	76 0e                	jbe    c0104b16 <page_init+0x301>
                end = KMEMSIZE;
c0104b08:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104b0f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104b16:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b19:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b1c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b1f:	0f 87 b4 00 00 00    	ja     c0104bd9 <page_init+0x3c4>
c0104b25:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b28:	72 09                	jb     c0104b33 <page_init+0x31e>
c0104b2a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104b2d:	0f 83 a6 00 00 00    	jae    c0104bd9 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104b33:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104b3a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b3d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104b40:	01 d0                	add    %edx,%eax
c0104b42:	83 e8 01             	sub    $0x1,%eax
c0104b45:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104b48:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104b4b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b50:	f7 75 9c             	divl   -0x64(%ebp)
c0104b53:	89 d0                	mov    %edx,%eax
c0104b55:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104b58:	29 c2                	sub    %eax,%edx
c0104b5a:	89 d0                	mov    %edx,%eax
c0104b5c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b61:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b6a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104b6d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104b70:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b75:	89 c7                	mov    %eax,%edi
c0104b77:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104b7d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104b80:	89 d0                	mov    %edx,%eax
c0104b82:	83 e0 00             	and    $0x0,%eax
c0104b85:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104b88:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104b8b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104b8e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b91:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104b94:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b9a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b9d:	77 3a                	ja     c0104bd9 <page_init+0x3c4>
c0104b9f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104ba2:	72 05                	jb     c0104ba9 <page_init+0x394>
c0104ba4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104ba7:	73 30                	jae    c0104bd9 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104ba9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104bac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104bb2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104bb5:	29 c8                	sub    %ecx,%eax
c0104bb7:	19 da                	sbb    %ebx,%edx
c0104bb9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104bbd:	c1 ea 0c             	shr    $0xc,%edx
c0104bc0:	89 c3                	mov    %eax,%ebx
c0104bc2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bc5:	89 04 24             	mov    %eax,(%esp)
c0104bc8:	e8 5a f8 ff ff       	call   c0104427 <pa2page>
c0104bcd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104bd1:	89 04 24             	mov    %eax,(%esp)
c0104bd4:	e8 55 fb ff ff       	call   c010472e <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104bd9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104bdd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104be0:	8b 00                	mov    (%eax),%eax
c0104be2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104be5:	0f 8f 7e fe ff ff    	jg     c0104a69 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104beb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104bf1:	5b                   	pop    %ebx
c0104bf2:	5e                   	pop    %esi
c0104bf3:	5f                   	pop    %edi
c0104bf4:	5d                   	pop    %ebp
c0104bf5:	c3                   	ret    

c0104bf6 <enable_paging>:

static void
enable_paging(void) {
c0104bf6:	55                   	push   %ebp
c0104bf7:	89 e5                	mov    %esp,%ebp
c0104bf9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104bfc:	a1 d0 1a 12 c0       	mov    0xc0121ad0,%eax
c0104c01:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104c04:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104c07:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104c0a:	0f 20 c0             	mov    %cr0,%eax
c0104c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104c10:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104c13:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104c16:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104c1d:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c2a:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104c2d:	c9                   	leave  
c0104c2e:	c3                   	ret    

c0104c2f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104c2f:	55                   	push   %ebp
c0104c30:	89 e5                	mov    %esp,%ebp
c0104c32:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104c35:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c38:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c3b:	31 d0                	xor    %edx,%eax
c0104c3d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c42:	85 c0                	test   %eax,%eax
c0104c44:	74 24                	je     c0104c6a <boot_map_segment+0x3b>
c0104c46:	c7 44 24 0c aa 99 10 	movl   $0xc01099aa,0xc(%esp)
c0104c4d:	c0 
c0104c4e:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0104c55:	c0 
c0104c56:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104c5d:	00 
c0104c5e:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104c65:	e8 86 c0 ff ff       	call   c0100cf0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104c6a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104c71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c74:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c79:	89 c2                	mov    %eax,%edx
c0104c7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c7e:	01 c2                	add    %eax,%edx
c0104c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c83:	01 d0                	add    %edx,%eax
c0104c85:	83 e8 01             	sub    $0x1,%eax
c0104c88:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c8e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c93:	f7 75 f0             	divl   -0x10(%ebp)
c0104c96:	89 d0                	mov    %edx,%eax
c0104c98:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104c9b:	29 c2                	sub    %eax,%edx
c0104c9d:	89 d0                	mov    %edx,%eax
c0104c9f:	c1 e8 0c             	shr    $0xc,%eax
c0104ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ca8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104cb3:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104cb6:	8b 45 14             	mov    0x14(%ebp),%eax
c0104cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104cc4:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104cc7:	eb 6b                	jmp    c0104d34 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104cc9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104cd0:	00 
c0104cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cdb:	89 04 24             	mov    %eax,(%esp)
c0104cde:	e8 cc 01 00 00       	call   c0104eaf <get_pte>
c0104ce3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104ce6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104cea:	75 24                	jne    c0104d10 <boot_map_segment+0xe1>
c0104cec:	c7 44 24 0c d6 99 10 	movl   $0xc01099d6,0xc(%esp)
c0104cf3:	c0 
c0104cf4:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0104cfb:	c0 
c0104cfc:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104d03:	00 
c0104d04:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104d0b:	e8 e0 bf ff ff       	call   c0100cf0 <__panic>
        *ptep = pa | PTE_P | perm;
c0104d10:	8b 45 18             	mov    0x18(%ebp),%eax
c0104d13:	8b 55 14             	mov    0x14(%ebp),%edx
c0104d16:	09 d0                	or     %edx,%eax
c0104d18:	83 c8 01             	or     $0x1,%eax
c0104d1b:	89 c2                	mov    %eax,%edx
c0104d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d20:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104d22:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104d26:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104d2d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d38:	75 8f                	jne    c0104cc9 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104d3a:	c9                   	leave  
c0104d3b:	c3                   	ret    

c0104d3c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104d3c:	55                   	push   %ebp
c0104d3d:	89 e5                	mov    %esp,%ebp
c0104d3f:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104d42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d49:	e8 ff f9 ff ff       	call   c010474d <alloc_pages>
c0104d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d55:	75 1c                	jne    c0104d73 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104d57:	c7 44 24 08 e3 99 10 	movl   $0xc01099e3,0x8(%esp)
c0104d5e:	c0 
c0104d5f:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104d66:	00 
c0104d67:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104d6e:	e8 7d bf ff ff       	call   c0100cf0 <__panic>
    }
    return page2kva(p);
c0104d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d76:	89 04 24             	mov    %eax,(%esp)
c0104d79:	e8 ee f6 ff ff       	call   c010446c <page2kva>
}
c0104d7e:	c9                   	leave  
c0104d7f:	c3                   	ret    

c0104d80 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104d80:	55                   	push   %ebp
c0104d81:	89 e5                	mov    %esp,%ebp
c0104d83:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104d86:	e8 70 f9 ff ff       	call   c01046fb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104d8b:	e8 85 fa ff ff       	call   c0104815 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104d90:	e8 46 05 00 00       	call   c01052db <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104d95:	e8 a2 ff ff ff       	call   c0104d3c <boot_alloc_page>
c0104d9a:	a3 24 1a 12 c0       	mov    %eax,0xc0121a24
    memset(boot_pgdir, 0, PGSIZE);
c0104d9f:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104da4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104dab:	00 
c0104dac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104db3:	00 
c0104db4:	89 04 24             	mov    %eax,(%esp)
c0104db7:	e8 23 3d 00 00       	call   c0108adf <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104dbc:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dc4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104dcb:	77 23                	ja     c0104df0 <pmm_init+0x70>
c0104dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104dd4:	c7 44 24 08 f8 98 10 	movl   $0xc01098f8,0x8(%esp)
c0104ddb:	c0 
c0104ddc:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104de3:	00 
c0104de4:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104deb:	e8 00 bf ff ff       	call   c0100cf0 <__panic>
c0104df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df3:	05 00 00 00 40       	add    $0x40000000,%eax
c0104df8:	a3 d0 1a 12 c0       	mov    %eax,0xc0121ad0

    check_pgdir();
c0104dfd:	e8 f7 04 00 00       	call   c01052f9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104e02:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e07:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104e0d:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e15:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104e1c:	77 23                	ja     c0104e41 <pmm_init+0xc1>
c0104e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e21:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e25:	c7 44 24 08 f8 98 10 	movl   $0xc01098f8,0x8(%esp)
c0104e2c:	c0 
c0104e2d:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104e34:	00 
c0104e35:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104e3c:	e8 af be ff ff       	call   c0100cf0 <__panic>
c0104e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e44:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e49:	83 c8 03             	or     $0x3,%eax
c0104e4c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104e4e:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e53:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104e5a:	00 
c0104e5b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e62:	00 
c0104e63:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104e6a:	38 
c0104e6b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104e72:	c0 
c0104e73:	89 04 24             	mov    %eax,(%esp)
c0104e76:	e8 b4 fd ff ff       	call   c0104c2f <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104e7b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e80:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0104e86:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104e8c:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104e8e:	e8 63 fd ff ff       	call   c0104bf6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104e93:	e8 74 f7 ff ff       	call   c010460c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104e98:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104ea3:	e8 ec 0a 00 00       	call   c0105994 <check_boot_pgdir>

    print_pgdir();
c0104ea8:	e8 79 0f 00 00       	call   c0105e26 <print_pgdir>

}
c0104ead:	c9                   	leave  
c0104eae:	c3                   	ret    

c0104eaf <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104eaf:	55                   	push   %ebp
c0104eb0:	89 e5                	mov    %esp,%ebp
c0104eb2:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = &pgdir[PDX(la)];
c0104eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104eb8:	c1 e8 16             	shr    $0x16,%eax
c0104ebb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104ec2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ec5:	01 d0                	add    %edx,%eax
c0104ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!(*pdep & PTE_P)){
c0104eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ecd:	8b 00                	mov    (%eax),%eax
c0104ecf:	83 e0 01             	and    $0x1,%eax
c0104ed2:	85 c0                	test   %eax,%eax
c0104ed4:	0f 85 b6 00 00 00    	jne    c0104f90 <get_pte+0xe1>
        struct  Page *p = NULL;
c0104eda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        if(create)
c0104ee1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104ee5:	74 0f                	je     c0104ef6 <get_pte+0x47>
            p = alloc_page();
c0104ee7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104eee:	e8 5a f8 ff ff       	call   c010474d <alloc_pages>
c0104ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p == NULL)
c0104ef6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104efa:	75 0a                	jne    c0104f06 <get_pte+0x57>
            return NULL;
c0104efc:	b8 00 00 00 00       	mov    $0x0,%eax
c0104f01:	e9 ef 00 00 00       	jmp    c0104ff5 <get_pte+0x146>
        set_page_ref(p, 1);
c0104f06:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f0d:	00 
c0104f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f11:	89 04 24             	mov    %eax,(%esp)
c0104f14:	e8 39 f6 ff ff       	call   c0104552 <set_page_ref>
        uintptr_t pa = page2pa(p);
c0104f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f1c:	89 04 24             	mov    %eax,(%esp)
c0104f1f:	e8 ed f4 ff ff       	call   c0104411 <page2pa>
c0104f24:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f30:	c1 e8 0c             	shr    $0xc,%eax
c0104f33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f36:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104f3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104f3e:	72 23                	jb     c0104f63 <get_pte+0xb4>
c0104f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f43:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f47:	c7 44 24 08 d4 98 10 	movl   $0xc01098d4,0x8(%esp)
c0104f4e:	c0 
c0104f4f:	c7 44 24 04 95 01 00 	movl   $0x195,0x4(%esp)
c0104f56:	00 
c0104f57:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104f5e:	e8 8d bd ff ff       	call   c0100cf0 <__panic>
c0104f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f66:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f6b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104f72:	00 
c0104f73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f7a:	00 
c0104f7b:	89 04 24             	mov    %eax,(%esp)
c0104f7e:	e8 5c 3b 00 00       	call   c0108adf <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f86:	83 c8 07             	or     $0x7,%eax
c0104f89:	89 c2                	mov    %eax,%edx
c0104f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f8e:	89 10                	mov    %edx,(%eax)
    }
    pde_t *a = (pte_t*)KADDR(PDE_ADDR(*pdep));
c0104f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f93:	8b 00                	mov    (%eax),%eax
c0104f95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa0:	c1 e8 0c             	shr    $0xc,%eax
c0104fa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104fa6:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104fab:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104fae:	72 23                	jb     c0104fd3 <get_pte+0x124>
c0104fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fb7:	c7 44 24 08 d4 98 10 	movl   $0xc01098d4,0x8(%esp)
c0104fbe:	c0 
c0104fbf:	c7 44 24 04 98 01 00 	movl   $0x198,0x4(%esp)
c0104fc6:	00 
c0104fc7:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0104fce:	e8 1d bd ff ff       	call   c0100cf0 <__panic>
c0104fd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fd6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104fdb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return &a[PTX(la)];
c0104fde:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fe1:	c1 e8 0c             	shr    $0xc,%eax
c0104fe4:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104fe9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104ff0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ff3:	01 d0                	add    %edx,%eax
}
c0104ff5:	c9                   	leave  
c0104ff6:	c3                   	ret    

c0104ff7 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104ff7:	55                   	push   %ebp
c0104ff8:	89 e5                	mov    %esp,%ebp
c0104ffa:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104ffd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105004:	00 
c0105005:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105008:	89 44 24 04          	mov    %eax,0x4(%esp)
c010500c:	8b 45 08             	mov    0x8(%ebp),%eax
c010500f:	89 04 24             	mov    %eax,(%esp)
c0105012:	e8 98 fe ff ff       	call   c0104eaf <get_pte>
c0105017:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010501a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010501e:	74 08                	je     c0105028 <get_page+0x31>
        *ptep_store = ptep;
c0105020:	8b 45 10             	mov    0x10(%ebp),%eax
c0105023:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105026:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010502c:	74 1b                	je     c0105049 <get_page+0x52>
c010502e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105031:	8b 00                	mov    (%eax),%eax
c0105033:	83 e0 01             	and    $0x1,%eax
c0105036:	85 c0                	test   %eax,%eax
c0105038:	74 0f                	je     c0105049 <get_page+0x52>
        return pa2page(*ptep);
c010503a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010503d:	8b 00                	mov    (%eax),%eax
c010503f:	89 04 24             	mov    %eax,(%esp)
c0105042:	e8 e0 f3 ff ff       	call   c0104427 <pa2page>
c0105047:	eb 05                	jmp    c010504e <get_page+0x57>
    }
    return NULL;
c0105049:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010504e:	c9                   	leave  
c010504f:	c3                   	ret    

c0105050 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105050:	55                   	push   %ebp
c0105051:	89 e5                	mov    %esp,%ebp
c0105053:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	if(*ptep & PTE_P){
c0105056:	8b 45 10             	mov    0x10(%ebp),%eax
c0105059:	8b 00                	mov    (%eax),%eax
c010505b:	83 e0 01             	and    $0x1,%eax
c010505e:	85 c0                	test   %eax,%eax
c0105060:	74 52                	je     c01050b4 <page_remove_pte+0x64>
        struct Page *p = pte2page(*ptep);
c0105062:	8b 45 10             	mov    0x10(%ebp),%eax
c0105065:	8b 00                	mov    (%eax),%eax
c0105067:	89 04 24             	mov    %eax,(%esp)
c010506a:	e8 9b f4 ff ff       	call   c010450a <pte2page>
c010506f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(p);
c0105072:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105075:	89 04 24             	mov    %eax,(%esp)
c0105078:	e8 f9 f4 ff ff       	call   c0104576 <page_ref_dec>
        if(p->ref == 0)
c010507d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105080:	8b 00                	mov    (%eax),%eax
c0105082:	85 c0                	test   %eax,%eax
c0105084:	75 13                	jne    c0105099 <page_remove_pte+0x49>
            free_page(p);
c0105086:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010508d:	00 
c010508e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105091:	89 04 24             	mov    %eax,(%esp)
c0105094:	e8 1f f7 ff ff       	call   c01047b8 <free_pages>
        *ptep = 0;
c0105099:	8b 45 10             	mov    0x10(%ebp),%eax
c010509c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01050a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ac:	89 04 24             	mov    %eax,(%esp)
c01050af:	e8 ff 00 00 00       	call   c01051b3 <tlb_invalidate>
    }
}
c01050b4:	c9                   	leave  
c01050b5:	c3                   	ret    

c01050b6 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01050b6:	55                   	push   %ebp
c01050b7:	89 e5                	mov    %esp,%ebp
c01050b9:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01050bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050c3:	00 
c01050c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ce:	89 04 24             	mov    %eax,(%esp)
c01050d1:	e8 d9 fd ff ff       	call   c0104eaf <get_pte>
c01050d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01050d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050dd:	74 19                	je     c01050f8 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01050df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f0:	89 04 24             	mov    %eax,(%esp)
c01050f3:	e8 58 ff ff ff       	call   c0105050 <page_remove_pte>
    }
}
c01050f8:	c9                   	leave  
c01050f9:	c3                   	ret    

c01050fa <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01050fa:	55                   	push   %ebp
c01050fb:	89 e5                	mov    %esp,%ebp
c01050fd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105100:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105107:	00 
c0105108:	8b 45 10             	mov    0x10(%ebp),%eax
c010510b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010510f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105112:	89 04 24             	mov    %eax,(%esp)
c0105115:	e8 95 fd ff ff       	call   c0104eaf <get_pte>
c010511a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010511d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105121:	75 0a                	jne    c010512d <page_insert+0x33>
        return -E_NO_MEM;
c0105123:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105128:	e9 84 00 00 00       	jmp    c01051b1 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010512d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105130:	89 04 24             	mov    %eax,(%esp)
c0105133:	e8 27 f4 ff ff       	call   c010455f <page_ref_inc>
    if (*ptep & PTE_P) {
c0105138:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010513b:	8b 00                	mov    (%eax),%eax
c010513d:	83 e0 01             	and    $0x1,%eax
c0105140:	85 c0                	test   %eax,%eax
c0105142:	74 3e                	je     c0105182 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105144:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105147:	8b 00                	mov    (%eax),%eax
c0105149:	89 04 24             	mov    %eax,(%esp)
c010514c:	e8 b9 f3 ff ff       	call   c010450a <pte2page>
c0105151:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105154:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105157:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010515a:	75 0d                	jne    c0105169 <page_insert+0x6f>
            page_ref_dec(page);
c010515c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010515f:	89 04 24             	mov    %eax,(%esp)
c0105162:	e8 0f f4 ff ff       	call   c0104576 <page_ref_dec>
c0105167:	eb 19                	jmp    c0105182 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105169:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010516c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105170:	8b 45 10             	mov    0x10(%ebp),%eax
c0105173:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105177:	8b 45 08             	mov    0x8(%ebp),%eax
c010517a:	89 04 24             	mov    %eax,(%esp)
c010517d:	e8 ce fe ff ff       	call   c0105050 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105182:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105185:	89 04 24             	mov    %eax,(%esp)
c0105188:	e8 84 f2 ff ff       	call   c0104411 <page2pa>
c010518d:	0b 45 14             	or     0x14(%ebp),%eax
c0105190:	83 c8 01             	or     $0x1,%eax
c0105193:	89 c2                	mov    %eax,%edx
c0105195:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105198:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010519a:	8b 45 10             	mov    0x10(%ebp),%eax
c010519d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a4:	89 04 24             	mov    %eax,(%esp)
c01051a7:	e8 07 00 00 00       	call   c01051b3 <tlb_invalidate>
    return 0;
c01051ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01051b1:	c9                   	leave  
c01051b2:	c3                   	ret    

c01051b3 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01051b3:	55                   	push   %ebp
c01051b4:	89 e5                	mov    %esp,%ebp
c01051b6:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01051b9:	0f 20 d8             	mov    %cr3,%eax
c01051bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01051bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01051c2:	89 c2                	mov    %eax,%edx
c01051c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051ca:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01051d1:	77 23                	ja     c01051f6 <tlb_invalidate+0x43>
c01051d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051da:	c7 44 24 08 f8 98 10 	movl   $0xc01098f8,0x8(%esp)
c01051e1:	c0 
c01051e2:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c01051e9:	00 
c01051ea:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01051f1:	e8 fa ba ff ff       	call   c0100cf0 <__panic>
c01051f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051f9:	05 00 00 00 40       	add    $0x40000000,%eax
c01051fe:	39 c2                	cmp    %eax,%edx
c0105200:	75 0c                	jne    c010520e <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105202:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105205:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105208:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010520b:	0f 01 38             	invlpg (%eax)
    }
}
c010520e:	c9                   	leave  
c010520f:	c3                   	ret    

c0105210 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105210:	55                   	push   %ebp
c0105211:	89 e5                	mov    %esp,%ebp
c0105213:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105216:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010521d:	e8 2b f5 ff ff       	call   c010474d <alloc_pages>
c0105222:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105229:	0f 84 a7 00 00 00    	je     c01052d6 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010522f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105232:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105239:	89 44 24 08          	mov    %eax,0x8(%esp)
c010523d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105240:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105244:	8b 45 08             	mov    0x8(%ebp),%eax
c0105247:	89 04 24             	mov    %eax,(%esp)
c010524a:	e8 ab fe ff ff       	call   c01050fa <page_insert>
c010524f:	85 c0                	test   %eax,%eax
c0105251:	74 1a                	je     c010526d <pgdir_alloc_page+0x5d>
            free_page(page);
c0105253:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010525a:	00 
c010525b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010525e:	89 04 24             	mov    %eax,(%esp)
c0105261:	e8 52 f5 ff ff       	call   c01047b8 <free_pages>
            return NULL;
c0105266:	b8 00 00 00 00       	mov    $0x0,%eax
c010526b:	eb 6c                	jmp    c01052d9 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c010526d:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0105272:	85 c0                	test   %eax,%eax
c0105274:	74 60                	je     c01052d6 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105276:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c010527b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105282:	00 
c0105283:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105286:	89 54 24 08          	mov    %edx,0x8(%esp)
c010528a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010528d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105291:	89 04 24             	mov    %eax,(%esp)
c0105294:	e8 78 0f 00 00       	call   c0106211 <swap_map_swappable>
            page->pra_vaddr=la;
c0105299:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010529c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010529f:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01052a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052a5:	89 04 24             	mov    %eax,(%esp)
c01052a8:	e8 9b f2 ff ff       	call   c0104548 <page_ref>
c01052ad:	83 f8 01             	cmp    $0x1,%eax
c01052b0:	74 24                	je     c01052d6 <pgdir_alloc_page+0xc6>
c01052b2:	c7 44 24 0c fc 99 10 	movl   $0xc01099fc,0xc(%esp)
c01052b9:	c0 
c01052ba:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01052c1:	c0 
c01052c2:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01052c9:	00 
c01052ca:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01052d1:	e8 1a ba ff ff       	call   c0100cf0 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01052d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01052d9:	c9                   	leave  
c01052da:	c3                   	ret    

c01052db <check_alloc_page>:

static void
check_alloc_page(void) {
c01052db:	55                   	push   %ebp
c01052dc:	89 e5                	mov    %esp,%ebp
c01052de:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01052e1:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01052e6:	8b 40 18             	mov    0x18(%eax),%eax
c01052e9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01052eb:	c7 04 24 10 9a 10 c0 	movl   $0xc0109a10,(%esp)
c01052f2:	e8 54 b0 ff ff       	call   c010034b <cprintf>
}
c01052f7:	c9                   	leave  
c01052f8:	c3                   	ret    

c01052f9 <check_pgdir>:

static void
check_pgdir(void) {
c01052f9:	55                   	push   %ebp
c01052fa:	89 e5                	mov    %esp,%ebp
c01052fc:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01052ff:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105304:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105309:	76 24                	jbe    c010532f <check_pgdir+0x36>
c010530b:	c7 44 24 0c 2f 9a 10 	movl   $0xc0109a2f,0xc(%esp)
c0105312:	c0 
c0105313:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010531a:	c0 
c010531b:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0105322:	00 
c0105323:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c010532a:	e8 c1 b9 ff ff       	call   c0100cf0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010532f:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105334:	85 c0                	test   %eax,%eax
c0105336:	74 0e                	je     c0105346 <check_pgdir+0x4d>
c0105338:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010533d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105342:	85 c0                	test   %eax,%eax
c0105344:	74 24                	je     c010536a <check_pgdir+0x71>
c0105346:	c7 44 24 0c 4c 9a 10 	movl   $0xc0109a4c,0xc(%esp)
c010534d:	c0 
c010534e:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105355:	c0 
c0105356:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c010535d:	00 
c010535e:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105365:	e8 86 b9 ff ff       	call   c0100cf0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010536a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010536f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105376:	00 
c0105377:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010537e:	00 
c010537f:	89 04 24             	mov    %eax,(%esp)
c0105382:	e8 70 fc ff ff       	call   c0104ff7 <get_page>
c0105387:	85 c0                	test   %eax,%eax
c0105389:	74 24                	je     c01053af <check_pgdir+0xb6>
c010538b:	c7 44 24 0c 84 9a 10 	movl   $0xc0109a84,0xc(%esp)
c0105392:	c0 
c0105393:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010539a:	c0 
c010539b:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c01053a2:	00 
c01053a3:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01053aa:	e8 41 b9 ff ff       	call   c0100cf0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01053af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053b6:	e8 92 f3 ff ff       	call   c010474d <alloc_pages>
c01053bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01053be:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01053c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01053ca:	00 
c01053cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053d2:	00 
c01053d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053da:	89 04 24             	mov    %eax,(%esp)
c01053dd:	e8 18 fd ff ff       	call   c01050fa <page_insert>
c01053e2:	85 c0                	test   %eax,%eax
c01053e4:	74 24                	je     c010540a <check_pgdir+0x111>
c01053e6:	c7 44 24 0c ac 9a 10 	movl   $0xc0109aac,0xc(%esp)
c01053ed:	c0 
c01053ee:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01053f5:	c0 
c01053f6:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c01053fd:	00 
c01053fe:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105405:	e8 e6 b8 ff ff       	call   c0100cf0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010540a:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010540f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105416:	00 
c0105417:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010541e:	00 
c010541f:	89 04 24             	mov    %eax,(%esp)
c0105422:	e8 88 fa ff ff       	call   c0104eaf <get_pte>
c0105427:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010542a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010542e:	75 24                	jne    c0105454 <check_pgdir+0x15b>
c0105430:	c7 44 24 0c d8 9a 10 	movl   $0xc0109ad8,0xc(%esp)
c0105437:	c0 
c0105438:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010543f:	c0 
c0105440:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105447:	00 
c0105448:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c010544f:	e8 9c b8 ff ff       	call   c0100cf0 <__panic>
    assert(pa2page(*ptep) == p1);
c0105454:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105457:	8b 00                	mov    (%eax),%eax
c0105459:	89 04 24             	mov    %eax,(%esp)
c010545c:	e8 c6 ef ff ff       	call   c0104427 <pa2page>
c0105461:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105464:	74 24                	je     c010548a <check_pgdir+0x191>
c0105466:	c7 44 24 0c 05 9b 10 	movl   $0xc0109b05,0xc(%esp)
c010546d:	c0 
c010546e:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105475:	c0 
c0105476:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c010547d:	00 
c010547e:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105485:	e8 66 b8 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p1) == 1);
c010548a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010548d:	89 04 24             	mov    %eax,(%esp)
c0105490:	e8 b3 f0 ff ff       	call   c0104548 <page_ref>
c0105495:	83 f8 01             	cmp    $0x1,%eax
c0105498:	74 24                	je     c01054be <check_pgdir+0x1c5>
c010549a:	c7 44 24 0c 1a 9b 10 	movl   $0xc0109b1a,0xc(%esp)
c01054a1:	c0 
c01054a2:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01054a9:	c0 
c01054aa:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01054b1:	00 
c01054b2:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01054b9:	e8 32 b8 ff ff       	call   c0100cf0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01054be:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01054c3:	8b 00                	mov    (%eax),%eax
c01054c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01054ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054d0:	c1 e8 0c             	shr    $0xc,%eax
c01054d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054d6:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01054db:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01054de:	72 23                	jb     c0105503 <check_pgdir+0x20a>
c01054e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054e7:	c7 44 24 08 d4 98 10 	movl   $0xc01098d4,0x8(%esp)
c01054ee:	c0 
c01054ef:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c01054f6:	00 
c01054f7:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01054fe:	e8 ed b7 ff ff       	call   c0100cf0 <__panic>
c0105503:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105506:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010550b:	83 c0 04             	add    $0x4,%eax
c010550e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105511:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105516:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010551d:	00 
c010551e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105525:	00 
c0105526:	89 04 24             	mov    %eax,(%esp)
c0105529:	e8 81 f9 ff ff       	call   c0104eaf <get_pte>
c010552e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105531:	74 24                	je     c0105557 <check_pgdir+0x25e>
c0105533:	c7 44 24 0c 2c 9b 10 	movl   $0xc0109b2c,0xc(%esp)
c010553a:	c0 
c010553b:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105542:	c0 
c0105543:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c010554a:	00 
c010554b:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105552:	e8 99 b7 ff ff       	call   c0100cf0 <__panic>

    p2 = alloc_page();
c0105557:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010555e:	e8 ea f1 ff ff       	call   c010474d <alloc_pages>
c0105563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105566:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010556b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105572:	00 
c0105573:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010557a:	00 
c010557b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010557e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105582:	89 04 24             	mov    %eax,(%esp)
c0105585:	e8 70 fb ff ff       	call   c01050fa <page_insert>
c010558a:	85 c0                	test   %eax,%eax
c010558c:	74 24                	je     c01055b2 <check_pgdir+0x2b9>
c010558e:	c7 44 24 0c 54 9b 10 	movl   $0xc0109b54,0xc(%esp)
c0105595:	c0 
c0105596:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010559d:	c0 
c010559e:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01055a5:	00 
c01055a6:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01055ad:	e8 3e b7 ff ff       	call   c0100cf0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01055b2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01055b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055be:	00 
c01055bf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01055c6:	00 
c01055c7:	89 04 24             	mov    %eax,(%esp)
c01055ca:	e8 e0 f8 ff ff       	call   c0104eaf <get_pte>
c01055cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055d6:	75 24                	jne    c01055fc <check_pgdir+0x303>
c01055d8:	c7 44 24 0c 8c 9b 10 	movl   $0xc0109b8c,0xc(%esp)
c01055df:	c0 
c01055e0:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01055e7:	c0 
c01055e8:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01055ef:	00 
c01055f0:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01055f7:	e8 f4 b6 ff ff       	call   c0100cf0 <__panic>
    assert(*ptep & PTE_U);
c01055fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055ff:	8b 00                	mov    (%eax),%eax
c0105601:	83 e0 04             	and    $0x4,%eax
c0105604:	85 c0                	test   %eax,%eax
c0105606:	75 24                	jne    c010562c <check_pgdir+0x333>
c0105608:	c7 44 24 0c bc 9b 10 	movl   $0xc0109bbc,0xc(%esp)
c010560f:	c0 
c0105610:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105617:	c0 
c0105618:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c010561f:	00 
c0105620:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105627:	e8 c4 b6 ff ff       	call   c0100cf0 <__panic>
    assert(*ptep & PTE_W);
c010562c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010562f:	8b 00                	mov    (%eax),%eax
c0105631:	83 e0 02             	and    $0x2,%eax
c0105634:	85 c0                	test   %eax,%eax
c0105636:	75 24                	jne    c010565c <check_pgdir+0x363>
c0105638:	c7 44 24 0c ca 9b 10 	movl   $0xc0109bca,0xc(%esp)
c010563f:	c0 
c0105640:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105647:	c0 
c0105648:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c010564f:	00 
c0105650:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105657:	e8 94 b6 ff ff       	call   c0100cf0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010565c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105661:	8b 00                	mov    (%eax),%eax
c0105663:	83 e0 04             	and    $0x4,%eax
c0105666:	85 c0                	test   %eax,%eax
c0105668:	75 24                	jne    c010568e <check_pgdir+0x395>
c010566a:	c7 44 24 0c d8 9b 10 	movl   $0xc0109bd8,0xc(%esp)
c0105671:	c0 
c0105672:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105679:	c0 
c010567a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105681:	00 
c0105682:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105689:	e8 62 b6 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p2) == 1);
c010568e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105691:	89 04 24             	mov    %eax,(%esp)
c0105694:	e8 af ee ff ff       	call   c0104548 <page_ref>
c0105699:	83 f8 01             	cmp    $0x1,%eax
c010569c:	74 24                	je     c01056c2 <check_pgdir+0x3c9>
c010569e:	c7 44 24 0c ee 9b 10 	movl   $0xc0109bee,0xc(%esp)
c01056a5:	c0 
c01056a6:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01056ad:	c0 
c01056ae:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01056b5:	00 
c01056b6:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01056bd:	e8 2e b6 ff ff       	call   c0100cf0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01056c2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01056c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01056ce:	00 
c01056cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01056d6:	00 
c01056d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056de:	89 04 24             	mov    %eax,(%esp)
c01056e1:	e8 14 fa ff ff       	call   c01050fa <page_insert>
c01056e6:	85 c0                	test   %eax,%eax
c01056e8:	74 24                	je     c010570e <check_pgdir+0x415>
c01056ea:	c7 44 24 0c 00 9c 10 	movl   $0xc0109c00,0xc(%esp)
c01056f1:	c0 
c01056f2:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01056f9:	c0 
c01056fa:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105701:	00 
c0105702:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105709:	e8 e2 b5 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p1) == 2);
c010570e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105711:	89 04 24             	mov    %eax,(%esp)
c0105714:	e8 2f ee ff ff       	call   c0104548 <page_ref>
c0105719:	83 f8 02             	cmp    $0x2,%eax
c010571c:	74 24                	je     c0105742 <check_pgdir+0x449>
c010571e:	c7 44 24 0c 2c 9c 10 	movl   $0xc0109c2c,0xc(%esp)
c0105725:	c0 
c0105726:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010572d:	c0 
c010572e:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105735:	00 
c0105736:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c010573d:	e8 ae b5 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p2) == 0);
c0105742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105745:	89 04 24             	mov    %eax,(%esp)
c0105748:	e8 fb ed ff ff       	call   c0104548 <page_ref>
c010574d:	85 c0                	test   %eax,%eax
c010574f:	74 24                	je     c0105775 <check_pgdir+0x47c>
c0105751:	c7 44 24 0c 3e 9c 10 	movl   $0xc0109c3e,0xc(%esp)
c0105758:	c0 
c0105759:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105760:	c0 
c0105761:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105768:	00 
c0105769:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105770:	e8 7b b5 ff ff       	call   c0100cf0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105775:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010577a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105781:	00 
c0105782:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105789:	00 
c010578a:	89 04 24             	mov    %eax,(%esp)
c010578d:	e8 1d f7 ff ff       	call   c0104eaf <get_pte>
c0105792:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105799:	75 24                	jne    c01057bf <check_pgdir+0x4c6>
c010579b:	c7 44 24 0c 8c 9b 10 	movl   $0xc0109b8c,0xc(%esp)
c01057a2:	c0 
c01057a3:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01057aa:	c0 
c01057ab:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01057b2:	00 
c01057b3:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01057ba:	e8 31 b5 ff ff       	call   c0100cf0 <__panic>
    assert(pa2page(*ptep) == p1);
c01057bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057c2:	8b 00                	mov    (%eax),%eax
c01057c4:	89 04 24             	mov    %eax,(%esp)
c01057c7:	e8 5b ec ff ff       	call   c0104427 <pa2page>
c01057cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01057cf:	74 24                	je     c01057f5 <check_pgdir+0x4fc>
c01057d1:	c7 44 24 0c 05 9b 10 	movl   $0xc0109b05,0xc(%esp)
c01057d8:	c0 
c01057d9:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01057e0:	c0 
c01057e1:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01057e8:	00 
c01057e9:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01057f0:	e8 fb b4 ff ff       	call   c0100cf0 <__panic>
    assert((*ptep & PTE_U) == 0);
c01057f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057f8:	8b 00                	mov    (%eax),%eax
c01057fa:	83 e0 04             	and    $0x4,%eax
c01057fd:	85 c0                	test   %eax,%eax
c01057ff:	74 24                	je     c0105825 <check_pgdir+0x52c>
c0105801:	c7 44 24 0c 50 9c 10 	movl   $0xc0109c50,0xc(%esp)
c0105808:	c0 
c0105809:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105810:	c0 
c0105811:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105818:	00 
c0105819:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105820:	e8 cb b4 ff ff       	call   c0100cf0 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105825:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010582a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105831:	00 
c0105832:	89 04 24             	mov    %eax,(%esp)
c0105835:	e8 7c f8 ff ff       	call   c01050b6 <page_remove>
    assert(page_ref(p1) == 1);
c010583a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010583d:	89 04 24             	mov    %eax,(%esp)
c0105840:	e8 03 ed ff ff       	call   c0104548 <page_ref>
c0105845:	83 f8 01             	cmp    $0x1,%eax
c0105848:	74 24                	je     c010586e <check_pgdir+0x575>
c010584a:	c7 44 24 0c 1a 9b 10 	movl   $0xc0109b1a,0xc(%esp)
c0105851:	c0 
c0105852:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105859:	c0 
c010585a:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105861:	00 
c0105862:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105869:	e8 82 b4 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p2) == 0);
c010586e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105871:	89 04 24             	mov    %eax,(%esp)
c0105874:	e8 cf ec ff ff       	call   c0104548 <page_ref>
c0105879:	85 c0                	test   %eax,%eax
c010587b:	74 24                	je     c01058a1 <check_pgdir+0x5a8>
c010587d:	c7 44 24 0c 3e 9c 10 	movl   $0xc0109c3e,0xc(%esp)
c0105884:	c0 
c0105885:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010588c:	c0 
c010588d:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105894:	00 
c0105895:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c010589c:	e8 4f b4 ff ff       	call   c0100cf0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01058a1:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01058a6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01058ad:	00 
c01058ae:	89 04 24             	mov    %eax,(%esp)
c01058b1:	e8 00 f8 ff ff       	call   c01050b6 <page_remove>
    assert(page_ref(p1) == 0);
c01058b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058b9:	89 04 24             	mov    %eax,(%esp)
c01058bc:	e8 87 ec ff ff       	call   c0104548 <page_ref>
c01058c1:	85 c0                	test   %eax,%eax
c01058c3:	74 24                	je     c01058e9 <check_pgdir+0x5f0>
c01058c5:	c7 44 24 0c 65 9c 10 	movl   $0xc0109c65,0xc(%esp)
c01058cc:	c0 
c01058cd:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c01058d4:	c0 
c01058d5:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01058dc:	00 
c01058dd:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01058e4:	e8 07 b4 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p2) == 0);
c01058e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058ec:	89 04 24             	mov    %eax,(%esp)
c01058ef:	e8 54 ec ff ff       	call   c0104548 <page_ref>
c01058f4:	85 c0                	test   %eax,%eax
c01058f6:	74 24                	je     c010591c <check_pgdir+0x623>
c01058f8:	c7 44 24 0c 3e 9c 10 	movl   $0xc0109c3e,0xc(%esp)
c01058ff:	c0 
c0105900:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105907:	c0 
c0105908:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c010590f:	00 
c0105910:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105917:	e8 d4 b3 ff ff       	call   c0100cf0 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c010591c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105921:	8b 00                	mov    (%eax),%eax
c0105923:	89 04 24             	mov    %eax,(%esp)
c0105926:	e8 fc ea ff ff       	call   c0104427 <pa2page>
c010592b:	89 04 24             	mov    %eax,(%esp)
c010592e:	e8 15 ec ff ff       	call   c0104548 <page_ref>
c0105933:	83 f8 01             	cmp    $0x1,%eax
c0105936:	74 24                	je     c010595c <check_pgdir+0x663>
c0105938:	c7 44 24 0c 78 9c 10 	movl   $0xc0109c78,0xc(%esp)
c010593f:	c0 
c0105940:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105947:	c0 
c0105948:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010594f:	00 
c0105950:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105957:	e8 94 b3 ff ff       	call   c0100cf0 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c010595c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105961:	8b 00                	mov    (%eax),%eax
c0105963:	89 04 24             	mov    %eax,(%esp)
c0105966:	e8 bc ea ff ff       	call   c0104427 <pa2page>
c010596b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105972:	00 
c0105973:	89 04 24             	mov    %eax,(%esp)
c0105976:	e8 3d ee ff ff       	call   c01047b8 <free_pages>
    boot_pgdir[0] = 0;
c010597b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105986:	c7 04 24 9e 9c 10 c0 	movl   $0xc0109c9e,(%esp)
c010598d:	e8 b9 a9 ff ff       	call   c010034b <cprintf>
}
c0105992:	c9                   	leave  
c0105993:	c3                   	ret    

c0105994 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105994:	55                   	push   %ebp
c0105995:	89 e5                	mov    %esp,%ebp
c0105997:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010599a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01059a1:	e9 ca 00 00 00       	jmp    c0105a70 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01059a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059af:	c1 e8 0c             	shr    $0xc,%eax
c01059b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059b5:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01059ba:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01059bd:	72 23                	jb     c01059e2 <check_boot_pgdir+0x4e>
c01059bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059c6:	c7 44 24 08 d4 98 10 	movl   $0xc01098d4,0x8(%esp)
c01059cd:	c0 
c01059ce:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c01059d5:	00 
c01059d6:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c01059dd:	e8 0e b3 ff ff       	call   c0100cf0 <__panic>
c01059e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059e5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01059ea:	89 c2                	mov    %eax,%edx
c01059ec:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01059f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059f8:	00 
c01059f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059fd:	89 04 24             	mov    %eax,(%esp)
c0105a00:	e8 aa f4 ff ff       	call   c0104eaf <get_pte>
c0105a05:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a0c:	75 24                	jne    c0105a32 <check_boot_pgdir+0x9e>
c0105a0e:	c7 44 24 0c b8 9c 10 	movl   $0xc0109cb8,0xc(%esp)
c0105a15:	c0 
c0105a16:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105a1d:	c0 
c0105a1e:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0105a25:	00 
c0105a26:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105a2d:	e8 be b2 ff ff       	call   c0100cf0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105a32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a35:	8b 00                	mov    (%eax),%eax
c0105a37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a3c:	89 c2                	mov    %eax,%edx
c0105a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a41:	39 c2                	cmp    %eax,%edx
c0105a43:	74 24                	je     c0105a69 <check_boot_pgdir+0xd5>
c0105a45:	c7 44 24 0c f5 9c 10 	movl   $0xc0109cf5,0xc(%esp)
c0105a4c:	c0 
c0105a4d:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105a54:	c0 
c0105a55:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105a5c:	00 
c0105a5d:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105a64:	e8 87 b2 ff ff       	call   c0100cf0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105a69:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a73:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105a78:	39 c2                	cmp    %eax,%edx
c0105a7a:	0f 82 26 ff ff ff    	jb     c01059a6 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105a80:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a85:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105a8a:	8b 00                	mov    (%eax),%eax
c0105a8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a91:	89 c2                	mov    %eax,%edx
c0105a93:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a9b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105aa2:	77 23                	ja     c0105ac7 <check_boot_pgdir+0x133>
c0105aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aab:	c7 44 24 08 f8 98 10 	movl   $0xc01098f8,0x8(%esp)
c0105ab2:	c0 
c0105ab3:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0105aba:	00 
c0105abb:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105ac2:	e8 29 b2 ff ff       	call   c0100cf0 <__panic>
c0105ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105aca:	05 00 00 00 40       	add    $0x40000000,%eax
c0105acf:	39 c2                	cmp    %eax,%edx
c0105ad1:	74 24                	je     c0105af7 <check_boot_pgdir+0x163>
c0105ad3:	c7 44 24 0c 0c 9d 10 	movl   $0xc0109d0c,0xc(%esp)
c0105ada:	c0 
c0105adb:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105ae2:	c0 
c0105ae3:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0105aea:	00 
c0105aeb:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105af2:	e8 f9 b1 ff ff       	call   c0100cf0 <__panic>

    assert(boot_pgdir[0] == 0);
c0105af7:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105afc:	8b 00                	mov    (%eax),%eax
c0105afe:	85 c0                	test   %eax,%eax
c0105b00:	74 24                	je     c0105b26 <check_boot_pgdir+0x192>
c0105b02:	c7 44 24 0c 40 9d 10 	movl   $0xc0109d40,0xc(%esp)
c0105b09:	c0 
c0105b0a:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105b11:	c0 
c0105b12:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0105b19:	00 
c0105b1a:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105b21:	e8 ca b1 ff ff       	call   c0100cf0 <__panic>

    struct Page *p;
    p = alloc_page();
c0105b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b2d:	e8 1b ec ff ff       	call   c010474d <alloc_pages>
c0105b32:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105b35:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105b3a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105b41:	00 
c0105b42:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105b49:	00 
c0105b4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b4d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b51:	89 04 24             	mov    %eax,(%esp)
c0105b54:	e8 a1 f5 ff ff       	call   c01050fa <page_insert>
c0105b59:	85 c0                	test   %eax,%eax
c0105b5b:	74 24                	je     c0105b81 <check_boot_pgdir+0x1ed>
c0105b5d:	c7 44 24 0c 54 9d 10 	movl   $0xc0109d54,0xc(%esp)
c0105b64:	c0 
c0105b65:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105b6c:	c0 
c0105b6d:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0105b74:	00 
c0105b75:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105b7c:	e8 6f b1 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p) == 1);
c0105b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b84:	89 04 24             	mov    %eax,(%esp)
c0105b87:	e8 bc e9 ff ff       	call   c0104548 <page_ref>
c0105b8c:	83 f8 01             	cmp    $0x1,%eax
c0105b8f:	74 24                	je     c0105bb5 <check_boot_pgdir+0x221>
c0105b91:	c7 44 24 0c 82 9d 10 	movl   $0xc0109d82,0xc(%esp)
c0105b98:	c0 
c0105b99:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105ba0:	c0 
c0105ba1:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0105ba8:	00 
c0105ba9:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105bb0:	e8 3b b1 ff ff       	call   c0100cf0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105bb5:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105bba:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105bc1:	00 
c0105bc2:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105bc9:	00 
c0105bca:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105bcd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105bd1:	89 04 24             	mov    %eax,(%esp)
c0105bd4:	e8 21 f5 ff ff       	call   c01050fa <page_insert>
c0105bd9:	85 c0                	test   %eax,%eax
c0105bdb:	74 24                	je     c0105c01 <check_boot_pgdir+0x26d>
c0105bdd:	c7 44 24 0c 94 9d 10 	movl   $0xc0109d94,0xc(%esp)
c0105be4:	c0 
c0105be5:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105bec:	c0 
c0105bed:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c0105bf4:	00 
c0105bf5:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105bfc:	e8 ef b0 ff ff       	call   c0100cf0 <__panic>
    assert(page_ref(p) == 2);
c0105c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c04:	89 04 24             	mov    %eax,(%esp)
c0105c07:	e8 3c e9 ff ff       	call   c0104548 <page_ref>
c0105c0c:	83 f8 02             	cmp    $0x2,%eax
c0105c0f:	74 24                	je     c0105c35 <check_boot_pgdir+0x2a1>
c0105c11:	c7 44 24 0c cb 9d 10 	movl   $0xc0109dcb,0xc(%esp)
c0105c18:	c0 
c0105c19:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105c20:	c0 
c0105c21:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c0105c28:	00 
c0105c29:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105c30:	e8 bb b0 ff ff       	call   c0100cf0 <__panic>

    const char *str = "ucore: Hello world!!";
c0105c35:	c7 45 dc dc 9d 10 c0 	movl   $0xc0109ddc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105c3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c43:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c4a:	e8 b9 2b 00 00       	call   c0108808 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105c4f:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105c56:	00 
c0105c57:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105c5e:	e8 1e 2c 00 00       	call   c0108881 <strcmp>
c0105c63:	85 c0                	test   %eax,%eax
c0105c65:	74 24                	je     c0105c8b <check_boot_pgdir+0x2f7>
c0105c67:	c7 44 24 0c f4 9d 10 	movl   $0xc0109df4,0xc(%esp)
c0105c6e:	c0 
c0105c6f:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105c76:	c0 
c0105c77:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c0105c7e:	00 
c0105c7f:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105c86:	e8 65 b0 ff ff       	call   c0100cf0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c8e:	89 04 24             	mov    %eax,(%esp)
c0105c91:	e8 d6 e7 ff ff       	call   c010446c <page2kva>
c0105c96:	05 00 01 00 00       	add    $0x100,%eax
c0105c9b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105c9e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105ca5:	e8 06 2b 00 00       	call   c01087b0 <strlen>
c0105caa:	85 c0                	test   %eax,%eax
c0105cac:	74 24                	je     c0105cd2 <check_boot_pgdir+0x33e>
c0105cae:	c7 44 24 0c 2c 9e 10 	movl   $0xc0109e2c,0xc(%esp)
c0105cb5:	c0 
c0105cb6:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105cbd:	c0 
c0105cbe:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c0105cc5:	00 
c0105cc6:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105ccd:	e8 1e b0 ff ff       	call   c0100cf0 <__panic>

    free_page(p);
c0105cd2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105cd9:	00 
c0105cda:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cdd:	89 04 24             	mov    %eax,(%esp)
c0105ce0:	e8 d3 ea ff ff       	call   c01047b8 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105ce5:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105cea:	8b 00                	mov    (%eax),%eax
c0105cec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105cf1:	89 04 24             	mov    %eax,(%esp)
c0105cf4:	e8 2e e7 ff ff       	call   c0104427 <pa2page>
c0105cf9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d00:	00 
c0105d01:	89 04 24             	mov    %eax,(%esp)
c0105d04:	e8 af ea ff ff       	call   c01047b8 <free_pages>
    boot_pgdir[0] = 0;
c0105d09:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105d0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105d14:	c7 04 24 50 9e 10 c0 	movl   $0xc0109e50,(%esp)
c0105d1b:	e8 2b a6 ff ff       	call   c010034b <cprintf>
}
c0105d20:	c9                   	leave  
c0105d21:	c3                   	ret    

c0105d22 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105d22:	55                   	push   %ebp
c0105d23:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d28:	83 e0 04             	and    $0x4,%eax
c0105d2b:	85 c0                	test   %eax,%eax
c0105d2d:	74 07                	je     c0105d36 <perm2str+0x14>
c0105d2f:	b8 75 00 00 00       	mov    $0x75,%eax
c0105d34:	eb 05                	jmp    c0105d3b <perm2str+0x19>
c0105d36:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105d3b:	a2 a8 1a 12 c0       	mov    %al,0xc0121aa8
    str[1] = 'r';
c0105d40:	c6 05 a9 1a 12 c0 72 	movb   $0x72,0xc0121aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4a:	83 e0 02             	and    $0x2,%eax
c0105d4d:	85 c0                	test   %eax,%eax
c0105d4f:	74 07                	je     c0105d58 <perm2str+0x36>
c0105d51:	b8 77 00 00 00       	mov    $0x77,%eax
c0105d56:	eb 05                	jmp    c0105d5d <perm2str+0x3b>
c0105d58:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105d5d:	a2 aa 1a 12 c0       	mov    %al,0xc0121aaa
    str[3] = '\0';
c0105d62:	c6 05 ab 1a 12 c0 00 	movb   $0x0,0xc0121aab
    return str;
c0105d69:	b8 a8 1a 12 c0       	mov    $0xc0121aa8,%eax
}
c0105d6e:	5d                   	pop    %ebp
c0105d6f:	c3                   	ret    

c0105d70 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105d70:	55                   	push   %ebp
c0105d71:	89 e5                	mov    %esp,%ebp
c0105d73:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d79:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d7c:	72 0a                	jb     c0105d88 <get_pgtable_items+0x18>
        return 0;
c0105d7e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105d83:	e9 9c 00 00 00       	jmp    c0105e24 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105d88:	eb 04                	jmp    c0105d8e <get_pgtable_items+0x1e>
        start ++;
c0105d8a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105d8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d91:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d94:	73 18                	jae    c0105dae <get_pgtable_items+0x3e>
c0105d96:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105da0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105da3:	01 d0                	add    %edx,%eax
c0105da5:	8b 00                	mov    (%eax),%eax
c0105da7:	83 e0 01             	and    $0x1,%eax
c0105daa:	85 c0                	test   %eax,%eax
c0105dac:	74 dc                	je     c0105d8a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105dae:	8b 45 10             	mov    0x10(%ebp),%eax
c0105db1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105db4:	73 69                	jae    c0105e1f <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105db6:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105dba:	74 08                	je     c0105dc4 <get_pgtable_items+0x54>
            *left_store = start;
c0105dbc:	8b 45 18             	mov    0x18(%ebp),%eax
c0105dbf:	8b 55 10             	mov    0x10(%ebp),%edx
c0105dc2:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105dc4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dc7:	8d 50 01             	lea    0x1(%eax),%edx
c0105dca:	89 55 10             	mov    %edx,0x10(%ebp)
c0105dcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105dd4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dd7:	01 d0                	add    %edx,%eax
c0105dd9:	8b 00                	mov    (%eax),%eax
c0105ddb:	83 e0 07             	and    $0x7,%eax
c0105dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105de1:	eb 04                	jmp    c0105de7 <get_pgtable_items+0x77>
            start ++;
c0105de3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105de7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ded:	73 1d                	jae    c0105e0c <get_pgtable_items+0x9c>
c0105def:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105df9:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dfc:	01 d0                	add    %edx,%eax
c0105dfe:	8b 00                	mov    (%eax),%eax
c0105e00:	83 e0 07             	and    $0x7,%eax
c0105e03:	89 c2                	mov    %eax,%edx
c0105e05:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e08:	39 c2                	cmp    %eax,%edx
c0105e0a:	74 d7                	je     c0105de3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105e0c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105e10:	74 08                	je     c0105e1a <get_pgtable_items+0xaa>
            *right_store = start;
c0105e12:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105e15:	8b 55 10             	mov    0x10(%ebp),%edx
c0105e18:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e1d:	eb 05                	jmp    c0105e24 <get_pgtable_items+0xb4>
    }
    return 0;
c0105e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e24:	c9                   	leave  
c0105e25:	c3                   	ret    

c0105e26 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105e26:	55                   	push   %ebp
c0105e27:	89 e5                	mov    %esp,%ebp
c0105e29:	57                   	push   %edi
c0105e2a:	56                   	push   %esi
c0105e2b:	53                   	push   %ebx
c0105e2c:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105e2f:	c7 04 24 70 9e 10 c0 	movl   $0xc0109e70,(%esp)
c0105e36:	e8 10 a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105e3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e42:	e9 fa 00 00 00       	jmp    c0105f41 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e4a:	89 04 24             	mov    %eax,(%esp)
c0105e4d:	e8 d0 fe ff ff       	call   c0105d22 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105e52:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e55:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e58:	29 d1                	sub    %edx,%ecx
c0105e5a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105e5c:	89 d6                	mov    %edx,%esi
c0105e5e:	c1 e6 16             	shl    $0x16,%esi
c0105e61:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105e64:	89 d3                	mov    %edx,%ebx
c0105e66:	c1 e3 16             	shl    $0x16,%ebx
c0105e69:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e6c:	89 d1                	mov    %edx,%ecx
c0105e6e:	c1 e1 16             	shl    $0x16,%ecx
c0105e71:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105e74:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e77:	29 d7                	sub    %edx,%edi
c0105e79:	89 fa                	mov    %edi,%edx
c0105e7b:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105e7f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105e83:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105e87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e8b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e8f:	c7 04 24 a1 9e 10 c0 	movl   $0xc0109ea1,(%esp)
c0105e96:	e8 b0 a4 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e9e:	c1 e0 0a             	shl    $0xa,%eax
c0105ea1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105ea4:	eb 54                	jmp    c0105efa <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ea9:	89 04 24             	mov    %eax,(%esp)
c0105eac:	e8 71 fe ff ff       	call   c0105d22 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105eb1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105eb4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105eb7:	29 d1                	sub    %edx,%ecx
c0105eb9:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105ebb:	89 d6                	mov    %edx,%esi
c0105ebd:	c1 e6 0c             	shl    $0xc,%esi
c0105ec0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105ec3:	89 d3                	mov    %edx,%ebx
c0105ec5:	c1 e3 0c             	shl    $0xc,%ebx
c0105ec8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105ecb:	c1 e2 0c             	shl    $0xc,%edx
c0105ece:	89 d1                	mov    %edx,%ecx
c0105ed0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105ed3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105ed6:	29 d7                	sub    %edx,%edi
c0105ed8:	89 fa                	mov    %edi,%edx
c0105eda:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105ede:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105ee2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105ee6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105eea:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105eee:	c7 04 24 c0 9e 10 c0 	movl   $0xc0109ec0,(%esp)
c0105ef5:	e8 51 a4 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105efa:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105eff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105f02:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f05:	89 ce                	mov    %ecx,%esi
c0105f07:	c1 e6 0a             	shl    $0xa,%esi
c0105f0a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105f0d:	89 cb                	mov    %ecx,%ebx
c0105f0f:	c1 e3 0a             	shl    $0xa,%ebx
c0105f12:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105f15:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105f19:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105f1c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105f20:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105f24:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f28:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105f2c:	89 1c 24             	mov    %ebx,(%esp)
c0105f2f:	e8 3c fe ff ff       	call   c0105d70 <get_pgtable_items>
c0105f34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f3b:	0f 85 65 ff ff ff    	jne    c0105ea6 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105f41:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105f46:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f49:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105f4c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105f50:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105f53:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105f57:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105f5b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f5f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105f66:	00 
c0105f67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105f6e:	e8 fd fd ff ff       	call   c0105d70 <get_pgtable_items>
c0105f73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f7a:	0f 85 c7 fe ff ff    	jne    c0105e47 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105f80:	c7 04 24 e4 9e 10 c0 	movl   $0xc0109ee4,(%esp)
c0105f87:	e8 bf a3 ff ff       	call   c010034b <cprintf>
}
c0105f8c:	83 c4 4c             	add    $0x4c,%esp
c0105f8f:	5b                   	pop    %ebx
c0105f90:	5e                   	pop    %esi
c0105f91:	5f                   	pop    %edi
c0105f92:	5d                   	pop    %ebp
c0105f93:	c3                   	ret    

c0105f94 <kmalloc>:

void *
kmalloc(size_t n) {
c0105f94:	55                   	push   %ebp
c0105f95:	89 e5                	mov    %esp,%ebp
c0105f97:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105f9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105fa1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105fa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105fac:	74 09                	je     c0105fb7 <kmalloc+0x23>
c0105fae:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105fb5:	76 24                	jbe    c0105fdb <kmalloc+0x47>
c0105fb7:	c7 44 24 0c 15 9f 10 	movl   $0xc0109f15,0xc(%esp)
c0105fbe:	c0 
c0105fbf:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0105fc6:	c0 
c0105fc7:	c7 44 24 04 b2 02 00 	movl   $0x2b2,0x4(%esp)
c0105fce:	00 
c0105fcf:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0105fd6:	e8 15 ad ff ff       	call   c0100cf0 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fde:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105fe3:	c1 e8 0c             	shr    $0xc,%eax
c0105fe6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fec:	89 04 24             	mov    %eax,(%esp)
c0105fef:	e8 59 e7 ff ff       	call   c010474d <alloc_pages>
c0105ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105ff7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ffb:	75 24                	jne    c0106021 <kmalloc+0x8d>
c0105ffd:	c7 44 24 0c 2c 9f 10 	movl   $0xc0109f2c,0xc(%esp)
c0106004:	c0 
c0106005:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c010600c:	c0 
c010600d:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c0106014:	00 
c0106015:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c010601c:	e8 cf ac ff ff       	call   c0100cf0 <__panic>
    ptr=page2kva(base);
c0106021:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106024:	89 04 24             	mov    %eax,(%esp)
c0106027:	e8 40 e4 ff ff       	call   c010446c <page2kva>
c010602c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c010602f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106032:	c9                   	leave  
c0106033:	c3                   	ret    

c0106034 <kfree>:

void 
kfree(void *ptr, size_t n) {
c0106034:	55                   	push   %ebp
c0106035:	89 e5                	mov    %esp,%ebp
c0106037:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c010603a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010603e:	74 09                	je     c0106049 <kfree+0x15>
c0106040:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0106047:	76 24                	jbe    c010606d <kfree+0x39>
c0106049:	c7 44 24 0c 15 9f 10 	movl   $0xc0109f15,0xc(%esp)
c0106050:	c0 
c0106051:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0106058:	c0 
c0106059:	c7 44 24 04 bc 02 00 	movl   $0x2bc,0x4(%esp)
c0106060:	00 
c0106061:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0106068:	e8 83 ac ff ff       	call   c0100cf0 <__panic>
    assert(ptr != NULL);
c010606d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106071:	75 24                	jne    c0106097 <kfree+0x63>
c0106073:	c7 44 24 0c 39 9f 10 	movl   $0xc0109f39,0xc(%esp)
c010607a:	c0 
c010607b:	c7 44 24 08 c1 99 10 	movl   $0xc01099c1,0x8(%esp)
c0106082:	c0 
c0106083:	c7 44 24 04 bd 02 00 	movl   $0x2bd,0x4(%esp)
c010608a:	00 
c010608b:	c7 04 24 9c 99 10 c0 	movl   $0xc010999c,(%esp)
c0106092:	e8 59 ac ff ff       	call   c0100cf0 <__panic>
    struct Page *base=NULL;
c0106097:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c010609e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060a1:	05 ff 0f 00 00       	add    $0xfff,%eax
c01060a6:	c1 e8 0c             	shr    $0xc,%eax
c01060a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c01060ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01060af:	89 04 24             	mov    %eax,(%esp)
c01060b2:	e8 09 e4 ff ff       	call   c01044c0 <kva2page>
c01060b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c01060ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060c4:	89 04 24             	mov    %eax,(%esp)
c01060c7:	e8 ec e6 ff ff       	call   c01047b8 <free_pages>
}
c01060cc:	c9                   	leave  
c01060cd:	c3                   	ret    

c01060ce <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01060ce:	55                   	push   %ebp
c01060cf:	89 e5                	mov    %esp,%ebp
c01060d1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01060d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01060d7:	c1 e8 0c             	shr    $0xc,%eax
c01060da:	89 c2                	mov    %eax,%edx
c01060dc:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01060e1:	39 c2                	cmp    %eax,%edx
c01060e3:	72 1c                	jb     c0106101 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01060e5:	c7 44 24 08 48 9f 10 	movl   $0xc0109f48,0x8(%esp)
c01060ec:	c0 
c01060ed:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01060f4:	00 
c01060f5:	c7 04 24 67 9f 10 c0 	movl   $0xc0109f67,(%esp)
c01060fc:	e8 ef ab ff ff       	call   c0100cf0 <__panic>
    }
    return &pages[PPN(pa)];
c0106101:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0106106:	8b 55 08             	mov    0x8(%ebp),%edx
c0106109:	c1 ea 0c             	shr    $0xc,%edx
c010610c:	c1 e2 05             	shl    $0x5,%edx
c010610f:	01 d0                	add    %edx,%eax
}
c0106111:	c9                   	leave  
c0106112:	c3                   	ret    

c0106113 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106113:	55                   	push   %ebp
c0106114:	89 e5                	mov    %esp,%ebp
c0106116:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106119:	8b 45 08             	mov    0x8(%ebp),%eax
c010611c:	83 e0 01             	and    $0x1,%eax
c010611f:	85 c0                	test   %eax,%eax
c0106121:	75 1c                	jne    c010613f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106123:	c7 44 24 08 78 9f 10 	movl   $0xc0109f78,0x8(%esp)
c010612a:	c0 
c010612b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106132:	00 
c0106133:	c7 04 24 67 9f 10 c0 	movl   $0xc0109f67,(%esp)
c010613a:	e8 b1 ab ff ff       	call   c0100cf0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010613f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106142:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106147:	89 04 24             	mov    %eax,(%esp)
c010614a:	e8 7f ff ff ff       	call   c01060ce <pa2page>
}
c010614f:	c9                   	leave  
c0106150:	c3                   	ret    

c0106151 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106151:	55                   	push   %ebp
c0106152:	89 e5                	mov    %esp,%ebp
c0106154:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106157:	e8 cf 1d 00 00       	call   c0107f2b <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010615c:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106161:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106166:	76 0c                	jbe    c0106174 <swap_init+0x23>
c0106168:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c010616d:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106172:	76 25                	jbe    c0106199 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106174:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c0106179:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010617d:	c7 44 24 08 99 9f 10 	movl   $0xc0109f99,0x8(%esp)
c0106184:	c0 
c0106185:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010618c:	00 
c010618d:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106194:	e8 57 ab ff ff       	call   c0100cf0 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106199:	c7 05 b4 1a 12 c0 40 	movl   $0xc0120a40,0xc0121ab4
c01061a0:	0a 12 c0 
     int r = sm->init();
c01061a3:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061a8:	8b 40 04             	mov    0x4(%eax),%eax
c01061ab:	ff d0                	call   *%eax
c01061ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01061b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01061b4:	75 26                	jne    c01061dc <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01061b6:	c7 05 ac 1a 12 c0 01 	movl   $0x1,0xc0121aac
c01061bd:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01061c0:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061c5:	8b 00                	mov    (%eax),%eax
c01061c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061cb:	c7 04 24 c3 9f 10 c0 	movl   $0xc0109fc3,(%esp)
c01061d2:	e8 74 a1 ff ff       	call   c010034b <cprintf>
          check_swap();
c01061d7:	e8 a4 04 00 00       	call   c0106680 <check_swap>
     }

     return r;
c01061dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01061df:	c9                   	leave  
c01061e0:	c3                   	ret    

c01061e1 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01061e1:	55                   	push   %ebp
c01061e2:	89 e5                	mov    %esp,%ebp
c01061e4:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01061e7:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061ec:	8b 40 08             	mov    0x8(%eax),%eax
c01061ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01061f2:	89 14 24             	mov    %edx,(%esp)
c01061f5:	ff d0                	call   *%eax
}
c01061f7:	c9                   	leave  
c01061f8:	c3                   	ret    

c01061f9 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01061f9:	55                   	push   %ebp
c01061fa:	89 e5                	mov    %esp,%ebp
c01061fc:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01061ff:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106204:	8b 40 0c             	mov    0xc(%eax),%eax
c0106207:	8b 55 08             	mov    0x8(%ebp),%edx
c010620a:	89 14 24             	mov    %edx,(%esp)
c010620d:	ff d0                	call   *%eax
}
c010620f:	c9                   	leave  
c0106210:	c3                   	ret    

c0106211 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106211:	55                   	push   %ebp
c0106212:	89 e5                	mov    %esp,%ebp
c0106214:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106217:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010621c:	8b 40 10             	mov    0x10(%eax),%eax
c010621f:	8b 55 14             	mov    0x14(%ebp),%edx
c0106222:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106226:	8b 55 10             	mov    0x10(%ebp),%edx
c0106229:	89 54 24 08          	mov    %edx,0x8(%esp)
c010622d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106230:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106234:	8b 55 08             	mov    0x8(%ebp),%edx
c0106237:	89 14 24             	mov    %edx,(%esp)
c010623a:	ff d0                	call   *%eax
}
c010623c:	c9                   	leave  
c010623d:	c3                   	ret    

c010623e <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010623e:	55                   	push   %ebp
c010623f:	89 e5                	mov    %esp,%ebp
c0106241:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106244:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106249:	8b 40 14             	mov    0x14(%eax),%eax
c010624c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010624f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106253:	8b 55 08             	mov    0x8(%ebp),%edx
c0106256:	89 14 24             	mov    %edx,(%esp)
c0106259:	ff d0                	call   *%eax
}
c010625b:	c9                   	leave  
c010625c:	c3                   	ret    

c010625d <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010625d:	55                   	push   %ebp
c010625e:	89 e5                	mov    %esp,%ebp
c0106260:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010626a:	e9 5a 01 00 00       	jmp    c01063c9 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c010626f:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106274:	8b 40 18             	mov    0x18(%eax),%eax
c0106277:	8b 55 10             	mov    0x10(%ebp),%edx
c010627a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010627e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106281:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106285:	8b 55 08             	mov    0x8(%ebp),%edx
c0106288:	89 14 24             	mov    %edx,(%esp)
c010628b:	ff d0                	call   *%eax
c010628d:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106294:	74 18                	je     c01062ae <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106296:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106299:	89 44 24 04          	mov    %eax,0x4(%esp)
c010629d:	c7 04 24 d8 9f 10 c0 	movl   $0xc0109fd8,(%esp)
c01062a4:	e8 a2 a0 ff ff       	call   c010034b <cprintf>
c01062a9:	e9 27 01 00 00       	jmp    c01063d5 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01062ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062b1:	8b 40 1c             	mov    0x1c(%eax),%eax
c01062b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01062b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01062ba:	8b 40 0c             	mov    0xc(%eax),%eax
c01062bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062c4:	00 
c01062c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062cc:	89 04 24             	mov    %eax,(%esp)
c01062cf:	e8 db eb ff ff       	call   c0104eaf <get_pte>
c01062d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01062d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062da:	8b 00                	mov    (%eax),%eax
c01062dc:	83 e0 01             	and    $0x1,%eax
c01062df:	85 c0                	test   %eax,%eax
c01062e1:	75 24                	jne    c0106307 <swap_out+0xaa>
c01062e3:	c7 44 24 0c 05 a0 10 	movl   $0xc010a005,0xc(%esp)
c01062ea:	c0 
c01062eb:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01062f2:	c0 
c01062f3:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01062fa:	00 
c01062fb:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106302:	e8 e9 a9 ff ff       	call   c0100cf0 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010630a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010630d:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106310:	c1 ea 0c             	shr    $0xc,%edx
c0106313:	83 c2 01             	add    $0x1,%edx
c0106316:	c1 e2 08             	shl    $0x8,%edx
c0106319:	89 44 24 04          	mov    %eax,0x4(%esp)
c010631d:	89 14 24             	mov    %edx,(%esp)
c0106320:	e8 c0 1c 00 00       	call   c0107fe5 <swapfs_write>
c0106325:	85 c0                	test   %eax,%eax
c0106327:	74 34                	je     c010635d <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106329:	c7 04 24 2f a0 10 c0 	movl   $0xc010a02f,(%esp)
c0106330:	e8 16 a0 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106335:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010633a:	8b 40 10             	mov    0x10(%eax),%eax
c010633d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106340:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106347:	00 
c0106348:	89 54 24 08          	mov    %edx,0x8(%esp)
c010634c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010634f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106353:	8b 55 08             	mov    0x8(%ebp),%edx
c0106356:	89 14 24             	mov    %edx,(%esp)
c0106359:	ff d0                	call   *%eax
c010635b:	eb 68                	jmp    c01063c5 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c010635d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106360:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106363:	c1 e8 0c             	shr    $0xc,%eax
c0106366:	83 c0 01             	add    $0x1,%eax
c0106369:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010636d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106370:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106374:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106377:	89 44 24 04          	mov    %eax,0x4(%esp)
c010637b:	c7 04 24 48 a0 10 c0 	movl   $0xc010a048,(%esp)
c0106382:	e8 c4 9f ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010638a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010638d:	c1 e8 0c             	shr    $0xc,%eax
c0106390:	83 c0 01             	add    $0x1,%eax
c0106393:	c1 e0 08             	shl    $0x8,%eax
c0106396:	89 c2                	mov    %eax,%edx
c0106398:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010639b:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c010639d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01063a7:	00 
c01063a8:	89 04 24             	mov    %eax,(%esp)
c01063ab:	e8 08 e4 ff ff       	call   c01047b8 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01063b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01063b3:	8b 40 0c             	mov    0xc(%eax),%eax
c01063b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063bd:	89 04 24             	mov    %eax,(%esp)
c01063c0:	e8 ee ed ff ff       	call   c01051b3 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01063c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01063c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063cf:	0f 85 9a fe ff ff    	jne    c010626f <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01063d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01063d8:	c9                   	leave  
c01063d9:	c3                   	ret    

c01063da <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01063da:	55                   	push   %ebp
c01063db:	89 e5                	mov    %esp,%ebp
c01063dd:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01063e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01063e7:	e8 61 e3 ff ff       	call   c010474d <alloc_pages>
c01063ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01063ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01063f3:	75 24                	jne    c0106419 <swap_in+0x3f>
c01063f5:	c7 44 24 0c 88 a0 10 	movl   $0xc010a088,0xc(%esp)
c01063fc:	c0 
c01063fd:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106404:	c0 
c0106405:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c010640c:	00 
c010640d:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106414:	e8 d7 a8 ff ff       	call   c0100cf0 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106419:	8b 45 08             	mov    0x8(%ebp),%eax
c010641c:	8b 40 0c             	mov    0xc(%eax),%eax
c010641f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106426:	00 
c0106427:	8b 55 0c             	mov    0xc(%ebp),%edx
c010642a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010642e:	89 04 24             	mov    %eax,(%esp)
c0106431:	e8 79 ea ff ff       	call   c0104eaf <get_pte>
c0106436:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106439:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010643c:	8b 00                	mov    (%eax),%eax
c010643e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106441:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106445:	89 04 24             	mov    %eax,(%esp)
c0106448:	e8 26 1b 00 00       	call   c0107f73 <swapfs_read>
c010644d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106454:	74 2a                	je     c0106480 <swap_in+0xa6>
     {
        assert(r!=0);
c0106456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010645a:	75 24                	jne    c0106480 <swap_in+0xa6>
c010645c:	c7 44 24 0c 95 a0 10 	movl   $0xc010a095,0xc(%esp)
c0106463:	c0 
c0106464:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c010646b:	c0 
c010646c:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106473:	00 
c0106474:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c010647b:	e8 70 a8 ff ff       	call   c0100cf0 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106480:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106483:	8b 00                	mov    (%eax),%eax
c0106485:	c1 e8 08             	shr    $0x8,%eax
c0106488:	89 c2                	mov    %eax,%edx
c010648a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010648d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106491:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106495:	c7 04 24 9c a0 10 c0 	movl   $0xc010a09c,(%esp)
c010649c:	e8 aa 9e ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c01064a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01064a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01064a7:	89 10                	mov    %edx,(%eax)
     return 0;
c01064a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01064ae:	c9                   	leave  
c01064af:	c3                   	ret    

c01064b0 <check_content_set>:



static inline void
check_content_set(void)
{
c01064b0:	55                   	push   %ebp
c01064b1:	89 e5                	mov    %esp,%ebp
c01064b3:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01064b6:	b8 00 10 00 00       	mov    $0x1000,%eax
c01064bb:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01064be:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01064c3:	83 f8 01             	cmp    $0x1,%eax
c01064c6:	74 24                	je     c01064ec <check_content_set+0x3c>
c01064c8:	c7 44 24 0c da a0 10 	movl   $0xc010a0da,0xc(%esp)
c01064cf:	c0 
c01064d0:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01064d7:	c0 
c01064d8:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01064df:	00 
c01064e0:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01064e7:	e8 04 a8 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01064ec:	b8 10 10 00 00       	mov    $0x1010,%eax
c01064f1:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01064f4:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01064f9:	83 f8 01             	cmp    $0x1,%eax
c01064fc:	74 24                	je     c0106522 <check_content_set+0x72>
c01064fe:	c7 44 24 0c da a0 10 	movl   $0xc010a0da,0xc(%esp)
c0106505:	c0 
c0106506:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c010650d:	c0 
c010650e:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106515:	00 
c0106516:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c010651d:	e8 ce a7 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106522:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106527:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010652a:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010652f:	83 f8 02             	cmp    $0x2,%eax
c0106532:	74 24                	je     c0106558 <check_content_set+0xa8>
c0106534:	c7 44 24 0c e9 a0 10 	movl   $0xc010a0e9,0xc(%esp)
c010653b:	c0 
c010653c:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106543:	c0 
c0106544:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010654b:	00 
c010654c:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106553:	e8 98 a7 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106558:	b8 10 20 00 00       	mov    $0x2010,%eax
c010655d:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106560:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106565:	83 f8 02             	cmp    $0x2,%eax
c0106568:	74 24                	je     c010658e <check_content_set+0xde>
c010656a:	c7 44 24 0c e9 a0 10 	movl   $0xc010a0e9,0xc(%esp)
c0106571:	c0 
c0106572:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106579:	c0 
c010657a:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106581:	00 
c0106582:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106589:	e8 62 a7 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c010658e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106593:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106596:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010659b:	83 f8 03             	cmp    $0x3,%eax
c010659e:	74 24                	je     c01065c4 <check_content_set+0x114>
c01065a0:	c7 44 24 0c f8 a0 10 	movl   $0xc010a0f8,0xc(%esp)
c01065a7:	c0 
c01065a8:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01065af:	c0 
c01065b0:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01065b7:	00 
c01065b8:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01065bf:	e8 2c a7 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01065c4:	b8 10 30 00 00       	mov    $0x3010,%eax
c01065c9:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01065cc:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01065d1:	83 f8 03             	cmp    $0x3,%eax
c01065d4:	74 24                	je     c01065fa <check_content_set+0x14a>
c01065d6:	c7 44 24 0c f8 a0 10 	movl   $0xc010a0f8,0xc(%esp)
c01065dd:	c0 
c01065de:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01065e5:	c0 
c01065e6:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01065ed:	00 
c01065ee:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01065f5:	e8 f6 a6 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01065fa:	b8 00 40 00 00       	mov    $0x4000,%eax
c01065ff:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106602:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106607:	83 f8 04             	cmp    $0x4,%eax
c010660a:	74 24                	je     c0106630 <check_content_set+0x180>
c010660c:	c7 44 24 0c 07 a1 10 	movl   $0xc010a107,0xc(%esp)
c0106613:	c0 
c0106614:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c010661b:	c0 
c010661c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106623:	00 
c0106624:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c010662b:	e8 c0 a6 ff ff       	call   c0100cf0 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106630:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106635:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106638:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010663d:	83 f8 04             	cmp    $0x4,%eax
c0106640:	74 24                	je     c0106666 <check_content_set+0x1b6>
c0106642:	c7 44 24 0c 07 a1 10 	movl   $0xc010a107,0xc(%esp)
c0106649:	c0 
c010664a:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106651:	c0 
c0106652:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106659:	00 
c010665a:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106661:	e8 8a a6 ff ff       	call   c0100cf0 <__panic>
}
c0106666:	c9                   	leave  
c0106667:	c3                   	ret    

c0106668 <check_content_access>:

static inline int
check_content_access(void)
{
c0106668:	55                   	push   %ebp
c0106669:	89 e5                	mov    %esp,%ebp
c010666b:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010666e:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106673:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106676:	ff d0                	call   *%eax
c0106678:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010667b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010667e:	c9                   	leave  
c010667f:	c3                   	ret    

c0106680 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106680:	55                   	push   %ebp
c0106681:	89 e5                	mov    %esp,%ebp
c0106683:	53                   	push   %ebx
c0106684:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106687:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010668e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106695:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010669c:	eb 6b                	jmp    c0106709 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c010669e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01066a1:	83 e8 0c             	sub    $0xc,%eax
c01066a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01066a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066aa:	83 c0 04             	add    $0x4,%eax
c01066ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01066b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01066b7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01066ba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01066bd:	0f a3 10             	bt     %edx,(%eax)
c01066c0:	19 c0                	sbb    %eax,%eax
c01066c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01066c5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01066c9:	0f 95 c0             	setne  %al
c01066cc:	0f b6 c0             	movzbl %al,%eax
c01066cf:	85 c0                	test   %eax,%eax
c01066d1:	75 24                	jne    c01066f7 <check_swap+0x77>
c01066d3:	c7 44 24 0c 16 a1 10 	movl   $0xc010a116,0xc(%esp)
c01066da:	c0 
c01066db:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01066e2:	c0 
c01066e3:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01066ea:	00 
c01066eb:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01066f2:	e8 f9 a5 ff ff       	call   c0100cf0 <__panic>
        count ++, total += p->property;
c01066f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01066fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066fe:	8b 50 08             	mov    0x8(%eax),%edx
c0106701:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106704:	01 d0                	add    %edx,%eax
c0106706:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106709:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010670c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010670f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106712:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106715:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106718:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c010671f:	0f 85 79 ff ff ff    	jne    c010669e <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106725:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106728:	e8 bd e0 ff ff       	call   c01047ea <nr_free_pages>
c010672d:	39 c3                	cmp    %eax,%ebx
c010672f:	74 24                	je     c0106755 <check_swap+0xd5>
c0106731:	c7 44 24 0c 26 a1 10 	movl   $0xc010a126,0xc(%esp)
c0106738:	c0 
c0106739:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106740:	c0 
c0106741:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106748:	00 
c0106749:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106750:	e8 9b a5 ff ff       	call   c0100cf0 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106755:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106758:	89 44 24 08          	mov    %eax,0x8(%esp)
c010675c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010675f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106763:	c7 04 24 40 a1 10 c0 	movl   $0xc010a140,(%esp)
c010676a:	e8 dc 9b ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010676f:	e8 47 0a 00 00       	call   c01071bb <mm_create>
c0106774:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106777:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010677b:	75 24                	jne    c01067a1 <check_swap+0x121>
c010677d:	c7 44 24 0c 66 a1 10 	movl   $0xc010a166,0xc(%esp)
c0106784:	c0 
c0106785:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c010678c:	c0 
c010678d:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106794:	00 
c0106795:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c010679c:	e8 4f a5 ff ff       	call   c0100cf0 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01067a1:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01067a6:	85 c0                	test   %eax,%eax
c01067a8:	74 24                	je     c01067ce <check_swap+0x14e>
c01067aa:	c7 44 24 0c 71 a1 10 	movl   $0xc010a171,0xc(%esp)
c01067b1:	c0 
c01067b2:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01067b9:	c0 
c01067ba:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01067c1:	00 
c01067c2:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01067c9:	e8 22 a5 ff ff       	call   c0100cf0 <__panic>

     check_mm_struct = mm;
c01067ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067d1:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01067d6:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c01067dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067df:	89 50 0c             	mov    %edx,0xc(%eax)
c01067e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067e5:	8b 40 0c             	mov    0xc(%eax),%eax
c01067e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01067eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01067ee:	8b 00                	mov    (%eax),%eax
c01067f0:	85 c0                	test   %eax,%eax
c01067f2:	74 24                	je     c0106818 <check_swap+0x198>
c01067f4:	c7 44 24 0c 89 a1 10 	movl   $0xc010a189,0xc(%esp)
c01067fb:	c0 
c01067fc:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106803:	c0 
c0106804:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010680b:	00 
c010680c:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106813:	e8 d8 a4 ff ff       	call   c0100cf0 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106818:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c010681f:	00 
c0106820:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106827:	00 
c0106828:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c010682f:	e8 ff 09 00 00       	call   c0107233 <vma_create>
c0106834:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106837:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010683b:	75 24                	jne    c0106861 <check_swap+0x1e1>
c010683d:	c7 44 24 0c 97 a1 10 	movl   $0xc010a197,0xc(%esp)
c0106844:	c0 
c0106845:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c010684c:	c0 
c010684d:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106854:	00 
c0106855:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c010685c:	e8 8f a4 ff ff       	call   c0100cf0 <__panic>

     insert_vma_struct(mm, vma);
c0106861:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106864:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106868:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010686b:	89 04 24             	mov    %eax,(%esp)
c010686e:	e8 50 0b 00 00       	call   c01073c3 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106873:	c7 04 24 a4 a1 10 c0 	movl   $0xc010a1a4,(%esp)
c010687a:	e8 cc 9a ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c010687f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106886:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106889:	8b 40 0c             	mov    0xc(%eax),%eax
c010688c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106893:	00 
c0106894:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010689b:	00 
c010689c:	89 04 24             	mov    %eax,(%esp)
c010689f:	e8 0b e6 ff ff       	call   c0104eaf <get_pte>
c01068a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01068a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01068ab:	75 24                	jne    c01068d1 <check_swap+0x251>
c01068ad:	c7 44 24 0c d8 a1 10 	movl   $0xc010a1d8,0xc(%esp)
c01068b4:	c0 
c01068b5:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01068bc:	c0 
c01068bd:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01068c4:	00 
c01068c5:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01068cc:	e8 1f a4 ff ff       	call   c0100cf0 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01068d1:	c7 04 24 ec a1 10 c0 	movl   $0xc010a1ec,(%esp)
c01068d8:	e8 6e 9a ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01068e4:	e9 a3 00 00 00       	jmp    c010698c <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01068e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01068f0:	e8 58 de ff ff       	call   c010474d <alloc_pages>
c01068f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068f8:	89 04 95 e0 1a 12 c0 	mov    %eax,-0x3fede520(,%edx,4)
          assert(check_rp[i] != NULL );
c01068ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106902:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106909:	85 c0                	test   %eax,%eax
c010690b:	75 24                	jne    c0106931 <check_swap+0x2b1>
c010690d:	c7 44 24 0c 10 a2 10 	movl   $0xc010a210,0xc(%esp)
c0106914:	c0 
c0106915:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c010691c:	c0 
c010691d:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106924:	00 
c0106925:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c010692c:	e8 bf a3 ff ff       	call   c0100cf0 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106931:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106934:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c010693b:	83 c0 04             	add    $0x4,%eax
c010693e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106945:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106948:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010694b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010694e:	0f a3 10             	bt     %edx,(%eax)
c0106951:	19 c0                	sbb    %eax,%eax
c0106953:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106956:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010695a:	0f 95 c0             	setne  %al
c010695d:	0f b6 c0             	movzbl %al,%eax
c0106960:	85 c0                	test   %eax,%eax
c0106962:	74 24                	je     c0106988 <check_swap+0x308>
c0106964:	c7 44 24 0c 24 a2 10 	movl   $0xc010a224,0xc(%esp)
c010696b:	c0 
c010696c:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106973:	c0 
c0106974:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010697b:	00 
c010697c:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106983:	e8 68 a3 ff ff       	call   c0100cf0 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106988:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010698c:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106990:	0f 8e 53 ff ff ff    	jle    c01068e9 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106996:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c010699b:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c01069a1:	89 45 98             	mov    %eax,-0x68(%ebp)
c01069a4:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01069a7:	c7 45 a8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01069ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01069b1:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01069b4:	89 50 04             	mov    %edx,0x4(%eax)
c01069b7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01069ba:	8b 50 04             	mov    0x4(%eax),%edx
c01069bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01069c0:	89 10                	mov    %edx,(%eax)
c01069c2:	c7 45 a4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01069c9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01069cc:	8b 40 04             	mov    0x4(%eax),%eax
c01069cf:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01069d2:	0f 94 c0             	sete   %al
c01069d5:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01069d8:	85 c0                	test   %eax,%eax
c01069da:	75 24                	jne    c0106a00 <check_swap+0x380>
c01069dc:	c7 44 24 0c 3f a2 10 	movl   $0xc010a23f,0xc(%esp)
c01069e3:	c0 
c01069e4:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c01069eb:	c0 
c01069ec:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01069f3:	00 
c01069f4:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c01069fb:	e8 f0 a2 ff ff       	call   c0100cf0 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106a00:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106a05:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106a08:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0106a0f:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a19:	eb 1e                	jmp    c0106a39 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a1e:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106a25:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a2c:	00 
c0106a2d:	89 04 24             	mov    %eax,(%esp)
c0106a30:	e8 83 dd ff ff       	call   c01047b8 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a35:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a39:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106a3d:	7e dc                	jle    c0106a1b <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106a3f:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106a44:	83 f8 04             	cmp    $0x4,%eax
c0106a47:	74 24                	je     c0106a6d <check_swap+0x3ed>
c0106a49:	c7 44 24 0c 58 a2 10 	movl   $0xc010a258,0xc(%esp)
c0106a50:	c0 
c0106a51:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106a58:	c0 
c0106a59:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106a60:	00 
c0106a61:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106a68:	e8 83 a2 ff ff       	call   c0100cf0 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106a6d:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106a74:	e8 d2 98 ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106a79:	c7 05 b8 1a 12 c0 00 	movl   $0x0,0xc0121ab8
c0106a80:	00 00 00 
     
     check_content_set();
c0106a83:	e8 28 fa ff ff       	call   c01064b0 <check_content_set>
     assert( nr_free == 0);         
c0106a88:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106a8d:	85 c0                	test   %eax,%eax
c0106a8f:	74 24                	je     c0106ab5 <check_swap+0x435>
c0106a91:	c7 44 24 0c a3 a2 10 	movl   $0xc010a2a3,0xc(%esp)
c0106a98:	c0 
c0106a99:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106aa0:	c0 
c0106aa1:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106aa8:	00 
c0106aa9:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106ab0:	e8 3b a2 ff ff       	call   c0100cf0 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106ab5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106abc:	eb 26                	jmp    c0106ae4 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ac1:	c7 04 85 00 1b 12 c0 	movl   $0xffffffff,-0x3fede500(,%eax,4)
c0106ac8:	ff ff ff ff 
c0106acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106acf:	8b 14 85 00 1b 12 c0 	mov    -0x3fede500(,%eax,4),%edx
c0106ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ad9:	89 14 85 40 1b 12 c0 	mov    %edx,-0x3fede4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106ae0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106ae4:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106ae8:	7e d4                	jle    c0106abe <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106aea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106af1:	e9 eb 00 00 00       	jmp    c0106be1 <check_swap+0x561>
         check_ptep[i]=0;
c0106af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106af9:	c7 04 85 94 1b 12 c0 	movl   $0x0,-0x3fede46c(,%eax,4)
c0106b00:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b07:	83 c0 01             	add    $0x1,%eax
c0106b0a:	c1 e0 0c             	shl    $0xc,%eax
c0106b0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106b14:	00 
c0106b15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b19:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106b1c:	89 04 24             	mov    %eax,(%esp)
c0106b1f:	e8 8b e3 ff ff       	call   c0104eaf <get_pte>
c0106b24:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106b27:	89 04 95 94 1b 12 c0 	mov    %eax,-0x3fede46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b31:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106b38:	85 c0                	test   %eax,%eax
c0106b3a:	75 24                	jne    c0106b60 <check_swap+0x4e0>
c0106b3c:	c7 44 24 0c b0 a2 10 	movl   $0xc010a2b0,0xc(%esp)
c0106b43:	c0 
c0106b44:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106b4b:	c0 
c0106b4c:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106b53:	00 
c0106b54:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106b5b:	e8 90 a1 ff ff       	call   c0100cf0 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b63:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106b6a:	8b 00                	mov    (%eax),%eax
c0106b6c:	89 04 24             	mov    %eax,(%esp)
c0106b6f:	e8 9f f5 ff ff       	call   c0106113 <pte2page>
c0106b74:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106b77:	8b 14 95 e0 1a 12 c0 	mov    -0x3fede520(,%edx,4),%edx
c0106b7e:	39 d0                	cmp    %edx,%eax
c0106b80:	74 24                	je     c0106ba6 <check_swap+0x526>
c0106b82:	c7 44 24 0c c8 a2 10 	movl   $0xc010a2c8,0xc(%esp)
c0106b89:	c0 
c0106b8a:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106b91:	c0 
c0106b92:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106b99:	00 
c0106b9a:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106ba1:	e8 4a a1 ff ff       	call   c0100cf0 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ba9:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106bb0:	8b 00                	mov    (%eax),%eax
c0106bb2:	83 e0 01             	and    $0x1,%eax
c0106bb5:	85 c0                	test   %eax,%eax
c0106bb7:	75 24                	jne    c0106bdd <check_swap+0x55d>
c0106bb9:	c7 44 24 0c f0 a2 10 	movl   $0xc010a2f0,0xc(%esp)
c0106bc0:	c0 
c0106bc1:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106bc8:	c0 
c0106bc9:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106bd0:	00 
c0106bd1:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106bd8:	e8 13 a1 ff ff       	call   c0100cf0 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106bdd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106be1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106be5:	0f 8e 0b ff ff ff    	jle    c0106af6 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106beb:	c7 04 24 0c a3 10 c0 	movl   $0xc010a30c,(%esp)
c0106bf2:	e8 54 97 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106bf7:	e8 6c fa ff ff       	call   c0106668 <check_content_access>
c0106bfc:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106bff:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106c03:	74 24                	je     c0106c29 <check_swap+0x5a9>
c0106c05:	c7 44 24 0c 32 a3 10 	movl   $0xc010a332,0xc(%esp)
c0106c0c:	c0 
c0106c0d:	c7 44 24 08 1a a0 10 	movl   $0xc010a01a,0x8(%esp)
c0106c14:	c0 
c0106c15:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106c1c:	00 
c0106c1d:	c7 04 24 b4 9f 10 c0 	movl   $0xc0109fb4,(%esp)
c0106c24:	e8 c7 a0 ff ff       	call   c0100cf0 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106c29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106c30:	eb 1e                	jmp    c0106c50 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c35:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106c3c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106c43:	00 
c0106c44:	89 04 24             	mov    %eax,(%esp)
c0106c47:	e8 6c db ff ff       	call   c01047b8 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106c4c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106c50:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106c54:	7e dc                	jle    c0106c32 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106c56:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c59:	89 04 24             	mov    %eax,(%esp)
c0106c5c:	e8 92 08 00 00       	call   c01074f3 <mm_destroy>
         
     nr_free = nr_free_store;
c0106c61:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106c64:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
     free_list = free_list_store;
c0106c69:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106c6c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106c6f:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0106c74:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4

     
     le = &free_list;
c0106c7a:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106c81:	eb 1d                	jmp    c0106ca0 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c86:	83 e8 0c             	sub    $0xc,%eax
c0106c89:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106c8c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106c90:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106c93:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106c96:	8b 40 08             	mov    0x8(%eax),%eax
c0106c99:	29 c2                	sub    %eax,%edx
c0106c9b:	89 d0                	mov    %edx,%eax
c0106c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ca0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ca3:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106ca6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106ca9:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106caf:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c0106cb6:	75 cb                	jne    c0106c83 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cc6:	c7 04 24 39 a3 10 c0 	movl   $0xc010a339,(%esp)
c0106ccd:	e8 79 96 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106cd2:	c7 04 24 53 a3 10 c0 	movl   $0xc010a353,(%esp)
c0106cd9:	e8 6d 96 ff ff       	call   c010034b <cprintf>
}
c0106cde:	83 c4 74             	add    $0x74,%esp
c0106ce1:	5b                   	pop    %ebx
c0106ce2:	5d                   	pop    %ebp
c0106ce3:	c3                   	ret    

c0106ce4 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106ce4:	55                   	push   %ebp
c0106ce5:	89 e5                	mov    %esp,%ebp
c0106ce7:	83 ec 10             	sub    $0x10,%esp
c0106cea:	c7 45 fc a4 1b 12 c0 	movl   $0xc0121ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106cf4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106cf7:	89 50 04             	mov    %edx,0x4(%eax)
c0106cfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106cfd:	8b 50 04             	mov    0x4(%eax),%edx
c0106d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d03:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d08:	c7 40 14 a4 1b 12 c0 	movl   $0xc0121ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106d0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d14:	c9                   	leave  
c0106d15:	c3                   	ret    

c0106d16 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106d16:	55                   	push   %ebp
c0106d17:	89 e5                	mov    %esp,%ebp
c0106d19:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d1f:	8b 40 14             	mov    0x14(%eax),%eax
c0106d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106d25:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d28:	83 c0 14             	add    $0x14,%eax
c0106d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106d2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106d32:	74 06                	je     c0106d3a <_fifo_map_swappable+0x24>
c0106d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d38:	75 24                	jne    c0106d5e <_fifo_map_swappable+0x48>
c0106d3a:	c7 44 24 0c 6c a3 10 	movl   $0xc010a36c,0xc(%esp)
c0106d41:	c0 
c0106d42:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106d49:	c0 
c0106d4a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106d51:	00 
c0106d52:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106d59:	e8 92 9f ff ff       	call   c0100cf0 <__panic>
c0106d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d61:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d67:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d73:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d79:	8b 40 04             	mov    0x4(%eax),%eax
c0106d7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106d82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d85:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106d88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106d8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d91:	89 10                	mov    %edx,(%eax)
c0106d93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d96:	8b 10                	mov    (%eax),%edx
c0106d98:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106d9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106da1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106da4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106daa:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106dad:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c0106daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106db4:	c9                   	leave  
c0106db5:	c3                   	ret    

c0106db6 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106db6:	55                   	push   %ebp
c0106db7:	89 e5                	mov    %esp,%ebp
c0106db9:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dbf:	8b 40 14             	mov    0x14(%eax),%eax
c0106dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106dc9:	75 24                	jne    c0106def <_fifo_swap_out_victim+0x39>
c0106dcb:	c7 44 24 0c b3 a3 10 	movl   $0xc010a3b3,0xc(%esp)
c0106dd2:	c0 
c0106dd3:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106dda:	c0 
c0106ddb:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106de2:	00 
c0106de3:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106dea:	e8 01 9f ff ff       	call   c0100cf0 <__panic>
     assert(in_tick==0);
c0106def:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106df3:	74 24                	je     c0106e19 <_fifo_swap_out_victim+0x63>
c0106df5:	c7 44 24 0c c0 a3 10 	movl   $0xc010a3c0,0xc(%esp)
c0106dfc:	c0 
c0106dfd:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106e04:	c0 
c0106e05:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106e0c:	00 
c0106e0d:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106e14:	e8 d7 9e ff ff       	call   c0100cf0 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *head_prev = head->prev;
c0106e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e1c:	8b 00                	mov    (%eax),%eax
c0106e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head != head_prev);
c0106e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106e27:	75 24                	jne    c0106e4d <_fifo_swap_out_victim+0x97>
c0106e29:	c7 44 24 0c cb a3 10 	movl   $0xc010a3cb,0xc(%esp)
c0106e30:	c0 
c0106e31:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106e38:	c0 
c0106e39:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0106e40:	00 
c0106e41:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106e48:	e8 a3 9e ff ff       	call   c0100cf0 <__panic>
c0106e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106e56:	8b 40 04             	mov    0x4(%eax),%eax
c0106e59:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106e5c:	8b 12                	mov    (%edx),%edx
c0106e5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106e61:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e67:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106e6a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e73:	89 10                	mov    %edx,(%eax)
     list_del(head_prev);
     struct Page *p = le2page(head_prev, pra_page_link);
c0106e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e78:	83 e8 14             	sub    $0x14,%eax
c0106e7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     assert(p != NULL);
c0106e7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106e82:	75 24                	jne    c0106ea8 <_fifo_swap_out_victim+0xf2>
c0106e84:	c7 44 24 0c dd a3 10 	movl   $0xc010a3dd,0xc(%esp)
c0106e8b:	c0 
c0106e8c:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106e93:	c0 
c0106e94:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0106e9b:	00 
c0106e9c:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106ea3:	e8 48 9e ff ff       	call   c0100cf0 <__panic>
     *ptr_page = p;
c0106ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106eab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106eae:	89 10                	mov    %edx,(%eax)
     return 0;
c0106eb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106eb5:	c9                   	leave  
c0106eb6:	c3                   	ret    

c0106eb7 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106eb7:	55                   	push   %ebp
c0106eb8:	89 e5                	mov    %esp,%ebp
c0106eba:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106ebd:	c7 04 24 e8 a3 10 c0 	movl   $0xc010a3e8,(%esp)
c0106ec4:	e8 82 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106ec9:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106ece:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106ed1:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106ed6:	83 f8 04             	cmp    $0x4,%eax
c0106ed9:	74 24                	je     c0106eff <_fifo_check_swap+0x48>
c0106edb:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0106ee2:	c0 
c0106ee3:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106eea:	c0 
c0106eeb:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0106ef2:	00 
c0106ef3:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106efa:	e8 f1 9d ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106eff:	c7 04 24 20 a4 10 c0 	movl   $0xc010a420,(%esp)
c0106f06:	e8 40 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106f0b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106f10:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106f13:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f18:	83 f8 04             	cmp    $0x4,%eax
c0106f1b:	74 24                	je     c0106f41 <_fifo_check_swap+0x8a>
c0106f1d:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0106f24:	c0 
c0106f25:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106f2c:	c0 
c0106f2d:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0106f34:	00 
c0106f35:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106f3c:	e8 af 9d ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106f41:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c0106f48:	e8 fe 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106f4d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106f52:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106f55:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f5a:	83 f8 04             	cmp    $0x4,%eax
c0106f5d:	74 24                	je     c0106f83 <_fifo_check_swap+0xcc>
c0106f5f:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0106f66:	c0 
c0106f67:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106f6e:	c0 
c0106f6f:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0106f76:	00 
c0106f77:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106f7e:	e8 6d 9d ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106f83:	c7 04 24 70 a4 10 c0 	movl   $0xc010a470,(%esp)
c0106f8a:	e8 bc 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f8f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f94:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106f97:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f9c:	83 f8 04             	cmp    $0x4,%eax
c0106f9f:	74 24                	je     c0106fc5 <_fifo_check_swap+0x10e>
c0106fa1:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0106fa8:	c0 
c0106fa9:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106fb0:	c0 
c0106fb1:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0106fb8:	00 
c0106fb9:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0106fc0:	e8 2b 9d ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106fc5:	c7 04 24 98 a4 10 c0 	movl   $0xc010a498,(%esp)
c0106fcc:	e8 7a 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106fd1:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106fd6:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106fd9:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106fde:	83 f8 05             	cmp    $0x5,%eax
c0106fe1:	74 24                	je     c0107007 <_fifo_check_swap+0x150>
c0106fe3:	c7 44 24 0c be a4 10 	movl   $0xc010a4be,0xc(%esp)
c0106fea:	c0 
c0106feb:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0106ff2:	c0 
c0106ff3:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0106ffa:	00 
c0106ffb:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0107002:	e8 e9 9c ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107007:	c7 04 24 70 a4 10 c0 	movl   $0xc010a470,(%esp)
c010700e:	e8 38 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107013:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107018:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010701b:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107020:	83 f8 05             	cmp    $0x5,%eax
c0107023:	74 24                	je     c0107049 <_fifo_check_swap+0x192>
c0107025:	c7 44 24 0c be a4 10 	movl   $0xc010a4be,0xc(%esp)
c010702c:	c0 
c010702d:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0107034:	c0 
c0107035:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010703c:	00 
c010703d:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0107044:	e8 a7 9c ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107049:	c7 04 24 20 a4 10 c0 	movl   $0xc010a420,(%esp)
c0107050:	e8 f6 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107055:	b8 00 10 00 00       	mov    $0x1000,%eax
c010705a:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c010705d:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107062:	83 f8 06             	cmp    $0x6,%eax
c0107065:	74 24                	je     c010708b <_fifo_check_swap+0x1d4>
c0107067:	c7 44 24 0c cd a4 10 	movl   $0xc010a4cd,0xc(%esp)
c010706e:	c0 
c010706f:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c0107076:	c0 
c0107077:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010707e:	00 
c010707f:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c0107086:	e8 65 9c ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010708b:	c7 04 24 70 a4 10 c0 	movl   $0xc010a470,(%esp)
c0107092:	e8 b4 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107097:	b8 00 20 00 00       	mov    $0x2000,%eax
c010709c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c010709f:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01070a4:	83 f8 07             	cmp    $0x7,%eax
c01070a7:	74 24                	je     c01070cd <_fifo_check_swap+0x216>
c01070a9:	c7 44 24 0c dc a4 10 	movl   $0xc010a4dc,0xc(%esp)
c01070b0:	c0 
c01070b1:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c01070b8:	c0 
c01070b9:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01070c0:	00 
c01070c1:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c01070c8:	e8 23 9c ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01070cd:	c7 04 24 e8 a3 10 c0 	movl   $0xc010a3e8,(%esp)
c01070d4:	e8 72 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01070d9:	b8 00 30 00 00       	mov    $0x3000,%eax
c01070de:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01070e1:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01070e6:	83 f8 08             	cmp    $0x8,%eax
c01070e9:	74 24                	je     c010710f <_fifo_check_swap+0x258>
c01070eb:	c7 44 24 0c eb a4 10 	movl   $0xc010a4eb,0xc(%esp)
c01070f2:	c0 
c01070f3:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c01070fa:	c0 
c01070fb:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107102:	00 
c0107103:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c010710a:	e8 e1 9b ff ff       	call   c0100cf0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010710f:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c0107116:	e8 30 92 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010711b:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107120:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107123:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107128:	83 f8 09             	cmp    $0x9,%eax
c010712b:	74 24                	je     c0107151 <_fifo_check_swap+0x29a>
c010712d:	c7 44 24 0c fa a4 10 	movl   $0xc010a4fa,0xc(%esp)
c0107134:	c0 
c0107135:	c7 44 24 08 8a a3 10 	movl   $0xc010a38a,0x8(%esp)
c010713c:	c0 
c010713d:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107144:	00 
c0107145:	c7 04 24 9f a3 10 c0 	movl   $0xc010a39f,(%esp)
c010714c:	e8 9f 9b ff ff       	call   c0100cf0 <__panic>
    return 0;
c0107151:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107156:	c9                   	leave  
c0107157:	c3                   	ret    

c0107158 <_fifo_init>:


static int
_fifo_init(void)
{
c0107158:	55                   	push   %ebp
c0107159:	89 e5                	mov    %esp,%ebp
    return 0;
c010715b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107160:	5d                   	pop    %ebp
c0107161:	c3                   	ret    

c0107162 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107162:	55                   	push   %ebp
c0107163:	89 e5                	mov    %esp,%ebp
    return 0;
c0107165:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010716a:	5d                   	pop    %ebp
c010716b:	c3                   	ret    

c010716c <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c010716c:	55                   	push   %ebp
c010716d:	89 e5                	mov    %esp,%ebp
c010716f:	b8 00 00 00 00       	mov    $0x0,%eax
c0107174:	5d                   	pop    %ebp
c0107175:	c3                   	ret    

c0107176 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107176:	55                   	push   %ebp
c0107177:	89 e5                	mov    %esp,%ebp
c0107179:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010717c:	8b 45 08             	mov    0x8(%ebp),%eax
c010717f:	c1 e8 0c             	shr    $0xc,%eax
c0107182:	89 c2                	mov    %eax,%edx
c0107184:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107189:	39 c2                	cmp    %eax,%edx
c010718b:	72 1c                	jb     c01071a9 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010718d:	c7 44 24 08 1c a5 10 	movl   $0xc010a51c,0x8(%esp)
c0107194:	c0 
c0107195:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010719c:	00 
c010719d:	c7 04 24 3b a5 10 c0 	movl   $0xc010a53b,(%esp)
c01071a4:	e8 47 9b ff ff       	call   c0100cf0 <__panic>
    }
    return &pages[PPN(pa)];
c01071a9:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01071ae:	8b 55 08             	mov    0x8(%ebp),%edx
c01071b1:	c1 ea 0c             	shr    $0xc,%edx
c01071b4:	c1 e2 05             	shl    $0x5,%edx
c01071b7:	01 d0                	add    %edx,%eax
}
c01071b9:	c9                   	leave  
c01071ba:	c3                   	ret    

c01071bb <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01071bb:	55                   	push   %ebp
c01071bc:	89 e5                	mov    %esp,%ebp
c01071be:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01071c1:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01071c8:	e8 c7 ed ff ff       	call   c0105f94 <kmalloc>
c01071cd:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01071d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071d4:	74 58                	je     c010722e <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01071d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01071dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01071e2:	89 50 04             	mov    %edx,0x4(%eax)
c01071e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071e8:	8b 50 04             	mov    0x4(%eax),%edx
c01071eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071ee:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01071f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01071fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107204:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107207:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010720e:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107213:	85 c0                	test   %eax,%eax
c0107215:	74 0d                	je     c0107224 <mm_create+0x69>
c0107217:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010721a:	89 04 24             	mov    %eax,(%esp)
c010721d:	e8 bf ef ff ff       	call   c01061e1 <swap_init_mm>
c0107222:	eb 0a                	jmp    c010722e <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107224:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107227:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010722e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107231:	c9                   	leave  
c0107232:	c3                   	ret    

c0107233 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107233:	55                   	push   %ebp
c0107234:	89 e5                	mov    %esp,%ebp
c0107236:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107239:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107240:	e8 4f ed ff ff       	call   c0105f94 <kmalloc>
c0107245:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010724c:	74 1b                	je     c0107269 <vma_create+0x36>
        vma->vm_start = vm_start;
c010724e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107251:	8b 55 08             	mov    0x8(%ebp),%edx
c0107254:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107257:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010725a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010725d:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107260:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107263:	8b 55 10             	mov    0x10(%ebp),%edx
c0107266:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107269:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010726c:	c9                   	leave  
c010726d:	c3                   	ret    

c010726e <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c010726e:	55                   	push   %ebp
c010726f:	89 e5                	mov    %esp,%ebp
c0107271:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010727b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010727f:	0f 84 95 00 00 00    	je     c010731a <find_vma+0xac>
        vma = mm->mmap_cache;
c0107285:	8b 45 08             	mov    0x8(%ebp),%eax
c0107288:	8b 40 08             	mov    0x8(%eax),%eax
c010728b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010728e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107292:	74 16                	je     c01072aa <find_vma+0x3c>
c0107294:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107297:	8b 40 04             	mov    0x4(%eax),%eax
c010729a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010729d:	77 0b                	ja     c01072aa <find_vma+0x3c>
c010729f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072a2:	8b 40 08             	mov    0x8(%eax),%eax
c01072a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072a8:	77 61                	ja     c010730b <find_vma+0x9d>
                bool found = 0;
c01072aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01072b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01072b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01072bd:	eb 28                	jmp    c01072e7 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01072bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072c2:	83 e8 10             	sub    $0x10,%eax
c01072c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01072c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072cb:	8b 40 04             	mov    0x4(%eax),%eax
c01072ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072d1:	77 14                	ja     c01072e7 <find_vma+0x79>
c01072d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072d6:	8b 40 08             	mov    0x8(%eax),%eax
c01072d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01072dc:	76 09                	jbe    c01072e7 <find_vma+0x79>
                        found = 1;
c01072de:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01072e5:	eb 17                	jmp    c01072fe <find_vma+0x90>
c01072e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01072ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072f0:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01072f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01072f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01072fc:	75 c1                	jne    c01072bf <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c01072fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107302:	75 07                	jne    c010730b <find_vma+0x9d>
                    vma = NULL;
c0107304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c010730b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010730f:	74 09                	je     c010731a <find_vma+0xac>
            mm->mmap_cache = vma;
c0107311:	8b 45 08             	mov    0x8(%ebp),%eax
c0107314:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107317:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c010731a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010731d:	c9                   	leave  
c010731e:	c3                   	ret    

c010731f <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c010731f:	55                   	push   %ebp
c0107320:	89 e5                	mov    %esp,%ebp
c0107322:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107325:	8b 45 08             	mov    0x8(%ebp),%eax
c0107328:	8b 50 04             	mov    0x4(%eax),%edx
c010732b:	8b 45 08             	mov    0x8(%ebp),%eax
c010732e:	8b 40 08             	mov    0x8(%eax),%eax
c0107331:	39 c2                	cmp    %eax,%edx
c0107333:	72 24                	jb     c0107359 <check_vma_overlap+0x3a>
c0107335:	c7 44 24 0c 49 a5 10 	movl   $0xc010a549,0xc(%esp)
c010733c:	c0 
c010733d:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107344:	c0 
c0107345:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010734c:	00 
c010734d:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107354:	e8 97 99 ff ff       	call   c0100cf0 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107359:	8b 45 08             	mov    0x8(%ebp),%eax
c010735c:	8b 50 08             	mov    0x8(%eax),%edx
c010735f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107362:	8b 40 04             	mov    0x4(%eax),%eax
c0107365:	39 c2                	cmp    %eax,%edx
c0107367:	76 24                	jbe    c010738d <check_vma_overlap+0x6e>
c0107369:	c7 44 24 0c 8c a5 10 	movl   $0xc010a58c,0xc(%esp)
c0107370:	c0 
c0107371:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107378:	c0 
c0107379:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107380:	00 
c0107381:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107388:	e8 63 99 ff ff       	call   c0100cf0 <__panic>
    assert(next->vm_start < next->vm_end);
c010738d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107390:	8b 50 04             	mov    0x4(%eax),%edx
c0107393:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107396:	8b 40 08             	mov    0x8(%eax),%eax
c0107399:	39 c2                	cmp    %eax,%edx
c010739b:	72 24                	jb     c01073c1 <check_vma_overlap+0xa2>
c010739d:	c7 44 24 0c ab a5 10 	movl   $0xc010a5ab,0xc(%esp)
c01073a4:	c0 
c01073a5:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01073ac:	c0 
c01073ad:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01073b4:	00 
c01073b5:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01073bc:	e8 2f 99 ff ff       	call   c0100cf0 <__panic>
}
c01073c1:	c9                   	leave  
c01073c2:	c3                   	ret    

c01073c3 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01073c3:	55                   	push   %ebp
c01073c4:	89 e5                	mov    %esp,%ebp
c01073c6:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01073c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073cc:	8b 50 04             	mov    0x4(%eax),%edx
c01073cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073d2:	8b 40 08             	mov    0x8(%eax),%eax
c01073d5:	39 c2                	cmp    %eax,%edx
c01073d7:	72 24                	jb     c01073fd <insert_vma_struct+0x3a>
c01073d9:	c7 44 24 0c c9 a5 10 	movl   $0xc010a5c9,0xc(%esp)
c01073e0:	c0 
c01073e1:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01073e8:	c0 
c01073e9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01073f0:	00 
c01073f1:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01073f8:	e8 f3 98 ff ff       	call   c0100cf0 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c01073fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107400:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107403:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107406:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107409:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010740c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010740f:	eb 21                	jmp    c0107432 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107411:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107414:	83 e8 10             	sub    $0x10,%eax
c0107417:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c010741a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010741d:	8b 50 04             	mov    0x4(%eax),%edx
c0107420:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107423:	8b 40 04             	mov    0x4(%eax),%eax
c0107426:	39 c2                	cmp    %eax,%edx
c0107428:	76 02                	jbe    c010742c <insert_vma_struct+0x69>
                break;
c010742a:	eb 1d                	jmp    c0107449 <insert_vma_struct+0x86>
            }
            le_prev = le;
c010742c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010742f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107432:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107435:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107438:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010743b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010743e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107441:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107444:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107447:	75 c8                	jne    c0107411 <insert_vma_struct+0x4e>
c0107449:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010744c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010744f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107452:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107455:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010745b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010745e:	74 15                	je     c0107475 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107460:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107463:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107466:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107469:	89 44 24 04          	mov    %eax,0x4(%esp)
c010746d:	89 14 24             	mov    %edx,(%esp)
c0107470:	e8 aa fe ff ff       	call   c010731f <check_vma_overlap>
    }
    if (le_next != list) {
c0107475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107478:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010747b:	74 15                	je     c0107492 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c010747d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107480:	83 e8 10             	sub    $0x10,%eax
c0107483:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010748a:	89 04 24             	mov    %eax,(%esp)
c010748d:	e8 8d fe ff ff       	call   c010731f <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107495:	8b 55 08             	mov    0x8(%ebp),%edx
c0107498:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c010749a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010749d:	8d 50 10             	lea    0x10(%eax),%edx
c01074a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01074a6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01074a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01074ac:	8b 40 04             	mov    0x4(%eax),%eax
c01074af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01074b2:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01074b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01074b8:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01074bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01074be:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01074c1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01074c4:	89 10                	mov    %edx,(%eax)
c01074c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01074c9:	8b 10                	mov    (%eax),%edx
c01074cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01074ce:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01074d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01074d4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01074d7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01074da:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01074dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01074e0:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01074e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01074e5:	8b 40 10             	mov    0x10(%eax),%eax
c01074e8:	8d 50 01             	lea    0x1(%eax),%edx
c01074eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01074ee:	89 50 10             	mov    %edx,0x10(%eax)
}
c01074f1:	c9                   	leave  
c01074f2:	c3                   	ret    

c01074f3 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01074f3:	55                   	push   %ebp
c01074f4:	89 e5                	mov    %esp,%ebp
c01074f6:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01074f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01074fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c01074ff:	eb 3e                	jmp    c010753f <mm_destroy+0x4c>
c0107501:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107504:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107507:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010750a:	8b 40 04             	mov    0x4(%eax),%eax
c010750d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107510:	8b 12                	mov    (%edx),%edx
c0107512:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107518:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010751b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010751e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107524:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107527:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0107529:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010752c:	83 e8 10             	sub    $0x10,%eax
c010752f:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107536:	00 
c0107537:	89 04 24             	mov    %eax,(%esp)
c010753a:	e8 f5 ea ff ff       	call   c0106034 <kfree>
c010753f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107542:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107545:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107548:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010754b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010754e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107554:	75 ab                	jne    c0107501 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0107556:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010755d:	00 
c010755e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107561:	89 04 24             	mov    %eax,(%esp)
c0107564:	e8 cb ea ff ff       	call   c0106034 <kfree>
    mm=NULL;
c0107569:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107570:	c9                   	leave  
c0107571:	c3                   	ret    

c0107572 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107572:	55                   	push   %ebp
c0107573:	89 e5                	mov    %esp,%ebp
c0107575:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107578:	e8 02 00 00 00       	call   c010757f <check_vmm>
}
c010757d:	c9                   	leave  
c010757e:	c3                   	ret    

c010757f <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010757f:	55                   	push   %ebp
c0107580:	89 e5                	mov    %esp,%ebp
c0107582:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107585:	e8 60 d2 ff ff       	call   c01047ea <nr_free_pages>
c010758a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c010758d:	e8 41 00 00 00       	call   c01075d3 <check_vma_struct>
    check_pgfault();
c0107592:	e8 03 05 00 00       	call   c0107a9a <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0107597:	e8 4e d2 ff ff       	call   c01047ea <nr_free_pages>
c010759c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010759f:	74 24                	je     c01075c5 <check_vmm+0x46>
c01075a1:	c7 44 24 0c e8 a5 10 	movl   $0xc010a5e8,0xc(%esp)
c01075a8:	c0 
c01075a9:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01075b0:	c0 
c01075b1:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c01075b8:	00 
c01075b9:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01075c0:	e8 2b 97 ff ff       	call   c0100cf0 <__panic>

    cprintf("check_vmm() succeeded.\n");
c01075c5:	c7 04 24 0f a6 10 c0 	movl   $0xc010a60f,(%esp)
c01075cc:	e8 7a 8d ff ff       	call   c010034b <cprintf>
}
c01075d1:	c9                   	leave  
c01075d2:	c3                   	ret    

c01075d3 <check_vma_struct>:

static void
check_vma_struct(void) {
c01075d3:	55                   	push   %ebp
c01075d4:	89 e5                	mov    %esp,%ebp
c01075d6:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01075d9:	e8 0c d2 ff ff       	call   c01047ea <nr_free_pages>
c01075de:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01075e1:	e8 d5 fb ff ff       	call   c01071bb <mm_create>
c01075e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01075e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01075ed:	75 24                	jne    c0107613 <check_vma_struct+0x40>
c01075ef:	c7 44 24 0c 27 a6 10 	movl   $0xc010a627,0xc(%esp)
c01075f6:	c0 
c01075f7:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01075fe:	c0 
c01075ff:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107606:	00 
c0107607:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c010760e:	e8 dd 96 ff ff       	call   c0100cf0 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107613:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010761a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010761d:	89 d0                	mov    %edx,%eax
c010761f:	c1 e0 02             	shl    $0x2,%eax
c0107622:	01 d0                	add    %edx,%eax
c0107624:	01 c0                	add    %eax,%eax
c0107626:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010762c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010762f:	eb 70                	jmp    c01076a1 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107631:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107634:	89 d0                	mov    %edx,%eax
c0107636:	c1 e0 02             	shl    $0x2,%eax
c0107639:	01 d0                	add    %edx,%eax
c010763b:	83 c0 02             	add    $0x2,%eax
c010763e:	89 c1                	mov    %eax,%ecx
c0107640:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107643:	89 d0                	mov    %edx,%eax
c0107645:	c1 e0 02             	shl    $0x2,%eax
c0107648:	01 d0                	add    %edx,%eax
c010764a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107651:	00 
c0107652:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107656:	89 04 24             	mov    %eax,(%esp)
c0107659:	e8 d5 fb ff ff       	call   c0107233 <vma_create>
c010765e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107661:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107665:	75 24                	jne    c010768b <check_vma_struct+0xb8>
c0107667:	c7 44 24 0c 32 a6 10 	movl   $0xc010a632,0xc(%esp)
c010766e:	c0 
c010766f:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107676:	c0 
c0107677:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010767e:	00 
c010767f:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107686:	e8 65 96 ff ff       	call   c0100cf0 <__panic>
        insert_vma_struct(mm, vma);
c010768b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010768e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107692:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107695:	89 04 24             	mov    %eax,(%esp)
c0107698:	e8 26 fd ff ff       	call   c01073c3 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c010769d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01076a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076a5:	7f 8a                	jg     c0107631 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01076a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076aa:	83 c0 01             	add    $0x1,%eax
c01076ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01076b0:	eb 70                	jmp    c0107722 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01076b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076b5:	89 d0                	mov    %edx,%eax
c01076b7:	c1 e0 02             	shl    $0x2,%eax
c01076ba:	01 d0                	add    %edx,%eax
c01076bc:	83 c0 02             	add    $0x2,%eax
c01076bf:	89 c1                	mov    %eax,%ecx
c01076c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076c4:	89 d0                	mov    %edx,%eax
c01076c6:	c1 e0 02             	shl    $0x2,%eax
c01076c9:	01 d0                	add    %edx,%eax
c01076cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01076d2:	00 
c01076d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01076d7:	89 04 24             	mov    %eax,(%esp)
c01076da:	e8 54 fb ff ff       	call   c0107233 <vma_create>
c01076df:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01076e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01076e6:	75 24                	jne    c010770c <check_vma_struct+0x139>
c01076e8:	c7 44 24 0c 32 a6 10 	movl   $0xc010a632,0xc(%esp)
c01076ef:	c0 
c01076f0:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01076f7:	c0 
c01076f8:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01076ff:	00 
c0107700:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107707:	e8 e4 95 ff ff       	call   c0100cf0 <__panic>
        insert_vma_struct(mm, vma);
c010770c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010770f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107713:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107716:	89 04 24             	mov    %eax,(%esp)
c0107719:	e8 a5 fc ff ff       	call   c01073c3 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010771e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107722:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107725:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107728:	7e 88                	jle    c01076b2 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010772a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010772d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107730:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107733:	8b 40 04             	mov    0x4(%eax),%eax
c0107736:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107739:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107740:	e9 97 00 00 00       	jmp    c01077dc <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107745:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107748:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010774b:	75 24                	jne    c0107771 <check_vma_struct+0x19e>
c010774d:	c7 44 24 0c 3e a6 10 	movl   $0xc010a63e,0xc(%esp)
c0107754:	c0 
c0107755:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c010775c:	c0 
c010775d:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107764:	00 
c0107765:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c010776c:	e8 7f 95 ff ff       	call   c0100cf0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107771:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107774:	83 e8 10             	sub    $0x10,%eax
c0107777:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010777a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010777d:	8b 48 04             	mov    0x4(%eax),%ecx
c0107780:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107783:	89 d0                	mov    %edx,%eax
c0107785:	c1 e0 02             	shl    $0x2,%eax
c0107788:	01 d0                	add    %edx,%eax
c010778a:	39 c1                	cmp    %eax,%ecx
c010778c:	75 17                	jne    c01077a5 <check_vma_struct+0x1d2>
c010778e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107791:	8b 48 08             	mov    0x8(%eax),%ecx
c0107794:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107797:	89 d0                	mov    %edx,%eax
c0107799:	c1 e0 02             	shl    $0x2,%eax
c010779c:	01 d0                	add    %edx,%eax
c010779e:	83 c0 02             	add    $0x2,%eax
c01077a1:	39 c1                	cmp    %eax,%ecx
c01077a3:	74 24                	je     c01077c9 <check_vma_struct+0x1f6>
c01077a5:	c7 44 24 0c 58 a6 10 	movl   $0xc010a658,0xc(%esp)
c01077ac:	c0 
c01077ad:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01077b4:	c0 
c01077b5:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01077bc:	00 
c01077bd:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01077c4:	e8 27 95 ff ff       	call   c0100cf0 <__panic>
c01077c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077cc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01077cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01077d2:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01077d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01077d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01077dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01077e2:	0f 8e 5d ff ff ff    	jle    c0107745 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01077e8:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01077ef:	e9 cd 01 00 00       	jmp    c01079c1 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01077f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01077fe:	89 04 24             	mov    %eax,(%esp)
c0107801:	e8 68 fa ff ff       	call   c010726e <find_vma>
c0107806:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107809:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010780d:	75 24                	jne    c0107833 <check_vma_struct+0x260>
c010780f:	c7 44 24 0c 8d a6 10 	movl   $0xc010a68d,0xc(%esp)
c0107816:	c0 
c0107817:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c010781e:	c0 
c010781f:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0107826:	00 
c0107827:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c010782e:	e8 bd 94 ff ff       	call   c0100cf0 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107833:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107836:	83 c0 01             	add    $0x1,%eax
c0107839:	89 44 24 04          	mov    %eax,0x4(%esp)
c010783d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107840:	89 04 24             	mov    %eax,(%esp)
c0107843:	e8 26 fa ff ff       	call   c010726e <find_vma>
c0107848:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c010784b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010784f:	75 24                	jne    c0107875 <check_vma_struct+0x2a2>
c0107851:	c7 44 24 0c 9a a6 10 	movl   $0xc010a69a,0xc(%esp)
c0107858:	c0 
c0107859:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107860:	c0 
c0107861:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0107868:	00 
c0107869:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107870:	e8 7b 94 ff ff       	call   c0100cf0 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107875:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107878:	83 c0 02             	add    $0x2,%eax
c010787b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010787f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107882:	89 04 24             	mov    %eax,(%esp)
c0107885:	e8 e4 f9 ff ff       	call   c010726e <find_vma>
c010788a:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c010788d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107891:	74 24                	je     c01078b7 <check_vma_struct+0x2e4>
c0107893:	c7 44 24 0c a7 a6 10 	movl   $0xc010a6a7,0xc(%esp)
c010789a:	c0 
c010789b:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01078a2:	c0 
c01078a3:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01078aa:	00 
c01078ab:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01078b2:	e8 39 94 ff ff       	call   c0100cf0 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01078b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078ba:	83 c0 03             	add    $0x3,%eax
c01078bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078c4:	89 04 24             	mov    %eax,(%esp)
c01078c7:	e8 a2 f9 ff ff       	call   c010726e <find_vma>
c01078cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01078cf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01078d3:	74 24                	je     c01078f9 <check_vma_struct+0x326>
c01078d5:	c7 44 24 0c b4 a6 10 	movl   $0xc010a6b4,0xc(%esp)
c01078dc:	c0 
c01078dd:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01078e4:	c0 
c01078e5:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01078ec:	00 
c01078ed:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01078f4:	e8 f7 93 ff ff       	call   c0100cf0 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01078f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078fc:	83 c0 04             	add    $0x4,%eax
c01078ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107903:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107906:	89 04 24             	mov    %eax,(%esp)
c0107909:	e8 60 f9 ff ff       	call   c010726e <find_vma>
c010790e:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107911:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107915:	74 24                	je     c010793b <check_vma_struct+0x368>
c0107917:	c7 44 24 0c c1 a6 10 	movl   $0xc010a6c1,0xc(%esp)
c010791e:	c0 
c010791f:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107926:	c0 
c0107927:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c010792e:	00 
c010792f:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107936:	e8 b5 93 ff ff       	call   c0100cf0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c010793b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010793e:	8b 50 04             	mov    0x4(%eax),%edx
c0107941:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107944:	39 c2                	cmp    %eax,%edx
c0107946:	75 10                	jne    c0107958 <check_vma_struct+0x385>
c0107948:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010794b:	8b 50 08             	mov    0x8(%eax),%edx
c010794e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107951:	83 c0 02             	add    $0x2,%eax
c0107954:	39 c2                	cmp    %eax,%edx
c0107956:	74 24                	je     c010797c <check_vma_struct+0x3a9>
c0107958:	c7 44 24 0c d0 a6 10 	movl   $0xc010a6d0,0xc(%esp)
c010795f:	c0 
c0107960:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107967:	c0 
c0107968:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010796f:	00 
c0107970:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107977:	e8 74 93 ff ff       	call   c0100cf0 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010797c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010797f:	8b 50 04             	mov    0x4(%eax),%edx
c0107982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107985:	39 c2                	cmp    %eax,%edx
c0107987:	75 10                	jne    c0107999 <check_vma_struct+0x3c6>
c0107989:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010798c:	8b 50 08             	mov    0x8(%eax),%edx
c010798f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107992:	83 c0 02             	add    $0x2,%eax
c0107995:	39 c2                	cmp    %eax,%edx
c0107997:	74 24                	je     c01079bd <check_vma_struct+0x3ea>
c0107999:	c7 44 24 0c 00 a7 10 	movl   $0xc010a700,0xc(%esp)
c01079a0:	c0 
c01079a1:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c01079a8:	c0 
c01079a9:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01079b0:	00 
c01079b1:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c01079b8:	e8 33 93 ff ff       	call   c0100cf0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01079bd:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01079c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01079c4:	89 d0                	mov    %edx,%eax
c01079c6:	c1 e0 02             	shl    $0x2,%eax
c01079c9:	01 d0                	add    %edx,%eax
c01079cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079ce:	0f 8d 20 fe ff ff    	jge    c01077f4 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01079d4:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01079db:	eb 70                	jmp    c0107a4d <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01079dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079e7:	89 04 24             	mov    %eax,(%esp)
c01079ea:	e8 7f f8 ff ff       	call   c010726e <find_vma>
c01079ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c01079f2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01079f6:	74 27                	je     c0107a1f <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01079f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01079fb:	8b 50 08             	mov    0x8(%eax),%edx
c01079fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107a01:	8b 40 04             	mov    0x4(%eax),%eax
c0107a04:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107a08:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a13:	c7 04 24 30 a7 10 c0 	movl   $0xc010a730,(%esp)
c0107a1a:	e8 2c 89 ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107a1f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107a23:	74 24                	je     c0107a49 <check_vma_struct+0x476>
c0107a25:	c7 44 24 0c 55 a7 10 	movl   $0xc010a755,0xc(%esp)
c0107a2c:	c0 
c0107a2d:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107a34:	c0 
c0107a35:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107a3c:	00 
c0107a3d:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107a44:	e8 a7 92 ff ff       	call   c0100cf0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107a49:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107a4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107a51:	79 8a                	jns    c01079dd <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a56:	89 04 24             	mov    %eax,(%esp)
c0107a59:	e8 95 fa ff ff       	call   c01074f3 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107a5e:	e8 87 cd ff ff       	call   c01047ea <nr_free_pages>
c0107a63:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107a66:	74 24                	je     c0107a8c <check_vma_struct+0x4b9>
c0107a68:	c7 44 24 0c e8 a5 10 	movl   $0xc010a5e8,0xc(%esp)
c0107a6f:	c0 
c0107a70:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107a77:	c0 
c0107a78:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107a7f:	00 
c0107a80:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107a87:	e8 64 92 ff ff       	call   c0100cf0 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107a8c:	c7 04 24 6c a7 10 c0 	movl   $0xc010a76c,(%esp)
c0107a93:	e8 b3 88 ff ff       	call   c010034b <cprintf>
}
c0107a98:	c9                   	leave  
c0107a99:	c3                   	ret    

c0107a9a <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107a9a:	55                   	push   %ebp
c0107a9b:	89 e5                	mov    %esp,%ebp
c0107a9d:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107aa0:	e8 45 cd ff ff       	call   c01047ea <nr_free_pages>
c0107aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107aa8:	e8 0e f7 ff ff       	call   c01071bb <mm_create>
c0107aad:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac
    assert(check_mm_struct != NULL);
c0107ab2:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107ab7:	85 c0                	test   %eax,%eax
c0107ab9:	75 24                	jne    c0107adf <check_pgfault+0x45>
c0107abb:	c7 44 24 0c 8b a7 10 	movl   $0xc010a78b,0xc(%esp)
c0107ac2:	c0 
c0107ac3:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107aca:	c0 
c0107acb:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107ad2:	00 
c0107ad3:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107ada:	e8 11 92 ff ff       	call   c0100cf0 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107adf:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107ae7:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0107aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107af0:	89 50 0c             	mov    %edx,0xc(%eax)
c0107af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107af6:	8b 40 0c             	mov    0xc(%eax),%eax
c0107af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107aff:	8b 00                	mov    (%eax),%eax
c0107b01:	85 c0                	test   %eax,%eax
c0107b03:	74 24                	je     c0107b29 <check_pgfault+0x8f>
c0107b05:	c7 44 24 0c a3 a7 10 	movl   $0xc010a7a3,0xc(%esp)
c0107b0c:	c0 
c0107b0d:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107b14:	c0 
c0107b15:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107b1c:	00 
c0107b1d:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107b24:	e8 c7 91 ff ff       	call   c0100cf0 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107b29:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107b30:	00 
c0107b31:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107b38:	00 
c0107b39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107b40:	e8 ee f6 ff ff       	call   c0107233 <vma_create>
c0107b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107b48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107b4c:	75 24                	jne    c0107b72 <check_pgfault+0xd8>
c0107b4e:	c7 44 24 0c 32 a6 10 	movl   $0xc010a632,0xc(%esp)
c0107b55:	c0 
c0107b56:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107b5d:	c0 
c0107b5e:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107b65:	00 
c0107b66:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107b6d:	e8 7e 91 ff ff       	call   c0100cf0 <__panic>

    insert_vma_struct(mm, vma);
c0107b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b7c:	89 04 24             	mov    %eax,(%esp)
c0107b7f:	e8 3f f8 ff ff       	call   c01073c3 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107b84:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107b8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b95:	89 04 24             	mov    %eax,(%esp)
c0107b98:	e8 d1 f6 ff ff       	call   c010726e <find_vma>
c0107b9d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107ba0:	74 24                	je     c0107bc6 <check_pgfault+0x12c>
c0107ba2:	c7 44 24 0c b1 a7 10 	movl   $0xc010a7b1,0xc(%esp)
c0107ba9:	c0 
c0107baa:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107bb1:	c0 
c0107bb2:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107bb9:	00 
c0107bba:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107bc1:	e8 2a 91 ff ff       	call   c0100cf0 <__panic>

    int i, sum = 0;
c0107bc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107bd4:	eb 17                	jmp    c0107bed <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bdc:	01 d0                	add    %edx,%eax
c0107bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107be1:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107be6:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107be9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107bed:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107bf1:	7e e3                	jle    c0107bd6 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107bfa:	eb 15                	jmp    c0107c11 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c02:	01 d0                	add    %edx,%eax
c0107c04:	0f b6 00             	movzbl (%eax),%eax
c0107c07:	0f be c0             	movsbl %al,%eax
c0107c0a:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107c0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107c11:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107c15:	7e e5                	jle    c0107bfc <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107c1b:	74 24                	je     c0107c41 <check_pgfault+0x1a7>
c0107c1d:	c7 44 24 0c cb a7 10 	movl   $0xc010a7cb,0xc(%esp)
c0107c24:	c0 
c0107c25:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107c2c:	c0 
c0107c2d:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107c34:	00 
c0107c35:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107c3c:	e8 af 90 ff ff       	call   c0100cf0 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107c41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c44:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107c47:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107c4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c56:	89 04 24             	mov    %eax,(%esp)
c0107c59:	e8 58 d4 ff ff       	call   c01050b6 <page_remove>
    free_page(pa2page(pgdir[0]));
c0107c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c61:	8b 00                	mov    (%eax),%eax
c0107c63:	89 04 24             	mov    %eax,(%esp)
c0107c66:	e8 0b f5 ff ff       	call   c0107176 <pa2page>
c0107c6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107c72:	00 
c0107c73:	89 04 24             	mov    %eax,(%esp)
c0107c76:	e8 3d cb ff ff       	call   c01047b8 <free_pages>
    pgdir[0] = 0;
c0107c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c91:	89 04 24             	mov    %eax,(%esp)
c0107c94:	e8 5a f8 ff ff       	call   c01074f3 <mm_destroy>
    check_mm_struct = NULL;
c0107c99:	c7 05 ac 1b 12 c0 00 	movl   $0x0,0xc0121bac
c0107ca0:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107ca3:	e8 42 cb ff ff       	call   c01047ea <nr_free_pages>
c0107ca8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107cab:	74 24                	je     c0107cd1 <check_pgfault+0x237>
c0107cad:	c7 44 24 0c e8 a5 10 	movl   $0xc010a5e8,0xc(%esp)
c0107cb4:	c0 
c0107cb5:	c7 44 24 08 67 a5 10 	movl   $0xc010a567,0x8(%esp)
c0107cbc:	c0 
c0107cbd:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107cc4:	00 
c0107cc5:	c7 04 24 7c a5 10 c0 	movl   $0xc010a57c,(%esp)
c0107ccc:	e8 1f 90 ff ff       	call   c0100cf0 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107cd1:	c7 04 24 d4 a7 10 c0 	movl   $0xc010a7d4,(%esp)
c0107cd8:	e8 6e 86 ff ff       	call   c010034b <cprintf>
}
c0107cdd:	c9                   	leave  
c0107cde:	c3                   	ret    

c0107cdf <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107cdf:	55                   	push   %ebp
c0107ce0:	89 e5                	mov    %esp,%ebp
c0107ce2:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107ce5:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107cec:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cf6:	89 04 24             	mov    %eax,(%esp)
c0107cf9:	e8 70 f5 ff ff       	call   c010726e <find_vma>
c0107cfe:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107d01:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107d06:	83 c0 01             	add    $0x1,%eax
c0107d09:	a3 b8 1a 12 c0       	mov    %eax,0xc0121ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107d0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107d12:	74 0b                	je     c0107d1f <do_pgfault+0x40>
c0107d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d17:	8b 40 04             	mov    0x4(%eax),%eax
c0107d1a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107d1d:	76 18                	jbe    c0107d37 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d26:	c7 04 24 f0 a7 10 c0 	movl   $0xc010a7f0,(%esp)
c0107d2d:	e8 19 86 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107d32:	e9 71 01 00 00       	jmp    c0107ea8 <do_pgfault+0x1c9>
    }
    //check the error_code
    switch (error_code & 3) {
c0107d37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d3a:	83 e0 03             	and    $0x3,%eax
c0107d3d:	85 c0                	test   %eax,%eax
c0107d3f:	74 36                	je     c0107d77 <do_pgfault+0x98>
c0107d41:	83 f8 01             	cmp    $0x1,%eax
c0107d44:	74 20                	je     c0107d66 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d49:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d4c:	83 e0 02             	and    $0x2,%eax
c0107d4f:	85 c0                	test   %eax,%eax
c0107d51:	75 11                	jne    c0107d64 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107d53:	c7 04 24 20 a8 10 c0 	movl   $0xc010a820,(%esp)
c0107d5a:	e8 ec 85 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107d5f:	e9 44 01 00 00       	jmp    c0107ea8 <do_pgfault+0x1c9>
        }
        break;
c0107d64:	eb 2f                	jmp    c0107d95 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107d66:	c7 04 24 80 a8 10 c0 	movl   $0xc010a880,(%esp)
c0107d6d:	e8 d9 85 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107d72:	e9 31 01 00 00       	jmp    c0107ea8 <do_pgfault+0x1c9>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d7a:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d7d:	83 e0 05             	and    $0x5,%eax
c0107d80:	85 c0                	test   %eax,%eax
c0107d82:	75 11                	jne    c0107d95 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107d84:	c7 04 24 b8 a8 10 c0 	movl   $0xc010a8b8,(%esp)
c0107d8b:	e8 bb 85 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107d90:	e9 13 01 00 00       	jmp    c0107ea8 <do_pgfault+0x1c9>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107d95:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d9f:	8b 40 0c             	mov    0xc(%eax),%eax
c0107da2:	83 e0 02             	and    $0x2,%eax
c0107da5:	85 c0                	test   %eax,%eax
c0107da7:	74 04                	je     c0107dad <do_pgfault+0xce>
        perm |= PTE_W;
c0107da9:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107dad:	8b 45 10             	mov    0x10(%ebp),%eax
c0107db0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107db3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107db6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107dbb:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107dbe:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107dc5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
	ptep = get_pte(mm->pgdir, addr, 1);
c0107dcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dcf:	8b 40 0c             	mov    0xc(%eax),%eax
c0107dd2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107dd9:	00 
c0107dda:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ddd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107de1:	89 04 24             	mov    %eax,(%esp)
c0107de4:	e8 c6 d0 ff ff       	call   c0104eaf <get_pte>
c0107de9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(*ptep == 0){
c0107dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107def:	8b 00                	mov    (%eax),%eax
c0107df1:	85 c0                	test   %eax,%eax
c0107df3:	75 24                	jne    c0107e19 <do_pgfault+0x13a>
		struct Page *p = pgdir_alloc_page(mm->pgdir, addr, perm);
c0107df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107df8:	8b 40 0c             	mov    0xc(%eax),%eax
c0107dfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107dfe:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107e02:	8b 55 10             	mov    0x10(%ebp),%edx
c0107e05:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e09:	89 04 24             	mov    %eax,(%esp)
c0107e0c:	e8 ff d3 ff ff       	call   c0105210 <pgdir_alloc_page>
c0107e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107e14:	e9 88 00 00 00       	jmp    c0107ea1 <do_pgfault+0x1c2>
	}
	else{
		if(swap_init_ok){
c0107e19:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107e1e:	85 c0                	test   %eax,%eax
c0107e20:	74 68                	je     c0107e8a <do_pgfault+0x1ab>
			struct Page *page = NULL;
c0107e22:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			int s_in = swap_in(mm, addr, &page);
c0107e29:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0107e2c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e30:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e37:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e3a:	89 04 24             	mov    %eax,(%esp)
c0107e3d:	e8 98 e5 ff ff       	call   c01063da <swap_in>
c0107e42:	89 45 dc             	mov    %eax,-0x24(%ebp)
			page_insert(mm->pgdir, page, addr, perm);
c0107e45:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e4b:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e4e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107e51:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107e55:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107e58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107e5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e60:	89 04 24             	mov    %eax,(%esp)
c0107e63:	e8 92 d2 ff ff       	call   c01050fa <page_insert>
			swap_map_swappable(mm, addr, page, s_in);
c0107e68:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107e6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107e6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107e72:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e76:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e80:	89 04 24             	mov    %eax,(%esp)
c0107e83:	e8 89 e3 ff ff       	call   c0106211 <swap_map_swappable>
c0107e88:	eb 17                	jmp    c0107ea1 <do_pgfault+0x1c2>
		}
		else{
			cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e8d:	8b 00                	mov    (%eax),%eax
c0107e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e93:	c7 04 24 1c a9 10 c0 	movl   $0xc010a91c,(%esp)
c0107e9a:	e8 ac 84 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107e9f:	eb 07                	jmp    c0107ea8 <do_pgfault+0x1c9>
		}
	}
   ret = 0;
c0107ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107eab:	c9                   	leave  
c0107eac:	c3                   	ret    

c0107ead <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107ead:	55                   	push   %ebp
c0107eae:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107eb0:	8b 55 08             	mov    0x8(%ebp),%edx
c0107eb3:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0107eb8:	29 c2                	sub    %eax,%edx
c0107eba:	89 d0                	mov    %edx,%eax
c0107ebc:	c1 f8 05             	sar    $0x5,%eax
}
c0107ebf:	5d                   	pop    %ebp
c0107ec0:	c3                   	ret    

c0107ec1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107ec1:	55                   	push   %ebp
c0107ec2:	89 e5                	mov    %esp,%ebp
c0107ec4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107ec7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107eca:	89 04 24             	mov    %eax,(%esp)
c0107ecd:	e8 db ff ff ff       	call   c0107ead <page2ppn>
c0107ed2:	c1 e0 0c             	shl    $0xc,%eax
}
c0107ed5:	c9                   	leave  
c0107ed6:	c3                   	ret    

c0107ed7 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107ed7:	55                   	push   %ebp
c0107ed8:	89 e5                	mov    %esp,%ebp
c0107eda:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107edd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ee0:	89 04 24             	mov    %eax,(%esp)
c0107ee3:	e8 d9 ff ff ff       	call   c0107ec1 <page2pa>
c0107ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107eee:	c1 e8 0c             	shr    $0xc,%eax
c0107ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107ef4:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107ef9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107efc:	72 23                	jb     c0107f21 <page2kva+0x4a>
c0107efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f01:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f05:	c7 44 24 08 44 a9 10 	movl   $0xc010a944,0x8(%esp)
c0107f0c:	c0 
c0107f0d:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107f14:	00 
c0107f15:	c7 04 24 67 a9 10 c0 	movl   $0xc010a967,(%esp)
c0107f1c:	e8 cf 8d ff ff       	call   c0100cf0 <__panic>
c0107f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f24:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107f29:	c9                   	leave  
c0107f2a:	c3                   	ret    

c0107f2b <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107f2b:	55                   	push   %ebp
c0107f2c:	89 e5                	mov    %esp,%ebp
c0107f2e:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107f31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f38:	e8 03 9b ff ff       	call   c0101a40 <ide_device_valid>
c0107f3d:	85 c0                	test   %eax,%eax
c0107f3f:	75 1c                	jne    c0107f5d <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107f41:	c7 44 24 08 75 a9 10 	movl   $0xc010a975,0x8(%esp)
c0107f48:	c0 
c0107f49:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107f50:	00 
c0107f51:	c7 04 24 8f a9 10 c0 	movl   $0xc010a98f,(%esp)
c0107f58:	e8 93 8d ff ff       	call   c0100cf0 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107f5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f64:	e8 16 9b ff ff       	call   c0101a7f <ide_device_size>
c0107f69:	c1 e8 03             	shr    $0x3,%eax
c0107f6c:	a3 7c 1b 12 c0       	mov    %eax,0xc0121b7c
}
c0107f71:	c9                   	leave  
c0107f72:	c3                   	ret    

c0107f73 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107f73:	55                   	push   %ebp
c0107f74:	89 e5                	mov    %esp,%ebp
c0107f76:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107f79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f7c:	89 04 24             	mov    %eax,(%esp)
c0107f7f:	e8 53 ff ff ff       	call   c0107ed7 <page2kva>
c0107f84:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f87:	c1 ea 08             	shr    $0x8,%edx
c0107f8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f91:	74 0b                	je     c0107f9e <swapfs_read+0x2b>
c0107f93:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0107f99:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107f9c:	72 23                	jb     c0107fc1 <swapfs_read+0x4e>
c0107f9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107fa5:	c7 44 24 08 a0 a9 10 	movl   $0xc010a9a0,0x8(%esp)
c0107fac:	c0 
c0107fad:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107fb4:	00 
c0107fb5:	c7 04 24 8f a9 10 c0 	movl   $0xc010a98f,(%esp)
c0107fbc:	e8 2f 8d ff ff       	call   c0100cf0 <__panic>
c0107fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fc4:	c1 e2 03             	shl    $0x3,%edx
c0107fc7:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107fce:	00 
c0107fcf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107fd3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107fde:	e8 db 9a ff ff       	call   c0101abe <ide_read_secs>
}
c0107fe3:	c9                   	leave  
c0107fe4:	c3                   	ret    

c0107fe5 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107fe5:	55                   	push   %ebp
c0107fe6:	89 e5                	mov    %esp,%ebp
c0107fe8:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107feb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fee:	89 04 24             	mov    %eax,(%esp)
c0107ff1:	e8 e1 fe ff ff       	call   c0107ed7 <page2kva>
c0107ff6:	8b 55 08             	mov    0x8(%ebp),%edx
c0107ff9:	c1 ea 08             	shr    $0x8,%edx
c0107ffc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107fff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108003:	74 0b                	je     c0108010 <swapfs_write+0x2b>
c0108005:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c010800b:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010800e:	72 23                	jb     c0108033 <swapfs_write+0x4e>
c0108010:	8b 45 08             	mov    0x8(%ebp),%eax
c0108013:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108017:	c7 44 24 08 a0 a9 10 	movl   $0xc010a9a0,0x8(%esp)
c010801e:	c0 
c010801f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108026:	00 
c0108027:	c7 04 24 8f a9 10 c0 	movl   $0xc010a98f,(%esp)
c010802e:	e8 bd 8c ff ff       	call   c0100cf0 <__panic>
c0108033:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108036:	c1 e2 03             	shl    $0x3,%edx
c0108039:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108040:	00 
c0108041:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108045:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108049:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108050:	e8 ab 9c ff ff       	call   c0101d00 <ide_write_secs>
}
c0108055:	c9                   	leave  
c0108056:	c3                   	ret    

c0108057 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108057:	55                   	push   %ebp
c0108058:	89 e5                	mov    %esp,%ebp
c010805a:	83 ec 58             	sub    $0x58,%esp
c010805d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108060:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108063:	8b 45 14             	mov    0x14(%ebp),%eax
c0108066:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108069:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010806c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010806f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108072:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108075:	8b 45 18             	mov    0x18(%ebp),%eax
c0108078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010807b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010807e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108081:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108084:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108087:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010808a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010808d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108091:	74 1c                	je     c01080af <printnum+0x58>
c0108093:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108096:	ba 00 00 00 00       	mov    $0x0,%edx
c010809b:	f7 75 e4             	divl   -0x1c(%ebp)
c010809e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01080a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01080a9:	f7 75 e4             	divl   -0x1c(%ebp)
c01080ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01080b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01080b5:	f7 75 e4             	divl   -0x1c(%ebp)
c01080b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01080bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01080be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01080c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01080c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01080c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01080ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080cd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01080d0:	8b 45 18             	mov    0x18(%ebp),%eax
c01080d3:	ba 00 00 00 00       	mov    $0x0,%edx
c01080d8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01080db:	77 56                	ja     c0108133 <printnum+0xdc>
c01080dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01080e0:	72 05                	jb     c01080e7 <printnum+0x90>
c01080e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01080e5:	77 4c                	ja     c0108133 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01080e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01080ea:	8d 50 ff             	lea    -0x1(%eax),%edx
c01080ed:	8b 45 20             	mov    0x20(%ebp),%eax
c01080f0:	89 44 24 18          	mov    %eax,0x18(%esp)
c01080f4:	89 54 24 14          	mov    %edx,0x14(%esp)
c01080f8:	8b 45 18             	mov    0x18(%ebp),%eax
c01080fb:	89 44 24 10          	mov    %eax,0x10(%esp)
c01080ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108102:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108105:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108109:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010810d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108110:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108114:	8b 45 08             	mov    0x8(%ebp),%eax
c0108117:	89 04 24             	mov    %eax,(%esp)
c010811a:	e8 38 ff ff ff       	call   c0108057 <printnum>
c010811f:	eb 1c                	jmp    c010813d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108121:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108128:	8b 45 20             	mov    0x20(%ebp),%eax
c010812b:	89 04 24             	mov    %eax,(%esp)
c010812e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108131:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0108133:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0108137:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010813b:	7f e4                	jg     c0108121 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010813d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108140:	05 40 aa 10 c0       	add    $0xc010aa40,%eax
c0108145:	0f b6 00             	movzbl (%eax),%eax
c0108148:	0f be c0             	movsbl %al,%eax
c010814b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010814e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108152:	89 04 24             	mov    %eax,(%esp)
c0108155:	8b 45 08             	mov    0x8(%ebp),%eax
c0108158:	ff d0                	call   *%eax
}
c010815a:	c9                   	leave  
c010815b:	c3                   	ret    

c010815c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010815c:	55                   	push   %ebp
c010815d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010815f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108163:	7e 14                	jle    c0108179 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108165:	8b 45 08             	mov    0x8(%ebp),%eax
c0108168:	8b 00                	mov    (%eax),%eax
c010816a:	8d 48 08             	lea    0x8(%eax),%ecx
c010816d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108170:	89 0a                	mov    %ecx,(%edx)
c0108172:	8b 50 04             	mov    0x4(%eax),%edx
c0108175:	8b 00                	mov    (%eax),%eax
c0108177:	eb 30                	jmp    c01081a9 <getuint+0x4d>
    }
    else if (lflag) {
c0108179:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010817d:	74 16                	je     c0108195 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010817f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108182:	8b 00                	mov    (%eax),%eax
c0108184:	8d 48 04             	lea    0x4(%eax),%ecx
c0108187:	8b 55 08             	mov    0x8(%ebp),%edx
c010818a:	89 0a                	mov    %ecx,(%edx)
c010818c:	8b 00                	mov    (%eax),%eax
c010818e:	ba 00 00 00 00       	mov    $0x0,%edx
c0108193:	eb 14                	jmp    c01081a9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108195:	8b 45 08             	mov    0x8(%ebp),%eax
c0108198:	8b 00                	mov    (%eax),%eax
c010819a:	8d 48 04             	lea    0x4(%eax),%ecx
c010819d:	8b 55 08             	mov    0x8(%ebp),%edx
c01081a0:	89 0a                	mov    %ecx,(%edx)
c01081a2:	8b 00                	mov    (%eax),%eax
c01081a4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01081a9:	5d                   	pop    %ebp
c01081aa:	c3                   	ret    

c01081ab <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01081ab:	55                   	push   %ebp
c01081ac:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01081ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01081b2:	7e 14                	jle    c01081c8 <getint+0x1d>
        return va_arg(*ap, long long);
c01081b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b7:	8b 00                	mov    (%eax),%eax
c01081b9:	8d 48 08             	lea    0x8(%eax),%ecx
c01081bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01081bf:	89 0a                	mov    %ecx,(%edx)
c01081c1:	8b 50 04             	mov    0x4(%eax),%edx
c01081c4:	8b 00                	mov    (%eax),%eax
c01081c6:	eb 28                	jmp    c01081f0 <getint+0x45>
    }
    else if (lflag) {
c01081c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01081cc:	74 12                	je     c01081e0 <getint+0x35>
        return va_arg(*ap, long);
c01081ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01081d1:	8b 00                	mov    (%eax),%eax
c01081d3:	8d 48 04             	lea    0x4(%eax),%ecx
c01081d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01081d9:	89 0a                	mov    %ecx,(%edx)
c01081db:	8b 00                	mov    (%eax),%eax
c01081dd:	99                   	cltd   
c01081de:	eb 10                	jmp    c01081f0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01081e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01081e3:	8b 00                	mov    (%eax),%eax
c01081e5:	8d 48 04             	lea    0x4(%eax),%ecx
c01081e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01081eb:	89 0a                	mov    %ecx,(%edx)
c01081ed:	8b 00                	mov    (%eax),%eax
c01081ef:	99                   	cltd   
    }
}
c01081f0:	5d                   	pop    %ebp
c01081f1:	c3                   	ret    

c01081f2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01081f2:	55                   	push   %ebp
c01081f3:	89 e5                	mov    %esp,%ebp
c01081f5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01081f8:	8d 45 14             	lea    0x14(%ebp),%eax
c01081fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01081fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108201:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108205:	8b 45 10             	mov    0x10(%ebp),%eax
c0108208:	89 44 24 08          	mov    %eax,0x8(%esp)
c010820c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010820f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108213:	8b 45 08             	mov    0x8(%ebp),%eax
c0108216:	89 04 24             	mov    %eax,(%esp)
c0108219:	e8 02 00 00 00       	call   c0108220 <vprintfmt>
    va_end(ap);
}
c010821e:	c9                   	leave  
c010821f:	c3                   	ret    

c0108220 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108220:	55                   	push   %ebp
c0108221:	89 e5                	mov    %esp,%ebp
c0108223:	56                   	push   %esi
c0108224:	53                   	push   %ebx
c0108225:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108228:	eb 18                	jmp    c0108242 <vprintfmt+0x22>
            if (ch == '\0') {
c010822a:	85 db                	test   %ebx,%ebx
c010822c:	75 05                	jne    c0108233 <vprintfmt+0x13>
                return;
c010822e:	e9 d1 03 00 00       	jmp    c0108604 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108233:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108236:	89 44 24 04          	mov    %eax,0x4(%esp)
c010823a:	89 1c 24             	mov    %ebx,(%esp)
c010823d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108240:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108242:	8b 45 10             	mov    0x10(%ebp),%eax
c0108245:	8d 50 01             	lea    0x1(%eax),%edx
c0108248:	89 55 10             	mov    %edx,0x10(%ebp)
c010824b:	0f b6 00             	movzbl (%eax),%eax
c010824e:	0f b6 d8             	movzbl %al,%ebx
c0108251:	83 fb 25             	cmp    $0x25,%ebx
c0108254:	75 d4                	jne    c010822a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108256:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010825a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108264:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108267:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010826e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108271:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108274:	8b 45 10             	mov    0x10(%ebp),%eax
c0108277:	8d 50 01             	lea    0x1(%eax),%edx
c010827a:	89 55 10             	mov    %edx,0x10(%ebp)
c010827d:	0f b6 00             	movzbl (%eax),%eax
c0108280:	0f b6 d8             	movzbl %al,%ebx
c0108283:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108286:	83 f8 55             	cmp    $0x55,%eax
c0108289:	0f 87 44 03 00 00    	ja     c01085d3 <vprintfmt+0x3b3>
c010828f:	8b 04 85 64 aa 10 c0 	mov    -0x3fef559c(,%eax,4),%eax
c0108296:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108298:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010829c:	eb d6                	jmp    c0108274 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010829e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01082a2:	eb d0                	jmp    c0108274 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01082a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01082ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01082ae:	89 d0                	mov    %edx,%eax
c01082b0:	c1 e0 02             	shl    $0x2,%eax
c01082b3:	01 d0                	add    %edx,%eax
c01082b5:	01 c0                	add    %eax,%eax
c01082b7:	01 d8                	add    %ebx,%eax
c01082b9:	83 e8 30             	sub    $0x30,%eax
c01082bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01082bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01082c2:	0f b6 00             	movzbl (%eax),%eax
c01082c5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01082c8:	83 fb 2f             	cmp    $0x2f,%ebx
c01082cb:	7e 0b                	jle    c01082d8 <vprintfmt+0xb8>
c01082cd:	83 fb 39             	cmp    $0x39,%ebx
c01082d0:	7f 06                	jg     c01082d8 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01082d2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01082d6:	eb d3                	jmp    c01082ab <vprintfmt+0x8b>
            goto process_precision;
c01082d8:	eb 33                	jmp    c010830d <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01082da:	8b 45 14             	mov    0x14(%ebp),%eax
c01082dd:	8d 50 04             	lea    0x4(%eax),%edx
c01082e0:	89 55 14             	mov    %edx,0x14(%ebp)
c01082e3:	8b 00                	mov    (%eax),%eax
c01082e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01082e8:	eb 23                	jmp    c010830d <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01082ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082ee:	79 0c                	jns    c01082fc <vprintfmt+0xdc>
                width = 0;
c01082f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01082f7:	e9 78 ff ff ff       	jmp    c0108274 <vprintfmt+0x54>
c01082fc:	e9 73 ff ff ff       	jmp    c0108274 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0108301:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108308:	e9 67 ff ff ff       	jmp    c0108274 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010830d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108311:	79 12                	jns    c0108325 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108313:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108316:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108319:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108320:	e9 4f ff ff ff       	jmp    c0108274 <vprintfmt+0x54>
c0108325:	e9 4a ff ff ff       	jmp    c0108274 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010832a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010832e:	e9 41 ff ff ff       	jmp    c0108274 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108333:	8b 45 14             	mov    0x14(%ebp),%eax
c0108336:	8d 50 04             	lea    0x4(%eax),%edx
c0108339:	89 55 14             	mov    %edx,0x14(%ebp)
c010833c:	8b 00                	mov    (%eax),%eax
c010833e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108341:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108345:	89 04 24             	mov    %eax,(%esp)
c0108348:	8b 45 08             	mov    0x8(%ebp),%eax
c010834b:	ff d0                	call   *%eax
            break;
c010834d:	e9 ac 02 00 00       	jmp    c01085fe <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108352:	8b 45 14             	mov    0x14(%ebp),%eax
c0108355:	8d 50 04             	lea    0x4(%eax),%edx
c0108358:	89 55 14             	mov    %edx,0x14(%ebp)
c010835b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010835d:	85 db                	test   %ebx,%ebx
c010835f:	79 02                	jns    c0108363 <vprintfmt+0x143>
                err = -err;
c0108361:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108363:	83 fb 06             	cmp    $0x6,%ebx
c0108366:	7f 0b                	jg     c0108373 <vprintfmt+0x153>
c0108368:	8b 34 9d 24 aa 10 c0 	mov    -0x3fef55dc(,%ebx,4),%esi
c010836f:	85 f6                	test   %esi,%esi
c0108371:	75 23                	jne    c0108396 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0108373:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108377:	c7 44 24 08 51 aa 10 	movl   $0xc010aa51,0x8(%esp)
c010837e:	c0 
c010837f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108382:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108386:	8b 45 08             	mov    0x8(%ebp),%eax
c0108389:	89 04 24             	mov    %eax,(%esp)
c010838c:	e8 61 fe ff ff       	call   c01081f2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108391:	e9 68 02 00 00       	jmp    c01085fe <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108396:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010839a:	c7 44 24 08 5a aa 10 	movl   $0xc010aa5a,0x8(%esp)
c01083a1:	c0 
c01083a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ac:	89 04 24             	mov    %eax,(%esp)
c01083af:	e8 3e fe ff ff       	call   c01081f2 <printfmt>
            }
            break;
c01083b4:	e9 45 02 00 00       	jmp    c01085fe <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01083b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01083bc:	8d 50 04             	lea    0x4(%eax),%edx
c01083bf:	89 55 14             	mov    %edx,0x14(%ebp)
c01083c2:	8b 30                	mov    (%eax),%esi
c01083c4:	85 f6                	test   %esi,%esi
c01083c6:	75 05                	jne    c01083cd <vprintfmt+0x1ad>
                p = "(null)";
c01083c8:	be 5d aa 10 c0       	mov    $0xc010aa5d,%esi
            }
            if (width > 0 && padc != '-') {
c01083cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01083d1:	7e 3e                	jle    c0108411 <vprintfmt+0x1f1>
c01083d3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01083d7:	74 38                	je     c0108411 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01083d9:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01083dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083e3:	89 34 24             	mov    %esi,(%esp)
c01083e6:	e8 ed 03 00 00       	call   c01087d8 <strnlen>
c01083eb:	29 c3                	sub    %eax,%ebx
c01083ed:	89 d8                	mov    %ebx,%eax
c01083ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01083f2:	eb 17                	jmp    c010840b <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01083f4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01083f8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01083fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083ff:	89 04 24             	mov    %eax,(%esp)
c0108402:	8b 45 08             	mov    0x8(%ebp),%eax
c0108405:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108407:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010840b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010840f:	7f e3                	jg     c01083f4 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108411:	eb 38                	jmp    c010844b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108413:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108417:	74 1f                	je     c0108438 <vprintfmt+0x218>
c0108419:	83 fb 1f             	cmp    $0x1f,%ebx
c010841c:	7e 05                	jle    c0108423 <vprintfmt+0x203>
c010841e:	83 fb 7e             	cmp    $0x7e,%ebx
c0108421:	7e 15                	jle    c0108438 <vprintfmt+0x218>
                    putch('?', putdat);
c0108423:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010842a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108431:	8b 45 08             	mov    0x8(%ebp),%eax
c0108434:	ff d0                	call   *%eax
c0108436:	eb 0f                	jmp    c0108447 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108438:	8b 45 0c             	mov    0xc(%ebp),%eax
c010843b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010843f:	89 1c 24             	mov    %ebx,(%esp)
c0108442:	8b 45 08             	mov    0x8(%ebp),%eax
c0108445:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108447:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010844b:	89 f0                	mov    %esi,%eax
c010844d:	8d 70 01             	lea    0x1(%eax),%esi
c0108450:	0f b6 00             	movzbl (%eax),%eax
c0108453:	0f be d8             	movsbl %al,%ebx
c0108456:	85 db                	test   %ebx,%ebx
c0108458:	74 10                	je     c010846a <vprintfmt+0x24a>
c010845a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010845e:	78 b3                	js     c0108413 <vprintfmt+0x1f3>
c0108460:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108464:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108468:	79 a9                	jns    c0108413 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010846a:	eb 17                	jmp    c0108483 <vprintfmt+0x263>
                putch(' ', putdat);
c010846c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010846f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108473:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010847a:	8b 45 08             	mov    0x8(%ebp),%eax
c010847d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010847f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108483:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108487:	7f e3                	jg     c010846c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0108489:	e9 70 01 00 00       	jmp    c01085fe <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010848e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108491:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108495:	8d 45 14             	lea    0x14(%ebp),%eax
c0108498:	89 04 24             	mov    %eax,(%esp)
c010849b:	e8 0b fd ff ff       	call   c01081ab <getint>
c01084a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01084a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084ac:	85 d2                	test   %edx,%edx
c01084ae:	79 26                	jns    c01084d6 <vprintfmt+0x2b6>
                putch('-', putdat);
c01084b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084b7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01084be:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c1:	ff d0                	call   *%eax
                num = -(long long)num;
c01084c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084c9:	f7 d8                	neg    %eax
c01084cb:	83 d2 00             	adc    $0x0,%edx
c01084ce:	f7 da                	neg    %edx
c01084d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01084d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01084dd:	e9 a8 00 00 00       	jmp    c010858a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01084e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084e9:	8d 45 14             	lea    0x14(%ebp),%eax
c01084ec:	89 04 24             	mov    %eax,(%esp)
c01084ef:	e8 68 fc ff ff       	call   c010815c <getuint>
c01084f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01084fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108501:	e9 84 00 00 00       	jmp    c010858a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108506:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108509:	89 44 24 04          	mov    %eax,0x4(%esp)
c010850d:	8d 45 14             	lea    0x14(%ebp),%eax
c0108510:	89 04 24             	mov    %eax,(%esp)
c0108513:	e8 44 fc ff ff       	call   c010815c <getuint>
c0108518:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010851b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010851e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108525:	eb 63                	jmp    c010858a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0108527:	8b 45 0c             	mov    0xc(%ebp),%eax
c010852a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010852e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108535:	8b 45 08             	mov    0x8(%ebp),%eax
c0108538:	ff d0                	call   *%eax
            putch('x', putdat);
c010853a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010853d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108541:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108548:	8b 45 08             	mov    0x8(%ebp),%eax
c010854b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010854d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108550:	8d 50 04             	lea    0x4(%eax),%edx
c0108553:	89 55 14             	mov    %edx,0x14(%ebp)
c0108556:	8b 00                	mov    (%eax),%eax
c0108558:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010855b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108562:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108569:	eb 1f                	jmp    c010858a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010856b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010856e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108572:	8d 45 14             	lea    0x14(%ebp),%eax
c0108575:	89 04 24             	mov    %eax,(%esp)
c0108578:	e8 df fb ff ff       	call   c010815c <getuint>
c010857d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108580:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108583:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010858a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010858e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108591:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108595:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108598:	89 54 24 14          	mov    %edx,0x14(%esp)
c010859c:	89 44 24 10          	mov    %eax,0x10(%esp)
c01085a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01085ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01085b8:	89 04 24             	mov    %eax,(%esp)
c01085bb:	e8 97 fa ff ff       	call   c0108057 <printnum>
            break;
c01085c0:	eb 3c                	jmp    c01085fe <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01085c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085c9:	89 1c 24             	mov    %ebx,(%esp)
c01085cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01085cf:	ff d0                	call   *%eax
            break;
c01085d1:	eb 2b                	jmp    c01085fe <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01085d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01085e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01085e4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01085e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01085ea:	eb 04                	jmp    c01085f0 <vprintfmt+0x3d0>
c01085ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01085f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01085f3:	83 e8 01             	sub    $0x1,%eax
c01085f6:	0f b6 00             	movzbl (%eax),%eax
c01085f9:	3c 25                	cmp    $0x25,%al
c01085fb:	75 ef                	jne    c01085ec <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01085fd:	90                   	nop
        }
    }
c01085fe:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01085ff:	e9 3e fc ff ff       	jmp    c0108242 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108604:	83 c4 40             	add    $0x40,%esp
c0108607:	5b                   	pop    %ebx
c0108608:	5e                   	pop    %esi
c0108609:	5d                   	pop    %ebp
c010860a:	c3                   	ret    

c010860b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010860b:	55                   	push   %ebp
c010860c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010860e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108611:	8b 40 08             	mov    0x8(%eax),%eax
c0108614:	8d 50 01             	lea    0x1(%eax),%edx
c0108617:	8b 45 0c             	mov    0xc(%ebp),%eax
c010861a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010861d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108620:	8b 10                	mov    (%eax),%edx
c0108622:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108625:	8b 40 04             	mov    0x4(%eax),%eax
c0108628:	39 c2                	cmp    %eax,%edx
c010862a:	73 12                	jae    c010863e <sprintputch+0x33>
        *b->buf ++ = ch;
c010862c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010862f:	8b 00                	mov    (%eax),%eax
c0108631:	8d 48 01             	lea    0x1(%eax),%ecx
c0108634:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108637:	89 0a                	mov    %ecx,(%edx)
c0108639:	8b 55 08             	mov    0x8(%ebp),%edx
c010863c:	88 10                	mov    %dl,(%eax)
    }
}
c010863e:	5d                   	pop    %ebp
c010863f:	c3                   	ret    

c0108640 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108640:	55                   	push   %ebp
c0108641:	89 e5                	mov    %esp,%ebp
c0108643:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108646:	8d 45 14             	lea    0x14(%ebp),%eax
c0108649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010864c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010864f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108653:	8b 45 10             	mov    0x10(%ebp),%eax
c0108656:	89 44 24 08          	mov    %eax,0x8(%esp)
c010865a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010865d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108661:	8b 45 08             	mov    0x8(%ebp),%eax
c0108664:	89 04 24             	mov    %eax,(%esp)
c0108667:	e8 08 00 00 00       	call   c0108674 <vsnprintf>
c010866c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010866f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108672:	c9                   	leave  
c0108673:	c3                   	ret    

c0108674 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108674:	55                   	push   %ebp
c0108675:	89 e5                	mov    %esp,%ebp
c0108677:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010867a:	8b 45 08             	mov    0x8(%ebp),%eax
c010867d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108680:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108683:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108686:	8b 45 08             	mov    0x8(%ebp),%eax
c0108689:	01 d0                	add    %edx,%eax
c010868b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010868e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108695:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108699:	74 0a                	je     c01086a5 <vsnprintf+0x31>
c010869b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010869e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086a1:	39 c2                	cmp    %eax,%edx
c01086a3:	76 07                	jbe    c01086ac <vsnprintf+0x38>
        return -E_INVAL;
c01086a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01086aa:	eb 2a                	jmp    c01086d6 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01086ac:	8b 45 14             	mov    0x14(%ebp),%eax
c01086af:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01086b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01086bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086c1:	c7 04 24 0b 86 10 c0 	movl   $0xc010860b,(%esp)
c01086c8:	e8 53 fb ff ff       	call   c0108220 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01086cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01086d0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01086d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01086d6:	c9                   	leave  
c01086d7:	c3                   	ret    

c01086d8 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01086d8:	55                   	push   %ebp
c01086d9:	89 e5                	mov    %esp,%ebp
c01086db:	57                   	push   %edi
c01086dc:	56                   	push   %esi
c01086dd:	53                   	push   %ebx
c01086de:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01086e1:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c01086e6:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01086ec:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c01086f2:	6b f0 05             	imul   $0x5,%eax,%esi
c01086f5:	01 f7                	add    %esi,%edi
c01086f7:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c01086fc:	f7 e6                	mul    %esi
c01086fe:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0108701:	89 f2                	mov    %esi,%edx
c0108703:	83 c0 0b             	add    $0xb,%eax
c0108706:	83 d2 00             	adc    $0x0,%edx
c0108709:	89 c7                	mov    %eax,%edi
c010870b:	83 e7 ff             	and    $0xffffffff,%edi
c010870e:	89 f9                	mov    %edi,%ecx
c0108710:	0f b7 da             	movzwl %dx,%ebx
c0108713:	89 0d 60 0a 12 c0    	mov    %ecx,0xc0120a60
c0108719:	89 1d 64 0a 12 c0    	mov    %ebx,0xc0120a64
    unsigned long long result = (next >> 12);
c010871f:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108724:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c010872a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010872e:	c1 ea 0c             	shr    $0xc,%edx
c0108731:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108734:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108737:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010873e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108741:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108744:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108747:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010874a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010874d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108750:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108754:	74 1c                	je     c0108772 <rand+0x9a>
c0108756:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108759:	ba 00 00 00 00       	mov    $0x0,%edx
c010875e:	f7 75 dc             	divl   -0x24(%ebp)
c0108761:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108764:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108767:	ba 00 00 00 00       	mov    $0x0,%edx
c010876c:	f7 75 dc             	divl   -0x24(%ebp)
c010876f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108772:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108775:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108778:	f7 75 dc             	divl   -0x24(%ebp)
c010877b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010877e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108781:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108784:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108787:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010878a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010878d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108790:	83 c4 24             	add    $0x24,%esp
c0108793:	5b                   	pop    %ebx
c0108794:	5e                   	pop    %esi
c0108795:	5f                   	pop    %edi
c0108796:	5d                   	pop    %ebp
c0108797:	c3                   	ret    

c0108798 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108798:	55                   	push   %ebp
c0108799:	89 e5                	mov    %esp,%ebp
    next = seed;
c010879b:	8b 45 08             	mov    0x8(%ebp),%eax
c010879e:	ba 00 00 00 00       	mov    $0x0,%edx
c01087a3:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c01087a8:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c01087ae:	5d                   	pop    %ebp
c01087af:	c3                   	ret    

c01087b0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01087b0:	55                   	push   %ebp
c01087b1:	89 e5                	mov    %esp,%ebp
c01087b3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01087b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01087bd:	eb 04                	jmp    c01087c3 <strlen+0x13>
        cnt ++;
c01087bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01087c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087c6:	8d 50 01             	lea    0x1(%eax),%edx
c01087c9:	89 55 08             	mov    %edx,0x8(%ebp)
c01087cc:	0f b6 00             	movzbl (%eax),%eax
c01087cf:	84 c0                	test   %al,%al
c01087d1:	75 ec                	jne    c01087bf <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01087d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01087d6:	c9                   	leave  
c01087d7:	c3                   	ret    

c01087d8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01087d8:	55                   	push   %ebp
c01087d9:	89 e5                	mov    %esp,%ebp
c01087db:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01087de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01087e5:	eb 04                	jmp    c01087eb <strnlen+0x13>
        cnt ++;
c01087e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01087eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01087f1:	73 10                	jae    c0108803 <strnlen+0x2b>
c01087f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f6:	8d 50 01             	lea    0x1(%eax),%edx
c01087f9:	89 55 08             	mov    %edx,0x8(%ebp)
c01087fc:	0f b6 00             	movzbl (%eax),%eax
c01087ff:	84 c0                	test   %al,%al
c0108801:	75 e4                	jne    c01087e7 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108803:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108806:	c9                   	leave  
c0108807:	c3                   	ret    

c0108808 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108808:	55                   	push   %ebp
c0108809:	89 e5                	mov    %esp,%ebp
c010880b:	57                   	push   %edi
c010880c:	56                   	push   %esi
c010880d:	83 ec 20             	sub    $0x20,%esp
c0108810:	8b 45 08             	mov    0x8(%ebp),%eax
c0108813:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108816:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108819:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010881c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010881f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108822:	89 d1                	mov    %edx,%ecx
c0108824:	89 c2                	mov    %eax,%edx
c0108826:	89 ce                	mov    %ecx,%esi
c0108828:	89 d7                	mov    %edx,%edi
c010882a:	ac                   	lods   %ds:(%esi),%al
c010882b:	aa                   	stos   %al,%es:(%edi)
c010882c:	84 c0                	test   %al,%al
c010882e:	75 fa                	jne    c010882a <strcpy+0x22>
c0108830:	89 fa                	mov    %edi,%edx
c0108832:	89 f1                	mov    %esi,%ecx
c0108834:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108837:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010883a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010883d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108840:	83 c4 20             	add    $0x20,%esp
c0108843:	5e                   	pop    %esi
c0108844:	5f                   	pop    %edi
c0108845:	5d                   	pop    %ebp
c0108846:	c3                   	ret    

c0108847 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108847:	55                   	push   %ebp
c0108848:	89 e5                	mov    %esp,%ebp
c010884a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010884d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108850:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108853:	eb 21                	jmp    c0108876 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0108855:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108858:	0f b6 10             	movzbl (%eax),%edx
c010885b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010885e:	88 10                	mov    %dl,(%eax)
c0108860:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108863:	0f b6 00             	movzbl (%eax),%eax
c0108866:	84 c0                	test   %al,%al
c0108868:	74 04                	je     c010886e <strncpy+0x27>
            src ++;
c010886a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010886e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108872:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108876:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010887a:	75 d9                	jne    c0108855 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010887c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010887f:	c9                   	leave  
c0108880:	c3                   	ret    

c0108881 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108881:	55                   	push   %ebp
c0108882:	89 e5                	mov    %esp,%ebp
c0108884:	57                   	push   %edi
c0108885:	56                   	push   %esi
c0108886:	83 ec 20             	sub    $0x20,%esp
c0108889:	8b 45 08             	mov    0x8(%ebp),%eax
c010888c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010888f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108892:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108895:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108898:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010889b:	89 d1                	mov    %edx,%ecx
c010889d:	89 c2                	mov    %eax,%edx
c010889f:	89 ce                	mov    %ecx,%esi
c01088a1:	89 d7                	mov    %edx,%edi
c01088a3:	ac                   	lods   %ds:(%esi),%al
c01088a4:	ae                   	scas   %es:(%edi),%al
c01088a5:	75 08                	jne    c01088af <strcmp+0x2e>
c01088a7:	84 c0                	test   %al,%al
c01088a9:	75 f8                	jne    c01088a3 <strcmp+0x22>
c01088ab:	31 c0                	xor    %eax,%eax
c01088ad:	eb 04                	jmp    c01088b3 <strcmp+0x32>
c01088af:	19 c0                	sbb    %eax,%eax
c01088b1:	0c 01                	or     $0x1,%al
c01088b3:	89 fa                	mov    %edi,%edx
c01088b5:	89 f1                	mov    %esi,%ecx
c01088b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01088ba:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01088bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01088c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01088c3:	83 c4 20             	add    $0x20,%esp
c01088c6:	5e                   	pop    %esi
c01088c7:	5f                   	pop    %edi
c01088c8:	5d                   	pop    %ebp
c01088c9:	c3                   	ret    

c01088ca <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01088ca:	55                   	push   %ebp
c01088cb:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01088cd:	eb 0c                	jmp    c01088db <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01088cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01088d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01088d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01088db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088df:	74 1a                	je     c01088fb <strncmp+0x31>
c01088e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e4:	0f b6 00             	movzbl (%eax),%eax
c01088e7:	84 c0                	test   %al,%al
c01088e9:	74 10                	je     c01088fb <strncmp+0x31>
c01088eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ee:	0f b6 10             	movzbl (%eax),%edx
c01088f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088f4:	0f b6 00             	movzbl (%eax),%eax
c01088f7:	38 c2                	cmp    %al,%dl
c01088f9:	74 d4                	je     c01088cf <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01088fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01088ff:	74 18                	je     c0108919 <strncmp+0x4f>
c0108901:	8b 45 08             	mov    0x8(%ebp),%eax
c0108904:	0f b6 00             	movzbl (%eax),%eax
c0108907:	0f b6 d0             	movzbl %al,%edx
c010890a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010890d:	0f b6 00             	movzbl (%eax),%eax
c0108910:	0f b6 c0             	movzbl %al,%eax
c0108913:	29 c2                	sub    %eax,%edx
c0108915:	89 d0                	mov    %edx,%eax
c0108917:	eb 05                	jmp    c010891e <strncmp+0x54>
c0108919:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010891e:	5d                   	pop    %ebp
c010891f:	c3                   	ret    

c0108920 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108920:	55                   	push   %ebp
c0108921:	89 e5                	mov    %esp,%ebp
c0108923:	83 ec 04             	sub    $0x4,%esp
c0108926:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108929:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010892c:	eb 14                	jmp    c0108942 <strchr+0x22>
        if (*s == c) {
c010892e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108931:	0f b6 00             	movzbl (%eax),%eax
c0108934:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108937:	75 05                	jne    c010893e <strchr+0x1e>
            return (char *)s;
c0108939:	8b 45 08             	mov    0x8(%ebp),%eax
c010893c:	eb 13                	jmp    c0108951 <strchr+0x31>
        }
        s ++;
c010893e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108942:	8b 45 08             	mov    0x8(%ebp),%eax
c0108945:	0f b6 00             	movzbl (%eax),%eax
c0108948:	84 c0                	test   %al,%al
c010894a:	75 e2                	jne    c010892e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010894c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108951:	c9                   	leave  
c0108952:	c3                   	ret    

c0108953 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108953:	55                   	push   %ebp
c0108954:	89 e5                	mov    %esp,%ebp
c0108956:	83 ec 04             	sub    $0x4,%esp
c0108959:	8b 45 0c             	mov    0xc(%ebp),%eax
c010895c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010895f:	eb 11                	jmp    c0108972 <strfind+0x1f>
        if (*s == c) {
c0108961:	8b 45 08             	mov    0x8(%ebp),%eax
c0108964:	0f b6 00             	movzbl (%eax),%eax
c0108967:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010896a:	75 02                	jne    c010896e <strfind+0x1b>
            break;
c010896c:	eb 0e                	jmp    c010897c <strfind+0x29>
        }
        s ++;
c010896e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108972:	8b 45 08             	mov    0x8(%ebp),%eax
c0108975:	0f b6 00             	movzbl (%eax),%eax
c0108978:	84 c0                	test   %al,%al
c010897a:	75 e5                	jne    c0108961 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010897c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010897f:	c9                   	leave  
c0108980:	c3                   	ret    

c0108981 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108981:	55                   	push   %ebp
c0108982:	89 e5                	mov    %esp,%ebp
c0108984:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010898e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108995:	eb 04                	jmp    c010899b <strtol+0x1a>
        s ++;
c0108997:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010899b:	8b 45 08             	mov    0x8(%ebp),%eax
c010899e:	0f b6 00             	movzbl (%eax),%eax
c01089a1:	3c 20                	cmp    $0x20,%al
c01089a3:	74 f2                	je     c0108997 <strtol+0x16>
c01089a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01089a8:	0f b6 00             	movzbl (%eax),%eax
c01089ab:	3c 09                	cmp    $0x9,%al
c01089ad:	74 e8                	je     c0108997 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01089af:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b2:	0f b6 00             	movzbl (%eax),%eax
c01089b5:	3c 2b                	cmp    $0x2b,%al
c01089b7:	75 06                	jne    c01089bf <strtol+0x3e>
        s ++;
c01089b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089bd:	eb 15                	jmp    c01089d4 <strtol+0x53>
    }
    else if (*s == '-') {
c01089bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01089c2:	0f b6 00             	movzbl (%eax),%eax
c01089c5:	3c 2d                	cmp    $0x2d,%al
c01089c7:	75 0b                	jne    c01089d4 <strtol+0x53>
        s ++, neg = 1;
c01089c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01089d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089d8:	74 06                	je     c01089e0 <strtol+0x5f>
c01089da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01089de:	75 24                	jne    c0108a04 <strtol+0x83>
c01089e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e3:	0f b6 00             	movzbl (%eax),%eax
c01089e6:	3c 30                	cmp    $0x30,%al
c01089e8:	75 1a                	jne    c0108a04 <strtol+0x83>
c01089ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ed:	83 c0 01             	add    $0x1,%eax
c01089f0:	0f b6 00             	movzbl (%eax),%eax
c01089f3:	3c 78                	cmp    $0x78,%al
c01089f5:	75 0d                	jne    c0108a04 <strtol+0x83>
        s += 2, base = 16;
c01089f7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01089fb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108a02:	eb 2a                	jmp    c0108a2e <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108a04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a08:	75 17                	jne    c0108a21 <strtol+0xa0>
c0108a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a0d:	0f b6 00             	movzbl (%eax),%eax
c0108a10:	3c 30                	cmp    $0x30,%al
c0108a12:	75 0d                	jne    c0108a21 <strtol+0xa0>
        s ++, base = 8;
c0108a14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a18:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108a1f:	eb 0d                	jmp    c0108a2e <strtol+0xad>
    }
    else if (base == 0) {
c0108a21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a25:	75 07                	jne    c0108a2e <strtol+0xad>
        base = 10;
c0108a27:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a31:	0f b6 00             	movzbl (%eax),%eax
c0108a34:	3c 2f                	cmp    $0x2f,%al
c0108a36:	7e 1b                	jle    c0108a53 <strtol+0xd2>
c0108a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a3b:	0f b6 00             	movzbl (%eax),%eax
c0108a3e:	3c 39                	cmp    $0x39,%al
c0108a40:	7f 11                	jg     c0108a53 <strtol+0xd2>
            dig = *s - '0';
c0108a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a45:	0f b6 00             	movzbl (%eax),%eax
c0108a48:	0f be c0             	movsbl %al,%eax
c0108a4b:	83 e8 30             	sub    $0x30,%eax
c0108a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a51:	eb 48                	jmp    c0108a9b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a56:	0f b6 00             	movzbl (%eax),%eax
c0108a59:	3c 60                	cmp    $0x60,%al
c0108a5b:	7e 1b                	jle    c0108a78 <strtol+0xf7>
c0108a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a60:	0f b6 00             	movzbl (%eax),%eax
c0108a63:	3c 7a                	cmp    $0x7a,%al
c0108a65:	7f 11                	jg     c0108a78 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a6a:	0f b6 00             	movzbl (%eax),%eax
c0108a6d:	0f be c0             	movsbl %al,%eax
c0108a70:	83 e8 57             	sub    $0x57,%eax
c0108a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a76:	eb 23                	jmp    c0108a9b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a7b:	0f b6 00             	movzbl (%eax),%eax
c0108a7e:	3c 40                	cmp    $0x40,%al
c0108a80:	7e 3d                	jle    c0108abf <strtol+0x13e>
c0108a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a85:	0f b6 00             	movzbl (%eax),%eax
c0108a88:	3c 5a                	cmp    $0x5a,%al
c0108a8a:	7f 33                	jg     c0108abf <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a8f:	0f b6 00             	movzbl (%eax),%eax
c0108a92:	0f be c0             	movsbl %al,%eax
c0108a95:	83 e8 37             	sub    $0x37,%eax
c0108a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a9e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108aa1:	7c 02                	jl     c0108aa5 <strtol+0x124>
            break;
c0108aa3:	eb 1a                	jmp    c0108abf <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108aa5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108aa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108aac:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108ab0:	89 c2                	mov    %eax,%edx
c0108ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ab5:	01 d0                	add    %edx,%eax
c0108ab7:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108aba:	e9 6f ff ff ff       	jmp    c0108a2e <strtol+0xad>

    if (endptr) {
c0108abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108ac3:	74 08                	je     c0108acd <strtol+0x14c>
        *endptr = (char *) s;
c0108ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ac8:	8b 55 08             	mov    0x8(%ebp),%edx
c0108acb:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108ad1:	74 07                	je     c0108ada <strtol+0x159>
c0108ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108ad6:	f7 d8                	neg    %eax
c0108ad8:	eb 03                	jmp    c0108add <strtol+0x15c>
c0108ada:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108add:	c9                   	leave  
c0108ade:	c3                   	ret    

c0108adf <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108adf:	55                   	push   %ebp
c0108ae0:	89 e5                	mov    %esp,%ebp
c0108ae2:	57                   	push   %edi
c0108ae3:	83 ec 24             	sub    $0x24,%esp
c0108ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ae9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108aec:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108af0:	8b 55 08             	mov    0x8(%ebp),%edx
c0108af3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108af6:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108af9:	8b 45 10             	mov    0x10(%ebp),%eax
c0108afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108aff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108b02:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108b06:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108b09:	89 d7                	mov    %edx,%edi
c0108b0b:	f3 aa                	rep stos %al,%es:(%edi)
c0108b0d:	89 fa                	mov    %edi,%edx
c0108b0f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108b12:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108b18:	83 c4 24             	add    $0x24,%esp
c0108b1b:	5f                   	pop    %edi
c0108b1c:	5d                   	pop    %ebp
c0108b1d:	c3                   	ret    

c0108b1e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108b1e:	55                   	push   %ebp
c0108b1f:	89 e5                	mov    %esp,%ebp
c0108b21:	57                   	push   %edi
c0108b22:	56                   	push   %esi
c0108b23:	53                   	push   %ebx
c0108b24:	83 ec 30             	sub    $0x30,%esp
c0108b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b30:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108b33:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b36:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b3c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108b3f:	73 42                	jae    c0108b83 <memmove+0x65>
c0108b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b50:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108b53:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b56:	c1 e8 02             	shr    $0x2,%eax
c0108b59:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108b5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b61:	89 d7                	mov    %edx,%edi
c0108b63:	89 c6                	mov    %eax,%esi
c0108b65:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b67:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108b6a:	83 e1 03             	and    $0x3,%ecx
c0108b6d:	74 02                	je     c0108b71 <memmove+0x53>
c0108b6f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b71:	89 f0                	mov    %esi,%eax
c0108b73:	89 fa                	mov    %edi,%edx
c0108b75:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108b78:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108b7b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108b81:	eb 36                	jmp    c0108bb9 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b8c:	01 c2                	add    %eax,%edx
c0108b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b91:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b97:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b9d:	89 c1                	mov    %eax,%ecx
c0108b9f:	89 d8                	mov    %ebx,%eax
c0108ba1:	89 d6                	mov    %edx,%esi
c0108ba3:	89 c7                	mov    %eax,%edi
c0108ba5:	fd                   	std    
c0108ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108ba8:	fc                   	cld    
c0108ba9:	89 f8                	mov    %edi,%eax
c0108bab:	89 f2                	mov    %esi,%edx
c0108bad:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108bb0:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108bb3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108bb9:	83 c4 30             	add    $0x30,%esp
c0108bbc:	5b                   	pop    %ebx
c0108bbd:	5e                   	pop    %esi
c0108bbe:	5f                   	pop    %edi
c0108bbf:	5d                   	pop    %ebp
c0108bc0:	c3                   	ret    

c0108bc1 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108bc1:	55                   	push   %ebp
c0108bc2:	89 e5                	mov    %esp,%ebp
c0108bc4:	57                   	push   %edi
c0108bc5:	56                   	push   %esi
c0108bc6:	83 ec 20             	sub    $0x20,%esp
c0108bc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108bd5:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108bde:	c1 e8 02             	shr    $0x2,%eax
c0108be1:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108be9:	89 d7                	mov    %edx,%edi
c0108beb:	89 c6                	mov    %eax,%esi
c0108bed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108bef:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108bf2:	83 e1 03             	and    $0x3,%ecx
c0108bf5:	74 02                	je     c0108bf9 <memcpy+0x38>
c0108bf7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108bf9:	89 f0                	mov    %esi,%eax
c0108bfb:	89 fa                	mov    %edi,%edx
c0108bfd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108c00:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108c09:	83 c4 20             	add    $0x20,%esp
c0108c0c:	5e                   	pop    %esi
c0108c0d:	5f                   	pop    %edi
c0108c0e:	5d                   	pop    %ebp
c0108c0f:	c3                   	ret    

c0108c10 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108c10:	55                   	push   %ebp
c0108c11:	89 e5                	mov    %esp,%ebp
c0108c13:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108c22:	eb 30                	jmp    c0108c54 <memcmp+0x44>
        if (*s1 != *s2) {
c0108c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c27:	0f b6 10             	movzbl (%eax),%edx
c0108c2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c2d:	0f b6 00             	movzbl (%eax),%eax
c0108c30:	38 c2                	cmp    %al,%dl
c0108c32:	74 18                	je     c0108c4c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c37:	0f b6 00             	movzbl (%eax),%eax
c0108c3a:	0f b6 d0             	movzbl %al,%edx
c0108c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108c40:	0f b6 00             	movzbl (%eax),%eax
c0108c43:	0f b6 c0             	movzbl %al,%eax
c0108c46:	29 c2                	sub    %eax,%edx
c0108c48:	89 d0                	mov    %edx,%eax
c0108c4a:	eb 1a                	jmp    c0108c66 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108c4c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108c50:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108c54:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c57:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108c5a:	89 55 10             	mov    %edx,0x10(%ebp)
c0108c5d:	85 c0                	test   %eax,%eax
c0108c5f:	75 c3                	jne    c0108c24 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108c61:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c66:	c9                   	leave  
c0108c67:	c3                   	ret    
