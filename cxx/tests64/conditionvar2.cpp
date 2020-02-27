#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define ttrace(...) do {\
	fprintf(stderr, "%s:%d>>> ",strrchr(__FILE__,'/')? strrchr(__FILE__,'/')+1:__FILE__,__LINE__);\
	fprintf(stderr,__VA_ARGS__);}while(0)

pthread_mutex_t mutex_lock   = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t   thread_cond  = PTHREAD_COND_INITIALIZER;

struct com_data
{
    int a;
    int b;
};

struct com_data mydata;

void *do_write(void *data)
{
    mydata.a = 0;
    mydata.b = 0;
    while(1)
    {
        pthread_mutex_lock(&mutex_lock);
        mydata.a = random() % 6000;
        mydata.b = random() % 6000;
        ttrace("wb4 cond %d\n", thread_cond);
        pthread_cond_signal(&thread_cond);
        ttrace("wafter cond %d\n", thread_cond);
        pthread_mutex_unlock(&mutex_lock);
        sleep(2);
    }
}

void *do_read(void *data)
{
    while(1)
    {
        pthread_mutex_lock(&mutex_lock);
        ttrace("rb4 cond %d\n", thread_cond);
        pthread_cond_wait(&thread_cond, &mutex_lock);
        ttrace("rafter cond %d\n", thread_cond);
        printf("%4d + %4d = %4d\n", mydata.a, mydata.b, mydata.a + mydata.b);
        pthread_mutex_unlock(&mutex_lock);
    }

    return 0;
}

int main()
{
    pthread_t p_thread[2];
    int thr_id;
    long status;
    long a = 1;
    int b = 2;

    thr_id = pthread_create(&p_thread[0], NULL, do_write, (void *)&a);
    thr_id = pthread_create(&p_thread[1], NULL, do_read, (void *)&b);

    pthread_join(p_thread[0], (void **) status);
    pthread_join(p_thread[1], (void **) status);

    return 0;
}
