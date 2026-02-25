@echo off
setlocal enabledelayedexpansion

:: 1. 判断环境变量
if defined ANDROID_HOME (
    set "BASE_PATH=%ANDROID_HOME%"
    echo [INFO] 使用 ANDROID_HOME: !BASE_PATH!
) else if defined ANDROID_SDK_ROOT (
    set "BASE_PATH=%ANDROID_SDK_ROOT%"
    echo [INFO] 使用 ANDROID_SDK_ROOT: !BASE_PATH!
) else (
    echo [ERROR] 未找到环境变量 ANDROID_HOME 或 ANDROID_SDK_ROOT。
    pause
    exit /b
)

:: 检查路径是否存在
if not exist "!BASE_PATH!" (
    echo [ERROR] 路径不存在: !BASE_PATH!
    pause
    exit /b
)
SET NDK_PATH=!BASE_PATH!\ndk
echo.
echo 正在扫描子目录...
echo ---------------------------------------

:: 2. 列出子目录供用户选择
set count=0
for /f "delims=" %%i in ('dir /ad /b "!NDK_PATH!"') do (
    set /a count+=1
    set "dir!count!=%%i"
    echo [!count!] %%i
)

if %count% == 0 (
    echo [WARN] 该目录下没有子目录。
    pause
    exit /b
)

echo ---------------------------------------
echo.

:: 3. 获取用户输入
set /p choice="请输入目录对应的序号 [1-!count!]: "

:: 4. 验证输入并打印完整目录
if not defined dir%choice% (
    echo [ERROR] 无效的选择。
    pause
    exit /b
)

:: 获取用户选中的子目录名称
set "SELECTED_SUBDIR=!dir%choice%!"

:: 拼接完整路径
:: 注意：这里处理了路径末尾可能有或没有斜杠的情况
set "FULL_PATH=!NDK_PATH!"
if "!FULL_PATH:~-1!"=="\" (
    set "RESULT=!FULL_PATH!!SELECTED_SUBDIR!"
) else (
    set "RESULT=!FULL_PATH!\!SELECTED_SUBDIR!"
)

echo.
echo =======================================
echo 选中的完整路径为:
echo "!RESULT!"
echo =======================================
echo.


SET TOOLCHAIN_FILE="!RESULT!\build\cmake\android.toolchain.cmake"

CD /D %~dp0
SET vs_dir=D:\Program Files\Microsoft Visual Studio\2022\Professional\VC\
CALL "%vs_dir%Auxiliary\Build\vcvars64.bat"

CALL :MakeAndroid armeabi-v7a armeabi-v7a
CALL :MakeAndroid arm64-v8a armeabi-arm64


PAUSE
EXIT /b



:: -------------------------------------------------------------------
:: 函数定义
:: -------------------------------------------------------------------
:MakeAndroid
SET ANDROID_ABI=%1
SET target_dir=%2
REM SET TOOLCHAIN_FILE="D:\Android\Sdk\ndk\21.4.7075529\build\cmake\android.toolchain.cmake"
SET BUILD_TYPE="Release"
SET ANDROID_API=21
SET ANDROID_STL="c++_shared"
SET builddir=build_android-%ANDROID_ABI%
IF EXIST "%builddir%" (
	rmdir /s /q "%builddir%"
)
MKDIR "%builddir%"
PUSHD "%builddir%"

set _PARAMS=-DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE%
SET _PARAMS=%_PARAMS% -DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang
SET _PARAMS=%_PARAMS% -DANDROID_NATIVE_API_LEVEL=%ANDROID_API%
SET _PARAMS=%_PARAMS% -DANDROID_ABI=%ANDROID_ABI%
SET _PARAMS=%_PARAMS% -DANDROID_STL=%ANDROID_STL%
SET _PARAMS=%_PARAMS% -DCMAKE_BUILD_TYPE=%BUILD_TYPE%

cmake -G"Ninja" %_PARAMS% ../
cmake --build ./ --
POPD

copy /Y "%builddir%\liblua.a" "Library\Android\%target_dir%\liblua.a"
goto :EOF
