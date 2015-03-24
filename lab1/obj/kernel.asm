
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 d2 32 00 00       	call   1032fe <memset>

    cons_init();                // init the console
  10002c:	e8 4f 15 00 00       	call   101580 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 a0 34 10 00 	movl   $0x1034a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 bc 34 10 00 	movl   $0x1034bc,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 ea 28 00 00       	call   102944 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 64 16 00 00       	call   1016c3 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 b6 17 00 00       	call   10181a <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 0a 0d 00 00       	call   100d73 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 c3 15 00 00       	call   101631 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 13 0c 00 00       	call   100ca5 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 c1 34 10 00 	movl   $0x1034c1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 cf 34 10 00 	movl   $0x1034cf,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 dd 34 10 00 	movl   $0x1034dd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 eb 34 10 00 	movl   $0x1034eb,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 f9 34 10 00 	movl   $0x1034f9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 08 35 10 00 	movl   $0x103508,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 47 35 10 00 	movl   $0x103547,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 dc 12 00 00       	call   1015ac <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 0a 28 00 00       	call   102b17 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 63 12 00 00       	call   1015ac <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 30 12 00 00       	call   1015d5 <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 4c 35 10 00    	movl   $0x10354c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 4c 35 10 00 	movl   $0x10354c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 ac 3d 10 00 	movl   $0x103dac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 34 b5 10 00 	movl   $0x10b534,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 35 b5 10 00 	movl   $0x10b535,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 2a d5 10 00 	movl   $0x10d52a,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 b0 2a 00 00       	call   103172 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 56 35 10 00 	movl   $0x103556,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 6f 35 10 00 	movl   $0x10356f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 87 34 10 	movl   $0x103487,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 87 35 10 00 	movl   $0x103587,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 9f 35 10 00 	movl   $0x10359f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 b7 35 10 00 	movl   $0x1035b7,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 d0 35 10 00 	movl   $0x1035d0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 fa 35 10 00 	movl   $0x1035fa,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 16 36 10 00 	movl   $0x103616,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i=0, j=0;
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
  1009b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009be:	e9 94 00 00 00       	jmp    100a57 <print_stackframe+0xc7>
	{
		//print ebp and eip;
		cprintf("ebp:0x%80x eip:0x%80x ", ebp, eip);
  1009c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d1:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  1009d8:	e8 35 f9 ff ff       	call   100312 <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
  1009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e0:	83 c0 08             	add    $0x8,%eax
  1009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//print arguments;
		cprintf(" args:");
  1009e6:	c7 04 24 3f 36 10 00 	movl   $0x10363f,(%esp)
  1009ed:	e8 20 f9 ff ff       	call   100312 <cprintf>
		for(j=0; j<4; j++)
  1009f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009f9:	eb 25                	jmp    100a20 <print_stackframe+0x90>
			cprintf("0x%80x ", args[j]);
  1009fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a08:	01 d0                	add    %edx,%eax
  100a0a:	8b 00                	mov    (%eax),%eax
  100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a10:	c7 04 24 46 36 10 00 	movl   $0x103646,(%esp)
  100a17:	e8 f6 f8 ff ff       	call   100312 <cprintf>
		//print ebp and eip;
		cprintf("ebp:0x%80x eip:0x%80x ", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		//print arguments;
		cprintf(" args:");
		for(j=0; j<4; j++)
  100a1c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a20:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a24:	7e d5                	jle    1009fb <print_stackframe+0x6b>
			cprintf("0x%80x ", args[j]);
		cprintf("\n");
  100a26:	c7 04 24 4e 36 10 00 	movl   $0x10364e,(%esp)
  100a2d:	e8 e0 f8 ff ff       	call   100312 <cprintf>
		//call print_debuginfo(eip-1)
		print_debuginfo(eip-1);
  100a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a35:	83 e8 01             	sub    $0x1,%eax
  100a38:	89 04 24             	mov    %eax,(%esp)
  100a3b:	e8 9c fe ff ff       	call   1008dc <print_debuginfo>
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
  100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a43:	83 c0 04             	add    $0x4,%eax
  100a46:	8b 00                	mov    (%eax),%eax
  100a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4e:	8b 00                	mov    (%eax),%eax
  100a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
print_stackframe(void) {
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i=0, j=0;
	for(i=0; i<STACKFRAME_DEPTH && ebp!=0; i++)
  100a53:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a57:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a5b:	7f 0a                	jg     100a67 <print_stackframe+0xd7>
  100a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a61:	0f 85 5c ff ff ff    	jne    1009c3 <print_stackframe+0x33>
		print_debuginfo(eip-1);
		//popup a calling stackframe;
		eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
	return;
  100a67:	90                   	nop
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a68:	c9                   	leave  
  100a69:	c3                   	ret    

00100a6a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a6a:	55                   	push   %ebp
  100a6b:	89 e5                	mov    %esp,%ebp
  100a6d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a77:	eb 0c                	jmp    100a85 <parse+0x1b>
            *buf ++ = '\0';
  100a79:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7c:	8d 50 01             	lea    0x1(%eax),%edx
  100a7f:	89 55 08             	mov    %edx,0x8(%ebp)
  100a82:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a85:	8b 45 08             	mov    0x8(%ebp),%eax
  100a88:	0f b6 00             	movzbl (%eax),%eax
  100a8b:	84 c0                	test   %al,%al
  100a8d:	74 1d                	je     100aac <parse+0x42>
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	0f b6 00             	movzbl (%eax),%eax
  100a95:	0f be c0             	movsbl %al,%eax
  100a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a9c:	c7 04 24 d0 36 10 00 	movl   $0x1036d0,(%esp)
  100aa3:	e8 97 26 00 00       	call   10313f <strchr>
  100aa8:	85 c0                	test   %eax,%eax
  100aaa:	75 cd                	jne    100a79 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aac:	8b 45 08             	mov    0x8(%ebp),%eax
  100aaf:	0f b6 00             	movzbl (%eax),%eax
  100ab2:	84 c0                	test   %al,%al
  100ab4:	75 02                	jne    100ab8 <parse+0x4e>
            break;
  100ab6:	eb 67                	jmp    100b1f <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ab8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100abc:	75 14                	jne    100ad2 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100abe:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ac5:	00 
  100ac6:	c7 04 24 d5 36 10 00 	movl   $0x1036d5,(%esp)
  100acd:	e8 40 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad5:	8d 50 01             	lea    0x1(%eax),%edx
  100ad8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100adb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae5:	01 c2                	add    %eax,%edx
  100ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aea:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aec:	eb 04                	jmp    100af2 <parse+0x88>
            buf ++;
  100aee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af2:	8b 45 08             	mov    0x8(%ebp),%eax
  100af5:	0f b6 00             	movzbl (%eax),%eax
  100af8:	84 c0                	test   %al,%al
  100afa:	74 1d                	je     100b19 <parse+0xaf>
  100afc:	8b 45 08             	mov    0x8(%ebp),%eax
  100aff:	0f b6 00             	movzbl (%eax),%eax
  100b02:	0f be c0             	movsbl %al,%eax
  100b05:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b09:	c7 04 24 d0 36 10 00 	movl   $0x1036d0,(%esp)
  100b10:	e8 2a 26 00 00       	call   10313f <strchr>
  100b15:	85 c0                	test   %eax,%eax
  100b17:	74 d5                	je     100aee <parse+0x84>
            buf ++;
        }
    }
  100b19:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b1a:	e9 66 ff ff ff       	jmp    100a85 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b22:	c9                   	leave  
  100b23:	c3                   	ret    

00100b24 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b24:	55                   	push   %ebp
  100b25:	89 e5                	mov    %esp,%ebp
  100b27:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b2a:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b31:	8b 45 08             	mov    0x8(%ebp),%eax
  100b34:	89 04 24             	mov    %eax,(%esp)
  100b37:	e8 2e ff ff ff       	call   100a6a <parse>
  100b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b43:	75 0a                	jne    100b4f <runcmd+0x2b>
        return 0;
  100b45:	b8 00 00 00 00       	mov    $0x0,%eax
  100b4a:	e9 85 00 00 00       	jmp    100bd4 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b56:	eb 5c                	jmp    100bb4 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b58:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b5e:	89 d0                	mov    %edx,%eax
  100b60:	01 c0                	add    %eax,%eax
  100b62:	01 d0                	add    %edx,%eax
  100b64:	c1 e0 02             	shl    $0x2,%eax
  100b67:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b6c:	8b 00                	mov    (%eax),%eax
  100b6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b72:	89 04 24             	mov    %eax,(%esp)
  100b75:	e8 26 25 00 00       	call   1030a0 <strcmp>
  100b7a:	85 c0                	test   %eax,%eax
  100b7c:	75 32                	jne    100bb0 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b81:	89 d0                	mov    %edx,%eax
  100b83:	01 c0                	add    %eax,%eax
  100b85:	01 d0                	add    %edx,%eax
  100b87:	c1 e0 02             	shl    $0x2,%eax
  100b8a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b8f:	8b 40 08             	mov    0x8(%eax),%eax
  100b92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b95:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b9f:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100ba2:	83 c2 04             	add    $0x4,%edx
  100ba5:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ba9:	89 0c 24             	mov    %ecx,(%esp)
  100bac:	ff d0                	call   *%eax
  100bae:	eb 24                	jmp    100bd4 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb7:	83 f8 02             	cmp    $0x2,%eax
  100bba:	76 9c                	jbe    100b58 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc3:	c7 04 24 f3 36 10 00 	movl   $0x1036f3,(%esp)
  100bca:	e8 43 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bd4:	c9                   	leave  
  100bd5:	c3                   	ret    

00100bd6 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bd6:	55                   	push   %ebp
  100bd7:	89 e5                	mov    %esp,%ebp
  100bd9:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bdc:	c7 04 24 0c 37 10 00 	movl   $0x10370c,(%esp)
  100be3:	e8 2a f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100be8:	c7 04 24 34 37 10 00 	movl   $0x103734,(%esp)
  100bef:	e8 1e f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bf8:	74 0b                	je     100c05 <kmonitor+0x2f>
        print_trapframe(tf);
  100bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  100bfd:	89 04 24             	mov    %eax,(%esp)
  100c00:	e8 da 0d 00 00       	call   1019df <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c05:	c7 04 24 59 37 10 00 	movl   $0x103759,(%esp)
  100c0c:	e8 f8 f5 ff ff       	call   100209 <readline>
  100c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c18:	74 18                	je     100c32 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c24:	89 04 24             	mov    %eax,(%esp)
  100c27:	e8 f8 fe ff ff       	call   100b24 <runcmd>
  100c2c:	85 c0                	test   %eax,%eax
  100c2e:	79 02                	jns    100c32 <kmonitor+0x5c>
                break;
  100c30:	eb 02                	jmp    100c34 <kmonitor+0x5e>
            }
        }
    }
  100c32:	eb d1                	jmp    100c05 <kmonitor+0x2f>
}
  100c34:	c9                   	leave  
  100c35:	c3                   	ret    

00100c36 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c36:	55                   	push   %ebp
  100c37:	89 e5                	mov    %esp,%ebp
  100c39:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c43:	eb 3f                	jmp    100c84 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c48:	89 d0                	mov    %edx,%eax
  100c4a:	01 c0                	add    %eax,%eax
  100c4c:	01 d0                	add    %edx,%eax
  100c4e:	c1 e0 02             	shl    $0x2,%eax
  100c51:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c56:	8b 48 04             	mov    0x4(%eax),%ecx
  100c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5c:	89 d0                	mov    %edx,%eax
  100c5e:	01 c0                	add    %eax,%eax
  100c60:	01 d0                	add    %edx,%eax
  100c62:	c1 e0 02             	shl    $0x2,%eax
  100c65:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c6a:	8b 00                	mov    (%eax),%eax
  100c6c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c74:	c7 04 24 5d 37 10 00 	movl   $0x10375d,(%esp)
  100c7b:	e8 92 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c87:	83 f8 02             	cmp    $0x2,%eax
  100c8a:	76 b9                	jbe    100c45 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c91:	c9                   	leave  
  100c92:	c3                   	ret    

00100c93 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c93:	55                   	push   %ebp
  100c94:	89 e5                	mov    %esp,%ebp
  100c96:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c99:	e8 a8 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca3:	c9                   	leave  
  100ca4:	c3                   	ret    

00100ca5 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ca5:	55                   	push   %ebp
  100ca6:	89 e5                	mov    %esp,%ebp
  100ca8:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cab:	e8 e0 fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb5:	c9                   	leave  
  100cb6:	c3                   	ret    

00100cb7 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cb7:	55                   	push   %ebp
  100cb8:	89 e5                	mov    %esp,%ebp
  100cba:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cbd:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cc2:	85 c0                	test   %eax,%eax
  100cc4:	74 02                	je     100cc8 <__panic+0x11>
        goto panic_dead;
  100cc6:	eb 48                	jmp    100d10 <__panic+0x59>
    }
    is_panic = 1;
  100cc8:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100ccf:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cd2:	8d 45 14             	lea    0x14(%ebp),%eax
  100cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce6:	c7 04 24 66 37 10 00 	movl   $0x103766,(%esp)
  100ced:	e8 20 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  100cfc:	89 04 24             	mov    %eax,(%esp)
  100cff:	e8 db f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d04:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100d0b:	e8 02 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d10:	e8 22 09 00 00       	call   101637 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d1c:	e8 b5 fe ff ff       	call   100bd6 <kmonitor>
    }
  100d21:	eb f2                	jmp    100d15 <__panic+0x5e>

00100d23 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d23:	55                   	push   %ebp
  100d24:	89 e5                	mov    %esp,%ebp
  100d26:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d29:	8d 45 14             	lea    0x14(%ebp),%eax
  100d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d32:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d36:	8b 45 08             	mov    0x8(%ebp),%eax
  100d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3d:	c7 04 24 84 37 10 00 	movl   $0x103784,(%esp)
  100d44:	e8 c9 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d50:	8b 45 10             	mov    0x10(%ebp),%eax
  100d53:	89 04 24             	mov    %eax,(%esp)
  100d56:	e8 84 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d5b:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100d62:	e8 ab f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d67:	c9                   	leave  
  100d68:	c3                   	ret    

00100d69 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d69:	55                   	push   %ebp
  100d6a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d6c:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d71:	5d                   	pop    %ebp
  100d72:	c3                   	ret    

00100d73 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d73:	55                   	push   %ebp
  100d74:	89 e5                	mov    %esp,%ebp
  100d76:	83 ec 28             	sub    $0x28,%esp
  100d79:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d7f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d83:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d87:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d8b:	ee                   	out    %al,(%dx)
  100d8c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d92:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d96:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d9a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9e:	ee                   	out    %al,(%dx)
  100d9f:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100da5:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dad:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db2:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100db9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dbc:	c7 04 24 a2 37 10 00 	movl   $0x1037a2,(%esp)
  100dc3:	e8 4a f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dcf:	e8 c1 08 00 00       	call   101695 <pic_enable>
}
  100dd4:	c9                   	leave  
  100dd5:	c3                   	ret    

00100dd6 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dd6:	55                   	push   %ebp
  100dd7:	89 e5                	mov    %esp,%ebp
  100dd9:	83 ec 10             	sub    $0x10,%esp
  100ddc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de6:	89 c2                	mov    %eax,%edx
  100de8:	ec                   	in     (%dx),%al
  100de9:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dec:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100df6:	89 c2                	mov    %eax,%edx
  100df8:	ec                   	in     (%dx),%al
  100df9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dfc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e02:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e06:	89 c2                	mov    %eax,%edx
  100e08:	ec                   	in     (%dx),%al
  100e09:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e0c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e12:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e16:	89 c2                	mov    %eax,%edx
  100e18:	ec                   	in     (%dx),%al
  100e19:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e1c:	c9                   	leave  
  100e1d:	c3                   	ret    

00100e1e <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e1e:	55                   	push   %ebp
  100e1f:	89 e5                	mov    %esp,%ebp
  100e21:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e24:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2e:	0f b7 00             	movzwl (%eax),%eax
  100e31:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e38:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e40:	0f b7 00             	movzwl (%eax),%eax
  100e43:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e47:	74 12                	je     100e5b <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e49:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e50:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e57:	b4 03 
  100e59:	eb 13                	jmp    100e6e <cga_init+0x50>
    } else {
        *cp = was;
  100e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e62:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e65:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e6c:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e6e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e75:	0f b7 c0             	movzwl %ax,%eax
  100e78:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e7c:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e80:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e84:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e88:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e89:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e90:	83 c0 01             	add    $0x1,%eax
  100e93:	0f b7 c0             	movzwl %ax,%eax
  100e96:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e9a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e9e:	89 c2                	mov    %eax,%edx
  100ea0:	ec                   	in     (%dx),%al
  100ea1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ea4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea8:	0f b6 c0             	movzbl %al,%eax
  100eab:	c1 e0 08             	shl    $0x8,%eax
  100eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eb1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb8:	0f b7 c0             	movzwl %ax,%eax
  100ebb:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ebf:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ecb:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ecc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed3:	83 c0 01             	add    $0x1,%eax
  100ed6:	0f b7 c0             	movzwl %ax,%eax
  100ed9:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100edd:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ee1:	89 c2                	mov    %eax,%edx
  100ee3:	ec                   	in     (%dx),%al
  100ee4:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ee7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eeb:	0f b6 c0             	movzbl %al,%eax
  100eee:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef4:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100efc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f02:	c9                   	leave  
  100f03:	c3                   	ret    

00100f04 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f04:	55                   	push   %ebp
  100f05:	89 e5                	mov    %esp,%ebp
  100f07:	83 ec 48             	sub    $0x48,%esp
  100f0a:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f10:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f14:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f18:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
  100f1d:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f23:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f27:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f2b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f2f:	ee                   	out    %al,(%dx)
  100f30:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f36:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f3a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f3e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f42:	ee                   	out    %al,(%dx)
  100f43:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f49:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f4d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f51:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f55:	ee                   	out    %al,(%dx)
  100f56:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f5c:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f60:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f64:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f6f:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f73:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f77:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f82:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f86:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f95:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f99:	89 c2                	mov    %eax,%edx
  100f9b:	ec                   	in     (%dx),%al
  100f9c:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f9f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa3:	3c ff                	cmp    $0xff,%al
  100fa5:	0f 95 c0             	setne  %al
  100fa8:	0f b6 c0             	movzbl %al,%eax
  100fab:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fb0:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb6:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fba:	89 c2                	mov    %eax,%edx
  100fbc:	ec                   	in     (%dx),%al
  100fbd:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fc0:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fc6:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fca:	89 c2                	mov    %eax,%edx
  100fcc:	ec                   	in     (%dx),%al
  100fcd:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fd0:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fd5:	85 c0                	test   %eax,%eax
  100fd7:	74 0c                	je     100fe5 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fe0:	e8 b0 06 00 00       	call   101695 <pic_enable>
    }
}
  100fe5:	c9                   	leave  
  100fe6:	c3                   	ret    

00100fe7 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fe7:	55                   	push   %ebp
  100fe8:	89 e5                	mov    %esp,%ebp
  100fea:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ff4:	eb 09                	jmp    100fff <lpt_putc_sub+0x18>
        delay();
  100ff6:	e8 db fd ff ff       	call   100dd6 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ffb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fff:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101005:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101009:	89 c2                	mov    %eax,%edx
  10100b:	ec                   	in     (%dx),%al
  10100c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10100f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101013:	84 c0                	test   %al,%al
  101015:	78 09                	js     101020 <lpt_putc_sub+0x39>
  101017:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10101e:	7e d6                	jle    100ff6 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101020:	8b 45 08             	mov    0x8(%ebp),%eax
  101023:	0f b6 c0             	movzbl %al,%eax
  101026:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10102c:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10102f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101033:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101037:	ee                   	out    %al,(%dx)
  101038:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10103e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101042:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101046:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10104a:	ee                   	out    %al,(%dx)
  10104b:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101051:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101055:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101059:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10105d:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10105e:	c9                   	leave  
  10105f:	c3                   	ret    

00101060 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101060:	55                   	push   %ebp
  101061:	89 e5                	mov    %esp,%ebp
  101063:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101066:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10106a:	74 0d                	je     101079 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	89 04 24             	mov    %eax,(%esp)
  101072:	e8 70 ff ff ff       	call   100fe7 <lpt_putc_sub>
  101077:	eb 24                	jmp    10109d <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101079:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101080:	e8 62 ff ff ff       	call   100fe7 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101085:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10108c:	e8 56 ff ff ff       	call   100fe7 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101091:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101098:	e8 4a ff ff ff       	call   100fe7 <lpt_putc_sub>
    }
}
  10109d:	c9                   	leave  
  10109e:	c3                   	ret    

0010109f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10109f:	55                   	push   %ebp
  1010a0:	89 e5                	mov    %esp,%ebp
  1010a2:	53                   	push   %ebx
  1010a3:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a9:	b0 00                	mov    $0x0,%al
  1010ab:	85 c0                	test   %eax,%eax
  1010ad:	75 07                	jne    1010b6 <cga_putc+0x17>
        c |= 0x0700;
  1010af:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b9:	0f b6 c0             	movzbl %al,%eax
  1010bc:	83 f8 0a             	cmp    $0xa,%eax
  1010bf:	74 4c                	je     10110d <cga_putc+0x6e>
  1010c1:	83 f8 0d             	cmp    $0xd,%eax
  1010c4:	74 57                	je     10111d <cga_putc+0x7e>
  1010c6:	83 f8 08             	cmp    $0x8,%eax
  1010c9:	0f 85 88 00 00 00    	jne    101157 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010cf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d6:	66 85 c0             	test   %ax,%ax
  1010d9:	74 30                	je     10110b <cga_putc+0x6c>
            crt_pos --;
  1010db:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e2:	83 e8 01             	sub    $0x1,%eax
  1010e5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010eb:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010f0:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010f7:	0f b7 d2             	movzwl %dx,%edx
  1010fa:	01 d2                	add    %edx,%edx
  1010fc:	01 c2                	add    %eax,%edx
  1010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101101:	b0 00                	mov    $0x0,%al
  101103:	83 c8 20             	or     $0x20,%eax
  101106:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101109:	eb 72                	jmp    10117d <cga_putc+0xde>
  10110b:	eb 70                	jmp    10117d <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10110d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101114:	83 c0 50             	add    $0x50,%eax
  101117:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10111d:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101124:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10112b:	0f b7 c1             	movzwl %cx,%eax
  10112e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101134:	c1 e8 10             	shr    $0x10,%eax
  101137:	89 c2                	mov    %eax,%edx
  101139:	66 c1 ea 06          	shr    $0x6,%dx
  10113d:	89 d0                	mov    %edx,%eax
  10113f:	c1 e0 02             	shl    $0x2,%eax
  101142:	01 d0                	add    %edx,%eax
  101144:	c1 e0 04             	shl    $0x4,%eax
  101147:	29 c1                	sub    %eax,%ecx
  101149:	89 ca                	mov    %ecx,%edx
  10114b:	89 d8                	mov    %ebx,%eax
  10114d:	29 d0                	sub    %edx,%eax
  10114f:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101155:	eb 26                	jmp    10117d <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101157:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10115d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101164:	8d 50 01             	lea    0x1(%eax),%edx
  101167:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10116e:	0f b7 c0             	movzwl %ax,%eax
  101171:	01 c0                	add    %eax,%eax
  101173:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101176:	8b 45 08             	mov    0x8(%ebp),%eax
  101179:	66 89 02             	mov    %ax,(%edx)
        break;
  10117c:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10117d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101184:	66 3d cf 07          	cmp    $0x7cf,%ax
  101188:	76 5b                	jbe    1011e5 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10118a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101195:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119a:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a1:	00 
  1011a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a6:	89 04 24             	mov    %eax,(%esp)
  1011a9:	e8 8f 21 00 00       	call   10333d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ae:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011b5:	eb 15                	jmp    1011cc <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011b7:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011bf:	01 d2                	add    %edx,%edx
  1011c1:	01 d0                	add    %edx,%eax
  1011c3:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011cc:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d3:	7e e2                	jle    1011b7 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011dc:	83 e8 50             	sub    $0x50,%eax
  1011df:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011e5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011ec:	0f b7 c0             	movzwl %ax,%eax
  1011ef:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011f3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011f7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011fb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011ff:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101200:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101207:	66 c1 e8 08          	shr    $0x8,%ax
  10120b:	0f b6 c0             	movzbl %al,%eax
  10120e:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101215:	83 c2 01             	add    $0x1,%edx
  101218:	0f b7 d2             	movzwl %dx,%edx
  10121b:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10121f:	88 45 ed             	mov    %al,-0x13(%ebp)
  101222:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101226:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10122a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10122b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101232:	0f b7 c0             	movzwl %ax,%eax
  101235:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101239:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10123d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101241:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101245:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101246:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10124d:	0f b6 c0             	movzbl %al,%eax
  101250:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101257:	83 c2 01             	add    $0x1,%edx
  10125a:	0f b7 d2             	movzwl %dx,%edx
  10125d:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101261:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101264:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101268:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10126c:	ee                   	out    %al,(%dx)
}
  10126d:	83 c4 34             	add    $0x34,%esp
  101270:	5b                   	pop    %ebx
  101271:	5d                   	pop    %ebp
  101272:	c3                   	ret    

00101273 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101273:	55                   	push   %ebp
  101274:	89 e5                	mov    %esp,%ebp
  101276:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101280:	eb 09                	jmp    10128b <serial_putc_sub+0x18>
        delay();
  101282:	e8 4f fb ff ff       	call   100dd6 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10128b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101291:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101295:	89 c2                	mov    %eax,%edx
  101297:	ec                   	in     (%dx),%al
  101298:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10129b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10129f:	0f b6 c0             	movzbl %al,%eax
  1012a2:	83 e0 20             	and    $0x20,%eax
  1012a5:	85 c0                	test   %eax,%eax
  1012a7:	75 09                	jne    1012b2 <serial_putc_sub+0x3f>
  1012a9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b0:	7e d0                	jle    101282 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b5:	0f b6 c0             	movzbl %al,%eax
  1012b8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012be:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012c9:	ee                   	out    %al,(%dx)
}
  1012ca:	c9                   	leave  
  1012cb:	c3                   	ret    

001012cc <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012cc:	55                   	push   %ebp
  1012cd:	89 e5                	mov    %esp,%ebp
  1012cf:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012d6:	74 0d                	je     1012e5 <serial_putc+0x19>
        serial_putc_sub(c);
  1012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012db:	89 04 24             	mov    %eax,(%esp)
  1012de:	e8 90 ff ff ff       	call   101273 <serial_putc_sub>
  1012e3:	eb 24                	jmp    101309 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012e5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012ec:	e8 82 ff ff ff       	call   101273 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012f8:	e8 76 ff ff ff       	call   101273 <serial_putc_sub>
        serial_putc_sub('\b');
  1012fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101304:	e8 6a ff ff ff       	call   101273 <serial_putc_sub>
    }
}
  101309:	c9                   	leave  
  10130a:	c3                   	ret    

0010130b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10130b:	55                   	push   %ebp
  10130c:	89 e5                	mov    %esp,%ebp
  10130e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101311:	eb 33                	jmp    101346 <cons_intr+0x3b>
        if (c != 0) {
  101313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101317:	74 2d                	je     101346 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101319:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131e:	8d 50 01             	lea    0x1(%eax),%edx
  101321:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10132a:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101330:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101335:	3d 00 02 00 00       	cmp    $0x200,%eax
  10133a:	75 0a                	jne    101346 <cons_intr+0x3b>
                cons.wpos = 0;
  10133c:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101343:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101346:	8b 45 08             	mov    0x8(%ebp),%eax
  101349:	ff d0                	call   *%eax
  10134b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10134e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101352:	75 bf                	jne    101313 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101354:	c9                   	leave  
  101355:	c3                   	ret    

00101356 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101356:	55                   	push   %ebp
  101357:	89 e5                	mov    %esp,%ebp
  101359:	83 ec 10             	sub    $0x10,%esp
  10135c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101362:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101366:	89 c2                	mov    %eax,%edx
  101368:	ec                   	in     (%dx),%al
  101369:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10136c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101370:	0f b6 c0             	movzbl %al,%eax
  101373:	83 e0 01             	and    $0x1,%eax
  101376:	85 c0                	test   %eax,%eax
  101378:	75 07                	jne    101381 <serial_proc_data+0x2b>
        return -1;
  10137a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10137f:	eb 2a                	jmp    1013ab <serial_proc_data+0x55>
  101381:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101387:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10138b:	89 c2                	mov    %eax,%edx
  10138d:	ec                   	in     (%dx),%al
  10138e:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101391:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101395:	0f b6 c0             	movzbl %al,%eax
  101398:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10139b:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10139f:	75 07                	jne    1013a8 <serial_proc_data+0x52>
        c = '\b';
  1013a1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b3:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013b8:	85 c0                	test   %eax,%eax
  1013ba:	74 0c                	je     1013c8 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013bc:	c7 04 24 56 13 10 00 	movl   $0x101356,(%esp)
  1013c3:	e8 43 ff ff ff       	call   10130b <cons_intr>
    }
}
  1013c8:	c9                   	leave  
  1013c9:	c3                   	ret    

001013ca <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ca:	55                   	push   %ebp
  1013cb:	89 e5                	mov    %esp,%ebp
  1013cd:	83 ec 38             	sub    $0x38,%esp
  1013d0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013da:	89 c2                	mov    %eax,%edx
  1013dc:	ec                   	in     (%dx),%al
  1013dd:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013e4:	0f b6 c0             	movzbl %al,%eax
  1013e7:	83 e0 01             	and    $0x1,%eax
  1013ea:	85 c0                	test   %eax,%eax
  1013ec:	75 0a                	jne    1013f8 <kbd_proc_data+0x2e>
        return -1;
  1013ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f3:	e9 59 01 00 00       	jmp    101551 <kbd_proc_data+0x187>
  1013f8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013fe:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101402:	89 c2                	mov    %eax,%edx
  101404:	ec                   	in     (%dx),%al
  101405:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101408:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10140c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10140f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101413:	75 17                	jne    10142c <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101415:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141a:	83 c8 40             	or     $0x40,%eax
  10141d:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101422:	b8 00 00 00 00       	mov    $0x0,%eax
  101427:	e9 25 01 00 00       	jmp    101551 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10142c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101430:	84 c0                	test   %al,%al
  101432:	79 47                	jns    10147b <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101434:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101439:	83 e0 40             	and    $0x40,%eax
  10143c:	85 c0                	test   %eax,%eax
  10143e:	75 09                	jne    101449 <kbd_proc_data+0x7f>
  101440:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101444:	83 e0 7f             	and    $0x7f,%eax
  101447:	eb 04                	jmp    10144d <kbd_proc_data+0x83>
  101449:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101450:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101454:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10145b:	83 c8 40             	or     $0x40,%eax
  10145e:	0f b6 c0             	movzbl %al,%eax
  101461:	f7 d0                	not    %eax
  101463:	89 c2                	mov    %eax,%edx
  101465:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146a:	21 d0                	and    %edx,%eax
  10146c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101471:	b8 00 00 00 00       	mov    $0x0,%eax
  101476:	e9 d6 00 00 00       	jmp    101551 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10147b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101480:	83 e0 40             	and    $0x40,%eax
  101483:	85 c0                	test   %eax,%eax
  101485:	74 11                	je     101498 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101487:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10148b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101490:	83 e0 bf             	and    $0xffffffbf,%eax
  101493:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101498:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149c:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a3:	0f b6 d0             	movzbl %al,%edx
  1014a6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ab:	09 d0                	or     %edx,%eax
  1014ad:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b6:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014bd:	0f b6 d0             	movzbl %al,%edx
  1014c0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c5:	31 d0                	xor    %edx,%eax
  1014c7:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014cc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d1:	83 e0 03             	and    $0x3,%eax
  1014d4:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014db:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014df:	01 d0                	add    %edx,%eax
  1014e1:	0f b6 00             	movzbl (%eax),%eax
  1014e4:	0f b6 c0             	movzbl %al,%eax
  1014e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014ea:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ef:	83 e0 08             	and    $0x8,%eax
  1014f2:	85 c0                	test   %eax,%eax
  1014f4:	74 22                	je     101518 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014f6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014fa:	7e 0c                	jle    101508 <kbd_proc_data+0x13e>
  1014fc:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101500:	7f 06                	jg     101508 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101502:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101506:	eb 10                	jmp    101518 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101508:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10150c:	7e 0a                	jle    101518 <kbd_proc_data+0x14e>
  10150e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101512:	7f 04                	jg     101518 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101514:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101518:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10151d:	f7 d0                	not    %eax
  10151f:	83 e0 06             	and    $0x6,%eax
  101522:	85 c0                	test   %eax,%eax
  101524:	75 28                	jne    10154e <kbd_proc_data+0x184>
  101526:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10152d:	75 1f                	jne    10154e <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10152f:	c7 04 24 bd 37 10 00 	movl   $0x1037bd,(%esp)
  101536:	e8 d7 ed ff ff       	call   100312 <cprintf>
  10153b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101541:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101545:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101549:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10154d:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10154e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101551:	c9                   	leave  
  101552:	c3                   	ret    

00101553 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101553:	55                   	push   %ebp
  101554:	89 e5                	mov    %esp,%ebp
  101556:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101559:	c7 04 24 ca 13 10 00 	movl   $0x1013ca,(%esp)
  101560:	e8 a6 fd ff ff       	call   10130b <cons_intr>
}
  101565:	c9                   	leave  
  101566:	c3                   	ret    

00101567 <kbd_init>:

static void
kbd_init(void) {
  101567:	55                   	push   %ebp
  101568:	89 e5                	mov    %esp,%ebp
  10156a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10156d:	e8 e1 ff ff ff       	call   101553 <kbd_intr>
    pic_enable(IRQ_KBD);
  101572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101579:	e8 17 01 00 00       	call   101695 <pic_enable>
}
  10157e:	c9                   	leave  
  10157f:	c3                   	ret    

00101580 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101580:	55                   	push   %ebp
  101581:	89 e5                	mov    %esp,%ebp
  101583:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101586:	e8 93 f8 ff ff       	call   100e1e <cga_init>
    serial_init();
  10158b:	e8 74 f9 ff ff       	call   100f04 <serial_init>
    kbd_init();
  101590:	e8 d2 ff ff ff       	call   101567 <kbd_init>
    if (!serial_exists) {
  101595:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10159a:	85 c0                	test   %eax,%eax
  10159c:	75 0c                	jne    1015aa <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10159e:	c7 04 24 c9 37 10 00 	movl   $0x1037c9,(%esp)
  1015a5:	e8 68 ed ff ff       	call   100312 <cprintf>
    }
}
  1015aa:	c9                   	leave  
  1015ab:	c3                   	ret    

001015ac <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ac:	55                   	push   %ebp
  1015ad:	89 e5                	mov    %esp,%ebp
  1015af:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b5:	89 04 24             	mov    %eax,(%esp)
  1015b8:	e8 a3 fa ff ff       	call   101060 <lpt_putc>
    cga_putc(c);
  1015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c0:	89 04 24             	mov    %eax,(%esp)
  1015c3:	e8 d7 fa ff ff       	call   10109f <cga_putc>
    serial_putc(c);
  1015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015cb:	89 04 24             	mov    %eax,(%esp)
  1015ce:	e8 f9 fc ff ff       	call   1012cc <serial_putc>
}
  1015d3:	c9                   	leave  
  1015d4:	c3                   	ret    

001015d5 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015d5:	55                   	push   %ebp
  1015d6:	89 e5                	mov    %esp,%ebp
  1015d8:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015db:	e8 cd fd ff ff       	call   1013ad <serial_intr>
    kbd_intr();
  1015e0:	e8 6e ff ff ff       	call   101553 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015e5:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015eb:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015f0:	39 c2                	cmp    %eax,%edx
  1015f2:	74 36                	je     10162a <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015f4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f9:	8d 50 01             	lea    0x1(%eax),%edx
  1015fc:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101602:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101609:	0f b6 c0             	movzbl %al,%eax
  10160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10160f:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101614:	3d 00 02 00 00       	cmp    $0x200,%eax
  101619:	75 0a                	jne    101625 <cons_getc+0x50>
            cons.rpos = 0;
  10161b:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101622:	00 00 00 
        }
        return c;
  101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101628:	eb 05                	jmp    10162f <cons_getc+0x5a>
    }
    return 0;
  10162a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10162f:	c9                   	leave  
  101630:	c3                   	ret    

00101631 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101631:	55                   	push   %ebp
  101632:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101634:	fb                   	sti    
    sti();
}
  101635:	5d                   	pop    %ebp
  101636:	c3                   	ret    

00101637 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10163a:	fa                   	cli    
    cli();
}
  10163b:	5d                   	pop    %ebp
  10163c:	c3                   	ret    

0010163d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
  101640:	83 ec 14             	sub    $0x14,%esp
  101643:	8b 45 08             	mov    0x8(%ebp),%eax
  101646:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10164a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164e:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101654:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101659:	85 c0                	test   %eax,%eax
  10165b:	74 36                	je     101693 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10165d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101661:	0f b6 c0             	movzbl %al,%eax
  101664:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10166a:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10166d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101671:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101675:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101676:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10167a:	66 c1 e8 08          	shr    $0x8,%ax
  10167e:	0f b6 c0             	movzbl %al,%eax
  101681:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101687:	88 45 f9             	mov    %al,-0x7(%ebp)
  10168a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10168e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101692:	ee                   	out    %al,(%dx)
    }
}
  101693:	c9                   	leave  
  101694:	c3                   	ret    

00101695 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101695:	55                   	push   %ebp
  101696:	89 e5                	mov    %esp,%ebp
  101698:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10169b:	8b 45 08             	mov    0x8(%ebp),%eax
  10169e:	ba 01 00 00 00       	mov    $0x1,%edx
  1016a3:	89 c1                	mov    %eax,%ecx
  1016a5:	d3 e2                	shl    %cl,%edx
  1016a7:	89 d0                	mov    %edx,%eax
  1016a9:	f7 d0                	not    %eax
  1016ab:	89 c2                	mov    %eax,%edx
  1016ad:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016b4:	21 d0                	and    %edx,%eax
  1016b6:	0f b7 c0             	movzwl %ax,%eax
  1016b9:	89 04 24             	mov    %eax,(%esp)
  1016bc:	e8 7c ff ff ff       	call   10163d <pic_setmask>
}
  1016c1:	c9                   	leave  
  1016c2:	c3                   	ret    

001016c3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016c3:	55                   	push   %ebp
  1016c4:	89 e5                	mov    %esp,%ebp
  1016c6:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c9:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016d0:	00 00 00 
  1016d3:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d9:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016dd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e5:	ee                   	out    %al,(%dx)
  1016e6:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016ec:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016f4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f8:	ee                   	out    %al,(%dx)
  1016f9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016ff:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101703:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101707:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10170b:	ee                   	out    %al,(%dx)
  10170c:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101712:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101716:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10171a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10171e:	ee                   	out    %al,(%dx)
  10171f:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101725:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101729:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10172d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101731:	ee                   	out    %al,(%dx)
  101732:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101738:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10173c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101740:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101744:	ee                   	out    %al,(%dx)
  101745:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10174b:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10174f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101753:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10175e:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101762:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101766:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101771:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101775:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101779:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101784:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101788:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10178c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101797:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10179b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10179f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017aa:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017ae:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017b2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017bd:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017c1:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c5:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017d0:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017d4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017d8:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017dd:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e4:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017e8:	74 12                	je     1017fc <pic_init+0x139>
        pic_setmask(irq_mask);
  1017ea:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017f1:	0f b7 c0             	movzwl %ax,%eax
  1017f4:	89 04 24             	mov    %eax,(%esp)
  1017f7:	e8 41 fe ff ff       	call   10163d <pic_setmask>
    }
}
  1017fc:	c9                   	leave  
  1017fd:	c3                   	ret    

001017fe <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fe:	55                   	push   %ebp
  1017ff:	89 e5                	mov    %esp,%ebp
  101801:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101804:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10180b:	00 
  10180c:	c7 04 24 00 38 10 00 	movl   $0x103800,(%esp)
  101813:	e8 fa ea ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101818:	c9                   	leave  
  101819:	c3                   	ret    

0010181a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10181a:	55                   	push   %ebp
  10181b:	89 e5                	mov    %esp,%ebp
  10181d:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
  101820:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i=0;
  101827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//setup each item of IDT;
	for(i=0; i<len; i++)
  10182e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101835:	e9 c3 00 00 00       	jmp    1018fd <idt_init+0xe3>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10183a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183d:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101844:	89 c2                	mov    %eax,%edx
  101846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101849:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101850:	00 
  101851:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101854:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10185b:	00 08 00 
  10185e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101861:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101868:	00 
  101869:	83 e2 e0             	and    $0xffffffe0,%edx
  10186c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101876:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10187d:	00 
  10187e:	83 e2 1f             	and    $0x1f,%edx
  101881:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101888:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101892:	00 
  101893:	83 e2 f0             	and    $0xfffffff0,%edx
  101896:	83 ca 0e             	or     $0xe,%edx
  101899:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a3:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018aa:	00 
  1018ab:	83 e2 ef             	and    $0xffffffef,%edx
  1018ae:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018bf:	00 
  1018c0:	83 e2 9f             	and    $0xffffff9f,%edx
  1018c3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d4:	00 
  1018d5:	83 ca 80             	or     $0xffffff80,%edx
  1018d8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018e9:	c1 e8 10             	shr    $0x10,%eax
  1018ec:	89 c2                	mov    %eax,%edx
  1018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f1:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018f8:	00 
idt_init(void) {
	extern uintptr_t __vectors[];
	int len  = sizeof(idt) / sizeof(struct gatedesc);//获得idt的表项数;
	int i=0;
	//setup each item of IDT;
	for(i=0; i<len; i++)
  1018f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101903:	0f 8c 31 ff ff ff    	jl     10183a <idt_init+0x20>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
  101909:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10190e:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101914:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10191b:	08 00 
  10191d:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101924:	83 e0 e0             	and    $0xffffffe0,%eax
  101927:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10192c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101933:	83 e0 1f             	and    $0x1f,%eax
  101936:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10193b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101942:	83 e0 f0             	and    $0xfffffff0,%eax
  101945:	83 c8 0e             	or     $0xe,%eax
  101948:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10194d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101954:	83 e0 ef             	and    $0xffffffef,%eax
  101957:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10195c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101963:	83 e0 9f             	and    $0xffffff9f,%eax
  101966:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101972:	83 c8 80             	or     $0xffffff80,%eax
  101975:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197a:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10197f:	c1 e8 10             	shr    $0x10,%eax
  101982:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101988:	c7 45 f4 60 e5 10 00 	movl   $0x10e560,-0xc(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101992:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);//载入IDT;
	return;
  101995:	90                   	nop
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101996:	c9                   	leave  
  101997:	c3                   	ret    

00101998 <trapname>:

static const char *
trapname(int trapno) {
  101998:	55                   	push   %ebp
  101999:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  10199b:	8b 45 08             	mov    0x8(%ebp),%eax
  10199e:	83 f8 13             	cmp    $0x13,%eax
  1019a1:	77 0c                	ja     1019af <trapname+0x17>
        return excnames[trapno];
  1019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a6:	8b 04 85 60 3b 10 00 	mov    0x103b60(,%eax,4),%eax
  1019ad:	eb 18                	jmp    1019c7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019af:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019b3:	7e 0d                	jle    1019c2 <trapname+0x2a>
  1019b5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019b9:	7f 07                	jg     1019c2 <trapname+0x2a>
        return "Hardware Interrupt";
  1019bb:	b8 0a 38 10 00       	mov    $0x10380a,%eax
  1019c0:	eb 05                	jmp    1019c7 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019c2:	b8 1d 38 10 00       	mov    $0x10381d,%eax
}
  1019c7:	5d                   	pop    %ebp
  1019c8:	c3                   	ret    

001019c9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019c9:	55                   	push   %ebp
  1019ca:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019d3:	66 83 f8 08          	cmp    $0x8,%ax
  1019d7:	0f 94 c0             	sete   %al
  1019da:	0f b6 c0             	movzbl %al,%eax
}
  1019dd:	5d                   	pop    %ebp
  1019de:	c3                   	ret    

001019df <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019df:	55                   	push   %ebp
  1019e0:	89 e5                	mov    %esp,%ebp
  1019e2:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ec:	c7 04 24 5e 38 10 00 	movl   $0x10385e,(%esp)
  1019f3:	e8 1a e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fb:	89 04 24             	mov    %eax,(%esp)
  1019fe:	e8 a1 01 00 00       	call   101ba4 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a0a:	0f b7 c0             	movzwl %ax,%eax
  101a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a11:	c7 04 24 6f 38 10 00 	movl   $0x10386f,(%esp)
  101a18:	e8 f5 e8 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a20:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a24:	0f b7 c0             	movzwl %ax,%eax
  101a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2b:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  101a32:	e8 db e8 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a37:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a3e:	0f b7 c0             	movzwl %ax,%eax
  101a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a45:	c7 04 24 95 38 10 00 	movl   $0x103895,(%esp)
  101a4c:	e8 c1 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a51:	8b 45 08             	mov    0x8(%ebp),%eax
  101a54:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a58:	0f b7 c0             	movzwl %ax,%eax
  101a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5f:	c7 04 24 a8 38 10 00 	movl   $0x1038a8,(%esp)
  101a66:	e8 a7 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	8b 40 30             	mov    0x30(%eax),%eax
  101a71:	89 04 24             	mov    %eax,(%esp)
  101a74:	e8 1f ff ff ff       	call   101998 <trapname>
  101a79:	8b 55 08             	mov    0x8(%ebp),%edx
  101a7c:	8b 52 30             	mov    0x30(%edx),%edx
  101a7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a83:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a87:	c7 04 24 bb 38 10 00 	movl   $0x1038bb,(%esp)
  101a8e:	e8 7f e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a93:	8b 45 08             	mov    0x8(%ebp),%eax
  101a96:	8b 40 34             	mov    0x34(%eax),%eax
  101a99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9d:	c7 04 24 cd 38 10 00 	movl   $0x1038cd,(%esp)
  101aa4:	e8 69 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	8b 40 38             	mov    0x38(%eax),%eax
  101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab3:	c7 04 24 dc 38 10 00 	movl   $0x1038dc,(%esp)
  101aba:	e8 53 e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101abf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ac6:	0f b7 c0             	movzwl %ax,%eax
  101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acd:	c7 04 24 eb 38 10 00 	movl   $0x1038eb,(%esp)
  101ad4:	e8 39 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	8b 40 40             	mov    0x40(%eax),%eax
  101adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae3:	c7 04 24 fe 38 10 00 	movl   $0x1038fe,(%esp)
  101aea:	e8 23 e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101af6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101afd:	eb 3e                	jmp    101b3d <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aff:	8b 45 08             	mov    0x8(%ebp),%eax
  101b02:	8b 50 40             	mov    0x40(%eax),%edx
  101b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b08:	21 d0                	and    %edx,%eax
  101b0a:	85 c0                	test   %eax,%eax
  101b0c:	74 28                	je     101b36 <print_trapframe+0x157>
  101b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b11:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b18:	85 c0                	test   %eax,%eax
  101b1a:	74 1a                	je     101b36 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b1f:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b26:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2a:	c7 04 24 0d 39 10 00 	movl   $0x10390d,(%esp)
  101b31:	e8 dc e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b36:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b3a:	d1 65 f0             	shll   -0x10(%ebp)
  101b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b40:	83 f8 17             	cmp    $0x17,%eax
  101b43:	76 ba                	jbe    101aff <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b45:	8b 45 08             	mov    0x8(%ebp),%eax
  101b48:	8b 40 40             	mov    0x40(%eax),%eax
  101b4b:	25 00 30 00 00       	and    $0x3000,%eax
  101b50:	c1 e8 0c             	shr    $0xc,%eax
  101b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b57:	c7 04 24 11 39 10 00 	movl   $0x103911,(%esp)
  101b5e:	e8 af e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b63:	8b 45 08             	mov    0x8(%ebp),%eax
  101b66:	89 04 24             	mov    %eax,(%esp)
  101b69:	e8 5b fe ff ff       	call   1019c9 <trap_in_kernel>
  101b6e:	85 c0                	test   %eax,%eax
  101b70:	75 30                	jne    101ba2 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	8b 40 44             	mov    0x44(%eax),%eax
  101b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7c:	c7 04 24 1a 39 10 00 	movl   $0x10391a,(%esp)
  101b83:	e8 8a e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b88:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8b:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b8f:	0f b7 c0             	movzwl %ax,%eax
  101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b96:	c7 04 24 29 39 10 00 	movl   $0x103929,(%esp)
  101b9d:	e8 70 e7 ff ff       	call   100312 <cprintf>
    }
}
  101ba2:	c9                   	leave  
  101ba3:	c3                   	ret    

00101ba4 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ba4:	55                   	push   %ebp
  101ba5:	89 e5                	mov    %esp,%ebp
  101ba7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 00                	mov    (%eax),%eax
  101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb3:	c7 04 24 3c 39 10 00 	movl   $0x10393c,(%esp)
  101bba:	e8 53 e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc2:	8b 40 04             	mov    0x4(%eax),%eax
  101bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc9:	c7 04 24 4b 39 10 00 	movl   $0x10394b,(%esp)
  101bd0:	e8 3d e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd8:	8b 40 08             	mov    0x8(%eax),%eax
  101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdf:	c7 04 24 5a 39 10 00 	movl   $0x10395a,(%esp)
  101be6:	e8 27 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101beb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bee:	8b 40 0c             	mov    0xc(%eax),%eax
  101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf5:	c7 04 24 69 39 10 00 	movl   $0x103969,(%esp)
  101bfc:	e8 11 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	8b 40 10             	mov    0x10(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 78 39 10 00 	movl   $0x103978,(%esp)
  101c12:	e8 fb e6 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	8b 40 14             	mov    0x14(%eax),%eax
  101c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c21:	c7 04 24 87 39 10 00 	movl   $0x103987,(%esp)
  101c28:	e8 e5 e6 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	8b 40 18             	mov    0x18(%eax),%eax
  101c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c37:	c7 04 24 96 39 10 00 	movl   $0x103996,(%esp)
  101c3e:	e8 cf e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c43:	8b 45 08             	mov    0x8(%ebp),%eax
  101c46:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4d:	c7 04 24 a5 39 10 00 	movl   $0x1039a5,(%esp)
  101c54:	e8 b9 e6 ff ff       	call   100312 <cprintf>
}
  101c59:	c9                   	leave  
  101c5a:	c3                   	ret    

00101c5b <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c5b:	55                   	push   %ebp
  101c5c:	89 e5                	mov    %esp,%ebp
  101c5e:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 30             	mov    0x30(%eax),%eax
  101c67:	83 f8 2f             	cmp    $0x2f,%eax
  101c6a:	77 1d                	ja     101c89 <trap_dispatch+0x2e>
  101c6c:	83 f8 2e             	cmp    $0x2e,%eax
  101c6f:	0f 83 f2 00 00 00    	jae    101d67 <trap_dispatch+0x10c>
  101c75:	83 f8 21             	cmp    $0x21,%eax
  101c78:	74 73                	je     101ced <trap_dispatch+0x92>
  101c7a:	83 f8 24             	cmp    $0x24,%eax
  101c7d:	74 48                	je     101cc7 <trap_dispatch+0x6c>
  101c7f:	83 f8 20             	cmp    $0x20,%eax
  101c82:	74 13                	je     101c97 <trap_dispatch+0x3c>
  101c84:	e9 a6 00 00 00       	jmp    101d2f <trap_dispatch+0xd4>
  101c89:	83 e8 78             	sub    $0x78,%eax
  101c8c:	83 f8 01             	cmp    $0x1,%eax
  101c8f:	0f 87 9a 00 00 00    	ja     101d2f <trap_dispatch+0xd4>
  101c95:	eb 7c                	jmp    101d13 <trap_dispatch+0xb8>
    case IRQ_OFFSET + IRQ_TIMER:
    	ticks++;//in clock.h(extern volatile size_t ticks;);
  101c97:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c9c:	83 c0 01             	add    $0x1,%eax
  101c9f:	a3 08 f9 10 00       	mov    %eax,0x10f908
    	if(ticks == TICK_NUM)
  101ca4:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101ca9:	83 f8 64             	cmp    $0x64,%eax
  101cac:	75 14                	jne    101cc2 <trap_dispatch+0x67>
    	{
    		print_ticks();//打印"100	ticks";
  101cae:	e8 4b fb ff ff       	call   1017fe <print_ticks>
    		ticks = 0;//时钟清零;
  101cb3:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101cba:	00 00 00 
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101cbd:	e9 a6 00 00 00       	jmp    101d68 <trap_dispatch+0x10d>
  101cc2:	e9 a1 00 00 00       	jmp    101d68 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cc7:	e8 09 f9 ff ff       	call   1015d5 <cons_getc>
  101ccc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ccf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cd3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cd7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdf:	c7 04 24 b4 39 10 00 	movl   $0x1039b4,(%esp)
  101ce6:	e8 27 e6 ff ff       	call   100312 <cprintf>
        break;
  101ceb:	eb 7b                	jmp    101d68 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ced:	e8 e3 f8 ff ff       	call   1015d5 <cons_getc>
  101cf2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cf5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cfd:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d05:	c7 04 24 c6 39 10 00 	movl   $0x1039c6,(%esp)
  101d0c:	e8 01 e6 ff ff       	call   100312 <cprintf>
        break;
  101d11:	eb 55                	jmp    101d68 <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d13:	c7 44 24 08 d5 39 10 	movl   $0x1039d5,0x8(%esp)
  101d1a:	00 
  101d1b:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  101d22:	00 
  101d23:	c7 04 24 e5 39 10 00 	movl   $0x1039e5,(%esp)
  101d2a:	e8 88 ef ff ff       	call   100cb7 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d36:	0f b7 c0             	movzwl %ax,%eax
  101d39:	83 e0 03             	and    $0x3,%eax
  101d3c:	85 c0                	test   %eax,%eax
  101d3e:	75 28                	jne    101d68 <trap_dispatch+0x10d>
            print_trapframe(tf);
  101d40:	8b 45 08             	mov    0x8(%ebp),%eax
  101d43:	89 04 24             	mov    %eax,(%esp)
  101d46:	e8 94 fc ff ff       	call   1019df <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d4b:	c7 44 24 08 f6 39 10 	movl   $0x1039f6,0x8(%esp)
  101d52:	00 
  101d53:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  101d5a:	00 
  101d5b:	c7 04 24 e5 39 10 00 	movl   $0x1039e5,(%esp)
  101d62:	e8 50 ef ff ff       	call   100cb7 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d67:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d68:	c9                   	leave  
  101d69:	c3                   	ret    

00101d6a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d6a:	55                   	push   %ebp
  101d6b:	89 e5                	mov    %esp,%ebp
  101d6d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d70:	8b 45 08             	mov    0x8(%ebp),%eax
  101d73:	89 04 24             	mov    %eax,(%esp)
  101d76:	e8 e0 fe ff ff       	call   101c5b <trap_dispatch>
}
  101d7b:	c9                   	leave  
  101d7c:	c3                   	ret    

00101d7d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d7d:	1e                   	push   %ds
    pushl %es
  101d7e:	06                   	push   %es
    pushl %fs
  101d7f:	0f a0                	push   %fs
    pushl %gs
  101d81:	0f a8                	push   %gs
    pushal
  101d83:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d84:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d89:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d8b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d8d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d8e:	e8 d7 ff ff ff       	call   101d6a <trap>

    # pop the pushed stack pointer
    popl %esp
  101d93:	5c                   	pop    %esp

00101d94 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d94:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d95:	0f a9                	pop    %gs
    popl %fs
  101d97:	0f a1                	pop    %fs
    popl %es
  101d99:	07                   	pop    %es
    popl %ds
  101d9a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d9b:	83 c4 08             	add    $0x8,%esp
    iret
  101d9e:	cf                   	iret   

00101d9f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d9f:	6a 00                	push   $0x0
  pushl $0
  101da1:	6a 00                	push   $0x0
  jmp __alltraps
  101da3:	e9 d5 ff ff ff       	jmp    101d7d <__alltraps>

00101da8 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da8:	6a 00                	push   $0x0
  pushl $1
  101daa:	6a 01                	push   $0x1
  jmp __alltraps
  101dac:	e9 cc ff ff ff       	jmp    101d7d <__alltraps>

00101db1 <vector2>:
.globl vector2
vector2:
  pushl $0
  101db1:	6a 00                	push   $0x0
  pushl $2
  101db3:	6a 02                	push   $0x2
  jmp __alltraps
  101db5:	e9 c3 ff ff ff       	jmp    101d7d <__alltraps>

00101dba <vector3>:
.globl vector3
vector3:
  pushl $0
  101dba:	6a 00                	push   $0x0
  pushl $3
  101dbc:	6a 03                	push   $0x3
  jmp __alltraps
  101dbe:	e9 ba ff ff ff       	jmp    101d7d <__alltraps>

00101dc3 <vector4>:
.globl vector4
vector4:
  pushl $0
  101dc3:	6a 00                	push   $0x0
  pushl $4
  101dc5:	6a 04                	push   $0x4
  jmp __alltraps
  101dc7:	e9 b1 ff ff ff       	jmp    101d7d <__alltraps>

00101dcc <vector5>:
.globl vector5
vector5:
  pushl $0
  101dcc:	6a 00                	push   $0x0
  pushl $5
  101dce:	6a 05                	push   $0x5
  jmp __alltraps
  101dd0:	e9 a8 ff ff ff       	jmp    101d7d <__alltraps>

00101dd5 <vector6>:
.globl vector6
vector6:
  pushl $0
  101dd5:	6a 00                	push   $0x0
  pushl $6
  101dd7:	6a 06                	push   $0x6
  jmp __alltraps
  101dd9:	e9 9f ff ff ff       	jmp    101d7d <__alltraps>

00101dde <vector7>:
.globl vector7
vector7:
  pushl $0
  101dde:	6a 00                	push   $0x0
  pushl $7
  101de0:	6a 07                	push   $0x7
  jmp __alltraps
  101de2:	e9 96 ff ff ff       	jmp    101d7d <__alltraps>

00101de7 <vector8>:
.globl vector8
vector8:
  pushl $8
  101de7:	6a 08                	push   $0x8
  jmp __alltraps
  101de9:	e9 8f ff ff ff       	jmp    101d7d <__alltraps>

00101dee <vector9>:
.globl vector9
vector9:
  pushl $9
  101dee:	6a 09                	push   $0x9
  jmp __alltraps
  101df0:	e9 88 ff ff ff       	jmp    101d7d <__alltraps>

00101df5 <vector10>:
.globl vector10
vector10:
  pushl $10
  101df5:	6a 0a                	push   $0xa
  jmp __alltraps
  101df7:	e9 81 ff ff ff       	jmp    101d7d <__alltraps>

00101dfc <vector11>:
.globl vector11
vector11:
  pushl $11
  101dfc:	6a 0b                	push   $0xb
  jmp __alltraps
  101dfe:	e9 7a ff ff ff       	jmp    101d7d <__alltraps>

00101e03 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e03:	6a 0c                	push   $0xc
  jmp __alltraps
  101e05:	e9 73 ff ff ff       	jmp    101d7d <__alltraps>

00101e0a <vector13>:
.globl vector13
vector13:
  pushl $13
  101e0a:	6a 0d                	push   $0xd
  jmp __alltraps
  101e0c:	e9 6c ff ff ff       	jmp    101d7d <__alltraps>

00101e11 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e11:	6a 0e                	push   $0xe
  jmp __alltraps
  101e13:	e9 65 ff ff ff       	jmp    101d7d <__alltraps>

00101e18 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $15
  101e1a:	6a 0f                	push   $0xf
  jmp __alltraps
  101e1c:	e9 5c ff ff ff       	jmp    101d7d <__alltraps>

00101e21 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $16
  101e23:	6a 10                	push   $0x10
  jmp __alltraps
  101e25:	e9 53 ff ff ff       	jmp    101d7d <__alltraps>

00101e2a <vector17>:
.globl vector17
vector17:
  pushl $17
  101e2a:	6a 11                	push   $0x11
  jmp __alltraps
  101e2c:	e9 4c ff ff ff       	jmp    101d7d <__alltraps>

00101e31 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $18
  101e33:	6a 12                	push   $0x12
  jmp __alltraps
  101e35:	e9 43 ff ff ff       	jmp    101d7d <__alltraps>

00101e3a <vector19>:
.globl vector19
vector19:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $19
  101e3c:	6a 13                	push   $0x13
  jmp __alltraps
  101e3e:	e9 3a ff ff ff       	jmp    101d7d <__alltraps>

00101e43 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $20
  101e45:	6a 14                	push   $0x14
  jmp __alltraps
  101e47:	e9 31 ff ff ff       	jmp    101d7d <__alltraps>

00101e4c <vector21>:
.globl vector21
vector21:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $21
  101e4e:	6a 15                	push   $0x15
  jmp __alltraps
  101e50:	e9 28 ff ff ff       	jmp    101d7d <__alltraps>

00101e55 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $22
  101e57:	6a 16                	push   $0x16
  jmp __alltraps
  101e59:	e9 1f ff ff ff       	jmp    101d7d <__alltraps>

00101e5e <vector23>:
.globl vector23
vector23:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $23
  101e60:	6a 17                	push   $0x17
  jmp __alltraps
  101e62:	e9 16 ff ff ff       	jmp    101d7d <__alltraps>

00101e67 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $24
  101e69:	6a 18                	push   $0x18
  jmp __alltraps
  101e6b:	e9 0d ff ff ff       	jmp    101d7d <__alltraps>

00101e70 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e70:	6a 00                	push   $0x0
  pushl $25
  101e72:	6a 19                	push   $0x19
  jmp __alltraps
  101e74:	e9 04 ff ff ff       	jmp    101d7d <__alltraps>

00101e79 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e79:	6a 00                	push   $0x0
  pushl $26
  101e7b:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e7d:	e9 fb fe ff ff       	jmp    101d7d <__alltraps>

00101e82 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e82:	6a 00                	push   $0x0
  pushl $27
  101e84:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e86:	e9 f2 fe ff ff       	jmp    101d7d <__alltraps>

00101e8b <vector28>:
.globl vector28
vector28:
  pushl $0
  101e8b:	6a 00                	push   $0x0
  pushl $28
  101e8d:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e8f:	e9 e9 fe ff ff       	jmp    101d7d <__alltraps>

00101e94 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e94:	6a 00                	push   $0x0
  pushl $29
  101e96:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e98:	e9 e0 fe ff ff       	jmp    101d7d <__alltraps>

00101e9d <vector30>:
.globl vector30
vector30:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $30
  101e9f:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ea1:	e9 d7 fe ff ff       	jmp    101d7d <__alltraps>

00101ea6 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $31
  101ea8:	6a 1f                	push   $0x1f
  jmp __alltraps
  101eaa:	e9 ce fe ff ff       	jmp    101d7d <__alltraps>

00101eaf <vector32>:
.globl vector32
vector32:
  pushl $0
  101eaf:	6a 00                	push   $0x0
  pushl $32
  101eb1:	6a 20                	push   $0x20
  jmp __alltraps
  101eb3:	e9 c5 fe ff ff       	jmp    101d7d <__alltraps>

00101eb8 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb8:	6a 00                	push   $0x0
  pushl $33
  101eba:	6a 21                	push   $0x21
  jmp __alltraps
  101ebc:	e9 bc fe ff ff       	jmp    101d7d <__alltraps>

00101ec1 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $34
  101ec3:	6a 22                	push   $0x22
  jmp __alltraps
  101ec5:	e9 b3 fe ff ff       	jmp    101d7d <__alltraps>

00101eca <vector35>:
.globl vector35
vector35:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $35
  101ecc:	6a 23                	push   $0x23
  jmp __alltraps
  101ece:	e9 aa fe ff ff       	jmp    101d7d <__alltraps>

00101ed3 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ed3:	6a 00                	push   $0x0
  pushl $36
  101ed5:	6a 24                	push   $0x24
  jmp __alltraps
  101ed7:	e9 a1 fe ff ff       	jmp    101d7d <__alltraps>

00101edc <vector37>:
.globl vector37
vector37:
  pushl $0
  101edc:	6a 00                	push   $0x0
  pushl $37
  101ede:	6a 25                	push   $0x25
  jmp __alltraps
  101ee0:	e9 98 fe ff ff       	jmp    101d7d <__alltraps>

00101ee5 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ee5:	6a 00                	push   $0x0
  pushl $38
  101ee7:	6a 26                	push   $0x26
  jmp __alltraps
  101ee9:	e9 8f fe ff ff       	jmp    101d7d <__alltraps>

00101eee <vector39>:
.globl vector39
vector39:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $39
  101ef0:	6a 27                	push   $0x27
  jmp __alltraps
  101ef2:	e9 86 fe ff ff       	jmp    101d7d <__alltraps>

00101ef7 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $40
  101ef9:	6a 28                	push   $0x28
  jmp __alltraps
  101efb:	e9 7d fe ff ff       	jmp    101d7d <__alltraps>

00101f00 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f00:	6a 00                	push   $0x0
  pushl $41
  101f02:	6a 29                	push   $0x29
  jmp __alltraps
  101f04:	e9 74 fe ff ff       	jmp    101d7d <__alltraps>

00101f09 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $42
  101f0b:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f0d:	e9 6b fe ff ff       	jmp    101d7d <__alltraps>

00101f12 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $43
  101f14:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f16:	e9 62 fe ff ff       	jmp    101d7d <__alltraps>

00101f1b <vector44>:
.globl vector44
vector44:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $44
  101f1d:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f1f:	e9 59 fe ff ff       	jmp    101d7d <__alltraps>

00101f24 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $45
  101f26:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f28:	e9 50 fe ff ff       	jmp    101d7d <__alltraps>

00101f2d <vector46>:
.globl vector46
vector46:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $46
  101f2f:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f31:	e9 47 fe ff ff       	jmp    101d7d <__alltraps>

00101f36 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $47
  101f38:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f3a:	e9 3e fe ff ff       	jmp    101d7d <__alltraps>

00101f3f <vector48>:
.globl vector48
vector48:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $48
  101f41:	6a 30                	push   $0x30
  jmp __alltraps
  101f43:	e9 35 fe ff ff       	jmp    101d7d <__alltraps>

00101f48 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $49
  101f4a:	6a 31                	push   $0x31
  jmp __alltraps
  101f4c:	e9 2c fe ff ff       	jmp    101d7d <__alltraps>

00101f51 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $50
  101f53:	6a 32                	push   $0x32
  jmp __alltraps
  101f55:	e9 23 fe ff ff       	jmp    101d7d <__alltraps>

00101f5a <vector51>:
.globl vector51
vector51:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $51
  101f5c:	6a 33                	push   $0x33
  jmp __alltraps
  101f5e:	e9 1a fe ff ff       	jmp    101d7d <__alltraps>

00101f63 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $52
  101f65:	6a 34                	push   $0x34
  jmp __alltraps
  101f67:	e9 11 fe ff ff       	jmp    101d7d <__alltraps>

00101f6c <vector53>:
.globl vector53
vector53:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $53
  101f6e:	6a 35                	push   $0x35
  jmp __alltraps
  101f70:	e9 08 fe ff ff       	jmp    101d7d <__alltraps>

00101f75 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $54
  101f77:	6a 36                	push   $0x36
  jmp __alltraps
  101f79:	e9 ff fd ff ff       	jmp    101d7d <__alltraps>

00101f7e <vector55>:
.globl vector55
vector55:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $55
  101f80:	6a 37                	push   $0x37
  jmp __alltraps
  101f82:	e9 f6 fd ff ff       	jmp    101d7d <__alltraps>

00101f87 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $56
  101f89:	6a 38                	push   $0x38
  jmp __alltraps
  101f8b:	e9 ed fd ff ff       	jmp    101d7d <__alltraps>

00101f90 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $57
  101f92:	6a 39                	push   $0x39
  jmp __alltraps
  101f94:	e9 e4 fd ff ff       	jmp    101d7d <__alltraps>

00101f99 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $58
  101f9b:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f9d:	e9 db fd ff ff       	jmp    101d7d <__alltraps>

00101fa2 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $59
  101fa4:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fa6:	e9 d2 fd ff ff       	jmp    101d7d <__alltraps>

00101fab <vector60>:
.globl vector60
vector60:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $60
  101fad:	6a 3c                	push   $0x3c
  jmp __alltraps
  101faf:	e9 c9 fd ff ff       	jmp    101d7d <__alltraps>

00101fb4 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $61
  101fb6:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb8:	e9 c0 fd ff ff       	jmp    101d7d <__alltraps>

00101fbd <vector62>:
.globl vector62
vector62:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $62
  101fbf:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fc1:	e9 b7 fd ff ff       	jmp    101d7d <__alltraps>

00101fc6 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $63
  101fc8:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fca:	e9 ae fd ff ff       	jmp    101d7d <__alltraps>

00101fcf <vector64>:
.globl vector64
vector64:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $64
  101fd1:	6a 40                	push   $0x40
  jmp __alltraps
  101fd3:	e9 a5 fd ff ff       	jmp    101d7d <__alltraps>

00101fd8 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $65
  101fda:	6a 41                	push   $0x41
  jmp __alltraps
  101fdc:	e9 9c fd ff ff       	jmp    101d7d <__alltraps>

00101fe1 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $66
  101fe3:	6a 42                	push   $0x42
  jmp __alltraps
  101fe5:	e9 93 fd ff ff       	jmp    101d7d <__alltraps>

00101fea <vector67>:
.globl vector67
vector67:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $67
  101fec:	6a 43                	push   $0x43
  jmp __alltraps
  101fee:	e9 8a fd ff ff       	jmp    101d7d <__alltraps>

00101ff3 <vector68>:
.globl vector68
vector68:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $68
  101ff5:	6a 44                	push   $0x44
  jmp __alltraps
  101ff7:	e9 81 fd ff ff       	jmp    101d7d <__alltraps>

00101ffc <vector69>:
.globl vector69
vector69:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $69
  101ffe:	6a 45                	push   $0x45
  jmp __alltraps
  102000:	e9 78 fd ff ff       	jmp    101d7d <__alltraps>

00102005 <vector70>:
.globl vector70
vector70:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $70
  102007:	6a 46                	push   $0x46
  jmp __alltraps
  102009:	e9 6f fd ff ff       	jmp    101d7d <__alltraps>

0010200e <vector71>:
.globl vector71
vector71:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $71
  102010:	6a 47                	push   $0x47
  jmp __alltraps
  102012:	e9 66 fd ff ff       	jmp    101d7d <__alltraps>

00102017 <vector72>:
.globl vector72
vector72:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $72
  102019:	6a 48                	push   $0x48
  jmp __alltraps
  10201b:	e9 5d fd ff ff       	jmp    101d7d <__alltraps>

00102020 <vector73>:
.globl vector73
vector73:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $73
  102022:	6a 49                	push   $0x49
  jmp __alltraps
  102024:	e9 54 fd ff ff       	jmp    101d7d <__alltraps>

00102029 <vector74>:
.globl vector74
vector74:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $74
  10202b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10202d:	e9 4b fd ff ff       	jmp    101d7d <__alltraps>

00102032 <vector75>:
.globl vector75
vector75:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $75
  102034:	6a 4b                	push   $0x4b
  jmp __alltraps
  102036:	e9 42 fd ff ff       	jmp    101d7d <__alltraps>

0010203b <vector76>:
.globl vector76
vector76:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $76
  10203d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10203f:	e9 39 fd ff ff       	jmp    101d7d <__alltraps>

00102044 <vector77>:
.globl vector77
vector77:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $77
  102046:	6a 4d                	push   $0x4d
  jmp __alltraps
  102048:	e9 30 fd ff ff       	jmp    101d7d <__alltraps>

0010204d <vector78>:
.globl vector78
vector78:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $78
  10204f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102051:	e9 27 fd ff ff       	jmp    101d7d <__alltraps>

00102056 <vector79>:
.globl vector79
vector79:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $79
  102058:	6a 4f                	push   $0x4f
  jmp __alltraps
  10205a:	e9 1e fd ff ff       	jmp    101d7d <__alltraps>

0010205f <vector80>:
.globl vector80
vector80:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $80
  102061:	6a 50                	push   $0x50
  jmp __alltraps
  102063:	e9 15 fd ff ff       	jmp    101d7d <__alltraps>

00102068 <vector81>:
.globl vector81
vector81:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $81
  10206a:	6a 51                	push   $0x51
  jmp __alltraps
  10206c:	e9 0c fd ff ff       	jmp    101d7d <__alltraps>

00102071 <vector82>:
.globl vector82
vector82:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $82
  102073:	6a 52                	push   $0x52
  jmp __alltraps
  102075:	e9 03 fd ff ff       	jmp    101d7d <__alltraps>

0010207a <vector83>:
.globl vector83
vector83:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $83
  10207c:	6a 53                	push   $0x53
  jmp __alltraps
  10207e:	e9 fa fc ff ff       	jmp    101d7d <__alltraps>

00102083 <vector84>:
.globl vector84
vector84:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $84
  102085:	6a 54                	push   $0x54
  jmp __alltraps
  102087:	e9 f1 fc ff ff       	jmp    101d7d <__alltraps>

0010208c <vector85>:
.globl vector85
vector85:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $85
  10208e:	6a 55                	push   $0x55
  jmp __alltraps
  102090:	e9 e8 fc ff ff       	jmp    101d7d <__alltraps>

00102095 <vector86>:
.globl vector86
vector86:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $86
  102097:	6a 56                	push   $0x56
  jmp __alltraps
  102099:	e9 df fc ff ff       	jmp    101d7d <__alltraps>

0010209e <vector87>:
.globl vector87
vector87:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $87
  1020a0:	6a 57                	push   $0x57
  jmp __alltraps
  1020a2:	e9 d6 fc ff ff       	jmp    101d7d <__alltraps>

001020a7 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $88
  1020a9:	6a 58                	push   $0x58
  jmp __alltraps
  1020ab:	e9 cd fc ff ff       	jmp    101d7d <__alltraps>

001020b0 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $89
  1020b2:	6a 59                	push   $0x59
  jmp __alltraps
  1020b4:	e9 c4 fc ff ff       	jmp    101d7d <__alltraps>

001020b9 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $90
  1020bb:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020bd:	e9 bb fc ff ff       	jmp    101d7d <__alltraps>

001020c2 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $91
  1020c4:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020c6:	e9 b2 fc ff ff       	jmp    101d7d <__alltraps>

001020cb <vector92>:
.globl vector92
vector92:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $92
  1020cd:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020cf:	e9 a9 fc ff ff       	jmp    101d7d <__alltraps>

001020d4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $93
  1020d6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d8:	e9 a0 fc ff ff       	jmp    101d7d <__alltraps>

001020dd <vector94>:
.globl vector94
vector94:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $94
  1020df:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020e1:	e9 97 fc ff ff       	jmp    101d7d <__alltraps>

001020e6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $95
  1020e8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020ea:	e9 8e fc ff ff       	jmp    101d7d <__alltraps>

001020ef <vector96>:
.globl vector96
vector96:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $96
  1020f1:	6a 60                	push   $0x60
  jmp __alltraps
  1020f3:	e9 85 fc ff ff       	jmp    101d7d <__alltraps>

001020f8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $97
  1020fa:	6a 61                	push   $0x61
  jmp __alltraps
  1020fc:	e9 7c fc ff ff       	jmp    101d7d <__alltraps>

00102101 <vector98>:
.globl vector98
vector98:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $98
  102103:	6a 62                	push   $0x62
  jmp __alltraps
  102105:	e9 73 fc ff ff       	jmp    101d7d <__alltraps>

0010210a <vector99>:
.globl vector99
vector99:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $99
  10210c:	6a 63                	push   $0x63
  jmp __alltraps
  10210e:	e9 6a fc ff ff       	jmp    101d7d <__alltraps>

00102113 <vector100>:
.globl vector100
vector100:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $100
  102115:	6a 64                	push   $0x64
  jmp __alltraps
  102117:	e9 61 fc ff ff       	jmp    101d7d <__alltraps>

0010211c <vector101>:
.globl vector101
vector101:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $101
  10211e:	6a 65                	push   $0x65
  jmp __alltraps
  102120:	e9 58 fc ff ff       	jmp    101d7d <__alltraps>

00102125 <vector102>:
.globl vector102
vector102:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $102
  102127:	6a 66                	push   $0x66
  jmp __alltraps
  102129:	e9 4f fc ff ff       	jmp    101d7d <__alltraps>

0010212e <vector103>:
.globl vector103
vector103:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $103
  102130:	6a 67                	push   $0x67
  jmp __alltraps
  102132:	e9 46 fc ff ff       	jmp    101d7d <__alltraps>

00102137 <vector104>:
.globl vector104
vector104:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $104
  102139:	6a 68                	push   $0x68
  jmp __alltraps
  10213b:	e9 3d fc ff ff       	jmp    101d7d <__alltraps>

00102140 <vector105>:
.globl vector105
vector105:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $105
  102142:	6a 69                	push   $0x69
  jmp __alltraps
  102144:	e9 34 fc ff ff       	jmp    101d7d <__alltraps>

00102149 <vector106>:
.globl vector106
vector106:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $106
  10214b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10214d:	e9 2b fc ff ff       	jmp    101d7d <__alltraps>

00102152 <vector107>:
.globl vector107
vector107:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $107
  102154:	6a 6b                	push   $0x6b
  jmp __alltraps
  102156:	e9 22 fc ff ff       	jmp    101d7d <__alltraps>

0010215b <vector108>:
.globl vector108
vector108:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $108
  10215d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10215f:	e9 19 fc ff ff       	jmp    101d7d <__alltraps>

00102164 <vector109>:
.globl vector109
vector109:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $109
  102166:	6a 6d                	push   $0x6d
  jmp __alltraps
  102168:	e9 10 fc ff ff       	jmp    101d7d <__alltraps>

0010216d <vector110>:
.globl vector110
vector110:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $110
  10216f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102171:	e9 07 fc ff ff       	jmp    101d7d <__alltraps>

00102176 <vector111>:
.globl vector111
vector111:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $111
  102178:	6a 6f                	push   $0x6f
  jmp __alltraps
  10217a:	e9 fe fb ff ff       	jmp    101d7d <__alltraps>

0010217f <vector112>:
.globl vector112
vector112:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $112
  102181:	6a 70                	push   $0x70
  jmp __alltraps
  102183:	e9 f5 fb ff ff       	jmp    101d7d <__alltraps>

00102188 <vector113>:
.globl vector113
vector113:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $113
  10218a:	6a 71                	push   $0x71
  jmp __alltraps
  10218c:	e9 ec fb ff ff       	jmp    101d7d <__alltraps>

00102191 <vector114>:
.globl vector114
vector114:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $114
  102193:	6a 72                	push   $0x72
  jmp __alltraps
  102195:	e9 e3 fb ff ff       	jmp    101d7d <__alltraps>

0010219a <vector115>:
.globl vector115
vector115:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $115
  10219c:	6a 73                	push   $0x73
  jmp __alltraps
  10219e:	e9 da fb ff ff       	jmp    101d7d <__alltraps>

001021a3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $116
  1021a5:	6a 74                	push   $0x74
  jmp __alltraps
  1021a7:	e9 d1 fb ff ff       	jmp    101d7d <__alltraps>

001021ac <vector117>:
.globl vector117
vector117:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $117
  1021ae:	6a 75                	push   $0x75
  jmp __alltraps
  1021b0:	e9 c8 fb ff ff       	jmp    101d7d <__alltraps>

001021b5 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $118
  1021b7:	6a 76                	push   $0x76
  jmp __alltraps
  1021b9:	e9 bf fb ff ff       	jmp    101d7d <__alltraps>

001021be <vector119>:
.globl vector119
vector119:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $119
  1021c0:	6a 77                	push   $0x77
  jmp __alltraps
  1021c2:	e9 b6 fb ff ff       	jmp    101d7d <__alltraps>

001021c7 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $120
  1021c9:	6a 78                	push   $0x78
  jmp __alltraps
  1021cb:	e9 ad fb ff ff       	jmp    101d7d <__alltraps>

001021d0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $121
  1021d2:	6a 79                	push   $0x79
  jmp __alltraps
  1021d4:	e9 a4 fb ff ff       	jmp    101d7d <__alltraps>

001021d9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $122
  1021db:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021dd:	e9 9b fb ff ff       	jmp    101d7d <__alltraps>

001021e2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $123
  1021e4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021e6:	e9 92 fb ff ff       	jmp    101d7d <__alltraps>

001021eb <vector124>:
.globl vector124
vector124:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $124
  1021ed:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021ef:	e9 89 fb ff ff       	jmp    101d7d <__alltraps>

001021f4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $125
  1021f6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f8:	e9 80 fb ff ff       	jmp    101d7d <__alltraps>

001021fd <vector126>:
.globl vector126
vector126:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $126
  1021ff:	6a 7e                	push   $0x7e
  jmp __alltraps
  102201:	e9 77 fb ff ff       	jmp    101d7d <__alltraps>

00102206 <vector127>:
.globl vector127
vector127:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $127
  102208:	6a 7f                	push   $0x7f
  jmp __alltraps
  10220a:	e9 6e fb ff ff       	jmp    101d7d <__alltraps>

0010220f <vector128>:
.globl vector128
vector128:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $128
  102211:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102216:	e9 62 fb ff ff       	jmp    101d7d <__alltraps>

0010221b <vector129>:
.globl vector129
vector129:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $129
  10221d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102222:	e9 56 fb ff ff       	jmp    101d7d <__alltraps>

00102227 <vector130>:
.globl vector130
vector130:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $130
  102229:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10222e:	e9 4a fb ff ff       	jmp    101d7d <__alltraps>

00102233 <vector131>:
.globl vector131
vector131:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $131
  102235:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10223a:	e9 3e fb ff ff       	jmp    101d7d <__alltraps>

0010223f <vector132>:
.globl vector132
vector132:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $132
  102241:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102246:	e9 32 fb ff ff       	jmp    101d7d <__alltraps>

0010224b <vector133>:
.globl vector133
vector133:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $133
  10224d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102252:	e9 26 fb ff ff       	jmp    101d7d <__alltraps>

00102257 <vector134>:
.globl vector134
vector134:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $134
  102259:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10225e:	e9 1a fb ff ff       	jmp    101d7d <__alltraps>

00102263 <vector135>:
.globl vector135
vector135:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $135
  102265:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10226a:	e9 0e fb ff ff       	jmp    101d7d <__alltraps>

0010226f <vector136>:
.globl vector136
vector136:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $136
  102271:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102276:	e9 02 fb ff ff       	jmp    101d7d <__alltraps>

0010227b <vector137>:
.globl vector137
vector137:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $137
  10227d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102282:	e9 f6 fa ff ff       	jmp    101d7d <__alltraps>

00102287 <vector138>:
.globl vector138
vector138:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $138
  102289:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10228e:	e9 ea fa ff ff       	jmp    101d7d <__alltraps>

00102293 <vector139>:
.globl vector139
vector139:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $139
  102295:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10229a:	e9 de fa ff ff       	jmp    101d7d <__alltraps>

0010229f <vector140>:
.globl vector140
vector140:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $140
  1022a1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022a6:	e9 d2 fa ff ff       	jmp    101d7d <__alltraps>

001022ab <vector141>:
.globl vector141
vector141:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $141
  1022ad:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022b2:	e9 c6 fa ff ff       	jmp    101d7d <__alltraps>

001022b7 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $142
  1022b9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022be:	e9 ba fa ff ff       	jmp    101d7d <__alltraps>

001022c3 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $143
  1022c5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022ca:	e9 ae fa ff ff       	jmp    101d7d <__alltraps>

001022cf <vector144>:
.globl vector144
vector144:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $144
  1022d1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022d6:	e9 a2 fa ff ff       	jmp    101d7d <__alltraps>

001022db <vector145>:
.globl vector145
vector145:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $145
  1022dd:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022e2:	e9 96 fa ff ff       	jmp    101d7d <__alltraps>

001022e7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $146
  1022e9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022ee:	e9 8a fa ff ff       	jmp    101d7d <__alltraps>

001022f3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $147
  1022f5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022fa:	e9 7e fa ff ff       	jmp    101d7d <__alltraps>

001022ff <vector148>:
.globl vector148
vector148:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $148
  102301:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102306:	e9 72 fa ff ff       	jmp    101d7d <__alltraps>

0010230b <vector149>:
.globl vector149
vector149:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $149
  10230d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102312:	e9 66 fa ff ff       	jmp    101d7d <__alltraps>

00102317 <vector150>:
.globl vector150
vector150:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $150
  102319:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10231e:	e9 5a fa ff ff       	jmp    101d7d <__alltraps>

00102323 <vector151>:
.globl vector151
vector151:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $151
  102325:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10232a:	e9 4e fa ff ff       	jmp    101d7d <__alltraps>

0010232f <vector152>:
.globl vector152
vector152:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $152
  102331:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102336:	e9 42 fa ff ff       	jmp    101d7d <__alltraps>

0010233b <vector153>:
.globl vector153
vector153:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $153
  10233d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102342:	e9 36 fa ff ff       	jmp    101d7d <__alltraps>

00102347 <vector154>:
.globl vector154
vector154:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $154
  102349:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10234e:	e9 2a fa ff ff       	jmp    101d7d <__alltraps>

00102353 <vector155>:
.globl vector155
vector155:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $155
  102355:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10235a:	e9 1e fa ff ff       	jmp    101d7d <__alltraps>

0010235f <vector156>:
.globl vector156
vector156:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $156
  102361:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102366:	e9 12 fa ff ff       	jmp    101d7d <__alltraps>

0010236b <vector157>:
.globl vector157
vector157:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $157
  10236d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102372:	e9 06 fa ff ff       	jmp    101d7d <__alltraps>

00102377 <vector158>:
.globl vector158
vector158:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $158
  102379:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10237e:	e9 fa f9 ff ff       	jmp    101d7d <__alltraps>

00102383 <vector159>:
.globl vector159
vector159:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $159
  102385:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10238a:	e9 ee f9 ff ff       	jmp    101d7d <__alltraps>

0010238f <vector160>:
.globl vector160
vector160:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $160
  102391:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102396:	e9 e2 f9 ff ff       	jmp    101d7d <__alltraps>

0010239b <vector161>:
.globl vector161
vector161:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $161
  10239d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023a2:	e9 d6 f9 ff ff       	jmp    101d7d <__alltraps>

001023a7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $162
  1023a9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023ae:	e9 ca f9 ff ff       	jmp    101d7d <__alltraps>

001023b3 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $163
  1023b5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023ba:	e9 be f9 ff ff       	jmp    101d7d <__alltraps>

001023bf <vector164>:
.globl vector164
vector164:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $164
  1023c1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023c6:	e9 b2 f9 ff ff       	jmp    101d7d <__alltraps>

001023cb <vector165>:
.globl vector165
vector165:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $165
  1023cd:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023d2:	e9 a6 f9 ff ff       	jmp    101d7d <__alltraps>

001023d7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $166
  1023d9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023de:	e9 9a f9 ff ff       	jmp    101d7d <__alltraps>

001023e3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $167
  1023e5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023ea:	e9 8e f9 ff ff       	jmp    101d7d <__alltraps>

001023ef <vector168>:
.globl vector168
vector168:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $168
  1023f1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023f6:	e9 82 f9 ff ff       	jmp    101d7d <__alltraps>

001023fb <vector169>:
.globl vector169
vector169:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $169
  1023fd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102402:	e9 76 f9 ff ff       	jmp    101d7d <__alltraps>

00102407 <vector170>:
.globl vector170
vector170:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $170
  102409:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10240e:	e9 6a f9 ff ff       	jmp    101d7d <__alltraps>

00102413 <vector171>:
.globl vector171
vector171:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $171
  102415:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10241a:	e9 5e f9 ff ff       	jmp    101d7d <__alltraps>

0010241f <vector172>:
.globl vector172
vector172:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $172
  102421:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102426:	e9 52 f9 ff ff       	jmp    101d7d <__alltraps>

0010242b <vector173>:
.globl vector173
vector173:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $173
  10242d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102432:	e9 46 f9 ff ff       	jmp    101d7d <__alltraps>

00102437 <vector174>:
.globl vector174
vector174:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $174
  102439:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10243e:	e9 3a f9 ff ff       	jmp    101d7d <__alltraps>

00102443 <vector175>:
.globl vector175
vector175:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $175
  102445:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10244a:	e9 2e f9 ff ff       	jmp    101d7d <__alltraps>

0010244f <vector176>:
.globl vector176
vector176:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $176
  102451:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102456:	e9 22 f9 ff ff       	jmp    101d7d <__alltraps>

0010245b <vector177>:
.globl vector177
vector177:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $177
  10245d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102462:	e9 16 f9 ff ff       	jmp    101d7d <__alltraps>

00102467 <vector178>:
.globl vector178
vector178:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $178
  102469:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10246e:	e9 0a f9 ff ff       	jmp    101d7d <__alltraps>

00102473 <vector179>:
.globl vector179
vector179:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $179
  102475:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10247a:	e9 fe f8 ff ff       	jmp    101d7d <__alltraps>

0010247f <vector180>:
.globl vector180
vector180:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $180
  102481:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102486:	e9 f2 f8 ff ff       	jmp    101d7d <__alltraps>

0010248b <vector181>:
.globl vector181
vector181:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $181
  10248d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102492:	e9 e6 f8 ff ff       	jmp    101d7d <__alltraps>

00102497 <vector182>:
.globl vector182
vector182:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $182
  102499:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10249e:	e9 da f8 ff ff       	jmp    101d7d <__alltraps>

001024a3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $183
  1024a5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024aa:	e9 ce f8 ff ff       	jmp    101d7d <__alltraps>

001024af <vector184>:
.globl vector184
vector184:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $184
  1024b1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024b6:	e9 c2 f8 ff ff       	jmp    101d7d <__alltraps>

001024bb <vector185>:
.globl vector185
vector185:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $185
  1024bd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024c2:	e9 b6 f8 ff ff       	jmp    101d7d <__alltraps>

001024c7 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $186
  1024c9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024ce:	e9 aa f8 ff ff       	jmp    101d7d <__alltraps>

001024d3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $187
  1024d5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024da:	e9 9e f8 ff ff       	jmp    101d7d <__alltraps>

001024df <vector188>:
.globl vector188
vector188:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $188
  1024e1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024e6:	e9 92 f8 ff ff       	jmp    101d7d <__alltraps>

001024eb <vector189>:
.globl vector189
vector189:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $189
  1024ed:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024f2:	e9 86 f8 ff ff       	jmp    101d7d <__alltraps>

001024f7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $190
  1024f9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024fe:	e9 7a f8 ff ff       	jmp    101d7d <__alltraps>

00102503 <vector191>:
.globl vector191
vector191:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $191
  102505:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10250a:	e9 6e f8 ff ff       	jmp    101d7d <__alltraps>

0010250f <vector192>:
.globl vector192
vector192:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $192
  102511:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102516:	e9 62 f8 ff ff       	jmp    101d7d <__alltraps>

0010251b <vector193>:
.globl vector193
vector193:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $193
  10251d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102522:	e9 56 f8 ff ff       	jmp    101d7d <__alltraps>

00102527 <vector194>:
.globl vector194
vector194:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $194
  102529:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10252e:	e9 4a f8 ff ff       	jmp    101d7d <__alltraps>

00102533 <vector195>:
.globl vector195
vector195:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $195
  102535:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10253a:	e9 3e f8 ff ff       	jmp    101d7d <__alltraps>

0010253f <vector196>:
.globl vector196
vector196:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $196
  102541:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102546:	e9 32 f8 ff ff       	jmp    101d7d <__alltraps>

0010254b <vector197>:
.globl vector197
vector197:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $197
  10254d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102552:	e9 26 f8 ff ff       	jmp    101d7d <__alltraps>

00102557 <vector198>:
.globl vector198
vector198:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $198
  102559:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10255e:	e9 1a f8 ff ff       	jmp    101d7d <__alltraps>

00102563 <vector199>:
.globl vector199
vector199:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $199
  102565:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10256a:	e9 0e f8 ff ff       	jmp    101d7d <__alltraps>

0010256f <vector200>:
.globl vector200
vector200:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $200
  102571:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102576:	e9 02 f8 ff ff       	jmp    101d7d <__alltraps>

0010257b <vector201>:
.globl vector201
vector201:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $201
  10257d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102582:	e9 f6 f7 ff ff       	jmp    101d7d <__alltraps>

00102587 <vector202>:
.globl vector202
vector202:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $202
  102589:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10258e:	e9 ea f7 ff ff       	jmp    101d7d <__alltraps>

00102593 <vector203>:
.globl vector203
vector203:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $203
  102595:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10259a:	e9 de f7 ff ff       	jmp    101d7d <__alltraps>

0010259f <vector204>:
.globl vector204
vector204:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $204
  1025a1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025a6:	e9 d2 f7 ff ff       	jmp    101d7d <__alltraps>

001025ab <vector205>:
.globl vector205
vector205:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $205
  1025ad:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025b2:	e9 c6 f7 ff ff       	jmp    101d7d <__alltraps>

001025b7 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $206
  1025b9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025be:	e9 ba f7 ff ff       	jmp    101d7d <__alltraps>

001025c3 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $207
  1025c5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025ca:	e9 ae f7 ff ff       	jmp    101d7d <__alltraps>

001025cf <vector208>:
.globl vector208
vector208:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $208
  1025d1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025d6:	e9 a2 f7 ff ff       	jmp    101d7d <__alltraps>

001025db <vector209>:
.globl vector209
vector209:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $209
  1025dd:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025e2:	e9 96 f7 ff ff       	jmp    101d7d <__alltraps>

001025e7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $210
  1025e9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025ee:	e9 8a f7 ff ff       	jmp    101d7d <__alltraps>

001025f3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $211
  1025f5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025fa:	e9 7e f7 ff ff       	jmp    101d7d <__alltraps>

001025ff <vector212>:
.globl vector212
vector212:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $212
  102601:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102606:	e9 72 f7 ff ff       	jmp    101d7d <__alltraps>

0010260b <vector213>:
.globl vector213
vector213:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $213
  10260d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102612:	e9 66 f7 ff ff       	jmp    101d7d <__alltraps>

00102617 <vector214>:
.globl vector214
vector214:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $214
  102619:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10261e:	e9 5a f7 ff ff       	jmp    101d7d <__alltraps>

00102623 <vector215>:
.globl vector215
vector215:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $215
  102625:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10262a:	e9 4e f7 ff ff       	jmp    101d7d <__alltraps>

0010262f <vector216>:
.globl vector216
vector216:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $216
  102631:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102636:	e9 42 f7 ff ff       	jmp    101d7d <__alltraps>

0010263b <vector217>:
.globl vector217
vector217:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $217
  10263d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102642:	e9 36 f7 ff ff       	jmp    101d7d <__alltraps>

00102647 <vector218>:
.globl vector218
vector218:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $218
  102649:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10264e:	e9 2a f7 ff ff       	jmp    101d7d <__alltraps>

00102653 <vector219>:
.globl vector219
vector219:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $219
  102655:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10265a:	e9 1e f7 ff ff       	jmp    101d7d <__alltraps>

0010265f <vector220>:
.globl vector220
vector220:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $220
  102661:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102666:	e9 12 f7 ff ff       	jmp    101d7d <__alltraps>

0010266b <vector221>:
.globl vector221
vector221:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $221
  10266d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102672:	e9 06 f7 ff ff       	jmp    101d7d <__alltraps>

00102677 <vector222>:
.globl vector222
vector222:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $222
  102679:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10267e:	e9 fa f6 ff ff       	jmp    101d7d <__alltraps>

00102683 <vector223>:
.globl vector223
vector223:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $223
  102685:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10268a:	e9 ee f6 ff ff       	jmp    101d7d <__alltraps>

0010268f <vector224>:
.globl vector224
vector224:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $224
  102691:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102696:	e9 e2 f6 ff ff       	jmp    101d7d <__alltraps>

0010269b <vector225>:
.globl vector225
vector225:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $225
  10269d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026a2:	e9 d6 f6 ff ff       	jmp    101d7d <__alltraps>

001026a7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $226
  1026a9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026ae:	e9 ca f6 ff ff       	jmp    101d7d <__alltraps>

001026b3 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $227
  1026b5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026ba:	e9 be f6 ff ff       	jmp    101d7d <__alltraps>

001026bf <vector228>:
.globl vector228
vector228:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $228
  1026c1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026c6:	e9 b2 f6 ff ff       	jmp    101d7d <__alltraps>

001026cb <vector229>:
.globl vector229
vector229:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $229
  1026cd:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026d2:	e9 a6 f6 ff ff       	jmp    101d7d <__alltraps>

001026d7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $230
  1026d9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026de:	e9 9a f6 ff ff       	jmp    101d7d <__alltraps>

001026e3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $231
  1026e5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026ea:	e9 8e f6 ff ff       	jmp    101d7d <__alltraps>

001026ef <vector232>:
.globl vector232
vector232:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $232
  1026f1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026f6:	e9 82 f6 ff ff       	jmp    101d7d <__alltraps>

001026fb <vector233>:
.globl vector233
vector233:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $233
  1026fd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102702:	e9 76 f6 ff ff       	jmp    101d7d <__alltraps>

00102707 <vector234>:
.globl vector234
vector234:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $234
  102709:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10270e:	e9 6a f6 ff ff       	jmp    101d7d <__alltraps>

00102713 <vector235>:
.globl vector235
vector235:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $235
  102715:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10271a:	e9 5e f6 ff ff       	jmp    101d7d <__alltraps>

0010271f <vector236>:
.globl vector236
vector236:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $236
  102721:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102726:	e9 52 f6 ff ff       	jmp    101d7d <__alltraps>

0010272b <vector237>:
.globl vector237
vector237:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $237
  10272d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102732:	e9 46 f6 ff ff       	jmp    101d7d <__alltraps>

00102737 <vector238>:
.globl vector238
vector238:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $238
  102739:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10273e:	e9 3a f6 ff ff       	jmp    101d7d <__alltraps>

00102743 <vector239>:
.globl vector239
vector239:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $239
  102745:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10274a:	e9 2e f6 ff ff       	jmp    101d7d <__alltraps>

0010274f <vector240>:
.globl vector240
vector240:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $240
  102751:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102756:	e9 22 f6 ff ff       	jmp    101d7d <__alltraps>

0010275b <vector241>:
.globl vector241
vector241:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $241
  10275d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102762:	e9 16 f6 ff ff       	jmp    101d7d <__alltraps>

00102767 <vector242>:
.globl vector242
vector242:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $242
  102769:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10276e:	e9 0a f6 ff ff       	jmp    101d7d <__alltraps>

00102773 <vector243>:
.globl vector243
vector243:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $243
  102775:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10277a:	e9 fe f5 ff ff       	jmp    101d7d <__alltraps>

0010277f <vector244>:
.globl vector244
vector244:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $244
  102781:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102786:	e9 f2 f5 ff ff       	jmp    101d7d <__alltraps>

0010278b <vector245>:
.globl vector245
vector245:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $245
  10278d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102792:	e9 e6 f5 ff ff       	jmp    101d7d <__alltraps>

00102797 <vector246>:
.globl vector246
vector246:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $246
  102799:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10279e:	e9 da f5 ff ff       	jmp    101d7d <__alltraps>

001027a3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $247
  1027a5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027aa:	e9 ce f5 ff ff       	jmp    101d7d <__alltraps>

001027af <vector248>:
.globl vector248
vector248:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $248
  1027b1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027b6:	e9 c2 f5 ff ff       	jmp    101d7d <__alltraps>

001027bb <vector249>:
.globl vector249
vector249:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $249
  1027bd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027c2:	e9 b6 f5 ff ff       	jmp    101d7d <__alltraps>

001027c7 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $250
  1027c9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027ce:	e9 aa f5 ff ff       	jmp    101d7d <__alltraps>

001027d3 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $251
  1027d5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027da:	e9 9e f5 ff ff       	jmp    101d7d <__alltraps>

001027df <vector252>:
.globl vector252
vector252:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $252
  1027e1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027e6:	e9 92 f5 ff ff       	jmp    101d7d <__alltraps>

001027eb <vector253>:
.globl vector253
vector253:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $253
  1027ed:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027f2:	e9 86 f5 ff ff       	jmp    101d7d <__alltraps>

001027f7 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $254
  1027f9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027fe:	e9 7a f5 ff ff       	jmp    101d7d <__alltraps>

00102803 <vector255>:
.globl vector255
vector255:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $255
  102805:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10280a:	e9 6e f5 ff ff       	jmp    101d7d <__alltraps>

0010280f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10280f:	55                   	push   %ebp
  102810:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102812:	8b 45 08             	mov    0x8(%ebp),%eax
  102815:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102818:	b8 23 00 00 00       	mov    $0x23,%eax
  10281d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10281f:	b8 23 00 00 00       	mov    $0x23,%eax
  102824:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102826:	b8 10 00 00 00       	mov    $0x10,%eax
  10282b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10282d:	b8 10 00 00 00       	mov    $0x10,%eax
  102832:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102834:	b8 10 00 00 00       	mov    $0x10,%eax
  102839:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10283b:	ea 42 28 10 00 08 00 	ljmp   $0x8,$0x102842
}
  102842:	5d                   	pop    %ebp
  102843:	c3                   	ret    

00102844 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102844:	55                   	push   %ebp
  102845:	89 e5                	mov    %esp,%ebp
  102847:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10284a:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10284f:	05 00 04 00 00       	add    $0x400,%eax
  102854:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102859:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102860:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102862:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102869:	68 00 
  10286b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102870:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102876:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10287b:	c1 e8 10             	shr    $0x10,%eax
  10287e:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102883:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10288a:	83 e0 f0             	and    $0xfffffff0,%eax
  10288d:	83 c8 09             	or     $0x9,%eax
  102890:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102895:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10289c:	83 c8 10             	or     $0x10,%eax
  10289f:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028a4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ab:	83 e0 9f             	and    $0xffffff9f,%eax
  1028ae:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028b3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ba:	83 c8 80             	or     $0xffffff80,%eax
  1028bd:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028c2:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c9:	83 e0 f0             	and    $0xfffffff0,%eax
  1028cc:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d1:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d8:	83 e0 ef             	and    $0xffffffef,%eax
  1028db:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e0:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028e7:	83 e0 df             	and    $0xffffffdf,%eax
  1028ea:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ef:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028f6:	83 c8 40             	or     $0x40,%eax
  1028f9:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028fe:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102905:	83 e0 7f             	and    $0x7f,%eax
  102908:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10290d:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102912:	c1 e8 18             	shr    $0x18,%eax
  102915:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10291a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102921:	83 e0 ef             	and    $0xffffffef,%eax
  102924:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102929:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102930:	e8 da fe ff ff       	call   10280f <lgdt>
  102935:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10293b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10293f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102942:	c9                   	leave  
  102943:	c3                   	ret    

00102944 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102944:	55                   	push   %ebp
  102945:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102947:	e8 f8 fe ff ff       	call   102844 <gdt_init>
}
  10294c:	5d                   	pop    %ebp
  10294d:	c3                   	ret    

0010294e <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10294e:	55                   	push   %ebp
  10294f:	89 e5                	mov    %esp,%ebp
  102951:	83 ec 58             	sub    $0x58,%esp
  102954:	8b 45 10             	mov    0x10(%ebp),%eax
  102957:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10295a:	8b 45 14             	mov    0x14(%ebp),%eax
  10295d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102960:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102963:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102966:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102969:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10296c:	8b 45 18             	mov    0x18(%ebp),%eax
  10296f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102975:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102978:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10297b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102981:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102984:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102988:	74 1c                	je     1029a6 <printnum+0x58>
  10298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10298d:	ba 00 00 00 00       	mov    $0x0,%edx
  102992:	f7 75 e4             	divl   -0x1c(%ebp)
  102995:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10299b:	ba 00 00 00 00       	mov    $0x0,%edx
  1029a0:	f7 75 e4             	divl   -0x1c(%ebp)
  1029a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029ac:	f7 75 e4             	divl   -0x1c(%ebp)
  1029af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029be:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029c4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029c7:	8b 45 18             	mov    0x18(%ebp),%eax
  1029ca:	ba 00 00 00 00       	mov    $0x0,%edx
  1029cf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029d2:	77 56                	ja     102a2a <printnum+0xdc>
  1029d4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029d7:	72 05                	jb     1029de <printnum+0x90>
  1029d9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029dc:	77 4c                	ja     102a2a <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029de:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029e4:	8b 45 20             	mov    0x20(%ebp),%eax
  1029e7:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029eb:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029ef:	8b 45 18             	mov    0x18(%ebp),%eax
  1029f2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a00:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0e:	89 04 24             	mov    %eax,(%esp)
  102a11:	e8 38 ff ff ff       	call   10294e <printnum>
  102a16:	eb 1c                	jmp    102a34 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a1f:	8b 45 20             	mov    0x20(%ebp),%eax
  102a22:	89 04 24             	mov    %eax,(%esp)
  102a25:	8b 45 08             	mov    0x8(%ebp),%eax
  102a28:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a2a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a2e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a32:	7f e4                	jg     102a18 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a37:	05 30 3c 10 00       	add    $0x103c30,%eax
  102a3c:	0f b6 00             	movzbl (%eax),%eax
  102a3f:	0f be c0             	movsbl %al,%eax
  102a42:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a45:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a49:	89 04 24             	mov    %eax,(%esp)
  102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4f:	ff d0                	call   *%eax
}
  102a51:	c9                   	leave  
  102a52:	c3                   	ret    

00102a53 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a53:	55                   	push   %ebp
  102a54:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a56:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a5a:	7e 14                	jle    102a70 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5f:	8b 00                	mov    (%eax),%eax
  102a61:	8d 48 08             	lea    0x8(%eax),%ecx
  102a64:	8b 55 08             	mov    0x8(%ebp),%edx
  102a67:	89 0a                	mov    %ecx,(%edx)
  102a69:	8b 50 04             	mov    0x4(%eax),%edx
  102a6c:	8b 00                	mov    (%eax),%eax
  102a6e:	eb 30                	jmp    102aa0 <getuint+0x4d>
    }
    else if (lflag) {
  102a70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a74:	74 16                	je     102a8c <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a76:	8b 45 08             	mov    0x8(%ebp),%eax
  102a79:	8b 00                	mov    (%eax),%eax
  102a7b:	8d 48 04             	lea    0x4(%eax),%ecx
  102a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  102a81:	89 0a                	mov    %ecx,(%edx)
  102a83:	8b 00                	mov    (%eax),%eax
  102a85:	ba 00 00 00 00       	mov    $0x0,%edx
  102a8a:	eb 14                	jmp    102aa0 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8f:	8b 00                	mov    (%eax),%eax
  102a91:	8d 48 04             	lea    0x4(%eax),%ecx
  102a94:	8b 55 08             	mov    0x8(%ebp),%edx
  102a97:	89 0a                	mov    %ecx,(%edx)
  102a99:	8b 00                	mov    (%eax),%eax
  102a9b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102aa0:	5d                   	pop    %ebp
  102aa1:	c3                   	ret    

00102aa2 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102aa2:	55                   	push   %ebp
  102aa3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102aa5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102aa9:	7e 14                	jle    102abf <getint+0x1d>
        return va_arg(*ap, long long);
  102aab:	8b 45 08             	mov    0x8(%ebp),%eax
  102aae:	8b 00                	mov    (%eax),%eax
  102ab0:	8d 48 08             	lea    0x8(%eax),%ecx
  102ab3:	8b 55 08             	mov    0x8(%ebp),%edx
  102ab6:	89 0a                	mov    %ecx,(%edx)
  102ab8:	8b 50 04             	mov    0x4(%eax),%edx
  102abb:	8b 00                	mov    (%eax),%eax
  102abd:	eb 28                	jmp    102ae7 <getint+0x45>
    }
    else if (lflag) {
  102abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ac3:	74 12                	je     102ad7 <getint+0x35>
        return va_arg(*ap, long);
  102ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac8:	8b 00                	mov    (%eax),%eax
  102aca:	8d 48 04             	lea    0x4(%eax),%ecx
  102acd:	8b 55 08             	mov    0x8(%ebp),%edx
  102ad0:	89 0a                	mov    %ecx,(%edx)
  102ad2:	8b 00                	mov    (%eax),%eax
  102ad4:	99                   	cltd   
  102ad5:	eb 10                	jmp    102ae7 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  102ada:	8b 00                	mov    (%eax),%eax
  102adc:	8d 48 04             	lea    0x4(%eax),%ecx
  102adf:	8b 55 08             	mov    0x8(%ebp),%edx
  102ae2:	89 0a                	mov    %ecx,(%edx)
  102ae4:	8b 00                	mov    (%eax),%eax
  102ae6:	99                   	cltd   
    }
}
  102ae7:	5d                   	pop    %ebp
  102ae8:	c3                   	ret    

00102ae9 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ae9:	55                   	push   %ebp
  102aea:	89 e5                	mov    %esp,%ebp
  102aec:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102aef:	8d 45 14             	lea    0x14(%ebp),%eax
  102af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102afc:	8b 45 10             	mov    0x10(%ebp),%eax
  102aff:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0d:	89 04 24             	mov    %eax,(%esp)
  102b10:	e8 02 00 00 00       	call   102b17 <vprintfmt>
    va_end(ap);
}
  102b15:	c9                   	leave  
  102b16:	c3                   	ret    

00102b17 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b17:	55                   	push   %ebp
  102b18:	89 e5                	mov    %esp,%ebp
  102b1a:	56                   	push   %esi
  102b1b:	53                   	push   %ebx
  102b1c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b1f:	eb 18                	jmp    102b39 <vprintfmt+0x22>
            if (ch == '\0') {
  102b21:	85 db                	test   %ebx,%ebx
  102b23:	75 05                	jne    102b2a <vprintfmt+0x13>
                return;
  102b25:	e9 d1 03 00 00       	jmp    102efb <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b31:	89 1c 24             	mov    %ebx,(%esp)
  102b34:	8b 45 08             	mov    0x8(%ebp),%eax
  102b37:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b39:	8b 45 10             	mov    0x10(%ebp),%eax
  102b3c:	8d 50 01             	lea    0x1(%eax),%edx
  102b3f:	89 55 10             	mov    %edx,0x10(%ebp)
  102b42:	0f b6 00             	movzbl (%eax),%eax
  102b45:	0f b6 d8             	movzbl %al,%ebx
  102b48:	83 fb 25             	cmp    $0x25,%ebx
  102b4b:	75 d4                	jne    102b21 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b4d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b51:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b68:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b6b:	8b 45 10             	mov    0x10(%ebp),%eax
  102b6e:	8d 50 01             	lea    0x1(%eax),%edx
  102b71:	89 55 10             	mov    %edx,0x10(%ebp)
  102b74:	0f b6 00             	movzbl (%eax),%eax
  102b77:	0f b6 d8             	movzbl %al,%ebx
  102b7a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b7d:	83 f8 55             	cmp    $0x55,%eax
  102b80:	0f 87 44 03 00 00    	ja     102eca <vprintfmt+0x3b3>
  102b86:	8b 04 85 54 3c 10 00 	mov    0x103c54(,%eax,4),%eax
  102b8d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b8f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b93:	eb d6                	jmp    102b6b <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b95:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b99:	eb d0                	jmp    102b6b <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ba2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ba5:	89 d0                	mov    %edx,%eax
  102ba7:	c1 e0 02             	shl    $0x2,%eax
  102baa:	01 d0                	add    %edx,%eax
  102bac:	01 c0                	add    %eax,%eax
  102bae:	01 d8                	add    %ebx,%eax
  102bb0:	83 e8 30             	sub    $0x30,%eax
  102bb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  102bb9:	0f b6 00             	movzbl (%eax),%eax
  102bbc:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bbf:	83 fb 2f             	cmp    $0x2f,%ebx
  102bc2:	7e 0b                	jle    102bcf <vprintfmt+0xb8>
  102bc4:	83 fb 39             	cmp    $0x39,%ebx
  102bc7:	7f 06                	jg     102bcf <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bc9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bcd:	eb d3                	jmp    102ba2 <vprintfmt+0x8b>
            goto process_precision;
  102bcf:	eb 33                	jmp    102c04 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bd1:	8b 45 14             	mov    0x14(%ebp),%eax
  102bd4:	8d 50 04             	lea    0x4(%eax),%edx
  102bd7:	89 55 14             	mov    %edx,0x14(%ebp)
  102bda:	8b 00                	mov    (%eax),%eax
  102bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bdf:	eb 23                	jmp    102c04 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102be1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102be5:	79 0c                	jns    102bf3 <vprintfmt+0xdc>
                width = 0;
  102be7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bee:	e9 78 ff ff ff       	jmp    102b6b <vprintfmt+0x54>
  102bf3:	e9 73 ff ff ff       	jmp    102b6b <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bf8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bff:	e9 67 ff ff ff       	jmp    102b6b <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102c04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c08:	79 12                	jns    102c1c <vprintfmt+0x105>
                width = precision, precision = -1;
  102c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c17:	e9 4f ff ff ff       	jmp    102b6b <vprintfmt+0x54>
  102c1c:	e9 4a ff ff ff       	jmp    102b6b <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c21:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c25:	e9 41 ff ff ff       	jmp    102b6b <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  102c2d:	8d 50 04             	lea    0x4(%eax),%edx
  102c30:	89 55 14             	mov    %edx,0x14(%ebp)
  102c33:	8b 00                	mov    (%eax),%eax
  102c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c38:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c3c:	89 04 24             	mov    %eax,(%esp)
  102c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c42:	ff d0                	call   *%eax
            break;
  102c44:	e9 ac 02 00 00       	jmp    102ef5 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c49:	8b 45 14             	mov    0x14(%ebp),%eax
  102c4c:	8d 50 04             	lea    0x4(%eax),%edx
  102c4f:	89 55 14             	mov    %edx,0x14(%ebp)
  102c52:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c54:	85 db                	test   %ebx,%ebx
  102c56:	79 02                	jns    102c5a <vprintfmt+0x143>
                err = -err;
  102c58:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c5a:	83 fb 06             	cmp    $0x6,%ebx
  102c5d:	7f 0b                	jg     102c6a <vprintfmt+0x153>
  102c5f:	8b 34 9d 14 3c 10 00 	mov    0x103c14(,%ebx,4),%esi
  102c66:	85 f6                	test   %esi,%esi
  102c68:	75 23                	jne    102c8d <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c6a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c6e:	c7 44 24 08 41 3c 10 	movl   $0x103c41,0x8(%esp)
  102c75:	00 
  102c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c80:	89 04 24             	mov    %eax,(%esp)
  102c83:	e8 61 fe ff ff       	call   102ae9 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c88:	e9 68 02 00 00       	jmp    102ef5 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c8d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c91:	c7 44 24 08 4a 3c 10 	movl   $0x103c4a,0x8(%esp)
  102c98:	00 
  102c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca3:	89 04 24             	mov    %eax,(%esp)
  102ca6:	e8 3e fe ff ff       	call   102ae9 <printfmt>
            }
            break;
  102cab:	e9 45 02 00 00       	jmp    102ef5 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  102cb3:	8d 50 04             	lea    0x4(%eax),%edx
  102cb6:	89 55 14             	mov    %edx,0x14(%ebp)
  102cb9:	8b 30                	mov    (%eax),%esi
  102cbb:	85 f6                	test   %esi,%esi
  102cbd:	75 05                	jne    102cc4 <vprintfmt+0x1ad>
                p = "(null)";
  102cbf:	be 4d 3c 10 00       	mov    $0x103c4d,%esi
            }
            if (width > 0 && padc != '-') {
  102cc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cc8:	7e 3e                	jle    102d08 <vprintfmt+0x1f1>
  102cca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cce:	74 38                	je     102d08 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cd0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cda:	89 34 24             	mov    %esi,(%esp)
  102cdd:	e8 15 03 00 00       	call   102ff7 <strnlen>
  102ce2:	29 c3                	sub    %eax,%ebx
  102ce4:	89 d8                	mov    %ebx,%eax
  102ce6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ce9:	eb 17                	jmp    102d02 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ceb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cf2:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cf6:	89 04 24             	mov    %eax,(%esp)
  102cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfc:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cfe:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d06:	7f e3                	jg     102ceb <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d08:	eb 38                	jmp    102d42 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d0a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d0e:	74 1f                	je     102d2f <vprintfmt+0x218>
  102d10:	83 fb 1f             	cmp    $0x1f,%ebx
  102d13:	7e 05                	jle    102d1a <vprintfmt+0x203>
  102d15:	83 fb 7e             	cmp    $0x7e,%ebx
  102d18:	7e 15                	jle    102d2f <vprintfmt+0x218>
                    putch('?', putdat);
  102d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d21:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d28:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2b:	ff d0                	call   *%eax
  102d2d:	eb 0f                	jmp    102d3e <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d32:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d36:	89 1c 24             	mov    %ebx,(%esp)
  102d39:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3c:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d3e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d42:	89 f0                	mov    %esi,%eax
  102d44:	8d 70 01             	lea    0x1(%eax),%esi
  102d47:	0f b6 00             	movzbl (%eax),%eax
  102d4a:	0f be d8             	movsbl %al,%ebx
  102d4d:	85 db                	test   %ebx,%ebx
  102d4f:	74 10                	je     102d61 <vprintfmt+0x24a>
  102d51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d55:	78 b3                	js     102d0a <vprintfmt+0x1f3>
  102d57:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d5f:	79 a9                	jns    102d0a <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d61:	eb 17                	jmp    102d7a <vprintfmt+0x263>
                putch(' ', putdat);
  102d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d6a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d71:	8b 45 08             	mov    0x8(%ebp),%eax
  102d74:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d76:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d7e:	7f e3                	jg     102d63 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d80:	e9 70 01 00 00       	jmp    102ef5 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d8c:	8d 45 14             	lea    0x14(%ebp),%eax
  102d8f:	89 04 24             	mov    %eax,(%esp)
  102d92:	e8 0b fd ff ff       	call   102aa2 <getint>
  102d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102da3:	85 d2                	test   %edx,%edx
  102da5:	79 26                	jns    102dcd <vprintfmt+0x2b6>
                putch('-', putdat);
  102da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102daa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dae:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102db5:	8b 45 08             	mov    0x8(%ebp),%eax
  102db8:	ff d0                	call   *%eax
                num = -(long long)num;
  102dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dc0:	f7 d8                	neg    %eax
  102dc2:	83 d2 00             	adc    $0x0,%edx
  102dc5:	f7 da                	neg    %edx
  102dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102dcd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dd4:	e9 a8 00 00 00       	jmp    102e81 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de0:	8d 45 14             	lea    0x14(%ebp),%eax
  102de3:	89 04 24             	mov    %eax,(%esp)
  102de6:	e8 68 fc ff ff       	call   102a53 <getuint>
  102deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dee:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102df1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102df8:	e9 84 00 00 00       	jmp    102e81 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e04:	8d 45 14             	lea    0x14(%ebp),%eax
  102e07:	89 04 24             	mov    %eax,(%esp)
  102e0a:	e8 44 fc ff ff       	call   102a53 <getuint>
  102e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e12:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e15:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e1c:	eb 63                	jmp    102e81 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e21:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e25:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2f:	ff d0                	call   *%eax
            putch('x', putdat);
  102e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e38:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e42:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e44:	8b 45 14             	mov    0x14(%ebp),%eax
  102e47:	8d 50 04             	lea    0x4(%eax),%edx
  102e4a:	89 55 14             	mov    %edx,0x14(%ebp)
  102e4d:	8b 00                	mov    (%eax),%eax
  102e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e60:	eb 1f                	jmp    102e81 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e69:	8d 45 14             	lea    0x14(%ebp),%eax
  102e6c:	89 04 24             	mov    %eax,(%esp)
  102e6f:	e8 df fb ff ff       	call   102a53 <getuint>
  102e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e77:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e88:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e8f:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e93:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ea1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eac:	8b 45 08             	mov    0x8(%ebp),%eax
  102eaf:	89 04 24             	mov    %eax,(%esp)
  102eb2:	e8 97 fa ff ff       	call   10294e <printnum>
            break;
  102eb7:	eb 3c                	jmp    102ef5 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ec0:	89 1c 24             	mov    %ebx,(%esp)
  102ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec6:	ff d0                	call   *%eax
            break;
  102ec8:	eb 2b                	jmp    102ef5 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  102edb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102edd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ee1:	eb 04                	jmp    102ee7 <vprintfmt+0x3d0>
  102ee3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  102eea:	83 e8 01             	sub    $0x1,%eax
  102eed:	0f b6 00             	movzbl (%eax),%eax
  102ef0:	3c 25                	cmp    $0x25,%al
  102ef2:	75 ef                	jne    102ee3 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102ef4:	90                   	nop
        }
    }
  102ef5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ef6:	e9 3e fc ff ff       	jmp    102b39 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102efb:	83 c4 40             	add    $0x40,%esp
  102efe:	5b                   	pop    %ebx
  102eff:	5e                   	pop    %esi
  102f00:	5d                   	pop    %ebp
  102f01:	c3                   	ret    

00102f02 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f02:	55                   	push   %ebp
  102f03:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f08:	8b 40 08             	mov    0x8(%eax),%eax
  102f0b:	8d 50 01             	lea    0x1(%eax),%edx
  102f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f11:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f17:	8b 10                	mov    (%eax),%edx
  102f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1c:	8b 40 04             	mov    0x4(%eax),%eax
  102f1f:	39 c2                	cmp    %eax,%edx
  102f21:	73 12                	jae    102f35 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f26:	8b 00                	mov    (%eax),%eax
  102f28:	8d 48 01             	lea    0x1(%eax),%ecx
  102f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f2e:	89 0a                	mov    %ecx,(%edx)
  102f30:	8b 55 08             	mov    0x8(%ebp),%edx
  102f33:	88 10                	mov    %dl,(%eax)
    }
}
  102f35:	5d                   	pop    %ebp
  102f36:	c3                   	ret    

00102f37 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f37:	55                   	push   %ebp
  102f38:	89 e5                	mov    %esp,%ebp
  102f3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f3d:	8d 45 14             	lea    0x14(%ebp),%eax
  102f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f46:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  102f4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f54:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f58:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5b:	89 04 24             	mov    %eax,(%esp)
  102f5e:	e8 08 00 00 00       	call   102f6b <vsnprintf>
  102f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f69:	c9                   	leave  
  102f6a:	c3                   	ret    

00102f6b <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f6b:	55                   	push   %ebp
  102f6c:	89 e5                	mov    %esp,%ebp
  102f6e:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f71:	8b 45 08             	mov    0x8(%ebp),%eax
  102f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f80:	01 d0                	add    %edx,%eax
  102f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f90:	74 0a                	je     102f9c <vsnprintf+0x31>
  102f92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f98:	39 c2                	cmp    %eax,%edx
  102f9a:	76 07                	jbe    102fa3 <vsnprintf+0x38>
        return -E_INVAL;
  102f9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102fa1:	eb 2a                	jmp    102fcd <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fa3:	8b 45 14             	mov    0x14(%ebp),%eax
  102fa6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102faa:	8b 45 10             	mov    0x10(%ebp),%eax
  102fad:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fb1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb8:	c7 04 24 02 2f 10 00 	movl   $0x102f02,(%esp)
  102fbf:	e8 53 fb ff ff       	call   102b17 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc7:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fcd:	c9                   	leave  
  102fce:	c3                   	ret    

00102fcf <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fcf:	55                   	push   %ebp
  102fd0:	89 e5                	mov    %esp,%ebp
  102fd2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fdc:	eb 04                	jmp    102fe2 <strlen+0x13>
        cnt ++;
  102fde:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe5:	8d 50 01             	lea    0x1(%eax),%edx
  102fe8:	89 55 08             	mov    %edx,0x8(%ebp)
  102feb:	0f b6 00             	movzbl (%eax),%eax
  102fee:	84 c0                	test   %al,%al
  102ff0:	75 ec                	jne    102fde <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102ff2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ff5:	c9                   	leave  
  102ff6:	c3                   	ret    

00102ff7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102ff7:	55                   	push   %ebp
  102ff8:	89 e5                	mov    %esp,%ebp
  102ffa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ffd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103004:	eb 04                	jmp    10300a <strnlen+0x13>
        cnt ++;
  103006:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10300a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10300d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103010:	73 10                	jae    103022 <strnlen+0x2b>
  103012:	8b 45 08             	mov    0x8(%ebp),%eax
  103015:	8d 50 01             	lea    0x1(%eax),%edx
  103018:	89 55 08             	mov    %edx,0x8(%ebp)
  10301b:	0f b6 00             	movzbl (%eax),%eax
  10301e:	84 c0                	test   %al,%al
  103020:	75 e4                	jne    103006 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103022:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103025:	c9                   	leave  
  103026:	c3                   	ret    

00103027 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103027:	55                   	push   %ebp
  103028:	89 e5                	mov    %esp,%ebp
  10302a:	57                   	push   %edi
  10302b:	56                   	push   %esi
  10302c:	83 ec 20             	sub    $0x20,%esp
  10302f:	8b 45 08             	mov    0x8(%ebp),%eax
  103032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103035:	8b 45 0c             	mov    0xc(%ebp),%eax
  103038:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10303b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103041:	89 d1                	mov    %edx,%ecx
  103043:	89 c2                	mov    %eax,%edx
  103045:	89 ce                	mov    %ecx,%esi
  103047:	89 d7                	mov    %edx,%edi
  103049:	ac                   	lods   %ds:(%esi),%al
  10304a:	aa                   	stos   %al,%es:(%edi)
  10304b:	84 c0                	test   %al,%al
  10304d:	75 fa                	jne    103049 <strcpy+0x22>
  10304f:	89 fa                	mov    %edi,%edx
  103051:	89 f1                	mov    %esi,%ecx
  103053:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103056:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103059:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10305f:	83 c4 20             	add    $0x20,%esp
  103062:	5e                   	pop    %esi
  103063:	5f                   	pop    %edi
  103064:	5d                   	pop    %ebp
  103065:	c3                   	ret    

00103066 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103066:	55                   	push   %ebp
  103067:	89 e5                	mov    %esp,%ebp
  103069:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10306c:	8b 45 08             	mov    0x8(%ebp),%eax
  10306f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103072:	eb 21                	jmp    103095 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103074:	8b 45 0c             	mov    0xc(%ebp),%eax
  103077:	0f b6 10             	movzbl (%eax),%edx
  10307a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10307d:	88 10                	mov    %dl,(%eax)
  10307f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103082:	0f b6 00             	movzbl (%eax),%eax
  103085:	84 c0                	test   %al,%al
  103087:	74 04                	je     10308d <strncpy+0x27>
            src ++;
  103089:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10308d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103091:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103095:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103099:	75 d9                	jne    103074 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  10309b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10309e:	c9                   	leave  
  10309f:	c3                   	ret    

001030a0 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1030a0:	55                   	push   %ebp
  1030a1:	89 e5                	mov    %esp,%ebp
  1030a3:	57                   	push   %edi
  1030a4:	56                   	push   %esi
  1030a5:	83 ec 20             	sub    $0x20,%esp
  1030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ba:	89 d1                	mov    %edx,%ecx
  1030bc:	89 c2                	mov    %eax,%edx
  1030be:	89 ce                	mov    %ecx,%esi
  1030c0:	89 d7                	mov    %edx,%edi
  1030c2:	ac                   	lods   %ds:(%esi),%al
  1030c3:	ae                   	scas   %es:(%edi),%al
  1030c4:	75 08                	jne    1030ce <strcmp+0x2e>
  1030c6:	84 c0                	test   %al,%al
  1030c8:	75 f8                	jne    1030c2 <strcmp+0x22>
  1030ca:	31 c0                	xor    %eax,%eax
  1030cc:	eb 04                	jmp    1030d2 <strcmp+0x32>
  1030ce:	19 c0                	sbb    %eax,%eax
  1030d0:	0c 01                	or     $0x1,%al
  1030d2:	89 fa                	mov    %edi,%edx
  1030d4:	89 f1                	mov    %esi,%ecx
  1030d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030d9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030dc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030df:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030e2:	83 c4 20             	add    $0x20,%esp
  1030e5:	5e                   	pop    %esi
  1030e6:	5f                   	pop    %edi
  1030e7:	5d                   	pop    %ebp
  1030e8:	c3                   	ret    

001030e9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030e9:	55                   	push   %ebp
  1030ea:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030ec:	eb 0c                	jmp    1030fa <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030ee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030f6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030fe:	74 1a                	je     10311a <strncmp+0x31>
  103100:	8b 45 08             	mov    0x8(%ebp),%eax
  103103:	0f b6 00             	movzbl (%eax),%eax
  103106:	84 c0                	test   %al,%al
  103108:	74 10                	je     10311a <strncmp+0x31>
  10310a:	8b 45 08             	mov    0x8(%ebp),%eax
  10310d:	0f b6 10             	movzbl (%eax),%edx
  103110:	8b 45 0c             	mov    0xc(%ebp),%eax
  103113:	0f b6 00             	movzbl (%eax),%eax
  103116:	38 c2                	cmp    %al,%dl
  103118:	74 d4                	je     1030ee <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10311a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10311e:	74 18                	je     103138 <strncmp+0x4f>
  103120:	8b 45 08             	mov    0x8(%ebp),%eax
  103123:	0f b6 00             	movzbl (%eax),%eax
  103126:	0f b6 d0             	movzbl %al,%edx
  103129:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312c:	0f b6 00             	movzbl (%eax),%eax
  10312f:	0f b6 c0             	movzbl %al,%eax
  103132:	29 c2                	sub    %eax,%edx
  103134:	89 d0                	mov    %edx,%eax
  103136:	eb 05                	jmp    10313d <strncmp+0x54>
  103138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10313d:	5d                   	pop    %ebp
  10313e:	c3                   	ret    

0010313f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10313f:	55                   	push   %ebp
  103140:	89 e5                	mov    %esp,%ebp
  103142:	83 ec 04             	sub    $0x4,%esp
  103145:	8b 45 0c             	mov    0xc(%ebp),%eax
  103148:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10314b:	eb 14                	jmp    103161 <strchr+0x22>
        if (*s == c) {
  10314d:	8b 45 08             	mov    0x8(%ebp),%eax
  103150:	0f b6 00             	movzbl (%eax),%eax
  103153:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103156:	75 05                	jne    10315d <strchr+0x1e>
            return (char *)s;
  103158:	8b 45 08             	mov    0x8(%ebp),%eax
  10315b:	eb 13                	jmp    103170 <strchr+0x31>
        }
        s ++;
  10315d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103161:	8b 45 08             	mov    0x8(%ebp),%eax
  103164:	0f b6 00             	movzbl (%eax),%eax
  103167:	84 c0                	test   %al,%al
  103169:	75 e2                	jne    10314d <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10316b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103170:	c9                   	leave  
  103171:	c3                   	ret    

00103172 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103172:	55                   	push   %ebp
  103173:	89 e5                	mov    %esp,%ebp
  103175:	83 ec 04             	sub    $0x4,%esp
  103178:	8b 45 0c             	mov    0xc(%ebp),%eax
  10317b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10317e:	eb 11                	jmp    103191 <strfind+0x1f>
        if (*s == c) {
  103180:	8b 45 08             	mov    0x8(%ebp),%eax
  103183:	0f b6 00             	movzbl (%eax),%eax
  103186:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103189:	75 02                	jne    10318d <strfind+0x1b>
            break;
  10318b:	eb 0e                	jmp    10319b <strfind+0x29>
        }
        s ++;
  10318d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  103191:	8b 45 08             	mov    0x8(%ebp),%eax
  103194:	0f b6 00             	movzbl (%eax),%eax
  103197:	84 c0                	test   %al,%al
  103199:	75 e5                	jne    103180 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  10319b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10319e:	c9                   	leave  
  10319f:	c3                   	ret    

001031a0 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1031a0:	55                   	push   %ebp
  1031a1:	89 e5                	mov    %esp,%ebp
  1031a3:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031b4:	eb 04                	jmp    1031ba <strtol+0x1a>
        s ++;
  1031b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bd:	0f b6 00             	movzbl (%eax),%eax
  1031c0:	3c 20                	cmp    $0x20,%al
  1031c2:	74 f2                	je     1031b6 <strtol+0x16>
  1031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c7:	0f b6 00             	movzbl (%eax),%eax
  1031ca:	3c 09                	cmp    $0x9,%al
  1031cc:	74 e8                	je     1031b6 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d1:	0f b6 00             	movzbl (%eax),%eax
  1031d4:	3c 2b                	cmp    $0x2b,%al
  1031d6:	75 06                	jne    1031de <strtol+0x3e>
        s ++;
  1031d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031dc:	eb 15                	jmp    1031f3 <strtol+0x53>
    }
    else if (*s == '-') {
  1031de:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e1:	0f b6 00             	movzbl (%eax),%eax
  1031e4:	3c 2d                	cmp    $0x2d,%al
  1031e6:	75 0b                	jne    1031f3 <strtol+0x53>
        s ++, neg = 1;
  1031e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031f7:	74 06                	je     1031ff <strtol+0x5f>
  1031f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031fd:	75 24                	jne    103223 <strtol+0x83>
  1031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103202:	0f b6 00             	movzbl (%eax),%eax
  103205:	3c 30                	cmp    $0x30,%al
  103207:	75 1a                	jne    103223 <strtol+0x83>
  103209:	8b 45 08             	mov    0x8(%ebp),%eax
  10320c:	83 c0 01             	add    $0x1,%eax
  10320f:	0f b6 00             	movzbl (%eax),%eax
  103212:	3c 78                	cmp    $0x78,%al
  103214:	75 0d                	jne    103223 <strtol+0x83>
        s += 2, base = 16;
  103216:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10321a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103221:	eb 2a                	jmp    10324d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103227:	75 17                	jne    103240 <strtol+0xa0>
  103229:	8b 45 08             	mov    0x8(%ebp),%eax
  10322c:	0f b6 00             	movzbl (%eax),%eax
  10322f:	3c 30                	cmp    $0x30,%al
  103231:	75 0d                	jne    103240 <strtol+0xa0>
        s ++, base = 8;
  103233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103237:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10323e:	eb 0d                	jmp    10324d <strtol+0xad>
    }
    else if (base == 0) {
  103240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103244:	75 07                	jne    10324d <strtol+0xad>
        base = 10;
  103246:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10324d:	8b 45 08             	mov    0x8(%ebp),%eax
  103250:	0f b6 00             	movzbl (%eax),%eax
  103253:	3c 2f                	cmp    $0x2f,%al
  103255:	7e 1b                	jle    103272 <strtol+0xd2>
  103257:	8b 45 08             	mov    0x8(%ebp),%eax
  10325a:	0f b6 00             	movzbl (%eax),%eax
  10325d:	3c 39                	cmp    $0x39,%al
  10325f:	7f 11                	jg     103272 <strtol+0xd2>
            dig = *s - '0';
  103261:	8b 45 08             	mov    0x8(%ebp),%eax
  103264:	0f b6 00             	movzbl (%eax),%eax
  103267:	0f be c0             	movsbl %al,%eax
  10326a:	83 e8 30             	sub    $0x30,%eax
  10326d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103270:	eb 48                	jmp    1032ba <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103272:	8b 45 08             	mov    0x8(%ebp),%eax
  103275:	0f b6 00             	movzbl (%eax),%eax
  103278:	3c 60                	cmp    $0x60,%al
  10327a:	7e 1b                	jle    103297 <strtol+0xf7>
  10327c:	8b 45 08             	mov    0x8(%ebp),%eax
  10327f:	0f b6 00             	movzbl (%eax),%eax
  103282:	3c 7a                	cmp    $0x7a,%al
  103284:	7f 11                	jg     103297 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103286:	8b 45 08             	mov    0x8(%ebp),%eax
  103289:	0f b6 00             	movzbl (%eax),%eax
  10328c:	0f be c0             	movsbl %al,%eax
  10328f:	83 e8 57             	sub    $0x57,%eax
  103292:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103295:	eb 23                	jmp    1032ba <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103297:	8b 45 08             	mov    0x8(%ebp),%eax
  10329a:	0f b6 00             	movzbl (%eax),%eax
  10329d:	3c 40                	cmp    $0x40,%al
  10329f:	7e 3d                	jle    1032de <strtol+0x13e>
  1032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a4:	0f b6 00             	movzbl (%eax),%eax
  1032a7:	3c 5a                	cmp    $0x5a,%al
  1032a9:	7f 33                	jg     1032de <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ae:	0f b6 00             	movzbl (%eax),%eax
  1032b1:	0f be c0             	movsbl %al,%eax
  1032b4:	83 e8 37             	sub    $0x37,%eax
  1032b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032c0:	7c 02                	jl     1032c4 <strtol+0x124>
            break;
  1032c2:	eb 1a                	jmp    1032de <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032cb:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032cf:	89 c2                	mov    %eax,%edx
  1032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032d4:	01 d0                	add    %edx,%eax
  1032d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032d9:	e9 6f ff ff ff       	jmp    10324d <strtol+0xad>

    if (endptr) {
  1032de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032e2:	74 08                	je     1032ec <strtol+0x14c>
        *endptr = (char *) s;
  1032e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e7:	8b 55 08             	mov    0x8(%ebp),%edx
  1032ea:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032f0:	74 07                	je     1032f9 <strtol+0x159>
  1032f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032f5:	f7 d8                	neg    %eax
  1032f7:	eb 03                	jmp    1032fc <strtol+0x15c>
  1032f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032fc:	c9                   	leave  
  1032fd:	c3                   	ret    

001032fe <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032fe:	55                   	push   %ebp
  1032ff:	89 e5                	mov    %esp,%ebp
  103301:	57                   	push   %edi
  103302:	83 ec 24             	sub    $0x24,%esp
  103305:	8b 45 0c             	mov    0xc(%ebp),%eax
  103308:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10330b:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10330f:	8b 55 08             	mov    0x8(%ebp),%edx
  103312:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103315:	88 45 f7             	mov    %al,-0x9(%ebp)
  103318:	8b 45 10             	mov    0x10(%ebp),%eax
  10331b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10331e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103321:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103325:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103328:	89 d7                	mov    %edx,%edi
  10332a:	f3 aa                	rep stos %al,%es:(%edi)
  10332c:	89 fa                	mov    %edi,%edx
  10332e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103331:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103334:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103337:	83 c4 24             	add    $0x24,%esp
  10333a:	5f                   	pop    %edi
  10333b:	5d                   	pop    %ebp
  10333c:	c3                   	ret    

0010333d <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10333d:	55                   	push   %ebp
  10333e:	89 e5                	mov    %esp,%ebp
  103340:	57                   	push   %edi
  103341:	56                   	push   %esi
  103342:	53                   	push   %ebx
  103343:	83 ec 30             	sub    $0x30,%esp
  103346:	8b 45 08             	mov    0x8(%ebp),%eax
  103349:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10334c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103352:	8b 45 10             	mov    0x10(%ebp),%eax
  103355:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10335e:	73 42                	jae    1033a2 <memmove+0x65>
  103360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103366:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103369:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10336c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10336f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103372:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103375:	c1 e8 02             	shr    $0x2,%eax
  103378:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10337a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10337d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103380:	89 d7                	mov    %edx,%edi
  103382:	89 c6                	mov    %eax,%esi
  103384:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103386:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103389:	83 e1 03             	and    $0x3,%ecx
  10338c:	74 02                	je     103390 <memmove+0x53>
  10338e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103390:	89 f0                	mov    %esi,%eax
  103392:	89 fa                	mov    %edi,%edx
  103394:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103397:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10339a:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10339d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033a0:	eb 36                	jmp    1033d8 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ab:	01 c2                	add    %eax,%edx
  1033ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033b0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033bc:	89 c1                	mov    %eax,%ecx
  1033be:	89 d8                	mov    %ebx,%eax
  1033c0:	89 d6                	mov    %edx,%esi
  1033c2:	89 c7                	mov    %eax,%edi
  1033c4:	fd                   	std    
  1033c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033c7:	fc                   	cld    
  1033c8:	89 f8                	mov    %edi,%eax
  1033ca:	89 f2                	mov    %esi,%edx
  1033cc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033cf:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033d2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033d8:	83 c4 30             	add    $0x30,%esp
  1033db:	5b                   	pop    %ebx
  1033dc:	5e                   	pop    %esi
  1033dd:	5f                   	pop    %edi
  1033de:	5d                   	pop    %ebp
  1033df:	c3                   	ret    

001033e0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033e0:	55                   	push   %ebp
  1033e1:	89 e5                	mov    %esp,%ebp
  1033e3:	57                   	push   %edi
  1033e4:	56                   	push   %esi
  1033e5:	83 ec 20             	sub    $0x20,%esp
  1033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033fd:	c1 e8 02             	shr    $0x2,%eax
  103400:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103408:	89 d7                	mov    %edx,%edi
  10340a:	89 c6                	mov    %eax,%esi
  10340c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10340e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103411:	83 e1 03             	and    $0x3,%ecx
  103414:	74 02                	je     103418 <memcpy+0x38>
  103416:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103418:	89 f0                	mov    %esi,%eax
  10341a:	89 fa                	mov    %edi,%edx
  10341c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10341f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103422:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103428:	83 c4 20             	add    $0x20,%esp
  10342b:	5e                   	pop    %esi
  10342c:	5f                   	pop    %edi
  10342d:	5d                   	pop    %ebp
  10342e:	c3                   	ret    

0010342f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10342f:	55                   	push   %ebp
  103430:	89 e5                	mov    %esp,%ebp
  103432:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103435:	8b 45 08             	mov    0x8(%ebp),%eax
  103438:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10343b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103441:	eb 30                	jmp    103473 <memcmp+0x44>
        if (*s1 != *s2) {
  103443:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103446:	0f b6 10             	movzbl (%eax),%edx
  103449:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10344c:	0f b6 00             	movzbl (%eax),%eax
  10344f:	38 c2                	cmp    %al,%dl
  103451:	74 18                	je     10346b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103453:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103456:	0f b6 00             	movzbl (%eax),%eax
  103459:	0f b6 d0             	movzbl %al,%edx
  10345c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10345f:	0f b6 00             	movzbl (%eax),%eax
  103462:	0f b6 c0             	movzbl %al,%eax
  103465:	29 c2                	sub    %eax,%edx
  103467:	89 d0                	mov    %edx,%eax
  103469:	eb 1a                	jmp    103485 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10346b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10346f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103473:	8b 45 10             	mov    0x10(%ebp),%eax
  103476:	8d 50 ff             	lea    -0x1(%eax),%edx
  103479:	89 55 10             	mov    %edx,0x10(%ebp)
  10347c:	85 c0                	test   %eax,%eax
  10347e:	75 c3                	jne    103443 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103480:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103485:	c9                   	leave  
  103486:	c3                   	ret    
