cmp(obj1, obj2)
{
    try
        return (obj1 > obj2) ? 1 : (obj1 = obj2) ? 0 : -1
    
    if obj1.__class != obj2.__class
        return "uncomparable"
    else if hasmethod(obj1, "__cmp")
        return obj1.__cmp(obj2)
    else
        throw Error("uncomparable", -1)
}
