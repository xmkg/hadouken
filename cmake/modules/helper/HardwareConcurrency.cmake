#!/usr/bin/env cmake

# ______________________________________________________
# A CMake module to retrieve logical processor count.
# 
# @file 	HardwareConcurrency.cmake
# @author 	Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 	14.02.2020
# 
# Copyright (c) Nettsi Informatics Technology Inc. 
# All rights reserved. Licensed under the Apache 2.0 License. 
# See LICENSE in the project root for license information.
# 
# SPDX-License-Identifier:	Apache 2.0
# ______________________________________________________

include(ProcessorCount)
ProcessorCount(HARDWARE_CONCURRENCY)