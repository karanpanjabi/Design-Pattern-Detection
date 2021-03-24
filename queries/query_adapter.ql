/**
 * @kind problem
 */

import cpp
import semmle.code.cpp.Print

import util

module AdapterPredicates {
    predicate hasNameMismatch(MemberFunction target_func, MemberFunction adaptee_func) {
        target_func.getName() != adaptee_func.getName()
    }

    predicate hasArgumentMismatch(MemberFunction target_func, MemberFunction adaptee_func) {

        // # of params
        target_func.getNumberOfParameters() != adaptee_func.getNumberOfParameters() or

        // type mismatch
        exists(
            int i |
            target_func.getParameter(i).getType() != adaptee_func.getParameter(i).getType()
        )
    }

    predicate hasMismatch(MemberFunction target_func, MemberFunction adaptee_func) {
        hasNameMismatch(target_func, adaptee_func) or
        hasArgumentMismatch(target_func, adaptee_func)
    }

    predicate overridesBaseMethod(MemberFunction func, Class baseType) {
        exists(
            MemberFunction target_func | 
            target_func = func.getAnOverriddenFunction() and
            target_func.getDeclaringType() = baseType
        )
    }

    predicate setTargetAndAdaptee(Class adapter, Class target, Class adaptee) {
        adapter != target and
        not adaptee.derivesFrom(target) and
        adapter != adaptee and

        not adaptee.isAbstract() and

        exists(
            ClassDerivation t_der, MemberFunction adapter_func, MemberFunction adaptee_func |

            // adapter.getName() = "Adapter" and
            // target.getName() = "Target" and
            t_der.getASpecifier().hasName("public") and
            t_der.getBaseClass() = target and
            t_der.getDerivedClass() = adapter and

            // polymorphic checks
            target.isPolymorphic() and
            adapter_func = adapter.getAMemberFunction() and
            overridesBaseMethod(adapter_func, target) and

            // object check
            adapter.getAMemberVariable().getType().stripType() = adaptee and

            // function call check to adaptee
            adaptee_func.getDeclaringType().getName() = adaptee.getName() and
            adapter_func.calls(adaptee_func)
            
            and

            AdapterPredicates::hasMismatch(adapter_func, adaptee_func)
        )
    }
}

class ClassAdapter extends Class {
    ClassAdapter() {
        exists(
            Class target, Class adaptee, 
            ClassDerivation t_der, ClassDerivation a_der,
            MemberFunction target_func, MemberFunction adapter_func |
            
            adaptee != target and
            t_der = this.getADerivation() and
            a_der = this.getADerivation() and

            t_der.getBaseClass() = target and
            t_der.getASpecifier().hasName("public") and

            a_der.getBaseClass() = adaptee and
            a_der.getASpecifier().hasName("private") and

            adapter_func = this.getAMemberFunction() and
            target_func = this.getAMemberFunction().getAnOverriddenFunction() and
            adapter_func.overrides(target_func) and

            target_func.getDeclaringType() = target and
            adapter_func.calls(adaptee.getAMemberFunction())
        )
    }
}

class ObjectAdapter extends Class {
    ObjectAdapter() {
        exists(
            Class target, Class adaptee | 
            // MemberFunction target_func, MemberFunction adapter_func, MemberFunction adaptee_func,
            // ClassDerivation t_der |
            
            // adaptee != target and
            // t_der = this.getADerivation() and

            // t_der.getBaseClass() = target and
            // t_der.getASpecifier().hasName("public") and

            // this.getAMemberVariable().getType().stripType().getName() = adaptee.getName() and

            // adapter_func = this.getAMemberFunction() and
            // target_func = this.getAMemberFunction().getAnOverriddenFunction() and
            // adapter_func.overrides(target_func) and

            // target_func.getDeclaringType().getName() = target.getName() and

            // adapter_func.calls(adaptee_func) and
            // adaptee_func.getDeclaringType().getName() = adaptee.getName()
            
            // and

            // AdapterPredicates::hasMismatch(target_func, adaptee_func)

            AdapterPredicates::setTargetAndAdaptee(this, target, adaptee)
        )
    }
}


query ClassAdapter getClassAdapter(Class c, string name) {
    checkPath(c) and 
    name = c.getQualifiedName() and
    result = c
}

// query ObjectAdapter getObjectAdapter(Class c, string name) {
//     checkPath(c) and 
//     name = c.getQualifiedName() and
//     result = c
// }

from Class adapter, Class target, Class adaptee
where 
    AdapterPredicates::setTargetAndAdaptee(adapter, target, adaptee) 
    and checkPath(adapter)
    and checkPath(adaptee)
    and checkPath(target)
select adapter, target, adaptee
