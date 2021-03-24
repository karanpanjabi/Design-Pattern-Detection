import util
import cpp

class AbsFactBase extends AbstractClass {
  ConcFact concFactory;
  Class baseProductcls;

  AbsFactBase() {
    concFactory = this.getADerivedClass() and
    exists(MemberFunction func |
      func = this.getAMemberFunction() and
      func.isVirtual() and
      baseProductcls = func.getType().stripType()
    )
  }

  ConcFact getAConcFactory() { result = concFactory }

  Class getABaseProduct() { result = baseProductcls }
}

query predicate hasProdCreation(AbsFactBase abscls) {
  exists(MemberFunction concFunc, Constructor prodCons, Class concProduct |
    concFunc = abscls.getAConcFactory().getAnOverridenMethod() and
    concFunc.calls+(prodCons) and
    concProduct = concFunc.getType().stripType() 
    and
    (
      concProduct = abscls.getABaseProduct()
      or
      prodCons.getType() = abscls.getABaseProduct().getADerivedClass() and
      concProduct = prodCons.getType()
    )
  )
}

class ConcFact extends Class {
  ConcFact() { not this.isAbstract() }

  MemberFunction getAnOverridenMethod() {
    exists(MemberFunction func |
      func = this.getAMemberFunction() and
      func.getAnOverriddenFunction().getDeclaringType() instanceof AbsFactBase and
      result = func
    )
  }
}

from AbsFactBase c
where checkPath(c)
select c, c.getAConcFactory(), c.getABaseProduct()
