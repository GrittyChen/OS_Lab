
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
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
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
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
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 35 5e 00 00       	call   c0105e8b <memset>

    cons_init();                // init the console
c0100056:	e8 8c 15 00 00       	call   c01015e7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 60 10 c0 	movl   $0xc0106020,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 60 10 c0 	movl   $0xc010603c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 0e 43 00 00       	call   c0104392 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 c7 16 00 00       	call   c0101750 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 3f 18 00 00       	call   c01018cd <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 0a 0d 00 00       	call   c0100d9d <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 26 16 00 00       	call   c01016be <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 13 0c 00 00       	call   c0100ccf <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 41 60 10 c0 	movl   $0xc0106041,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 5d 60 10 c0 	movl   $0xc010605d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 6b 60 10 c0 	movl   $0xc010606b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 79 60 10 c0 	movl   $0xc0106079,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 88 60 10 c0 	movl   $0xc0106088,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 a8 60 10 c0 	movl   $0xc01060a8,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 c7 60 10 c0 	movl   $0xc01060c7,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 19 13 00 00       	call   c0101613 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 6d 53 00 00       	call   c01056a4 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 a0 12 00 00       	call   c0101613 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 80 12 00 00       	call   c010164f <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 cc 60 10 c0    	movl   $0xc01060cc,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 cc 60 10 c0 	movl   $0xc01060cc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 40 73 10 c0 	movl   $0xc0107340,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 fc 1f 11 c0 	movl   $0xc0111ffc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec fd 1f 11 c0 	movl   $0xc0111ffd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 3d 4a 11 c0 	movl   $0xc0114a3d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 13 56 00 00       	call   c0105cff <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 d6 60 10 c0 	movl   $0xc01060d6,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 ef 60 10 c0 	movl   $0xc01060ef,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 14 60 10 	movl   $0xc0106014,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 07 61 10 c0 	movl   $0xc0106107,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 1f 61 10 c0 	movl   $0xc010611f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 37 61 10 c0 	movl   $0xc0106137,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 50 61 10 c0 	movl   $0xc0106150,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 7a 61 10 c0 	movl   $0xc010617a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 96 61 10 c0 	movl   $0xc0106196,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i=0, j=0;
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
c01009e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e8:	e9 94 00 00 00       	jmp    c0100a81 <print_stackframe+0xc7>
	{
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c01009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fb:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c0100a02:	e8 35 f9 ff ff       	call   c010033c <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0a:	83 c0 08             	add    $0x8,%eax
c0100a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//print arguments;
		cprintf("args:");
c0100a10:	c7 04 24 bf 61 10 c0 	movl   $0xc01061bf,(%esp)
c0100a17:	e8 20 f9 ff ff       	call   c010033c <cprintf>
		for(j=0; j<4; j++)
c0100a1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a23:	eb 25                	jmp    c0100a4a <print_stackframe+0x90>
			cprintf("0x%08x ", args[j]);
c0100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a32:	01 d0                	add    %edx,%eax
c0100a34:	8b 00                	mov    (%eax),%eax
c0100a36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3a:	c7 04 24 c5 61 10 c0 	movl   $0xc01061c5,(%esp)
c0100a41:	e8 f6 f8 ff ff       	call   c010033c <cprintf>
		//print ebp and eip;
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		//print arguments;
		cprintf("args:");
		for(j=0; j<4; j++)
c0100a46:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a4a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4e:	7e d5                	jle    c0100a25 <print_stackframe+0x6b>
			cprintf("0x%08x ", args[j]);
		cprintf("\n");
c0100a50:	c7 04 24 cd 61 10 c0 	movl   $0xc01061cd,(%esp)
c0100a57:	e8 e0 f8 ff ff       	call   c010033c <cprintf>
		//call print_debuginfo(eip-1)
		print_debuginfo(eip-1);
c0100a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5f:	83 e8 01             	sub    $0x1,%eax
c0100a62:	89 04 24             	mov    %eax,(%esp)
c0100a65:	e8 9c fe ff ff       	call   c0100906 <print_debuginfo>
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	83 c0 04             	add    $0x4,%eax
c0100a70:	8b 00                	mov    (%eax),%eax
c0100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a78:	8b 00                	mov    (%eax),%eax
c0100a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i=0, j=0;
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
c0100a7d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a81:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a85:	7f 0a                	jg     c0100a91 <print_stackframe+0xd7>
c0100a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a8b:	0f 85 5c ff ff ff    	jne    c01009ed <print_stackframe+0x33>
		print_debuginfo(eip-1);
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
	return;
c0100a91:	90                   	nop
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a92:	c9                   	leave  
c0100a93:	c3                   	ret    

c0100a94 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a94:	55                   	push   %ebp
c0100a95:	89 e5                	mov    %esp,%ebp
c0100a97:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa1:	eb 0c                	jmp    c0100aaf <parse+0x1b>
            *buf ++ = '\0';
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa9:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aac:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	0f b6 00             	movzbl (%eax),%eax
c0100ab5:	84 c0                	test   %al,%al
c0100ab7:	74 1d                	je     c0100ad6 <parse+0x42>
c0100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abc:	0f b6 00             	movzbl (%eax),%eax
c0100abf:	0f be c0             	movsbl %al,%eax
c0100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac6:	c7 04 24 50 62 10 c0 	movl   $0xc0106250,(%esp)
c0100acd:	e8 fa 51 00 00       	call   c0105ccc <strchr>
c0100ad2:	85 c0                	test   %eax,%eax
c0100ad4:	75 cd                	jne    c0100aa3 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad9:	0f b6 00             	movzbl (%eax),%eax
c0100adc:	84 c0                	test   %al,%al
c0100ade:	75 02                	jne    c0100ae2 <parse+0x4e>
            break;
c0100ae0:	eb 67                	jmp    c0100b49 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ae2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae6:	75 14                	jne    c0100afc <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aef:	00 
c0100af0:	c7 04 24 55 62 10 c0 	movl   $0xc0106255,(%esp)
c0100af7:	e8 40 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aff:	8d 50 01             	lea    0x1(%eax),%edx
c0100b02:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0f:	01 c2                	add    %eax,%edx
c0100b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b14:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b16:	eb 04                	jmp    c0100b1c <parse+0x88>
            buf ++;
c0100b18:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1f:	0f b6 00             	movzbl (%eax),%eax
c0100b22:	84 c0                	test   %al,%al
c0100b24:	74 1d                	je     c0100b43 <parse+0xaf>
c0100b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b29:	0f b6 00             	movzbl (%eax),%eax
c0100b2c:	0f be c0             	movsbl %al,%eax
c0100b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b33:	c7 04 24 50 62 10 c0 	movl   $0xc0106250,(%esp)
c0100b3a:	e8 8d 51 00 00       	call   c0105ccc <strchr>
c0100b3f:	85 c0                	test   %eax,%eax
c0100b41:	74 d5                	je     c0100b18 <parse+0x84>
            buf ++;
        }
    }
c0100b43:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b44:	e9 66 ff ff ff       	jmp    c0100aaf <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b4c:	c9                   	leave  
c0100b4d:	c3                   	ret    

c0100b4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4e:	55                   	push   %ebp
c0100b4f:	89 e5                	mov    %esp,%ebp
c0100b51:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b54:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5e:	89 04 24             	mov    %eax,(%esp)
c0100b61:	e8 2e ff ff ff       	call   c0100a94 <parse>
c0100b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6d:	75 0a                	jne    c0100b79 <runcmd+0x2b>
        return 0;
c0100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b74:	e9 85 00 00 00       	jmp    c0100bfe <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b80:	eb 5c                	jmp    c0100bde <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b82:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b88:	89 d0                	mov    %edx,%eax
c0100b8a:	01 c0                	add    %eax,%eax
c0100b8c:	01 d0                	add    %edx,%eax
c0100b8e:	c1 e0 02             	shl    $0x2,%eax
c0100b91:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 89 50 00 00       	call   c0105c2d <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 32                	jne    c0100bda <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bab:	89 d0                	mov    %edx,%eax
c0100bad:	01 c0                	add    %eax,%eax
c0100baf:	01 d0                	add    %edx,%eax
c0100bb1:	c1 e0 02             	shl    $0x2,%eax
c0100bb4:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bb9:	8b 40 08             	mov    0x8(%eax),%eax
c0100bbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbf:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc9:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bcc:	83 c2 04             	add    $0x4,%edx
c0100bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bd3:	89 0c 24             	mov    %ecx,(%esp)
c0100bd6:	ff d0                	call   *%eax
c0100bd8:	eb 24                	jmp    c0100bfe <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be1:	83 f8 02             	cmp    $0x2,%eax
c0100be4:	76 9c                	jbe    c0100b82 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bed:	c7 04 24 73 62 10 c0 	movl   $0xc0106273,(%esp)
c0100bf4:	e8 43 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfe:	c9                   	leave  
c0100bff:	c3                   	ret    

c0100c00 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c00:	55                   	push   %ebp
c0100c01:	89 e5                	mov    %esp,%ebp
c0100c03:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c06:	c7 04 24 8c 62 10 c0 	movl   $0xc010628c,(%esp)
c0100c0d:	e8 2a f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c12:	c7 04 24 b4 62 10 c0 	movl   $0xc01062b4,(%esp)
c0100c19:	e8 1e f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c22:	74 0b                	je     c0100c2f <kmonitor+0x2f>
        print_trapframe(tf);
c0100c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c27:	89 04 24             	mov    %eax,(%esp)
c0100c2a:	e8 63 0e 00 00       	call   c0101a92 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2f:	c7 04 24 d9 62 10 c0 	movl   $0xc01062d9,(%esp)
c0100c36:	e8 f8 f5 ff ff       	call   c0100233 <readline>
c0100c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c42:	74 18                	je     c0100c5c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4e:	89 04 24             	mov    %eax,(%esp)
c0100c51:	e8 f8 fe ff ff       	call   c0100b4e <runcmd>
c0100c56:	85 c0                	test   %eax,%eax
c0100c58:	79 02                	jns    c0100c5c <kmonitor+0x5c>
                break;
c0100c5a:	eb 02                	jmp    c0100c5e <kmonitor+0x5e>
            }
        }
    }
c0100c5c:	eb d1                	jmp    c0100c2f <kmonitor+0x2f>
}
c0100c5e:	c9                   	leave  
c0100c5f:	c3                   	ret    

c0100c60 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c60:	55                   	push   %ebp
c0100c61:	89 e5                	mov    %esp,%ebp
c0100c63:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c6d:	eb 3f                	jmp    c0100cae <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c80:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c86:	89 d0                	mov    %edx,%eax
c0100c88:	01 c0                	add    %eax,%eax
c0100c8a:	01 d0                	add    %edx,%eax
c0100c8c:	c1 e0 02             	shl    $0x2,%eax
c0100c8f:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c94:	8b 00                	mov    (%eax),%eax
c0100c96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9e:	c7 04 24 dd 62 10 c0 	movl   $0xc01062dd,(%esp)
c0100ca5:	e8 92 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100caa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb1:	83 f8 02             	cmp    $0x2,%eax
c0100cb4:	76 b9                	jbe    c0100c6f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbb:	c9                   	leave  
c0100cbc:	c3                   	ret    

c0100cbd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cbd:	55                   	push   %ebp
c0100cbe:	89 e5                	mov    %esp,%ebp
c0100cc0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cc3:	e8 a8 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd5:	e8 e0 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdf:	c9                   	leave  
c0100ce0:	c3                   	ret    

c0100ce1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ce1:	55                   	push   %ebp
c0100ce2:	89 e5                	mov    %esp,%ebp
c0100ce4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce7:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cec:	85 c0                	test   %eax,%eax
c0100cee:	74 02                	je     c0100cf2 <__panic+0x11>
        goto panic_dead;
c0100cf0:	eb 48                	jmp    c0100d3a <__panic+0x59>
    }
    is_panic = 1;
c0100cf2:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cf9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cfc:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d05:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d10:	c7 04 24 e6 62 10 c0 	movl   $0xc01062e6,(%esp)
c0100d17:	e8 20 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d23:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d26:	89 04 24             	mov    %eax,(%esp)
c0100d29:	e8 db f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d2e:	c7 04 24 02 63 10 c0 	movl   $0xc0106302,(%esp)
c0100d35:	e8 02 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d3a:	e8 85 09 00 00       	call   c01016c4 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d46:	e8 b5 fe ff ff       	call   c0100c00 <kmonitor>
    }
c0100d4b:	eb f2                	jmp    c0100d3f <__panic+0x5e>

c0100d4d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d4d:	55                   	push   %ebp
c0100d4e:	89 e5                	mov    %esp,%ebp
c0100d50:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d53:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d5c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d67:	c7 04 24 04 63 10 c0 	movl   $0xc0106304,(%esp)
c0100d6e:	e8 c9 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d7a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d7d:	89 04 24             	mov    %eax,(%esp)
c0100d80:	e8 84 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d85:	c7 04 24 02 63 10 c0 	movl   $0xc0106302,(%esp)
c0100d8c:	e8 ab f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d91:	c9                   	leave  
c0100d92:	c3                   	ret    

c0100d93 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d93:	55                   	push   %ebp
c0100d94:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d96:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d9b:	5d                   	pop    %ebp
c0100d9c:	c3                   	ret    

c0100d9d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d9d:	55                   	push   %ebp
c0100d9e:	89 e5                	mov    %esp,%ebp
c0100da0:	83 ec 28             	sub    $0x28,%esp
c0100da3:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da9:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100db1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db5:	ee                   	out    %al,(%dx)
c0100db6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dbc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dc0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc8:	ee                   	out    %al,(%dx)
c0100dc9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dcf:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dd3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ddb:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ddc:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100de3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de6:	c7 04 24 22 63 10 c0 	movl   $0xc0106322,(%esp)
c0100ded:	e8 4a f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100df2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df9:	e8 24 09 00 00       	call   c0101722 <pic_enable>
}
c0100dfe:	c9                   	leave  
c0100dff:	c3                   	ret    

c0100e00 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e00:	55                   	push   %ebp
c0100e01:	89 e5                	mov    %esp,%ebp
c0100e03:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e06:	9c                   	pushf  
c0100e07:	58                   	pop    %eax
c0100e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0e:	25 00 02 00 00       	and    $0x200,%eax
c0100e13:	85 c0                	test   %eax,%eax
c0100e15:	74 0c                	je     c0100e23 <__intr_save+0x23>
        intr_disable();
c0100e17:	e8 a8 08 00 00       	call   c01016c4 <intr_disable>
        return 1;
c0100e1c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e21:	eb 05                	jmp    c0100e28 <__intr_save+0x28>
    }
    return 0;
c0100e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e28:	c9                   	leave  
c0100e29:	c3                   	ret    

c0100e2a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e2a:	55                   	push   %ebp
c0100e2b:	89 e5                	mov    %esp,%ebp
c0100e2d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e34:	74 05                	je     c0100e3b <__intr_restore+0x11>
        intr_enable();
c0100e36:	e8 83 08 00 00       	call   c01016be <intr_enable>
    }
}
c0100e3b:	c9                   	leave  
c0100e3c:	c3                   	ret    

c0100e3d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e3d:	55                   	push   %ebp
c0100e3e:	89 e5                	mov    %esp,%ebp
c0100e40:	83 ec 10             	sub    $0x10,%esp
c0100e43:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e49:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e4d:	89 c2                	mov    %eax,%edx
c0100e4f:	ec                   	in     (%dx),%al
c0100e50:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e53:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e59:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e5d:	89 c2                	mov    %eax,%edx
c0100e5f:	ec                   	in     (%dx),%al
c0100e60:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e63:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e69:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e6d:	89 c2                	mov    %eax,%edx
c0100e6f:	ec                   	in     (%dx),%al
c0100e70:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e73:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e79:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e7d:	89 c2                	mov    %eax,%edx
c0100e7f:	ec                   	in     (%dx),%al
c0100e80:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e83:	c9                   	leave  
c0100e84:	c3                   	ret    

c0100e85 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e85:	55                   	push   %ebp
c0100e86:	89 e5                	mov    %esp,%ebp
c0100e88:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e8b:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	0f b7 00             	movzwl (%eax),%eax
c0100e98:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea7:	0f b7 00             	movzwl (%eax),%eax
c0100eaa:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eae:	74 12                	je     c0100ec2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eb0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb7:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ebe:	b4 03 
c0100ec0:	eb 13                	jmp    c0100ed5 <cga_init+0x50>
    } else {
        *cp = was;
c0100ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ecc:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ed3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edc:	0f b7 c0             	movzwl %ax,%eax
c0100edf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ee3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eeb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eef:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ef0:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ef7:	83 c0 01             	add    $0x1,%eax
c0100efa:	0f b7 c0             	movzwl %ax,%eax
c0100efd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f01:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f05:	89 c2                	mov    %eax,%edx
c0100f07:	ec                   	in     (%dx),%al
c0100f08:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f0b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0f:	0f b6 c0             	movzbl %al,%eax
c0100f12:	c1 e0 08             	shl    $0x8,%eax
c0100f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f18:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1f:	0f b7 c0             	movzwl %ax,%eax
c0100f22:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f26:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f2a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f32:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f33:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f3a:	83 c0 01             	add    $0x1,%eax
c0100f3d:	0f b7 c0             	movzwl %ax,%eax
c0100f40:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f44:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f48:	89 c2                	mov    %eax,%edx
c0100f4a:	ec                   	in     (%dx),%al
c0100f4b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f4e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f52:	0f b6 c0             	movzbl %al,%eax
c0100f55:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f5b:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f63:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f69:	c9                   	leave  
c0100f6a:	c3                   	ret    

c0100f6b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f6b:	55                   	push   %ebp
c0100f6c:	89 e5                	mov    %esp,%ebp
c0100f6e:	83 ec 48             	sub    $0x48,%esp
c0100f71:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f77:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f7b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f83:	ee                   	out    %al,(%dx)
c0100f84:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f8a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f92:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f96:	ee                   	out    %al,(%dx)
c0100f97:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f9d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fa1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa9:	ee                   	out    %al,(%dx)
c0100faa:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fb0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fbc:	ee                   	out    %al,(%dx)
c0100fbd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fc3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fcb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcf:	ee                   	out    %al,(%dx)
c0100fd0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fda:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fde:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fe2:	ee                   	out    %al,(%dx)
c0100fe3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff5:	ee                   	out    %al,(%dx)
c0100ff6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffc:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101000:	89 c2                	mov    %eax,%edx
c0101002:	ec                   	in     (%dx),%al
c0101003:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101006:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010100a:	3c ff                	cmp    $0xff,%al
c010100c:	0f 95 c0             	setne  %al
c010100f:	0f b6 c0             	movzbl %al,%eax
c0101012:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101017:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010101d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101021:	89 c2                	mov    %eax,%edx
c0101023:	ec                   	in     (%dx),%al
c0101024:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101027:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010102d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101031:	89 c2                	mov    %eax,%edx
c0101033:	ec                   	in     (%dx),%al
c0101034:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101037:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010103c:	85 c0                	test   %eax,%eax
c010103e:	74 0c                	je     c010104c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101040:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101047:	e8 d6 06 00 00       	call   c0101722 <pic_enable>
    }
}
c010104c:	c9                   	leave  
c010104d:	c3                   	ret    

c010104e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104e:	55                   	push   %ebp
c010104f:	89 e5                	mov    %esp,%ebp
c0101051:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101054:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010105b:	eb 09                	jmp    c0101066 <lpt_putc_sub+0x18>
        delay();
c010105d:	e8 db fd ff ff       	call   c0100e3d <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101062:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101066:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010106c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101070:	89 c2                	mov    %eax,%edx
c0101072:	ec                   	in     (%dx),%al
c0101073:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101076:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010107a:	84 c0                	test   %al,%al
c010107c:	78 09                	js     c0101087 <lpt_putc_sub+0x39>
c010107e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101085:	7e d6                	jle    c010105d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101087:	8b 45 08             	mov    0x8(%ebp),%eax
c010108a:	0f b6 c0             	movzbl %al,%eax
c010108d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101093:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101096:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010109a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109e:	ee                   	out    %al,(%dx)
c010109f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010ad:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010b1:	ee                   	out    %al,(%dx)
c01010b2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010bc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c5:	c9                   	leave  
c01010c6:	c3                   	ret    

c01010c7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c7:	55                   	push   %ebp
c01010c8:	89 e5                	mov    %esp,%ebp
c01010ca:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010cd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010d1:	74 0d                	je     c01010e0 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d6:	89 04 24             	mov    %eax,(%esp)
c01010d9:	e8 70 ff ff ff       	call   c010104e <lpt_putc_sub>
c01010de:	eb 24                	jmp    c0101104 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e7:	e8 62 ff ff ff       	call   c010104e <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010ec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010f3:	e8 56 ff ff ff       	call   c010104e <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ff:	e8 4a ff ff ff       	call   c010104e <lpt_putc_sub>
    }
}
c0101104:	c9                   	leave  
c0101105:	c3                   	ret    

c0101106 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101106:	55                   	push   %ebp
c0101107:	89 e5                	mov    %esp,%ebp
c0101109:	53                   	push   %ebx
c010110a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010110d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101110:	b0 00                	mov    $0x0,%al
c0101112:	85 c0                	test   %eax,%eax
c0101114:	75 07                	jne    c010111d <cga_putc+0x17>
        c |= 0x0700;
c0101116:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010111d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101120:	0f b6 c0             	movzbl %al,%eax
c0101123:	83 f8 0a             	cmp    $0xa,%eax
c0101126:	74 4c                	je     c0101174 <cga_putc+0x6e>
c0101128:	83 f8 0d             	cmp    $0xd,%eax
c010112b:	74 57                	je     c0101184 <cga_putc+0x7e>
c010112d:	83 f8 08             	cmp    $0x8,%eax
c0101130:	0f 85 88 00 00 00    	jne    c01011be <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101136:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010113d:	66 85 c0             	test   %ax,%ax
c0101140:	74 30                	je     c0101172 <cga_putc+0x6c>
            crt_pos --;
c0101142:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101149:	83 e8 01             	sub    $0x1,%eax
c010114c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101152:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101157:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010115e:	0f b7 d2             	movzwl %dx,%edx
c0101161:	01 d2                	add    %edx,%edx
c0101163:	01 c2                	add    %eax,%edx
c0101165:	8b 45 08             	mov    0x8(%ebp),%eax
c0101168:	b0 00                	mov    $0x0,%al
c010116a:	83 c8 20             	or     $0x20,%eax
c010116d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101170:	eb 72                	jmp    c01011e4 <cga_putc+0xde>
c0101172:	eb 70                	jmp    c01011e4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101174:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010117b:	83 c0 50             	add    $0x50,%eax
c010117e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101184:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010118b:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101192:	0f b7 c1             	movzwl %cx,%eax
c0101195:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010119b:	c1 e8 10             	shr    $0x10,%eax
c010119e:	89 c2                	mov    %eax,%edx
c01011a0:	66 c1 ea 06          	shr    $0x6,%dx
c01011a4:	89 d0                	mov    %edx,%eax
c01011a6:	c1 e0 02             	shl    $0x2,%eax
c01011a9:	01 d0                	add    %edx,%eax
c01011ab:	c1 e0 04             	shl    $0x4,%eax
c01011ae:	29 c1                	sub    %eax,%ecx
c01011b0:	89 ca                	mov    %ecx,%edx
c01011b2:	89 d8                	mov    %ebx,%eax
c01011b4:	29 d0                	sub    %edx,%eax
c01011b6:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011bc:	eb 26                	jmp    c01011e4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011be:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011c4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011cb:	8d 50 01             	lea    0x1(%eax),%edx
c01011ce:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011d5:	0f b7 c0             	movzwl %ax,%eax
c01011d8:	01 c0                	add    %eax,%eax
c01011da:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e0:	66 89 02             	mov    %ax,(%edx)
        break;
c01011e3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011eb:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ef:	76 5b                	jbe    c010124c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011f1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011f6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011fc:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101201:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101208:	00 
c0101209:	89 54 24 04          	mov    %edx,0x4(%esp)
c010120d:	89 04 24             	mov    %eax,(%esp)
c0101210:	e8 b5 4c 00 00       	call   c0105eca <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101215:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010121c:	eb 15                	jmp    c0101233 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010121e:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101223:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101226:	01 d2                	add    %edx,%edx
c0101228:	01 d0                	add    %edx,%eax
c010122a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101233:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010123a:	7e e2                	jle    c010121e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010123c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101243:	83 e8 50             	sub    $0x50,%eax
c0101246:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010124c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101253:	0f b7 c0             	movzwl %ax,%eax
c0101256:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010125a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010125e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101262:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101266:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101267:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010126e:	66 c1 e8 08          	shr    $0x8,%ax
c0101272:	0f b6 c0             	movzbl %al,%eax
c0101275:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010127c:	83 c2 01             	add    $0x1,%edx
c010127f:	0f b7 d2             	movzwl %dx,%edx
c0101282:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101286:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101289:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010128d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101292:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101299:	0f b7 c0             	movzwl %ax,%eax
c010129c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012a0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012ac:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012ad:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012b4:	0f b6 c0             	movzbl %al,%eax
c01012b7:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012be:	83 c2 01             	add    $0x1,%edx
c01012c1:	0f b7 d2             	movzwl %dx,%edx
c01012c4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012cb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012cf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d3:	ee                   	out    %al,(%dx)
}
c01012d4:	83 c4 34             	add    $0x34,%esp
c01012d7:	5b                   	pop    %ebx
c01012d8:	5d                   	pop    %ebp
c01012d9:	c3                   	ret    

c01012da <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012da:	55                   	push   %ebp
c01012db:	89 e5                	mov    %esp,%ebp
c01012dd:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e7:	eb 09                	jmp    c01012f2 <serial_putc_sub+0x18>
        delay();
c01012e9:	e8 4f fb ff ff       	call   c0100e3d <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012f2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012fc:	89 c2                	mov    %eax,%edx
c01012fe:	ec                   	in     (%dx),%al
c01012ff:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101302:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101306:	0f b6 c0             	movzbl %al,%eax
c0101309:	83 e0 20             	and    $0x20,%eax
c010130c:	85 c0                	test   %eax,%eax
c010130e:	75 09                	jne    c0101319 <serial_putc_sub+0x3f>
c0101310:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101317:	7e d0                	jle    c01012e9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101319:	8b 45 08             	mov    0x8(%ebp),%eax
c010131c:	0f b6 c0             	movzbl %al,%eax
c010131f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101325:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101328:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010132c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101330:	ee                   	out    %al,(%dx)
}
c0101331:	c9                   	leave  
c0101332:	c3                   	ret    

c0101333 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101333:	55                   	push   %ebp
c0101334:	89 e5                	mov    %esp,%ebp
c0101336:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101339:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010133d:	74 0d                	je     c010134c <serial_putc+0x19>
        serial_putc_sub(c);
c010133f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101342:	89 04 24             	mov    %eax,(%esp)
c0101345:	e8 90 ff ff ff       	call   c01012da <serial_putc_sub>
c010134a:	eb 24                	jmp    c0101370 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010134c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101353:	e8 82 ff ff ff       	call   c01012da <serial_putc_sub>
        serial_putc_sub(' ');
c0101358:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135f:	e8 76 ff ff ff       	call   c01012da <serial_putc_sub>
        serial_putc_sub('\b');
c0101364:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010136b:	e8 6a ff ff ff       	call   c01012da <serial_putc_sub>
    }
}
c0101370:	c9                   	leave  
c0101371:	c3                   	ret    

c0101372 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101372:	55                   	push   %ebp
c0101373:	89 e5                	mov    %esp,%ebp
c0101375:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101378:	eb 33                	jmp    c01013ad <cons_intr+0x3b>
        if (c != 0) {
c010137a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137e:	74 2d                	je     c01013ad <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101380:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101385:	8d 50 01             	lea    0x1(%eax),%edx
c0101388:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010138e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101391:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101397:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010139c:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013a1:	75 0a                	jne    c01013ad <cons_intr+0x3b>
                cons.wpos = 0;
c01013a3:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01013aa:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b0:	ff d0                	call   *%eax
c01013b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b9:	75 bf                	jne    c010137a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013bb:	c9                   	leave  
c01013bc:	c3                   	ret    

c01013bd <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013bd:	55                   	push   %ebp
c01013be:	89 e5                	mov    %esp,%ebp
c01013c0:	83 ec 10             	sub    $0x10,%esp
c01013c3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013cd:	89 c2                	mov    %eax,%edx
c01013cf:	ec                   	in     (%dx),%al
c01013d0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013d3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d7:	0f b6 c0             	movzbl %al,%eax
c01013da:	83 e0 01             	and    $0x1,%eax
c01013dd:	85 c0                	test   %eax,%eax
c01013df:	75 07                	jne    c01013e8 <serial_proc_data+0x2b>
        return -1;
c01013e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e6:	eb 2a                	jmp    c0101412 <serial_proc_data+0x55>
c01013e8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ee:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013f2:	89 c2                	mov    %eax,%edx
c01013f4:	ec                   	in     (%dx),%al
c01013f5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013fc:	0f b6 c0             	movzbl %al,%eax
c01013ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101402:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101406:	75 07                	jne    c010140f <serial_proc_data+0x52>
        c = '\b';
c0101408:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101412:	c9                   	leave  
c0101413:	c3                   	ret    

c0101414 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101414:	55                   	push   %ebp
c0101415:	89 e5                	mov    %esp,%ebp
c0101417:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010141a:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010141f:	85 c0                	test   %eax,%eax
c0101421:	74 0c                	je     c010142f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101423:	c7 04 24 bd 13 10 c0 	movl   $0xc01013bd,(%esp)
c010142a:	e8 43 ff ff ff       	call   c0101372 <cons_intr>
    }
}
c010142f:	c9                   	leave  
c0101430:	c3                   	ret    

c0101431 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101431:	55                   	push   %ebp
c0101432:	89 e5                	mov    %esp,%ebp
c0101434:	83 ec 38             	sub    $0x38,%esp
c0101437:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010143d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101441:	89 c2                	mov    %eax,%edx
c0101443:	ec                   	in     (%dx),%al
c0101444:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101447:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010144b:	0f b6 c0             	movzbl %al,%eax
c010144e:	83 e0 01             	and    $0x1,%eax
c0101451:	85 c0                	test   %eax,%eax
c0101453:	75 0a                	jne    c010145f <kbd_proc_data+0x2e>
        return -1;
c0101455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010145a:	e9 59 01 00 00       	jmp    c01015b8 <kbd_proc_data+0x187>
c010145f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101465:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101469:	89 c2                	mov    %eax,%edx
c010146b:	ec                   	in     (%dx),%al
c010146c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101473:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101476:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010147a:	75 17                	jne    c0101493 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010147c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101481:	83 c8 40             	or     $0x40,%eax
c0101484:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101489:	b8 00 00 00 00       	mov    $0x0,%eax
c010148e:	e9 25 01 00 00       	jmp    c01015b8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101497:	84 c0                	test   %al,%al
c0101499:	79 47                	jns    c01014e2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010149b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014a0:	83 e0 40             	and    $0x40,%eax
c01014a3:	85 c0                	test   %eax,%eax
c01014a5:	75 09                	jne    c01014b0 <kbd_proc_data+0x7f>
c01014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ab:	83 e0 7f             	and    $0x7f,%eax
c01014ae:	eb 04                	jmp    c01014b4 <kbd_proc_data+0x83>
c01014b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bb:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014c2:	83 c8 40             	or     $0x40,%eax
c01014c5:	0f b6 c0             	movzbl %al,%eax
c01014c8:	f7 d0                	not    %eax
c01014ca:	89 c2                	mov    %eax,%edx
c01014cc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d1:	21 d0                	and    %edx,%eax
c01014d3:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014d8:	b8 00 00 00 00       	mov    $0x0,%eax
c01014dd:	e9 d6 00 00 00       	jmp    c01015b8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014e2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e7:	83 e0 40             	and    $0x40,%eax
c01014ea:	85 c0                	test   %eax,%eax
c01014ec:	74 11                	je     c01014ff <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ee:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	83 e0 bf             	and    $0xffffffbf,%eax
c01014fa:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014ff:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101503:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c010150a:	0f b6 d0             	movzbl %al,%edx
c010150d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101512:	09 d0                	or     %edx,%eax
c0101514:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101519:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151d:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101524:	0f b6 d0             	movzbl %al,%edx
c0101527:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010152c:	31 d0                	xor    %edx,%eax
c010152e:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101533:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101538:	83 e0 03             	and    $0x3,%eax
c010153b:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101542:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101546:	01 d0                	add    %edx,%eax
c0101548:	0f b6 00             	movzbl (%eax),%eax
c010154b:	0f b6 c0             	movzbl %al,%eax
c010154e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101551:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101556:	83 e0 08             	and    $0x8,%eax
c0101559:	85 c0                	test   %eax,%eax
c010155b:	74 22                	je     c010157f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010155d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101561:	7e 0c                	jle    c010156f <kbd_proc_data+0x13e>
c0101563:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101567:	7f 06                	jg     c010156f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101569:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010156d:	eb 10                	jmp    c010157f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101573:	7e 0a                	jle    c010157f <kbd_proc_data+0x14e>
c0101575:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101579:	7f 04                	jg     c010157f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010157b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101584:	f7 d0                	not    %eax
c0101586:	83 e0 06             	and    $0x6,%eax
c0101589:	85 c0                	test   %eax,%eax
c010158b:	75 28                	jne    c01015b5 <kbd_proc_data+0x184>
c010158d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101594:	75 1f                	jne    c01015b5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101596:	c7 04 24 3d 63 10 c0 	movl   $0xc010633d,(%esp)
c010159d:	e8 9a ed ff ff       	call   c010033c <cprintf>
c01015a2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015ac:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015b0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b8:	c9                   	leave  
c01015b9:	c3                   	ret    

c01015ba <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ba:	55                   	push   %ebp
c01015bb:	89 e5                	mov    %esp,%ebp
c01015bd:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015c0:	c7 04 24 31 14 10 c0 	movl   $0xc0101431,(%esp)
c01015c7:	e8 a6 fd ff ff       	call   c0101372 <cons_intr>
}
c01015cc:	c9                   	leave  
c01015cd:	c3                   	ret    

c01015ce <kbd_init>:

static void
kbd_init(void) {
c01015ce:	55                   	push   %ebp
c01015cf:	89 e5                	mov    %esp,%ebp
c01015d1:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d4:	e8 e1 ff ff ff       	call   c01015ba <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015e0:	e8 3d 01 00 00       	call   c0101722 <pic_enable>
}
c01015e5:	c9                   	leave  
c01015e6:	c3                   	ret    

c01015e7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e7:	55                   	push   %ebp
c01015e8:	89 e5                	mov    %esp,%ebp
c01015ea:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015ed:	e8 93 f8 ff ff       	call   c0100e85 <cga_init>
    serial_init();
c01015f2:	e8 74 f9 ff ff       	call   c0100f6b <serial_init>
    kbd_init();
c01015f7:	e8 d2 ff ff ff       	call   c01015ce <kbd_init>
    if (!serial_exists) {
c01015fc:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101601:	85 c0                	test   %eax,%eax
c0101603:	75 0c                	jne    c0101611 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101605:	c7 04 24 49 63 10 c0 	movl   $0xc0106349,(%esp)
c010160c:	e8 2b ed ff ff       	call   c010033c <cprintf>
    }
}
c0101611:	c9                   	leave  
c0101612:	c3                   	ret    

c0101613 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101613:	55                   	push   %ebp
c0101614:	89 e5                	mov    %esp,%ebp
c0101616:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101619:	e8 e2 f7 ff ff       	call   c0100e00 <__intr_save>
c010161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101621:	8b 45 08             	mov    0x8(%ebp),%eax
c0101624:	89 04 24             	mov    %eax,(%esp)
c0101627:	e8 9b fa ff ff       	call   c01010c7 <lpt_putc>
        cga_putc(c);
c010162c:	8b 45 08             	mov    0x8(%ebp),%eax
c010162f:	89 04 24             	mov    %eax,(%esp)
c0101632:	e8 cf fa ff ff       	call   c0101106 <cga_putc>
        serial_putc(c);
c0101637:	8b 45 08             	mov    0x8(%ebp),%eax
c010163a:	89 04 24             	mov    %eax,(%esp)
c010163d:	e8 f1 fc ff ff       	call   c0101333 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101645:	89 04 24             	mov    %eax,(%esp)
c0101648:	e8 dd f7 ff ff       	call   c0100e2a <__intr_restore>
}
c010164d:	c9                   	leave  
c010164e:	c3                   	ret    

c010164f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164f:	55                   	push   %ebp
c0101650:	89 e5                	mov    %esp,%ebp
c0101652:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101655:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010165c:	e8 9f f7 ff ff       	call   c0100e00 <__intr_save>
c0101661:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101664:	e8 ab fd ff ff       	call   c0101414 <serial_intr>
        kbd_intr();
c0101669:	e8 4c ff ff ff       	call   c01015ba <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166e:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101674:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101679:	39 c2                	cmp    %eax,%edx
c010167b:	74 31                	je     c01016ae <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010167d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101682:	8d 50 01             	lea    0x1(%eax),%edx
c0101685:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010168b:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101692:	0f b6 c0             	movzbl %al,%eax
c0101695:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101698:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010169d:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016a2:	75 0a                	jne    c01016ae <cons_getc+0x5f>
                cons.rpos = 0;
c01016a4:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c01016ab:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016b1:	89 04 24             	mov    %eax,(%esp)
c01016b4:	e8 71 f7 ff ff       	call   c0100e2a <__intr_restore>
    return c;
c01016b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016bc:	c9                   	leave  
c01016bd:	c3                   	ret    

c01016be <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016be:	55                   	push   %ebp
c01016bf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016c1:	fb                   	sti    
    sti();
}
c01016c2:	5d                   	pop    %ebp
c01016c3:	c3                   	ret    

c01016c4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016c4:	55                   	push   %ebp
c01016c5:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016c7:	fa                   	cli    
    cli();
}
c01016c8:	5d                   	pop    %ebp
c01016c9:	c3                   	ret    

c01016ca <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ca:	55                   	push   %ebp
c01016cb:	89 e5                	mov    %esp,%ebp
c01016cd:	83 ec 14             	sub    $0x14,%esp
c01016d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016db:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016e1:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016e6:	85 c0                	test   %eax,%eax
c01016e8:	74 36                	je     c0101720 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ee:	0f b6 c0             	movzbl %al,%eax
c01016f1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016f7:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016fa:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016fe:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101702:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101703:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101707:	66 c1 e8 08          	shr    $0x8,%ax
c010170b:	0f b6 c0             	movzbl %al,%eax
c010170e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101714:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101717:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010171b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010171f:	ee                   	out    %al,(%dx)
    }
}
c0101720:	c9                   	leave  
c0101721:	c3                   	ret    

c0101722 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101722:	55                   	push   %ebp
c0101723:	89 e5                	mov    %esp,%ebp
c0101725:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101728:	8b 45 08             	mov    0x8(%ebp),%eax
c010172b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101730:	89 c1                	mov    %eax,%ecx
c0101732:	d3 e2                	shl    %cl,%edx
c0101734:	89 d0                	mov    %edx,%eax
c0101736:	f7 d0                	not    %eax
c0101738:	89 c2                	mov    %eax,%edx
c010173a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101741:	21 d0                	and    %edx,%eax
c0101743:	0f b7 c0             	movzwl %ax,%eax
c0101746:	89 04 24             	mov    %eax,(%esp)
c0101749:	e8 7c ff ff ff       	call   c01016ca <pic_setmask>
}
c010174e:	c9                   	leave  
c010174f:	c3                   	ret    

c0101750 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101750:	55                   	push   %ebp
c0101751:	89 e5                	mov    %esp,%ebp
c0101753:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101756:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010175d:	00 00 00 
c0101760:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101766:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010176a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010176e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101772:	ee                   	out    %al,(%dx)
c0101773:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101779:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010177d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101781:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101785:	ee                   	out    %al,(%dx)
c0101786:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010178c:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101790:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101794:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101798:	ee                   	out    %al,(%dx)
c0101799:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010179f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017a3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017a7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017ab:	ee                   	out    %al,(%dx)
c01017ac:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017b2:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017b6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017ba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017be:	ee                   	out    %al,(%dx)
c01017bf:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017c5:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017c9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017cd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017d1:	ee                   	out    %al,(%dx)
c01017d2:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017d8:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017dc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017e4:	ee                   	out    %al,(%dx)
c01017e5:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017eb:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017ef:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017f7:	ee                   	out    %al,(%dx)
c01017f8:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017fe:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101802:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101806:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010180a:	ee                   	out    %al,(%dx)
c010180b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101811:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101815:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101819:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010181d:	ee                   	out    %al,(%dx)
c010181e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101824:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101828:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010182c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101830:	ee                   	out    %al,(%dx)
c0101831:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101837:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010183b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010183f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101843:	ee                   	out    %al,(%dx)
c0101844:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010184a:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010184e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101852:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101856:	ee                   	out    %al,(%dx)
c0101857:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010185d:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101861:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101865:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101869:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010186a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101871:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101875:	74 12                	je     c0101889 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101877:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010187e:	0f b7 c0             	movzwl %ax,%eax
c0101881:	89 04 24             	mov    %eax,(%esp)
c0101884:	e8 41 fe ff ff       	call   c01016ca <pic_setmask>
    }
}
c0101889:	c9                   	leave  
c010188a:	c3                   	ret    

c010188b <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010188b:	55                   	push   %ebp
c010188c:	89 e5                	mov    %esp,%ebp
c010188e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101891:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101898:	00 
c0101899:	c7 04 24 80 63 10 c0 	movl   $0xc0106380,(%esp)
c01018a0:	e8 97 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018a5:	c7 04 24 8a 63 10 c0 	movl   $0xc010638a,(%esp)
c01018ac:	e8 8b ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c01018b1:	c7 44 24 08 98 63 10 	movl   $0xc0106398,0x8(%esp)
c01018b8:	c0 
c01018b9:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018c0:	00 
c01018c1:	c7 04 24 ae 63 10 c0 	movl   $0xc01063ae,(%esp)
c01018c8:	e8 14 f4 ff ff       	call   c0100ce1 <__panic>

c01018cd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018cd:	55                   	push   %ebp
c01018ce:	89 e5                	mov    %esp,%ebp
c01018d0:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
c01018d3:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i=0;
c01018da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//setup each item of IDT;
	for(i=0; i<len; i++)
c01018e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e8:	e9 c3 00 00 00       	jmp    c01019b0 <idt_init+0xe3>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f0:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018f7:	89 c2                	mov    %eax,%edx
c01018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fc:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c0101903:	c0 
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c010190e:	c0 08 00 
c0101911:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101914:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c010191b:	c0 
c010191c:	83 e2 e0             	and    $0xffffffe0,%edx
c010191f:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101926:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101929:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101930:	c0 
c0101931:	83 e2 1f             	and    $0x1f,%edx
c0101934:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101945:	c0 
c0101946:	83 e2 f0             	and    $0xfffffff0,%edx
c0101949:	83 ca 0e             	or     $0xe,%edx
c010194c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101953:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101956:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010195d:	c0 
c010195e:	83 e2 ef             	and    $0xffffffef,%edx
c0101961:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101968:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101972:	c0 
c0101973:	83 e2 9f             	and    $0xffffff9f,%edx
c0101976:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101980:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101987:	c0 
c0101988:	83 ca 80             	or     $0xffffff80,%edx
c010198b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101995:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010199c:	c1 e8 10             	shr    $0x10,%eax
c010199f:	89 c2                	mov    %eax,%edx
c01019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a4:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c01019ab:	c0 
idt_init(void) {
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
	int i=0;
	//setup each item of IDT;
	for(i=0; i<len; i++)
c01019ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01019b6:	0f 8c 31 ff ff ff    	jl     c01018ed <idt_init+0x20>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
c01019bc:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019c1:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c01019c7:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01019ce:	08 00 
c01019d0:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019d7:	83 e0 e0             	and    $0xffffffe0,%eax
c01019da:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019df:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019e6:	83 e0 1f             	and    $0x1f,%eax
c01019e9:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019ee:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019f5:	83 e0 f0             	and    $0xfffffff0,%eax
c01019f8:	83 c8 0e             	or     $0xe,%eax
c01019fb:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a00:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a07:	83 e0 ef             	and    $0xffffffef,%eax
c0101a0a:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a0f:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a16:	83 e0 9f             	and    $0xffffff9f,%eax
c0101a19:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a1e:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a25:	83 c8 80             	or     $0xffffff80,%eax
c0101a28:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a2d:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a32:	c1 e8 10             	shr    $0x10,%eax
c0101a35:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101a3b:	c7 45 f4 80 75 11 c0 	movl   $0xc0117580,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a45:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);//载入IDT;
	return;
c0101a48:	90                   	nop
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c0101a49:	c9                   	leave  
c0101a4a:	c3                   	ret    

c0101a4b <trapname>:

static const char *
trapname(int trapno) {
c0101a4b:	55                   	push   %ebp
c0101a4c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a51:	83 f8 13             	cmp    $0x13,%eax
c0101a54:	77 0c                	ja     c0101a62 <trapname+0x17>
        return excnames[trapno];
c0101a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a59:	8b 04 85 00 67 10 c0 	mov    -0x3fef9900(,%eax,4),%eax
c0101a60:	eb 18                	jmp    c0101a7a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a62:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a66:	7e 0d                	jle    c0101a75 <trapname+0x2a>
c0101a68:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6c:	7f 07                	jg     c0101a75 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a6e:	b8 bf 63 10 c0       	mov    $0xc01063bf,%eax
c0101a73:	eb 05                	jmp    c0101a7a <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a75:	b8 d2 63 10 c0       	mov    $0xc01063d2,%eax
}
c0101a7a:	5d                   	pop    %ebp
c0101a7b:	c3                   	ret    

c0101a7c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a7c:	55                   	push   %ebp
c0101a7d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a82:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a86:	66 83 f8 08          	cmp    $0x8,%ax
c0101a8a:	0f 94 c0             	sete   %al
c0101a8d:	0f b6 c0             	movzbl %al,%eax
}
c0101a90:	5d                   	pop    %ebp
c0101a91:	c3                   	ret    

c0101a92 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a92:	55                   	push   %ebp
c0101a93:	89 e5                	mov    %esp,%ebp
c0101a95:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9f:	c7 04 24 13 64 10 c0 	movl   $0xc0106413,(%esp)
c0101aa6:	e8 91 e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aae:	89 04 24             	mov    %eax,(%esp)
c0101ab1:	e8 a1 01 00 00       	call   c0101c57 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101abd:	0f b7 c0             	movzwl %ax,%eax
c0101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac4:	c7 04 24 24 64 10 c0 	movl   $0xc0106424,(%esp)
c0101acb:	e8 6c e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad7:	0f b7 c0             	movzwl %ax,%eax
c0101ada:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ade:	c7 04 24 37 64 10 c0 	movl   $0xc0106437,(%esp)
c0101ae5:	e8 52 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aed:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101af1:	0f b7 c0             	movzwl %ax,%eax
c0101af4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af8:	c7 04 24 4a 64 10 c0 	movl   $0xc010644a,(%esp)
c0101aff:	e8 38 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b07:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b0b:	0f b7 c0             	movzwl %ax,%eax
c0101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b12:	c7 04 24 5d 64 10 c0 	movl   $0xc010645d,(%esp)
c0101b19:	e8 1e e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b21:	8b 40 30             	mov    0x30(%eax),%eax
c0101b24:	89 04 24             	mov    %eax,(%esp)
c0101b27:	e8 1f ff ff ff       	call   c0101a4b <trapname>
c0101b2c:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b2f:	8b 52 30             	mov    0x30(%edx),%edx
c0101b32:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b36:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b3a:	c7 04 24 70 64 10 c0 	movl   $0xc0106470,(%esp)
c0101b41:	e8 f6 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b49:	8b 40 34             	mov    0x34(%eax),%eax
c0101b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b50:	c7 04 24 82 64 10 c0 	movl   $0xc0106482,(%esp)
c0101b57:	e8 e0 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5f:	8b 40 38             	mov    0x38(%eax),%eax
c0101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b66:	c7 04 24 91 64 10 c0 	movl   $0xc0106491,(%esp)
c0101b6d:	e8 ca e7 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b75:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b79:	0f b7 c0             	movzwl %ax,%eax
c0101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b80:	c7 04 24 a0 64 10 c0 	movl   $0xc01064a0,(%esp)
c0101b87:	e8 b0 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	8b 40 40             	mov    0x40(%eax),%eax
c0101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b96:	c7 04 24 b3 64 10 c0 	movl   $0xc01064b3,(%esp)
c0101b9d:	e8 9a e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ba9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bb0:	eb 3e                	jmp    c0101bf0 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb5:	8b 50 40             	mov    0x40(%eax),%edx
c0101bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bbb:	21 d0                	and    %edx,%eax
c0101bbd:	85 c0                	test   %eax,%eax
c0101bbf:	74 28                	je     c0101be9 <print_trapframe+0x157>
c0101bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc4:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bcb:	85 c0                	test   %eax,%eax
c0101bcd:	74 1a                	je     c0101be9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd2:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdd:	c7 04 24 c2 64 10 c0 	movl   $0xc01064c2,(%esp)
c0101be4:	e8 53 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101be9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bed:	d1 65 f0             	shll   -0x10(%ebp)
c0101bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf3:	83 f8 17             	cmp    $0x17,%eax
c0101bf6:	76 ba                	jbe    c0101bb2 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	8b 40 40             	mov    0x40(%eax),%eax
c0101bfe:	25 00 30 00 00       	and    $0x3000,%eax
c0101c03:	c1 e8 0c             	shr    $0xc,%eax
c0101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0a:	c7 04 24 c6 64 10 c0 	movl   $0xc01064c6,(%esp)
c0101c11:	e8 26 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c19:	89 04 24             	mov    %eax,(%esp)
c0101c1c:	e8 5b fe ff ff       	call   c0101a7c <trap_in_kernel>
c0101c21:	85 c0                	test   %eax,%eax
c0101c23:	75 30                	jne    c0101c55 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c28:	8b 40 44             	mov    0x44(%eax),%eax
c0101c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2f:	c7 04 24 cf 64 10 c0 	movl   $0xc01064cf,(%esp)
c0101c36:	e8 01 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c42:	0f b7 c0             	movzwl %ax,%eax
c0101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c49:	c7 04 24 de 64 10 c0 	movl   $0xc01064de,(%esp)
c0101c50:	e8 e7 e6 ff ff       	call   c010033c <cprintf>
    }
}
c0101c55:	c9                   	leave  
c0101c56:	c3                   	ret    

c0101c57 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c57:	55                   	push   %ebp
c0101c58:	89 e5                	mov    %esp,%ebp
c0101c5a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c60:	8b 00                	mov    (%eax),%eax
c0101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c66:	c7 04 24 f1 64 10 c0 	movl   $0xc01064f1,(%esp)
c0101c6d:	e8 ca e6 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c75:	8b 40 04             	mov    0x4(%eax),%eax
c0101c78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7c:	c7 04 24 00 65 10 c0 	movl   $0xc0106500,(%esp)
c0101c83:	e8 b4 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c92:	c7 04 24 0f 65 10 c0 	movl   $0xc010650f,(%esp)
c0101c99:	e8 9e e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca1:	8b 40 0c             	mov    0xc(%eax),%eax
c0101ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca8:	c7 04 24 1e 65 10 c0 	movl   $0xc010651e,(%esp)
c0101caf:	e8 88 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb7:	8b 40 10             	mov    0x10(%eax),%eax
c0101cba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbe:	c7 04 24 2d 65 10 c0 	movl   $0xc010652d,(%esp)
c0101cc5:	e8 72 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ccd:	8b 40 14             	mov    0x14(%eax),%eax
c0101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd4:	c7 04 24 3c 65 10 c0 	movl   $0xc010653c,(%esp)
c0101cdb:	e8 5c e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce3:	8b 40 18             	mov    0x18(%eax),%eax
c0101ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cea:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0101cf1:	e8 46 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d00:	c7 04 24 5a 65 10 c0 	movl   $0xc010655a,(%esp)
c0101d07:	e8 30 e6 ff ff       	call   c010033c <cprintf>
}
c0101d0c:	c9                   	leave  
c0101d0d:	c3                   	ret    

c0101d0e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d0e:	55                   	push   %ebp
c0101d0f:	89 e5                	mov    %esp,%ebp
c0101d11:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d17:	8b 40 30             	mov    0x30(%eax),%eax
c0101d1a:	83 f8 2f             	cmp    $0x2f,%eax
c0101d1d:	77 21                	ja     c0101d40 <trap_dispatch+0x32>
c0101d1f:	83 f8 2e             	cmp    $0x2e,%eax
c0101d22:	0f 83 04 01 00 00    	jae    c0101e2c <trap_dispatch+0x11e>
c0101d28:	83 f8 21             	cmp    $0x21,%eax
c0101d2b:	0f 84 81 00 00 00    	je     c0101db2 <trap_dispatch+0xa4>
c0101d31:	83 f8 24             	cmp    $0x24,%eax
c0101d34:	74 56                	je     c0101d8c <trap_dispatch+0x7e>
c0101d36:	83 f8 20             	cmp    $0x20,%eax
c0101d39:	74 16                	je     c0101d51 <trap_dispatch+0x43>
c0101d3b:	e9 b4 00 00 00       	jmp    c0101df4 <trap_dispatch+0xe6>
c0101d40:	83 e8 78             	sub    $0x78,%eax
c0101d43:	83 f8 01             	cmp    $0x1,%eax
c0101d46:	0f 87 a8 00 00 00    	ja     c0101df4 <trap_dispatch+0xe6>
c0101d4c:	e9 87 00 00 00       	jmp    c0101dd8 <trap_dispatch+0xca>
    case IRQ_OFFSET + IRQ_TIMER:
    	ticks++;//in clock.h(extern volatile size_t ticks;);
c0101d51:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d56:	83 c0 01             	add    $0x1,%eax
c0101d59:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
    	if(ticks % TICK_NUM == 0)
c0101d5e:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d64:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d69:	89 c8                	mov    %ecx,%eax
c0101d6b:	f7 e2                	mul    %edx
c0101d6d:	89 d0                	mov    %edx,%eax
c0101d6f:	c1 e8 05             	shr    $0x5,%eax
c0101d72:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d75:	29 c1                	sub    %eax,%ecx
c0101d77:	89 c8                	mov    %ecx,%eax
c0101d79:	85 c0                	test   %eax,%eax
c0101d7b:	75 0a                	jne    c0101d87 <trap_dispatch+0x79>
    	{
    		print_ticks();//打印"100	ticks";
c0101d7d:	e8 09 fb ff ff       	call   c010188b <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101d82:	e9 a6 00 00 00       	jmp    c0101e2d <trap_dispatch+0x11f>
c0101d87:	e9 a1 00 00 00       	jmp    c0101e2d <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d8c:	e8 be f8 ff ff       	call   c010164f <cons_getc>
c0101d91:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d94:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d98:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d9c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101da0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da4:	c7 04 24 69 65 10 c0 	movl   $0xc0106569,(%esp)
c0101dab:	e8 8c e5 ff ff       	call   c010033c <cprintf>
        break;
c0101db0:	eb 7b                	jmp    c0101e2d <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101db2:	e8 98 f8 ff ff       	call   c010164f <cons_getc>
c0101db7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dba:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dbe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dc2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dca:	c7 04 24 7b 65 10 c0 	movl   $0xc010657b,(%esp)
c0101dd1:	e8 66 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101dd6:	eb 55                	jmp    c0101e2d <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101dd8:	c7 44 24 08 8a 65 10 	movl   $0xc010658a,0x8(%esp)
c0101ddf:	c0 
c0101de0:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0101de7:	00 
c0101de8:	c7 04 24 ae 63 10 c0 	movl   $0xc01063ae,(%esp)
c0101def:	e8 ed ee ff ff       	call   c0100ce1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101df4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dfb:	0f b7 c0             	movzwl %ax,%eax
c0101dfe:	83 e0 03             	and    $0x3,%eax
c0101e01:	85 c0                	test   %eax,%eax
c0101e03:	75 28                	jne    c0101e2d <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e08:	89 04 24             	mov    %eax,(%esp)
c0101e0b:	e8 82 fc ff ff       	call   c0101a92 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e10:	c7 44 24 08 9a 65 10 	movl   $0xc010659a,0x8(%esp)
c0101e17:	c0 
c0101e18:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0101e1f:	00 
c0101e20:	c7 04 24 ae 63 10 c0 	movl   $0xc01063ae,(%esp)
c0101e27:	e8 b5 ee ff ff       	call   c0100ce1 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e2c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e2d:	c9                   	leave  
c0101e2e:	c3                   	ret    

c0101e2f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e2f:	55                   	push   %ebp
c0101e30:	89 e5                	mov    %esp,%ebp
c0101e32:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e38:	89 04 24             	mov    %eax,(%esp)
c0101e3b:	e8 ce fe ff ff       	call   c0101d0e <trap_dispatch>
}
c0101e40:	c9                   	leave  
c0101e41:	c3                   	ret    

c0101e42 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e42:	1e                   	push   %ds
    pushl %es
c0101e43:	06                   	push   %es
    pushl %fs
c0101e44:	0f a0                	push   %fs
    pushl %gs
c0101e46:	0f a8                	push   %gs
    pushal
c0101e48:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e49:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e4e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e50:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e52:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e53:	e8 d7 ff ff ff       	call   c0101e2f <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e58:	5c                   	pop    %esp

c0101e59 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e59:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e5a:	0f a9                	pop    %gs
    popl %fs
c0101e5c:	0f a1                	pop    %fs
    popl %es
c0101e5e:	07                   	pop    %es
    popl %ds
c0101e5f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e60:	83 c4 08             	add    $0x8,%esp
    iret
c0101e63:	cf                   	iret   

c0101e64 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e64:	6a 00                	push   $0x0
  pushl $0
c0101e66:	6a 00                	push   $0x0
  jmp __alltraps
c0101e68:	e9 d5 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101e6d <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e6d:	6a 00                	push   $0x0
  pushl $1
c0101e6f:	6a 01                	push   $0x1
  jmp __alltraps
c0101e71:	e9 cc ff ff ff       	jmp    c0101e42 <__alltraps>

c0101e76 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e76:	6a 00                	push   $0x0
  pushl $2
c0101e78:	6a 02                	push   $0x2
  jmp __alltraps
c0101e7a:	e9 c3 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101e7f <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e7f:	6a 00                	push   $0x0
  pushl $3
c0101e81:	6a 03                	push   $0x3
  jmp __alltraps
c0101e83:	e9 ba ff ff ff       	jmp    c0101e42 <__alltraps>

c0101e88 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e88:	6a 00                	push   $0x0
  pushl $4
c0101e8a:	6a 04                	push   $0x4
  jmp __alltraps
c0101e8c:	e9 b1 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101e91 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e91:	6a 00                	push   $0x0
  pushl $5
c0101e93:	6a 05                	push   $0x5
  jmp __alltraps
c0101e95:	e9 a8 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101e9a <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e9a:	6a 00                	push   $0x0
  pushl $6
c0101e9c:	6a 06                	push   $0x6
  jmp __alltraps
c0101e9e:	e9 9f ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ea3 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ea3:	6a 00                	push   $0x0
  pushl $7
c0101ea5:	6a 07                	push   $0x7
  jmp __alltraps
c0101ea7:	e9 96 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101eac <vector8>:
.globl vector8
vector8:
  pushl $8
c0101eac:	6a 08                	push   $0x8
  jmp __alltraps
c0101eae:	e9 8f ff ff ff       	jmp    c0101e42 <__alltraps>

c0101eb3 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101eb3:	6a 09                	push   $0x9
  jmp __alltraps
c0101eb5:	e9 88 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101eba <vector10>:
.globl vector10
vector10:
  pushl $10
c0101eba:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ebc:	e9 81 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ec1 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ec1:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ec3:	e9 7a ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ec8 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ec8:	6a 0c                	push   $0xc
  jmp __alltraps
c0101eca:	e9 73 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ecf <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ecf:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ed1:	e9 6c ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ed6 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ed6:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ed8:	e9 65 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101edd <vector15>:
.globl vector15
vector15:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $15
c0101edf:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ee1:	e9 5c ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ee6 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ee6:	6a 00                	push   $0x0
  pushl $16
c0101ee8:	6a 10                	push   $0x10
  jmp __alltraps
c0101eea:	e9 53 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101eef <vector17>:
.globl vector17
vector17:
  pushl $17
c0101eef:	6a 11                	push   $0x11
  jmp __alltraps
c0101ef1:	e9 4c ff ff ff       	jmp    c0101e42 <__alltraps>

c0101ef6 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $18
c0101ef8:	6a 12                	push   $0x12
  jmp __alltraps
c0101efa:	e9 43 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101eff <vector19>:
.globl vector19
vector19:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $19
c0101f01:	6a 13                	push   $0x13
  jmp __alltraps
c0101f03:	e9 3a ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f08 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $20
c0101f0a:	6a 14                	push   $0x14
  jmp __alltraps
c0101f0c:	e9 31 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f11 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $21
c0101f13:	6a 15                	push   $0x15
  jmp __alltraps
c0101f15:	e9 28 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f1a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $22
c0101f1c:	6a 16                	push   $0x16
  jmp __alltraps
c0101f1e:	e9 1f ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f23 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $23
c0101f25:	6a 17                	push   $0x17
  jmp __alltraps
c0101f27:	e9 16 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f2c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $24
c0101f2e:	6a 18                	push   $0x18
  jmp __alltraps
c0101f30:	e9 0d ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f35 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $25
c0101f37:	6a 19                	push   $0x19
  jmp __alltraps
c0101f39:	e9 04 ff ff ff       	jmp    c0101e42 <__alltraps>

c0101f3e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $26
c0101f40:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f42:	e9 fb fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f47 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $27
c0101f49:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f4b:	e9 f2 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f50 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $28
c0101f52:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f54:	e9 e9 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f59 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $29
c0101f5b:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f5d:	e9 e0 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f62 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $30
c0101f64:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f66:	e9 d7 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f6b <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $31
c0101f6d:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f6f:	e9 ce fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f74 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $32
c0101f76:	6a 20                	push   $0x20
  jmp __alltraps
c0101f78:	e9 c5 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f7d <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $33
c0101f7f:	6a 21                	push   $0x21
  jmp __alltraps
c0101f81:	e9 bc fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f86 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $34
c0101f88:	6a 22                	push   $0x22
  jmp __alltraps
c0101f8a:	e9 b3 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f8f <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $35
c0101f91:	6a 23                	push   $0x23
  jmp __alltraps
c0101f93:	e9 aa fe ff ff       	jmp    c0101e42 <__alltraps>

c0101f98 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $36
c0101f9a:	6a 24                	push   $0x24
  jmp __alltraps
c0101f9c:	e9 a1 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fa1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $37
c0101fa3:	6a 25                	push   $0x25
  jmp __alltraps
c0101fa5:	e9 98 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101faa <vector38>:
.globl vector38
vector38:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $38
c0101fac:	6a 26                	push   $0x26
  jmp __alltraps
c0101fae:	e9 8f fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fb3 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $39
c0101fb5:	6a 27                	push   $0x27
  jmp __alltraps
c0101fb7:	e9 86 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fbc <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $40
c0101fbe:	6a 28                	push   $0x28
  jmp __alltraps
c0101fc0:	e9 7d fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fc5 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $41
c0101fc7:	6a 29                	push   $0x29
  jmp __alltraps
c0101fc9:	e9 74 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fce <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $42
c0101fd0:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fd2:	e9 6b fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fd7 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $43
c0101fd9:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fdb:	e9 62 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fe0 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $44
c0101fe2:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fe4:	e9 59 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101fe9 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $45
c0101feb:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fed:	e9 50 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101ff2 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $46
c0101ff4:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101ff6:	e9 47 fe ff ff       	jmp    c0101e42 <__alltraps>

c0101ffb <vector47>:
.globl vector47
vector47:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $47
c0101ffd:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fff:	e9 3e fe ff ff       	jmp    c0101e42 <__alltraps>

c0102004 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $48
c0102006:	6a 30                	push   $0x30
  jmp __alltraps
c0102008:	e9 35 fe ff ff       	jmp    c0101e42 <__alltraps>

c010200d <vector49>:
.globl vector49
vector49:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $49
c010200f:	6a 31                	push   $0x31
  jmp __alltraps
c0102011:	e9 2c fe ff ff       	jmp    c0101e42 <__alltraps>

c0102016 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $50
c0102018:	6a 32                	push   $0x32
  jmp __alltraps
c010201a:	e9 23 fe ff ff       	jmp    c0101e42 <__alltraps>

c010201f <vector51>:
.globl vector51
vector51:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $51
c0102021:	6a 33                	push   $0x33
  jmp __alltraps
c0102023:	e9 1a fe ff ff       	jmp    c0101e42 <__alltraps>

c0102028 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $52
c010202a:	6a 34                	push   $0x34
  jmp __alltraps
c010202c:	e9 11 fe ff ff       	jmp    c0101e42 <__alltraps>

c0102031 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $53
c0102033:	6a 35                	push   $0x35
  jmp __alltraps
c0102035:	e9 08 fe ff ff       	jmp    c0101e42 <__alltraps>

c010203a <vector54>:
.globl vector54
vector54:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $54
c010203c:	6a 36                	push   $0x36
  jmp __alltraps
c010203e:	e9 ff fd ff ff       	jmp    c0101e42 <__alltraps>

c0102043 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $55
c0102045:	6a 37                	push   $0x37
  jmp __alltraps
c0102047:	e9 f6 fd ff ff       	jmp    c0101e42 <__alltraps>

c010204c <vector56>:
.globl vector56
vector56:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $56
c010204e:	6a 38                	push   $0x38
  jmp __alltraps
c0102050:	e9 ed fd ff ff       	jmp    c0101e42 <__alltraps>

c0102055 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $57
c0102057:	6a 39                	push   $0x39
  jmp __alltraps
c0102059:	e9 e4 fd ff ff       	jmp    c0101e42 <__alltraps>

c010205e <vector58>:
.globl vector58
vector58:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $58
c0102060:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102062:	e9 db fd ff ff       	jmp    c0101e42 <__alltraps>

c0102067 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $59
c0102069:	6a 3b                	push   $0x3b
  jmp __alltraps
c010206b:	e9 d2 fd ff ff       	jmp    c0101e42 <__alltraps>

c0102070 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $60
c0102072:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102074:	e9 c9 fd ff ff       	jmp    c0101e42 <__alltraps>

c0102079 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $61
c010207b:	6a 3d                	push   $0x3d
  jmp __alltraps
c010207d:	e9 c0 fd ff ff       	jmp    c0101e42 <__alltraps>

c0102082 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $62
c0102084:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102086:	e9 b7 fd ff ff       	jmp    c0101e42 <__alltraps>

c010208b <vector63>:
.globl vector63
vector63:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $63
c010208d:	6a 3f                	push   $0x3f
  jmp __alltraps
c010208f:	e9 ae fd ff ff       	jmp    c0101e42 <__alltraps>

c0102094 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $64
c0102096:	6a 40                	push   $0x40
  jmp __alltraps
c0102098:	e9 a5 fd ff ff       	jmp    c0101e42 <__alltraps>

c010209d <vector65>:
.globl vector65
vector65:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $65
c010209f:	6a 41                	push   $0x41
  jmp __alltraps
c01020a1:	e9 9c fd ff ff       	jmp    c0101e42 <__alltraps>

c01020a6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $66
c01020a8:	6a 42                	push   $0x42
  jmp __alltraps
c01020aa:	e9 93 fd ff ff       	jmp    c0101e42 <__alltraps>

c01020af <vector67>:
.globl vector67
vector67:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $67
c01020b1:	6a 43                	push   $0x43
  jmp __alltraps
c01020b3:	e9 8a fd ff ff       	jmp    c0101e42 <__alltraps>

c01020b8 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $68
c01020ba:	6a 44                	push   $0x44
  jmp __alltraps
c01020bc:	e9 81 fd ff ff       	jmp    c0101e42 <__alltraps>

c01020c1 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $69
c01020c3:	6a 45                	push   $0x45
  jmp __alltraps
c01020c5:	e9 78 fd ff ff       	jmp    c0101e42 <__alltraps>

c01020ca <vector70>:
.globl vector70
vector70:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $70
c01020cc:	6a 46                	push   $0x46
  jmp __alltraps
c01020ce:	e9 6f fd ff ff       	jmp    c0101e42 <__alltraps>

c01020d3 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $71
c01020d5:	6a 47                	push   $0x47
  jmp __alltraps
c01020d7:	e9 66 fd ff ff       	jmp    c0101e42 <__alltraps>

c01020dc <vector72>:
.globl vector72
vector72:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $72
c01020de:	6a 48                	push   $0x48
  jmp __alltraps
c01020e0:	e9 5d fd ff ff       	jmp    c0101e42 <__alltraps>

c01020e5 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $73
c01020e7:	6a 49                	push   $0x49
  jmp __alltraps
c01020e9:	e9 54 fd ff ff       	jmp    c0101e42 <__alltraps>

c01020ee <vector74>:
.globl vector74
vector74:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $74
c01020f0:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020f2:	e9 4b fd ff ff       	jmp    c0101e42 <__alltraps>

c01020f7 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $75
c01020f9:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020fb:	e9 42 fd ff ff       	jmp    c0101e42 <__alltraps>

c0102100 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $76
c0102102:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102104:	e9 39 fd ff ff       	jmp    c0101e42 <__alltraps>

c0102109 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $77
c010210b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010210d:	e9 30 fd ff ff       	jmp    c0101e42 <__alltraps>

c0102112 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $78
c0102114:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102116:	e9 27 fd ff ff       	jmp    c0101e42 <__alltraps>

c010211b <vector79>:
.globl vector79
vector79:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $79
c010211d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010211f:	e9 1e fd ff ff       	jmp    c0101e42 <__alltraps>

c0102124 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $80
c0102126:	6a 50                	push   $0x50
  jmp __alltraps
c0102128:	e9 15 fd ff ff       	jmp    c0101e42 <__alltraps>

c010212d <vector81>:
.globl vector81
vector81:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $81
c010212f:	6a 51                	push   $0x51
  jmp __alltraps
c0102131:	e9 0c fd ff ff       	jmp    c0101e42 <__alltraps>

c0102136 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $82
c0102138:	6a 52                	push   $0x52
  jmp __alltraps
c010213a:	e9 03 fd ff ff       	jmp    c0101e42 <__alltraps>

c010213f <vector83>:
.globl vector83
vector83:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $83
c0102141:	6a 53                	push   $0x53
  jmp __alltraps
c0102143:	e9 fa fc ff ff       	jmp    c0101e42 <__alltraps>

c0102148 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $84
c010214a:	6a 54                	push   $0x54
  jmp __alltraps
c010214c:	e9 f1 fc ff ff       	jmp    c0101e42 <__alltraps>

c0102151 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $85
c0102153:	6a 55                	push   $0x55
  jmp __alltraps
c0102155:	e9 e8 fc ff ff       	jmp    c0101e42 <__alltraps>

c010215a <vector86>:
.globl vector86
vector86:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $86
c010215c:	6a 56                	push   $0x56
  jmp __alltraps
c010215e:	e9 df fc ff ff       	jmp    c0101e42 <__alltraps>

c0102163 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $87
c0102165:	6a 57                	push   $0x57
  jmp __alltraps
c0102167:	e9 d6 fc ff ff       	jmp    c0101e42 <__alltraps>

c010216c <vector88>:
.globl vector88
vector88:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $88
c010216e:	6a 58                	push   $0x58
  jmp __alltraps
c0102170:	e9 cd fc ff ff       	jmp    c0101e42 <__alltraps>

c0102175 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $89
c0102177:	6a 59                	push   $0x59
  jmp __alltraps
c0102179:	e9 c4 fc ff ff       	jmp    c0101e42 <__alltraps>

c010217e <vector90>:
.globl vector90
vector90:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $90
c0102180:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102182:	e9 bb fc ff ff       	jmp    c0101e42 <__alltraps>

c0102187 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $91
c0102189:	6a 5b                	push   $0x5b
  jmp __alltraps
c010218b:	e9 b2 fc ff ff       	jmp    c0101e42 <__alltraps>

c0102190 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $92
c0102192:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102194:	e9 a9 fc ff ff       	jmp    c0101e42 <__alltraps>

c0102199 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $93
c010219b:	6a 5d                	push   $0x5d
  jmp __alltraps
c010219d:	e9 a0 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021a2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $94
c01021a4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021a6:	e9 97 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021ab <vector95>:
.globl vector95
vector95:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $95
c01021ad:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021af:	e9 8e fc ff ff       	jmp    c0101e42 <__alltraps>

c01021b4 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $96
c01021b6:	6a 60                	push   $0x60
  jmp __alltraps
c01021b8:	e9 85 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021bd <vector97>:
.globl vector97
vector97:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $97
c01021bf:	6a 61                	push   $0x61
  jmp __alltraps
c01021c1:	e9 7c fc ff ff       	jmp    c0101e42 <__alltraps>

c01021c6 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $98
c01021c8:	6a 62                	push   $0x62
  jmp __alltraps
c01021ca:	e9 73 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021cf <vector99>:
.globl vector99
vector99:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $99
c01021d1:	6a 63                	push   $0x63
  jmp __alltraps
c01021d3:	e9 6a fc ff ff       	jmp    c0101e42 <__alltraps>

c01021d8 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $100
c01021da:	6a 64                	push   $0x64
  jmp __alltraps
c01021dc:	e9 61 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021e1 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $101
c01021e3:	6a 65                	push   $0x65
  jmp __alltraps
c01021e5:	e9 58 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021ea <vector102>:
.globl vector102
vector102:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $102
c01021ec:	6a 66                	push   $0x66
  jmp __alltraps
c01021ee:	e9 4f fc ff ff       	jmp    c0101e42 <__alltraps>

c01021f3 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $103
c01021f5:	6a 67                	push   $0x67
  jmp __alltraps
c01021f7:	e9 46 fc ff ff       	jmp    c0101e42 <__alltraps>

c01021fc <vector104>:
.globl vector104
vector104:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $104
c01021fe:	6a 68                	push   $0x68
  jmp __alltraps
c0102200:	e9 3d fc ff ff       	jmp    c0101e42 <__alltraps>

c0102205 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $105
c0102207:	6a 69                	push   $0x69
  jmp __alltraps
c0102209:	e9 34 fc ff ff       	jmp    c0101e42 <__alltraps>

c010220e <vector106>:
.globl vector106
vector106:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $106
c0102210:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102212:	e9 2b fc ff ff       	jmp    c0101e42 <__alltraps>

c0102217 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $107
c0102219:	6a 6b                	push   $0x6b
  jmp __alltraps
c010221b:	e9 22 fc ff ff       	jmp    c0101e42 <__alltraps>

c0102220 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $108
c0102222:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102224:	e9 19 fc ff ff       	jmp    c0101e42 <__alltraps>

c0102229 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $109
c010222b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010222d:	e9 10 fc ff ff       	jmp    c0101e42 <__alltraps>

c0102232 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $110
c0102234:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102236:	e9 07 fc ff ff       	jmp    c0101e42 <__alltraps>

c010223b <vector111>:
.globl vector111
vector111:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $111
c010223d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010223f:	e9 fe fb ff ff       	jmp    c0101e42 <__alltraps>

c0102244 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $112
c0102246:	6a 70                	push   $0x70
  jmp __alltraps
c0102248:	e9 f5 fb ff ff       	jmp    c0101e42 <__alltraps>

c010224d <vector113>:
.globl vector113
vector113:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $113
c010224f:	6a 71                	push   $0x71
  jmp __alltraps
c0102251:	e9 ec fb ff ff       	jmp    c0101e42 <__alltraps>

c0102256 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $114
c0102258:	6a 72                	push   $0x72
  jmp __alltraps
c010225a:	e9 e3 fb ff ff       	jmp    c0101e42 <__alltraps>

c010225f <vector115>:
.globl vector115
vector115:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $115
c0102261:	6a 73                	push   $0x73
  jmp __alltraps
c0102263:	e9 da fb ff ff       	jmp    c0101e42 <__alltraps>

c0102268 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $116
c010226a:	6a 74                	push   $0x74
  jmp __alltraps
c010226c:	e9 d1 fb ff ff       	jmp    c0101e42 <__alltraps>

c0102271 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $117
c0102273:	6a 75                	push   $0x75
  jmp __alltraps
c0102275:	e9 c8 fb ff ff       	jmp    c0101e42 <__alltraps>

c010227a <vector118>:
.globl vector118
vector118:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $118
c010227c:	6a 76                	push   $0x76
  jmp __alltraps
c010227e:	e9 bf fb ff ff       	jmp    c0101e42 <__alltraps>

c0102283 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $119
c0102285:	6a 77                	push   $0x77
  jmp __alltraps
c0102287:	e9 b6 fb ff ff       	jmp    c0101e42 <__alltraps>

c010228c <vector120>:
.globl vector120
vector120:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $120
c010228e:	6a 78                	push   $0x78
  jmp __alltraps
c0102290:	e9 ad fb ff ff       	jmp    c0101e42 <__alltraps>

c0102295 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $121
c0102297:	6a 79                	push   $0x79
  jmp __alltraps
c0102299:	e9 a4 fb ff ff       	jmp    c0101e42 <__alltraps>

c010229e <vector122>:
.globl vector122
vector122:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $122
c01022a0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022a2:	e9 9b fb ff ff       	jmp    c0101e42 <__alltraps>

c01022a7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $123
c01022a9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022ab:	e9 92 fb ff ff       	jmp    c0101e42 <__alltraps>

c01022b0 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $124
c01022b2:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022b4:	e9 89 fb ff ff       	jmp    c0101e42 <__alltraps>

c01022b9 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $125
c01022bb:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022bd:	e9 80 fb ff ff       	jmp    c0101e42 <__alltraps>

c01022c2 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $126
c01022c4:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022c6:	e9 77 fb ff ff       	jmp    c0101e42 <__alltraps>

c01022cb <vector127>:
.globl vector127
vector127:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $127
c01022cd:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022cf:	e9 6e fb ff ff       	jmp    c0101e42 <__alltraps>

c01022d4 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $128
c01022d6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022db:	e9 62 fb ff ff       	jmp    c0101e42 <__alltraps>

c01022e0 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $129
c01022e2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022e7:	e9 56 fb ff ff       	jmp    c0101e42 <__alltraps>

c01022ec <vector130>:
.globl vector130
vector130:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $130
c01022ee:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022f3:	e9 4a fb ff ff       	jmp    c0101e42 <__alltraps>

c01022f8 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $131
c01022fa:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022ff:	e9 3e fb ff ff       	jmp    c0101e42 <__alltraps>

c0102304 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $132
c0102306:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010230b:	e9 32 fb ff ff       	jmp    c0101e42 <__alltraps>

c0102310 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $133
c0102312:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102317:	e9 26 fb ff ff       	jmp    c0101e42 <__alltraps>

c010231c <vector134>:
.globl vector134
vector134:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $134
c010231e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102323:	e9 1a fb ff ff       	jmp    c0101e42 <__alltraps>

c0102328 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $135
c010232a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010232f:	e9 0e fb ff ff       	jmp    c0101e42 <__alltraps>

c0102334 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $136
c0102336:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010233b:	e9 02 fb ff ff       	jmp    c0101e42 <__alltraps>

c0102340 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $137
c0102342:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102347:	e9 f6 fa ff ff       	jmp    c0101e42 <__alltraps>

c010234c <vector138>:
.globl vector138
vector138:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $138
c010234e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102353:	e9 ea fa ff ff       	jmp    c0101e42 <__alltraps>

c0102358 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $139
c010235a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010235f:	e9 de fa ff ff       	jmp    c0101e42 <__alltraps>

c0102364 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $140
c0102366:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010236b:	e9 d2 fa ff ff       	jmp    c0101e42 <__alltraps>

c0102370 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $141
c0102372:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102377:	e9 c6 fa ff ff       	jmp    c0101e42 <__alltraps>

c010237c <vector142>:
.globl vector142
vector142:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $142
c010237e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102383:	e9 ba fa ff ff       	jmp    c0101e42 <__alltraps>

c0102388 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $143
c010238a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010238f:	e9 ae fa ff ff       	jmp    c0101e42 <__alltraps>

c0102394 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $144
c0102396:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010239b:	e9 a2 fa ff ff       	jmp    c0101e42 <__alltraps>

c01023a0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $145
c01023a2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023a7:	e9 96 fa ff ff       	jmp    c0101e42 <__alltraps>

c01023ac <vector146>:
.globl vector146
vector146:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $146
c01023ae:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023b3:	e9 8a fa ff ff       	jmp    c0101e42 <__alltraps>

c01023b8 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $147
c01023ba:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023bf:	e9 7e fa ff ff       	jmp    c0101e42 <__alltraps>

c01023c4 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $148
c01023c6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023cb:	e9 72 fa ff ff       	jmp    c0101e42 <__alltraps>

c01023d0 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $149
c01023d2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023d7:	e9 66 fa ff ff       	jmp    c0101e42 <__alltraps>

c01023dc <vector150>:
.globl vector150
vector150:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $150
c01023de:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023e3:	e9 5a fa ff ff       	jmp    c0101e42 <__alltraps>

c01023e8 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $151
c01023ea:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023ef:	e9 4e fa ff ff       	jmp    c0101e42 <__alltraps>

c01023f4 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $152
c01023f6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023fb:	e9 42 fa ff ff       	jmp    c0101e42 <__alltraps>

c0102400 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $153
c0102402:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102407:	e9 36 fa ff ff       	jmp    c0101e42 <__alltraps>

c010240c <vector154>:
.globl vector154
vector154:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $154
c010240e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102413:	e9 2a fa ff ff       	jmp    c0101e42 <__alltraps>

c0102418 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $155
c010241a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010241f:	e9 1e fa ff ff       	jmp    c0101e42 <__alltraps>

c0102424 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $156
c0102426:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010242b:	e9 12 fa ff ff       	jmp    c0101e42 <__alltraps>

c0102430 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $157
c0102432:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102437:	e9 06 fa ff ff       	jmp    c0101e42 <__alltraps>

c010243c <vector158>:
.globl vector158
vector158:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $158
c010243e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102443:	e9 fa f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102448 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $159
c010244a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010244f:	e9 ee f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102454 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $160
c0102456:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010245b:	e9 e2 f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102460 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $161
c0102462:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102467:	e9 d6 f9 ff ff       	jmp    c0101e42 <__alltraps>

c010246c <vector162>:
.globl vector162
vector162:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $162
c010246e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102473:	e9 ca f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102478 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $163
c010247a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010247f:	e9 be f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102484 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $164
c0102486:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010248b:	e9 b2 f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102490 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $165
c0102492:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102497:	e9 a6 f9 ff ff       	jmp    c0101e42 <__alltraps>

c010249c <vector166>:
.globl vector166
vector166:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $166
c010249e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024a3:	e9 9a f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024a8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $167
c01024aa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024af:	e9 8e f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024b4 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $168
c01024b6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024bb:	e9 82 f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024c0 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $169
c01024c2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024c7:	e9 76 f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024cc <vector170>:
.globl vector170
vector170:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $170
c01024ce:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024d3:	e9 6a f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024d8 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $171
c01024da:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024df:	e9 5e f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024e4 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $172
c01024e6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024eb:	e9 52 f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024f0 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $173
c01024f2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024f7:	e9 46 f9 ff ff       	jmp    c0101e42 <__alltraps>

c01024fc <vector174>:
.globl vector174
vector174:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $174
c01024fe:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102503:	e9 3a f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102508 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $175
c010250a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010250f:	e9 2e f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102514 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $176
c0102516:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010251b:	e9 22 f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102520 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $177
c0102522:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102527:	e9 16 f9 ff ff       	jmp    c0101e42 <__alltraps>

c010252c <vector178>:
.globl vector178
vector178:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $178
c010252e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102533:	e9 0a f9 ff ff       	jmp    c0101e42 <__alltraps>

c0102538 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $179
c010253a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010253f:	e9 fe f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102544 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $180
c0102546:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010254b:	e9 f2 f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102550 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $181
c0102552:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102557:	e9 e6 f8 ff ff       	jmp    c0101e42 <__alltraps>

c010255c <vector182>:
.globl vector182
vector182:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $182
c010255e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102563:	e9 da f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102568 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $183
c010256a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010256f:	e9 ce f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102574 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $184
c0102576:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010257b:	e9 c2 f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102580 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $185
c0102582:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102587:	e9 b6 f8 ff ff       	jmp    c0101e42 <__alltraps>

c010258c <vector186>:
.globl vector186
vector186:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $186
c010258e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102593:	e9 aa f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102598 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $187
c010259a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010259f:	e9 9e f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025a4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $188
c01025a6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025ab:	e9 92 f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025b0 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $189
c01025b2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025b7:	e9 86 f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025bc <vector190>:
.globl vector190
vector190:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $190
c01025be:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025c3:	e9 7a f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025c8 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $191
c01025ca:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025cf:	e9 6e f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025d4 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $192
c01025d6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025db:	e9 62 f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025e0 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $193
c01025e2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025e7:	e9 56 f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025ec <vector194>:
.globl vector194
vector194:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $194
c01025ee:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025f3:	e9 4a f8 ff ff       	jmp    c0101e42 <__alltraps>

c01025f8 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $195
c01025fa:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025ff:	e9 3e f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102604 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $196
c0102606:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010260b:	e9 32 f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102610 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $197
c0102612:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102617:	e9 26 f8 ff ff       	jmp    c0101e42 <__alltraps>

c010261c <vector198>:
.globl vector198
vector198:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $198
c010261e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102623:	e9 1a f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102628 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $199
c010262a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010262f:	e9 0e f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102634 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $200
c0102636:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010263b:	e9 02 f8 ff ff       	jmp    c0101e42 <__alltraps>

c0102640 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $201
c0102642:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102647:	e9 f6 f7 ff ff       	jmp    c0101e42 <__alltraps>

c010264c <vector202>:
.globl vector202
vector202:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $202
c010264e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102653:	e9 ea f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102658 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $203
c010265a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010265f:	e9 de f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102664 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $204
c0102666:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010266b:	e9 d2 f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102670 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $205
c0102672:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102677:	e9 c6 f7 ff ff       	jmp    c0101e42 <__alltraps>

c010267c <vector206>:
.globl vector206
vector206:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $206
c010267e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102683:	e9 ba f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102688 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $207
c010268a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010268f:	e9 ae f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102694 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $208
c0102696:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010269b:	e9 a2 f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026a0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $209
c01026a2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026a7:	e9 96 f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026ac <vector210>:
.globl vector210
vector210:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $210
c01026ae:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026b3:	e9 8a f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026b8 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $211
c01026ba:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026bf:	e9 7e f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026c4 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $212
c01026c6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026cb:	e9 72 f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026d0 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $213
c01026d2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026d7:	e9 66 f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026dc <vector214>:
.globl vector214
vector214:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $214
c01026de:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026e3:	e9 5a f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026e8 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $215
c01026ea:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026ef:	e9 4e f7 ff ff       	jmp    c0101e42 <__alltraps>

c01026f4 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $216
c01026f6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026fb:	e9 42 f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102700 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $217
c0102702:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102707:	e9 36 f7 ff ff       	jmp    c0101e42 <__alltraps>

c010270c <vector218>:
.globl vector218
vector218:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $218
c010270e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102713:	e9 2a f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102718 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $219
c010271a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010271f:	e9 1e f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102724 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $220
c0102726:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010272b:	e9 12 f7 ff ff       	jmp    c0101e42 <__alltraps>

c0102730 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $221
c0102732:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102737:	e9 06 f7 ff ff       	jmp    c0101e42 <__alltraps>

c010273c <vector222>:
.globl vector222
vector222:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $222
c010273e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102743:	e9 fa f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102748 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $223
c010274a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010274f:	e9 ee f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102754 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $224
c0102756:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010275b:	e9 e2 f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102760 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $225
c0102762:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102767:	e9 d6 f6 ff ff       	jmp    c0101e42 <__alltraps>

c010276c <vector226>:
.globl vector226
vector226:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $226
c010276e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102773:	e9 ca f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102778 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $227
c010277a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010277f:	e9 be f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102784 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $228
c0102786:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010278b:	e9 b2 f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102790 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $229
c0102792:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102797:	e9 a6 f6 ff ff       	jmp    c0101e42 <__alltraps>

c010279c <vector230>:
.globl vector230
vector230:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $230
c010279e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027a3:	e9 9a f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027a8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $231
c01027aa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027af:	e9 8e f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027b4 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $232
c01027b6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027bb:	e9 82 f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027c0 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $233
c01027c2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027c7:	e9 76 f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027cc <vector234>:
.globl vector234
vector234:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $234
c01027ce:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027d3:	e9 6a f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027d8 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $235
c01027da:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027df:	e9 5e f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027e4 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $236
c01027e6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027eb:	e9 52 f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027f0 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $237
c01027f2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027f7:	e9 46 f6 ff ff       	jmp    c0101e42 <__alltraps>

c01027fc <vector238>:
.globl vector238
vector238:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $238
c01027fe:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102803:	e9 3a f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102808 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $239
c010280a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010280f:	e9 2e f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102814 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $240
c0102816:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010281b:	e9 22 f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102820 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $241
c0102822:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102827:	e9 16 f6 ff ff       	jmp    c0101e42 <__alltraps>

c010282c <vector242>:
.globl vector242
vector242:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $242
c010282e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102833:	e9 0a f6 ff ff       	jmp    c0101e42 <__alltraps>

c0102838 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $243
c010283a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010283f:	e9 fe f5 ff ff       	jmp    c0101e42 <__alltraps>

c0102844 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $244
c0102846:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010284b:	e9 f2 f5 ff ff       	jmp    c0101e42 <__alltraps>

c0102850 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $245
c0102852:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102857:	e9 e6 f5 ff ff       	jmp    c0101e42 <__alltraps>

c010285c <vector246>:
.globl vector246
vector246:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $246
c010285e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102863:	e9 da f5 ff ff       	jmp    c0101e42 <__alltraps>

c0102868 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $247
c010286a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010286f:	e9 ce f5 ff ff       	jmp    c0101e42 <__alltraps>

c0102874 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $248
c0102876:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010287b:	e9 c2 f5 ff ff       	jmp    c0101e42 <__alltraps>

c0102880 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $249
c0102882:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102887:	e9 b6 f5 ff ff       	jmp    c0101e42 <__alltraps>

c010288c <vector250>:
.globl vector250
vector250:
  pushl $0
c010288c:	6a 00                	push   $0x0
  pushl $250
c010288e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102893:	e9 aa f5 ff ff       	jmp    c0101e42 <__alltraps>

c0102898 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102898:	6a 00                	push   $0x0
  pushl $251
c010289a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010289f:	e9 9e f5 ff ff       	jmp    c0101e42 <__alltraps>

c01028a4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $252
c01028a6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028ab:	e9 92 f5 ff ff       	jmp    c0101e42 <__alltraps>

c01028b0 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028b0:	6a 00                	push   $0x0
  pushl $253
c01028b2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028b7:	e9 86 f5 ff ff       	jmp    c0101e42 <__alltraps>

c01028bc <vector254>:
.globl vector254
vector254:
  pushl $0
c01028bc:	6a 00                	push   $0x0
  pushl $254
c01028be:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028c3:	e9 7a f5 ff ff       	jmp    c0101e42 <__alltraps>

c01028c8 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $255
c01028ca:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028cf:	e9 6e f5 ff ff       	jmp    c0101e42 <__alltraps>

c01028d4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028d4:	55                   	push   %ebp
c01028d5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01028da:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01028df:	29 c2                	sub    %eax,%edx
c01028e1:	89 d0                	mov    %edx,%eax
c01028e3:	c1 f8 02             	sar    $0x2,%eax
c01028e6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028ec:	5d                   	pop    %ebp
c01028ed:	c3                   	ret    

c01028ee <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028ee:	55                   	push   %ebp
c01028ef:	89 e5                	mov    %esp,%ebp
c01028f1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f7:	89 04 24             	mov    %eax,(%esp)
c01028fa:	e8 d5 ff ff ff       	call   c01028d4 <page2ppn>
c01028ff:	c1 e0 0c             	shl    $0xc,%eax
}
c0102902:	c9                   	leave  
c0102903:	c3                   	ret    

c0102904 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102904:	55                   	push   %ebp
c0102905:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102907:	8b 45 08             	mov    0x8(%ebp),%eax
c010290a:	8b 00                	mov    (%eax),%eax
}
c010290c:	5d                   	pop    %ebp
c010290d:	c3                   	ret    

c010290e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010290e:	55                   	push   %ebp
c010290f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102911:	8b 45 08             	mov    0x8(%ebp),%eax
c0102914:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102917:	89 10                	mov    %edx,(%eax)
}
c0102919:	5d                   	pop    %ebp
c010291a:	c3                   	ret    

c010291b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010291b:	55                   	push   %ebp
c010291c:	89 e5                	mov    %esp,%ebp
c010291e:	83 ec 10             	sub    $0x10,%esp
c0102921:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010292b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010292e:	89 50 04             	mov    %edx,0x4(%eax)
c0102931:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102934:	8b 50 04             	mov    0x4(%eax),%edx
c0102937:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010293a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010293c:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102943:	00 00 00 
}
c0102946:	c9                   	leave  
c0102947:	c3                   	ret    

c0102948 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102948:	55                   	push   %ebp
c0102949:	89 e5                	mov    %esp,%ebp
c010294b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010294e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102952:	75 24                	jne    c0102978 <default_init_memmap+0x30>
c0102954:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c010295b:	c0 
c010295c:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102963:	c0 
c0102964:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010296b:	00 
c010296c:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102973:	e8 69 e3 ff ff       	call   c0100ce1 <__panic>
    struct Page *p = base;
c0102978:	8b 45 08             	mov    0x8(%ebp),%eax
c010297b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010297e:	eb 7d                	jmp    c01029fd <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102980:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102983:	83 c0 04             	add    $0x4,%eax
c0102986:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010298d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102990:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102993:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102996:	0f a3 10             	bt     %edx,(%eax)
c0102999:	19 c0                	sbb    %eax,%eax
c010299b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010299e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029a2:	0f 95 c0             	setne  %al
c01029a5:	0f b6 c0             	movzbl %al,%eax
c01029a8:	85 c0                	test   %eax,%eax
c01029aa:	75 24                	jne    c01029d0 <default_init_memmap+0x88>
c01029ac:	c7 44 24 0c 81 67 10 	movl   $0xc0106781,0xc(%esp)
c01029b3:	c0 
c01029b4:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01029bb:	c0 
c01029bc:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01029c3:	00 
c01029c4:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01029cb:	e8 11 e3 ff ff       	call   c0100ce1 <__panic>
        p->flags = p->property = 0;
c01029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029dd:	8b 50 08             	mov    0x8(%eax),%edx
c01029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e3:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029ed:	00 
c01029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f1:	89 04 24             	mov    %eax,(%esp)
c01029f4:	e8 15 ff ff ff       	call   c010290e <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029f9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029fd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a00:	89 d0                	mov    %edx,%eax
c0102a02:	c1 e0 02             	shl    $0x2,%eax
c0102a05:	01 d0                	add    %edx,%eax
c0102a07:	c1 e0 02             	shl    $0x2,%eax
c0102a0a:	89 c2                	mov    %eax,%edx
c0102a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a0f:	01 d0                	add    %edx,%eax
c0102a11:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a14:	0f 85 66 ff ff ff    	jne    c0102980 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a20:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a26:	83 c0 04             	add    $0x4,%eax
c0102a29:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a39:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102a3c:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a45:	01 d0                	add    %edx,%eax
c0102a47:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add(&free_list, &(base->page_link));
c0102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4f:	83 c0 0c             	add    $0xc,%eax
c0102a52:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102a59:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a62:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a65:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a6b:	8b 40 04             	mov    0x4(%eax),%eax
c0102a6e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a71:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102a74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a77:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a80:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a83:	89 10                	mov    %edx,(%eax)
c0102a85:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a88:	8b 10                	mov    (%eax),%edx
c0102a8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a90:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a93:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a96:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a99:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a9c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a9f:	89 10                	mov    %edx,(%eax)
}
c0102aa1:	c9                   	leave  
c0102aa2:	c3                   	ret    

c0102aa3 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102aa3:	55                   	push   %ebp
c0102aa4:	89 e5                	mov    %esp,%ebp
c0102aa6:	83 ec 68             	sub    $0x68,%esp
    
    assert(n > 0);
c0102aa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aad:	75 24                	jne    c0102ad3 <default_alloc_pages+0x30>
c0102aaf:	c7 44 24 0c 50 67 10 	movl   $0xc0106750,0xc(%esp)
c0102ab6:	c0 
c0102ab7:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102abe:	c0 
c0102abf:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0102ac6:	00 
c0102ac7:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102ace:	e8 0e e2 ff ff       	call   c0100ce1 <__panic>
    if (n > nr_free) {
c0102ad3:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102ad8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102adb:	73 0a                	jae    c0102ae7 <default_alloc_pages+0x44>
        return NULL;
c0102add:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ae2:	e9 54 01 00 00       	jmp    c0102c3b <default_alloc_pages+0x198>
    }
    struct Page *page = NULL;
c0102ae7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102aee:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102af5:	eb 1c                	jmp    c0102b13 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102afa:	83 e8 0c             	sub    $0xc,%eax
c0102afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b03:	8b 40 08             	mov    0x8(%eax),%eax
c0102b06:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b09:	72 08                	jb     c0102b13 <default_alloc_pages+0x70>
            page = p;
c0102b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b11:	eb 18                	jmp    c0102b2b <default_alloc_pages+0x88>
c0102b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b1c:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b22:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102b29:	75 cc                	jne    c0102af7 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if(page != NULL){
c0102b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b2f:	0f 84 03 01 00 00    	je     c0102c38 <default_alloc_pages+0x195>
c0102b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b3e:	8b 00                	mov    (%eax),%eax
        le = list_prev(le);
c0102b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(page->property > n){
c0102b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b46:	8b 40 08             	mov    0x8(%eax),%eax
c0102b49:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b4c:	0f 86 95 00 00 00    	jbe    c0102be7 <default_alloc_pages+0x144>
            struct Page *p = page + n;
c0102b52:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b55:	89 d0                	mov    %edx,%eax
c0102b57:	c1 e0 02             	shl    $0x2,%eax
c0102b5a:	01 d0                	add    %edx,%eax
c0102b5c:	c1 e0 02             	shl    $0x2,%eax
c0102b5f:	89 c2                	mov    %eax,%edx
c0102b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b64:	01 d0                	add    %edx,%eax
c0102b66:	89 45 e8             	mov    %eax,-0x18(%ebp)
            SetPageProperty(p);
c0102b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b6c:	83 c0 04             	add    $0x4,%eax
c0102b6f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102b76:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b79:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b7f:	0f ab 10             	bts    %edx,(%eax)
            p->property = page->property - n;
c0102b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b85:	8b 40 08             	mov    0x8(%eax),%eax
c0102b88:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b8b:	89 c2                	mov    %eax,%edx
c0102b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b90:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(le, &(p->page_link));
c0102b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b96:	8d 50 0c             	lea    0xc(%eax),%edx
c0102b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b9c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102b9f:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102ba2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ba5:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102ba8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102bab:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102bae:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bb1:	8b 40 04             	mov    0x4(%eax),%eax
c0102bb4:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102bb7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102bba:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bbd:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102bc0:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102bc3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bc6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bc9:	89 10                	mov    %edx,(%eax)
c0102bcb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bce:	8b 10                	mov    (%eax),%edx
c0102bd0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102bd3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bd6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bd9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102bdc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bdf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102be2:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102be5:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0102be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bea:	83 c0 0c             	add    $0xc,%eax
c0102bed:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102bf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102bf3:	8b 40 04             	mov    0x4(%eax),%eax
c0102bf6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bf9:	8b 12                	mov    (%edx),%edx
c0102bfb:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0102bfe:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c04:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c07:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c0d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102c10:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102c12:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102c17:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c1a:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        ClearPageProperty(page);
c0102c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c22:	83 c0 04             	add    $0x4,%eax
c0102c25:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0102c2c:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c2f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c32:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102c35:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c3b:	c9                   	leave  
c0102c3c:	c3                   	ret    

c0102c3d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c3d:	55                   	push   %ebp
c0102c3e:	89 e5                	mov    %esp,%ebp
c0102c40:	81 ec 88 00 00 00    	sub    $0x88,%esp
    struct Page *p = base;
c0102c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c4c:	e9 9d 00 00 00       	jmp    c0102cee <default_free_pages+0xb1>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c54:	83 c0 04             	add    $0x4,%eax
c0102c57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c61:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c64:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c67:	0f a3 10             	bt     %edx,(%eax)
c0102c6a:	19 c0                	sbb    %eax,%eax
c0102c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c73:	0f 95 c0             	setne  %al
c0102c76:	0f b6 c0             	movzbl %al,%eax
c0102c79:	85 c0                	test   %eax,%eax
c0102c7b:	75 2c                	jne    c0102ca9 <default_free_pages+0x6c>
c0102c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c80:	83 c0 04             	add    $0x4,%eax
c0102c83:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c90:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c93:	0f a3 10             	bt     %edx,(%eax)
c0102c96:	19 c0                	sbb    %eax,%eax
c0102c98:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c9b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c9f:	0f 95 c0             	setne  %al
c0102ca2:	0f b6 c0             	movzbl %al,%eax
c0102ca5:	85 c0                	test   %eax,%eax
c0102ca7:	74 24                	je     c0102ccd <default_free_pages+0x90>
c0102ca9:	c7 44 24 0c 94 67 10 	movl   $0xc0106794,0xc(%esp)
c0102cb0:	c0 
c0102cb1:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102cb8:	c0 
c0102cb9:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0102cc0:	00 
c0102cc1:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102cc8:	e8 14 e0 ff ff       	call   c0100ce1 <__panic>
        p->flags = 0;
c0102ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102cd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cde:	00 
c0102cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce2:	89 04 24             	mov    %eax,(%esp)
c0102ce5:	e8 24 fc ff ff       	call   c010290e <set_page_ref>
}

static void
default_free_pages(struct Page *base, size_t n) {
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102cea:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102cee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cf1:	89 d0                	mov    %edx,%eax
c0102cf3:	c1 e0 02             	shl    $0x2,%eax
c0102cf6:	01 d0                	add    %edx,%eax
c0102cf8:	c1 e0 02             	shl    $0x2,%eax
c0102cfb:	89 c2                	mov    %eax,%edx
c0102cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d00:	01 d0                	add    %edx,%eax
c0102d02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d05:	0f 85 46 ff ff ff    	jne    c0102c51 <default_free_pages+0x14>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d11:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d17:	83 c0 04             	add    $0x4,%eax
c0102d1a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102d21:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d24:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d2a:	0f ab 10             	bts    %edx,(%eax)
c0102d2d:	c7 45 cc 50 89 11 c0 	movl   $0xc0118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d37:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102d3d:	e9 26 01 00 00       	jmp    c0102e68 <default_free_pages+0x22b>
        p = le2page(le, page_link);
c0102d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d45:	83 e8 0c             	sub    $0xc,%eax
c0102d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c0102d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4e:	8b 50 08             	mov    0x8(%eax),%edx
c0102d51:	89 d0                	mov    %edx,%eax
c0102d53:	c1 e0 02             	shl    $0x2,%eax
c0102d56:	01 d0                	add    %edx,%eax
c0102d58:	c1 e0 02             	shl    $0x2,%eax
c0102d5b:	89 c2                	mov    %eax,%edx
c0102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d60:	01 d0                	add    %edx,%eax
c0102d62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d65:	75 6c                	jne    c0102dd3 <default_free_pages+0x196>
            base->property += p->property;
c0102d67:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d6a:	8b 50 08             	mov    0x8(%eax),%edx
c0102d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d70:	8b 40 08             	mov    0x8(%eax),%eax
c0102d73:	01 c2                	add    %eax,%edx
c0102d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d78:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7e:	83 c0 04             	add    $0x4,%eax
c0102d81:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102d88:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d8b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d8e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d91:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d97:	83 c0 0c             	add    $0xc,%eax
c0102d9a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102da0:	8b 40 04             	mov    0x4(%eax),%eax
c0102da3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102da6:	8b 12                	mov    (%edx),%edx
c0102da8:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102dab:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102dae:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102db1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102db4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102db7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dbd:	89 10                	mov    %edx,(%eax)
c0102dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dc2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102dc5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102dc8:	8b 40 04             	mov    0x4(%eax),%eax
            le = list_next(le);
c0102dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
c0102dce:	e9 a2 00 00 00       	jmp    c0102e75 <default_free_pages+0x238>
        }
        else if (p + p->property == base) {
c0102dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd6:	8b 50 08             	mov    0x8(%eax),%edx
c0102dd9:	89 d0                	mov    %edx,%eax
c0102ddb:	c1 e0 02             	shl    $0x2,%eax
c0102dde:	01 d0                	add    %edx,%eax
c0102de0:	c1 e0 02             	shl    $0x2,%eax
c0102de3:	89 c2                	mov    %eax,%edx
c0102de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de8:	01 d0                	add    %edx,%eax
c0102dea:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ded:	75 60                	jne    c0102e4f <default_free_pages+0x212>
            p->property += base->property;
c0102def:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df2:	8b 50 08             	mov    0x8(%eax),%edx
c0102df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df8:	8b 40 08             	mov    0x8(%eax),%eax
c0102dfb:	01 c2                	add    %eax,%edx
c0102dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e00:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e06:	83 c0 04             	add    $0x4,%eax
c0102e09:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102e10:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102e13:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e16:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e19:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e1f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e25:	83 c0 0c             	add    $0xc,%eax
c0102e28:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e2b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e2e:	8b 40 04             	mov    0x4(%eax),%eax
c0102e31:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e34:	8b 12                	mov    (%edx),%edx
c0102e36:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e39:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e3c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e3f:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102e42:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e45:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e48:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e4b:	89 10                	mov    %edx,(%eax)
c0102e4d:	eb 0a                	jmp    c0102e59 <default_free_pages+0x21c>
        }
        else if(p > base){
c0102e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e52:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e55:	76 02                	jbe    c0102e59 <default_free_pages+0x21c>
            //le = list_prev(le);
            break;
c0102e57:	eb 1c                	jmp    c0102e75 <default_free_pages+0x238>
c0102e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e5c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e5f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e62:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0102e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102e68:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102e6f:	0f 85 cd fe ff ff    	jne    c0102d42 <default_free_pages+0x105>
            //le = list_prev(le);
            break;
        }
        le = list_next(le);
    }
    nr_free += n;
c0102e75:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e7e:	01 d0                	add    %edx,%eax
c0102e80:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add_before(le, &(base->page_link));
c0102e85:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e88:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e8e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e91:	89 55 94             	mov    %edx,-0x6c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102e94:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e97:	8b 00                	mov    (%eax),%eax
c0102e99:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102e9c:	89 55 90             	mov    %edx,-0x70(%ebp)
c0102e9f:	89 45 8c             	mov    %eax,-0x74(%ebp)
c0102ea2:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ea5:	89 45 88             	mov    %eax,-0x78(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ea8:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102eab:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102eae:	89 10                	mov    %edx,(%eax)
c0102eb0:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102eb3:	8b 10                	mov    (%eax),%edx
c0102eb5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102eb8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ebb:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102ebe:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102ec1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ec4:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102ec7:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102eca:	89 10                	mov    %edx,(%eax)
}
c0102ecc:	c9                   	leave  
c0102ecd:	c3                   	ret    

c0102ece <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ece:	55                   	push   %ebp
c0102ecf:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ed1:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102ed6:	5d                   	pop    %ebp
c0102ed7:	c3                   	ret    

c0102ed8 <basic_check>:

static void
basic_check(void) {
c0102ed8:	55                   	push   %ebp
c0102ed9:	89 e5                	mov    %esp,%ebp
c0102edb:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102ede:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ef1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ef8:	e8 85 0e 00 00       	call   c0103d82 <alloc_pages>
c0102efd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f04:	75 24                	jne    c0102f2a <basic_check+0x52>
c0102f06:	c7 44 24 0c b9 67 10 	movl   $0xc01067b9,0xc(%esp)
c0102f0d:	c0 
c0102f0e:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102f15:	c0 
c0102f16:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0102f1d:	00 
c0102f1e:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102f25:	e8 b7 dd ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f31:	e8 4c 0e 00 00       	call   c0103d82 <alloc_pages>
c0102f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f3d:	75 24                	jne    c0102f63 <basic_check+0x8b>
c0102f3f:	c7 44 24 0c d5 67 10 	movl   $0xc01067d5,0xc(%esp)
c0102f46:	c0 
c0102f47:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102f4e:	c0 
c0102f4f:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102f56:	00 
c0102f57:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102f5e:	e8 7e dd ff ff       	call   c0100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f6a:	e8 13 0e 00 00       	call   c0103d82 <alloc_pages>
c0102f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f76:	75 24                	jne    c0102f9c <basic_check+0xc4>
c0102f78:	c7 44 24 0c f1 67 10 	movl   $0xc01067f1,0xc(%esp)
c0102f7f:	c0 
c0102f80:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102f87:	c0 
c0102f88:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0102f8f:	00 
c0102f90:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102f97:	e8 45 dd ff ff       	call   c0100ce1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fa2:	74 10                	je     c0102fb4 <basic_check+0xdc>
c0102fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fa7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102faa:	74 08                	je     c0102fb4 <basic_check+0xdc>
c0102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102faf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fb2:	75 24                	jne    c0102fd8 <basic_check+0x100>
c0102fb4:	c7 44 24 0c 10 68 10 	movl   $0xc0106810,0xc(%esp)
c0102fbb:	c0 
c0102fbc:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0102fc3:	c0 
c0102fc4:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0102fcb:	00 
c0102fcc:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0102fd3:	e8 09 dd ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fdb:	89 04 24             	mov    %eax,(%esp)
c0102fde:	e8 21 f9 ff ff       	call   c0102904 <page_ref>
c0102fe3:	85 c0                	test   %eax,%eax
c0102fe5:	75 1e                	jne    c0103005 <basic_check+0x12d>
c0102fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fea:	89 04 24             	mov    %eax,(%esp)
c0102fed:	e8 12 f9 ff ff       	call   c0102904 <page_ref>
c0102ff2:	85 c0                	test   %eax,%eax
c0102ff4:	75 0f                	jne    c0103005 <basic_check+0x12d>
c0102ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ff9:	89 04 24             	mov    %eax,(%esp)
c0102ffc:	e8 03 f9 ff ff       	call   c0102904 <page_ref>
c0103001:	85 c0                	test   %eax,%eax
c0103003:	74 24                	je     c0103029 <basic_check+0x151>
c0103005:	c7 44 24 0c 34 68 10 	movl   $0xc0106834,0xc(%esp)
c010300c:	c0 
c010300d:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103014:	c0 
c0103015:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c010301c:	00 
c010301d:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103024:	e8 b8 dc ff ff       	call   c0100ce1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103029:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010302c:	89 04 24             	mov    %eax,(%esp)
c010302f:	e8 ba f8 ff ff       	call   c01028ee <page2pa>
c0103034:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010303a:	c1 e2 0c             	shl    $0xc,%edx
c010303d:	39 d0                	cmp    %edx,%eax
c010303f:	72 24                	jb     c0103065 <basic_check+0x18d>
c0103041:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c0103048:	c0 
c0103049:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103050:	c0 
c0103051:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103058:	00 
c0103059:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103060:	e8 7c dc ff ff       	call   c0100ce1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103065:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103068:	89 04 24             	mov    %eax,(%esp)
c010306b:	e8 7e f8 ff ff       	call   c01028ee <page2pa>
c0103070:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103076:	c1 e2 0c             	shl    $0xc,%edx
c0103079:	39 d0                	cmp    %edx,%eax
c010307b:	72 24                	jb     c01030a1 <basic_check+0x1c9>
c010307d:	c7 44 24 0c 8d 68 10 	movl   $0xc010688d,0xc(%esp)
c0103084:	c0 
c0103085:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010308c:	c0 
c010308d:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0103094:	00 
c0103095:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010309c:	e8 40 dc ff ff       	call   c0100ce1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030a4:	89 04 24             	mov    %eax,(%esp)
c01030a7:	e8 42 f8 ff ff       	call   c01028ee <page2pa>
c01030ac:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01030b2:	c1 e2 0c             	shl    $0xc,%edx
c01030b5:	39 d0                	cmp    %edx,%eax
c01030b7:	72 24                	jb     c01030dd <basic_check+0x205>
c01030b9:	c7 44 24 0c aa 68 10 	movl   $0xc01068aa,0xc(%esp)
c01030c0:	c0 
c01030c1:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01030c8:	c0 
c01030c9:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c01030d0:	00 
c01030d1:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01030d8:	e8 04 dc ff ff       	call   c0100ce1 <__panic>

    list_entry_t free_list_store = free_list;
c01030dd:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01030e2:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01030e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030ee:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01030f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030fb:	89 50 04             	mov    %edx,0x4(%eax)
c01030fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103101:	8b 50 04             	mov    0x4(%eax),%edx
c0103104:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103107:	89 10                	mov    %edx,(%eax)
c0103109:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103110:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103113:	8b 40 04             	mov    0x4(%eax),%eax
c0103116:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103119:	0f 94 c0             	sete   %al
c010311c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010311f:	85 c0                	test   %eax,%eax
c0103121:	75 24                	jne    c0103147 <basic_check+0x26f>
c0103123:	c7 44 24 0c c7 68 10 	movl   $0xc01068c7,0xc(%esp)
c010312a:	c0 
c010312b:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103132:	c0 
c0103133:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c010313a:	00 
c010313b:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103142:	e8 9a db ff ff       	call   c0100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103147:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010314c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010314f:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103156:	00 00 00 

    assert(alloc_page() == NULL);
c0103159:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103160:	e8 1d 0c 00 00       	call   c0103d82 <alloc_pages>
c0103165:	85 c0                	test   %eax,%eax
c0103167:	74 24                	je     c010318d <basic_check+0x2b5>
c0103169:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c0103170:	c0 
c0103171:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103178:	c0 
c0103179:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103180:	00 
c0103181:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103188:	e8 54 db ff ff       	call   c0100ce1 <__panic>

    free_page(p0);
c010318d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103194:	00 
c0103195:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103198:	89 04 24             	mov    %eax,(%esp)
c010319b:	e8 1a 0c 00 00       	call   c0103dba <free_pages>
    free_page(p1);
c01031a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031a7:	00 
c01031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031ab:	89 04 24             	mov    %eax,(%esp)
c01031ae:	e8 07 0c 00 00       	call   c0103dba <free_pages>
    free_page(p2);
c01031b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031ba:	00 
c01031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031be:	89 04 24             	mov    %eax,(%esp)
c01031c1:	e8 f4 0b 00 00       	call   c0103dba <free_pages>
    assert(nr_free == 3);
c01031c6:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01031cb:	83 f8 03             	cmp    $0x3,%eax
c01031ce:	74 24                	je     c01031f4 <basic_check+0x31c>
c01031d0:	c7 44 24 0c f3 68 10 	movl   $0xc01068f3,0xc(%esp)
c01031d7:	c0 
c01031d8:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01031df:	c0 
c01031e0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01031e7:	00 
c01031e8:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01031ef:	e8 ed da ff ff       	call   c0100ce1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01031f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031fb:	e8 82 0b 00 00       	call   c0103d82 <alloc_pages>
c0103200:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103203:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103207:	75 24                	jne    c010322d <basic_check+0x355>
c0103209:	c7 44 24 0c b9 67 10 	movl   $0xc01067b9,0xc(%esp)
c0103210:	c0 
c0103211:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103218:	c0 
c0103219:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103220:	00 
c0103221:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103228:	e8 b4 da ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010322d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103234:	e8 49 0b 00 00       	call   c0103d82 <alloc_pages>
c0103239:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010323c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103240:	75 24                	jne    c0103266 <basic_check+0x38e>
c0103242:	c7 44 24 0c d5 67 10 	movl   $0xc01067d5,0xc(%esp)
c0103249:	c0 
c010324a:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103251:	c0 
c0103252:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103259:	00 
c010325a:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103261:	e8 7b da ff ff       	call   c0100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103266:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010326d:	e8 10 0b 00 00       	call   c0103d82 <alloc_pages>
c0103272:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103279:	75 24                	jne    c010329f <basic_check+0x3c7>
c010327b:	c7 44 24 0c f1 67 10 	movl   $0xc01067f1,0xc(%esp)
c0103282:	c0 
c0103283:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010328a:	c0 
c010328b:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103292:	00 
c0103293:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010329a:	e8 42 da ff ff       	call   c0100ce1 <__panic>

    assert(alloc_page() == NULL);
c010329f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032a6:	e8 d7 0a 00 00       	call   c0103d82 <alloc_pages>
c01032ab:	85 c0                	test   %eax,%eax
c01032ad:	74 24                	je     c01032d3 <basic_check+0x3fb>
c01032af:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c01032b6:	c0 
c01032b7:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01032be:	c0 
c01032bf:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01032c6:	00 
c01032c7:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01032ce:	e8 0e da ff ff       	call   c0100ce1 <__panic>

    free_page(p0);
c01032d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032da:	00 
c01032db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032de:	89 04 24             	mov    %eax,(%esp)
c01032e1:	e8 d4 0a 00 00       	call   c0103dba <free_pages>
c01032e6:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c01032ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032f0:	8b 40 04             	mov    0x4(%eax),%eax
c01032f3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01032f6:	0f 94 c0             	sete   %al
c01032f9:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032fc:	85 c0                	test   %eax,%eax
c01032fe:	74 24                	je     c0103324 <basic_check+0x44c>
c0103300:	c7 44 24 0c 00 69 10 	movl   $0xc0106900,0xc(%esp)
c0103307:	c0 
c0103308:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010330f:	c0 
c0103310:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103317:	00 
c0103318:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010331f:	e8 bd d9 ff ff       	call   c0100ce1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103324:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010332b:	e8 52 0a 00 00       	call   c0103d82 <alloc_pages>
c0103330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103336:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103339:	74 24                	je     c010335f <basic_check+0x487>
c010333b:	c7 44 24 0c 18 69 10 	movl   $0xc0106918,0xc(%esp)
c0103342:	c0 
c0103343:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010334a:	c0 
c010334b:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0103352:	00 
c0103353:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010335a:	e8 82 d9 ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c010335f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103366:	e8 17 0a 00 00       	call   c0103d82 <alloc_pages>
c010336b:	85 c0                	test   %eax,%eax
c010336d:	74 24                	je     c0103393 <basic_check+0x4bb>
c010336f:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c0103376:	c0 
c0103377:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010337e:	c0 
c010337f:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103386:	00 
c0103387:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010338e:	e8 4e d9 ff ff       	call   c0100ce1 <__panic>

    assert(nr_free == 0);
c0103393:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103398:	85 c0                	test   %eax,%eax
c010339a:	74 24                	je     c01033c0 <basic_check+0x4e8>
c010339c:	c7 44 24 0c 31 69 10 	movl   $0xc0106931,0xc(%esp)
c01033a3:	c0 
c01033a4:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01033ab:	c0 
c01033ac:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01033b3:	00 
c01033b4:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01033bb:	e8 21 d9 ff ff       	call   c0100ce1 <__panic>
    free_list = free_list_store;
c01033c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033c6:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01033cb:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c01033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d4:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c01033d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033e0:	00 
c01033e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033e4:	89 04 24             	mov    %eax,(%esp)
c01033e7:	e8 ce 09 00 00       	call   c0103dba <free_pages>
    free_page(p1);
c01033ec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033f3:	00 
c01033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033f7:	89 04 24             	mov    %eax,(%esp)
c01033fa:	e8 bb 09 00 00       	call   c0103dba <free_pages>
    free_page(p2);
c01033ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103406:	00 
c0103407:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340a:	89 04 24             	mov    %eax,(%esp)
c010340d:	e8 a8 09 00 00       	call   c0103dba <free_pages>
}
c0103412:	c9                   	leave  
c0103413:	c3                   	ret    

c0103414 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103414:	55                   	push   %ebp
c0103415:	89 e5                	mov    %esp,%ebp
c0103417:	53                   	push   %ebx
c0103418:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010341e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010342c:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103433:	eb 6b                	jmp    c01034a0 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103435:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103438:	83 e8 0c             	sub    $0xc,%eax
c010343b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103441:	83 c0 04             	add    $0x4,%eax
c0103444:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010344b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010344e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103451:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103454:	0f a3 10             	bt     %edx,(%eax)
c0103457:	19 c0                	sbb    %eax,%eax
c0103459:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010345c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103460:	0f 95 c0             	setne  %al
c0103463:	0f b6 c0             	movzbl %al,%eax
c0103466:	85 c0                	test   %eax,%eax
c0103468:	75 24                	jne    c010348e <default_check+0x7a>
c010346a:	c7 44 24 0c 3e 69 10 	movl   $0xc010693e,0xc(%esp)
c0103471:	c0 
c0103472:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103479:	c0 
c010347a:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103481:	00 
c0103482:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103489:	e8 53 d8 ff ff       	call   c0100ce1 <__panic>
        count ++, total += p->property;
c010348e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103492:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103495:	8b 50 08             	mov    0x8(%eax),%edx
c0103498:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010349b:	01 d0                	add    %edx,%eax
c010349d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034a3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01034a9:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034af:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01034b6:	0f 85 79 ff ff ff    	jne    c0103435 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01034bc:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01034bf:	e8 28 09 00 00       	call   c0103dec <nr_free_pages>
c01034c4:	39 c3                	cmp    %eax,%ebx
c01034c6:	74 24                	je     c01034ec <default_check+0xd8>
c01034c8:	c7 44 24 0c 4e 69 10 	movl   $0xc010694e,0xc(%esp)
c01034cf:	c0 
c01034d0:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01034d7:	c0 
c01034d8:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01034df:	00 
c01034e0:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01034e7:	e8 f5 d7 ff ff       	call   c0100ce1 <__panic>

    basic_check();
c01034ec:	e8 e7 f9 ff ff       	call   c0102ed8 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01034f1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034f8:	e8 85 08 00 00       	call   c0103d82 <alloc_pages>
c01034fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103500:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103504:	75 24                	jne    c010352a <default_check+0x116>
c0103506:	c7 44 24 0c 67 69 10 	movl   $0xc0106967,0xc(%esp)
c010350d:	c0 
c010350e:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103515:	c0 
c0103516:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010351d:	00 
c010351e:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103525:	e8 b7 d7 ff ff       	call   c0100ce1 <__panic>
    assert(!PageProperty(p0));
c010352a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010352d:	83 c0 04             	add    $0x4,%eax
c0103530:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103537:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010353a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010353d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103540:	0f a3 10             	bt     %edx,(%eax)
c0103543:	19 c0                	sbb    %eax,%eax
c0103545:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103548:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010354c:	0f 95 c0             	setne  %al
c010354f:	0f b6 c0             	movzbl %al,%eax
c0103552:	85 c0                	test   %eax,%eax
c0103554:	74 24                	je     c010357a <default_check+0x166>
c0103556:	c7 44 24 0c 72 69 10 	movl   $0xc0106972,0xc(%esp)
c010355d:	c0 
c010355e:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103565:	c0 
c0103566:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c010356d:	00 
c010356e:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103575:	e8 67 d7 ff ff       	call   c0100ce1 <__panic>

    list_entry_t free_list_store = free_list;
c010357a:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010357f:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103585:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103588:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010358b:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103592:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103595:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103598:	89 50 04             	mov    %edx,0x4(%eax)
c010359b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010359e:	8b 50 04             	mov    0x4(%eax),%edx
c01035a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035a4:	89 10                	mov    %edx,(%eax)
c01035a6:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01035ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035b0:	8b 40 04             	mov    0x4(%eax),%eax
c01035b3:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01035b6:	0f 94 c0             	sete   %al
c01035b9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01035bc:	85 c0                	test   %eax,%eax
c01035be:	75 24                	jne    c01035e4 <default_check+0x1d0>
c01035c0:	c7 44 24 0c c7 68 10 	movl   $0xc01068c7,0xc(%esp)
c01035c7:	c0 
c01035c8:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01035cf:	c0 
c01035d0:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01035d7:	00 
c01035d8:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01035df:	e8 fd d6 ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c01035e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035eb:	e8 92 07 00 00       	call   c0103d82 <alloc_pages>
c01035f0:	85 c0                	test   %eax,%eax
c01035f2:	74 24                	je     c0103618 <default_check+0x204>
c01035f4:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c01035fb:	c0 
c01035fc:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103603:	c0 
c0103604:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010360b:	00 
c010360c:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103613:	e8 c9 d6 ff ff       	call   c0100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103618:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010361d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103620:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103627:	00 00 00 

    free_pages(p0 + 2, 3);
c010362a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010362d:	83 c0 28             	add    $0x28,%eax
c0103630:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103637:	00 
c0103638:	89 04 24             	mov    %eax,(%esp)
c010363b:	e8 7a 07 00 00       	call   c0103dba <free_pages>
    assert(alloc_pages(4) == NULL);
c0103640:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103647:	e8 36 07 00 00       	call   c0103d82 <alloc_pages>
c010364c:	85 c0                	test   %eax,%eax
c010364e:	74 24                	je     c0103674 <default_check+0x260>
c0103650:	c7 44 24 0c 84 69 10 	movl   $0xc0106984,0xc(%esp)
c0103657:	c0 
c0103658:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010365f:	c0 
c0103660:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103667:	00 
c0103668:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010366f:	e8 6d d6 ff ff       	call   c0100ce1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103677:	83 c0 28             	add    $0x28,%eax
c010367a:	83 c0 04             	add    $0x4,%eax
c010367d:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103684:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103687:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010368a:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010368d:	0f a3 10             	bt     %edx,(%eax)
c0103690:	19 c0                	sbb    %eax,%eax
c0103692:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103695:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103699:	0f 95 c0             	setne  %al
c010369c:	0f b6 c0             	movzbl %al,%eax
c010369f:	85 c0                	test   %eax,%eax
c01036a1:	74 0e                	je     c01036b1 <default_check+0x29d>
c01036a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036a6:	83 c0 28             	add    $0x28,%eax
c01036a9:	8b 40 08             	mov    0x8(%eax),%eax
c01036ac:	83 f8 03             	cmp    $0x3,%eax
c01036af:	74 24                	je     c01036d5 <default_check+0x2c1>
c01036b1:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c01036b8:	c0 
c01036b9:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01036c0:	c0 
c01036c1:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c01036c8:	00 
c01036c9:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01036d0:	e8 0c d6 ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01036d5:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01036dc:	e8 a1 06 00 00       	call   c0103d82 <alloc_pages>
c01036e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01036e8:	75 24                	jne    c010370e <default_check+0x2fa>
c01036ea:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c01036f1:	c0 
c01036f2:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01036f9:	c0 
c01036fa:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103701:	00 
c0103702:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103709:	e8 d3 d5 ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c010370e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103715:	e8 68 06 00 00       	call   c0103d82 <alloc_pages>
c010371a:	85 c0                	test   %eax,%eax
c010371c:	74 24                	je     c0103742 <default_check+0x32e>
c010371e:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c0103725:	c0 
c0103726:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010372d:	c0 
c010372e:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103735:	00 
c0103736:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010373d:	e8 9f d5 ff ff       	call   c0100ce1 <__panic>
    assert(p0 + 2 == p1);
c0103742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103745:	83 c0 28             	add    $0x28,%eax
c0103748:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010374b:	74 24                	je     c0103771 <default_check+0x35d>
c010374d:	c7 44 24 0c e6 69 10 	movl   $0xc01069e6,0xc(%esp)
c0103754:	c0 
c0103755:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010375c:	c0 
c010375d:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103764:	00 
c0103765:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010376c:	e8 70 d5 ff ff       	call   c0100ce1 <__panic>

    p2 = p0 + 1;
c0103771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103774:	83 c0 14             	add    $0x14,%eax
c0103777:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010377a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103781:	00 
c0103782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103785:	89 04 24             	mov    %eax,(%esp)
c0103788:	e8 2d 06 00 00       	call   c0103dba <free_pages>
    free_pages(p1, 3);
c010378d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103794:	00 
c0103795:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103798:	89 04 24             	mov    %eax,(%esp)
c010379b:	e8 1a 06 00 00       	call   c0103dba <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037a3:	83 c0 04             	add    $0x4,%eax
c01037a6:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01037ad:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037b0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037b3:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037b6:	0f a3 10             	bt     %edx,(%eax)
c01037b9:	19 c0                	sbb    %eax,%eax
c01037bb:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01037be:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01037c2:	0f 95 c0             	setne  %al
c01037c5:	0f b6 c0             	movzbl %al,%eax
c01037c8:	85 c0                	test   %eax,%eax
c01037ca:	74 0b                	je     c01037d7 <default_check+0x3c3>
c01037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037cf:	8b 40 08             	mov    0x8(%eax),%eax
c01037d2:	83 f8 01             	cmp    $0x1,%eax
c01037d5:	74 24                	je     c01037fb <default_check+0x3e7>
c01037d7:	c7 44 24 0c f4 69 10 	movl   $0xc01069f4,0xc(%esp)
c01037de:	c0 
c01037df:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01037e6:	c0 
c01037e7:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c01037ee:	00 
c01037ef:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01037f6:	e8 e6 d4 ff ff       	call   c0100ce1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037fe:	83 c0 04             	add    $0x4,%eax
c0103801:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103808:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010380b:	8b 45 90             	mov    -0x70(%ebp),%eax
c010380e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103811:	0f a3 10             	bt     %edx,(%eax)
c0103814:	19 c0                	sbb    %eax,%eax
c0103816:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103819:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010381d:	0f 95 c0             	setne  %al
c0103820:	0f b6 c0             	movzbl %al,%eax
c0103823:	85 c0                	test   %eax,%eax
c0103825:	74 0b                	je     c0103832 <default_check+0x41e>
c0103827:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010382a:	8b 40 08             	mov    0x8(%eax),%eax
c010382d:	83 f8 03             	cmp    $0x3,%eax
c0103830:	74 24                	je     c0103856 <default_check+0x442>
c0103832:	c7 44 24 0c 1c 6a 10 	movl   $0xc0106a1c,0xc(%esp)
c0103839:	c0 
c010383a:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103841:	c0 
c0103842:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103849:	00 
c010384a:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103851:	e8 8b d4 ff ff       	call   c0100ce1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103856:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010385d:	e8 20 05 00 00       	call   c0103d82 <alloc_pages>
c0103862:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103865:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103868:	83 e8 14             	sub    $0x14,%eax
c010386b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010386e:	74 24                	je     c0103894 <default_check+0x480>
c0103870:	c7 44 24 0c 42 6a 10 	movl   $0xc0106a42,0xc(%esp)
c0103877:	c0 
c0103878:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010387f:	c0 
c0103880:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103887:	00 
c0103888:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010388f:	e8 4d d4 ff ff       	call   c0100ce1 <__panic>
    free_page(p0);
c0103894:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010389b:	00 
c010389c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010389f:	89 04 24             	mov    %eax,(%esp)
c01038a2:	e8 13 05 00 00       	call   c0103dba <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01038a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01038ae:	e8 cf 04 00 00       	call   c0103d82 <alloc_pages>
c01038b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038b9:	83 c0 14             	add    $0x14,%eax
c01038bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01038bf:	74 24                	je     c01038e5 <default_check+0x4d1>
c01038c1:	c7 44 24 0c 60 6a 10 	movl   $0xc0106a60,0xc(%esp)
c01038c8:	c0 
c01038c9:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c01038d0:	c0 
c01038d1:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01038d8:	00 
c01038d9:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01038e0:	e8 fc d3 ff ff       	call   c0100ce1 <__panic>

    free_pages(p0, 2);
c01038e5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038ec:	00 
c01038ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038f0:	89 04 24             	mov    %eax,(%esp)
c01038f3:	e8 c2 04 00 00       	call   c0103dba <free_pages>
    free_page(p2);
c01038f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038ff:	00 
c0103900:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103903:	89 04 24             	mov    %eax,(%esp)
c0103906:	e8 af 04 00 00       	call   c0103dba <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010390b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103912:	e8 6b 04 00 00       	call   c0103d82 <alloc_pages>
c0103917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010391a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010391e:	75 24                	jne    c0103944 <default_check+0x530>
c0103920:	c7 44 24 0c 80 6a 10 	movl   $0xc0106a80,0xc(%esp)
c0103927:	c0 
c0103928:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c010392f:	c0 
c0103930:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103937:	00 
c0103938:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c010393f:	e8 9d d3 ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0103944:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010394b:	e8 32 04 00 00       	call   c0103d82 <alloc_pages>
c0103950:	85 c0                	test   %eax,%eax
c0103952:	74 24                	je     c0103978 <default_check+0x564>
c0103954:	c7 44 24 0c de 68 10 	movl   $0xc01068de,0xc(%esp)
c010395b:	c0 
c010395c:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103963:	c0 
c0103964:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c010396b:	00 
c010396c:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103973:	e8 69 d3 ff ff       	call   c0100ce1 <__panic>

    assert(nr_free == 0);
c0103978:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010397d:	85 c0                	test   %eax,%eax
c010397f:	74 24                	je     c01039a5 <default_check+0x591>
c0103981:	c7 44 24 0c 31 69 10 	movl   $0xc0106931,0xc(%esp)
c0103988:	c0 
c0103989:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103990:	c0 
c0103991:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103998:	00 
c0103999:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c01039a0:	e8 3c d3 ff ff       	call   c0100ce1 <__panic>
    nr_free = nr_free_store;
c01039a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039a8:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01039ad:	8b 45 80             	mov    -0x80(%ebp),%eax
c01039b0:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01039b3:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01039b8:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c01039be:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01039c5:	00 
c01039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039c9:	89 04 24             	mov    %eax,(%esp)
c01039cc:	e8 e9 03 00 00       	call   c0103dba <free_pages>

    le = &free_list;
c01039d1:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01039d8:	eb 1d                	jmp    c01039f7 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01039da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039dd:	83 e8 0c             	sub    $0xc,%eax
c01039e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01039e3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01039e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01039ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039ed:	8b 40 08             	mov    0x8(%eax),%eax
c01039f0:	29 c2                	sub    %eax,%edx
c01039f2:	89 d0                	mov    %edx,%eax
c01039f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039fa:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039fd:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103a00:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103a03:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a06:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103a0d:	75 cb                	jne    c01039da <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a13:	74 24                	je     c0103a39 <default_check+0x625>
c0103a15:	c7 44 24 0c 9e 6a 10 	movl   $0xc0106a9e,0xc(%esp)
c0103a1c:	c0 
c0103a1d:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103a24:	c0 
c0103a25:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103a2c:	00 
c0103a2d:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103a34:	e8 a8 d2 ff ff       	call   c0100ce1 <__panic>
    assert(total == 0);
c0103a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a3d:	74 24                	je     c0103a63 <default_check+0x64f>
c0103a3f:	c7 44 24 0c a9 6a 10 	movl   $0xc0106aa9,0xc(%esp)
c0103a46:	c0 
c0103a47:	c7 44 24 08 56 67 10 	movl   $0xc0106756,0x8(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103a56:	00 
c0103a57:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103a5e:	e8 7e d2 ff ff       	call   c0100ce1 <__panic>
}
c0103a63:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a69:	5b                   	pop    %ebx
c0103a6a:	5d                   	pop    %ebp
c0103a6b:	c3                   	ret    

c0103a6c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a6c:	55                   	push   %ebp
c0103a6d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a6f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a72:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a77:	29 c2                	sub    %eax,%edx
c0103a79:	89 d0                	mov    %edx,%eax
c0103a7b:	c1 f8 02             	sar    $0x2,%eax
c0103a7e:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a84:	5d                   	pop    %ebp
c0103a85:	c3                   	ret    

c0103a86 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a86:	55                   	push   %ebp
c0103a87:	89 e5                	mov    %esp,%ebp
c0103a89:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8f:	89 04 24             	mov    %eax,(%esp)
c0103a92:	e8 d5 ff ff ff       	call   c0103a6c <page2ppn>
c0103a97:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a9a:	c9                   	leave  
c0103a9b:	c3                   	ret    

c0103a9c <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a9c:	55                   	push   %ebp
c0103a9d:	89 e5                	mov    %esp,%ebp
c0103a9f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa5:	c1 e8 0c             	shr    $0xc,%eax
c0103aa8:	89 c2                	mov    %eax,%edx
c0103aaa:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103aaf:	39 c2                	cmp    %eax,%edx
c0103ab1:	72 1c                	jb     c0103acf <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103ab3:	c7 44 24 08 e4 6a 10 	movl   $0xc0106ae4,0x8(%esp)
c0103aba:	c0 
c0103abb:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103ac2:	00 
c0103ac3:	c7 04 24 03 6b 10 c0 	movl   $0xc0106b03,(%esp)
c0103aca:	e8 12 d2 ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c0103acf:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad8:	c1 e8 0c             	shr    $0xc,%eax
c0103adb:	89 c2                	mov    %eax,%edx
c0103add:	89 d0                	mov    %edx,%eax
c0103adf:	c1 e0 02             	shl    $0x2,%eax
c0103ae2:	01 d0                	add    %edx,%eax
c0103ae4:	c1 e0 02             	shl    $0x2,%eax
c0103ae7:	01 c8                	add    %ecx,%eax
}
c0103ae9:	c9                   	leave  
c0103aea:	c3                   	ret    

c0103aeb <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103aeb:	55                   	push   %ebp
c0103aec:	89 e5                	mov    %esp,%ebp
c0103aee:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af4:	89 04 24             	mov    %eax,(%esp)
c0103af7:	e8 8a ff ff ff       	call   c0103a86 <page2pa>
c0103afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b02:	c1 e8 0c             	shr    $0xc,%eax
c0103b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b08:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103b0d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b10:	72 23                	jb     c0103b35 <page2kva+0x4a>
c0103b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b15:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b19:	c7 44 24 08 14 6b 10 	movl   $0xc0106b14,0x8(%esp)
c0103b20:	c0 
c0103b21:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b28:	00 
c0103b29:	c7 04 24 03 6b 10 c0 	movl   $0xc0106b03,(%esp)
c0103b30:	e8 ac d1 ff ff       	call   c0100ce1 <__panic>
c0103b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b38:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b3d:	c9                   	leave  
c0103b3e:	c3                   	ret    

c0103b3f <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b3f:	55                   	push   %ebp
c0103b40:	89 e5                	mov    %esp,%ebp
c0103b42:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b48:	83 e0 01             	and    $0x1,%eax
c0103b4b:	85 c0                	test   %eax,%eax
c0103b4d:	75 1c                	jne    c0103b6b <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b4f:	c7 44 24 08 38 6b 10 	movl   $0xc0106b38,0x8(%esp)
c0103b56:	c0 
c0103b57:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b5e:	00 
c0103b5f:	c7 04 24 03 6b 10 c0 	movl   $0xc0106b03,(%esp)
c0103b66:	e8 76 d1 ff ff       	call   c0100ce1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b73:	89 04 24             	mov    %eax,(%esp)
c0103b76:	e8 21 ff ff ff       	call   c0103a9c <pa2page>
}
c0103b7b:	c9                   	leave  
c0103b7c:	c3                   	ret    

c0103b7d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103b7d:	55                   	push   %ebp
c0103b7e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b83:	8b 00                	mov    (%eax),%eax
}
c0103b85:	5d                   	pop    %ebp
c0103b86:	c3                   	ret    

c0103b87 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b87:	55                   	push   %ebp
c0103b88:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b90:	89 10                	mov    %edx,(%eax)
}
c0103b92:	5d                   	pop    %ebp
c0103b93:	c3                   	ret    

c0103b94 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b94:	55                   	push   %ebp
c0103b95:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9a:	8b 00                	mov    (%eax),%eax
c0103b9c:	8d 50 01             	lea    0x1(%eax),%edx
c0103b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba2:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba7:	8b 00                	mov    (%eax),%eax
}
c0103ba9:	5d                   	pop    %ebp
c0103baa:	c3                   	ret    

c0103bab <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103bab:	55                   	push   %ebp
c0103bac:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb1:	8b 00                	mov    (%eax),%eax
c0103bb3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bbe:	8b 00                	mov    (%eax),%eax
}
c0103bc0:	5d                   	pop    %ebp
c0103bc1:	c3                   	ret    

c0103bc2 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103bc2:	55                   	push   %ebp
c0103bc3:	89 e5                	mov    %esp,%ebp
c0103bc5:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103bc8:	9c                   	pushf  
c0103bc9:	58                   	pop    %eax
c0103bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103bd0:	25 00 02 00 00       	and    $0x200,%eax
c0103bd5:	85 c0                	test   %eax,%eax
c0103bd7:	74 0c                	je     c0103be5 <__intr_save+0x23>
        intr_disable();
c0103bd9:	e8 e6 da ff ff       	call   c01016c4 <intr_disable>
        return 1;
c0103bde:	b8 01 00 00 00       	mov    $0x1,%eax
c0103be3:	eb 05                	jmp    c0103bea <__intr_save+0x28>
    }
    return 0;
c0103be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bea:	c9                   	leave  
c0103beb:	c3                   	ret    

c0103bec <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103bec:	55                   	push   %ebp
c0103bed:	89 e5                	mov    %esp,%ebp
c0103bef:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103bf6:	74 05                	je     c0103bfd <__intr_restore+0x11>
        intr_enable();
c0103bf8:	e8 c1 da ff ff       	call   c01016be <intr_enable>
    }
}
c0103bfd:	c9                   	leave  
c0103bfe:	c3                   	ret    

c0103bff <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103bff:	55                   	push   %ebp
c0103c00:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c05:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c08:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c0d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c0f:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c14:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103c16:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c1b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103c1d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c22:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c24:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c29:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103c2b:	ea 32 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103c32
}
c0103c32:	5d                   	pop    %ebp
c0103c33:	c3                   	ret    

c0103c34 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c34:	55                   	push   %ebp
c0103c35:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c3a:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103c3f:	5d                   	pop    %ebp
c0103c40:	c3                   	ret    

c0103c41 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c41:	55                   	push   %ebp
c0103c42:	89 e5                	mov    %esp,%ebp
c0103c44:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c47:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c4c:	89 04 24             	mov    %eax,(%esp)
c0103c4f:	e8 e0 ff ff ff       	call   c0103c34 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c54:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103c5b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c5d:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c64:	68 00 
c0103c66:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c6b:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c71:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c76:	c1 e8 10             	shr    $0x10,%eax
c0103c79:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c7e:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c85:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c88:	83 c8 09             	or     $0x9,%eax
c0103c8b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c90:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c97:	83 e0 ef             	and    $0xffffffef,%eax
c0103c9a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c9f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103ca6:	83 e0 9f             	and    $0xffffff9f,%eax
c0103ca9:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cae:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cb5:	83 c8 80             	or     $0xffffff80,%eax
c0103cb8:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cbd:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cc4:	83 e0 f0             	and    $0xfffffff0,%eax
c0103cc7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ccc:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cd3:	83 e0 ef             	and    $0xffffffef,%eax
c0103cd6:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cdb:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ce2:	83 e0 df             	and    $0xffffffdf,%eax
c0103ce5:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cea:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cf1:	83 c8 40             	or     $0x40,%eax
c0103cf4:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cf9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d00:	83 e0 7f             	and    $0x7f,%eax
c0103d03:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d08:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103d0d:	c1 e8 18             	shr    $0x18,%eax
c0103d10:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103d15:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103d1c:	e8 de fe ff ff       	call   c0103bff <lgdt>
c0103d21:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d27:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103d2b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103d2e:	c9                   	leave  
c0103d2f:	c3                   	ret    

c0103d30 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103d30:	55                   	push   %ebp
c0103d31:	89 e5                	mov    %esp,%ebp
c0103d33:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d36:	c7 05 5c 89 11 c0 c8 	movl   $0xc0106ac8,0xc011895c
c0103d3d:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d40:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d45:	8b 00                	mov    (%eax),%eax
c0103d47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d4b:	c7 04 24 64 6b 10 c0 	movl   $0xc0106b64,(%esp)
c0103d52:	e8 e5 c5 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103d57:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d5c:	8b 40 04             	mov    0x4(%eax),%eax
c0103d5f:	ff d0                	call   *%eax
}
c0103d61:	c9                   	leave  
c0103d62:	c3                   	ret    

c0103d63 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d63:	55                   	push   %ebp
c0103d64:	89 e5                	mov    %esp,%ebp
c0103d66:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d69:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d6e:	8b 40 08             	mov    0x8(%eax),%eax
c0103d71:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d74:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d78:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d7b:	89 14 24             	mov    %edx,(%esp)
c0103d7e:	ff d0                	call   *%eax
}
c0103d80:	c9                   	leave  
c0103d81:	c3                   	ret    

c0103d82 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d82:	55                   	push   %ebp
c0103d83:	89 e5                	mov    %esp,%ebp
c0103d85:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d8f:	e8 2e fe ff ff       	call   c0103bc2 <__intr_save>
c0103d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d97:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d9c:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d9f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103da2:	89 14 24             	mov    %edx,(%esp)
c0103da5:	ff d0                	call   *%eax
c0103da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dad:	89 04 24             	mov    %eax,(%esp)
c0103db0:	e8 37 fe ff ff       	call   c0103bec <__intr_restore>
    return page;
c0103db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103db8:	c9                   	leave  
c0103db9:	c3                   	ret    

c0103dba <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103dba:	55                   	push   %ebp
c0103dbb:	89 e5                	mov    %esp,%ebp
c0103dbd:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103dc0:	e8 fd fd ff ff       	call   c0103bc2 <__intr_save>
c0103dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103dc8:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103dcd:	8b 40 10             	mov    0x10(%eax),%eax
c0103dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dd3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103dd7:	8b 55 08             	mov    0x8(%ebp),%edx
c0103dda:	89 14 24             	mov    %edx,(%esp)
c0103ddd:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de2:	89 04 24             	mov    %eax,(%esp)
c0103de5:	e8 02 fe ff ff       	call   c0103bec <__intr_restore>
}
c0103dea:	c9                   	leave  
c0103deb:	c3                   	ret    

c0103dec <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103dec:	55                   	push   %ebp
c0103ded:	89 e5                	mov    %esp,%ebp
c0103def:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103df2:	e8 cb fd ff ff       	call   c0103bc2 <__intr_save>
c0103df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103dfa:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103dff:	8b 40 14             	mov    0x14(%eax),%eax
c0103e02:	ff d0                	call   *%eax
c0103e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e0a:	89 04 24             	mov    %eax,(%esp)
c0103e0d:	e8 da fd ff ff       	call   c0103bec <__intr_restore>
    return ret;
c0103e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103e15:	c9                   	leave  
c0103e16:	c3                   	ret    

c0103e17 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103e17:	55                   	push   %ebp
c0103e18:	89 e5                	mov    %esp,%ebp
c0103e1a:	57                   	push   %edi
c0103e1b:	56                   	push   %esi
c0103e1c:	53                   	push   %ebx
c0103e1d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103e23:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103e2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e38:	c7 04 24 7b 6b 10 c0 	movl   $0xc0106b7b,(%esp)
c0103e3f:	e8 f8 c4 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e4b:	e9 15 01 00 00       	jmp    c0103f65 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e50:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e53:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e56:	89 d0                	mov    %edx,%eax
c0103e58:	c1 e0 02             	shl    $0x2,%eax
c0103e5b:	01 d0                	add    %edx,%eax
c0103e5d:	c1 e0 02             	shl    $0x2,%eax
c0103e60:	01 c8                	add    %ecx,%eax
c0103e62:	8b 50 08             	mov    0x8(%eax),%edx
c0103e65:	8b 40 04             	mov    0x4(%eax),%eax
c0103e68:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e6b:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e6e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e71:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e74:	89 d0                	mov    %edx,%eax
c0103e76:	c1 e0 02             	shl    $0x2,%eax
c0103e79:	01 d0                	add    %edx,%eax
c0103e7b:	c1 e0 02             	shl    $0x2,%eax
c0103e7e:	01 c8                	add    %ecx,%eax
c0103e80:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e83:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e86:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e89:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e8c:	01 c8                	add    %ecx,%eax
c0103e8e:	11 da                	adc    %ebx,%edx
c0103e90:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e93:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e96:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e9c:	89 d0                	mov    %edx,%eax
c0103e9e:	c1 e0 02             	shl    $0x2,%eax
c0103ea1:	01 d0                	add    %edx,%eax
c0103ea3:	c1 e0 02             	shl    $0x2,%eax
c0103ea6:	01 c8                	add    %ecx,%eax
c0103ea8:	83 c0 14             	add    $0x14,%eax
c0103eab:	8b 00                	mov    (%eax),%eax
c0103ead:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103eb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103eb6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103eb9:	83 c0 ff             	add    $0xffffffff,%eax
c0103ebc:	83 d2 ff             	adc    $0xffffffff,%edx
c0103ebf:	89 c6                	mov    %eax,%esi
c0103ec1:	89 d7                	mov    %edx,%edi
c0103ec3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ec6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ec9:	89 d0                	mov    %edx,%eax
c0103ecb:	c1 e0 02             	shl    $0x2,%eax
c0103ece:	01 d0                	add    %edx,%eax
c0103ed0:	c1 e0 02             	shl    $0x2,%eax
c0103ed3:	01 c8                	add    %ecx,%eax
c0103ed5:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ed8:	8b 58 10             	mov    0x10(%eax),%ebx
c0103edb:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ee1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103ee5:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103ee9:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103eed:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ef0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ef3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ef7:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103efb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103eff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f03:	c7 04 24 88 6b 10 c0 	movl   $0xc0106b88,(%esp)
c0103f0a:	e8 2d c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103f0f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f12:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f15:	89 d0                	mov    %edx,%eax
c0103f17:	c1 e0 02             	shl    $0x2,%eax
c0103f1a:	01 d0                	add    %edx,%eax
c0103f1c:	c1 e0 02             	shl    $0x2,%eax
c0103f1f:	01 c8                	add    %ecx,%eax
c0103f21:	83 c0 14             	add    $0x14,%eax
c0103f24:	8b 00                	mov    (%eax),%eax
c0103f26:	83 f8 01             	cmp    $0x1,%eax
c0103f29:	75 36                	jne    c0103f61 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f31:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f34:	77 2b                	ja     c0103f61 <page_init+0x14a>
c0103f36:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f39:	72 05                	jb     c0103f40 <page_init+0x129>
c0103f3b:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f3e:	73 21                	jae    c0103f61 <page_init+0x14a>
c0103f40:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f44:	77 1b                	ja     c0103f61 <page_init+0x14a>
c0103f46:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f4a:	72 09                	jb     c0103f55 <page_init+0x13e>
c0103f4c:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f53:	77 0c                	ja     c0103f61 <page_init+0x14a>
                maxpa = end;
c0103f55:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f58:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f61:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f65:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f68:	8b 00                	mov    (%eax),%eax
c0103f6a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f6d:	0f 8f dd fe ff ff    	jg     c0103e50 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f77:	72 1d                	jb     c0103f96 <page_init+0x17f>
c0103f79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f7d:	77 09                	ja     c0103f88 <page_init+0x171>
c0103f7f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f86:	76 0e                	jbe    c0103f96 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f88:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f9c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103fa0:	c1 ea 0c             	shr    $0xc,%edx
c0103fa3:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103fa8:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103faf:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103fb4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103fb7:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103fba:	01 d0                	add    %edx,%eax
c0103fbc:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103fbf:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fc2:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fc7:	f7 75 ac             	divl   -0x54(%ebp)
c0103fca:	89 d0                	mov    %edx,%eax
c0103fcc:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103fcf:	29 c2                	sub    %eax,%edx
c0103fd1:	89 d0                	mov    %edx,%eax
c0103fd3:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103fd8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fdf:	eb 2f                	jmp    c0104010 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103fe1:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103fe7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fea:	89 d0                	mov    %edx,%eax
c0103fec:	c1 e0 02             	shl    $0x2,%eax
c0103fef:	01 d0                	add    %edx,%eax
c0103ff1:	c1 e0 02             	shl    $0x2,%eax
c0103ff4:	01 c8                	add    %ecx,%eax
c0103ff6:	83 c0 04             	add    $0x4,%eax
c0103ff9:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104000:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104003:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104006:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104009:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010400c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104010:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104013:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104018:	39 c2                	cmp    %eax,%edx
c010401a:	72 c5                	jb     c0103fe1 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010401c:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104022:	89 d0                	mov    %edx,%eax
c0104024:	c1 e0 02             	shl    $0x2,%eax
c0104027:	01 d0                	add    %edx,%eax
c0104029:	c1 e0 02             	shl    $0x2,%eax
c010402c:	89 c2                	mov    %eax,%edx
c010402e:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104033:	01 d0                	add    %edx,%eax
c0104035:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104038:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010403f:	77 23                	ja     c0104064 <page_init+0x24d>
c0104041:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104044:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104048:	c7 44 24 08 b8 6b 10 	movl   $0xc0106bb8,0x8(%esp)
c010404f:	c0 
c0104050:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104057:	00 
c0104058:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c010405f:	e8 7d cc ff ff       	call   c0100ce1 <__panic>
c0104064:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104067:	05 00 00 00 40       	add    $0x40000000,%eax
c010406c:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010406f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104076:	e9 74 01 00 00       	jmp    c01041ef <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010407b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010407e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104081:	89 d0                	mov    %edx,%eax
c0104083:	c1 e0 02             	shl    $0x2,%eax
c0104086:	01 d0                	add    %edx,%eax
c0104088:	c1 e0 02             	shl    $0x2,%eax
c010408b:	01 c8                	add    %ecx,%eax
c010408d:	8b 50 08             	mov    0x8(%eax),%edx
c0104090:	8b 40 04             	mov    0x4(%eax),%eax
c0104093:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104096:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104099:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010409c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010409f:	89 d0                	mov    %edx,%eax
c01040a1:	c1 e0 02             	shl    $0x2,%eax
c01040a4:	01 d0                	add    %edx,%eax
c01040a6:	c1 e0 02             	shl    $0x2,%eax
c01040a9:	01 c8                	add    %ecx,%eax
c01040ab:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040ae:	8b 58 10             	mov    0x10(%eax),%ebx
c01040b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040b7:	01 c8                	add    %ecx,%eax
c01040b9:	11 da                	adc    %ebx,%edx
c01040bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040be:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01040c1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040c7:	89 d0                	mov    %edx,%eax
c01040c9:	c1 e0 02             	shl    $0x2,%eax
c01040cc:	01 d0                	add    %edx,%eax
c01040ce:	c1 e0 02             	shl    $0x2,%eax
c01040d1:	01 c8                	add    %ecx,%eax
c01040d3:	83 c0 14             	add    $0x14,%eax
c01040d6:	8b 00                	mov    (%eax),%eax
c01040d8:	83 f8 01             	cmp    $0x1,%eax
c01040db:	0f 85 0a 01 00 00    	jne    c01041eb <page_init+0x3d4>
            if (begin < freemem) {
c01040e1:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040e4:	ba 00 00 00 00       	mov    $0x0,%edx
c01040e9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040ec:	72 17                	jb     c0104105 <page_init+0x2ee>
c01040ee:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040f1:	77 05                	ja     c01040f8 <page_init+0x2e1>
c01040f3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01040f6:	76 0d                	jbe    c0104105 <page_init+0x2ee>
                begin = freemem;
c01040f8:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104105:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104109:	72 1d                	jb     c0104128 <page_init+0x311>
c010410b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010410f:	77 09                	ja     c010411a <page_init+0x303>
c0104111:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104118:	76 0e                	jbe    c0104128 <page_init+0x311>
                end = KMEMSIZE;
c010411a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104121:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104128:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010412b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010412e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104131:	0f 87 b4 00 00 00    	ja     c01041eb <page_init+0x3d4>
c0104137:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010413a:	72 09                	jb     c0104145 <page_init+0x32e>
c010413c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010413f:	0f 83 a6 00 00 00    	jae    c01041eb <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104145:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010414c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010414f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104152:	01 d0                	add    %edx,%eax
c0104154:	83 e8 01             	sub    $0x1,%eax
c0104157:	89 45 98             	mov    %eax,-0x68(%ebp)
c010415a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010415d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104162:	f7 75 9c             	divl   -0x64(%ebp)
c0104165:	89 d0                	mov    %edx,%eax
c0104167:	8b 55 98             	mov    -0x68(%ebp),%edx
c010416a:	29 c2                	sub    %eax,%edx
c010416c:	89 d0                	mov    %edx,%eax
c010416e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104173:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104176:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104179:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010417c:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010417f:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104182:	ba 00 00 00 00       	mov    $0x0,%edx
c0104187:	89 c7                	mov    %eax,%edi
c0104189:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010418f:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104192:	89 d0                	mov    %edx,%eax
c0104194:	83 e0 00             	and    $0x0,%eax
c0104197:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010419a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010419d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01041a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01041a3:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01041a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041ac:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041af:	77 3a                	ja     c01041eb <page_init+0x3d4>
c01041b1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041b4:	72 05                	jb     c01041bb <page_init+0x3a4>
c01041b6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01041b9:	73 30                	jae    c01041eb <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01041bb:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01041be:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01041c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01041c7:	29 c8                	sub    %ecx,%eax
c01041c9:	19 da                	sbb    %ebx,%edx
c01041cb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01041cf:	c1 ea 0c             	shr    $0xc,%edx
c01041d2:	89 c3                	mov    %eax,%ebx
c01041d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041d7:	89 04 24             	mov    %eax,(%esp)
c01041da:	e8 bd f8 ff ff       	call   c0103a9c <pa2page>
c01041df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041e3:	89 04 24             	mov    %eax,(%esp)
c01041e6:	e8 78 fb ff ff       	call   c0103d63 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01041eb:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041f2:	8b 00                	mov    (%eax),%eax
c01041f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041f7:	0f 8f 7e fe ff ff    	jg     c010407b <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01041fd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104203:	5b                   	pop    %ebx
c0104204:	5e                   	pop    %esi
c0104205:	5f                   	pop    %edi
c0104206:	5d                   	pop    %ebp
c0104207:	c3                   	ret    

c0104208 <enable_paging>:

static void
enable_paging(void) {
c0104208:	55                   	push   %ebp
c0104209:	89 e5                	mov    %esp,%ebp
c010420b:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010420e:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c0104213:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104216:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104219:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010421c:	0f 20 c0             	mov    %cr0,%eax
c010421f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104222:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104225:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104228:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010422f:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104233:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104236:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104239:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010423c:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010423f:	c9                   	leave  
c0104240:	c3                   	ret    

c0104241 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104241:	55                   	push   %ebp
c0104242:	89 e5                	mov    %esp,%ebp
c0104244:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104247:	8b 45 14             	mov    0x14(%ebp),%eax
c010424a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010424d:	31 d0                	xor    %edx,%eax
c010424f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104254:	85 c0                	test   %eax,%eax
c0104256:	74 24                	je     c010427c <boot_map_segment+0x3b>
c0104258:	c7 44 24 0c ea 6b 10 	movl   $0xc0106bea,0xc(%esp)
c010425f:	c0 
c0104260:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104267:	c0 
c0104268:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010426f:	00 
c0104270:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104277:	e8 65 ca ff ff       	call   c0100ce1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010427c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104286:	25 ff 0f 00 00       	and    $0xfff,%eax
c010428b:	89 c2                	mov    %eax,%edx
c010428d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104290:	01 c2                	add    %eax,%edx
c0104292:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104295:	01 d0                	add    %edx,%eax
c0104297:	83 e8 01             	sub    $0x1,%eax
c010429a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010429d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01042a5:	f7 75 f0             	divl   -0x10(%ebp)
c01042a8:	89 d0                	mov    %edx,%eax
c01042aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042ad:	29 c2                	sub    %eax,%edx
c01042af:	89 d0                	mov    %edx,%eax
c01042b1:	c1 e8 0c             	shr    $0xc,%eax
c01042b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01042b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01042bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042c5:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01042c8:	8b 45 14             	mov    0x14(%ebp),%eax
c01042cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042d6:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042d9:	eb 6b                	jmp    c0104346 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042e2:	00 
c01042e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ed:	89 04 24             	mov    %eax,(%esp)
c01042f0:	e8 cc 01 00 00       	call   c01044c1 <get_pte>
c01042f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01042f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042fc:	75 24                	jne    c0104322 <boot_map_segment+0xe1>
c01042fe:	c7 44 24 0c 16 6c 10 	movl   $0xc0106c16,0xc(%esp)
c0104305:	c0 
c0104306:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c010430d:	c0 
c010430e:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104315:	00 
c0104316:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c010431d:	e8 bf c9 ff ff       	call   c0100ce1 <__panic>
        *ptep = pa | PTE_P | perm;
c0104322:	8b 45 18             	mov    0x18(%ebp),%eax
c0104325:	8b 55 14             	mov    0x14(%ebp),%edx
c0104328:	09 d0                	or     %edx,%eax
c010432a:	83 c8 01             	or     $0x1,%eax
c010432d:	89 c2                	mov    %eax,%edx
c010432f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104332:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104334:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104338:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010433f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010434a:	75 8f                	jne    c01042db <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010434c:	c9                   	leave  
c010434d:	c3                   	ret    

c010434e <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010434e:	55                   	push   %ebp
c010434f:	89 e5                	mov    %esp,%ebp
c0104351:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104354:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010435b:	e8 22 fa ff ff       	call   c0103d82 <alloc_pages>
c0104360:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104367:	75 1c                	jne    c0104385 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104369:	c7 44 24 08 23 6c 10 	movl   $0xc0106c23,0x8(%esp)
c0104370:	c0 
c0104371:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104378:	00 
c0104379:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104380:	e8 5c c9 ff ff       	call   c0100ce1 <__panic>
    }
    return page2kva(p);
c0104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104388:	89 04 24             	mov    %eax,(%esp)
c010438b:	e8 5b f7 ff ff       	call   c0103aeb <page2kva>
}
c0104390:	c9                   	leave  
c0104391:	c3                   	ret    

c0104392 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104392:	55                   	push   %ebp
c0104393:	89 e5                	mov    %esp,%ebp
c0104395:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104398:	e8 93 f9 ff ff       	call   c0103d30 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010439d:	e8 75 fa ff ff       	call   c0103e17 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01043a2:	e8 7b 04 00 00       	call   c0104822 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01043a7:	e8 a2 ff ff ff       	call   c010434e <boot_alloc_page>
c01043ac:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01043b1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043b6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01043bd:	00 
c01043be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01043c5:	00 
c01043c6:	89 04 24             	mov    %eax,(%esp)
c01043c9:	e8 bd 1a 00 00       	call   c0105e8b <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01043ce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043d6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043dd:	77 23                	ja     c0104402 <pmm_init+0x70>
c01043df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043e6:	c7 44 24 08 b8 6b 10 	movl   $0xc0106bb8,0x8(%esp)
c01043ed:	c0 
c01043ee:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01043f5:	00 
c01043f6:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01043fd:	e8 df c8 ff ff       	call   c0100ce1 <__panic>
c0104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104405:	05 00 00 00 40       	add    $0x40000000,%eax
c010440a:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c010440f:	e8 2c 04 00 00       	call   c0104840 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104414:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104419:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010441f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104424:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104427:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010442e:	77 23                	ja     c0104453 <pmm_init+0xc1>
c0104430:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104433:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104437:	c7 44 24 08 b8 6b 10 	movl   $0xc0106bb8,0x8(%esp)
c010443e:	c0 
c010443f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104446:	00 
c0104447:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c010444e:	e8 8e c8 ff ff       	call   c0100ce1 <__panic>
c0104453:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104456:	05 00 00 00 40       	add    $0x40000000,%eax
c010445b:	83 c8 03             	or     $0x3,%eax
c010445e:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104460:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104465:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010446c:	00 
c010446d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104474:	00 
c0104475:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010447c:	38 
c010447d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104484:	c0 
c0104485:	89 04 24             	mov    %eax,(%esp)
c0104488:	e8 b4 fd ff ff       	call   c0104241 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010448d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104492:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104498:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010449e:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01044a0:	e8 63 fd ff ff       	call   c0104208 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01044a5:	e8 97 f7 ff ff       	call   c0103c41 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01044aa:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01044af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01044b5:	e8 21 0a 00 00       	call   c0104edb <check_boot_pgdir>

    print_pgdir();
c01044ba:	e8 ae 0e 00 00       	call   c010536d <print_pgdir>

}
c01044bf:	c9                   	leave  
c01044c0:	c3                   	ret    

c01044c1 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01044c1:	55                   	push   %ebp
c01044c2:	89 e5                	mov    %esp,%ebp
c01044c4:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01044c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044ca:	c1 e8 16             	shr    $0x16,%eax
c01044cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01044d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d7:	01 d0                	add    %edx,%eax
c01044d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!(*pdep & PTE_P)){
c01044dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044df:	8b 00                	mov    (%eax),%eax
c01044e1:	83 e0 01             	and    $0x1,%eax
c01044e4:	85 c0                	test   %eax,%eax
c01044e6:	0f 85 b6 00 00 00    	jne    c01045a2 <get_pte+0xe1>
        struct  Page *p = NULL;
c01044ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        if(create)
c01044f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044f7:	74 0f                	je     c0104508 <get_pte+0x47>
            p = alloc_page();
c01044f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104500:	e8 7d f8 ff ff       	call   c0103d82 <alloc_pages>
c0104505:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p == NULL)
c0104508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010450c:	75 0a                	jne    c0104518 <get_pte+0x57>
            return NULL;
c010450e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104513:	e9 ef 00 00 00       	jmp    c0104607 <get_pte+0x146>
        set_page_ref(p, 1);
c0104518:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010451f:	00 
c0104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104523:	89 04 24             	mov    %eax,(%esp)
c0104526:	e8 5c f6 ff ff       	call   c0103b87 <set_page_ref>
        uintptr_t pa = page2pa(p);
c010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452e:	89 04 24             	mov    %eax,(%esp)
c0104531:	e8 50 f5 ff ff       	call   c0103a86 <page2pa>
c0104536:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104539:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010453c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010453f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104542:	c1 e8 0c             	shr    $0xc,%eax
c0104545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104548:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010454d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104550:	72 23                	jb     c0104575 <get_pte+0xb4>
c0104552:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104555:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104559:	c7 44 24 08 14 6b 10 	movl   $0xc0106b14,0x8(%esp)
c0104560:	c0 
c0104561:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
c0104568:	00 
c0104569:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104570:	e8 6c c7 ff ff       	call   c0100ce1 <__panic>
c0104575:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104578:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010457d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104584:	00 
c0104585:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010458c:	00 
c010458d:	89 04 24             	mov    %eax,(%esp)
c0104590:	e8 f6 18 00 00       	call   c0105e8b <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104595:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104598:	83 c8 07             	or     $0x7,%eax
c010459b:	89 c2                	mov    %eax,%edx
c010459d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a0:	89 10                	mov    %edx,(%eax)
    }
    pde_t *a = (pte_t*)KADDR(PDE_ADDR(*pdep));
c01045a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a5:	8b 00                	mov    (%eax),%eax
c01045a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01045af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045b2:	c1 e8 0c             	shr    $0xc,%eax
c01045b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01045b8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01045bd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01045c0:	72 23                	jb     c01045e5 <get_pte+0x124>
c01045c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045c9:	c7 44 24 08 14 6b 10 	movl   $0xc0106b14,0x8(%esp)
c01045d0:	c0 
c01045d1:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c01045d8:	00 
c01045d9:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01045e0:	e8 fc c6 ff ff       	call   c0100ce1 <__panic>
c01045e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045e8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return &a[PTX(la)];
c01045f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045f3:	c1 e8 0c             	shr    $0xc,%eax
c01045f6:	25 ff 03 00 00       	and    $0x3ff,%eax
c01045fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104602:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104605:	01 d0                	add    %edx,%eax
}
c0104607:	c9                   	leave  
c0104608:	c3                   	ret    

c0104609 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104609:	55                   	push   %ebp
c010460a:	89 e5                	mov    %esp,%ebp
c010460c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010460f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104616:	00 
c0104617:	8b 45 0c             	mov    0xc(%ebp),%eax
c010461a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010461e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104621:	89 04 24             	mov    %eax,(%esp)
c0104624:	e8 98 fe ff ff       	call   c01044c1 <get_pte>
c0104629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010462c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104630:	74 08                	je     c010463a <get_page+0x31>
        *ptep_store = ptep;
c0104632:	8b 45 10             	mov    0x10(%ebp),%eax
c0104635:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104638:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010463a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010463e:	74 1b                	je     c010465b <get_page+0x52>
c0104640:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104643:	8b 00                	mov    (%eax),%eax
c0104645:	83 e0 01             	and    $0x1,%eax
c0104648:	85 c0                	test   %eax,%eax
c010464a:	74 0f                	je     c010465b <get_page+0x52>
        return pa2page(*ptep);
c010464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010464f:	8b 00                	mov    (%eax),%eax
c0104651:	89 04 24             	mov    %eax,(%esp)
c0104654:	e8 43 f4 ff ff       	call   c0103a9c <pa2page>
c0104659:	eb 05                	jmp    c0104660 <get_page+0x57>
    }
    return NULL;
c010465b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104660:	c9                   	leave  
c0104661:	c3                   	ret    

c0104662 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104662:	55                   	push   %ebp
c0104663:	89 e5                	mov    %esp,%ebp
c0104665:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    
    if(*ptep & PTE_P){
c0104668:	8b 45 10             	mov    0x10(%ebp),%eax
c010466b:	8b 00                	mov    (%eax),%eax
c010466d:	83 e0 01             	and    $0x1,%eax
c0104670:	85 c0                	test   %eax,%eax
c0104672:	74 52                	je     c01046c6 <page_remove_pte+0x64>
        struct Page *p = pte2page(*ptep);
c0104674:	8b 45 10             	mov    0x10(%ebp),%eax
c0104677:	8b 00                	mov    (%eax),%eax
c0104679:	89 04 24             	mov    %eax,(%esp)
c010467c:	e8 be f4 ff ff       	call   c0103b3f <pte2page>
c0104681:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(p);
c0104684:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104687:	89 04 24             	mov    %eax,(%esp)
c010468a:	e8 1c f5 ff ff       	call   c0103bab <page_ref_dec>
        if(p->ref == 0)
c010468f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104692:	8b 00                	mov    (%eax),%eax
c0104694:	85 c0                	test   %eax,%eax
c0104696:	75 13                	jne    c01046ab <page_remove_pte+0x49>
            free_page(p);
c0104698:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010469f:	00 
c01046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a3:	89 04 24             	mov    %eax,(%esp)
c01046a6:	e8 0f f7 ff ff       	call   c0103dba <free_pages>
        *ptep = 0;
c01046ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01046b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046be:	89 04 24             	mov    %eax,(%esp)
c01046c1:	e8 ff 00 00 00       	call   c01047c5 <tlb_invalidate>
    }
}
c01046c6:	c9                   	leave  
c01046c7:	c3                   	ret    

c01046c8 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01046c8:	55                   	push   %ebp
c01046c9:	89 e5                	mov    %esp,%ebp
c01046cb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01046ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046d5:	00 
c01046d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e0:	89 04 24             	mov    %eax,(%esp)
c01046e3:	e8 d9 fd ff ff       	call   c01044c1 <get_pte>
c01046e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01046eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ef:	74 19                	je     c010470a <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01046f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104702:	89 04 24             	mov    %eax,(%esp)
c0104705:	e8 58 ff ff ff       	call   c0104662 <page_remove_pte>
    }
}
c010470a:	c9                   	leave  
c010470b:	c3                   	ret    

c010470c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010470c:	55                   	push   %ebp
c010470d:	89 e5                	mov    %esp,%ebp
c010470f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104712:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104719:	00 
c010471a:	8b 45 10             	mov    0x10(%ebp),%eax
c010471d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104721:	8b 45 08             	mov    0x8(%ebp),%eax
c0104724:	89 04 24             	mov    %eax,(%esp)
c0104727:	e8 95 fd ff ff       	call   c01044c1 <get_pte>
c010472c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010472f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104733:	75 0a                	jne    c010473f <page_insert+0x33>
        return -E_NO_MEM;
c0104735:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010473a:	e9 84 00 00 00       	jmp    c01047c3 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010473f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104742:	89 04 24             	mov    %eax,(%esp)
c0104745:	e8 4a f4 ff ff       	call   c0103b94 <page_ref_inc>
    if (*ptep & PTE_P) {
c010474a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010474d:	8b 00                	mov    (%eax),%eax
c010474f:	83 e0 01             	and    $0x1,%eax
c0104752:	85 c0                	test   %eax,%eax
c0104754:	74 3e                	je     c0104794 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104759:	8b 00                	mov    (%eax),%eax
c010475b:	89 04 24             	mov    %eax,(%esp)
c010475e:	e8 dc f3 ff ff       	call   c0103b3f <pte2page>
c0104763:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104766:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104769:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010476c:	75 0d                	jne    c010477b <page_insert+0x6f>
            page_ref_dec(page);
c010476e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104771:	89 04 24             	mov    %eax,(%esp)
c0104774:	e8 32 f4 ff ff       	call   c0103bab <page_ref_dec>
c0104779:	eb 19                	jmp    c0104794 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010477b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010477e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104782:	8b 45 10             	mov    0x10(%ebp),%eax
c0104785:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104789:	8b 45 08             	mov    0x8(%ebp),%eax
c010478c:	89 04 24             	mov    %eax,(%esp)
c010478f:	e8 ce fe ff ff       	call   c0104662 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104794:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104797:	89 04 24             	mov    %eax,(%esp)
c010479a:	e8 e7 f2 ff ff       	call   c0103a86 <page2pa>
c010479f:	0b 45 14             	or     0x14(%ebp),%eax
c01047a2:	83 c8 01             	or     $0x1,%eax
c01047a5:	89 c2                	mov    %eax,%edx
c01047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047aa:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01047ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01047af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01047b6:	89 04 24             	mov    %eax,(%esp)
c01047b9:	e8 07 00 00 00       	call   c01047c5 <tlb_invalidate>
    return 0;
c01047be:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047c3:	c9                   	leave  
c01047c4:	c3                   	ret    

c01047c5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01047c5:	55                   	push   %ebp
c01047c6:	89 e5                	mov    %esp,%ebp
c01047c8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01047cb:	0f 20 d8             	mov    %cr3,%eax
c01047ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01047d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01047d4:	89 c2                	mov    %eax,%edx
c01047d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047dc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01047e3:	77 23                	ja     c0104808 <tlb_invalidate+0x43>
c01047e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047ec:	c7 44 24 08 b8 6b 10 	movl   $0xc0106bb8,0x8(%esp)
c01047f3:	c0 
c01047f4:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01047fb:	00 
c01047fc:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104803:	e8 d9 c4 ff ff       	call   c0100ce1 <__panic>
c0104808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010480b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104810:	39 c2                	cmp    %eax,%edx
c0104812:	75 0c                	jne    c0104820 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104814:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104817:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010481a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010481d:	0f 01 38             	invlpg (%eax)
    }
}
c0104820:	c9                   	leave  
c0104821:	c3                   	ret    

c0104822 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104822:	55                   	push   %ebp
c0104823:	89 e5                	mov    %esp,%ebp
c0104825:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104828:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010482d:	8b 40 18             	mov    0x18(%eax),%eax
c0104830:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104832:	c7 04 24 3c 6c 10 c0 	movl   $0xc0106c3c,(%esp)
c0104839:	e8 fe ba ff ff       	call   c010033c <cprintf>
}
c010483e:	c9                   	leave  
c010483f:	c3                   	ret    

c0104840 <check_pgdir>:

static void
check_pgdir(void) {
c0104840:	55                   	push   %ebp
c0104841:	89 e5                	mov    %esp,%ebp
c0104843:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104846:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010484b:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104850:	76 24                	jbe    c0104876 <check_pgdir+0x36>
c0104852:	c7 44 24 0c 5b 6c 10 	movl   $0xc0106c5b,0xc(%esp)
c0104859:	c0 
c010485a:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104861:	c0 
c0104862:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104869:	00 
c010486a:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104871:	e8 6b c4 ff ff       	call   c0100ce1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104876:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010487b:	85 c0                	test   %eax,%eax
c010487d:	74 0e                	je     c010488d <check_pgdir+0x4d>
c010487f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104884:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104889:	85 c0                	test   %eax,%eax
c010488b:	74 24                	je     c01048b1 <check_pgdir+0x71>
c010488d:	c7 44 24 0c 78 6c 10 	movl   $0xc0106c78,0xc(%esp)
c0104894:	c0 
c0104895:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c010489c:	c0 
c010489d:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01048a4:	00 
c01048a5:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01048ac:	e8 30 c4 ff ff       	call   c0100ce1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01048b1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048bd:	00 
c01048be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048c5:	00 
c01048c6:	89 04 24             	mov    %eax,(%esp)
c01048c9:	e8 3b fd ff ff       	call   c0104609 <get_page>
c01048ce:	85 c0                	test   %eax,%eax
c01048d0:	74 24                	je     c01048f6 <check_pgdir+0xb6>
c01048d2:	c7 44 24 0c b0 6c 10 	movl   $0xc0106cb0,0xc(%esp)
c01048d9:	c0 
c01048da:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c01048e1:	c0 
c01048e2:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01048e9:	00 
c01048ea:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01048f1:	e8 eb c3 ff ff       	call   c0100ce1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01048f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048fd:	e8 80 f4 ff ff       	call   c0103d82 <alloc_pages>
c0104902:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104905:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010490a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104911:	00 
c0104912:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104919:	00 
c010491a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010491d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104921:	89 04 24             	mov    %eax,(%esp)
c0104924:	e8 e3 fd ff ff       	call   c010470c <page_insert>
c0104929:	85 c0                	test   %eax,%eax
c010492b:	74 24                	je     c0104951 <check_pgdir+0x111>
c010492d:	c7 44 24 0c d8 6c 10 	movl   $0xc0106cd8,0xc(%esp)
c0104934:	c0 
c0104935:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c010493c:	c0 
c010493d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104944:	00 
c0104945:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c010494c:	e8 90 c3 ff ff       	call   c0100ce1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104951:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104956:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010495d:	00 
c010495e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104965:	00 
c0104966:	89 04 24             	mov    %eax,(%esp)
c0104969:	e8 53 fb ff ff       	call   c01044c1 <get_pte>
c010496e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104971:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104975:	75 24                	jne    c010499b <check_pgdir+0x15b>
c0104977:	c7 44 24 0c 04 6d 10 	movl   $0xc0106d04,0xc(%esp)
c010497e:	c0 
c010497f:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104986:	c0 
c0104987:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c010498e:	00 
c010498f:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104996:	e8 46 c3 ff ff       	call   c0100ce1 <__panic>
    assert(pa2page(*ptep) == p1);
c010499b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010499e:	8b 00                	mov    (%eax),%eax
c01049a0:	89 04 24             	mov    %eax,(%esp)
c01049a3:	e8 f4 f0 ff ff       	call   c0103a9c <pa2page>
c01049a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01049ab:	74 24                	je     c01049d1 <check_pgdir+0x191>
c01049ad:	c7 44 24 0c 31 6d 10 	movl   $0xc0106d31,0xc(%esp)
c01049b4:	c0 
c01049b5:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c01049bc:	c0 
c01049bd:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c01049c4:	00 
c01049c5:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01049cc:	e8 10 c3 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p1) == 1);
c01049d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d4:	89 04 24             	mov    %eax,(%esp)
c01049d7:	e8 a1 f1 ff ff       	call   c0103b7d <page_ref>
c01049dc:	83 f8 01             	cmp    $0x1,%eax
c01049df:	74 24                	je     c0104a05 <check_pgdir+0x1c5>
c01049e1:	c7 44 24 0c 46 6d 10 	movl   $0xc0106d46,0xc(%esp)
c01049e8:	c0 
c01049e9:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c01049f0:	c0 
c01049f1:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c01049f8:	00 
c01049f9:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104a00:	e8 dc c2 ff ff       	call   c0100ce1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104a05:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a0a:	8b 00                	mov    (%eax),%eax
c0104a0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a11:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a17:	c1 e8 0c             	shr    $0xc,%eax
c0104a1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a1d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104a22:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104a25:	72 23                	jb     c0104a4a <check_pgdir+0x20a>
c0104a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a2e:	c7 44 24 08 14 6b 10 	movl   $0xc0106b14,0x8(%esp)
c0104a35:	c0 
c0104a36:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104a3d:	00 
c0104a3e:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104a45:	e8 97 c2 ff ff       	call   c0100ce1 <__panic>
c0104a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a4d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a52:	83 c0 04             	add    $0x4,%eax
c0104a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a58:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a5d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a64:	00 
c0104a65:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a6c:	00 
c0104a6d:	89 04 24             	mov    %eax,(%esp)
c0104a70:	e8 4c fa ff ff       	call   c01044c1 <get_pte>
c0104a75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a78:	74 24                	je     c0104a9e <check_pgdir+0x25e>
c0104a7a:	c7 44 24 0c 58 6d 10 	movl   $0xc0106d58,0xc(%esp)
c0104a81:	c0 
c0104a82:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104a89:	c0 
c0104a8a:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104a91:	00 
c0104a92:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104a99:	e8 43 c2 ff ff       	call   c0100ce1 <__panic>

    p2 = alloc_page();
c0104a9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104aa5:	e8 d8 f2 ff ff       	call   c0103d82 <alloc_pages>
c0104aaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104aad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ab2:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104ab9:	00 
c0104aba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ac1:	00 
c0104ac2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ac5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ac9:	89 04 24             	mov    %eax,(%esp)
c0104acc:	e8 3b fc ff ff       	call   c010470c <page_insert>
c0104ad1:	85 c0                	test   %eax,%eax
c0104ad3:	74 24                	je     c0104af9 <check_pgdir+0x2b9>
c0104ad5:	c7 44 24 0c 80 6d 10 	movl   $0xc0106d80,0xc(%esp)
c0104adc:	c0 
c0104add:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104ae4:	c0 
c0104ae5:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104aec:	00 
c0104aed:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104af4:	e8 e8 c1 ff ff       	call   c0100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104af9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104afe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b05:	00 
c0104b06:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b0d:	00 
c0104b0e:	89 04 24             	mov    %eax,(%esp)
c0104b11:	e8 ab f9 ff ff       	call   c01044c1 <get_pte>
c0104b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b1d:	75 24                	jne    c0104b43 <check_pgdir+0x303>
c0104b1f:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104b26:	c0 
c0104b27:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104b2e:	c0 
c0104b2f:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104b36:	00 
c0104b37:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104b3e:	e8 9e c1 ff ff       	call   c0100ce1 <__panic>
    assert(*ptep & PTE_U);
c0104b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b46:	8b 00                	mov    (%eax),%eax
c0104b48:	83 e0 04             	and    $0x4,%eax
c0104b4b:	85 c0                	test   %eax,%eax
c0104b4d:	75 24                	jne    c0104b73 <check_pgdir+0x333>
c0104b4f:	c7 44 24 0c e8 6d 10 	movl   $0xc0106de8,0xc(%esp)
c0104b56:	c0 
c0104b57:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104b5e:	c0 
c0104b5f:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104b66:	00 
c0104b67:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104b6e:	e8 6e c1 ff ff       	call   c0100ce1 <__panic>
    assert(*ptep & PTE_W);
c0104b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b76:	8b 00                	mov    (%eax),%eax
c0104b78:	83 e0 02             	and    $0x2,%eax
c0104b7b:	85 c0                	test   %eax,%eax
c0104b7d:	75 24                	jne    c0104ba3 <check_pgdir+0x363>
c0104b7f:	c7 44 24 0c f6 6d 10 	movl   $0xc0106df6,0xc(%esp)
c0104b86:	c0 
c0104b87:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104b8e:	c0 
c0104b8f:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104b96:	00 
c0104b97:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104b9e:	e8 3e c1 ff ff       	call   c0100ce1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104ba3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ba8:	8b 00                	mov    (%eax),%eax
c0104baa:	83 e0 04             	and    $0x4,%eax
c0104bad:	85 c0                	test   %eax,%eax
c0104baf:	75 24                	jne    c0104bd5 <check_pgdir+0x395>
c0104bb1:	c7 44 24 0c 04 6e 10 	movl   $0xc0106e04,0xc(%esp)
c0104bb8:	c0 
c0104bb9:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104bc0:	c0 
c0104bc1:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104bc8:	00 
c0104bc9:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104bd0:	e8 0c c1 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 1);
c0104bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bd8:	89 04 24             	mov    %eax,(%esp)
c0104bdb:	e8 9d ef ff ff       	call   c0103b7d <page_ref>
c0104be0:	83 f8 01             	cmp    $0x1,%eax
c0104be3:	74 24                	je     c0104c09 <check_pgdir+0x3c9>
c0104be5:	c7 44 24 0c 1a 6e 10 	movl   $0xc0106e1a,0xc(%esp)
c0104bec:	c0 
c0104bed:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104bf4:	c0 
c0104bf5:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104bfc:	00 
c0104bfd:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104c04:	e8 d8 c0 ff ff       	call   c0100ce1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104c09:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c0e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104c15:	00 
c0104c16:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c1d:	00 
c0104c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c21:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c25:	89 04 24             	mov    %eax,(%esp)
c0104c28:	e8 df fa ff ff       	call   c010470c <page_insert>
c0104c2d:	85 c0                	test   %eax,%eax
c0104c2f:	74 24                	je     c0104c55 <check_pgdir+0x415>
c0104c31:	c7 44 24 0c 2c 6e 10 	movl   $0xc0106e2c,0xc(%esp)
c0104c38:	c0 
c0104c39:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104c40:	c0 
c0104c41:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104c48:	00 
c0104c49:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104c50:	e8 8c c0 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p1) == 2);
c0104c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c58:	89 04 24             	mov    %eax,(%esp)
c0104c5b:	e8 1d ef ff ff       	call   c0103b7d <page_ref>
c0104c60:	83 f8 02             	cmp    $0x2,%eax
c0104c63:	74 24                	je     c0104c89 <check_pgdir+0x449>
c0104c65:	c7 44 24 0c 58 6e 10 	movl   $0xc0106e58,0xc(%esp)
c0104c6c:	c0 
c0104c6d:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104c74:	c0 
c0104c75:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104c7c:	00 
c0104c7d:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104c84:	e8 58 c0 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c0104c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c8c:	89 04 24             	mov    %eax,(%esp)
c0104c8f:	e8 e9 ee ff ff       	call   c0103b7d <page_ref>
c0104c94:	85 c0                	test   %eax,%eax
c0104c96:	74 24                	je     c0104cbc <check_pgdir+0x47c>
c0104c98:	c7 44 24 0c 6a 6e 10 	movl   $0xc0106e6a,0xc(%esp)
c0104c9f:	c0 
c0104ca0:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104ca7:	c0 
c0104ca8:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104caf:	00 
c0104cb0:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104cb7:	e8 25 c0 ff ff       	call   c0100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104cbc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cc1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cc8:	00 
c0104cc9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cd0:	00 
c0104cd1:	89 04 24             	mov    %eax,(%esp)
c0104cd4:	e8 e8 f7 ff ff       	call   c01044c1 <get_pte>
c0104cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ce0:	75 24                	jne    c0104d06 <check_pgdir+0x4c6>
c0104ce2:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104ce9:	c0 
c0104cea:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104cf1:	c0 
c0104cf2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104cf9:	00 
c0104cfa:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104d01:	e8 db bf ff ff       	call   c0100ce1 <__panic>
    assert(pa2page(*ptep) == p1);
c0104d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d09:	8b 00                	mov    (%eax),%eax
c0104d0b:	89 04 24             	mov    %eax,(%esp)
c0104d0e:	e8 89 ed ff ff       	call   c0103a9c <pa2page>
c0104d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d16:	74 24                	je     c0104d3c <check_pgdir+0x4fc>
c0104d18:	c7 44 24 0c 31 6d 10 	movl   $0xc0106d31,0xc(%esp)
c0104d1f:	c0 
c0104d20:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104d27:	c0 
c0104d28:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104d2f:	00 
c0104d30:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104d37:	e8 a5 bf ff ff       	call   c0100ce1 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d3f:	8b 00                	mov    (%eax),%eax
c0104d41:	83 e0 04             	and    $0x4,%eax
c0104d44:	85 c0                	test   %eax,%eax
c0104d46:	74 24                	je     c0104d6c <check_pgdir+0x52c>
c0104d48:	c7 44 24 0c 7c 6e 10 	movl   $0xc0106e7c,0xc(%esp)
c0104d4f:	c0 
c0104d50:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104d57:	c0 
c0104d58:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104d5f:	00 
c0104d60:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104d67:	e8 75 bf ff ff       	call   c0100ce1 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d6c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d78:	00 
c0104d79:	89 04 24             	mov    %eax,(%esp)
c0104d7c:	e8 47 f9 ff ff       	call   c01046c8 <page_remove>
    assert(page_ref(p1) == 1);
c0104d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d84:	89 04 24             	mov    %eax,(%esp)
c0104d87:	e8 f1 ed ff ff       	call   c0103b7d <page_ref>
c0104d8c:	83 f8 01             	cmp    $0x1,%eax
c0104d8f:	74 24                	je     c0104db5 <check_pgdir+0x575>
c0104d91:	c7 44 24 0c 46 6d 10 	movl   $0xc0106d46,0xc(%esp)
c0104d98:	c0 
c0104d99:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104da0:	c0 
c0104da1:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104da8:	00 
c0104da9:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104db0:	e8 2c bf ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c0104db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104db8:	89 04 24             	mov    %eax,(%esp)
c0104dbb:	e8 bd ed ff ff       	call   c0103b7d <page_ref>
c0104dc0:	85 c0                	test   %eax,%eax
c0104dc2:	74 24                	je     c0104de8 <check_pgdir+0x5a8>
c0104dc4:	c7 44 24 0c 6a 6e 10 	movl   $0xc0106e6a,0xc(%esp)
c0104dcb:	c0 
c0104dcc:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104dd3:	c0 
c0104dd4:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104ddb:	00 
c0104ddc:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104de3:	e8 f9 be ff ff       	call   c0100ce1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104de8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ded:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104df4:	00 
c0104df5:	89 04 24             	mov    %eax,(%esp)
c0104df8:	e8 cb f8 ff ff       	call   c01046c8 <page_remove>
    assert(page_ref(p1) == 0);
c0104dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e00:	89 04 24             	mov    %eax,(%esp)
c0104e03:	e8 75 ed ff ff       	call   c0103b7d <page_ref>
c0104e08:	85 c0                	test   %eax,%eax
c0104e0a:	74 24                	je     c0104e30 <check_pgdir+0x5f0>
c0104e0c:	c7 44 24 0c 91 6e 10 	movl   $0xc0106e91,0xc(%esp)
c0104e13:	c0 
c0104e14:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104e1b:	c0 
c0104e1c:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104e23:	00 
c0104e24:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104e2b:	e8 b1 be ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c0104e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e33:	89 04 24             	mov    %eax,(%esp)
c0104e36:	e8 42 ed ff ff       	call   c0103b7d <page_ref>
c0104e3b:	85 c0                	test   %eax,%eax
c0104e3d:	74 24                	je     c0104e63 <check_pgdir+0x623>
c0104e3f:	c7 44 24 0c 6a 6e 10 	movl   $0xc0106e6a,0xc(%esp)
c0104e46:	c0 
c0104e47:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104e4e:	c0 
c0104e4f:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104e56:	00 
c0104e57:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104e5e:	e8 7e be ff ff       	call   c0100ce1 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104e63:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e68:	8b 00                	mov    (%eax),%eax
c0104e6a:	89 04 24             	mov    %eax,(%esp)
c0104e6d:	e8 2a ec ff ff       	call   c0103a9c <pa2page>
c0104e72:	89 04 24             	mov    %eax,(%esp)
c0104e75:	e8 03 ed ff ff       	call   c0103b7d <page_ref>
c0104e7a:	83 f8 01             	cmp    $0x1,%eax
c0104e7d:	74 24                	je     c0104ea3 <check_pgdir+0x663>
c0104e7f:	c7 44 24 0c a4 6e 10 	movl   $0xc0106ea4,0xc(%esp)
c0104e86:	c0 
c0104e87:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104e8e:	c0 
c0104e8f:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104e96:	00 
c0104e97:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104e9e:	e8 3e be ff ff       	call   c0100ce1 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104ea3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ea8:	8b 00                	mov    (%eax),%eax
c0104eaa:	89 04 24             	mov    %eax,(%esp)
c0104ead:	e8 ea eb ff ff       	call   c0103a9c <pa2page>
c0104eb2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104eb9:	00 
c0104eba:	89 04 24             	mov    %eax,(%esp)
c0104ebd:	e8 f8 ee ff ff       	call   c0103dba <free_pages>
    boot_pgdir[0] = 0;
c0104ec2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104ecd:	c7 04 24 ca 6e 10 c0 	movl   $0xc0106eca,(%esp)
c0104ed4:	e8 63 b4 ff ff       	call   c010033c <cprintf>
}
c0104ed9:	c9                   	leave  
c0104eda:	c3                   	ret    

c0104edb <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104edb:	55                   	push   %ebp
c0104edc:	89 e5                	mov    %esp,%ebp
c0104ede:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ee1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ee8:	e9 ca 00 00 00       	jmp    c0104fb7 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef6:	c1 e8 0c             	shr    $0xc,%eax
c0104ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104efc:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f01:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104f04:	72 23                	jb     c0104f29 <check_boot_pgdir+0x4e>
c0104f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f09:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f0d:	c7 44 24 08 14 6b 10 	movl   $0xc0106b14,0x8(%esp)
c0104f14:	c0 
c0104f15:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104f1c:	00 
c0104f1d:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104f24:	e8 b8 bd ff ff       	call   c0100ce1 <__panic>
c0104f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f2c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f31:	89 c2                	mov    %eax,%edx
c0104f33:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f38:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f3f:	00 
c0104f40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f44:	89 04 24             	mov    %eax,(%esp)
c0104f47:	e8 75 f5 ff ff       	call   c01044c1 <get_pte>
c0104f4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f53:	75 24                	jne    c0104f79 <check_boot_pgdir+0x9e>
c0104f55:	c7 44 24 0c e4 6e 10 	movl   $0xc0106ee4,0xc(%esp)
c0104f5c:	c0 
c0104f5d:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104f64:	c0 
c0104f65:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104f6c:	00 
c0104f6d:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104f74:	e8 68 bd ff ff       	call   c0100ce1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f7c:	8b 00                	mov    (%eax),%eax
c0104f7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f83:	89 c2                	mov    %eax,%edx
c0104f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f88:	39 c2                	cmp    %eax,%edx
c0104f8a:	74 24                	je     c0104fb0 <check_boot_pgdir+0xd5>
c0104f8c:	c7 44 24 0c 21 6f 10 	movl   $0xc0106f21,0xc(%esp)
c0104f93:	c0 
c0104f94:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0104f9b:	c0 
c0104f9c:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104fa3:	00 
c0104fa4:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0104fab:	e8 31 bd ff ff       	call   c0100ce1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104fb0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104fba:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104fbf:	39 c2                	cmp    %eax,%edx
c0104fc1:	0f 82 26 ff ff ff    	jb     c0104eed <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104fc7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fcc:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104fd1:	8b 00                	mov    (%eax),%eax
c0104fd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104fd8:	89 c2                	mov    %eax,%edx
c0104fda:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fe2:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104fe9:	77 23                	ja     c010500e <check_boot_pgdir+0x133>
c0104feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ff2:	c7 44 24 08 b8 6b 10 	movl   $0xc0106bb8,0x8(%esp)
c0104ff9:	c0 
c0104ffa:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105001:	00 
c0105002:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0105009:	e8 d3 bc ff ff       	call   c0100ce1 <__panic>
c010500e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105011:	05 00 00 00 40       	add    $0x40000000,%eax
c0105016:	39 c2                	cmp    %eax,%edx
c0105018:	74 24                	je     c010503e <check_boot_pgdir+0x163>
c010501a:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0105021:	c0 
c0105022:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0105029:	c0 
c010502a:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105031:	00 
c0105032:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0105039:	e8 a3 bc ff ff       	call   c0100ce1 <__panic>

    assert(boot_pgdir[0] == 0);
c010503e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105043:	8b 00                	mov    (%eax),%eax
c0105045:	85 c0                	test   %eax,%eax
c0105047:	74 24                	je     c010506d <check_boot_pgdir+0x192>
c0105049:	c7 44 24 0c 6c 6f 10 	movl   $0xc0106f6c,0xc(%esp)
c0105050:	c0 
c0105051:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0105058:	c0 
c0105059:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105060:	00 
c0105061:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0105068:	e8 74 bc ff ff       	call   c0100ce1 <__panic>

    struct Page *p;
    p = alloc_page();
c010506d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105074:	e8 09 ed ff ff       	call   c0103d82 <alloc_pages>
c0105079:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010507c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105081:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105088:	00 
c0105089:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105090:	00 
c0105091:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105094:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105098:	89 04 24             	mov    %eax,(%esp)
c010509b:	e8 6c f6 ff ff       	call   c010470c <page_insert>
c01050a0:	85 c0                	test   %eax,%eax
c01050a2:	74 24                	je     c01050c8 <check_boot_pgdir+0x1ed>
c01050a4:	c7 44 24 0c 80 6f 10 	movl   $0xc0106f80,0xc(%esp)
c01050ab:	c0 
c01050ac:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c01050b3:	c0 
c01050b4:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c01050bb:	00 
c01050bc:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01050c3:	e8 19 bc ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p) == 1);
c01050c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050cb:	89 04 24             	mov    %eax,(%esp)
c01050ce:	e8 aa ea ff ff       	call   c0103b7d <page_ref>
c01050d3:	83 f8 01             	cmp    $0x1,%eax
c01050d6:	74 24                	je     c01050fc <check_boot_pgdir+0x221>
c01050d8:	c7 44 24 0c ae 6f 10 	movl   $0xc0106fae,0xc(%esp)
c01050df:	c0 
c01050e0:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c01050e7:	c0 
c01050e8:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01050ef:	00 
c01050f0:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01050f7:	e8 e5 bb ff ff       	call   c0100ce1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01050fc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105101:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105108:	00 
c0105109:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105110:	00 
c0105111:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105114:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105118:	89 04 24             	mov    %eax,(%esp)
c010511b:	e8 ec f5 ff ff       	call   c010470c <page_insert>
c0105120:	85 c0                	test   %eax,%eax
c0105122:	74 24                	je     c0105148 <check_boot_pgdir+0x26d>
c0105124:	c7 44 24 0c c0 6f 10 	movl   $0xc0106fc0,0xc(%esp)
c010512b:	c0 
c010512c:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0105133:	c0 
c0105134:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c010513b:	00 
c010513c:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0105143:	e8 99 bb ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p) == 2);
c0105148:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010514b:	89 04 24             	mov    %eax,(%esp)
c010514e:	e8 2a ea ff ff       	call   c0103b7d <page_ref>
c0105153:	83 f8 02             	cmp    $0x2,%eax
c0105156:	74 24                	je     c010517c <check_boot_pgdir+0x2a1>
c0105158:	c7 44 24 0c f7 6f 10 	movl   $0xc0106ff7,0xc(%esp)
c010515f:	c0 
c0105160:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0105167:	c0 
c0105168:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010516f:	00 
c0105170:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0105177:	e8 65 bb ff ff       	call   c0100ce1 <__panic>

    const char *str = "ucore: Hello world!!";
c010517c:	c7 45 dc 08 70 10 c0 	movl   $0xc0107008,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105183:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105186:	89 44 24 04          	mov    %eax,0x4(%esp)
c010518a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105191:	e8 1e 0a 00 00       	call   c0105bb4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105196:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010519d:	00 
c010519e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051a5:	e8 83 0a 00 00       	call   c0105c2d <strcmp>
c01051aa:	85 c0                	test   %eax,%eax
c01051ac:	74 24                	je     c01051d2 <check_boot_pgdir+0x2f7>
c01051ae:	c7 44 24 0c 20 70 10 	movl   $0xc0107020,0xc(%esp)
c01051b5:	c0 
c01051b6:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c01051bd:	c0 
c01051be:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01051c5:	00 
c01051c6:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c01051cd:	e8 0f bb ff ff       	call   c0100ce1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01051d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051d5:	89 04 24             	mov    %eax,(%esp)
c01051d8:	e8 0e e9 ff ff       	call   c0103aeb <page2kva>
c01051dd:	05 00 01 00 00       	add    $0x100,%eax
c01051e2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01051e5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051ec:	e8 6b 09 00 00       	call   c0105b5c <strlen>
c01051f1:	85 c0                	test   %eax,%eax
c01051f3:	74 24                	je     c0105219 <check_boot_pgdir+0x33e>
c01051f5:	c7 44 24 0c 58 70 10 	movl   $0xc0107058,0xc(%esp)
c01051fc:	c0 
c01051fd:	c7 44 24 08 01 6c 10 	movl   $0xc0106c01,0x8(%esp)
c0105204:	c0 
c0105205:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c010520c:	00 
c010520d:	c7 04 24 dc 6b 10 c0 	movl   $0xc0106bdc,(%esp)
c0105214:	e8 c8 ba ff ff       	call   c0100ce1 <__panic>

    free_page(p);
c0105219:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105220:	00 
c0105221:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105224:	89 04 24             	mov    %eax,(%esp)
c0105227:	e8 8e eb ff ff       	call   c0103dba <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010522c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105231:	8b 00                	mov    (%eax),%eax
c0105233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105238:	89 04 24             	mov    %eax,(%esp)
c010523b:	e8 5c e8 ff ff       	call   c0103a9c <pa2page>
c0105240:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105247:	00 
c0105248:	89 04 24             	mov    %eax,(%esp)
c010524b:	e8 6a eb ff ff       	call   c0103dba <free_pages>
    boot_pgdir[0] = 0;
c0105250:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010525b:	c7 04 24 7c 70 10 c0 	movl   $0xc010707c,(%esp)
c0105262:	e8 d5 b0 ff ff       	call   c010033c <cprintf>
}
c0105267:	c9                   	leave  
c0105268:	c3                   	ret    

c0105269 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105269:	55                   	push   %ebp
c010526a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010526c:	8b 45 08             	mov    0x8(%ebp),%eax
c010526f:	83 e0 04             	and    $0x4,%eax
c0105272:	85 c0                	test   %eax,%eax
c0105274:	74 07                	je     c010527d <perm2str+0x14>
c0105276:	b8 75 00 00 00       	mov    $0x75,%eax
c010527b:	eb 05                	jmp    c0105282 <perm2str+0x19>
c010527d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105282:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105287:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010528e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105291:	83 e0 02             	and    $0x2,%eax
c0105294:	85 c0                	test   %eax,%eax
c0105296:	74 07                	je     c010529f <perm2str+0x36>
c0105298:	b8 77 00 00 00       	mov    $0x77,%eax
c010529d:	eb 05                	jmp    c01052a4 <perm2str+0x3b>
c010529f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01052a4:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01052a9:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01052b0:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01052b5:	5d                   	pop    %ebp
c01052b6:	c3                   	ret    

c01052b7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01052b7:	55                   	push   %ebp
c01052b8:	89 e5                	mov    %esp,%ebp
c01052ba:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01052bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01052c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052c3:	72 0a                	jb     c01052cf <get_pgtable_items+0x18>
        return 0;
c01052c5:	b8 00 00 00 00       	mov    $0x0,%eax
c01052ca:	e9 9c 00 00 00       	jmp    c010536b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01052cf:	eb 04                	jmp    c01052d5 <get_pgtable_items+0x1e>
        start ++;
c01052d1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01052d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01052d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052db:	73 18                	jae    c01052f5 <get_pgtable_items+0x3e>
c01052dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01052e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052e7:	8b 45 14             	mov    0x14(%ebp),%eax
c01052ea:	01 d0                	add    %edx,%eax
c01052ec:	8b 00                	mov    (%eax),%eax
c01052ee:	83 e0 01             	and    $0x1,%eax
c01052f1:	85 c0                	test   %eax,%eax
c01052f3:	74 dc                	je     c01052d1 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01052f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01052f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052fb:	73 69                	jae    c0105366 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01052fd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105301:	74 08                	je     c010530b <get_pgtable_items+0x54>
            *left_store = start;
c0105303:	8b 45 18             	mov    0x18(%ebp),%eax
c0105306:	8b 55 10             	mov    0x10(%ebp),%edx
c0105309:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010530b:	8b 45 10             	mov    0x10(%ebp),%eax
c010530e:	8d 50 01             	lea    0x1(%eax),%edx
c0105311:	89 55 10             	mov    %edx,0x10(%ebp)
c0105314:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010531b:	8b 45 14             	mov    0x14(%ebp),%eax
c010531e:	01 d0                	add    %edx,%eax
c0105320:	8b 00                	mov    (%eax),%eax
c0105322:	83 e0 07             	and    $0x7,%eax
c0105325:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105328:	eb 04                	jmp    c010532e <get_pgtable_items+0x77>
            start ++;
c010532a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010532e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105331:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105334:	73 1d                	jae    c0105353 <get_pgtable_items+0x9c>
c0105336:	8b 45 10             	mov    0x10(%ebp),%eax
c0105339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105340:	8b 45 14             	mov    0x14(%ebp),%eax
c0105343:	01 d0                	add    %edx,%eax
c0105345:	8b 00                	mov    (%eax),%eax
c0105347:	83 e0 07             	and    $0x7,%eax
c010534a:	89 c2                	mov    %eax,%edx
c010534c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010534f:	39 c2                	cmp    %eax,%edx
c0105351:	74 d7                	je     c010532a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105353:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105357:	74 08                	je     c0105361 <get_pgtable_items+0xaa>
            *right_store = start;
c0105359:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010535c:	8b 55 10             	mov    0x10(%ebp),%edx
c010535f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105361:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105364:	eb 05                	jmp    c010536b <get_pgtable_items+0xb4>
    }
    return 0;
c0105366:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010536b:	c9                   	leave  
c010536c:	c3                   	ret    

c010536d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010536d:	55                   	push   %ebp
c010536e:	89 e5                	mov    %esp,%ebp
c0105370:	57                   	push   %edi
c0105371:	56                   	push   %esi
c0105372:	53                   	push   %ebx
c0105373:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105376:	c7 04 24 9c 70 10 c0 	movl   $0xc010709c,(%esp)
c010537d:	e8 ba af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105382:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105389:	e9 fa 00 00 00       	jmp    c0105488 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010538e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105391:	89 04 24             	mov    %eax,(%esp)
c0105394:	e8 d0 fe ff ff       	call   c0105269 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105399:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010539c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010539f:	29 d1                	sub    %edx,%ecx
c01053a1:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01053a3:	89 d6                	mov    %edx,%esi
c01053a5:	c1 e6 16             	shl    $0x16,%esi
c01053a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053ab:	89 d3                	mov    %edx,%ebx
c01053ad:	c1 e3 16             	shl    $0x16,%ebx
c01053b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053b3:	89 d1                	mov    %edx,%ecx
c01053b5:	c1 e1 16             	shl    $0x16,%ecx
c01053b8:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01053bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053be:	29 d7                	sub    %edx,%edi
c01053c0:	89 fa                	mov    %edi,%edx
c01053c2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053c6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053d6:	c7 04 24 cd 70 10 c0 	movl   $0xc01070cd,(%esp)
c01053dd:	e8 5a af ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01053e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053e5:	c1 e0 0a             	shl    $0xa,%eax
c01053e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053eb:	eb 54                	jmp    c0105441 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053f0:	89 04 24             	mov    %eax,(%esp)
c01053f3:	e8 71 fe ff ff       	call   c0105269 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01053f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01053fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053fe:	29 d1                	sub    %edx,%ecx
c0105400:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105402:	89 d6                	mov    %edx,%esi
c0105404:	c1 e6 0c             	shl    $0xc,%esi
c0105407:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010540a:	89 d3                	mov    %edx,%ebx
c010540c:	c1 e3 0c             	shl    $0xc,%ebx
c010540f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105412:	c1 e2 0c             	shl    $0xc,%edx
c0105415:	89 d1                	mov    %edx,%ecx
c0105417:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010541a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010541d:	29 d7                	sub    %edx,%edi
c010541f:	89 fa                	mov    %edi,%edx
c0105421:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105425:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105429:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010542d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105431:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105435:	c7 04 24 ec 70 10 c0 	movl   $0xc01070ec,(%esp)
c010543c:	e8 fb ae ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105441:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105446:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105449:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010544c:	89 ce                	mov    %ecx,%esi
c010544e:	c1 e6 0a             	shl    $0xa,%esi
c0105451:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105454:	89 cb                	mov    %ecx,%ebx
c0105456:	c1 e3 0a             	shl    $0xa,%ebx
c0105459:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010545c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105460:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105463:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105467:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010546b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010546f:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105473:	89 1c 24             	mov    %ebx,(%esp)
c0105476:	e8 3c fe ff ff       	call   c01052b7 <get_pgtable_items>
c010547b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010547e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105482:	0f 85 65 ff ff ff    	jne    c01053ed <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105488:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010548d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105490:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105493:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105497:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010549a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010549e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054a6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01054ad:	00 
c01054ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01054b5:	e8 fd fd ff ff       	call   c01052b7 <get_pgtable_items>
c01054ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054c1:	0f 85 c7 fe ff ff    	jne    c010538e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01054c7:	c7 04 24 10 71 10 c0 	movl   $0xc0107110,(%esp)
c01054ce:	e8 69 ae ff ff       	call   c010033c <cprintf>
}
c01054d3:	83 c4 4c             	add    $0x4c,%esp
c01054d6:	5b                   	pop    %ebx
c01054d7:	5e                   	pop    %esi
c01054d8:	5f                   	pop    %edi
c01054d9:	5d                   	pop    %ebp
c01054da:	c3                   	ret    

c01054db <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01054db:	55                   	push   %ebp
c01054dc:	89 e5                	mov    %esp,%ebp
c01054de:	83 ec 58             	sub    $0x58,%esp
c01054e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01054e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054e7:	8b 45 14             	mov    0x14(%ebp),%eax
c01054ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054f9:	8b 45 18             	mov    0x18(%ebp),%eax
c01054fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105502:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105505:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105508:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010550b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010550e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105511:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105515:	74 1c                	je     c0105533 <printnum+0x58>
c0105517:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010551a:	ba 00 00 00 00       	mov    $0x0,%edx
c010551f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105522:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105525:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105528:	ba 00 00 00 00       	mov    $0x0,%edx
c010552d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105530:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105533:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105536:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105539:	f7 75 e4             	divl   -0x1c(%ebp)
c010553c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010553f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105542:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105545:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105548:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010554b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010554e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105551:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105554:	8b 45 18             	mov    0x18(%ebp),%eax
c0105557:	ba 00 00 00 00       	mov    $0x0,%edx
c010555c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010555f:	77 56                	ja     c01055b7 <printnum+0xdc>
c0105561:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105564:	72 05                	jb     c010556b <printnum+0x90>
c0105566:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105569:	77 4c                	ja     c01055b7 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010556b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010556e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105571:	8b 45 20             	mov    0x20(%ebp),%eax
c0105574:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105578:	89 54 24 14          	mov    %edx,0x14(%esp)
c010557c:	8b 45 18             	mov    0x18(%ebp),%eax
c010557f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105583:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105586:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105589:	89 44 24 08          	mov    %eax,0x8(%esp)
c010558d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105591:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105594:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105598:	8b 45 08             	mov    0x8(%ebp),%eax
c010559b:	89 04 24             	mov    %eax,(%esp)
c010559e:	e8 38 ff ff ff       	call   c01054db <printnum>
c01055a3:	eb 1c                	jmp    c01055c1 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01055a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055ac:	8b 45 20             	mov    0x20(%ebp),%eax
c01055af:	89 04 24             	mov    %eax,(%esp)
c01055b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b5:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01055b7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01055bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01055bf:	7f e4                	jg     c01055a5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01055c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01055c4:	05 c4 71 10 c0       	add    $0xc01071c4,%eax
c01055c9:	0f b6 00             	movzbl (%eax),%eax
c01055cc:	0f be c0             	movsbl %al,%eax
c01055cf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055d6:	89 04 24             	mov    %eax,(%esp)
c01055d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055dc:	ff d0                	call   *%eax
}
c01055de:	c9                   	leave  
c01055df:	c3                   	ret    

c01055e0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01055e0:	55                   	push   %ebp
c01055e1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055e3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055e7:	7e 14                	jle    c01055fd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01055e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ec:	8b 00                	mov    (%eax),%eax
c01055ee:	8d 48 08             	lea    0x8(%eax),%ecx
c01055f1:	8b 55 08             	mov    0x8(%ebp),%edx
c01055f4:	89 0a                	mov    %ecx,(%edx)
c01055f6:	8b 50 04             	mov    0x4(%eax),%edx
c01055f9:	8b 00                	mov    (%eax),%eax
c01055fb:	eb 30                	jmp    c010562d <getuint+0x4d>
    }
    else if (lflag) {
c01055fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105601:	74 16                	je     c0105619 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105603:	8b 45 08             	mov    0x8(%ebp),%eax
c0105606:	8b 00                	mov    (%eax),%eax
c0105608:	8d 48 04             	lea    0x4(%eax),%ecx
c010560b:	8b 55 08             	mov    0x8(%ebp),%edx
c010560e:	89 0a                	mov    %ecx,(%edx)
c0105610:	8b 00                	mov    (%eax),%eax
c0105612:	ba 00 00 00 00       	mov    $0x0,%edx
c0105617:	eb 14                	jmp    c010562d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105619:	8b 45 08             	mov    0x8(%ebp),%eax
c010561c:	8b 00                	mov    (%eax),%eax
c010561e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105621:	8b 55 08             	mov    0x8(%ebp),%edx
c0105624:	89 0a                	mov    %ecx,(%edx)
c0105626:	8b 00                	mov    (%eax),%eax
c0105628:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010562d:	5d                   	pop    %ebp
c010562e:	c3                   	ret    

c010562f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010562f:	55                   	push   %ebp
c0105630:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105632:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105636:	7e 14                	jle    c010564c <getint+0x1d>
        return va_arg(*ap, long long);
c0105638:	8b 45 08             	mov    0x8(%ebp),%eax
c010563b:	8b 00                	mov    (%eax),%eax
c010563d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105640:	8b 55 08             	mov    0x8(%ebp),%edx
c0105643:	89 0a                	mov    %ecx,(%edx)
c0105645:	8b 50 04             	mov    0x4(%eax),%edx
c0105648:	8b 00                	mov    (%eax),%eax
c010564a:	eb 28                	jmp    c0105674 <getint+0x45>
    }
    else if (lflag) {
c010564c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105650:	74 12                	je     c0105664 <getint+0x35>
        return va_arg(*ap, long);
c0105652:	8b 45 08             	mov    0x8(%ebp),%eax
c0105655:	8b 00                	mov    (%eax),%eax
c0105657:	8d 48 04             	lea    0x4(%eax),%ecx
c010565a:	8b 55 08             	mov    0x8(%ebp),%edx
c010565d:	89 0a                	mov    %ecx,(%edx)
c010565f:	8b 00                	mov    (%eax),%eax
c0105661:	99                   	cltd   
c0105662:	eb 10                	jmp    c0105674 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105664:	8b 45 08             	mov    0x8(%ebp),%eax
c0105667:	8b 00                	mov    (%eax),%eax
c0105669:	8d 48 04             	lea    0x4(%eax),%ecx
c010566c:	8b 55 08             	mov    0x8(%ebp),%edx
c010566f:	89 0a                	mov    %ecx,(%edx)
c0105671:	8b 00                	mov    (%eax),%eax
c0105673:	99                   	cltd   
    }
}
c0105674:	5d                   	pop    %ebp
c0105675:	c3                   	ret    

c0105676 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105676:	55                   	push   %ebp
c0105677:	89 e5                	mov    %esp,%ebp
c0105679:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010567c:	8d 45 14             	lea    0x14(%ebp),%eax
c010567f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105682:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105685:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105689:	8b 45 10             	mov    0x10(%ebp),%eax
c010568c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105690:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105693:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105697:	8b 45 08             	mov    0x8(%ebp),%eax
c010569a:	89 04 24             	mov    %eax,(%esp)
c010569d:	e8 02 00 00 00       	call   c01056a4 <vprintfmt>
    va_end(ap);
}
c01056a2:	c9                   	leave  
c01056a3:	c3                   	ret    

c01056a4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01056a4:	55                   	push   %ebp
c01056a5:	89 e5                	mov    %esp,%ebp
c01056a7:	56                   	push   %esi
c01056a8:	53                   	push   %ebx
c01056a9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056ac:	eb 18                	jmp    c01056c6 <vprintfmt+0x22>
            if (ch == '\0') {
c01056ae:	85 db                	test   %ebx,%ebx
c01056b0:	75 05                	jne    c01056b7 <vprintfmt+0x13>
                return;
c01056b2:	e9 d1 03 00 00       	jmp    c0105a88 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01056b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056be:	89 1c 24             	mov    %ebx,(%esp)
c01056c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c4:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c9:	8d 50 01             	lea    0x1(%eax),%edx
c01056cc:	89 55 10             	mov    %edx,0x10(%ebp)
c01056cf:	0f b6 00             	movzbl (%eax),%eax
c01056d2:	0f b6 d8             	movzbl %al,%ebx
c01056d5:	83 fb 25             	cmp    $0x25,%ebx
c01056d8:	75 d4                	jne    c01056ae <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01056da:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01056de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01056e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01056eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01056f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01056f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01056fb:	8d 50 01             	lea    0x1(%eax),%edx
c01056fe:	89 55 10             	mov    %edx,0x10(%ebp)
c0105701:	0f b6 00             	movzbl (%eax),%eax
c0105704:	0f b6 d8             	movzbl %al,%ebx
c0105707:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010570a:	83 f8 55             	cmp    $0x55,%eax
c010570d:	0f 87 44 03 00 00    	ja     c0105a57 <vprintfmt+0x3b3>
c0105713:	8b 04 85 e8 71 10 c0 	mov    -0x3fef8e18(,%eax,4),%eax
c010571a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010571c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105720:	eb d6                	jmp    c01056f8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105722:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105726:	eb d0                	jmp    c01056f8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105728:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010572f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105732:	89 d0                	mov    %edx,%eax
c0105734:	c1 e0 02             	shl    $0x2,%eax
c0105737:	01 d0                	add    %edx,%eax
c0105739:	01 c0                	add    %eax,%eax
c010573b:	01 d8                	add    %ebx,%eax
c010573d:	83 e8 30             	sub    $0x30,%eax
c0105740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105743:	8b 45 10             	mov    0x10(%ebp),%eax
c0105746:	0f b6 00             	movzbl (%eax),%eax
c0105749:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010574c:	83 fb 2f             	cmp    $0x2f,%ebx
c010574f:	7e 0b                	jle    c010575c <vprintfmt+0xb8>
c0105751:	83 fb 39             	cmp    $0x39,%ebx
c0105754:	7f 06                	jg     c010575c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105756:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010575a:	eb d3                	jmp    c010572f <vprintfmt+0x8b>
            goto process_precision;
c010575c:	eb 33                	jmp    c0105791 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010575e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105761:	8d 50 04             	lea    0x4(%eax),%edx
c0105764:	89 55 14             	mov    %edx,0x14(%ebp)
c0105767:	8b 00                	mov    (%eax),%eax
c0105769:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010576c:	eb 23                	jmp    c0105791 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010576e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105772:	79 0c                	jns    c0105780 <vprintfmt+0xdc>
                width = 0;
c0105774:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010577b:	e9 78 ff ff ff       	jmp    c01056f8 <vprintfmt+0x54>
c0105780:	e9 73 ff ff ff       	jmp    c01056f8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105785:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010578c:	e9 67 ff ff ff       	jmp    c01056f8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105791:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105795:	79 12                	jns    c01057a9 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010579a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010579d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01057a4:	e9 4f ff ff ff       	jmp    c01056f8 <vprintfmt+0x54>
c01057a9:	e9 4a ff ff ff       	jmp    c01056f8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01057ae:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01057b2:	e9 41 ff ff ff       	jmp    c01056f8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01057b7:	8b 45 14             	mov    0x14(%ebp),%eax
c01057ba:	8d 50 04             	lea    0x4(%eax),%edx
c01057bd:	89 55 14             	mov    %edx,0x14(%ebp)
c01057c0:	8b 00                	mov    (%eax),%eax
c01057c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057c5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057c9:	89 04 24             	mov    %eax,(%esp)
c01057cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cf:	ff d0                	call   *%eax
            break;
c01057d1:	e9 ac 02 00 00       	jmp    c0105a82 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01057d6:	8b 45 14             	mov    0x14(%ebp),%eax
c01057d9:	8d 50 04             	lea    0x4(%eax),%edx
c01057dc:	89 55 14             	mov    %edx,0x14(%ebp)
c01057df:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01057e1:	85 db                	test   %ebx,%ebx
c01057e3:	79 02                	jns    c01057e7 <vprintfmt+0x143>
                err = -err;
c01057e5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01057e7:	83 fb 06             	cmp    $0x6,%ebx
c01057ea:	7f 0b                	jg     c01057f7 <vprintfmt+0x153>
c01057ec:	8b 34 9d a8 71 10 c0 	mov    -0x3fef8e58(,%ebx,4),%esi
c01057f3:	85 f6                	test   %esi,%esi
c01057f5:	75 23                	jne    c010581a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01057f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01057fb:	c7 44 24 08 d5 71 10 	movl   $0xc01071d5,0x8(%esp)
c0105802:	c0 
c0105803:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105806:	89 44 24 04          	mov    %eax,0x4(%esp)
c010580a:	8b 45 08             	mov    0x8(%ebp),%eax
c010580d:	89 04 24             	mov    %eax,(%esp)
c0105810:	e8 61 fe ff ff       	call   c0105676 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105815:	e9 68 02 00 00       	jmp    c0105a82 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010581a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010581e:	c7 44 24 08 de 71 10 	movl   $0xc01071de,0x8(%esp)
c0105825:	c0 
c0105826:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105829:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105830:	89 04 24             	mov    %eax,(%esp)
c0105833:	e8 3e fe ff ff       	call   c0105676 <printfmt>
            }
            break;
c0105838:	e9 45 02 00 00       	jmp    c0105a82 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010583d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105840:	8d 50 04             	lea    0x4(%eax),%edx
c0105843:	89 55 14             	mov    %edx,0x14(%ebp)
c0105846:	8b 30                	mov    (%eax),%esi
c0105848:	85 f6                	test   %esi,%esi
c010584a:	75 05                	jne    c0105851 <vprintfmt+0x1ad>
                p = "(null)";
c010584c:	be e1 71 10 c0       	mov    $0xc01071e1,%esi
            }
            if (width > 0 && padc != '-') {
c0105851:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105855:	7e 3e                	jle    c0105895 <vprintfmt+0x1f1>
c0105857:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010585b:	74 38                	je     c0105895 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010585d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105863:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105867:	89 34 24             	mov    %esi,(%esp)
c010586a:	e8 15 03 00 00       	call   c0105b84 <strnlen>
c010586f:	29 c3                	sub    %eax,%ebx
c0105871:	89 d8                	mov    %ebx,%eax
c0105873:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105876:	eb 17                	jmp    c010588f <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105878:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010587c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010587f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105883:	89 04 24             	mov    %eax,(%esp)
c0105886:	8b 45 08             	mov    0x8(%ebp),%eax
c0105889:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010588b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010588f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105893:	7f e3                	jg     c0105878 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105895:	eb 38                	jmp    c01058cf <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105897:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010589b:	74 1f                	je     c01058bc <vprintfmt+0x218>
c010589d:	83 fb 1f             	cmp    $0x1f,%ebx
c01058a0:	7e 05                	jle    c01058a7 <vprintfmt+0x203>
c01058a2:	83 fb 7e             	cmp    $0x7e,%ebx
c01058a5:	7e 15                	jle    c01058bc <vprintfmt+0x218>
                    putch('?', putdat);
c01058a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058ae:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01058b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b8:	ff d0                	call   *%eax
c01058ba:	eb 0f                	jmp    c01058cb <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01058bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058c3:	89 1c 24             	mov    %ebx,(%esp)
c01058c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c9:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058cb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058cf:	89 f0                	mov    %esi,%eax
c01058d1:	8d 70 01             	lea    0x1(%eax),%esi
c01058d4:	0f b6 00             	movzbl (%eax),%eax
c01058d7:	0f be d8             	movsbl %al,%ebx
c01058da:	85 db                	test   %ebx,%ebx
c01058dc:	74 10                	je     c01058ee <vprintfmt+0x24a>
c01058de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058e2:	78 b3                	js     c0105897 <vprintfmt+0x1f3>
c01058e4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01058e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058ec:	79 a9                	jns    c0105897 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01058ee:	eb 17                	jmp    c0105907 <vprintfmt+0x263>
                putch(' ', putdat);
c01058f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01058fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105901:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105903:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105907:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010590b:	7f e3                	jg     c01058f0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010590d:	e9 70 01 00 00       	jmp    c0105a82 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105912:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105915:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105919:	8d 45 14             	lea    0x14(%ebp),%eax
c010591c:	89 04 24             	mov    %eax,(%esp)
c010591f:	e8 0b fd ff ff       	call   c010562f <getint>
c0105924:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105927:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010592a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010592d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105930:	85 d2                	test   %edx,%edx
c0105932:	79 26                	jns    c010595a <vprintfmt+0x2b6>
                putch('-', putdat);
c0105934:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105942:	8b 45 08             	mov    0x8(%ebp),%eax
c0105945:	ff d0                	call   *%eax
                num = -(long long)num;
c0105947:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010594a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010594d:	f7 d8                	neg    %eax
c010594f:	83 d2 00             	adc    $0x0,%edx
c0105952:	f7 da                	neg    %edx
c0105954:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105957:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010595a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105961:	e9 a8 00 00 00       	jmp    c0105a0e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105966:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105969:	89 44 24 04          	mov    %eax,0x4(%esp)
c010596d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105970:	89 04 24             	mov    %eax,(%esp)
c0105973:	e8 68 fc ff ff       	call   c01055e0 <getuint>
c0105978:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010597b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010597e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105985:	e9 84 00 00 00       	jmp    c0105a0e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010598a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010598d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105991:	8d 45 14             	lea    0x14(%ebp),%eax
c0105994:	89 04 24             	mov    %eax,(%esp)
c0105997:	e8 44 fc ff ff       	call   c01055e0 <getuint>
c010599c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010599f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01059a2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01059a9:	eb 63                	jmp    c0105a0e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01059ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01059b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bc:	ff d0                	call   *%eax
            putch('x', putdat);
c01059be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c5:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01059cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cf:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01059d1:	8b 45 14             	mov    0x14(%ebp),%eax
c01059d4:	8d 50 04             	lea    0x4(%eax),%edx
c01059d7:	89 55 14             	mov    %edx,0x14(%ebp)
c01059da:	8b 00                	mov    (%eax),%eax
c01059dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01059e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01059ed:	eb 1f                	jmp    c0105a0e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01059ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f6:	8d 45 14             	lea    0x14(%ebp),%eax
c01059f9:	89 04 24             	mov    %eax,(%esp)
c01059fc:	e8 df fb ff ff       	call   c01055e0 <getuint>
c0105a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a04:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105a07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105a0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a15:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105a19:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105a1c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105a20:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3c:	89 04 24             	mov    %eax,(%esp)
c0105a3f:	e8 97 fa ff ff       	call   c01054db <printnum>
            break;
c0105a44:	eb 3c                	jmp    c0105a82 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a4d:	89 1c 24             	mov    %ebx,(%esp)
c0105a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a53:	ff d0                	call   *%eax
            break;
c0105a55:	eb 2b                	jmp    c0105a82 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a5e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a68:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a6a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a6e:	eb 04                	jmp    c0105a74 <vprintfmt+0x3d0>
c0105a70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a74:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a77:	83 e8 01             	sub    $0x1,%eax
c0105a7a:	0f b6 00             	movzbl (%eax),%eax
c0105a7d:	3c 25                	cmp    $0x25,%al
c0105a7f:	75 ef                	jne    c0105a70 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105a81:	90                   	nop
        }
    }
c0105a82:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a83:	e9 3e fc ff ff       	jmp    c01056c6 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105a88:	83 c4 40             	add    $0x40,%esp
c0105a8b:	5b                   	pop    %ebx
c0105a8c:	5e                   	pop    %esi
c0105a8d:	5d                   	pop    %ebp
c0105a8e:	c3                   	ret    

c0105a8f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a8f:	55                   	push   %ebp
c0105a90:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a95:	8b 40 08             	mov    0x8(%eax),%eax
c0105a98:	8d 50 01             	lea    0x1(%eax),%edx
c0105a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a9e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa4:	8b 10                	mov    (%eax),%edx
c0105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa9:	8b 40 04             	mov    0x4(%eax),%eax
c0105aac:	39 c2                	cmp    %eax,%edx
c0105aae:	73 12                	jae    c0105ac2 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab3:	8b 00                	mov    (%eax),%eax
c0105ab5:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105abb:	89 0a                	mov    %ecx,(%edx)
c0105abd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ac0:	88 10                	mov    %dl,(%eax)
    }
}
c0105ac2:	5d                   	pop    %ebp
c0105ac3:	c3                   	ret    

c0105ac4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105ac4:	55                   	push   %ebp
c0105ac5:	89 e5                	mov    %esp,%ebp
c0105ac7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105aca:	8d 45 14             	lea    0x14(%ebp),%eax
c0105acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ad3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ad7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ada:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ade:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae8:	89 04 24             	mov    %eax,(%esp)
c0105aeb:	e8 08 00 00 00       	call   c0105af8 <vsnprintf>
c0105af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105af6:	c9                   	leave  
c0105af7:	c3                   	ret    

c0105af8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105af8:	55                   	push   %ebp
c0105af9:	89 e5                	mov    %esp,%ebp
c0105afb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b07:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0d:	01 d0                	add    %edx,%eax
c0105b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105b19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b1d:	74 0a                	je     c0105b29 <vsnprintf+0x31>
c0105b1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b25:	39 c2                	cmp    %eax,%edx
c0105b27:	76 07                	jbe    c0105b30 <vsnprintf+0x38>
        return -E_INVAL;
c0105b29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b2e:	eb 2a                	jmp    c0105b5a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b30:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b37:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b45:	c7 04 24 8f 5a 10 c0 	movl   $0xc0105a8f,(%esp)
c0105b4c:	e8 53 fb ff ff       	call   c01056a4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b54:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b5a:	c9                   	leave  
c0105b5b:	c3                   	ret    

c0105b5c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b5c:	55                   	push   %ebp
c0105b5d:	89 e5                	mov    %esp,%ebp
c0105b5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b69:	eb 04                	jmp    c0105b6f <strlen+0x13>
        cnt ++;
c0105b6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b72:	8d 50 01             	lea    0x1(%eax),%edx
c0105b75:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b78:	0f b6 00             	movzbl (%eax),%eax
c0105b7b:	84 c0                	test   %al,%al
c0105b7d:	75 ec                	jne    c0105b6b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b82:	c9                   	leave  
c0105b83:	c3                   	ret    

c0105b84 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b84:	55                   	push   %ebp
c0105b85:	89 e5                	mov    %esp,%ebp
c0105b87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b91:	eb 04                	jmp    c0105b97 <strnlen+0x13>
        cnt ++;
c0105b93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b9d:	73 10                	jae    c0105baf <strnlen+0x2b>
c0105b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba2:	8d 50 01             	lea    0x1(%eax),%edx
c0105ba5:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ba8:	0f b6 00             	movzbl (%eax),%eax
c0105bab:	84 c0                	test   %al,%al
c0105bad:	75 e4                	jne    c0105b93 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105bb2:	c9                   	leave  
c0105bb3:	c3                   	ret    

c0105bb4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105bb4:	55                   	push   %ebp
c0105bb5:	89 e5                	mov    %esp,%ebp
c0105bb7:	57                   	push   %edi
c0105bb8:	56                   	push   %esi
c0105bb9:	83 ec 20             	sub    $0x20,%esp
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bce:	89 d1                	mov    %edx,%ecx
c0105bd0:	89 c2                	mov    %eax,%edx
c0105bd2:	89 ce                	mov    %ecx,%esi
c0105bd4:	89 d7                	mov    %edx,%edi
c0105bd6:	ac                   	lods   %ds:(%esi),%al
c0105bd7:	aa                   	stos   %al,%es:(%edi)
c0105bd8:	84 c0                	test   %al,%al
c0105bda:	75 fa                	jne    c0105bd6 <strcpy+0x22>
c0105bdc:	89 fa                	mov    %edi,%edx
c0105bde:	89 f1                	mov    %esi,%ecx
c0105be0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105be3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105bec:	83 c4 20             	add    $0x20,%esp
c0105bef:	5e                   	pop    %esi
c0105bf0:	5f                   	pop    %edi
c0105bf1:	5d                   	pop    %ebp
c0105bf2:	c3                   	ret    

c0105bf3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105bf3:	55                   	push   %ebp
c0105bf4:	89 e5                	mov    %esp,%ebp
c0105bf6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105bff:	eb 21                	jmp    c0105c22 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105c01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c04:	0f b6 10             	movzbl (%eax),%edx
c0105c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c0a:	88 10                	mov    %dl,(%eax)
c0105c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c0f:	0f b6 00             	movzbl (%eax),%eax
c0105c12:	84 c0                	test   %al,%al
c0105c14:	74 04                	je     c0105c1a <strncpy+0x27>
            src ++;
c0105c16:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105c1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105c1e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105c22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c26:	75 d9                	jne    c0105c01 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105c28:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c2b:	c9                   	leave  
c0105c2c:	c3                   	ret    

c0105c2d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105c2d:	55                   	push   %ebp
c0105c2e:	89 e5                	mov    %esp,%ebp
c0105c30:	57                   	push   %edi
c0105c31:	56                   	push   %esi
c0105c32:	83 ec 20             	sub    $0x20,%esp
c0105c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c47:	89 d1                	mov    %edx,%ecx
c0105c49:	89 c2                	mov    %eax,%edx
c0105c4b:	89 ce                	mov    %ecx,%esi
c0105c4d:	89 d7                	mov    %edx,%edi
c0105c4f:	ac                   	lods   %ds:(%esi),%al
c0105c50:	ae                   	scas   %es:(%edi),%al
c0105c51:	75 08                	jne    c0105c5b <strcmp+0x2e>
c0105c53:	84 c0                	test   %al,%al
c0105c55:	75 f8                	jne    c0105c4f <strcmp+0x22>
c0105c57:	31 c0                	xor    %eax,%eax
c0105c59:	eb 04                	jmp    c0105c5f <strcmp+0x32>
c0105c5b:	19 c0                	sbb    %eax,%eax
c0105c5d:	0c 01                	or     $0x1,%al
c0105c5f:	89 fa                	mov    %edi,%edx
c0105c61:	89 f1                	mov    %esi,%ecx
c0105c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c66:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105c6f:	83 c4 20             	add    $0x20,%esp
c0105c72:	5e                   	pop    %esi
c0105c73:	5f                   	pop    %edi
c0105c74:	5d                   	pop    %ebp
c0105c75:	c3                   	ret    

c0105c76 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105c76:	55                   	push   %ebp
c0105c77:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c79:	eb 0c                	jmp    c0105c87 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105c7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c8b:	74 1a                	je     c0105ca7 <strncmp+0x31>
c0105c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c90:	0f b6 00             	movzbl (%eax),%eax
c0105c93:	84 c0                	test   %al,%al
c0105c95:	74 10                	je     c0105ca7 <strncmp+0x31>
c0105c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9a:	0f b6 10             	movzbl (%eax),%edx
c0105c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ca0:	0f b6 00             	movzbl (%eax),%eax
c0105ca3:	38 c2                	cmp    %al,%dl
c0105ca5:	74 d4                	je     c0105c7b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ca7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cab:	74 18                	je     c0105cc5 <strncmp+0x4f>
c0105cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb0:	0f b6 00             	movzbl (%eax),%eax
c0105cb3:	0f b6 d0             	movzbl %al,%edx
c0105cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb9:	0f b6 00             	movzbl (%eax),%eax
c0105cbc:	0f b6 c0             	movzbl %al,%eax
c0105cbf:	29 c2                	sub    %eax,%edx
c0105cc1:	89 d0                	mov    %edx,%eax
c0105cc3:	eb 05                	jmp    c0105cca <strncmp+0x54>
c0105cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cca:	5d                   	pop    %ebp
c0105ccb:	c3                   	ret    

c0105ccc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105ccc:	55                   	push   %ebp
c0105ccd:	89 e5                	mov    %esp,%ebp
c0105ccf:	83 ec 04             	sub    $0x4,%esp
c0105cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105cd8:	eb 14                	jmp    c0105cee <strchr+0x22>
        if (*s == c) {
c0105cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdd:	0f b6 00             	movzbl (%eax),%eax
c0105ce0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ce3:	75 05                	jne    c0105cea <strchr+0x1e>
            return (char *)s;
c0105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce8:	eb 13                	jmp    c0105cfd <strchr+0x31>
        }
        s ++;
c0105cea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf1:	0f b6 00             	movzbl (%eax),%eax
c0105cf4:	84 c0                	test   %al,%al
c0105cf6:	75 e2                	jne    c0105cda <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cfd:	c9                   	leave  
c0105cfe:	c3                   	ret    

c0105cff <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105cff:	55                   	push   %ebp
c0105d00:	89 e5                	mov    %esp,%ebp
c0105d02:	83 ec 04             	sub    $0x4,%esp
c0105d05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d08:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105d0b:	eb 11                	jmp    c0105d1e <strfind+0x1f>
        if (*s == c) {
c0105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d10:	0f b6 00             	movzbl (%eax),%eax
c0105d13:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105d16:	75 02                	jne    c0105d1a <strfind+0x1b>
            break;
c0105d18:	eb 0e                	jmp    c0105d28 <strfind+0x29>
        }
        s ++;
c0105d1a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d21:	0f b6 00             	movzbl (%eax),%eax
c0105d24:	84 c0                	test   %al,%al
c0105d26:	75 e5                	jne    c0105d0d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105d28:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d2b:	c9                   	leave  
c0105d2c:	c3                   	ret    

c0105d2d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105d2d:	55                   	push   %ebp
c0105d2e:	89 e5                	mov    %esp,%ebp
c0105d30:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105d33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105d3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d41:	eb 04                	jmp    c0105d47 <strtol+0x1a>
        s ++;
c0105d43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4a:	0f b6 00             	movzbl (%eax),%eax
c0105d4d:	3c 20                	cmp    $0x20,%al
c0105d4f:	74 f2                	je     c0105d43 <strtol+0x16>
c0105d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d54:	0f b6 00             	movzbl (%eax),%eax
c0105d57:	3c 09                	cmp    $0x9,%al
c0105d59:	74 e8                	je     c0105d43 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5e:	0f b6 00             	movzbl (%eax),%eax
c0105d61:	3c 2b                	cmp    $0x2b,%al
c0105d63:	75 06                	jne    c0105d6b <strtol+0x3e>
        s ++;
c0105d65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d69:	eb 15                	jmp    c0105d80 <strtol+0x53>
    }
    else if (*s == '-') {
c0105d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6e:	0f b6 00             	movzbl (%eax),%eax
c0105d71:	3c 2d                	cmp    $0x2d,%al
c0105d73:	75 0b                	jne    c0105d80 <strtol+0x53>
        s ++, neg = 1;
c0105d75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d79:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d84:	74 06                	je     c0105d8c <strtol+0x5f>
c0105d86:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d8a:	75 24                	jne    c0105db0 <strtol+0x83>
c0105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8f:	0f b6 00             	movzbl (%eax),%eax
c0105d92:	3c 30                	cmp    $0x30,%al
c0105d94:	75 1a                	jne    c0105db0 <strtol+0x83>
c0105d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d99:	83 c0 01             	add    $0x1,%eax
c0105d9c:	0f b6 00             	movzbl (%eax),%eax
c0105d9f:	3c 78                	cmp    $0x78,%al
c0105da1:	75 0d                	jne    c0105db0 <strtol+0x83>
        s += 2, base = 16;
c0105da3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105da7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105dae:	eb 2a                	jmp    c0105dda <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105db4:	75 17                	jne    c0105dcd <strtol+0xa0>
c0105db6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db9:	0f b6 00             	movzbl (%eax),%eax
c0105dbc:	3c 30                	cmp    $0x30,%al
c0105dbe:	75 0d                	jne    c0105dcd <strtol+0xa0>
        s ++, base = 8;
c0105dc0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dc4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105dcb:	eb 0d                	jmp    c0105dda <strtol+0xad>
    }
    else if (base == 0) {
c0105dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dd1:	75 07                	jne    c0105dda <strtol+0xad>
        base = 10;
c0105dd3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105dda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ddd:	0f b6 00             	movzbl (%eax),%eax
c0105de0:	3c 2f                	cmp    $0x2f,%al
c0105de2:	7e 1b                	jle    c0105dff <strtol+0xd2>
c0105de4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de7:	0f b6 00             	movzbl (%eax),%eax
c0105dea:	3c 39                	cmp    $0x39,%al
c0105dec:	7f 11                	jg     c0105dff <strtol+0xd2>
            dig = *s - '0';
c0105dee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df1:	0f b6 00             	movzbl (%eax),%eax
c0105df4:	0f be c0             	movsbl %al,%eax
c0105df7:	83 e8 30             	sub    $0x30,%eax
c0105dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dfd:	eb 48                	jmp    c0105e47 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e02:	0f b6 00             	movzbl (%eax),%eax
c0105e05:	3c 60                	cmp    $0x60,%al
c0105e07:	7e 1b                	jle    c0105e24 <strtol+0xf7>
c0105e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e0c:	0f b6 00             	movzbl (%eax),%eax
c0105e0f:	3c 7a                	cmp    $0x7a,%al
c0105e11:	7f 11                	jg     c0105e24 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e16:	0f b6 00             	movzbl (%eax),%eax
c0105e19:	0f be c0             	movsbl %al,%eax
c0105e1c:	83 e8 57             	sub    $0x57,%eax
c0105e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e22:	eb 23                	jmp    c0105e47 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105e24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e27:	0f b6 00             	movzbl (%eax),%eax
c0105e2a:	3c 40                	cmp    $0x40,%al
c0105e2c:	7e 3d                	jle    c0105e6b <strtol+0x13e>
c0105e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e31:	0f b6 00             	movzbl (%eax),%eax
c0105e34:	3c 5a                	cmp    $0x5a,%al
c0105e36:	7f 33                	jg     c0105e6b <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3b:	0f b6 00             	movzbl (%eax),%eax
c0105e3e:	0f be c0             	movsbl %al,%eax
c0105e41:	83 e8 37             	sub    $0x37,%eax
c0105e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e4a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e4d:	7c 02                	jl     c0105e51 <strtol+0x124>
            break;
c0105e4f:	eb 1a                	jmp    c0105e6b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105e51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e58:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e5c:	89 c2                	mov    %eax,%edx
c0105e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e61:	01 d0                	add    %edx,%eax
c0105e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105e66:	e9 6f ff ff ff       	jmp    c0105dda <strtol+0xad>

    if (endptr) {
c0105e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e6f:	74 08                	je     c0105e79 <strtol+0x14c>
        *endptr = (char *) s;
c0105e71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e74:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e77:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105e7d:	74 07                	je     c0105e86 <strtol+0x159>
c0105e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e82:	f7 d8                	neg    %eax
c0105e84:	eb 03                	jmp    c0105e89 <strtol+0x15c>
c0105e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e89:	c9                   	leave  
c0105e8a:	c3                   	ret    

c0105e8b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e8b:	55                   	push   %ebp
c0105e8c:	89 e5                	mov    %esp,%ebp
c0105e8e:	57                   	push   %edi
c0105e8f:	83 ec 24             	sub    $0x24,%esp
c0105e92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e95:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e98:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105e9c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105ea2:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105ea5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105eab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105eae:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105eb2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105eb5:	89 d7                	mov    %edx,%edi
c0105eb7:	f3 aa                	rep stos %al,%es:(%edi)
c0105eb9:	89 fa                	mov    %edi,%edx
c0105ebb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ebe:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105ec4:	83 c4 24             	add    $0x24,%esp
c0105ec7:	5f                   	pop    %edi
c0105ec8:	5d                   	pop    %ebp
c0105ec9:	c3                   	ret    

c0105eca <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105eca:	55                   	push   %ebp
c0105ecb:	89 e5                	mov    %esp,%ebp
c0105ecd:	57                   	push   %edi
c0105ece:	56                   	push   %esi
c0105ecf:	53                   	push   %ebx
c0105ed0:	83 ec 30             	sub    $0x30,%esp
c0105ed3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105edf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ee2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105eeb:	73 42                	jae    c0105f2f <memmove+0x65>
c0105eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ef0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105efc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105eff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f02:	c1 e8 02             	shr    $0x2,%eax
c0105f05:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f0d:	89 d7                	mov    %edx,%edi
c0105f0f:	89 c6                	mov    %eax,%esi
c0105f11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f13:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f16:	83 e1 03             	and    $0x3,%ecx
c0105f19:	74 02                	je     c0105f1d <memmove+0x53>
c0105f1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f1d:	89 f0                	mov    %esi,%eax
c0105f1f:	89 fa                	mov    %edi,%edx
c0105f21:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105f24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105f27:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f2d:	eb 36                	jmp    c0105f65 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f32:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f38:	01 c2                	add    %eax,%edx
c0105f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f3d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f43:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f49:	89 c1                	mov    %eax,%ecx
c0105f4b:	89 d8                	mov    %ebx,%eax
c0105f4d:	89 d6                	mov    %edx,%esi
c0105f4f:	89 c7                	mov    %eax,%edi
c0105f51:	fd                   	std    
c0105f52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f54:	fc                   	cld    
c0105f55:	89 f8                	mov    %edi,%eax
c0105f57:	89 f2                	mov    %esi,%edx
c0105f59:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f5c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105f65:	83 c4 30             	add    $0x30,%esp
c0105f68:	5b                   	pop    %ebx
c0105f69:	5e                   	pop    %esi
c0105f6a:	5f                   	pop    %edi
c0105f6b:	5d                   	pop    %ebp
c0105f6c:	c3                   	ret    

c0105f6d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105f6d:	55                   	push   %ebp
c0105f6e:	89 e5                	mov    %esp,%ebp
c0105f70:	57                   	push   %edi
c0105f71:	56                   	push   %esi
c0105f72:	83 ec 20             	sub    $0x20,%esp
c0105f75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f81:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f84:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f8a:	c1 e8 02             	shr    $0x2,%eax
c0105f8d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f95:	89 d7                	mov    %edx,%edi
c0105f97:	89 c6                	mov    %eax,%esi
c0105f99:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f9b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f9e:	83 e1 03             	and    $0x3,%ecx
c0105fa1:	74 02                	je     c0105fa5 <memcpy+0x38>
c0105fa3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105fa5:	89 f0                	mov    %esi,%eax
c0105fa7:	89 fa                	mov    %edi,%edx
c0105fa9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105fac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105faf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105fb5:	83 c4 20             	add    $0x20,%esp
c0105fb8:	5e                   	pop    %esi
c0105fb9:	5f                   	pop    %edi
c0105fba:	5d                   	pop    %ebp
c0105fbb:	c3                   	ret    

c0105fbc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105fbc:	55                   	push   %ebp
c0105fbd:	89 e5                	mov    %esp,%ebp
c0105fbf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105fc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105fce:	eb 30                	jmp    c0106000 <memcmp+0x44>
        if (*s1 != *s2) {
c0105fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105fd3:	0f b6 10             	movzbl (%eax),%edx
c0105fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fd9:	0f b6 00             	movzbl (%eax),%eax
c0105fdc:	38 c2                	cmp    %al,%dl
c0105fde:	74 18                	je     c0105ff8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105fe3:	0f b6 00             	movzbl (%eax),%eax
c0105fe6:	0f b6 d0             	movzbl %al,%edx
c0105fe9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fec:	0f b6 00             	movzbl (%eax),%eax
c0105fef:	0f b6 c0             	movzbl %al,%eax
c0105ff2:	29 c2                	sub    %eax,%edx
c0105ff4:	89 d0                	mov    %edx,%eax
c0105ff6:	eb 1a                	jmp    c0106012 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105ff8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ffc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106000:	8b 45 10             	mov    0x10(%ebp),%eax
c0106003:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106006:	89 55 10             	mov    %edx,0x10(%ebp)
c0106009:	85 c0                	test   %eax,%eax
c010600b:	75 c3                	jne    c0105fd0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010600d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106012:	c9                   	leave  
c0106013:	c3                   	ret    
