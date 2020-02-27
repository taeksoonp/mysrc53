/*
 * https://www.joinc.co.kr/w/man/3/pthread_cond_wait
 */
#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <iostream>

using namespace std;

void *ping(void *);
void *pong(void *);

pthread_mutex_t sync_mutex;
pthread_cond_t  sync_cond;

pthread_mutex_t gmutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t  gcond  = PTHREAD_COND_INITIALIZER;

int main()
{
    vector<void *(*)(void *)> thread_list;
    vector<pthread_t> tident(2);
    int thresult;
    int status;
    int i;

    pthread_mutex_init(&sync_mutex, NULL);
    pthread_cond_init(&sync_cond, NULL);

    thread_list.push_back(pong);
    thread_list.push_back(ping);

    for(i = 0; i < thread_list.size(); i++ )
    {
        pthread_mutex_lock(&sync_mutex);
        if (pthread_create(&tident[i], NULL, thread_list[i], (void *)NULL) <0)
        {
            perror("error:");
            exit(0);
        }
        pthread_cond_wait(&sync_cond, &sync_mutex);
        pthread_mutex_unlock(&sync_mutex);
    }
    for (i = 0; i < tident.size(); i++)
    {
        pthread_join(tident[i], (void **)&status);
    }
}

const int howmany = 10;
void *ping(void *data)
{
    pthread_mutex_lock(&sync_mutex);
    pthread_cond_signal(&sync_cond);
    pthread_mutex_unlock(&sync_mutex);
    for(int i=0; i<howmany; i++)
    {
        pthread_mutex_lock(&gmutex);
        printf("%d : ping\n", i);
        pthread_cond_signal(&gcond);
        pthread_cond_wait(&gcond, &gmutex);
        pthread_mutex_unlock(&gmutex);
        usleep(random()%100);
    }

    std::cout <<"ping-bye\n";

    return 0;
}

void *pong(void *data)
{
    pthread_mutex_lock(&sync_mutex);
    sleep(1);
    pthread_cond_signal(&sync_cond);
    pthread_mutex_unlock(&sync_mutex);
    for(int i=0; i<howmany; i++)
    {
        pthread_mutex_lock(&gmutex);
        pthread_cond_wait(&gcond, &gmutex);
        printf("%d : pong\n", i);
        pthread_cond_signal(&gcond);
        pthread_mutex_unlock(&gmutex);
    }

    std::cout <<"pong-bye\n";

    return 0;
}
