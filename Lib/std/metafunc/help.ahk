help(obj)
{
    if obj.hasmethod("help")
        return obj.__help()
    
    return "no help message"
}