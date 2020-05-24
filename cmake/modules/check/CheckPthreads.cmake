#!/usr/bin/env cmake

# ______________________________________________________
# CMake file to check whether pthreads available in compilation environment.
# 
# @file 	CheckPthreads.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	25.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

set(CMAKE_REQUIRED_QUIET true)
set(CMAKE_REQUIRED_LIBRARIES "-lpthread")

check_cxx_source_compiles("
    #include <pthread.h>
    extern \"C\" void* thread_proc(void* arg)
    {
    return arg;
    }
    int main(void)
    {
        pthread_mutex_t mut;
        int result = pthread_mutex_init(&mut, 0);
        if(0 == result)
        {
            result |= pthread_mutex_lock(&mut);
            result |= pthread_mutex_unlock(&mut);
            result |= pthread_mutex_trylock(&mut);
            result |= pthread_mutex_unlock(&mut);
            result |= pthread_mutex_destroy(&mut);

            pthread_t t;
            int r = pthread_create(&t, 0, &thread_proc, 0);
            // result |= r;
            if(r == 0)
            {
                //
                // If we can create a thread, then we must be able to join to it:
                //
                void* arg;
                r = pthread_join(t, &arg);
                result |= r;
            }
        }
        return result;
    }
    "
    ${PB_PARENT_PROJECT_NAME_UPPER}_FEATURE_HAS_PTHREADS
)