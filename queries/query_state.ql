import util
import cpp

query predicate hasStateInName(StateInterface cls) {
  cls.getName().toLowerCase().regexpMatch(".*state.*")
}

class StateInterface extends Class {

  StateInterface() { 
    checkPath(this) and
    exists(this.getADerivedClass())
  }
}

class ContextClass extends Class {
  StateInterface stInt;
  MemberFunction chSt;

  ContextClass() { 
    checkPath(this) and
    stInt = this.getAMemberVariable().getType().stripType() and

    chSt = this.getAMemberFunction() and

    exists(
      MemberVariable var, AssignExpr a_expr |
      var = this.getAMemberVariable() and
      a_expr.getEnclosingFunction() = chSt and
      a_expr.getLValue().(FieldAccess).getTarget() = var
    )
  }

  MemberFunction getChangeOfStateFunction() {
    result = chSt
  }

}

query predicate hasChStBeenCalledManyTimes(ContextClass cls) {
  count(
    FunctionCall fcall |
    fcall.getTarget() = cls.getChangeOfStateFunction()
  ) > 1
}

query MemberFunction getChSt(ContextClass cls) {
  result = cls.getChangeOfStateFunction()
}

query StateInterface getStateInterfaces() {
  checkPath(result) and
  hasStateInName(result)
}

query StateInterface getStrictStateInterfaces() {
  checkPath(result) and
  result.isAbstract() and
  hasStateInName(result)
}

query ContextClass getContextClasses() {
  checkPath(result) and
  hasChStBeenCalledManyTimes(result)
}