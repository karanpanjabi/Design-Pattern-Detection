/**
 * @kind problem
 */

import cpp

predicate checkPath(Element el) { exists(string s | s = el.getFile().getRelativePath()) }

predicate hasCompositeChildren(Class composite, Class base) {
  count(MemberVariable var |
    var = composite.getAMemberVariable() and
    var.getType().stripType() = base
  |
    var
  ) > 1
}

predicate hasArrayOrVectorChildren(CompositeClass composite) {
    checkPath(composite) and
    exists(
        MemberVariable var |
        var = composite.getAMemberVariable() and
        var.getType() instanceof ArrayType
    )
}

query predicate hasAggregateChildren(CompositeClass composite, Class base) {
  hasCompositeChildren(composite, base)
//   or
//   hasArrayOrVectorChildren(composite, base)
}

predicate hasCompositeOperation(CompositeClass composite) {
    composite.
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
} 


// from CompositeClass c
// select c, c.getLocation()

from CompositeClass c
where hasAggregateChildren(c, c.getBaseComponent())
select c, c.getAMemberVariable().getType().getAQlClass()