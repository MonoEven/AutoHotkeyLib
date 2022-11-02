#Include <std\metafunc\len>
#Include <std\metafunc\iter>

zip(_iter*)
{
    ret := []
    miniter := ""
    minnum := len(_iter[1])
    for i in _iter
    {
        if len(i) < minnum
        {
            miniter := i
            minnum := len(i)
        }
    }
    loop minnum
        ret.push([])
    for i in _iter
    {
        for j in iter(i)
        {
            ret[A_Index].push(j)
            if A_Index = minnum
                break
        }
    }
    return ret
}
