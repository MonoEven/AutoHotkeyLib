iter(_iter)
{
    if hasmethod(_iter, "__enum")
        return _iter
    else if hasprop(_iter, "array")
        return _iter.array
    else if hasmethod(_iter, "ownprops")
        return _iter.ownprops()
    else
        throw Error("uniterable", -1)
}
