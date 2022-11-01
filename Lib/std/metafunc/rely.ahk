rely(obj)
{
    err_rely := []
    if !hasmethod(obj, "__rely")
        return true
    
    installdir := RegRead("HKLM\SOFTWARE\AutoHotkey", "InstallDir", "")
    for i in obj.__rely()
    {
        arr_i := strsplit(i, " ")
        lib_i := arr_i[1]
        ver_i := arr_i[2]
        if fileexist(format("{}\Lib\{}", installdir, i))
        {
            if vercompare(version(strsplit(lib_i, "\")[-1]), ver_i)
                continue
        }
        err_rely.push(i)
    }
    if !err_rely.length
        return true
    return err_rely
}

version(_class)
{
    if hasmethod(_class, "__version")
        return _class.__version()
    return "0.0.0"
}