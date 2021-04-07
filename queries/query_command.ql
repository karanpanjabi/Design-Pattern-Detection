import cpp
import util

class BaseCommandClass extends Class {
  Element invoker;
  MemberFunction executor;

  BaseCommandClass() {
    checkPath(this) and
    exists(this.getADerivedClass()) and
    executor.getDeclaringType() = this and
    invoker.(Class).getAMemberVariable().getType().stripType() = this and
    invoker.(Class).getAMemberFunction().calls(executor)
  }
}

class ConcCommandClass extends Class {
  ConcCommandClass() { this.getADerivation().getBaseClass() instanceof BaseCommandClass }

  MemberFunction getAnOverridenMethod() {
    exists(MemberFunction func |
      func = this.getAMemberFunction() and
      func.isVirtual() and
      not func instanceof Destructor and
      result = func
    )
  }
}

predicate hasCallToReceiver(ConcCommandClass cls) {
  exists(Element recv |
    checkPath(recv) and
    cls.getAnOverridenMethod().calls(recv.(Class).getAMemberFunction())
    or
    cls.getAnOverridenMethod().calls(recv.(Function))
  )
}

query predicate getCommandClasses(BaseCommandClass bcmd, ConcCommandClass ccmd) {
  bcmd.getADerivedClass() = ccmd
}

query predicate getStrictCommandClasses(BaseCommandClass bcmd, ConcCommandClass ccmd) {
  bcmd.getADerivedClass() = ccmd and
  hasCallToReceiver(ccmd)
}
