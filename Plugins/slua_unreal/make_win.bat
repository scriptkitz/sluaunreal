REM mkdir build_win32 & pushd build_win32
REM cmake -G "Visual Studio 17 2022" ..
REM popd
REM cmake --build build_win32 --config RelWithDebInfo
REM md Library\Win32
REM copy /Y build_win32\RelWithDebInfo\lua.lib Library\Win32\lua.lib
REM copy /Y build_win32\RelWithDebInfo\lua.pdb Library\Win32\lua.pdb

mkdir build_win64 & pushd build_win64
cmake -G "Visual Studio 17 2022" -A x64 ..
popd
cmake --build build_win64 --config RelWithDebInfo
md Library\Win64
copy /Y build_win64\RelWithDebInfo\lua.lib Library\Win64\lua.lib
copy /Y build_win32\RelWithDebInfo\lua.pdb Library\Win64\lua.pdb