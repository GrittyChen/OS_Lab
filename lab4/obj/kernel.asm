
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
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
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 29 9c 00 00       	call   c0109c7f <memset>

    cons_init();                // init the console
c0100056:	e8 a3 15 00 00       	call   c01015fe <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 9e 10 c0 	movl   $0xc0109e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 9e 10 c0 	movl   $0xc0109e3c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 12 54 00 00       	call   c0105496 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 53 1f 00 00       	call   c0101fdc <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 cb 20 00 00       	call   c0102159 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 b0 7a 00 00       	call   c0107b43 <vmm_init>
    proc_init();                // init process table
c0100093:	e8 dd 8d 00 00       	call   c0108e75 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 92 16 00 00       	call   c010172f <ide_init>
    swap_init();                // init swap
c010009d:	e8 90 66 00 00       	call   c0106732 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 0d 0d 00 00       	call   c0100db4 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 9e 1e 00 00       	call   c0101f4a <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 83 8f 00 00       	call   c0109034 <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 13 0c 00 00       	call   c0100ce6 <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 41 9e 10 c0 	movl   $0xc0109e41,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 4f 9e 10 c0 	movl   $0xc0109e4f,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 5d 9e 10 c0 	movl   $0xc0109e5d,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 6b 9e 10 c0 	movl   $0xc0109e6b,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 79 9e 10 c0 	movl   $0xc0109e79,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 88 9e 10 c0 	movl   $0xc0109e88,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 a8 9e 10 c0 	movl   $0xc0109ea8,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 c7 9e 10 c0 	movl   $0xc0109ec7,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 19 13 00 00       	call   c010162a <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 72 90 00 00       	call   c01093c0 <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 a0 12 00 00       	call   c010162a <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 80 12 00 00       	call   c0101666 <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 cc 9e 10 c0    	movl   $0xc0109ecc,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 cc 9e 10 c0 	movl   $0xc0109ecc,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 34 c0 10 c0 	movl   $0xc010c034,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 f8 d3 11 c0 	movl   $0xc011d3f8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec f9 d3 11 c0 	movl   $0xc011d3f9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 fc 1b 12 c0 	movl   $0xc0121bfc,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 f0 93 00 00       	call   c0109af3 <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 d6 9e 10 c0 	movl   $0xc0109ed6,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 ef 9e 10 c0 	movl   $0xc0109eef,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 08 9e 10 	movl   $0xc0109e08,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 07 9f 10 c0 	movl   $0xc0109f07,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 1f 9f 10 c0 	movl   $0xc0109f1f,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 37 9f 10 c0 	movl   $0xc0109f37,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 50 9f 10 c0 	movl   $0xc0109f50,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 7a 9f 10 c0 	movl   $0xc0109f7a,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 96 9f 10 c0 	movl   $0xc0109f96,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i=0, j=0;
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
c01009f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009ff:	e9 94 00 00 00       	jmp    c0100a98 <print_stackframe+0xc7>
	{
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c0100a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a07:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a12:	c7 04 24 a8 9f 10 c0 	movl   $0xc0109fa8,(%esp)
c0100a19:	e8 35 f9 ff ff       	call   c0100353 <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a21:	83 c0 08             	add    $0x8,%eax
c0100a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//print arguments;
		cprintf("args:");
c0100a27:	c7 04 24 bf 9f 10 c0 	movl   $0xc0109fbf,(%esp)
c0100a2e:	e8 20 f9 ff ff       	call   c0100353 <cprintf>
		for(j=0; j<4; j++)
c0100a33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a3a:	eb 25                	jmp    c0100a61 <print_stackframe+0x90>
			cprintf("0x%08x ", args[j]);
c0100a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a49:	01 d0                	add    %edx,%eax
c0100a4b:	8b 00                	mov    (%eax),%eax
c0100a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a51:	c7 04 24 c5 9f 10 c0 	movl   $0xc0109fc5,(%esp)
c0100a58:	e8 f6 f8 ff ff       	call   c0100353 <cprintf>
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		//print arguments;
		cprintf("args:");
		for(j=0; j<4; j++)
c0100a5d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a61:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a65:	7e d5                	jle    c0100a3c <print_stackframe+0x6b>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100a67:	c7 04 24 cd 9f 10 c0 	movl   $0xc0109fcd,(%esp)
c0100a6e:	e8 e0 f8 ff ff       	call   c0100353 <cprintf>
		//call print_debuginfo(eip-1)
		print_debuginfo(eip-1);
c0100a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a76:	83 e8 01             	sub    $0x1,%eax
c0100a79:	89 04 24             	mov    %eax,(%esp)
c0100a7c:	e8 9c fe ff ff       	call   c010091d <print_debuginfo>
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
c0100a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a84:	83 c0 04             	add    $0x4,%eax
c0100a87:	8b 00                	mov    (%eax),%eax
c0100a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8f:	8b 00                	mov    (%eax),%eax
c0100a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i=0, j=0;
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
c0100a94:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a98:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a9c:	7f 0a                	jg     c0100aa8 <print_stackframe+0xd7>
c0100a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100aa2:	0f 85 5c ff ff ff    	jne    c0100a04 <print_stackframe+0x33>
		print_debuginfo(eip-1);
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
	return;
c0100aa8:	90                   	nop
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100aa9:	c9                   	leave  
c0100aaa:	c3                   	ret    

c0100aab <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aab:	55                   	push   %ebp
c0100aac:	89 e5                	mov    %esp,%ebp
c0100aae:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ab8:	eb 0c                	jmp    c0100ac6 <parse+0x1b>
            *buf ++ = '\0';
c0100aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abd:	8d 50 01             	lea    0x1(%eax),%edx
c0100ac0:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ac3:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac9:	0f b6 00             	movzbl (%eax),%eax
c0100acc:	84 c0                	test   %al,%al
c0100ace:	74 1d                	je     c0100aed <parse+0x42>
c0100ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad3:	0f b6 00             	movzbl (%eax),%eax
c0100ad6:	0f be c0             	movsbl %al,%eax
c0100ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100add:	c7 04 24 50 a0 10 c0 	movl   $0xc010a050,(%esp)
c0100ae4:	e8 d7 8f 00 00       	call   c0109ac0 <strchr>
c0100ae9:	85 c0                	test   %eax,%eax
c0100aeb:	75 cd                	jne    c0100aba <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af0:	0f b6 00             	movzbl (%eax),%eax
c0100af3:	84 c0                	test   %al,%al
c0100af5:	75 02                	jne    c0100af9 <parse+0x4e>
            break;
c0100af7:	eb 67                	jmp    c0100b60 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100af9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100afd:	75 14                	jne    c0100b13 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100aff:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b06:	00 
c0100b07:	c7 04 24 55 a0 10 c0 	movl   $0xc010a055,(%esp)
c0100b0e:	e8 40 f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b16:	8d 50 01             	lea    0x1(%eax),%edx
c0100b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b26:	01 c2                	add    %eax,%edx
c0100b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2b:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b2d:	eb 04                	jmp    c0100b33 <parse+0x88>
            buf ++;
c0100b2f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b36:	0f b6 00             	movzbl (%eax),%eax
c0100b39:	84 c0                	test   %al,%al
c0100b3b:	74 1d                	je     c0100b5a <parse+0xaf>
c0100b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b40:	0f b6 00             	movzbl (%eax),%eax
c0100b43:	0f be c0             	movsbl %al,%eax
c0100b46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4a:	c7 04 24 50 a0 10 c0 	movl   $0xc010a050,(%esp)
c0100b51:	e8 6a 8f 00 00       	call   c0109ac0 <strchr>
c0100b56:	85 c0                	test   %eax,%eax
c0100b58:	74 d5                	je     c0100b2f <parse+0x84>
            buf ++;
        }
    }
c0100b5a:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b5b:	e9 66 ff ff ff       	jmp    c0100ac6 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b63:	c9                   	leave  
c0100b64:	c3                   	ret    

c0100b65 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b65:	55                   	push   %ebp
c0100b66:	89 e5                	mov    %esp,%ebp
c0100b68:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b6b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b75:	89 04 24             	mov    %eax,(%esp)
c0100b78:	e8 2e ff ff ff       	call   c0100aab <parse>
c0100b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b84:	75 0a                	jne    c0100b90 <runcmd+0x2b>
        return 0;
c0100b86:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b8b:	e9 85 00 00 00       	jmp    c0100c15 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b97:	eb 5c                	jmp    c0100bf5 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b99:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9f:	89 d0                	mov    %edx,%eax
c0100ba1:	01 c0                	add    %eax,%eax
c0100ba3:	01 d0                	add    %edx,%eax
c0100ba5:	c1 e0 02             	shl    $0x2,%eax
c0100ba8:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bad:	8b 00                	mov    (%eax),%eax
c0100baf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100bb3:	89 04 24             	mov    %eax,(%esp)
c0100bb6:	e8 66 8e 00 00       	call   c0109a21 <strcmp>
c0100bbb:	85 c0                	test   %eax,%eax
c0100bbd:	75 32                	jne    c0100bf1 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bc2:	89 d0                	mov    %edx,%eax
c0100bc4:	01 c0                	add    %eax,%eax
c0100bc6:	01 d0                	add    %edx,%eax
c0100bc8:	c1 e0 02             	shl    $0x2,%eax
c0100bcb:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bd0:	8b 40 08             	mov    0x8(%eax),%eax
c0100bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bd6:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bdc:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100be0:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100be3:	83 c2 04             	add    $0x4,%edx
c0100be6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bea:	89 0c 24             	mov    %ecx,(%esp)
c0100bed:	ff d0                	call   *%eax
c0100bef:	eb 24                	jmp    c0100c15 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bf1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf8:	83 f8 02             	cmp    $0x2,%eax
c0100bfb:	76 9c                	jbe    c0100b99 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bfd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c04:	c7 04 24 73 a0 10 c0 	movl   $0xc010a073,(%esp)
c0100c0b:	e8 43 f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c15:	c9                   	leave  
c0100c16:	c3                   	ret    

c0100c17 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c17:	55                   	push   %ebp
c0100c18:	89 e5                	mov    %esp,%ebp
c0100c1a:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c1d:	c7 04 24 8c a0 10 c0 	movl   $0xc010a08c,(%esp)
c0100c24:	e8 2a f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c29:	c7 04 24 b4 a0 10 c0 	movl   $0xc010a0b4,(%esp)
c0100c30:	e8 1e f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c39:	74 0b                	je     c0100c46 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3e:	89 04 24             	mov    %eax,(%esp)
c0100c41:	e8 d8 16 00 00       	call   c010231e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c46:	c7 04 24 d9 a0 10 c0 	movl   $0xc010a0d9,(%esp)
c0100c4d:	e8 f8 f5 ff ff       	call   c010024a <readline>
c0100c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c59:	74 18                	je     c0100c73 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c65:	89 04 24             	mov    %eax,(%esp)
c0100c68:	e8 f8 fe ff ff       	call   c0100b65 <runcmd>
c0100c6d:	85 c0                	test   %eax,%eax
c0100c6f:	79 02                	jns    c0100c73 <kmonitor+0x5c>
                break;
c0100c71:	eb 02                	jmp    c0100c75 <kmonitor+0x5e>
            }
        }
    }
c0100c73:	eb d1                	jmp    c0100c46 <kmonitor+0x2f>
}
c0100c75:	c9                   	leave  
c0100c76:	c3                   	ret    

c0100c77 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c77:	55                   	push   %ebp
c0100c78:	89 e5                	mov    %esp,%ebp
c0100c7a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c84:	eb 3f                	jmp    c0100cc5 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c89:	89 d0                	mov    %edx,%eax
c0100c8b:	01 c0                	add    %eax,%eax
c0100c8d:	01 d0                	add    %edx,%eax
c0100c8f:	c1 e0 02             	shl    $0x2,%eax
c0100c92:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c97:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9d:	89 d0                	mov    %edx,%eax
c0100c9f:	01 c0                	add    %eax,%eax
c0100ca1:	01 d0                	add    %edx,%eax
c0100ca3:	c1 e0 02             	shl    $0x2,%eax
c0100ca6:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100cab:	8b 00                	mov    (%eax),%eax
c0100cad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb5:	c7 04 24 dd a0 10 c0 	movl   $0xc010a0dd,(%esp)
c0100cbc:	e8 92 f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cc1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc8:	83 f8 02             	cmp    $0x2,%eax
c0100ccb:	76 b9                	jbe    c0100c86 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd2:	c9                   	leave  
c0100cd3:	c3                   	ret    

c0100cd4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cd4:	55                   	push   %ebp
c0100cd5:	89 e5                	mov    %esp,%ebp
c0100cd7:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cda:	e8 a8 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce4:	c9                   	leave  
c0100ce5:	c3                   	ret    

c0100ce6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ce6:	55                   	push   %ebp
c0100ce7:	89 e5                	mov    %esp,%ebp
c0100ce9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cec:	e8 e0 fc ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf6:	c9                   	leave  
c0100cf7:	c3                   	ret    

c0100cf8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cf8:	55                   	push   %ebp
c0100cf9:	89 e5                	mov    %esp,%ebp
c0100cfb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cfe:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100d03:	85 c0                	test   %eax,%eax
c0100d05:	74 02                	je     c0100d09 <__panic+0x11>
        goto panic_dead;
c0100d07:	eb 48                	jmp    c0100d51 <__panic+0x59>
    }
    is_panic = 1;
c0100d09:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100d10:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d13:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d27:	c7 04 24 e6 a0 10 c0 	movl   $0xc010a0e6,(%esp)
c0100d2e:	e8 20 f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d3d:	89 04 24             	mov    %eax,(%esp)
c0100d40:	e8 db f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d45:	c7 04 24 02 a1 10 c0 	movl   $0xc010a102,(%esp)
c0100d4c:	e8 02 f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d51:	e8 fa 11 00 00       	call   c0101f50 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d5d:	e8 b5 fe ff ff       	call   c0100c17 <kmonitor>
    }
c0100d62:	eb f2                	jmp    c0100d56 <__panic+0x5e>

c0100d64 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d64:	55                   	push   %ebp
c0100d65:	89 e5                	mov    %esp,%ebp
c0100d67:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d6a:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d73:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d7e:	c7 04 24 04 a1 10 c0 	movl   $0xc010a104,(%esp)
c0100d85:	e8 c9 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d91:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d94:	89 04 24             	mov    %eax,(%esp)
c0100d97:	e8 84 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d9c:	c7 04 24 02 a1 10 c0 	movl   $0xc010a102,(%esp)
c0100da3:	e8 ab f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100da8:	c9                   	leave  
c0100da9:	c3                   	ret    

c0100daa <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100daa:	55                   	push   %ebp
c0100dab:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100dad:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100db2:	5d                   	pop    %ebp
c0100db3:	c3                   	ret    

c0100db4 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100db4:	55                   	push   %ebp
c0100db5:	89 e5                	mov    %esp,%ebp
c0100db7:	83 ec 28             	sub    $0x28,%esp
c0100dba:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100dc0:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dc4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dc8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dcc:	ee                   	out    %al,(%dx)
c0100dcd:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dd3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dd7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ddb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ddf:	ee                   	out    %al,(%dx)
c0100de0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100de6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dea:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dee:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100df2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100df3:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100dfa:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dfd:	c7 04 24 22 a1 10 c0 	movl   $0xc010a122,(%esp)
c0100e04:	e8 4a f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e10:	e8 99 11 00 00       	call   c0101fae <pic_enable>
}
c0100e15:	c9                   	leave  
c0100e16:	c3                   	ret    

c0100e17 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e17:	55                   	push   %ebp
c0100e18:	89 e5                	mov    %esp,%ebp
c0100e1a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e1d:	9c                   	pushf  
c0100e1e:	58                   	pop    %eax
c0100e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e25:	25 00 02 00 00       	and    $0x200,%eax
c0100e2a:	85 c0                	test   %eax,%eax
c0100e2c:	74 0c                	je     c0100e3a <__intr_save+0x23>
        intr_disable();
c0100e2e:	e8 1d 11 00 00       	call   c0101f50 <intr_disable>
        return 1;
c0100e33:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e38:	eb 05                	jmp    c0100e3f <__intr_save+0x28>
    }
    return 0;
c0100e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e3f:	c9                   	leave  
c0100e40:	c3                   	ret    

c0100e41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e4b:	74 05                	je     c0100e52 <__intr_restore+0x11>
        intr_enable();
c0100e4d:	e8 f8 10 00 00       	call   c0101f4a <intr_enable>
    }
}
c0100e52:	c9                   	leave  
c0100e53:	c3                   	ret    

c0100e54 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e54:	55                   	push   %ebp
c0100e55:	89 e5                	mov    %esp,%ebp
c0100e57:	83 ec 10             	sub    $0x10,%esp
c0100e5a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e60:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e64:	89 c2                	mov    %eax,%edx
c0100e66:	ec                   	in     (%dx),%al
c0100e67:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e6a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e70:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e74:	89 c2                	mov    %eax,%edx
c0100e76:	ec                   	in     (%dx),%al
c0100e77:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e7a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e80:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e84:	89 c2                	mov    %eax,%edx
c0100e86:	ec                   	in     (%dx),%al
c0100e87:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e8a:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e90:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e94:	89 c2                	mov    %eax,%edx
c0100e96:	ec                   	in     (%dx),%al
c0100e97:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e9a:	c9                   	leave  
c0100e9b:	c3                   	ret    

c0100e9c <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e9c:	55                   	push   %ebp
c0100e9d:	89 e5                	mov    %esp,%ebp
c0100e9f:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ea2:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eac:	0f b7 00             	movzwl (%eax),%eax
c0100eaf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb6:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebe:	0f b7 00             	movzwl (%eax),%eax
c0100ec1:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ec5:	74 12                	je     c0100ed9 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec7:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ece:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100ed5:	b4 03 
c0100ed7:	eb 13                	jmp    c0100eec <cga_init+0x50>
    } else {
        *cp = was;
c0100ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100edc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ee0:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ee3:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100eea:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eec:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ef3:	0f b7 c0             	movzwl %ax,%eax
c0100ef6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100efa:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f06:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f07:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f0e:	83 c0 01             	add    $0x1,%eax
c0100f11:	0f b7 c0             	movzwl %ax,%eax
c0100f14:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f18:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f1c:	89 c2                	mov    %eax,%edx
c0100f1e:	ec                   	in     (%dx),%al
c0100f1f:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f22:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f26:	0f b6 c0             	movzbl %al,%eax
c0100f29:	c1 e0 08             	shl    $0x8,%eax
c0100f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f2f:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f36:	0f b7 c0             	movzwl %ax,%eax
c0100f39:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f3d:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f41:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f45:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f49:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f4a:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f51:	83 c0 01             	add    $0x1,%eax
c0100f54:	0f b7 c0             	movzwl %ax,%eax
c0100f57:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f5f:	89 c2                	mov    %eax,%edx
c0100f61:	ec                   	in     (%dx),%al
c0100f62:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f65:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f69:	0f b6 c0             	movzbl %al,%eax
c0100f6c:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f72:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f7a:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f80:	c9                   	leave  
c0100f81:	c3                   	ret    

c0100f82 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f82:	55                   	push   %ebp
c0100f83:	89 e5                	mov    %esp,%ebp
c0100f85:	83 ec 48             	sub    $0x48,%esp
c0100f88:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f8e:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f9a:	ee                   	out    %al,(%dx)
c0100f9b:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100fa1:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100fa5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fa9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fad:	ee                   	out    %al,(%dx)
c0100fae:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fb4:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fb8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fc0:	ee                   	out    %al,(%dx)
c0100fc1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fcb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fcf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fd3:	ee                   	out    %al,(%dx)
c0100fd4:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fda:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fde:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fe2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fe6:	ee                   	out    %al,(%dx)
c0100fe7:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fed:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100ff1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100ff5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff9:	ee                   	out    %al,(%dx)
c0100ffa:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101000:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0101004:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101008:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010100c:	ee                   	out    %al,(%dx)
c010100d:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101013:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101017:	89 c2                	mov    %eax,%edx
c0101019:	ec                   	in     (%dx),%al
c010101a:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c010101d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101021:	3c ff                	cmp    $0xff,%al
c0101023:	0f 95 c0             	setne  %al
c0101026:	0f b6 c0             	movzbl %al,%eax
c0101029:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c010102e:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101034:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101038:	89 c2                	mov    %eax,%edx
c010103a:	ec                   	in     (%dx),%al
c010103b:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010103e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101044:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101048:	89 c2                	mov    %eax,%edx
c010104a:	ec                   	in     (%dx),%al
c010104b:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010104e:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101053:	85 c0                	test   %eax,%eax
c0101055:	74 0c                	je     c0101063 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101057:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010105e:	e8 4b 0f 00 00       	call   c0101fae <pic_enable>
    }
}
c0101063:	c9                   	leave  
c0101064:	c3                   	ret    

c0101065 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101065:	55                   	push   %ebp
c0101066:	89 e5                	mov    %esp,%ebp
c0101068:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101072:	eb 09                	jmp    c010107d <lpt_putc_sub+0x18>
        delay();
c0101074:	e8 db fd ff ff       	call   c0100e54 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101079:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010107d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101083:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101087:	89 c2                	mov    %eax,%edx
c0101089:	ec                   	in     (%dx),%al
c010108a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010108d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101091:	84 c0                	test   %al,%al
c0101093:	78 09                	js     c010109e <lpt_putc_sub+0x39>
c0101095:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010109c:	7e d6                	jle    c0101074 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010109e:	8b 45 08             	mov    0x8(%ebp),%eax
c01010a1:	0f b6 c0             	movzbl %al,%eax
c01010a4:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010aa:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010ad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010b1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010b5:	ee                   	out    %al,(%dx)
c01010b6:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010bc:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010c0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010c4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010c8:	ee                   	out    %al,(%dx)
c01010c9:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010cf:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010d3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010db:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010dc:	c9                   	leave  
c01010dd:	c3                   	ret    

c01010de <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010de:	55                   	push   %ebp
c01010df:	89 e5                	mov    %esp,%ebp
c01010e1:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010e4:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010e8:	74 0d                	je     c01010f7 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ed:	89 04 24             	mov    %eax,(%esp)
c01010f0:	e8 70 ff ff ff       	call   c0101065 <lpt_putc_sub>
c01010f5:	eb 24                	jmp    c010111b <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010f7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fe:	e8 62 ff ff ff       	call   c0101065 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101103:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010110a:	e8 56 ff ff ff       	call   c0101065 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010110f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101116:	e8 4a ff ff ff       	call   c0101065 <lpt_putc_sub>
    }
}
c010111b:	c9                   	leave  
c010111c:	c3                   	ret    

c010111d <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010111d:	55                   	push   %ebp
c010111e:	89 e5                	mov    %esp,%ebp
c0101120:	53                   	push   %ebx
c0101121:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101124:	8b 45 08             	mov    0x8(%ebp),%eax
c0101127:	b0 00                	mov    $0x0,%al
c0101129:	85 c0                	test   %eax,%eax
c010112b:	75 07                	jne    c0101134 <cga_putc+0x17>
        c |= 0x0700;
c010112d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101134:	8b 45 08             	mov    0x8(%ebp),%eax
c0101137:	0f b6 c0             	movzbl %al,%eax
c010113a:	83 f8 0a             	cmp    $0xa,%eax
c010113d:	74 4c                	je     c010118b <cga_putc+0x6e>
c010113f:	83 f8 0d             	cmp    $0xd,%eax
c0101142:	74 57                	je     c010119b <cga_putc+0x7e>
c0101144:	83 f8 08             	cmp    $0x8,%eax
c0101147:	0f 85 88 00 00 00    	jne    c01011d5 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010114d:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101154:	66 85 c0             	test   %ax,%ax
c0101157:	74 30                	je     c0101189 <cga_putc+0x6c>
            crt_pos --;
c0101159:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101160:	83 e8 01             	sub    $0x1,%eax
c0101163:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101169:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010116e:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c0101175:	0f b7 d2             	movzwl %dx,%edx
c0101178:	01 d2                	add    %edx,%edx
c010117a:	01 c2                	add    %eax,%edx
c010117c:	8b 45 08             	mov    0x8(%ebp),%eax
c010117f:	b0 00                	mov    $0x0,%al
c0101181:	83 c8 20             	or     $0x20,%eax
c0101184:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101187:	eb 72                	jmp    c01011fb <cga_putc+0xde>
c0101189:	eb 70                	jmp    c01011fb <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010118b:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101192:	83 c0 50             	add    $0x50,%eax
c0101195:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010119b:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c01011a2:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c01011a9:	0f b7 c1             	movzwl %cx,%eax
c01011ac:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011b2:	c1 e8 10             	shr    $0x10,%eax
c01011b5:	89 c2                	mov    %eax,%edx
c01011b7:	66 c1 ea 06          	shr    $0x6,%dx
c01011bb:	89 d0                	mov    %edx,%eax
c01011bd:	c1 e0 02             	shl    $0x2,%eax
c01011c0:	01 d0                	add    %edx,%eax
c01011c2:	c1 e0 04             	shl    $0x4,%eax
c01011c5:	29 c1                	sub    %eax,%ecx
c01011c7:	89 ca                	mov    %ecx,%edx
c01011c9:	89 d8                	mov    %ebx,%eax
c01011cb:	29 d0                	sub    %edx,%eax
c01011cd:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011d3:	eb 26                	jmp    c01011fb <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011d5:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011db:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e2:	8d 50 01             	lea    0x1(%eax),%edx
c01011e5:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011ec:	0f b7 c0             	movzwl %ax,%eax
c01011ef:	01 c0                	add    %eax,%eax
c01011f1:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f7:	66 89 02             	mov    %ax,(%edx)
        break;
c01011fa:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011fb:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101202:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101206:	76 5b                	jbe    c0101263 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101208:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010120d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101213:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101218:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010121f:	00 
c0101220:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101224:	89 04 24             	mov    %eax,(%esp)
c0101227:	e8 92 8a 00 00       	call   c0109cbe <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101233:	eb 15                	jmp    c010124a <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101235:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010123a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010123d:	01 d2                	add    %edx,%edx
c010123f:	01 d0                	add    %edx,%eax
c0101241:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101246:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010124a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101251:	7e e2                	jle    c0101235 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101253:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010125a:	83 e8 50             	sub    $0x50,%eax
c010125d:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101263:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010126a:	0f b7 c0             	movzwl %ax,%eax
c010126d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101271:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101275:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101279:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010127d:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010127e:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101285:	66 c1 e8 08          	shr    $0x8,%ax
c0101289:	0f b6 c0             	movzbl %al,%eax
c010128c:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101293:	83 c2 01             	add    $0x1,%edx
c0101296:	0f b7 d2             	movzwl %dx,%edx
c0101299:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010129d:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a9:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c01012b0:	0f b7 c0             	movzwl %ax,%eax
c01012b3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012b7:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012bb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012bf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012c3:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012c4:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012cb:	0f b6 c0             	movzbl %al,%eax
c01012ce:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012d5:	83 c2 01             	add    $0x1,%edx
c01012d8:	0f b7 d2             	movzwl %dx,%edx
c01012db:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012df:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012e2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012e6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ea:	ee                   	out    %al,(%dx)
}
c01012eb:	83 c4 34             	add    $0x34,%esp
c01012ee:	5b                   	pop    %ebx
c01012ef:	5d                   	pop    %ebp
c01012f0:	c3                   	ret    

c01012f1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012f1:	55                   	push   %ebp
c01012f2:	89 e5                	mov    %esp,%ebp
c01012f4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012fe:	eb 09                	jmp    c0101309 <serial_putc_sub+0x18>
        delay();
c0101300:	e8 4f fb ff ff       	call   c0100e54 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101305:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101309:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010130f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101313:	89 c2                	mov    %eax,%edx
c0101315:	ec                   	in     (%dx),%al
c0101316:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101319:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010131d:	0f b6 c0             	movzbl %al,%eax
c0101320:	83 e0 20             	and    $0x20,%eax
c0101323:	85 c0                	test   %eax,%eax
c0101325:	75 09                	jne    c0101330 <serial_putc_sub+0x3f>
c0101327:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010132e:	7e d0                	jle    c0101300 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101330:	8b 45 08             	mov    0x8(%ebp),%eax
c0101333:	0f b6 c0             	movzbl %al,%eax
c0101336:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010133c:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010133f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101343:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101347:	ee                   	out    %al,(%dx)
}
c0101348:	c9                   	leave  
c0101349:	c3                   	ret    

c010134a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010134a:	55                   	push   %ebp
c010134b:	89 e5                	mov    %esp,%ebp
c010134d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101350:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101354:	74 0d                	je     c0101363 <serial_putc+0x19>
        serial_putc_sub(c);
c0101356:	8b 45 08             	mov    0x8(%ebp),%eax
c0101359:	89 04 24             	mov    %eax,(%esp)
c010135c:	e8 90 ff ff ff       	call   c01012f1 <serial_putc_sub>
c0101361:	eb 24                	jmp    c0101387 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101363:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010136a:	e8 82 ff ff ff       	call   c01012f1 <serial_putc_sub>
        serial_putc_sub(' ');
c010136f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101376:	e8 76 ff ff ff       	call   c01012f1 <serial_putc_sub>
        serial_putc_sub('\b');
c010137b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101382:	e8 6a ff ff ff       	call   c01012f1 <serial_putc_sub>
    }
}
c0101387:	c9                   	leave  
c0101388:	c3                   	ret    

c0101389 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101389:	55                   	push   %ebp
c010138a:	89 e5                	mov    %esp,%ebp
c010138c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010138f:	eb 33                	jmp    c01013c4 <cons_intr+0x3b>
        if (c != 0) {
c0101391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101395:	74 2d                	je     c01013c4 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101397:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c010139c:	8d 50 01             	lea    0x1(%eax),%edx
c010139f:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c01013a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a8:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013ae:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c01013b3:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b8:	75 0a                	jne    c01013c4 <cons_intr+0x3b>
                cons.wpos = 0;
c01013ba:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013c1:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c7:	ff d0                	call   *%eax
c01013c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013d0:	75 bf                	jne    c0101391 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013d2:	c9                   	leave  
c01013d3:	c3                   	ret    

c01013d4 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013d4:	55                   	push   %ebp
c01013d5:	89 e5                	mov    %esp,%ebp
c01013d7:	83 ec 10             	sub    $0x10,%esp
c01013da:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013e4:	89 c2                	mov    %eax,%edx
c01013e6:	ec                   	in     (%dx),%al
c01013e7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013ee:	0f b6 c0             	movzbl %al,%eax
c01013f1:	83 e0 01             	and    $0x1,%eax
c01013f4:	85 c0                	test   %eax,%eax
c01013f6:	75 07                	jne    c01013ff <serial_proc_data+0x2b>
        return -1;
c01013f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013fd:	eb 2a                	jmp    c0101429 <serial_proc_data+0x55>
c01013ff:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101405:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101409:	89 c2                	mov    %eax,%edx
c010140b:	ec                   	in     (%dx),%al
c010140c:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c010140f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101413:	0f b6 c0             	movzbl %al,%eax
c0101416:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101419:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010141d:	75 07                	jne    c0101426 <serial_proc_data+0x52>
        c = '\b';
c010141f:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101426:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101429:	c9                   	leave  
c010142a:	c3                   	ret    

c010142b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010142b:	55                   	push   %ebp
c010142c:	89 e5                	mov    %esp,%ebp
c010142e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101431:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	74 0c                	je     c0101446 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010143a:	c7 04 24 d4 13 10 c0 	movl   $0xc01013d4,(%esp)
c0101441:	e8 43 ff ff ff       	call   c0101389 <cons_intr>
    }
}
c0101446:	c9                   	leave  
c0101447:	c3                   	ret    

c0101448 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101448:	55                   	push   %ebp
c0101449:	89 e5                	mov    %esp,%ebp
c010144b:	83 ec 38             	sub    $0x38,%esp
c010144e:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101454:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101458:	89 c2                	mov    %eax,%edx
c010145a:	ec                   	in     (%dx),%al
c010145b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010145e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101462:	0f b6 c0             	movzbl %al,%eax
c0101465:	83 e0 01             	and    $0x1,%eax
c0101468:	85 c0                	test   %eax,%eax
c010146a:	75 0a                	jne    c0101476 <kbd_proc_data+0x2e>
        return -1;
c010146c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101471:	e9 59 01 00 00       	jmp    c01015cf <kbd_proc_data+0x187>
c0101476:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010147c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101480:	89 c2                	mov    %eax,%edx
c0101482:	ec                   	in     (%dx),%al
c0101483:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101486:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010148a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010148d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101491:	75 17                	jne    c01014aa <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101493:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101498:	83 c8 40             	or     $0x40,%eax
c010149b:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014a0:	b8 00 00 00 00       	mov    $0x0,%eax
c01014a5:	e9 25 01 00 00       	jmp    c01015cf <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014aa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ae:	84 c0                	test   %al,%al
c01014b0:	79 47                	jns    c01014f9 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014b2:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014b7:	83 e0 40             	and    $0x40,%eax
c01014ba:	85 c0                	test   %eax,%eax
c01014bc:	75 09                	jne    c01014c7 <kbd_proc_data+0x7f>
c01014be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c2:	83 e0 7f             	and    $0x7f,%eax
c01014c5:	eb 04                	jmp    c01014cb <kbd_proc_data+0x83>
c01014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014cb:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ce:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d2:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014d9:	83 c8 40             	or     $0x40,%eax
c01014dc:	0f b6 c0             	movzbl %al,%eax
c01014df:	f7 d0                	not    %eax
c01014e1:	89 c2                	mov    %eax,%edx
c01014e3:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014e8:	21 d0                	and    %edx,%eax
c01014ea:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014ef:	b8 00 00 00 00       	mov    $0x0,%eax
c01014f4:	e9 d6 00 00 00       	jmp    c01015cf <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014f9:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014fe:	83 e0 40             	and    $0x40,%eax
c0101501:	85 c0                	test   %eax,%eax
c0101503:	74 11                	je     c0101516 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101505:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101509:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010150e:	83 e0 bf             	and    $0xffffffbf,%eax
c0101511:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c0101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151a:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101521:	0f b6 d0             	movzbl %al,%edx
c0101524:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101529:	09 d0                	or     %edx,%eax
c010152b:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c010153b:	0f b6 d0             	movzbl %al,%edx
c010153e:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101543:	31 d0                	xor    %edx,%eax
c0101545:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c010154a:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010154f:	83 e0 03             	and    $0x3,%eax
c0101552:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c0101559:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010155d:	01 d0                	add    %edx,%eax
c010155f:	0f b6 00             	movzbl (%eax),%eax
c0101562:	0f b6 c0             	movzbl %al,%eax
c0101565:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101568:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010156d:	83 e0 08             	and    $0x8,%eax
c0101570:	85 c0                	test   %eax,%eax
c0101572:	74 22                	je     c0101596 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101574:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101578:	7e 0c                	jle    c0101586 <kbd_proc_data+0x13e>
c010157a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010157e:	7f 06                	jg     c0101586 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101580:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101584:	eb 10                	jmp    c0101596 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101586:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010158a:	7e 0a                	jle    c0101596 <kbd_proc_data+0x14e>
c010158c:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101590:	7f 04                	jg     c0101596 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101592:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101596:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010159b:	f7 d0                	not    %eax
c010159d:	83 e0 06             	and    $0x6,%eax
c01015a0:	85 c0                	test   %eax,%eax
c01015a2:	75 28                	jne    c01015cc <kbd_proc_data+0x184>
c01015a4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015ab:	75 1f                	jne    c01015cc <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015ad:	c7 04 24 3d a1 10 c0 	movl   $0xc010a13d,(%esp)
c01015b4:	e8 9a ed ff ff       	call   c0100353 <cprintf>
c01015b9:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015bf:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015c3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015c7:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015cb:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015cf:	c9                   	leave  
c01015d0:	c3                   	ret    

c01015d1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015d1:	55                   	push   %ebp
c01015d2:	89 e5                	mov    %esp,%ebp
c01015d4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015d7:	c7 04 24 48 14 10 c0 	movl   $0xc0101448,(%esp)
c01015de:	e8 a6 fd ff ff       	call   c0101389 <cons_intr>
}
c01015e3:	c9                   	leave  
c01015e4:	c3                   	ret    

c01015e5 <kbd_init>:

static void
kbd_init(void) {
c01015e5:	55                   	push   %ebp
c01015e6:	89 e5                	mov    %esp,%ebp
c01015e8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015eb:	e8 e1 ff ff ff       	call   c01015d1 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015f7:	e8 b2 09 00 00       	call   c0101fae <pic_enable>
}
c01015fc:	c9                   	leave  
c01015fd:	c3                   	ret    

c01015fe <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015fe:	55                   	push   %ebp
c01015ff:	89 e5                	mov    %esp,%ebp
c0101601:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101604:	e8 93 f8 ff ff       	call   c0100e9c <cga_init>
    serial_init();
c0101609:	e8 74 f9 ff ff       	call   c0100f82 <serial_init>
    kbd_init();
c010160e:	e8 d2 ff ff ff       	call   c01015e5 <kbd_init>
    if (!serial_exists) {
c0101613:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101618:	85 c0                	test   %eax,%eax
c010161a:	75 0c                	jne    c0101628 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010161c:	c7 04 24 49 a1 10 c0 	movl   $0xc010a149,(%esp)
c0101623:	e8 2b ed ff ff       	call   c0100353 <cprintf>
    }
}
c0101628:	c9                   	leave  
c0101629:	c3                   	ret    

c010162a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010162a:	55                   	push   %ebp
c010162b:	89 e5                	mov    %esp,%ebp
c010162d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101630:	e8 e2 f7 ff ff       	call   c0100e17 <__intr_save>
c0101635:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101638:	8b 45 08             	mov    0x8(%ebp),%eax
c010163b:	89 04 24             	mov    %eax,(%esp)
c010163e:	e8 9b fa ff ff       	call   c01010de <lpt_putc>
        cga_putc(c);
c0101643:	8b 45 08             	mov    0x8(%ebp),%eax
c0101646:	89 04 24             	mov    %eax,(%esp)
c0101649:	e8 cf fa ff ff       	call   c010111d <cga_putc>
        serial_putc(c);
c010164e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101651:	89 04 24             	mov    %eax,(%esp)
c0101654:	e8 f1 fc ff ff       	call   c010134a <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101659:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010165c:	89 04 24             	mov    %eax,(%esp)
c010165f:	e8 dd f7 ff ff       	call   c0100e41 <__intr_restore>
}
c0101664:	c9                   	leave  
c0101665:	c3                   	ret    

c0101666 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101666:	55                   	push   %ebp
c0101667:	89 e5                	mov    %esp,%ebp
c0101669:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010166c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101673:	e8 9f f7 ff ff       	call   c0100e17 <__intr_save>
c0101678:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010167b:	e8 ab fd ff ff       	call   c010142b <serial_intr>
        kbd_intr();
c0101680:	e8 4c ff ff ff       	call   c01015d1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101685:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c010168b:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101690:	39 c2                	cmp    %eax,%edx
c0101692:	74 31                	je     c01016c5 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101694:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101699:	8d 50 01             	lea    0x1(%eax),%edx
c010169c:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c01016a2:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c01016a9:	0f b6 c0             	movzbl %al,%eax
c01016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016af:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c01016b4:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b9:	75 0a                	jne    c01016c5 <cons_getc+0x5f>
                cons.rpos = 0;
c01016bb:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016c2:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016c8:	89 04 24             	mov    %eax,(%esp)
c01016cb:	e8 71 f7 ff ff       	call   c0100e41 <__intr_restore>
    return c;
c01016d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016d3:	c9                   	leave  
c01016d4:	c3                   	ret    

c01016d5 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016d5:	55                   	push   %ebp
c01016d6:	89 e5                	mov    %esp,%ebp
c01016d8:	83 ec 14             	sub    $0x14,%esp
c01016db:	8b 45 08             	mov    0x8(%ebp),%eax
c01016de:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016e2:	90                   	nop
c01016e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e7:	83 c0 07             	add    $0x7,%eax
c01016ea:	0f b7 c0             	movzwl %ax,%eax
c01016ed:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016f1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016f5:	89 c2                	mov    %eax,%edx
c01016f7:	ec                   	in     (%dx),%al
c01016f8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016fb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016ff:	0f b6 c0             	movzbl %al,%eax
c0101702:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0101705:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101708:	25 80 00 00 00       	and    $0x80,%eax
c010170d:	85 c0                	test   %eax,%eax
c010170f:	75 d2                	jne    c01016e3 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101715:	74 11                	je     c0101728 <ide_wait_ready+0x53>
c0101717:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010171a:	83 e0 21             	and    $0x21,%eax
c010171d:	85 c0                	test   %eax,%eax
c010171f:	74 07                	je     c0101728 <ide_wait_ready+0x53>
        return -1;
c0101721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101726:	eb 05                	jmp    c010172d <ide_wait_ready+0x58>
    }
    return 0;
c0101728:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010172d:	c9                   	leave  
c010172e:	c3                   	ret    

c010172f <ide_init>:

void
ide_init(void) {
c010172f:	55                   	push   %ebp
c0101730:	89 e5                	mov    %esp,%ebp
c0101732:	57                   	push   %edi
c0101733:	53                   	push   %ebx
c0101734:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010173a:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101740:	e9 d6 02 00 00       	jmp    c0101a1b <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101745:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101749:	c1 e0 03             	shl    $0x3,%eax
c010174c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101753:	29 c2                	sub    %eax,%edx
c0101755:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010175b:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010175e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101762:	66 d1 e8             	shr    %ax
c0101765:	0f b7 c0             	movzwl %ax,%eax
c0101768:	0f b7 04 85 68 a1 10 	movzwl -0x3fef5e98(,%eax,4),%eax
c010176f:	c0 
c0101770:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101774:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101778:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010177f:	00 
c0101780:	89 04 24             	mov    %eax,(%esp)
c0101783:	e8 4d ff ff ff       	call   c01016d5 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101788:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010178c:	83 e0 01             	and    $0x1,%eax
c010178f:	c1 e0 04             	shl    $0x4,%eax
c0101792:	83 c8 e0             	or     $0xffffffe0,%eax
c0101795:	0f b6 c0             	movzbl %al,%eax
c0101798:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010179c:	83 c2 06             	add    $0x6,%edx
c010179f:	0f b7 d2             	movzwl %dx,%edx
c01017a2:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c01017a6:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017ad:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017b1:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017b2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017bd:	00 
c01017be:	89 04 24             	mov    %eax,(%esp)
c01017c1:	e8 0f ff ff ff       	call   c01016d5 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017c6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ca:	83 c0 07             	add    $0x7,%eax
c01017cd:	0f b7 c0             	movzwl %ax,%eax
c01017d0:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017d4:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017d8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017dc:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017e0:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017e1:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017ec:	00 
c01017ed:	89 04 24             	mov    %eax,(%esp)
c01017f0:	e8 e0 fe ff ff       	call   c01016d5 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017f5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017f9:	83 c0 07             	add    $0x7,%eax
c01017fc:	0f b7 c0             	movzwl %ax,%eax
c01017ff:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101803:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0101807:	89 c2                	mov    %eax,%edx
c0101809:	ec                   	in     (%dx),%al
c010180a:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c010180d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101811:	84 c0                	test   %al,%al
c0101813:	0f 84 f7 01 00 00    	je     c0101a10 <ide_init+0x2e1>
c0101819:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010181d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101824:	00 
c0101825:	89 04 24             	mov    %eax,(%esp)
c0101828:	e8 a8 fe ff ff       	call   c01016d5 <ide_wait_ready>
c010182d:	85 c0                	test   %eax,%eax
c010182f:	0f 85 db 01 00 00    	jne    c0101a10 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101835:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101839:	c1 e0 03             	shl    $0x3,%eax
c010183c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101843:	29 c2                	sub    %eax,%edx
c0101845:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010184b:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010184e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101852:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101855:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010185b:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010185e:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101865:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101868:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010186b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010186e:	89 cb                	mov    %ecx,%ebx
c0101870:	89 df                	mov    %ebx,%edi
c0101872:	89 c1                	mov    %eax,%ecx
c0101874:	fc                   	cld    
c0101875:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101877:	89 c8                	mov    %ecx,%eax
c0101879:	89 fb                	mov    %edi,%ebx
c010187b:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010187e:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101881:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010188a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188d:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101893:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101896:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101899:	25 00 00 00 04       	and    $0x4000000,%eax
c010189e:	85 c0                	test   %eax,%eax
c01018a0:	74 0e                	je     c01018b0 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c01018a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018a5:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c01018ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01018ae:	eb 09                	jmp    c01018b9 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c01018b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018b3:	8b 40 78             	mov    0x78(%eax),%eax
c01018b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c01018b9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018bd:	c1 e0 03             	shl    $0x3,%eax
c01018c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c7:	29 c2                	sub    %eax,%edx
c01018c9:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018d2:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018d5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018d9:	c1 e0 03             	shl    $0x3,%eax
c01018dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018e3:	29 c2                	sub    %eax,%edx
c01018e5:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018ee:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018f4:	83 c0 62             	add    $0x62,%eax
c01018f7:	0f b7 00             	movzwl (%eax),%eax
c01018fa:	0f b7 c0             	movzwl %ax,%eax
c01018fd:	25 00 02 00 00       	and    $0x200,%eax
c0101902:	85 c0                	test   %eax,%eax
c0101904:	75 24                	jne    c010192a <ide_init+0x1fb>
c0101906:	c7 44 24 0c 70 a1 10 	movl   $0xc010a170,0xc(%esp)
c010190d:	c0 
c010190e:	c7 44 24 08 b3 a1 10 	movl   $0xc010a1b3,0x8(%esp)
c0101915:	c0 
c0101916:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c010191d:	00 
c010191e:	c7 04 24 c8 a1 10 c0 	movl   $0xc010a1c8,(%esp)
c0101925:	e8 ce f3 ff ff       	call   c0100cf8 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010192a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010192e:	c1 e0 03             	shl    $0x3,%eax
c0101931:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101938:	29 c2                	sub    %eax,%edx
c010193a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101940:	83 c0 0c             	add    $0xc,%eax
c0101943:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101949:	83 c0 36             	add    $0x36,%eax
c010194c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c010194f:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101956:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010195d:	eb 34                	jmp    c0101993 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c010195f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101962:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101965:	01 c2                	add    %eax,%edx
c0101967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196a:	8d 48 01             	lea    0x1(%eax),%ecx
c010196d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101970:	01 c8                	add    %ecx,%eax
c0101972:	0f b6 00             	movzbl (%eax),%eax
c0101975:	88 02                	mov    %al,(%edx)
c0101977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197a:	8d 50 01             	lea    0x1(%eax),%edx
c010197d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101980:	01 c2                	add    %eax,%edx
c0101982:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101985:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101988:	01 c8                	add    %ecx,%eax
c010198a:	0f b6 00             	movzbl (%eax),%eax
c010198d:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010198f:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101993:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101996:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101999:	72 c4                	jb     c010195f <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c010199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019a1:	01 d0                	add    %edx,%eax
c01019a3:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c01019a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019a9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01019ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01019af:	85 c0                	test   %eax,%eax
c01019b1:	74 0f                	je     c01019c2 <ide_init+0x293>
c01019b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019b9:	01 d0                	add    %edx,%eax
c01019bb:	0f b6 00             	movzbl (%eax),%eax
c01019be:	3c 20                	cmp    $0x20,%al
c01019c0:	74 d9                	je     c010199b <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019c2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c6:	c1 e0 03             	shl    $0x3,%eax
c01019c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019d0:	29 c2                	sub    %eax,%edx
c01019d2:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d8:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019db:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019df:	c1 e0 03             	shl    $0x3,%eax
c01019e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019e9:	29 c2                	sub    %eax,%edx
c01019eb:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019f1:	8b 50 08             	mov    0x8(%eax),%edx
c01019f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019fc:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a04:	c7 04 24 da a1 10 c0 	movl   $0xc010a1da,(%esp)
c0101a0b:	e8 43 e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101a10:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a14:	83 c0 01             	add    $0x1,%eax
c0101a17:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a1b:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a20:	0f 86 1f fd ff ff    	jbe    c0101745 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a26:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a2d:	e8 7c 05 00 00       	call   c0101fae <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a32:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a39:	e8 70 05 00 00       	call   c0101fae <pic_enable>
}
c0101a3e:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a44:	5b                   	pop    %ebx
c0101a45:	5f                   	pop    %edi
c0101a46:	5d                   	pop    %ebp
c0101a47:	c3                   	ret    

c0101a48 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a48:	55                   	push   %ebp
c0101a49:	89 e5                	mov    %esp,%ebp
c0101a4b:	83 ec 04             	sub    $0x4,%esp
c0101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a51:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a55:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a5a:	77 24                	ja     c0101a80 <ide_device_valid+0x38>
c0101a5c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a60:	c1 e0 03             	shl    $0x3,%eax
c0101a63:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a6a:	29 c2                	sub    %eax,%edx
c0101a6c:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a72:	0f b6 00             	movzbl (%eax),%eax
c0101a75:	84 c0                	test   %al,%al
c0101a77:	74 07                	je     c0101a80 <ide_device_valid+0x38>
c0101a79:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a7e:	eb 05                	jmp    c0101a85 <ide_device_valid+0x3d>
c0101a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a85:	c9                   	leave  
c0101a86:	c3                   	ret    

c0101a87 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a87:	55                   	push   %ebp
c0101a88:	89 e5                	mov    %esp,%ebp
c0101a8a:	83 ec 08             	sub    $0x8,%esp
c0101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a90:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a94:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a98:	89 04 24             	mov    %eax,(%esp)
c0101a9b:	e8 a8 ff ff ff       	call   c0101a48 <ide_device_valid>
c0101aa0:	85 c0                	test   %eax,%eax
c0101aa2:	74 1b                	je     c0101abf <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101aa4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aa8:	c1 e0 03             	shl    $0x3,%eax
c0101aab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ab2:	29 c2                	sub    %eax,%edx
c0101ab4:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101aba:	8b 40 08             	mov    0x8(%eax),%eax
c0101abd:	eb 05                	jmp    c0101ac4 <ide_device_size+0x3d>
    }
    return 0;
c0101abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ac4:	c9                   	leave  
c0101ac5:	c3                   	ret    

c0101ac6 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ac6:	55                   	push   %ebp
c0101ac7:	89 e5                	mov    %esp,%ebp
c0101ac9:	57                   	push   %edi
c0101aca:	53                   	push   %ebx
c0101acb:	83 ec 50             	sub    $0x50,%esp
c0101ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad1:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ad5:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101adc:	77 24                	ja     c0101b02 <ide_read_secs+0x3c>
c0101ade:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ae3:	77 1d                	ja     c0101b02 <ide_read_secs+0x3c>
c0101ae5:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ae9:	c1 e0 03             	shl    $0x3,%eax
c0101aec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101af3:	29 c2                	sub    %eax,%edx
c0101af5:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101afb:	0f b6 00             	movzbl (%eax),%eax
c0101afe:	84 c0                	test   %al,%al
c0101b00:	75 24                	jne    c0101b26 <ide_read_secs+0x60>
c0101b02:	c7 44 24 0c f8 a1 10 	movl   $0xc010a1f8,0xc(%esp)
c0101b09:	c0 
c0101b0a:	c7 44 24 08 b3 a1 10 	movl   $0xc010a1b3,0x8(%esp)
c0101b11:	c0 
c0101b12:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101b19:	00 
c0101b1a:	c7 04 24 c8 a1 10 c0 	movl   $0xc010a1c8,(%esp)
c0101b21:	e8 d2 f1 ff ff       	call   c0100cf8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b26:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b2d:	77 0f                	ja     c0101b3e <ide_read_secs+0x78>
c0101b2f:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b32:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b35:	01 d0                	add    %edx,%eax
c0101b37:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b3c:	76 24                	jbe    c0101b62 <ide_read_secs+0x9c>
c0101b3e:	c7 44 24 0c 20 a2 10 	movl   $0xc010a220,0xc(%esp)
c0101b45:	c0 
c0101b46:	c7 44 24 08 b3 a1 10 	movl   $0xc010a1b3,0x8(%esp)
c0101b4d:	c0 
c0101b4e:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b55:	00 
c0101b56:	c7 04 24 c8 a1 10 c0 	movl   $0xc010a1c8,(%esp)
c0101b5d:	e8 96 f1 ff ff       	call   c0100cf8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b66:	66 d1 e8             	shr    %ax
c0101b69:	0f b7 c0             	movzwl %ax,%eax
c0101b6c:	0f b7 04 85 68 a1 10 	movzwl -0x3fef5e98(,%eax,4),%eax
c0101b73:	c0 
c0101b74:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b78:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b7c:	66 d1 e8             	shr    %ax
c0101b7f:	0f b7 c0             	movzwl %ax,%eax
c0101b82:	0f b7 04 85 6a a1 10 	movzwl -0x3fef5e96(,%eax,4),%eax
c0101b89:	c0 
c0101b8a:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b8e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b99:	00 
c0101b9a:	89 04 24             	mov    %eax,(%esp)
c0101b9d:	e8 33 fb ff ff       	call   c01016d5 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ba2:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ba6:	83 c0 02             	add    $0x2,%eax
c0101ba9:	0f b7 c0             	movzwl %ax,%eax
c0101bac:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101bb0:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bb4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101bb8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101bbc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101bbd:	8b 45 14             	mov    0x14(%ebp),%eax
c0101bc0:	0f b6 c0             	movzbl %al,%eax
c0101bc3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc7:	83 c2 02             	add    $0x2,%edx
c0101bca:	0f b7 d2             	movzwl %dx,%edx
c0101bcd:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bd1:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bd4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bd8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bdc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be0:	0f b6 c0             	movzbl %al,%eax
c0101be3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be7:	83 c2 03             	add    $0x3,%edx
c0101bea:	0f b7 d2             	movzwl %dx,%edx
c0101bed:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bf1:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bf4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bf8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c00:	c1 e8 08             	shr    $0x8,%eax
c0101c03:	0f b6 c0             	movzbl %al,%eax
c0101c06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c0a:	83 c2 04             	add    $0x4,%edx
c0101c0d:	0f b7 d2             	movzwl %dx,%edx
c0101c10:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101c14:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101c17:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c1b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c23:	c1 e8 10             	shr    $0x10,%eax
c0101c26:	0f b6 c0             	movzbl %al,%eax
c0101c29:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c2d:	83 c2 05             	add    $0x5,%edx
c0101c30:	0f b7 d2             	movzwl %dx,%edx
c0101c33:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c37:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c3a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c3e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c42:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c43:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c47:	83 e0 01             	and    $0x1,%eax
c0101c4a:	c1 e0 04             	shl    $0x4,%eax
c0101c4d:	89 c2                	mov    %eax,%edx
c0101c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c52:	c1 e8 18             	shr    $0x18,%eax
c0101c55:	83 e0 0f             	and    $0xf,%eax
c0101c58:	09 d0                	or     %edx,%eax
c0101c5a:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c5d:	0f b6 c0             	movzbl %al,%eax
c0101c60:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c64:	83 c2 06             	add    $0x6,%edx
c0101c67:	0f b7 d2             	movzwl %dx,%edx
c0101c6a:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c6e:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c71:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c75:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c79:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c7a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c7e:	83 c0 07             	add    $0x7,%eax
c0101c81:	0f b7 c0             	movzwl %ax,%eax
c0101c84:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c88:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c8c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c90:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c94:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c9c:	eb 5a                	jmp    c0101cf8 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c9e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ca9:	00 
c0101caa:	89 04 24             	mov    %eax,(%esp)
c0101cad:	e8 23 fa ff ff       	call   c01016d5 <ide_wait_ready>
c0101cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101cb9:	74 02                	je     c0101cbd <ide_read_secs+0x1f7>
            goto out;
c0101cbb:	eb 41                	jmp    c0101cfe <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101cbd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101cc4:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cc7:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cca:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cd1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cd4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cda:	89 cb                	mov    %ecx,%ebx
c0101cdc:	89 df                	mov    %ebx,%edi
c0101cde:	89 c1                	mov    %eax,%ecx
c0101ce0:	fc                   	cld    
c0101ce1:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101ce3:	89 c8                	mov    %ecx,%eax
c0101ce5:	89 fb                	mov    %edi,%ebx
c0101ce7:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cea:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101ced:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cf1:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cf8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cfc:	75 a0                	jne    c0101c9e <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101d01:	83 c4 50             	add    $0x50,%esp
c0101d04:	5b                   	pop    %ebx
c0101d05:	5f                   	pop    %edi
c0101d06:	5d                   	pop    %ebp
c0101d07:	c3                   	ret    

c0101d08 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d08:	55                   	push   %ebp
c0101d09:	89 e5                	mov    %esp,%ebp
c0101d0b:	56                   	push   %esi
c0101d0c:	53                   	push   %ebx
c0101d0d:	83 ec 50             	sub    $0x50,%esp
c0101d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d13:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101d17:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d1e:	77 24                	ja     c0101d44 <ide_write_secs+0x3c>
c0101d20:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d25:	77 1d                	ja     c0101d44 <ide_write_secs+0x3c>
c0101d27:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d2b:	c1 e0 03             	shl    $0x3,%eax
c0101d2e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d35:	29 c2                	sub    %eax,%edx
c0101d37:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d3d:	0f b6 00             	movzbl (%eax),%eax
c0101d40:	84 c0                	test   %al,%al
c0101d42:	75 24                	jne    c0101d68 <ide_write_secs+0x60>
c0101d44:	c7 44 24 0c f8 a1 10 	movl   $0xc010a1f8,0xc(%esp)
c0101d4b:	c0 
c0101d4c:	c7 44 24 08 b3 a1 10 	movl   $0xc010a1b3,0x8(%esp)
c0101d53:	c0 
c0101d54:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d5b:	00 
c0101d5c:	c7 04 24 c8 a1 10 c0 	movl   $0xc010a1c8,(%esp)
c0101d63:	e8 90 ef ff ff       	call   c0100cf8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d68:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d6f:	77 0f                	ja     c0101d80 <ide_write_secs+0x78>
c0101d71:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d74:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d77:	01 d0                	add    %edx,%eax
c0101d79:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d7e:	76 24                	jbe    c0101da4 <ide_write_secs+0x9c>
c0101d80:	c7 44 24 0c 20 a2 10 	movl   $0xc010a220,0xc(%esp)
c0101d87:	c0 
c0101d88:	c7 44 24 08 b3 a1 10 	movl   $0xc010a1b3,0x8(%esp)
c0101d8f:	c0 
c0101d90:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d97:	00 
c0101d98:	c7 04 24 c8 a1 10 c0 	movl   $0xc010a1c8,(%esp)
c0101d9f:	e8 54 ef ff ff       	call   c0100cf8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101da4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da8:	66 d1 e8             	shr    %ax
c0101dab:	0f b7 c0             	movzwl %ax,%eax
c0101dae:	0f b7 04 85 68 a1 10 	movzwl -0x3fef5e98(,%eax,4),%eax
c0101db5:	c0 
c0101db6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101dba:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101dbe:	66 d1 e8             	shr    %ax
c0101dc1:	0f b7 c0             	movzwl %ax,%eax
c0101dc4:	0f b7 04 85 6a a1 10 	movzwl -0x3fef5e96(,%eax,4),%eax
c0101dcb:	c0 
c0101dcc:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dd0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101dd4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101ddb:	00 
c0101ddc:	89 04 24             	mov    %eax,(%esp)
c0101ddf:	e8 f1 f8 ff ff       	call   c01016d5 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101de4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101de8:	83 c0 02             	add    $0x2,%eax
c0101deb:	0f b7 c0             	movzwl %ax,%eax
c0101dee:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101df2:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101df6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dfa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101dfe:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101dff:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e02:	0f b6 c0             	movzbl %al,%eax
c0101e05:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e09:	83 c2 02             	add    $0x2,%edx
c0101e0c:	0f b7 d2             	movzwl %dx,%edx
c0101e0f:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101e13:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101e16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e1e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e22:	0f b6 c0             	movzbl %al,%eax
c0101e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e29:	83 c2 03             	add    $0x3,%edx
c0101e2c:	0f b7 d2             	movzwl %dx,%edx
c0101e2f:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e33:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e36:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e3a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e42:	c1 e8 08             	shr    $0x8,%eax
c0101e45:	0f b6 c0             	movzbl %al,%eax
c0101e48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e4c:	83 c2 04             	add    $0x4,%edx
c0101e4f:	0f b7 d2             	movzwl %dx,%edx
c0101e52:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e56:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e59:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e5d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e65:	c1 e8 10             	shr    $0x10,%eax
c0101e68:	0f b6 c0             	movzbl %al,%eax
c0101e6b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e6f:	83 c2 05             	add    $0x5,%edx
c0101e72:	0f b7 d2             	movzwl %dx,%edx
c0101e75:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e79:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e7c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e80:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e84:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e85:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e89:	83 e0 01             	and    $0x1,%eax
c0101e8c:	c1 e0 04             	shl    $0x4,%eax
c0101e8f:	89 c2                	mov    %eax,%edx
c0101e91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e94:	c1 e8 18             	shr    $0x18,%eax
c0101e97:	83 e0 0f             	and    $0xf,%eax
c0101e9a:	09 d0                	or     %edx,%eax
c0101e9c:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e9f:	0f b6 c0             	movzbl %al,%eax
c0101ea2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ea6:	83 c2 06             	add    $0x6,%edx
c0101ea9:	0f b7 d2             	movzwl %dx,%edx
c0101eac:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101eb0:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101eb3:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101eb7:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101ebb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ebc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec0:	83 c0 07             	add    $0x7,%eax
c0101ec3:	0f b7 c0             	movzwl %ax,%eax
c0101ec6:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eca:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101ece:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101ed2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ed6:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ed7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ede:	eb 5a                	jmp    c0101f3a <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ee0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101eeb:	00 
c0101eec:	89 04 24             	mov    %eax,(%esp)
c0101eef:	e8 e1 f7 ff ff       	call   c01016d5 <ide_wait_ready>
c0101ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101efb:	74 02                	je     c0101eff <ide_write_secs+0x1f7>
            goto out;
c0101efd:	eb 41                	jmp    c0101f40 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101eff:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f03:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f06:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f09:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f0c:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101f13:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101f16:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101f19:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f1c:	89 cb                	mov    %ecx,%ebx
c0101f1e:	89 de                	mov    %ebx,%esi
c0101f20:	89 c1                	mov    %eax,%ecx
c0101f22:	fc                   	cld    
c0101f23:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f25:	89 c8                	mov    %ecx,%eax
c0101f27:	89 f3                	mov    %esi,%ebx
c0101f29:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f2c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f2f:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f33:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f3a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f3e:	75 a0                	jne    c0101ee0 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f43:	83 c4 50             	add    $0x50,%esp
c0101f46:	5b                   	pop    %ebx
c0101f47:	5e                   	pop    %esi
c0101f48:	5d                   	pop    %ebp
c0101f49:	c3                   	ret    

c0101f4a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f4a:	55                   	push   %ebp
c0101f4b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f4d:	fb                   	sti    
    sti();
}
c0101f4e:	5d                   	pop    %ebp
c0101f4f:	c3                   	ret    

c0101f50 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f50:	55                   	push   %ebp
c0101f51:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f53:	fa                   	cli    
    cli();
}
c0101f54:	5d                   	pop    %ebp
c0101f55:	c3                   	ret    

c0101f56 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f56:	55                   	push   %ebp
c0101f57:	89 e5                	mov    %esp,%ebp
c0101f59:	83 ec 14             	sub    $0x14,%esp
c0101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f63:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f67:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f6d:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f72:	85 c0                	test   %eax,%eax
c0101f74:	74 36                	je     c0101fac <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f76:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f7a:	0f b6 c0             	movzbl %al,%eax
c0101f7d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f83:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f86:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f8a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f8e:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f8f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f93:	66 c1 e8 08          	shr    $0x8,%ax
c0101f97:	0f b6 c0             	movzbl %al,%eax
c0101f9a:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fa0:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101fa3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fa7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fab:	ee                   	out    %al,(%dx)
    }
}
c0101fac:	c9                   	leave  
c0101fad:	c3                   	ret    

c0101fae <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101fae:	55                   	push   %ebp
c0101faf:	89 e5                	mov    %esp,%ebp
c0101fb1:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb7:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fbc:	89 c1                	mov    %eax,%ecx
c0101fbe:	d3 e2                	shl    %cl,%edx
c0101fc0:	89 d0                	mov    %edx,%eax
c0101fc2:	f7 d0                	not    %eax
c0101fc4:	89 c2                	mov    %eax,%edx
c0101fc6:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fcd:	21 d0                	and    %edx,%eax
c0101fcf:	0f b7 c0             	movzwl %ax,%eax
c0101fd2:	89 04 24             	mov    %eax,(%esp)
c0101fd5:	e8 7c ff ff ff       	call   c0101f56 <pic_setmask>
}
c0101fda:	c9                   	leave  
c0101fdb:	c3                   	ret    

c0101fdc <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fdc:	55                   	push   %ebp
c0101fdd:	89 e5                	mov    %esp,%ebp
c0101fdf:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fe2:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fe9:	00 00 00 
c0101fec:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101ff2:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101ff6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101ffa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101ffe:	ee                   	out    %al,(%dx)
c0101fff:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0102005:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0102009:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010200d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102011:	ee                   	out    %al,(%dx)
c0102012:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102018:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010201c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102020:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102024:	ee                   	out    %al,(%dx)
c0102025:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010202b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010202f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102033:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102037:	ee                   	out    %al,(%dx)
c0102038:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010203e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102042:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102046:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010204a:	ee                   	out    %al,(%dx)
c010204b:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102051:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102055:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102059:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010205d:	ee                   	out    %al,(%dx)
c010205e:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102064:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102068:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010206c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102070:	ee                   	out    %al,(%dx)
c0102071:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102077:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010207b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010207f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102083:	ee                   	out    %al,(%dx)
c0102084:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010208a:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010208e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102092:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102096:	ee                   	out    %al,(%dx)
c0102097:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010209d:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01020a1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01020a5:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01020a9:	ee                   	out    %al,(%dx)
c01020aa:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01020b0:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01020b4:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01020b8:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020bc:	ee                   	out    %al,(%dx)
c01020bd:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020c3:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020c7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020cb:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020cf:	ee                   	out    %al,(%dx)
c01020d0:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020d6:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020da:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020de:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020e2:	ee                   	out    %al,(%dx)
c01020e3:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020e9:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020ed:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020f1:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020f5:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020f6:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020fd:	66 83 f8 ff          	cmp    $0xffff,%ax
c0102101:	74 12                	je     c0102115 <pic_init+0x139>
        pic_setmask(irq_mask);
c0102103:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c010210a:	0f b7 c0             	movzwl %ax,%eax
c010210d:	89 04 24             	mov    %eax,(%esp)
c0102110:	e8 41 fe ff ff       	call   c0101f56 <pic_setmask>
    }
}
c0102115:	c9                   	leave  
c0102116:	c3                   	ret    

c0102117 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102117:	55                   	push   %ebp
c0102118:	89 e5                	mov    %esp,%ebp
c010211a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010211d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102124:	00 
c0102125:	c7 04 24 60 a2 10 c0 	movl   $0xc010a260,(%esp)
c010212c:	e8 22 e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102131:	c7 04 24 6a a2 10 c0 	movl   $0xc010a26a,(%esp)
c0102138:	e8 16 e2 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c010213d:	c7 44 24 08 78 a2 10 	movl   $0xc010a278,0x8(%esp)
c0102144:	c0 
c0102145:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c010214c:	00 
c010214d:	c7 04 24 8e a2 10 c0 	movl   $0xc010a28e,(%esp)
c0102154:	e8 9f eb ff ff       	call   c0100cf8 <__panic>

c0102159 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102159:	55                   	push   %ebp
c010215a:	89 e5                	mov    %esp,%ebp
c010215c:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
c010215f:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i=0;
c0102166:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//setup each item of IDT;
	for(i=0; i<len; i++)
c010216d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102174:	e9 c3 00 00 00       	jmp    c010223c <idt_init+0xe3>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102179:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217c:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102183:	89 c2                	mov    %eax,%edx
c0102185:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102188:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c010218f:	c0 
c0102190:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102193:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c010219a:	c0 08 00 
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c01021a7:	c0 
c01021a8:	83 e2 e0             	and    $0xffffffe0,%edx
c01021ab:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c01021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b5:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c01021bc:	c0 
c01021bd:	83 e2 1f             	and    $0x1f,%edx
c01021c0:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c01021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ca:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021d1:	c0 
c01021d2:	83 e2 f0             	and    $0xfffffff0,%edx
c01021d5:	83 ca 0e             	or     $0xe,%edx
c01021d8:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e2:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021e9:	c0 
c01021ea:	83 e2 ef             	and    $0xffffffef,%edx
c01021ed:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f7:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021fe:	c0 
c01021ff:	83 e2 9f             	and    $0xffffff9f,%edx
c0102202:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102209:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220c:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102213:	c0 
c0102214:	83 ca 80             	or     $0xffffff80,%edx
c0102217:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c010221e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102221:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102228:	c1 e8 10             	shr    $0x10,%eax
c010222b:	89 c2                	mov    %eax,%edx
c010222d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102230:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c0102237:	c0 
idt_init(void) {
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
	int i=0;
	//setup each item of IDT;
	for(i=0; i<len; i++)
c0102238:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010223c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102242:	0f 8c 31 ff ff ff    	jl     c0102179 <idt_init+0x20>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
c0102248:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c010224d:	66 a3 e8 55 12 c0    	mov    %ax,0xc01255e8
c0102253:	66 c7 05 ea 55 12 c0 	movw   $0x8,0xc01255ea
c010225a:	08 00 
c010225c:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c0102263:	83 e0 e0             	and    $0xffffffe0,%eax
c0102266:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c010226b:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c0102272:	83 e0 1f             	and    $0x1f,%eax
c0102275:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c010227a:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102281:	83 e0 f0             	and    $0xfffffff0,%eax
c0102284:	83 c8 0e             	or     $0xe,%eax
c0102287:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010228c:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102293:	83 e0 ef             	and    $0xffffffef,%eax
c0102296:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010229b:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c01022a2:	83 e0 9f             	and    $0xffffff9f,%eax
c01022a5:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c01022aa:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c01022b1:	83 c8 80             	or     $0xffffff80,%eax
c01022b4:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c01022b9:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c01022be:	c1 e8 10             	shr    $0x10,%eax
c01022c1:	66 a3 ee 55 12 c0    	mov    %ax,0xc01255ee
c01022c7:	c7 45 f4 80 45 12 c0 	movl   $0xc0124580,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01022d1:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);//载入IDT;
	return;
c01022d4:	90                   	nop
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c01022d5:	c9                   	leave  
c01022d6:	c3                   	ret    

c01022d7 <trapname>:

static const char *
trapname(int trapno) {
c01022d7:	55                   	push   %ebp
c01022d8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022da:	8b 45 08             	mov    0x8(%ebp),%eax
c01022dd:	83 f8 13             	cmp    $0x13,%eax
c01022e0:	77 0c                	ja     c01022ee <trapname+0x17>
        return excnames[trapno];
c01022e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e5:	8b 04 85 60 a6 10 c0 	mov    -0x3fef59a0(,%eax,4),%eax
c01022ec:	eb 18                	jmp    c0102306 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022ee:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022f2:	7e 0d                	jle    c0102301 <trapname+0x2a>
c01022f4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022f8:	7f 07                	jg     c0102301 <trapname+0x2a>
        return "Hardware Interrupt";
c01022fa:	b8 9f a2 10 c0       	mov    $0xc010a29f,%eax
c01022ff:	eb 05                	jmp    c0102306 <trapname+0x2f>
    }
    return "(unknown trap)";
c0102301:	b8 b2 a2 10 c0       	mov    $0xc010a2b2,%eax
}
c0102306:	5d                   	pop    %ebp
c0102307:	c3                   	ret    

c0102308 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102308:	55                   	push   %ebp
c0102309:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010230b:	8b 45 08             	mov    0x8(%ebp),%eax
c010230e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102312:	66 83 f8 08          	cmp    $0x8,%ax
c0102316:	0f 94 c0             	sete   %al
c0102319:	0f b6 c0             	movzbl %al,%eax
}
c010231c:	5d                   	pop    %ebp
c010231d:	c3                   	ret    

c010231e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c010231e:	55                   	push   %ebp
c010231f:	89 e5                	mov    %esp,%ebp
c0102321:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102324:	8b 45 08             	mov    0x8(%ebp),%eax
c0102327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010232b:	c7 04 24 f3 a2 10 c0 	movl   $0xc010a2f3,(%esp)
c0102332:	e8 1c e0 ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c0102337:	8b 45 08             	mov    0x8(%ebp),%eax
c010233a:	89 04 24             	mov    %eax,(%esp)
c010233d:	e8 a1 01 00 00       	call   c01024e3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102342:	8b 45 08             	mov    0x8(%ebp),%eax
c0102345:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102349:	0f b7 c0             	movzwl %ax,%eax
c010234c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102350:	c7 04 24 04 a3 10 c0 	movl   $0xc010a304,(%esp)
c0102357:	e8 f7 df ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010235c:	8b 45 08             	mov    0x8(%ebp),%eax
c010235f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102363:	0f b7 c0             	movzwl %ax,%eax
c0102366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010236a:	c7 04 24 17 a3 10 c0 	movl   $0xc010a317,(%esp)
c0102371:	e8 dd df ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102376:	8b 45 08             	mov    0x8(%ebp),%eax
c0102379:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010237d:	0f b7 c0             	movzwl %ax,%eax
c0102380:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102384:	c7 04 24 2a a3 10 c0 	movl   $0xc010a32a,(%esp)
c010238b:	e8 c3 df ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102390:	8b 45 08             	mov    0x8(%ebp),%eax
c0102393:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102397:	0f b7 c0             	movzwl %ax,%eax
c010239a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010239e:	c7 04 24 3d a3 10 c0 	movl   $0xc010a33d,(%esp)
c01023a5:	e8 a9 df ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01023aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ad:	8b 40 30             	mov    0x30(%eax),%eax
c01023b0:	89 04 24             	mov    %eax,(%esp)
c01023b3:	e8 1f ff ff ff       	call   c01022d7 <trapname>
c01023b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01023bb:	8b 52 30             	mov    0x30(%edx),%edx
c01023be:	89 44 24 08          	mov    %eax,0x8(%esp)
c01023c2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01023c6:	c7 04 24 50 a3 10 c0 	movl   $0xc010a350,(%esp)
c01023cd:	e8 81 df ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01023d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d5:	8b 40 34             	mov    0x34(%eax),%eax
c01023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023dc:	c7 04 24 62 a3 10 c0 	movl   $0xc010a362,(%esp)
c01023e3:	e8 6b df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023eb:	8b 40 38             	mov    0x38(%eax),%eax
c01023ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f2:	c7 04 24 71 a3 10 c0 	movl   $0xc010a371,(%esp)
c01023f9:	e8 55 df ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102401:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102405:	0f b7 c0             	movzwl %ax,%eax
c0102408:	89 44 24 04          	mov    %eax,0x4(%esp)
c010240c:	c7 04 24 80 a3 10 c0 	movl   $0xc010a380,(%esp)
c0102413:	e8 3b df ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102418:	8b 45 08             	mov    0x8(%ebp),%eax
c010241b:	8b 40 40             	mov    0x40(%eax),%eax
c010241e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102422:	c7 04 24 93 a3 10 c0 	movl   $0xc010a393,(%esp)
c0102429:	e8 25 df ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010242e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102435:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010243c:	eb 3e                	jmp    c010247c <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010243e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102441:	8b 50 40             	mov    0x40(%eax),%edx
c0102444:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102447:	21 d0                	and    %edx,%eax
c0102449:	85 c0                	test   %eax,%eax
c010244b:	74 28                	je     c0102475 <print_trapframe+0x157>
c010244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102450:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102457:	85 c0                	test   %eax,%eax
c0102459:	74 1a                	je     c0102475 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c010245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010245e:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102465:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102469:	c7 04 24 a2 a3 10 c0 	movl   $0xc010a3a2,(%esp)
c0102470:	e8 de de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102475:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102479:	d1 65 f0             	shll   -0x10(%ebp)
c010247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010247f:	83 f8 17             	cmp    $0x17,%eax
c0102482:	76 ba                	jbe    c010243e <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102484:	8b 45 08             	mov    0x8(%ebp),%eax
c0102487:	8b 40 40             	mov    0x40(%eax),%eax
c010248a:	25 00 30 00 00       	and    $0x3000,%eax
c010248f:	c1 e8 0c             	shr    $0xc,%eax
c0102492:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102496:	c7 04 24 a6 a3 10 c0 	movl   $0xc010a3a6,(%esp)
c010249d:	e8 b1 de ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c01024a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a5:	89 04 24             	mov    %eax,(%esp)
c01024a8:	e8 5b fe ff ff       	call   c0102308 <trap_in_kernel>
c01024ad:	85 c0                	test   %eax,%eax
c01024af:	75 30                	jne    c01024e1 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01024b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b4:	8b 40 44             	mov    0x44(%eax),%eax
c01024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024bb:	c7 04 24 af a3 10 c0 	movl   $0xc010a3af,(%esp)
c01024c2:	e8 8c de ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01024c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ca:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01024ce:	0f b7 c0             	movzwl %ax,%eax
c01024d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d5:	c7 04 24 be a3 10 c0 	movl   $0xc010a3be,(%esp)
c01024dc:	e8 72 de ff ff       	call   c0100353 <cprintf>
    }
}
c01024e1:	c9                   	leave  
c01024e2:	c3                   	ret    

c01024e3 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024e3:	55                   	push   %ebp
c01024e4:	89 e5                	mov    %esp,%ebp
c01024e6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ec:	8b 00                	mov    (%eax),%eax
c01024ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f2:	c7 04 24 d1 a3 10 c0 	movl   $0xc010a3d1,(%esp)
c01024f9:	e8 55 de ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102501:	8b 40 04             	mov    0x4(%eax),%eax
c0102504:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102508:	c7 04 24 e0 a3 10 c0 	movl   $0xc010a3e0,(%esp)
c010250f:	e8 3f de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102514:	8b 45 08             	mov    0x8(%ebp),%eax
c0102517:	8b 40 08             	mov    0x8(%eax),%eax
c010251a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010251e:	c7 04 24 ef a3 10 c0 	movl   $0xc010a3ef,(%esp)
c0102525:	e8 29 de ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c010252a:	8b 45 08             	mov    0x8(%ebp),%eax
c010252d:	8b 40 0c             	mov    0xc(%eax),%eax
c0102530:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102534:	c7 04 24 fe a3 10 c0 	movl   $0xc010a3fe,(%esp)
c010253b:	e8 13 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102540:	8b 45 08             	mov    0x8(%ebp),%eax
c0102543:	8b 40 10             	mov    0x10(%eax),%eax
c0102546:	89 44 24 04          	mov    %eax,0x4(%esp)
c010254a:	c7 04 24 0d a4 10 c0 	movl   $0xc010a40d,(%esp)
c0102551:	e8 fd dd ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102556:	8b 45 08             	mov    0x8(%ebp),%eax
c0102559:	8b 40 14             	mov    0x14(%eax),%eax
c010255c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102560:	c7 04 24 1c a4 10 c0 	movl   $0xc010a41c,(%esp)
c0102567:	e8 e7 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010256c:	8b 45 08             	mov    0x8(%ebp),%eax
c010256f:	8b 40 18             	mov    0x18(%eax),%eax
c0102572:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102576:	c7 04 24 2b a4 10 c0 	movl   $0xc010a42b,(%esp)
c010257d:	e8 d1 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102582:	8b 45 08             	mov    0x8(%ebp),%eax
c0102585:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102588:	89 44 24 04          	mov    %eax,0x4(%esp)
c010258c:	c7 04 24 3a a4 10 c0 	movl   $0xc010a43a,(%esp)
c0102593:	e8 bb dd ff ff       	call   c0100353 <cprintf>
}
c0102598:	c9                   	leave  
c0102599:	c3                   	ret    

c010259a <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010259a:	55                   	push   %ebp
c010259b:	89 e5                	mov    %esp,%ebp
c010259d:	53                   	push   %ebx
c010259e:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01025a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a4:	8b 40 34             	mov    0x34(%eax),%eax
c01025a7:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025aa:	85 c0                	test   %eax,%eax
c01025ac:	74 07                	je     c01025b5 <print_pgfault+0x1b>
c01025ae:	b9 49 a4 10 c0       	mov    $0xc010a449,%ecx
c01025b3:	eb 05                	jmp    c01025ba <print_pgfault+0x20>
c01025b5:	b9 5a a4 10 c0       	mov    $0xc010a45a,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01025ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01025bd:	8b 40 34             	mov    0x34(%eax),%eax
c01025c0:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025c3:	85 c0                	test   %eax,%eax
c01025c5:	74 07                	je     c01025ce <print_pgfault+0x34>
c01025c7:	ba 57 00 00 00       	mov    $0x57,%edx
c01025cc:	eb 05                	jmp    c01025d3 <print_pgfault+0x39>
c01025ce:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01025d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d6:	8b 40 34             	mov    0x34(%eax),%eax
c01025d9:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025dc:	85 c0                	test   %eax,%eax
c01025de:	74 07                	je     c01025e7 <print_pgfault+0x4d>
c01025e0:	b8 55 00 00 00       	mov    $0x55,%eax
c01025e5:	eb 05                	jmp    c01025ec <print_pgfault+0x52>
c01025e7:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025ec:	0f 20 d3             	mov    %cr2,%ebx
c01025ef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01025f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025f5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102601:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102605:	c7 04 24 68 a4 10 c0 	movl   $0xc010a468,(%esp)
c010260c:	e8 42 dd ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102611:	83 c4 34             	add    $0x34,%esp
c0102614:	5b                   	pop    %ebx
c0102615:	5d                   	pop    %ebp
c0102616:	c3                   	ret    

c0102617 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102617:	55                   	push   %ebp
c0102618:	89 e5                	mov    %esp,%ebp
c010261a:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c010261d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102620:	89 04 24             	mov    %eax,(%esp)
c0102623:	e8 72 ff ff ff       	call   c010259a <print_pgfault>
    if (check_mm_struct != NULL) {
c0102628:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010262d:	85 c0                	test   %eax,%eax
c010262f:	74 28                	je     c0102659 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102631:	0f 20 d0             	mov    %cr2,%eax
c0102634:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102637:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c010263a:	89 c1                	mov    %eax,%ecx
c010263c:	8b 45 08             	mov    0x8(%ebp),%eax
c010263f:	8b 50 34             	mov    0x34(%eax),%edx
c0102642:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0102647:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010264b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010264f:	89 04 24             	mov    %eax,(%esp)
c0102652:	e8 fd 5b 00 00       	call   c0108254 <do_pgfault>
c0102657:	eb 1c                	jmp    c0102675 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102659:	c7 44 24 08 8b a4 10 	movl   $0xc010a48b,0x8(%esp)
c0102660:	c0 
c0102661:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102668:	00 
c0102669:	c7 04 24 8e a2 10 c0 	movl   $0xc010a28e,(%esp)
c0102670:	e8 83 e6 ff ff       	call   c0100cf8 <__panic>
}
c0102675:	c9                   	leave  
c0102676:	c3                   	ret    

c0102677 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102677:	55                   	push   %ebp
c0102678:	89 e5                	mov    %esp,%ebp
c010267a:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010267d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102680:	8b 40 30             	mov    0x30(%eax),%eax
c0102683:	83 f8 24             	cmp    $0x24,%eax
c0102686:	0f 84 c2 00 00 00    	je     c010274e <trap_dispatch+0xd7>
c010268c:	83 f8 24             	cmp    $0x24,%eax
c010268f:	77 18                	ja     c01026a9 <trap_dispatch+0x32>
c0102691:	83 f8 20             	cmp    $0x20,%eax
c0102694:	74 7d                	je     c0102713 <trap_dispatch+0x9c>
c0102696:	83 f8 21             	cmp    $0x21,%eax
c0102699:	0f 84 d5 00 00 00    	je     c0102774 <trap_dispatch+0xfd>
c010269f:	83 f8 0e             	cmp    $0xe,%eax
c01026a2:	74 28                	je     c01026cc <trap_dispatch+0x55>
c01026a4:	e9 0d 01 00 00       	jmp    c01027b6 <trap_dispatch+0x13f>
c01026a9:	83 f8 2e             	cmp    $0x2e,%eax
c01026ac:	0f 82 04 01 00 00    	jb     c01027b6 <trap_dispatch+0x13f>
c01026b2:	83 f8 2f             	cmp    $0x2f,%eax
c01026b5:	0f 86 33 01 00 00    	jbe    c01027ee <trap_dispatch+0x177>
c01026bb:	83 e8 78             	sub    $0x78,%eax
c01026be:	83 f8 01             	cmp    $0x1,%eax
c01026c1:	0f 87 ef 00 00 00    	ja     c01027b6 <trap_dispatch+0x13f>
c01026c7:	e9 ce 00 00 00       	jmp    c010279a <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01026cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01026cf:	89 04 24             	mov    %eax,(%esp)
c01026d2:	e8 40 ff ff ff       	call   c0102617 <pgfault_handler>
c01026d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026de:	74 2e                	je     c010270e <trap_dispatch+0x97>
            print_trapframe(tf);
c01026e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e3:	89 04 24             	mov    %eax,(%esp)
c01026e6:	e8 33 fc ff ff       	call   c010231e <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026f2:	c7 44 24 08 a2 a4 10 	movl   $0xc010a4a2,0x8(%esp)
c01026f9:	c0 
c01026fa:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0102701:	00 
c0102702:	c7 04 24 8e a2 10 c0 	movl   $0xc010a28e,(%esp)
c0102709:	e8 ea e5 ff ff       	call   c0100cf8 <__panic>
        }
        break;
c010270e:	e9 dc 00 00 00       	jmp    c01027ef <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_TIMER:
#if 0
    LAB3 : If some page replacement algorithm(such as CLOCK PRA) need tick to change the priority of pages, 
    then you can add code here. 
#endif
		ticks++;//in clock.h(extern volatile size_t ticks;);
c0102713:	a1 14 7b 12 c0       	mov    0xc0127b14,%eax
c0102718:	83 c0 01             	add    $0x1,%eax
c010271b:	a3 14 7b 12 c0       	mov    %eax,0xc0127b14
    	if(ticks % TICK_NUM == 0)
c0102720:	8b 0d 14 7b 12 c0    	mov    0xc0127b14,%ecx
c0102726:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c010272b:	89 c8                	mov    %ecx,%eax
c010272d:	f7 e2                	mul    %edx
c010272f:	89 d0                	mov    %edx,%eax
c0102731:	c1 e8 05             	shr    $0x5,%eax
c0102734:	6b c0 64             	imul   $0x64,%eax,%eax
c0102737:	29 c1                	sub    %eax,%ecx
c0102739:	89 c8                	mov    %ecx,%eax
c010273b:	85 c0                	test   %eax,%eax
c010273d:	75 0a                	jne    c0102749 <trap_dispatch+0xd2>
    	{
    		print_ticks();//打印"100	ticks";
c010273f:	e8 d3 f9 ff ff       	call   c0102117 <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0102744:	e9 a6 00 00 00       	jmp    c01027ef <trap_dispatch+0x178>
c0102749:	e9 a1 00 00 00       	jmp    c01027ef <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c010274e:	e8 13 ef ff ff       	call   c0101666 <cons_getc>
c0102753:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102756:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010275a:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010275e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102762:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102766:	c7 04 24 bd a4 10 c0 	movl   $0xc010a4bd,(%esp)
c010276d:	e8 e1 db ff ff       	call   c0100353 <cprintf>
        break;
c0102772:	eb 7b                	jmp    c01027ef <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102774:	e8 ed ee ff ff       	call   c0101666 <cons_getc>
c0102779:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c010277c:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102780:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102784:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102788:	89 44 24 04          	mov    %eax,0x4(%esp)
c010278c:	c7 04 24 cf a4 10 c0 	movl   $0xc010a4cf,(%esp)
c0102793:	e8 bb db ff ff       	call   c0100353 <cprintf>
        break;
c0102798:	eb 55                	jmp    c01027ef <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c010279a:	c7 44 24 08 de a4 10 	movl   $0xc010a4de,0x8(%esp)
c01027a1:	c0 
c01027a2:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c01027a9:	00 
c01027aa:	c7 04 24 8e a2 10 c0 	movl   $0xc010a28e,(%esp)
c01027b1:	e8 42 e5 ff ff       	call   c0100cf8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01027b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01027bd:	0f b7 c0             	movzwl %ax,%eax
c01027c0:	83 e0 03             	and    $0x3,%eax
c01027c3:	85 c0                	test   %eax,%eax
c01027c5:	75 28                	jne    c01027ef <trap_dispatch+0x178>
            print_trapframe(tf);
c01027c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ca:	89 04 24             	mov    %eax,(%esp)
c01027cd:	e8 4c fb ff ff       	call   c010231e <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01027d2:	c7 44 24 08 ee a4 10 	movl   $0xc010a4ee,0x8(%esp)
c01027d9:	c0 
c01027da:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01027e1:	00 
c01027e2:	c7 04 24 8e a2 10 c0 	movl   $0xc010a28e,(%esp)
c01027e9:	e8 0a e5 ff ff       	call   c0100cf8 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01027ee:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c01027ef:	c9                   	leave  
c01027f0:	c3                   	ret    

c01027f1 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01027f1:	55                   	push   %ebp
c01027f2:	89 e5                	mov    %esp,%ebp
c01027f4:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01027f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027fa:	89 04 24             	mov    %eax,(%esp)
c01027fd:	e8 75 fe ff ff       	call   c0102677 <trap_dispatch>
}
c0102802:	c9                   	leave  
c0102803:	c3                   	ret    

c0102804 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102804:	1e                   	push   %ds
    pushl %es
c0102805:	06                   	push   %es
    pushl %fs
c0102806:	0f a0                	push   %fs
    pushl %gs
c0102808:	0f a8                	push   %gs
    pushal
c010280a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010280b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102810:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102812:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102814:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102815:	e8 d7 ff ff ff       	call   c01027f1 <trap>

    # pop the pushed stack pointer
    popl %esp
c010281a:	5c                   	pop    %esp

c010281b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010281b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010281c:	0f a9                	pop    %gs
    popl %fs
c010281e:	0f a1                	pop    %fs
    popl %es
c0102820:	07                   	pop    %es
    popl %ds
c0102821:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102822:	83 c4 08             	add    $0x8,%esp
    iret
c0102825:	cf                   	iret   

c0102826 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102826:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c010282a:	e9 ec ff ff ff       	jmp    c010281b <__trapret>

c010282f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $0
c0102831:	6a 00                	push   $0x0
  jmp __alltraps
c0102833:	e9 cc ff ff ff       	jmp    c0102804 <__alltraps>

c0102838 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $1
c010283a:	6a 01                	push   $0x1
  jmp __alltraps
c010283c:	e9 c3 ff ff ff       	jmp    c0102804 <__alltraps>

c0102841 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $2
c0102843:	6a 02                	push   $0x2
  jmp __alltraps
c0102845:	e9 ba ff ff ff       	jmp    c0102804 <__alltraps>

c010284a <vector3>:
.globl vector3
vector3:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $3
c010284c:	6a 03                	push   $0x3
  jmp __alltraps
c010284e:	e9 b1 ff ff ff       	jmp    c0102804 <__alltraps>

c0102853 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $4
c0102855:	6a 04                	push   $0x4
  jmp __alltraps
c0102857:	e9 a8 ff ff ff       	jmp    c0102804 <__alltraps>

c010285c <vector5>:
.globl vector5
vector5:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $5
c010285e:	6a 05                	push   $0x5
  jmp __alltraps
c0102860:	e9 9f ff ff ff       	jmp    c0102804 <__alltraps>

c0102865 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $6
c0102867:	6a 06                	push   $0x6
  jmp __alltraps
c0102869:	e9 96 ff ff ff       	jmp    c0102804 <__alltraps>

c010286e <vector7>:
.globl vector7
vector7:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $7
c0102870:	6a 07                	push   $0x7
  jmp __alltraps
c0102872:	e9 8d ff ff ff       	jmp    c0102804 <__alltraps>

c0102877 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102877:	6a 08                	push   $0x8
  jmp __alltraps
c0102879:	e9 86 ff ff ff       	jmp    c0102804 <__alltraps>

c010287e <vector9>:
.globl vector9
vector9:
  pushl $9
c010287e:	6a 09                	push   $0x9
  jmp __alltraps
c0102880:	e9 7f ff ff ff       	jmp    c0102804 <__alltraps>

c0102885 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102885:	6a 0a                	push   $0xa
  jmp __alltraps
c0102887:	e9 78 ff ff ff       	jmp    c0102804 <__alltraps>

c010288c <vector11>:
.globl vector11
vector11:
  pushl $11
c010288c:	6a 0b                	push   $0xb
  jmp __alltraps
c010288e:	e9 71 ff ff ff       	jmp    c0102804 <__alltraps>

c0102893 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102893:	6a 0c                	push   $0xc
  jmp __alltraps
c0102895:	e9 6a ff ff ff       	jmp    c0102804 <__alltraps>

c010289a <vector13>:
.globl vector13
vector13:
  pushl $13
c010289a:	6a 0d                	push   $0xd
  jmp __alltraps
c010289c:	e9 63 ff ff ff       	jmp    c0102804 <__alltraps>

c01028a1 <vector14>:
.globl vector14
vector14:
  pushl $14
c01028a1:	6a 0e                	push   $0xe
  jmp __alltraps
c01028a3:	e9 5c ff ff ff       	jmp    c0102804 <__alltraps>

c01028a8 <vector15>:
.globl vector15
vector15:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $15
c01028aa:	6a 0f                	push   $0xf
  jmp __alltraps
c01028ac:	e9 53 ff ff ff       	jmp    c0102804 <__alltraps>

c01028b1 <vector16>:
.globl vector16
vector16:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $16
c01028b3:	6a 10                	push   $0x10
  jmp __alltraps
c01028b5:	e9 4a ff ff ff       	jmp    c0102804 <__alltraps>

c01028ba <vector17>:
.globl vector17
vector17:
  pushl $17
c01028ba:	6a 11                	push   $0x11
  jmp __alltraps
c01028bc:	e9 43 ff ff ff       	jmp    c0102804 <__alltraps>

c01028c1 <vector18>:
.globl vector18
vector18:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $18
c01028c3:	6a 12                	push   $0x12
  jmp __alltraps
c01028c5:	e9 3a ff ff ff       	jmp    c0102804 <__alltraps>

c01028ca <vector19>:
.globl vector19
vector19:
  pushl $0
c01028ca:	6a 00                	push   $0x0
  pushl $19
c01028cc:	6a 13                	push   $0x13
  jmp __alltraps
c01028ce:	e9 31 ff ff ff       	jmp    c0102804 <__alltraps>

c01028d3 <vector20>:
.globl vector20
vector20:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $20
c01028d5:	6a 14                	push   $0x14
  jmp __alltraps
c01028d7:	e9 28 ff ff ff       	jmp    c0102804 <__alltraps>

c01028dc <vector21>:
.globl vector21
vector21:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $21
c01028de:	6a 15                	push   $0x15
  jmp __alltraps
c01028e0:	e9 1f ff ff ff       	jmp    c0102804 <__alltraps>

c01028e5 <vector22>:
.globl vector22
vector22:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $22
c01028e7:	6a 16                	push   $0x16
  jmp __alltraps
c01028e9:	e9 16 ff ff ff       	jmp    c0102804 <__alltraps>

c01028ee <vector23>:
.globl vector23
vector23:
  pushl $0
c01028ee:	6a 00                	push   $0x0
  pushl $23
c01028f0:	6a 17                	push   $0x17
  jmp __alltraps
c01028f2:	e9 0d ff ff ff       	jmp    c0102804 <__alltraps>

c01028f7 <vector24>:
.globl vector24
vector24:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $24
c01028f9:	6a 18                	push   $0x18
  jmp __alltraps
c01028fb:	e9 04 ff ff ff       	jmp    c0102804 <__alltraps>

c0102900 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $25
c0102902:	6a 19                	push   $0x19
  jmp __alltraps
c0102904:	e9 fb fe ff ff       	jmp    c0102804 <__alltraps>

c0102909 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $26
c010290b:	6a 1a                	push   $0x1a
  jmp __alltraps
c010290d:	e9 f2 fe ff ff       	jmp    c0102804 <__alltraps>

c0102912 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102912:	6a 00                	push   $0x0
  pushl $27
c0102914:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102916:	e9 e9 fe ff ff       	jmp    c0102804 <__alltraps>

c010291b <vector28>:
.globl vector28
vector28:
  pushl $0
c010291b:	6a 00                	push   $0x0
  pushl $28
c010291d:	6a 1c                	push   $0x1c
  jmp __alltraps
c010291f:	e9 e0 fe ff ff       	jmp    c0102804 <__alltraps>

c0102924 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $29
c0102926:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102928:	e9 d7 fe ff ff       	jmp    c0102804 <__alltraps>

c010292d <vector30>:
.globl vector30
vector30:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $30
c010292f:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102931:	e9 ce fe ff ff       	jmp    c0102804 <__alltraps>

c0102936 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102936:	6a 00                	push   $0x0
  pushl $31
c0102938:	6a 1f                	push   $0x1f
  jmp __alltraps
c010293a:	e9 c5 fe ff ff       	jmp    c0102804 <__alltraps>

c010293f <vector32>:
.globl vector32
vector32:
  pushl $0
c010293f:	6a 00                	push   $0x0
  pushl $32
c0102941:	6a 20                	push   $0x20
  jmp __alltraps
c0102943:	e9 bc fe ff ff       	jmp    c0102804 <__alltraps>

c0102948 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $33
c010294a:	6a 21                	push   $0x21
  jmp __alltraps
c010294c:	e9 b3 fe ff ff       	jmp    c0102804 <__alltraps>

c0102951 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $34
c0102953:	6a 22                	push   $0x22
  jmp __alltraps
c0102955:	e9 aa fe ff ff       	jmp    c0102804 <__alltraps>

c010295a <vector35>:
.globl vector35
vector35:
  pushl $0
c010295a:	6a 00                	push   $0x0
  pushl $35
c010295c:	6a 23                	push   $0x23
  jmp __alltraps
c010295e:	e9 a1 fe ff ff       	jmp    c0102804 <__alltraps>

c0102963 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102963:	6a 00                	push   $0x0
  pushl $36
c0102965:	6a 24                	push   $0x24
  jmp __alltraps
c0102967:	e9 98 fe ff ff       	jmp    c0102804 <__alltraps>

c010296c <vector37>:
.globl vector37
vector37:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $37
c010296e:	6a 25                	push   $0x25
  jmp __alltraps
c0102970:	e9 8f fe ff ff       	jmp    c0102804 <__alltraps>

c0102975 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $38
c0102977:	6a 26                	push   $0x26
  jmp __alltraps
c0102979:	e9 86 fe ff ff       	jmp    c0102804 <__alltraps>

c010297e <vector39>:
.globl vector39
vector39:
  pushl $0
c010297e:	6a 00                	push   $0x0
  pushl $39
c0102980:	6a 27                	push   $0x27
  jmp __alltraps
c0102982:	e9 7d fe ff ff       	jmp    c0102804 <__alltraps>

c0102987 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102987:	6a 00                	push   $0x0
  pushl $40
c0102989:	6a 28                	push   $0x28
  jmp __alltraps
c010298b:	e9 74 fe ff ff       	jmp    c0102804 <__alltraps>

c0102990 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $41
c0102992:	6a 29                	push   $0x29
  jmp __alltraps
c0102994:	e9 6b fe ff ff       	jmp    c0102804 <__alltraps>

c0102999 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $42
c010299b:	6a 2a                	push   $0x2a
  jmp __alltraps
c010299d:	e9 62 fe ff ff       	jmp    c0102804 <__alltraps>

c01029a2 <vector43>:
.globl vector43
vector43:
  pushl $0
c01029a2:	6a 00                	push   $0x0
  pushl $43
c01029a4:	6a 2b                	push   $0x2b
  jmp __alltraps
c01029a6:	e9 59 fe ff ff       	jmp    c0102804 <__alltraps>

c01029ab <vector44>:
.globl vector44
vector44:
  pushl $0
c01029ab:	6a 00                	push   $0x0
  pushl $44
c01029ad:	6a 2c                	push   $0x2c
  jmp __alltraps
c01029af:	e9 50 fe ff ff       	jmp    c0102804 <__alltraps>

c01029b4 <vector45>:
.globl vector45
vector45:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $45
c01029b6:	6a 2d                	push   $0x2d
  jmp __alltraps
c01029b8:	e9 47 fe ff ff       	jmp    c0102804 <__alltraps>

c01029bd <vector46>:
.globl vector46
vector46:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $46
c01029bf:	6a 2e                	push   $0x2e
  jmp __alltraps
c01029c1:	e9 3e fe ff ff       	jmp    c0102804 <__alltraps>

c01029c6 <vector47>:
.globl vector47
vector47:
  pushl $0
c01029c6:	6a 00                	push   $0x0
  pushl $47
c01029c8:	6a 2f                	push   $0x2f
  jmp __alltraps
c01029ca:	e9 35 fe ff ff       	jmp    c0102804 <__alltraps>

c01029cf <vector48>:
.globl vector48
vector48:
  pushl $0
c01029cf:	6a 00                	push   $0x0
  pushl $48
c01029d1:	6a 30                	push   $0x30
  jmp __alltraps
c01029d3:	e9 2c fe ff ff       	jmp    c0102804 <__alltraps>

c01029d8 <vector49>:
.globl vector49
vector49:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $49
c01029da:	6a 31                	push   $0x31
  jmp __alltraps
c01029dc:	e9 23 fe ff ff       	jmp    c0102804 <__alltraps>

c01029e1 <vector50>:
.globl vector50
vector50:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $50
c01029e3:	6a 32                	push   $0x32
  jmp __alltraps
c01029e5:	e9 1a fe ff ff       	jmp    c0102804 <__alltraps>

c01029ea <vector51>:
.globl vector51
vector51:
  pushl $0
c01029ea:	6a 00                	push   $0x0
  pushl $51
c01029ec:	6a 33                	push   $0x33
  jmp __alltraps
c01029ee:	e9 11 fe ff ff       	jmp    c0102804 <__alltraps>

c01029f3 <vector52>:
.globl vector52
vector52:
  pushl $0
c01029f3:	6a 00                	push   $0x0
  pushl $52
c01029f5:	6a 34                	push   $0x34
  jmp __alltraps
c01029f7:	e9 08 fe ff ff       	jmp    c0102804 <__alltraps>

c01029fc <vector53>:
.globl vector53
vector53:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $53
c01029fe:	6a 35                	push   $0x35
  jmp __alltraps
c0102a00:	e9 ff fd ff ff       	jmp    c0102804 <__alltraps>

c0102a05 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $54
c0102a07:	6a 36                	push   $0x36
  jmp __alltraps
c0102a09:	e9 f6 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a0e <vector55>:
.globl vector55
vector55:
  pushl $0
c0102a0e:	6a 00                	push   $0x0
  pushl $55
c0102a10:	6a 37                	push   $0x37
  jmp __alltraps
c0102a12:	e9 ed fd ff ff       	jmp    c0102804 <__alltraps>

c0102a17 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102a17:	6a 00                	push   $0x0
  pushl $56
c0102a19:	6a 38                	push   $0x38
  jmp __alltraps
c0102a1b:	e9 e4 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a20 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $57
c0102a22:	6a 39                	push   $0x39
  jmp __alltraps
c0102a24:	e9 db fd ff ff       	jmp    c0102804 <__alltraps>

c0102a29 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $58
c0102a2b:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102a2d:	e9 d2 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a32 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102a32:	6a 00                	push   $0x0
  pushl $59
c0102a34:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102a36:	e9 c9 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a3b <vector60>:
.globl vector60
vector60:
  pushl $0
c0102a3b:	6a 00                	push   $0x0
  pushl $60
c0102a3d:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102a3f:	e9 c0 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a44 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $61
c0102a46:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102a48:	e9 b7 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a4d <vector62>:
.globl vector62
vector62:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $62
c0102a4f:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102a51:	e9 ae fd ff ff       	jmp    c0102804 <__alltraps>

c0102a56 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102a56:	6a 00                	push   $0x0
  pushl $63
c0102a58:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102a5a:	e9 a5 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a5f <vector64>:
.globl vector64
vector64:
  pushl $0
c0102a5f:	6a 00                	push   $0x0
  pushl $64
c0102a61:	6a 40                	push   $0x40
  jmp __alltraps
c0102a63:	e9 9c fd ff ff       	jmp    c0102804 <__alltraps>

c0102a68 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102a68:	6a 00                	push   $0x0
  pushl $65
c0102a6a:	6a 41                	push   $0x41
  jmp __alltraps
c0102a6c:	e9 93 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a71 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $66
c0102a73:	6a 42                	push   $0x42
  jmp __alltraps
c0102a75:	e9 8a fd ff ff       	jmp    c0102804 <__alltraps>

c0102a7a <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a7a:	6a 00                	push   $0x0
  pushl $67
c0102a7c:	6a 43                	push   $0x43
  jmp __alltraps
c0102a7e:	e9 81 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a83 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $68
c0102a85:	6a 44                	push   $0x44
  jmp __alltraps
c0102a87:	e9 78 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a8c <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $69
c0102a8e:	6a 45                	push   $0x45
  jmp __alltraps
c0102a90:	e9 6f fd ff ff       	jmp    c0102804 <__alltraps>

c0102a95 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $70
c0102a97:	6a 46                	push   $0x46
  jmp __alltraps
c0102a99:	e9 66 fd ff ff       	jmp    c0102804 <__alltraps>

c0102a9e <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a9e:	6a 00                	push   $0x0
  pushl $71
c0102aa0:	6a 47                	push   $0x47
  jmp __alltraps
c0102aa2:	e9 5d fd ff ff       	jmp    c0102804 <__alltraps>

c0102aa7 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102aa7:	6a 00                	push   $0x0
  pushl $72
c0102aa9:	6a 48                	push   $0x48
  jmp __alltraps
c0102aab:	e9 54 fd ff ff       	jmp    c0102804 <__alltraps>

c0102ab0 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $73
c0102ab2:	6a 49                	push   $0x49
  jmp __alltraps
c0102ab4:	e9 4b fd ff ff       	jmp    c0102804 <__alltraps>

c0102ab9 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $74
c0102abb:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102abd:	e9 42 fd ff ff       	jmp    c0102804 <__alltraps>

c0102ac2 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ac2:	6a 00                	push   $0x0
  pushl $75
c0102ac4:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ac6:	e9 39 fd ff ff       	jmp    c0102804 <__alltraps>

c0102acb <vector76>:
.globl vector76
vector76:
  pushl $0
c0102acb:	6a 00                	push   $0x0
  pushl $76
c0102acd:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102acf:	e9 30 fd ff ff       	jmp    c0102804 <__alltraps>

c0102ad4 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102ad4:	6a 00                	push   $0x0
  pushl $77
c0102ad6:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102ad8:	e9 27 fd ff ff       	jmp    c0102804 <__alltraps>

c0102add <vector78>:
.globl vector78
vector78:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $78
c0102adf:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102ae1:	e9 1e fd ff ff       	jmp    c0102804 <__alltraps>

c0102ae6 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102ae6:	6a 00                	push   $0x0
  pushl $79
c0102ae8:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102aea:	e9 15 fd ff ff       	jmp    c0102804 <__alltraps>

c0102aef <vector80>:
.globl vector80
vector80:
  pushl $0
c0102aef:	6a 00                	push   $0x0
  pushl $80
c0102af1:	6a 50                	push   $0x50
  jmp __alltraps
c0102af3:	e9 0c fd ff ff       	jmp    c0102804 <__alltraps>

c0102af8 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102af8:	6a 00                	push   $0x0
  pushl $81
c0102afa:	6a 51                	push   $0x51
  jmp __alltraps
c0102afc:	e9 03 fd ff ff       	jmp    c0102804 <__alltraps>

c0102b01 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $82
c0102b03:	6a 52                	push   $0x52
  jmp __alltraps
c0102b05:	e9 fa fc ff ff       	jmp    c0102804 <__alltraps>

c0102b0a <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b0a:	6a 00                	push   $0x0
  pushl $83
c0102b0c:	6a 53                	push   $0x53
  jmp __alltraps
c0102b0e:	e9 f1 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b13 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102b13:	6a 00                	push   $0x0
  pushl $84
c0102b15:	6a 54                	push   $0x54
  jmp __alltraps
c0102b17:	e9 e8 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b1c <vector85>:
.globl vector85
vector85:
  pushl $0
c0102b1c:	6a 00                	push   $0x0
  pushl $85
c0102b1e:	6a 55                	push   $0x55
  jmp __alltraps
c0102b20:	e9 df fc ff ff       	jmp    c0102804 <__alltraps>

c0102b25 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $86
c0102b27:	6a 56                	push   $0x56
  jmp __alltraps
c0102b29:	e9 d6 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b2e <vector87>:
.globl vector87
vector87:
  pushl $0
c0102b2e:	6a 00                	push   $0x0
  pushl $87
c0102b30:	6a 57                	push   $0x57
  jmp __alltraps
c0102b32:	e9 cd fc ff ff       	jmp    c0102804 <__alltraps>

c0102b37 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102b37:	6a 00                	push   $0x0
  pushl $88
c0102b39:	6a 58                	push   $0x58
  jmp __alltraps
c0102b3b:	e9 c4 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b40 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102b40:	6a 00                	push   $0x0
  pushl $89
c0102b42:	6a 59                	push   $0x59
  jmp __alltraps
c0102b44:	e9 bb fc ff ff       	jmp    c0102804 <__alltraps>

c0102b49 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $90
c0102b4b:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102b4d:	e9 b2 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b52 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102b52:	6a 00                	push   $0x0
  pushl $91
c0102b54:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102b56:	e9 a9 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b5b <vector92>:
.globl vector92
vector92:
  pushl $0
c0102b5b:	6a 00                	push   $0x0
  pushl $92
c0102b5d:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102b5f:	e9 a0 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b64 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102b64:	6a 00                	push   $0x0
  pushl $93
c0102b66:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102b68:	e9 97 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b6d <vector94>:
.globl vector94
vector94:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $94
c0102b6f:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102b71:	e9 8e fc ff ff       	jmp    c0102804 <__alltraps>

c0102b76 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b76:	6a 00                	push   $0x0
  pushl $95
c0102b78:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b7a:	e9 85 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b7f <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b7f:	6a 00                	push   $0x0
  pushl $96
c0102b81:	6a 60                	push   $0x60
  jmp __alltraps
c0102b83:	e9 7c fc ff ff       	jmp    c0102804 <__alltraps>

c0102b88 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b88:	6a 00                	push   $0x0
  pushl $97
c0102b8a:	6a 61                	push   $0x61
  jmp __alltraps
c0102b8c:	e9 73 fc ff ff       	jmp    c0102804 <__alltraps>

c0102b91 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $98
c0102b93:	6a 62                	push   $0x62
  jmp __alltraps
c0102b95:	e9 6a fc ff ff       	jmp    c0102804 <__alltraps>

c0102b9a <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b9a:	6a 00                	push   $0x0
  pushl $99
c0102b9c:	6a 63                	push   $0x63
  jmp __alltraps
c0102b9e:	e9 61 fc ff ff       	jmp    c0102804 <__alltraps>

c0102ba3 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ba3:	6a 00                	push   $0x0
  pushl $100
c0102ba5:	6a 64                	push   $0x64
  jmp __alltraps
c0102ba7:	e9 58 fc ff ff       	jmp    c0102804 <__alltraps>

c0102bac <vector101>:
.globl vector101
vector101:
  pushl $0
c0102bac:	6a 00                	push   $0x0
  pushl $101
c0102bae:	6a 65                	push   $0x65
  jmp __alltraps
c0102bb0:	e9 4f fc ff ff       	jmp    c0102804 <__alltraps>

c0102bb5 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102bb5:	6a 00                	push   $0x0
  pushl $102
c0102bb7:	6a 66                	push   $0x66
  jmp __alltraps
c0102bb9:	e9 46 fc ff ff       	jmp    c0102804 <__alltraps>

c0102bbe <vector103>:
.globl vector103
vector103:
  pushl $0
c0102bbe:	6a 00                	push   $0x0
  pushl $103
c0102bc0:	6a 67                	push   $0x67
  jmp __alltraps
c0102bc2:	e9 3d fc ff ff       	jmp    c0102804 <__alltraps>

c0102bc7 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102bc7:	6a 00                	push   $0x0
  pushl $104
c0102bc9:	6a 68                	push   $0x68
  jmp __alltraps
c0102bcb:	e9 34 fc ff ff       	jmp    c0102804 <__alltraps>

c0102bd0 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102bd0:	6a 00                	push   $0x0
  pushl $105
c0102bd2:	6a 69                	push   $0x69
  jmp __alltraps
c0102bd4:	e9 2b fc ff ff       	jmp    c0102804 <__alltraps>

c0102bd9 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $106
c0102bdb:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102bdd:	e9 22 fc ff ff       	jmp    c0102804 <__alltraps>

c0102be2 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102be2:	6a 00                	push   $0x0
  pushl $107
c0102be4:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102be6:	e9 19 fc ff ff       	jmp    c0102804 <__alltraps>

c0102beb <vector108>:
.globl vector108
vector108:
  pushl $0
c0102beb:	6a 00                	push   $0x0
  pushl $108
c0102bed:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102bef:	e9 10 fc ff ff       	jmp    c0102804 <__alltraps>

c0102bf4 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102bf4:	6a 00                	push   $0x0
  pushl $109
c0102bf6:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102bf8:	e9 07 fc ff ff       	jmp    c0102804 <__alltraps>

c0102bfd <vector110>:
.globl vector110
vector110:
  pushl $0
c0102bfd:	6a 00                	push   $0x0
  pushl $110
c0102bff:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c01:	e9 fe fb ff ff       	jmp    c0102804 <__alltraps>

c0102c06 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c06:	6a 00                	push   $0x0
  pushl $111
c0102c08:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c0a:	e9 f5 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c0f <vector112>:
.globl vector112
vector112:
  pushl $0
c0102c0f:	6a 00                	push   $0x0
  pushl $112
c0102c11:	6a 70                	push   $0x70
  jmp __alltraps
c0102c13:	e9 ec fb ff ff       	jmp    c0102804 <__alltraps>

c0102c18 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102c18:	6a 00                	push   $0x0
  pushl $113
c0102c1a:	6a 71                	push   $0x71
  jmp __alltraps
c0102c1c:	e9 e3 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c21 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102c21:	6a 00                	push   $0x0
  pushl $114
c0102c23:	6a 72                	push   $0x72
  jmp __alltraps
c0102c25:	e9 da fb ff ff       	jmp    c0102804 <__alltraps>

c0102c2a <vector115>:
.globl vector115
vector115:
  pushl $0
c0102c2a:	6a 00                	push   $0x0
  pushl $115
c0102c2c:	6a 73                	push   $0x73
  jmp __alltraps
c0102c2e:	e9 d1 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c33 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102c33:	6a 00                	push   $0x0
  pushl $116
c0102c35:	6a 74                	push   $0x74
  jmp __alltraps
c0102c37:	e9 c8 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c3c <vector117>:
.globl vector117
vector117:
  pushl $0
c0102c3c:	6a 00                	push   $0x0
  pushl $117
c0102c3e:	6a 75                	push   $0x75
  jmp __alltraps
c0102c40:	e9 bf fb ff ff       	jmp    c0102804 <__alltraps>

c0102c45 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102c45:	6a 00                	push   $0x0
  pushl $118
c0102c47:	6a 76                	push   $0x76
  jmp __alltraps
c0102c49:	e9 b6 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c4e <vector119>:
.globl vector119
vector119:
  pushl $0
c0102c4e:	6a 00                	push   $0x0
  pushl $119
c0102c50:	6a 77                	push   $0x77
  jmp __alltraps
c0102c52:	e9 ad fb ff ff       	jmp    c0102804 <__alltraps>

c0102c57 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102c57:	6a 00                	push   $0x0
  pushl $120
c0102c59:	6a 78                	push   $0x78
  jmp __alltraps
c0102c5b:	e9 a4 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c60 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102c60:	6a 00                	push   $0x0
  pushl $121
c0102c62:	6a 79                	push   $0x79
  jmp __alltraps
c0102c64:	e9 9b fb ff ff       	jmp    c0102804 <__alltraps>

c0102c69 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102c69:	6a 00                	push   $0x0
  pushl $122
c0102c6b:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102c6d:	e9 92 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c72 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102c72:	6a 00                	push   $0x0
  pushl $123
c0102c74:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c76:	e9 89 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c7b <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c7b:	6a 00                	push   $0x0
  pushl $124
c0102c7d:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c7f:	e9 80 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c84 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c84:	6a 00                	push   $0x0
  pushl $125
c0102c86:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c88:	e9 77 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c8d <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c8d:	6a 00                	push   $0x0
  pushl $126
c0102c8f:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c91:	e9 6e fb ff ff       	jmp    c0102804 <__alltraps>

c0102c96 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $127
c0102c98:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c9a:	e9 65 fb ff ff       	jmp    c0102804 <__alltraps>

c0102c9f <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c9f:	6a 00                	push   $0x0
  pushl $128
c0102ca1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102ca6:	e9 59 fb ff ff       	jmp    c0102804 <__alltraps>

c0102cab <vector129>:
.globl vector129
vector129:
  pushl $0
c0102cab:	6a 00                	push   $0x0
  pushl $129
c0102cad:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102cb2:	e9 4d fb ff ff       	jmp    c0102804 <__alltraps>

c0102cb7 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102cb7:	6a 00                	push   $0x0
  pushl $130
c0102cb9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102cbe:	e9 41 fb ff ff       	jmp    c0102804 <__alltraps>

c0102cc3 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102cc3:	6a 00                	push   $0x0
  pushl $131
c0102cc5:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102cca:	e9 35 fb ff ff       	jmp    c0102804 <__alltraps>

c0102ccf <vector132>:
.globl vector132
vector132:
  pushl $0
c0102ccf:	6a 00                	push   $0x0
  pushl $132
c0102cd1:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102cd6:	e9 29 fb ff ff       	jmp    c0102804 <__alltraps>

c0102cdb <vector133>:
.globl vector133
vector133:
  pushl $0
c0102cdb:	6a 00                	push   $0x0
  pushl $133
c0102cdd:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ce2:	e9 1d fb ff ff       	jmp    c0102804 <__alltraps>

c0102ce7 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102ce7:	6a 00                	push   $0x0
  pushl $134
c0102ce9:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102cee:	e9 11 fb ff ff       	jmp    c0102804 <__alltraps>

c0102cf3 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102cf3:	6a 00                	push   $0x0
  pushl $135
c0102cf5:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102cfa:	e9 05 fb ff ff       	jmp    c0102804 <__alltraps>

c0102cff <vector136>:
.globl vector136
vector136:
  pushl $0
c0102cff:	6a 00                	push   $0x0
  pushl $136
c0102d01:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d06:	e9 f9 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d0b <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d0b:	6a 00                	push   $0x0
  pushl $137
c0102d0d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102d12:	e9 ed fa ff ff       	jmp    c0102804 <__alltraps>

c0102d17 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102d17:	6a 00                	push   $0x0
  pushl $138
c0102d19:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102d1e:	e9 e1 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d23 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102d23:	6a 00                	push   $0x0
  pushl $139
c0102d25:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102d2a:	e9 d5 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d2f <vector140>:
.globl vector140
vector140:
  pushl $0
c0102d2f:	6a 00                	push   $0x0
  pushl $140
c0102d31:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102d36:	e9 c9 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d3b <vector141>:
.globl vector141
vector141:
  pushl $0
c0102d3b:	6a 00                	push   $0x0
  pushl $141
c0102d3d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102d42:	e9 bd fa ff ff       	jmp    c0102804 <__alltraps>

c0102d47 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102d47:	6a 00                	push   $0x0
  pushl $142
c0102d49:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102d4e:	e9 b1 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d53 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102d53:	6a 00                	push   $0x0
  pushl $143
c0102d55:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102d5a:	e9 a5 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d5f <vector144>:
.globl vector144
vector144:
  pushl $0
c0102d5f:	6a 00                	push   $0x0
  pushl $144
c0102d61:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102d66:	e9 99 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d6b <vector145>:
.globl vector145
vector145:
  pushl $0
c0102d6b:	6a 00                	push   $0x0
  pushl $145
c0102d6d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102d72:	e9 8d fa ff ff       	jmp    c0102804 <__alltraps>

c0102d77 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d77:	6a 00                	push   $0x0
  pushl $146
c0102d79:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d7e:	e9 81 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d83 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d83:	6a 00                	push   $0x0
  pushl $147
c0102d85:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d8a:	e9 75 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d8f <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d8f:	6a 00                	push   $0x0
  pushl $148
c0102d91:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d96:	e9 69 fa ff ff       	jmp    c0102804 <__alltraps>

c0102d9b <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d9b:	6a 00                	push   $0x0
  pushl $149
c0102d9d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102da2:	e9 5d fa ff ff       	jmp    c0102804 <__alltraps>

c0102da7 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102da7:	6a 00                	push   $0x0
  pushl $150
c0102da9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102dae:	e9 51 fa ff ff       	jmp    c0102804 <__alltraps>

c0102db3 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102db3:	6a 00                	push   $0x0
  pushl $151
c0102db5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102dba:	e9 45 fa ff ff       	jmp    c0102804 <__alltraps>

c0102dbf <vector152>:
.globl vector152
vector152:
  pushl $0
c0102dbf:	6a 00                	push   $0x0
  pushl $152
c0102dc1:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102dc6:	e9 39 fa ff ff       	jmp    c0102804 <__alltraps>

c0102dcb <vector153>:
.globl vector153
vector153:
  pushl $0
c0102dcb:	6a 00                	push   $0x0
  pushl $153
c0102dcd:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102dd2:	e9 2d fa ff ff       	jmp    c0102804 <__alltraps>

c0102dd7 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102dd7:	6a 00                	push   $0x0
  pushl $154
c0102dd9:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102dde:	e9 21 fa ff ff       	jmp    c0102804 <__alltraps>

c0102de3 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102de3:	6a 00                	push   $0x0
  pushl $155
c0102de5:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102dea:	e9 15 fa ff ff       	jmp    c0102804 <__alltraps>

c0102def <vector156>:
.globl vector156
vector156:
  pushl $0
c0102def:	6a 00                	push   $0x0
  pushl $156
c0102df1:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102df6:	e9 09 fa ff ff       	jmp    c0102804 <__alltraps>

c0102dfb <vector157>:
.globl vector157
vector157:
  pushl $0
c0102dfb:	6a 00                	push   $0x0
  pushl $157
c0102dfd:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e02:	e9 fd f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e07 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e07:	6a 00                	push   $0x0
  pushl $158
c0102e09:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102e0e:	e9 f1 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e13 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102e13:	6a 00                	push   $0x0
  pushl $159
c0102e15:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102e1a:	e9 e5 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e1f <vector160>:
.globl vector160
vector160:
  pushl $0
c0102e1f:	6a 00                	push   $0x0
  pushl $160
c0102e21:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102e26:	e9 d9 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e2b <vector161>:
.globl vector161
vector161:
  pushl $0
c0102e2b:	6a 00                	push   $0x0
  pushl $161
c0102e2d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102e32:	e9 cd f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e37 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102e37:	6a 00                	push   $0x0
  pushl $162
c0102e39:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102e3e:	e9 c1 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e43 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102e43:	6a 00                	push   $0x0
  pushl $163
c0102e45:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102e4a:	e9 b5 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e4f <vector164>:
.globl vector164
vector164:
  pushl $0
c0102e4f:	6a 00                	push   $0x0
  pushl $164
c0102e51:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102e56:	e9 a9 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e5b <vector165>:
.globl vector165
vector165:
  pushl $0
c0102e5b:	6a 00                	push   $0x0
  pushl $165
c0102e5d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102e62:	e9 9d f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e67 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102e67:	6a 00                	push   $0x0
  pushl $166
c0102e69:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102e6e:	e9 91 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e73 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102e73:	6a 00                	push   $0x0
  pushl $167
c0102e75:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e7a:	e9 85 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e7f <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e7f:	6a 00                	push   $0x0
  pushl $168
c0102e81:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e86:	e9 79 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e8b <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e8b:	6a 00                	push   $0x0
  pushl $169
c0102e8d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e92:	e9 6d f9 ff ff       	jmp    c0102804 <__alltraps>

c0102e97 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e97:	6a 00                	push   $0x0
  pushl $170
c0102e99:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e9e:	e9 61 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102ea3 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102ea3:	6a 00                	push   $0x0
  pushl $171
c0102ea5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102eaa:	e9 55 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102eaf <vector172>:
.globl vector172
vector172:
  pushl $0
c0102eaf:	6a 00                	push   $0x0
  pushl $172
c0102eb1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102eb6:	e9 49 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102ebb <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ebb:	6a 00                	push   $0x0
  pushl $173
c0102ebd:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102ec2:	e9 3d f9 ff ff       	jmp    c0102804 <__alltraps>

c0102ec7 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102ec7:	6a 00                	push   $0x0
  pushl $174
c0102ec9:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102ece:	e9 31 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102ed3 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102ed3:	6a 00                	push   $0x0
  pushl $175
c0102ed5:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102eda:	e9 25 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102edf <vector176>:
.globl vector176
vector176:
  pushl $0
c0102edf:	6a 00                	push   $0x0
  pushl $176
c0102ee1:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102ee6:	e9 19 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102eeb <vector177>:
.globl vector177
vector177:
  pushl $0
c0102eeb:	6a 00                	push   $0x0
  pushl $177
c0102eed:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102ef2:	e9 0d f9 ff ff       	jmp    c0102804 <__alltraps>

c0102ef7 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102ef7:	6a 00                	push   $0x0
  pushl $178
c0102ef9:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102efe:	e9 01 f9 ff ff       	jmp    c0102804 <__alltraps>

c0102f03 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f03:	6a 00                	push   $0x0
  pushl $179
c0102f05:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f0a:	e9 f5 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f0f <vector180>:
.globl vector180
vector180:
  pushl $0
c0102f0f:	6a 00                	push   $0x0
  pushl $180
c0102f11:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102f16:	e9 e9 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f1b <vector181>:
.globl vector181
vector181:
  pushl $0
c0102f1b:	6a 00                	push   $0x0
  pushl $181
c0102f1d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102f22:	e9 dd f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f27 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102f27:	6a 00                	push   $0x0
  pushl $182
c0102f29:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102f2e:	e9 d1 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f33 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102f33:	6a 00                	push   $0x0
  pushl $183
c0102f35:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102f3a:	e9 c5 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f3f <vector184>:
.globl vector184
vector184:
  pushl $0
c0102f3f:	6a 00                	push   $0x0
  pushl $184
c0102f41:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102f46:	e9 b9 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f4b <vector185>:
.globl vector185
vector185:
  pushl $0
c0102f4b:	6a 00                	push   $0x0
  pushl $185
c0102f4d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102f52:	e9 ad f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f57 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102f57:	6a 00                	push   $0x0
  pushl $186
c0102f59:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102f5e:	e9 a1 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f63 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102f63:	6a 00                	push   $0x0
  pushl $187
c0102f65:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102f6a:	e9 95 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f6f <vector188>:
.globl vector188
vector188:
  pushl $0
c0102f6f:	6a 00                	push   $0x0
  pushl $188
c0102f71:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f76:	e9 89 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f7b <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f7b:	6a 00                	push   $0x0
  pushl $189
c0102f7d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f82:	e9 7d f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f87 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f87:	6a 00                	push   $0x0
  pushl $190
c0102f89:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f8e:	e9 71 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f93 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f93:	6a 00                	push   $0x0
  pushl $191
c0102f95:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f9a:	e9 65 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102f9f <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f9f:	6a 00                	push   $0x0
  pushl $192
c0102fa1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102fa6:	e9 59 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fab <vector193>:
.globl vector193
vector193:
  pushl $0
c0102fab:	6a 00                	push   $0x0
  pushl $193
c0102fad:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102fb2:	e9 4d f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fb7 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102fb7:	6a 00                	push   $0x0
  pushl $194
c0102fb9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102fbe:	e9 41 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fc3 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102fc3:	6a 00                	push   $0x0
  pushl $195
c0102fc5:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102fca:	e9 35 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fcf <vector196>:
.globl vector196
vector196:
  pushl $0
c0102fcf:	6a 00                	push   $0x0
  pushl $196
c0102fd1:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102fd6:	e9 29 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fdb <vector197>:
.globl vector197
vector197:
  pushl $0
c0102fdb:	6a 00                	push   $0x0
  pushl $197
c0102fdd:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102fe2:	e9 1d f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fe7 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102fe7:	6a 00                	push   $0x0
  pushl $198
c0102fe9:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102fee:	e9 11 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102ff3 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102ff3:	6a 00                	push   $0x0
  pushl $199
c0102ff5:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102ffa:	e9 05 f8 ff ff       	jmp    c0102804 <__alltraps>

c0102fff <vector200>:
.globl vector200
vector200:
  pushl $0
c0102fff:	6a 00                	push   $0x0
  pushl $200
c0103001:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0103006:	e9 f9 f7 ff ff       	jmp    c0102804 <__alltraps>

c010300b <vector201>:
.globl vector201
vector201:
  pushl $0
c010300b:	6a 00                	push   $0x0
  pushl $201
c010300d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103012:	e9 ed f7 ff ff       	jmp    c0102804 <__alltraps>

c0103017 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103017:	6a 00                	push   $0x0
  pushl $202
c0103019:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010301e:	e9 e1 f7 ff ff       	jmp    c0102804 <__alltraps>

c0103023 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103023:	6a 00                	push   $0x0
  pushl $203
c0103025:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010302a:	e9 d5 f7 ff ff       	jmp    c0102804 <__alltraps>

c010302f <vector204>:
.globl vector204
vector204:
  pushl $0
c010302f:	6a 00                	push   $0x0
  pushl $204
c0103031:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103036:	e9 c9 f7 ff ff       	jmp    c0102804 <__alltraps>

c010303b <vector205>:
.globl vector205
vector205:
  pushl $0
c010303b:	6a 00                	push   $0x0
  pushl $205
c010303d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103042:	e9 bd f7 ff ff       	jmp    c0102804 <__alltraps>

c0103047 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103047:	6a 00                	push   $0x0
  pushl $206
c0103049:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010304e:	e9 b1 f7 ff ff       	jmp    c0102804 <__alltraps>

c0103053 <vector207>:
.globl vector207
vector207:
  pushl $0
c0103053:	6a 00                	push   $0x0
  pushl $207
c0103055:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010305a:	e9 a5 f7 ff ff       	jmp    c0102804 <__alltraps>

c010305f <vector208>:
.globl vector208
vector208:
  pushl $0
c010305f:	6a 00                	push   $0x0
  pushl $208
c0103061:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103066:	e9 99 f7 ff ff       	jmp    c0102804 <__alltraps>

c010306b <vector209>:
.globl vector209
vector209:
  pushl $0
c010306b:	6a 00                	push   $0x0
  pushl $209
c010306d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103072:	e9 8d f7 ff ff       	jmp    c0102804 <__alltraps>

c0103077 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103077:	6a 00                	push   $0x0
  pushl $210
c0103079:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010307e:	e9 81 f7 ff ff       	jmp    c0102804 <__alltraps>

c0103083 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103083:	6a 00                	push   $0x0
  pushl $211
c0103085:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010308a:	e9 75 f7 ff ff       	jmp    c0102804 <__alltraps>

c010308f <vector212>:
.globl vector212
vector212:
  pushl $0
c010308f:	6a 00                	push   $0x0
  pushl $212
c0103091:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103096:	e9 69 f7 ff ff       	jmp    c0102804 <__alltraps>

c010309b <vector213>:
.globl vector213
vector213:
  pushl $0
c010309b:	6a 00                	push   $0x0
  pushl $213
c010309d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01030a2:	e9 5d f7 ff ff       	jmp    c0102804 <__alltraps>

c01030a7 <vector214>:
.globl vector214
vector214:
  pushl $0
c01030a7:	6a 00                	push   $0x0
  pushl $214
c01030a9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01030ae:	e9 51 f7 ff ff       	jmp    c0102804 <__alltraps>

c01030b3 <vector215>:
.globl vector215
vector215:
  pushl $0
c01030b3:	6a 00                	push   $0x0
  pushl $215
c01030b5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01030ba:	e9 45 f7 ff ff       	jmp    c0102804 <__alltraps>

c01030bf <vector216>:
.globl vector216
vector216:
  pushl $0
c01030bf:	6a 00                	push   $0x0
  pushl $216
c01030c1:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01030c6:	e9 39 f7 ff ff       	jmp    c0102804 <__alltraps>

c01030cb <vector217>:
.globl vector217
vector217:
  pushl $0
c01030cb:	6a 00                	push   $0x0
  pushl $217
c01030cd:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01030d2:	e9 2d f7 ff ff       	jmp    c0102804 <__alltraps>

c01030d7 <vector218>:
.globl vector218
vector218:
  pushl $0
c01030d7:	6a 00                	push   $0x0
  pushl $218
c01030d9:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01030de:	e9 21 f7 ff ff       	jmp    c0102804 <__alltraps>

c01030e3 <vector219>:
.globl vector219
vector219:
  pushl $0
c01030e3:	6a 00                	push   $0x0
  pushl $219
c01030e5:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01030ea:	e9 15 f7 ff ff       	jmp    c0102804 <__alltraps>

c01030ef <vector220>:
.globl vector220
vector220:
  pushl $0
c01030ef:	6a 00                	push   $0x0
  pushl $220
c01030f1:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01030f6:	e9 09 f7 ff ff       	jmp    c0102804 <__alltraps>

c01030fb <vector221>:
.globl vector221
vector221:
  pushl $0
c01030fb:	6a 00                	push   $0x0
  pushl $221
c01030fd:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103102:	e9 fd f6 ff ff       	jmp    c0102804 <__alltraps>

c0103107 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103107:	6a 00                	push   $0x0
  pushl $222
c0103109:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010310e:	e9 f1 f6 ff ff       	jmp    c0102804 <__alltraps>

c0103113 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103113:	6a 00                	push   $0x0
  pushl $223
c0103115:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010311a:	e9 e5 f6 ff ff       	jmp    c0102804 <__alltraps>

c010311f <vector224>:
.globl vector224
vector224:
  pushl $0
c010311f:	6a 00                	push   $0x0
  pushl $224
c0103121:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103126:	e9 d9 f6 ff ff       	jmp    c0102804 <__alltraps>

c010312b <vector225>:
.globl vector225
vector225:
  pushl $0
c010312b:	6a 00                	push   $0x0
  pushl $225
c010312d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103132:	e9 cd f6 ff ff       	jmp    c0102804 <__alltraps>

c0103137 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103137:	6a 00                	push   $0x0
  pushl $226
c0103139:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010313e:	e9 c1 f6 ff ff       	jmp    c0102804 <__alltraps>

c0103143 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103143:	6a 00                	push   $0x0
  pushl $227
c0103145:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010314a:	e9 b5 f6 ff ff       	jmp    c0102804 <__alltraps>

c010314f <vector228>:
.globl vector228
vector228:
  pushl $0
c010314f:	6a 00                	push   $0x0
  pushl $228
c0103151:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103156:	e9 a9 f6 ff ff       	jmp    c0102804 <__alltraps>

c010315b <vector229>:
.globl vector229
vector229:
  pushl $0
c010315b:	6a 00                	push   $0x0
  pushl $229
c010315d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103162:	e9 9d f6 ff ff       	jmp    c0102804 <__alltraps>

c0103167 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103167:	6a 00                	push   $0x0
  pushl $230
c0103169:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010316e:	e9 91 f6 ff ff       	jmp    c0102804 <__alltraps>

c0103173 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103173:	6a 00                	push   $0x0
  pushl $231
c0103175:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010317a:	e9 85 f6 ff ff       	jmp    c0102804 <__alltraps>

c010317f <vector232>:
.globl vector232
vector232:
  pushl $0
c010317f:	6a 00                	push   $0x0
  pushl $232
c0103181:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103186:	e9 79 f6 ff ff       	jmp    c0102804 <__alltraps>

c010318b <vector233>:
.globl vector233
vector233:
  pushl $0
c010318b:	6a 00                	push   $0x0
  pushl $233
c010318d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103192:	e9 6d f6 ff ff       	jmp    c0102804 <__alltraps>

c0103197 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103197:	6a 00                	push   $0x0
  pushl $234
c0103199:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010319e:	e9 61 f6 ff ff       	jmp    c0102804 <__alltraps>

c01031a3 <vector235>:
.globl vector235
vector235:
  pushl $0
c01031a3:	6a 00                	push   $0x0
  pushl $235
c01031a5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01031aa:	e9 55 f6 ff ff       	jmp    c0102804 <__alltraps>

c01031af <vector236>:
.globl vector236
vector236:
  pushl $0
c01031af:	6a 00                	push   $0x0
  pushl $236
c01031b1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01031b6:	e9 49 f6 ff ff       	jmp    c0102804 <__alltraps>

c01031bb <vector237>:
.globl vector237
vector237:
  pushl $0
c01031bb:	6a 00                	push   $0x0
  pushl $237
c01031bd:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01031c2:	e9 3d f6 ff ff       	jmp    c0102804 <__alltraps>

c01031c7 <vector238>:
.globl vector238
vector238:
  pushl $0
c01031c7:	6a 00                	push   $0x0
  pushl $238
c01031c9:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01031ce:	e9 31 f6 ff ff       	jmp    c0102804 <__alltraps>

c01031d3 <vector239>:
.globl vector239
vector239:
  pushl $0
c01031d3:	6a 00                	push   $0x0
  pushl $239
c01031d5:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01031da:	e9 25 f6 ff ff       	jmp    c0102804 <__alltraps>

c01031df <vector240>:
.globl vector240
vector240:
  pushl $0
c01031df:	6a 00                	push   $0x0
  pushl $240
c01031e1:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01031e6:	e9 19 f6 ff ff       	jmp    c0102804 <__alltraps>

c01031eb <vector241>:
.globl vector241
vector241:
  pushl $0
c01031eb:	6a 00                	push   $0x0
  pushl $241
c01031ed:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01031f2:	e9 0d f6 ff ff       	jmp    c0102804 <__alltraps>

c01031f7 <vector242>:
.globl vector242
vector242:
  pushl $0
c01031f7:	6a 00                	push   $0x0
  pushl $242
c01031f9:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01031fe:	e9 01 f6 ff ff       	jmp    c0102804 <__alltraps>

c0103203 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103203:	6a 00                	push   $0x0
  pushl $243
c0103205:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010320a:	e9 f5 f5 ff ff       	jmp    c0102804 <__alltraps>

c010320f <vector244>:
.globl vector244
vector244:
  pushl $0
c010320f:	6a 00                	push   $0x0
  pushl $244
c0103211:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103216:	e9 e9 f5 ff ff       	jmp    c0102804 <__alltraps>

c010321b <vector245>:
.globl vector245
vector245:
  pushl $0
c010321b:	6a 00                	push   $0x0
  pushl $245
c010321d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103222:	e9 dd f5 ff ff       	jmp    c0102804 <__alltraps>

c0103227 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103227:	6a 00                	push   $0x0
  pushl $246
c0103229:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010322e:	e9 d1 f5 ff ff       	jmp    c0102804 <__alltraps>

c0103233 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103233:	6a 00                	push   $0x0
  pushl $247
c0103235:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010323a:	e9 c5 f5 ff ff       	jmp    c0102804 <__alltraps>

c010323f <vector248>:
.globl vector248
vector248:
  pushl $0
c010323f:	6a 00                	push   $0x0
  pushl $248
c0103241:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103246:	e9 b9 f5 ff ff       	jmp    c0102804 <__alltraps>

c010324b <vector249>:
.globl vector249
vector249:
  pushl $0
c010324b:	6a 00                	push   $0x0
  pushl $249
c010324d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103252:	e9 ad f5 ff ff       	jmp    c0102804 <__alltraps>

c0103257 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103257:	6a 00                	push   $0x0
  pushl $250
c0103259:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010325e:	e9 a1 f5 ff ff       	jmp    c0102804 <__alltraps>

c0103263 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103263:	6a 00                	push   $0x0
  pushl $251
c0103265:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010326a:	e9 95 f5 ff ff       	jmp    c0102804 <__alltraps>

c010326f <vector252>:
.globl vector252
vector252:
  pushl $0
c010326f:	6a 00                	push   $0x0
  pushl $252
c0103271:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103276:	e9 89 f5 ff ff       	jmp    c0102804 <__alltraps>

c010327b <vector253>:
.globl vector253
vector253:
  pushl $0
c010327b:	6a 00                	push   $0x0
  pushl $253
c010327d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103282:	e9 7d f5 ff ff       	jmp    c0102804 <__alltraps>

c0103287 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103287:	6a 00                	push   $0x0
  pushl $254
c0103289:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010328e:	e9 71 f5 ff ff       	jmp    c0102804 <__alltraps>

c0103293 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103293:	6a 00                	push   $0x0
  pushl $255
c0103295:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010329a:	e9 65 f5 ff ff       	jmp    c0102804 <__alltraps>

c010329f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010329f:	55                   	push   %ebp
c01032a0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01032a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01032a5:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01032aa:	29 c2                	sub    %eax,%edx
c01032ac:	89 d0                	mov    %edx,%eax
c01032ae:	c1 f8 05             	sar    $0x5,%eax
}
c01032b1:	5d                   	pop    %ebp
c01032b2:	c3                   	ret    

c01032b3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01032b3:	55                   	push   %ebp
c01032b4:	89 e5                	mov    %esp,%ebp
c01032b6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01032b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01032bc:	89 04 24             	mov    %eax,(%esp)
c01032bf:	e8 db ff ff ff       	call   c010329f <page2ppn>
c01032c4:	c1 e0 0c             	shl    $0xc,%eax
}
c01032c7:	c9                   	leave  
c01032c8:	c3                   	ret    

c01032c9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01032c9:	55                   	push   %ebp
c01032ca:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01032cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01032cf:	8b 00                	mov    (%eax),%eax
}
c01032d1:	5d                   	pop    %ebp
c01032d2:	c3                   	ret    

c01032d3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01032d3:	55                   	push   %ebp
c01032d4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01032d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01032d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032dc:	89 10                	mov    %edx,(%eax)
}
c01032de:	5d                   	pop    %ebp
c01032df:	c3                   	ret    

c01032e0 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01032e0:	55                   	push   %ebp
c01032e1:	89 e5                	mov    %esp,%ebp
c01032e3:	83 ec 10             	sub    $0x10,%esp
c01032e6:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032f3:	89 50 04             	mov    %edx,0x4(%eax)
c01032f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032f9:	8b 50 04             	mov    0x4(%eax),%edx
c01032fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032ff:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103301:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103308:	00 00 00 
}
c010330b:	c9                   	leave  
c010330c:	c3                   	ret    

c010330d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010330d:	55                   	push   %ebp
c010330e:	89 e5                	mov    %esp,%ebp
c0103310:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103313:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103317:	75 24                	jne    c010333d <default_init_memmap+0x30>
c0103319:	c7 44 24 0c b0 a6 10 	movl   $0xc010a6b0,0xc(%esp)
c0103320:	c0 
c0103321:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103328:	c0 
c0103329:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103330:	00 
c0103331:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103338:	e8 bb d9 ff ff       	call   c0100cf8 <__panic>
    struct Page *p = base;
c010333d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103340:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103343:	eb 7d                	jmp    c01033c2 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103345:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103348:	83 c0 04             	add    $0x4,%eax
c010334b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103352:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103355:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103358:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010335b:	0f a3 10             	bt     %edx,(%eax)
c010335e:	19 c0                	sbb    %eax,%eax
c0103360:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103363:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103367:	0f 95 c0             	setne  %al
c010336a:	0f b6 c0             	movzbl %al,%eax
c010336d:	85 c0                	test   %eax,%eax
c010336f:	75 24                	jne    c0103395 <default_init_memmap+0x88>
c0103371:	c7 44 24 0c e1 a6 10 	movl   $0xc010a6e1,0xc(%esp)
c0103378:	c0 
c0103379:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103380:	c0 
c0103381:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103388:	00 
c0103389:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103390:	e8 63 d9 ff ff       	call   c0100cf8 <__panic>
        p->flags = p->property = 0;
c0103395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103398:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a2:	8b 50 08             	mov    0x8(%eax),%edx
c01033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a8:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01033ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01033b2:	00 
c01033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b6:	89 04 24             	mov    %eax,(%esp)
c01033b9:	e8 15 ff ff ff       	call   c01032d3 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01033be:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01033c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033c5:	c1 e0 05             	shl    $0x5,%eax
c01033c8:	89 c2                	mov    %eax,%edx
c01033ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01033cd:	01 d0                	add    %edx,%eax
c01033cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01033d2:	0f 85 6d ff ff ff    	jne    c0103345 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01033d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01033db:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033de:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01033e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01033e4:	83 c0 04             	add    $0x4,%eax
c01033e7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01033ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01033f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01033f7:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01033fa:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c0103400:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103403:	01 d0                	add    %edx,%eax
c0103405:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    list_add(&free_list, &(base->page_link));
c010340a:	8b 45 08             	mov    0x8(%ebp),%eax
c010340d:	83 c0 0c             	add    $0xc,%eax
c0103410:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c0103417:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010341a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010341d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103420:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103423:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103426:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103429:	8b 40 04             	mov    0x4(%eax),%eax
c010342c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010342f:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103432:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103435:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103438:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010343b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010343e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103441:	89 10                	mov    %edx,(%eax)
c0103443:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103446:	8b 10                	mov    (%eax),%edx
c0103448:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010344b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010344e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103451:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103454:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103457:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010345a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010345d:	89 10                	mov    %edx,(%eax)
}
c010345f:	c9                   	leave  
c0103460:	c3                   	ret    

c0103461 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103461:	55                   	push   %ebp
c0103462:	89 e5                	mov    %esp,%ebp
c0103464:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103467:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010346b:	75 24                	jne    c0103491 <default_alloc_pages+0x30>
c010346d:	c7 44 24 0c b0 a6 10 	movl   $0xc010a6b0,0xc(%esp)
c0103474:	c0 
c0103475:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c010347c:	c0 
c010347d:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0103484:	00 
c0103485:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c010348c:	e8 67 d8 ff ff       	call   c0100cf8 <__panic>
    if (n > nr_free) {
c0103491:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103496:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103499:	73 0a                	jae    c01034a5 <default_alloc_pages+0x44>
        return NULL;
c010349b:	b8 00 00 00 00       	mov    $0x0,%eax
c01034a0:	e9 4d 01 00 00       	jmp    c01035f2 <default_alloc_pages+0x191>
    }
    struct Page *page = NULL;
c01034a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01034ac:	c7 45 f0 18 7b 12 c0 	movl   $0xc0127b18,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01034b3:	eb 1c                	jmp    c01034d1 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01034b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034b8:	83 e8 0c             	sub    $0xc,%eax
c01034bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01034be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034c1:	8b 40 08             	mov    0x8(%eax),%eax
c01034c4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034c7:	72 08                	jb     c01034d1 <default_alloc_pages+0x70>
            page = p;
c01034c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01034cf:	eb 18                	jmp    c01034e9 <default_alloc_pages+0x88>
c01034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034da:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01034dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034e0:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c01034e7:	75 cc                	jne    c01034b5 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if(page != NULL){
c01034e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034ed:	0f 84 fc 00 00 00    	je     c01035ef <default_alloc_pages+0x18e>
c01034f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01034f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034fc:	8b 00                	mov    (%eax),%eax
        le = list_prev(le);
c01034fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(page->property > n){
c0103501:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103504:	8b 40 08             	mov    0x8(%eax),%eax
c0103507:	3b 45 08             	cmp    0x8(%ebp),%eax
c010350a:	0f 86 8e 00 00 00    	jbe    c010359e <default_alloc_pages+0x13d>
            struct Page *p = page + n;
c0103510:	8b 45 08             	mov    0x8(%ebp),%eax
c0103513:	c1 e0 05             	shl    $0x5,%eax
c0103516:	89 c2                	mov    %eax,%edx
c0103518:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010351b:	01 d0                	add    %edx,%eax
c010351d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            SetPageProperty(p);
c0103520:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103523:	83 c0 04             	add    $0x4,%eax
c0103526:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c010352d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103530:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103533:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103536:	0f ab 10             	bts    %edx,(%eax)
            p->property = page->property - n;
c0103539:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010353c:	8b 40 08             	mov    0x8(%eax),%eax
c010353f:	2b 45 08             	sub    0x8(%ebp),%eax
c0103542:	89 c2                	mov    %eax,%edx
c0103544:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103547:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(le, &(p->page_link));
c010354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010354d:	8d 50 0c             	lea    0xc(%eax),%edx
c0103550:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103553:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103556:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010355c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010355f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103562:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103565:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103568:	8b 40 04             	mov    0x4(%eax),%eax
c010356b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010356e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0103571:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103574:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103577:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010357a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010357d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103580:	89 10                	mov    %edx,(%eax)
c0103582:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103585:	8b 10                	mov    (%eax),%edx
c0103587:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010358a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010358d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103590:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103593:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103596:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103599:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010359c:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c010359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a1:	83 c0 0c             	add    $0xc,%eax
c01035a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01035a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01035aa:	8b 40 04             	mov    0x4(%eax),%eax
c01035ad:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01035b0:	8b 12                	mov    (%edx),%edx
c01035b2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01035b5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035bb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01035be:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035c1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035c4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01035c7:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01035c9:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01035ce:	2b 45 08             	sub    0x8(%ebp),%eax
c01035d1:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
        ClearPageProperty(page);
c01035d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d9:	83 c0 04             	add    $0x4,%eax
c01035dc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035e6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035e9:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035ec:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c01035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01035f2:	c9                   	leave  
c01035f3:	c3                   	ret    

c01035f4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01035f4:	55                   	push   %ebp
c01035f5:	89 e5                	mov    %esp,%ebp
c01035f7:	81 ec 88 00 00 00    	sub    $0x88,%esp
    struct Page *p = base;
c01035fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103600:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103603:	e9 9d 00 00 00       	jmp    c01036a5 <default_free_pages+0xb1>
        assert(!PageReserved(p) && !PageProperty(p));
c0103608:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010360b:	83 c0 04             	add    $0x4,%eax
c010360e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103615:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103618:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010361b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010361e:	0f a3 10             	bt     %edx,(%eax)
c0103621:	19 c0                	sbb    %eax,%eax
c0103623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103626:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010362a:	0f 95 c0             	setne  %al
c010362d:	0f b6 c0             	movzbl %al,%eax
c0103630:	85 c0                	test   %eax,%eax
c0103632:	75 2c                	jne    c0103660 <default_free_pages+0x6c>
c0103634:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103637:	83 c0 04             	add    $0x4,%eax
c010363a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103641:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103644:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103647:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010364a:	0f a3 10             	bt     %edx,(%eax)
c010364d:	19 c0                	sbb    %eax,%eax
c010364f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0103652:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103656:	0f 95 c0             	setne  %al
c0103659:	0f b6 c0             	movzbl %al,%eax
c010365c:	85 c0                	test   %eax,%eax
c010365e:	74 24                	je     c0103684 <default_free_pages+0x90>
c0103660:	c7 44 24 0c f4 a6 10 	movl   $0xc010a6f4,0xc(%esp)
c0103667:	c0 
c0103668:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c010366f:	c0 
c0103670:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0103677:	00 
c0103678:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c010367f:	e8 74 d6 ff ff       	call   c0100cf8 <__panic>
        p->flags = 0;
c0103684:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103687:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010368e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103695:	00 
c0103696:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103699:	89 04 24             	mov    %eax,(%esp)
c010369c:	e8 32 fc ff ff       	call   c01032d3 <set_page_ref>
}

static void
default_free_pages(struct Page *base, size_t n) {
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01036a1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01036a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036a8:	c1 e0 05             	shl    $0x5,%eax
c01036ab:	89 c2                	mov    %eax,%edx
c01036ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b0:	01 d0                	add    %edx,%eax
c01036b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036b5:	0f 85 4d ff ff ff    	jne    c0103608 <default_free_pages+0x14>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01036bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01036be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036c1:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01036c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c7:	83 c0 04             	add    $0x4,%eax
c01036ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01036d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036da:	0f ab 10             	bts    %edx,(%eax)
c01036dd:	c7 45 cc 18 7b 12 c0 	movl   $0xc0127b18,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01036e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01036e7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01036ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01036ed:	e9 18 01 00 00       	jmp    c010380a <default_free_pages+0x216>
        p = le2page(le, page_link);
c01036f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f5:	83 e8 0c             	sub    $0xc,%eax
c01036f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c01036fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01036fe:	8b 40 08             	mov    0x8(%eax),%eax
c0103701:	c1 e0 05             	shl    $0x5,%eax
c0103704:	89 c2                	mov    %eax,%edx
c0103706:	8b 45 08             	mov    0x8(%ebp),%eax
c0103709:	01 d0                	add    %edx,%eax
c010370b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010370e:	75 6c                	jne    c010377c <default_free_pages+0x188>
            base->property += p->property;
c0103710:	8b 45 08             	mov    0x8(%ebp),%eax
c0103713:	8b 50 08             	mov    0x8(%eax),%edx
c0103716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103719:	8b 40 08             	mov    0x8(%eax),%eax
c010371c:	01 c2                	add    %eax,%edx
c010371e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103721:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0103724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103727:	83 c0 04             	add    $0x4,%eax
c010372a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103731:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103734:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103737:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010373a:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c010373d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103740:	83 c0 0c             	add    $0xc,%eax
c0103743:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103746:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103749:	8b 40 04             	mov    0x4(%eax),%eax
c010374c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010374f:	8b 12                	mov    (%edx),%edx
c0103751:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103754:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103757:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010375a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010375d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103760:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103763:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103766:	89 10                	mov    %edx,(%eax)
c0103768:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010376b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010376e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103771:	8b 40 04             	mov    0x4(%eax),%eax
            le = list_next(le);
c0103774:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
c0103777:	e9 9b 00 00 00       	jmp    c0103817 <default_free_pages+0x223>
        }
        else if (p + p->property == base) {
c010377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377f:	8b 40 08             	mov    0x8(%eax),%eax
c0103782:	c1 e0 05             	shl    $0x5,%eax
c0103785:	89 c2                	mov    %eax,%edx
c0103787:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010378a:	01 d0                	add    %edx,%eax
c010378c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010378f:	75 60                	jne    c01037f1 <default_free_pages+0x1fd>
            p->property += base->property;
c0103791:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103794:	8b 50 08             	mov    0x8(%eax),%edx
c0103797:	8b 45 08             	mov    0x8(%ebp),%eax
c010379a:	8b 40 08             	mov    0x8(%eax),%eax
c010379d:	01 c2                	add    %eax,%edx
c010379f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037a2:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01037a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01037a8:	83 c0 04             	add    $0x4,%eax
c01037ab:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01037b2:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01037b5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01037b8:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01037bb:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c01037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c1:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c7:	83 c0 0c             	add    $0xc,%eax
c01037ca:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01037cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037d0:	8b 40 04             	mov    0x4(%eax),%eax
c01037d3:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01037d6:	8b 12                	mov    (%edx),%edx
c01037d8:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01037db:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01037de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01037e1:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037e4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037e7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01037ea:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01037ed:	89 10                	mov    %edx,(%eax)
c01037ef:	eb 0a                	jmp    c01037fb <default_free_pages+0x207>
        }
        else if(p > base){
c01037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037f7:	76 02                	jbe    c01037fb <default_free_pages+0x207>
            break;
c01037f9:	eb 1c                	jmp    c0103817 <default_free_pages+0x223>
c01037fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037fe:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103801:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103804:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0103807:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c010380a:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c0103811:	0f 85 db fe ff ff    	jne    c01036f2 <default_free_pages+0xfe>
        else if(p > base){
            break;
        }
        le = list_next(le);
    }
    nr_free += n;
c0103817:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c010381d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103820:	01 d0                	add    %edx,%eax
c0103822:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    list_add_before(le, &(base->page_link));
c0103827:	8b 45 08             	mov    0x8(%ebp),%eax
c010382a:	8d 50 0c             	lea    0xc(%eax),%edx
c010382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103830:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103833:	89 55 94             	mov    %edx,-0x6c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103836:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103839:	8b 00                	mov    (%eax),%eax
c010383b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010383e:	89 55 90             	mov    %edx,-0x70(%ebp)
c0103841:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0103844:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103847:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010384a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010384d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103850:	89 10                	mov    %edx,(%eax)
c0103852:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103855:	8b 10                	mov    (%eax),%edx
c0103857:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010385a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010385d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103860:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103863:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103866:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103869:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010386c:	89 10                	mov    %edx,(%eax)
}
c010386e:	c9                   	leave  
c010386f:	c3                   	ret    

c0103870 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103870:	55                   	push   %ebp
c0103871:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103873:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c0103878:	5d                   	pop    %ebp
c0103879:	c3                   	ret    

c010387a <basic_check>:

static void
basic_check(void) {
c010387a:	55                   	push   %ebp
c010387b:	89 e5                	mov    %esp,%ebp
c010387d:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103887:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010388a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010388d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103890:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103893:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010389a:	e8 c4 15 00 00       	call   c0104e63 <alloc_pages>
c010389f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01038a6:	75 24                	jne    c01038cc <basic_check+0x52>
c01038a8:	c7 44 24 0c 19 a7 10 	movl   $0xc010a719,0xc(%esp)
c01038af:	c0 
c01038b0:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01038b7:	c0 
c01038b8:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c01038bf:	00 
c01038c0:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01038c7:	e8 2c d4 ff ff       	call   c0100cf8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01038cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038d3:	e8 8b 15 00 00       	call   c0104e63 <alloc_pages>
c01038d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038df:	75 24                	jne    c0103905 <basic_check+0x8b>
c01038e1:	c7 44 24 0c 35 a7 10 	movl   $0xc010a735,0xc(%esp)
c01038e8:	c0 
c01038e9:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01038f0:	c0 
c01038f1:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01038f8:	00 
c01038f9:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103900:	e8 f3 d3 ff ff       	call   c0100cf8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103905:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010390c:	e8 52 15 00 00       	call   c0104e63 <alloc_pages>
c0103911:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103918:	75 24                	jne    c010393e <basic_check+0xc4>
c010391a:	c7 44 24 0c 51 a7 10 	movl   $0xc010a751,0xc(%esp)
c0103921:	c0 
c0103922:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103929:	c0 
c010392a:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0103931:	00 
c0103932:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103939:	e8 ba d3 ff ff       	call   c0100cf8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103941:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103944:	74 10                	je     c0103956 <basic_check+0xdc>
c0103946:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103949:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010394c:	74 08                	je     c0103956 <basic_check+0xdc>
c010394e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103951:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103954:	75 24                	jne    c010397a <basic_check+0x100>
c0103956:	c7 44 24 0c 70 a7 10 	movl   $0xc010a770,0xc(%esp)
c010395d:	c0 
c010395e:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103965:	c0 
c0103966:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c010396d:	00 
c010396e:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103975:	e8 7e d3 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010397a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010397d:	89 04 24             	mov    %eax,(%esp)
c0103980:	e8 44 f9 ff ff       	call   c01032c9 <page_ref>
c0103985:	85 c0                	test   %eax,%eax
c0103987:	75 1e                	jne    c01039a7 <basic_check+0x12d>
c0103989:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010398c:	89 04 24             	mov    %eax,(%esp)
c010398f:	e8 35 f9 ff ff       	call   c01032c9 <page_ref>
c0103994:	85 c0                	test   %eax,%eax
c0103996:	75 0f                	jne    c01039a7 <basic_check+0x12d>
c0103998:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010399b:	89 04 24             	mov    %eax,(%esp)
c010399e:	e8 26 f9 ff ff       	call   c01032c9 <page_ref>
c01039a3:	85 c0                	test   %eax,%eax
c01039a5:	74 24                	je     c01039cb <basic_check+0x151>
c01039a7:	c7 44 24 0c 94 a7 10 	movl   $0xc010a794,0xc(%esp)
c01039ae:	c0 
c01039af:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01039b6:	c0 
c01039b7:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c01039be:	00 
c01039bf:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01039c6:	e8 2d d3 ff ff       	call   c0100cf8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01039cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039ce:	89 04 24             	mov    %eax,(%esp)
c01039d1:	e8 dd f8 ff ff       	call   c01032b3 <page2pa>
c01039d6:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01039dc:	c1 e2 0c             	shl    $0xc,%edx
c01039df:	39 d0                	cmp    %edx,%eax
c01039e1:	72 24                	jb     c0103a07 <basic_check+0x18d>
c01039e3:	c7 44 24 0c d0 a7 10 	movl   $0xc010a7d0,0xc(%esp)
c01039ea:	c0 
c01039eb:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01039f2:	c0 
c01039f3:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01039fa:	00 
c01039fb:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103a02:	e8 f1 d2 ff ff       	call   c0100cf8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a0a:	89 04 24             	mov    %eax,(%esp)
c0103a0d:	e8 a1 f8 ff ff       	call   c01032b3 <page2pa>
c0103a12:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103a18:	c1 e2 0c             	shl    $0xc,%edx
c0103a1b:	39 d0                	cmp    %edx,%eax
c0103a1d:	72 24                	jb     c0103a43 <basic_check+0x1c9>
c0103a1f:	c7 44 24 0c ed a7 10 	movl   $0xc010a7ed,0xc(%esp)
c0103a26:	c0 
c0103a27:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103a2e:	c0 
c0103a2f:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0103a36:	00 
c0103a37:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103a3e:	e8 b5 d2 ff ff       	call   c0100cf8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a46:	89 04 24             	mov    %eax,(%esp)
c0103a49:	e8 65 f8 ff ff       	call   c01032b3 <page2pa>
c0103a4e:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103a54:	c1 e2 0c             	shl    $0xc,%edx
c0103a57:	39 d0                	cmp    %edx,%eax
c0103a59:	72 24                	jb     c0103a7f <basic_check+0x205>
c0103a5b:	c7 44 24 0c 0a a8 10 	movl   $0xc010a80a,0xc(%esp)
c0103a62:	c0 
c0103a63:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103a6a:	c0 
c0103a6b:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103a72:	00 
c0103a73:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103a7a:	e8 79 d2 ff ff       	call   c0100cf8 <__panic>

    list_entry_t free_list_store = free_list;
c0103a7f:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103a84:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103a8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a8d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a90:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a9d:	89 50 04             	mov    %edx,0x4(%eax)
c0103aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103aa3:	8b 50 04             	mov    0x4(%eax),%edx
c0103aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103aa9:	89 10                	mov    %edx,(%eax)
c0103aab:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103ab2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ab5:	8b 40 04             	mov    0x4(%eax),%eax
c0103ab8:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103abb:	0f 94 c0             	sete   %al
c0103abe:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ac1:	85 c0                	test   %eax,%eax
c0103ac3:	75 24                	jne    c0103ae9 <basic_check+0x26f>
c0103ac5:	c7 44 24 0c 27 a8 10 	movl   $0xc010a827,0xc(%esp)
c0103acc:	c0 
c0103acd:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103ad4:	c0 
c0103ad5:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0103adc:	00 
c0103add:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103ae4:	e8 0f d2 ff ff       	call   c0100cf8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103ae9:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103aee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103af1:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103af8:	00 00 00 

    assert(alloc_page() == NULL);
c0103afb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b02:	e8 5c 13 00 00       	call   c0104e63 <alloc_pages>
c0103b07:	85 c0                	test   %eax,%eax
c0103b09:	74 24                	je     c0103b2f <basic_check+0x2b5>
c0103b0b:	c7 44 24 0c 3e a8 10 	movl   $0xc010a83e,0xc(%esp)
c0103b12:	c0 
c0103b13:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103b1a:	c0 
c0103b1b:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0103b22:	00 
c0103b23:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103b2a:	e8 c9 d1 ff ff       	call   c0100cf8 <__panic>

    free_page(p0);
c0103b2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b36:	00 
c0103b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3a:	89 04 24             	mov    %eax,(%esp)
c0103b3d:	e8 8c 13 00 00       	call   c0104ece <free_pages>
    free_page(p1);
c0103b42:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b49:	00 
c0103b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b4d:	89 04 24             	mov    %eax,(%esp)
c0103b50:	e8 79 13 00 00       	call   c0104ece <free_pages>
    free_page(p2);
c0103b55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b5c:	00 
c0103b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b60:	89 04 24             	mov    %eax,(%esp)
c0103b63:	e8 66 13 00 00       	call   c0104ece <free_pages>
    assert(nr_free == 3);
c0103b68:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103b6d:	83 f8 03             	cmp    $0x3,%eax
c0103b70:	74 24                	je     c0103b96 <basic_check+0x31c>
c0103b72:	c7 44 24 0c 53 a8 10 	movl   $0xc010a853,0xc(%esp)
c0103b79:	c0 
c0103b7a:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103b81:	c0 
c0103b82:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103b89:	00 
c0103b8a:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103b91:	e8 62 d1 ff ff       	call   c0100cf8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b9d:	e8 c1 12 00 00       	call   c0104e63 <alloc_pages>
c0103ba2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ba5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103ba9:	75 24                	jne    c0103bcf <basic_check+0x355>
c0103bab:	c7 44 24 0c 19 a7 10 	movl   $0xc010a719,0xc(%esp)
c0103bb2:	c0 
c0103bb3:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103bba:	c0 
c0103bbb:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103bc2:	00 
c0103bc3:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103bca:	e8 29 d1 ff ff       	call   c0100cf8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103bcf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bd6:	e8 88 12 00 00       	call   c0104e63 <alloc_pages>
c0103bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103be2:	75 24                	jne    c0103c08 <basic_check+0x38e>
c0103be4:	c7 44 24 0c 35 a7 10 	movl   $0xc010a735,0xc(%esp)
c0103beb:	c0 
c0103bec:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103bf3:	c0 
c0103bf4:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103bfb:	00 
c0103bfc:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103c03:	e8 f0 d0 ff ff       	call   c0100cf8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c0f:	e8 4f 12 00 00       	call   c0104e63 <alloc_pages>
c0103c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c1b:	75 24                	jne    c0103c41 <basic_check+0x3c7>
c0103c1d:	c7 44 24 0c 51 a7 10 	movl   $0xc010a751,0xc(%esp)
c0103c24:	c0 
c0103c25:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103c2c:	c0 
c0103c2d:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103c34:	00 
c0103c35:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103c3c:	e8 b7 d0 ff ff       	call   c0100cf8 <__panic>

    assert(alloc_page() == NULL);
c0103c41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c48:	e8 16 12 00 00       	call   c0104e63 <alloc_pages>
c0103c4d:	85 c0                	test   %eax,%eax
c0103c4f:	74 24                	je     c0103c75 <basic_check+0x3fb>
c0103c51:	c7 44 24 0c 3e a8 10 	movl   $0xc010a83e,0xc(%esp)
c0103c58:	c0 
c0103c59:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103c60:	c0 
c0103c61:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103c68:	00 
c0103c69:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103c70:	e8 83 d0 ff ff       	call   c0100cf8 <__panic>

    free_page(p0);
c0103c75:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c7c:	00 
c0103c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c80:	89 04 24             	mov    %eax,(%esp)
c0103c83:	e8 46 12 00 00       	call   c0104ece <free_pages>
c0103c88:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103c8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c92:	8b 40 04             	mov    0x4(%eax),%eax
c0103c95:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c98:	0f 94 c0             	sete   %al
c0103c9b:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c9e:	85 c0                	test   %eax,%eax
c0103ca0:	74 24                	je     c0103cc6 <basic_check+0x44c>
c0103ca2:	c7 44 24 0c 60 a8 10 	movl   $0xc010a860,0xc(%esp)
c0103ca9:	c0 
c0103caa:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103cb1:	c0 
c0103cb2:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103cb9:	00 
c0103cba:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103cc1:	e8 32 d0 ff ff       	call   c0100cf8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103cc6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ccd:	e8 91 11 00 00       	call   c0104e63 <alloc_pages>
c0103cd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cdb:	74 24                	je     c0103d01 <basic_check+0x487>
c0103cdd:	c7 44 24 0c 78 a8 10 	movl   $0xc010a878,0xc(%esp)
c0103ce4:	c0 
c0103ce5:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103cec:	c0 
c0103ced:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103cf4:	00 
c0103cf5:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103cfc:	e8 f7 cf ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c0103d01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d08:	e8 56 11 00 00       	call   c0104e63 <alloc_pages>
c0103d0d:	85 c0                	test   %eax,%eax
c0103d0f:	74 24                	je     c0103d35 <basic_check+0x4bb>
c0103d11:	c7 44 24 0c 3e a8 10 	movl   $0xc010a83e,0xc(%esp)
c0103d18:	c0 
c0103d19:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103d20:	c0 
c0103d21:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0103d28:	00 
c0103d29:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103d30:	e8 c3 cf ff ff       	call   c0100cf8 <__panic>

    assert(nr_free == 0);
c0103d35:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103d3a:	85 c0                	test   %eax,%eax
c0103d3c:	74 24                	je     c0103d62 <basic_check+0x4e8>
c0103d3e:	c7 44 24 0c 91 a8 10 	movl   $0xc010a891,0xc(%esp)
c0103d45:	c0 
c0103d46:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103d4d:	c0 
c0103d4e:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103d55:	00 
c0103d56:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103d5d:	e8 96 cf ff ff       	call   c0100cf8 <__panic>
    free_list = free_list_store;
c0103d62:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d68:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103d6d:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d76:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103d7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d82:	00 
c0103d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d86:	89 04 24             	mov    %eax,(%esp)
c0103d89:	e8 40 11 00 00       	call   c0104ece <free_pages>
    free_page(p1);
c0103d8e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d95:	00 
c0103d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d99:	89 04 24             	mov    %eax,(%esp)
c0103d9c:	e8 2d 11 00 00       	call   c0104ece <free_pages>
    free_page(p2);
c0103da1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103da8:	00 
c0103da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dac:	89 04 24             	mov    %eax,(%esp)
c0103daf:	e8 1a 11 00 00       	call   c0104ece <free_pages>
}
c0103db4:	c9                   	leave  
c0103db5:	c3                   	ret    

c0103db6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103db6:	55                   	push   %ebp
c0103db7:	89 e5                	mov    %esp,%ebp
c0103db9:	53                   	push   %ebx
c0103dba:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103dc7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103dce:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103dd5:	eb 6b                	jmp    c0103e42 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dda:	83 e8 0c             	sub    $0xc,%eax
c0103ddd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103de3:	83 c0 04             	add    $0x4,%eax
c0103de6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103ded:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103df0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103df3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103df6:	0f a3 10             	bt     %edx,(%eax)
c0103df9:	19 c0                	sbb    %eax,%eax
c0103dfb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103dfe:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103e02:	0f 95 c0             	setne  %al
c0103e05:	0f b6 c0             	movzbl %al,%eax
c0103e08:	85 c0                	test   %eax,%eax
c0103e0a:	75 24                	jne    c0103e30 <default_check+0x7a>
c0103e0c:	c7 44 24 0c 9e a8 10 	movl   $0xc010a89e,0xc(%esp)
c0103e13:	c0 
c0103e14:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103e1b:	c0 
c0103e1c:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103e23:	00 
c0103e24:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103e2b:	e8 c8 ce ff ff       	call   c0100cf8 <__panic>
        count ++, total += p->property;
c0103e30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e37:	8b 50 08             	mov    0x8(%eax),%edx
c0103e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e3d:	01 d0                	add    %edx,%eax
c0103e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e45:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e4b:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e51:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103e58:	0f 85 79 ff ff ff    	jne    c0103dd7 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e5e:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e61:	e8 9a 10 00 00       	call   c0104f00 <nr_free_pages>
c0103e66:	39 c3                	cmp    %eax,%ebx
c0103e68:	74 24                	je     c0103e8e <default_check+0xd8>
c0103e6a:	c7 44 24 0c ae a8 10 	movl   $0xc010a8ae,0xc(%esp)
c0103e71:	c0 
c0103e72:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103e79:	c0 
c0103e7a:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103e81:	00 
c0103e82:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103e89:	e8 6a ce ff ff       	call   c0100cf8 <__panic>

    basic_check();
c0103e8e:	e8 e7 f9 ff ff       	call   c010387a <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e93:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e9a:	e8 c4 0f 00 00       	call   c0104e63 <alloc_pages>
c0103e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ea6:	75 24                	jne    c0103ecc <default_check+0x116>
c0103ea8:	c7 44 24 0c c7 a8 10 	movl   $0xc010a8c7,0xc(%esp)
c0103eaf:	c0 
c0103eb0:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103eb7:	c0 
c0103eb8:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103ebf:	00 
c0103ec0:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103ec7:	e8 2c ce ff ff       	call   c0100cf8 <__panic>
    assert(!PageProperty(p0));
c0103ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ecf:	83 c0 04             	add    $0x4,%eax
c0103ed2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103ed9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103edc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103edf:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103ee2:	0f a3 10             	bt     %edx,(%eax)
c0103ee5:	19 c0                	sbb    %eax,%eax
c0103ee7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103eea:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103eee:	0f 95 c0             	setne  %al
c0103ef1:	0f b6 c0             	movzbl %al,%eax
c0103ef4:	85 c0                	test   %eax,%eax
c0103ef6:	74 24                	je     c0103f1c <default_check+0x166>
c0103ef8:	c7 44 24 0c d2 a8 10 	movl   $0xc010a8d2,0xc(%esp)
c0103eff:	c0 
c0103f00:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103f07:	c0 
c0103f08:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103f0f:	00 
c0103f10:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103f17:	e8 dc cd ff ff       	call   c0100cf8 <__panic>

    list_entry_t free_list_store = free_list;
c0103f1c:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103f21:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103f27:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103f2a:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103f2d:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f34:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f37:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f3a:	89 50 04             	mov    %edx,0x4(%eax)
c0103f3d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f40:	8b 50 04             	mov    0x4(%eax),%edx
c0103f43:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f46:	89 10                	mov    %edx,(%eax)
c0103f48:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103f4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f52:	8b 40 04             	mov    0x4(%eax),%eax
c0103f55:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f58:	0f 94 c0             	sete   %al
c0103f5b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f5e:	85 c0                	test   %eax,%eax
c0103f60:	75 24                	jne    c0103f86 <default_check+0x1d0>
c0103f62:	c7 44 24 0c 27 a8 10 	movl   $0xc010a827,0xc(%esp)
c0103f69:	c0 
c0103f6a:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103f71:	c0 
c0103f72:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103f79:	00 
c0103f7a:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103f81:	e8 72 cd ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c0103f86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f8d:	e8 d1 0e 00 00       	call   c0104e63 <alloc_pages>
c0103f92:	85 c0                	test   %eax,%eax
c0103f94:	74 24                	je     c0103fba <default_check+0x204>
c0103f96:	c7 44 24 0c 3e a8 10 	movl   $0xc010a83e,0xc(%esp)
c0103f9d:	c0 
c0103f9e:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0103fa5:	c0 
c0103fa6:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103fad:	00 
c0103fae:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0103fb5:	e8 3e cd ff ff       	call   c0100cf8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103fba:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103fbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103fc2:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103fc9:	00 00 00 

    free_pages(p0 + 2, 3);
c0103fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fcf:	83 c0 40             	add    $0x40,%eax
c0103fd2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103fd9:	00 
c0103fda:	89 04 24             	mov    %eax,(%esp)
c0103fdd:	e8 ec 0e 00 00       	call   c0104ece <free_pages>
    assert(alloc_pages(4) == NULL);
c0103fe2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103fe9:	e8 75 0e 00 00       	call   c0104e63 <alloc_pages>
c0103fee:	85 c0                	test   %eax,%eax
c0103ff0:	74 24                	je     c0104016 <default_check+0x260>
c0103ff2:	c7 44 24 0c e4 a8 10 	movl   $0xc010a8e4,0xc(%esp)
c0103ff9:	c0 
c0103ffa:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104001:	c0 
c0104002:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104009:	00 
c010400a:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104011:	e8 e2 cc ff ff       	call   c0100cf8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104019:	83 c0 40             	add    $0x40,%eax
c010401c:	83 c0 04             	add    $0x4,%eax
c010401f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104026:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104029:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010402c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010402f:	0f a3 10             	bt     %edx,(%eax)
c0104032:	19 c0                	sbb    %eax,%eax
c0104034:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104037:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010403b:	0f 95 c0             	setne  %al
c010403e:	0f b6 c0             	movzbl %al,%eax
c0104041:	85 c0                	test   %eax,%eax
c0104043:	74 0e                	je     c0104053 <default_check+0x29d>
c0104045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104048:	83 c0 40             	add    $0x40,%eax
c010404b:	8b 40 08             	mov    0x8(%eax),%eax
c010404e:	83 f8 03             	cmp    $0x3,%eax
c0104051:	74 24                	je     c0104077 <default_check+0x2c1>
c0104053:	c7 44 24 0c fc a8 10 	movl   $0xc010a8fc,0xc(%esp)
c010405a:	c0 
c010405b:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104062:	c0 
c0104063:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010406a:	00 
c010406b:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104072:	e8 81 cc ff ff       	call   c0100cf8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104077:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010407e:	e8 e0 0d 00 00       	call   c0104e63 <alloc_pages>
c0104083:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104086:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010408a:	75 24                	jne    c01040b0 <default_check+0x2fa>
c010408c:	c7 44 24 0c 28 a9 10 	movl   $0xc010a928,0xc(%esp)
c0104093:	c0 
c0104094:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c010409b:	c0 
c010409c:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01040a3:	00 
c01040a4:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01040ab:	e8 48 cc ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c01040b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040b7:	e8 a7 0d 00 00       	call   c0104e63 <alloc_pages>
c01040bc:	85 c0                	test   %eax,%eax
c01040be:	74 24                	je     c01040e4 <default_check+0x32e>
c01040c0:	c7 44 24 0c 3e a8 10 	movl   $0xc010a83e,0xc(%esp)
c01040c7:	c0 
c01040c8:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01040cf:	c0 
c01040d0:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c01040d7:	00 
c01040d8:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01040df:	e8 14 cc ff ff       	call   c0100cf8 <__panic>
    assert(p0 + 2 == p1);
c01040e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040e7:	83 c0 40             	add    $0x40,%eax
c01040ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040ed:	74 24                	je     c0104113 <default_check+0x35d>
c01040ef:	c7 44 24 0c 46 a9 10 	movl   $0xc010a946,0xc(%esp)
c01040f6:	c0 
c01040f7:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01040fe:	c0 
c01040ff:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104106:	00 
c0104107:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c010410e:	e8 e5 cb ff ff       	call   c0100cf8 <__panic>

    p2 = p0 + 1;
c0104113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104116:	83 c0 20             	add    $0x20,%eax
c0104119:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010411c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104123:	00 
c0104124:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104127:	89 04 24             	mov    %eax,(%esp)
c010412a:	e8 9f 0d 00 00       	call   c0104ece <free_pages>
    free_pages(p1, 3);
c010412f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104136:	00 
c0104137:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010413a:	89 04 24             	mov    %eax,(%esp)
c010413d:	e8 8c 0d 00 00       	call   c0104ece <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104145:	83 c0 04             	add    $0x4,%eax
c0104148:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010414f:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104152:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104155:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104158:	0f a3 10             	bt     %edx,(%eax)
c010415b:	19 c0                	sbb    %eax,%eax
c010415d:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104160:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104164:	0f 95 c0             	setne  %al
c0104167:	0f b6 c0             	movzbl %al,%eax
c010416a:	85 c0                	test   %eax,%eax
c010416c:	74 0b                	je     c0104179 <default_check+0x3c3>
c010416e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104171:	8b 40 08             	mov    0x8(%eax),%eax
c0104174:	83 f8 01             	cmp    $0x1,%eax
c0104177:	74 24                	je     c010419d <default_check+0x3e7>
c0104179:	c7 44 24 0c 54 a9 10 	movl   $0xc010a954,0xc(%esp)
c0104180:	c0 
c0104181:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104188:	c0 
c0104189:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0104190:	00 
c0104191:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104198:	e8 5b cb ff ff       	call   c0100cf8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010419d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041a0:	83 c0 04             	add    $0x4,%eax
c01041a3:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01041aa:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041ad:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041b0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041b3:	0f a3 10             	bt     %edx,(%eax)
c01041b6:	19 c0                	sbb    %eax,%eax
c01041b8:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01041bb:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01041bf:	0f 95 c0             	setne  %al
c01041c2:	0f b6 c0             	movzbl %al,%eax
c01041c5:	85 c0                	test   %eax,%eax
c01041c7:	74 0b                	je     c01041d4 <default_check+0x41e>
c01041c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041cc:	8b 40 08             	mov    0x8(%eax),%eax
c01041cf:	83 f8 03             	cmp    $0x3,%eax
c01041d2:	74 24                	je     c01041f8 <default_check+0x442>
c01041d4:	c7 44 24 0c 7c a9 10 	movl   $0xc010a97c,0xc(%esp)
c01041db:	c0 
c01041dc:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01041e3:	c0 
c01041e4:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01041eb:	00 
c01041ec:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01041f3:	e8 00 cb ff ff       	call   c0100cf8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01041f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041ff:	e8 5f 0c 00 00       	call   c0104e63 <alloc_pages>
c0104204:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104207:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010420a:	83 e8 20             	sub    $0x20,%eax
c010420d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104210:	74 24                	je     c0104236 <default_check+0x480>
c0104212:	c7 44 24 0c a2 a9 10 	movl   $0xc010a9a2,0xc(%esp)
c0104219:	c0 
c010421a:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104221:	c0 
c0104222:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0104229:	00 
c010422a:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104231:	e8 c2 ca ff ff       	call   c0100cf8 <__panic>
    free_page(p0);
c0104236:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010423d:	00 
c010423e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104241:	89 04 24             	mov    %eax,(%esp)
c0104244:	e8 85 0c 00 00       	call   c0104ece <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104249:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104250:	e8 0e 0c 00 00       	call   c0104e63 <alloc_pages>
c0104255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104258:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010425b:	83 c0 20             	add    $0x20,%eax
c010425e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104261:	74 24                	je     c0104287 <default_check+0x4d1>
c0104263:	c7 44 24 0c c0 a9 10 	movl   $0xc010a9c0,0xc(%esp)
c010426a:	c0 
c010426b:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104272:	c0 
c0104273:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010427a:	00 
c010427b:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104282:	e8 71 ca ff ff       	call   c0100cf8 <__panic>

    free_pages(p0, 2);
c0104287:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010428e:	00 
c010428f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104292:	89 04 24             	mov    %eax,(%esp)
c0104295:	e8 34 0c 00 00       	call   c0104ece <free_pages>
    free_page(p2);
c010429a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042a1:	00 
c01042a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042a5:	89 04 24             	mov    %eax,(%esp)
c01042a8:	e8 21 0c 00 00       	call   c0104ece <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01042ad:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01042b4:	e8 aa 0b 00 00       	call   c0104e63 <alloc_pages>
c01042b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042c0:	75 24                	jne    c01042e6 <default_check+0x530>
c01042c2:	c7 44 24 0c e0 a9 10 	movl   $0xc010a9e0,0xc(%esp)
c01042c9:	c0 
c01042ca:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01042d1:	c0 
c01042d2:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01042d9:	00 
c01042da:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01042e1:	e8 12 ca ff ff       	call   c0100cf8 <__panic>
    assert(alloc_page() == NULL);
c01042e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042ed:	e8 71 0b 00 00       	call   c0104e63 <alloc_pages>
c01042f2:	85 c0                	test   %eax,%eax
c01042f4:	74 24                	je     c010431a <default_check+0x564>
c01042f6:	c7 44 24 0c 3e a8 10 	movl   $0xc010a83e,0xc(%esp)
c01042fd:	c0 
c01042fe:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104305:	c0 
c0104306:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010430d:	00 
c010430e:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104315:	e8 de c9 ff ff       	call   c0100cf8 <__panic>

    assert(nr_free == 0);
c010431a:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010431f:	85 c0                	test   %eax,%eax
c0104321:	74 24                	je     c0104347 <default_check+0x591>
c0104323:	c7 44 24 0c 91 a8 10 	movl   $0xc010a891,0xc(%esp)
c010432a:	c0 
c010432b:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c0104332:	c0 
c0104333:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c010433a:	00 
c010433b:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104342:	e8 b1 c9 ff ff       	call   c0100cf8 <__panic>
    nr_free = nr_free_store;
c0104347:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010434a:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c010434f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104352:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104355:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c010435a:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c0104360:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104367:	00 
c0104368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010436b:	89 04 24             	mov    %eax,(%esp)
c010436e:	e8 5b 0b 00 00       	call   c0104ece <free_pages>

    le = &free_list;
c0104373:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010437a:	eb 1d                	jmp    c0104399 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010437c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010437f:	83 e8 0c             	sub    $0xc,%eax
c0104382:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104385:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104389:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010438c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010438f:	8b 40 08             	mov    0x8(%eax),%eax
c0104392:	29 c2                	sub    %eax,%edx
c0104394:	89 d0                	mov    %edx,%eax
c0104396:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104399:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010439c:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010439f:	8b 45 88             	mov    -0x78(%ebp),%eax
c01043a2:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01043a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043a8:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c01043af:	75 cb                	jne    c010437c <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01043b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043b5:	74 24                	je     c01043db <default_check+0x625>
c01043b7:	c7 44 24 0c fe a9 10 	movl   $0xc010a9fe,0xc(%esp)
c01043be:	c0 
c01043bf:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01043c6:	c0 
c01043c7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01043ce:	00 
c01043cf:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c01043d6:	e8 1d c9 ff ff       	call   c0100cf8 <__panic>
    assert(total == 0);
c01043db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043df:	74 24                	je     c0104405 <default_check+0x64f>
c01043e1:	c7 44 24 0c 09 aa 10 	movl   $0xc010aa09,0xc(%esp)
c01043e8:	c0 
c01043e9:	c7 44 24 08 b6 a6 10 	movl   $0xc010a6b6,0x8(%esp)
c01043f0:	c0 
c01043f1:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01043f8:	00 
c01043f9:	c7 04 24 cb a6 10 c0 	movl   $0xc010a6cb,(%esp)
c0104400:	e8 f3 c8 ff ff       	call   c0100cf8 <__panic>
}
c0104405:	81 c4 94 00 00 00    	add    $0x94,%esp
c010440b:	5b                   	pop    %ebx
c010440c:	5d                   	pop    %ebp
c010440d:	c3                   	ret    

c010440e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010440e:	55                   	push   %ebp
c010440f:	89 e5                	mov    %esp,%ebp
c0104411:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104414:	9c                   	pushf  
c0104415:	58                   	pop    %eax
c0104416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104419:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010441c:	25 00 02 00 00       	and    $0x200,%eax
c0104421:	85 c0                	test   %eax,%eax
c0104423:	74 0c                	je     c0104431 <__intr_save+0x23>
        intr_disable();
c0104425:	e8 26 db ff ff       	call   c0101f50 <intr_disable>
        return 1;
c010442a:	b8 01 00 00 00       	mov    $0x1,%eax
c010442f:	eb 05                	jmp    c0104436 <__intr_save+0x28>
    }
    return 0;
c0104431:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104436:	c9                   	leave  
c0104437:	c3                   	ret    

c0104438 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104438:	55                   	push   %ebp
c0104439:	89 e5                	mov    %esp,%ebp
c010443b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010443e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104442:	74 05                	je     c0104449 <__intr_restore+0x11>
        intr_enable();
c0104444:	e8 01 db ff ff       	call   c0101f4a <intr_enable>
    }
}
c0104449:	c9                   	leave  
c010444a:	c3                   	ret    

c010444b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010444b:	55                   	push   %ebp
c010444c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010444e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104451:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104456:	29 c2                	sub    %eax,%edx
c0104458:	89 d0                	mov    %edx,%eax
c010445a:	c1 f8 05             	sar    $0x5,%eax
}
c010445d:	5d                   	pop    %ebp
c010445e:	c3                   	ret    

c010445f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010445f:	55                   	push   %ebp
c0104460:	89 e5                	mov    %esp,%ebp
c0104462:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104465:	8b 45 08             	mov    0x8(%ebp),%eax
c0104468:	89 04 24             	mov    %eax,(%esp)
c010446b:	e8 db ff ff ff       	call   c010444b <page2ppn>
c0104470:	c1 e0 0c             	shl    $0xc,%eax
}
c0104473:	c9                   	leave  
c0104474:	c3                   	ret    

c0104475 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104475:	55                   	push   %ebp
c0104476:	89 e5                	mov    %esp,%ebp
c0104478:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010447b:	8b 45 08             	mov    0x8(%ebp),%eax
c010447e:	c1 e8 0c             	shr    $0xc,%eax
c0104481:	89 c2                	mov    %eax,%edx
c0104483:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104488:	39 c2                	cmp    %eax,%edx
c010448a:	72 1c                	jb     c01044a8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010448c:	c7 44 24 08 44 aa 10 	movl   $0xc010aa44,0x8(%esp)
c0104493:	c0 
c0104494:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010449b:	00 
c010449c:	c7 04 24 63 aa 10 c0 	movl   $0xc010aa63,(%esp)
c01044a3:	e8 50 c8 ff ff       	call   c0100cf8 <__panic>
    }
    return &pages[PPN(pa)];
c01044a8:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01044ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01044b0:	c1 ea 0c             	shr    $0xc,%edx
c01044b3:	c1 e2 05             	shl    $0x5,%edx
c01044b6:	01 d0                	add    %edx,%eax
}
c01044b8:	c9                   	leave  
c01044b9:	c3                   	ret    

c01044ba <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01044ba:	55                   	push   %ebp
c01044bb:	89 e5                	mov    %esp,%ebp
c01044bd:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01044c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c3:	89 04 24             	mov    %eax,(%esp)
c01044c6:	e8 94 ff ff ff       	call   c010445f <page2pa>
c01044cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d1:	c1 e8 0c             	shr    $0xc,%eax
c01044d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044d7:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01044dc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01044df:	72 23                	jb     c0104504 <page2kva+0x4a>
c01044e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044e8:	c7 44 24 08 74 aa 10 	movl   $0xc010aa74,0x8(%esp)
c01044ef:	c0 
c01044f0:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01044f7:	00 
c01044f8:	c7 04 24 63 aa 10 c0 	movl   $0xc010aa63,(%esp)
c01044ff:	e8 f4 c7 ff ff       	call   c0100cf8 <__panic>
c0104504:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104507:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010450c:	c9                   	leave  
c010450d:	c3                   	ret    

c010450e <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010450e:	55                   	push   %ebp
c010450f:	89 e5                	mov    %esp,%ebp
c0104511:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104514:	8b 45 08             	mov    0x8(%ebp),%eax
c0104517:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010451a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104521:	77 23                	ja     c0104546 <kva2page+0x38>
c0104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104526:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010452a:	c7 44 24 08 98 aa 10 	movl   $0xc010aa98,0x8(%esp)
c0104531:	c0 
c0104532:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104539:	00 
c010453a:	c7 04 24 63 aa 10 c0 	movl   $0xc010aa63,(%esp)
c0104541:	e8 b2 c7 ff ff       	call   c0100cf8 <__panic>
c0104546:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104549:	05 00 00 00 40       	add    $0x40000000,%eax
c010454e:	89 04 24             	mov    %eax,(%esp)
c0104551:	e8 1f ff ff ff       	call   c0104475 <pa2page>
}
c0104556:	c9                   	leave  
c0104557:	c3                   	ret    

c0104558 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104558:	55                   	push   %ebp
c0104559:	89 e5                	mov    %esp,%ebp
c010455b:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c010455e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104561:	ba 01 00 00 00       	mov    $0x1,%edx
c0104566:	89 c1                	mov    %eax,%ecx
c0104568:	d3 e2                	shl    %cl,%edx
c010456a:	89 d0                	mov    %edx,%eax
c010456c:	89 04 24             	mov    %eax,(%esp)
c010456f:	e8 ef 08 00 00       	call   c0104e63 <alloc_pages>
c0104574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010457b:	75 07                	jne    c0104584 <__slob_get_free_pages+0x2c>
    return NULL;
c010457d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104582:	eb 0b                	jmp    c010458f <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104587:	89 04 24             	mov    %eax,(%esp)
c010458a:	e8 2b ff ff ff       	call   c01044ba <page2kva>
}
c010458f:	c9                   	leave  
c0104590:	c3                   	ret    

c0104591 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104591:	55                   	push   %ebp
c0104592:	89 e5                	mov    %esp,%ebp
c0104594:	53                   	push   %ebx
c0104595:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104598:	8b 45 0c             	mov    0xc(%ebp),%eax
c010459b:	ba 01 00 00 00       	mov    $0x1,%edx
c01045a0:	89 c1                	mov    %eax,%ecx
c01045a2:	d3 e2                	shl    %cl,%edx
c01045a4:	89 d0                	mov    %edx,%eax
c01045a6:	89 c3                	mov    %eax,%ebx
c01045a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ab:	89 04 24             	mov    %eax,(%esp)
c01045ae:	e8 5b ff ff ff       	call   c010450e <kva2page>
c01045b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01045b7:	89 04 24             	mov    %eax,(%esp)
c01045ba:	e8 0f 09 00 00       	call   c0104ece <free_pages>
}
c01045bf:	83 c4 14             	add    $0x14,%esp
c01045c2:	5b                   	pop    %ebx
c01045c3:	5d                   	pop    %ebp
c01045c4:	c3                   	ret    

c01045c5 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c01045c5:	55                   	push   %ebp
c01045c6:	89 e5                	mov    %esp,%ebp
c01045c8:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c01045cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ce:	83 c0 08             	add    $0x8,%eax
c01045d1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01045d6:	76 24                	jbe    c01045fc <slob_alloc+0x37>
c01045d8:	c7 44 24 0c bc aa 10 	movl   $0xc010aabc,0xc(%esp)
c01045df:	c0 
c01045e0:	c7 44 24 08 db aa 10 	movl   $0xc010aadb,0x8(%esp)
c01045e7:	c0 
c01045e8:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01045ef:	00 
c01045f0:	c7 04 24 f0 aa 10 c0 	movl   $0xc010aaf0,(%esp)
c01045f7:	e8 fc c6 ff ff       	call   c0100cf8 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01045fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104603:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010460a:	8b 45 08             	mov    0x8(%ebp),%eax
c010460d:	83 c0 07             	add    $0x7,%eax
c0104610:	c1 e8 03             	shr    $0x3,%eax
c0104613:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104616:	e8 f3 fd ff ff       	call   c010440e <__intr_save>
c010461b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c010461e:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104623:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104626:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104629:	8b 40 04             	mov    0x4(%eax),%eax
c010462c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c010462f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104633:	74 25                	je     c010465a <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104635:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104638:	8b 45 10             	mov    0x10(%ebp),%eax
c010463b:	01 d0                	add    %edx,%eax
c010463d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104640:	8b 45 10             	mov    0x10(%ebp),%eax
c0104643:	f7 d8                	neg    %eax
c0104645:	21 d0                	and    %edx,%eax
c0104647:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c010464a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010464d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104650:	29 c2                	sub    %eax,%edx
c0104652:	89 d0                	mov    %edx,%eax
c0104654:	c1 f8 03             	sar    $0x3,%eax
c0104657:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c010465a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010465d:	8b 00                	mov    (%eax),%eax
c010465f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104662:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104665:	01 ca                	add    %ecx,%edx
c0104667:	39 d0                	cmp    %edx,%eax
c0104669:	0f 8c aa 00 00 00    	jl     c0104719 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010466f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104673:	74 38                	je     c01046ad <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104675:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104678:	8b 00                	mov    (%eax),%eax
c010467a:	2b 45 e8             	sub    -0x18(%ebp),%eax
c010467d:	89 c2                	mov    %eax,%edx
c010467f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104682:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104684:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104687:	8b 50 04             	mov    0x4(%eax),%edx
c010468a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010468d:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104690:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104693:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104696:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104699:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010469f:	89 10                	mov    %edx,(%eax)
				prev = cur;
c01046a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01046a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01046ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b0:	8b 00                	mov    (%eax),%eax
c01046b2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01046b5:	75 0e                	jne    c01046c5 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c01046b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ba:	8b 50 04             	mov    0x4(%eax),%edx
c01046bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c0:	89 50 04             	mov    %edx,0x4(%eax)
c01046c3:	eb 3c                	jmp    c0104701 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c01046c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01046cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d2:	01 c2                	add    %eax,%edx
c01046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d7:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c01046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046dd:	8b 40 04             	mov    0x4(%eax),%eax
c01046e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01046e3:	8b 12                	mov    (%edx),%edx
c01046e5:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01046e8:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ed:	8b 40 04             	mov    0x4(%eax),%eax
c01046f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01046f3:	8b 52 04             	mov    0x4(%edx),%edx
c01046f6:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01046f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01046ff:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104704:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010470c:	89 04 24             	mov    %eax,(%esp)
c010470f:	e8 24 fd ff ff       	call   c0104438 <__intr_restore>
			return cur;
c0104714:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104717:	eb 7f                	jmp    c0104798 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104719:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010471e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104721:	75 61                	jne    c0104784 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104726:	89 04 24             	mov    %eax,(%esp)
c0104729:	e8 0a fd ff ff       	call   c0104438 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c010472e:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104735:	75 07                	jne    c010473e <slob_alloc+0x179>
				return 0;
c0104737:	b8 00 00 00 00       	mov    $0x0,%eax
c010473c:	eb 5a                	jmp    c0104798 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010473e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104745:	00 
c0104746:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104749:	89 04 24             	mov    %eax,(%esp)
c010474c:	e8 07 fe ff ff       	call   c0104558 <__slob_get_free_pages>
c0104751:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104754:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104758:	75 07                	jne    c0104761 <slob_alloc+0x19c>
				return 0;
c010475a:	b8 00 00 00 00       	mov    $0x0,%eax
c010475f:	eb 37                	jmp    c0104798 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104761:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104768:	00 
c0104769:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010476c:	89 04 24             	mov    %eax,(%esp)
c010476f:	e8 26 00 00 00       	call   c010479a <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104774:	e8 95 fc ff ff       	call   c010440e <__intr_save>
c0104779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c010477c:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104781:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104784:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104787:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010478a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010478d:	8b 40 04             	mov    0x4(%eax),%eax
c0104790:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104793:	e9 97 fe ff ff       	jmp    c010462f <slob_alloc+0x6a>
}
c0104798:	c9                   	leave  
c0104799:	c3                   	ret    

c010479a <slob_free>:

static void slob_free(void *block, int size)
{
c010479a:	55                   	push   %ebp
c010479b:	89 e5                	mov    %esp,%ebp
c010479d:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c01047a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01047a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01047aa:	75 05                	jne    c01047b1 <slob_free+0x17>
		return;
c01047ac:	e9 ff 00 00 00       	jmp    c01048b0 <slob_free+0x116>

	if (size)
c01047b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01047b5:	74 10                	je     c01047c7 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c01047b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047ba:	83 c0 07             	add    $0x7,%eax
c01047bd:	c1 e8 03             	shr    $0x3,%eax
c01047c0:	89 c2                	mov    %eax,%edx
c01047c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047c5:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c01047c7:	e8 42 fc ff ff       	call   c010440e <__intr_save>
c01047cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01047cf:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01047d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047d7:	eb 27                	jmp    c0104800 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c01047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047dc:	8b 40 04             	mov    0x4(%eax),%eax
c01047df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047e2:	77 13                	ja     c01047f7 <slob_free+0x5d>
c01047e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047ea:	77 27                	ja     c0104813 <slob_free+0x79>
c01047ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ef:	8b 40 04             	mov    0x4(%eax),%eax
c01047f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047f5:	77 1c                	ja     c0104813 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01047f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fa:	8b 40 04             	mov    0x4(%eax),%eax
c01047fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104800:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104803:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104806:	76 d1                	jbe    c01047d9 <slob_free+0x3f>
c0104808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010480b:	8b 40 04             	mov    0x4(%eax),%eax
c010480e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104811:	76 c6                	jbe    c01047d9 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104813:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104816:	8b 00                	mov    (%eax),%eax
c0104818:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010481f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104822:	01 c2                	add    %eax,%edx
c0104824:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104827:	8b 40 04             	mov    0x4(%eax),%eax
c010482a:	39 c2                	cmp    %eax,%edx
c010482c:	75 25                	jne    c0104853 <slob_free+0xb9>
		b->units += cur->next->units;
c010482e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104831:	8b 10                	mov    (%eax),%edx
c0104833:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104836:	8b 40 04             	mov    0x4(%eax),%eax
c0104839:	8b 00                	mov    (%eax),%eax
c010483b:	01 c2                	add    %eax,%edx
c010483d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104840:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104845:	8b 40 04             	mov    0x4(%eax),%eax
c0104848:	8b 50 04             	mov    0x4(%eax),%edx
c010484b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010484e:	89 50 04             	mov    %edx,0x4(%eax)
c0104851:	eb 0c                	jmp    c010485f <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104853:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104856:	8b 50 04             	mov    0x4(%eax),%edx
c0104859:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485c:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c010485f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104862:	8b 00                	mov    (%eax),%eax
c0104864:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010486b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486e:	01 d0                	add    %edx,%eax
c0104870:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104873:	75 1f                	jne    c0104894 <slob_free+0xfa>
		cur->units += b->units;
c0104875:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104878:	8b 10                	mov    (%eax),%edx
c010487a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010487d:	8b 00                	mov    (%eax),%eax
c010487f:	01 c2                	add    %eax,%edx
c0104881:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104884:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104886:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104889:	8b 50 04             	mov    0x4(%eax),%edx
c010488c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010488f:	89 50 04             	mov    %edx,0x4(%eax)
c0104892:	eb 09                	jmp    c010489d <slob_free+0x103>
	} else
		cur->next = b;
c0104894:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104897:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010489a:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c010489d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a0:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c01048a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048a8:	89 04 24             	mov    %eax,(%esp)
c01048ab:	e8 88 fb ff ff       	call   c0104438 <__intr_restore>
}
c01048b0:	c9                   	leave  
c01048b1:	c3                   	ret    

c01048b2 <slob_init>:



void
slob_init(void) {
c01048b2:	55                   	push   %ebp
c01048b3:	89 e5                	mov    %esp,%ebp
c01048b5:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c01048b8:	c7 04 24 02 ab 10 c0 	movl   $0xc010ab02,(%esp)
c01048bf:	e8 8f ba ff ff       	call   c0100353 <cprintf>
}
c01048c4:	c9                   	leave  
c01048c5:	c3                   	ret    

c01048c6 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c01048c6:	55                   	push   %ebp
c01048c7:	89 e5                	mov    %esp,%ebp
c01048c9:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c01048cc:	e8 e1 ff ff ff       	call   c01048b2 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c01048d1:	c7 04 24 16 ab 10 c0 	movl   $0xc010ab16,(%esp)
c01048d8:	e8 76 ba ff ff       	call   c0100353 <cprintf>
}
c01048dd:	c9                   	leave  
c01048de:	c3                   	ret    

c01048df <slob_allocated>:

size_t
slob_allocated(void) {
c01048df:	55                   	push   %ebp
c01048e0:	89 e5                	mov    %esp,%ebp
  return 0;
c01048e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048e7:	5d                   	pop    %ebp
c01048e8:	c3                   	ret    

c01048e9 <kallocated>:

size_t
kallocated(void) {
c01048e9:	55                   	push   %ebp
c01048ea:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c01048ec:	e8 ee ff ff ff       	call   c01048df <slob_allocated>
}
c01048f1:	5d                   	pop    %ebp
c01048f2:	c3                   	ret    

c01048f3 <find_order>:

static int find_order(int size)
{
c01048f3:	55                   	push   %ebp
c01048f4:	89 e5                	mov    %esp,%ebp
c01048f6:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c01048f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104900:	eb 07                	jmp    c0104909 <find_order+0x16>
		order++;
c0104902:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104906:	d1 7d 08             	sarl   0x8(%ebp)
c0104909:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104910:	7f f0                	jg     c0104902 <find_order+0xf>
		order++;
	return order;
c0104912:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104915:	c9                   	leave  
c0104916:	c3                   	ret    

c0104917 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104917:	55                   	push   %ebp
c0104918:	89 e5                	mov    %esp,%ebp
c010491a:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c010491d:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104924:	77 38                	ja     c010495e <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104926:	8b 45 08             	mov    0x8(%ebp),%eax
c0104929:	8d 50 08             	lea    0x8(%eax),%edx
c010492c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104933:	00 
c0104934:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010493b:	89 14 24             	mov    %edx,(%esp)
c010493e:	e8 82 fc ff ff       	call   c01045c5 <slob_alloc>
c0104943:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010494a:	74 08                	je     c0104954 <__kmalloc+0x3d>
c010494c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010494f:	83 c0 08             	add    $0x8,%eax
c0104952:	eb 05                	jmp    c0104959 <__kmalloc+0x42>
c0104954:	b8 00 00 00 00       	mov    $0x0,%eax
c0104959:	e9 a6 00 00 00       	jmp    c0104a04 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c010495e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104965:	00 
c0104966:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104969:	89 44 24 04          	mov    %eax,0x4(%esp)
c010496d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104974:	e8 4c fc ff ff       	call   c01045c5 <slob_alloc>
c0104979:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c010497c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104980:	75 07                	jne    c0104989 <__kmalloc+0x72>
		return 0;
c0104982:	b8 00 00 00 00       	mov    $0x0,%eax
c0104987:	eb 7b                	jmp    c0104a04 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104989:	8b 45 08             	mov    0x8(%ebp),%eax
c010498c:	89 04 24             	mov    %eax,(%esp)
c010498f:	e8 5f ff ff ff       	call   c01048f3 <find_order>
c0104994:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104997:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104999:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499c:	8b 00                	mov    (%eax),%eax
c010499e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049a5:	89 04 24             	mov    %eax,(%esp)
c01049a8:	e8 ab fb ff ff       	call   c0104558 <__slob_get_free_pages>
c01049ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049b0:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c01049b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049b6:	8b 40 04             	mov    0x4(%eax),%eax
c01049b9:	85 c0                	test   %eax,%eax
c01049bb:	74 2f                	je     c01049ec <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c01049bd:	e8 4c fa ff ff       	call   c010440e <__intr_save>
c01049c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c01049c5:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c01049cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ce:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c01049d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d4:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c01049d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049dc:	89 04 24             	mov    %eax,(%esp)
c01049df:	e8 54 fa ff ff       	call   c0104438 <__intr_restore>
		return bb->pages;
c01049e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e7:	8b 40 04             	mov    0x4(%eax),%eax
c01049ea:	eb 18                	jmp    c0104a04 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01049ec:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c01049f3:	00 
c01049f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f7:	89 04 24             	mov    %eax,(%esp)
c01049fa:	e8 9b fd ff ff       	call   c010479a <slob_free>
	return 0;
c01049ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a04:	c9                   	leave  
c0104a05:	c3                   	ret    

c0104a06 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104a06:	55                   	push   %ebp
c0104a07:	89 e5                	mov    %esp,%ebp
c0104a09:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104a0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a13:	00 
c0104a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a17:	89 04 24             	mov    %eax,(%esp)
c0104a1a:	e8 f8 fe ff ff       	call   c0104917 <__kmalloc>
}
c0104a1f:	c9                   	leave  
c0104a20:	c3                   	ret    

c0104a21 <kfree>:


void kfree(void *block)
{
c0104a21:	55                   	push   %ebp
c0104a22:	89 e5                	mov    %esp,%ebp
c0104a24:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104a27:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104a2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a32:	75 05                	jne    c0104a39 <kfree+0x18>
		return;
c0104a34:	e9 a2 00 00 00       	jmp    c0104adb <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a3c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a41:	85 c0                	test   %eax,%eax
c0104a43:	75 7f                	jne    c0104ac4 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104a45:	e8 c4 f9 ff ff       	call   c010440e <__intr_save>
c0104a4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104a4d:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a55:	eb 5c                	jmp    c0104ab3 <kfree+0x92>
			if (bb->pages == block) {
c0104a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a5a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a5d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104a60:	75 3f                	jne    c0104aa1 <kfree+0x80>
				*last = bb->next;
c0104a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a65:	8b 50 08             	mov    0x8(%eax),%edx
c0104a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a6b:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a70:	89 04 24             	mov    %eax,(%esp)
c0104a73:	e8 c0 f9 ff ff       	call   c0104438 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a7b:	8b 10                	mov    (%eax),%edx
c0104a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a80:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a84:	89 04 24             	mov    %eax,(%esp)
c0104a87:	e8 05 fb ff ff       	call   c0104591 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104a8c:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104a93:	00 
c0104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a97:	89 04 24             	mov    %eax,(%esp)
c0104a9a:	e8 fb fc ff ff       	call   c010479a <slob_free>
				return;
c0104a9f:	eb 3a                	jmp    c0104adb <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa4:	83 c0 08             	add    $0x8,%eax
c0104aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aad:	8b 40 08             	mov    0x8(%eax),%eax
c0104ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ab7:	75 9e                	jne    c0104a57 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104abc:	89 04 24             	mov    %eax,(%esp)
c0104abf:	e8 74 f9 ff ff       	call   c0104438 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ac7:	83 e8 08             	sub    $0x8,%eax
c0104aca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ad1:	00 
c0104ad2:	89 04 24             	mov    %eax,(%esp)
c0104ad5:	e8 c0 fc ff ff       	call   c010479a <slob_free>
	return;
c0104ada:	90                   	nop
}
c0104adb:	c9                   	leave  
c0104adc:	c3                   	ret    

c0104add <ksize>:


unsigned int ksize(const void *block)
{
c0104add:	55                   	push   %ebp
c0104ade:	89 e5                	mov    %esp,%ebp
c0104ae0:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104ae3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ae7:	75 07                	jne    c0104af0 <ksize+0x13>
		return 0;
c0104ae9:	b8 00 00 00 00       	mov    $0x0,%eax
c0104aee:	eb 6b                	jmp    c0104b5b <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af3:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104af8:	85 c0                	test   %eax,%eax
c0104afa:	75 54                	jne    c0104b50 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104afc:	e8 0d f9 ff ff       	call   c010440e <__intr_save>
c0104b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104b04:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b0c:	eb 31                	jmp    c0104b3f <ksize+0x62>
			if (bb->pages == block) {
c0104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b11:	8b 40 04             	mov    0x4(%eax),%eax
c0104b14:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b17:	75 1d                	jne    c0104b36 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b1c:	89 04 24             	mov    %eax,(%esp)
c0104b1f:	e8 14 f9 ff ff       	call   c0104438 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b27:	8b 00                	mov    (%eax),%eax
c0104b29:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104b2e:	89 c1                	mov    %eax,%ecx
c0104b30:	d3 e2                	shl    %cl,%edx
c0104b32:	89 d0                	mov    %edx,%eax
c0104b34:	eb 25                	jmp    c0104b5b <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b39:	8b 40 08             	mov    0x8(%eax),%eax
c0104b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b43:	75 c9                	jne    c0104b0e <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b48:	89 04 24             	mov    %eax,(%esp)
c0104b4b:	e8 e8 f8 ff ff       	call   c0104438 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b53:	83 e8 08             	sub    $0x8,%eax
c0104b56:	8b 00                	mov    (%eax),%eax
c0104b58:	c1 e0 03             	shl    $0x3,%eax
}
c0104b5b:	c9                   	leave  
c0104b5c:	c3                   	ret    

c0104b5d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104b5d:	55                   	push   %ebp
c0104b5e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104b60:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b63:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104b68:	29 c2                	sub    %eax,%edx
c0104b6a:	89 d0                	mov    %edx,%eax
c0104b6c:	c1 f8 05             	sar    $0x5,%eax
}
c0104b6f:	5d                   	pop    %ebp
c0104b70:	c3                   	ret    

c0104b71 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104b71:	55                   	push   %ebp
c0104b72:	89 e5                	mov    %esp,%ebp
c0104b74:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7a:	89 04 24             	mov    %eax,(%esp)
c0104b7d:	e8 db ff ff ff       	call   c0104b5d <page2ppn>
c0104b82:	c1 e0 0c             	shl    $0xc,%eax
}
c0104b85:	c9                   	leave  
c0104b86:	c3                   	ret    

c0104b87 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b87:	55                   	push   %ebp
c0104b88:	89 e5                	mov    %esp,%ebp
c0104b8a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b90:	c1 e8 0c             	shr    $0xc,%eax
c0104b93:	89 c2                	mov    %eax,%edx
c0104b95:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104b9a:	39 c2                	cmp    %eax,%edx
c0104b9c:	72 1c                	jb     c0104bba <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104b9e:	c7 44 24 08 34 ab 10 	movl   $0xc010ab34,0x8(%esp)
c0104ba5:	c0 
c0104ba6:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104bad:	00 
c0104bae:	c7 04 24 53 ab 10 c0 	movl   $0xc010ab53,(%esp)
c0104bb5:	e8 3e c1 ff ff       	call   c0100cf8 <__panic>
    }
    return &pages[PPN(pa)];
c0104bba:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104bbf:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bc2:	c1 ea 0c             	shr    $0xc,%edx
c0104bc5:	c1 e2 05             	shl    $0x5,%edx
c0104bc8:	01 d0                	add    %edx,%eax
}
c0104bca:	c9                   	leave  
c0104bcb:	c3                   	ret    

c0104bcc <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104bcc:	55                   	push   %ebp
c0104bcd:	89 e5                	mov    %esp,%ebp
c0104bcf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bd5:	89 04 24             	mov    %eax,(%esp)
c0104bd8:	e8 94 ff ff ff       	call   c0104b71 <page2pa>
c0104bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be3:	c1 e8 0c             	shr    $0xc,%eax
c0104be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104be9:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104bee:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104bf1:	72 23                	jb     c0104c16 <page2kva+0x4a>
c0104bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104bfa:	c7 44 24 08 64 ab 10 	movl   $0xc010ab64,0x8(%esp)
c0104c01:	c0 
c0104c02:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104c09:	00 
c0104c0a:	c7 04 24 53 ab 10 c0 	movl   $0xc010ab53,(%esp)
c0104c11:	e8 e2 c0 ff ff       	call   c0100cf8 <__panic>
c0104c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c19:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104c1e:	c9                   	leave  
c0104c1f:	c3                   	ret    

c0104c20 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104c20:	55                   	push   %ebp
c0104c21:	89 e5                	mov    %esp,%ebp
c0104c23:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c29:	83 e0 01             	and    $0x1,%eax
c0104c2c:	85 c0                	test   %eax,%eax
c0104c2e:	75 1c                	jne    c0104c4c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104c30:	c7 44 24 08 88 ab 10 	movl   $0xc010ab88,0x8(%esp)
c0104c37:	c0 
c0104c38:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104c3f:	00 
c0104c40:	c7 04 24 53 ab 10 c0 	movl   $0xc010ab53,(%esp)
c0104c47:	e8 ac c0 ff ff       	call   c0100cf8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104c4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c54:	89 04 24             	mov    %eax,(%esp)
c0104c57:	e8 2b ff ff ff       	call   c0104b87 <pa2page>
}
c0104c5c:	c9                   	leave  
c0104c5d:	c3                   	ret    

c0104c5e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104c5e:	55                   	push   %ebp
c0104c5f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c64:	8b 00                	mov    (%eax),%eax
}
c0104c66:	5d                   	pop    %ebp
c0104c67:	c3                   	ret    

c0104c68 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104c68:	55                   	push   %ebp
c0104c69:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c71:	89 10                	mov    %edx,(%eax)
}
c0104c73:	5d                   	pop    %ebp
c0104c74:	c3                   	ret    

c0104c75 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104c75:	55                   	push   %ebp
c0104c76:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c7b:	8b 00                	mov    (%eax),%eax
c0104c7d:	8d 50 01             	lea    0x1(%eax),%edx
c0104c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c83:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c88:	8b 00                	mov    (%eax),%eax
}
c0104c8a:	5d                   	pop    %ebp
c0104c8b:	c3                   	ret    

c0104c8c <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104c8c:	55                   	push   %ebp
c0104c8d:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c92:	8b 00                	mov    (%eax),%eax
c0104c94:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9f:	8b 00                	mov    (%eax),%eax
}
c0104ca1:	5d                   	pop    %ebp
c0104ca2:	c3                   	ret    

c0104ca3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104ca3:	55                   	push   %ebp
c0104ca4:	89 e5                	mov    %esp,%ebp
c0104ca6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104ca9:	9c                   	pushf  
c0104caa:	58                   	pop    %eax
c0104cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104cb1:	25 00 02 00 00       	and    $0x200,%eax
c0104cb6:	85 c0                	test   %eax,%eax
c0104cb8:	74 0c                	je     c0104cc6 <__intr_save+0x23>
        intr_disable();
c0104cba:	e8 91 d2 ff ff       	call   c0101f50 <intr_disable>
        return 1;
c0104cbf:	b8 01 00 00 00       	mov    $0x1,%eax
c0104cc4:	eb 05                	jmp    c0104ccb <__intr_save+0x28>
    }
    return 0;
c0104cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ccb:	c9                   	leave  
c0104ccc:	c3                   	ret    

c0104ccd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104ccd:	55                   	push   %ebp
c0104cce:	89 e5                	mov    %esp,%ebp
c0104cd0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104cd7:	74 05                	je     c0104cde <__intr_restore+0x11>
        intr_enable();
c0104cd9:	e8 6c d2 ff ff       	call   c0101f4a <intr_enable>
    }
}
c0104cde:	c9                   	leave  
c0104cdf:	c3                   	ret    

c0104ce0 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104ce0:	55                   	push   %ebp
c0104ce1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ce6:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104ce9:	b8 23 00 00 00       	mov    $0x23,%eax
c0104cee:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104cf0:	b8 23 00 00 00       	mov    $0x23,%eax
c0104cf5:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104cf7:	b8 10 00 00 00       	mov    $0x10,%eax
c0104cfc:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104cfe:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d03:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104d05:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d0a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104d0c:	ea 13 4d 10 c0 08 00 	ljmp   $0x8,$0xc0104d13
}
c0104d13:	5d                   	pop    %ebp
c0104d14:	c3                   	ret    

c0104d15 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104d15:	55                   	push   %ebp
c0104d16:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d1b:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104d20:	5d                   	pop    %ebp
c0104d21:	c3                   	ret    

c0104d22 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104d22:	55                   	push   %ebp
c0104d23:	89 e5                	mov    %esp,%ebp
c0104d25:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104d28:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104d2d:	89 04 24             	mov    %eax,(%esp)
c0104d30:	e8 e0 ff ff ff       	call   c0104d15 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104d35:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104d3c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104d3e:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104d45:	68 00 
c0104d47:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104d4c:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104d52:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104d57:	c1 e8 10             	shr    $0x10,%eax
c0104d5a:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104d5f:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104d66:	83 e0 f0             	and    $0xfffffff0,%eax
c0104d69:	83 c8 09             	or     $0x9,%eax
c0104d6c:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104d71:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104d78:	83 e0 ef             	and    $0xffffffef,%eax
c0104d7b:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104d80:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104d87:	83 e0 9f             	and    $0xffffff9f,%eax
c0104d8a:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104d8f:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104d96:	83 c8 80             	or     $0xffffff80,%eax
c0104d99:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104d9e:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104da5:	83 e0 f0             	and    $0xfffffff0,%eax
c0104da8:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104dad:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104db4:	83 e0 ef             	and    $0xffffffef,%eax
c0104db7:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104dbc:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104dc3:	83 e0 df             	and    $0xffffffdf,%eax
c0104dc6:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104dcb:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104dd2:	83 c8 40             	or     $0x40,%eax
c0104dd5:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104dda:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104de1:	83 e0 7f             	and    $0x7f,%eax
c0104de4:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104de9:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104dee:	c1 e8 18             	shr    $0x18,%eax
c0104df1:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104df6:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104dfd:	e8 de fe ff ff       	call   c0104ce0 <lgdt>
c0104e02:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104e08:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104e0c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104e0f:	c9                   	leave  
c0104e10:	c3                   	ret    

c0104e11 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104e11:	55                   	push   %ebp
c0104e12:	89 e5                	mov    %esp,%ebp
c0104e14:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104e17:	c7 05 24 7b 12 c0 28 	movl   $0xc010aa28,0xc0127b24
c0104e1e:	aa 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104e21:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e26:	8b 00                	mov    (%eax),%eax
c0104e28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104e2c:	c7 04 24 b4 ab 10 c0 	movl   $0xc010abb4,(%esp)
c0104e33:	e8 1b b5 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104e38:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e3d:	8b 40 04             	mov    0x4(%eax),%eax
c0104e40:	ff d0                	call   *%eax
}
c0104e42:	c9                   	leave  
c0104e43:	c3                   	ret    

c0104e44 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104e44:	55                   	push   %ebp
c0104e45:	89 e5                	mov    %esp,%ebp
c0104e47:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104e4a:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e4f:	8b 40 08             	mov    0x8(%eax),%eax
c0104e52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e55:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e59:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e5c:	89 14 24             	mov    %edx,(%esp)
c0104e5f:	ff d0                	call   *%eax
}
c0104e61:	c9                   	leave  
c0104e62:	c3                   	ret    

c0104e63 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104e63:	55                   	push   %ebp
c0104e64:	89 e5                	mov    %esp,%ebp
c0104e66:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104e69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104e70:	e8 2e fe ff ff       	call   c0104ca3 <__intr_save>
c0104e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104e78:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e7d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e80:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e83:	89 14 24             	mov    %edx,(%esp)
c0104e86:	ff d0                	call   *%eax
c0104e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e8e:	89 04 24             	mov    %eax,(%esp)
c0104e91:	e8 37 fe ff ff       	call   c0104ccd <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e9a:	75 2d                	jne    c0104ec9 <alloc_pages+0x66>
c0104e9c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104ea0:	77 27                	ja     c0104ec9 <alloc_pages+0x66>
c0104ea2:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104ea7:	85 c0                	test   %eax,%eax
c0104ea9:	74 1e                	je     c0104ec9 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104eab:	8b 55 08             	mov    0x8(%ebp),%edx
c0104eae:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104eb3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104eba:	00 
c0104ebb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ebf:	89 04 24             	mov    %eax,(%esp)
c0104ec2:	e8 77 19 00 00       	call   c010683e <swap_out>
    }
c0104ec7:	eb a7                	jmp    c0104e70 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104ecc:	c9                   	leave  
c0104ecd:	c3                   	ret    

c0104ece <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104ece:	55                   	push   %ebp
c0104ecf:	89 e5                	mov    %esp,%ebp
c0104ed1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104ed4:	e8 ca fd ff ff       	call   c0104ca3 <__intr_save>
c0104ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104edc:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104ee1:	8b 40 10             	mov    0x10(%eax),%eax
c0104ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ee7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104eeb:	8b 55 08             	mov    0x8(%ebp),%edx
c0104eee:	89 14 24             	mov    %edx,(%esp)
c0104ef1:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef6:	89 04 24             	mov    %eax,(%esp)
c0104ef9:	e8 cf fd ff ff       	call   c0104ccd <__intr_restore>
}
c0104efe:	c9                   	leave  
c0104eff:	c3                   	ret    

c0104f00 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104f00:	55                   	push   %ebp
c0104f01:	89 e5                	mov    %esp,%ebp
c0104f03:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104f06:	e8 98 fd ff ff       	call   c0104ca3 <__intr_save>
c0104f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104f0e:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104f13:	8b 40 14             	mov    0x14(%eax),%eax
c0104f16:	ff d0                	call   *%eax
c0104f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f1e:	89 04 24             	mov    %eax,(%esp)
c0104f21:	e8 a7 fd ff ff       	call   c0104ccd <__intr_restore>
    return ret;
c0104f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104f29:	c9                   	leave  
c0104f2a:	c3                   	ret    

c0104f2b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104f2b:	55                   	push   %ebp
c0104f2c:	89 e5                	mov    %esp,%ebp
c0104f2e:	57                   	push   %edi
c0104f2f:	56                   	push   %esi
c0104f30:	53                   	push   %ebx
c0104f31:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104f37:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104f3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104f45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104f4c:	c7 04 24 cb ab 10 c0 	movl   $0xc010abcb,(%esp)
c0104f53:	e8 fb b3 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104f5f:	e9 15 01 00 00       	jmp    c0105079 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104f64:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f67:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f6a:	89 d0                	mov    %edx,%eax
c0104f6c:	c1 e0 02             	shl    $0x2,%eax
c0104f6f:	01 d0                	add    %edx,%eax
c0104f71:	c1 e0 02             	shl    $0x2,%eax
c0104f74:	01 c8                	add    %ecx,%eax
c0104f76:	8b 50 08             	mov    0x8(%eax),%edx
c0104f79:	8b 40 04             	mov    0x4(%eax),%eax
c0104f7c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104f7f:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104f82:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f85:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f88:	89 d0                	mov    %edx,%eax
c0104f8a:	c1 e0 02             	shl    $0x2,%eax
c0104f8d:	01 d0                	add    %edx,%eax
c0104f8f:	c1 e0 02             	shl    $0x2,%eax
c0104f92:	01 c8                	add    %ecx,%eax
c0104f94:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104f97:	8b 58 10             	mov    0x10(%eax),%ebx
c0104f9a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f9d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104fa0:	01 c8                	add    %ecx,%eax
c0104fa2:	11 da                	adc    %ebx,%edx
c0104fa4:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104fa7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104faa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fb0:	89 d0                	mov    %edx,%eax
c0104fb2:	c1 e0 02             	shl    $0x2,%eax
c0104fb5:	01 d0                	add    %edx,%eax
c0104fb7:	c1 e0 02             	shl    $0x2,%eax
c0104fba:	01 c8                	add    %ecx,%eax
c0104fbc:	83 c0 14             	add    $0x14,%eax
c0104fbf:	8b 00                	mov    (%eax),%eax
c0104fc1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104fc7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104fca:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104fcd:	83 c0 ff             	add    $0xffffffff,%eax
c0104fd0:	83 d2 ff             	adc    $0xffffffff,%edx
c0104fd3:	89 c6                	mov    %eax,%esi
c0104fd5:	89 d7                	mov    %edx,%edi
c0104fd7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fda:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fdd:	89 d0                	mov    %edx,%eax
c0104fdf:	c1 e0 02             	shl    $0x2,%eax
c0104fe2:	01 d0                	add    %edx,%eax
c0104fe4:	c1 e0 02             	shl    $0x2,%eax
c0104fe7:	01 c8                	add    %ecx,%eax
c0104fe9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104fec:	8b 58 10             	mov    0x10(%eax),%ebx
c0104fef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104ff5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104ff9:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104ffd:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0105001:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105004:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105007:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010500b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010500f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0105013:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105017:	c7 04 24 d8 ab 10 c0 	movl   $0xc010abd8,(%esp)
c010501e:	e8 30 b3 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0105023:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105026:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105029:	89 d0                	mov    %edx,%eax
c010502b:	c1 e0 02             	shl    $0x2,%eax
c010502e:	01 d0                	add    %edx,%eax
c0105030:	c1 e0 02             	shl    $0x2,%eax
c0105033:	01 c8                	add    %ecx,%eax
c0105035:	83 c0 14             	add    $0x14,%eax
c0105038:	8b 00                	mov    (%eax),%eax
c010503a:	83 f8 01             	cmp    $0x1,%eax
c010503d:	75 36                	jne    c0105075 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010503f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105042:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105045:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105048:	77 2b                	ja     c0105075 <page_init+0x14a>
c010504a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010504d:	72 05                	jb     c0105054 <page_init+0x129>
c010504f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105052:	73 21                	jae    c0105075 <page_init+0x14a>
c0105054:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105058:	77 1b                	ja     c0105075 <page_init+0x14a>
c010505a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010505e:	72 09                	jb     c0105069 <page_init+0x13e>
c0105060:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105067:	77 0c                	ja     c0105075 <page_init+0x14a>
                maxpa = end;
c0105069:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010506c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010506f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105072:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105075:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105079:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010507c:	8b 00                	mov    (%eax),%eax
c010507e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105081:	0f 8f dd fe ff ff    	jg     c0104f64 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105087:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010508b:	72 1d                	jb     c01050aa <page_init+0x17f>
c010508d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105091:	77 09                	ja     c010509c <page_init+0x171>
c0105093:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010509a:	76 0e                	jbe    c01050aa <page_init+0x17f>
        maxpa = KMEMSIZE;
c010509c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01050a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01050aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01050b0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01050b4:	c1 ea 0c             	shr    $0xc,%edx
c01050b7:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01050bc:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01050c3:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01050c8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01050cb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01050ce:	01 d0                	add    %edx,%eax
c01050d0:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01050d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01050d6:	ba 00 00 00 00       	mov    $0x0,%edx
c01050db:	f7 75 ac             	divl   -0x54(%ebp)
c01050de:	89 d0                	mov    %edx,%eax
c01050e0:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01050e3:	29 c2                	sub    %eax,%edx
c01050e5:	89 d0                	mov    %edx,%eax
c01050e7:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c01050ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01050f3:	eb 27                	jmp    c010511c <page_init+0x1f1>
        SetPageReserved(pages + i);
c01050f5:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01050fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050fd:	c1 e2 05             	shl    $0x5,%edx
c0105100:	01 d0                	add    %edx,%eax
c0105102:	83 c0 04             	add    $0x4,%eax
c0105105:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010510c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010510f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105112:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105115:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105118:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010511c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010511f:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105124:	39 c2                	cmp    %eax,%edx
c0105126:	72 cd                	jb     c01050f5 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105128:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010512d:	c1 e0 05             	shl    $0x5,%eax
c0105130:	89 c2                	mov    %eax,%edx
c0105132:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0105137:	01 d0                	add    %edx,%eax
c0105139:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010513c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105143:	77 23                	ja     c0105168 <page_init+0x23d>
c0105145:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105148:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010514c:	c7 44 24 08 08 ac 10 	movl   $0xc010ac08,0x8(%esp)
c0105153:	c0 
c0105154:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010515b:	00 
c010515c:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105163:	e8 90 bb ff ff       	call   c0100cf8 <__panic>
c0105168:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010516b:	05 00 00 00 40       	add    $0x40000000,%eax
c0105170:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105173:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010517a:	e9 74 01 00 00       	jmp    c01052f3 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010517f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105182:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105185:	89 d0                	mov    %edx,%eax
c0105187:	c1 e0 02             	shl    $0x2,%eax
c010518a:	01 d0                	add    %edx,%eax
c010518c:	c1 e0 02             	shl    $0x2,%eax
c010518f:	01 c8                	add    %ecx,%eax
c0105191:	8b 50 08             	mov    0x8(%eax),%edx
c0105194:	8b 40 04             	mov    0x4(%eax),%eax
c0105197:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010519a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010519d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051a3:	89 d0                	mov    %edx,%eax
c01051a5:	c1 e0 02             	shl    $0x2,%eax
c01051a8:	01 d0                	add    %edx,%eax
c01051aa:	c1 e0 02             	shl    $0x2,%eax
c01051ad:	01 c8                	add    %ecx,%eax
c01051af:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051b2:	8b 58 10             	mov    0x10(%eax),%ebx
c01051b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051bb:	01 c8                	add    %ecx,%eax
c01051bd:	11 da                	adc    %ebx,%edx
c01051bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01051c2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01051c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051cb:	89 d0                	mov    %edx,%eax
c01051cd:	c1 e0 02             	shl    $0x2,%eax
c01051d0:	01 d0                	add    %edx,%eax
c01051d2:	c1 e0 02             	shl    $0x2,%eax
c01051d5:	01 c8                	add    %ecx,%eax
c01051d7:	83 c0 14             	add    $0x14,%eax
c01051da:	8b 00                	mov    (%eax),%eax
c01051dc:	83 f8 01             	cmp    $0x1,%eax
c01051df:	0f 85 0a 01 00 00    	jne    c01052ef <page_init+0x3c4>
            if (begin < freemem) {
c01051e5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01051e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01051ed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01051f0:	72 17                	jb     c0105209 <page_init+0x2de>
c01051f2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01051f5:	77 05                	ja     c01051fc <page_init+0x2d1>
c01051f7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01051fa:	76 0d                	jbe    c0105209 <page_init+0x2de>
                begin = freemem;
c01051fc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01051ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105202:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105209:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010520d:	72 1d                	jb     c010522c <page_init+0x301>
c010520f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105213:	77 09                	ja     c010521e <page_init+0x2f3>
c0105215:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010521c:	76 0e                	jbe    c010522c <page_init+0x301>
                end = KMEMSIZE;
c010521e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105225:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010522c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010522f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105232:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105235:	0f 87 b4 00 00 00    	ja     c01052ef <page_init+0x3c4>
c010523b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010523e:	72 09                	jb     c0105249 <page_init+0x31e>
c0105240:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105243:	0f 83 a6 00 00 00    	jae    c01052ef <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105249:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105250:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105253:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105256:	01 d0                	add    %edx,%eax
c0105258:	83 e8 01             	sub    $0x1,%eax
c010525b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010525e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105261:	ba 00 00 00 00       	mov    $0x0,%edx
c0105266:	f7 75 9c             	divl   -0x64(%ebp)
c0105269:	89 d0                	mov    %edx,%eax
c010526b:	8b 55 98             	mov    -0x68(%ebp),%edx
c010526e:	29 c2                	sub    %eax,%edx
c0105270:	89 d0                	mov    %edx,%eax
c0105272:	ba 00 00 00 00       	mov    $0x0,%edx
c0105277:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010527a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010527d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105280:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105283:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105286:	ba 00 00 00 00       	mov    $0x0,%edx
c010528b:	89 c7                	mov    %eax,%edi
c010528d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105293:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105296:	89 d0                	mov    %edx,%eax
c0105298:	83 e0 00             	and    $0x0,%eax
c010529b:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010529e:	8b 45 80             	mov    -0x80(%ebp),%eax
c01052a1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01052a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01052a7:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01052aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01052b3:	77 3a                	ja     c01052ef <page_init+0x3c4>
c01052b5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01052b8:	72 05                	jb     c01052bf <page_init+0x394>
c01052ba:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01052bd:	73 30                	jae    c01052ef <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01052bf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01052c2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01052c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01052c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01052cb:	29 c8                	sub    %ecx,%eax
c01052cd:	19 da                	sbb    %ebx,%edx
c01052cf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01052d3:	c1 ea 0c             	shr    $0xc,%edx
c01052d6:	89 c3                	mov    %eax,%ebx
c01052d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052db:	89 04 24             	mov    %eax,(%esp)
c01052de:	e8 a4 f8 ff ff       	call   c0104b87 <pa2page>
c01052e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01052e7:	89 04 24             	mov    %eax,(%esp)
c01052ea:	e8 55 fb ff ff       	call   c0104e44 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01052ef:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01052f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01052f6:	8b 00                	mov    (%eax),%eax
c01052f8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01052fb:	0f 8f 7e fe ff ff    	jg     c010517f <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0105301:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0105307:	5b                   	pop    %ebx
c0105308:	5e                   	pop    %esi
c0105309:	5f                   	pop    %edi
c010530a:	5d                   	pop    %ebp
c010530b:	c3                   	ret    

c010530c <enable_paging>:

static void
enable_paging(void) {
c010530c:	55                   	push   %ebp
c010530d:	89 e5                	mov    %esp,%ebp
c010530f:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0105312:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c0105317:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010531a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010531d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0105320:	0f 20 c0             	mov    %cr0,%eax
c0105323:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105326:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105329:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010532c:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105333:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105337:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010533a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010533d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105340:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105343:	c9                   	leave  
c0105344:	c3                   	ret    

c0105345 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105345:	55                   	push   %ebp
c0105346:	89 e5                	mov    %esp,%ebp
c0105348:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010534b:	8b 45 14             	mov    0x14(%ebp),%eax
c010534e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105351:	31 d0                	xor    %edx,%eax
c0105353:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105358:	85 c0                	test   %eax,%eax
c010535a:	74 24                	je     c0105380 <boot_map_segment+0x3b>
c010535c:	c7 44 24 0c 3a ac 10 	movl   $0xc010ac3a,0xc(%esp)
c0105363:	c0 
c0105364:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c010536b:	c0 
c010536c:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105373:	00 
c0105374:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c010537b:	e8 78 b9 ff ff       	call   c0100cf8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105380:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105387:	8b 45 0c             	mov    0xc(%ebp),%eax
c010538a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010538f:	89 c2                	mov    %eax,%edx
c0105391:	8b 45 10             	mov    0x10(%ebp),%eax
c0105394:	01 c2                	add    %eax,%edx
c0105396:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105399:	01 d0                	add    %edx,%eax
c010539b:	83 e8 01             	sub    $0x1,%eax
c010539e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01053a9:	f7 75 f0             	divl   -0x10(%ebp)
c01053ac:	89 d0                	mov    %edx,%eax
c01053ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053b1:	29 c2                	sub    %eax,%edx
c01053b3:	89 d0                	mov    %edx,%eax
c01053b5:	c1 e8 0c             	shr    $0xc,%eax
c01053b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01053bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053be:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053c9:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01053cc:	8b 45 14             	mov    0x14(%ebp),%eax
c01053cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053da:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01053dd:	eb 6b                	jmp    c010544a <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01053df:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01053e6:	00 
c01053e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f1:	89 04 24             	mov    %eax,(%esp)
c01053f4:	e8 d1 01 00 00       	call   c01055ca <get_pte>
c01053f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01053fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105400:	75 24                	jne    c0105426 <boot_map_segment+0xe1>
c0105402:	c7 44 24 0c 66 ac 10 	movl   $0xc010ac66,0xc(%esp)
c0105409:	c0 
c010540a:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105411:	c0 
c0105412:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105419:	00 
c010541a:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105421:	e8 d2 b8 ff ff       	call   c0100cf8 <__panic>
        *ptep = pa | PTE_P | perm;
c0105426:	8b 45 18             	mov    0x18(%ebp),%eax
c0105429:	8b 55 14             	mov    0x14(%ebp),%edx
c010542c:	09 d0                	or     %edx,%eax
c010542e:	83 c8 01             	or     $0x1,%eax
c0105431:	89 c2                	mov    %eax,%edx
c0105433:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105436:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105438:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010543c:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105443:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010544a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010544e:	75 8f                	jne    c01053df <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0105450:	c9                   	leave  
c0105451:	c3                   	ret    

c0105452 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105452:	55                   	push   %ebp
c0105453:	89 e5                	mov    %esp,%ebp
c0105455:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105458:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010545f:	e8 ff f9 ff ff       	call   c0104e63 <alloc_pages>
c0105464:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010546b:	75 1c                	jne    c0105489 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010546d:	c7 44 24 08 73 ac 10 	movl   $0xc010ac73,0x8(%esp)
c0105474:	c0 
c0105475:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010547c:	00 
c010547d:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105484:	e8 6f b8 ff ff       	call   c0100cf8 <__panic>
    }
    return page2kva(p);
c0105489:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010548c:	89 04 24             	mov    %eax,(%esp)
c010548f:	e8 38 f7 ff ff       	call   c0104bcc <page2kva>
}
c0105494:	c9                   	leave  
c0105495:	c3                   	ret    

c0105496 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105496:	55                   	push   %ebp
c0105497:	89 e5                	mov    %esp,%ebp
c0105499:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010549c:	e8 70 f9 ff ff       	call   c0104e11 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01054a1:	e8 85 fa ff ff       	call   c0104f2b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01054a6:	e8 4b 05 00 00       	call   c01059f6 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01054ab:	e8 a2 ff ff ff       	call   c0105452 <boot_alloc_page>
c01054b0:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c01054b5:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01054ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01054c1:	00 
c01054c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01054c9:	00 
c01054ca:	89 04 24             	mov    %eax,(%esp)
c01054cd:	e8 ad 47 00 00       	call   c0109c7f <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01054d2:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01054d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054da:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01054e1:	77 23                	ja     c0105506 <pmm_init+0x70>
c01054e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054ea:	c7 44 24 08 08 ac 10 	movl   $0xc010ac08,0x8(%esp)
c01054f1:	c0 
c01054f2:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01054f9:	00 
c01054fa:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105501:	e8 f2 b7 ff ff       	call   c0100cf8 <__panic>
c0105506:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105509:	05 00 00 00 40       	add    $0x40000000,%eax
c010550e:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c0105513:	e8 fc 04 00 00       	call   c0105a14 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105518:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010551d:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105523:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105528:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010552b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105532:	77 23                	ja     c0105557 <pmm_init+0xc1>
c0105534:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105537:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010553b:	c7 44 24 08 08 ac 10 	movl   $0xc010ac08,0x8(%esp)
c0105542:	c0 
c0105543:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c010554a:	00 
c010554b:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105552:	e8 a1 b7 ff ff       	call   c0100cf8 <__panic>
c0105557:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010555a:	05 00 00 00 40       	add    $0x40000000,%eax
c010555f:	83 c8 03             	or     $0x3,%eax
c0105562:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105564:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105569:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105570:	00 
c0105571:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105578:	00 
c0105579:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105580:	38 
c0105581:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105588:	c0 
c0105589:	89 04 24             	mov    %eax,(%esp)
c010558c:	e8 b4 fd ff ff       	call   c0105345 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0105591:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105596:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c010559c:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01055a2:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01055a4:	e8 63 fd ff ff       	call   c010530c <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01055a9:	e8 74 f7 ff ff       	call   c0104d22 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01055ae:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01055b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01055b9:	e8 f1 0a 00 00       	call   c01060af <check_boot_pgdir>

    print_pgdir();
c01055be:	e8 7e 0f 00 00       	call   c0106541 <print_pgdir>
    
    kmalloc_init();
c01055c3:	e8 fe f2 ff ff       	call   c01048c6 <kmalloc_init>

}
c01055c8:	c9                   	leave  
c01055c9:	c3                   	ret    

c01055ca <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01055ca:	55                   	push   %ebp
c01055cb:	89 e5                	mov    %esp,%ebp
c01055cd:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
	pde_t *pdep = &pgdir[PDX(la)];
c01055d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055d3:	c1 e8 16             	shr    $0x16,%eax
c01055d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01055dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e0:	01 d0                	add    %edx,%eax
c01055e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!(*pdep & PTE_P)){
c01055e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055e8:	8b 00                	mov    (%eax),%eax
c01055ea:	83 e0 01             	and    $0x1,%eax
c01055ed:	85 c0                	test   %eax,%eax
c01055ef:	0f 85 b6 00 00 00    	jne    c01056ab <get_pte+0xe1>
        struct  Page *p = NULL;
c01055f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        if(create)
c01055fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105600:	74 0f                	je     c0105611 <get_pte+0x47>
            p = alloc_page();
c0105602:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105609:	e8 55 f8 ff ff       	call   c0104e63 <alloc_pages>
c010560e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p == NULL)
c0105611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105615:	75 0a                	jne    c0105621 <get_pte+0x57>
            return NULL;
c0105617:	b8 00 00 00 00       	mov    $0x0,%eax
c010561c:	e9 ef 00 00 00       	jmp    c0105710 <get_pte+0x146>
        set_page_ref(p, 1);
c0105621:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105628:	00 
c0105629:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010562c:	89 04 24             	mov    %eax,(%esp)
c010562f:	e8 34 f6 ff ff       	call   c0104c68 <set_page_ref>
        uintptr_t pa = page2pa(p);
c0105634:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105637:	89 04 24             	mov    %eax,(%esp)
c010563a:	e8 32 f5 ff ff       	call   c0104b71 <page2pa>
c010563f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0105642:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105645:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105648:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010564b:	c1 e8 0c             	shr    $0xc,%eax
c010564e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105651:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105656:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105659:	72 23                	jb     c010567e <get_pte+0xb4>
c010565b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010565e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105662:	c7 44 24 08 64 ab 10 	movl   $0xc010ab64,0x8(%esp)
c0105669:	c0 
c010566a:	c7 44 24 04 98 01 00 	movl   $0x198,0x4(%esp)
c0105671:	00 
c0105672:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105679:	e8 7a b6 ff ff       	call   c0100cf8 <__panic>
c010567e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105681:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105686:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010568d:	00 
c010568e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105695:	00 
c0105696:	89 04 24             	mov    %eax,(%esp)
c0105699:	e8 e1 45 00 00       	call   c0109c7f <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010569e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01056a1:	83 c8 07             	or     $0x7,%eax
c01056a4:	89 c2                	mov    %eax,%edx
c01056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056a9:	89 10                	mov    %edx,(%eax)
    }
    pde_t *a = (pte_t*)KADDR(PDE_ADDR(*pdep));
c01056ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056ae:	8b 00                	mov    (%eax),%eax
c01056b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01056b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01056b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056bb:	c1 e8 0c             	shr    $0xc,%eax
c01056be:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01056c1:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01056c6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01056c9:	72 23                	jb     c01056ee <get_pte+0x124>
c01056cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056d2:	c7 44 24 08 64 ab 10 	movl   $0xc010ab64,0x8(%esp)
c01056d9:	c0 
c01056da:	c7 44 24 04 9b 01 00 	movl   $0x19b,0x4(%esp)
c01056e1:	00 
c01056e2:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01056e9:	e8 0a b6 ff ff       	call   c0100cf8 <__panic>
c01056ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056f1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01056f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return &a[PTX(la)];
c01056f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056fc:	c1 e8 0c             	shr    $0xc,%eax
c01056ff:	25 ff 03 00 00       	and    $0x3ff,%eax
c0105704:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010570b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010570e:	01 d0                	add    %edx,%eax
}
c0105710:	c9                   	leave  
c0105711:	c3                   	ret    

c0105712 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105712:	55                   	push   %ebp
c0105713:	89 e5                	mov    %esp,%ebp
c0105715:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105718:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010571f:	00 
c0105720:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105723:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105727:	8b 45 08             	mov    0x8(%ebp),%eax
c010572a:	89 04 24             	mov    %eax,(%esp)
c010572d:	e8 98 fe ff ff       	call   c01055ca <get_pte>
c0105732:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105739:	74 08                	je     c0105743 <get_page+0x31>
        *ptep_store = ptep;
c010573b:	8b 45 10             	mov    0x10(%ebp),%eax
c010573e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105741:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105747:	74 1b                	je     c0105764 <get_page+0x52>
c0105749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010574c:	8b 00                	mov    (%eax),%eax
c010574e:	83 e0 01             	and    $0x1,%eax
c0105751:	85 c0                	test   %eax,%eax
c0105753:	74 0f                	je     c0105764 <get_page+0x52>
        return pa2page(*ptep);
c0105755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105758:	8b 00                	mov    (%eax),%eax
c010575a:	89 04 24             	mov    %eax,(%esp)
c010575d:	e8 25 f4 ff ff       	call   c0104b87 <pa2page>
c0105762:	eb 05                	jmp    c0105769 <get_page+0x57>
    }
    return NULL;
c0105764:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105769:	c9                   	leave  
c010576a:	c3                   	ret    

c010576b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010576b:	55                   	push   %ebp
c010576c:	89 e5                	mov    %esp,%ebp
c010576e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
	if(*ptep & PTE_P){
c0105771:	8b 45 10             	mov    0x10(%ebp),%eax
c0105774:	8b 00                	mov    (%eax),%eax
c0105776:	83 e0 01             	and    $0x1,%eax
c0105779:	85 c0                	test   %eax,%eax
c010577b:	74 52                	je     c01057cf <page_remove_pte+0x64>
        struct Page *p = pte2page(*ptep);
c010577d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105780:	8b 00                	mov    (%eax),%eax
c0105782:	89 04 24             	mov    %eax,(%esp)
c0105785:	e8 96 f4 ff ff       	call   c0104c20 <pte2page>
c010578a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(p);
c010578d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105790:	89 04 24             	mov    %eax,(%esp)
c0105793:	e8 f4 f4 ff ff       	call   c0104c8c <page_ref_dec>
        if(p->ref == 0)
c0105798:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010579b:	8b 00                	mov    (%eax),%eax
c010579d:	85 c0                	test   %eax,%eax
c010579f:	75 13                	jne    c01057b4 <page_remove_pte+0x49>
            free_page(p);
c01057a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01057a8:	00 
c01057a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057ac:	89 04 24             	mov    %eax,(%esp)
c01057af:	e8 1a f7 ff ff       	call   c0104ece <free_pages>
        *ptep = 0;
c01057b4:	8b 45 10             	mov    0x10(%ebp),%eax
c01057b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01057bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c7:	89 04 24             	mov    %eax,(%esp)
c01057ca:	e8 ff 00 00 00       	call   c01058ce <tlb_invalidate>
    }
}
c01057cf:	c9                   	leave  
c01057d0:	c3                   	ret    

c01057d1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01057d1:	55                   	push   %ebp
c01057d2:	89 e5                	mov    %esp,%ebp
c01057d4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01057d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01057de:	00 
c01057df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e9:	89 04 24             	mov    %eax,(%esp)
c01057ec:	e8 d9 fd ff ff       	call   c01055ca <get_pte>
c01057f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01057f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057f8:	74 19                	je     c0105813 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01057fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105801:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105804:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105808:	8b 45 08             	mov    0x8(%ebp),%eax
c010580b:	89 04 24             	mov    %eax,(%esp)
c010580e:	e8 58 ff ff ff       	call   c010576b <page_remove_pte>
    }
}
c0105813:	c9                   	leave  
c0105814:	c3                   	ret    

c0105815 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105815:	55                   	push   %ebp
c0105816:	89 e5                	mov    %esp,%ebp
c0105818:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010581b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105822:	00 
c0105823:	8b 45 10             	mov    0x10(%ebp),%eax
c0105826:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582a:	8b 45 08             	mov    0x8(%ebp),%eax
c010582d:	89 04 24             	mov    %eax,(%esp)
c0105830:	e8 95 fd ff ff       	call   c01055ca <get_pte>
c0105835:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105838:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010583c:	75 0a                	jne    c0105848 <page_insert+0x33>
        return -E_NO_MEM;
c010583e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105843:	e9 84 00 00 00       	jmp    c01058cc <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105848:	8b 45 0c             	mov    0xc(%ebp),%eax
c010584b:	89 04 24             	mov    %eax,(%esp)
c010584e:	e8 22 f4 ff ff       	call   c0104c75 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105853:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105856:	8b 00                	mov    (%eax),%eax
c0105858:	83 e0 01             	and    $0x1,%eax
c010585b:	85 c0                	test   %eax,%eax
c010585d:	74 3e                	je     c010589d <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010585f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105862:	8b 00                	mov    (%eax),%eax
c0105864:	89 04 24             	mov    %eax,(%esp)
c0105867:	e8 b4 f3 ff ff       	call   c0104c20 <pte2page>
c010586c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010586f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105872:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105875:	75 0d                	jne    c0105884 <page_insert+0x6f>
            page_ref_dec(page);
c0105877:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587a:	89 04 24             	mov    %eax,(%esp)
c010587d:	e8 0a f4 ff ff       	call   c0104c8c <page_ref_dec>
c0105882:	eb 19                	jmp    c010589d <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105884:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105887:	89 44 24 08          	mov    %eax,0x8(%esp)
c010588b:	8b 45 10             	mov    0x10(%ebp),%eax
c010588e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105892:	8b 45 08             	mov    0x8(%ebp),%eax
c0105895:	89 04 24             	mov    %eax,(%esp)
c0105898:	e8 ce fe ff ff       	call   c010576b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010589d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a0:	89 04 24             	mov    %eax,(%esp)
c01058a3:	e8 c9 f2 ff ff       	call   c0104b71 <page2pa>
c01058a8:	0b 45 14             	or     0x14(%ebp),%eax
c01058ab:	83 c8 01             	or     $0x1,%eax
c01058ae:	89 c2                	mov    %eax,%edx
c01058b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058b3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01058b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bf:	89 04 24             	mov    %eax,(%esp)
c01058c2:	e8 07 00 00 00       	call   c01058ce <tlb_invalidate>
    return 0;
c01058c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01058cc:	c9                   	leave  
c01058cd:	c3                   	ret    

c01058ce <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01058ce:	55                   	push   %ebp
c01058cf:	89 e5                	mov    %esp,%ebp
c01058d1:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01058d4:	0f 20 d8             	mov    %cr3,%eax
c01058d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01058da:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01058dd:	89 c2                	mov    %eax,%edx
c01058df:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058e5:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01058ec:	77 23                	ja     c0105911 <tlb_invalidate+0x43>
c01058ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058f5:	c7 44 24 08 08 ac 10 	movl   $0xc010ac08,0x8(%esp)
c01058fc:	c0 
c01058fd:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0105904:	00 
c0105905:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c010590c:	e8 e7 b3 ff ff       	call   c0100cf8 <__panic>
c0105911:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105914:	05 00 00 00 40       	add    $0x40000000,%eax
c0105919:	39 c2                	cmp    %eax,%edx
c010591b:	75 0c                	jne    c0105929 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010591d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105920:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105923:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105926:	0f 01 38             	invlpg (%eax)
    }
}
c0105929:	c9                   	leave  
c010592a:	c3                   	ret    

c010592b <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010592b:	55                   	push   %ebp
c010592c:	89 e5                	mov    %esp,%ebp
c010592e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105931:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105938:	e8 26 f5 ff ff       	call   c0104e63 <alloc_pages>
c010593d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105940:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105944:	0f 84 a7 00 00 00    	je     c01059f1 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010594a:	8b 45 10             	mov    0x10(%ebp),%eax
c010594d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105951:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105954:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105958:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010595f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105962:	89 04 24             	mov    %eax,(%esp)
c0105965:	e8 ab fe ff ff       	call   c0105815 <page_insert>
c010596a:	85 c0                	test   %eax,%eax
c010596c:	74 1a                	je     c0105988 <pgdir_alloc_page+0x5d>
            free_page(page);
c010596e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105975:	00 
c0105976:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105979:	89 04 24             	mov    %eax,(%esp)
c010597c:	e8 4d f5 ff ff       	call   c0104ece <free_pages>
            return NULL;
c0105981:	b8 00 00 00 00       	mov    $0x0,%eax
c0105986:	eb 6c                	jmp    c01059f4 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105988:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c010598d:	85 c0                	test   %eax,%eax
c010598f:	74 60                	je     c01059f1 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105991:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0105996:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010599d:	00 
c010599e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01059a5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059ac:	89 04 24             	mov    %eax,(%esp)
c01059af:	e8 3e 0e 00 00       	call   c01067f2 <swap_map_swappable>
            page->pra_vaddr=la;
c01059b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059b7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059ba:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01059bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c0:	89 04 24             	mov    %eax,(%esp)
c01059c3:	e8 96 f2 ff ff       	call   c0104c5e <page_ref>
c01059c8:	83 f8 01             	cmp    $0x1,%eax
c01059cb:	74 24                	je     c01059f1 <pgdir_alloc_page+0xc6>
c01059cd:	c7 44 24 0c 8c ac 10 	movl   $0xc010ac8c,0xc(%esp)
c01059d4:	c0 
c01059d5:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c01059dc:	c0 
c01059dd:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c01059e4:	00 
c01059e5:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01059ec:	e8 07 b3 ff ff       	call   c0100cf8 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01059f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059f4:	c9                   	leave  
c01059f5:	c3                   	ret    

c01059f6 <check_alloc_page>:

static void
check_alloc_page(void) {
c01059f6:	55                   	push   %ebp
c01059f7:	89 e5                	mov    %esp,%ebp
c01059f9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01059fc:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0105a01:	8b 40 18             	mov    0x18(%eax),%eax
c0105a04:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105a06:	c7 04 24 a0 ac 10 c0 	movl   $0xc010aca0,(%esp)
c0105a0d:	e8 41 a9 ff ff       	call   c0100353 <cprintf>
}
c0105a12:	c9                   	leave  
c0105a13:	c3                   	ret    

c0105a14 <check_pgdir>:

static void
check_pgdir(void) {
c0105a14:	55                   	push   %ebp
c0105a15:	89 e5                	mov    %esp,%ebp
c0105a17:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105a1a:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105a1f:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105a24:	76 24                	jbe    c0105a4a <check_pgdir+0x36>
c0105a26:	c7 44 24 0c bf ac 10 	movl   $0xc010acbf,0xc(%esp)
c0105a2d:	c0 
c0105a2e:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105a35:	c0 
c0105a36:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105a3d:	00 
c0105a3e:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105a45:	e8 ae b2 ff ff       	call   c0100cf8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105a4a:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a4f:	85 c0                	test   %eax,%eax
c0105a51:	74 0e                	je     c0105a61 <check_pgdir+0x4d>
c0105a53:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a58:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105a5d:	85 c0                	test   %eax,%eax
c0105a5f:	74 24                	je     c0105a85 <check_pgdir+0x71>
c0105a61:	c7 44 24 0c dc ac 10 	movl   $0xc010acdc,0xc(%esp)
c0105a68:	c0 
c0105a69:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105a70:	c0 
c0105a71:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105a78:	00 
c0105a79:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105a80:	e8 73 b2 ff ff       	call   c0100cf8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105a85:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a91:	00 
c0105a92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a99:	00 
c0105a9a:	89 04 24             	mov    %eax,(%esp)
c0105a9d:	e8 70 fc ff ff       	call   c0105712 <get_page>
c0105aa2:	85 c0                	test   %eax,%eax
c0105aa4:	74 24                	je     c0105aca <check_pgdir+0xb6>
c0105aa6:	c7 44 24 0c 14 ad 10 	movl   $0xc010ad14,0xc(%esp)
c0105aad:	c0 
c0105aae:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105ab5:	c0 
c0105ab6:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105abd:	00 
c0105abe:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105ac5:	e8 2e b2 ff ff       	call   c0100cf8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105aca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ad1:	e8 8d f3 ff ff       	call   c0104e63 <alloc_pages>
c0105ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105ad9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ade:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105ae5:	00 
c0105ae6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105aed:	00 
c0105aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105af1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105af5:	89 04 24             	mov    %eax,(%esp)
c0105af8:	e8 18 fd ff ff       	call   c0105815 <page_insert>
c0105afd:	85 c0                	test   %eax,%eax
c0105aff:	74 24                	je     c0105b25 <check_pgdir+0x111>
c0105b01:	c7 44 24 0c 3c ad 10 	movl   $0xc010ad3c,0xc(%esp)
c0105b08:	c0 
c0105b09:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105b10:	c0 
c0105b11:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105b18:	00 
c0105b19:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105b20:	e8 d3 b1 ff ff       	call   c0100cf8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105b25:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b31:	00 
c0105b32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b39:	00 
c0105b3a:	89 04 24             	mov    %eax,(%esp)
c0105b3d:	e8 88 fa ff ff       	call   c01055ca <get_pte>
c0105b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105b49:	75 24                	jne    c0105b6f <check_pgdir+0x15b>
c0105b4b:	c7 44 24 0c 68 ad 10 	movl   $0xc010ad68,0xc(%esp)
c0105b52:	c0 
c0105b53:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105b5a:	c0 
c0105b5b:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105b62:	00 
c0105b63:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105b6a:	e8 89 b1 ff ff       	call   c0100cf8 <__panic>
    assert(pa2page(*ptep) == p1);
c0105b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b72:	8b 00                	mov    (%eax),%eax
c0105b74:	89 04 24             	mov    %eax,(%esp)
c0105b77:	e8 0b f0 ff ff       	call   c0104b87 <pa2page>
c0105b7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105b7f:	74 24                	je     c0105ba5 <check_pgdir+0x191>
c0105b81:	c7 44 24 0c 95 ad 10 	movl   $0xc010ad95,0xc(%esp)
c0105b88:	c0 
c0105b89:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105b90:	c0 
c0105b91:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105b98:	00 
c0105b99:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105ba0:	e8 53 b1 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p1) == 1);
c0105ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ba8:	89 04 24             	mov    %eax,(%esp)
c0105bab:	e8 ae f0 ff ff       	call   c0104c5e <page_ref>
c0105bb0:	83 f8 01             	cmp    $0x1,%eax
c0105bb3:	74 24                	je     c0105bd9 <check_pgdir+0x1c5>
c0105bb5:	c7 44 24 0c aa ad 10 	movl   $0xc010adaa,0xc(%esp)
c0105bbc:	c0 
c0105bbd:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105bc4:	c0 
c0105bc5:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105bcc:	00 
c0105bcd:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105bd4:	e8 1f b1 ff ff       	call   c0100cf8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105bd9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105bde:	8b 00                	mov    (%eax),%eax
c0105be0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105beb:	c1 e8 0c             	shr    $0xc,%eax
c0105bee:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105bf1:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105bf6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105bf9:	72 23                	jb     c0105c1e <check_pgdir+0x20a>
c0105bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105bfe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c02:	c7 44 24 08 64 ab 10 	movl   $0xc010ab64,0x8(%esp)
c0105c09:	c0 
c0105c0a:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105c11:	00 
c0105c12:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105c19:	e8 da b0 ff ff       	call   c0100cf8 <__panic>
c0105c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c21:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105c26:	83 c0 04             	add    $0x4,%eax
c0105c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105c2c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c31:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c38:	00 
c0105c39:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105c40:	00 
c0105c41:	89 04 24             	mov    %eax,(%esp)
c0105c44:	e8 81 f9 ff ff       	call   c01055ca <get_pte>
c0105c49:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105c4c:	74 24                	je     c0105c72 <check_pgdir+0x25e>
c0105c4e:	c7 44 24 0c bc ad 10 	movl   $0xc010adbc,0xc(%esp)
c0105c55:	c0 
c0105c56:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105c5d:	c0 
c0105c5e:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105c65:	00 
c0105c66:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105c6d:	e8 86 b0 ff ff       	call   c0100cf8 <__panic>

    p2 = alloc_page();
c0105c72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c79:	e8 e5 f1 ff ff       	call   c0104e63 <alloc_pages>
c0105c7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105c81:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c86:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105c8d:	00 
c0105c8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105c95:	00 
c0105c96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c99:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c9d:	89 04 24             	mov    %eax,(%esp)
c0105ca0:	e8 70 fb ff ff       	call   c0105815 <page_insert>
c0105ca5:	85 c0                	test   %eax,%eax
c0105ca7:	74 24                	je     c0105ccd <check_pgdir+0x2b9>
c0105ca9:	c7 44 24 0c e4 ad 10 	movl   $0xc010ade4,0xc(%esp)
c0105cb0:	c0 
c0105cb1:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105cb8:	c0 
c0105cb9:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105cc0:	00 
c0105cc1:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105cc8:	e8 2b b0 ff ff       	call   c0100cf8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105ccd:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105cd2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105cd9:	00 
c0105cda:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105ce1:	00 
c0105ce2:	89 04 24             	mov    %eax,(%esp)
c0105ce5:	e8 e0 f8 ff ff       	call   c01055ca <get_pte>
c0105cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ced:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105cf1:	75 24                	jne    c0105d17 <check_pgdir+0x303>
c0105cf3:	c7 44 24 0c 1c ae 10 	movl   $0xc010ae1c,0xc(%esp)
c0105cfa:	c0 
c0105cfb:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105d02:	c0 
c0105d03:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105d0a:	00 
c0105d0b:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105d12:	e8 e1 af ff ff       	call   c0100cf8 <__panic>
    assert(*ptep & PTE_U);
c0105d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d1a:	8b 00                	mov    (%eax),%eax
c0105d1c:	83 e0 04             	and    $0x4,%eax
c0105d1f:	85 c0                	test   %eax,%eax
c0105d21:	75 24                	jne    c0105d47 <check_pgdir+0x333>
c0105d23:	c7 44 24 0c 4c ae 10 	movl   $0xc010ae4c,0xc(%esp)
c0105d2a:	c0 
c0105d2b:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105d32:	c0 
c0105d33:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105d3a:	00 
c0105d3b:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105d42:	e8 b1 af ff ff       	call   c0100cf8 <__panic>
    assert(*ptep & PTE_W);
c0105d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d4a:	8b 00                	mov    (%eax),%eax
c0105d4c:	83 e0 02             	and    $0x2,%eax
c0105d4f:	85 c0                	test   %eax,%eax
c0105d51:	75 24                	jne    c0105d77 <check_pgdir+0x363>
c0105d53:	c7 44 24 0c 5a ae 10 	movl   $0xc010ae5a,0xc(%esp)
c0105d5a:	c0 
c0105d5b:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105d62:	c0 
c0105d63:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105d6a:	00 
c0105d6b:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105d72:	e8 81 af ff ff       	call   c0100cf8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105d77:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d7c:	8b 00                	mov    (%eax),%eax
c0105d7e:	83 e0 04             	and    $0x4,%eax
c0105d81:	85 c0                	test   %eax,%eax
c0105d83:	75 24                	jne    c0105da9 <check_pgdir+0x395>
c0105d85:	c7 44 24 0c 68 ae 10 	movl   $0xc010ae68,0xc(%esp)
c0105d8c:	c0 
c0105d8d:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105d94:	c0 
c0105d95:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105d9c:	00 
c0105d9d:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105da4:	e8 4f af ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 1);
c0105da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dac:	89 04 24             	mov    %eax,(%esp)
c0105daf:	e8 aa ee ff ff       	call   c0104c5e <page_ref>
c0105db4:	83 f8 01             	cmp    $0x1,%eax
c0105db7:	74 24                	je     c0105ddd <check_pgdir+0x3c9>
c0105db9:	c7 44 24 0c 7e ae 10 	movl   $0xc010ae7e,0xc(%esp)
c0105dc0:	c0 
c0105dc1:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105dc8:	c0 
c0105dc9:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105dd0:	00 
c0105dd1:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105dd8:	e8 1b af ff ff       	call   c0100cf8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105ddd:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105de2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105de9:	00 
c0105dea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105df1:	00 
c0105df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105df5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105df9:	89 04 24             	mov    %eax,(%esp)
c0105dfc:	e8 14 fa ff ff       	call   c0105815 <page_insert>
c0105e01:	85 c0                	test   %eax,%eax
c0105e03:	74 24                	je     c0105e29 <check_pgdir+0x415>
c0105e05:	c7 44 24 0c 90 ae 10 	movl   $0xc010ae90,0xc(%esp)
c0105e0c:	c0 
c0105e0d:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105e14:	c0 
c0105e15:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105e1c:	00 
c0105e1d:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105e24:	e8 cf ae ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p1) == 2);
c0105e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e2c:	89 04 24             	mov    %eax,(%esp)
c0105e2f:	e8 2a ee ff ff       	call   c0104c5e <page_ref>
c0105e34:	83 f8 02             	cmp    $0x2,%eax
c0105e37:	74 24                	je     c0105e5d <check_pgdir+0x449>
c0105e39:	c7 44 24 0c bc ae 10 	movl   $0xc010aebc,0xc(%esp)
c0105e40:	c0 
c0105e41:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105e48:	c0 
c0105e49:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105e50:	00 
c0105e51:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105e58:	e8 9b ae ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 0);
c0105e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e60:	89 04 24             	mov    %eax,(%esp)
c0105e63:	e8 f6 ed ff ff       	call   c0104c5e <page_ref>
c0105e68:	85 c0                	test   %eax,%eax
c0105e6a:	74 24                	je     c0105e90 <check_pgdir+0x47c>
c0105e6c:	c7 44 24 0c ce ae 10 	movl   $0xc010aece,0xc(%esp)
c0105e73:	c0 
c0105e74:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105e7b:	c0 
c0105e7c:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105e83:	00 
c0105e84:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105e8b:	e8 68 ae ff ff       	call   c0100cf8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105e90:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105e95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e9c:	00 
c0105e9d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105ea4:	00 
c0105ea5:	89 04 24             	mov    %eax,(%esp)
c0105ea8:	e8 1d f7 ff ff       	call   c01055ca <get_pte>
c0105ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105eb4:	75 24                	jne    c0105eda <check_pgdir+0x4c6>
c0105eb6:	c7 44 24 0c 1c ae 10 	movl   $0xc010ae1c,0xc(%esp)
c0105ebd:	c0 
c0105ebe:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105ec5:	c0 
c0105ec6:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105ecd:	00 
c0105ece:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105ed5:	e8 1e ae ff ff       	call   c0100cf8 <__panic>
    assert(pa2page(*ptep) == p1);
c0105eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105edd:	8b 00                	mov    (%eax),%eax
c0105edf:	89 04 24             	mov    %eax,(%esp)
c0105ee2:	e8 a0 ec ff ff       	call   c0104b87 <pa2page>
c0105ee7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105eea:	74 24                	je     c0105f10 <check_pgdir+0x4fc>
c0105eec:	c7 44 24 0c 95 ad 10 	movl   $0xc010ad95,0xc(%esp)
c0105ef3:	c0 
c0105ef4:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105efb:	c0 
c0105efc:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105f03:	00 
c0105f04:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105f0b:	e8 e8 ad ff ff       	call   c0100cf8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0105f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f13:	8b 00                	mov    (%eax),%eax
c0105f15:	83 e0 04             	and    $0x4,%eax
c0105f18:	85 c0                	test   %eax,%eax
c0105f1a:	74 24                	je     c0105f40 <check_pgdir+0x52c>
c0105f1c:	c7 44 24 0c e0 ae 10 	movl   $0xc010aee0,0xc(%esp)
c0105f23:	c0 
c0105f24:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105f2b:	c0 
c0105f2c:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105f33:	00 
c0105f34:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105f3b:	e8 b8 ad ff ff       	call   c0100cf8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105f40:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105f4c:	00 
c0105f4d:	89 04 24             	mov    %eax,(%esp)
c0105f50:	e8 7c f8 ff ff       	call   c01057d1 <page_remove>
    assert(page_ref(p1) == 1);
c0105f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f58:	89 04 24             	mov    %eax,(%esp)
c0105f5b:	e8 fe ec ff ff       	call   c0104c5e <page_ref>
c0105f60:	83 f8 01             	cmp    $0x1,%eax
c0105f63:	74 24                	je     c0105f89 <check_pgdir+0x575>
c0105f65:	c7 44 24 0c aa ad 10 	movl   $0xc010adaa,0xc(%esp)
c0105f6c:	c0 
c0105f6d:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105f74:	c0 
c0105f75:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105f7c:	00 
c0105f7d:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105f84:	e8 6f ad ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 0);
c0105f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f8c:	89 04 24             	mov    %eax,(%esp)
c0105f8f:	e8 ca ec ff ff       	call   c0104c5e <page_ref>
c0105f94:	85 c0                	test   %eax,%eax
c0105f96:	74 24                	je     c0105fbc <check_pgdir+0x5a8>
c0105f98:	c7 44 24 0c ce ae 10 	movl   $0xc010aece,0xc(%esp)
c0105f9f:	c0 
c0105fa0:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105fa7:	c0 
c0105fa8:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105faf:	00 
c0105fb0:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105fb7:	e8 3c ad ff ff       	call   c0100cf8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105fbc:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105fc1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105fc8:	00 
c0105fc9:	89 04 24             	mov    %eax,(%esp)
c0105fcc:	e8 00 f8 ff ff       	call   c01057d1 <page_remove>
    assert(page_ref(p1) == 0);
c0105fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fd4:	89 04 24             	mov    %eax,(%esp)
c0105fd7:	e8 82 ec ff ff       	call   c0104c5e <page_ref>
c0105fdc:	85 c0                	test   %eax,%eax
c0105fde:	74 24                	je     c0106004 <check_pgdir+0x5f0>
c0105fe0:	c7 44 24 0c f5 ae 10 	movl   $0xc010aef5,0xc(%esp)
c0105fe7:	c0 
c0105fe8:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0105fef:	c0 
c0105ff0:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0105ff7:	00 
c0105ff8:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0105fff:	e8 f4 ac ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p2) == 0);
c0106004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106007:	89 04 24             	mov    %eax,(%esp)
c010600a:	e8 4f ec ff ff       	call   c0104c5e <page_ref>
c010600f:	85 c0                	test   %eax,%eax
c0106011:	74 24                	je     c0106037 <check_pgdir+0x623>
c0106013:	c7 44 24 0c ce ae 10 	movl   $0xc010aece,0xc(%esp)
c010601a:	c0 
c010601b:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0106022:	c0 
c0106023:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c010602a:	00 
c010602b:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0106032:	e8 c1 ac ff ff       	call   c0100cf8 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0106037:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010603c:	8b 00                	mov    (%eax),%eax
c010603e:	89 04 24             	mov    %eax,(%esp)
c0106041:	e8 41 eb ff ff       	call   c0104b87 <pa2page>
c0106046:	89 04 24             	mov    %eax,(%esp)
c0106049:	e8 10 ec ff ff       	call   c0104c5e <page_ref>
c010604e:	83 f8 01             	cmp    $0x1,%eax
c0106051:	74 24                	je     c0106077 <check_pgdir+0x663>
c0106053:	c7 44 24 0c 08 af 10 	movl   $0xc010af08,0xc(%esp)
c010605a:	c0 
c010605b:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0106062:	c0 
c0106063:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c010606a:	00 
c010606b:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0106072:	e8 81 ac ff ff       	call   c0100cf8 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0106077:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010607c:	8b 00                	mov    (%eax),%eax
c010607e:	89 04 24             	mov    %eax,(%esp)
c0106081:	e8 01 eb ff ff       	call   c0104b87 <pa2page>
c0106086:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010608d:	00 
c010608e:	89 04 24             	mov    %eax,(%esp)
c0106091:	e8 38 ee ff ff       	call   c0104ece <free_pages>
    boot_pgdir[0] = 0;
c0106096:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010609b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01060a1:	c7 04 24 2e af 10 c0 	movl   $0xc010af2e,(%esp)
c01060a8:	e8 a6 a2 ff ff       	call   c0100353 <cprintf>
}
c01060ad:	c9                   	leave  
c01060ae:	c3                   	ret    

c01060af <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01060af:	55                   	push   %ebp
c01060b0:	89 e5                	mov    %esp,%ebp
c01060b2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01060b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01060bc:	e9 ca 00 00 00       	jmp    c010618b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01060c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060ca:	c1 e8 0c             	shr    $0xc,%eax
c01060cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060d0:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01060d5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01060d8:	72 23                	jb     c01060fd <check_boot_pgdir+0x4e>
c01060da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060e1:	c7 44 24 08 64 ab 10 	movl   $0xc010ab64,0x8(%esp)
c01060e8:	c0 
c01060e9:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c01060f0:	00 
c01060f1:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01060f8:	e8 fb ab ff ff       	call   c0100cf8 <__panic>
c01060fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106100:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106105:	89 c2                	mov    %eax,%edx
c0106107:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010610c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106113:	00 
c0106114:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106118:	89 04 24             	mov    %eax,(%esp)
c010611b:	e8 aa f4 ff ff       	call   c01055ca <get_pte>
c0106120:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106123:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106127:	75 24                	jne    c010614d <check_boot_pgdir+0x9e>
c0106129:	c7 44 24 0c 48 af 10 	movl   $0xc010af48,0xc(%esp)
c0106130:	c0 
c0106131:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0106138:	c0 
c0106139:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c0106140:	00 
c0106141:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0106148:	e8 ab ab ff ff       	call   c0100cf8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010614d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106150:	8b 00                	mov    (%eax),%eax
c0106152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106157:	89 c2                	mov    %eax,%edx
c0106159:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010615c:	39 c2                	cmp    %eax,%edx
c010615e:	74 24                	je     c0106184 <check_boot_pgdir+0xd5>
c0106160:	c7 44 24 0c 85 af 10 	movl   $0xc010af85,0xc(%esp)
c0106167:	c0 
c0106168:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c010616f:	c0 
c0106170:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0106177:	00 
c0106178:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c010617f:	e8 74 ab ff ff       	call   c0100cf8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106184:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010618b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010618e:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0106193:	39 c2                	cmp    %eax,%edx
c0106195:	0f 82 26 ff ff ff    	jb     c01060c1 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010619b:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01061a0:	05 ac 0f 00 00       	add    $0xfac,%eax
c01061a5:	8b 00                	mov    (%eax),%eax
c01061a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01061ac:	89 c2                	mov    %eax,%edx
c01061ae:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01061b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061b6:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01061bd:	77 23                	ja     c01061e2 <check_boot_pgdir+0x133>
c01061bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061c6:	c7 44 24 08 08 ac 10 	movl   $0xc010ac08,0x8(%esp)
c01061cd:	c0 
c01061ce:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c01061d5:	00 
c01061d6:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01061dd:	e8 16 ab ff ff       	call   c0100cf8 <__panic>
c01061e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061e5:	05 00 00 00 40       	add    $0x40000000,%eax
c01061ea:	39 c2                	cmp    %eax,%edx
c01061ec:	74 24                	je     c0106212 <check_boot_pgdir+0x163>
c01061ee:	c7 44 24 0c 9c af 10 	movl   $0xc010af9c,0xc(%esp)
c01061f5:	c0 
c01061f6:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c01061fd:	c0 
c01061fe:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0106205:	00 
c0106206:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c010620d:	e8 e6 aa ff ff       	call   c0100cf8 <__panic>

    assert(boot_pgdir[0] == 0);
c0106212:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106217:	8b 00                	mov    (%eax),%eax
c0106219:	85 c0                	test   %eax,%eax
c010621b:	74 24                	je     c0106241 <check_boot_pgdir+0x192>
c010621d:	c7 44 24 0c d0 af 10 	movl   $0xc010afd0,0xc(%esp)
c0106224:	c0 
c0106225:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c010622c:	c0 
c010622d:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0106234:	00 
c0106235:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c010623c:	e8 b7 aa ff ff       	call   c0100cf8 <__panic>

    struct Page *p;
    p = alloc_page();
c0106241:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106248:	e8 16 ec ff ff       	call   c0104e63 <alloc_pages>
c010624d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106250:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106255:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010625c:	00 
c010625d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106264:	00 
c0106265:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106268:	89 54 24 04          	mov    %edx,0x4(%esp)
c010626c:	89 04 24             	mov    %eax,(%esp)
c010626f:	e8 a1 f5 ff ff       	call   c0105815 <page_insert>
c0106274:	85 c0                	test   %eax,%eax
c0106276:	74 24                	je     c010629c <check_boot_pgdir+0x1ed>
c0106278:	c7 44 24 0c e4 af 10 	movl   $0xc010afe4,0xc(%esp)
c010627f:	c0 
c0106280:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0106287:	c0 
c0106288:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c010628f:	00 
c0106290:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0106297:	e8 5c aa ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p) == 1);
c010629c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010629f:	89 04 24             	mov    %eax,(%esp)
c01062a2:	e8 b7 e9 ff ff       	call   c0104c5e <page_ref>
c01062a7:	83 f8 01             	cmp    $0x1,%eax
c01062aa:	74 24                	je     c01062d0 <check_boot_pgdir+0x221>
c01062ac:	c7 44 24 0c 12 b0 10 	movl   $0xc010b012,0xc(%esp)
c01062b3:	c0 
c01062b4:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c01062bb:	c0 
c01062bc:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c01062c3:	00 
c01062c4:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01062cb:	e8 28 aa ff ff       	call   c0100cf8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01062d0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062d5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01062dc:	00 
c01062dd:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01062e4:	00 
c01062e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01062e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062ec:	89 04 24             	mov    %eax,(%esp)
c01062ef:	e8 21 f5 ff ff       	call   c0105815 <page_insert>
c01062f4:	85 c0                	test   %eax,%eax
c01062f6:	74 24                	je     c010631c <check_boot_pgdir+0x26d>
c01062f8:	c7 44 24 0c 24 b0 10 	movl   $0xc010b024,0xc(%esp)
c01062ff:	c0 
c0106300:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0106307:	c0 
c0106308:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c010630f:	00 
c0106310:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c0106317:	e8 dc a9 ff ff       	call   c0100cf8 <__panic>
    assert(page_ref(p) == 2);
c010631c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010631f:	89 04 24             	mov    %eax,(%esp)
c0106322:	e8 37 e9 ff ff       	call   c0104c5e <page_ref>
c0106327:	83 f8 02             	cmp    $0x2,%eax
c010632a:	74 24                	je     c0106350 <check_boot_pgdir+0x2a1>
c010632c:	c7 44 24 0c 5b b0 10 	movl   $0xc010b05b,0xc(%esp)
c0106333:	c0 
c0106334:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c010633b:	c0 
c010633c:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c0106343:	00 
c0106344:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c010634b:	e8 a8 a9 ff ff       	call   c0100cf8 <__panic>

    const char *str = "ucore: Hello world!!";
c0106350:	c7 45 dc 6c b0 10 c0 	movl   $0xc010b06c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106357:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010635a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010635e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106365:	e8 3e 36 00 00       	call   c01099a8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010636a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106371:	00 
c0106372:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106379:	e8 a3 36 00 00       	call   c0109a21 <strcmp>
c010637e:	85 c0                	test   %eax,%eax
c0106380:	74 24                	je     c01063a6 <check_boot_pgdir+0x2f7>
c0106382:	c7 44 24 0c 84 b0 10 	movl   $0xc010b084,0xc(%esp)
c0106389:	c0 
c010638a:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c0106391:	c0 
c0106392:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c0106399:	00 
c010639a:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01063a1:	e8 52 a9 ff ff       	call   c0100cf8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01063a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063a9:	89 04 24             	mov    %eax,(%esp)
c01063ac:	e8 1b e8 ff ff       	call   c0104bcc <page2kva>
c01063b1:	05 00 01 00 00       	add    $0x100,%eax
c01063b6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01063b9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01063c0:	e8 8b 35 00 00       	call   c0109950 <strlen>
c01063c5:	85 c0                	test   %eax,%eax
c01063c7:	74 24                	je     c01063ed <check_boot_pgdir+0x33e>
c01063c9:	c7 44 24 0c bc b0 10 	movl   $0xc010b0bc,0xc(%esp)
c01063d0:	c0 
c01063d1:	c7 44 24 08 51 ac 10 	movl   $0xc010ac51,0x8(%esp)
c01063d8:	c0 
c01063d9:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c01063e0:	00 
c01063e1:	c7 04 24 2c ac 10 c0 	movl   $0xc010ac2c,(%esp)
c01063e8:	e8 0b a9 ff ff       	call   c0100cf8 <__panic>

    free_page(p);
c01063ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01063f4:	00 
c01063f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01063f8:	89 04 24             	mov    %eax,(%esp)
c01063fb:	e8 ce ea ff ff       	call   c0104ece <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0106400:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106405:	8b 00                	mov    (%eax),%eax
c0106407:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010640c:	89 04 24             	mov    %eax,(%esp)
c010640f:	e8 73 e7 ff ff       	call   c0104b87 <pa2page>
c0106414:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010641b:	00 
c010641c:	89 04 24             	mov    %eax,(%esp)
c010641f:	e8 aa ea ff ff       	call   c0104ece <free_pages>
    boot_pgdir[0] = 0;
c0106424:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010642f:	c7 04 24 e0 b0 10 c0 	movl   $0xc010b0e0,(%esp)
c0106436:	e8 18 9f ff ff       	call   c0100353 <cprintf>
}
c010643b:	c9                   	leave  
c010643c:	c3                   	ret    

c010643d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010643d:	55                   	push   %ebp
c010643e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106440:	8b 45 08             	mov    0x8(%ebp),%eax
c0106443:	83 e0 04             	and    $0x4,%eax
c0106446:	85 c0                	test   %eax,%eax
c0106448:	74 07                	je     c0106451 <perm2str+0x14>
c010644a:	b8 75 00 00 00       	mov    $0x75,%eax
c010644f:	eb 05                	jmp    c0106456 <perm2str+0x19>
c0106451:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106456:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c010645b:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106462:	8b 45 08             	mov    0x8(%ebp),%eax
c0106465:	83 e0 02             	and    $0x2,%eax
c0106468:	85 c0                	test   %eax,%eax
c010646a:	74 07                	je     c0106473 <perm2str+0x36>
c010646c:	b8 77 00 00 00       	mov    $0x77,%eax
c0106471:	eb 05                	jmp    c0106478 <perm2str+0x3b>
c0106473:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106478:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c010647d:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c0106484:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c0106489:	5d                   	pop    %ebp
c010648a:	c3                   	ret    

c010648b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010648b:	55                   	push   %ebp
c010648c:	89 e5                	mov    %esp,%ebp
c010648e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106491:	8b 45 10             	mov    0x10(%ebp),%eax
c0106494:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106497:	72 0a                	jb     c01064a3 <get_pgtable_items+0x18>
        return 0;
c0106499:	b8 00 00 00 00       	mov    $0x0,%eax
c010649e:	e9 9c 00 00 00       	jmp    c010653f <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01064a3:	eb 04                	jmp    c01064a9 <get_pgtable_items+0x1e>
        start ++;
c01064a5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01064a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01064ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01064af:	73 18                	jae    c01064c9 <get_pgtable_items+0x3e>
c01064b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01064b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01064bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01064be:	01 d0                	add    %edx,%eax
c01064c0:	8b 00                	mov    (%eax),%eax
c01064c2:	83 e0 01             	and    $0x1,%eax
c01064c5:	85 c0                	test   %eax,%eax
c01064c7:	74 dc                	je     c01064a5 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01064c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01064cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01064cf:	73 69                	jae    c010653a <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01064d1:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01064d5:	74 08                	je     c01064df <get_pgtable_items+0x54>
            *left_store = start;
c01064d7:	8b 45 18             	mov    0x18(%ebp),%eax
c01064da:	8b 55 10             	mov    0x10(%ebp),%edx
c01064dd:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01064df:	8b 45 10             	mov    0x10(%ebp),%eax
c01064e2:	8d 50 01             	lea    0x1(%eax),%edx
c01064e5:	89 55 10             	mov    %edx,0x10(%ebp)
c01064e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01064ef:	8b 45 14             	mov    0x14(%ebp),%eax
c01064f2:	01 d0                	add    %edx,%eax
c01064f4:	8b 00                	mov    (%eax),%eax
c01064f6:	83 e0 07             	and    $0x7,%eax
c01064f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01064fc:	eb 04                	jmp    c0106502 <get_pgtable_items+0x77>
            start ++;
c01064fe:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106502:	8b 45 10             	mov    0x10(%ebp),%eax
c0106505:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106508:	73 1d                	jae    c0106527 <get_pgtable_items+0x9c>
c010650a:	8b 45 10             	mov    0x10(%ebp),%eax
c010650d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106514:	8b 45 14             	mov    0x14(%ebp),%eax
c0106517:	01 d0                	add    %edx,%eax
c0106519:	8b 00                	mov    (%eax),%eax
c010651b:	83 e0 07             	and    $0x7,%eax
c010651e:	89 c2                	mov    %eax,%edx
c0106520:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106523:	39 c2                	cmp    %eax,%edx
c0106525:	74 d7                	je     c01064fe <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106527:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010652b:	74 08                	je     c0106535 <get_pgtable_items+0xaa>
            *right_store = start;
c010652d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106530:	8b 55 10             	mov    0x10(%ebp),%edx
c0106533:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106535:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106538:	eb 05                	jmp    c010653f <get_pgtable_items+0xb4>
    }
    return 0;
c010653a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010653f:	c9                   	leave  
c0106540:	c3                   	ret    

c0106541 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106541:	55                   	push   %ebp
c0106542:	89 e5                	mov    %esp,%ebp
c0106544:	57                   	push   %edi
c0106545:	56                   	push   %esi
c0106546:	53                   	push   %ebx
c0106547:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010654a:	c7 04 24 00 b1 10 c0 	movl   $0xc010b100,(%esp)
c0106551:	e8 fd 9d ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106556:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010655d:	e9 fa 00 00 00       	jmp    c010665c <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106565:	89 04 24             	mov    %eax,(%esp)
c0106568:	e8 d0 fe ff ff       	call   c010643d <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010656d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106570:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106573:	29 d1                	sub    %edx,%ecx
c0106575:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106577:	89 d6                	mov    %edx,%esi
c0106579:	c1 e6 16             	shl    $0x16,%esi
c010657c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010657f:	89 d3                	mov    %edx,%ebx
c0106581:	c1 e3 16             	shl    $0x16,%ebx
c0106584:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106587:	89 d1                	mov    %edx,%ecx
c0106589:	c1 e1 16             	shl    $0x16,%ecx
c010658c:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010658f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106592:	29 d7                	sub    %edx,%edi
c0106594:	89 fa                	mov    %edi,%edx
c0106596:	89 44 24 14          	mov    %eax,0x14(%esp)
c010659a:	89 74 24 10          	mov    %esi,0x10(%esp)
c010659e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01065a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01065a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065aa:	c7 04 24 31 b1 10 c0 	movl   $0xc010b131,(%esp)
c01065b1:	e8 9d 9d ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01065b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01065b9:	c1 e0 0a             	shl    $0xa,%eax
c01065bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01065bf:	eb 54                	jmp    c0106615 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01065c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065c4:	89 04 24             	mov    %eax,(%esp)
c01065c7:	e8 71 fe ff ff       	call   c010643d <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01065cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01065cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01065d2:	29 d1                	sub    %edx,%ecx
c01065d4:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01065d6:	89 d6                	mov    %edx,%esi
c01065d8:	c1 e6 0c             	shl    $0xc,%esi
c01065db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01065de:	89 d3                	mov    %edx,%ebx
c01065e0:	c1 e3 0c             	shl    $0xc,%ebx
c01065e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01065e6:	c1 e2 0c             	shl    $0xc,%edx
c01065e9:	89 d1                	mov    %edx,%ecx
c01065eb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01065ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01065f1:	29 d7                	sub    %edx,%edi
c01065f3:	89 fa                	mov    %edi,%edx
c01065f5:	89 44 24 14          	mov    %eax,0x14(%esp)
c01065f9:	89 74 24 10          	mov    %esi,0x10(%esp)
c01065fd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106601:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106605:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106609:	c7 04 24 50 b1 10 c0 	movl   $0xc010b150,(%esp)
c0106610:	e8 3e 9d ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106615:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010661a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010661d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106620:	89 ce                	mov    %ecx,%esi
c0106622:	c1 e6 0a             	shl    $0xa,%esi
c0106625:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106628:	89 cb                	mov    %ecx,%ebx
c010662a:	c1 e3 0a             	shl    $0xa,%ebx
c010662d:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106630:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106634:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106637:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010663b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010663f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106643:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106647:	89 1c 24             	mov    %ebx,(%esp)
c010664a:	e8 3c fe ff ff       	call   c010648b <get_pgtable_items>
c010664f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106652:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106656:	0f 85 65 ff ff ff    	jne    c01065c1 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010665c:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106661:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106664:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106667:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010666b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010666e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106672:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106676:	89 44 24 08          	mov    %eax,0x8(%esp)
c010667a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106681:	00 
c0106682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106689:	e8 fd fd ff ff       	call   c010648b <get_pgtable_items>
c010668e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106695:	0f 85 c7 fe ff ff    	jne    c0106562 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010669b:	c7 04 24 74 b1 10 c0 	movl   $0xc010b174,(%esp)
c01066a2:	e8 ac 9c ff ff       	call   c0100353 <cprintf>
}
c01066a7:	83 c4 4c             	add    $0x4c,%esp
c01066aa:	5b                   	pop    %ebx
c01066ab:	5e                   	pop    %esi
c01066ac:	5f                   	pop    %edi
c01066ad:	5d                   	pop    %ebp
c01066ae:	c3                   	ret    

c01066af <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01066af:	55                   	push   %ebp
c01066b0:	89 e5                	mov    %esp,%ebp
c01066b2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01066b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01066b8:	c1 e8 0c             	shr    $0xc,%eax
c01066bb:	89 c2                	mov    %eax,%edx
c01066bd:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01066c2:	39 c2                	cmp    %eax,%edx
c01066c4:	72 1c                	jb     c01066e2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01066c6:	c7 44 24 08 a8 b1 10 	movl   $0xc010b1a8,0x8(%esp)
c01066cd:	c0 
c01066ce:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01066d5:	00 
c01066d6:	c7 04 24 c7 b1 10 c0 	movl   $0xc010b1c7,(%esp)
c01066dd:	e8 16 a6 ff ff       	call   c0100cf8 <__panic>
    }
    return &pages[PPN(pa)];
c01066e2:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01066e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01066ea:	c1 ea 0c             	shr    $0xc,%edx
c01066ed:	c1 e2 05             	shl    $0x5,%edx
c01066f0:	01 d0                	add    %edx,%eax
}
c01066f2:	c9                   	leave  
c01066f3:	c3                   	ret    

c01066f4 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01066f4:	55                   	push   %ebp
c01066f5:	89 e5                	mov    %esp,%ebp
c01066f7:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01066fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01066fd:	83 e0 01             	and    $0x1,%eax
c0106700:	85 c0                	test   %eax,%eax
c0106702:	75 1c                	jne    c0106720 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106704:	c7 44 24 08 d8 b1 10 	movl   $0xc010b1d8,0x8(%esp)
c010670b:	c0 
c010670c:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0106713:	00 
c0106714:	c7 04 24 c7 b1 10 c0 	movl   $0xc010b1c7,(%esp)
c010671b:	e8 d8 a5 ff ff       	call   c0100cf8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106720:	8b 45 08             	mov    0x8(%ebp),%eax
c0106723:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106728:	89 04 24             	mov    %eax,(%esp)
c010672b:	e8 7f ff ff ff       	call   c01066af <pa2page>
}
c0106730:	c9                   	leave  
c0106731:	c3                   	ret    

c0106732 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106732:	55                   	push   %ebp
c0106733:	89 e5                	mov    %esp,%ebp
c0106735:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106738:	e8 63 1d 00 00       	call   c01084a0 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010673d:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106742:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106747:	76 0c                	jbe    c0106755 <swap_init+0x23>
c0106749:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010674e:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106753:	76 25                	jbe    c010677a <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106755:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010675a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010675e:	c7 44 24 08 f9 b1 10 	movl   $0xc010b1f9,0x8(%esp)
c0106765:	c0 
c0106766:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c010676d:	00 
c010676e:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106775:	e8 7e a5 ff ff       	call   c0100cf8 <__panic>
     }
     

     sm = &swap_manager_fifo;
c010677a:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c0106781:	4a 12 c0 
     int r = sm->init();
c0106784:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106789:	8b 40 04             	mov    0x4(%eax),%eax
c010678c:	ff d0                	call   *%eax
c010678e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106795:	75 26                	jne    c01067bd <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106797:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c010679e:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01067a1:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067a6:	8b 00                	mov    (%eax),%eax
c01067a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067ac:	c7 04 24 23 b2 10 c0 	movl   $0xc010b223,(%esp)
c01067b3:	e8 9b 9b ff ff       	call   c0100353 <cprintf>
          check_swap();
c01067b8:	e8 a4 04 00 00       	call   c0106c61 <check_swap>
     }

     return r;
c01067bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01067c0:	c9                   	leave  
c01067c1:	c3                   	ret    

c01067c2 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01067c2:	55                   	push   %ebp
c01067c3:	89 e5                	mov    %esp,%ebp
c01067c5:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01067c8:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067cd:	8b 40 08             	mov    0x8(%eax),%eax
c01067d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01067d3:	89 14 24             	mov    %edx,(%esp)
c01067d6:	ff d0                	call   *%eax
}
c01067d8:	c9                   	leave  
c01067d9:	c3                   	ret    

c01067da <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01067da:	55                   	push   %ebp
c01067db:	89 e5                	mov    %esp,%ebp
c01067dd:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01067e0:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067e5:	8b 40 0c             	mov    0xc(%eax),%eax
c01067e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01067eb:	89 14 24             	mov    %edx,(%esp)
c01067ee:	ff d0                	call   *%eax
}
c01067f0:	c9                   	leave  
c01067f1:	c3                   	ret    

c01067f2 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01067f2:	55                   	push   %ebp
c01067f3:	89 e5                	mov    %esp,%ebp
c01067f5:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01067f8:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067fd:	8b 40 10             	mov    0x10(%eax),%eax
c0106800:	8b 55 14             	mov    0x14(%ebp),%edx
c0106803:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106807:	8b 55 10             	mov    0x10(%ebp),%edx
c010680a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010680e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106811:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106815:	8b 55 08             	mov    0x8(%ebp),%edx
c0106818:	89 14 24             	mov    %edx,(%esp)
c010681b:	ff d0                	call   *%eax
}
c010681d:	c9                   	leave  
c010681e:	c3                   	ret    

c010681f <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010681f:	55                   	push   %ebp
c0106820:	89 e5                	mov    %esp,%ebp
c0106822:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106825:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010682a:	8b 40 14             	mov    0x14(%eax),%eax
c010682d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106830:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106834:	8b 55 08             	mov    0x8(%ebp),%edx
c0106837:	89 14 24             	mov    %edx,(%esp)
c010683a:	ff d0                	call   *%eax
}
c010683c:	c9                   	leave  
c010683d:	c3                   	ret    

c010683e <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c010683e:	55                   	push   %ebp
c010683f:	89 e5                	mov    %esp,%ebp
c0106841:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106844:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010684b:	e9 5a 01 00 00       	jmp    c01069aa <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106850:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106855:	8b 40 18             	mov    0x18(%eax),%eax
c0106858:	8b 55 10             	mov    0x10(%ebp),%edx
c010685b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010685f:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106862:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106866:	8b 55 08             	mov    0x8(%ebp),%edx
c0106869:	89 14 24             	mov    %edx,(%esp)
c010686c:	ff d0                	call   *%eax
c010686e:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106871:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106875:	74 18                	je     c010688f <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106877:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010687a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010687e:	c7 04 24 38 b2 10 c0 	movl   $0xc010b238,(%esp)
c0106885:	e8 c9 9a ff ff       	call   c0100353 <cprintf>
c010688a:	e9 27 01 00 00       	jmp    c01069b6 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c010688f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106892:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106895:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106898:	8b 45 08             	mov    0x8(%ebp),%eax
c010689b:	8b 40 0c             	mov    0xc(%eax),%eax
c010689e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01068a5:	00 
c01068a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01068a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068ad:	89 04 24             	mov    %eax,(%esp)
c01068b0:	e8 15 ed ff ff       	call   c01055ca <get_pte>
c01068b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01068b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068bb:	8b 00                	mov    (%eax),%eax
c01068bd:	83 e0 01             	and    $0x1,%eax
c01068c0:	85 c0                	test   %eax,%eax
c01068c2:	75 24                	jne    c01068e8 <swap_out+0xaa>
c01068c4:	c7 44 24 0c 65 b2 10 	movl   $0xc010b265,0xc(%esp)
c01068cb:	c0 
c01068cc:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c01068d3:	c0 
c01068d4:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01068db:	00 
c01068dc:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c01068e3:	e8 10 a4 ff ff       	call   c0100cf8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01068e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01068ee:	8b 52 1c             	mov    0x1c(%edx),%edx
c01068f1:	c1 ea 0c             	shr    $0xc,%edx
c01068f4:	83 c2 01             	add    $0x1,%edx
c01068f7:	c1 e2 08             	shl    $0x8,%edx
c01068fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068fe:	89 14 24             	mov    %edx,(%esp)
c0106901:	e8 54 1c 00 00       	call   c010855a <swapfs_write>
c0106906:	85 c0                	test   %eax,%eax
c0106908:	74 34                	je     c010693e <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c010690a:	c7 04 24 8f b2 10 c0 	movl   $0xc010b28f,(%esp)
c0106911:	e8 3d 9a ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106916:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010691b:	8b 40 10             	mov    0x10(%eax),%eax
c010691e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106921:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106928:	00 
c0106929:	89 54 24 08          	mov    %edx,0x8(%esp)
c010692d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106930:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106934:	8b 55 08             	mov    0x8(%ebp),%edx
c0106937:	89 14 24             	mov    %edx,(%esp)
c010693a:	ff d0                	call   *%eax
c010693c:	eb 68                	jmp    c01069a6 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c010693e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106941:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106944:	c1 e8 0c             	shr    $0xc,%eax
c0106947:	83 c0 01             	add    $0x1,%eax
c010694a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010694e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106951:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106958:	89 44 24 04          	mov    %eax,0x4(%esp)
c010695c:	c7 04 24 a8 b2 10 c0 	movl   $0xc010b2a8,(%esp)
c0106963:	e8 eb 99 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010696b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010696e:	c1 e8 0c             	shr    $0xc,%eax
c0106971:	83 c0 01             	add    $0x1,%eax
c0106974:	c1 e0 08             	shl    $0x8,%eax
c0106977:	89 c2                	mov    %eax,%edx
c0106979:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010697c:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c010697e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106981:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106988:	00 
c0106989:	89 04 24             	mov    %eax,(%esp)
c010698c:	e8 3d e5 ff ff       	call   c0104ece <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106991:	8b 45 08             	mov    0x8(%ebp),%eax
c0106994:	8b 40 0c             	mov    0xc(%eax),%eax
c0106997:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010699a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010699e:	89 04 24             	mov    %eax,(%esp)
c01069a1:	e8 28 ef ff ff       	call   c01058ce <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01069a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01069aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01069b0:	0f 85 9a fe ff ff    	jne    c0106850 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01069b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01069b9:	c9                   	leave  
c01069ba:	c3                   	ret    

c01069bb <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01069bb:	55                   	push   %ebp
c01069bc:	89 e5                	mov    %esp,%ebp
c01069be:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01069c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01069c8:	e8 96 e4 ff ff       	call   c0104e63 <alloc_pages>
c01069cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01069d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01069d4:	75 24                	jne    c01069fa <swap_in+0x3f>
c01069d6:	c7 44 24 0c e8 b2 10 	movl   $0xc010b2e8,0xc(%esp)
c01069dd:	c0 
c01069de:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c01069e5:	c0 
c01069e6:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01069ed:	00 
c01069ee:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c01069f5:	e8 fe a2 ff ff       	call   c0100cf8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01069fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01069fd:	8b 40 0c             	mov    0xc(%eax),%eax
c0106a00:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106a07:	00 
c0106a08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106a0b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a0f:	89 04 24             	mov    %eax,(%esp)
c0106a12:	e8 b3 eb ff ff       	call   c01055ca <get_pte>
c0106a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106a1d:	8b 00                	mov    (%eax),%eax
c0106a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106a22:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a26:	89 04 24             	mov    %eax,(%esp)
c0106a29:	e8 ba 1a 00 00       	call   c01084e8 <swapfs_read>
c0106a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106a31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106a35:	74 2a                	je     c0106a61 <swap_in+0xa6>
     {
        assert(r!=0);
c0106a37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106a3b:	75 24                	jne    c0106a61 <swap_in+0xa6>
c0106a3d:	c7 44 24 0c f5 b2 10 	movl   $0xc010b2f5,0xc(%esp)
c0106a44:	c0 
c0106a45:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106a4c:	c0 
c0106a4d:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106a54:	00 
c0106a55:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106a5c:	e8 97 a2 ff ff       	call   c0100cf8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106a64:	8b 00                	mov    (%eax),%eax
c0106a66:	c1 e8 08             	shr    $0x8,%eax
c0106a69:	89 c2                	mov    %eax,%edx
c0106a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a6e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a76:	c7 04 24 fc b2 10 c0 	movl   $0xc010b2fc,(%esp)
c0106a7d:	e8 d1 98 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0106a82:	8b 45 10             	mov    0x10(%ebp),%eax
c0106a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106a88:	89 10                	mov    %edx,(%eax)
     return 0;
c0106a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106a8f:	c9                   	leave  
c0106a90:	c3                   	ret    

c0106a91 <check_content_set>:



static inline void
check_content_set(void)
{
c0106a91:	55                   	push   %ebp
c0106a92:	89 e5                	mov    %esp,%ebp
c0106a94:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106a97:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106a9c:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106a9f:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106aa4:	83 f8 01             	cmp    $0x1,%eax
c0106aa7:	74 24                	je     c0106acd <check_content_set+0x3c>
c0106aa9:	c7 44 24 0c 3a b3 10 	movl   $0xc010b33a,0xc(%esp)
c0106ab0:	c0 
c0106ab1:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106ab8:	c0 
c0106ab9:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106ac0:	00 
c0106ac1:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106ac8:	e8 2b a2 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106acd:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106ad2:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106ad5:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106ada:	83 f8 01             	cmp    $0x1,%eax
c0106add:	74 24                	je     c0106b03 <check_content_set+0x72>
c0106adf:	c7 44 24 0c 3a b3 10 	movl   $0xc010b33a,0xc(%esp)
c0106ae6:	c0 
c0106ae7:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106aee:	c0 
c0106aef:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106af6:	00 
c0106af7:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106afe:	e8 f5 a1 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106b03:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106b08:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106b0b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b10:	83 f8 02             	cmp    $0x2,%eax
c0106b13:	74 24                	je     c0106b39 <check_content_set+0xa8>
c0106b15:	c7 44 24 0c 49 b3 10 	movl   $0xc010b349,0xc(%esp)
c0106b1c:	c0 
c0106b1d:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106b24:	c0 
c0106b25:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106b2c:	00 
c0106b2d:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106b34:	e8 bf a1 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106b39:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106b3e:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106b41:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b46:	83 f8 02             	cmp    $0x2,%eax
c0106b49:	74 24                	je     c0106b6f <check_content_set+0xde>
c0106b4b:	c7 44 24 0c 49 b3 10 	movl   $0xc010b349,0xc(%esp)
c0106b52:	c0 
c0106b53:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106b5a:	c0 
c0106b5b:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106b62:	00 
c0106b63:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106b6a:	e8 89 a1 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106b6f:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106b74:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106b77:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b7c:	83 f8 03             	cmp    $0x3,%eax
c0106b7f:	74 24                	je     c0106ba5 <check_content_set+0x114>
c0106b81:	c7 44 24 0c 58 b3 10 	movl   $0xc010b358,0xc(%esp)
c0106b88:	c0 
c0106b89:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106b90:	c0 
c0106b91:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106b98:	00 
c0106b99:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106ba0:	e8 53 a1 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106ba5:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106baa:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106bad:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106bb2:	83 f8 03             	cmp    $0x3,%eax
c0106bb5:	74 24                	je     c0106bdb <check_content_set+0x14a>
c0106bb7:	c7 44 24 0c 58 b3 10 	movl   $0xc010b358,0xc(%esp)
c0106bbe:	c0 
c0106bbf:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106bc6:	c0 
c0106bc7:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106bce:	00 
c0106bcf:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106bd6:	e8 1d a1 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106bdb:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106be0:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106be3:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106be8:	83 f8 04             	cmp    $0x4,%eax
c0106beb:	74 24                	je     c0106c11 <check_content_set+0x180>
c0106bed:	c7 44 24 0c 67 b3 10 	movl   $0xc010b367,0xc(%esp)
c0106bf4:	c0 
c0106bf5:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106bfc:	c0 
c0106bfd:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106c04:	00 
c0106c05:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106c0c:	e8 e7 a0 ff ff       	call   c0100cf8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106c11:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106c16:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106c19:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106c1e:	83 f8 04             	cmp    $0x4,%eax
c0106c21:	74 24                	je     c0106c47 <check_content_set+0x1b6>
c0106c23:	c7 44 24 0c 67 b3 10 	movl   $0xc010b367,0xc(%esp)
c0106c2a:	c0 
c0106c2b:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106c32:	c0 
c0106c33:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106c3a:	00 
c0106c3b:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106c42:	e8 b1 a0 ff ff       	call   c0100cf8 <__panic>
}
c0106c47:	c9                   	leave  
c0106c48:	c3                   	ret    

c0106c49 <check_content_access>:

static inline int
check_content_access(void)
{
c0106c49:	55                   	push   %ebp
c0106c4a:	89 e5                	mov    %esp,%ebp
c0106c4c:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106c4f:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106c54:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106c57:	ff d0                	call   *%eax
c0106c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106c5f:	c9                   	leave  
c0106c60:	c3                   	ret    

c0106c61 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106c61:	55                   	push   %ebp
c0106c62:	89 e5                	mov    %esp,%ebp
c0106c64:	53                   	push   %ebx
c0106c65:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106c6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106c76:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106c7d:	eb 6b                	jmp    c0106cea <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c82:	83 e8 0c             	sub    $0xc,%eax
c0106c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106c88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c8b:	83 c0 04             	add    $0x4,%eax
c0106c8e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106c95:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106c98:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106c9b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106c9e:	0f a3 10             	bt     %edx,(%eax)
c0106ca1:	19 c0                	sbb    %eax,%eax
c0106ca3:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106ca6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106caa:	0f 95 c0             	setne  %al
c0106cad:	0f b6 c0             	movzbl %al,%eax
c0106cb0:	85 c0                	test   %eax,%eax
c0106cb2:	75 24                	jne    c0106cd8 <check_swap+0x77>
c0106cb4:	c7 44 24 0c 76 b3 10 	movl   $0xc010b376,0xc(%esp)
c0106cbb:	c0 
c0106cbc:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106cc3:	c0 
c0106cc4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106ccb:	00 
c0106ccc:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106cd3:	e8 20 a0 ff ff       	call   c0100cf8 <__panic>
        count ++, total += p->property;
c0106cd8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cdf:	8b 50 08             	mov    0x8(%eax),%edx
c0106ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ce5:	01 d0                	add    %edx,%eax
c0106ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ced:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106cf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106cf3:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106cf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106cf9:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106d00:	0f 85 79 ff ff ff    	jne    c0106c7f <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106d06:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106d09:	e8 f2 e1 ff ff       	call   c0104f00 <nr_free_pages>
c0106d0e:	39 c3                	cmp    %eax,%ebx
c0106d10:	74 24                	je     c0106d36 <check_swap+0xd5>
c0106d12:	c7 44 24 0c 86 b3 10 	movl   $0xc010b386,0xc(%esp)
c0106d19:	c0 
c0106d1a:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106d21:	c0 
c0106d22:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106d29:	00 
c0106d2a:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106d31:	e8 c2 9f ff ff       	call   c0100cf8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d39:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d44:	c7 04 24 a0 b3 10 c0 	movl   $0xc010b3a0,(%esp)
c0106d4b:	e8 03 96 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106d50:	e8 47 0a 00 00       	call   c010779c <mm_create>
c0106d55:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106d58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106d5c:	75 24                	jne    c0106d82 <check_swap+0x121>
c0106d5e:	c7 44 24 0c c6 b3 10 	movl   $0xc010b3c6,0xc(%esp)
c0106d65:	c0 
c0106d66:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106d6d:	c0 
c0106d6e:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106d75:	00 
c0106d76:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106d7d:	e8 76 9f ff ff       	call   c0100cf8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106d82:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106d87:	85 c0                	test   %eax,%eax
c0106d89:	74 24                	je     c0106daf <check_swap+0x14e>
c0106d8b:	c7 44 24 0c d1 b3 10 	movl   $0xc010b3d1,0xc(%esp)
c0106d92:	c0 
c0106d93:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106d9a:	c0 
c0106d9b:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106da2:	00 
c0106da3:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106daa:	e8 49 9f ff ff       	call   c0100cf8 <__panic>

     check_mm_struct = mm;
c0106daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106db2:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106db7:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106dc0:	89 50 0c             	mov    %edx,0xc(%eax)
c0106dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106dc6:	8b 40 0c             	mov    0xc(%eax),%eax
c0106dc9:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106dcf:	8b 00                	mov    (%eax),%eax
c0106dd1:	85 c0                	test   %eax,%eax
c0106dd3:	74 24                	je     c0106df9 <check_swap+0x198>
c0106dd5:	c7 44 24 0c e9 b3 10 	movl   $0xc010b3e9,0xc(%esp)
c0106ddc:	c0 
c0106ddd:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106de4:	c0 
c0106de5:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106dec:	00 
c0106ded:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106df4:	e8 ff 9e ff ff       	call   c0100cf8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106df9:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106e00:	00 
c0106e01:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106e08:	00 
c0106e09:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106e10:	e8 ff 09 00 00       	call   c0107814 <vma_create>
c0106e15:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106e18:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106e1c:	75 24                	jne    c0106e42 <check_swap+0x1e1>
c0106e1e:	c7 44 24 0c f7 b3 10 	movl   $0xc010b3f7,0xc(%esp)
c0106e25:	c0 
c0106e26:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106e2d:	c0 
c0106e2e:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106e35:	00 
c0106e36:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106e3d:	e8 b6 9e ff ff       	call   c0100cf8 <__panic>

     insert_vma_struct(mm, vma);
c0106e42:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106e45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e4c:	89 04 24             	mov    %eax,(%esp)
c0106e4f:	e8 50 0b 00 00       	call   c01079a4 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106e54:	c7 04 24 04 b4 10 c0 	movl   $0xc010b404,(%esp)
c0106e5b:	e8 f3 94 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106e60:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e6a:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e6d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106e74:	00 
c0106e75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106e7c:	00 
c0106e7d:	89 04 24             	mov    %eax,(%esp)
c0106e80:	e8 45 e7 ff ff       	call   c01055ca <get_pte>
c0106e85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106e88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106e8c:	75 24                	jne    c0106eb2 <check_swap+0x251>
c0106e8e:	c7 44 24 0c 38 b4 10 	movl   $0xc010b438,0xc(%esp)
c0106e95:	c0 
c0106e96:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106e9d:	c0 
c0106e9e:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106ea5:	00 
c0106ea6:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106ead:	e8 46 9e ff ff       	call   c0100cf8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106eb2:	c7 04 24 4c b4 10 c0 	movl   $0xc010b44c,(%esp)
c0106eb9:	e8 95 94 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106ec5:	e9 a3 00 00 00       	jmp    c0106f6d <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106eca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106ed1:	e8 8d df ff ff       	call   c0104e63 <alloc_pages>
c0106ed6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ed9:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ee3:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106eea:	85 c0                	test   %eax,%eax
c0106eec:	75 24                	jne    c0106f12 <check_swap+0x2b1>
c0106eee:	c7 44 24 0c 70 b4 10 	movl   $0xc010b470,0xc(%esp)
c0106ef5:	c0 
c0106ef6:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106efd:	c0 
c0106efe:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106f05:	00 
c0106f06:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106f0d:	e8 e6 9d ff ff       	call   c0100cf8 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f15:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106f1c:	83 c0 04             	add    $0x4,%eax
c0106f1f:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106f26:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106f29:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106f2c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106f2f:	0f a3 10             	bt     %edx,(%eax)
c0106f32:	19 c0                	sbb    %eax,%eax
c0106f34:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106f37:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106f3b:	0f 95 c0             	setne  %al
c0106f3e:	0f b6 c0             	movzbl %al,%eax
c0106f41:	85 c0                	test   %eax,%eax
c0106f43:	74 24                	je     c0106f69 <check_swap+0x308>
c0106f45:	c7 44 24 0c 84 b4 10 	movl   $0xc010b484,0xc(%esp)
c0106f4c:	c0 
c0106f4d:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106f54:	c0 
c0106f55:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106f5c:	00 
c0106f5d:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106f64:	e8 8f 9d ff ff       	call   c0100cf8 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f69:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106f6d:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106f71:	0f 8e 53 ff ff ff    	jle    c0106eca <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106f77:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0106f7c:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0106f82:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106f85:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106f88:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106f8f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f92:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106f95:	89 50 04             	mov    %edx,0x4(%eax)
c0106f98:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f9b:	8b 50 04             	mov    0x4(%eax),%edx
c0106f9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106fa1:	89 10                	mov    %edx,(%eax)
c0106fa3:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106faa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106fad:	8b 40 04             	mov    0x4(%eax),%eax
c0106fb0:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106fb3:	0f 94 c0             	sete   %al
c0106fb6:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106fb9:	85 c0                	test   %eax,%eax
c0106fbb:	75 24                	jne    c0106fe1 <check_swap+0x380>
c0106fbd:	c7 44 24 0c 9f b4 10 	movl   $0xc010b49f,0xc(%esp)
c0106fc4:	c0 
c0106fc5:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0106fcc:	c0 
c0106fcd:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106fd4:	00 
c0106fd5:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0106fdc:	e8 17 9d ff ff       	call   c0100cf8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106fe1:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106fe6:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106fe9:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0106ff0:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ff3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106ffa:	eb 1e                	jmp    c010701a <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fff:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0107006:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010700d:	00 
c010700e:	89 04 24             	mov    %eax,(%esp)
c0107011:	e8 b8 de ff ff       	call   c0104ece <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107016:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010701a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010701e:	7e dc                	jle    c0106ffc <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107020:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0107025:	83 f8 04             	cmp    $0x4,%eax
c0107028:	74 24                	je     c010704e <check_swap+0x3ed>
c010702a:	c7 44 24 0c b8 b4 10 	movl   $0xc010b4b8,0xc(%esp)
c0107031:	c0 
c0107032:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0107039:	c0 
c010703a:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107041:	00 
c0107042:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0107049:	e8 aa 9c ff ff       	call   c0100cf8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c010704e:	c7 04 24 dc b4 10 c0 	movl   $0xc010b4dc,(%esp)
c0107055:	e8 f9 92 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c010705a:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0107061:	00 00 00 
     
     check_content_set();
c0107064:	e8 28 fa ff ff       	call   c0106a91 <check_content_set>
     assert( nr_free == 0);         
c0107069:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010706e:	85 c0                	test   %eax,%eax
c0107070:	74 24                	je     c0107096 <check_swap+0x435>
c0107072:	c7 44 24 0c 03 b5 10 	movl   $0xc010b503,0xc(%esp)
c0107079:	c0 
c010707a:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0107081:	c0 
c0107082:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0107089:	00 
c010708a:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0107091:	e8 62 9c ff ff       	call   c0100cf8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0107096:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010709d:	eb 26                	jmp    c01070c5 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c010709f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070a2:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c01070a9:	ff ff ff ff 
c01070ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070b0:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c01070b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070ba:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01070c1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01070c5:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01070c9:	7e d4                	jle    c010709f <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01070d2:	e9 eb 00 00 00       	jmp    c01071c2 <check_swap+0x561>
         check_ptep[i]=0;
c01070d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070da:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c01070e1:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01070e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070e8:	83 c0 01             	add    $0x1,%eax
c01070eb:	c1 e0 0c             	shl    $0xc,%eax
c01070ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01070f5:	00 
c01070f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01070fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01070fd:	89 04 24             	mov    %eax,(%esp)
c0107100:	e8 c5 e4 ff ff       	call   c01055ca <get_pte>
c0107105:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107108:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c010710f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107112:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107119:	85 c0                	test   %eax,%eax
c010711b:	75 24                	jne    c0107141 <check_swap+0x4e0>
c010711d:	c7 44 24 0c 10 b5 10 	movl   $0xc010b510,0xc(%esp)
c0107124:	c0 
c0107125:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c010712c:	c0 
c010712d:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107134:	00 
c0107135:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c010713c:	e8 b7 9b ff ff       	call   c0100cf8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0107141:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107144:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c010714b:	8b 00                	mov    (%eax),%eax
c010714d:	89 04 24             	mov    %eax,(%esp)
c0107150:	e8 9f f5 ff ff       	call   c01066f4 <pte2page>
c0107155:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107158:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c010715f:	39 d0                	cmp    %edx,%eax
c0107161:	74 24                	je     c0107187 <check_swap+0x526>
c0107163:	c7 44 24 0c 28 b5 10 	movl   $0xc010b528,0xc(%esp)
c010716a:	c0 
c010716b:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c0107172:	c0 
c0107173:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010717a:	00 
c010717b:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0107182:	e8 71 9b ff ff       	call   c0100cf8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107187:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010718a:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107191:	8b 00                	mov    (%eax),%eax
c0107193:	83 e0 01             	and    $0x1,%eax
c0107196:	85 c0                	test   %eax,%eax
c0107198:	75 24                	jne    c01071be <check_swap+0x55d>
c010719a:	c7 44 24 0c 50 b5 10 	movl   $0xc010b550,0xc(%esp)
c01071a1:	c0 
c01071a2:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c01071a9:	c0 
c01071aa:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01071b1:	00 
c01071b2:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c01071b9:	e8 3a 9b ff ff       	call   c0100cf8 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01071be:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01071c2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01071c6:	0f 8e 0b ff ff ff    	jle    c01070d7 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01071cc:	c7 04 24 6c b5 10 c0 	movl   $0xc010b56c,(%esp)
c01071d3:	e8 7b 91 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01071d8:	e8 6c fa ff ff       	call   c0106c49 <check_content_access>
c01071dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01071e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01071e4:	74 24                	je     c010720a <check_swap+0x5a9>
c01071e6:	c7 44 24 0c 92 b5 10 	movl   $0xc010b592,0xc(%esp)
c01071ed:	c0 
c01071ee:	c7 44 24 08 7a b2 10 	movl   $0xc010b27a,0x8(%esp)
c01071f5:	c0 
c01071f6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01071fd:	00 
c01071fe:	c7 04 24 14 b2 10 c0 	movl   $0xc010b214,(%esp)
c0107205:	e8 ee 9a ff ff       	call   c0100cf8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010720a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107211:	eb 1e                	jmp    c0107231 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0107213:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107216:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c010721d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107224:	00 
c0107225:	89 04 24             	mov    %eax,(%esp)
c0107228:	e8 a1 dc ff ff       	call   c0104ece <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010722d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107231:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107235:	7e dc                	jle    c0107213 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0107237:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010723a:	89 04 24             	mov    %eax,(%esp)
c010723d:	e8 92 08 00 00       	call   c0107ad4 <mm_destroy>
         
     nr_free = nr_free_store;
c0107242:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107245:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c010724a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010724d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107250:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0107255:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c010725b:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107262:	eb 1d                	jmp    c0107281 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0107264:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107267:	83 e8 0c             	sub    $0xc,%eax
c010726a:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c010726d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107271:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107274:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107277:	8b 40 08             	mov    0x8(%eax),%eax
c010727a:	29 c2                	sub    %eax,%edx
c010727c:	89 d0                	mov    %edx,%eax
c010727e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107281:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107284:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107287:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010728a:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010728d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107290:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0107297:	75 cb                	jne    c0107264 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107299:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010729c:	89 44 24 08          	mov    %eax,0x8(%esp)
c01072a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01072a7:	c7 04 24 99 b5 10 c0 	movl   $0xc010b599,(%esp)
c01072ae:	e8 a0 90 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01072b3:	c7 04 24 b3 b5 10 c0 	movl   $0xc010b5b3,(%esp)
c01072ba:	e8 94 90 ff ff       	call   c0100353 <cprintf>
}
c01072bf:	83 c4 74             	add    $0x74,%esp
c01072c2:	5b                   	pop    %ebx
c01072c3:	5d                   	pop    %ebp
c01072c4:	c3                   	ret    

c01072c5 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01072c5:	55                   	push   %ebp
c01072c6:	89 e5                	mov    %esp,%ebp
c01072c8:	83 ec 10             	sub    $0x10,%esp
c01072cb:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01072d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01072d8:	89 50 04             	mov    %edx,0x4(%eax)
c01072db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072de:	8b 50 04             	mov    0x4(%eax),%edx
c01072e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01072e4:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01072e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01072e9:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01072f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01072f5:	c9                   	leave  
c01072f6:	c3                   	ret    

c01072f7 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01072f7:	55                   	push   %ebp
c01072f8:	89 e5                	mov    %esp,%ebp
c01072fa:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01072fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107300:	8b 40 14             	mov    0x14(%eax),%eax
c0107303:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107306:	8b 45 10             	mov    0x10(%ebp),%eax
c0107309:	83 c0 14             	add    $0x14,%eax
c010730c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c010730f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107313:	74 06                	je     c010731b <_fifo_map_swappable+0x24>
c0107315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107319:	75 24                	jne    c010733f <_fifo_map_swappable+0x48>
c010731b:	c7 44 24 0c cc b5 10 	movl   $0xc010b5cc,0xc(%esp)
c0107322:	c0 
c0107323:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c010732a:	c0 
c010732b:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0107332:	00 
c0107333:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c010733a:	e8 b9 99 ff ff       	call   c0100cf8 <__panic>
c010733f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107342:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107345:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107348:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010734b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010734e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107351:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107354:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010735a:	8b 40 04             	mov    0x4(%eax),%eax
c010735d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107360:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107363:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107366:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107369:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010736c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010736f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107372:	89 10                	mov    %edx,(%eax)
c0107374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107377:	8b 10                	mov    (%eax),%edx
c0107379:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010737c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010737f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107382:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107385:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107388:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010738b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010738e:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c0107390:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107395:	c9                   	leave  
c0107396:	c3                   	ret    

c0107397 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107397:	55                   	push   %ebp
c0107398:	89 e5                	mov    %esp,%ebp
c010739a:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010739d:	8b 45 08             	mov    0x8(%ebp),%eax
c01073a0:	8b 40 14             	mov    0x14(%eax),%eax
c01073a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01073a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01073aa:	75 24                	jne    c01073d0 <_fifo_swap_out_victim+0x39>
c01073ac:	c7 44 24 0c 13 b6 10 	movl   $0xc010b613,0xc(%esp)
c01073b3:	c0 
c01073b4:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c01073bb:	c0 
c01073bc:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c01073c3:	00 
c01073c4:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01073cb:	e8 28 99 ff ff       	call   c0100cf8 <__panic>
     assert(in_tick==0);
c01073d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01073d4:	74 24                	je     c01073fa <_fifo_swap_out_victim+0x63>
c01073d6:	c7 44 24 0c 20 b6 10 	movl   $0xc010b620,0xc(%esp)
c01073dd:	c0 
c01073de:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c01073e5:	c0 
c01073e6:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01073ed:	00 
c01073ee:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01073f5:	e8 fe 98 ff ff       	call   c0100cf8 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *head_prev = head->prev;
c01073fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073fd:	8b 00                	mov    (%eax),%eax
c01073ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head != head_prev);
c0107402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107405:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107408:	75 24                	jne    c010742e <_fifo_swap_out_victim+0x97>
c010740a:	c7 44 24 0c 2b b6 10 	movl   $0xc010b62b,0xc(%esp)
c0107411:	c0 
c0107412:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c0107419:	c0 
c010741a:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0107421:	00 
c0107422:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c0107429:	e8 ca 98 ff ff       	call   c0100cf8 <__panic>
c010742e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107431:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107434:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107437:	8b 40 04             	mov    0x4(%eax),%eax
c010743a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010743d:	8b 12                	mov    (%edx),%edx
c010743f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107442:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107448:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010744b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010744e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107451:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107454:	89 10                	mov    %edx,(%eax)
     list_del(head_prev);
     struct Page *p = le2page(head_prev, pra_page_link);
c0107456:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107459:	83 e8 14             	sub    $0x14,%eax
c010745c:	89 45 ec             	mov    %eax,-0x14(%ebp)
     assert(p != NULL);
c010745f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107463:	75 24                	jne    c0107489 <_fifo_swap_out_victim+0xf2>
c0107465:	c7 44 24 0c 3d b6 10 	movl   $0xc010b63d,0xc(%esp)
c010746c:	c0 
c010746d:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c0107474:	c0 
c0107475:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c010747c:	00 
c010747d:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c0107484:	e8 6f 98 ff ff       	call   c0100cf8 <__panic>
     *ptr_page = p;
c0107489:	8b 45 0c             	mov    0xc(%ebp),%eax
c010748c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010748f:	89 10                	mov    %edx,(%eax)
     return 0;
c0107491:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107496:	c9                   	leave  
c0107497:	c3                   	ret    

c0107498 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107498:	55                   	push   %ebp
c0107499:	89 e5                	mov    %esp,%ebp
c010749b:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c010749e:	c7 04 24 48 b6 10 c0 	movl   $0xc010b648,(%esp)
c01074a5:	e8 a9 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01074aa:	b8 00 30 00 00       	mov    $0x3000,%eax
c01074af:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01074b2:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074b7:	83 f8 04             	cmp    $0x4,%eax
c01074ba:	74 24                	je     c01074e0 <_fifo_check_swap+0x48>
c01074bc:	c7 44 24 0c 6e b6 10 	movl   $0xc010b66e,0xc(%esp)
c01074c3:	c0 
c01074c4:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c01074cb:	c0 
c01074cc:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c01074d3:	00 
c01074d4:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01074db:	e8 18 98 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01074e0:	c7 04 24 80 b6 10 c0 	movl   $0xc010b680,(%esp)
c01074e7:	e8 67 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01074ec:	b8 00 10 00 00       	mov    $0x1000,%eax
c01074f1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01074f4:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074f9:	83 f8 04             	cmp    $0x4,%eax
c01074fc:	74 24                	je     c0107522 <_fifo_check_swap+0x8a>
c01074fe:	c7 44 24 0c 6e b6 10 	movl   $0xc010b66e,0xc(%esp)
c0107505:	c0 
c0107506:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c010750d:	c0 
c010750e:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0107515:	00 
c0107516:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c010751d:	e8 d6 97 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107522:	c7 04 24 a8 b6 10 c0 	movl   $0xc010b6a8,(%esp)
c0107529:	e8 25 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010752e:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107533:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107536:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010753b:	83 f8 04             	cmp    $0x4,%eax
c010753e:	74 24                	je     c0107564 <_fifo_check_swap+0xcc>
c0107540:	c7 44 24 0c 6e b6 10 	movl   $0xc010b66e,0xc(%esp)
c0107547:	c0 
c0107548:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c010754f:	c0 
c0107550:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0107557:	00 
c0107558:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c010755f:	e8 94 97 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107564:	c7 04 24 d0 b6 10 c0 	movl   $0xc010b6d0,(%esp)
c010756b:	e8 e3 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107570:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107575:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107578:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010757d:	83 f8 04             	cmp    $0x4,%eax
c0107580:	74 24                	je     c01075a6 <_fifo_check_swap+0x10e>
c0107582:	c7 44 24 0c 6e b6 10 	movl   $0xc010b66e,0xc(%esp)
c0107589:	c0 
c010758a:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c0107591:	c0 
c0107592:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0107599:	00 
c010759a:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01075a1:	e8 52 97 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01075a6:	c7 04 24 f8 b6 10 c0 	movl   $0xc010b6f8,(%esp)
c01075ad:	e8 a1 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01075b2:	b8 00 50 00 00       	mov    $0x5000,%eax
c01075b7:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01075ba:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01075bf:	83 f8 05             	cmp    $0x5,%eax
c01075c2:	74 24                	je     c01075e8 <_fifo_check_swap+0x150>
c01075c4:	c7 44 24 0c 1e b7 10 	movl   $0xc010b71e,0xc(%esp)
c01075cb:	c0 
c01075cc:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c01075d3:	c0 
c01075d4:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c01075db:	00 
c01075dc:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01075e3:	e8 10 97 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01075e8:	c7 04 24 d0 b6 10 c0 	movl   $0xc010b6d0,(%esp)
c01075ef:	e8 5f 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01075f4:	b8 00 20 00 00       	mov    $0x2000,%eax
c01075f9:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01075fc:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107601:	83 f8 05             	cmp    $0x5,%eax
c0107604:	74 24                	je     c010762a <_fifo_check_swap+0x192>
c0107606:	c7 44 24 0c 1e b7 10 	movl   $0xc010b71e,0xc(%esp)
c010760d:	c0 
c010760e:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c0107615:	c0 
c0107616:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010761d:	00 
c010761e:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c0107625:	e8 ce 96 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010762a:	c7 04 24 80 b6 10 c0 	movl   $0xc010b680,(%esp)
c0107631:	e8 1d 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107636:	b8 00 10 00 00       	mov    $0x1000,%eax
c010763b:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c010763e:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107643:	83 f8 06             	cmp    $0x6,%eax
c0107646:	74 24                	je     c010766c <_fifo_check_swap+0x1d4>
c0107648:	c7 44 24 0c 2d b7 10 	movl   $0xc010b72d,0xc(%esp)
c010764f:	c0 
c0107650:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c0107657:	c0 
c0107658:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010765f:	00 
c0107660:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c0107667:	e8 8c 96 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010766c:	c7 04 24 d0 b6 10 c0 	movl   $0xc010b6d0,(%esp)
c0107673:	e8 db 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107678:	b8 00 20 00 00       	mov    $0x2000,%eax
c010767d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107680:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107685:	83 f8 07             	cmp    $0x7,%eax
c0107688:	74 24                	je     c01076ae <_fifo_check_swap+0x216>
c010768a:	c7 44 24 0c 3c b7 10 	movl   $0xc010b73c,0xc(%esp)
c0107691:	c0 
c0107692:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c0107699:	c0 
c010769a:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01076a1:	00 
c01076a2:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01076a9:	e8 4a 96 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01076ae:	c7 04 24 48 b6 10 c0 	movl   $0xc010b648,(%esp)
c01076b5:	e8 99 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01076ba:	b8 00 30 00 00       	mov    $0x3000,%eax
c01076bf:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01076c2:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01076c7:	83 f8 08             	cmp    $0x8,%eax
c01076ca:	74 24                	je     c01076f0 <_fifo_check_swap+0x258>
c01076cc:	c7 44 24 0c 4b b7 10 	movl   $0xc010b74b,0xc(%esp)
c01076d3:	c0 
c01076d4:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c01076db:	c0 
c01076dc:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01076e3:	00 
c01076e4:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c01076eb:	e8 08 96 ff ff       	call   c0100cf8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01076f0:	c7 04 24 a8 b6 10 c0 	movl   $0xc010b6a8,(%esp)
c01076f7:	e8 57 8c ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01076fc:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107701:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107704:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107709:	83 f8 09             	cmp    $0x9,%eax
c010770c:	74 24                	je     c0107732 <_fifo_check_swap+0x29a>
c010770e:	c7 44 24 0c 5a b7 10 	movl   $0xc010b75a,0xc(%esp)
c0107715:	c0 
c0107716:	c7 44 24 08 ea b5 10 	movl   $0xc010b5ea,0x8(%esp)
c010771d:	c0 
c010771e:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107725:	00 
c0107726:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c010772d:	e8 c6 95 ff ff       	call   c0100cf8 <__panic>
    return 0;
c0107732:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107737:	c9                   	leave  
c0107738:	c3                   	ret    

c0107739 <_fifo_init>:


static int
_fifo_init(void)
{
c0107739:	55                   	push   %ebp
c010773a:	89 e5                	mov    %esp,%ebp
    return 0;
c010773c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107741:	5d                   	pop    %ebp
c0107742:	c3                   	ret    

c0107743 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107743:	55                   	push   %ebp
c0107744:	89 e5                	mov    %esp,%ebp
    return 0;
c0107746:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010774b:	5d                   	pop    %ebp
c010774c:	c3                   	ret    

c010774d <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c010774d:	55                   	push   %ebp
c010774e:	89 e5                	mov    %esp,%ebp
c0107750:	b8 00 00 00 00       	mov    $0x0,%eax
c0107755:	5d                   	pop    %ebp
c0107756:	c3                   	ret    

c0107757 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107757:	55                   	push   %ebp
c0107758:	89 e5                	mov    %esp,%ebp
c010775a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010775d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107760:	c1 e8 0c             	shr    $0xc,%eax
c0107763:	89 c2                	mov    %eax,%edx
c0107765:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010776a:	39 c2                	cmp    %eax,%edx
c010776c:	72 1c                	jb     c010778a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010776e:	c7 44 24 08 7c b7 10 	movl   $0xc010b77c,0x8(%esp)
c0107775:	c0 
c0107776:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010777d:	00 
c010777e:	c7 04 24 9b b7 10 c0 	movl   $0xc010b79b,(%esp)
c0107785:	e8 6e 95 ff ff       	call   c0100cf8 <__panic>
    }
    return &pages[PPN(pa)];
c010778a:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010778f:	8b 55 08             	mov    0x8(%ebp),%edx
c0107792:	c1 ea 0c             	shr    $0xc,%edx
c0107795:	c1 e2 05             	shl    $0x5,%edx
c0107798:	01 d0                	add    %edx,%eax
}
c010779a:	c9                   	leave  
c010779b:	c3                   	ret    

c010779c <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c010779c:	55                   	push   %ebp
c010779d:	89 e5                	mov    %esp,%ebp
c010779f:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01077a2:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01077a9:	e8 58 d2 ff ff       	call   c0104a06 <kmalloc>
c01077ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01077b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077b5:	74 58                	je     c010780f <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01077b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01077bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01077c3:	89 50 04             	mov    %edx,0x4(%eax)
c01077c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077c9:	8b 50 04             	mov    0x4(%eax),%edx
c01077cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077cf:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01077d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01077db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c01077e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077e8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c01077ef:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01077f4:	85 c0                	test   %eax,%eax
c01077f6:	74 0d                	je     c0107805 <mm_create+0x69>
c01077f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077fb:	89 04 24             	mov    %eax,(%esp)
c01077fe:	e8 bf ef ff ff       	call   c01067c2 <swap_init_mm>
c0107803:	eb 0a                	jmp    c010780f <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107808:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010780f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107812:	c9                   	leave  
c0107813:	c3                   	ret    

c0107814 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107814:	55                   	push   %ebp
c0107815:	89 e5                	mov    %esp,%ebp
c0107817:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010781a:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107821:	e8 e0 d1 ff ff       	call   c0104a06 <kmalloc>
c0107826:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010782d:	74 1b                	je     c010784a <vma_create+0x36>
        vma->vm_start = vm_start;
c010782f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107832:	8b 55 08             	mov    0x8(%ebp),%edx
c0107835:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107838:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010783b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010783e:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107841:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107844:	8b 55 10             	mov    0x10(%ebp),%edx
c0107847:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010784a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010784d:	c9                   	leave  
c010784e:	c3                   	ret    

c010784f <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c010784f:	55                   	push   %ebp
c0107850:	89 e5                	mov    %esp,%ebp
c0107852:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107855:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010785c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107860:	0f 84 95 00 00 00    	je     c01078fb <find_vma+0xac>
        vma = mm->mmap_cache;
c0107866:	8b 45 08             	mov    0x8(%ebp),%eax
c0107869:	8b 40 08             	mov    0x8(%eax),%eax
c010786c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010786f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107873:	74 16                	je     c010788b <find_vma+0x3c>
c0107875:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107878:	8b 40 04             	mov    0x4(%eax),%eax
c010787b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010787e:	77 0b                	ja     c010788b <find_vma+0x3c>
c0107880:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107883:	8b 40 08             	mov    0x8(%eax),%eax
c0107886:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107889:	77 61                	ja     c01078ec <find_vma+0x9d>
                bool found = 0;
c010788b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107892:	8b 45 08             	mov    0x8(%ebp),%eax
c0107895:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107898:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010789b:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c010789e:	eb 28                	jmp    c01078c8 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01078a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078a3:	83 e8 10             	sub    $0x10,%eax
c01078a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01078a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01078ac:	8b 40 04             	mov    0x4(%eax),%eax
c01078af:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01078b2:	77 14                	ja     c01078c8 <find_vma+0x79>
c01078b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01078b7:	8b 40 08             	mov    0x8(%eax),%eax
c01078ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01078bd:	76 09                	jbe    c01078c8 <find_vma+0x79>
                        found = 1;
c01078bf:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01078c6:	eb 17                	jmp    c01078df <find_vma+0x90>
c01078c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01078ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078d1:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01078d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01078d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01078dd:	75 c1                	jne    c01078a0 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c01078df:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01078e3:	75 07                	jne    c01078ec <find_vma+0x9d>
                    vma = NULL;
c01078e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c01078ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01078f0:	74 09                	je     c01078fb <find_vma+0xac>
            mm->mmap_cache = vma;
c01078f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01078f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01078f8:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01078fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01078fe:	c9                   	leave  
c01078ff:	c3                   	ret    

c0107900 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107900:	55                   	push   %ebp
c0107901:	89 e5                	mov    %esp,%ebp
c0107903:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107906:	8b 45 08             	mov    0x8(%ebp),%eax
c0107909:	8b 50 04             	mov    0x4(%eax),%edx
c010790c:	8b 45 08             	mov    0x8(%ebp),%eax
c010790f:	8b 40 08             	mov    0x8(%eax),%eax
c0107912:	39 c2                	cmp    %eax,%edx
c0107914:	72 24                	jb     c010793a <check_vma_overlap+0x3a>
c0107916:	c7 44 24 0c a9 b7 10 	movl   $0xc010b7a9,0xc(%esp)
c010791d:	c0 
c010791e:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107925:	c0 
c0107926:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c010792d:	00 
c010792e:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107935:	e8 be 93 ff ff       	call   c0100cf8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c010793a:	8b 45 08             	mov    0x8(%ebp),%eax
c010793d:	8b 50 08             	mov    0x8(%eax),%edx
c0107940:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107943:	8b 40 04             	mov    0x4(%eax),%eax
c0107946:	39 c2                	cmp    %eax,%edx
c0107948:	76 24                	jbe    c010796e <check_vma_overlap+0x6e>
c010794a:	c7 44 24 0c ec b7 10 	movl   $0xc010b7ec,0xc(%esp)
c0107951:	c0 
c0107952:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107959:	c0 
c010795a:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107961:	00 
c0107962:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107969:	e8 8a 93 ff ff       	call   c0100cf8 <__panic>
    assert(next->vm_start < next->vm_end);
c010796e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107971:	8b 50 04             	mov    0x4(%eax),%edx
c0107974:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107977:	8b 40 08             	mov    0x8(%eax),%eax
c010797a:	39 c2                	cmp    %eax,%edx
c010797c:	72 24                	jb     c01079a2 <check_vma_overlap+0xa2>
c010797e:	c7 44 24 0c 0b b8 10 	movl   $0xc010b80b,0xc(%esp)
c0107985:	c0 
c0107986:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c010798d:	c0 
c010798e:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107995:	00 
c0107996:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c010799d:	e8 56 93 ff ff       	call   c0100cf8 <__panic>
}
c01079a2:	c9                   	leave  
c01079a3:	c3                   	ret    

c01079a4 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01079a4:	55                   	push   %ebp
c01079a5:	89 e5                	mov    %esp,%ebp
c01079a7:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01079aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079ad:	8b 50 04             	mov    0x4(%eax),%edx
c01079b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079b3:	8b 40 08             	mov    0x8(%eax),%eax
c01079b6:	39 c2                	cmp    %eax,%edx
c01079b8:	72 24                	jb     c01079de <insert_vma_struct+0x3a>
c01079ba:	c7 44 24 0c 29 b8 10 	movl   $0xc010b829,0xc(%esp)
c01079c1:	c0 
c01079c2:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c01079c9:	c0 
c01079ca:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01079d1:	00 
c01079d2:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c01079d9:	e8 1a 93 ff ff       	call   c0100cf8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c01079de:	8b 45 08             	mov    0x8(%ebp),%eax
c01079e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c01079e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01079e7:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c01079ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01079ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c01079f0:	eb 21                	jmp    c0107a13 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c01079f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079f5:	83 e8 10             	sub    $0x10,%eax
c01079f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01079fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079fe:	8b 50 04             	mov    0x4(%eax),%edx
c0107a01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a04:	8b 40 04             	mov    0x4(%eax),%eax
c0107a07:	39 c2                	cmp    %eax,%edx
c0107a09:	76 02                	jbe    c0107a0d <insert_vma_struct+0x69>
                break;
c0107a0b:	eb 1d                	jmp    c0107a2a <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a16:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a1c:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a25:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107a28:	75 c8                	jne    c01079f2 <insert_vma_struct+0x4e>
c0107a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107a30:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a33:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a3c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107a3f:	74 15                	je     c0107a56 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a44:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a4e:	89 14 24             	mov    %edx,(%esp)
c0107a51:	e8 aa fe ff ff       	call   c0107900 <check_vma_overlap>
    }
    if (le_next != list) {
c0107a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a59:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107a5c:	74 15                	je     c0107a73 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a61:	83 e8 10             	sub    $0x10,%eax
c0107a64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a6b:	89 04 24             	mov    %eax,(%esp)
c0107a6e:	e8 8d fe ff ff       	call   c0107900 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107a73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a76:	8b 55 08             	mov    0x8(%ebp),%edx
c0107a79:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a7e:	8d 50 10             	lea    0x10(%eax),%edx
c0107a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a84:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107a87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107a8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107a8d:	8b 40 04             	mov    0x4(%eax),%eax
c0107a90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107a93:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107a96:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107a99:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107a9c:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107a9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107aa2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107aa5:	89 10                	mov    %edx,(%eax)
c0107aa7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107aaa:	8b 10                	mov    (%eax),%edx
c0107aac:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107aaf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107ab2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107ab5:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107ab8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107abb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107abe:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107ac1:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ac6:	8b 40 10             	mov    0x10(%eax),%eax
c0107ac9:	8d 50 01             	lea    0x1(%eax),%edx
c0107acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0107acf:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107ad2:	c9                   	leave  
c0107ad3:	c3                   	ret    

c0107ad4 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107ad4:	55                   	push   %ebp
c0107ad5:	89 e5                	mov    %esp,%ebp
c0107ad7:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0107add:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107ae0:	eb 36                	jmp    c0107b18 <mm_destroy+0x44>
c0107ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107aeb:	8b 40 04             	mov    0x4(%eax),%eax
c0107aee:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107af1:	8b 12                	mov    (%edx),%edx
c0107af3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107afc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107aff:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b05:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107b08:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b0d:	83 e8 10             	sub    $0x10,%eax
c0107b10:	89 04 24             	mov    %eax,(%esp)
c0107b13:	e8 09 cf ff ff       	call   c0104a21 <kfree>
c0107b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b21:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b2a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107b2d:	75 b3                	jne    c0107ae2 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b32:	89 04 24             	mov    %eax,(%esp)
c0107b35:	e8 e7 ce ff ff       	call   c0104a21 <kfree>
    mm=NULL;
c0107b3a:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107b41:	c9                   	leave  
c0107b42:	c3                   	ret    

c0107b43 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107b43:	55                   	push   %ebp
c0107b44:	89 e5                	mov    %esp,%ebp
c0107b46:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107b49:	e8 02 00 00 00       	call   c0107b50 <check_vmm>
}
c0107b4e:	c9                   	leave  
c0107b4f:	c3                   	ret    

c0107b50 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107b50:	55                   	push   %ebp
c0107b51:	89 e5                	mov    %esp,%ebp
c0107b53:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107b56:	e8 a5 d3 ff ff       	call   c0104f00 <nr_free_pages>
c0107b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107b5e:	e8 13 00 00 00       	call   c0107b76 <check_vma_struct>
    check_pgfault();
c0107b63:	e8 a7 04 00 00       	call   c010800f <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0107b68:	c7 04 24 45 b8 10 c0 	movl   $0xc010b845,(%esp)
c0107b6f:	e8 df 87 ff ff       	call   c0100353 <cprintf>
}
c0107b74:	c9                   	leave  
c0107b75:	c3                   	ret    

c0107b76 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107b76:	55                   	push   %ebp
c0107b77:	89 e5                	mov    %esp,%ebp
c0107b79:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107b7c:	e8 7f d3 ff ff       	call   c0104f00 <nr_free_pages>
c0107b81:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107b84:	e8 13 fc ff ff       	call   c010779c <mm_create>
c0107b89:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107b8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107b90:	75 24                	jne    c0107bb6 <check_vma_struct+0x40>
c0107b92:	c7 44 24 0c 5d b8 10 	movl   $0xc010b85d,0xc(%esp)
c0107b99:	c0 
c0107b9a:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107ba1:	c0 
c0107ba2:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107ba9:	00 
c0107baa:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107bb1:	e8 42 91 ff ff       	call   c0100cf8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107bb6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107bbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107bc0:	89 d0                	mov    %edx,%eax
c0107bc2:	c1 e0 02             	shl    $0x2,%eax
c0107bc5:	01 d0                	add    %edx,%eax
c0107bc7:	01 c0                	add    %eax,%eax
c0107bc9:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107bd2:	eb 70                	jmp    c0107c44 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bd7:	89 d0                	mov    %edx,%eax
c0107bd9:	c1 e0 02             	shl    $0x2,%eax
c0107bdc:	01 d0                	add    %edx,%eax
c0107bde:	83 c0 02             	add    $0x2,%eax
c0107be1:	89 c1                	mov    %eax,%ecx
c0107be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107be6:	89 d0                	mov    %edx,%eax
c0107be8:	c1 e0 02             	shl    $0x2,%eax
c0107beb:	01 d0                	add    %edx,%eax
c0107bed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107bf4:	00 
c0107bf5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107bf9:	89 04 24             	mov    %eax,(%esp)
c0107bfc:	e8 13 fc ff ff       	call   c0107814 <vma_create>
c0107c01:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107c04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107c08:	75 24                	jne    c0107c2e <check_vma_struct+0xb8>
c0107c0a:	c7 44 24 0c 68 b8 10 	movl   $0xc010b868,0xc(%esp)
c0107c11:	c0 
c0107c12:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107c19:	c0 
c0107c1a:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107c21:	00 
c0107c22:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107c29:	e8 ca 90 ff ff       	call   c0100cf8 <__panic>
        insert_vma_struct(mm, vma);
c0107c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107c31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c38:	89 04 24             	mov    %eax,(%esp)
c0107c3b:	e8 64 fd ff ff       	call   c01079a4 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107c40:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107c48:	7f 8a                	jg     c0107bd4 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c4d:	83 c0 01             	add    $0x1,%eax
c0107c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107c53:	eb 70                	jmp    c0107cc5 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107c58:	89 d0                	mov    %edx,%eax
c0107c5a:	c1 e0 02             	shl    $0x2,%eax
c0107c5d:	01 d0                	add    %edx,%eax
c0107c5f:	83 c0 02             	add    $0x2,%eax
c0107c62:	89 c1                	mov    %eax,%ecx
c0107c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107c67:	89 d0                	mov    %edx,%eax
c0107c69:	c1 e0 02             	shl    $0x2,%eax
c0107c6c:	01 d0                	add    %edx,%eax
c0107c6e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107c75:	00 
c0107c76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107c7a:	89 04 24             	mov    %eax,(%esp)
c0107c7d:	e8 92 fb ff ff       	call   c0107814 <vma_create>
c0107c82:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107c85:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107c89:	75 24                	jne    c0107caf <check_vma_struct+0x139>
c0107c8b:	c7 44 24 0c 68 b8 10 	movl   $0xc010b868,0xc(%esp)
c0107c92:	c0 
c0107c93:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107c9a:	c0 
c0107c9b:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107ca2:	00 
c0107ca3:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107caa:	e8 49 90 ff ff       	call   c0100cf8 <__panic>
        insert_vma_struct(mm, vma);
c0107caf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cb9:	89 04 24             	mov    %eax,(%esp)
c0107cbc:	e8 e3 fc ff ff       	call   c01079a4 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107cc1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cc8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107ccb:	7e 88                	jle    c0107c55 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cd0:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107cd3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107cd6:	8b 40 04             	mov    0x4(%eax),%eax
c0107cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107cdc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107ce3:	e9 97 00 00 00       	jmp    c0107d7f <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ceb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107cee:	75 24                	jne    c0107d14 <check_vma_struct+0x19e>
c0107cf0:	c7 44 24 0c 74 b8 10 	movl   $0xc010b874,0xc(%esp)
c0107cf7:	c0 
c0107cf8:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107cff:	c0 
c0107d00:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107d07:	00 
c0107d08:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107d0f:	e8 e4 8f ff ff       	call   c0100cf8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d17:	83 e8 10             	sub    $0x10,%eax
c0107d1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107d1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107d20:	8b 48 04             	mov    0x4(%eax),%ecx
c0107d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d26:	89 d0                	mov    %edx,%eax
c0107d28:	c1 e0 02             	shl    $0x2,%eax
c0107d2b:	01 d0                	add    %edx,%eax
c0107d2d:	39 c1                	cmp    %eax,%ecx
c0107d2f:	75 17                	jne    c0107d48 <check_vma_struct+0x1d2>
c0107d31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107d34:	8b 48 08             	mov    0x8(%eax),%ecx
c0107d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d3a:	89 d0                	mov    %edx,%eax
c0107d3c:	c1 e0 02             	shl    $0x2,%eax
c0107d3f:	01 d0                	add    %edx,%eax
c0107d41:	83 c0 02             	add    $0x2,%eax
c0107d44:	39 c1                	cmp    %eax,%ecx
c0107d46:	74 24                	je     c0107d6c <check_vma_struct+0x1f6>
c0107d48:	c7 44 24 0c 8c b8 10 	movl   $0xc010b88c,0xc(%esp)
c0107d4f:	c0 
c0107d50:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107d57:	c0 
c0107d58:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107d5f:	00 
c0107d60:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107d67:	e8 8c 8f ff ff       	call   c0100cf8 <__panic>
c0107d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d6f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107d72:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107d75:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107d7b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d82:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107d85:	0f 8e 5d ff ff ff    	jle    c0107ce8 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107d8b:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107d92:	e9 cd 01 00 00       	jmp    c0107f64 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107da1:	89 04 24             	mov    %eax,(%esp)
c0107da4:	e8 a6 fa ff ff       	call   c010784f <find_vma>
c0107da9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107dac:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107db0:	75 24                	jne    c0107dd6 <check_vma_struct+0x260>
c0107db2:	c7 44 24 0c c1 b8 10 	movl   $0xc010b8c1,0xc(%esp)
c0107db9:	c0 
c0107dba:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107dc1:	c0 
c0107dc2:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107dc9:	00 
c0107dca:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107dd1:	e8 22 8f ff ff       	call   c0100cf8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dd9:	83 c0 01             	add    $0x1,%eax
c0107ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107de3:	89 04 24             	mov    %eax,(%esp)
c0107de6:	e8 64 fa ff ff       	call   c010784f <find_vma>
c0107deb:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107dee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107df2:	75 24                	jne    c0107e18 <check_vma_struct+0x2a2>
c0107df4:	c7 44 24 0c ce b8 10 	movl   $0xc010b8ce,0xc(%esp)
c0107dfb:	c0 
c0107dfc:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107e03:	c0 
c0107e04:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107e0b:	00 
c0107e0c:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107e13:	e8 e0 8e ff ff       	call   c0100cf8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e1b:	83 c0 02             	add    $0x2,%eax
c0107e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e25:	89 04 24             	mov    %eax,(%esp)
c0107e28:	e8 22 fa ff ff       	call   c010784f <find_vma>
c0107e2d:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107e30:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107e34:	74 24                	je     c0107e5a <check_vma_struct+0x2e4>
c0107e36:	c7 44 24 0c db b8 10 	movl   $0xc010b8db,0xc(%esp)
c0107e3d:	c0 
c0107e3e:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107e45:	c0 
c0107e46:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107e4d:	00 
c0107e4e:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107e55:	e8 9e 8e ff ff       	call   c0100cf8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e5d:	83 c0 03             	add    $0x3,%eax
c0107e60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e67:	89 04 24             	mov    %eax,(%esp)
c0107e6a:	e8 e0 f9 ff ff       	call   c010784f <find_vma>
c0107e6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107e72:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107e76:	74 24                	je     c0107e9c <check_vma_struct+0x326>
c0107e78:	c7 44 24 0c e8 b8 10 	movl   $0xc010b8e8,0xc(%esp)
c0107e7f:	c0 
c0107e80:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107e87:	c0 
c0107e88:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107e8f:	00 
c0107e90:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107e97:	e8 5c 8e ff ff       	call   c0100cf8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e9f:	83 c0 04             	add    $0x4,%eax
c0107ea2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ea9:	89 04 24             	mov    %eax,(%esp)
c0107eac:	e8 9e f9 ff ff       	call   c010784f <find_vma>
c0107eb1:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107eb4:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107eb8:	74 24                	je     c0107ede <check_vma_struct+0x368>
c0107eba:	c7 44 24 0c f5 b8 10 	movl   $0xc010b8f5,0xc(%esp)
c0107ec1:	c0 
c0107ec2:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107ec9:	c0 
c0107eca:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107ed1:	00 
c0107ed2:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107ed9:	e8 1a 8e ff ff       	call   c0100cf8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107ede:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107ee1:	8b 50 04             	mov    0x4(%eax),%edx
c0107ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ee7:	39 c2                	cmp    %eax,%edx
c0107ee9:	75 10                	jne    c0107efb <check_vma_struct+0x385>
c0107eeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107eee:	8b 50 08             	mov    0x8(%eax),%edx
c0107ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ef4:	83 c0 02             	add    $0x2,%eax
c0107ef7:	39 c2                	cmp    %eax,%edx
c0107ef9:	74 24                	je     c0107f1f <check_vma_struct+0x3a9>
c0107efb:	c7 44 24 0c 04 b9 10 	movl   $0xc010b904,0xc(%esp)
c0107f02:	c0 
c0107f03:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107f0a:	c0 
c0107f0b:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0107f12:	00 
c0107f13:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107f1a:	e8 d9 8d ff ff       	call   c0100cf8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107f1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f22:	8b 50 04             	mov    0x4(%eax),%edx
c0107f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f28:	39 c2                	cmp    %eax,%edx
c0107f2a:	75 10                	jne    c0107f3c <check_vma_struct+0x3c6>
c0107f2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f2f:	8b 50 08             	mov    0x8(%eax),%edx
c0107f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f35:	83 c0 02             	add    $0x2,%eax
c0107f38:	39 c2                	cmp    %eax,%edx
c0107f3a:	74 24                	je     c0107f60 <check_vma_struct+0x3ea>
c0107f3c:	c7 44 24 0c 34 b9 10 	movl   $0xc010b934,0xc(%esp)
c0107f43:	c0 
c0107f44:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107f4b:	c0 
c0107f4c:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107f53:	00 
c0107f54:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107f5b:	e8 98 8d ff ff       	call   c0100cf8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107f60:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107f64:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107f67:	89 d0                	mov    %edx,%eax
c0107f69:	c1 e0 02             	shl    $0x2,%eax
c0107f6c:	01 d0                	add    %edx,%eax
c0107f6e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107f71:	0f 8d 20 fe ff ff    	jge    c0107d97 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107f77:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107f7e:	eb 70                	jmp    c0107ff0 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f8a:	89 04 24             	mov    %eax,(%esp)
c0107f8d:	e8 bd f8 ff ff       	call   c010784f <find_vma>
c0107f92:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107f95:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107f99:	74 27                	je     c0107fc2 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107f9b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107f9e:	8b 50 08             	mov    0x8(%eax),%edx
c0107fa1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107fa4:	8b 40 04             	mov    0x4(%eax),%eax
c0107fa7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107fab:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fb6:	c7 04 24 64 b9 10 c0 	movl   $0xc010b964,(%esp)
c0107fbd:	e8 91 83 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107fc2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107fc6:	74 24                	je     c0107fec <check_vma_struct+0x476>
c0107fc8:	c7 44 24 0c 89 b9 10 	movl   $0xc010b989,0xc(%esp)
c0107fcf:	c0 
c0107fd0:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0107fd7:	c0 
c0107fd8:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107fdf:	00 
c0107fe0:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0107fe7:	e8 0c 8d ff ff       	call   c0100cf8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107fec:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ff4:	79 8a                	jns    c0107f80 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ff9:	89 04 24             	mov    %eax,(%esp)
c0107ffc:	e8 d3 fa ff ff       	call   c0107ad4 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108001:	c7 04 24 a0 b9 10 c0 	movl   $0xc010b9a0,(%esp)
c0108008:	e8 46 83 ff ff       	call   c0100353 <cprintf>
}
c010800d:	c9                   	leave  
c010800e:	c3                   	ret    

c010800f <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c010800f:	55                   	push   %ebp
c0108010:	89 e5                	mov    %esp,%ebp
c0108012:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108015:	e8 e6 ce ff ff       	call   c0104f00 <nr_free_pages>
c010801a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c010801d:	e8 7a f7 ff ff       	call   c010779c <mm_create>
c0108022:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c0108027:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010802c:	85 c0                	test   %eax,%eax
c010802e:	75 24                	jne    c0108054 <check_pgfault+0x45>
c0108030:	c7 44 24 0c bf b9 10 	movl   $0xc010b9bf,0xc(%esp)
c0108037:	c0 
c0108038:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c010803f:	c0 
c0108040:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0108047:	00 
c0108048:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c010804f:	e8 a4 8c ff ff       	call   c0100cf8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108054:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0108059:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c010805c:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0108062:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108065:	89 50 0c             	mov    %edx,0xc(%eax)
c0108068:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010806b:	8b 40 0c             	mov    0xc(%eax),%eax
c010806e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108074:	8b 00                	mov    (%eax),%eax
c0108076:	85 c0                	test   %eax,%eax
c0108078:	74 24                	je     c010809e <check_pgfault+0x8f>
c010807a:	c7 44 24 0c d7 b9 10 	movl   $0xc010b9d7,0xc(%esp)
c0108081:	c0 
c0108082:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0108089:	c0 
c010808a:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0108091:	00 
c0108092:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0108099:	e8 5a 8c ff ff       	call   c0100cf8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c010809e:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01080a5:	00 
c01080a6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01080ad:	00 
c01080ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01080b5:	e8 5a f7 ff ff       	call   c0107814 <vma_create>
c01080ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01080bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01080c1:	75 24                	jne    c01080e7 <check_pgfault+0xd8>
c01080c3:	c7 44 24 0c 68 b8 10 	movl   $0xc010b868,0xc(%esp)
c01080ca:	c0 
c01080cb:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c01080d2:	c0 
c01080d3:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01080da:	00 
c01080db:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c01080e2:	e8 11 8c ff ff       	call   c0100cf8 <__panic>

    insert_vma_struct(mm, vma);
c01080e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01080ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080f1:	89 04 24             	mov    %eax,(%esp)
c01080f4:	e8 ab f8 ff ff       	call   c01079a4 <insert_vma_struct>

    uintptr_t addr = 0x100;
c01080f9:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108100:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108107:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010810a:	89 04 24             	mov    %eax,(%esp)
c010810d:	e8 3d f7 ff ff       	call   c010784f <find_vma>
c0108112:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108115:	74 24                	je     c010813b <check_pgfault+0x12c>
c0108117:	c7 44 24 0c e5 b9 10 	movl   $0xc010b9e5,0xc(%esp)
c010811e:	c0 
c010811f:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0108126:	c0 
c0108127:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010812e:	00 
c010812f:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0108136:	e8 bd 8b ff ff       	call   c0100cf8 <__panic>

    int i, sum = 0;
c010813b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108149:	eb 17                	jmp    c0108162 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c010814b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010814e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108151:	01 d0                	add    %edx,%eax
c0108153:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108156:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108158:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010815b:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c010815e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108162:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108166:	7e e3                	jle    c010814b <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010816f:	eb 15                	jmp    c0108186 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108171:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108174:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108177:	01 d0                	add    %edx,%eax
c0108179:	0f b6 00             	movzbl (%eax),%eax
c010817c:	0f be c0             	movsbl %al,%eax
c010817f:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108182:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108186:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010818a:	7e e5                	jle    c0108171 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c010818c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108190:	74 24                	je     c01081b6 <check_pgfault+0x1a7>
c0108192:	c7 44 24 0c ff b9 10 	movl   $0xc010b9ff,0xc(%esp)
c0108199:	c0 
c010819a:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c01081a1:	c0 
c01081a2:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01081a9:	00 
c01081aa:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c01081b1:	e8 42 8b ff ff       	call   c0100cf8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01081b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01081b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01081bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01081bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081cb:	89 04 24             	mov    %eax,(%esp)
c01081ce:	e8 fe d5 ff ff       	call   c01057d1 <page_remove>
    free_page(pa2page(pgdir[0]));
c01081d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081d6:	8b 00                	mov    (%eax),%eax
c01081d8:	89 04 24             	mov    %eax,(%esp)
c01081db:	e8 77 f5 ff ff       	call   c0107757 <pa2page>
c01081e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01081e7:	00 
c01081e8:	89 04 24             	mov    %eax,(%esp)
c01081eb:	e8 de cc ff ff       	call   c0104ece <free_pages>
    pgdir[0] = 0;
c01081f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01081f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081fc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108203:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108206:	89 04 24             	mov    %eax,(%esp)
c0108209:	e8 c6 f8 ff ff       	call   c0107ad4 <mm_destroy>
    check_mm_struct = NULL;
c010820e:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c0108215:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108218:	e8 e3 cc ff ff       	call   c0104f00 <nr_free_pages>
c010821d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108220:	74 24                	je     c0108246 <check_pgfault+0x237>
c0108222:	c7 44 24 0c 08 ba 10 	movl   $0xc010ba08,0xc(%esp)
c0108229:	c0 
c010822a:	c7 44 24 08 c7 b7 10 	movl   $0xc010b7c7,0x8(%esp)
c0108231:	c0 
c0108232:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0108239:	00 
c010823a:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c0108241:	e8 b2 8a ff ff       	call   c0100cf8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108246:	c7 04 24 2f ba 10 c0 	movl   $0xc010ba2f,(%esp)
c010824d:	e8 01 81 ff ff       	call   c0100353 <cprintf>
}
c0108252:	c9                   	leave  
c0108253:	c3                   	ret    

c0108254 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108254:	55                   	push   %ebp
c0108255:	89 e5                	mov    %esp,%ebp
c0108257:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c010825a:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108261:	8b 45 10             	mov    0x10(%ebp),%eax
c0108264:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108268:	8b 45 08             	mov    0x8(%ebp),%eax
c010826b:	89 04 24             	mov    %eax,(%esp)
c010826e:	e8 dc f5 ff ff       	call   c010784f <find_vma>
c0108273:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108276:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010827b:	83 c0 01             	add    $0x1,%eax
c010827e:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108283:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108287:	74 0b                	je     c0108294 <do_pgfault+0x40>
c0108289:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010828c:	8b 40 04             	mov    0x4(%eax),%eax
c010828f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108292:	76 18                	jbe    c01082ac <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108294:	8b 45 10             	mov    0x10(%ebp),%eax
c0108297:	89 44 24 04          	mov    %eax,0x4(%esp)
c010829b:	c7 04 24 4c ba 10 c0 	movl   $0xc010ba4c,(%esp)
c01082a2:	e8 ac 80 ff ff       	call   c0100353 <cprintf>
        goto failed;
c01082a7:	e9 71 01 00 00       	jmp    c010841d <do_pgfault+0x1c9>
    }
    //check the error_code
    switch (error_code & 3) {
c01082ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082af:	83 e0 03             	and    $0x3,%eax
c01082b2:	85 c0                	test   %eax,%eax
c01082b4:	74 36                	je     c01082ec <do_pgfault+0x98>
c01082b6:	83 f8 01             	cmp    $0x1,%eax
c01082b9:	74 20                	je     c01082db <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01082bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082be:	8b 40 0c             	mov    0xc(%eax),%eax
c01082c1:	83 e0 02             	and    $0x2,%eax
c01082c4:	85 c0                	test   %eax,%eax
c01082c6:	75 11                	jne    c01082d9 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01082c8:	c7 04 24 7c ba 10 c0 	movl   $0xc010ba7c,(%esp)
c01082cf:	e8 7f 80 ff ff       	call   c0100353 <cprintf>
            goto failed;
c01082d4:	e9 44 01 00 00       	jmp    c010841d <do_pgfault+0x1c9>
        }
        break;
c01082d9:	eb 2f                	jmp    c010830a <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01082db:	c7 04 24 dc ba 10 c0 	movl   $0xc010badc,(%esp)
c01082e2:	e8 6c 80 ff ff       	call   c0100353 <cprintf>
        goto failed;
c01082e7:	e9 31 01 00 00       	jmp    c010841d <do_pgfault+0x1c9>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01082ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082ef:	8b 40 0c             	mov    0xc(%eax),%eax
c01082f2:	83 e0 05             	and    $0x5,%eax
c01082f5:	85 c0                	test   %eax,%eax
c01082f7:	75 11                	jne    c010830a <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c01082f9:	c7 04 24 14 bb 10 c0 	movl   $0xc010bb14,(%esp)
c0108300:	e8 4e 80 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108305:	e9 13 01 00 00       	jmp    c010841d <do_pgfault+0x1c9>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c010830a:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108311:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108314:	8b 40 0c             	mov    0xc(%eax),%eax
c0108317:	83 e0 02             	and    $0x2,%eax
c010831a:	85 c0                	test   %eax,%eax
c010831c:	74 04                	je     c0108322 <do_pgfault+0xce>
        perm |= PTE_W;
c010831e:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108322:	8b 45 10             	mov    0x10(%ebp),%eax
c0108325:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108328:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010832b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108330:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108333:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c010833a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
	ptep = get_pte(mm->pgdir, addr, 1);
c0108341:	8b 45 08             	mov    0x8(%ebp),%eax
c0108344:	8b 40 0c             	mov    0xc(%eax),%eax
c0108347:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010834e:	00 
c010834f:	8b 55 10             	mov    0x10(%ebp),%edx
c0108352:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108356:	89 04 24             	mov    %eax,(%esp)
c0108359:	e8 6c d2 ff ff       	call   c01055ca <get_pte>
c010835e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(*ptep == 0){
c0108361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108364:	8b 00                	mov    (%eax),%eax
c0108366:	85 c0                	test   %eax,%eax
c0108368:	75 24                	jne    c010838e <do_pgfault+0x13a>
		struct Page *p = pgdir_alloc_page(mm->pgdir, addr, perm);
c010836a:	8b 45 08             	mov    0x8(%ebp),%eax
c010836d:	8b 40 0c             	mov    0xc(%eax),%eax
c0108370:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108373:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108377:	8b 55 10             	mov    0x10(%ebp),%edx
c010837a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010837e:	89 04 24             	mov    %eax,(%esp)
c0108381:	e8 a5 d5 ff ff       	call   c010592b <pgdir_alloc_page>
c0108386:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108389:	e9 88 00 00 00       	jmp    c0108416 <do_pgfault+0x1c2>
	}
	else{
		if(swap_init_ok){
c010838e:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0108393:	85 c0                	test   %eax,%eax
c0108395:	74 68                	je     c01083ff <do_pgfault+0x1ab>
			struct Page *page = NULL;
c0108397:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			int s_in = swap_in(mm, addr, &page);
c010839e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01083a1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01083a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01083af:	89 04 24             	mov    %eax,(%esp)
c01083b2:	e8 04 e6 ff ff       	call   c01069bb <swap_in>
c01083b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
			page_insert(mm->pgdir, page, addr, perm);
c01083ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01083bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01083c0:	8b 40 0c             	mov    0xc(%eax),%eax
c01083c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01083c6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01083ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
c01083cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01083d1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083d5:	89 04 24             	mov    %eax,(%esp)
c01083d8:	e8 38 d4 ff ff       	call   c0105815 <page_insert>
			swap_map_swappable(mm, addr, page, s_in);
c01083dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01083e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01083e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01083e7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01083ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01083f5:	89 04 24             	mov    %eax,(%esp)
c01083f8:	e8 f5 e3 ff ff       	call   c01067f2 <swap_map_swappable>
c01083fd:	eb 17                	jmp    c0108416 <do_pgfault+0x1c2>
		}
		else{
			cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01083ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108402:	8b 00                	mov    (%eax),%eax
c0108404:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108408:	c7 04 24 78 bb 10 c0 	movl   $0xc010bb78,(%esp)
c010840f:	e8 3f 7f ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108414:	eb 07                	jmp    c010841d <do_pgfault+0x1c9>
		}
	}
   ret = 0;
c0108416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010841d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108420:	c9                   	leave  
c0108421:	c3                   	ret    

c0108422 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108422:	55                   	push   %ebp
c0108423:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108425:	8b 55 08             	mov    0x8(%ebp),%edx
c0108428:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010842d:	29 c2                	sub    %eax,%edx
c010842f:	89 d0                	mov    %edx,%eax
c0108431:	c1 f8 05             	sar    $0x5,%eax
}
c0108434:	5d                   	pop    %ebp
c0108435:	c3                   	ret    

c0108436 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108436:	55                   	push   %ebp
c0108437:	89 e5                	mov    %esp,%ebp
c0108439:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010843c:	8b 45 08             	mov    0x8(%ebp),%eax
c010843f:	89 04 24             	mov    %eax,(%esp)
c0108442:	e8 db ff ff ff       	call   c0108422 <page2ppn>
c0108447:	c1 e0 0c             	shl    $0xc,%eax
}
c010844a:	c9                   	leave  
c010844b:	c3                   	ret    

c010844c <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c010844c:	55                   	push   %ebp
c010844d:	89 e5                	mov    %esp,%ebp
c010844f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108452:	8b 45 08             	mov    0x8(%ebp),%eax
c0108455:	89 04 24             	mov    %eax,(%esp)
c0108458:	e8 d9 ff ff ff       	call   c0108436 <page2pa>
c010845d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108460:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108463:	c1 e8 0c             	shr    $0xc,%eax
c0108466:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108469:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010846e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108471:	72 23                	jb     c0108496 <page2kva+0x4a>
c0108473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108476:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010847a:	c7 44 24 08 a0 bb 10 	movl   $0xc010bba0,0x8(%esp)
c0108481:	c0 
c0108482:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108489:	00 
c010848a:	c7 04 24 c3 bb 10 c0 	movl   $0xc010bbc3,(%esp)
c0108491:	e8 62 88 ff ff       	call   c0100cf8 <__panic>
c0108496:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108499:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010849e:	c9                   	leave  
c010849f:	c3                   	ret    

c01084a0 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01084a0:	55                   	push   %ebp
c01084a1:	89 e5                	mov    %esp,%ebp
c01084a3:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01084a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01084ad:	e8 96 95 ff ff       	call   c0101a48 <ide_device_valid>
c01084b2:	85 c0                	test   %eax,%eax
c01084b4:	75 1c                	jne    c01084d2 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01084b6:	c7 44 24 08 d1 bb 10 	movl   $0xc010bbd1,0x8(%esp)
c01084bd:	c0 
c01084be:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01084c5:	00 
c01084c6:	c7 04 24 eb bb 10 c0 	movl   $0xc010bbeb,(%esp)
c01084cd:	e8 26 88 ff ff       	call   c0100cf8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01084d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01084d9:	e8 a9 95 ff ff       	call   c0101a87 <ide_device_size>
c01084de:	c1 e8 03             	shr    $0x3,%eax
c01084e1:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c01084e6:	c9                   	leave  
c01084e7:	c3                   	ret    

c01084e8 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01084e8:	55                   	push   %ebp
c01084e9:	89 e5                	mov    %esp,%ebp
c01084eb:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01084ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084f1:	89 04 24             	mov    %eax,(%esp)
c01084f4:	e8 53 ff ff ff       	call   c010844c <page2kva>
c01084f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01084fc:	c1 ea 08             	shr    $0x8,%edx
c01084ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108506:	74 0b                	je     c0108513 <swapfs_read+0x2b>
c0108508:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c010850e:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108511:	72 23                	jb     c0108536 <swapfs_read+0x4e>
c0108513:	8b 45 08             	mov    0x8(%ebp),%eax
c0108516:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010851a:	c7 44 24 08 fc bb 10 	movl   $0xc010bbfc,0x8(%esp)
c0108521:	c0 
c0108522:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108529:	00 
c010852a:	c7 04 24 eb bb 10 c0 	movl   $0xc010bbeb,(%esp)
c0108531:	e8 c2 87 ff ff       	call   c0100cf8 <__panic>
c0108536:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108539:	c1 e2 03             	shl    $0x3,%edx
c010853c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108543:	00 
c0108544:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108548:	89 54 24 04          	mov    %edx,0x4(%esp)
c010854c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108553:	e8 6e 95 ff ff       	call   c0101ac6 <ide_read_secs>
}
c0108558:	c9                   	leave  
c0108559:	c3                   	ret    

c010855a <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010855a:	55                   	push   %ebp
c010855b:	89 e5                	mov    %esp,%ebp
c010855d:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108563:	89 04 24             	mov    %eax,(%esp)
c0108566:	e8 e1 fe ff ff       	call   c010844c <page2kva>
c010856b:	8b 55 08             	mov    0x8(%ebp),%edx
c010856e:	c1 ea 08             	shr    $0x8,%edx
c0108571:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108578:	74 0b                	je     c0108585 <swapfs_write+0x2b>
c010857a:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108580:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108583:	72 23                	jb     c01085a8 <swapfs_write+0x4e>
c0108585:	8b 45 08             	mov    0x8(%ebp),%eax
c0108588:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010858c:	c7 44 24 08 fc bb 10 	movl   $0xc010bbfc,0x8(%esp)
c0108593:	c0 
c0108594:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c010859b:	00 
c010859c:	c7 04 24 eb bb 10 c0 	movl   $0xc010bbeb,(%esp)
c01085a3:	e8 50 87 ff ff       	call   c0100cf8 <__panic>
c01085a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01085ab:	c1 e2 03             	shl    $0x3,%edx
c01085ae:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01085b5:	00 
c01085b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085ba:	89 54 24 04          	mov    %edx,0x4(%esp)
c01085be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01085c5:	e8 3e 97 ff ff       	call   c0101d08 <ide_write_secs>
}
c01085ca:	c9                   	leave  
c01085cb:	c3                   	ret    

c01085cc <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c01085cc:	52                   	push   %edx
    call *%ebx              # call fn
c01085cd:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c01085cf:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c01085d0:	e8 28 08 00 00       	call   c0108dfd <do_exit>

c01085d5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01085d5:	55                   	push   %ebp
c01085d6:	89 e5                	mov    %esp,%ebp
c01085d8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01085db:	9c                   	pushf  
c01085dc:	58                   	pop    %eax
c01085dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01085e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01085e3:	25 00 02 00 00       	and    $0x200,%eax
c01085e8:	85 c0                	test   %eax,%eax
c01085ea:	74 0c                	je     c01085f8 <__intr_save+0x23>
        intr_disable();
c01085ec:	e8 5f 99 ff ff       	call   c0101f50 <intr_disable>
        return 1;
c01085f1:	b8 01 00 00 00       	mov    $0x1,%eax
c01085f6:	eb 05                	jmp    c01085fd <__intr_save+0x28>
    }
    return 0;
c01085f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01085fd:	c9                   	leave  
c01085fe:	c3                   	ret    

c01085ff <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01085ff:	55                   	push   %ebp
c0108600:	89 e5                	mov    %esp,%ebp
c0108602:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108609:	74 05                	je     c0108610 <__intr_restore+0x11>
        intr_enable();
c010860b:	e8 3a 99 ff ff       	call   c0101f4a <intr_enable>
    }
}
c0108610:	c9                   	leave  
c0108611:	c3                   	ret    

c0108612 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108612:	55                   	push   %ebp
c0108613:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108615:	8b 55 08             	mov    0x8(%ebp),%edx
c0108618:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010861d:	29 c2                	sub    %eax,%edx
c010861f:	89 d0                	mov    %edx,%eax
c0108621:	c1 f8 05             	sar    $0x5,%eax
}
c0108624:	5d                   	pop    %ebp
c0108625:	c3                   	ret    

c0108626 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108626:	55                   	push   %ebp
c0108627:	89 e5                	mov    %esp,%ebp
c0108629:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010862c:	8b 45 08             	mov    0x8(%ebp),%eax
c010862f:	89 04 24             	mov    %eax,(%esp)
c0108632:	e8 db ff ff ff       	call   c0108612 <page2ppn>
c0108637:	c1 e0 0c             	shl    $0xc,%eax
}
c010863a:	c9                   	leave  
c010863b:	c3                   	ret    

c010863c <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010863c:	55                   	push   %ebp
c010863d:	89 e5                	mov    %esp,%ebp
c010863f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0108642:	8b 45 08             	mov    0x8(%ebp),%eax
c0108645:	c1 e8 0c             	shr    $0xc,%eax
c0108648:	89 c2                	mov    %eax,%edx
c010864a:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010864f:	39 c2                	cmp    %eax,%edx
c0108651:	72 1c                	jb     c010866f <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0108653:	c7 44 24 08 1c bc 10 	movl   $0xc010bc1c,0x8(%esp)
c010865a:	c0 
c010865b:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0108662:	00 
c0108663:	c7 04 24 3b bc 10 c0 	movl   $0xc010bc3b,(%esp)
c010866a:	e8 89 86 ff ff       	call   c0100cf8 <__panic>
    }
    return &pages[PPN(pa)];
c010866f:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108674:	8b 55 08             	mov    0x8(%ebp),%edx
c0108677:	c1 ea 0c             	shr    $0xc,%edx
c010867a:	c1 e2 05             	shl    $0x5,%edx
c010867d:	01 d0                	add    %edx,%eax
}
c010867f:	c9                   	leave  
c0108680:	c3                   	ret    

c0108681 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0108681:	55                   	push   %ebp
c0108682:	89 e5                	mov    %esp,%ebp
c0108684:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108687:	8b 45 08             	mov    0x8(%ebp),%eax
c010868a:	89 04 24             	mov    %eax,(%esp)
c010868d:	e8 94 ff ff ff       	call   c0108626 <page2pa>
c0108692:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108698:	c1 e8 0c             	shr    $0xc,%eax
c010869b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010869e:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01086a3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01086a6:	72 23                	jb     c01086cb <page2kva+0x4a>
c01086a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086af:	c7 44 24 08 4c bc 10 	movl   $0xc010bc4c,0x8(%esp)
c01086b6:	c0 
c01086b7:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01086be:	00 
c01086bf:	c7 04 24 3b bc 10 c0 	movl   $0xc010bc3b,(%esp)
c01086c6:	e8 2d 86 ff ff       	call   c0100cf8 <__panic>
c01086cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01086d3:	c9                   	leave  
c01086d4:	c3                   	ret    

c01086d5 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01086d5:	55                   	push   %ebp
c01086d6:	89 e5                	mov    %esp,%ebp
c01086d8:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01086db:	8b 45 08             	mov    0x8(%ebp),%eax
c01086de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086e1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01086e8:	77 23                	ja     c010870d <kva2page+0x38>
c01086ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086f1:	c7 44 24 08 70 bc 10 	movl   $0xc010bc70,0x8(%esp)
c01086f8:	c0 
c01086f9:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0108700:	00 
c0108701:	c7 04 24 3b bc 10 c0 	movl   $0xc010bc3b,(%esp)
c0108708:	e8 eb 85 ff ff       	call   c0100cf8 <__panic>
c010870d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108710:	05 00 00 00 40       	add    $0x40000000,%eax
c0108715:	89 04 24             	mov    %eax,(%esp)
c0108718:	e8 1f ff ff ff       	call   c010863c <pa2page>
}
c010871d:	c9                   	leave  
c010871e:	c3                   	ret    

c010871f <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c010871f:	55                   	push   %ebp
c0108720:	89 e5                	mov    %esp,%ebp
c0108722:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0108725:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c010872c:	e8 d5 c2 ff ff       	call   c0104a06 <kmalloc>
c0108731:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0108734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108738:	0f 84 a3 00 00 00    	je     c01087e1 <alloc_proc+0xc2>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
     proc->state = PROC_UNINIT;//初始化时候的进程状态;
c010873e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     proc->pid = 0;//pid设为0;
c0108747:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010874a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
     proc->runs = 0;//运行时间初始化为0;
c0108751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108754:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
     proc->kstack = 0;//内核栈初始化为0;
c010875b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010875e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     proc->need_resched = 0;//初始化为0;
c0108765:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108768:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
     proc->parent = current;//父进程位current;
c010876f:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108775:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108778:	89 50 14             	mov    %edx,0x14(%eax)
     proc->mm = NULL;
c010877b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010877e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
     memset(&(proc->context), 0, sizeof(struct context));
c0108785:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108788:	83 c0 1c             	add    $0x1c,%eax
c010878b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108792:	00 
c0108793:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010879a:	00 
c010879b:	89 04 24             	mov    %eax,(%esp)
c010879e:	e8 dc 14 00 00       	call   c0109c7f <memset>
     proc->tf = NULL;
c01087a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087a6:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
     proc->cr3 = boot_cr3;//初始化为boot_cr3;
c01087ad:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c01087b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087b6:	89 50 40             	mov    %edx,0x40(%eax)
     proc->flags = 0;
c01087b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087bc:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
     memset(proc->name, 0, PROC_NAME_LEN+1);
c01087c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087c6:	83 c0 48             	add    $0x48,%eax
c01087c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01087d0:	00 
c01087d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01087d8:	00 
c01087d9:	89 04 24             	mov    %eax,(%esp)
c01087dc:	e8 9e 14 00 00       	call   c0109c7f <memset>
     /*for(int i=0; i<PROC_NAME_LEN+1; i++)
     {
     	proc->name[i] = 0;
     }*/
    }
    return proc;
c01087e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01087e4:	c9                   	leave  
c01087e5:	c3                   	ret    

c01087e6 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01087e6:	55                   	push   %ebp
c01087e7:	89 e5                	mov    %esp,%ebp
c01087e9:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01087ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ef:	83 c0 48             	add    $0x48,%eax
c01087f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01087f9:	00 
c01087fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108801:	00 
c0108802:	89 04 24             	mov    %eax,(%esp)
c0108805:	e8 75 14 00 00       	call   c0109c7f <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c010880a:	8b 45 08             	mov    0x8(%ebp),%eax
c010880d:	8d 50 48             	lea    0x48(%eax),%edx
c0108810:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108817:	00 
c0108818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010881b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010881f:	89 14 24             	mov    %edx,(%esp)
c0108822:	e8 3a 15 00 00       	call   c0109d61 <memcpy>
}
c0108827:	c9                   	leave  
c0108828:	c3                   	ret    

c0108829 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0108829:	55                   	push   %ebp
c010882a:	89 e5                	mov    %esp,%ebp
c010882c:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c010882f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108836:	00 
c0108837:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010883e:	00 
c010883f:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c0108846:	e8 34 14 00 00       	call   c0109c7f <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010884b:	8b 45 08             	mov    0x8(%ebp),%eax
c010884e:	83 c0 48             	add    $0x48,%eax
c0108851:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108858:	00 
c0108859:	89 44 24 04          	mov    %eax,0x4(%esp)
c010885d:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c0108864:	e8 f8 14 00 00       	call   c0109d61 <memcpy>
}
c0108869:	c9                   	leave  
c010886a:	c3                   	ret    

c010886b <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c010886b:	55                   	push   %ebp
c010886c:	89 e5                	mov    %esp,%ebp
c010886e:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108871:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0108878:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010887d:	83 c0 01             	add    $0x1,%eax
c0108880:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108885:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010888a:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c010888f:	7e 0c                	jle    c010889d <get_pid+0x32>
        last_pid = 1;
c0108891:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108898:	00 00 00 
        goto inside;
c010889b:	eb 13                	jmp    c01088b0 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c010889d:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c01088a3:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01088a8:	39 c2                	cmp    %eax,%edx
c01088aa:	0f 8c ac 00 00 00    	jl     c010895c <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01088b0:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c01088b7:	20 00 00 
    repeat:
        le = list;
c01088ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01088bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01088c0:	eb 7f                	jmp    c0108941 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01088c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01088c5:	83 e8 58             	sub    $0x58,%eax
c01088c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01088cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088ce:	8b 50 04             	mov    0x4(%eax),%edx
c01088d1:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01088d6:	39 c2                	cmp    %eax,%edx
c01088d8:	75 3e                	jne    c0108918 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c01088da:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01088df:	83 c0 01             	add    $0x1,%eax
c01088e2:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01088e7:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c01088ed:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01088f2:	39 c2                	cmp    %eax,%edx
c01088f4:	7c 4b                	jl     c0108941 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c01088f6:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01088fb:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108900:	7e 0a                	jle    c010890c <get_pid+0xa1>
                        last_pid = 1;
c0108902:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108909:	00 00 00 
                    }
                    next_safe = MAX_PID;
c010890c:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108913:	20 00 00 
                    goto repeat;
c0108916:	eb a2                	jmp    c01088ba <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108918:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010891b:	8b 50 04             	mov    0x4(%eax),%edx
c010891e:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108923:	39 c2                	cmp    %eax,%edx
c0108925:	7e 1a                	jle    c0108941 <get_pid+0xd6>
c0108927:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010892a:	8b 50 04             	mov    0x4(%eax),%edx
c010892d:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108932:	39 c2                	cmp    %eax,%edx
c0108934:	7d 0b                	jge    c0108941 <get_pid+0xd6>
                next_safe = proc->pid;
c0108936:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108939:	8b 40 04             	mov    0x4(%eax),%eax
c010893c:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c0108941:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108944:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108947:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010894a:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c010894d:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108950:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108953:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108956:	0f 85 66 ff ff ff    	jne    c01088c2 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c010895c:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c0108961:	c9                   	leave  
c0108962:	c3                   	ret    

c0108963 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108963:	55                   	push   %ebp
c0108964:	89 e5                	mov    %esp,%ebp
c0108966:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0108969:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010896e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108971:	74 63                	je     c01089d6 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108973:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108978:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010897b:	8b 45 08             	mov    0x8(%ebp),%eax
c010897e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108981:	e8 4f fc ff ff       	call   c01085d5 <__intr_save>
c0108986:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108989:	8b 45 08             	mov    0x8(%ebp),%eax
c010898c:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108991:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108994:	8b 40 0c             	mov    0xc(%eax),%eax
c0108997:	05 00 20 00 00       	add    $0x2000,%eax
c010899c:	89 04 24             	mov    %eax,(%esp)
c010899f:	e8 71 c3 ff ff       	call   c0104d15 <load_esp0>
            lcr3(next->cr3);
c01089a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089a7:	8b 40 40             	mov    0x40(%eax),%eax
c01089aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01089ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089b0:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01089b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089b6:	8d 50 1c             	lea    0x1c(%eax),%edx
c01089b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089bc:	83 c0 1c             	add    $0x1c,%eax
c01089bf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01089c3:	89 04 24             	mov    %eax,(%esp)
c01089c6:	e8 84 06 00 00       	call   c010904f <switch_to>
        }
        local_intr_restore(intr_flag);
c01089cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089ce:	89 04 24             	mov    %eax,(%esp)
c01089d1:	e8 29 fc ff ff       	call   c01085ff <__intr_restore>
    }
}
c01089d6:	c9                   	leave  
c01089d7:	c3                   	ret    

c01089d8 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c01089d8:	55                   	push   %ebp
c01089d9:	89 e5                	mov    %esp,%ebp
c01089db:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c01089de:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01089e3:	8b 40 3c             	mov    0x3c(%eax),%eax
c01089e6:	89 04 24             	mov    %eax,(%esp)
c01089e9:	e8 38 9e ff ff       	call   c0102826 <forkrets>
}
c01089ee:	c9                   	leave  
c01089ef:	c3                   	ret    

c01089f0 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c01089f0:	55                   	push   %ebp
c01089f1:	89 e5                	mov    %esp,%ebp
c01089f3:	53                   	push   %ebx
c01089f4:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c01089f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01089fa:	8d 58 60             	lea    0x60(%eax),%ebx
c01089fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a00:	8b 40 04             	mov    0x4(%eax),%eax
c0108a03:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108a0a:	00 
c0108a0b:	89 04 24             	mov    %eax,(%esp)
c0108a0e:	e8 bf 07 00 00       	call   c01091d2 <hash32>
c0108a13:	c1 e0 03             	shl    $0x3,%eax
c0108a16:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a1e:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a30:	8b 40 04             	mov    0x4(%eax),%eax
c0108a33:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108a36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108a39:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108a3c:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108a3f:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108a48:	89 10                	mov    %edx,(%eax)
c0108a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a4d:	8b 10                	mov    (%eax),%edx
c0108a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108a52:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a58:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a5b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a61:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108a64:	89 10                	mov    %edx,(%eax)
}
c0108a66:	83 c4 34             	add    $0x34,%esp
c0108a69:	5b                   	pop    %ebx
c0108a6a:	5d                   	pop    %ebp
c0108a6b:	c3                   	ret    

c0108a6c <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108a6c:	55                   	push   %ebp
c0108a6d:	89 e5                	mov    %esp,%ebp
c0108a6f:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108a72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108a76:	7e 5f                	jle    c0108ad7 <find_proc+0x6b>
c0108a78:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108a7f:	7f 56                	jg     c0108ad7 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a84:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108a8b:	00 
c0108a8c:	89 04 24             	mov    %eax,(%esp)
c0108a8f:	e8 3e 07 00 00       	call   c01091d2 <hash32>
c0108a94:	c1 e0 03             	shl    $0x3,%eax
c0108a97:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108aa5:	eb 19                	jmp    c0108ac0 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aaa:	83 e8 60             	sub    $0x60,%eax
c0108aad:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ab3:	8b 40 04             	mov    0x4(%eax),%eax
c0108ab6:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108ab9:	75 05                	jne    c0108ac0 <find_proc+0x54>
                return proc;
c0108abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108abe:	eb 1c                	jmp    c0108adc <find_proc+0x70>
c0108ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ac3:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ac9:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ad2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108ad5:	75 d0                	jne    c0108aa7 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108adc:	c9                   	leave  
c0108add:	c3                   	ret    

c0108ade <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108ade:	55                   	push   %ebp
c0108adf:	89 e5                	mov    %esp,%ebp
c0108ae1:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108ae4:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0108aeb:	00 
c0108aec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108af3:	00 
c0108af4:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108af7:	89 04 24             	mov    %eax,(%esp)
c0108afa:	e8 80 11 00 00       	call   c0109c7f <memset>
    tf.tf_cs = KERNEL_CS;
c0108aff:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108b05:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108b0b:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108b0f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108b13:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108b17:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b1e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108b21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b24:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108b27:	b8 cc 85 10 c0       	mov    $0xc01085cc,%eax
c0108b2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108b2f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b32:	80 cc 01             	or     $0x1,%ah
c0108b35:	89 c2                	mov    %eax,%edx
c0108b37:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108b3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108b45:	00 
c0108b46:	89 14 24             	mov    %edx,(%esp)
c0108b49:	e8 79 01 00 00       	call   c0108cc7 <do_fork>
}
c0108b4e:	c9                   	leave  
c0108b4f:	c3                   	ret    

c0108b50 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108b50:	55                   	push   %ebp
c0108b51:	89 e5                	mov    %esp,%ebp
c0108b53:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108b56:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108b5d:	e8 01 c3 ff ff       	call   c0104e63 <alloc_pages>
c0108b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108b69:	74 1a                	je     c0108b85 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b6e:	89 04 24             	mov    %eax,(%esp)
c0108b71:	e8 0b fb ff ff       	call   c0108681 <page2kva>
c0108b76:	89 c2                	mov    %eax,%edx
c0108b78:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b7b:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108b7e:	b8 00 00 00 00       	mov    $0x0,%eax
c0108b83:	eb 05                	jmp    c0108b8a <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108b85:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108b8a:	c9                   	leave  
c0108b8b:	c3                   	ret    

c0108b8c <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108b8c:	55                   	push   %ebp
c0108b8d:	89 e5                	mov    %esp,%ebp
c0108b8f:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b95:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b98:	89 04 24             	mov    %eax,(%esp)
c0108b9b:	e8 35 fb ff ff       	call   c01086d5 <kva2page>
c0108ba0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108ba7:	00 
c0108ba8:	89 04 24             	mov    %eax,(%esp)
c0108bab:	e8 1e c3 ff ff       	call   c0104ece <free_pages>
}
c0108bb0:	c9                   	leave  
c0108bb1:	c3                   	ret    

c0108bb2 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108bb2:	55                   	push   %ebp
c0108bb3:	89 e5                	mov    %esp,%ebp
c0108bb5:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108bb8:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108bbd:	8b 40 18             	mov    0x18(%eax),%eax
c0108bc0:	85 c0                	test   %eax,%eax
c0108bc2:	74 24                	je     c0108be8 <copy_mm+0x36>
c0108bc4:	c7 44 24 0c 94 bc 10 	movl   $0xc010bc94,0xc(%esp)
c0108bcb:	c0 
c0108bcc:	c7 44 24 08 a8 bc 10 	movl   $0xc010bca8,0x8(%esp)
c0108bd3:	c0 
c0108bd4:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0108bdb:	00 
c0108bdc:	c7 04 24 bd bc 10 c0 	movl   $0xc010bcbd,(%esp)
c0108be3:	e8 10 81 ff ff       	call   c0100cf8 <__panic>
    /* do nothing in this project */
    return 0;
c0108be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108bed:	c9                   	leave  
c0108bee:	c3                   	ret    

c0108bef <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108bef:	55                   	push   %ebp
c0108bf0:	89 e5                	mov    %esp,%ebp
c0108bf2:	57                   	push   %edi
c0108bf3:	56                   	push   %esi
c0108bf4:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bf8:	8b 40 0c             	mov    0xc(%eax),%eax
c0108bfb:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108c00:	89 c2                	mov    %eax,%edx
c0108c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c05:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c0b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c0e:	8b 55 10             	mov    0x10(%ebp),%edx
c0108c11:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108c16:	89 c1                	mov    %eax,%ecx
c0108c18:	83 e1 01             	and    $0x1,%ecx
c0108c1b:	85 c9                	test   %ecx,%ecx
c0108c1d:	74 0e                	je     c0108c2d <copy_thread+0x3e>
c0108c1f:	0f b6 0a             	movzbl (%edx),%ecx
c0108c22:	88 08                	mov    %cl,(%eax)
c0108c24:	83 c0 01             	add    $0x1,%eax
c0108c27:	83 c2 01             	add    $0x1,%edx
c0108c2a:	83 eb 01             	sub    $0x1,%ebx
c0108c2d:	89 c1                	mov    %eax,%ecx
c0108c2f:	83 e1 02             	and    $0x2,%ecx
c0108c32:	85 c9                	test   %ecx,%ecx
c0108c34:	74 0f                	je     c0108c45 <copy_thread+0x56>
c0108c36:	0f b7 0a             	movzwl (%edx),%ecx
c0108c39:	66 89 08             	mov    %cx,(%eax)
c0108c3c:	83 c0 02             	add    $0x2,%eax
c0108c3f:	83 c2 02             	add    $0x2,%edx
c0108c42:	83 eb 02             	sub    $0x2,%ebx
c0108c45:	89 d9                	mov    %ebx,%ecx
c0108c47:	c1 e9 02             	shr    $0x2,%ecx
c0108c4a:	89 c7                	mov    %eax,%edi
c0108c4c:	89 d6                	mov    %edx,%esi
c0108c4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108c50:	89 f2                	mov    %esi,%edx
c0108c52:	89 f8                	mov    %edi,%eax
c0108c54:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108c59:	89 de                	mov    %ebx,%esi
c0108c5b:	83 e6 02             	and    $0x2,%esi
c0108c5e:	85 f6                	test   %esi,%esi
c0108c60:	74 0b                	je     c0108c6d <copy_thread+0x7e>
c0108c62:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108c66:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108c6a:	83 c1 02             	add    $0x2,%ecx
c0108c6d:	83 e3 01             	and    $0x1,%ebx
c0108c70:	85 db                	test   %ebx,%ebx
c0108c72:	74 07                	je     c0108c7b <copy_thread+0x8c>
c0108c74:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108c78:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c7e:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c81:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c8b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c91:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c97:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0108c9d:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108ca0:	8b 52 40             	mov    0x40(%edx),%edx
c0108ca3:	80 ce 02             	or     $0x2,%dh
c0108ca6:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108ca9:	ba d8 89 10 c0       	mov    $0xc01089d8,%edx
c0108cae:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cb1:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cb7:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108cba:	89 c2                	mov    %eax,%edx
c0108cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cbf:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108cc2:	5b                   	pop    %ebx
c0108cc3:	5e                   	pop    %esi
c0108cc4:	5f                   	pop    %edi
c0108cc5:	5d                   	pop    %ebp
c0108cc6:	c3                   	ret    

c0108cc7 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108cc7:	55                   	push   %ebp
c0108cc8:	89 e5                	mov    %esp,%ebp
c0108cca:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108ccd:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108cd4:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108cd9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108cde:	7e 05                	jle    c0108ce5 <do_fork+0x1e>
        goto fork_out;
c0108ce0:	e9 04 01 00 00       	jmp    c0108de9 <do_fork+0x122>
    }
    ret = -E_NO_MEM;
c0108ce5:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
   	proc = alloc_proc();
c0108cec:	e8 2e fa ff ff       	call   c010871f <alloc_proc>
c0108cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
   	if(proc == NULL)
c0108cf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108cf8:	75 05                	jne    c0108cff <do_fork+0x38>
   		goto fork_out;
c0108cfa:	e9 ea 00 00 00       	jmp    c0108de9 <do_fork+0x122>
    int a = setup_kstack(proc);
c0108cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d02:	89 04 24             	mov    %eax,(%esp)
c0108d05:	e8 46 fe ff ff       	call   c0108b50 <setup_kstack>
c0108d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(a != 0)
c0108d0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108d11:	74 11                	je     c0108d24 <do_fork+0x5d>
    	goto bad_fork_cleanup_kstack;
c0108d13:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d17:	89 04 24             	mov    %eax,(%esp)
c0108d1a:	e8 6d fe ff ff       	call   c0108b8c <put_kstack>
c0108d1f:	e9 ca 00 00 00       	jmp    c0108dee <do_fork+0x127>
   	if(proc == NULL)
   		goto fork_out;
    int a = setup_kstack(proc);
    if(a != 0)
    	goto bad_fork_cleanup_kstack;
    int b = copy_mm(clone_flags, proc);
c0108d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d2e:	89 04 24             	mov    %eax,(%esp)
c0108d31:	e8 7c fe ff ff       	call   c0108bb2 <copy_mm>
c0108d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != 0)
c0108d39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108d3d:	74 05                	je     c0108d44 <do_fork+0x7d>
    	goto bad_fork_cleanup_proc;
c0108d3f:	e9 aa 00 00 00       	jmp    c0108dee <do_fork+0x127>
    copy_thread(proc, stack, tf);
c0108d44:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d47:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d55:	89 04 24             	mov    %eax,(%esp)
c0108d58:	e8 92 fe ff ff       	call   c0108bef <copy_thread>
    proc->pid = get_pid();
c0108d5d:	e8 09 fb ff ff       	call   c010886b <get_pid>
c0108d62:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108d65:	89 42 04             	mov    %eax,0x4(%edx)
    hash_proc(proc);
c0108d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d6b:	89 04 24             	mov    %eax,(%esp)
c0108d6e:	e8 7d fc ff ff       	call   c01089f0 <hash_proc>
    list_add(&proc_list, &(proc->list_link));
c0108d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d76:	83 c0 58             	add    $0x58,%eax
c0108d79:	c7 45 e4 10 7c 12 c0 	movl   $0xc0127c10,-0x1c(%ebp)
c0108d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d86:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108d8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d92:	8b 40 04             	mov    0x4(%eax),%eax
c0108d95:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108d98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108d9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d9e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0108da1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108da4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108da7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108daa:	89 10                	mov    %edx,(%eax)
c0108dac:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108daf:	8b 10                	mov    (%eax),%edx
c0108db1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108db4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108db7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108dba:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108dbd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108dc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108dc3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108dc6:	89 10                	mov    %edx,(%eax)
    nr_process++;
c0108dc8:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108dcd:	83 c0 01             	add    $0x1,%eax
c0108dd0:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00
    wakeup_proc(proc);
c0108dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108dd8:	89 04 24             	mov    %eax,(%esp)
c0108ddb:	e8 e3 02 00 00       	call   c01090c3 <wakeup_proc>
    ret = proc->pid;
c0108de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108de3:	8b 40 04             	mov    0x4(%eax),%eax
c0108de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
fork_out:
    return ret;
c0108de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108dec:	eb 0d                	jmp    c0108dfb <do_fork+0x134>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108df1:	89 04 24             	mov    %eax,(%esp)
c0108df4:	e8 28 bc ff ff       	call   c0104a21 <kfree>
    goto fork_out;
c0108df9:	eb ee                	jmp    c0108de9 <do_fork+0x122>
}
c0108dfb:	c9                   	leave  
c0108dfc:	c3                   	ret    

c0108dfd <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108dfd:	55                   	push   %ebp
c0108dfe:	89 e5                	mov    %esp,%ebp
c0108e00:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108e03:	c7 44 24 08 d1 bc 10 	movl   $0xc010bcd1,0x8(%esp)
c0108e0a:	c0 
c0108e0b:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
c0108e12:	00 
c0108e13:	c7 04 24 bd bc 10 c0 	movl   $0xc010bcbd,(%esp)
c0108e1a:	e8 d9 7e ff ff       	call   c0100cf8 <__panic>

c0108e1f <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108e1f:	55                   	push   %ebp
c0108e20:	89 e5                	mov    %esp,%ebp
c0108e22:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108e25:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108e2a:	89 04 24             	mov    %eax,(%esp)
c0108e2d:	e8 f7 f9 ff ff       	call   c0108829 <get_proc_name>
c0108e32:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108e38:	8b 52 04             	mov    0x4(%edx),%edx
c0108e3b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e3f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108e43:	c7 04 24 e4 bc 10 c0 	movl   $0xc010bce4,(%esp)
c0108e4a:	e8 04 75 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108e4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e56:	c7 04 24 0a bd 10 c0 	movl   $0xc010bd0a,(%esp)
c0108e5d:	e8 f1 74 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108e62:	c7 04 24 17 bd 10 c0 	movl   $0xc010bd17,(%esp)
c0108e69:	e8 e5 74 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108e6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108e73:	c9                   	leave  
c0108e74:	c3                   	ret    

c0108e75 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108e75:	55                   	push   %ebp
c0108e76:	89 e5                	mov    %esp,%ebp
c0108e78:	83 ec 28             	sub    $0x28,%esp
c0108e7b:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108e82:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e85:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108e88:	89 50 04             	mov    %edx,0x4(%eax)
c0108e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e8e:	8b 50 04             	mov    0x4(%eax),%edx
c0108e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e94:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108e96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108e9d:	eb 26                	jmp    c0108ec5 <proc_init+0x50>
        list_init(hash_list + i);
c0108e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ea2:	c1 e0 03             	shl    $0x3,%eax
c0108ea5:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108eaa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108eb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108eb3:	89 50 04             	mov    %edx,0x4(%eax)
c0108eb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108eb9:	8b 50 04             	mov    0x4(%eax),%edx
c0108ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ebf:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108ec1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108ec5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108ecc:	7e d1                	jle    c0108e9f <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108ece:	e8 4c f8 ff ff       	call   c010871f <alloc_proc>
c0108ed3:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0108ed8:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108edd:	85 c0                	test   %eax,%eax
c0108edf:	75 1c                	jne    c0108efd <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0108ee1:	c7 44 24 08 33 bd 10 	movl   $0xc010bd33,0x8(%esp)
c0108ee8:	c0 
c0108ee9:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
c0108ef0:	00 
c0108ef1:	c7 04 24 bd bc 10 c0 	movl   $0xc010bcbd,(%esp)
c0108ef8:	e8 fb 7d ff ff       	call   c0100cf8 <__panic>
    }

    idleproc->pid = 0;
c0108efd:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108f09:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f0e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108f14:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f19:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c0108f1e:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108f21:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f26:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108f2d:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f32:	c7 44 24 04 4b bd 10 	movl   $0xc010bd4b,0x4(%esp)
c0108f39:	c0 
c0108f3a:	89 04 24             	mov    %eax,(%esp)
c0108f3d:	e8 a4 f8 ff ff       	call   c01087e6 <set_proc_name>
    nr_process ++;
c0108f42:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108f47:	83 c0 01             	add    $0x1,%eax
c0108f4a:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c0108f4f:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f54:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108f59:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108f60:	00 
c0108f61:	c7 44 24 04 50 bd 10 	movl   $0xc010bd50,0x4(%esp)
c0108f68:	c0 
c0108f69:	c7 04 24 1f 8e 10 c0 	movl   $0xc0108e1f,(%esp)
c0108f70:	e8 69 fb ff ff       	call   c0108ade <kernel_thread>
c0108f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108f78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108f7c:	7f 1c                	jg     c0108f9a <proc_init+0x125>
        panic("create init_main failed.\n");
c0108f7e:	c7 44 24 08 5e bd 10 	movl   $0xc010bd5e,0x8(%esp)
c0108f85:	c0 
c0108f86:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
c0108f8d:	00 
c0108f8e:	c7 04 24 bd bc 10 c0 	movl   $0xc010bcbd,(%esp)
c0108f95:	e8 5e 7d ff ff       	call   c0100cf8 <__panic>
    }

    initproc = find_proc(pid);
c0108f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f9d:	89 04 24             	mov    %eax,(%esp)
c0108fa0:	e8 c7 fa ff ff       	call   c0108a6c <find_proc>
c0108fa5:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c0108faa:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108faf:	c7 44 24 04 78 bd 10 	movl   $0xc010bd78,0x4(%esp)
c0108fb6:	c0 
c0108fb7:	89 04 24             	mov    %eax,(%esp)
c0108fba:	e8 27 f8 ff ff       	call   c01087e6 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108fbf:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108fc4:	85 c0                	test   %eax,%eax
c0108fc6:	74 0c                	je     c0108fd4 <proc_init+0x15f>
c0108fc8:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108fcd:	8b 40 04             	mov    0x4(%eax),%eax
c0108fd0:	85 c0                	test   %eax,%eax
c0108fd2:	74 24                	je     c0108ff8 <proc_init+0x183>
c0108fd4:	c7 44 24 0c 80 bd 10 	movl   $0xc010bd80,0xc(%esp)
c0108fdb:	c0 
c0108fdc:	c7 44 24 08 a8 bc 10 	movl   $0xc010bca8,0x8(%esp)
c0108fe3:	c0 
c0108fe4:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c0108feb:	00 
c0108fec:	c7 04 24 bd bc 10 c0 	movl   $0xc010bcbd,(%esp)
c0108ff3:	e8 00 7d ff ff       	call   c0100cf8 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108ff8:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108ffd:	85 c0                	test   %eax,%eax
c0108fff:	74 0d                	je     c010900e <proc_init+0x199>
c0109001:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0109006:	8b 40 04             	mov    0x4(%eax),%eax
c0109009:	83 f8 01             	cmp    $0x1,%eax
c010900c:	74 24                	je     c0109032 <proc_init+0x1bd>
c010900e:	c7 44 24 0c a8 bd 10 	movl   $0xc010bda8,0xc(%esp)
c0109015:	c0 
c0109016:	c7 44 24 08 a8 bc 10 	movl   $0xc010bca8,0x8(%esp)
c010901d:	c0 
c010901e:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
c0109025:	00 
c0109026:	c7 04 24 bd bc 10 c0 	movl   $0xc010bcbd,(%esp)
c010902d:	e8 c6 7c ff ff       	call   c0100cf8 <__panic>
}
c0109032:	c9                   	leave  
c0109033:	c3                   	ret    

c0109034 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0109034:	55                   	push   %ebp
c0109035:	89 e5                	mov    %esp,%ebp
c0109037:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010903a:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010903f:	8b 40 10             	mov    0x10(%eax),%eax
c0109042:	85 c0                	test   %eax,%eax
c0109044:	74 07                	je     c010904d <cpu_idle+0x19>
            schedule();
c0109046:	e8 c1 00 00 00       	call   c010910c <schedule>
        }
    }
c010904b:	eb ed                	jmp    c010903a <cpu_idle+0x6>
c010904d:	eb eb                	jmp    c010903a <cpu_idle+0x6>

c010904f <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010904f:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0109053:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c0109055:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c0109058:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010905b:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010905e:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0109061:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0109064:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c0109067:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010906a:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010906e:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0109071:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0109074:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c0109077:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010907a:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010907d:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0109080:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0109083:	ff 30                	pushl  (%eax)

    ret
c0109085:	c3                   	ret    

c0109086 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0109086:	55                   	push   %ebp
c0109087:	89 e5                	mov    %esp,%ebp
c0109089:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010908c:	9c                   	pushf  
c010908d:	58                   	pop    %eax
c010908e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0109091:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0109094:	25 00 02 00 00       	and    $0x200,%eax
c0109099:	85 c0                	test   %eax,%eax
c010909b:	74 0c                	je     c01090a9 <__intr_save+0x23>
        intr_disable();
c010909d:	e8 ae 8e ff ff       	call   c0101f50 <intr_disable>
        return 1;
c01090a2:	b8 01 00 00 00       	mov    $0x1,%eax
c01090a7:	eb 05                	jmp    c01090ae <__intr_save+0x28>
    }
    return 0;
c01090a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01090ae:	c9                   	leave  
c01090af:	c3                   	ret    

c01090b0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01090b0:	55                   	push   %ebp
c01090b1:	89 e5                	mov    %esp,%ebp
c01090b3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01090b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01090ba:	74 05                	je     c01090c1 <__intr_restore+0x11>
        intr_enable();
c01090bc:	e8 89 8e ff ff       	call   c0101f4a <intr_enable>
    }
}
c01090c1:	c9                   	leave  
c01090c2:	c3                   	ret    

c01090c3 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c01090c3:	55                   	push   %ebp
c01090c4:	89 e5                	mov    %esp,%ebp
c01090c6:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c01090c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01090cc:	8b 00                	mov    (%eax),%eax
c01090ce:	83 f8 03             	cmp    $0x3,%eax
c01090d1:	74 0a                	je     c01090dd <wakeup_proc+0x1a>
c01090d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01090d6:	8b 00                	mov    (%eax),%eax
c01090d8:	83 f8 02             	cmp    $0x2,%eax
c01090db:	75 24                	jne    c0109101 <wakeup_proc+0x3e>
c01090dd:	c7 44 24 0c d0 bd 10 	movl   $0xc010bdd0,0xc(%esp)
c01090e4:	c0 
c01090e5:	c7 44 24 08 0b be 10 	movl   $0xc010be0b,0x8(%esp)
c01090ec:	c0 
c01090ed:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c01090f4:	00 
c01090f5:	c7 04 24 20 be 10 c0 	movl   $0xc010be20,(%esp)
c01090fc:	e8 f7 7b ff ff       	call   c0100cf8 <__panic>
    proc->state = PROC_RUNNABLE;
c0109101:	8b 45 08             	mov    0x8(%ebp),%eax
c0109104:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c010910a:	c9                   	leave  
c010910b:	c3                   	ret    

c010910c <schedule>:

void
schedule(void) {
c010910c:	55                   	push   %ebp
c010910d:	89 e5                	mov    %esp,%ebp
c010910f:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0109112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0109119:	e8 68 ff ff ff       	call   c0109086 <__intr_save>
c010911e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0109121:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109126:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010912d:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0109133:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109138:	39 c2                	cmp    %eax,%edx
c010913a:	74 0a                	je     c0109146 <schedule+0x3a>
c010913c:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109141:	83 c0 58             	add    $0x58,%eax
c0109144:	eb 05                	jmp    c010914b <schedule+0x3f>
c0109146:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c010914b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010914e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109151:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109154:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010915a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010915d:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109160:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109163:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c010916a:	74 15                	je     c0109181 <schedule+0x75>
                next = le2proc(le, list_link);
c010916c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010916f:	83 e8 58             	sub    $0x58,%eax
c0109172:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0109175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109178:	8b 00                	mov    (%eax),%eax
c010917a:	83 f8 02             	cmp    $0x2,%eax
c010917d:	75 02                	jne    c0109181 <schedule+0x75>
                    break;
c010917f:	eb 08                	jmp    c0109189 <schedule+0x7d>
                }
            }
        } while (le != last);
c0109181:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109184:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0109187:	75 cb                	jne    c0109154 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c0109189:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010918d:	74 0a                	je     c0109199 <schedule+0x8d>
c010918f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109192:	8b 00                	mov    (%eax),%eax
c0109194:	83 f8 02             	cmp    $0x2,%eax
c0109197:	74 08                	je     c01091a1 <schedule+0x95>
            next = idleproc;
c0109199:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c010919e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c01091a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091a4:	8b 40 08             	mov    0x8(%eax),%eax
c01091a7:	8d 50 01             	lea    0x1(%eax),%edx
c01091aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091ad:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c01091b0:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01091b5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01091b8:	74 0b                	je     c01091c5 <schedule+0xb9>
            proc_run(next);
c01091ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091bd:	89 04 24             	mov    %eax,(%esp)
c01091c0:	e8 9e f7 ff ff       	call   c0108963 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c01091c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01091c8:	89 04 24             	mov    %eax,(%esp)
c01091cb:	e8 e0 fe ff ff       	call   c01090b0 <__intr_restore>
}
c01091d0:	c9                   	leave  
c01091d1:	c3                   	ret    

c01091d2 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c01091d2:	55                   	push   %ebp
c01091d3:	89 e5                	mov    %esp,%ebp
c01091d5:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c01091d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01091db:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c01091e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c01091e4:	b8 20 00 00 00       	mov    $0x20,%eax
c01091e9:	2b 45 0c             	sub    0xc(%ebp),%eax
c01091ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01091ef:	89 c1                	mov    %eax,%ecx
c01091f1:	d3 ea                	shr    %cl,%edx
c01091f3:	89 d0                	mov    %edx,%eax
}
c01091f5:	c9                   	leave  
c01091f6:	c3                   	ret    

c01091f7 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01091f7:	55                   	push   %ebp
c01091f8:	89 e5                	mov    %esp,%ebp
c01091fa:	83 ec 58             	sub    $0x58,%esp
c01091fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0109200:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109203:	8b 45 14             	mov    0x14(%ebp),%eax
c0109206:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0109209:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010920c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010920f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109212:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0109215:	8b 45 18             	mov    0x18(%ebp),%eax
c0109218:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010921b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010921e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109221:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109224:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109227:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010922a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010922d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109231:	74 1c                	je     c010924f <printnum+0x58>
c0109233:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109236:	ba 00 00 00 00       	mov    $0x0,%edx
c010923b:	f7 75 e4             	divl   -0x1c(%ebp)
c010923e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109241:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109244:	ba 00 00 00 00       	mov    $0x0,%edx
c0109249:	f7 75 e4             	divl   -0x1c(%ebp)
c010924c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010924f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109252:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109255:	f7 75 e4             	divl   -0x1c(%ebp)
c0109258:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010925b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010925e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109261:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109264:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109267:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010926a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010926d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109270:	8b 45 18             	mov    0x18(%ebp),%eax
c0109273:	ba 00 00 00 00       	mov    $0x0,%edx
c0109278:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010927b:	77 56                	ja     c01092d3 <printnum+0xdc>
c010927d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109280:	72 05                	jb     c0109287 <printnum+0x90>
c0109282:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0109285:	77 4c                	ja     c01092d3 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0109287:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010928a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010928d:	8b 45 20             	mov    0x20(%ebp),%eax
c0109290:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109294:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109298:	8b 45 18             	mov    0x18(%ebp),%eax
c010929b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010929f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01092a5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01092a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01092ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01092b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01092b7:	89 04 24             	mov    %eax,(%esp)
c01092ba:	e8 38 ff ff ff       	call   c01091f7 <printnum>
c01092bf:	eb 1c                	jmp    c01092dd <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01092c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01092c8:	8b 45 20             	mov    0x20(%ebp),%eax
c01092cb:	89 04 24             	mov    %eax,(%esp)
c01092ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01092d1:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01092d3:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01092d7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01092db:	7f e4                	jg     c01092c1 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01092dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01092e0:	05 b8 be 10 c0       	add    $0xc010beb8,%eax
c01092e5:	0f b6 00             	movzbl (%eax),%eax
c01092e8:	0f be c0             	movsbl %al,%eax
c01092eb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01092ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01092f2:	89 04 24             	mov    %eax,(%esp)
c01092f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01092f8:	ff d0                	call   *%eax
}
c01092fa:	c9                   	leave  
c01092fb:	c3                   	ret    

c01092fc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01092fc:	55                   	push   %ebp
c01092fd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01092ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109303:	7e 14                	jle    c0109319 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0109305:	8b 45 08             	mov    0x8(%ebp),%eax
c0109308:	8b 00                	mov    (%eax),%eax
c010930a:	8d 48 08             	lea    0x8(%eax),%ecx
c010930d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109310:	89 0a                	mov    %ecx,(%edx)
c0109312:	8b 50 04             	mov    0x4(%eax),%edx
c0109315:	8b 00                	mov    (%eax),%eax
c0109317:	eb 30                	jmp    c0109349 <getuint+0x4d>
    }
    else if (lflag) {
c0109319:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010931d:	74 16                	je     c0109335 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010931f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109322:	8b 00                	mov    (%eax),%eax
c0109324:	8d 48 04             	lea    0x4(%eax),%ecx
c0109327:	8b 55 08             	mov    0x8(%ebp),%edx
c010932a:	89 0a                	mov    %ecx,(%edx)
c010932c:	8b 00                	mov    (%eax),%eax
c010932e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109333:	eb 14                	jmp    c0109349 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0109335:	8b 45 08             	mov    0x8(%ebp),%eax
c0109338:	8b 00                	mov    (%eax),%eax
c010933a:	8d 48 04             	lea    0x4(%eax),%ecx
c010933d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109340:	89 0a                	mov    %ecx,(%edx)
c0109342:	8b 00                	mov    (%eax),%eax
c0109344:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0109349:	5d                   	pop    %ebp
c010934a:	c3                   	ret    

c010934b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010934b:	55                   	push   %ebp
c010934c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010934e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109352:	7e 14                	jle    c0109368 <getint+0x1d>
        return va_arg(*ap, long long);
c0109354:	8b 45 08             	mov    0x8(%ebp),%eax
c0109357:	8b 00                	mov    (%eax),%eax
c0109359:	8d 48 08             	lea    0x8(%eax),%ecx
c010935c:	8b 55 08             	mov    0x8(%ebp),%edx
c010935f:	89 0a                	mov    %ecx,(%edx)
c0109361:	8b 50 04             	mov    0x4(%eax),%edx
c0109364:	8b 00                	mov    (%eax),%eax
c0109366:	eb 28                	jmp    c0109390 <getint+0x45>
    }
    else if (lflag) {
c0109368:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010936c:	74 12                	je     c0109380 <getint+0x35>
        return va_arg(*ap, long);
c010936e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109371:	8b 00                	mov    (%eax),%eax
c0109373:	8d 48 04             	lea    0x4(%eax),%ecx
c0109376:	8b 55 08             	mov    0x8(%ebp),%edx
c0109379:	89 0a                	mov    %ecx,(%edx)
c010937b:	8b 00                	mov    (%eax),%eax
c010937d:	99                   	cltd   
c010937e:	eb 10                	jmp    c0109390 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109380:	8b 45 08             	mov    0x8(%ebp),%eax
c0109383:	8b 00                	mov    (%eax),%eax
c0109385:	8d 48 04             	lea    0x4(%eax),%ecx
c0109388:	8b 55 08             	mov    0x8(%ebp),%edx
c010938b:	89 0a                	mov    %ecx,(%edx)
c010938d:	8b 00                	mov    (%eax),%eax
c010938f:	99                   	cltd   
    }
}
c0109390:	5d                   	pop    %ebp
c0109391:	c3                   	ret    

c0109392 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109392:	55                   	push   %ebp
c0109393:	89 e5                	mov    %esp,%ebp
c0109395:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0109398:	8d 45 14             	lea    0x14(%ebp),%eax
c010939b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010939e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01093a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01093a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01093ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b6:	89 04 24             	mov    %eax,(%esp)
c01093b9:	e8 02 00 00 00       	call   c01093c0 <vprintfmt>
    va_end(ap);
}
c01093be:	c9                   	leave  
c01093bf:	c3                   	ret    

c01093c0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01093c0:	55                   	push   %ebp
c01093c1:	89 e5                	mov    %esp,%ebp
c01093c3:	56                   	push   %esi
c01093c4:	53                   	push   %ebx
c01093c5:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01093c8:	eb 18                	jmp    c01093e2 <vprintfmt+0x22>
            if (ch == '\0') {
c01093ca:	85 db                	test   %ebx,%ebx
c01093cc:	75 05                	jne    c01093d3 <vprintfmt+0x13>
                return;
c01093ce:	e9 d1 03 00 00       	jmp    c01097a4 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01093d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093da:	89 1c 24             	mov    %ebx,(%esp)
c01093dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01093e0:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01093e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01093e5:	8d 50 01             	lea    0x1(%eax),%edx
c01093e8:	89 55 10             	mov    %edx,0x10(%ebp)
c01093eb:	0f b6 00             	movzbl (%eax),%eax
c01093ee:	0f b6 d8             	movzbl %al,%ebx
c01093f1:	83 fb 25             	cmp    $0x25,%ebx
c01093f4:	75 d4                	jne    c01093ca <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01093f6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01093fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109404:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0109407:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010940e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109411:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109414:	8b 45 10             	mov    0x10(%ebp),%eax
c0109417:	8d 50 01             	lea    0x1(%eax),%edx
c010941a:	89 55 10             	mov    %edx,0x10(%ebp)
c010941d:	0f b6 00             	movzbl (%eax),%eax
c0109420:	0f b6 d8             	movzbl %al,%ebx
c0109423:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0109426:	83 f8 55             	cmp    $0x55,%eax
c0109429:	0f 87 44 03 00 00    	ja     c0109773 <vprintfmt+0x3b3>
c010942f:	8b 04 85 dc be 10 c0 	mov    -0x3fef4124(,%eax,4),%eax
c0109436:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109438:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010943c:	eb d6                	jmp    c0109414 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010943e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0109442:	eb d0                	jmp    c0109414 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109444:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010944b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010944e:	89 d0                	mov    %edx,%eax
c0109450:	c1 e0 02             	shl    $0x2,%eax
c0109453:	01 d0                	add    %edx,%eax
c0109455:	01 c0                	add    %eax,%eax
c0109457:	01 d8                	add    %ebx,%eax
c0109459:	83 e8 30             	sub    $0x30,%eax
c010945c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010945f:	8b 45 10             	mov    0x10(%ebp),%eax
c0109462:	0f b6 00             	movzbl (%eax),%eax
c0109465:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109468:	83 fb 2f             	cmp    $0x2f,%ebx
c010946b:	7e 0b                	jle    c0109478 <vprintfmt+0xb8>
c010946d:	83 fb 39             	cmp    $0x39,%ebx
c0109470:	7f 06                	jg     c0109478 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109472:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0109476:	eb d3                	jmp    c010944b <vprintfmt+0x8b>
            goto process_precision;
c0109478:	eb 33                	jmp    c01094ad <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010947a:	8b 45 14             	mov    0x14(%ebp),%eax
c010947d:	8d 50 04             	lea    0x4(%eax),%edx
c0109480:	89 55 14             	mov    %edx,0x14(%ebp)
c0109483:	8b 00                	mov    (%eax),%eax
c0109485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0109488:	eb 23                	jmp    c01094ad <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010948a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010948e:	79 0c                	jns    c010949c <vprintfmt+0xdc>
                width = 0;
c0109490:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109497:	e9 78 ff ff ff       	jmp    c0109414 <vprintfmt+0x54>
c010949c:	e9 73 ff ff ff       	jmp    c0109414 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01094a1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01094a8:	e9 67 ff ff ff       	jmp    c0109414 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01094ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01094b1:	79 12                	jns    c01094c5 <vprintfmt+0x105>
                width = precision, precision = -1;
c01094b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01094b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01094b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01094c0:	e9 4f ff ff ff       	jmp    c0109414 <vprintfmt+0x54>
c01094c5:	e9 4a ff ff ff       	jmp    c0109414 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01094ca:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01094ce:	e9 41 ff ff ff       	jmp    c0109414 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01094d3:	8b 45 14             	mov    0x14(%ebp),%eax
c01094d6:	8d 50 04             	lea    0x4(%eax),%edx
c01094d9:	89 55 14             	mov    %edx,0x14(%ebp)
c01094dc:	8b 00                	mov    (%eax),%eax
c01094de:	8b 55 0c             	mov    0xc(%ebp),%edx
c01094e1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01094e5:	89 04 24             	mov    %eax,(%esp)
c01094e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01094eb:	ff d0                	call   *%eax
            break;
c01094ed:	e9 ac 02 00 00       	jmp    c010979e <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01094f2:	8b 45 14             	mov    0x14(%ebp),%eax
c01094f5:	8d 50 04             	lea    0x4(%eax),%edx
c01094f8:	89 55 14             	mov    %edx,0x14(%ebp)
c01094fb:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01094fd:	85 db                	test   %ebx,%ebx
c01094ff:	79 02                	jns    c0109503 <vprintfmt+0x143>
                err = -err;
c0109501:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109503:	83 fb 06             	cmp    $0x6,%ebx
c0109506:	7f 0b                	jg     c0109513 <vprintfmt+0x153>
c0109508:	8b 34 9d 9c be 10 c0 	mov    -0x3fef4164(,%ebx,4),%esi
c010950f:	85 f6                	test   %esi,%esi
c0109511:	75 23                	jne    c0109536 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0109513:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109517:	c7 44 24 08 c9 be 10 	movl   $0xc010bec9,0x8(%esp)
c010951e:	c0 
c010951f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109522:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109526:	8b 45 08             	mov    0x8(%ebp),%eax
c0109529:	89 04 24             	mov    %eax,(%esp)
c010952c:	e8 61 fe ff ff       	call   c0109392 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109531:	e9 68 02 00 00       	jmp    c010979e <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0109536:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010953a:	c7 44 24 08 d2 be 10 	movl   $0xc010bed2,0x8(%esp)
c0109541:	c0 
c0109542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109545:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109549:	8b 45 08             	mov    0x8(%ebp),%eax
c010954c:	89 04 24             	mov    %eax,(%esp)
c010954f:	e8 3e fe ff ff       	call   c0109392 <printfmt>
            }
            break;
c0109554:	e9 45 02 00 00       	jmp    c010979e <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109559:	8b 45 14             	mov    0x14(%ebp),%eax
c010955c:	8d 50 04             	lea    0x4(%eax),%edx
c010955f:	89 55 14             	mov    %edx,0x14(%ebp)
c0109562:	8b 30                	mov    (%eax),%esi
c0109564:	85 f6                	test   %esi,%esi
c0109566:	75 05                	jne    c010956d <vprintfmt+0x1ad>
                p = "(null)";
c0109568:	be d5 be 10 c0       	mov    $0xc010bed5,%esi
            }
            if (width > 0 && padc != '-') {
c010956d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109571:	7e 3e                	jle    c01095b1 <vprintfmt+0x1f1>
c0109573:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109577:	74 38                	je     c01095b1 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109579:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010957c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010957f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109583:	89 34 24             	mov    %esi,(%esp)
c0109586:	e8 ed 03 00 00       	call   c0109978 <strnlen>
c010958b:	29 c3                	sub    %eax,%ebx
c010958d:	89 d8                	mov    %ebx,%eax
c010958f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109592:	eb 17                	jmp    c01095ab <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0109594:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109598:	8b 55 0c             	mov    0xc(%ebp),%edx
c010959b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010959f:	89 04 24             	mov    %eax,(%esp)
c01095a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a5:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01095a7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01095ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01095af:	7f e3                	jg     c0109594 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01095b1:	eb 38                	jmp    c01095eb <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01095b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01095b7:	74 1f                	je     c01095d8 <vprintfmt+0x218>
c01095b9:	83 fb 1f             	cmp    $0x1f,%ebx
c01095bc:	7e 05                	jle    c01095c3 <vprintfmt+0x203>
c01095be:	83 fb 7e             	cmp    $0x7e,%ebx
c01095c1:	7e 15                	jle    c01095d8 <vprintfmt+0x218>
                    putch('?', putdat);
c01095c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095ca:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01095d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01095d4:	ff d0                	call   *%eax
c01095d6:	eb 0f                	jmp    c01095e7 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01095d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095df:	89 1c 24             	mov    %ebx,(%esp)
c01095e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e5:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01095e7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01095eb:	89 f0                	mov    %esi,%eax
c01095ed:	8d 70 01             	lea    0x1(%eax),%esi
c01095f0:	0f b6 00             	movzbl (%eax),%eax
c01095f3:	0f be d8             	movsbl %al,%ebx
c01095f6:	85 db                	test   %ebx,%ebx
c01095f8:	74 10                	je     c010960a <vprintfmt+0x24a>
c01095fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01095fe:	78 b3                	js     c01095b3 <vprintfmt+0x1f3>
c0109600:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109604:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109608:	79 a9                	jns    c01095b3 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010960a:	eb 17                	jmp    c0109623 <vprintfmt+0x263>
                putch(' ', putdat);
c010960c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010960f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109613:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010961a:	8b 45 08             	mov    0x8(%ebp),%eax
c010961d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010961f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109623:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109627:	7f e3                	jg     c010960c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0109629:	e9 70 01 00 00       	jmp    c010979e <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010962e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109631:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109635:	8d 45 14             	lea    0x14(%ebp),%eax
c0109638:	89 04 24             	mov    %eax,(%esp)
c010963b:	e8 0b fd ff ff       	call   c010934b <getint>
c0109640:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109643:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109646:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109649:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010964c:	85 d2                	test   %edx,%edx
c010964e:	79 26                	jns    c0109676 <vprintfmt+0x2b6>
                putch('-', putdat);
c0109650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109653:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109657:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010965e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109661:	ff d0                	call   *%eax
                num = -(long long)num;
c0109663:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109666:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109669:	f7 d8                	neg    %eax
c010966b:	83 d2 00             	adc    $0x0,%edx
c010966e:	f7 da                	neg    %edx
c0109670:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109673:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109676:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010967d:	e9 a8 00 00 00       	jmp    c010972a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109682:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109685:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109689:	8d 45 14             	lea    0x14(%ebp),%eax
c010968c:	89 04 24             	mov    %eax,(%esp)
c010968f:	e8 68 fc ff ff       	call   c01092fc <getuint>
c0109694:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109697:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010969a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01096a1:	e9 84 00 00 00       	jmp    c010972a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01096a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01096a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096ad:	8d 45 14             	lea    0x14(%ebp),%eax
c01096b0:	89 04 24             	mov    %eax,(%esp)
c01096b3:	e8 44 fc ff ff       	call   c01092fc <getuint>
c01096b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01096be:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01096c5:	eb 63                	jmp    c010972a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01096c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096ce:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01096d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01096d8:	ff d0                	call   *%eax
            putch('x', putdat);
c01096da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096e1:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01096e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01096eb:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01096ed:	8b 45 14             	mov    0x14(%ebp),%eax
c01096f0:	8d 50 04             	lea    0x4(%eax),%edx
c01096f3:	89 55 14             	mov    %edx,0x14(%ebp)
c01096f6:	8b 00                	mov    (%eax),%eax
c01096f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109702:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109709:	eb 1f                	jmp    c010972a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010970b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010970e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109712:	8d 45 14             	lea    0x14(%ebp),%eax
c0109715:	89 04 24             	mov    %eax,(%esp)
c0109718:	e8 df fb ff ff       	call   c01092fc <getuint>
c010971d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109720:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109723:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010972a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010972e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109731:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109735:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109738:	89 54 24 14          	mov    %edx,0x14(%esp)
c010973c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109740:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109743:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109746:	89 44 24 08          	mov    %eax,0x8(%esp)
c010974a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010974e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109751:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109755:	8b 45 08             	mov    0x8(%ebp),%eax
c0109758:	89 04 24             	mov    %eax,(%esp)
c010975b:	e8 97 fa ff ff       	call   c01091f7 <printnum>
            break;
c0109760:	eb 3c                	jmp    c010979e <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109762:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109765:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109769:	89 1c 24             	mov    %ebx,(%esp)
c010976c:	8b 45 08             	mov    0x8(%ebp),%eax
c010976f:	ff d0                	call   *%eax
            break;
c0109771:	eb 2b                	jmp    c010979e <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109773:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109776:	89 44 24 04          	mov    %eax,0x4(%esp)
c010977a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109781:	8b 45 08             	mov    0x8(%ebp),%eax
c0109784:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109786:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010978a:	eb 04                	jmp    c0109790 <vprintfmt+0x3d0>
c010978c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109790:	8b 45 10             	mov    0x10(%ebp),%eax
c0109793:	83 e8 01             	sub    $0x1,%eax
c0109796:	0f b6 00             	movzbl (%eax),%eax
c0109799:	3c 25                	cmp    $0x25,%al
c010979b:	75 ef                	jne    c010978c <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010979d:	90                   	nop
        }
    }
c010979e:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010979f:	e9 3e fc ff ff       	jmp    c01093e2 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01097a4:	83 c4 40             	add    $0x40,%esp
c01097a7:	5b                   	pop    %ebx
c01097a8:	5e                   	pop    %esi
c01097a9:	5d                   	pop    %ebp
c01097aa:	c3                   	ret    

c01097ab <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01097ab:	55                   	push   %ebp
c01097ac:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01097ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097b1:	8b 40 08             	mov    0x8(%eax),%eax
c01097b4:	8d 50 01             	lea    0x1(%eax),%edx
c01097b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097ba:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01097bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097c0:	8b 10                	mov    (%eax),%edx
c01097c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097c5:	8b 40 04             	mov    0x4(%eax),%eax
c01097c8:	39 c2                	cmp    %eax,%edx
c01097ca:	73 12                	jae    c01097de <sprintputch+0x33>
        *b->buf ++ = ch;
c01097cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097cf:	8b 00                	mov    (%eax),%eax
c01097d1:	8d 48 01             	lea    0x1(%eax),%ecx
c01097d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01097d7:	89 0a                	mov    %ecx,(%edx)
c01097d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01097dc:	88 10                	mov    %dl,(%eax)
    }
}
c01097de:	5d                   	pop    %ebp
c01097df:	c3                   	ret    

c01097e0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01097e0:	55                   	push   %ebp
c01097e1:	89 e5                	mov    %esp,%ebp
c01097e3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01097e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01097e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01097ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01097f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01097f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01097fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109801:	8b 45 08             	mov    0x8(%ebp),%eax
c0109804:	89 04 24             	mov    %eax,(%esp)
c0109807:	e8 08 00 00 00       	call   c0109814 <vsnprintf>
c010980c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010980f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109812:	c9                   	leave  
c0109813:	c3                   	ret    

c0109814 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109814:	55                   	push   %ebp
c0109815:	89 e5                	mov    %esp,%ebp
c0109817:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010981a:	8b 45 08             	mov    0x8(%ebp),%eax
c010981d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109820:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109823:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109826:	8b 45 08             	mov    0x8(%ebp),%eax
c0109829:	01 d0                	add    %edx,%eax
c010982b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010982e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109835:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109839:	74 0a                	je     c0109845 <vsnprintf+0x31>
c010983b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010983e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109841:	39 c2                	cmp    %eax,%edx
c0109843:	76 07                	jbe    c010984c <vsnprintf+0x38>
        return -E_INVAL;
c0109845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010984a:	eb 2a                	jmp    c0109876 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010984c:	8b 45 14             	mov    0x14(%ebp),%eax
c010984f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109853:	8b 45 10             	mov    0x10(%ebp),%eax
c0109856:	89 44 24 08          	mov    %eax,0x8(%esp)
c010985a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010985d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109861:	c7 04 24 ab 97 10 c0 	movl   $0xc01097ab,(%esp)
c0109868:	e8 53 fb ff ff       	call   c01093c0 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010986d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109870:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109873:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109876:	c9                   	leave  
c0109877:	c3                   	ret    

c0109878 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109878:	55                   	push   %ebp
c0109879:	89 e5                	mov    %esp,%ebp
c010987b:	57                   	push   %edi
c010987c:	56                   	push   %esi
c010987d:	53                   	push   %ebx
c010987e:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109881:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109886:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c010988c:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109892:	6b f0 05             	imul   $0x5,%eax,%esi
c0109895:	01 f7                	add    %esi,%edi
c0109897:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010989c:	f7 e6                	mul    %esi
c010989e:	8d 34 17             	lea    (%edi,%edx,1),%esi
c01098a1:	89 f2                	mov    %esi,%edx
c01098a3:	83 c0 0b             	add    $0xb,%eax
c01098a6:	83 d2 00             	adc    $0x0,%edx
c01098a9:	89 c7                	mov    %eax,%edi
c01098ab:	83 e7 ff             	and    $0xffffffff,%edi
c01098ae:	89 f9                	mov    %edi,%ecx
c01098b0:	0f b7 da             	movzwl %dx,%ebx
c01098b3:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c01098b9:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c01098bf:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c01098c4:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c01098ca:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01098ce:	c1 ea 0c             	shr    $0xc,%edx
c01098d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01098d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01098d7:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01098de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01098e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01098e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01098e7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01098ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01098ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01098f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01098f4:	74 1c                	je     c0109912 <rand+0x9a>
c01098f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01098f9:	ba 00 00 00 00       	mov    $0x0,%edx
c01098fe:	f7 75 dc             	divl   -0x24(%ebp)
c0109901:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109904:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109907:	ba 00 00 00 00       	mov    $0x0,%edx
c010990c:	f7 75 dc             	divl   -0x24(%ebp)
c010990f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109912:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109915:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109918:	f7 75 dc             	divl   -0x24(%ebp)
c010991b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010991e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109921:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109924:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109927:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010992a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010992d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109930:	83 c4 24             	add    $0x24,%esp
c0109933:	5b                   	pop    %ebx
c0109934:	5e                   	pop    %esi
c0109935:	5f                   	pop    %edi
c0109936:	5d                   	pop    %ebp
c0109937:	c3                   	ret    

c0109938 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109938:	55                   	push   %ebp
c0109939:	89 e5                	mov    %esp,%ebp
    next = seed;
c010993b:	8b 45 08             	mov    0x8(%ebp),%eax
c010993e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109943:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c0109948:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c010994e:	5d                   	pop    %ebp
c010994f:	c3                   	ret    

c0109950 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109950:	55                   	push   %ebp
c0109951:	89 e5                	mov    %esp,%ebp
c0109953:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109956:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010995d:	eb 04                	jmp    c0109963 <strlen+0x13>
        cnt ++;
c010995f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109963:	8b 45 08             	mov    0x8(%ebp),%eax
c0109966:	8d 50 01             	lea    0x1(%eax),%edx
c0109969:	89 55 08             	mov    %edx,0x8(%ebp)
c010996c:	0f b6 00             	movzbl (%eax),%eax
c010996f:	84 c0                	test   %al,%al
c0109971:	75 ec                	jne    c010995f <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109973:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109976:	c9                   	leave  
c0109977:	c3                   	ret    

c0109978 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0109978:	55                   	push   %ebp
c0109979:	89 e5                	mov    %esp,%ebp
c010997b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010997e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109985:	eb 04                	jmp    c010998b <strnlen+0x13>
        cnt ++;
c0109987:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010998b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010998e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109991:	73 10                	jae    c01099a3 <strnlen+0x2b>
c0109993:	8b 45 08             	mov    0x8(%ebp),%eax
c0109996:	8d 50 01             	lea    0x1(%eax),%edx
c0109999:	89 55 08             	mov    %edx,0x8(%ebp)
c010999c:	0f b6 00             	movzbl (%eax),%eax
c010999f:	84 c0                	test   %al,%al
c01099a1:	75 e4                	jne    c0109987 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01099a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01099a6:	c9                   	leave  
c01099a7:	c3                   	ret    

c01099a8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01099a8:	55                   	push   %ebp
c01099a9:	89 e5                	mov    %esp,%ebp
c01099ab:	57                   	push   %edi
c01099ac:	56                   	push   %esi
c01099ad:	83 ec 20             	sub    $0x20,%esp
c01099b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01099b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01099bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01099bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01099c2:	89 d1                	mov    %edx,%ecx
c01099c4:	89 c2                	mov    %eax,%edx
c01099c6:	89 ce                	mov    %ecx,%esi
c01099c8:	89 d7                	mov    %edx,%edi
c01099ca:	ac                   	lods   %ds:(%esi),%al
c01099cb:	aa                   	stos   %al,%es:(%edi)
c01099cc:	84 c0                	test   %al,%al
c01099ce:	75 fa                	jne    c01099ca <strcpy+0x22>
c01099d0:	89 fa                	mov    %edi,%edx
c01099d2:	89 f1                	mov    %esi,%ecx
c01099d4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01099d7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01099da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01099dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01099e0:	83 c4 20             	add    $0x20,%esp
c01099e3:	5e                   	pop    %esi
c01099e4:	5f                   	pop    %edi
c01099e5:	5d                   	pop    %ebp
c01099e6:	c3                   	ret    

c01099e7 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01099e7:	55                   	push   %ebp
c01099e8:	89 e5                	mov    %esp,%ebp
c01099ea:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01099ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01099f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01099f3:	eb 21                	jmp    c0109a16 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01099f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099f8:	0f b6 10             	movzbl (%eax),%edx
c01099fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01099fe:	88 10                	mov    %dl,(%eax)
c0109a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109a03:	0f b6 00             	movzbl (%eax),%eax
c0109a06:	84 c0                	test   %al,%al
c0109a08:	74 04                	je     c0109a0e <strncpy+0x27>
            src ++;
c0109a0a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109a0e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109a12:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0109a16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a1a:	75 d9                	jne    c01099f5 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109a1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109a1f:	c9                   	leave  
c0109a20:	c3                   	ret    

c0109a21 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109a21:	55                   	push   %ebp
c0109a22:	89 e5                	mov    %esp,%ebp
c0109a24:	57                   	push   %edi
c0109a25:	56                   	push   %esi
c0109a26:	83 ec 20             	sub    $0x20,%esp
c0109a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0109a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a3b:	89 d1                	mov    %edx,%ecx
c0109a3d:	89 c2                	mov    %eax,%edx
c0109a3f:	89 ce                	mov    %ecx,%esi
c0109a41:	89 d7                	mov    %edx,%edi
c0109a43:	ac                   	lods   %ds:(%esi),%al
c0109a44:	ae                   	scas   %es:(%edi),%al
c0109a45:	75 08                	jne    c0109a4f <strcmp+0x2e>
c0109a47:	84 c0                	test   %al,%al
c0109a49:	75 f8                	jne    c0109a43 <strcmp+0x22>
c0109a4b:	31 c0                	xor    %eax,%eax
c0109a4d:	eb 04                	jmp    c0109a53 <strcmp+0x32>
c0109a4f:	19 c0                	sbb    %eax,%eax
c0109a51:	0c 01                	or     $0x1,%al
c0109a53:	89 fa                	mov    %edi,%edx
c0109a55:	89 f1                	mov    %esi,%ecx
c0109a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a5a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109a5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109a63:	83 c4 20             	add    $0x20,%esp
c0109a66:	5e                   	pop    %esi
c0109a67:	5f                   	pop    %edi
c0109a68:	5d                   	pop    %ebp
c0109a69:	c3                   	ret    

c0109a6a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0109a6a:	55                   	push   %ebp
c0109a6b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109a6d:	eb 0c                	jmp    c0109a7b <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109a6f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109a73:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a77:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109a7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a7f:	74 1a                	je     c0109a9b <strncmp+0x31>
c0109a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a84:	0f b6 00             	movzbl (%eax),%eax
c0109a87:	84 c0                	test   %al,%al
c0109a89:	74 10                	je     c0109a9b <strncmp+0x31>
c0109a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a8e:	0f b6 10             	movzbl (%eax),%edx
c0109a91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a94:	0f b6 00             	movzbl (%eax),%eax
c0109a97:	38 c2                	cmp    %al,%dl
c0109a99:	74 d4                	je     c0109a6f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109a9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a9f:	74 18                	je     c0109ab9 <strncmp+0x4f>
c0109aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aa4:	0f b6 00             	movzbl (%eax),%eax
c0109aa7:	0f b6 d0             	movzbl %al,%edx
c0109aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109aad:	0f b6 00             	movzbl (%eax),%eax
c0109ab0:	0f b6 c0             	movzbl %al,%eax
c0109ab3:	29 c2                	sub    %eax,%edx
c0109ab5:	89 d0                	mov    %edx,%eax
c0109ab7:	eb 05                	jmp    c0109abe <strncmp+0x54>
c0109ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109abe:	5d                   	pop    %ebp
c0109abf:	c3                   	ret    

c0109ac0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109ac0:	55                   	push   %ebp
c0109ac1:	89 e5                	mov    %esp,%ebp
c0109ac3:	83 ec 04             	sub    $0x4,%esp
c0109ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ac9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109acc:	eb 14                	jmp    c0109ae2 <strchr+0x22>
        if (*s == c) {
c0109ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ad1:	0f b6 00             	movzbl (%eax),%eax
c0109ad4:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109ad7:	75 05                	jne    c0109ade <strchr+0x1e>
            return (char *)s;
c0109ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109adc:	eb 13                	jmp    c0109af1 <strchr+0x31>
        }
        s ++;
c0109ade:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae5:	0f b6 00             	movzbl (%eax),%eax
c0109ae8:	84 c0                	test   %al,%al
c0109aea:	75 e2                	jne    c0109ace <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0109aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109af1:	c9                   	leave  
c0109af2:	c3                   	ret    

c0109af3 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109af3:	55                   	push   %ebp
c0109af4:	89 e5                	mov    %esp,%ebp
c0109af6:	83 ec 04             	sub    $0x4,%esp
c0109af9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109afc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109aff:	eb 11                	jmp    c0109b12 <strfind+0x1f>
        if (*s == c) {
c0109b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b04:	0f b6 00             	movzbl (%eax),%eax
c0109b07:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109b0a:	75 02                	jne    c0109b0e <strfind+0x1b>
            break;
c0109b0c:	eb 0e                	jmp    c0109b1c <strfind+0x29>
        }
        s ++;
c0109b0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b15:	0f b6 00             	movzbl (%eax),%eax
c0109b18:	84 c0                	test   %al,%al
c0109b1a:	75 e5                	jne    c0109b01 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0109b1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109b1f:	c9                   	leave  
c0109b20:	c3                   	ret    

c0109b21 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109b21:	55                   	push   %ebp
c0109b22:	89 e5                	mov    %esp,%ebp
c0109b24:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109b27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109b2e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109b35:	eb 04                	jmp    c0109b3b <strtol+0x1a>
        s ++;
c0109b37:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b3e:	0f b6 00             	movzbl (%eax),%eax
c0109b41:	3c 20                	cmp    $0x20,%al
c0109b43:	74 f2                	je     c0109b37 <strtol+0x16>
c0109b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b48:	0f b6 00             	movzbl (%eax),%eax
c0109b4b:	3c 09                	cmp    $0x9,%al
c0109b4d:	74 e8                	je     c0109b37 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b52:	0f b6 00             	movzbl (%eax),%eax
c0109b55:	3c 2b                	cmp    $0x2b,%al
c0109b57:	75 06                	jne    c0109b5f <strtol+0x3e>
        s ++;
c0109b59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109b5d:	eb 15                	jmp    c0109b74 <strtol+0x53>
    }
    else if (*s == '-') {
c0109b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b62:	0f b6 00             	movzbl (%eax),%eax
c0109b65:	3c 2d                	cmp    $0x2d,%al
c0109b67:	75 0b                	jne    c0109b74 <strtol+0x53>
        s ++, neg = 1;
c0109b69:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109b6d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109b74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109b78:	74 06                	je     c0109b80 <strtol+0x5f>
c0109b7a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109b7e:	75 24                	jne    c0109ba4 <strtol+0x83>
c0109b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b83:	0f b6 00             	movzbl (%eax),%eax
c0109b86:	3c 30                	cmp    $0x30,%al
c0109b88:	75 1a                	jne    c0109ba4 <strtol+0x83>
c0109b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b8d:	83 c0 01             	add    $0x1,%eax
c0109b90:	0f b6 00             	movzbl (%eax),%eax
c0109b93:	3c 78                	cmp    $0x78,%al
c0109b95:	75 0d                	jne    c0109ba4 <strtol+0x83>
        s += 2, base = 16;
c0109b97:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109b9b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109ba2:	eb 2a                	jmp    c0109bce <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109ba8:	75 17                	jne    c0109bc1 <strtol+0xa0>
c0109baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bad:	0f b6 00             	movzbl (%eax),%eax
c0109bb0:	3c 30                	cmp    $0x30,%al
c0109bb2:	75 0d                	jne    c0109bc1 <strtol+0xa0>
        s ++, base = 8;
c0109bb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109bb8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109bbf:	eb 0d                	jmp    c0109bce <strtol+0xad>
    }
    else if (base == 0) {
c0109bc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109bc5:	75 07                	jne    c0109bce <strtol+0xad>
        base = 10;
c0109bc7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bd1:	0f b6 00             	movzbl (%eax),%eax
c0109bd4:	3c 2f                	cmp    $0x2f,%al
c0109bd6:	7e 1b                	jle    c0109bf3 <strtol+0xd2>
c0109bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bdb:	0f b6 00             	movzbl (%eax),%eax
c0109bde:	3c 39                	cmp    $0x39,%al
c0109be0:	7f 11                	jg     c0109bf3 <strtol+0xd2>
            dig = *s - '0';
c0109be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109be5:	0f b6 00             	movzbl (%eax),%eax
c0109be8:	0f be c0             	movsbl %al,%eax
c0109beb:	83 e8 30             	sub    $0x30,%eax
c0109bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109bf1:	eb 48                	jmp    c0109c3b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bf6:	0f b6 00             	movzbl (%eax),%eax
c0109bf9:	3c 60                	cmp    $0x60,%al
c0109bfb:	7e 1b                	jle    c0109c18 <strtol+0xf7>
c0109bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c00:	0f b6 00             	movzbl (%eax),%eax
c0109c03:	3c 7a                	cmp    $0x7a,%al
c0109c05:	7f 11                	jg     c0109c18 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c0a:	0f b6 00             	movzbl (%eax),%eax
c0109c0d:	0f be c0             	movsbl %al,%eax
c0109c10:	83 e8 57             	sub    $0x57,%eax
c0109c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109c16:	eb 23                	jmp    c0109c3b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c1b:	0f b6 00             	movzbl (%eax),%eax
c0109c1e:	3c 40                	cmp    $0x40,%al
c0109c20:	7e 3d                	jle    c0109c5f <strtol+0x13e>
c0109c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c25:	0f b6 00             	movzbl (%eax),%eax
c0109c28:	3c 5a                	cmp    $0x5a,%al
c0109c2a:	7f 33                	jg     c0109c5f <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109c2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c2f:	0f b6 00             	movzbl (%eax),%eax
c0109c32:	0f be c0             	movsbl %al,%eax
c0109c35:	83 e8 37             	sub    $0x37,%eax
c0109c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109c3e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109c41:	7c 02                	jl     c0109c45 <strtol+0x124>
            break;
c0109c43:	eb 1a                	jmp    c0109c5f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109c45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109c49:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c4c:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109c50:	89 c2                	mov    %eax,%edx
c0109c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109c55:	01 d0                	add    %edx,%eax
c0109c57:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109c5a:	e9 6f ff ff ff       	jmp    c0109bce <strtol+0xad>

    if (endptr) {
c0109c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109c63:	74 08                	je     c0109c6d <strtol+0x14c>
        *endptr = (char *) s;
c0109c65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c68:	8b 55 08             	mov    0x8(%ebp),%edx
c0109c6b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109c71:	74 07                	je     c0109c7a <strtol+0x159>
c0109c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c76:	f7 d8                	neg    %eax
c0109c78:	eb 03                	jmp    c0109c7d <strtol+0x15c>
c0109c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109c7d:	c9                   	leave  
c0109c7e:	c3                   	ret    

c0109c7f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109c7f:	55                   	push   %ebp
c0109c80:	89 e5                	mov    %esp,%ebp
c0109c82:	57                   	push   %edi
c0109c83:	83 ec 24             	sub    $0x24,%esp
c0109c86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c89:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109c8c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109c90:	8b 55 08             	mov    0x8(%ebp),%edx
c0109c93:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109c96:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109c99:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109c9f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109ca2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109ca6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109ca9:	89 d7                	mov    %edx,%edi
c0109cab:	f3 aa                	rep stos %al,%es:(%edi)
c0109cad:	89 fa                	mov    %edi,%edx
c0109caf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109cb2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109cb8:	83 c4 24             	add    $0x24,%esp
c0109cbb:	5f                   	pop    %edi
c0109cbc:	5d                   	pop    %ebp
c0109cbd:	c3                   	ret    

c0109cbe <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109cbe:	55                   	push   %ebp
c0109cbf:	89 e5                	mov    %esp,%ebp
c0109cc1:	57                   	push   %edi
c0109cc2:	56                   	push   %esi
c0109cc3:	53                   	push   %ebx
c0109cc4:	83 ec 30             	sub    $0x30,%esp
c0109cc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109cd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0109cd6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cdc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109cdf:	73 42                	jae    c0109d23 <memmove+0x65>
c0109ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ce4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109cea:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109cf0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109cf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109cf6:	c1 e8 02             	shr    $0x2,%eax
c0109cf9:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109cfb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109cfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109d01:	89 d7                	mov    %edx,%edi
c0109d03:	89 c6                	mov    %eax,%esi
c0109d05:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109d07:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109d0a:	83 e1 03             	and    $0x3,%ecx
c0109d0d:	74 02                	je     c0109d11 <memmove+0x53>
c0109d0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109d11:	89 f0                	mov    %esi,%eax
c0109d13:	89 fa                	mov    %edi,%edx
c0109d15:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109d18:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109d1b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109d1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109d21:	eb 36                	jmp    c0109d59 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d26:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d2c:	01 c2                	add    %eax,%edx
c0109d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d31:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d37:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109d3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d3d:	89 c1                	mov    %eax,%ecx
c0109d3f:	89 d8                	mov    %ebx,%eax
c0109d41:	89 d6                	mov    %edx,%esi
c0109d43:	89 c7                	mov    %eax,%edi
c0109d45:	fd                   	std    
c0109d46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109d48:	fc                   	cld    
c0109d49:	89 f8                	mov    %edi,%eax
c0109d4b:	89 f2                	mov    %esi,%edx
c0109d4d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109d50:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109d53:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109d59:	83 c4 30             	add    $0x30,%esp
c0109d5c:	5b                   	pop    %ebx
c0109d5d:	5e                   	pop    %esi
c0109d5e:	5f                   	pop    %edi
c0109d5f:	5d                   	pop    %ebp
c0109d60:	c3                   	ret    

c0109d61 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109d61:	55                   	push   %ebp
c0109d62:	89 e5                	mov    %esp,%ebp
c0109d64:	57                   	push   %edi
c0109d65:	56                   	push   %esi
c0109d66:	83 ec 20             	sub    $0x20,%esp
c0109d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109d75:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d7e:	c1 e8 02             	shr    $0x2,%eax
c0109d81:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d89:	89 d7                	mov    %edx,%edi
c0109d8b:	89 c6                	mov    %eax,%esi
c0109d8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109d8f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109d92:	83 e1 03             	and    $0x3,%ecx
c0109d95:	74 02                	je     c0109d99 <memcpy+0x38>
c0109d97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109d99:	89 f0                	mov    %esi,%eax
c0109d9b:	89 fa                	mov    %edi,%edx
c0109d9d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109da0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109da3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109da9:	83 c4 20             	add    $0x20,%esp
c0109dac:	5e                   	pop    %esi
c0109dad:	5f                   	pop    %edi
c0109dae:	5d                   	pop    %ebp
c0109daf:	c3                   	ret    

c0109db0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109db0:	55                   	push   %ebp
c0109db1:	89 e5                	mov    %esp,%ebp
c0109db3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0109db9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109dbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109dc2:	eb 30                	jmp    c0109df4 <memcmp+0x44>
        if (*s1 != *s2) {
c0109dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109dc7:	0f b6 10             	movzbl (%eax),%edx
c0109dca:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109dcd:	0f b6 00             	movzbl (%eax),%eax
c0109dd0:	38 c2                	cmp    %al,%dl
c0109dd2:	74 18                	je     c0109dec <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109dd7:	0f b6 00             	movzbl (%eax),%eax
c0109dda:	0f b6 d0             	movzbl %al,%edx
c0109ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109de0:	0f b6 00             	movzbl (%eax),%eax
c0109de3:	0f b6 c0             	movzbl %al,%eax
c0109de6:	29 c2                	sub    %eax,%edx
c0109de8:	89 d0                	mov    %edx,%eax
c0109dea:	eb 1a                	jmp    c0109e06 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109dec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109df0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109df4:	8b 45 10             	mov    0x10(%ebp),%eax
c0109df7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109dfa:	89 55 10             	mov    %edx,0x10(%ebp)
c0109dfd:	85 c0                	test   %eax,%eax
c0109dff:	75 c3                	jne    c0109dc4 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109e06:	c9                   	leave  
c0109e07:	c3                   	ret    
