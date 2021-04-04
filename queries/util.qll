import cpp

predicate checkPath(Element el) {
    exists(el.getFile().getRelativePath())
}

predicate isClassAbstract(Class c) { c.isAbstract() }