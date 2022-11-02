#Include <std\metafunc\iter>

oneloop(_func, _iter, iternum := 1, flag := "")
{
    ret := []
    tmplst := []
    tmplst.length := iternum
    _enum := iter(_iter).__enum(iternum)
    reflst := [&tmp1, &tmp2, &tmp3, &tmp4, &tmp5, &tmp6, &tmp7, &tmp8, &tmp9, &tmp10, &tmp11, &tmp12, &tmp13, &tmp14, &tmp15, &tmp16, &tmp17, &tmp18, &tmp19]
    reflst.length := iternum
    while _enum(reflst*)
    {
        loop iternum
            tmplst[A_Index] := %reflst[A_Index]%
        if !(flag is func) || flag(tmplst*)
        {
            if _func = ""
            {
                if iternum = 1
                    ret.push(tmplst*)
                else
                    ret.push(tmplst.clone())
            }
            else
                ret.push(_func(tmplst*))
        }
    }
    return ret
}
