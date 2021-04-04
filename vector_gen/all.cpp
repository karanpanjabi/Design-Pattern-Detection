#include <iostream>
#include <vector>
#include <map>
#include <exception>
#include <string>

namespace JobQueueEx
{
    /** Job **/
    struct Job
    {
        int jobNumber;
        std::string jobName;
    };

    class JobQueue
    {
    public:
        /** Constructor **/
        JobQueue();

        /** Singeleton: Get Instance **/
        static JobQueue *getInstance();

        /** Add Job
     * Adds job to the queue
     * Returns the job number
     */
        int addJob(std::string jobName);

        /** Cancel Job
     * Cancels specified job, cancels first
     * job in the queue if no job number is specified
     */
        void cancelJob(int jobNumber = 0);

        /** Print Queue
     * Outputs the contents of the queue
     */
        void printQueue();

    private:
        std::vector<Job> queue; /** Queue Data Structure */

        static bool created;         /** True if instance of JobQueue has been created */
        static JobQueue *myInstance; /** Pointer to the JobQueue instance (Singleton) */
    };

    class InvalidRequest : public std::exception
    {
        virtual const char *what() const throw()
        {
            return "Invalid Request on Queue";
        }
    } InvalidRequest;

    bool JobQueue::created = false;
    JobQueue *JobQueue::myInstance = NULL;

    JobQueue::JobQueue() {}

    JobQueue *JobQueue::getInstance()
    {
        if (!created)
        {
            myInstance = new JobQueue();
            created = true;
        }
        return myInstance;
    }

    int JobQueue::addJob(std::string jobName)
    {
        Job newJob;
        newJob.jobName = jobName;
        newJob.jobNumber = queue.size() + 1;
        queue.push_back(newJob);

        return newJob.jobNumber;
    }

    void JobQueue::cancelJob(int jobNumber)
    {

        try
        {
            if (queue.size() == 0)
            {
                throw InvalidRequest;
            }

            else if (jobNumber == 0)
            {
                // remove the first job
                queue.erase(queue.begin());
            }
            else
            {
                // remove specified job
                int jobIndex = -1;
                for (int i = 0; i < queue.size(); i++)
                {
                    if (queue.at(i).jobNumber == jobNumber)
                    {
                        jobIndex = i;
                    }
                }
                if (jobIndex == -1)
                    throw InvalidRequest;

                queue.erase(queue.begin() + jobIndex);
            }
        }
        catch (std::exception &e)
        {
            std::cout << e.what() << std::endl;
        }
    }

    void JobQueue::printQueue()
    {
        for (unsigned int i = 0; i < queue.size(); i++)
        {
            std::cout << queue.at(i).jobNumber << "\t" << queue.at(i).jobName
                      << std::endl;
        }
    }

}

namespace Singleton
{
    class TestSingleton
    {
    public:
        static TestSingleton *ptr;

        TestSingleton(TestSingleton &other) = delete;
        void operator=(const TestSingleton &) = delete;

        static TestSingleton *getInst()
        {
            return ptr;
        }

        void anotherfunc()
        {
        }

    private:
        TestSingleton()
        {
        }
    };

    TestSingleton *TestSingleton::ptr = nullptr;

}

// --------------- ADAPTER ------------------------

namespace ClassAdapter
{
    /*
 * Target
 * defines specific interface that Client uses
 */
    class Target
    {
    public:
        virtual ~Target() {}

        virtual void request() = 0;
        // ...
    };

    /*
 * Adaptee
 * all requests get delegated to the Adaptee which defines
 * an existing interface that needs adapting
 */
    class Adaptee
    {
    public:
        ~Adaptee() {}

        void specificRequest()
        {
            std::cout << "specific request" << std::endl;
        }
        // ...
    };

    /*
 * Adapter
 * implements the Target interface and lets the Adaptee respond
 * to request on a Target by extending both classes
 * ie adapts the interface of Adaptee to the Target interface
 */
    class Adapter : public Target, private Adaptee
    {
    public:
        virtual void request()
        {
            specificRequest();
        }
        // ...
    };
}

namespace ObjectAdapter
{
    class Target
    {
    public:
        virtual ~Target() {}

        virtual void request() = 0;
        // ...
    };

    /*
 * Adaptee
 * defines an existing interface that needs adapting and thanks
 * to Adapter it will get calls that client makes on the Target
 *
 */
    class Adaptee
    {
    public:
        void specificRequest()
        {
            std::cout << "specific request" << std::endl;
        }
        // ...
    };

    /*
 * Adapter
 * implements the Target interface and when it gets a method call it
 * delegates the call to a Adaptee
 */
    class Adapter : public Target
    {
    public:
        Adapter() : adaptee() {}

        ~Adapter()
        {
            delete adaptee;
        }

        void request()
        {
            adaptee->specificRequest();
            // ...
        }
        // ...

    private:
        Adaptee *adaptee;
        // ...
    };
} // namespace ObjectAdapter

// ------------------ BRIDGE -----------------

namespace Bridge
{
    /*
 * Implementor
 * defines the interface for implementation classes
 */
    class Implementor
    {
    public:
        virtual ~Implementor() {}

        virtual void action() = 0;
        // ...
    };

    /*
 * Concrete Implementors
 * implement the Implementor interface and define concrete implementations
 */
    class ConcreteImplementorA : public Implementor
    {
    public:
        ~ConcreteImplementorA() {}

        void action()
        {
            std::cout << "Concrete Implementor A" << std::endl;
        }
        // ...
    };

    class ConcreteImplementorB : public Implementor
    {
    public:
        ~ConcreteImplementorB() {}

        void action()
        {
            std::cout << "Concrete Implementor B" << std::endl;
        }
        // ...
    };

    /*
 * Abstraction
 * defines the abstraction's interface
 */
    class Abstraction
    {
    public:
        virtual ~Abstraction() {}

        virtual void operation() = 0;
        // ...
    };

    /*
 * RefinedAbstraction
 * extends the interface defined by Abstraction
 */
    class RefinedAbstraction : public Abstraction
    {
    public:
        ~RefinedAbstraction() {}

        RefinedAbstraction(Implementor *impl) : implementor(impl) {}

        void operation()
        {
            implementor->action();
        }
        // ...

    private:
        Implementor *implementor;
    };
} // namespace Bridge

// ------------------ COMPOSITE -------------------------

namespace Composite
{
    /*
 * Component
 * defines an interface for all objects in the composition
 * both the composite and the leaf nodes
 */
    class Component
    {
    public:
        virtual ~Component() {}

        virtual Component *getChild(int)
        {
            return 0;
        }

        virtual void add(Component *)
        { /* ... */
        }
        virtual void remove(int)
        { /* ... */
        }

        virtual void operation() = 0;
    };

    /*
 * Composite
 * defines behavior of the components having children
 * and store child components
 */
    class Composite : public Component
    {
    public:
        ~Composite()
        {
            for (unsigned int i = 0; i < children.size(); i++)
            {
                delete children[i];
            }
        }

        Component *getChild(const unsigned int index)
        {
            return children[index];
        }

        void add(Component *component)
        {
            children.push_back(component);
        }

        void remove(const unsigned int index)
        {
            Component *child = children[index];
            children.erase(children.begin() + index);
            delete child;
        }

        void operation()
        {
            for (unsigned int i = 0; i < children.size(); i++)
            {
                children[i]->operation();
            }
        }

    private:
        std::vector<Component *> children;
    };

    /*
 * Leaf
 * defines the behavior for the elements in the composition,
 * it has no children
 */
    class Leaf : public Component
    {
    public:
        Leaf(const int i) : id(i) {}

        ~Leaf() {}

        void operation()
        {
            std::cout << "Leaf " << id << " operation" << std::endl;
        }

    private:
        int id;
    };

} // namespace Composite

// ----------------- DECORATOR -------------------

namespace Decorator
{
    /*
 * Component
 * defines an interface for objects that can have responsibilities
 * added to them dynamically
 */
    class Component
    {
    public:
        virtual ~Component() {}

        virtual void operation() = 0;
        // ...
    };

    /*
 * Concrete Component
 * defines an object to which additional responsibilities
 * can be attached
 */
    class ConcreteComponent : public Component
    {
    public:
        ~ConcreteComponent() {}

        void operation()
        {
            std::cout << "Concrete Component operation" << std::endl;
        }
        // ...
    };

    /*
 * Decorator
 * maintains a reference to a Component object and defines an interface
 * that conforms to Component's interface
 */
    class Decorator : public Component
    {
    public:
        ~Decorator() {}

        Decorator(Component *c) : component(c) {}

        virtual void operation()
        {
            component->operation();
        }
        // ...

    private:
        Component *component;
    };

    /*
 * Concrete Decorators
 * add responsibilities to the component (can extend the state
 * of the component)
 */
    class ConcreteDecoratorA : public Decorator
    {
    public:
        ConcreteDecoratorA(Component *c) : Decorator(c) {}

        void operation()
        {
            Decorator::operation();
            std::cout << "Decorator A" << std::endl;
        }
        // ...
    };

    class ConcreteDecoratorB : public Decorator
    {
    public:
        ConcreteDecoratorB(Component *c) : Decorator(c) {}

        void operation()
        {
            Decorator::operation();
            std::cout << "Decorator B" << std::endl;
        }
        // ...
    };
} // namespace Decorator

// --------------------- FACADE ----------------------

namespace Facade
{
    /*
 * Subsystems
 * implement more complex subsystem functionality
 * and have no knowledge of the facade
 */
    class SubsystemA
    {
    public:
        void suboperation()
        {
            std::cout << "Subsystem A method" << std::endl;
            // ...
        }
        // ...
    };

    class SubsystemB
    {
    public:
        void suboperation()
        {
            std::cout << "Subsystem B method" << std::endl;
            // ...
        }
        // ...
    };

    class SubsystemC
    {
    public:
        void suboperation()
        {
            std::cout << "Subsystem C method" << std::endl;
            // ...
        }
        // ...
    };

    /*
 * Facade
 * delegates client requests to appropriate subsystem object
 * and unified interface that is easier to use
 */
    class Facade
    {
    public:
        Facade() : subsystemA(), subsystemB(), subsystemC() {}

        void operation1()
        {
            subsystemA->suboperation();
            subsystemB->suboperation();
            // ...
        }

        void operation2()
        {
            subsystemC->suboperation();
            // ...
        }
        // ...

    private:
        SubsystemA *subsystemA;
        SubsystemB *subsystemB;
        SubsystemC *subsystemC;
        // ...
    };
} // namespace Facade

namespace FlyWeight
{
    /*
 * Flyweight
 * declares an interface through which flyweights can receive
 * and act on extrinsic state
 */
    class Flyweight
    {
    public:
        virtual ~Flyweight() {}
        virtual void operation() = 0;
        // ...
    };

    /*
 * UnsharedConcreteFlyweight
 * not all subclasses need to be shared
 */
    class UnsharedConcreteFlyweight : public Flyweight
    {
    public:
        UnsharedConcreteFlyweight(const int intrinsic_state) : state(intrinsic_state) {}

        ~UnsharedConcreteFlyweight() {}

        void operation()
        {
            std::cout << "Unshared Flyweight with state " << state << std::endl;
        }
        // ...

    private:
        int state;
        // ...
    };

    /*
 * ConcreteFlyweight
 * implements the Flyweight interface and adds storage
 * for intrinsic state
 */
    class ConcreteFlyweight : public Flyweight
    {
    public:
        ConcreteFlyweight(const int all_state) : state(all_state) {}

        ~ConcreteFlyweight() {}

        void operation()
        {
            std::cout << "Concrete Flyweight with state " << state << std::endl;
        }
        // ...

    private:
        int state;
        // ...
    };

    /*
 * FlyweightFactory
 * creates and manages flyweight objects and ensures
 * that flyweights are shared properly
 */
    class FlyweightFactory
    {
    public:
        ~FlyweightFactory()
        {
            for (auto it = flies.begin(); it != flies.end(); it++)
            {
                delete it->second;
            }
            flies.clear();
        }

        Flyweight *getFlyweight(const int key)
        {
            if (flies.find(key) != flies.end())
            {
                return flies[key];
            }
            Flyweight *fly = new ConcreteFlyweight(key);
            flies.insert(std::pair<int, Flyweight *>(key, fly));
            return fly;
        }
        // ...

    private:
        std::map<int, Flyweight *> flies;
        // ...
    };
} // namespace FlyWeight

// --------------------- PROXY ---------------------

namespace Proxy
{
    /*
 * Subject
 * defines the common interface for RealSubject and Proxy
 * so that a Proxy can be used anywhere a RealSubject is expected
 */
    class Subject
    {
    public:
        virtual ~Subject()
        { /* ... */
        }

        virtual void request() = 0;
        // ...
    };

    /*
 * Real Subject
 * defines the real object that the proxy represents
 */
    class RealSubject : public Subject
    {
    public:
        void request()
        {
            std::cout << "Real Subject request" << std::endl;
        }
        // ...
    };

    /*
 * Proxy
 * maintains a reference that lets the proxy access the real subject
 */
    class Proxy : public Subject
    {
    public:
        Proxy()
        {
            subject = new RealSubject();
        }

        ~Proxy()
        {
            delete subject;
        }

        void request()
        {
            subject->request();
        }
        // ...

    private:
        RealSubject *subject;
    };
} // namespace Proxy

int main()
{
    // dummy
}