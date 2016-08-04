# CS140 -- Lab 1

### 

*   CS140 -- Data Structures & Algorithms I
*   Spring 2014
*   [James S. Plank](http://web.eecs.utk.edu/~plank)
*   [This file: **http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab1**](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab1/index.html)
*   Lab Directory: **/home/plank/cs140/Labs/Lab1**

* * *

This lab has two programs to hand in: **checkerboard.cpp** and **moonglow.cpp**. You can do this lab with only this information from [the C++ review lecture notes.](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Notes/Review/index.html) In particular, you don't need stringstreams or any such mess. Just a good understanding of **cin**.

* * *

## Checkerboard.cpp

A _generalized checkerboard_ is a rectangular grid one that has four parameters:

*   _R_: The number of rows.
*   _C_: The number of columns.
*   _SC_: The starting character.
*   _CS_: The cycle size.

The grid is a _(R * C)_ matrix, where the element in row _r_ and column _c_, contains the character _SC + (r+c)%CS_. For example, here's a generalized checkerboard with _R=5_, _C=6_, _SC = 'a'_ and _CS=4_:

```
| a | b | c | d | a | b |
| b | c | d | a | b | c |
| c | d | a | b | c | d |
| d | a | b | c | d | a |
| a | b | c | d | a | b |
```

Your job is to write the program **checkerboard.cpp**, which reads five integers from standard input. The first four are the parameters _R_, _C_, _SC_ and _CS_, as defined above. The fifth parameter is a width _W_. Your program should print out the specified checkerboard such that each element of the grid is printed as a _(W * W)_ square. Here are some examples:

<pre>UNIX> <font color="darkred">**./checkerboard**</font>
<font color="darkred">**5 6 a 4 1**</font>
abcdab
bcdabc
cdabcd
dabcda
abcdab
UNIX> <font color="darkred">**./checkerboard**</font>
<font color="darkred">**5 6 a 4 3**</font>
aaabbbcccdddaaabbb
aaabbbcccdddaaabbb
aaabbbcccdddaaabbb
bbbcccdddaaabbbccc
bbbcccdddaaabbbccc
bbbcccdddaaabbbccc
cccdddaaabbbcccddd
cccdddaaabbbcccddd
cccdddaaabbbcccddd
dddaaabbbcccdddaaa
dddaaabbbcccdddaaa
dddaaabbbcccdddaaa
aaabbbcccdddaaabbb
aaabbbcccdddaaabbb
aaabbbcccdddaaabbb
UNIX> <font color="darkred">**checkerboard**</font>
<font color="darkred">**4 40 J 20 3**</font>
JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]
JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]
JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]
KKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJ
KKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJ
KKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJ
LLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKK
LLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKK
LLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKK
MMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLL
MMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLL
MMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLLMMMNNNOOOPPPQQQRRRSSSTTTUUUVVVWWWXXXYYYZZZ[[[\\\]]]JJJKKKLLL
UNIX> <font color="darkred">**./checkerboard**</font>
<font color="darkred">**4 40 0 2 3**</font>
000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111
000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111
000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111
111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000
111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000
111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000
000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111
000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111
000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111
111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000
111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000
111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000111000
UNIX> 
</pre>

**Error checking:** Your program should print the same output as mine on standard error if too few arguments are given, or if they are not numbers. It should exit silently if any of the parameters is less than or equal to zero, and if the ASCII value of the starting character plus the cycle size is greater than 127.

* * *

## Moonglow.cpp

Your sister Sheri is an Philosophy professor. She recently gave a midterm exam to 500 students in her intro class, and it was graded by her PhD student, Moonglow (philosophy students have names like these), who put each student's test scores into a text file with a rather byzantine format. Unfortunately, before Moonglow could convert those files to Excel for Sheri, his wife Sunshine left him, got into their VW van with their child Starrlite and drove home to the commune in northern California where they grew up. That should not surprise you. Moonglow of course followed her, and since the commune is off the grid (duh), Sheri is stuck with 500 text files that she doesn't know how to process.

Fortunately, you're in CS140, and Sheri has offered you a quarter of her grant money to convert those files into a more palatable format. $25 isn't a huge amount of money, but you love your sister, and this shouldn't take you long, so you agree. You are to write the program **moonglow.cpp** which reads a file in Moonglow's format on standard input, and prints a very simple output.

Here's Moonglow's format. The text file is composed of words. If a word is a number, then that is a student's score on a question, so you add it to the student's exam score. If the word is not a number, but is the word "NAME", then the next word is the student's name (Moonglow only uses first names -- last names are corporate and impersonal). If the word is "AVERAGE", then you start reading numbers until you read a word that is not a number (or is the end of the file). You average all of those numbers and add that to the score. Since Moonglow is a little scatterbrained, sometimes a number does not follow "AVERAGE." In that case, you ignore the "AVERAGE".

When you are done reading the file, your program should print the student's name, a space, and the student's score. Just use **cout** for this -- nothing exciting.

### Error Checking

You don't have to check for errors, and you may assume that the input is in the correct format. That would cost Sheri more money. However, this is a pretty flexible format. The only things that you need to assume are:

*   The input will specify exactly one student's name.
*   That student's name won't be "AVERAGE" or "NAME."

Here are some examples:

<pre>UNIX> <font color="darkred">**cat test-1.txt**</font>
NAME Fred
UNIX> <font color="darkred">**./moonglow < test-1.txt**</font>
Fred 0
UNIX> <font color="darkred">**cat test-2.txt**</font>
NAME Dontonio
8.6
16.2
UNIX> <font color="darkred">**./moonglow < test-2.txt**</font>
Dontonio 24.8
UNIX> <font color="darkred">**cat test-3.txt**</font>
I miss Starrlight!!
15 NAME
Frank
UNIX> <font color="darkred">**./moonglow < test-3.txt**</font>
Frank 15
UNIX> <font color="darkred">**cat test-4.txt**</font>
AVERAGE 10 15 20 NAME Luther 10 Starrlite!!
UNIX> <font color="darkred">**./moonglow < test-4.txt**</font>
Luther 25
UNIX> <font color="darkred">**cat test-5.txt**</font>
NAME Baby-Daisy
AVERAGE 3 4 5 6
AVERAGE 7 8 9
Where's Starrlite!!
UNIX> <font color="darkred">**./moonglow < test-5.txt**</font>
Baby-Daisy 12.5
UNIX> <font color="darkred">**cat test-6.txt**</font>
Starrlite AVERAGE Starrlite!!! NAME 
Starrlite
AVERAGE 55 Starrlite!!!  Starrlite
AVERAGE Starrlite 5 6 7
UNIX> <font color="darkred">**./moonglow < test-6.txt**</font>
Starrlite 73
UNIX> 
</pre>

Some comments on the examples. First, the file doesn't have to have any scores, like **[test-1.txt](test-1.txt)**. Second, you should use doubles and not integers. Third, the "NAME" can appear anywhere, and can be on a different line than the name, as in **[test-3.txt](test-3.txt)**. Last, the "AVERAGE" can have zero numbers after it, as it does twice in **[test-6.txt](test-6.txt)**. Thus, in the file, the score is 55, from the second "AVERAGE", plus 5, 6 and 7, which equals 73.

* * *

### The Gradescript

The grading programs are in **/home/plank/cs140/Labs/Lab1/gradescript** and **/home/plank/cs140/Labs/Lab1/gradeall**

The first 30 tests are for **checkerboard**. The remaining 70 are for **moonglow**.