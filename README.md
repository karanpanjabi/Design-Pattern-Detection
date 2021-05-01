# Design Pattern Detection in C++

## Results

Quantifying our results on a large scale has proven to be a challenge. While precision is
easy to calculate, finding classes missed by our tool does not seem to have any obvious
solution. Manually going through every large codebase tested on to understand the semantics
of each class is well beyond the scope of this project.

However, we have checked the results of our tool on a handful of small repositories. These
were taken from GitHub based on design patterns they contained. It is important to note
that these do not accurately represent real world uses of design patterns since these
have been written with the intention of implementing a specific pattern.

With a threshold cosine similarity of 0.7, our tool was able to soft match patterns in
these toy repositories with an accuracy of *100%*.

When testing on large codebases, we were limited by our ability to build the project
locally. CodeQL monitors the source code seen during the build process to build its
database. In spite of this, we were able to test our tool on three large projects.

##### 1. GTN by Facebook Research
  In this cutting edge, currently in development project by Facebook, we only found the
  singleton pattern.
##### 2. Workflow by Sogou
  Workflow is a backend engine used by the Sogou for high performance and high concurrency
  services. In this project, our tool found the singleton and strategy patterns
##### 3. Drogon
  In this widely used C++ web framework, we notably found the observer pattern in the implementation of the event loop to handle asynchronous tasks.

While the codebase is too large to check if our tool missed any patterns, a precision of 100% was seen. This indicates that the classes it found were all indeed ocurrences of that pattern.
