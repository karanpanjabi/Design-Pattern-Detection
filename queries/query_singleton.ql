/**
 * @kind problem
 */

import cpp

predicate hasRestrictedConstructors(Class c) {
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

predicate hasStaticFunctionWithSameReturn(Class c) {
    exists(
        MemberFunction f |
        f = c.getAMemberFunction() and
        f.getName() != c.getName() and
        f.isStatic() and
        f.getType().stripType() = c
    )
}

predicate hasNoFriends(Class c) {
    not exists(
        Class other |
        other.inMemberOrFriendOf(c) and
        other != c
    )
}

predicate hasStaticVariableWithSameType(Class c) {
    exists(
        MemberVariable v |
        v = c.getAMemberVariable() and
        v.isStatic() and
        v.getType().stripType() = c
    )
}

predicate hasMemberFunctionWithStaticVar(Class c) {
    exists(
        StaticLocalVariable v |
        v.getType().stripType() = c and
        v.getEnclosingElement() = c.getAMemberFunction()
    )
}

from Class c
where 
    // c.getName().regexpMatch(".*ingle.*")
    // and
    hasRestrictedConstructors(c)
    and
    hasStaticFunctionWithSameReturn(c)
    and
    hasNoFriends(c)
    and
    (hasStaticVariableWithSameType(c)
    or
    hasMemberFunctionWithStaticVar(c))

select c, c.getLocation()