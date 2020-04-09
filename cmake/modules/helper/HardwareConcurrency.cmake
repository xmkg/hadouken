# ______________________________________________________
# Contains the list of required includes for the project boilerplate.
# 
# @file 		HardwareConcurrency.cmake
# @author 		Mustafa Kemal GILOR <mgilor@nettsi.com>
# @date 		14.02.2020
# 
# @copyright   2020 NETTSI Informatics Technology Inc.
# 
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# ______________________________________________________

include(ProcessorCount)
ProcessorCount(HARDWARE_CONCURRENCY)