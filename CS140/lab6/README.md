# CS140 -- Lab 6

### 

*   CS140 -- Fundamental Algorithms
*   Spring, 2014
*   [James S. Plank](http://www.cs.utk.edu/~plank)
*   [This file: **http://www.cs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6**](http://www.cs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/index.html)
*   Lab Directory: **/home/plank/cs140/Labs/Lab6**

You are in Vegas with your wife and her family. On morning number 1, they all want to go to the "Venetian" hotel and casino to ride the Gondolas. You have the choice of going or staying. Hmmm, let's see. You've already overpaid once in your life to ride a real gondola in Venice. It's something like 500 bazillion degrees in Vegas, and the gondola rides are in a big concrete swimming pool. You thank the family, but send them on their merry way.

You wander around the casino, and see this game called _Keno_. It's a bit like a lottery. There are 80 balls numbered 1 through 80, and they will pick 20 of them randomly. They have a catchy little flier about all the Keno bets you can make:

| | | |
|:----:|:----:|:----:|
| ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/K1.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/K2.jpg) ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/K3.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/K4.jpg) |

The whole flier is [here](Keno.jpg).

Now, we're talking entertainment! You know there's no way that these tempting little bets are going to make you money in the long run, but have a little mathematical problem to solve, and that's better than gambling! Your job is to figure out which of these bets is the best -- in other words, which one will lose you the least amount of money in the long run.

Let's analyze the bet sheet. On the "2-Bit Menu" you will pay a quarter per game, which you will not get back. Let's say you choose the "5 catch win." This means that you will pick five numbers. They will pick 20\. If exactly three of your five numbers are in their twenty, they pay you a quarter (i.e. you get your money back). If exactly four of your five are in their twenty, then they pay you a dollar. And if all five are your numbers are in their twenty, you win $200!!!!! Whoo-hoo!!!

So, suppose you want to calculate what the average return on your investment will be. The probability of matching exactly three balls is 0.0839351\. The probability of matching exactly four balls is 0.0120923. And the probability of matching exactly five is 0.000644925. I'll show you how to calculate those later. So, to calculate your return:

*   You always lose your initial 0.25
*   8.39351 percent of the time, you win back 0.25\.
*   1.20923 percent of the time, you win back a dollar
*   0.0644925 percent of the time, you win $200.
*   Therefore, your return is -0.25 + 0.0839351 * (0.25) + 0.0120923 * (1) + 0.000644925 * (200). That is -0.087939, so you lose roughly nine cents on every 25 cent bet.
*   If you care to normalize that to the dollar, you normalized return is -0.087939/.25 = -0.35 per bet. That's one lousy bet. At least it only costs a quarter (although the fine print says you have to play 21 times....)

* * *

Onto the lab. In mathematics, a binomial coefficient _binom(n,k)_ is defined to equal (n!)/((k!)(n-k)!). It represents the number of ways to choose _k_ distinct items from a collection of _n_. Therefore, the total number of ways that you can choose 20 balls from 80 is _binom(80,20) = (80!)/(20!60!)_.

In Keno, suppose you pick _p_ balls. Then the number of ways to match exactly _c_ of those _p_ in the twenty randomly chosen balls is:

<center>_binom(80-p,20-c) * binom(p,c)_</center>

So, the probability of you matching exactly exactly _c_ of _p_ is:

<center>_binom(80-p,20-c) * binom(p,c) / binom(80,20)_</center>

Let's take a concrete example. If we choose five balls and want to match exactly three, that's: _binom(75,17) * binom(5,3) / binom(80,20)_. Which equals:

<center>![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/binom1.jpg)</center>

Fortunately, we can cancel quite a few of these terms. For example, (75!)/(80!) = 1/(80*79*78*77*76). And (5!)/(3!) = 5*4\. We can keep cancelling until we get:

<center>![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab6/binom2.jpg)</center>

This equals 0.0839351\.

(For the true nerds, yes, we can do a prime factorization and cancel many more terms, but for the purposes of this lab, we'll just do simple cancellations).

* * *

### Your Job: #1: product.cpp

You are to write two programs: **product.cpp** and **keno.cpp**.

The first implements a class called a "product", defined in **[product.h](product.h)**:

<pre>#ifndef _PRODUCT_H
#define _PRODUCT_H
#include <iostream>
#include <vector>
#include <cstdlib>
using namespace std;

class Product {
  public:
    void Invert();
    void Multiply_Number(int n);
    void Divide_Number(int n);
    void Multiply_Factorial(int n);
    void Divide_Factorial(int n);
    void Multiply_Binom(int n, int k);
    void Divide_Binom(int n, int k);
    void Clear();
    void Print();
    double Calculate_Product();
  protected:
    vector <int> numerator;
    vector <int> denominator;
};

#endif
</pre>

This represents a product as two vectors - a numerator and a denominator. These will start as empty vectors. When you call **Multiply_Number(i)**, you will make sure that **numerator[i]** and **denominator[i]** exist, and then you will increment **numerator[i]**. When you call **Divide_Number(i)**, you will again make sure that **numerator[i]** and **denominator[i]** exist, and then you will increment **denominator[i]**. You don't have to error check, but you may assume that **Multiply_Number(i)** and **Divide_Number(i)** are always called on positive integers. So, if you make the following calls:

<pre>Product p;

p.Multiply_Number(4);
p.Multiply_Number(5);
p.Multiply_Number(5);
p.Divide_Number(5);
</pre>

</center>

Then **p's** numerator will be a vector containing: { 0, 0, 0, 0, 1, 2 } and **p's** denominator will be a vector containing: { 0, 0, 0, 0, 0, 1 }.

The other calls are defined as follows:

*   **Multiply_Factorial(n)** and **Divide_Factorial(n)** multiply and divide by **(n!)**. Note, (0!) is equal to one and negative numbers are undefined. You do not have to error check for negative numbers.
*   **Multiply_Binom(n,k)** and **Divide_Binom(n,k)** multiply and divide by _binom(n,k)_. Again, you do not have to error check for negative numbers, or for whether **k** is greater than **n**. However, it's fair game for **k** to be zero, and for both **n** and **k** to be zero.
*   **Invert()** swaps the numerator and denominator.
*   **Print()** prints what the product is by printing the numerator and denominator. It should cancel numbers that are in both the numerator and denominator. Numbers in the numerator should be separated by spaces and asterisks, and numbers in the denominator should be separated by slashes. If the numerator is equal to one, print "1". If the denominator is equal to one, print nothing.

    For example, the following code:

    <pre>Product p;

    p.Multiply_Number(5);
    p.Multiply_Number(4);
    p.Divide_Number(3);
    p.Print();
    </pre>
    
    Will print:
    <pre>4 * 5 / 3
    </pre>

    And the following code:

    <pre>Product p;

    p.Print();
    p.Multiply_Binom(6,3);
    p.Print();
    p.Multiply_Number(5);
    p.Divide_Number(4);
    </pre>

    Will print:

    <pre>
    1
    4 * 5 * 6 / 2 / 3
    5 * 5 * 6 / 2 / 3
    </pre>

*   Finally, **Calculate_Product()** calculates and returns the product. Like **Print()** if terms cancel, **Calculate_Product()** should not use them for the calculation. For example, in the last product above, **Calculate_Product()** should calculate 5*5*6/2/3, and not 4*5*5*6/2/3/4.

Although that's a lot of text, implementing **product.cpp** is extremely straightforward. It shouldn't take you long, but make sure you test it.

To help you test, I have a program called **[prod_tester.cpp](prod_tester.cpp)** in the lab directory, which lets you enter commands on standard input to manipulate a product:

<pre>UNIX> **prod_tester**
**Help?**
Bad command.  Should be one of

  CLEAR, CALCULATE, INVERT, PRINT, MULTIPLY, DIVIDE, MULT_EXP, DIV_EXP, MULT_BINOM or DIV_BINOM.
**PRINT**
1
**MULTIPLY 5**
**PRINT**
5
**DIVIDE 5**
**PRINT**
1
**MULT_BINOM 75 17** 
**MULT_BINOM 5 3**
**DIV_BINOM 80 20**
**PRINT**
4 * 5 * 18 * 19 * 20 * 59 * 60 / 2 / 76 / 77 / 78 / 79 / 80
**CALCULATE**
0.0839351
**<CNTL-D>**
UNIX> 
</pre>

When you compile your **product.cpp** with **[prod_tester.cpp](prod_tester.cpp)**, your output should match mine _exactly_. Many of the grading script's tests will use **prod_tester** to test your program.

* * *

### Your Job: #2: keno.cpp

Now that you've written **product.cpp**, use it to write **keno.cpp**, which calculates Keno odds using the formula above. **Keno.cpp** should read numbers on standard input. The first word will be the amount to bet, and the second should be the number of balls that you are going to pick. After that, there will be pairs of words that compose the winning table. These will be in the order _catch, payout_, where **catch** is the exact number of balls to match, and **payout** is the payout of that number of balls. You do not need to error check.

So, for example, the "5 catch win" above would be represented with:

<pre>0.25 5    3 0.25   4 1   5 200
</pre>

Now the first line of your program should print out the bet, and the second line should print the balls picked. The bet should be padded to two decimal places (use **printf** instead of **cout**). Then for each payout, you should print the probability of winning and the expected return (probability times payout). Use **cout** for these lines and have them match mine exactly. Finally, you should print the expected return per bet, which is the sum of all expected returns minus the bet. Have this padded to two decimal places (use **printf** instead of **cout**). Finally, print the normalized return, which is the expected return divided by the bet. Again, pad that to two decimal places.

This lets us evaluate all the Keno options in the flier. First, the "2-bit menu":

<pre>UNIX> **echo "0.25 5    3 0.25   4 1   5 200" | keno**
Bet: 0.25
Balls Picked: 5
  Probability of catching 3 of 5: 0.0839351 -- Expected return: 0.0209838
  Probability of catching 4 of 5: 0.0120923 -- Expected return: 0.0120923
  Probability of catching 5 of 5: 0.000644925 -- Expected return: 0.128985
Your return per bet: -0.09
Normalized: -0.35
UNIX> **echo "0.25 6   3 .25  4 .50   5 10   6 500" | keno**
Bet: 0.25
Balls Picked: 6
  Probability of catching 3 of 6: 0.12982 -- Expected return: 0.0324549
  Probability of catching 4 of 6: 0.0285379 -- Expected return: 0.014269
  Probability of catching 5 of 6: 0.00309564 -- Expected return: 0.0309564
  Probability of catching 6 of 6: 0.000128985 -- Expected return: 0.0644925
Your return per bet: -0.11
Normalized: -0.43
UNIX> **echo "0.25 7   4 .25  5 .75   6 75  7 3000" | keno**
Bet: 0.25
Balls Picked: 7
  Probability of catching 4 of 7: 0.052191 -- Expected return: 0.0130477
  Probability of catching 5 of 7: 0.0086385 -- Expected return: 0.00647888
  Probability of catching 6 of 7: 0.000732077 -- Expected return: 0.0549058
  Probability of catching 7 of 7: 2.44026e-05 -- Expected return: 0.0732077
Your return per bet: -0.10
Normalized: -0.41
UNIX> **echo "0.25 8  5 1  6 20  7 300 8 10000" | keno**
Bet: 0.25
Balls Picked: 8
  Probability of catching 5 of 8: 0.0183026 -- Expected return: 0.0183026
  Probability of catching 6 of 8: 0.00236671 -- Expected return: 0.0473343
  Probability of catching 7 of 8: 0.000160455 -- Expected return: 0.0481365
  Probability of catching 8 of 8: 4.34566e-06 -- Expected return: 0.0434566
Your return per bet: -0.09
Normalized: -0.37
UNIX> **echo "0.25 9   5 1  6 10   7 35  8 800  9 13000" | keno**
Bet: 0.25
Balls Picked: 9
  Probability of catching 5 of 9: 0.0326015 -- Expected return: 0.0326015
  Probability of catching 6 of 9: 0.00571956 -- Expected return: 0.0571956
  Probability of catching 7 of 9: 0.000591678 -- Expected return: 0.0207087
  Probability of catching 8 of 9: 3.25925e-05 -- Expected return: 0.026074
  Probability of catching 9 of 9: 7.24277e-07 -- Expected return: 0.0094156
Your return per bet: -0.10
Normalized: -0.42
UNIX> **echo "0.25 10  5 .25  6 2.50  7 25  8 250  9 2500  10 25000" | keno**
Bet: 0.25
Balls Picked: 10
  Probability of catching 5 of 10: 0.0514277 -- Expected return: 0.0128569
  Probability of catching 6 of 10: 0.0114794 -- Expected return: 0.0286985
  Probability of catching 7 of 10: 0.00161114 -- Expected return: 0.0402786
  Probability of catching 8 of 10: 0.000135419 -- Expected return: 0.0338548
  Probability of catching 9 of 10: 6.12065e-06 -- Expected return: 0.0153016
  Probability of catching 10 of 10: 1.12212e-07 -- Expected return: 0.0028053
Your return per bet: -0.12
Normalized: -0.46
UNIX> 
</pre>

Clearly, the "2-bit" menu is not a sound investment strategy. I especially love the part that says "Don't know what number to play? We have Quick Pick!" How about you just remove money from my bank account and then I don't have to think at all!!!!!!

How about the other Keno games? "You asked for it -- The Catch All 5 Spot":

<pre>UNIX> **echo "1.50 5  5 1300" | keno**
Bet: 1.50
Balls Picked: 5
  Probability of catching 5 of 5: 0.000644925 -- Expected return: 0.838402
Your return per bet: -0.66
Normalized: -0.44
UNIX> 
</pre>

The "Brand New 8 spot:"

<pre>UNIX> **echo ".40 8  5 2   6 20  7 200  8 20000" | keno**
Bet: 0.40
Balls Picked: 8
  Probability of catching 5 of 8: 0.0183026 -- Expected return: 0.0366052
  Probability of catching 6 of 8: 0.00236671 -- Expected return: 0.0473343
  Probability of catching 7 of 8: 0.000160455 -- Expected return: 0.032091
  Probability of catching 8 of 8: 4.34566e-06 -- Expected return: 0.0869132
Your return per bet: -0.20
Normalized: -0.49
UNIX> 
</pre>

And "100 Dimes" -- note this one has a catch zero:

<pre>UNIX> **echo ".10 7  0 .10  6 20  7 1200" | keno**
Bet: 0.10
Balls Picked: 7
  Probability of catching 0 of 7: 0.121574 -- Expected return: 0.0121574
  Probability of catching 6 of 7: 0.000732077 -- Expected return: 0.0146415
  Probability of catching 7 of 7: 2.44026e-05 -- Expected return: 0.0292831
Your return per bet: -0.04
Normalized: -0.44
UNIX> 
</pre>

Perhaps I should have ridden the gondola........

* * *

### This is no longer required -- I just include it for amusement

You are visiting your aunt and uncle, and as you walk by their computer room, you hear your eight-year-old neice Pippy swearing up a storm in front of her computer. As you probe, you realize that she's blowing a simulated wad of money on [Free Online Keno](http://onlinekeno.net/play-free-keno/online-keno)!!!

Using your newfound understanding of Keno and your ability to program, write up a paragraph that shows Pippy how much she is losing on each of her fifteen potential Keno bets.

* * *

### Doing Keno in Stages

**Keno.cpp** is a very small program (mine is 56 lines), but you can still do it in stages. For example, I did it in three stages. Stage 1 just prints out the input:

<pre>UNIX> **echo "0.25 5    3 0.25   4 1   5 200" | keno1**
Bet: 0.25
Balls Picked: 5
  Catch 3/5 - 0.25
  Catch 4/5 - 1.00
  Catch 5/5 - 200.00
UNIX> 
</pre>

Stage 2 calculates the probabilities.

<pre>UNIX> **echo "0.25 5    3 0.25   4 1   5 200" | keno2**
Bet: 0.25
Balls Picked: 5
  Probability of catching 3 of 5: 0.0839351
  Probability of catching 4 of 5: 0.0120923
  Probability of catching 5 of 5: 0.000644925
UNIX>
</pre>

And then stage three finishes everything up.