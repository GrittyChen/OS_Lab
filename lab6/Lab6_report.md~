#Lab6 Report
#【练习0】填写已有实验   
本实验依赖实验1/2/3/4/5。请把你做的实验2/3/4/5的代码填入本实验中代码中有"LAB1"/"LAB2"/"LAB3"/"LAB4"/"LAB5"的注释相应部分。并确保编译通过。注意:为了能够正确执行lab6的测试应用程序,可能需对已完成的实验1/2/3/4/5的代码进行进一步改进。  

> 根据注释将前期实验的代码拷贝到相应的位置，注意有几个地方标识了Lab6的地方就需要在前面实验的基础上update一下代码，主要有两个地方：第一处是Lab1的第三处，需要添加一个run_timer_list()函数即可，第二处是Lab4的第一处在经过Lab的update之后还需要初始化几个proc的成员变量(rq, run_link, time_slice, lab6_run_pool, lab6_stride, lab6_priority)。这样练习0就完成了。  

#【练习1】使用Round Robin调度算法(不需要编码)    
完成练习0后,建议大家比较一下(可用kdiff3等文件比较软件)个人完成的lab5和练习0完成后的刚修改的lab6之间的区别,分析了解lab6采用RR调度算法后的执行过程。执行make	grade,大部分测试用例应该通过。但执行priority.c应该过不去。  

> 完成实验0之后执行make grade之后的结果如下:  
```
grittychen@grittychen-K45VD:~/桌面/lab6$ make grade
badsegment:              (2.8s)
  -check result:                             OK
  -check output:                             OK
divzero:                 (1.5s)
  -check result:                             OK
  -check output:                             OK
softint:                 (1.5s)
  -check result:                             OK
  -check output:                             OK
faultread:               (1.5s)
  -check result:                             OK
  -check output:                             OK
faultreadkernel:         (1.5s)
  -check result:                             OK
  -check output:                             OK
hello:                   (1.5s)
  -check result:                             OK
  -check output:                             OK
testbss:                 (1.6s)
  -check result:                             OK
  -check output:                             OK
pgdir:                   (1.5s)
  -check result:                             OK
  -check output:                             OK
yield:                   (1.5s)
  -check result:                             OK
  -check output:                             OK
badarg:                  (1.5s)
  -check result:                             OK
  -check output:                             OK
exit:                    (1.5s)
  -check result:                             OK
  -check output:                             OK
spin:                    (2.1s)
  -check result:                             OK
  -check output:                             OK
waitkill:                (4.1s)
  -check result:                             OK
  -check output:                             OK
forktest:                (1.6s)
  -check result:                             OK
  -check output:                             OK
forktree:                (1.5s)
  -check result:                             OK
  -check output:                             OK
matrix:                  (12.8s)
  -check result:                             OK
  -check output:                             OK
priority:                (21.5s)
  -check result:                             WRONG
   -e !! error: missing 'sched class: stride_scheduler'
   !! error: missing 'stride sched correct result: 1 2 3 4 5'

  -check output:                             OK
Total Score: 163/170
make: *** [grade] 错误 1
```
除了priority其他都是对的，练习0基本正确。  

#【练习1问题1】
请理解并分析sched_calss中各个函数指针的用法,并接合Round	Robin调度算法描ucore的调度执行过程   

> 首先我们列出sched_calss的结构体:   
```
struct sched_class {
    // the name of sched_class
    const char *name;
    // Init the run queue
    void (*init)(struct run_queue *rq);
    // put the proc into runqueue, and this function must be called with rq_lock
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // get the proc out runqueue, and this function must be called with rq_lock
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // choose the next runnable task
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // dealer of the time-tick
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
    /* for SMP support in the future
     *  load_balance
     *     void (*load_balance)(struct rq* rq);
     *  get some proc from this rq, used in load_balance,
     *  return value is the num of gotten proc
     *  int (*get_proc)(struct rq* rq, struct proc* procs_moved[]);
     */
};
```
其中总共有五个函数，作用分别是:   
void (*init)(struct run_queue *rq);--初始化执行队列   
void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);--将当前进程加入执行队列   
void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);--将当前进程弹出执行队列   
struct proc_struct *(*pick_next)(struct run_queue *rq);--选出下一个可执行的进程   
void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);--计算整个队列当中的proc的tick，进行更新操作   
ucore操作系统中RR调度算法的调度流程是选择当前队列中第一个可执行进程运行，当该进程的时间片使用完或者进程结束则选择下一个进程运行，若是因为时间片使用完导致进程切换，则须将当前进程添加到队列尾部，然后继续执行。   

#【练习1问题2】   
请在实验报告中简要说明如何设计实现"多级反馈队列调度算法",给出概要设计,鼓励给出详细设计   

> 大体的设计思路是设计多个优先级不同的队列，每个队列对应的时间片不同，高优先级对应的时间片短，当一个进程处于高优先级队列被调度执行一个时间片未结束，则将其放入优先级低一级的队列中去，若当前执行队列为空，则低优先级队列抢占高优先级队列执行。这样就答题实现了多级反馈队列调度算法，在每隔队列中的调度仍按照RR调度机制。   

#【练习2】实现Stride Scheduling调度算法(需要编码)    
首先需要换掉RR调度器的实现,即用default_sched_stride_c覆盖default_sched.c。然后根据此文件和后续文档对Stride度器的相关描述,完成Stride调度算法的实现。   

> 实现流程如下:   
(1)定义BIG_STRIDE的值，根据理论知识，所以我把他定义为0x60000000 = 2^30;   
```
#define BIG_STRIDE  0x60000000  /* you should give a value, and is ??? */
```
(2)完成stride_init函数:   
```
static void
stride_init(struct run_queue *rq) {
    list_init(&(rq->run_list));
    if(rq->lab6_run_pool != NULL)
      skew_heap_init(rq->lab6_run_pool);
    rq->proc_num = 0;
    return;
     /* LAB6: YOUR CODE
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0
      */
}
```
即完成初始化工作，按照注释实现即可;  
(3)完成stride_enqueue函数:  
```
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
    proc->time_slice = rq->max_time_slice;
    proc->rq = rq;
    rq->proc_num++;
    return;
     /* LAB6: YOUR CODE
      * (1) insert the proc into rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_insert: insert a entry into skew_heap
      *         list_add_before: insert  a entry into the last of list
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */
}
```
即完成入队操作函数，这一部分的重点在与第一步，选择什么方法将proc插入rp中，由于考虑到完成的是lab6，所以我选择了skew_heap_insert的方法实现，然后接下来按照注释完成即可;  
(4)完成stride_dequeue函数:  
```
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
  rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
  rq->proc_num--;
  return;
     /* LAB6: YOUR CODE
      * (1) remove the proc from rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
}
```
即完成出队操作函数，与入队操作相对应，选择skew_heap_remove函数来完成出队操作，并将进程数减1完成整个函数;  
(5)完成stride_pick_next函数:  
```
static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
    struct proc_struct *p = NULL;
    if(rq->lab6_run_pool){
	p=le2proc(rq->lab6_run_pool, lab6_run_pool);
	p->lab6_stride += (BIG_STRIDE / p->lab6_priority);
    }
    return p;
     /* LAB6: YOUR CODE
      * (1) get a  proc_struct pointer p  with the minimum value of stride
             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_poll
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
}
```
即完成选择下一个执行的进程操作函数，按照算法要求选择最小的stride值选择要运行的进程即可，注意的是与前面对应，选择的是le2proc方法实现进程的选择，然后更新选择进程的stride值即可，返回选出的进程，完成函数;  
(6)完成stride_proc_tick函数:  
```
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE */
    if(proc->time_slice > 0){
	proc->time_slice--;
    }
    if(proc->time_slice == 0){
	proc->need_resched = 1;
    }
    return;
}
```
根据doc中的代码实现时间处理函数即可;   
