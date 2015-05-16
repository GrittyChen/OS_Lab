#include <stdio.h>
#include <proc.h>
#include <sem.h>
#include <monitor.h>
#include <assert.h>

#define N 5 /* 鍝插瀹舵暟鐩�*/
#define LEFT (i-1+N)%N /* i鐨勫乏閭诲彿鐮�*/
#define RIGHT (i+1)%N /* i鐨勫彸閭诲彿鐮�*/
#define THINKING 0 /* 鍝插瀹舵鍦ㄦ�鑰�*/
#define HUNGRY 1 /* 鍝插瀹舵兂鍙栧緱鍙夊瓙 */
#define EATING 2 /* 鍝插瀹舵鍦ㄥ悆闈�*/
#define TIMES  4 /* 鍚�娆￠キ */
#define SLEEP_TIME 10

//---------- philosophers problem using semaphore ----------------------
int state_sema[N]; /* 璁板綍姣忎釜浜虹姸鎬佺殑鏁扮粍 */
/* 淇″彿閲忔槸涓�釜鐗规畩鐨勬暣鍨嬪彉閲�*/
semaphore_t mutex; /* 涓寸晫鍖轰簰鏂�*/
semaphore_t s[N]; /* 姣忎釜鍝插瀹朵竴涓俊鍙烽噺 */

struct proc_struct *philosopher_proc_sema[N];

void phi_test_sema(i) /* i锛氬摬瀛﹀鍙风爜浠�鍒癗-1 */
{ 
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
            &&state_sema[RIGHT]!=EATING)
    {
        state_sema[i]=EATING;
        up(&s[i]);
    }
}

void phi_take_forks_sema(int i) /* i锛氬摬瀛﹀鍙风爜浠�鍒癗-1 */
{ 
        down(&mutex); /* 杩涘叆涓寸晫鍖�*/
        state_sema[i]=HUNGRY; /* 璁板綍涓嬪摬瀛﹀i楗ラタ鐨勪簨瀹�*/
        phi_test_sema(i); /* 璇曞浘寰楀埌涓ゅ彧鍙夊瓙 */
        up(&mutex); /* 绂诲紑涓寸晫鍖�*/
        down(&s[i]); /* 濡傛灉寰椾笉鍒板弶瀛愬氨闃诲 */
}

void phi_put_forks_sema(int i) /* i锛氬摬瀛﹀鍙风爜浠�鍒癗-1 */
{ 
        down(&mutex); /* 杩涘叆涓寸晫鍖�*/
        state_sema[i]=THINKING; /* 鍝插瀹惰繘椁愮粨鏉�*/
        phi_test_sema(LEFT); /* 鐪嬩竴涓嬪乏閭诲眳鐜板湪鏄惁鑳借繘椁�*/
        phi_test_sema(RIGHT); /* 鐪嬩竴涓嬪彸閭诲眳鐜板湪鏄惁鑳借繘椁�*/
        up(&mutex); /* 绂诲紑涓寸晫鍖�*/
}

int philosopher_using_semaphore(void * arg) /* i锛氬摬瀛﹀鍙风爜锛屼粠0鍒癗-1 */
{
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_sema\n",i);
    while(iter++<TIMES)
    { /* 鏃犻檺寰幆 */
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 鍝插瀹舵鍦ㄦ�鑰�*/
        do_sleep(SLEEP_TIME);
        phi_take_forks_sema(i); 
        /* 闇�涓ゅ彧鍙夊瓙锛屾垨鑰呴樆濉�*/
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 杩涢 */
        do_sleep(SLEEP_TIME);
        phi_put_forks_sema(i); 
        /* 鎶婁袱鎶婂弶瀛愬悓鏃舵斁鍥炴瀛�*/
    }
    cprintf("No.%d philosopher_sema quit\n",i);
    return 0;    
}

//-----------------philosopher problem using monitor ------------
/*PSEUDO CODE :philosopher problem using monitor
 * monitor dp
 * {
 *  enum {thinking, hungry, eating} state[5];
 *  condition self[5];
 *
 *  void pickup(int i) {
 *      state[i] = hungry;
 *      if ((state[(i+4)%5] != eating) && (state[(i+1)%5] != eating)) {
 *        state[i] = eating;
 *      else
 *         self[i].wait();
 *   }
 *
 *   void putdown(int i) {
 *      state[i] = thinking;
 *      if ((state[(i+4)%5] == hungry) && (state[(i+3)%5] != eating)) {
 *          state[(i+4)%5] = eating;
 *          self[(i+4)%5].signal();
 *      }
 *      if ((state[(i+1)%5] == hungry) && (state[(i+2)%5] != eating)) {
 *          state[(i+1)%5] = eating;
 *          self[(i+1)%5].signal();
 *      }
 *   }
 *
 *   void init() {
 *      for (int i = 0; i < 5; i++)
 *         state[i] = thinking;
 *   }
 * }
 */

struct proc_struct *philosopher_proc_condvar[N]; // N philosopher
int state_condvar[N];                            // the philosopher's state: EATING, HUNGARY, THINKING  
monitor_t mt, *mtp=&mt;                          // monitor

void phi_test_condvar (i) { 
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
            &&state_condvar[RIGHT]!=EATING) {
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
        state_condvar[i] = EATING ;
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
        cond_signal(&mtp->cv[i]) ;
    }
}


void phi_take_forks_condvar(int i) {
     down(&(mtp->mutex));
//--------into routine in monitor--------------
     // LAB7 EXERCISE1: YOUR CODE
     // I am hungry
     state_condvar[i] = HUNGRY;
     // try to get fork
     phi_test_condvar(i);
     while(state_condvar[i] != EATING){
	 cond_wait(&mtp->cv[i]);
     }
//--------leave routine in monitor--------------
      if(mtp->next_count>0)
         up(&(mtp->next));
      else
         up(&(mtp->mutex));
}

void phi_put_forks_condvar(int i) {
     down(&(mtp->mutex));

//--------into routine in monitor--------------
     // LAB7 EXERCISE1: YOUR CODE
     // I ate over
     state_condvar[i] = THINKING;
     // test left and right neighbors
     phi_test_condvar(LEFT);
     phi_test_condvar(RIGHT);
//--------leave routine in monitor--------------
     if(mtp->next_count>0)
        up(&(mtp->next));
     else
        up(&(mtp->mutex));
}

//---------- philosophers using monitor (condition variable) ----------------------
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
  
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_condvar\n",i);
    while(iter++<TIMES)
    { /* iterate*/
        cprintf("Iter %d, No.%d philosopher_condvar is thinking\n",iter,i); /* thinking*/
        do_sleep(SLEEP_TIME);
        phi_take_forks_condvar(i); 
        /* need two forks, maybe blocked */
        cprintf("Iter %d, No.%d philosopher_condvar is eating\n",iter,i); /* eating*/
        do_sleep(SLEEP_TIME);
        phi_put_forks_condvar(i); 
        /* return two forks back*/
    }
    cprintf("No.%d philosopher_condvar quit\n",i);
    return 0;    
}

void check_sync(void){

    int i;

    //check semaphore
    sem_init(&mutex, 1);
    for(i=0;i<N;i++){
        sem_init(&s[i], 0);
        int pid = kernel_thread(philosopher_using_semaphore, (void *)i, 0);
        if (pid <= 0) {
            panic("create No.%d philosopher_using_semaphore failed.\n");
        }
        philosopher_proc_sema[i] = find_proc(pid);
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
    }

    //check condition variable
    monitor_init(&mt, N);
    for(i=0;i<N;i++){
        state_condvar[i]=THINKING;
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
        if (pid <= 0) {
            panic("create No.%d philosopher_using_condvar failed.\n");
        }
        philosopher_proc_condvar[i] = find_proc(pid);
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
    }
}
