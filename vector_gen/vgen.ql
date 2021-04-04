/**
 * @kind problem
 */

import cpp

predicate checkPath(Element el) {
    exists(el.getFile().getRelativePath())
}

query predicate hasRestrictedConstructors(Class c) {
    checkPath(c) and
    exists(
        NoArgConstructor cons |
        cons = c.getAConstructor() and
        (cons.isPrivate() or cons.isProtected())
    ) 
    and
    exists(
        CopyConstructor cons |
        cons = c.getAConstructor() and
        (cons.isPrivate() or 
        cons.isDeleted()
        )
    )
}

query predicate hasStaticFunctionWithSameReturn(Class c) {
    checkPath(c) and
    exists(
        MemberFunction f |
        f = c.getAMemberFunction() and
        f.getName() != c.getName() and
        f.isStatic() and
        f.getType().stripType() = c
    )
}

query predicate hasNoFriends(Class c) {
    checkPath(c) and
    not exists(
        Class other |
        other.inMemberOrFriendOf(c) and
        other != c
    )
}

query predicate hasStaticVariableWithSameType(Class c) {
    checkPath(c) and
    exists(
        MemberVariable v |
        v = c.getAMemberVariable() and
        v.isStatic() and
        v.getType().stripType() = c
    )
}

query predicate hasMemberFunctionWithStaticVar(Class c) {
    checkPath(c) and
    exists(
        StaticLocalVariable v |
        v.getType().stripType() = c and
        v.getEnclosingElement() = c.getAMemberFunction()
    )
}

query predicate getAllClasses(Class c) {
    checkPath(c) 
    // and
    // result = c.getQualifiedName()
}