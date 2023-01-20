" GUI Configuration"
set guifont=Consolas:h10
"colorscheme desert
colorscheme torte
set noeb vb t_vb=

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nospell

set number
set nowrap
set spell spelllang=en_us
syntax on

" Setup functions (VS11)
function! VSSetupCall(cmd)
    let VS='C:\Program Files (x86)\Microsoft Visual Studio 11.0\'
    execute "!start \"".VS."VC\\vcvarsall.bat\""." && ".a:cmd . " & pause"
   " execute "!echo \"".VS."VC\\vcvarsall.bat\""." && ".a:cmd . " & pause"
endfunction


" Main project configuration
let P='F:\Pegasus\SB_kgarcia\'
let GNM_ROOT='C:\Program\\\ Files\\\ (x86)\SCE\ORBIS\\\ SDKs\5.000\target\include_common\gnm'

" Pegasus specific build commands"
function! CompileFilePegasus(rootPath,pkg,targetFile,pathBack)
    let CMD="MSBuild ".a:rootPath."\Project\\VS11\\Pegasus\\".a:pkg."\\".a:pkg.".vcxproj /p:Configuration=Dev-Debug /t:ClCompile /p:SelectedFiles=\"".a:pathBack."Source\\Pegasus\\".a:pkg."\\".a:targetFile."\""
    call VSSetupCall(CMD)
endfunction

function! CompileCurrentFilePegasus(rootPath)
    let pathArray = split(@%,"\\")
    let pathArrayLen = len(pathArray)
    let pkg = pathArray[5]
    let targetFile = pathArray[pathArrayLen - 1]
    let pathBack = "..\\..\\..\\..\\"
    if pkg == "Render"
        let targetFile = pathArray[pathArrayLen - 2]."\\".targetFile
    endif
    call CompileFilePegasus(a:rootPath,pkg,targetFile,pathBack)
endfunction

" FB build specific build commands"
function! CtagFrostbite(root, fbproject, enginefolder)
    let CodePath = a:root.":\\".a:fbproject."\\TnT\\Code\\".a:enginefolder."\\"
    let TagPath = CodePath."tags"
    execute "!".a:root.": && cd ".CodePath". && ctags -R --extra=f -h \".h.hpp\""
    let &tags.=",".TagPath
endfunction

" FB build specific build commands"
function! CtagLoadFrostbite(root, fbproject, enginefolder)
    let CodePath = a:root.":\\".a:fbproject."\\TnT\\Code\\".a:enginefolder."\\"
    let TagPath = CodePath."tags"
    execute "set tags+=".TagPath
endfunction


" FB build specific build commands"
function! CSGenFrostbite(root, fbproject, enginefolder)
    let CodePath = a:root.":\\".a:fbproject."\\TnT\\Code\\".a:enginefolder."\\"
    execute "!dir /S /B ".CodePath." | findstr .*\\.h$ > ".CodePath."cscope.files && dir /S /B ".CodePath." | findstr .*\\.cpp >> ".CodePath."cscope.files && pushd ".CodePath." && cscope -b && popd"
endfunction

" FB build specific build commands"
function! CSLoadFrostbite(root, fbproject, enginefolder)
    let CodePath = a:root.":\\".a:fbproject."\\TnT\\Code\\".a:enginefolder."\\"
    execute "cscope add ".CodePath."\\cscope.out"
endfunction

" Unity build specific build commands"
function! CtagUnity(root, uproject, enginefolder)
    let CodePath = a:root.":\\".a:uproject."\\".a:enginefolder."\\"
    let TagPath = CodePath."tags"
    execute "!".a:root.": && cd ".CodePath". && ctags -R --extra=f -h \".h.hpp\" --langmap=c:.c.hlsl.shader.compute"
    let &tags.=",".TagPath
endfunction
" Unity build specific build commands"
function! CtagLoadUnity(root, uproject, enginefolder)
    let CodePath = a:root.":\\".a:uproject."\\".a:enginefolder."\\"
    let TagPath = CodePath."tags"
    execute "set tags+=".TagPath
endfunction
" Unity build specific build commands"
function! CSGenUnity(root, uproject, enginefolder)
    let CodePath = a:root.":\\".a:uproject."\\".a:enginefolder."\\"
    silent execute "!dir /S /B ".CodePath." | findstr .*\\.shader$ >  ".CodePath."cscope.files"
    silent execute "!dir /S /B ".CodePath." | findstr .*\\.hlsl$   >> ".CodePath."cscope.files"
    silent execute "!dir /S /B ".CodePath." | findstr .*\\.h$      >> ".CodePath."cscope.files"
    silent execute "!dir /S /B ".CodePath." | findstr .*\\.cpp$    >> ".CodePath."cscope.files"
    silent execute "!dir /S /B ".CodePath." | findstr .*\\.compute$ >> ".CodePath."cscope.files"
    silent execute "!dir /S /B ".CodePath." | findstr .*\\.cs$    >> ".CodePath."cscope.files"
    execute "!pushd ".CodePath." && cscope -b && popd"
endfunction
" FB build specific build commands"
function! CSLoadUnity(root, uproject, enginefolder)
    let CodePath = a:root.":\\".a:uproject."\\".a:enginefolder."\\"
    execute "cscope add ".CodePath."\\cscope.out"
endfunction

command! CP execute "\"C:\\Program Files (x86)\\Microsoft Visual Studio 11.0\\Common7\\IDE\\devenv.com\" ".P."Project\\VS11\\Pegasus.sln /Build Dev-Debug"
command! -nargs=* CF  call CompileCurrentFilePegasus(P)

" Pegasus Syntax cmds
command! CSGenpg execute "!dir /S /B ".P." | findstr .*\\.h$ > ".P."cscope.files && dir /S /B ".P." | findstr .*\\.cpp >> ".P."cscope.files && pushd ".P." && cscope -b && popd"
command! CSLoadpg  cscope add F:\Pegasus\SB_kgarcia\cscope.out
command! Genpg execute "!pushd ".P."Source && ctags -R && popd && pushd ".P."Include && ctags -R && popd"
command! Loadpg set tags+=F:\Pegasus\SB_kgarcia\Include\tags,F:\Pegasus\SB_kgarcia\Source\tags
command! Loaddx set tags+=C:\d3d11h\tags
command! Loadgnm execute "set tags+=".GNM_ROOT."\\tags,".GNM_ROOT."x\\tags"
command! Genqt execute "!pushd C:\\Qt\\Qt5.1.0\\5.1.0\\msvc2012\\include && ctags -R"
command! Loadqt set tags+=C:\Qt\Qt5.1.0\5.1.0\msvc2012\include\tags
command! -nargs=* CtagFB call CtagFrostbite(<f-args>)
command! -nargs=* CtagLoadFB call CtagLoadFrostbite(<f-args>)
command! -nargs=* CSGenFb call CSGenFrostbite(<f-args>)
command! -nargs=* CSLoadFb call CSLoadFrostbite(<f-args>)
command! -nargs=* CtagU call CtagUnity(<f-args>)
command! -nargs=* CtagLoadU call CtagLoadUnity(<f-args>)
command! -nargs=* CSGenU call CSGenUnity(<f-args>)
command! -nargs=* CSLoadU call CSLoadUnity(<f-args>)
