import cpp

predicate checkPath(Element el) {
    exists(el.getFile().getRelativePath())
}