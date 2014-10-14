unittestingframeworkforc
========================
As an experiment, I wrote this "unit testing framework" which works based off of an excel spreadsheet template and generates c code for function under test.

how to use
=========================
Study the excel spreadsheet. You will have to fill out the following information about function 
 - function signature
 - global datatypes and their values it's using, per test case
 - arguments to the function per test case
 
plans for future development
============================
I am still looking at easier and more standard ways to test a particular function. One of the biggest challenges I am facing, is to test code that is not so much unit-testable. I started writing these scripts because I got tired of setting breakpoints and specifying variable and global values at runtime.
Depending on how things go, I am planning to add some more utilities to this framework, mainly for assertions etc.
