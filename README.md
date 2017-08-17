# Practical Work: Tabling in Logical Programming

## Task

Tabling is a recognized and powerful implementation technique that improves the declarativeness of traditional Prolog systems in dealing with recursion and redundant computations. Tabling consists of saving and reusing the results of sub-computations during the execution of a program and, for that, the calls and the answers to tabled subgoals are stored in a proper data structure called the table space.
We can distinguish two main categories of tabling mechanisms: *suspension-based tabling* and *linear tabling*. In suspension-based tabling, a tabled evaluation can be seen as a sequence of sub-computations that suspend and later resume. Linear tabling mechanisms use iterative computations of tabled subgoals to compute fix-points. The main idea of linear tabling is to maintain a single execution tree where tabled subgoals always extend the current computation without requiring suspension and resumption of sub-computations.

The most efficient approach to support tabled evaluation in a Prolog system is to modify and extend the low-level engine. Although this approach is ideal for run-time efficiency, it is not easily portable to other Prolog systems as engine level modifications are rather complex and time consuming. A simpler approach is to apply source level transformations to a tabled program and then use external tabling primitives to provide direct control over the search strategy. In this work, it is proposed that you use the latter approach to implement linear tabling on top of the [Yap Prolog][1] system.

## Compiling

The file [tabling.yap][2] contains the proposed implementation. After starting Yap, just type in `[tabling].` to compile and load the file.

There are three test files:

- [lpath.yap](source/lpath.yap)
- [rpath.yap](source/rpath.yap)
- [samegen.yap](source/samegen.yap)

and they can be compiled and loaded by running

- `[lpath].`
- `[rpath].`
- `[samegen].`

respectively.

## Implementation

We can distinguish two main components for the proposed approach: the component that implements the source level transformations and the component that implements the support for the external tabling primitives. For the purpose of this work, you can consider that programs are already re-written as desired and only the support for the external tabling primitives is missing.

Described suggested implementation can be read in Portuguese after compiling [this][3] TeX file.

## Executing and obtaining results

The number of solutions calculated can be determined by running `count_solutions(lpath(X,Y), Count).`, taking as example the **lpath** test example.

The number of calls can be determined by running `count_solutions(enum_calls(lpath(X,Y)), Count).`, taking as example the **lpath** test example.

The number of sub-solutions calculated can be determined by running `count_solutions(enum_subsolutions(lpath(X,Y)), Count).`, taking as example the **lpath** test example.

## Results

To be added here.

[1]: http://www.dcc.fc.up.pt/~vsc/Yap/
[2]: source/tabling.yap
[3]: report/il1_report.tex
