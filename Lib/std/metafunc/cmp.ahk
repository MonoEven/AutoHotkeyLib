cmp(obj1, obj2)
{
    try
        return (obj1 > obj2) ? 1 : (obj1 = obj2) ? 0 : -1
    
    if obj1.__class != obj2._class
        return "uncomparable"
    else if hasmethod(obj1, "__cmp")
        return obj1.cmp(obj2)
    else
        return "uncomparable"
}
