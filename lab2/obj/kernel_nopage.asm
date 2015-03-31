
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 35 5e 00 00       	call   105e8b <memset>

    cons_init();                // init the console
  100056:	e8 8c 15 00 00       	call   1015e7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 20 60 10 00 	movl   $0x106020,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 3c 60 10 00 	movl   $0x10603c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 0e 43 00 00       	call   104392 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 c7 16 00 00       	call   101750 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 3f 18 00 00       	call   1018cd <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 0a 0d 00 00       	call   100d9d <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 26 16 00 00       	call   1016be <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 13 0c 00 00       	call   100ccf <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 41 60 10 00 	movl   $0x106041,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 5d 60 10 00 	movl   $0x10605d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 6b 60 10 00 	movl   $0x10606b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 79 60 10 00 	movl   $0x106079,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 88 60 10 00 	movl   $0x106088,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 a8 60 10 00 	movl   $0x1060a8,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 c7 60 10 00 	movl   $0x1060c7,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 19 13 00 00       	call   101613 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 6d 53 00 00       	call   1056a4 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 a0 12 00 00       	call   101613 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 80 12 00 00       	call   10164f <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 cc 60 10 00    	movl   $0x1060cc,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 cc 60 10 00 	movl   $0x1060cc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 40 73 10 00 	movl   $0x107340,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 fc 1f 11 00 	movl   $0x111ffc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec fd 1f 11 00 	movl   $0x111ffd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 3d 4a 11 00 	movl   $0x114a3d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 13 56 00 00       	call   105cff <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 d6 60 10 00 	movl   $0x1060d6,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 ef 60 10 00 	movl   $0x1060ef,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 14 60 10 	movl   $0x106014,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 07 61 10 00 	movl   $0x106107,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 1f 61 10 00 	movl   $0x10611f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 37 61 10 00 	movl   $0x106137,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 50 61 10 00 	movl   $0x106150,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 7a 61 10 00 	movl   $0x10617a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 96 61 10 00 	movl   $0x106196,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i=0, j=0;
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
  1009e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e8:	e9 94 00 00 00       	jmp    100a81 <print_stackframe+0xc7>
	{
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  1009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fb:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  100a02:	e8 35 f9 ff ff       	call   10033c <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
  100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0a:	83 c0 08             	add    $0x8,%eax
  100a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//print arguments;
		cprintf("args:");
  100a10:	c7 04 24 bf 61 10 00 	movl   $0x1061bf,(%esp)
  100a17:	e8 20 f9 ff ff       	call   10033c <cprintf>
		for(j=0; j<4; j++)
  100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a23:	eb 25                	jmp    100a4a <print_stackframe+0x90>
			cprintf("0x%08x ", args[j]);
  100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a32:	01 d0                	add    %edx,%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3a:	c7 04 24 c5 61 10 00 	movl   $0x1061c5,(%esp)
  100a41:	e8 f6 f8 ff ff       	call   10033c <cprintf>
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		//print arguments;
		cprintf("args:");
		for(j=0; j<4; j++)
  100a46:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a4a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4e:	7e d5                	jle    100a25 <print_stackframe+0x6b>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
  100a50:	c7 04 24 cd 61 10 00 	movl   $0x1061cd,(%esp)
  100a57:	e8 e0 f8 ff ff       	call   10033c <cprintf>
		//call print_debuginfo(eip-1)
		print_debuginfo(eip-1);
  100a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a5f:	83 e8 01             	sub    $0x1,%eax
  100a62:	89 04 24             	mov    %eax,(%esp)
  100a65:	e8 9c fe ff ff       	call   100906 <print_debuginfo>
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
  100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6d:	83 c0 04             	add    $0x4,%eax
  100a70:	8b 00                	mov    (%eax),%eax
  100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a78:	8b 00                	mov    (%eax),%eax
  100a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i=0, j=0;
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
  100a7d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a81:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a85:	7f 0a                	jg     100a91 <print_stackframe+0xd7>
  100a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a8b:	0f 85 5c ff ff ff    	jne    1009ed <print_stackframe+0x33>
		print_debuginfo(eip-1);
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
	return;
  100a91:	90                   	nop
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a94:	55                   	push   %ebp
  100a95:	89 e5                	mov    %esp,%ebp
  100a97:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa1:	eb 0c                	jmp    100aaf <parse+0x1b>
            *buf ++ = '\0';
  100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa6:	8d 50 01             	lea    0x1(%eax),%edx
  100aa9:	89 55 08             	mov    %edx,0x8(%ebp)
  100aac:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab2:	0f b6 00             	movzbl (%eax),%eax
  100ab5:	84 c0                	test   %al,%al
  100ab7:	74 1d                	je     100ad6 <parse+0x42>
  100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  100abc:	0f b6 00             	movzbl (%eax),%eax
  100abf:	0f be c0             	movsbl %al,%eax
  100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac6:	c7 04 24 50 62 10 00 	movl   $0x106250,(%esp)
  100acd:	e8 fa 51 00 00       	call   105ccc <strchr>
  100ad2:	85 c0                	test   %eax,%eax
  100ad4:	75 cd                	jne    100aa3 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad9:	0f b6 00             	movzbl (%eax),%eax
  100adc:	84 c0                	test   %al,%al
  100ade:	75 02                	jne    100ae2 <parse+0x4e>
            break;
  100ae0:	eb 67                	jmp    100b49 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ae2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ae6:	75 14                	jne    100afc <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ae8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aef:	00 
  100af0:	c7 04 24 55 62 10 00 	movl   $0x106255,(%esp)
  100af7:	e8 40 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aff:	8d 50 01             	lea    0x1(%eax),%edx
  100b02:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b0f:	01 c2                	add    %eax,%edx
  100b11:	8b 45 08             	mov    0x8(%ebp),%eax
  100b14:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b16:	eb 04                	jmp    100b1c <parse+0x88>
            buf ++;
  100b18:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1f:	0f b6 00             	movzbl (%eax),%eax
  100b22:	84 c0                	test   %al,%al
  100b24:	74 1d                	je     100b43 <parse+0xaf>
  100b26:	8b 45 08             	mov    0x8(%ebp),%eax
  100b29:	0f b6 00             	movzbl (%eax),%eax
  100b2c:	0f be c0             	movsbl %al,%eax
  100b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b33:	c7 04 24 50 62 10 00 	movl   $0x106250,(%esp)
  100b3a:	e8 8d 51 00 00       	call   105ccc <strchr>
  100b3f:	85 c0                	test   %eax,%eax
  100b41:	74 d5                	je     100b18 <parse+0x84>
            buf ++;
        }
    }
  100b43:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b44:	e9 66 ff ff ff       	jmp    100aaf <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b4c:	c9                   	leave  
  100b4d:	c3                   	ret    

00100b4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b4e:	55                   	push   %ebp
  100b4f:	89 e5                	mov    %esp,%ebp
  100b51:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b54:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5e:	89 04 24             	mov    %eax,(%esp)
  100b61:	e8 2e ff ff ff       	call   100a94 <parse>
  100b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b6d:	75 0a                	jne    100b79 <runcmd+0x2b>
        return 0;
  100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b74:	e9 85 00 00 00       	jmp    100bfe <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b80:	eb 5c                	jmp    100bde <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b82:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b88:	89 d0                	mov    %edx,%eax
  100b8a:	01 c0                	add    %eax,%eax
  100b8c:	01 d0                	add    %edx,%eax
  100b8e:	c1 e0 02             	shl    $0x2,%eax
  100b91:	05 20 70 11 00       	add    $0x117020,%eax
  100b96:	8b 00                	mov    (%eax),%eax
  100b98:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b9c:	89 04 24             	mov    %eax,(%esp)
  100b9f:	e8 89 50 00 00       	call   105c2d <strcmp>
  100ba4:	85 c0                	test   %eax,%eax
  100ba6:	75 32                	jne    100bda <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bab:	89 d0                	mov    %edx,%eax
  100bad:	01 c0                	add    %eax,%eax
  100baf:	01 d0                	add    %edx,%eax
  100bb1:	c1 e0 02             	shl    $0x2,%eax
  100bb4:	05 20 70 11 00       	add    $0x117020,%eax
  100bb9:	8b 40 08             	mov    0x8(%eax),%eax
  100bbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bbf:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bc5:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bc9:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bcc:	83 c2 04             	add    $0x4,%edx
  100bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bd3:	89 0c 24             	mov    %ecx,(%esp)
  100bd6:	ff d0                	call   *%eax
  100bd8:	eb 24                	jmp    100bfe <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100be1:	83 f8 02             	cmp    $0x2,%eax
  100be4:	76 9c                	jbe    100b82 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100be6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bed:	c7 04 24 73 62 10 00 	movl   $0x106273,(%esp)
  100bf4:	e8 43 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bfe:	c9                   	leave  
  100bff:	c3                   	ret    

00100c00 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c00:	55                   	push   %ebp
  100c01:	89 e5                	mov    %esp,%ebp
  100c03:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c06:	c7 04 24 8c 62 10 00 	movl   $0x10628c,(%esp)
  100c0d:	e8 2a f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c12:	c7 04 24 b4 62 10 00 	movl   $0x1062b4,(%esp)
  100c19:	e8 1e f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c22:	74 0b                	je     100c2f <kmonitor+0x2f>
        print_trapframe(tf);
  100c24:	8b 45 08             	mov    0x8(%ebp),%eax
  100c27:	89 04 24             	mov    %eax,(%esp)
  100c2a:	e8 63 0e 00 00       	call   101a92 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c2f:	c7 04 24 d9 62 10 00 	movl   $0x1062d9,(%esp)
  100c36:	e8 f8 f5 ff ff       	call   100233 <readline>
  100c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c42:	74 18                	je     100c5c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c44:	8b 45 08             	mov    0x8(%ebp),%eax
  100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c4e:	89 04 24             	mov    %eax,(%esp)
  100c51:	e8 f8 fe ff ff       	call   100b4e <runcmd>
  100c56:	85 c0                	test   %eax,%eax
  100c58:	79 02                	jns    100c5c <kmonitor+0x5c>
                break;
  100c5a:	eb 02                	jmp    100c5e <kmonitor+0x5e>
            }
        }
    }
  100c5c:	eb d1                	jmp    100c2f <kmonitor+0x2f>
}
  100c5e:	c9                   	leave  
  100c5f:	c3                   	ret    

00100c60 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c60:	55                   	push   %ebp
  100c61:	89 e5                	mov    %esp,%ebp
  100c63:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c6d:	eb 3f                	jmp    100cae <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c72:	89 d0                	mov    %edx,%eax
  100c74:	01 c0                	add    %eax,%eax
  100c76:	01 d0                	add    %edx,%eax
  100c78:	c1 e0 02             	shl    $0x2,%eax
  100c7b:	05 20 70 11 00       	add    $0x117020,%eax
  100c80:	8b 48 04             	mov    0x4(%eax),%ecx
  100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c86:	89 d0                	mov    %edx,%eax
  100c88:	01 c0                	add    %eax,%eax
  100c8a:	01 d0                	add    %edx,%eax
  100c8c:	c1 e0 02             	shl    $0x2,%eax
  100c8f:	05 20 70 11 00       	add    $0x117020,%eax
  100c94:	8b 00                	mov    (%eax),%eax
  100c96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c9e:	c7 04 24 dd 62 10 00 	movl   $0x1062dd,(%esp)
  100ca5:	e8 92 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100caa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb1:	83 f8 02             	cmp    $0x2,%eax
  100cb4:	76 b9                	jbe    100c6f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbb:	c9                   	leave  
  100cbc:	c3                   	ret    

00100cbd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cbd:	55                   	push   %ebp
  100cbe:	89 e5                	mov    %esp,%ebp
  100cc0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cc3:	e8 a8 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccd:	c9                   	leave  
  100cce:	c3                   	ret    

00100ccf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ccf:	55                   	push   %ebp
  100cd0:	89 e5                	mov    %esp,%ebp
  100cd2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cd5:	e8 e0 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cdf:	c9                   	leave  
  100ce0:	c3                   	ret    

00100ce1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ce1:	55                   	push   %ebp
  100ce2:	89 e5                	mov    %esp,%ebp
  100ce4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ce7:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cec:	85 c0                	test   %eax,%eax
  100cee:	74 02                	je     100cf2 <__panic+0x11>
        goto panic_dead;
  100cf0:	eb 48                	jmp    100d3a <__panic+0x59>
    }
    is_panic = 1;
  100cf2:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cf9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cfc:	8d 45 14             	lea    0x14(%ebp),%eax
  100cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d09:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d10:	c7 04 24 e6 62 10 00 	movl   $0x1062e6,(%esp)
  100d17:	e8 20 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d23:	8b 45 10             	mov    0x10(%ebp),%eax
  100d26:	89 04 24             	mov    %eax,(%esp)
  100d29:	e8 db f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d2e:	c7 04 24 02 63 10 00 	movl   $0x106302,(%esp)
  100d35:	e8 02 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d3a:	e8 85 09 00 00       	call   1016c4 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d46:	e8 b5 fe ff ff       	call   100c00 <kmonitor>
    }
  100d4b:	eb f2                	jmp    100d3f <__panic+0x5e>

00100d4d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d4d:	55                   	push   %ebp
  100d4e:	89 e5                	mov    %esp,%ebp
  100d50:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d53:	8d 45 14             	lea    0x14(%ebp),%eax
  100d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d60:	8b 45 08             	mov    0x8(%ebp),%eax
  100d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d67:	c7 04 24 04 63 10 00 	movl   $0x106304,(%esp)
  100d6e:	e8 c9 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d7d:	89 04 24             	mov    %eax,(%esp)
  100d80:	e8 84 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d85:	c7 04 24 02 63 10 00 	movl   $0x106302,(%esp)
  100d8c:	e8 ab f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d91:	c9                   	leave  
  100d92:	c3                   	ret    

00100d93 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d93:	55                   	push   %ebp
  100d94:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d96:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d9b:	5d                   	pop    %ebp
  100d9c:	c3                   	ret    

00100d9d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d9d:	55                   	push   %ebp
  100d9e:	89 e5                	mov    %esp,%ebp
  100da0:	83 ec 28             	sub    $0x28,%esp
  100da3:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100da9:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100db1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db5:	ee                   	out    %al,(%dx)
  100db6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dbc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dc0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dc4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dc8:	ee                   	out    %al,(%dx)
  100dc9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dcf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dd3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ddb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100ddc:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100de3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100de6:	c7 04 24 22 63 10 00 	movl   $0x106322,(%esp)
  100ded:	e8 4a f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100df2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df9:	e8 24 09 00 00       	call   101722 <pic_enable>
}
  100dfe:	c9                   	leave  
  100dff:	c3                   	ret    

00100e00 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e00:	55                   	push   %ebp
  100e01:	89 e5                	mov    %esp,%ebp
  100e03:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e06:	9c                   	pushf  
  100e07:	58                   	pop    %eax
  100e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e0e:	25 00 02 00 00       	and    $0x200,%eax
  100e13:	85 c0                	test   %eax,%eax
  100e15:	74 0c                	je     100e23 <__intr_save+0x23>
        intr_disable();
  100e17:	e8 a8 08 00 00       	call   1016c4 <intr_disable>
        return 1;
  100e1c:	b8 01 00 00 00       	mov    $0x1,%eax
  100e21:	eb 05                	jmp    100e28 <__intr_save+0x28>
    }
    return 0;
  100e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e28:	c9                   	leave  
  100e29:	c3                   	ret    

00100e2a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e2a:	55                   	push   %ebp
  100e2b:	89 e5                	mov    %esp,%ebp
  100e2d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e34:	74 05                	je     100e3b <__intr_restore+0x11>
        intr_enable();
  100e36:	e8 83 08 00 00       	call   1016be <intr_enable>
    }
}
  100e3b:	c9                   	leave  
  100e3c:	c3                   	ret    

00100e3d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e3d:	55                   	push   %ebp
  100e3e:	89 e5                	mov    %esp,%ebp
  100e40:	83 ec 10             	sub    $0x10,%esp
  100e43:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e49:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e53:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e59:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e63:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e69:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e73:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e79:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e7d:	89 c2                	mov    %eax,%edx
  100e7f:	ec                   	in     (%dx),%al
  100e80:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e83:	c9                   	leave  
  100e84:	c3                   	ret    

00100e85 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e85:	55                   	push   %ebp
  100e86:	89 e5                	mov    %esp,%ebp
  100e88:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e8b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e95:	0f b7 00             	movzwl (%eax),%eax
  100e98:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea7:	0f b7 00             	movzwl (%eax),%eax
  100eaa:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100eae:	74 12                	je     100ec2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eb0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eb7:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ebe:	b4 03 
  100ec0:	eb 13                	jmp    100ed5 <cga_init+0x50>
    } else {
        *cp = was;
  100ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ec9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ecc:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ed3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	0f b7 c0             	movzwl %ax,%eax
  100edf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ee3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eeb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eef:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ef0:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ef7:	83 c0 01             	add    $0x1,%eax
  100efa:	0f b7 c0             	movzwl %ax,%eax
  100efd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f01:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f05:	89 c2                	mov    %eax,%edx
  100f07:	ec                   	in     (%dx),%al
  100f08:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f0b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f0f:	0f b6 c0             	movzbl %al,%eax
  100f12:	c1 e0 08             	shl    $0x8,%eax
  100f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	0f b7 c0             	movzwl %ax,%eax
  100f22:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f26:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f2a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f2e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f33:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f3a:	83 c0 01             	add    $0x1,%eax
  100f3d:	0f b7 c0             	movzwl %ax,%eax
  100f40:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f44:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f48:	89 c2                	mov    %eax,%edx
  100f4a:	ec                   	in     (%dx),%al
  100f4b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f4e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f52:	0f b6 c0             	movzbl %al,%eax
  100f55:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f5b:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f63:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f69:	c9                   	leave  
  100f6a:	c3                   	ret    

00100f6b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f6b:	55                   	push   %ebp
  100f6c:	89 e5                	mov    %esp,%ebp
  100f6e:	83 ec 48             	sub    $0x48,%esp
  100f71:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f77:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f7b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f7f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f83:	ee                   	out    %al,(%dx)
  100f84:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f8a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f92:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
  100f97:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f9d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fa1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fa5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa9:	ee                   	out    %al,(%dx)
  100faa:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fb4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fb8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fbc:	ee                   	out    %al,(%dx)
  100fbd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fc3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fc7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fcb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fcf:	ee                   	out    %al,(%dx)
  100fd0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fd6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fda:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fde:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fe2:	ee                   	out    %al,(%dx)
  100fe3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ff1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ff5:	ee                   	out    %al,(%dx)
  100ff6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ffc:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101000:	89 c2                	mov    %eax,%edx
  101002:	ec                   	in     (%dx),%al
  101003:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101006:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10100a:	3c ff                	cmp    $0xff,%al
  10100c:	0f 95 c0             	setne  %al
  10100f:	0f b6 c0             	movzbl %al,%eax
  101012:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101017:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10101d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101021:	89 c2                	mov    %eax,%edx
  101023:	ec                   	in     (%dx),%al
  101024:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101027:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10102d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101031:	89 c2                	mov    %eax,%edx
  101033:	ec                   	in     (%dx),%al
  101034:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101037:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10103c:	85 c0                	test   %eax,%eax
  10103e:	74 0c                	je     10104c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101040:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101047:	e8 d6 06 00 00       	call   101722 <pic_enable>
    }
}
  10104c:	c9                   	leave  
  10104d:	c3                   	ret    

0010104e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10104e:	55                   	push   %ebp
  10104f:	89 e5                	mov    %esp,%ebp
  101051:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101054:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10105b:	eb 09                	jmp    101066 <lpt_putc_sub+0x18>
        delay();
  10105d:	e8 db fd ff ff       	call   100e3d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101062:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101066:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10106c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101070:	89 c2                	mov    %eax,%edx
  101072:	ec                   	in     (%dx),%al
  101073:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101076:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10107a:	84 c0                	test   %al,%al
  10107c:	78 09                	js     101087 <lpt_putc_sub+0x39>
  10107e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101085:	7e d6                	jle    10105d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101087:	8b 45 08             	mov    0x8(%ebp),%eax
  10108a:	0f b6 c0             	movzbl %al,%eax
  10108d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101093:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101096:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10109a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10109e:	ee                   	out    %al,(%dx)
  10109f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010a5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010a9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010b1:	ee                   	out    %al,(%dx)
  1010b2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010b8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010bc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010c0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010c4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010c5:	c9                   	leave  
  1010c6:	c3                   	ret    

001010c7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010c7:	55                   	push   %ebp
  1010c8:	89 e5                	mov    %esp,%ebp
  1010ca:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010cd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010d1:	74 0d                	je     1010e0 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d6:	89 04 24             	mov    %eax,(%esp)
  1010d9:	e8 70 ff ff ff       	call   10104e <lpt_putc_sub>
  1010de:	eb 24                	jmp    101104 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e7:	e8 62 ff ff ff       	call   10104e <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010ec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010f3:	e8 56 ff ff ff       	call   10104e <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010f8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ff:	e8 4a ff ff ff       	call   10104e <lpt_putc_sub>
    }
}
  101104:	c9                   	leave  
  101105:	c3                   	ret    

00101106 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101106:	55                   	push   %ebp
  101107:	89 e5                	mov    %esp,%ebp
  101109:	53                   	push   %ebx
  10110a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	b0 00                	mov    $0x0,%al
  101112:	85 c0                	test   %eax,%eax
  101114:	75 07                	jne    10111d <cga_putc+0x17>
        c |= 0x0700;
  101116:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10111d:	8b 45 08             	mov    0x8(%ebp),%eax
  101120:	0f b6 c0             	movzbl %al,%eax
  101123:	83 f8 0a             	cmp    $0xa,%eax
  101126:	74 4c                	je     101174 <cga_putc+0x6e>
  101128:	83 f8 0d             	cmp    $0xd,%eax
  10112b:	74 57                	je     101184 <cga_putc+0x7e>
  10112d:	83 f8 08             	cmp    $0x8,%eax
  101130:	0f 85 88 00 00 00    	jne    1011be <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101136:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10113d:	66 85 c0             	test   %ax,%ax
  101140:	74 30                	je     101172 <cga_putc+0x6c>
            crt_pos --;
  101142:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101149:	83 e8 01             	sub    $0x1,%eax
  10114c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101152:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101157:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10115e:	0f b7 d2             	movzwl %dx,%edx
  101161:	01 d2                	add    %edx,%edx
  101163:	01 c2                	add    %eax,%edx
  101165:	8b 45 08             	mov    0x8(%ebp),%eax
  101168:	b0 00                	mov    $0x0,%al
  10116a:	83 c8 20             	or     $0x20,%eax
  10116d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101170:	eb 72                	jmp    1011e4 <cga_putc+0xde>
  101172:	eb 70                	jmp    1011e4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101174:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10117b:	83 c0 50             	add    $0x50,%eax
  10117e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101184:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10118b:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101192:	0f b7 c1             	movzwl %cx,%eax
  101195:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10119b:	c1 e8 10             	shr    $0x10,%eax
  10119e:	89 c2                	mov    %eax,%edx
  1011a0:	66 c1 ea 06          	shr    $0x6,%dx
  1011a4:	89 d0                	mov    %edx,%eax
  1011a6:	c1 e0 02             	shl    $0x2,%eax
  1011a9:	01 d0                	add    %edx,%eax
  1011ab:	c1 e0 04             	shl    $0x4,%eax
  1011ae:	29 c1                	sub    %eax,%ecx
  1011b0:	89 ca                	mov    %ecx,%edx
  1011b2:	89 d8                	mov    %ebx,%eax
  1011b4:	29 d0                	sub    %edx,%eax
  1011b6:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011bc:	eb 26                	jmp    1011e4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011be:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011c4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011cb:	8d 50 01             	lea    0x1(%eax),%edx
  1011ce:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011d5:	0f b7 c0             	movzwl %ax,%eax
  1011d8:	01 c0                	add    %eax,%eax
  1011da:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e0:	66 89 02             	mov    %ax,(%edx)
        break;
  1011e3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011e4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011eb:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011ef:	76 5b                	jbe    10124c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011f1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011fc:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101201:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101208:	00 
  101209:	89 54 24 04          	mov    %edx,0x4(%esp)
  10120d:	89 04 24             	mov    %eax,(%esp)
  101210:	e8 b5 4c 00 00       	call   105eca <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101215:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10121c:	eb 15                	jmp    101233 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10121e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101226:	01 d2                	add    %edx,%edx
  101228:	01 d0                	add    %edx,%eax
  10122a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10122f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101233:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10123a:	7e e2                	jle    10121e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10123c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101243:	83 e8 50             	sub    $0x50,%eax
  101246:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10124c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101253:	0f b7 c0             	movzwl %ax,%eax
  101256:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10125a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10125e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101262:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101266:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101267:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10126e:	66 c1 e8 08          	shr    $0x8,%ax
  101272:	0f b6 c0             	movzbl %al,%eax
  101275:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10127c:	83 c2 01             	add    $0x1,%edx
  10127f:	0f b7 d2             	movzwl %dx,%edx
  101282:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101286:	88 45 ed             	mov    %al,-0x13(%ebp)
  101289:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10128d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101292:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101299:	0f b7 c0             	movzwl %ax,%eax
  10129c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012a0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012a4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012a8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012ac:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012ad:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012b4:	0f b6 c0             	movzbl %al,%eax
  1012b7:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012be:	83 c2 01             	add    $0x1,%edx
  1012c1:	0f b7 d2             	movzwl %dx,%edx
  1012c4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012c8:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012cb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012cf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012d3:	ee                   	out    %al,(%dx)
}
  1012d4:	83 c4 34             	add    $0x34,%esp
  1012d7:	5b                   	pop    %ebx
  1012d8:	5d                   	pop    %ebp
  1012d9:	c3                   	ret    

001012da <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012da:	55                   	push   %ebp
  1012db:	89 e5                	mov    %esp,%ebp
  1012dd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012e7:	eb 09                	jmp    1012f2 <serial_putc_sub+0x18>
        delay();
  1012e9:	e8 4f fb ff ff       	call   100e3d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012f2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012f8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012fc:	89 c2                	mov    %eax,%edx
  1012fe:	ec                   	in     (%dx),%al
  1012ff:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101302:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101306:	0f b6 c0             	movzbl %al,%eax
  101309:	83 e0 20             	and    $0x20,%eax
  10130c:	85 c0                	test   %eax,%eax
  10130e:	75 09                	jne    101319 <serial_putc_sub+0x3f>
  101310:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101317:	7e d0                	jle    1012e9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101319:	8b 45 08             	mov    0x8(%ebp),%eax
  10131c:	0f b6 c0             	movzbl %al,%eax
  10131f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101325:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101328:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10132c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101330:	ee                   	out    %al,(%dx)
}
  101331:	c9                   	leave  
  101332:	c3                   	ret    

00101333 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101333:	55                   	push   %ebp
  101334:	89 e5                	mov    %esp,%ebp
  101336:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101339:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10133d:	74 0d                	je     10134c <serial_putc+0x19>
        serial_putc_sub(c);
  10133f:	8b 45 08             	mov    0x8(%ebp),%eax
  101342:	89 04 24             	mov    %eax,(%esp)
  101345:	e8 90 ff ff ff       	call   1012da <serial_putc_sub>
  10134a:	eb 24                	jmp    101370 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10134c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101353:	e8 82 ff ff ff       	call   1012da <serial_putc_sub>
        serial_putc_sub(' ');
  101358:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10135f:	e8 76 ff ff ff       	call   1012da <serial_putc_sub>
        serial_putc_sub('\b');
  101364:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10136b:	e8 6a ff ff ff       	call   1012da <serial_putc_sub>
    }
}
  101370:	c9                   	leave  
  101371:	c3                   	ret    

00101372 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101372:	55                   	push   %ebp
  101373:	89 e5                	mov    %esp,%ebp
  101375:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101378:	eb 33                	jmp    1013ad <cons_intr+0x3b>
        if (c != 0) {
  10137a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10137e:	74 2d                	je     1013ad <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101380:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101385:	8d 50 01             	lea    0x1(%eax),%edx
  101388:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10138e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101391:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101397:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10139c:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013a1:	75 0a                	jne    1013ad <cons_intr+0x3b>
                cons.wpos = 0;
  1013a3:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1013aa:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b0:	ff d0                	call   *%eax
  1013b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013b5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013b9:	75 bf                	jne    10137a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013bb:	c9                   	leave  
  1013bc:	c3                   	ret    

001013bd <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013bd:	55                   	push   %ebp
  1013be:	89 e5                	mov    %esp,%ebp
  1013c0:	83 ec 10             	sub    $0x10,%esp
  1013c3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013c9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013cd:	89 c2                	mov    %eax,%edx
  1013cf:	ec                   	in     (%dx),%al
  1013d0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013d7:	0f b6 c0             	movzbl %al,%eax
  1013da:	83 e0 01             	and    $0x1,%eax
  1013dd:	85 c0                	test   %eax,%eax
  1013df:	75 07                	jne    1013e8 <serial_proc_data+0x2b>
        return -1;
  1013e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e6:	eb 2a                	jmp    101412 <serial_proc_data+0x55>
  1013e8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ee:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013f2:	89 c2                	mov    %eax,%edx
  1013f4:	ec                   	in     (%dx),%al
  1013f5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013f8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013fc:	0f b6 c0             	movzbl %al,%eax
  1013ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101402:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101406:	75 07                	jne    10140f <serial_proc_data+0x52>
        c = '\b';
  101408:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101412:	c9                   	leave  
  101413:	c3                   	ret    

00101414 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101414:	55                   	push   %ebp
  101415:	89 e5                	mov    %esp,%ebp
  101417:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10141a:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10141f:	85 c0                	test   %eax,%eax
  101421:	74 0c                	je     10142f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101423:	c7 04 24 bd 13 10 00 	movl   $0x1013bd,(%esp)
  10142a:	e8 43 ff ff ff       	call   101372 <cons_intr>
    }
}
  10142f:	c9                   	leave  
  101430:	c3                   	ret    

00101431 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101431:	55                   	push   %ebp
  101432:	89 e5                	mov    %esp,%ebp
  101434:	83 ec 38             	sub    $0x38,%esp
  101437:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10143d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101441:	89 c2                	mov    %eax,%edx
  101443:	ec                   	in     (%dx),%al
  101444:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101447:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10144b:	0f b6 c0             	movzbl %al,%eax
  10144e:	83 e0 01             	and    $0x1,%eax
  101451:	85 c0                	test   %eax,%eax
  101453:	75 0a                	jne    10145f <kbd_proc_data+0x2e>
        return -1;
  101455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10145a:	e9 59 01 00 00       	jmp    1015b8 <kbd_proc_data+0x187>
  10145f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101465:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101469:	89 c2                	mov    %eax,%edx
  10146b:	ec                   	in     (%dx),%al
  10146c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10146f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101473:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101476:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10147a:	75 17                	jne    101493 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10147c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101481:	83 c8 40             	or     $0x40,%eax
  101484:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101489:	b8 00 00 00 00       	mov    $0x0,%eax
  10148e:	e9 25 01 00 00       	jmp    1015b8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101497:	84 c0                	test   %al,%al
  101499:	79 47                	jns    1014e2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10149b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014a0:	83 e0 40             	and    $0x40,%eax
  1014a3:	85 c0                	test   %eax,%eax
  1014a5:	75 09                	jne    1014b0 <kbd_proc_data+0x7f>
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	83 e0 7f             	and    $0x7f,%eax
  1014ae:	eb 04                	jmp    1014b4 <kbd_proc_data+0x83>
  1014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bb:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014c2:	83 c8 40             	or     $0x40,%eax
  1014c5:	0f b6 c0             	movzbl %al,%eax
  1014c8:	f7 d0                	not    %eax
  1014ca:	89 c2                	mov    %eax,%edx
  1014cc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d1:	21 d0                	and    %edx,%eax
  1014d3:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014d8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014dd:	e9 d6 00 00 00       	jmp    1015b8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014e2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e7:	83 e0 40             	and    $0x40,%eax
  1014ea:	85 c0                	test   %eax,%eax
  1014ec:	74 11                	je     1014ff <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014ee:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	83 e0 bf             	and    $0xffffffbf,%eax
  1014fa:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101503:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  10150a:	0f b6 d0             	movzbl %al,%edx
  10150d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101512:	09 d0                	or     %edx,%eax
  101514:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101519:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151d:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101524:	0f b6 d0             	movzbl %al,%edx
  101527:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10152c:	31 d0                	xor    %edx,%eax
  10152e:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101533:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101538:	83 e0 03             	and    $0x3,%eax
  10153b:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101542:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101546:	01 d0                	add    %edx,%eax
  101548:	0f b6 00             	movzbl (%eax),%eax
  10154b:	0f b6 c0             	movzbl %al,%eax
  10154e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101551:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101556:	83 e0 08             	and    $0x8,%eax
  101559:	85 c0                	test   %eax,%eax
  10155b:	74 22                	je     10157f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10155d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101561:	7e 0c                	jle    10156f <kbd_proc_data+0x13e>
  101563:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101567:	7f 06                	jg     10156f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101569:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10156d:	eb 10                	jmp    10157f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10156f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101573:	7e 0a                	jle    10157f <kbd_proc_data+0x14e>
  101575:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101579:	7f 04                	jg     10157f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10157b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10157f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101584:	f7 d0                	not    %eax
  101586:	83 e0 06             	and    $0x6,%eax
  101589:	85 c0                	test   %eax,%eax
  10158b:	75 28                	jne    1015b5 <kbd_proc_data+0x184>
  10158d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101594:	75 1f                	jne    1015b5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101596:	c7 04 24 3d 63 10 00 	movl   $0x10633d,(%esp)
  10159d:	e8 9a ed ff ff       	call   10033c <cprintf>
  1015a2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015a8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015ac:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015b0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015b4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015c0:	c7 04 24 31 14 10 00 	movl   $0x101431,(%esp)
  1015c7:	e8 a6 fd ff ff       	call   101372 <cons_intr>
}
  1015cc:	c9                   	leave  
  1015cd:	c3                   	ret    

001015ce <kbd_init>:

static void
kbd_init(void) {
  1015ce:	55                   	push   %ebp
  1015cf:	89 e5                	mov    %esp,%ebp
  1015d1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015d4:	e8 e1 ff ff ff       	call   1015ba <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015e0:	e8 3d 01 00 00       	call   101722 <pic_enable>
}
  1015e5:	c9                   	leave  
  1015e6:	c3                   	ret    

001015e7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e7:	55                   	push   %ebp
  1015e8:	89 e5                	mov    %esp,%ebp
  1015ea:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015ed:	e8 93 f8 ff ff       	call   100e85 <cga_init>
    serial_init();
  1015f2:	e8 74 f9 ff ff       	call   100f6b <serial_init>
    kbd_init();
  1015f7:	e8 d2 ff ff ff       	call   1015ce <kbd_init>
    if (!serial_exists) {
  1015fc:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101601:	85 c0                	test   %eax,%eax
  101603:	75 0c                	jne    101611 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101605:	c7 04 24 49 63 10 00 	movl   $0x106349,(%esp)
  10160c:	e8 2b ed ff ff       	call   10033c <cprintf>
    }
}
  101611:	c9                   	leave  
  101612:	c3                   	ret    

00101613 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101613:	55                   	push   %ebp
  101614:	89 e5                	mov    %esp,%ebp
  101616:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101619:	e8 e2 f7 ff ff       	call   100e00 <__intr_save>
  10161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101621:	8b 45 08             	mov    0x8(%ebp),%eax
  101624:	89 04 24             	mov    %eax,(%esp)
  101627:	e8 9b fa ff ff       	call   1010c7 <lpt_putc>
        cga_putc(c);
  10162c:	8b 45 08             	mov    0x8(%ebp),%eax
  10162f:	89 04 24             	mov    %eax,(%esp)
  101632:	e8 cf fa ff ff       	call   101106 <cga_putc>
        serial_putc(c);
  101637:	8b 45 08             	mov    0x8(%ebp),%eax
  10163a:	89 04 24             	mov    %eax,(%esp)
  10163d:	e8 f1 fc ff ff       	call   101333 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101645:	89 04 24             	mov    %eax,(%esp)
  101648:	e8 dd f7 ff ff       	call   100e2a <__intr_restore>
}
  10164d:	c9                   	leave  
  10164e:	c3                   	ret    

0010164f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10164f:	55                   	push   %ebp
  101650:	89 e5                	mov    %esp,%ebp
  101652:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101655:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10165c:	e8 9f f7 ff ff       	call   100e00 <__intr_save>
  101661:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101664:	e8 ab fd ff ff       	call   101414 <serial_intr>
        kbd_intr();
  101669:	e8 4c ff ff ff       	call   1015ba <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10166e:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101674:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101679:	39 c2                	cmp    %eax,%edx
  10167b:	74 31                	je     1016ae <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	8d 50 01             	lea    0x1(%eax),%edx
  101685:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10168b:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101692:	0f b6 c0             	movzbl %al,%eax
  101695:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101698:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10169d:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016a2:	75 0a                	jne    1016ae <cons_getc+0x5f>
                cons.rpos = 0;
  1016a4:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  1016ab:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016b1:	89 04 24             	mov    %eax,(%esp)
  1016b4:	e8 71 f7 ff ff       	call   100e2a <__intr_restore>
    return c;
  1016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016bc:	c9                   	leave  
  1016bd:	c3                   	ret    

001016be <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016be:	55                   	push   %ebp
  1016bf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016c1:	fb                   	sti    
    sti();
}
  1016c2:	5d                   	pop    %ebp
  1016c3:	c3                   	ret    

001016c4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016c4:	55                   	push   %ebp
  1016c5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016c7:	fa                   	cli    
    cli();
}
  1016c8:	5d                   	pop    %ebp
  1016c9:	c3                   	ret    

001016ca <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ca:	55                   	push   %ebp
  1016cb:	89 e5                	mov    %esp,%ebp
  1016cd:	83 ec 14             	sub    $0x14,%esp
  1016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016db:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016e1:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016e6:	85 c0                	test   %eax,%eax
  1016e8:	74 36                	je     101720 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ee:	0f b6 c0             	movzbl %al,%eax
  1016f1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016f7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016fa:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016fe:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101702:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101703:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101707:	66 c1 e8 08          	shr    $0x8,%ax
  10170b:	0f b6 c0             	movzbl %al,%eax
  10170e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101714:	88 45 f9             	mov    %al,-0x7(%ebp)
  101717:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10171b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
    }
}
  101720:	c9                   	leave  
  101721:	c3                   	ret    

00101722 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101722:	55                   	push   %ebp
  101723:	89 e5                	mov    %esp,%ebp
  101725:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101728:	8b 45 08             	mov    0x8(%ebp),%eax
  10172b:	ba 01 00 00 00       	mov    $0x1,%edx
  101730:	89 c1                	mov    %eax,%ecx
  101732:	d3 e2                	shl    %cl,%edx
  101734:	89 d0                	mov    %edx,%eax
  101736:	f7 d0                	not    %eax
  101738:	89 c2                	mov    %eax,%edx
  10173a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101741:	21 d0                	and    %edx,%eax
  101743:	0f b7 c0             	movzwl %ax,%eax
  101746:	89 04 24             	mov    %eax,(%esp)
  101749:	e8 7c ff ff ff       	call   1016ca <pic_setmask>
}
  10174e:	c9                   	leave  
  10174f:	c3                   	ret    

00101750 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101750:	55                   	push   %ebp
  101751:	89 e5                	mov    %esp,%ebp
  101753:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101756:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10175d:	00 00 00 
  101760:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101766:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10176a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10176e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101772:	ee                   	out    %al,(%dx)
  101773:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101779:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10177d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101781:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101785:	ee                   	out    %al,(%dx)
  101786:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10178c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101790:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101794:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101798:	ee                   	out    %al,(%dx)
  101799:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10179f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017a3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017a7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017ab:	ee                   	out    %al,(%dx)
  1017ac:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017b2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017b6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017ba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017be:	ee                   	out    %al,(%dx)
  1017bf:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017c5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017c9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017cd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017d1:	ee                   	out    %al,(%dx)
  1017d2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017d8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017dc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017e4:	ee                   	out    %al,(%dx)
  1017e5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017eb:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017ef:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017f7:	ee                   	out    %al,(%dx)
  1017f8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017fe:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101802:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101806:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10180a:	ee                   	out    %al,(%dx)
  10180b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101811:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101815:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101819:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10181d:	ee                   	out    %al,(%dx)
  10181e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101824:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101828:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10182c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101830:	ee                   	out    %al,(%dx)
  101831:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101837:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10183b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10183f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101843:	ee                   	out    %al,(%dx)
  101844:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10184a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10184e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101852:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101856:	ee                   	out    %al,(%dx)
  101857:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10185d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101861:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101865:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101869:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10186a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101871:	66 83 f8 ff          	cmp    $0xffff,%ax
  101875:	74 12                	je     101889 <pic_init+0x139>
        pic_setmask(irq_mask);
  101877:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10187e:	0f b7 c0             	movzwl %ax,%eax
  101881:	89 04 24             	mov    %eax,(%esp)
  101884:	e8 41 fe ff ff       	call   1016ca <pic_setmask>
    }
}
  101889:	c9                   	leave  
  10188a:	c3                   	ret    

0010188b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10188b:	55                   	push   %ebp
  10188c:	89 e5                	mov    %esp,%ebp
  10188e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101891:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101898:	00 
  101899:	c7 04 24 80 63 10 00 	movl   $0x106380,(%esp)
  1018a0:	e8 97 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018a5:	c7 04 24 8a 63 10 00 	movl   $0x10638a,(%esp)
  1018ac:	e8 8b ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  1018b1:	c7 44 24 08 98 63 10 	movl   $0x106398,0x8(%esp)
  1018b8:	00 
  1018b9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018c0:	00 
  1018c1:	c7 04 24 ae 63 10 00 	movl   $0x1063ae,(%esp)
  1018c8:	e8 14 f4 ff ff       	call   100ce1 <__panic>

001018cd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018cd:	55                   	push   %ebp
  1018ce:	89 e5                	mov    %esp,%ebp
  1018d0:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
  1018d3:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i=0;
  1018da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//setup each item of IDT;
	for(i=0; i<len; i++)
  1018e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018e8:	e9 c3 00 00 00       	jmp    1019b0 <idt_init+0xe3>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f0:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018f7:	89 c2                	mov    %eax,%edx
  1018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fc:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  101903:	00 
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  10190e:	00 08 00 
  101911:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101914:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  10191b:	00 
  10191c:	83 e2 e0             	and    $0xffffffe0,%edx
  10191f:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101926:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101929:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101930:	00 
  101931:	83 e2 1f             	and    $0x1f,%edx
  101934:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101945:	00 
  101946:	83 e2 f0             	and    $0xfffffff0,%edx
  101949:	83 ca 0e             	or     $0xe,%edx
  10194c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101953:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101956:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10195d:	00 
  10195e:	83 e2 ef             	and    $0xffffffef,%edx
  101961:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101968:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101972:	00 
  101973:	83 e2 9f             	and    $0xffffff9f,%edx
  101976:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101987:	00 
  101988:	83 ca 80             	or     $0xffffff80,%edx
  10198b:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10199c:	c1 e8 10             	shr    $0x10,%eax
  10199f:	89 c2                	mov    %eax,%edx
  1019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a4:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  1019ab:	00 
idt_init(void) {
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
	int i=0;
	//setup each item of IDT;
	for(i=0; i<len; i++)
  1019ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1019b6:	0f 8c 31 ff ff ff    	jl     1018ed <idt_init+0x20>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
  1019bc:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019c1:	66 a3 88 84 11 00    	mov    %ax,0x118488
  1019c7:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019ce:	08 00 
  1019d0:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019d7:	83 e0 e0             	and    $0xffffffe0,%eax
  1019da:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019df:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019e6:	83 e0 1f             	and    $0x1f,%eax
  1019e9:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019ee:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019f5:	83 e0 f0             	and    $0xfffffff0,%eax
  1019f8:	83 c8 0e             	or     $0xe,%eax
  1019fb:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a00:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a07:	83 e0 ef             	and    $0xffffffef,%eax
  101a0a:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a0f:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a16:	83 e0 9f             	and    $0xffffff9f,%eax
  101a19:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a1e:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a25:	83 c8 80             	or     $0xffffff80,%eax
  101a28:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a2d:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a32:	c1 e8 10             	shr    $0x10,%eax
  101a35:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a3b:	c7 45 f4 80 75 11 00 	movl   $0x117580,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a45:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);//载入IDT;
	return;
  101a48:	90                   	nop
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101a49:	c9                   	leave  
  101a4a:	c3                   	ret    

00101a4b <trapname>:

static const char *
trapname(int trapno) {
  101a4b:	55                   	push   %ebp
  101a4c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a51:	83 f8 13             	cmp    $0x13,%eax
  101a54:	77 0c                	ja     101a62 <trapname+0x17>
        return excnames[trapno];
  101a56:	8b 45 08             	mov    0x8(%ebp),%eax
  101a59:	8b 04 85 00 67 10 00 	mov    0x106700(,%eax,4),%eax
  101a60:	eb 18                	jmp    101a7a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a62:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a66:	7e 0d                	jle    101a75 <trapname+0x2a>
  101a68:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a6c:	7f 07                	jg     101a75 <trapname+0x2a>
        return "Hardware Interrupt";
  101a6e:	b8 bf 63 10 00       	mov    $0x1063bf,%eax
  101a73:	eb 05                	jmp    101a7a <trapname+0x2f>
    }
    return "(unknown trap)";
  101a75:	b8 d2 63 10 00       	mov    $0x1063d2,%eax
}
  101a7a:	5d                   	pop    %ebp
  101a7b:	c3                   	ret    

00101a7c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a7c:	55                   	push   %ebp
  101a7d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a86:	66 83 f8 08          	cmp    $0x8,%ax
  101a8a:	0f 94 c0             	sete   %al
  101a8d:	0f b6 c0             	movzbl %al,%eax
}
  101a90:	5d                   	pop    %ebp
  101a91:	c3                   	ret    

00101a92 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a92:	55                   	push   %ebp
  101a93:	89 e5                	mov    %esp,%ebp
  101a95:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a98:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9f:	c7 04 24 13 64 10 00 	movl   $0x106413,(%esp)
  101aa6:	e8 91 e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	89 04 24             	mov    %eax,(%esp)
  101ab1:	e8 a1 01 00 00       	call   101c57 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101abd:	0f b7 c0             	movzwl %ax,%eax
  101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac4:	c7 04 24 24 64 10 00 	movl   $0x106424,(%esp)
  101acb:	e8 6c e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ad7:	0f b7 c0             	movzwl %ax,%eax
  101ada:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ade:	c7 04 24 37 64 10 00 	movl   $0x106437,(%esp)
  101ae5:	e8 52 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aea:	8b 45 08             	mov    0x8(%ebp),%eax
  101aed:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af1:	0f b7 c0             	movzwl %ax,%eax
  101af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af8:	c7 04 24 4a 64 10 00 	movl   $0x10644a,(%esp)
  101aff:	e8 38 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b04:	8b 45 08             	mov    0x8(%ebp),%eax
  101b07:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b0b:	0f b7 c0             	movzwl %ax,%eax
  101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b12:	c7 04 24 5d 64 10 00 	movl   $0x10645d,(%esp)
  101b19:	e8 1e e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b21:	8b 40 30             	mov    0x30(%eax),%eax
  101b24:	89 04 24             	mov    %eax,(%esp)
  101b27:	e8 1f ff ff ff       	call   101a4b <trapname>
  101b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  101b2f:	8b 52 30             	mov    0x30(%edx),%edx
  101b32:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b36:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b3a:	c7 04 24 70 64 10 00 	movl   $0x106470,(%esp)
  101b41:	e8 f6 e7 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b46:	8b 45 08             	mov    0x8(%ebp),%eax
  101b49:	8b 40 34             	mov    0x34(%eax),%eax
  101b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b50:	c7 04 24 82 64 10 00 	movl   $0x106482,(%esp)
  101b57:	e8 e0 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	8b 40 38             	mov    0x38(%eax),%eax
  101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b66:	c7 04 24 91 64 10 00 	movl   $0x106491,(%esp)
  101b6d:	e8 ca e7 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b79:	0f b7 c0             	movzwl %ax,%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 a0 64 10 00 	movl   $0x1064a0,(%esp)
  101b87:	e8 b0 e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	8b 40 40             	mov    0x40(%eax),%eax
  101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b96:	c7 04 24 b3 64 10 00 	movl   $0x1064b3,(%esp)
  101b9d:	e8 9a e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ba9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bb0:	eb 3e                	jmp    101bf0 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb5:	8b 50 40             	mov    0x40(%eax),%edx
  101bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bbb:	21 d0                	and    %edx,%eax
  101bbd:	85 c0                	test   %eax,%eax
  101bbf:	74 28                	je     101be9 <print_trapframe+0x157>
  101bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc4:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bcb:	85 c0                	test   %eax,%eax
  101bcd:	74 1a                	je     101be9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd2:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 c2 64 10 00 	movl   $0x1064c2,(%esp)
  101be4:	e8 53 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101be9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bed:	d1 65 f0             	shll   -0x10(%ebp)
  101bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bf3:	83 f8 17             	cmp    $0x17,%eax
  101bf6:	76 ba                	jbe    101bb2 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 40             	mov    0x40(%eax),%eax
  101bfe:	25 00 30 00 00       	and    $0x3000,%eax
  101c03:	c1 e8 0c             	shr    $0xc,%eax
  101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0a:	c7 04 24 c6 64 10 00 	movl   $0x1064c6,(%esp)
  101c11:	e8 26 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101c16:	8b 45 08             	mov    0x8(%ebp),%eax
  101c19:	89 04 24             	mov    %eax,(%esp)
  101c1c:	e8 5b fe ff ff       	call   101a7c <trap_in_kernel>
  101c21:	85 c0                	test   %eax,%eax
  101c23:	75 30                	jne    101c55 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c25:	8b 45 08             	mov    0x8(%ebp),%eax
  101c28:	8b 40 44             	mov    0x44(%eax),%eax
  101c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2f:	c7 04 24 cf 64 10 00 	movl   $0x1064cf,(%esp)
  101c36:	e8 01 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c42:	0f b7 c0             	movzwl %ax,%eax
  101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c49:	c7 04 24 de 64 10 00 	movl   $0x1064de,(%esp)
  101c50:	e8 e7 e6 ff ff       	call   10033c <cprintf>
    }
}
  101c55:	c9                   	leave  
  101c56:	c3                   	ret    

00101c57 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c57:	55                   	push   %ebp
  101c58:	89 e5                	mov    %esp,%ebp
  101c5a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c60:	8b 00                	mov    (%eax),%eax
  101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c66:	c7 04 24 f1 64 10 00 	movl   $0x1064f1,(%esp)
  101c6d:	e8 ca e6 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c72:	8b 45 08             	mov    0x8(%ebp),%eax
  101c75:	8b 40 04             	mov    0x4(%eax),%eax
  101c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7c:	c7 04 24 00 65 10 00 	movl   $0x106500,(%esp)
  101c83:	e8 b4 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c88:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8b:	8b 40 08             	mov    0x8(%eax),%eax
  101c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c92:	c7 04 24 0f 65 10 00 	movl   $0x10650f,(%esp)
  101c99:	e8 9e e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  101ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca8:	c7 04 24 1e 65 10 00 	movl   $0x10651e,(%esp)
  101caf:	e8 88 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb7:	8b 40 10             	mov    0x10(%eax),%eax
  101cba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbe:	c7 04 24 2d 65 10 00 	movl   $0x10652d,(%esp)
  101cc5:	e8 72 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccd:	8b 40 14             	mov    0x14(%eax),%eax
  101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd4:	c7 04 24 3c 65 10 00 	movl   $0x10653c,(%esp)
  101cdb:	e8 5c e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce3:	8b 40 18             	mov    0x18(%eax),%eax
  101ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cea:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  101cf1:	e8 46 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d00:	c7 04 24 5a 65 10 00 	movl   $0x10655a,(%esp)
  101d07:	e8 30 e6 ff ff       	call   10033c <cprintf>
}
  101d0c:	c9                   	leave  
  101d0d:	c3                   	ret    

00101d0e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d0e:	55                   	push   %ebp
  101d0f:	89 e5                	mov    %esp,%ebp
  101d11:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d14:	8b 45 08             	mov    0x8(%ebp),%eax
  101d17:	8b 40 30             	mov    0x30(%eax),%eax
  101d1a:	83 f8 2f             	cmp    $0x2f,%eax
  101d1d:	77 21                	ja     101d40 <trap_dispatch+0x32>
  101d1f:	83 f8 2e             	cmp    $0x2e,%eax
  101d22:	0f 83 04 01 00 00    	jae    101e2c <trap_dispatch+0x11e>
  101d28:	83 f8 21             	cmp    $0x21,%eax
  101d2b:	0f 84 81 00 00 00    	je     101db2 <trap_dispatch+0xa4>
  101d31:	83 f8 24             	cmp    $0x24,%eax
  101d34:	74 56                	je     101d8c <trap_dispatch+0x7e>
  101d36:	83 f8 20             	cmp    $0x20,%eax
  101d39:	74 16                	je     101d51 <trap_dispatch+0x43>
  101d3b:	e9 b4 00 00 00       	jmp    101df4 <trap_dispatch+0xe6>
  101d40:	83 e8 78             	sub    $0x78,%eax
  101d43:	83 f8 01             	cmp    $0x1,%eax
  101d46:	0f 87 a8 00 00 00    	ja     101df4 <trap_dispatch+0xe6>
  101d4c:	e9 87 00 00 00       	jmp    101dd8 <trap_dispatch+0xca>
    case IRQ_OFFSET + IRQ_TIMER:
    	ticks++;//in clock.h(extern volatile size_t ticks;);
  101d51:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d56:	83 c0 01             	add    $0x1,%eax
  101d59:	a3 4c 89 11 00       	mov    %eax,0x11894c
    	if(ticks % TICK_NUM == 0)
  101d5e:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d64:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d69:	89 c8                	mov    %ecx,%eax
  101d6b:	f7 e2                	mul    %edx
  101d6d:	89 d0                	mov    %edx,%eax
  101d6f:	c1 e8 05             	shr    $0x5,%eax
  101d72:	6b c0 64             	imul   $0x64,%eax,%eax
  101d75:	29 c1                	sub    %eax,%ecx
  101d77:	89 c8                	mov    %ecx,%eax
  101d79:	85 c0                	test   %eax,%eax
  101d7b:	75 0a                	jne    101d87 <trap_dispatch+0x79>
    	{
    		print_ticks();//打印"100	ticks";
  101d7d:	e8 09 fb ff ff       	call   10188b <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101d82:	e9 a6 00 00 00       	jmp    101e2d <trap_dispatch+0x11f>
  101d87:	e9 a1 00 00 00       	jmp    101e2d <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d8c:	e8 be f8 ff ff       	call   10164f <cons_getc>
  101d91:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d94:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d98:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d9c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da4:	c7 04 24 69 65 10 00 	movl   $0x106569,(%esp)
  101dab:	e8 8c e5 ff ff       	call   10033c <cprintf>
        break;
  101db0:	eb 7b                	jmp    101e2d <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101db2:	e8 98 f8 ff ff       	call   10164f <cons_getc>
  101db7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dba:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dbe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dc2:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dca:	c7 04 24 7b 65 10 00 	movl   $0x10657b,(%esp)
  101dd1:	e8 66 e5 ff ff       	call   10033c <cprintf>
        break;
  101dd6:	eb 55                	jmp    101e2d <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dd8:	c7 44 24 08 8a 65 10 	movl   $0x10658a,0x8(%esp)
  101ddf:	00 
  101de0:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  101de7:	00 
  101de8:	c7 04 24 ae 63 10 00 	movl   $0x1063ae,(%esp)
  101def:	e8 ed ee ff ff       	call   100ce1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101df4:	8b 45 08             	mov    0x8(%ebp),%eax
  101df7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dfb:	0f b7 c0             	movzwl %ax,%eax
  101dfe:	83 e0 03             	and    $0x3,%eax
  101e01:	85 c0                	test   %eax,%eax
  101e03:	75 28                	jne    101e2d <trap_dispatch+0x11f>
            print_trapframe(tf);
  101e05:	8b 45 08             	mov    0x8(%ebp),%eax
  101e08:	89 04 24             	mov    %eax,(%esp)
  101e0b:	e8 82 fc ff ff       	call   101a92 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e10:	c7 44 24 08 9a 65 10 	movl   $0x10659a,0x8(%esp)
  101e17:	00 
  101e18:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  101e1f:	00 
  101e20:	c7 04 24 ae 63 10 00 	movl   $0x1063ae,(%esp)
  101e27:	e8 b5 ee ff ff       	call   100ce1 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e2c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e2d:	c9                   	leave  
  101e2e:	c3                   	ret    

00101e2f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e2f:	55                   	push   %ebp
  101e30:	89 e5                	mov    %esp,%ebp
  101e32:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	89 04 24             	mov    %eax,(%esp)
  101e3b:	e8 ce fe ff ff       	call   101d0e <trap_dispatch>
}
  101e40:	c9                   	leave  
  101e41:	c3                   	ret    

00101e42 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e42:	1e                   	push   %ds
    pushl %es
  101e43:	06                   	push   %es
    pushl %fs
  101e44:	0f a0                	push   %fs
    pushl %gs
  101e46:	0f a8                	push   %gs
    pushal
  101e48:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e49:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e4e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e50:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e52:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e53:	e8 d7 ff ff ff       	call   101e2f <trap>

    # pop the pushed stack pointer
    popl %esp
  101e58:	5c                   	pop    %esp

00101e59 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e59:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e5a:	0f a9                	pop    %gs
    popl %fs
  101e5c:	0f a1                	pop    %fs
    popl %es
  101e5e:	07                   	pop    %es
    popl %ds
  101e5f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e60:	83 c4 08             	add    $0x8,%esp
    iret
  101e63:	cf                   	iret   

00101e64 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e64:	6a 00                	push   $0x0
  pushl $0
  101e66:	6a 00                	push   $0x0
  jmp __alltraps
  101e68:	e9 d5 ff ff ff       	jmp    101e42 <__alltraps>

00101e6d <vector1>:
.globl vector1
vector1:
  pushl $0
  101e6d:	6a 00                	push   $0x0
  pushl $1
  101e6f:	6a 01                	push   $0x1
  jmp __alltraps
  101e71:	e9 cc ff ff ff       	jmp    101e42 <__alltraps>

00101e76 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $2
  101e78:	6a 02                	push   $0x2
  jmp __alltraps
  101e7a:	e9 c3 ff ff ff       	jmp    101e42 <__alltraps>

00101e7f <vector3>:
.globl vector3
vector3:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $3
  101e81:	6a 03                	push   $0x3
  jmp __alltraps
  101e83:	e9 ba ff ff ff       	jmp    101e42 <__alltraps>

00101e88 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e88:	6a 00                	push   $0x0
  pushl $4
  101e8a:	6a 04                	push   $0x4
  jmp __alltraps
  101e8c:	e9 b1 ff ff ff       	jmp    101e42 <__alltraps>

00101e91 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e91:	6a 00                	push   $0x0
  pushl $5
  101e93:	6a 05                	push   $0x5
  jmp __alltraps
  101e95:	e9 a8 ff ff ff       	jmp    101e42 <__alltraps>

00101e9a <vector6>:
.globl vector6
vector6:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $6
  101e9c:	6a 06                	push   $0x6
  jmp __alltraps
  101e9e:	e9 9f ff ff ff       	jmp    101e42 <__alltraps>

00101ea3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $7
  101ea5:	6a 07                	push   $0x7
  jmp __alltraps
  101ea7:	e9 96 ff ff ff       	jmp    101e42 <__alltraps>

00101eac <vector8>:
.globl vector8
vector8:
  pushl $8
  101eac:	6a 08                	push   $0x8
  jmp __alltraps
  101eae:	e9 8f ff ff ff       	jmp    101e42 <__alltraps>

00101eb3 <vector9>:
.globl vector9
vector9:
  pushl $9
  101eb3:	6a 09                	push   $0x9
  jmp __alltraps
  101eb5:	e9 88 ff ff ff       	jmp    101e42 <__alltraps>

00101eba <vector10>:
.globl vector10
vector10:
  pushl $10
  101eba:	6a 0a                	push   $0xa
  jmp __alltraps
  101ebc:	e9 81 ff ff ff       	jmp    101e42 <__alltraps>

00101ec1 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ec1:	6a 0b                	push   $0xb
  jmp __alltraps
  101ec3:	e9 7a ff ff ff       	jmp    101e42 <__alltraps>

00101ec8 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ec8:	6a 0c                	push   $0xc
  jmp __alltraps
  101eca:	e9 73 ff ff ff       	jmp    101e42 <__alltraps>

00101ecf <vector13>:
.globl vector13
vector13:
  pushl $13
  101ecf:	6a 0d                	push   $0xd
  jmp __alltraps
  101ed1:	e9 6c ff ff ff       	jmp    101e42 <__alltraps>

00101ed6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ed6:	6a 0e                	push   $0xe
  jmp __alltraps
  101ed8:	e9 65 ff ff ff       	jmp    101e42 <__alltraps>

00101edd <vector15>:
.globl vector15
vector15:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $15
  101edf:	6a 0f                	push   $0xf
  jmp __alltraps
  101ee1:	e9 5c ff ff ff       	jmp    101e42 <__alltraps>

00101ee6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $16
  101ee8:	6a 10                	push   $0x10
  jmp __alltraps
  101eea:	e9 53 ff ff ff       	jmp    101e42 <__alltraps>

00101eef <vector17>:
.globl vector17
vector17:
  pushl $17
  101eef:	6a 11                	push   $0x11
  jmp __alltraps
  101ef1:	e9 4c ff ff ff       	jmp    101e42 <__alltraps>

00101ef6 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $18
  101ef8:	6a 12                	push   $0x12
  jmp __alltraps
  101efa:	e9 43 ff ff ff       	jmp    101e42 <__alltraps>

00101eff <vector19>:
.globl vector19
vector19:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $19
  101f01:	6a 13                	push   $0x13
  jmp __alltraps
  101f03:	e9 3a ff ff ff       	jmp    101e42 <__alltraps>

00101f08 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $20
  101f0a:	6a 14                	push   $0x14
  jmp __alltraps
  101f0c:	e9 31 ff ff ff       	jmp    101e42 <__alltraps>

00101f11 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $21
  101f13:	6a 15                	push   $0x15
  jmp __alltraps
  101f15:	e9 28 ff ff ff       	jmp    101e42 <__alltraps>

00101f1a <vector22>:
.globl vector22
vector22:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $22
  101f1c:	6a 16                	push   $0x16
  jmp __alltraps
  101f1e:	e9 1f ff ff ff       	jmp    101e42 <__alltraps>

00101f23 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $23
  101f25:	6a 17                	push   $0x17
  jmp __alltraps
  101f27:	e9 16 ff ff ff       	jmp    101e42 <__alltraps>

00101f2c <vector24>:
.globl vector24
vector24:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $24
  101f2e:	6a 18                	push   $0x18
  jmp __alltraps
  101f30:	e9 0d ff ff ff       	jmp    101e42 <__alltraps>

00101f35 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $25
  101f37:	6a 19                	push   $0x19
  jmp __alltraps
  101f39:	e9 04 ff ff ff       	jmp    101e42 <__alltraps>

00101f3e <vector26>:
.globl vector26
vector26:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $26
  101f40:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f42:	e9 fb fe ff ff       	jmp    101e42 <__alltraps>

00101f47 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $27
  101f49:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f4b:	e9 f2 fe ff ff       	jmp    101e42 <__alltraps>

00101f50 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $28
  101f52:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f54:	e9 e9 fe ff ff       	jmp    101e42 <__alltraps>

00101f59 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $29
  101f5b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f5d:	e9 e0 fe ff ff       	jmp    101e42 <__alltraps>

00101f62 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $30
  101f64:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f66:	e9 d7 fe ff ff       	jmp    101e42 <__alltraps>

00101f6b <vector31>:
.globl vector31
vector31:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $31
  101f6d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f6f:	e9 ce fe ff ff       	jmp    101e42 <__alltraps>

00101f74 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $32
  101f76:	6a 20                	push   $0x20
  jmp __alltraps
  101f78:	e9 c5 fe ff ff       	jmp    101e42 <__alltraps>

00101f7d <vector33>:
.globl vector33
vector33:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $33
  101f7f:	6a 21                	push   $0x21
  jmp __alltraps
  101f81:	e9 bc fe ff ff       	jmp    101e42 <__alltraps>

00101f86 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $34
  101f88:	6a 22                	push   $0x22
  jmp __alltraps
  101f8a:	e9 b3 fe ff ff       	jmp    101e42 <__alltraps>

00101f8f <vector35>:
.globl vector35
vector35:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $35
  101f91:	6a 23                	push   $0x23
  jmp __alltraps
  101f93:	e9 aa fe ff ff       	jmp    101e42 <__alltraps>

00101f98 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $36
  101f9a:	6a 24                	push   $0x24
  jmp __alltraps
  101f9c:	e9 a1 fe ff ff       	jmp    101e42 <__alltraps>

00101fa1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $37
  101fa3:	6a 25                	push   $0x25
  jmp __alltraps
  101fa5:	e9 98 fe ff ff       	jmp    101e42 <__alltraps>

00101faa <vector38>:
.globl vector38
vector38:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $38
  101fac:	6a 26                	push   $0x26
  jmp __alltraps
  101fae:	e9 8f fe ff ff       	jmp    101e42 <__alltraps>

00101fb3 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $39
  101fb5:	6a 27                	push   $0x27
  jmp __alltraps
  101fb7:	e9 86 fe ff ff       	jmp    101e42 <__alltraps>

00101fbc <vector40>:
.globl vector40
vector40:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $40
  101fbe:	6a 28                	push   $0x28
  jmp __alltraps
  101fc0:	e9 7d fe ff ff       	jmp    101e42 <__alltraps>

00101fc5 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $41
  101fc7:	6a 29                	push   $0x29
  jmp __alltraps
  101fc9:	e9 74 fe ff ff       	jmp    101e42 <__alltraps>

00101fce <vector42>:
.globl vector42
vector42:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $42
  101fd0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fd2:	e9 6b fe ff ff       	jmp    101e42 <__alltraps>

00101fd7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $43
  101fd9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fdb:	e9 62 fe ff ff       	jmp    101e42 <__alltraps>

00101fe0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $44
  101fe2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fe4:	e9 59 fe ff ff       	jmp    101e42 <__alltraps>

00101fe9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $45
  101feb:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fed:	e9 50 fe ff ff       	jmp    101e42 <__alltraps>

00101ff2 <vector46>:
.globl vector46
vector46:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $46
  101ff4:	6a 2e                	push   $0x2e
  jmp __alltraps
  101ff6:	e9 47 fe ff ff       	jmp    101e42 <__alltraps>

00101ffb <vector47>:
.globl vector47
vector47:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $47
  101ffd:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fff:	e9 3e fe ff ff       	jmp    101e42 <__alltraps>

00102004 <vector48>:
.globl vector48
vector48:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $48
  102006:	6a 30                	push   $0x30
  jmp __alltraps
  102008:	e9 35 fe ff ff       	jmp    101e42 <__alltraps>

0010200d <vector49>:
.globl vector49
vector49:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $49
  10200f:	6a 31                	push   $0x31
  jmp __alltraps
  102011:	e9 2c fe ff ff       	jmp    101e42 <__alltraps>

00102016 <vector50>:
.globl vector50
vector50:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $50
  102018:	6a 32                	push   $0x32
  jmp __alltraps
  10201a:	e9 23 fe ff ff       	jmp    101e42 <__alltraps>

0010201f <vector51>:
.globl vector51
vector51:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $51
  102021:	6a 33                	push   $0x33
  jmp __alltraps
  102023:	e9 1a fe ff ff       	jmp    101e42 <__alltraps>

00102028 <vector52>:
.globl vector52
vector52:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $52
  10202a:	6a 34                	push   $0x34
  jmp __alltraps
  10202c:	e9 11 fe ff ff       	jmp    101e42 <__alltraps>

00102031 <vector53>:
.globl vector53
vector53:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $53
  102033:	6a 35                	push   $0x35
  jmp __alltraps
  102035:	e9 08 fe ff ff       	jmp    101e42 <__alltraps>

0010203a <vector54>:
.globl vector54
vector54:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $54
  10203c:	6a 36                	push   $0x36
  jmp __alltraps
  10203e:	e9 ff fd ff ff       	jmp    101e42 <__alltraps>

00102043 <vector55>:
.globl vector55
vector55:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $55
  102045:	6a 37                	push   $0x37
  jmp __alltraps
  102047:	e9 f6 fd ff ff       	jmp    101e42 <__alltraps>

0010204c <vector56>:
.globl vector56
vector56:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $56
  10204e:	6a 38                	push   $0x38
  jmp __alltraps
  102050:	e9 ed fd ff ff       	jmp    101e42 <__alltraps>

00102055 <vector57>:
.globl vector57
vector57:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $57
  102057:	6a 39                	push   $0x39
  jmp __alltraps
  102059:	e9 e4 fd ff ff       	jmp    101e42 <__alltraps>

0010205e <vector58>:
.globl vector58
vector58:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $58
  102060:	6a 3a                	push   $0x3a
  jmp __alltraps
  102062:	e9 db fd ff ff       	jmp    101e42 <__alltraps>

00102067 <vector59>:
.globl vector59
vector59:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $59
  102069:	6a 3b                	push   $0x3b
  jmp __alltraps
  10206b:	e9 d2 fd ff ff       	jmp    101e42 <__alltraps>

00102070 <vector60>:
.globl vector60
vector60:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $60
  102072:	6a 3c                	push   $0x3c
  jmp __alltraps
  102074:	e9 c9 fd ff ff       	jmp    101e42 <__alltraps>

00102079 <vector61>:
.globl vector61
vector61:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $61
  10207b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10207d:	e9 c0 fd ff ff       	jmp    101e42 <__alltraps>

00102082 <vector62>:
.globl vector62
vector62:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $62
  102084:	6a 3e                	push   $0x3e
  jmp __alltraps
  102086:	e9 b7 fd ff ff       	jmp    101e42 <__alltraps>

0010208b <vector63>:
.globl vector63
vector63:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $63
  10208d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10208f:	e9 ae fd ff ff       	jmp    101e42 <__alltraps>

00102094 <vector64>:
.globl vector64
vector64:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $64
  102096:	6a 40                	push   $0x40
  jmp __alltraps
  102098:	e9 a5 fd ff ff       	jmp    101e42 <__alltraps>

0010209d <vector65>:
.globl vector65
vector65:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $65
  10209f:	6a 41                	push   $0x41
  jmp __alltraps
  1020a1:	e9 9c fd ff ff       	jmp    101e42 <__alltraps>

001020a6 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $66
  1020a8:	6a 42                	push   $0x42
  jmp __alltraps
  1020aa:	e9 93 fd ff ff       	jmp    101e42 <__alltraps>

001020af <vector67>:
.globl vector67
vector67:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $67
  1020b1:	6a 43                	push   $0x43
  jmp __alltraps
  1020b3:	e9 8a fd ff ff       	jmp    101e42 <__alltraps>

001020b8 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $68
  1020ba:	6a 44                	push   $0x44
  jmp __alltraps
  1020bc:	e9 81 fd ff ff       	jmp    101e42 <__alltraps>

001020c1 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $69
  1020c3:	6a 45                	push   $0x45
  jmp __alltraps
  1020c5:	e9 78 fd ff ff       	jmp    101e42 <__alltraps>

001020ca <vector70>:
.globl vector70
vector70:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $70
  1020cc:	6a 46                	push   $0x46
  jmp __alltraps
  1020ce:	e9 6f fd ff ff       	jmp    101e42 <__alltraps>

001020d3 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $71
  1020d5:	6a 47                	push   $0x47
  jmp __alltraps
  1020d7:	e9 66 fd ff ff       	jmp    101e42 <__alltraps>

001020dc <vector72>:
.globl vector72
vector72:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $72
  1020de:	6a 48                	push   $0x48
  jmp __alltraps
  1020e0:	e9 5d fd ff ff       	jmp    101e42 <__alltraps>

001020e5 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $73
  1020e7:	6a 49                	push   $0x49
  jmp __alltraps
  1020e9:	e9 54 fd ff ff       	jmp    101e42 <__alltraps>

001020ee <vector74>:
.globl vector74
vector74:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $74
  1020f0:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020f2:	e9 4b fd ff ff       	jmp    101e42 <__alltraps>

001020f7 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $75
  1020f9:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020fb:	e9 42 fd ff ff       	jmp    101e42 <__alltraps>

00102100 <vector76>:
.globl vector76
vector76:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $76
  102102:	6a 4c                	push   $0x4c
  jmp __alltraps
  102104:	e9 39 fd ff ff       	jmp    101e42 <__alltraps>

00102109 <vector77>:
.globl vector77
vector77:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $77
  10210b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10210d:	e9 30 fd ff ff       	jmp    101e42 <__alltraps>

00102112 <vector78>:
.globl vector78
vector78:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $78
  102114:	6a 4e                	push   $0x4e
  jmp __alltraps
  102116:	e9 27 fd ff ff       	jmp    101e42 <__alltraps>

0010211b <vector79>:
.globl vector79
vector79:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $79
  10211d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10211f:	e9 1e fd ff ff       	jmp    101e42 <__alltraps>

00102124 <vector80>:
.globl vector80
vector80:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $80
  102126:	6a 50                	push   $0x50
  jmp __alltraps
  102128:	e9 15 fd ff ff       	jmp    101e42 <__alltraps>

0010212d <vector81>:
.globl vector81
vector81:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $81
  10212f:	6a 51                	push   $0x51
  jmp __alltraps
  102131:	e9 0c fd ff ff       	jmp    101e42 <__alltraps>

00102136 <vector82>:
.globl vector82
vector82:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $82
  102138:	6a 52                	push   $0x52
  jmp __alltraps
  10213a:	e9 03 fd ff ff       	jmp    101e42 <__alltraps>

0010213f <vector83>:
.globl vector83
vector83:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $83
  102141:	6a 53                	push   $0x53
  jmp __alltraps
  102143:	e9 fa fc ff ff       	jmp    101e42 <__alltraps>

00102148 <vector84>:
.globl vector84
vector84:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $84
  10214a:	6a 54                	push   $0x54
  jmp __alltraps
  10214c:	e9 f1 fc ff ff       	jmp    101e42 <__alltraps>

00102151 <vector85>:
.globl vector85
vector85:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $85
  102153:	6a 55                	push   $0x55
  jmp __alltraps
  102155:	e9 e8 fc ff ff       	jmp    101e42 <__alltraps>

0010215a <vector86>:
.globl vector86
vector86:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $86
  10215c:	6a 56                	push   $0x56
  jmp __alltraps
  10215e:	e9 df fc ff ff       	jmp    101e42 <__alltraps>

00102163 <vector87>:
.globl vector87
vector87:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $87
  102165:	6a 57                	push   $0x57
  jmp __alltraps
  102167:	e9 d6 fc ff ff       	jmp    101e42 <__alltraps>

0010216c <vector88>:
.globl vector88
vector88:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $88
  10216e:	6a 58                	push   $0x58
  jmp __alltraps
  102170:	e9 cd fc ff ff       	jmp    101e42 <__alltraps>

00102175 <vector89>:
.globl vector89
vector89:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $89
  102177:	6a 59                	push   $0x59
  jmp __alltraps
  102179:	e9 c4 fc ff ff       	jmp    101e42 <__alltraps>

0010217e <vector90>:
.globl vector90
vector90:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $90
  102180:	6a 5a                	push   $0x5a
  jmp __alltraps
  102182:	e9 bb fc ff ff       	jmp    101e42 <__alltraps>

00102187 <vector91>:
.globl vector91
vector91:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $91
  102189:	6a 5b                	push   $0x5b
  jmp __alltraps
  10218b:	e9 b2 fc ff ff       	jmp    101e42 <__alltraps>

00102190 <vector92>:
.globl vector92
vector92:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $92
  102192:	6a 5c                	push   $0x5c
  jmp __alltraps
  102194:	e9 a9 fc ff ff       	jmp    101e42 <__alltraps>

00102199 <vector93>:
.globl vector93
vector93:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $93
  10219b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10219d:	e9 a0 fc ff ff       	jmp    101e42 <__alltraps>

001021a2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $94
  1021a4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021a6:	e9 97 fc ff ff       	jmp    101e42 <__alltraps>

001021ab <vector95>:
.globl vector95
vector95:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $95
  1021ad:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021af:	e9 8e fc ff ff       	jmp    101e42 <__alltraps>

001021b4 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $96
  1021b6:	6a 60                	push   $0x60
  jmp __alltraps
  1021b8:	e9 85 fc ff ff       	jmp    101e42 <__alltraps>

001021bd <vector97>:
.globl vector97
vector97:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $97
  1021bf:	6a 61                	push   $0x61
  jmp __alltraps
  1021c1:	e9 7c fc ff ff       	jmp    101e42 <__alltraps>

001021c6 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $98
  1021c8:	6a 62                	push   $0x62
  jmp __alltraps
  1021ca:	e9 73 fc ff ff       	jmp    101e42 <__alltraps>

001021cf <vector99>:
.globl vector99
vector99:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $99
  1021d1:	6a 63                	push   $0x63
  jmp __alltraps
  1021d3:	e9 6a fc ff ff       	jmp    101e42 <__alltraps>

001021d8 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $100
  1021da:	6a 64                	push   $0x64
  jmp __alltraps
  1021dc:	e9 61 fc ff ff       	jmp    101e42 <__alltraps>

001021e1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $101
  1021e3:	6a 65                	push   $0x65
  jmp __alltraps
  1021e5:	e9 58 fc ff ff       	jmp    101e42 <__alltraps>

001021ea <vector102>:
.globl vector102
vector102:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $102
  1021ec:	6a 66                	push   $0x66
  jmp __alltraps
  1021ee:	e9 4f fc ff ff       	jmp    101e42 <__alltraps>

001021f3 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $103
  1021f5:	6a 67                	push   $0x67
  jmp __alltraps
  1021f7:	e9 46 fc ff ff       	jmp    101e42 <__alltraps>

001021fc <vector104>:
.globl vector104
vector104:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $104
  1021fe:	6a 68                	push   $0x68
  jmp __alltraps
  102200:	e9 3d fc ff ff       	jmp    101e42 <__alltraps>

00102205 <vector105>:
.globl vector105
vector105:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $105
  102207:	6a 69                	push   $0x69
  jmp __alltraps
  102209:	e9 34 fc ff ff       	jmp    101e42 <__alltraps>

0010220e <vector106>:
.globl vector106
vector106:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $106
  102210:	6a 6a                	push   $0x6a
  jmp __alltraps
  102212:	e9 2b fc ff ff       	jmp    101e42 <__alltraps>

00102217 <vector107>:
.globl vector107
vector107:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $107
  102219:	6a 6b                	push   $0x6b
  jmp __alltraps
  10221b:	e9 22 fc ff ff       	jmp    101e42 <__alltraps>

00102220 <vector108>:
.globl vector108
vector108:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $108
  102222:	6a 6c                	push   $0x6c
  jmp __alltraps
  102224:	e9 19 fc ff ff       	jmp    101e42 <__alltraps>

00102229 <vector109>:
.globl vector109
vector109:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $109
  10222b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10222d:	e9 10 fc ff ff       	jmp    101e42 <__alltraps>

00102232 <vector110>:
.globl vector110
vector110:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $110
  102234:	6a 6e                	push   $0x6e
  jmp __alltraps
  102236:	e9 07 fc ff ff       	jmp    101e42 <__alltraps>

0010223b <vector111>:
.globl vector111
vector111:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $111
  10223d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10223f:	e9 fe fb ff ff       	jmp    101e42 <__alltraps>

00102244 <vector112>:
.globl vector112
vector112:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $112
  102246:	6a 70                	push   $0x70
  jmp __alltraps
  102248:	e9 f5 fb ff ff       	jmp    101e42 <__alltraps>

0010224d <vector113>:
.globl vector113
vector113:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $113
  10224f:	6a 71                	push   $0x71
  jmp __alltraps
  102251:	e9 ec fb ff ff       	jmp    101e42 <__alltraps>

00102256 <vector114>:
.globl vector114
vector114:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $114
  102258:	6a 72                	push   $0x72
  jmp __alltraps
  10225a:	e9 e3 fb ff ff       	jmp    101e42 <__alltraps>

0010225f <vector115>:
.globl vector115
vector115:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $115
  102261:	6a 73                	push   $0x73
  jmp __alltraps
  102263:	e9 da fb ff ff       	jmp    101e42 <__alltraps>

00102268 <vector116>:
.globl vector116
vector116:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $116
  10226a:	6a 74                	push   $0x74
  jmp __alltraps
  10226c:	e9 d1 fb ff ff       	jmp    101e42 <__alltraps>

00102271 <vector117>:
.globl vector117
vector117:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $117
  102273:	6a 75                	push   $0x75
  jmp __alltraps
  102275:	e9 c8 fb ff ff       	jmp    101e42 <__alltraps>

0010227a <vector118>:
.globl vector118
vector118:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $118
  10227c:	6a 76                	push   $0x76
  jmp __alltraps
  10227e:	e9 bf fb ff ff       	jmp    101e42 <__alltraps>

00102283 <vector119>:
.globl vector119
vector119:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $119
  102285:	6a 77                	push   $0x77
  jmp __alltraps
  102287:	e9 b6 fb ff ff       	jmp    101e42 <__alltraps>

0010228c <vector120>:
.globl vector120
vector120:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $120
  10228e:	6a 78                	push   $0x78
  jmp __alltraps
  102290:	e9 ad fb ff ff       	jmp    101e42 <__alltraps>

00102295 <vector121>:
.globl vector121
vector121:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $121
  102297:	6a 79                	push   $0x79
  jmp __alltraps
  102299:	e9 a4 fb ff ff       	jmp    101e42 <__alltraps>

0010229e <vector122>:
.globl vector122
vector122:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $122
  1022a0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022a2:	e9 9b fb ff ff       	jmp    101e42 <__alltraps>

001022a7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $123
  1022a9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022ab:	e9 92 fb ff ff       	jmp    101e42 <__alltraps>

001022b0 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $124
  1022b2:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022b4:	e9 89 fb ff ff       	jmp    101e42 <__alltraps>

001022b9 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $125
  1022bb:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022bd:	e9 80 fb ff ff       	jmp    101e42 <__alltraps>

001022c2 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $126
  1022c4:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022c6:	e9 77 fb ff ff       	jmp    101e42 <__alltraps>

001022cb <vector127>:
.globl vector127
vector127:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $127
  1022cd:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022cf:	e9 6e fb ff ff       	jmp    101e42 <__alltraps>

001022d4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $128
  1022d6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022db:	e9 62 fb ff ff       	jmp    101e42 <__alltraps>

001022e0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $129
  1022e2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022e7:	e9 56 fb ff ff       	jmp    101e42 <__alltraps>

001022ec <vector130>:
.globl vector130
vector130:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $130
  1022ee:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022f3:	e9 4a fb ff ff       	jmp    101e42 <__alltraps>

001022f8 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $131
  1022fa:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022ff:	e9 3e fb ff ff       	jmp    101e42 <__alltraps>

00102304 <vector132>:
.globl vector132
vector132:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $132
  102306:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10230b:	e9 32 fb ff ff       	jmp    101e42 <__alltraps>

00102310 <vector133>:
.globl vector133
vector133:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $133
  102312:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102317:	e9 26 fb ff ff       	jmp    101e42 <__alltraps>

0010231c <vector134>:
.globl vector134
vector134:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $134
  10231e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102323:	e9 1a fb ff ff       	jmp    101e42 <__alltraps>

00102328 <vector135>:
.globl vector135
vector135:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $135
  10232a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10232f:	e9 0e fb ff ff       	jmp    101e42 <__alltraps>

00102334 <vector136>:
.globl vector136
vector136:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $136
  102336:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10233b:	e9 02 fb ff ff       	jmp    101e42 <__alltraps>

00102340 <vector137>:
.globl vector137
vector137:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $137
  102342:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102347:	e9 f6 fa ff ff       	jmp    101e42 <__alltraps>

0010234c <vector138>:
.globl vector138
vector138:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $138
  10234e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102353:	e9 ea fa ff ff       	jmp    101e42 <__alltraps>

00102358 <vector139>:
.globl vector139
vector139:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $139
  10235a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10235f:	e9 de fa ff ff       	jmp    101e42 <__alltraps>

00102364 <vector140>:
.globl vector140
vector140:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $140
  102366:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10236b:	e9 d2 fa ff ff       	jmp    101e42 <__alltraps>

00102370 <vector141>:
.globl vector141
vector141:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $141
  102372:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102377:	e9 c6 fa ff ff       	jmp    101e42 <__alltraps>

0010237c <vector142>:
.globl vector142
vector142:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $142
  10237e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102383:	e9 ba fa ff ff       	jmp    101e42 <__alltraps>

00102388 <vector143>:
.globl vector143
vector143:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $143
  10238a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10238f:	e9 ae fa ff ff       	jmp    101e42 <__alltraps>

00102394 <vector144>:
.globl vector144
vector144:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $144
  102396:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10239b:	e9 a2 fa ff ff       	jmp    101e42 <__alltraps>

001023a0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $145
  1023a2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023a7:	e9 96 fa ff ff       	jmp    101e42 <__alltraps>

001023ac <vector146>:
.globl vector146
vector146:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $146
  1023ae:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023b3:	e9 8a fa ff ff       	jmp    101e42 <__alltraps>

001023b8 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $147
  1023ba:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023bf:	e9 7e fa ff ff       	jmp    101e42 <__alltraps>

001023c4 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $148
  1023c6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023cb:	e9 72 fa ff ff       	jmp    101e42 <__alltraps>

001023d0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $149
  1023d2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023d7:	e9 66 fa ff ff       	jmp    101e42 <__alltraps>

001023dc <vector150>:
.globl vector150
vector150:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $150
  1023de:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023e3:	e9 5a fa ff ff       	jmp    101e42 <__alltraps>

001023e8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $151
  1023ea:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023ef:	e9 4e fa ff ff       	jmp    101e42 <__alltraps>

001023f4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $152
  1023f6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023fb:	e9 42 fa ff ff       	jmp    101e42 <__alltraps>

00102400 <vector153>:
.globl vector153
vector153:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $153
  102402:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102407:	e9 36 fa ff ff       	jmp    101e42 <__alltraps>

0010240c <vector154>:
.globl vector154
vector154:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $154
  10240e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102413:	e9 2a fa ff ff       	jmp    101e42 <__alltraps>

00102418 <vector155>:
.globl vector155
vector155:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $155
  10241a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10241f:	e9 1e fa ff ff       	jmp    101e42 <__alltraps>

00102424 <vector156>:
.globl vector156
vector156:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $156
  102426:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10242b:	e9 12 fa ff ff       	jmp    101e42 <__alltraps>

00102430 <vector157>:
.globl vector157
vector157:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $157
  102432:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102437:	e9 06 fa ff ff       	jmp    101e42 <__alltraps>

0010243c <vector158>:
.globl vector158
vector158:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $158
  10243e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102443:	e9 fa f9 ff ff       	jmp    101e42 <__alltraps>

00102448 <vector159>:
.globl vector159
vector159:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $159
  10244a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10244f:	e9 ee f9 ff ff       	jmp    101e42 <__alltraps>

00102454 <vector160>:
.globl vector160
vector160:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $160
  102456:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10245b:	e9 e2 f9 ff ff       	jmp    101e42 <__alltraps>

00102460 <vector161>:
.globl vector161
vector161:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $161
  102462:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102467:	e9 d6 f9 ff ff       	jmp    101e42 <__alltraps>

0010246c <vector162>:
.globl vector162
vector162:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $162
  10246e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102473:	e9 ca f9 ff ff       	jmp    101e42 <__alltraps>

00102478 <vector163>:
.globl vector163
vector163:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $163
  10247a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10247f:	e9 be f9 ff ff       	jmp    101e42 <__alltraps>

00102484 <vector164>:
.globl vector164
vector164:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $164
  102486:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10248b:	e9 b2 f9 ff ff       	jmp    101e42 <__alltraps>

00102490 <vector165>:
.globl vector165
vector165:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $165
  102492:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102497:	e9 a6 f9 ff ff       	jmp    101e42 <__alltraps>

0010249c <vector166>:
.globl vector166
vector166:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $166
  10249e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024a3:	e9 9a f9 ff ff       	jmp    101e42 <__alltraps>

001024a8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $167
  1024aa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024af:	e9 8e f9 ff ff       	jmp    101e42 <__alltraps>

001024b4 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $168
  1024b6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024bb:	e9 82 f9 ff ff       	jmp    101e42 <__alltraps>

001024c0 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $169
  1024c2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024c7:	e9 76 f9 ff ff       	jmp    101e42 <__alltraps>

001024cc <vector170>:
.globl vector170
vector170:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $170
  1024ce:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024d3:	e9 6a f9 ff ff       	jmp    101e42 <__alltraps>

001024d8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $171
  1024da:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024df:	e9 5e f9 ff ff       	jmp    101e42 <__alltraps>

001024e4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $172
  1024e6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024eb:	e9 52 f9 ff ff       	jmp    101e42 <__alltraps>

001024f0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $173
  1024f2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024f7:	e9 46 f9 ff ff       	jmp    101e42 <__alltraps>

001024fc <vector174>:
.globl vector174
vector174:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $174
  1024fe:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102503:	e9 3a f9 ff ff       	jmp    101e42 <__alltraps>

00102508 <vector175>:
.globl vector175
vector175:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $175
  10250a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10250f:	e9 2e f9 ff ff       	jmp    101e42 <__alltraps>

00102514 <vector176>:
.globl vector176
vector176:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $176
  102516:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10251b:	e9 22 f9 ff ff       	jmp    101e42 <__alltraps>

00102520 <vector177>:
.globl vector177
vector177:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $177
  102522:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102527:	e9 16 f9 ff ff       	jmp    101e42 <__alltraps>

0010252c <vector178>:
.globl vector178
vector178:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $178
  10252e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102533:	e9 0a f9 ff ff       	jmp    101e42 <__alltraps>

00102538 <vector179>:
.globl vector179
vector179:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $179
  10253a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10253f:	e9 fe f8 ff ff       	jmp    101e42 <__alltraps>

00102544 <vector180>:
.globl vector180
vector180:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $180
  102546:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10254b:	e9 f2 f8 ff ff       	jmp    101e42 <__alltraps>

00102550 <vector181>:
.globl vector181
vector181:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $181
  102552:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102557:	e9 e6 f8 ff ff       	jmp    101e42 <__alltraps>

0010255c <vector182>:
.globl vector182
vector182:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $182
  10255e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102563:	e9 da f8 ff ff       	jmp    101e42 <__alltraps>

00102568 <vector183>:
.globl vector183
vector183:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $183
  10256a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10256f:	e9 ce f8 ff ff       	jmp    101e42 <__alltraps>

00102574 <vector184>:
.globl vector184
vector184:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $184
  102576:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10257b:	e9 c2 f8 ff ff       	jmp    101e42 <__alltraps>

00102580 <vector185>:
.globl vector185
vector185:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $185
  102582:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102587:	e9 b6 f8 ff ff       	jmp    101e42 <__alltraps>

0010258c <vector186>:
.globl vector186
vector186:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $186
  10258e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102593:	e9 aa f8 ff ff       	jmp    101e42 <__alltraps>

00102598 <vector187>:
.globl vector187
vector187:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $187
  10259a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10259f:	e9 9e f8 ff ff       	jmp    101e42 <__alltraps>

001025a4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $188
  1025a6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025ab:	e9 92 f8 ff ff       	jmp    101e42 <__alltraps>

001025b0 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $189
  1025b2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025b7:	e9 86 f8 ff ff       	jmp    101e42 <__alltraps>

001025bc <vector190>:
.globl vector190
vector190:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $190
  1025be:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025c3:	e9 7a f8 ff ff       	jmp    101e42 <__alltraps>

001025c8 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $191
  1025ca:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025cf:	e9 6e f8 ff ff       	jmp    101e42 <__alltraps>

001025d4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $192
  1025d6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025db:	e9 62 f8 ff ff       	jmp    101e42 <__alltraps>

001025e0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $193
  1025e2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025e7:	e9 56 f8 ff ff       	jmp    101e42 <__alltraps>

001025ec <vector194>:
.globl vector194
vector194:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $194
  1025ee:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025f3:	e9 4a f8 ff ff       	jmp    101e42 <__alltraps>

001025f8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $195
  1025fa:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025ff:	e9 3e f8 ff ff       	jmp    101e42 <__alltraps>

00102604 <vector196>:
.globl vector196
vector196:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $196
  102606:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10260b:	e9 32 f8 ff ff       	jmp    101e42 <__alltraps>

00102610 <vector197>:
.globl vector197
vector197:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $197
  102612:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102617:	e9 26 f8 ff ff       	jmp    101e42 <__alltraps>

0010261c <vector198>:
.globl vector198
vector198:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $198
  10261e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102623:	e9 1a f8 ff ff       	jmp    101e42 <__alltraps>

00102628 <vector199>:
.globl vector199
vector199:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $199
  10262a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10262f:	e9 0e f8 ff ff       	jmp    101e42 <__alltraps>

00102634 <vector200>:
.globl vector200
vector200:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $200
  102636:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10263b:	e9 02 f8 ff ff       	jmp    101e42 <__alltraps>

00102640 <vector201>:
.globl vector201
vector201:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $201
  102642:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102647:	e9 f6 f7 ff ff       	jmp    101e42 <__alltraps>

0010264c <vector202>:
.globl vector202
vector202:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $202
  10264e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102653:	e9 ea f7 ff ff       	jmp    101e42 <__alltraps>

00102658 <vector203>:
.globl vector203
vector203:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $203
  10265a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10265f:	e9 de f7 ff ff       	jmp    101e42 <__alltraps>

00102664 <vector204>:
.globl vector204
vector204:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $204
  102666:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10266b:	e9 d2 f7 ff ff       	jmp    101e42 <__alltraps>

00102670 <vector205>:
.globl vector205
vector205:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $205
  102672:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102677:	e9 c6 f7 ff ff       	jmp    101e42 <__alltraps>

0010267c <vector206>:
.globl vector206
vector206:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $206
  10267e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102683:	e9 ba f7 ff ff       	jmp    101e42 <__alltraps>

00102688 <vector207>:
.globl vector207
vector207:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $207
  10268a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10268f:	e9 ae f7 ff ff       	jmp    101e42 <__alltraps>

00102694 <vector208>:
.globl vector208
vector208:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $208
  102696:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10269b:	e9 a2 f7 ff ff       	jmp    101e42 <__alltraps>

001026a0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $209
  1026a2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026a7:	e9 96 f7 ff ff       	jmp    101e42 <__alltraps>

001026ac <vector210>:
.globl vector210
vector210:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $210
  1026ae:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026b3:	e9 8a f7 ff ff       	jmp    101e42 <__alltraps>

001026b8 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $211
  1026ba:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026bf:	e9 7e f7 ff ff       	jmp    101e42 <__alltraps>

001026c4 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $212
  1026c6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026cb:	e9 72 f7 ff ff       	jmp    101e42 <__alltraps>

001026d0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $213
  1026d2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026d7:	e9 66 f7 ff ff       	jmp    101e42 <__alltraps>

001026dc <vector214>:
.globl vector214
vector214:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $214
  1026de:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026e3:	e9 5a f7 ff ff       	jmp    101e42 <__alltraps>

001026e8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $215
  1026ea:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026ef:	e9 4e f7 ff ff       	jmp    101e42 <__alltraps>

001026f4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $216
  1026f6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026fb:	e9 42 f7 ff ff       	jmp    101e42 <__alltraps>

00102700 <vector217>:
.globl vector217
vector217:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $217
  102702:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102707:	e9 36 f7 ff ff       	jmp    101e42 <__alltraps>

0010270c <vector218>:
.globl vector218
vector218:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $218
  10270e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102713:	e9 2a f7 ff ff       	jmp    101e42 <__alltraps>

00102718 <vector219>:
.globl vector219
vector219:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $219
  10271a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10271f:	e9 1e f7 ff ff       	jmp    101e42 <__alltraps>

00102724 <vector220>:
.globl vector220
vector220:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $220
  102726:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10272b:	e9 12 f7 ff ff       	jmp    101e42 <__alltraps>

00102730 <vector221>:
.globl vector221
vector221:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $221
  102732:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102737:	e9 06 f7 ff ff       	jmp    101e42 <__alltraps>

0010273c <vector222>:
.globl vector222
vector222:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $222
  10273e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102743:	e9 fa f6 ff ff       	jmp    101e42 <__alltraps>

00102748 <vector223>:
.globl vector223
vector223:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $223
  10274a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10274f:	e9 ee f6 ff ff       	jmp    101e42 <__alltraps>

00102754 <vector224>:
.globl vector224
vector224:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $224
  102756:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10275b:	e9 e2 f6 ff ff       	jmp    101e42 <__alltraps>

00102760 <vector225>:
.globl vector225
vector225:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $225
  102762:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102767:	e9 d6 f6 ff ff       	jmp    101e42 <__alltraps>

0010276c <vector226>:
.globl vector226
vector226:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $226
  10276e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102773:	e9 ca f6 ff ff       	jmp    101e42 <__alltraps>

00102778 <vector227>:
.globl vector227
vector227:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $227
  10277a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10277f:	e9 be f6 ff ff       	jmp    101e42 <__alltraps>

00102784 <vector228>:
.globl vector228
vector228:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $228
  102786:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10278b:	e9 b2 f6 ff ff       	jmp    101e42 <__alltraps>

00102790 <vector229>:
.globl vector229
vector229:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $229
  102792:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102797:	e9 a6 f6 ff ff       	jmp    101e42 <__alltraps>

0010279c <vector230>:
.globl vector230
vector230:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $230
  10279e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027a3:	e9 9a f6 ff ff       	jmp    101e42 <__alltraps>

001027a8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $231
  1027aa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027af:	e9 8e f6 ff ff       	jmp    101e42 <__alltraps>

001027b4 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $232
  1027b6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027bb:	e9 82 f6 ff ff       	jmp    101e42 <__alltraps>

001027c0 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $233
  1027c2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027c7:	e9 76 f6 ff ff       	jmp    101e42 <__alltraps>

001027cc <vector234>:
.globl vector234
vector234:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $234
  1027ce:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027d3:	e9 6a f6 ff ff       	jmp    101e42 <__alltraps>

001027d8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $235
  1027da:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027df:	e9 5e f6 ff ff       	jmp    101e42 <__alltraps>

001027e4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $236
  1027e6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027eb:	e9 52 f6 ff ff       	jmp    101e42 <__alltraps>

001027f0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $237
  1027f2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027f7:	e9 46 f6 ff ff       	jmp    101e42 <__alltraps>

001027fc <vector238>:
.globl vector238
vector238:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $238
  1027fe:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102803:	e9 3a f6 ff ff       	jmp    101e42 <__alltraps>

00102808 <vector239>:
.globl vector239
vector239:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $239
  10280a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10280f:	e9 2e f6 ff ff       	jmp    101e42 <__alltraps>

00102814 <vector240>:
.globl vector240
vector240:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $240
  102816:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10281b:	e9 22 f6 ff ff       	jmp    101e42 <__alltraps>

00102820 <vector241>:
.globl vector241
vector241:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $241
  102822:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102827:	e9 16 f6 ff ff       	jmp    101e42 <__alltraps>

0010282c <vector242>:
.globl vector242
vector242:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $242
  10282e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102833:	e9 0a f6 ff ff       	jmp    101e42 <__alltraps>

00102838 <vector243>:
.globl vector243
vector243:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $243
  10283a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10283f:	e9 fe f5 ff ff       	jmp    101e42 <__alltraps>

00102844 <vector244>:
.globl vector244
vector244:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $244
  102846:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10284b:	e9 f2 f5 ff ff       	jmp    101e42 <__alltraps>

00102850 <vector245>:
.globl vector245
vector245:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $245
  102852:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102857:	e9 e6 f5 ff ff       	jmp    101e42 <__alltraps>

0010285c <vector246>:
.globl vector246
vector246:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $246
  10285e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102863:	e9 da f5 ff ff       	jmp    101e42 <__alltraps>

00102868 <vector247>:
.globl vector247
vector247:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $247
  10286a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10286f:	e9 ce f5 ff ff       	jmp    101e42 <__alltraps>

00102874 <vector248>:
.globl vector248
vector248:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $248
  102876:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10287b:	e9 c2 f5 ff ff       	jmp    101e42 <__alltraps>

00102880 <vector249>:
.globl vector249
vector249:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $249
  102882:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102887:	e9 b6 f5 ff ff       	jmp    101e42 <__alltraps>

0010288c <vector250>:
.globl vector250
vector250:
  pushl $0
  10288c:	6a 00                	push   $0x0
  pushl $250
  10288e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102893:	e9 aa f5 ff ff       	jmp    101e42 <__alltraps>

00102898 <vector251>:
.globl vector251
vector251:
  pushl $0
  102898:	6a 00                	push   $0x0
  pushl $251
  10289a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10289f:	e9 9e f5 ff ff       	jmp    101e42 <__alltraps>

001028a4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028a4:	6a 00                	push   $0x0
  pushl $252
  1028a6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028ab:	e9 92 f5 ff ff       	jmp    101e42 <__alltraps>

001028b0 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028b0:	6a 00                	push   $0x0
  pushl $253
  1028b2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028b7:	e9 86 f5 ff ff       	jmp    101e42 <__alltraps>

001028bc <vector254>:
.globl vector254
vector254:
  pushl $0
  1028bc:	6a 00                	push   $0x0
  pushl $254
  1028be:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028c3:	e9 7a f5 ff ff       	jmp    101e42 <__alltraps>

001028c8 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028c8:	6a 00                	push   $0x0
  pushl $255
  1028ca:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028cf:	e9 6e f5 ff ff       	jmp    101e42 <__alltraps>

001028d4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028d4:	55                   	push   %ebp
  1028d5:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1028da:	a1 64 89 11 00       	mov    0x118964,%eax
  1028df:	29 c2                	sub    %eax,%edx
  1028e1:	89 d0                	mov    %edx,%eax
  1028e3:	c1 f8 02             	sar    $0x2,%eax
  1028e6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028ec:	5d                   	pop    %ebp
  1028ed:	c3                   	ret    

001028ee <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028ee:	55                   	push   %ebp
  1028ef:	89 e5                	mov    %esp,%ebp
  1028f1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f7:	89 04 24             	mov    %eax,(%esp)
  1028fa:	e8 d5 ff ff ff       	call   1028d4 <page2ppn>
  1028ff:	c1 e0 0c             	shl    $0xc,%eax
}
  102902:	c9                   	leave  
  102903:	c3                   	ret    

00102904 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102904:	55                   	push   %ebp
  102905:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102907:	8b 45 08             	mov    0x8(%ebp),%eax
  10290a:	8b 00                	mov    (%eax),%eax
}
  10290c:	5d                   	pop    %ebp
  10290d:	c3                   	ret    

0010290e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10290e:	55                   	push   %ebp
  10290f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102911:	8b 45 08             	mov    0x8(%ebp),%eax
  102914:	8b 55 0c             	mov    0xc(%ebp),%edx
  102917:	89 10                	mov    %edx,(%eax)
}
  102919:	5d                   	pop    %ebp
  10291a:	c3                   	ret    

0010291b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10291b:	55                   	push   %ebp
  10291c:	89 e5                	mov    %esp,%ebp
  10291e:	83 ec 10             	sub    $0x10,%esp
  102921:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10292b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10292e:	89 50 04             	mov    %edx,0x4(%eax)
  102931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102934:	8b 50 04             	mov    0x4(%eax),%edx
  102937:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10293a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10293c:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102943:	00 00 00 
}
  102946:	c9                   	leave  
  102947:	c3                   	ret    

00102948 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102948:	55                   	push   %ebp
  102949:	89 e5                	mov    %esp,%ebp
  10294b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10294e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102952:	75 24                	jne    102978 <default_init_memmap+0x30>
  102954:	c7 44 24 0c 50 67 10 	movl   $0x106750,0xc(%esp)
  10295b:	00 
  10295c:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102963:	00 
  102964:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10296b:	00 
  10296c:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102973:	e8 69 e3 ff ff       	call   100ce1 <__panic>
    struct Page *p = base;
  102978:	8b 45 08             	mov    0x8(%ebp),%eax
  10297b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10297e:	eb 7d                	jmp    1029fd <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102983:	83 c0 04             	add    $0x4,%eax
  102986:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10298d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102993:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102996:	0f a3 10             	bt     %edx,(%eax)
  102999:	19 c0                	sbb    %eax,%eax
  10299b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10299e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029a2:	0f 95 c0             	setne  %al
  1029a5:	0f b6 c0             	movzbl %al,%eax
  1029a8:	85 c0                	test   %eax,%eax
  1029aa:	75 24                	jne    1029d0 <default_init_memmap+0x88>
  1029ac:	c7 44 24 0c 81 67 10 	movl   $0x106781,0xc(%esp)
  1029b3:	00 
  1029b4:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1029bb:	00 
  1029bc:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1029c3:	00 
  1029c4:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1029cb:	e8 11 e3 ff ff       	call   100ce1 <__panic>
        p->flags = p->property = 0;
  1029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029dd:	8b 50 08             	mov    0x8(%eax),%edx
  1029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e3:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029ed:	00 
  1029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f1:	89 04 24             	mov    %eax,(%esp)
  1029f4:	e8 15 ff ff ff       	call   10290e <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029f9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a00:	89 d0                	mov    %edx,%eax
  102a02:	c1 e0 02             	shl    $0x2,%eax
  102a05:	01 d0                	add    %edx,%eax
  102a07:	c1 e0 02             	shl    $0x2,%eax
  102a0a:	89 c2                	mov    %eax,%edx
  102a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0f:	01 d0                	add    %edx,%eax
  102a11:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a14:	0f 85 66 ff ff ff    	jne    102980 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a20:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a23:	8b 45 08             	mov    0x8(%ebp),%eax
  102a26:	83 c0 04             	add    $0x4,%eax
  102a29:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a39:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102a3c:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a45:	01 d0                	add    %edx,%eax
  102a47:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add(&free_list, &(base->page_link));
  102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4f:	83 c0 0c             	add    $0xc,%eax
  102a52:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102a59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a65:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a6b:	8b 40 04             	mov    0x4(%eax),%eax
  102a6e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a71:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102a74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a77:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102a7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a80:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a83:	89 10                	mov    %edx,(%eax)
  102a85:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a88:	8b 10                	mov    (%eax),%edx
  102a8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a93:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a96:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a9c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a9f:	89 10                	mov    %edx,(%eax)
}
  102aa1:	c9                   	leave  
  102aa2:	c3                   	ret    

00102aa3 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102aa3:	55                   	push   %ebp
  102aa4:	89 e5                	mov    %esp,%ebp
  102aa6:	83 ec 68             	sub    $0x68,%esp
    
    assert(n > 0);
  102aa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aad:	75 24                	jne    102ad3 <default_alloc_pages+0x30>
  102aaf:	c7 44 24 0c 50 67 10 	movl   $0x106750,0xc(%esp)
  102ab6:	00 
  102ab7:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102abe:	00 
  102abf:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  102ac6:	00 
  102ac7:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102ace:	e8 0e e2 ff ff       	call   100ce1 <__panic>
    if (n > nr_free) {
  102ad3:	a1 58 89 11 00       	mov    0x118958,%eax
  102ad8:	3b 45 08             	cmp    0x8(%ebp),%eax
  102adb:	73 0a                	jae    102ae7 <default_alloc_pages+0x44>
        return NULL;
  102add:	b8 00 00 00 00       	mov    $0x0,%eax
  102ae2:	e9 54 01 00 00       	jmp    102c3b <default_alloc_pages+0x198>
    }
    struct Page *page = NULL;
  102ae7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102aee:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102af5:	eb 1c                	jmp    102b13 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102afa:	83 e8 0c             	sub    $0xc,%eax
  102afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b03:	8b 40 08             	mov    0x8(%eax),%eax
  102b06:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b09:	72 08                	jb     102b13 <default_alloc_pages+0x70>
            page = p;
  102b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b11:	eb 18                	jmp    102b2b <default_alloc_pages+0x88>
  102b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b1c:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b22:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102b29:	75 cc                	jne    102af7 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if(page != NULL){
  102b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b2f:	0f 84 03 01 00 00    	je     102c38 <default_alloc_pages+0x195>
  102b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b3e:	8b 00                	mov    (%eax),%eax
        le = list_prev(le);
  102b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(page->property > n){
  102b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b46:	8b 40 08             	mov    0x8(%eax),%eax
  102b49:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b4c:	0f 86 95 00 00 00    	jbe    102be7 <default_alloc_pages+0x144>
            struct Page *p = page + n;
  102b52:	8b 55 08             	mov    0x8(%ebp),%edx
  102b55:	89 d0                	mov    %edx,%eax
  102b57:	c1 e0 02             	shl    $0x2,%eax
  102b5a:	01 d0                	add    %edx,%eax
  102b5c:	c1 e0 02             	shl    $0x2,%eax
  102b5f:	89 c2                	mov    %eax,%edx
  102b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b64:	01 d0                	add    %edx,%eax
  102b66:	89 45 e8             	mov    %eax,-0x18(%ebp)
            SetPageProperty(p);
  102b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b6c:	83 c0 04             	add    $0x4,%eax
  102b6f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102b76:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b7f:	0f ab 10             	bts    %edx,(%eax)
            p->property = page->property - n;
  102b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b85:	8b 40 08             	mov    0x8(%eax),%eax
  102b88:	2b 45 08             	sub    0x8(%ebp),%eax
  102b8b:	89 c2                	mov    %eax,%edx
  102b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b90:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(le, &(p->page_link));
  102b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b96:	8d 50 0c             	lea    0xc(%eax),%edx
  102b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102b9f:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102ba2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ba5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102ba8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102bab:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102bae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102bb1:	8b 40 04             	mov    0x4(%eax),%eax
  102bb4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102bb7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102bba:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bbd:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102bc0:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102bc3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bc6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102bc9:	89 10                	mov    %edx,(%eax)
  102bcb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bce:	8b 10                	mov    (%eax),%edx
  102bd0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102bd3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bd6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bd9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102bdc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bdf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102be2:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102be5:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  102be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bea:	83 c0 0c             	add    $0xc,%eax
  102bed:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102bf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102bf3:	8b 40 04             	mov    0x4(%eax),%eax
  102bf6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bf9:	8b 12                	mov    (%edx),%edx
  102bfb:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  102bfe:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c04:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c07:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c0d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102c10:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  102c12:	a1 58 89 11 00       	mov    0x118958,%eax
  102c17:	2b 45 08             	sub    0x8(%ebp),%eax
  102c1a:	a3 58 89 11 00       	mov    %eax,0x118958
        ClearPageProperty(page);
  102c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c22:	83 c0 04             	add    $0x4,%eax
  102c25:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  102c2c:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c2f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c32:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102c35:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c3b:	c9                   	leave  
  102c3c:	c3                   	ret    

00102c3d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c3d:	55                   	push   %ebp
  102c3e:	89 e5                	mov    %esp,%ebp
  102c40:	81 ec 88 00 00 00    	sub    $0x88,%esp
    struct Page *p = base;
  102c46:	8b 45 08             	mov    0x8(%ebp),%eax
  102c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c4c:	e9 9d 00 00 00       	jmp    102cee <default_free_pages+0xb1>
        assert(!PageReserved(p) && !PageProperty(p));
  102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c54:	83 c0 04             	add    $0x4,%eax
  102c57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c67:	0f a3 10             	bt     %edx,(%eax)
  102c6a:	19 c0                	sbb    %eax,%eax
  102c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c73:	0f 95 c0             	setne  %al
  102c76:	0f b6 c0             	movzbl %al,%eax
  102c79:	85 c0                	test   %eax,%eax
  102c7b:	75 2c                	jne    102ca9 <default_free_pages+0x6c>
  102c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c80:	83 c0 04             	add    $0x4,%eax
  102c83:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c93:	0f a3 10             	bt     %edx,(%eax)
  102c96:	19 c0                	sbb    %eax,%eax
  102c98:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102c9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102c9f:	0f 95 c0             	setne  %al
  102ca2:	0f b6 c0             	movzbl %al,%eax
  102ca5:	85 c0                	test   %eax,%eax
  102ca7:	74 24                	je     102ccd <default_free_pages+0x90>
  102ca9:	c7 44 24 0c 94 67 10 	movl   $0x106794,0xc(%esp)
  102cb0:	00 
  102cb1:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102cb8:	00 
  102cb9:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  102cc0:	00 
  102cc1:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102cc8:	e8 14 e0 ff ff       	call   100ce1 <__panic>
        p->flags = 0;
  102ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102cd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cde:	00 
  102cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce2:	89 04 24             	mov    %eax,(%esp)
  102ce5:	e8 24 fc ff ff       	call   10290e <set_page_ref>
}

static void
default_free_pages(struct Page *base, size_t n) {
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102cea:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cf1:	89 d0                	mov    %edx,%eax
  102cf3:	c1 e0 02             	shl    $0x2,%eax
  102cf6:	01 d0                	add    %edx,%eax
  102cf8:	c1 e0 02             	shl    $0x2,%eax
  102cfb:	89 c2                	mov    %eax,%edx
  102cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102d00:	01 d0                	add    %edx,%eax
  102d02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d05:	0f 85 46 ff ff ff    	jne    102c51 <default_free_pages+0x14>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d11:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102d14:	8b 45 08             	mov    0x8(%ebp),%eax
  102d17:	83 c0 04             	add    $0x4,%eax
  102d1a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102d21:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d24:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d2a:	0f ab 10             	bts    %edx,(%eax)
  102d2d:	c7 45 cc 50 89 11 00 	movl   $0x118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d37:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102d3d:	e9 26 01 00 00       	jmp    102e68 <default_free_pages+0x22b>
        p = le2page(le, page_link);
  102d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d45:	83 e8 0c             	sub    $0xc,%eax
  102d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
  102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4e:	8b 50 08             	mov    0x8(%eax),%edx
  102d51:	89 d0                	mov    %edx,%eax
  102d53:	c1 e0 02             	shl    $0x2,%eax
  102d56:	01 d0                	add    %edx,%eax
  102d58:	c1 e0 02             	shl    $0x2,%eax
  102d5b:	89 c2                	mov    %eax,%edx
  102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d60:	01 d0                	add    %edx,%eax
  102d62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d65:	75 6c                	jne    102dd3 <default_free_pages+0x196>
            base->property += p->property;
  102d67:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6a:	8b 50 08             	mov    0x8(%eax),%edx
  102d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d70:	8b 40 08             	mov    0x8(%eax),%eax
  102d73:	01 c2                	add    %eax,%edx
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7e:	83 c0 04             	add    $0x4,%eax
  102d81:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d88:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d8b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d8e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d91:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d97:	83 c0 0c             	add    $0xc,%eax
  102d9a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102da0:	8b 40 04             	mov    0x4(%eax),%eax
  102da3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102da6:	8b 12                	mov    (%edx),%edx
  102da8:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102dab:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102dae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102db1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102db4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102db7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dba:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dbd:	89 10                	mov    %edx,(%eax)
  102dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102dc5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102dc8:	8b 40 04             	mov    0x4(%eax),%eax
            le = list_next(le);
  102dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  102dce:	e9 a2 00 00 00       	jmp    102e75 <default_free_pages+0x238>
        }
        else if (p + p->property == base) {
  102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd6:	8b 50 08             	mov    0x8(%eax),%edx
  102dd9:	89 d0                	mov    %edx,%eax
  102ddb:	c1 e0 02             	shl    $0x2,%eax
  102dde:	01 d0                	add    %edx,%eax
  102de0:	c1 e0 02             	shl    $0x2,%eax
  102de3:	89 c2                	mov    %eax,%edx
  102de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de8:	01 d0                	add    %edx,%eax
  102dea:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ded:	75 60                	jne    102e4f <default_free_pages+0x212>
            p->property += base->property;
  102def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df2:	8b 50 08             	mov    0x8(%eax),%edx
  102df5:	8b 45 08             	mov    0x8(%ebp),%eax
  102df8:	8b 40 08             	mov    0x8(%eax),%eax
  102dfb:	01 c2                	add    %eax,%edx
  102dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e00:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e03:	8b 45 08             	mov    0x8(%ebp),%eax
  102e06:	83 c0 04             	add    $0x4,%eax
  102e09:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102e10:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102e13:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e16:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e19:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e1f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e25:	83 c0 0c             	add    $0xc,%eax
  102e28:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e2b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e2e:	8b 40 04             	mov    0x4(%eax),%eax
  102e31:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e34:	8b 12                	mov    (%edx),%edx
  102e36:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e39:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e3c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e3f:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102e42:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e45:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e48:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e4b:	89 10                	mov    %edx,(%eax)
  102e4d:	eb 0a                	jmp    102e59 <default_free_pages+0x21c>
        }
        else if(p > base){
  102e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e52:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e55:	76 02                	jbe    102e59 <default_free_pages+0x21c>
            //le = list_prev(le);
            break;
  102e57:	eb 1c                	jmp    102e75 <default_free_pages+0x238>
  102e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e5c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102e5f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e62:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
  102e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102e68:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102e6f:	0f 85 cd fe ff ff    	jne    102d42 <default_free_pages+0x105>
            //le = list_prev(le);
            break;
        }
        le = list_next(le);
    }
    nr_free += n;
  102e75:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e7e:	01 d0                	add    %edx,%eax
  102e80:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add_before(le, &(base->page_link));
  102e85:	8b 45 08             	mov    0x8(%ebp),%eax
  102e88:	8d 50 0c             	lea    0xc(%eax),%edx
  102e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e8e:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e91:	89 55 94             	mov    %edx,-0x6c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102e94:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e97:	8b 00                	mov    (%eax),%eax
  102e99:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102e9c:	89 55 90             	mov    %edx,-0x70(%ebp)
  102e9f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  102ea2:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ea5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ea8:	8b 45 88             	mov    -0x78(%ebp),%eax
  102eab:	8b 55 90             	mov    -0x70(%ebp),%edx
  102eae:	89 10                	mov    %edx,(%eax)
  102eb0:	8b 45 88             	mov    -0x78(%ebp),%eax
  102eb3:	8b 10                	mov    (%eax),%edx
  102eb5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102eb8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ebb:	8b 45 90             	mov    -0x70(%ebp),%eax
  102ebe:	8b 55 88             	mov    -0x78(%ebp),%edx
  102ec1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ec4:	8b 45 90             	mov    -0x70(%ebp),%eax
  102ec7:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102eca:	89 10                	mov    %edx,(%eax)
}
  102ecc:	c9                   	leave  
  102ecd:	c3                   	ret    

00102ece <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102ece:	55                   	push   %ebp
  102ecf:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102ed1:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102ed6:	5d                   	pop    %ebp
  102ed7:	c3                   	ret    

00102ed8 <basic_check>:

static void
basic_check(void) {
  102ed8:	55                   	push   %ebp
  102ed9:	89 e5                	mov    %esp,%ebp
  102edb:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102ede:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102ef1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ef8:	e8 85 0e 00 00       	call   103d82 <alloc_pages>
  102efd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f04:	75 24                	jne    102f2a <basic_check+0x52>
  102f06:	c7 44 24 0c b9 67 10 	movl   $0x1067b9,0xc(%esp)
  102f0d:	00 
  102f0e:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102f15:	00 
  102f16:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  102f1d:	00 
  102f1e:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102f25:	e8 b7 dd ff ff       	call   100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f31:	e8 4c 0e 00 00       	call   103d82 <alloc_pages>
  102f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f3d:	75 24                	jne    102f63 <basic_check+0x8b>
  102f3f:	c7 44 24 0c d5 67 10 	movl   $0x1067d5,0xc(%esp)
  102f46:	00 
  102f47:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102f4e:	00 
  102f4f:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102f56:	00 
  102f57:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102f5e:	e8 7e dd ff ff       	call   100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f6a:	e8 13 0e 00 00       	call   103d82 <alloc_pages>
  102f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f76:	75 24                	jne    102f9c <basic_check+0xc4>
  102f78:	c7 44 24 0c f1 67 10 	movl   $0x1067f1,0xc(%esp)
  102f7f:	00 
  102f80:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102f87:	00 
  102f88:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  102f8f:	00 
  102f90:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102f97:	e8 45 dd ff ff       	call   100ce1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102fa2:	74 10                	je     102fb4 <basic_check+0xdc>
  102fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102faa:	74 08                	je     102fb4 <basic_check+0xdc>
  102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102faf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102fb2:	75 24                	jne    102fd8 <basic_check+0x100>
  102fb4:	c7 44 24 0c 10 68 10 	movl   $0x106810,0xc(%esp)
  102fbb:	00 
  102fbc:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  102fc3:	00 
  102fc4:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  102fcb:	00 
  102fcc:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  102fd3:	e8 09 dd ff ff       	call   100ce1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fdb:	89 04 24             	mov    %eax,(%esp)
  102fde:	e8 21 f9 ff ff       	call   102904 <page_ref>
  102fe3:	85 c0                	test   %eax,%eax
  102fe5:	75 1e                	jne    103005 <basic_check+0x12d>
  102fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fea:	89 04 24             	mov    %eax,(%esp)
  102fed:	e8 12 f9 ff ff       	call   102904 <page_ref>
  102ff2:	85 c0                	test   %eax,%eax
  102ff4:	75 0f                	jne    103005 <basic_check+0x12d>
  102ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ff9:	89 04 24             	mov    %eax,(%esp)
  102ffc:	e8 03 f9 ff ff       	call   102904 <page_ref>
  103001:	85 c0                	test   %eax,%eax
  103003:	74 24                	je     103029 <basic_check+0x151>
  103005:	c7 44 24 0c 34 68 10 	movl   $0x106834,0xc(%esp)
  10300c:	00 
  10300d:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103014:	00 
  103015:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  10301c:	00 
  10301d:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103024:	e8 b8 dc ff ff       	call   100ce1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10302c:	89 04 24             	mov    %eax,(%esp)
  10302f:	e8 ba f8 ff ff       	call   1028ee <page2pa>
  103034:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10303a:	c1 e2 0c             	shl    $0xc,%edx
  10303d:	39 d0                	cmp    %edx,%eax
  10303f:	72 24                	jb     103065 <basic_check+0x18d>
  103041:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  103048:	00 
  103049:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103050:	00 
  103051:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  103058:	00 
  103059:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103060:	e8 7c dc ff ff       	call   100ce1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103068:	89 04 24             	mov    %eax,(%esp)
  10306b:	e8 7e f8 ff ff       	call   1028ee <page2pa>
  103070:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103076:	c1 e2 0c             	shl    $0xc,%edx
  103079:	39 d0                	cmp    %edx,%eax
  10307b:	72 24                	jb     1030a1 <basic_check+0x1c9>
  10307d:	c7 44 24 0c 8d 68 10 	movl   $0x10688d,0xc(%esp)
  103084:	00 
  103085:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10308c:	00 
  10308d:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  103094:	00 
  103095:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10309c:	e8 40 dc ff ff       	call   100ce1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030a4:	89 04 24             	mov    %eax,(%esp)
  1030a7:	e8 42 f8 ff ff       	call   1028ee <page2pa>
  1030ac:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1030b2:	c1 e2 0c             	shl    $0xc,%edx
  1030b5:	39 d0                	cmp    %edx,%eax
  1030b7:	72 24                	jb     1030dd <basic_check+0x205>
  1030b9:	c7 44 24 0c aa 68 10 	movl   $0x1068aa,0xc(%esp)
  1030c0:	00 
  1030c1:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1030c8:	00 
  1030c9:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  1030d0:	00 
  1030d1:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1030d8:	e8 04 dc ff ff       	call   100ce1 <__panic>

    list_entry_t free_list_store = free_list;
  1030dd:	a1 50 89 11 00       	mov    0x118950,%eax
  1030e2:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1030e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030ee:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1030f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1030fb:	89 50 04             	mov    %edx,0x4(%eax)
  1030fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103101:	8b 50 04             	mov    0x4(%eax),%edx
  103104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103107:	89 10                	mov    %edx,(%eax)
  103109:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103110:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103113:	8b 40 04             	mov    0x4(%eax),%eax
  103116:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103119:	0f 94 c0             	sete   %al
  10311c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10311f:	85 c0                	test   %eax,%eax
  103121:	75 24                	jne    103147 <basic_check+0x26f>
  103123:	c7 44 24 0c c7 68 10 	movl   $0x1068c7,0xc(%esp)
  10312a:	00 
  10312b:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103132:	00 
  103133:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  10313a:	00 
  10313b:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103142:	e8 9a db ff ff       	call   100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
  103147:	a1 58 89 11 00       	mov    0x118958,%eax
  10314c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10314f:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103156:	00 00 00 

    assert(alloc_page() == NULL);
  103159:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103160:	e8 1d 0c 00 00       	call   103d82 <alloc_pages>
  103165:	85 c0                	test   %eax,%eax
  103167:	74 24                	je     10318d <basic_check+0x2b5>
  103169:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  103170:	00 
  103171:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103178:	00 
  103179:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  103180:	00 
  103181:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103188:	e8 54 db ff ff       	call   100ce1 <__panic>

    free_page(p0);
  10318d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103194:	00 
  103195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103198:	89 04 24             	mov    %eax,(%esp)
  10319b:	e8 1a 0c 00 00       	call   103dba <free_pages>
    free_page(p1);
  1031a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031a7:	00 
  1031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031ab:	89 04 24             	mov    %eax,(%esp)
  1031ae:	e8 07 0c 00 00       	call   103dba <free_pages>
    free_page(p2);
  1031b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031ba:	00 
  1031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031be:	89 04 24             	mov    %eax,(%esp)
  1031c1:	e8 f4 0b 00 00       	call   103dba <free_pages>
    assert(nr_free == 3);
  1031c6:	a1 58 89 11 00       	mov    0x118958,%eax
  1031cb:	83 f8 03             	cmp    $0x3,%eax
  1031ce:	74 24                	je     1031f4 <basic_check+0x31c>
  1031d0:	c7 44 24 0c f3 68 10 	movl   $0x1068f3,0xc(%esp)
  1031d7:	00 
  1031d8:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1031df:	00 
  1031e0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  1031e7:	00 
  1031e8:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1031ef:	e8 ed da ff ff       	call   100ce1 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1031f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031fb:	e8 82 0b 00 00       	call   103d82 <alloc_pages>
  103200:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103203:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103207:	75 24                	jne    10322d <basic_check+0x355>
  103209:	c7 44 24 0c b9 67 10 	movl   $0x1067b9,0xc(%esp)
  103210:	00 
  103211:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103218:	00 
  103219:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  103220:	00 
  103221:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103228:	e8 b4 da ff ff       	call   100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10322d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103234:	e8 49 0b 00 00       	call   103d82 <alloc_pages>
  103239:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10323c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103240:	75 24                	jne    103266 <basic_check+0x38e>
  103242:	c7 44 24 0c d5 67 10 	movl   $0x1067d5,0xc(%esp)
  103249:	00 
  10324a:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103251:	00 
  103252:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  103259:	00 
  10325a:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103261:	e8 7b da ff ff       	call   100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103266:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10326d:	e8 10 0b 00 00       	call   103d82 <alloc_pages>
  103272:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103279:	75 24                	jne    10329f <basic_check+0x3c7>
  10327b:	c7 44 24 0c f1 67 10 	movl   $0x1067f1,0xc(%esp)
  103282:	00 
  103283:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10328a:	00 
  10328b:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  103292:	00 
  103293:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10329a:	e8 42 da ff ff       	call   100ce1 <__panic>

    assert(alloc_page() == NULL);
  10329f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032a6:	e8 d7 0a 00 00       	call   103d82 <alloc_pages>
  1032ab:	85 c0                	test   %eax,%eax
  1032ad:	74 24                	je     1032d3 <basic_check+0x3fb>
  1032af:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  1032b6:	00 
  1032b7:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1032be:	00 
  1032bf:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  1032c6:	00 
  1032c7:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1032ce:	e8 0e da ff ff       	call   100ce1 <__panic>

    free_page(p0);
  1032d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032da:	00 
  1032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032de:	89 04 24             	mov    %eax,(%esp)
  1032e1:	e8 d4 0a 00 00       	call   103dba <free_pages>
  1032e6:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  1032ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1032f0:	8b 40 04             	mov    0x4(%eax),%eax
  1032f3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1032f6:	0f 94 c0             	sete   %al
  1032f9:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1032fc:	85 c0                	test   %eax,%eax
  1032fe:	74 24                	je     103324 <basic_check+0x44c>
  103300:	c7 44 24 0c 00 69 10 	movl   $0x106900,0xc(%esp)
  103307:	00 
  103308:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10330f:	00 
  103310:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  103317:	00 
  103318:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10331f:	e8 bd d9 ff ff       	call   100ce1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103324:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10332b:	e8 52 0a 00 00       	call   103d82 <alloc_pages>
  103330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103336:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103339:	74 24                	je     10335f <basic_check+0x487>
  10333b:	c7 44 24 0c 18 69 10 	movl   $0x106918,0xc(%esp)
  103342:	00 
  103343:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10334a:	00 
  10334b:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  103352:	00 
  103353:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10335a:	e8 82 d9 ff ff       	call   100ce1 <__panic>
    assert(alloc_page() == NULL);
  10335f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103366:	e8 17 0a 00 00       	call   103d82 <alloc_pages>
  10336b:	85 c0                	test   %eax,%eax
  10336d:	74 24                	je     103393 <basic_check+0x4bb>
  10336f:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  103376:	00 
  103377:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10337e:	00 
  10337f:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  103386:	00 
  103387:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10338e:	e8 4e d9 ff ff       	call   100ce1 <__panic>

    assert(nr_free == 0);
  103393:	a1 58 89 11 00       	mov    0x118958,%eax
  103398:	85 c0                	test   %eax,%eax
  10339a:	74 24                	je     1033c0 <basic_check+0x4e8>
  10339c:	c7 44 24 0c 31 69 10 	movl   $0x106931,0xc(%esp)
  1033a3:	00 
  1033a4:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1033ab:	00 
  1033ac:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  1033b3:	00 
  1033b4:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1033bb:	e8 21 d9 ff ff       	call   100ce1 <__panic>
    free_list = free_list_store;
  1033c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033c6:	a3 50 89 11 00       	mov    %eax,0x118950
  1033cb:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  1033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d4:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  1033d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033e0:	00 
  1033e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033e4:	89 04 24             	mov    %eax,(%esp)
  1033e7:	e8 ce 09 00 00       	call   103dba <free_pages>
    free_page(p1);
  1033ec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033f3:	00 
  1033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033f7:	89 04 24             	mov    %eax,(%esp)
  1033fa:	e8 bb 09 00 00       	call   103dba <free_pages>
    free_page(p2);
  1033ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103406:	00 
  103407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10340a:	89 04 24             	mov    %eax,(%esp)
  10340d:	e8 a8 09 00 00       	call   103dba <free_pages>
}
  103412:	c9                   	leave  
  103413:	c3                   	ret    

00103414 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103414:	55                   	push   %ebp
  103415:	89 e5                	mov    %esp,%ebp
  103417:	53                   	push   %ebx
  103418:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10341e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10342c:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103433:	eb 6b                	jmp    1034a0 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103438:	83 e8 0c             	sub    $0xc,%eax
  10343b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103441:	83 c0 04             	add    $0x4,%eax
  103444:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10344b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10344e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103451:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103454:	0f a3 10             	bt     %edx,(%eax)
  103457:	19 c0                	sbb    %eax,%eax
  103459:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10345c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103460:	0f 95 c0             	setne  %al
  103463:	0f b6 c0             	movzbl %al,%eax
  103466:	85 c0                	test   %eax,%eax
  103468:	75 24                	jne    10348e <default_check+0x7a>
  10346a:	c7 44 24 0c 3e 69 10 	movl   $0x10693e,0xc(%esp)
  103471:	00 
  103472:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103479:	00 
  10347a:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103481:	00 
  103482:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103489:	e8 53 d8 ff ff       	call   100ce1 <__panic>
        count ++, total += p->property;
  10348e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103492:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103495:	8b 50 08             	mov    0x8(%eax),%edx
  103498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10349b:	01 d0                	add    %edx,%eax
  10349d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034a3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1034a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1034a9:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034af:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1034b6:	0f 85 79 ff ff ff    	jne    103435 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1034bc:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1034bf:	e8 28 09 00 00       	call   103dec <nr_free_pages>
  1034c4:	39 c3                	cmp    %eax,%ebx
  1034c6:	74 24                	je     1034ec <default_check+0xd8>
  1034c8:	c7 44 24 0c 4e 69 10 	movl   $0x10694e,0xc(%esp)
  1034cf:	00 
  1034d0:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1034d7:	00 
  1034d8:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1034df:	00 
  1034e0:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1034e7:	e8 f5 d7 ff ff       	call   100ce1 <__panic>

    basic_check();
  1034ec:	e8 e7 f9 ff ff       	call   102ed8 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1034f1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1034f8:	e8 85 08 00 00       	call   103d82 <alloc_pages>
  1034fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103500:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103504:	75 24                	jne    10352a <default_check+0x116>
  103506:	c7 44 24 0c 67 69 10 	movl   $0x106967,0xc(%esp)
  10350d:	00 
  10350e:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103515:	00 
  103516:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  10351d:	00 
  10351e:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103525:	e8 b7 d7 ff ff       	call   100ce1 <__panic>
    assert(!PageProperty(p0));
  10352a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10352d:	83 c0 04             	add    $0x4,%eax
  103530:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103537:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10353a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10353d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103540:	0f a3 10             	bt     %edx,(%eax)
  103543:	19 c0                	sbb    %eax,%eax
  103545:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103548:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10354c:	0f 95 c0             	setne  %al
  10354f:	0f b6 c0             	movzbl %al,%eax
  103552:	85 c0                	test   %eax,%eax
  103554:	74 24                	je     10357a <default_check+0x166>
  103556:	c7 44 24 0c 72 69 10 	movl   $0x106972,0xc(%esp)
  10355d:	00 
  10355e:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103565:	00 
  103566:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  10356d:	00 
  10356e:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103575:	e8 67 d7 ff ff       	call   100ce1 <__panic>

    list_entry_t free_list_store = free_list;
  10357a:	a1 50 89 11 00       	mov    0x118950,%eax
  10357f:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103585:	89 45 80             	mov    %eax,-0x80(%ebp)
  103588:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10358b:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103592:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103595:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103598:	89 50 04             	mov    %edx,0x4(%eax)
  10359b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10359e:	8b 50 04             	mov    0x4(%eax),%edx
  1035a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1035a4:	89 10                	mov    %edx,(%eax)
  1035a6:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1035ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1035b0:	8b 40 04             	mov    0x4(%eax),%eax
  1035b3:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1035b6:	0f 94 c0             	sete   %al
  1035b9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1035bc:	85 c0                	test   %eax,%eax
  1035be:	75 24                	jne    1035e4 <default_check+0x1d0>
  1035c0:	c7 44 24 0c c7 68 10 	movl   $0x1068c7,0xc(%esp)
  1035c7:	00 
  1035c8:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1035cf:	00 
  1035d0:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1035d7:	00 
  1035d8:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1035df:	e8 fd d6 ff ff       	call   100ce1 <__panic>
    assert(alloc_page() == NULL);
  1035e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035eb:	e8 92 07 00 00       	call   103d82 <alloc_pages>
  1035f0:	85 c0                	test   %eax,%eax
  1035f2:	74 24                	je     103618 <default_check+0x204>
  1035f4:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  1035fb:	00 
  1035fc:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103603:	00 
  103604:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10360b:	00 
  10360c:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103613:	e8 c9 d6 ff ff       	call   100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
  103618:	a1 58 89 11 00       	mov    0x118958,%eax
  10361d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103620:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103627:	00 00 00 

    free_pages(p0 + 2, 3);
  10362a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362d:	83 c0 28             	add    $0x28,%eax
  103630:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103637:	00 
  103638:	89 04 24             	mov    %eax,(%esp)
  10363b:	e8 7a 07 00 00       	call   103dba <free_pages>
    assert(alloc_pages(4) == NULL);
  103640:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103647:	e8 36 07 00 00       	call   103d82 <alloc_pages>
  10364c:	85 c0                	test   %eax,%eax
  10364e:	74 24                	je     103674 <default_check+0x260>
  103650:	c7 44 24 0c 84 69 10 	movl   $0x106984,0xc(%esp)
  103657:	00 
  103658:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10365f:	00 
  103660:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103667:	00 
  103668:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10366f:	e8 6d d6 ff ff       	call   100ce1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103677:	83 c0 28             	add    $0x28,%eax
  10367a:	83 c0 04             	add    $0x4,%eax
  10367d:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103684:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103687:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10368a:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10368d:	0f a3 10             	bt     %edx,(%eax)
  103690:	19 c0                	sbb    %eax,%eax
  103692:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103695:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103699:	0f 95 c0             	setne  %al
  10369c:	0f b6 c0             	movzbl %al,%eax
  10369f:	85 c0                	test   %eax,%eax
  1036a1:	74 0e                	je     1036b1 <default_check+0x29d>
  1036a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036a6:	83 c0 28             	add    $0x28,%eax
  1036a9:	8b 40 08             	mov    0x8(%eax),%eax
  1036ac:	83 f8 03             	cmp    $0x3,%eax
  1036af:	74 24                	je     1036d5 <default_check+0x2c1>
  1036b1:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  1036b8:	00 
  1036b9:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1036c0:	00 
  1036c1:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  1036c8:	00 
  1036c9:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1036d0:	e8 0c d6 ff ff       	call   100ce1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1036d5:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1036dc:	e8 a1 06 00 00       	call   103d82 <alloc_pages>
  1036e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1036e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1036e8:	75 24                	jne    10370e <default_check+0x2fa>
  1036ea:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  1036f1:	00 
  1036f2:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1036f9:	00 
  1036fa:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103701:	00 
  103702:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103709:	e8 d3 d5 ff ff       	call   100ce1 <__panic>
    assert(alloc_page() == NULL);
  10370e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103715:	e8 68 06 00 00       	call   103d82 <alloc_pages>
  10371a:	85 c0                	test   %eax,%eax
  10371c:	74 24                	je     103742 <default_check+0x32e>
  10371e:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  103725:	00 
  103726:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10372d:	00 
  10372e:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103735:	00 
  103736:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10373d:	e8 9f d5 ff ff       	call   100ce1 <__panic>
    assert(p0 + 2 == p1);
  103742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103745:	83 c0 28             	add    $0x28,%eax
  103748:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10374b:	74 24                	je     103771 <default_check+0x35d>
  10374d:	c7 44 24 0c e6 69 10 	movl   $0x1069e6,0xc(%esp)
  103754:	00 
  103755:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10375c:	00 
  10375d:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103764:	00 
  103765:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10376c:	e8 70 d5 ff ff       	call   100ce1 <__panic>

    p2 = p0 + 1;
  103771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103774:	83 c0 14             	add    $0x14,%eax
  103777:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  10377a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103781:	00 
  103782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103785:	89 04 24             	mov    %eax,(%esp)
  103788:	e8 2d 06 00 00       	call   103dba <free_pages>
    free_pages(p1, 3);
  10378d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103794:	00 
  103795:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103798:	89 04 24             	mov    %eax,(%esp)
  10379b:	e8 1a 06 00 00       	call   103dba <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037a3:	83 c0 04             	add    $0x4,%eax
  1037a6:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1037ad:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037b0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1037b3:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1037b6:	0f a3 10             	bt     %edx,(%eax)
  1037b9:	19 c0                	sbb    %eax,%eax
  1037bb:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1037be:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1037c2:	0f 95 c0             	setne  %al
  1037c5:	0f b6 c0             	movzbl %al,%eax
  1037c8:	85 c0                	test   %eax,%eax
  1037ca:	74 0b                	je     1037d7 <default_check+0x3c3>
  1037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037cf:	8b 40 08             	mov    0x8(%eax),%eax
  1037d2:	83 f8 01             	cmp    $0x1,%eax
  1037d5:	74 24                	je     1037fb <default_check+0x3e7>
  1037d7:	c7 44 24 0c f4 69 10 	movl   $0x1069f4,0xc(%esp)
  1037de:	00 
  1037df:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1037e6:	00 
  1037e7:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  1037ee:	00 
  1037ef:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1037f6:	e8 e6 d4 ff ff       	call   100ce1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1037fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037fe:	83 c0 04             	add    $0x4,%eax
  103801:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103808:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10380b:	8b 45 90             	mov    -0x70(%ebp),%eax
  10380e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103811:	0f a3 10             	bt     %edx,(%eax)
  103814:	19 c0                	sbb    %eax,%eax
  103816:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103819:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10381d:	0f 95 c0             	setne  %al
  103820:	0f b6 c0             	movzbl %al,%eax
  103823:	85 c0                	test   %eax,%eax
  103825:	74 0b                	je     103832 <default_check+0x41e>
  103827:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10382a:	8b 40 08             	mov    0x8(%eax),%eax
  10382d:	83 f8 03             	cmp    $0x3,%eax
  103830:	74 24                	je     103856 <default_check+0x442>
  103832:	c7 44 24 0c 1c 6a 10 	movl   $0x106a1c,0xc(%esp)
  103839:	00 
  10383a:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103841:	00 
  103842:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103849:	00 
  10384a:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103851:	e8 8b d4 ff ff       	call   100ce1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103856:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10385d:	e8 20 05 00 00       	call   103d82 <alloc_pages>
  103862:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103865:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103868:	83 e8 14             	sub    $0x14,%eax
  10386b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10386e:	74 24                	je     103894 <default_check+0x480>
  103870:	c7 44 24 0c 42 6a 10 	movl   $0x106a42,0xc(%esp)
  103877:	00 
  103878:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10387f:	00 
  103880:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103887:	00 
  103888:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10388f:	e8 4d d4 ff ff       	call   100ce1 <__panic>
    free_page(p0);
  103894:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10389b:	00 
  10389c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10389f:	89 04 24             	mov    %eax,(%esp)
  1038a2:	e8 13 05 00 00       	call   103dba <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1038a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1038ae:	e8 cf 04 00 00       	call   103d82 <alloc_pages>
  1038b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038b9:	83 c0 14             	add    $0x14,%eax
  1038bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1038bf:	74 24                	je     1038e5 <default_check+0x4d1>
  1038c1:	c7 44 24 0c 60 6a 10 	movl   $0x106a60,0xc(%esp)
  1038c8:	00 
  1038c9:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  1038d0:	00 
  1038d1:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1038d8:	00 
  1038d9:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1038e0:	e8 fc d3 ff ff       	call   100ce1 <__panic>

    free_pages(p0, 2);
  1038e5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1038ec:	00 
  1038ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038f0:	89 04 24             	mov    %eax,(%esp)
  1038f3:	e8 c2 04 00 00       	call   103dba <free_pages>
    free_page(p2);
  1038f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038ff:	00 
  103900:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103903:	89 04 24             	mov    %eax,(%esp)
  103906:	e8 af 04 00 00       	call   103dba <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10390b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103912:	e8 6b 04 00 00       	call   103d82 <alloc_pages>
  103917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10391a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10391e:	75 24                	jne    103944 <default_check+0x530>
  103920:	c7 44 24 0c 80 6a 10 	movl   $0x106a80,0xc(%esp)
  103927:	00 
  103928:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  10392f:	00 
  103930:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103937:	00 
  103938:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  10393f:	e8 9d d3 ff ff       	call   100ce1 <__panic>
    assert(alloc_page() == NULL);
  103944:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10394b:	e8 32 04 00 00       	call   103d82 <alloc_pages>
  103950:	85 c0                	test   %eax,%eax
  103952:	74 24                	je     103978 <default_check+0x564>
  103954:	c7 44 24 0c de 68 10 	movl   $0x1068de,0xc(%esp)
  10395b:	00 
  10395c:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103963:	00 
  103964:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  10396b:	00 
  10396c:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103973:	e8 69 d3 ff ff       	call   100ce1 <__panic>

    assert(nr_free == 0);
  103978:	a1 58 89 11 00       	mov    0x118958,%eax
  10397d:	85 c0                	test   %eax,%eax
  10397f:	74 24                	je     1039a5 <default_check+0x591>
  103981:	c7 44 24 0c 31 69 10 	movl   $0x106931,0xc(%esp)
  103988:	00 
  103989:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103990:	00 
  103991:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103998:	00 
  103999:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  1039a0:	e8 3c d3 ff ff       	call   100ce1 <__panic>
    nr_free = nr_free_store;
  1039a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039a8:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1039ad:	8b 45 80             	mov    -0x80(%ebp),%eax
  1039b0:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1039b3:	a3 50 89 11 00       	mov    %eax,0x118950
  1039b8:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1039be:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1039c5:	00 
  1039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039c9:	89 04 24             	mov    %eax,(%esp)
  1039cc:	e8 e9 03 00 00       	call   103dba <free_pages>

    le = &free_list;
  1039d1:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1039d8:	eb 1d                	jmp    1039f7 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1039da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039dd:	83 e8 0c             	sub    $0xc,%eax
  1039e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1039e3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1039e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1039ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1039ed:	8b 40 08             	mov    0x8(%eax),%eax
  1039f0:	29 c2                	sub    %eax,%edx
  1039f2:	89 d0                	mov    %edx,%eax
  1039f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039fa:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1039fd:	8b 45 88             	mov    -0x78(%ebp),%eax
  103a00:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103a03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a06:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103a0d:	75 cb                	jne    1039da <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a13:	74 24                	je     103a39 <default_check+0x625>
  103a15:	c7 44 24 0c 9e 6a 10 	movl   $0x106a9e,0xc(%esp)
  103a1c:	00 
  103a1d:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103a24:	00 
  103a25:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103a2c:	00 
  103a2d:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103a34:	e8 a8 d2 ff ff       	call   100ce1 <__panic>
    assert(total == 0);
  103a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a3d:	74 24                	je     103a63 <default_check+0x64f>
  103a3f:	c7 44 24 0c a9 6a 10 	movl   $0x106aa9,0xc(%esp)
  103a46:	00 
  103a47:	c7 44 24 08 56 67 10 	movl   $0x106756,0x8(%esp)
  103a4e:	00 
  103a4f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103a56:	00 
  103a57:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103a5e:	e8 7e d2 ff ff       	call   100ce1 <__panic>
}
  103a63:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a69:	5b                   	pop    %ebx
  103a6a:	5d                   	pop    %ebp
  103a6b:	c3                   	ret    

00103a6c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a6c:	55                   	push   %ebp
  103a6d:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  103a72:	a1 64 89 11 00       	mov    0x118964,%eax
  103a77:	29 c2                	sub    %eax,%edx
  103a79:	89 d0                	mov    %edx,%eax
  103a7b:	c1 f8 02             	sar    $0x2,%eax
  103a7e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a84:	5d                   	pop    %ebp
  103a85:	c3                   	ret    

00103a86 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a86:	55                   	push   %ebp
  103a87:	89 e5                	mov    %esp,%ebp
  103a89:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  103a8f:	89 04 24             	mov    %eax,(%esp)
  103a92:	e8 d5 ff ff ff       	call   103a6c <page2ppn>
  103a97:	c1 e0 0c             	shl    $0xc,%eax
}
  103a9a:	c9                   	leave  
  103a9b:	c3                   	ret    

00103a9c <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a9c:	55                   	push   %ebp
  103a9d:	89 e5                	mov    %esp,%ebp
  103a9f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa5:	c1 e8 0c             	shr    $0xc,%eax
  103aa8:	89 c2                	mov    %eax,%edx
  103aaa:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103aaf:	39 c2                	cmp    %eax,%edx
  103ab1:	72 1c                	jb     103acf <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103ab3:	c7 44 24 08 e4 6a 10 	movl   $0x106ae4,0x8(%esp)
  103aba:	00 
  103abb:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103ac2:	00 
  103ac3:	c7 04 24 03 6b 10 00 	movl   $0x106b03,(%esp)
  103aca:	e8 12 d2 ff ff       	call   100ce1 <__panic>
    }
    return &pages[PPN(pa)];
  103acf:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad8:	c1 e8 0c             	shr    $0xc,%eax
  103adb:	89 c2                	mov    %eax,%edx
  103add:	89 d0                	mov    %edx,%eax
  103adf:	c1 e0 02             	shl    $0x2,%eax
  103ae2:	01 d0                	add    %edx,%eax
  103ae4:	c1 e0 02             	shl    $0x2,%eax
  103ae7:	01 c8                	add    %ecx,%eax
}
  103ae9:	c9                   	leave  
  103aea:	c3                   	ret    

00103aeb <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103aeb:	55                   	push   %ebp
  103aec:	89 e5                	mov    %esp,%ebp
  103aee:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103af1:	8b 45 08             	mov    0x8(%ebp),%eax
  103af4:	89 04 24             	mov    %eax,(%esp)
  103af7:	e8 8a ff ff ff       	call   103a86 <page2pa>
  103afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b02:	c1 e8 0c             	shr    $0xc,%eax
  103b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b08:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103b0d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b10:	72 23                	jb     103b35 <page2kva+0x4a>
  103b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b19:	c7 44 24 08 14 6b 10 	movl   $0x106b14,0x8(%esp)
  103b20:	00 
  103b21:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103b28:	00 
  103b29:	c7 04 24 03 6b 10 00 	movl   $0x106b03,(%esp)
  103b30:	e8 ac d1 ff ff       	call   100ce1 <__panic>
  103b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b38:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103b3d:	c9                   	leave  
  103b3e:	c3                   	ret    

00103b3f <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103b3f:	55                   	push   %ebp
  103b40:	89 e5                	mov    %esp,%ebp
  103b42:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103b45:	8b 45 08             	mov    0x8(%ebp),%eax
  103b48:	83 e0 01             	and    $0x1,%eax
  103b4b:	85 c0                	test   %eax,%eax
  103b4d:	75 1c                	jne    103b6b <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103b4f:	c7 44 24 08 38 6b 10 	movl   $0x106b38,0x8(%esp)
  103b56:	00 
  103b57:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103b5e:	00 
  103b5f:	c7 04 24 03 6b 10 00 	movl   $0x106b03,(%esp)
  103b66:	e8 76 d1 ff ff       	call   100ce1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b73:	89 04 24             	mov    %eax,(%esp)
  103b76:	e8 21 ff ff ff       	call   103a9c <pa2page>
}
  103b7b:	c9                   	leave  
  103b7c:	c3                   	ret    

00103b7d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103b7d:	55                   	push   %ebp
  103b7e:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b80:	8b 45 08             	mov    0x8(%ebp),%eax
  103b83:	8b 00                	mov    (%eax),%eax
}
  103b85:	5d                   	pop    %ebp
  103b86:	c3                   	ret    

00103b87 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103b87:	55                   	push   %ebp
  103b88:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b90:	89 10                	mov    %edx,(%eax)
}
  103b92:	5d                   	pop    %ebp
  103b93:	c3                   	ret    

00103b94 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103b94:	55                   	push   %ebp
  103b95:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b97:	8b 45 08             	mov    0x8(%ebp),%eax
  103b9a:	8b 00                	mov    (%eax),%eax
  103b9c:	8d 50 01             	lea    0x1(%eax),%edx
  103b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba2:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba7:	8b 00                	mov    (%eax),%eax
}
  103ba9:	5d                   	pop    %ebp
  103baa:	c3                   	ret    

00103bab <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103bab:	55                   	push   %ebp
  103bac:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103bae:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb1:	8b 00                	mov    (%eax),%eax
  103bb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  103bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb9:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  103bbe:	8b 00                	mov    (%eax),%eax
}
  103bc0:	5d                   	pop    %ebp
  103bc1:	c3                   	ret    

00103bc2 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103bc2:	55                   	push   %ebp
  103bc3:	89 e5                	mov    %esp,%ebp
  103bc5:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103bc8:	9c                   	pushf  
  103bc9:	58                   	pop    %eax
  103bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103bd0:	25 00 02 00 00       	and    $0x200,%eax
  103bd5:	85 c0                	test   %eax,%eax
  103bd7:	74 0c                	je     103be5 <__intr_save+0x23>
        intr_disable();
  103bd9:	e8 e6 da ff ff       	call   1016c4 <intr_disable>
        return 1;
  103bde:	b8 01 00 00 00       	mov    $0x1,%eax
  103be3:	eb 05                	jmp    103bea <__intr_save+0x28>
    }
    return 0;
  103be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103bea:	c9                   	leave  
  103beb:	c3                   	ret    

00103bec <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103bec:	55                   	push   %ebp
  103bed:	89 e5                	mov    %esp,%ebp
  103bef:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103bf6:	74 05                	je     103bfd <__intr_restore+0x11>
        intr_enable();
  103bf8:	e8 c1 da ff ff       	call   1016be <intr_enable>
    }
}
  103bfd:	c9                   	leave  
  103bfe:	c3                   	ret    

00103bff <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103bff:	55                   	push   %ebp
  103c00:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103c02:	8b 45 08             	mov    0x8(%ebp),%eax
  103c05:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103c08:	b8 23 00 00 00       	mov    $0x23,%eax
  103c0d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103c0f:	b8 23 00 00 00       	mov    $0x23,%eax
  103c14:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103c16:	b8 10 00 00 00       	mov    $0x10,%eax
  103c1b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103c1d:	b8 10 00 00 00       	mov    $0x10,%eax
  103c22:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103c24:	b8 10 00 00 00       	mov    $0x10,%eax
  103c29:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103c2b:	ea 32 3c 10 00 08 00 	ljmp   $0x8,$0x103c32
}
  103c32:	5d                   	pop    %ebp
  103c33:	c3                   	ret    

00103c34 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103c34:	55                   	push   %ebp
  103c35:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c37:	8b 45 08             	mov    0x8(%ebp),%eax
  103c3a:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103c3f:	5d                   	pop    %ebp
  103c40:	c3                   	ret    

00103c41 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103c41:	55                   	push   %ebp
  103c42:	89 e5                	mov    %esp,%ebp
  103c44:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103c47:	b8 00 70 11 00       	mov    $0x117000,%eax
  103c4c:	89 04 24             	mov    %eax,(%esp)
  103c4f:	e8 e0 ff ff ff       	call   103c34 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103c54:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103c5b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103c5d:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103c64:	68 00 
  103c66:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c6b:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c71:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c76:	c1 e8 10             	shr    $0x10,%eax
  103c79:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c7e:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c85:	83 e0 f0             	and    $0xfffffff0,%eax
  103c88:	83 c8 09             	or     $0x9,%eax
  103c8b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c90:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c97:	83 e0 ef             	and    $0xffffffef,%eax
  103c9a:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c9f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103ca6:	83 e0 9f             	and    $0xffffff9f,%eax
  103ca9:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cae:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cb5:	83 c8 80             	or     $0xffffff80,%eax
  103cb8:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cbd:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cc4:	83 e0 f0             	and    $0xfffffff0,%eax
  103cc7:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ccc:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cd3:	83 e0 ef             	and    $0xffffffef,%eax
  103cd6:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cdb:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ce2:	83 e0 df             	and    $0xffffffdf,%eax
  103ce5:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cea:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cf1:	83 c8 40             	or     $0x40,%eax
  103cf4:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cf9:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d00:	83 e0 7f             	and    $0x7f,%eax
  103d03:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d08:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103d0d:	c1 e8 18             	shr    $0x18,%eax
  103d10:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103d15:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103d1c:	e8 de fe ff ff       	call   103bff <lgdt>
  103d21:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103d27:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103d2b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103d2e:	c9                   	leave  
  103d2f:	c3                   	ret    

00103d30 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103d30:	55                   	push   %ebp
  103d31:	89 e5                	mov    %esp,%ebp
  103d33:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d36:	c7 05 5c 89 11 00 c8 	movl   $0x106ac8,0x11895c
  103d3d:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103d40:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d45:	8b 00                	mov    (%eax),%eax
  103d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d4b:	c7 04 24 64 6b 10 00 	movl   $0x106b64,(%esp)
  103d52:	e8 e5 c5 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103d57:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d5c:	8b 40 04             	mov    0x4(%eax),%eax
  103d5f:	ff d0                	call   *%eax
}
  103d61:	c9                   	leave  
  103d62:	c3                   	ret    

00103d63 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103d63:	55                   	push   %ebp
  103d64:	89 e5                	mov    %esp,%ebp
  103d66:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d69:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d6e:	8b 40 08             	mov    0x8(%eax),%eax
  103d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d74:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d78:	8b 55 08             	mov    0x8(%ebp),%edx
  103d7b:	89 14 24             	mov    %edx,(%esp)
  103d7e:	ff d0                	call   *%eax
}
  103d80:	c9                   	leave  
  103d81:	c3                   	ret    

00103d82 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d82:	55                   	push   %ebp
  103d83:	89 e5                	mov    %esp,%ebp
  103d85:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d8f:	e8 2e fe ff ff       	call   103bc2 <__intr_save>
  103d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d97:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  103d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  103da2:	89 14 24             	mov    %edx,(%esp)
  103da5:	ff d0                	call   *%eax
  103da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dad:	89 04 24             	mov    %eax,(%esp)
  103db0:	e8 37 fe ff ff       	call   103bec <__intr_restore>
    return page;
  103db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103db8:	c9                   	leave  
  103db9:	c3                   	ret    

00103dba <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103dba:	55                   	push   %ebp
  103dbb:	89 e5                	mov    %esp,%ebp
  103dbd:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103dc0:	e8 fd fd ff ff       	call   103bc2 <__intr_save>
  103dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103dc8:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103dcd:	8b 40 10             	mov    0x10(%eax),%eax
  103dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  103dd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  103dda:	89 14 24             	mov    %edx,(%esp)
  103ddd:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103de2:	89 04 24             	mov    %eax,(%esp)
  103de5:	e8 02 fe ff ff       	call   103bec <__intr_restore>
}
  103dea:	c9                   	leave  
  103deb:	c3                   	ret    

00103dec <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103dec:	55                   	push   %ebp
  103ded:	89 e5                	mov    %esp,%ebp
  103def:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103df2:	e8 cb fd ff ff       	call   103bc2 <__intr_save>
  103df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103dfa:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103dff:	8b 40 14             	mov    0x14(%eax),%eax
  103e02:	ff d0                	call   *%eax
  103e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e0a:	89 04 24             	mov    %eax,(%esp)
  103e0d:	e8 da fd ff ff       	call   103bec <__intr_restore>
    return ret;
  103e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103e15:	c9                   	leave  
  103e16:	c3                   	ret    

00103e17 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103e17:	55                   	push   %ebp
  103e18:	89 e5                	mov    %esp,%ebp
  103e1a:	57                   	push   %edi
  103e1b:	56                   	push   %esi
  103e1c:	53                   	push   %ebx
  103e1d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103e23:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103e2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e38:	c7 04 24 7b 6b 10 00 	movl   $0x106b7b,(%esp)
  103e3f:	e8 f8 c4 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e4b:	e9 15 01 00 00       	jmp    103f65 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103e50:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e56:	89 d0                	mov    %edx,%eax
  103e58:	c1 e0 02             	shl    $0x2,%eax
  103e5b:	01 d0                	add    %edx,%eax
  103e5d:	c1 e0 02             	shl    $0x2,%eax
  103e60:	01 c8                	add    %ecx,%eax
  103e62:	8b 50 08             	mov    0x8(%eax),%edx
  103e65:	8b 40 04             	mov    0x4(%eax),%eax
  103e68:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e6b:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e74:	89 d0                	mov    %edx,%eax
  103e76:	c1 e0 02             	shl    $0x2,%eax
  103e79:	01 d0                	add    %edx,%eax
  103e7b:	c1 e0 02             	shl    $0x2,%eax
  103e7e:	01 c8                	add    %ecx,%eax
  103e80:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e83:	8b 58 10             	mov    0x10(%eax),%ebx
  103e86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e89:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e8c:	01 c8                	add    %ecx,%eax
  103e8e:	11 da                	adc    %ebx,%edx
  103e90:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e93:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e96:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e9c:	89 d0                	mov    %edx,%eax
  103e9e:	c1 e0 02             	shl    $0x2,%eax
  103ea1:	01 d0                	add    %edx,%eax
  103ea3:	c1 e0 02             	shl    $0x2,%eax
  103ea6:	01 c8                	add    %ecx,%eax
  103ea8:	83 c0 14             	add    $0x14,%eax
  103eab:	8b 00                	mov    (%eax),%eax
  103ead:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103eb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103eb6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103eb9:	83 c0 ff             	add    $0xffffffff,%eax
  103ebc:	83 d2 ff             	adc    $0xffffffff,%edx
  103ebf:	89 c6                	mov    %eax,%esi
  103ec1:	89 d7                	mov    %edx,%edi
  103ec3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ec6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ec9:	89 d0                	mov    %edx,%eax
  103ecb:	c1 e0 02             	shl    $0x2,%eax
  103ece:	01 d0                	add    %edx,%eax
  103ed0:	c1 e0 02             	shl    $0x2,%eax
  103ed3:	01 c8                	add    %ecx,%eax
  103ed5:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ed8:	8b 58 10             	mov    0x10(%eax),%ebx
  103edb:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103ee1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103ee5:	89 74 24 14          	mov    %esi,0x14(%esp)
  103ee9:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103eed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ef0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ef3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ef7:	89 54 24 10          	mov    %edx,0x10(%esp)
  103efb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103eff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f03:	c7 04 24 88 6b 10 00 	movl   $0x106b88,(%esp)
  103f0a:	e8 2d c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103f0f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f12:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f15:	89 d0                	mov    %edx,%eax
  103f17:	c1 e0 02             	shl    $0x2,%eax
  103f1a:	01 d0                	add    %edx,%eax
  103f1c:	c1 e0 02             	shl    $0x2,%eax
  103f1f:	01 c8                	add    %ecx,%eax
  103f21:	83 c0 14             	add    $0x14,%eax
  103f24:	8b 00                	mov    (%eax),%eax
  103f26:	83 f8 01             	cmp    $0x1,%eax
  103f29:	75 36                	jne    103f61 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f31:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f34:	77 2b                	ja     103f61 <page_init+0x14a>
  103f36:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f39:	72 05                	jb     103f40 <page_init+0x129>
  103f3b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103f3e:	73 21                	jae    103f61 <page_init+0x14a>
  103f40:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f44:	77 1b                	ja     103f61 <page_init+0x14a>
  103f46:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f4a:	72 09                	jb     103f55 <page_init+0x13e>
  103f4c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103f53:	77 0c                	ja     103f61 <page_init+0x14a>
                maxpa = end;
  103f55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f58:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f61:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f65:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f68:	8b 00                	mov    (%eax),%eax
  103f6a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f6d:	0f 8f dd fe ff ff    	jg     103e50 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f77:	72 1d                	jb     103f96 <page_init+0x17f>
  103f79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f7d:	77 09                	ja     103f88 <page_init+0x171>
  103f7f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f86:	76 0e                	jbe    103f96 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f88:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f9c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103fa0:	c1 ea 0c             	shr    $0xc,%edx
  103fa3:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103fa8:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103faf:	b8 68 89 11 00       	mov    $0x118968,%eax
  103fb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  103fb7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103fba:	01 d0                	add    %edx,%eax
  103fbc:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103fbf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  103fc7:	f7 75 ac             	divl   -0x54(%ebp)
  103fca:	89 d0                	mov    %edx,%eax
  103fcc:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103fcf:	29 c2                	sub    %eax,%edx
  103fd1:	89 d0                	mov    %edx,%eax
  103fd3:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103fd8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fdf:	eb 2f                	jmp    104010 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103fe1:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103fe7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fea:	89 d0                	mov    %edx,%eax
  103fec:	c1 e0 02             	shl    $0x2,%eax
  103fef:	01 d0                	add    %edx,%eax
  103ff1:	c1 e0 02             	shl    $0x2,%eax
  103ff4:	01 c8                	add    %ecx,%eax
  103ff6:	83 c0 04             	add    $0x4,%eax
  103ff9:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104000:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104003:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104006:	8b 55 90             	mov    -0x70(%ebp),%edx
  104009:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10400c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104010:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104013:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104018:	39 c2                	cmp    %eax,%edx
  10401a:	72 c5                	jb     103fe1 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10401c:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104022:	89 d0                	mov    %edx,%eax
  104024:	c1 e0 02             	shl    $0x2,%eax
  104027:	01 d0                	add    %edx,%eax
  104029:	c1 e0 02             	shl    $0x2,%eax
  10402c:	89 c2                	mov    %eax,%edx
  10402e:	a1 64 89 11 00       	mov    0x118964,%eax
  104033:	01 d0                	add    %edx,%eax
  104035:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104038:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  10403f:	77 23                	ja     104064 <page_init+0x24d>
  104041:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104044:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104048:	c7 44 24 08 b8 6b 10 	movl   $0x106bb8,0x8(%esp)
  10404f:	00 
  104050:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104057:	00 
  104058:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  10405f:	e8 7d cc ff ff       	call   100ce1 <__panic>
  104064:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104067:	05 00 00 00 40       	add    $0x40000000,%eax
  10406c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10406f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104076:	e9 74 01 00 00       	jmp    1041ef <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10407b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10407e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104081:	89 d0                	mov    %edx,%eax
  104083:	c1 e0 02             	shl    $0x2,%eax
  104086:	01 d0                	add    %edx,%eax
  104088:	c1 e0 02             	shl    $0x2,%eax
  10408b:	01 c8                	add    %ecx,%eax
  10408d:	8b 50 08             	mov    0x8(%eax),%edx
  104090:	8b 40 04             	mov    0x4(%eax),%eax
  104093:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104096:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104099:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10409c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10409f:	89 d0                	mov    %edx,%eax
  1040a1:	c1 e0 02             	shl    $0x2,%eax
  1040a4:	01 d0                	add    %edx,%eax
  1040a6:	c1 e0 02             	shl    $0x2,%eax
  1040a9:	01 c8                	add    %ecx,%eax
  1040ab:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040ae:	8b 58 10             	mov    0x10(%eax),%ebx
  1040b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040b7:	01 c8                	add    %ecx,%eax
  1040b9:	11 da                	adc    %ebx,%edx
  1040bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040be:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1040c1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040c7:	89 d0                	mov    %edx,%eax
  1040c9:	c1 e0 02             	shl    $0x2,%eax
  1040cc:	01 d0                	add    %edx,%eax
  1040ce:	c1 e0 02             	shl    $0x2,%eax
  1040d1:	01 c8                	add    %ecx,%eax
  1040d3:	83 c0 14             	add    $0x14,%eax
  1040d6:	8b 00                	mov    (%eax),%eax
  1040d8:	83 f8 01             	cmp    $0x1,%eax
  1040db:	0f 85 0a 01 00 00    	jne    1041eb <page_init+0x3d4>
            if (begin < freemem) {
  1040e1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040e4:	ba 00 00 00 00       	mov    $0x0,%edx
  1040e9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040ec:	72 17                	jb     104105 <page_init+0x2ee>
  1040ee:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040f1:	77 05                	ja     1040f8 <page_init+0x2e1>
  1040f3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1040f6:	76 0d                	jbe    104105 <page_init+0x2ee>
                begin = freemem;
  1040f8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104105:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104109:	72 1d                	jb     104128 <page_init+0x311>
  10410b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10410f:	77 09                	ja     10411a <page_init+0x303>
  104111:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104118:	76 0e                	jbe    104128 <page_init+0x311>
                end = KMEMSIZE;
  10411a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104121:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104128:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10412b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10412e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104131:	0f 87 b4 00 00 00    	ja     1041eb <page_init+0x3d4>
  104137:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10413a:	72 09                	jb     104145 <page_init+0x32e>
  10413c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10413f:	0f 83 a6 00 00 00    	jae    1041eb <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104145:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10414c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10414f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104152:	01 d0                	add    %edx,%eax
  104154:	83 e8 01             	sub    $0x1,%eax
  104157:	89 45 98             	mov    %eax,-0x68(%ebp)
  10415a:	8b 45 98             	mov    -0x68(%ebp),%eax
  10415d:	ba 00 00 00 00       	mov    $0x0,%edx
  104162:	f7 75 9c             	divl   -0x64(%ebp)
  104165:	89 d0                	mov    %edx,%eax
  104167:	8b 55 98             	mov    -0x68(%ebp),%edx
  10416a:	29 c2                	sub    %eax,%edx
  10416c:	89 d0                	mov    %edx,%eax
  10416e:	ba 00 00 00 00       	mov    $0x0,%edx
  104173:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104176:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104179:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10417c:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10417f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104182:	ba 00 00 00 00       	mov    $0x0,%edx
  104187:	89 c7                	mov    %eax,%edi
  104189:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10418f:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104192:	89 d0                	mov    %edx,%eax
  104194:	83 e0 00             	and    $0x0,%eax
  104197:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10419a:	8b 45 80             	mov    -0x80(%ebp),%eax
  10419d:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1041a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1041a3:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1041a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041ac:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041af:	77 3a                	ja     1041eb <page_init+0x3d4>
  1041b1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041b4:	72 05                	jb     1041bb <page_init+0x3a4>
  1041b6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1041b9:	73 30                	jae    1041eb <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1041bb:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1041be:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1041c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1041c7:	29 c8                	sub    %ecx,%eax
  1041c9:	19 da                	sbb    %ebx,%edx
  1041cb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1041cf:	c1 ea 0c             	shr    $0xc,%edx
  1041d2:	89 c3                	mov    %eax,%ebx
  1041d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041d7:	89 04 24             	mov    %eax,(%esp)
  1041da:	e8 bd f8 ff ff       	call   103a9c <pa2page>
  1041df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041e3:	89 04 24             	mov    %eax,(%esp)
  1041e6:	e8 78 fb ff ff       	call   103d63 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1041eb:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041f2:	8b 00                	mov    (%eax),%eax
  1041f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1041f7:	0f 8f 7e fe ff ff    	jg     10407b <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1041fd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104203:	5b                   	pop    %ebx
  104204:	5e                   	pop    %esi
  104205:	5f                   	pop    %edi
  104206:	5d                   	pop    %ebp
  104207:	c3                   	ret    

00104208 <enable_paging>:

static void
enable_paging(void) {
  104208:	55                   	push   %ebp
  104209:	89 e5                	mov    %esp,%ebp
  10420b:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10420e:	a1 60 89 11 00       	mov    0x118960,%eax
  104213:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104216:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104219:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10421c:	0f 20 c0             	mov    %cr0,%eax
  10421f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104222:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104225:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104228:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10422f:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104233:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104236:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10423c:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10423f:	c9                   	leave  
  104240:	c3                   	ret    

00104241 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104241:	55                   	push   %ebp
  104242:	89 e5                	mov    %esp,%ebp
  104244:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104247:	8b 45 14             	mov    0x14(%ebp),%eax
  10424a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10424d:	31 d0                	xor    %edx,%eax
  10424f:	25 ff 0f 00 00       	and    $0xfff,%eax
  104254:	85 c0                	test   %eax,%eax
  104256:	74 24                	je     10427c <boot_map_segment+0x3b>
  104258:	c7 44 24 0c ea 6b 10 	movl   $0x106bea,0xc(%esp)
  10425f:	00 
  104260:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104267:	00 
  104268:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10426f:	00 
  104270:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104277:	e8 65 ca ff ff       	call   100ce1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10427c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104283:	8b 45 0c             	mov    0xc(%ebp),%eax
  104286:	25 ff 0f 00 00       	and    $0xfff,%eax
  10428b:	89 c2                	mov    %eax,%edx
  10428d:	8b 45 10             	mov    0x10(%ebp),%eax
  104290:	01 c2                	add    %eax,%edx
  104292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104295:	01 d0                	add    %edx,%eax
  104297:	83 e8 01             	sub    $0x1,%eax
  10429a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10429d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1042a5:	f7 75 f0             	divl   -0x10(%ebp)
  1042a8:	89 d0                	mov    %edx,%eax
  1042aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1042ad:	29 c2                	sub    %eax,%edx
  1042af:	89 d0                	mov    %edx,%eax
  1042b1:	c1 e8 0c             	shr    $0xc,%eax
  1042b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1042b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1042bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042c5:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1042c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1042cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042d6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042d9:	eb 6b                	jmp    104346 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1042db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1042e2:	00 
  1042e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ed:	89 04 24             	mov    %eax,(%esp)
  1042f0:	e8 cc 01 00 00       	call   1044c1 <get_pte>
  1042f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1042f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1042fc:	75 24                	jne    104322 <boot_map_segment+0xe1>
  1042fe:	c7 44 24 0c 16 6c 10 	movl   $0x106c16,0xc(%esp)
  104305:	00 
  104306:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  10430d:	00 
  10430e:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104315:	00 
  104316:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  10431d:	e8 bf c9 ff ff       	call   100ce1 <__panic>
        *ptep = pa | PTE_P | perm;
  104322:	8b 45 18             	mov    0x18(%ebp),%eax
  104325:	8b 55 14             	mov    0x14(%ebp),%edx
  104328:	09 d0                	or     %edx,%eax
  10432a:	83 c8 01             	or     $0x1,%eax
  10432d:	89 c2                	mov    %eax,%edx
  10432f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104332:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104334:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104338:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10433f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10434a:	75 8f                	jne    1042db <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10434c:	c9                   	leave  
  10434d:	c3                   	ret    

0010434e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10434e:	55                   	push   %ebp
  10434f:	89 e5                	mov    %esp,%ebp
  104351:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104354:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10435b:	e8 22 fa ff ff       	call   103d82 <alloc_pages>
  104360:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104367:	75 1c                	jne    104385 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104369:	c7 44 24 08 23 6c 10 	movl   $0x106c23,0x8(%esp)
  104370:	00 
  104371:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104378:	00 
  104379:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104380:	e8 5c c9 ff ff       	call   100ce1 <__panic>
    }
    return page2kva(p);
  104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104388:	89 04 24             	mov    %eax,(%esp)
  10438b:	e8 5b f7 ff ff       	call   103aeb <page2kva>
}
  104390:	c9                   	leave  
  104391:	c3                   	ret    

00104392 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104392:	55                   	push   %ebp
  104393:	89 e5                	mov    %esp,%ebp
  104395:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104398:	e8 93 f9 ff ff       	call   103d30 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10439d:	e8 75 fa ff ff       	call   103e17 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1043a2:	e8 7b 04 00 00       	call   104822 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1043a7:	e8 a2 ff ff ff       	call   10434e <boot_alloc_page>
  1043ac:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1043b1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043b6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1043bd:	00 
  1043be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1043c5:	00 
  1043c6:	89 04 24             	mov    %eax,(%esp)
  1043c9:	e8 bd 1a 00 00       	call   105e8b <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1043ce:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043d6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1043dd:	77 23                	ja     104402 <pmm_init+0x70>
  1043df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043e6:	c7 44 24 08 b8 6b 10 	movl   $0x106bb8,0x8(%esp)
  1043ed:	00 
  1043ee:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1043f5:	00 
  1043f6:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1043fd:	e8 df c8 ff ff       	call   100ce1 <__panic>
  104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104405:	05 00 00 00 40       	add    $0x40000000,%eax
  10440a:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  10440f:	e8 2c 04 00 00       	call   104840 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104414:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104419:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10441f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104427:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10442e:	77 23                	ja     104453 <pmm_init+0xc1>
  104430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104437:	c7 44 24 08 b8 6b 10 	movl   $0x106bb8,0x8(%esp)
  10443e:	00 
  10443f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104446:	00 
  104447:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  10444e:	e8 8e c8 ff ff       	call   100ce1 <__panic>
  104453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104456:	05 00 00 00 40       	add    $0x40000000,%eax
  10445b:	83 c8 03             	or     $0x3,%eax
  10445e:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104460:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104465:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10446c:	00 
  10446d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104474:	00 
  104475:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10447c:	38 
  10447d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104484:	c0 
  104485:	89 04 24             	mov    %eax,(%esp)
  104488:	e8 b4 fd ff ff       	call   104241 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10448d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104492:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104498:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10449e:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1044a0:	e8 63 fd ff ff       	call   104208 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1044a5:	e8 97 f7 ff ff       	call   103c41 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1044aa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1044af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1044b5:	e8 21 0a 00 00       	call   104edb <check_boot_pgdir>

    print_pgdir();
  1044ba:	e8 ae 0e 00 00       	call   10536d <print_pgdir>

}
  1044bf:	c9                   	leave  
  1044c0:	c3                   	ret    

001044c1 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1044c1:	55                   	push   %ebp
  1044c2:	89 e5                	mov    %esp,%ebp
  1044c4:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1044c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044ca:	c1 e8 16             	shr    $0x16,%eax
  1044cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1044d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d7:	01 d0                	add    %edx,%eax
  1044d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!(*pdep & PTE_P)){
  1044dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044df:	8b 00                	mov    (%eax),%eax
  1044e1:	83 e0 01             	and    $0x1,%eax
  1044e4:	85 c0                	test   %eax,%eax
  1044e6:	0f 85 b6 00 00 00    	jne    1045a2 <get_pte+0xe1>
        struct  Page *p = NULL;
  1044ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        if(create)
  1044f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044f7:	74 0f                	je     104508 <get_pte+0x47>
            p = alloc_page();
  1044f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104500:	e8 7d f8 ff ff       	call   103d82 <alloc_pages>
  104505:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p == NULL)
  104508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10450c:	75 0a                	jne    104518 <get_pte+0x57>
            return NULL;
  10450e:	b8 00 00 00 00       	mov    $0x0,%eax
  104513:	e9 ef 00 00 00       	jmp    104607 <get_pte+0x146>
        set_page_ref(p, 1);
  104518:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10451f:	00 
  104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104523:	89 04 24             	mov    %eax,(%esp)
  104526:	e8 5c f6 ff ff       	call   103b87 <set_page_ref>
        uintptr_t pa = page2pa(p);
  10452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452e:	89 04 24             	mov    %eax,(%esp)
  104531:	e8 50 f5 ff ff       	call   103a86 <page2pa>
  104536:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  104539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10453c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10453f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104542:	c1 e8 0c             	shr    $0xc,%eax
  104545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104548:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10454d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104550:	72 23                	jb     104575 <get_pte+0xb4>
  104552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104555:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104559:	c7 44 24 08 14 6b 10 	movl   $0x106b14,0x8(%esp)
  104560:	00 
  104561:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
  104568:	00 
  104569:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104570:	e8 6c c7 ff ff       	call   100ce1 <__panic>
  104575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104578:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10457d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104584:	00 
  104585:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10458c:	00 
  10458d:	89 04 24             	mov    %eax,(%esp)
  104590:	e8 f6 18 00 00       	call   105e8b <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  104595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104598:	83 c8 07             	or     $0x7,%eax
  10459b:	89 c2                	mov    %eax,%edx
  10459d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a0:	89 10                	mov    %edx,(%eax)
    }
    pde_t *a = (pte_t*)KADDR(PDE_ADDR(*pdep));
  1045a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a5:	8b 00                	mov    (%eax),%eax
  1045a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1045ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1045af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045b2:	c1 e8 0c             	shr    $0xc,%eax
  1045b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1045b8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1045bd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1045c0:	72 23                	jb     1045e5 <get_pte+0x124>
  1045c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045c9:	c7 44 24 08 14 6b 10 	movl   $0x106b14,0x8(%esp)
  1045d0:	00 
  1045d1:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
  1045d8:	00 
  1045d9:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1045e0:	e8 fc c6 ff ff       	call   100ce1 <__panic>
  1045e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045e8:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return &a[PTX(la)];
  1045f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f3:	c1 e8 0c             	shr    $0xc,%eax
  1045f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  1045fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104602:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104605:	01 d0                	add    %edx,%eax
}
  104607:	c9                   	leave  
  104608:	c3                   	ret    

00104609 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104609:	55                   	push   %ebp
  10460a:	89 e5                	mov    %esp,%ebp
  10460c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10460f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104616:	00 
  104617:	8b 45 0c             	mov    0xc(%ebp),%eax
  10461a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10461e:	8b 45 08             	mov    0x8(%ebp),%eax
  104621:	89 04 24             	mov    %eax,(%esp)
  104624:	e8 98 fe ff ff       	call   1044c1 <get_pte>
  104629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10462c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104630:	74 08                	je     10463a <get_page+0x31>
        *ptep_store = ptep;
  104632:	8b 45 10             	mov    0x10(%ebp),%eax
  104635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104638:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10463a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10463e:	74 1b                	je     10465b <get_page+0x52>
  104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104643:	8b 00                	mov    (%eax),%eax
  104645:	83 e0 01             	and    $0x1,%eax
  104648:	85 c0                	test   %eax,%eax
  10464a:	74 0f                	je     10465b <get_page+0x52>
        return pa2page(*ptep);
  10464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10464f:	8b 00                	mov    (%eax),%eax
  104651:	89 04 24             	mov    %eax,(%esp)
  104654:	e8 43 f4 ff ff       	call   103a9c <pa2page>
  104659:	eb 05                	jmp    104660 <get_page+0x57>
    }
    return NULL;
  10465b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104660:	c9                   	leave  
  104661:	c3                   	ret    

00104662 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104662:	55                   	push   %ebp
  104663:	89 e5                	mov    %esp,%ebp
  104665:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    
    if(*ptep & PTE_P){
  104668:	8b 45 10             	mov    0x10(%ebp),%eax
  10466b:	8b 00                	mov    (%eax),%eax
  10466d:	83 e0 01             	and    $0x1,%eax
  104670:	85 c0                	test   %eax,%eax
  104672:	74 52                	je     1046c6 <page_remove_pte+0x64>
        struct Page *p = pte2page(*ptep);
  104674:	8b 45 10             	mov    0x10(%ebp),%eax
  104677:	8b 00                	mov    (%eax),%eax
  104679:	89 04 24             	mov    %eax,(%esp)
  10467c:	e8 be f4 ff ff       	call   103b3f <pte2page>
  104681:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(p);
  104684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104687:	89 04 24             	mov    %eax,(%esp)
  10468a:	e8 1c f5 ff ff       	call   103bab <page_ref_dec>
        if(p->ref == 0)
  10468f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104692:	8b 00                	mov    (%eax),%eax
  104694:	85 c0                	test   %eax,%eax
  104696:	75 13                	jne    1046ab <page_remove_pte+0x49>
            free_page(p);
  104698:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10469f:	00 
  1046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a3:	89 04 24             	mov    %eax,(%esp)
  1046a6:	e8 0f f7 ff ff       	call   103dba <free_pages>
        *ptep = 0;
  1046ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  1046b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1046be:	89 04 24             	mov    %eax,(%esp)
  1046c1:	e8 ff 00 00 00       	call   1047c5 <tlb_invalidate>
    }
}
  1046c6:	c9                   	leave  
  1046c7:	c3                   	ret    

001046c8 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1046c8:	55                   	push   %ebp
  1046c9:	89 e5                	mov    %esp,%ebp
  1046cb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1046ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046d5:	00 
  1046d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1046e0:	89 04 24             	mov    %eax,(%esp)
  1046e3:	e8 d9 fd ff ff       	call   1044c1 <get_pte>
  1046e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1046eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046ef:	74 19                	je     10470a <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1046f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104702:	89 04 24             	mov    %eax,(%esp)
  104705:	e8 58 ff ff ff       	call   104662 <page_remove_pte>
    }
}
  10470a:	c9                   	leave  
  10470b:	c3                   	ret    

0010470c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10470c:	55                   	push   %ebp
  10470d:	89 e5                	mov    %esp,%ebp
  10470f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104712:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104719:	00 
  10471a:	8b 45 10             	mov    0x10(%ebp),%eax
  10471d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104721:	8b 45 08             	mov    0x8(%ebp),%eax
  104724:	89 04 24             	mov    %eax,(%esp)
  104727:	e8 95 fd ff ff       	call   1044c1 <get_pte>
  10472c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10472f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104733:	75 0a                	jne    10473f <page_insert+0x33>
        return -E_NO_MEM;
  104735:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10473a:	e9 84 00 00 00       	jmp    1047c3 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10473f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104742:	89 04 24             	mov    %eax,(%esp)
  104745:	e8 4a f4 ff ff       	call   103b94 <page_ref_inc>
    if (*ptep & PTE_P) {
  10474a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10474d:	8b 00                	mov    (%eax),%eax
  10474f:	83 e0 01             	and    $0x1,%eax
  104752:	85 c0                	test   %eax,%eax
  104754:	74 3e                	je     104794 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104759:	8b 00                	mov    (%eax),%eax
  10475b:	89 04 24             	mov    %eax,(%esp)
  10475e:	e8 dc f3 ff ff       	call   103b3f <pte2page>
  104763:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104769:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10476c:	75 0d                	jne    10477b <page_insert+0x6f>
            page_ref_dec(page);
  10476e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104771:	89 04 24             	mov    %eax,(%esp)
  104774:	e8 32 f4 ff ff       	call   103bab <page_ref_dec>
  104779:	eb 19                	jmp    104794 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10477b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10477e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104782:	8b 45 10             	mov    0x10(%ebp),%eax
  104785:	89 44 24 04          	mov    %eax,0x4(%esp)
  104789:	8b 45 08             	mov    0x8(%ebp),%eax
  10478c:	89 04 24             	mov    %eax,(%esp)
  10478f:	e8 ce fe ff ff       	call   104662 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104794:	8b 45 0c             	mov    0xc(%ebp),%eax
  104797:	89 04 24             	mov    %eax,(%esp)
  10479a:	e8 e7 f2 ff ff       	call   103a86 <page2pa>
  10479f:	0b 45 14             	or     0x14(%ebp),%eax
  1047a2:	83 c8 01             	or     $0x1,%eax
  1047a5:	89 c2                	mov    %eax,%edx
  1047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047aa:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1047ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1047af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1047b6:	89 04 24             	mov    %eax,(%esp)
  1047b9:	e8 07 00 00 00       	call   1047c5 <tlb_invalidate>
    return 0;
  1047be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047c3:	c9                   	leave  
  1047c4:	c3                   	ret    

001047c5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1047c5:	55                   	push   %ebp
  1047c6:	89 e5                	mov    %esp,%ebp
  1047c8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1047cb:	0f 20 d8             	mov    %cr3,%eax
  1047ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1047d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1047d4:	89 c2                	mov    %eax,%edx
  1047d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047dc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1047e3:	77 23                	ja     104808 <tlb_invalidate+0x43>
  1047e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047ec:	c7 44 24 08 b8 6b 10 	movl   $0x106bb8,0x8(%esp)
  1047f3:	00 
  1047f4:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1047fb:	00 
  1047fc:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104803:	e8 d9 c4 ff ff       	call   100ce1 <__panic>
  104808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10480b:	05 00 00 00 40       	add    $0x40000000,%eax
  104810:	39 c2                	cmp    %eax,%edx
  104812:	75 0c                	jne    104820 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104814:	8b 45 0c             	mov    0xc(%ebp),%eax
  104817:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10481a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10481d:	0f 01 38             	invlpg (%eax)
    }
}
  104820:	c9                   	leave  
  104821:	c3                   	ret    

00104822 <check_alloc_page>:

static void
check_alloc_page(void) {
  104822:	55                   	push   %ebp
  104823:	89 e5                	mov    %esp,%ebp
  104825:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104828:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10482d:	8b 40 18             	mov    0x18(%eax),%eax
  104830:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104832:	c7 04 24 3c 6c 10 00 	movl   $0x106c3c,(%esp)
  104839:	e8 fe ba ff ff       	call   10033c <cprintf>
}
  10483e:	c9                   	leave  
  10483f:	c3                   	ret    

00104840 <check_pgdir>:

static void
check_pgdir(void) {
  104840:	55                   	push   %ebp
  104841:	89 e5                	mov    %esp,%ebp
  104843:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104846:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10484b:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104850:	76 24                	jbe    104876 <check_pgdir+0x36>
  104852:	c7 44 24 0c 5b 6c 10 	movl   $0x106c5b,0xc(%esp)
  104859:	00 
  10485a:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104861:	00 
  104862:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104869:	00 
  10486a:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104871:	e8 6b c4 ff ff       	call   100ce1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104876:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10487b:	85 c0                	test   %eax,%eax
  10487d:	74 0e                	je     10488d <check_pgdir+0x4d>
  10487f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104884:	25 ff 0f 00 00       	and    $0xfff,%eax
  104889:	85 c0                	test   %eax,%eax
  10488b:	74 24                	je     1048b1 <check_pgdir+0x71>
  10488d:	c7 44 24 0c 78 6c 10 	movl   $0x106c78,0xc(%esp)
  104894:	00 
  104895:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  10489c:	00 
  10489d:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1048a4:	00 
  1048a5:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1048ac:	e8 30 c4 ff ff       	call   100ce1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1048b1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048bd:	00 
  1048be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048c5:	00 
  1048c6:	89 04 24             	mov    %eax,(%esp)
  1048c9:	e8 3b fd ff ff       	call   104609 <get_page>
  1048ce:	85 c0                	test   %eax,%eax
  1048d0:	74 24                	je     1048f6 <check_pgdir+0xb6>
  1048d2:	c7 44 24 0c b0 6c 10 	movl   $0x106cb0,0xc(%esp)
  1048d9:	00 
  1048da:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  1048e1:	00 
  1048e2:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1048e9:	00 
  1048ea:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1048f1:	e8 eb c3 ff ff       	call   100ce1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1048f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048fd:	e8 80 f4 ff ff       	call   103d82 <alloc_pages>
  104902:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104905:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10490a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104911:	00 
  104912:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104919:	00 
  10491a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10491d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104921:	89 04 24             	mov    %eax,(%esp)
  104924:	e8 e3 fd ff ff       	call   10470c <page_insert>
  104929:	85 c0                	test   %eax,%eax
  10492b:	74 24                	je     104951 <check_pgdir+0x111>
  10492d:	c7 44 24 0c d8 6c 10 	movl   $0x106cd8,0xc(%esp)
  104934:	00 
  104935:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  10493c:	00 
  10493d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104944:	00 
  104945:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  10494c:	e8 90 c3 ff ff       	call   100ce1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104951:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104956:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10495d:	00 
  10495e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104965:	00 
  104966:	89 04 24             	mov    %eax,(%esp)
  104969:	e8 53 fb ff ff       	call   1044c1 <get_pte>
  10496e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104971:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104975:	75 24                	jne    10499b <check_pgdir+0x15b>
  104977:	c7 44 24 0c 04 6d 10 	movl   $0x106d04,0xc(%esp)
  10497e:	00 
  10497f:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104986:	00 
  104987:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  10498e:	00 
  10498f:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104996:	e8 46 c3 ff ff       	call   100ce1 <__panic>
    assert(pa2page(*ptep) == p1);
  10499b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10499e:	8b 00                	mov    (%eax),%eax
  1049a0:	89 04 24             	mov    %eax,(%esp)
  1049a3:	e8 f4 f0 ff ff       	call   103a9c <pa2page>
  1049a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1049ab:	74 24                	je     1049d1 <check_pgdir+0x191>
  1049ad:	c7 44 24 0c 31 6d 10 	movl   $0x106d31,0xc(%esp)
  1049b4:	00 
  1049b5:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  1049bc:	00 
  1049bd:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  1049c4:	00 
  1049c5:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1049cc:	e8 10 c3 ff ff       	call   100ce1 <__panic>
    assert(page_ref(p1) == 1);
  1049d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d4:	89 04 24             	mov    %eax,(%esp)
  1049d7:	e8 a1 f1 ff ff       	call   103b7d <page_ref>
  1049dc:	83 f8 01             	cmp    $0x1,%eax
  1049df:	74 24                	je     104a05 <check_pgdir+0x1c5>
  1049e1:	c7 44 24 0c 46 6d 10 	movl   $0x106d46,0xc(%esp)
  1049e8:	00 
  1049e9:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  1049f0:	00 
  1049f1:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1049f8:	00 
  1049f9:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104a00:	e8 dc c2 ff ff       	call   100ce1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104a05:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a0a:	8b 00                	mov    (%eax),%eax
  104a0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104a11:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a17:	c1 e8 0c             	shr    $0xc,%eax
  104a1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104a1d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104a22:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104a25:	72 23                	jb     104a4a <check_pgdir+0x20a>
  104a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a2e:	c7 44 24 08 14 6b 10 	movl   $0x106b14,0x8(%esp)
  104a35:	00 
  104a36:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104a3d:	00 
  104a3e:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104a45:	e8 97 c2 ff ff       	call   100ce1 <__panic>
  104a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a4d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a52:	83 c0 04             	add    $0x4,%eax
  104a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a58:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a5d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a64:	00 
  104a65:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a6c:	00 
  104a6d:	89 04 24             	mov    %eax,(%esp)
  104a70:	e8 4c fa ff ff       	call   1044c1 <get_pte>
  104a75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104a78:	74 24                	je     104a9e <check_pgdir+0x25e>
  104a7a:	c7 44 24 0c 58 6d 10 	movl   $0x106d58,0xc(%esp)
  104a81:	00 
  104a82:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104a89:	00 
  104a8a:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104a91:	00 
  104a92:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104a99:	e8 43 c2 ff ff       	call   100ce1 <__panic>

    p2 = alloc_page();
  104a9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104aa5:	e8 d8 f2 ff ff       	call   103d82 <alloc_pages>
  104aaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104aad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ab2:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104ab9:	00 
  104aba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104ac1:	00 
  104ac2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104ac5:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ac9:	89 04 24             	mov    %eax,(%esp)
  104acc:	e8 3b fc ff ff       	call   10470c <page_insert>
  104ad1:	85 c0                	test   %eax,%eax
  104ad3:	74 24                	je     104af9 <check_pgdir+0x2b9>
  104ad5:	c7 44 24 0c 80 6d 10 	movl   $0x106d80,0xc(%esp)
  104adc:	00 
  104add:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104ae4:	00 
  104ae5:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104aec:	00 
  104aed:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104af4:	e8 e8 c1 ff ff       	call   100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104af9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104afe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b05:	00 
  104b06:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b0d:	00 
  104b0e:	89 04 24             	mov    %eax,(%esp)
  104b11:	e8 ab f9 ff ff       	call   1044c1 <get_pte>
  104b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b1d:	75 24                	jne    104b43 <check_pgdir+0x303>
  104b1f:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104b26:	00 
  104b27:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104b2e:	00 
  104b2f:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104b36:	00 
  104b37:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104b3e:	e8 9e c1 ff ff       	call   100ce1 <__panic>
    assert(*ptep & PTE_U);
  104b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b46:	8b 00                	mov    (%eax),%eax
  104b48:	83 e0 04             	and    $0x4,%eax
  104b4b:	85 c0                	test   %eax,%eax
  104b4d:	75 24                	jne    104b73 <check_pgdir+0x333>
  104b4f:	c7 44 24 0c e8 6d 10 	movl   $0x106de8,0xc(%esp)
  104b56:	00 
  104b57:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104b5e:	00 
  104b5f:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104b66:	00 
  104b67:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104b6e:	e8 6e c1 ff ff       	call   100ce1 <__panic>
    assert(*ptep & PTE_W);
  104b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b76:	8b 00                	mov    (%eax),%eax
  104b78:	83 e0 02             	and    $0x2,%eax
  104b7b:	85 c0                	test   %eax,%eax
  104b7d:	75 24                	jne    104ba3 <check_pgdir+0x363>
  104b7f:	c7 44 24 0c f6 6d 10 	movl   $0x106df6,0xc(%esp)
  104b86:	00 
  104b87:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104b8e:	00 
  104b8f:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104b96:	00 
  104b97:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104b9e:	e8 3e c1 ff ff       	call   100ce1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104ba3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ba8:	8b 00                	mov    (%eax),%eax
  104baa:	83 e0 04             	and    $0x4,%eax
  104bad:	85 c0                	test   %eax,%eax
  104baf:	75 24                	jne    104bd5 <check_pgdir+0x395>
  104bb1:	c7 44 24 0c 04 6e 10 	movl   $0x106e04,0xc(%esp)
  104bb8:	00 
  104bb9:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104bc0:	00 
  104bc1:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104bc8:	00 
  104bc9:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104bd0:	e8 0c c1 ff ff       	call   100ce1 <__panic>
    assert(page_ref(p2) == 1);
  104bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bd8:	89 04 24             	mov    %eax,(%esp)
  104bdb:	e8 9d ef ff ff       	call   103b7d <page_ref>
  104be0:	83 f8 01             	cmp    $0x1,%eax
  104be3:	74 24                	je     104c09 <check_pgdir+0x3c9>
  104be5:	c7 44 24 0c 1a 6e 10 	movl   $0x106e1a,0xc(%esp)
  104bec:	00 
  104bed:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104bf4:	00 
  104bf5:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104bfc:	00 
  104bfd:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104c04:	e8 d8 c0 ff ff       	call   100ce1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104c09:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c0e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104c15:	00 
  104c16:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c1d:	00 
  104c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c21:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c25:	89 04 24             	mov    %eax,(%esp)
  104c28:	e8 df fa ff ff       	call   10470c <page_insert>
  104c2d:	85 c0                	test   %eax,%eax
  104c2f:	74 24                	je     104c55 <check_pgdir+0x415>
  104c31:	c7 44 24 0c 2c 6e 10 	movl   $0x106e2c,0xc(%esp)
  104c38:	00 
  104c39:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104c40:	00 
  104c41:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104c48:	00 
  104c49:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104c50:	e8 8c c0 ff ff       	call   100ce1 <__panic>
    assert(page_ref(p1) == 2);
  104c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c58:	89 04 24             	mov    %eax,(%esp)
  104c5b:	e8 1d ef ff ff       	call   103b7d <page_ref>
  104c60:	83 f8 02             	cmp    $0x2,%eax
  104c63:	74 24                	je     104c89 <check_pgdir+0x449>
  104c65:	c7 44 24 0c 58 6e 10 	movl   $0x106e58,0xc(%esp)
  104c6c:	00 
  104c6d:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104c74:	00 
  104c75:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104c7c:	00 
  104c7d:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104c84:	e8 58 c0 ff ff       	call   100ce1 <__panic>
    assert(page_ref(p2) == 0);
  104c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c8c:	89 04 24             	mov    %eax,(%esp)
  104c8f:	e8 e9 ee ff ff       	call   103b7d <page_ref>
  104c94:	85 c0                	test   %eax,%eax
  104c96:	74 24                	je     104cbc <check_pgdir+0x47c>
  104c98:	c7 44 24 0c 6a 6e 10 	movl   $0x106e6a,0xc(%esp)
  104c9f:	00 
  104ca0:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104ca7:	00 
  104ca8:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104caf:	00 
  104cb0:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104cb7:	e8 25 c0 ff ff       	call   100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104cbc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cc1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cc8:	00 
  104cc9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cd0:	00 
  104cd1:	89 04 24             	mov    %eax,(%esp)
  104cd4:	e8 e8 f7 ff ff       	call   1044c1 <get_pte>
  104cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ce0:	75 24                	jne    104d06 <check_pgdir+0x4c6>
  104ce2:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104ce9:	00 
  104cea:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104cf1:	00 
  104cf2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104cf9:	00 
  104cfa:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104d01:	e8 db bf ff ff       	call   100ce1 <__panic>
    assert(pa2page(*ptep) == p1);
  104d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d09:	8b 00                	mov    (%eax),%eax
  104d0b:	89 04 24             	mov    %eax,(%esp)
  104d0e:	e8 89 ed ff ff       	call   103a9c <pa2page>
  104d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d16:	74 24                	je     104d3c <check_pgdir+0x4fc>
  104d18:	c7 44 24 0c 31 6d 10 	movl   $0x106d31,0xc(%esp)
  104d1f:	00 
  104d20:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104d27:	00 
  104d28:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d2f:	00 
  104d30:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104d37:	e8 a5 bf ff ff       	call   100ce1 <__panic>
    assert((*ptep & PTE_U) == 0);
  104d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d3f:	8b 00                	mov    (%eax),%eax
  104d41:	83 e0 04             	and    $0x4,%eax
  104d44:	85 c0                	test   %eax,%eax
  104d46:	74 24                	je     104d6c <check_pgdir+0x52c>
  104d48:	c7 44 24 0c 7c 6e 10 	movl   $0x106e7c,0xc(%esp)
  104d4f:	00 
  104d50:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104d57:	00 
  104d58:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104d5f:	00 
  104d60:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104d67:	e8 75 bf ff ff       	call   100ce1 <__panic>

    page_remove(boot_pgdir, 0x0);
  104d6c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d78:	00 
  104d79:	89 04 24             	mov    %eax,(%esp)
  104d7c:	e8 47 f9 ff ff       	call   1046c8 <page_remove>
    assert(page_ref(p1) == 1);
  104d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d84:	89 04 24             	mov    %eax,(%esp)
  104d87:	e8 f1 ed ff ff       	call   103b7d <page_ref>
  104d8c:	83 f8 01             	cmp    $0x1,%eax
  104d8f:	74 24                	je     104db5 <check_pgdir+0x575>
  104d91:	c7 44 24 0c 46 6d 10 	movl   $0x106d46,0xc(%esp)
  104d98:	00 
  104d99:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104da0:	00 
  104da1:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104da8:	00 
  104da9:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104db0:	e8 2c bf ff ff       	call   100ce1 <__panic>
    assert(page_ref(p2) == 0);
  104db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104db8:	89 04 24             	mov    %eax,(%esp)
  104dbb:	e8 bd ed ff ff       	call   103b7d <page_ref>
  104dc0:	85 c0                	test   %eax,%eax
  104dc2:	74 24                	je     104de8 <check_pgdir+0x5a8>
  104dc4:	c7 44 24 0c 6a 6e 10 	movl   $0x106e6a,0xc(%esp)
  104dcb:	00 
  104dcc:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104dd3:	00 
  104dd4:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104ddb:	00 
  104ddc:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104de3:	e8 f9 be ff ff       	call   100ce1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104de8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ded:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104df4:	00 
  104df5:	89 04 24             	mov    %eax,(%esp)
  104df8:	e8 cb f8 ff ff       	call   1046c8 <page_remove>
    assert(page_ref(p1) == 0);
  104dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e00:	89 04 24             	mov    %eax,(%esp)
  104e03:	e8 75 ed ff ff       	call   103b7d <page_ref>
  104e08:	85 c0                	test   %eax,%eax
  104e0a:	74 24                	je     104e30 <check_pgdir+0x5f0>
  104e0c:	c7 44 24 0c 91 6e 10 	movl   $0x106e91,0xc(%esp)
  104e13:	00 
  104e14:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104e1b:	00 
  104e1c:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104e23:	00 
  104e24:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104e2b:	e8 b1 be ff ff       	call   100ce1 <__panic>
    assert(page_ref(p2) == 0);
  104e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e33:	89 04 24             	mov    %eax,(%esp)
  104e36:	e8 42 ed ff ff       	call   103b7d <page_ref>
  104e3b:	85 c0                	test   %eax,%eax
  104e3d:	74 24                	je     104e63 <check_pgdir+0x623>
  104e3f:	c7 44 24 0c 6a 6e 10 	movl   $0x106e6a,0xc(%esp)
  104e46:	00 
  104e47:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104e4e:	00 
  104e4f:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104e56:	00 
  104e57:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104e5e:	e8 7e be ff ff       	call   100ce1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104e63:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e68:	8b 00                	mov    (%eax),%eax
  104e6a:	89 04 24             	mov    %eax,(%esp)
  104e6d:	e8 2a ec ff ff       	call   103a9c <pa2page>
  104e72:	89 04 24             	mov    %eax,(%esp)
  104e75:	e8 03 ed ff ff       	call   103b7d <page_ref>
  104e7a:	83 f8 01             	cmp    $0x1,%eax
  104e7d:	74 24                	je     104ea3 <check_pgdir+0x663>
  104e7f:	c7 44 24 0c a4 6e 10 	movl   $0x106ea4,0xc(%esp)
  104e86:	00 
  104e87:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104e8e:	00 
  104e8f:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104e96:	00 
  104e97:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104e9e:	e8 3e be ff ff       	call   100ce1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104ea3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ea8:	8b 00                	mov    (%eax),%eax
  104eaa:	89 04 24             	mov    %eax,(%esp)
  104ead:	e8 ea eb ff ff       	call   103a9c <pa2page>
  104eb2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104eb9:	00 
  104eba:	89 04 24             	mov    %eax,(%esp)
  104ebd:	e8 f8 ee ff ff       	call   103dba <free_pages>
    boot_pgdir[0] = 0;
  104ec2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104ecd:	c7 04 24 ca 6e 10 00 	movl   $0x106eca,(%esp)
  104ed4:	e8 63 b4 ff ff       	call   10033c <cprintf>
}
  104ed9:	c9                   	leave  
  104eda:	c3                   	ret    

00104edb <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104edb:	55                   	push   %ebp
  104edc:	89 e5                	mov    %esp,%ebp
  104ede:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ee1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ee8:	e9 ca 00 00 00       	jmp    104fb7 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef6:	c1 e8 0c             	shr    $0xc,%eax
  104ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104efc:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f01:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104f04:	72 23                	jb     104f29 <check_boot_pgdir+0x4e>
  104f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f09:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f0d:	c7 44 24 08 14 6b 10 	movl   $0x106b14,0x8(%esp)
  104f14:	00 
  104f15:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104f1c:	00 
  104f1d:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104f24:	e8 b8 bd ff ff       	call   100ce1 <__panic>
  104f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f2c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104f31:	89 c2                	mov    %eax,%edx
  104f33:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f38:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f3f:	00 
  104f40:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f44:	89 04 24             	mov    %eax,(%esp)
  104f47:	e8 75 f5 ff ff       	call   1044c1 <get_pte>
  104f4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104f4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104f53:	75 24                	jne    104f79 <check_boot_pgdir+0x9e>
  104f55:	c7 44 24 0c e4 6e 10 	movl   $0x106ee4,0xc(%esp)
  104f5c:	00 
  104f5d:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104f64:	00 
  104f65:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104f6c:	00 
  104f6d:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104f74:	e8 68 bd ff ff       	call   100ce1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f7c:	8b 00                	mov    (%eax),%eax
  104f7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f83:	89 c2                	mov    %eax,%edx
  104f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f88:	39 c2                	cmp    %eax,%edx
  104f8a:	74 24                	je     104fb0 <check_boot_pgdir+0xd5>
  104f8c:	c7 44 24 0c 21 6f 10 	movl   $0x106f21,0xc(%esp)
  104f93:	00 
  104f94:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  104f9b:	00 
  104f9c:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104fa3:	00 
  104fa4:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  104fab:	e8 31 bd ff ff       	call   100ce1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104fb0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104fba:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104fbf:	39 c2                	cmp    %eax,%edx
  104fc1:	0f 82 26 ff ff ff    	jb     104eed <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104fc7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fcc:	05 ac 0f 00 00       	add    $0xfac,%eax
  104fd1:	8b 00                	mov    (%eax),%eax
  104fd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104fd8:	89 c2                	mov    %eax,%edx
  104fda:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104fe2:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104fe9:	77 23                	ja     10500e <check_boot_pgdir+0x133>
  104feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ff2:	c7 44 24 08 b8 6b 10 	movl   $0x106bb8,0x8(%esp)
  104ff9:	00 
  104ffa:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  105001:	00 
  105002:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  105009:	e8 d3 bc ff ff       	call   100ce1 <__panic>
  10500e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105011:	05 00 00 00 40       	add    $0x40000000,%eax
  105016:	39 c2                	cmp    %eax,%edx
  105018:	74 24                	je     10503e <check_boot_pgdir+0x163>
  10501a:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  105021:	00 
  105022:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  105029:	00 
  10502a:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  105031:	00 
  105032:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  105039:	e8 a3 bc ff ff       	call   100ce1 <__panic>

    assert(boot_pgdir[0] == 0);
  10503e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105043:	8b 00                	mov    (%eax),%eax
  105045:	85 c0                	test   %eax,%eax
  105047:	74 24                	je     10506d <check_boot_pgdir+0x192>
  105049:	c7 44 24 0c 6c 6f 10 	movl   $0x106f6c,0xc(%esp)
  105050:	00 
  105051:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  105058:	00 
  105059:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105060:	00 
  105061:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  105068:	e8 74 bc ff ff       	call   100ce1 <__panic>

    struct Page *p;
    p = alloc_page();
  10506d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105074:	e8 09 ed ff ff       	call   103d82 <alloc_pages>
  105079:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10507c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105081:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105088:	00 
  105089:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105090:	00 
  105091:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105094:	89 54 24 04          	mov    %edx,0x4(%esp)
  105098:	89 04 24             	mov    %eax,(%esp)
  10509b:	e8 6c f6 ff ff       	call   10470c <page_insert>
  1050a0:	85 c0                	test   %eax,%eax
  1050a2:	74 24                	je     1050c8 <check_boot_pgdir+0x1ed>
  1050a4:	c7 44 24 0c 80 6f 10 	movl   $0x106f80,0xc(%esp)
  1050ab:	00 
  1050ac:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  1050b3:	00 
  1050b4:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  1050bb:	00 
  1050bc:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1050c3:	e8 19 bc ff ff       	call   100ce1 <__panic>
    assert(page_ref(p) == 1);
  1050c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050cb:	89 04 24             	mov    %eax,(%esp)
  1050ce:	e8 aa ea ff ff       	call   103b7d <page_ref>
  1050d3:	83 f8 01             	cmp    $0x1,%eax
  1050d6:	74 24                	je     1050fc <check_boot_pgdir+0x221>
  1050d8:	c7 44 24 0c ae 6f 10 	movl   $0x106fae,0xc(%esp)
  1050df:	00 
  1050e0:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  1050e7:	00 
  1050e8:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  1050ef:	00 
  1050f0:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1050f7:	e8 e5 bb ff ff       	call   100ce1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1050fc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105101:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105108:	00 
  105109:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105110:	00 
  105111:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105114:	89 54 24 04          	mov    %edx,0x4(%esp)
  105118:	89 04 24             	mov    %eax,(%esp)
  10511b:	e8 ec f5 ff ff       	call   10470c <page_insert>
  105120:	85 c0                	test   %eax,%eax
  105122:	74 24                	je     105148 <check_boot_pgdir+0x26d>
  105124:	c7 44 24 0c c0 6f 10 	movl   $0x106fc0,0xc(%esp)
  10512b:	00 
  10512c:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  105133:	00 
  105134:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  10513b:	00 
  10513c:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  105143:	e8 99 bb ff ff       	call   100ce1 <__panic>
    assert(page_ref(p) == 2);
  105148:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10514b:	89 04 24             	mov    %eax,(%esp)
  10514e:	e8 2a ea ff ff       	call   103b7d <page_ref>
  105153:	83 f8 02             	cmp    $0x2,%eax
  105156:	74 24                	je     10517c <check_boot_pgdir+0x2a1>
  105158:	c7 44 24 0c f7 6f 10 	movl   $0x106ff7,0xc(%esp)
  10515f:	00 
  105160:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  105167:	00 
  105168:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10516f:	00 
  105170:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  105177:	e8 65 bb ff ff       	call   100ce1 <__panic>

    const char *str = "ucore: Hello world!!";
  10517c:	c7 45 dc 08 70 10 00 	movl   $0x107008,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105183:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105186:	89 44 24 04          	mov    %eax,0x4(%esp)
  10518a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105191:	e8 1e 0a 00 00       	call   105bb4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105196:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10519d:	00 
  10519e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051a5:	e8 83 0a 00 00       	call   105c2d <strcmp>
  1051aa:	85 c0                	test   %eax,%eax
  1051ac:	74 24                	je     1051d2 <check_boot_pgdir+0x2f7>
  1051ae:	c7 44 24 0c 20 70 10 	movl   $0x107020,0xc(%esp)
  1051b5:	00 
  1051b6:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  1051bd:	00 
  1051be:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  1051c5:	00 
  1051c6:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  1051cd:	e8 0f bb ff ff       	call   100ce1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1051d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051d5:	89 04 24             	mov    %eax,(%esp)
  1051d8:	e8 0e e9 ff ff       	call   103aeb <page2kva>
  1051dd:	05 00 01 00 00       	add    $0x100,%eax
  1051e2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1051e5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051ec:	e8 6b 09 00 00       	call   105b5c <strlen>
  1051f1:	85 c0                	test   %eax,%eax
  1051f3:	74 24                	je     105219 <check_boot_pgdir+0x33e>
  1051f5:	c7 44 24 0c 58 70 10 	movl   $0x107058,0xc(%esp)
  1051fc:	00 
  1051fd:	c7 44 24 08 01 6c 10 	movl   $0x106c01,0x8(%esp)
  105204:	00 
  105205:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  10520c:	00 
  10520d:	c7 04 24 dc 6b 10 00 	movl   $0x106bdc,(%esp)
  105214:	e8 c8 ba ff ff       	call   100ce1 <__panic>

    free_page(p);
  105219:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105220:	00 
  105221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105224:	89 04 24             	mov    %eax,(%esp)
  105227:	e8 8e eb ff ff       	call   103dba <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10522c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105231:	8b 00                	mov    (%eax),%eax
  105233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105238:	89 04 24             	mov    %eax,(%esp)
  10523b:	e8 5c e8 ff ff       	call   103a9c <pa2page>
  105240:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105247:	00 
  105248:	89 04 24             	mov    %eax,(%esp)
  10524b:	e8 6a eb ff ff       	call   103dba <free_pages>
    boot_pgdir[0] = 0;
  105250:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10525b:	c7 04 24 7c 70 10 00 	movl   $0x10707c,(%esp)
  105262:	e8 d5 b0 ff ff       	call   10033c <cprintf>
}
  105267:	c9                   	leave  
  105268:	c3                   	ret    

00105269 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105269:	55                   	push   %ebp
  10526a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10526c:	8b 45 08             	mov    0x8(%ebp),%eax
  10526f:	83 e0 04             	and    $0x4,%eax
  105272:	85 c0                	test   %eax,%eax
  105274:	74 07                	je     10527d <perm2str+0x14>
  105276:	b8 75 00 00 00       	mov    $0x75,%eax
  10527b:	eb 05                	jmp    105282 <perm2str+0x19>
  10527d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105282:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105287:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10528e:	8b 45 08             	mov    0x8(%ebp),%eax
  105291:	83 e0 02             	and    $0x2,%eax
  105294:	85 c0                	test   %eax,%eax
  105296:	74 07                	je     10529f <perm2str+0x36>
  105298:	b8 77 00 00 00       	mov    $0x77,%eax
  10529d:	eb 05                	jmp    1052a4 <perm2str+0x3b>
  10529f:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1052a4:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1052a9:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1052b0:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1052b5:	5d                   	pop    %ebp
  1052b6:	c3                   	ret    

001052b7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1052b7:	55                   	push   %ebp
  1052b8:	89 e5                	mov    %esp,%ebp
  1052ba:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1052bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1052c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052c3:	72 0a                	jb     1052cf <get_pgtable_items+0x18>
        return 0;
  1052c5:	b8 00 00 00 00       	mov    $0x0,%eax
  1052ca:	e9 9c 00 00 00       	jmp    10536b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1052cf:	eb 04                	jmp    1052d5 <get_pgtable_items+0x1e>
        start ++;
  1052d1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1052d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1052d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052db:	73 18                	jae    1052f5 <get_pgtable_items+0x3e>
  1052dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1052e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1052ea:	01 d0                	add    %edx,%eax
  1052ec:	8b 00                	mov    (%eax),%eax
  1052ee:	83 e0 01             	and    $0x1,%eax
  1052f1:	85 c0                	test   %eax,%eax
  1052f3:	74 dc                	je     1052d1 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1052f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1052f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052fb:	73 69                	jae    105366 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1052fd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105301:	74 08                	je     10530b <get_pgtable_items+0x54>
            *left_store = start;
  105303:	8b 45 18             	mov    0x18(%ebp),%eax
  105306:	8b 55 10             	mov    0x10(%ebp),%edx
  105309:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10530b:	8b 45 10             	mov    0x10(%ebp),%eax
  10530e:	8d 50 01             	lea    0x1(%eax),%edx
  105311:	89 55 10             	mov    %edx,0x10(%ebp)
  105314:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10531b:	8b 45 14             	mov    0x14(%ebp),%eax
  10531e:	01 d0                	add    %edx,%eax
  105320:	8b 00                	mov    (%eax),%eax
  105322:	83 e0 07             	and    $0x7,%eax
  105325:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105328:	eb 04                	jmp    10532e <get_pgtable_items+0x77>
            start ++;
  10532a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10532e:	8b 45 10             	mov    0x10(%ebp),%eax
  105331:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105334:	73 1d                	jae    105353 <get_pgtable_items+0x9c>
  105336:	8b 45 10             	mov    0x10(%ebp),%eax
  105339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105340:	8b 45 14             	mov    0x14(%ebp),%eax
  105343:	01 d0                	add    %edx,%eax
  105345:	8b 00                	mov    (%eax),%eax
  105347:	83 e0 07             	and    $0x7,%eax
  10534a:	89 c2                	mov    %eax,%edx
  10534c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10534f:	39 c2                	cmp    %eax,%edx
  105351:	74 d7                	je     10532a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105353:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105357:	74 08                	je     105361 <get_pgtable_items+0xaa>
            *right_store = start;
  105359:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10535c:	8b 55 10             	mov    0x10(%ebp),%edx
  10535f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105364:	eb 05                	jmp    10536b <get_pgtable_items+0xb4>
    }
    return 0;
  105366:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10536b:	c9                   	leave  
  10536c:	c3                   	ret    

0010536d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10536d:	55                   	push   %ebp
  10536e:	89 e5                	mov    %esp,%ebp
  105370:	57                   	push   %edi
  105371:	56                   	push   %esi
  105372:	53                   	push   %ebx
  105373:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105376:	c7 04 24 9c 70 10 00 	movl   $0x10709c,(%esp)
  10537d:	e8 ba af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105382:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105389:	e9 fa 00 00 00       	jmp    105488 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10538e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105391:	89 04 24             	mov    %eax,(%esp)
  105394:	e8 d0 fe ff ff       	call   105269 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105399:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10539c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10539f:	29 d1                	sub    %edx,%ecx
  1053a1:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1053a3:	89 d6                	mov    %edx,%esi
  1053a5:	c1 e6 16             	shl    $0x16,%esi
  1053a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1053ab:	89 d3                	mov    %edx,%ebx
  1053ad:	c1 e3 16             	shl    $0x16,%ebx
  1053b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053b3:	89 d1                	mov    %edx,%ecx
  1053b5:	c1 e1 16             	shl    $0x16,%ecx
  1053b8:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1053bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1053be:	29 d7                	sub    %edx,%edi
  1053c0:	89 fa                	mov    %edi,%edx
  1053c2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053d6:	c7 04 24 cd 70 10 00 	movl   $0x1070cd,(%esp)
  1053dd:	e8 5a af ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1053e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053e5:	c1 e0 0a             	shl    $0xa,%eax
  1053e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053eb:	eb 54                	jmp    105441 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053f0:	89 04 24             	mov    %eax,(%esp)
  1053f3:	e8 71 fe ff ff       	call   105269 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1053f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1053fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053fe:	29 d1                	sub    %edx,%ecx
  105400:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105402:	89 d6                	mov    %edx,%esi
  105404:	c1 e6 0c             	shl    $0xc,%esi
  105407:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10540a:	89 d3                	mov    %edx,%ebx
  10540c:	c1 e3 0c             	shl    $0xc,%ebx
  10540f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105412:	c1 e2 0c             	shl    $0xc,%edx
  105415:	89 d1                	mov    %edx,%ecx
  105417:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10541a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10541d:	29 d7                	sub    %edx,%edi
  10541f:	89 fa                	mov    %edi,%edx
  105421:	89 44 24 14          	mov    %eax,0x14(%esp)
  105425:	89 74 24 10          	mov    %esi,0x10(%esp)
  105429:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10542d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105431:	89 54 24 04          	mov    %edx,0x4(%esp)
  105435:	c7 04 24 ec 70 10 00 	movl   $0x1070ec,(%esp)
  10543c:	e8 fb ae ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105441:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105449:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10544c:	89 ce                	mov    %ecx,%esi
  10544e:	c1 e6 0a             	shl    $0xa,%esi
  105451:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105454:	89 cb                	mov    %ecx,%ebx
  105456:	c1 e3 0a             	shl    $0xa,%ebx
  105459:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  10545c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105460:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105463:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105467:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10546b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10546f:	89 74 24 04          	mov    %esi,0x4(%esp)
  105473:	89 1c 24             	mov    %ebx,(%esp)
  105476:	e8 3c fe ff ff       	call   1052b7 <get_pgtable_items>
  10547b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10547e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105482:	0f 85 65 ff ff ff    	jne    1053ed <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105488:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10548d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105490:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105493:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105497:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10549a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10549e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054a6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1054ad:	00 
  1054ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054b5:	e8 fd fd ff ff       	call   1052b7 <get_pgtable_items>
  1054ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054c1:	0f 85 c7 fe ff ff    	jne    10538e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1054c7:	c7 04 24 10 71 10 00 	movl   $0x107110,(%esp)
  1054ce:	e8 69 ae ff ff       	call   10033c <cprintf>
}
  1054d3:	83 c4 4c             	add    $0x4c,%esp
  1054d6:	5b                   	pop    %ebx
  1054d7:	5e                   	pop    %esi
  1054d8:	5f                   	pop    %edi
  1054d9:	5d                   	pop    %ebp
  1054da:	c3                   	ret    

001054db <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1054db:	55                   	push   %ebp
  1054dc:	89 e5                	mov    %esp,%ebp
  1054de:	83 ec 58             	sub    $0x58,%esp
  1054e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1054e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1054e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1054ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1054f9:	8b 45 18             	mov    0x18(%ebp),%eax
  1054fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105505:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105508:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10550b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10550e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105511:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105515:	74 1c                	je     105533 <printnum+0x58>
  105517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10551a:	ba 00 00 00 00       	mov    $0x0,%edx
  10551f:	f7 75 e4             	divl   -0x1c(%ebp)
  105522:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105528:	ba 00 00 00 00       	mov    $0x0,%edx
  10552d:	f7 75 e4             	divl   -0x1c(%ebp)
  105530:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105536:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105539:	f7 75 e4             	divl   -0x1c(%ebp)
  10553c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10553f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105548:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10554b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10554e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105551:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105554:	8b 45 18             	mov    0x18(%ebp),%eax
  105557:	ba 00 00 00 00       	mov    $0x0,%edx
  10555c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10555f:	77 56                	ja     1055b7 <printnum+0xdc>
  105561:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105564:	72 05                	jb     10556b <printnum+0x90>
  105566:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105569:	77 4c                	ja     1055b7 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10556b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10556e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105571:	8b 45 20             	mov    0x20(%ebp),%eax
  105574:	89 44 24 18          	mov    %eax,0x18(%esp)
  105578:	89 54 24 14          	mov    %edx,0x14(%esp)
  10557c:	8b 45 18             	mov    0x18(%ebp),%eax
  10557f:	89 44 24 10          	mov    %eax,0x10(%esp)
  105583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105586:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105589:	89 44 24 08          	mov    %eax,0x8(%esp)
  10558d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105591:	8b 45 0c             	mov    0xc(%ebp),%eax
  105594:	89 44 24 04          	mov    %eax,0x4(%esp)
  105598:	8b 45 08             	mov    0x8(%ebp),%eax
  10559b:	89 04 24             	mov    %eax,(%esp)
  10559e:	e8 38 ff ff ff       	call   1054db <printnum>
  1055a3:	eb 1c                	jmp    1055c1 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1055a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ac:	8b 45 20             	mov    0x20(%ebp),%eax
  1055af:	89 04 24             	mov    %eax,(%esp)
  1055b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b5:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1055b7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1055bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1055bf:	7f e4                	jg     1055a5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1055c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1055c4:	05 c4 71 10 00       	add    $0x1071c4,%eax
  1055c9:	0f b6 00             	movzbl (%eax),%eax
  1055cc:	0f be c0             	movsbl %al,%eax
  1055cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055d6:	89 04 24             	mov    %eax,(%esp)
  1055d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055dc:	ff d0                	call   *%eax
}
  1055de:	c9                   	leave  
  1055df:	c3                   	ret    

001055e0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1055e0:	55                   	push   %ebp
  1055e1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055e3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055e7:	7e 14                	jle    1055fd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1055e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ec:	8b 00                	mov    (%eax),%eax
  1055ee:	8d 48 08             	lea    0x8(%eax),%ecx
  1055f1:	8b 55 08             	mov    0x8(%ebp),%edx
  1055f4:	89 0a                	mov    %ecx,(%edx)
  1055f6:	8b 50 04             	mov    0x4(%eax),%edx
  1055f9:	8b 00                	mov    (%eax),%eax
  1055fb:	eb 30                	jmp    10562d <getuint+0x4d>
    }
    else if (lflag) {
  1055fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105601:	74 16                	je     105619 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105603:	8b 45 08             	mov    0x8(%ebp),%eax
  105606:	8b 00                	mov    (%eax),%eax
  105608:	8d 48 04             	lea    0x4(%eax),%ecx
  10560b:	8b 55 08             	mov    0x8(%ebp),%edx
  10560e:	89 0a                	mov    %ecx,(%edx)
  105610:	8b 00                	mov    (%eax),%eax
  105612:	ba 00 00 00 00       	mov    $0x0,%edx
  105617:	eb 14                	jmp    10562d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105619:	8b 45 08             	mov    0x8(%ebp),%eax
  10561c:	8b 00                	mov    (%eax),%eax
  10561e:	8d 48 04             	lea    0x4(%eax),%ecx
  105621:	8b 55 08             	mov    0x8(%ebp),%edx
  105624:	89 0a                	mov    %ecx,(%edx)
  105626:	8b 00                	mov    (%eax),%eax
  105628:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10562d:	5d                   	pop    %ebp
  10562e:	c3                   	ret    

0010562f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10562f:	55                   	push   %ebp
  105630:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105632:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105636:	7e 14                	jle    10564c <getint+0x1d>
        return va_arg(*ap, long long);
  105638:	8b 45 08             	mov    0x8(%ebp),%eax
  10563b:	8b 00                	mov    (%eax),%eax
  10563d:	8d 48 08             	lea    0x8(%eax),%ecx
  105640:	8b 55 08             	mov    0x8(%ebp),%edx
  105643:	89 0a                	mov    %ecx,(%edx)
  105645:	8b 50 04             	mov    0x4(%eax),%edx
  105648:	8b 00                	mov    (%eax),%eax
  10564a:	eb 28                	jmp    105674 <getint+0x45>
    }
    else if (lflag) {
  10564c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105650:	74 12                	je     105664 <getint+0x35>
        return va_arg(*ap, long);
  105652:	8b 45 08             	mov    0x8(%ebp),%eax
  105655:	8b 00                	mov    (%eax),%eax
  105657:	8d 48 04             	lea    0x4(%eax),%ecx
  10565a:	8b 55 08             	mov    0x8(%ebp),%edx
  10565d:	89 0a                	mov    %ecx,(%edx)
  10565f:	8b 00                	mov    (%eax),%eax
  105661:	99                   	cltd   
  105662:	eb 10                	jmp    105674 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105664:	8b 45 08             	mov    0x8(%ebp),%eax
  105667:	8b 00                	mov    (%eax),%eax
  105669:	8d 48 04             	lea    0x4(%eax),%ecx
  10566c:	8b 55 08             	mov    0x8(%ebp),%edx
  10566f:	89 0a                	mov    %ecx,(%edx)
  105671:	8b 00                	mov    (%eax),%eax
  105673:	99                   	cltd   
    }
}
  105674:	5d                   	pop    %ebp
  105675:	c3                   	ret    

00105676 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105676:	55                   	push   %ebp
  105677:	89 e5                	mov    %esp,%ebp
  105679:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10567c:	8d 45 14             	lea    0x14(%ebp),%eax
  10567f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105685:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105689:	8b 45 10             	mov    0x10(%ebp),%eax
  10568c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105690:	8b 45 0c             	mov    0xc(%ebp),%eax
  105693:	89 44 24 04          	mov    %eax,0x4(%esp)
  105697:	8b 45 08             	mov    0x8(%ebp),%eax
  10569a:	89 04 24             	mov    %eax,(%esp)
  10569d:	e8 02 00 00 00       	call   1056a4 <vprintfmt>
    va_end(ap);
}
  1056a2:	c9                   	leave  
  1056a3:	c3                   	ret    

001056a4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1056a4:	55                   	push   %ebp
  1056a5:	89 e5                	mov    %esp,%ebp
  1056a7:	56                   	push   %esi
  1056a8:	53                   	push   %ebx
  1056a9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056ac:	eb 18                	jmp    1056c6 <vprintfmt+0x22>
            if (ch == '\0') {
  1056ae:	85 db                	test   %ebx,%ebx
  1056b0:	75 05                	jne    1056b7 <vprintfmt+0x13>
                return;
  1056b2:	e9 d1 03 00 00       	jmp    105a88 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1056b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056be:	89 1c 24             	mov    %ebx,(%esp)
  1056c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c4:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1056c9:	8d 50 01             	lea    0x1(%eax),%edx
  1056cc:	89 55 10             	mov    %edx,0x10(%ebp)
  1056cf:	0f b6 00             	movzbl (%eax),%eax
  1056d2:	0f b6 d8             	movzbl %al,%ebx
  1056d5:	83 fb 25             	cmp    $0x25,%ebx
  1056d8:	75 d4                	jne    1056ae <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1056da:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1056de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1056e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1056eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1056f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1056f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1056fb:	8d 50 01             	lea    0x1(%eax),%edx
  1056fe:	89 55 10             	mov    %edx,0x10(%ebp)
  105701:	0f b6 00             	movzbl (%eax),%eax
  105704:	0f b6 d8             	movzbl %al,%ebx
  105707:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10570a:	83 f8 55             	cmp    $0x55,%eax
  10570d:	0f 87 44 03 00 00    	ja     105a57 <vprintfmt+0x3b3>
  105713:	8b 04 85 e8 71 10 00 	mov    0x1071e8(,%eax,4),%eax
  10571a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10571c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105720:	eb d6                	jmp    1056f8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105722:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105726:	eb d0                	jmp    1056f8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10572f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105732:	89 d0                	mov    %edx,%eax
  105734:	c1 e0 02             	shl    $0x2,%eax
  105737:	01 d0                	add    %edx,%eax
  105739:	01 c0                	add    %eax,%eax
  10573b:	01 d8                	add    %ebx,%eax
  10573d:	83 e8 30             	sub    $0x30,%eax
  105740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105743:	8b 45 10             	mov    0x10(%ebp),%eax
  105746:	0f b6 00             	movzbl (%eax),%eax
  105749:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10574c:	83 fb 2f             	cmp    $0x2f,%ebx
  10574f:	7e 0b                	jle    10575c <vprintfmt+0xb8>
  105751:	83 fb 39             	cmp    $0x39,%ebx
  105754:	7f 06                	jg     10575c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105756:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10575a:	eb d3                	jmp    10572f <vprintfmt+0x8b>
            goto process_precision;
  10575c:	eb 33                	jmp    105791 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  10575e:	8b 45 14             	mov    0x14(%ebp),%eax
  105761:	8d 50 04             	lea    0x4(%eax),%edx
  105764:	89 55 14             	mov    %edx,0x14(%ebp)
  105767:	8b 00                	mov    (%eax),%eax
  105769:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10576c:	eb 23                	jmp    105791 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  10576e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105772:	79 0c                	jns    105780 <vprintfmt+0xdc>
                width = 0;
  105774:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10577b:	e9 78 ff ff ff       	jmp    1056f8 <vprintfmt+0x54>
  105780:	e9 73 ff ff ff       	jmp    1056f8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105785:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10578c:	e9 67 ff ff ff       	jmp    1056f8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105791:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105795:	79 12                	jns    1057a9 <vprintfmt+0x105>
                width = precision, precision = -1;
  105797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10579a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10579d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1057a4:	e9 4f ff ff ff       	jmp    1056f8 <vprintfmt+0x54>
  1057a9:	e9 4a ff ff ff       	jmp    1056f8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1057ae:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1057b2:	e9 41 ff ff ff       	jmp    1056f8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1057b7:	8b 45 14             	mov    0x14(%ebp),%eax
  1057ba:	8d 50 04             	lea    0x4(%eax),%edx
  1057bd:	89 55 14             	mov    %edx,0x14(%ebp)
  1057c0:	8b 00                	mov    (%eax),%eax
  1057c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057c9:	89 04 24             	mov    %eax,(%esp)
  1057cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1057cf:	ff d0                	call   *%eax
            break;
  1057d1:	e9 ac 02 00 00       	jmp    105a82 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1057d6:	8b 45 14             	mov    0x14(%ebp),%eax
  1057d9:	8d 50 04             	lea    0x4(%eax),%edx
  1057dc:	89 55 14             	mov    %edx,0x14(%ebp)
  1057df:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1057e1:	85 db                	test   %ebx,%ebx
  1057e3:	79 02                	jns    1057e7 <vprintfmt+0x143>
                err = -err;
  1057e5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1057e7:	83 fb 06             	cmp    $0x6,%ebx
  1057ea:	7f 0b                	jg     1057f7 <vprintfmt+0x153>
  1057ec:	8b 34 9d a8 71 10 00 	mov    0x1071a8(,%ebx,4),%esi
  1057f3:	85 f6                	test   %esi,%esi
  1057f5:	75 23                	jne    10581a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1057f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057fb:	c7 44 24 08 d5 71 10 	movl   $0x1071d5,0x8(%esp)
  105802:	00 
  105803:	8b 45 0c             	mov    0xc(%ebp),%eax
  105806:	89 44 24 04          	mov    %eax,0x4(%esp)
  10580a:	8b 45 08             	mov    0x8(%ebp),%eax
  10580d:	89 04 24             	mov    %eax,(%esp)
  105810:	e8 61 fe ff ff       	call   105676 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105815:	e9 68 02 00 00       	jmp    105a82 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10581a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10581e:	c7 44 24 08 de 71 10 	movl   $0x1071de,0x8(%esp)
  105825:	00 
  105826:	8b 45 0c             	mov    0xc(%ebp),%eax
  105829:	89 44 24 04          	mov    %eax,0x4(%esp)
  10582d:	8b 45 08             	mov    0x8(%ebp),%eax
  105830:	89 04 24             	mov    %eax,(%esp)
  105833:	e8 3e fe ff ff       	call   105676 <printfmt>
            }
            break;
  105838:	e9 45 02 00 00       	jmp    105a82 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10583d:	8b 45 14             	mov    0x14(%ebp),%eax
  105840:	8d 50 04             	lea    0x4(%eax),%edx
  105843:	89 55 14             	mov    %edx,0x14(%ebp)
  105846:	8b 30                	mov    (%eax),%esi
  105848:	85 f6                	test   %esi,%esi
  10584a:	75 05                	jne    105851 <vprintfmt+0x1ad>
                p = "(null)";
  10584c:	be e1 71 10 00       	mov    $0x1071e1,%esi
            }
            if (width > 0 && padc != '-') {
  105851:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105855:	7e 3e                	jle    105895 <vprintfmt+0x1f1>
  105857:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10585b:	74 38                	je     105895 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10585d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105863:	89 44 24 04          	mov    %eax,0x4(%esp)
  105867:	89 34 24             	mov    %esi,(%esp)
  10586a:	e8 15 03 00 00       	call   105b84 <strnlen>
  10586f:	29 c3                	sub    %eax,%ebx
  105871:	89 d8                	mov    %ebx,%eax
  105873:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105876:	eb 17                	jmp    10588f <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105878:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10587c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10587f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105883:	89 04 24             	mov    %eax,(%esp)
  105886:	8b 45 08             	mov    0x8(%ebp),%eax
  105889:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10588b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10588f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105893:	7f e3                	jg     105878 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105895:	eb 38                	jmp    1058cf <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105897:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10589b:	74 1f                	je     1058bc <vprintfmt+0x218>
  10589d:	83 fb 1f             	cmp    $0x1f,%ebx
  1058a0:	7e 05                	jle    1058a7 <vprintfmt+0x203>
  1058a2:	83 fb 7e             	cmp    $0x7e,%ebx
  1058a5:	7e 15                	jle    1058bc <vprintfmt+0x218>
                    putch('?', putdat);
  1058a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ae:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1058b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b8:	ff d0                	call   *%eax
  1058ba:	eb 0f                	jmp    1058cb <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1058bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058c3:	89 1c 24             	mov    %ebx,(%esp)
  1058c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c9:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058cb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058cf:	89 f0                	mov    %esi,%eax
  1058d1:	8d 70 01             	lea    0x1(%eax),%esi
  1058d4:	0f b6 00             	movzbl (%eax),%eax
  1058d7:	0f be d8             	movsbl %al,%ebx
  1058da:	85 db                	test   %ebx,%ebx
  1058dc:	74 10                	je     1058ee <vprintfmt+0x24a>
  1058de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058e2:	78 b3                	js     105897 <vprintfmt+0x1f3>
  1058e4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1058e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058ec:	79 a9                	jns    105897 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1058ee:	eb 17                	jmp    105907 <vprintfmt+0x263>
                putch(' ', putdat);
  1058f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1058fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105901:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105903:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105907:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10590b:	7f e3                	jg     1058f0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10590d:	e9 70 01 00 00       	jmp    105a82 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105915:	89 44 24 04          	mov    %eax,0x4(%esp)
  105919:	8d 45 14             	lea    0x14(%ebp),%eax
  10591c:	89 04 24             	mov    %eax,(%esp)
  10591f:	e8 0b fd ff ff       	call   10562f <getint>
  105924:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105927:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10592a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10592d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105930:	85 d2                	test   %edx,%edx
  105932:	79 26                	jns    10595a <vprintfmt+0x2b6>
                putch('-', putdat);
  105934:	8b 45 0c             	mov    0xc(%ebp),%eax
  105937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10593b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105942:	8b 45 08             	mov    0x8(%ebp),%eax
  105945:	ff d0                	call   *%eax
                num = -(long long)num;
  105947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10594a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10594d:	f7 d8                	neg    %eax
  10594f:	83 d2 00             	adc    $0x0,%edx
  105952:	f7 da                	neg    %edx
  105954:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105957:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10595a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105961:	e9 a8 00 00 00       	jmp    105a0e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105969:	89 44 24 04          	mov    %eax,0x4(%esp)
  10596d:	8d 45 14             	lea    0x14(%ebp),%eax
  105970:	89 04 24             	mov    %eax,(%esp)
  105973:	e8 68 fc ff ff       	call   1055e0 <getuint>
  105978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10597b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10597e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105985:	e9 84 00 00 00       	jmp    105a0e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10598a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10598d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105991:	8d 45 14             	lea    0x14(%ebp),%eax
  105994:	89 04 24             	mov    %eax,(%esp)
  105997:	e8 44 fc ff ff       	call   1055e0 <getuint>
  10599c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10599f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1059a2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1059a9:	eb 63                	jmp    105a0e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1059ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1059b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bc:	ff d0                	call   *%eax
            putch('x', putdat);
  1059be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c5:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1059cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059cf:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1059d1:	8b 45 14             	mov    0x14(%ebp),%eax
  1059d4:	8d 50 04             	lea    0x4(%eax),%edx
  1059d7:	89 55 14             	mov    %edx,0x14(%ebp)
  1059da:	8b 00                	mov    (%eax),%eax
  1059dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1059e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1059ed:	eb 1f                	jmp    105a0e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1059ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f6:	8d 45 14             	lea    0x14(%ebp),%eax
  1059f9:	89 04 24             	mov    %eax,(%esp)
  1059fc:	e8 df fb ff ff       	call   1055e0 <getuint>
  105a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a04:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105a07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105a0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a15:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a1c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a20:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a39:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3c:	89 04 24             	mov    %eax,(%esp)
  105a3f:	e8 97 fa ff ff       	call   1054db <printnum>
            break;
  105a44:	eb 3c                	jmp    105a82 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a4d:	89 1c 24             	mov    %ebx,(%esp)
  105a50:	8b 45 08             	mov    0x8(%ebp),%eax
  105a53:	ff d0                	call   *%eax
            break;
  105a55:	eb 2b                	jmp    105a82 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a5e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a65:	8b 45 08             	mov    0x8(%ebp),%eax
  105a68:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105a6a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a6e:	eb 04                	jmp    105a74 <vprintfmt+0x3d0>
  105a70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a74:	8b 45 10             	mov    0x10(%ebp),%eax
  105a77:	83 e8 01             	sub    $0x1,%eax
  105a7a:	0f b6 00             	movzbl (%eax),%eax
  105a7d:	3c 25                	cmp    $0x25,%al
  105a7f:	75 ef                	jne    105a70 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105a81:	90                   	nop
        }
    }
  105a82:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a83:	e9 3e fc ff ff       	jmp    1056c6 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105a88:	83 c4 40             	add    $0x40,%esp
  105a8b:	5b                   	pop    %ebx
  105a8c:	5e                   	pop    %esi
  105a8d:	5d                   	pop    %ebp
  105a8e:	c3                   	ret    

00105a8f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a8f:	55                   	push   %ebp
  105a90:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a95:	8b 40 08             	mov    0x8(%eax),%eax
  105a98:	8d 50 01             	lea    0x1(%eax),%edx
  105a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a9e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa4:	8b 10                	mov    (%eax),%edx
  105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa9:	8b 40 04             	mov    0x4(%eax),%eax
  105aac:	39 c2                	cmp    %eax,%edx
  105aae:	73 12                	jae    105ac2 <sprintputch+0x33>
        *b->buf ++ = ch;
  105ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ab3:	8b 00                	mov    (%eax),%eax
  105ab5:	8d 48 01             	lea    0x1(%eax),%ecx
  105ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  105abb:	89 0a                	mov    %ecx,(%edx)
  105abd:	8b 55 08             	mov    0x8(%ebp),%edx
  105ac0:	88 10                	mov    %dl,(%eax)
    }
}
  105ac2:	5d                   	pop    %ebp
  105ac3:	c3                   	ret    

00105ac4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105ac4:	55                   	push   %ebp
  105ac5:	89 e5                	mov    %esp,%ebp
  105ac7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105aca:	8d 45 14             	lea    0x14(%ebp),%eax
  105acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ad3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  105ada:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae8:	89 04 24             	mov    %eax,(%esp)
  105aeb:	e8 08 00 00 00       	call   105af8 <vsnprintf>
  105af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105af6:	c9                   	leave  
  105af7:	c3                   	ret    

00105af8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105af8:	55                   	push   %ebp
  105af9:	89 e5                	mov    %esp,%ebp
  105afb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105afe:	8b 45 08             	mov    0x8(%ebp),%eax
  105b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b07:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0d:	01 d0                	add    %edx,%eax
  105b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105b19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b1d:	74 0a                	je     105b29 <vsnprintf+0x31>
  105b1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b25:	39 c2                	cmp    %eax,%edx
  105b27:	76 07                	jbe    105b30 <vsnprintf+0x38>
        return -E_INVAL;
  105b29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b2e:	eb 2a                	jmp    105b5a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b30:	8b 45 14             	mov    0x14(%ebp),%eax
  105b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b37:	8b 45 10             	mov    0x10(%ebp),%eax
  105b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b45:	c7 04 24 8f 5a 10 00 	movl   $0x105a8f,(%esp)
  105b4c:	e8 53 fb ff ff       	call   1056a4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b54:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b5a:	c9                   	leave  
  105b5b:	c3                   	ret    

00105b5c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b5c:	55                   	push   %ebp
  105b5d:	89 e5                	mov    %esp,%ebp
  105b5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b69:	eb 04                	jmp    105b6f <strlen+0x13>
        cnt ++;
  105b6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b72:	8d 50 01             	lea    0x1(%eax),%edx
  105b75:	89 55 08             	mov    %edx,0x8(%ebp)
  105b78:	0f b6 00             	movzbl (%eax),%eax
  105b7b:	84 c0                	test   %al,%al
  105b7d:	75 ec                	jne    105b6b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b82:	c9                   	leave  
  105b83:	c3                   	ret    

00105b84 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b84:	55                   	push   %ebp
  105b85:	89 e5                	mov    %esp,%ebp
  105b87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b91:	eb 04                	jmp    105b97 <strnlen+0x13>
        cnt ++;
  105b93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b9d:	73 10                	jae    105baf <strnlen+0x2b>
  105b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba2:	8d 50 01             	lea    0x1(%eax),%edx
  105ba5:	89 55 08             	mov    %edx,0x8(%ebp)
  105ba8:	0f b6 00             	movzbl (%eax),%eax
  105bab:	84 c0                	test   %al,%al
  105bad:	75 e4                	jne    105b93 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105bb2:	c9                   	leave  
  105bb3:	c3                   	ret    

00105bb4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105bb4:	55                   	push   %ebp
  105bb5:	89 e5                	mov    %esp,%ebp
  105bb7:	57                   	push   %edi
  105bb8:	56                   	push   %esi
  105bb9:	83 ec 20             	sub    $0x20,%esp
  105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bce:	89 d1                	mov    %edx,%ecx
  105bd0:	89 c2                	mov    %eax,%edx
  105bd2:	89 ce                	mov    %ecx,%esi
  105bd4:	89 d7                	mov    %edx,%edi
  105bd6:	ac                   	lods   %ds:(%esi),%al
  105bd7:	aa                   	stos   %al,%es:(%edi)
  105bd8:	84 c0                	test   %al,%al
  105bda:	75 fa                	jne    105bd6 <strcpy+0x22>
  105bdc:	89 fa                	mov    %edi,%edx
  105bde:	89 f1                	mov    %esi,%ecx
  105be0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105be3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105bec:	83 c4 20             	add    $0x20,%esp
  105bef:	5e                   	pop    %esi
  105bf0:	5f                   	pop    %edi
  105bf1:	5d                   	pop    %ebp
  105bf2:	c3                   	ret    

00105bf3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105bf3:	55                   	push   %ebp
  105bf4:	89 e5                	mov    %esp,%ebp
  105bf6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105bff:	eb 21                	jmp    105c22 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c04:	0f b6 10             	movzbl (%eax),%edx
  105c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c0a:	88 10                	mov    %dl,(%eax)
  105c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c0f:	0f b6 00             	movzbl (%eax),%eax
  105c12:	84 c0                	test   %al,%al
  105c14:	74 04                	je     105c1a <strncpy+0x27>
            src ++;
  105c16:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105c1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105c1e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105c22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c26:	75 d9                	jne    105c01 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105c28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c2b:	c9                   	leave  
  105c2c:	c3                   	ret    

00105c2d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105c2d:	55                   	push   %ebp
  105c2e:	89 e5                	mov    %esp,%ebp
  105c30:	57                   	push   %edi
  105c31:	56                   	push   %esi
  105c32:	83 ec 20             	sub    $0x20,%esp
  105c35:	8b 45 08             	mov    0x8(%ebp),%eax
  105c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c47:	89 d1                	mov    %edx,%ecx
  105c49:	89 c2                	mov    %eax,%edx
  105c4b:	89 ce                	mov    %ecx,%esi
  105c4d:	89 d7                	mov    %edx,%edi
  105c4f:	ac                   	lods   %ds:(%esi),%al
  105c50:	ae                   	scas   %es:(%edi),%al
  105c51:	75 08                	jne    105c5b <strcmp+0x2e>
  105c53:	84 c0                	test   %al,%al
  105c55:	75 f8                	jne    105c4f <strcmp+0x22>
  105c57:	31 c0                	xor    %eax,%eax
  105c59:	eb 04                	jmp    105c5f <strcmp+0x32>
  105c5b:	19 c0                	sbb    %eax,%eax
  105c5d:	0c 01                	or     $0x1,%al
  105c5f:	89 fa                	mov    %edi,%edx
  105c61:	89 f1                	mov    %esi,%ecx
  105c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c66:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105c6f:	83 c4 20             	add    $0x20,%esp
  105c72:	5e                   	pop    %esi
  105c73:	5f                   	pop    %edi
  105c74:	5d                   	pop    %ebp
  105c75:	c3                   	ret    

00105c76 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105c76:	55                   	push   %ebp
  105c77:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c79:	eb 0c                	jmp    105c87 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105c7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c8b:	74 1a                	je     105ca7 <strncmp+0x31>
  105c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c90:	0f b6 00             	movzbl (%eax),%eax
  105c93:	84 c0                	test   %al,%al
  105c95:	74 10                	je     105ca7 <strncmp+0x31>
  105c97:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9a:	0f b6 10             	movzbl (%eax),%edx
  105c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ca0:	0f b6 00             	movzbl (%eax),%eax
  105ca3:	38 c2                	cmp    %al,%dl
  105ca5:	74 d4                	je     105c7b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105ca7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cab:	74 18                	je     105cc5 <strncmp+0x4f>
  105cad:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb0:	0f b6 00             	movzbl (%eax),%eax
  105cb3:	0f b6 d0             	movzbl %al,%edx
  105cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb9:	0f b6 00             	movzbl (%eax),%eax
  105cbc:	0f b6 c0             	movzbl %al,%eax
  105cbf:	29 c2                	sub    %eax,%edx
  105cc1:	89 d0                	mov    %edx,%eax
  105cc3:	eb 05                	jmp    105cca <strncmp+0x54>
  105cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cca:	5d                   	pop    %ebp
  105ccb:	c3                   	ret    

00105ccc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105ccc:	55                   	push   %ebp
  105ccd:	89 e5                	mov    %esp,%ebp
  105ccf:	83 ec 04             	sub    $0x4,%esp
  105cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105cd8:	eb 14                	jmp    105cee <strchr+0x22>
        if (*s == c) {
  105cda:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdd:	0f b6 00             	movzbl (%eax),%eax
  105ce0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ce3:	75 05                	jne    105cea <strchr+0x1e>
            return (char *)s;
  105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce8:	eb 13                	jmp    105cfd <strchr+0x31>
        }
        s ++;
  105cea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105cee:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf1:	0f b6 00             	movzbl (%eax),%eax
  105cf4:	84 c0                	test   %al,%al
  105cf6:	75 e2                	jne    105cda <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cfd:	c9                   	leave  
  105cfe:	c3                   	ret    

00105cff <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105cff:	55                   	push   %ebp
  105d00:	89 e5                	mov    %esp,%ebp
  105d02:	83 ec 04             	sub    $0x4,%esp
  105d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d08:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105d0b:	eb 11                	jmp    105d1e <strfind+0x1f>
        if (*s == c) {
  105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d10:	0f b6 00             	movzbl (%eax),%eax
  105d13:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105d16:	75 02                	jne    105d1a <strfind+0x1b>
            break;
  105d18:	eb 0e                	jmp    105d28 <strfind+0x29>
        }
        s ++;
  105d1a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d21:	0f b6 00             	movzbl (%eax),%eax
  105d24:	84 c0                	test   %al,%al
  105d26:	75 e5                	jne    105d0d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105d28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d2b:	c9                   	leave  
  105d2c:	c3                   	ret    

00105d2d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105d2d:	55                   	push   %ebp
  105d2e:	89 e5                	mov    %esp,%ebp
  105d30:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105d33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105d3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d41:	eb 04                	jmp    105d47 <strtol+0x1a>
        s ++;
  105d43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d47:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4a:	0f b6 00             	movzbl (%eax),%eax
  105d4d:	3c 20                	cmp    $0x20,%al
  105d4f:	74 f2                	je     105d43 <strtol+0x16>
  105d51:	8b 45 08             	mov    0x8(%ebp),%eax
  105d54:	0f b6 00             	movzbl (%eax),%eax
  105d57:	3c 09                	cmp    $0x9,%al
  105d59:	74 e8                	je     105d43 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5e:	0f b6 00             	movzbl (%eax),%eax
  105d61:	3c 2b                	cmp    $0x2b,%al
  105d63:	75 06                	jne    105d6b <strtol+0x3e>
        s ++;
  105d65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d69:	eb 15                	jmp    105d80 <strtol+0x53>
    }
    else if (*s == '-') {
  105d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d6e:	0f b6 00             	movzbl (%eax),%eax
  105d71:	3c 2d                	cmp    $0x2d,%al
  105d73:	75 0b                	jne    105d80 <strtol+0x53>
        s ++, neg = 1;
  105d75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d79:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d84:	74 06                	je     105d8c <strtol+0x5f>
  105d86:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d8a:	75 24                	jne    105db0 <strtol+0x83>
  105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8f:	0f b6 00             	movzbl (%eax),%eax
  105d92:	3c 30                	cmp    $0x30,%al
  105d94:	75 1a                	jne    105db0 <strtol+0x83>
  105d96:	8b 45 08             	mov    0x8(%ebp),%eax
  105d99:	83 c0 01             	add    $0x1,%eax
  105d9c:	0f b6 00             	movzbl (%eax),%eax
  105d9f:	3c 78                	cmp    $0x78,%al
  105da1:	75 0d                	jne    105db0 <strtol+0x83>
        s += 2, base = 16;
  105da3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105da7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105dae:	eb 2a                	jmp    105dda <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105db4:	75 17                	jne    105dcd <strtol+0xa0>
  105db6:	8b 45 08             	mov    0x8(%ebp),%eax
  105db9:	0f b6 00             	movzbl (%eax),%eax
  105dbc:	3c 30                	cmp    $0x30,%al
  105dbe:	75 0d                	jne    105dcd <strtol+0xa0>
        s ++, base = 8;
  105dc0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dc4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105dcb:	eb 0d                	jmp    105dda <strtol+0xad>
    }
    else if (base == 0) {
  105dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dd1:	75 07                	jne    105dda <strtol+0xad>
        base = 10;
  105dd3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105dda:	8b 45 08             	mov    0x8(%ebp),%eax
  105ddd:	0f b6 00             	movzbl (%eax),%eax
  105de0:	3c 2f                	cmp    $0x2f,%al
  105de2:	7e 1b                	jle    105dff <strtol+0xd2>
  105de4:	8b 45 08             	mov    0x8(%ebp),%eax
  105de7:	0f b6 00             	movzbl (%eax),%eax
  105dea:	3c 39                	cmp    $0x39,%al
  105dec:	7f 11                	jg     105dff <strtol+0xd2>
            dig = *s - '0';
  105dee:	8b 45 08             	mov    0x8(%ebp),%eax
  105df1:	0f b6 00             	movzbl (%eax),%eax
  105df4:	0f be c0             	movsbl %al,%eax
  105df7:	83 e8 30             	sub    $0x30,%eax
  105dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dfd:	eb 48                	jmp    105e47 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105dff:	8b 45 08             	mov    0x8(%ebp),%eax
  105e02:	0f b6 00             	movzbl (%eax),%eax
  105e05:	3c 60                	cmp    $0x60,%al
  105e07:	7e 1b                	jle    105e24 <strtol+0xf7>
  105e09:	8b 45 08             	mov    0x8(%ebp),%eax
  105e0c:	0f b6 00             	movzbl (%eax),%eax
  105e0f:	3c 7a                	cmp    $0x7a,%al
  105e11:	7f 11                	jg     105e24 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105e13:	8b 45 08             	mov    0x8(%ebp),%eax
  105e16:	0f b6 00             	movzbl (%eax),%eax
  105e19:	0f be c0             	movsbl %al,%eax
  105e1c:	83 e8 57             	sub    $0x57,%eax
  105e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e22:	eb 23                	jmp    105e47 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105e24:	8b 45 08             	mov    0x8(%ebp),%eax
  105e27:	0f b6 00             	movzbl (%eax),%eax
  105e2a:	3c 40                	cmp    $0x40,%al
  105e2c:	7e 3d                	jle    105e6b <strtol+0x13e>
  105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e31:	0f b6 00             	movzbl (%eax),%eax
  105e34:	3c 5a                	cmp    $0x5a,%al
  105e36:	7f 33                	jg     105e6b <strtol+0x13e>
            dig = *s - 'A' + 10;
  105e38:	8b 45 08             	mov    0x8(%ebp),%eax
  105e3b:	0f b6 00             	movzbl (%eax),%eax
  105e3e:	0f be c0             	movsbl %al,%eax
  105e41:	83 e8 37             	sub    $0x37,%eax
  105e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e4a:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e4d:	7c 02                	jl     105e51 <strtol+0x124>
            break;
  105e4f:	eb 1a                	jmp    105e6b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105e51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e58:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e5c:	89 c2                	mov    %eax,%edx
  105e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e61:	01 d0                	add    %edx,%eax
  105e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105e66:	e9 6f ff ff ff       	jmp    105dda <strtol+0xad>

    if (endptr) {
  105e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e6f:	74 08                	je     105e79 <strtol+0x14c>
        *endptr = (char *) s;
  105e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e74:	8b 55 08             	mov    0x8(%ebp),%edx
  105e77:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105e7d:	74 07                	je     105e86 <strtol+0x159>
  105e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e82:	f7 d8                	neg    %eax
  105e84:	eb 03                	jmp    105e89 <strtol+0x15c>
  105e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e89:	c9                   	leave  
  105e8a:	c3                   	ret    

00105e8b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e8b:	55                   	push   %ebp
  105e8c:	89 e5                	mov    %esp,%ebp
  105e8e:	57                   	push   %edi
  105e8f:	83 ec 24             	sub    $0x24,%esp
  105e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e95:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e98:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  105e9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105ea2:	88 45 f7             	mov    %al,-0x9(%ebp)
  105ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  105ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105eab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105eae:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105eb2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105eb5:	89 d7                	mov    %edx,%edi
  105eb7:	f3 aa                	rep stos %al,%es:(%edi)
  105eb9:	89 fa                	mov    %edi,%edx
  105ebb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ebe:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105ec4:	83 c4 24             	add    $0x24,%esp
  105ec7:	5f                   	pop    %edi
  105ec8:	5d                   	pop    %ebp
  105ec9:	c3                   	ret    

00105eca <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105eca:	55                   	push   %ebp
  105ecb:	89 e5                	mov    %esp,%ebp
  105ecd:	57                   	push   %edi
  105ece:	56                   	push   %esi
  105ecf:	53                   	push   %ebx
  105ed0:	83 ec 30             	sub    $0x30,%esp
  105ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105edf:	8b 45 10             	mov    0x10(%ebp),%eax
  105ee2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ee8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105eeb:	73 42                	jae    105f2f <memmove+0x65>
  105eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ef0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105efc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105eff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105f02:	c1 e8 02             	shr    $0x2,%eax
  105f05:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f0d:	89 d7                	mov    %edx,%edi
  105f0f:	89 c6                	mov    %eax,%esi
  105f11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f13:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105f16:	83 e1 03             	and    $0x3,%ecx
  105f19:	74 02                	je     105f1d <memmove+0x53>
  105f1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f1d:	89 f0                	mov    %esi,%eax
  105f1f:	89 fa                	mov    %edi,%edx
  105f21:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105f24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105f27:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f2d:	eb 36                	jmp    105f65 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f38:	01 c2                	add    %eax,%edx
  105f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f3d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f43:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f49:	89 c1                	mov    %eax,%ecx
  105f4b:	89 d8                	mov    %ebx,%eax
  105f4d:	89 d6                	mov    %edx,%esi
  105f4f:	89 c7                	mov    %eax,%edi
  105f51:	fd                   	std    
  105f52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f54:	fc                   	cld    
  105f55:	89 f8                	mov    %edi,%eax
  105f57:	89 f2                	mov    %esi,%edx
  105f59:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f5c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105f65:	83 c4 30             	add    $0x30,%esp
  105f68:	5b                   	pop    %ebx
  105f69:	5e                   	pop    %esi
  105f6a:	5f                   	pop    %edi
  105f6b:	5d                   	pop    %ebp
  105f6c:	c3                   	ret    

00105f6d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105f6d:	55                   	push   %ebp
  105f6e:	89 e5                	mov    %esp,%ebp
  105f70:	57                   	push   %edi
  105f71:	56                   	push   %esi
  105f72:	83 ec 20             	sub    $0x20,%esp
  105f75:	8b 45 08             	mov    0x8(%ebp),%eax
  105f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f81:	8b 45 10             	mov    0x10(%ebp),%eax
  105f84:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f8a:	c1 e8 02             	shr    $0x2,%eax
  105f8d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f95:	89 d7                	mov    %edx,%edi
  105f97:	89 c6                	mov    %eax,%esi
  105f99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f9b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f9e:	83 e1 03             	and    $0x3,%ecx
  105fa1:	74 02                	je     105fa5 <memcpy+0x38>
  105fa3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105fa5:	89 f0                	mov    %esi,%eax
  105fa7:	89 fa                	mov    %edi,%edx
  105fa9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105fac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105faf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105fb5:	83 c4 20             	add    $0x20,%esp
  105fb8:	5e                   	pop    %esi
  105fb9:	5f                   	pop    %edi
  105fba:	5d                   	pop    %ebp
  105fbb:	c3                   	ret    

00105fbc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105fbc:	55                   	push   %ebp
  105fbd:	89 e5                	mov    %esp,%ebp
  105fbf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  105fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105fce:	eb 30                	jmp    106000 <memcmp+0x44>
        if (*s1 != *s2) {
  105fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105fd3:	0f b6 10             	movzbl (%eax),%edx
  105fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fd9:	0f b6 00             	movzbl (%eax),%eax
  105fdc:	38 c2                	cmp    %al,%dl
  105fde:	74 18                	je     105ff8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105fe3:	0f b6 00             	movzbl (%eax),%eax
  105fe6:	0f b6 d0             	movzbl %al,%edx
  105fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fec:	0f b6 00             	movzbl (%eax),%eax
  105fef:	0f b6 c0             	movzbl %al,%eax
  105ff2:	29 c2                	sub    %eax,%edx
  105ff4:	89 d0                	mov    %edx,%eax
  105ff6:	eb 1a                	jmp    106012 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105ff8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105ffc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106000:	8b 45 10             	mov    0x10(%ebp),%eax
  106003:	8d 50 ff             	lea    -0x1(%eax),%edx
  106006:	89 55 10             	mov    %edx,0x10(%ebp)
  106009:	85 c0                	test   %eax,%eax
  10600b:	75 c3                	jne    105fd0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10600d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106012:	c9                   	leave  
  106013:	c3                   	ret    
