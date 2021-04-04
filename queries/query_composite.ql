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

predicate hasArrayOrVectorChildren(CompositeClass composite) {
    exists(
        MemberVariable var |
        var = composite.getAMemberVariable() and
        var.getType() instanceof ArrayType
    )
}

query predicate hasAggregateChildren(CompositeClass composite) {
  hasCompositeChildren(composite)
//   or
//   hasArrayOrVectorChildren(composite, base)
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
      MemberFunction func, FunctionCall fcall, BlockStmt stmt, BlockStmt stmt2, ForStmt fstmt |
      func = composite.getAnOverridenMethod() and
      fcall.getEnclosingFunction() = func and
      fstmt = func.getBlock().getAChild() and
      stmt = fcall.getEnclosingBlock() and
      stmt = fstmt.getStmt()
    ) 
}

class CompositeClass extends Class {
  Class baseComponent;

  CompositeClass() {
    checkPath(this) and
    this.derivesFrom(baseComponent) and
    baseComponent.isAbstract()
  }

  Class getBaseComponent() {
      result = baseComponent
  }

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