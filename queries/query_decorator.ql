/**
 * @kind problem
 */

import cpp
import util

class BaseDecoratorClass extends Class {
  Class componentclass;
  MemberVariable compvar;

  BaseDecoratorClass() {
    // derivation
    this.derivesFrom(componentclass) and
    this.isAbstract() and
    componentclass.isAbstract() and
    // variable checking
    compvar.getType().stripType() = componentclass and
    compvar.getDeclaringType() = this and
    count(compvar) = 1
  }

  Class getComponentClass() { result = componentclass }

  MemberVariable getComponentVar() { result = compvar }
}

query predicate hasCallToOperation(ConcreteDecoratorClass conc_deco) {
  exists(MemberFunction func, MemberFunction component_func |
    func = conc_deco.getAnOverridenMethod() and
    component_func = func.getAnOverriddenFunction+() and
    component_func.getDeclaringType() = conc_deco.getBaseDecorator().getComponentClass() and
    func.calls(component_func)
  )
}

query predicate hasOtherFunctionality(ConcreteDecoratorClass conc_deco) {
  exists(MemberFunction func, MemberFunction component_func, BlockStmt blkstmt, Stmt stmt, int c |
    func = conc_deco.getAnOverridenMethod() and
    component_func = func.getAnOverriddenFunction+() and
    blkstmt = func.getBlock() and
    c = blkstmt.getNumStmt() and
    c > 2
  )
}

class ConcreteDecoratorClass extends Class {
  BaseDecoratorClass baseDecorator;

  ConcreteDecoratorClass() {
    this.derivesFrom(baseDecorator) and
    not this.isAbstract()
  }

  BaseDecoratorClass getBaseDecorator() { result = baseDecorator }

  MemberFunction getAnOverridenMethod() {
    exists(MemberFunction func |
      func = this.getAMemberFunction() and
      func.getAnOverriddenFunction().getDeclaringType() instanceof BaseDecoratorClass and
      not func instanceof Destructor and
      result = func
    )
  }
}

query BaseDecoratorClass getBaseDecoratorClasses() {
    checkPath(result)
}

query ConcreteDecoratorClass getConcreteDecoratorClasses() {
    checkPath(result)
}

query ConcreteDecoratorClass getStrictConcreteDecoratorClasses() {
    checkPath(result) and
    hasCallToOperation(result) and
    hasOtherFunctionality(result)
}
