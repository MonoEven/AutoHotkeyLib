#Include <std\metafunc\iter>

sum(_iter, start := 0)
{
    ret := start
    for i in iter(_iter)
    {
        if ret is string
            ret .= i
        else if ret is number
            ret += i
        else if ret is array
            ret.extend(i)
        else if ret is map
            ret.update(i)
        else if hasmethod(ret, "add")
            ret.add(i)
        else if ret is object
            ret.update(i)
        else
            throw Error("unsumable", -1)
    }
    return ret
}
