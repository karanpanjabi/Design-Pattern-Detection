/**
 * @kind problem
 */

import cpp
import util

predicate hasCompositeChildren(CompositeClass composite) {
  count(MemberVariable var |
    var = composite.getAMemberVariable() and
    var.getType().stripType() = composite.getABaseClass()
  |
    var
  ) > 1
}

query predicate hasArrayOrVectorChildren(CompositeClass composite) {
  exists(MemberVariable var |
    var = composite.getAMemberVariable() and
    var.getType() instanceof ArrayType
  )
  or
  exists(MemberVariable var, ClassTemplateInstantiation v_class |
    var = composite.getAMemberVariable() and
    v_class = var.getType() and
    v_class.getSimpleName() = "vector" and
    v_class.getTemplateArgument(0).(Type).stripType() = composite.getBaseComponent()
  )
}

query predicate hasAggregateChildren(CompositeClass composite) {
  hasCompositeChildren(composite)
    or
    hasArrayOrVectorChildren(composite)
}

query predicate hasCompositeOperation(CompositeClass composite) {
  exists(
    MemberFunction func, FunctionCall fcall1, FunctionCall fcall2 |
    func = composite.getAnOverridenMethod() and
    fcall1.getEnclosingFunction() = func and
    fcall2.getEnclosingFunction() = func and
    fcall1.getAPredecessor().(PointerFieldAccess).getTarget() != fcall2.getAPredecessor().(PointerFieldAccess).getTarget()
  ) 
  or
  exists(
    MemberFunction func, FunctionCall fcall, BlockStmt stmt, BlockStmt stmt2, Loop lstmt |
    func = composite.getAnOverridenMethod() and
    fcall.getEnclosingFunction() = func and
    lstmt = func.getBlock().getAChild() and
    stmt = fcall.getEnclosingBlock() and
    stmt = lstmt.getStmt()
  ) 
}

class CompositeClass extends Class {
  Class baseComponent;

  CompositeClass() {
    checkPath(this) and
    this.derivesFrom(baseComponent) and
    baseComponent.isAbstract()
  }

  Class getBaseComponent() { result = baseComponent }

  MemberFunction getAnOverridenMethod() {
    exists(MemberFunction func |
      func = this.getAMemberFunction() and
      func.isVirtual() and
      not func instanceof Destructor and
      result = func
    )
  }
}

// from CompositeClass c
// select c, c.getLocation()
from CompositeClass c
where hasAggregateChildren(c)
select c, c.getAMemberVariable().getType().getAQlClass()
