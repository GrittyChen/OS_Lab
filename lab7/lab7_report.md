#Lab7 Report  
#【练习0】填写已有实验  
本实验依赖实验1/2/3/4/5/6。请把你做的实验1/2/3/4/5/6的代码填入本实验中代码中有"LAB1"/"LAB2"/"LAB3"/"LAB4"/"LAB5"/"LAB6"的注释相应部分。并确保编译通过。注意:为了能够正确执行lab7的测试应用程序,可能需对已完成的实验1/2/3/4/5/6的代码进行进一步改进。  

> 直接将lab6更新后的代码拷贝到lab7相应位置即可。  

#【练习1】理解内核级信号量的实现和基于内核级信号量的哲学家就餐问题(不需要编码)  
1、请在实验报告中给出内核级信号量的设计描述,并说其大致执行流流程。  

> 首先我们看看内核级信号量的数据结构及其操作函数:  
```
typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;
void sem_init(semaphore_t *sem, int value);
void up(semaphore_t *sem);
void down(semaphore_t *sem);
bool try_down(semaphore_t *sem);
```
从中我们可以看出内核级信号量包含两个成员变量，一个是值(value)代表的是剩余资源的数量，另一个是等待队列(wait_queue)表示等待资源的进程队列。接着我们可以看到与信号量相关的操作函数有四个，我们逐个分析:  
sem_init函数:  
```
void
sem_init(semaphore_t *sem, int value) {
    sem->value = value;
    wait_queue_init(&(sem->wait_queue));
}
```
这个函数就是对一个信号量进行初始化，设置资源数和等待队列，即value值和wait_queue。  
up函数:  
```
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        else {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}
void
up(semaphore_t *sem) {
    __up(sem, WT_KSEM);
}
```
从上述代码我们可以看到这个函数调用__up函数，功能是当有一个进程释放了某个资源后，先检查等待队列是否为空，也就是是否有进程在等待该资源，若没有，则将value加1，说明此资源数增加，因为有进程释放了该资源，若不为空，即有进程等待该资源，则不需将value加1，直接唤醒该进程，将释放的资源给该进程，其实这个函数相当于V操作。  
down函数:  
```
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);
    schedule();
    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);
    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
void
down(semaphore_t *sem) {
    uint32_t flags = __down(sem, WT_KSEM);
    assert(flags == 0);
}
```
从上面代码我们可以看出down函数调用__down函数，功能是先判断value的值，若大于0则直接将value减1，也就是分配了一个资源给进程；若小于等于0则需要将进程放入等待队列并且进行调度，直到有进程释放了该资源且调度到该进程时才能唤醒此进程，其实这个函数相当于P操作。  
try_down函数:  
```
bool
try_down(semaphore_t *sem) {
    bool intr_flag, ret = 0;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --, ret = 1;
    }
    local_intr_restore(intr_flag);
    return ret;
}
```
从上面代码可以看出这个函数就是一个尝试做down操作的函数。  
内核信号量的大致执行流程是:对于一个会被多个进程访问的资源设置一个信号量并进行初始化，即进行sem_init操作，当有进程申请该资源时，进行down操作，当有进程释放该资源时进行up操作。  

2、请在实验报告中给出给用户态进程/线程提供信号量机制的设计方案,并比较说明给内核级提供信号量机制的异同。  

> 用户级的信号量机制跟内核级是一样的，所做的操作基本是一样，我们可以在用内核级维护一个与用户进程相关的信号量，当用户进程使用信号量时，跳转到内核态调用这个相关信号量，然后进行一系列操作。与内核级信号量不同的是用户级信号量需要进入到内核态做相关操作，而内核级不需要。  

#【练习2】完成内核级条件变量和基于内核级条件变量的哲学家就餐问题(需要编码)  
首先掌握管程机制,然后基于信号量实现完成条件变量实现,然后用管程机制实现哲学家就餐问题的解决方案(基于条件变量)。  

> 按照注释完成code,详情见代码(kern/sync/monitor.c and kern/sync/check_sync.c)  

1、请在实验报告中给出内核级条件变量的设计描述,并说其大致执行流流程。  

> 我们看条件变量的数据结构及其操作函数:  
```
typedef struct condvar{
    semaphore_t sem;        // the sem semaphore  is used to down the waiting proc, and the signaling proc should up the waiting proc
    int count;              // the number of waiters on condvar
    monitor_t * owner;      // the owner(monitor) of this condvar
} condvar_t;
typedef struct monitor{
    semaphore_t mutex;      // the mutex lock for going into the routines in monitor, should be initialized to 1
    semaphore_t next;       // the next semaphore is used to down the signaling proc itself, and the other OR wakeuped waiting proc should wake up the sleeped signaling proc.
    int next_count;         // the number of of sleeped signaling proc
    condvar_t *cv;          // the condvars in monitor
} monitor_t;
// Initialize variables in monitor.
void     monitor_init (monitor_t *cvp, size_t num_cv);
// Unlock one of threads waiting on the condition variable. 
void     cond_signal (condvar_t *cvp);
// Suspend calling thread on a condition variable waiting for condition atomically unlock mutex in monitor,
// and suspends calling thread on conditional variable after waking up locks mutex.
void     cond_wait (condvar_t *cvp);
```
我们逐个分析其操作函数:  
monitor_init()函数:初始化条件变量,将next_count置为0,对mutex,next进行初始化,并分配num个condvar_t,将cv的count置为0,初始化sem和owner.  
cond_signal()函数:如果cv的count>0就说明有进程在等待,需要唤醒等待在cv.sem上的进程,并使自己睡眠,同时monitor.next_count++,在被唤醒后执行monitor.next_count--;如果cv的count=0,说明没有进程在等待cv.sem,则直接退出.  
cond_wait()函数:先将cv.count++,如果monitor.next_count>0,说明有进程执行cond_signal()函数并且处于sleep状态,此时唤醒进程;否则,说明目前没有因为执行了cond_signal()函数的进程处于sleep状态,此时唤醒因为互斥条件mutex无法进入管程的进程.  

2、请在实验报告中给出给用户态进程/线程提供条件变量机制的设计方案,并比较说明给内核级提供条件变量机制的异同。  

> 同上面的用户级信号量,用户级条件变量机制跟内核级条件变量是一样的,只需要维护一个内核的条件变量与之对应,当进程使用条件变量时,直接切换到内核态进行操作即可。与内核级条件变量机制不同的是需要进入内核态,有进程的转换。  
