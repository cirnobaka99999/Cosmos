@echo off

REM Necessary to set dir when running as admin
cd %~dp0

echo Compiling cosmos
cd "..\..\source"
%windir%\Microsoft.NET\Framework\V3.5\msbuild Cosmos.sln /maxcpucount /verbosity:normal /nologo /p:Configuration=Bootstrap /p:Platform=x86
rem /t:Rebuild
cd ..\Build\VSIP\

echo Copying files
xcopy /Y ..\..\Source\libraries\MDbg\raw.* .
xcopy /Y ..\..\Source\libraries\MDbg\corapi.* .
xcopy /Y ..\..\source2\Build\Cosmos.Build.MSBuild\Cosmos.targets .
xcopy /Y ..\..\source2\Build\Cosmos.Build.Common\bin\Debug\Cosmos.Build.Common.* .
xcopy /Y ..\..\source2\Build\Cosmos.Build.MSBuild\bin\Debug\Cosmos.Build.MSBuild.* .
xcopy /Y ..\..\source2\IL2PCU\Cosmos.IL2CPU.Debug\bin\Debug\Cosmos.Compiler.Debug.* .
xcopy /Y ..\..\source2\debug\Cosmos.Debug.Common\bin\debug\Cosmos.Debug.Common.* .
xcopy /Y ..\..\source2\debug\Cosmos.Debug.HostProcess\bin\debug\Cosmos.Debug.HostProcess.* .
xcopy /Y ..\..\source2\debug\Cosmos.Debug.VSDebugEngine\bin\debug\Cosmos.Debug.VSDebugEngine.* .
xcopy /Y ..\..\source\Cosmos\Cosmos.Hardware\bin\debug\Cosmos.Hardware2.* .
xcopy /Y ..\..\source\Cosmos.Hardware.Plugs\bin\Debug\Cosmos.Hardware.Plugs.* .
xcopy /Y ..\..\source2\IL2PCU\Cosmos.IL2CPU\bin\debug\Cosmos.IL2CPU.* .
xcopy /Y ..\..\source2\IL2PCU\Cosmos.IL2CPU.x86\bin\debug\Cosmos.IL2CPU.X86.* .
xcopy /Y ..\..\source\Cosmos\Cosmos.Kernel\bin\debug\Cosmos.Kernel.* .
xcopy /Y ..\..\source\Cosmos\Cosmos.Kernel.Plugs\bin\debug\Cosmos.Kernel.Plugs.* .
xcopy /Y ..\..\source\Cosmos\Cosmos.System\bin\debug\Cosmos.Sys.* .
xcopy /Y ..\..\source\Cosmos\Cosmos.Sys.Plugs\bin\Debug\Cosmos.Sys.Plugs.* .
xcopy /Y ..\..\source\Cosmos.Kernel.FileSystems\bin\debug\Cosmos.Sys.FileSystem.* .
xcopy /Y ..\..\source2\VSIP\Cosmos.VS.Package\bin\Debug\Cosmos.VS.Package.* .
xcopy /Y "..\..\source2\VSIP\Cosmos.VS.Package\obj\x86\Debug\Cosmos.zip" .
xcopy /Y "..\..\source2\VSIP\Cosmos.VS.Package\obj\x86\Debug\CosmosProject (C#).zip" .
xcopy /Y "..\..\source2\VSIP\Cosmos.VS.Package\obj\x86\Debug\CosmosKernel (C#).zip" .

REM xcopy /Y "..\..\source2\VSIP\Cosmos.VS.Package\obj\Debug\CosmosProject (VB).zip" .
REM xcopy /Y "..\..\source2\VSIP\Cosmos.VS.Package\obj\Debug\CosmosKernel (VB).zip" .
REM splitup compiler:
xcopy /Y ..\..\source2\Compiler\Cosmos.Compiler.Assembler\bin\debug\Cosmos.Compiler.Assembler.* .
xcopy /Y ..\..\source2\Compiler\Cosmos.Compiler.Assembler.X86\bin\debug\Cosmos.Compiler.Assembler.X86.* .
xcopy /Y ..\..\source2\Compiler\Cosmos.Compiler.DebugStub\bin\debug\Cosmos.Compiler.DebugStub.* .
xcopy /Y ..\..\source2\Compiler\Cosmos.Compiler.XSharp\bin\debug\Cosmos.Compiler.XSharp.* .

echo .
echo .
echo .
echo Creating setup.exe
REM Try one, then if not there the other for x64
IF EXIST "C:\Program Files\Inno Setup 5\ISCC.exe" (
	"C:\Program Files\Inno Setup 5\ISCC" /Q ..\..\Setup2\Cosmos.iss /dBuildConfiguration=Devkit
) ELSE (
	"C:\Program Files (x86)\Inno Setup 5\ISCC" /Q ..\..\Setup2\Cosmos.iss /dBuildConfiguration=Devkit
)

..\..\Setup2\Output\CosmosUserKit.exe /SILENT

rem Relaunch VS
rem calling .sln doesnt work. Might be related to having 2010 and 2008 both installed
rem ..\..\source\Cosmos.sln
"C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe" ..\..\source\Cosmos.sln
"C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe" ..\..\source\Cosmos.sln
