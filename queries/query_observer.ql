import cpp
import util

class SubjectClass extends Class {
  ObserverClass obs_type;

  SubjectClass() {
    exists(MemberVariable var, ClassTemplateInstantiation v_class |
      checkPath(this) and
      var = getAllMemberVariables(this) and
      (
        var.getType() instanceof ArrayType and
        var.getType().stripType() = obs_type
        or
        v_class = var.getType() and
        v_class.getSimpleName() in ["vector", "set", "queue", "list"] and
        v_class.getTemplateArgument(0).(Type).stripType() = obs_type
      )
    ) and
    not isInSameHierarchy(this, obs_type)
  }

  ObserverClass getObserverClass() { result = obs_type or result = obs_type.getADerivedClass() }
}

query predicate hasNotifyDefinition(SubjectClass cls) {
  exists(MemberFunction notify, MemberFunction update, FunctionCall updatecall, Loop lstmt |
    notify = getAllMemberFunctions(cls) and
    lstmt = notify.getBlock().getAChild() and
    update = cls.getObserverClass().getAMemberFunction() and
    updateFunctionAccessesSubject(cls) and
    updatecall.getTarget() = update and
    updatecall.getEnclosingFunction() = notify and
    updatecall.getEnclosingElement+().(Loop) = lstmt
  )
}

query predicate updateFunctionAccessesSubject(SubjectClass subject_cls) {
  exists(LocalScopeVariable var, MemberFunction update_func |
    subject_cls.getObserverClass().getAMemberFunction() = update_func and
    var.getFunction() = update_func and
    (
      var.getType().stripType() = subject_cls or
      var.getType().stripType() = subject_cls.getADerivedClass*()
    )
  )
}

class ConcSubjectClass extends Class {
  SubjectClass baseCls;

  ConcSubjectClass() { this.derivesFrom(baseCls) }
}

class ObserverClass extends Class { }

class ConcObserverClass extends Class { }

query ObserverClass getObserverClasses() {
  exists(SubjectClass cls | hasNotifyDefinition(cls) and result = cls.getObserverClass())
}

Declaration getAllMembers(Class cls) {
  result = cls.getAMember()
  or
  exists(Class superclass, Declaration decl |
    superclass = cls.getADerivation().getBaseClass() and
    decl = getAllMembers(superclass) and
    (
      decl.hasSpecifier("public")
      or
      decl.hasSpecifier("protected")
    ) and
    result = decl
  )
}

MemberFunction getAllMemberFunctions(Class cls) { result = getAllMembers(cls).(MemberFunction) }

MemberVariable getAllMemberVariables(Class cls) { result = getAllMembers(cls).(MemberVariable) }

predicate isInSameHierarchy(Class c1, Class c2) {
  c1.getADerivedClass*() = c2 or
  c2.getADerivedClass*() = c1
}
