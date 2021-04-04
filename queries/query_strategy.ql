import util
import cpp

query predicate hasStateInName(StrategyInterface cls) {
  cls.getName().toLowerCase().regexpMatch(".*state.*")
}

class StrategyInterface extends Class {

  StrategyInterface() { 
    checkPath(this) and
    exists(this.getADerivedClass())
  }
}

class ContextClass extends Class {
  StrategyInterface stInt;
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

  StrategyInterface getStrategyInterface() {
    result = stInt
  }

  MemberFunction getChangeOfStrategyFunction() {
    result = chSt
  }

}

query predicate hasChStBeenCalledManyTimes(ContextClass cls) {
  count(
    FunctionCall fcall |
    fcall.getTarget() = cls.getChangeOfStrategyFunction()
  ) > 1
}

query MemberFunction getChSt(ContextClass cls) {
  result = cls.getChangeOfStrategyFunction()
}

query StrategyInterface getStrategyInterfaces() {
  checkPath(result)
}

query StrategyInterface getStrictStrategyInterfaces() {
  exists(
    ContextClass c_class |
    result = c_class.getStrategyInterface()
  ) and
  result.isAbstract()
}

query ContextClass getContextClasses() {
  checkPath(result) and
  not hasChStBeenCalledManyTimes(result)
}