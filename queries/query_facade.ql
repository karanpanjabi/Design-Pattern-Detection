import cpp
import util

class FacadeClass extends Class {
  Element client;
  Class subsystem;

  FacadeClass() {
    // client wants to use the subsystem functionality
    // client doesn't know or want to work with subsystem directly
    // facade in turn calls/uses the subsystem
    checkPath(this) and
    checkPath(client) and
    checkPath(subsystem) and
    (
      client.(Class).getAMemberFunction().calls(this.getAMemberFunction()) or
      client.(Function).calls(this.getAMemberFunction())
    ) and
    this.getAMemberFunction().calls(subsystem.getAMemberFunction()) and
    client != subsystem and
    not (
      client.(Class).getAMemberFunction().calls(subsystem.getAMemberFunction()) or
      client.(Function).calls(subsystem.getAMemberFunction())
    )
  }
}

query predicate getFacadeClasses(FacadeClass f) { checkPath(f) }
