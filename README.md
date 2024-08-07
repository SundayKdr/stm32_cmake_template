## Cmake template for stm32
## How to use
Use this repo as start folder for your stm32 project.
For example quick start:
1. [x] put your .ioc file inside folder
2. [x] build sources in Cube app

Correct root cmake file:

1. prj_name, TARGET_CPU, DEVICE_FAMILY, DEVICE_NAME, DEVICE_FULL_NAME
2. **VENDOR_DIRS** list of stm32 specific dirs (with rel paths) should be there
2. **PRJ_DIRS** list of all folders with your business logic and third_party 
3. The idea is that you can put your libs in **third_party** folder 
using git submodule (git submodule add #link# #folder_name or path#) of fetch content (see cmake/g_test.cmake as example)
4. COMPILE_DEFS list of compile definitions we all be added global(main target and tests)


```cmake
set(prj_name            prj_name)
set(TARGET_CPU          "cortex-m4")
set(DEVICE_FAMILY       STM32G4xx)
set(DEVICE_NAME         STM32G431xx)
set(DEVICE_FULL_NAME    STM32G431CBTX)

set(VENDOR_DIRS Core Drivers Middlewares)
set(PRJ_DIRS app third_party)

set(COMPILE_DEFS
        ${DEVICE_NAME}
        USE_HAL_DRIVER
        #USE_FULL_LL_DRIVER
        #USBPD_PORT_COUNT=1
        #_SNK
        #USBPDCORE_LIB_PD3_FULL
)
```

## Tests
To use Google **gtest** simply:
1. set option to **ON**
```cmake
option(BUILD_TESTS "Build tests" ON)
```
2. put tests in ${PROJECT_SOURCE_DIR}/tests folder