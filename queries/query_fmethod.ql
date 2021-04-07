import cpp
import util

class FactoryMethod extends Function {
  Class hierarchyBase;

  FactoryMethod() {
    checkPath(this) and
    this.getType().stripType() = hierarchyBase and
    exists(Class derived |
      derived = hierarchyBase.getADerivedClass() and
      this.getEntryPoint().getASuccessor*().(Call).getTarget() = derived.getAConstructor()
    )
  }
}

query predicate getFMethod(FactoryMethod m) { checkPath(m) }

query predicate gf(Function f) {
  getAllFunctions(f)
}