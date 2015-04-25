#Report of Lab4   
#【练习0】填写已有实验   
本实验依赖实验1/2/3。请把你做的实验1/2/3的代码填入本实验中代码中有"LAB1","LAB2","LAB3"的注释相应部分。   

> 直接将lab1、lab2、lab3实验代码拷贝到相应的位置即可，详情见代码。   

#【练习1】 分配并初始化一个进程控制块   
alloc_proc函数(位于kern/process/proc.c中)负责分配并返回一个新的struct	proc_struct结构,用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化,你需要完成这个初始化过程。   

> 根据代码注释我们需要设置state/pid/runs/kstack/need_resched/parent/mm/context/tf/cr3/flags/name这几个进程的参数,根据代码提示将state设为PROC_UNINIT;然后将pid/runs/kstack/need_resched/flags都设为0;将parent设为current,将/mm/tf都设为NULL;再将cr3设为系统初始的boot_cr3;最后初始化一下context和name即可,在这个函数的实现中我们并不需要给这些进程参数设置具体的值,只需要给他们分配空间进行简单的初始化即可。(详情见代码)   

#【练习1问题】   
请说明proc_struct中struct context context和struct trapframe *tf成员变量含义和在本实验中的作用是啥?(提示通过看代码和编程调试可以判断出来)   

> context是进程的上下文信息;而tf是当前中断(current interrupt)指针;context的作用是在进程转换过程中用来保存进程的上下文,以便在进程转换时能保留进程的上下文信息;tf的作用就是用来处理interrupt的,这个变量指向当前中interrupt，这样给予我们处理interrupt带来了很大方便。   

#【练习2】为新创建的内核线程分配资源   
创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用do_fork函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块,但alloc_proc只是找到了一小块内存用以记录进程的必要信息,并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是,创建当前内核线程的一个副本,它们的执行上下文、代码、数据都一样,但是存储位置不同。在这个过程中,需要给新内核线程分配资源,并且复制原进程的状态。你需要完成在kern/process/proc.c中的do_fork函数中的处理过程。   

> 按照实验指导提示以及注释提示的流程,完成该函数的流程为(详情见代码):   
1、调用alloc_proc来给新进程分配相应的空间以及初步的初始化;   
2、调用setup_kstack函数给进程分配一个内核栈;   
3、调用copy_mm函数复制原进程的内存管理信息到新进程;   
4、调用copy_thread函数复制原进程上下文到新进程;   
5、调用hash_proc和list_add函数将进程添加到hash_list和proc_list(注意要将nr_process+1);   
6、调用wakeup_proc函数唤醒进程;   
7、将返回值ret设为进程pid(在此之前需要调用get_pid()函数来获得进程pid)。   

#【练习2问题】   
请说明ucore是否做到给每个新fork的线程一个唯一的id?请说明你的分析和理由。   

> 一般来说是可以保证的,因为当进程的个数不超过MAX_PID的时候我们能够保证每个进程的pid不同,因为这时pid是递增的,当超过MAX_PID的进程被创建了,我们的get_pid()函数就会执行一个循环去查找前MAX_PID个进程,知道找到一个pid在0-MAX_PID之间的进程被释放后我们就将这个新创建进程的pid设为这个被释放的进程的pid;这样理论上是可以保证每个进程的pid都是唯一的。   

#【练习3】阅读代码,理解proc_run函数和它调用的函数如何完成进程切换的   

> 其实proc_run函数的大致过程是第一步保存现场,即保存进程转换前的现场,从local_intr_save(intr_flag);语句我们可以看出;然后就是进程转换的过程,先让当前进程变为转换后的进程(current = proc;)然后切换函数调用栈的栈指针(load_esp0(next->kstack + KSTACKSIZE);)接着切换页表基址(lcr3(next->cr3);)最后切换进程上下文(switch_to(&(prev->context), &(next->context));)进程转换完成后我们需要恢复现场(local_intr_restore(intr_flag);)这样整个进程切换就完成了。   

#【练习3问题1】   
在本实验的执行过程中,创建且运行了几个内核线程?   

> 创建了两个内核进程,一个是pid为0的idleproc进程,另一个是pid为1的idleproc进程   

#【练习3问题2】  
语句 local_intr_save(intr_flag);....local_intr_restore(intr_flag);在这里有何作用?请说明理由  

> 这两个语句的作用是保存现场和恢复现场的作用,因为进程切换是当做中断来处理的,我们在进程切换前需要保存现场,之后需要恢复现场。  
