# CS140 -- Lab 0.5

### 

*   CS140 -- Data Structures and Algorithms I
*   Spring, 2014
*   [James S. Plank](http://web.eecs.utk.edu/~plank)
*   [**http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab0.5**](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab0.5)
*   Lab Directory: **/home/plank/cs140/Labs/Lab0.5**

The purpose of this lab is to give you practice using the grading scripts that you will use in your homeworks. The intent is for you to finish it in lab; however, if you don't you have time to finish it on your own. After this in-class lab, you'll be doing topcoder in lab.

### The program that you should write: How much gold -- gold.cpp

This program reads a "map" on standard input. It's really a text file in the following format:

*   A period stands for dirt
*   A dash stands for a rock with nothing under it
*   An upper case letter stands for rock with gold hiden under it. The amount of gold represented by the letter: A stands for one ounce, B stands for two ounces, etc.
*   There are no other characters on the map.

For example, the following map in **[map1.txt](map1.txt)** contains a lot of dirt, but it also contains one rock with nothing under it, and three rocks with gold: one ounce (A), three ounces (C) and 26 ounces (Z).

<pre>...............
..-............
.........A.....
..Z.........C..
</pre>

Your job is to write a program called **gold.cpp**, which reads a map on standard input and prints the total ounces of gold on the map.

There is an example executable in **gold**. Try it out:

<pre>UNIX> <font color="darkred">**gold < map1.txt**</font>
30
UNIX> <font color="darkred">**cat map2.txt**</font>
ABCDE.
.F----.
--...........G
UNIX> <font color="darkred">**gold < map2.txt**</font>
28
UNIX> 
</pre>

* * *

### Testing and Grading for Correctness

There are two programs that you should use for testing and grading. The first is **gradescript**. You can call it from the lab directory, and you call it with a number between 1 and 100\. This will execute a of your **gold** program. You need to have your **gold** executable in the current directory, and call the gradescript as follows:

<pre>UNIX> <font color="darkred">**~plank/cs140/Labs/Lab0.5/gradescript 1**</font>
Problem 001 is correct.

Test: ./gold < /home/plank/cs140/Labs/Lab0.5/Gradescript-Examples/001.txt
UNIX> 
</pre>

The gradescript is saying that test #1 worked correctly. The test that it ran was:

<pre>UNIX> <font color="darkred">**./gold < /home/plank/cs140/Labs/Lab0.5/Gradescript-Examples/001.txt**</font>
1
UNIX> 
</pre>

You can examine the input file with **cat** or **more**, or even **vi**:

<pre>UNIX> <font color="darkred">**cat /home/plank/cs140/Labs/Lab0.5/Gradescript-Examples/001.txt**</font>
A
UNIX> 
</pre>

Let us suppose that you made a mistake writing **gold**, and that instead it is a program that always prints "1":

<pre>UNIX> <font color="darkred">**cat retone.cpp**</font>
#include <iostream>
using namespace std;

int main()
{
  cout << "1\n";
  return 0;
}
UNIX> <font color="darkred">**g++ -o gold retone.cpp**</font>
UNIX> 
</pre>

When you run problem one on it, it works fine, because "1" is the proper output for the first problem. However, it fails on problem 2:

<pre>UNIX> <font color="darkred">**~plank/cs140/Labs/Lab0.5/gradescript 1**</font>
Problem 001 is correct.

Test: ./gold < /home/plank/cs140/Labs/Lab0.5/Gradescript-Examples/001.txt
UNIX> <font color="darkred">**~plank/cs140/Labs/Lab0.5/gradescript 2**</font>
Problem 002 is incorrect.

Your standard output does not match the correct one.

TEST:

./gold < /home/plank/cs140/Labs/Lab0.5/Gradescript-Examples/002.txt

FILES:

Your standard output is in tmp-002-test-stdout.txt.
Your standard error  is in tmp-002-test-stderr.txt.

The correct standard output is in tmp-002-correct-stdout.txt.
The correct standard error  is in tmp-002-correct-stderr.txt.

Look at correct files and your files, perhaps run 'diff -y' on them, and figure out your mistake.
Please remember to delete this files when you are finished.
UNIX> 
</pre>

You can examine your output and the proper output in the files listed:

<pre>UNIX> <font color="darkred">**cat tmp-002-test-stdout.txt**</font>
1
UNIX> <font color="darkred">**cat tmp-002-correct-stdout.txt**</font>
30
UNIX> <font color="darkred">**cat /home/plank/cs140/Labs/Lab0.5/Gradescript-Examples/002.txt**</font>
...............
..-............
.........A.....
..Z.........C..
UNIX> 
</pre>

That way, you can try to find your errors. In most cases, your output must match mine _exactly_. That can be a challenge.

The script **gradeall** checks your programs in 100 test cases:

<pre>UNIX> <font color="darkred">**/home/plank/cs140/Labs/Lab0.5/gradeall**</font>
Problem 001 is correct.
Problem 002 is correct.
Problem 003 is correct.

...

Problem 099 is correct.
Problem 100 is correct.

100 Correct out of 100
UNIX> 
</pre>