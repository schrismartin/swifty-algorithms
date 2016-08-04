# CS140 -- Lab 4

*   CS140 -- Data Structures
*   [James S. Plank](http://www.cs.utk.edu/~plank)
*   Spring, 2014
*   Directory for files, makefile, executables and gradescript: **/home/plank/cs140/Labs/Lab4**
*   Last modified: _Fri Feb 25 18:02:20 EST 2011_

## The format of this lab

I have written a header file, **hash140.h** and a program **hash_test.cpp** that uses the class/methods defined in that header file. Your job is to create the file **hash140.cpp**, which implements the methods defined in **hash140.h**.

_You may not change either **hash140.h** or **hash_test.cpp**. You will only turn in **hash140.cpp**, and the TA's will compile and test it with the **hash140.h** and **hash_test.cpp** that are in the lab directory._

There is a **makefile** in the lab directory which facilitates compilation.

* * *

## Cryptographic Hash Functions

There are several well-known algorithms that compute hash functions of arbitrarily-sized data. One example is the [MD5](http://en.wikipedia.org/wiki/MD5) function that produces a 128-bit hash function from any sized data. Another example is [SHA-1](http://en.wikipedia.org/wiki/SHA-1), which produces a 160-bit hash. Both functions attempt to generate uniformly distributed hashes from arbitrary data that are secure, in that you can't get any information about the data from the hash. I won't go into a discussion beyond that, except that SHA-1 does a better job, but is more computationally expensive. For our purposes, we will assume that the functions produce hashes from data that look like random streams of bits.

The **openssl** command generates hashes from files using either technique. For example:

<pre>UNIX> <font color="darkred">**cat input-1.txt**</font>
Rosalita, jump a little lighter.
Senorita come sit by my fire.
UNIX> <font color="darkred">**cat input-2.txt**</font>
Sosalita, jump a little lighter.
Senorita come sit by my fire.
UNIX> <font color="darkred">**openssl md5 input-1.txt input-2.txt**</font>
MD5(input-1.txt)= b9937df3fefbe66d8fcdda363730bf14
MD5(input-2.txt)= 3a752ef1b9bfd1db6ba6a701b6772065
UNIX> <font color="darkred">**openssl sha1 input-1.txt input-2.txt**</font>
SHA1(input-1.txt)= 9a2c3d93445fa844094eb213a17fc5996895c925
SHA1(input-2.txt)= 8886b6ef4671093b15c2dba387c3eb169e9db5d2
UNIX> 
</pre>

The representation of the hashes is a long stream of hexadecimal. You can read each hex digit as four bits. Thus the first eight bits of b9937df3fefbe66d8fcdda363730bf14 are 10111001 (b9). The hexadecimal string is 32 characters long -- hence the hash is 128 bits.

The ASCII value of 'R' is 82 (binary 1010010) and the value of 'S' is 83 (binary 1010011). That means that **input-1.txt** and **input-2.txt** differ by exactly one bit. However, look how different the hashes of both values are. That's a great thing about both functions. (Look up [avalanche effect](http://en.wikipedia.org/wiki/Avalanche_effect) if you want to learn more about that property).

Hashes like MD5 and SHA-1 are often used to represent large files. For example, suppose I have an MP3 file in my library that is 4 MB long, and has an MD5 hash of 6282f7860277242c80b69d3a20e0b40e. Suppose I have a CD that should have the song on it and I want to make sure that the song is not corrupted. I can calculate the hash of the song on the CD, and if it doesn't equal 6282f7860277242c80b69d3a20e0b40e, then I know it's corrupted. If it does equal 6282f7860277242c80b69d3a20e0b40e, I can assume with probability 1/2<sup>128</sup> that it is not corrupted.

* * *

### hash140.h

Take a look at the header file **[hash140.h](hash140.h)**:

<pre>#include <iostream>
#include <vector>
#include <string>
using namespace std;

class HashTable {
  public:
    HashTable(int table_size, string function, string collision);
    void Add_Hash(string &key, string &val);
    string Find(string &key);
    void Print();
    int Total_Probes();
  protected:
    vector <string> keys;
    vector <string> vals;
    int nkeys;
    int Fxn;
    int Coll;
    int tmp;
};
</pre>

This defines a **HashTable** class. It will be used to store keys and values. Both are strings. The keys are strings of hexadecimal digits, just like the MD5 and SHA-1 hashes. They may be of arbitrary size. The values are strings as well. The intent of the hash table is to store hashes as keys, and filenames as values. Then you can the hashes to identify the contents of files, as described above.

The constructor creates a hash table of the given size. We will support two hash functions, **"Last7"** and **"XOR"**. I'll define them later. The hash table will use open addressing with one of two collision resolution strategies: **"Linear"** for linear probing and **"Double"** for double hashing. More on that later too.

When you represent the hash table, you'll have two arrays -- one of keys and one of values. They'll both be the same size, and the element in **vals[i]** will correspond to the key in **keys[i]**. You represent an empty slot in **keys** and **vals** with an empty string.

The four protected **int**s named **nkeys**, **Fxn**, **Coll** and **tmp** are there for you to use however you wish. I use them as follows: I use **nkeys** store the number of keys that are in the hash table. I used **Fxn** to record which hash function I'm using, and **Coll** to record which collision resolution strategy I'm using. I used **tmp** to help write **Total_Probes()**. Basically, whenever I call **Find()**, I have it increment **tmp** with the number of probes that it took. That allows me to write **Total_Probes** easily.

Here are the methods. The constructor should be obvious.

**Add_Hash()** adds the given key/val pair to the hash table. You may assume that the key is not already in the hash table. You will insert them with the proper hash function and collision resolution strategy. You need to flag two possible errors:

1.  There is no more room in the hash table.
2.  There is room, but the key can't go in the hash table. This can only happen with double hashing -- I'll give a concrete example below.

**Find()** looks for the given key in the hash table and returns its associated value, or the empty string if the key is not in the hash table.

**Print()** should print all non-empty slots in the hash table, one per line. The index should be printed first, right justified and padded to five characters. Then the key and the value, each separated by a space.

**Total_Probes()** traverses the hash table, and for every key, calculates how many probes it takes to find the key. It returns this value. Again, I'll give examples below.

I've written a **main()** procedure in **[hash_test.cpp](hash_test.cpp)**. It needs to be compiled with your implementation of **HashTable**, which should be in **hash140.cpp**. You run it as follows:

<pre>hash_test table-size function(Last7|XOR) resolution(Linear|Double) [dictionary]
</pre>

The first three arguments are obvious. The last is optional, and is a "dictionary" file of key/value pairs. **Hash_test** first inserts all key/value pairs from the dictionary. Then it accepts commands on standard input:

*   **ADD** _key_ _val_: Adds the given key/val pair. Both should be one word, and the key should be in hexadecimal.
*   **FIND** _key_. This prints the val assocated with _key_.
*   **PRINT** prints the hash table.
*   **TPROBES** prints the total number of probes for every key in the hash table.

I'll show examples of calling this later.

* * *

## Reading Hexadecimal

To read an integer **i** in hexadecimal from standard input, you do:

<pre>cin >> hex >> i;
</pre>

Extending on this, **[read_as_hex.cpp](read_as_hex.cpp)** reads strings from standard input and assumes that they are hexadecimal representations of integers. It prints out the decimal and hexidecimal values of the integers:


<pre>#include <string>
#include <iostream>
#include <sstream>
using namespace std;

main()
{
  string s;
  istringstream ss;
  int i;

  while (cin >> s) {
    ss.clear();
    ss.str(s);
    if (ss >> hex >> i) printf("%d 0x%x\n", i, i);
  }
}
</pre>


Giving it "10" and "20" as input prints out the proper values:

<pre>UNIX> <font color="darkred">**echo 10 20 | read_as_hex**</font>
16 0x10
32 0x20
UNIX> 
</pre>

Why do I tell you this? Well.......

* * *

## Hash Functions

The keys that you store are hexadecimal strings that can be any length. You need to hash these strings into integers. We are going to do this in two ways.

The first is called **Last7**. It treats the last seven digits of the hash string as a number in hexadecimal. Thus, the hash of **"b9937df3fefbe66d8fcdda363730bf14"** will be 120635156, which is equal to 0x730bf14. If the string has fewer than 7 characters, then simply treat the whole string as a hexadecimal number. Thus, the hash of **"11"** will be 17, which is equal to 0x11.

The second hash function is called **XOR**. With this hash function, you break up the string into seven-character words, and then treat each word as a number in hexadecimal. The last word can be fewer than seven characters. You then calculate the bitwise exclusive-or of each of these numbers. That is your hash function. So, let's take an easy example: **"a000000a0000101"**. First, we break this up into seven-digit words (except for the last one): **"a000000"**, **"a000010"** and **"1"**. Their bitwise exclusive-or is equal to 0x11, so the **XOR** hash of **"a000000a0000101"** is equal to 17.

* * *

## Collision Resolution

Linear probing is straightforward. With double hashing, you will use the specified hash function as the first hash function, and the other one as the second hash function. If the second hash function ends up yielding an increment of zero, set it to one.

* * *

## Examples

Let's start with a simple example -- putting one value into a hash table.

<pre>UNIX> <font color="darkred">**hash_test 10 Last7 Linear**</font>
<font color="darkred">**ADD a Fred**</font>
<font color="darkred">**PRINT**</font>
    0 a Fred
<font color="darkred">**<CNTL-D>**</font>
UNIX> 
</pre>

Since 0xa = 10, the hash value is 10, which means that the key/val go to index 0.

Let's try some of those example keys above:

<pre>UNIX> <font color="darkred">**hash_test 10 Last7 Linear**</font>
<font color="darkred">**ADD b9937df3fefbe66d8fcdda363730bf14 Fred**</font>
<font color="darkred">**PRINT**</font>
    6 b9937df3fefbe66d8fcdda363730bf14 Fred
<font color="darkred">**ADD 11 Luther**</font>
<font color="darkred">**PRINT**</font>
    6 b9937df3fefbe66d8fcdda363730bf14 Fred
    7 11 Luther
<font color="darkred">**FIND b9937df3fefbe66d8fcdda363730bf14**</font>
b9937df3fefbe66d8fcdda363730bf14 Fred
<font color="darkred">**FIND Fred**</font>
Didn't find Fred
<font color="darkred">**<CNTL-D>**</font>
UNIX> <font color="darkred">**hash_test 10 XOR Linear**</font>
<font color="darkred">**ADD a000000a0000101 Fred**</font>
<font color="darkred">**PRINT**</font>
    7 a000000a0000101 Fred
<font color="darkred">**<CNTL-D>**</font>
UNIX> 
</pre>

This example shows linear probing in action because **"001"**, **"1"** and **"a000000b"** all hash to values that equal 1 mod 10:

<pre>UNIX> <font color="darkred">**hash_test 10 Last7 Linear**</font>
<font color="darkred">**ADD 001 Fred**</font>
<font color="darkred">**ADD 1 Binky**</font>
<font color="darkred">**ADD a000000b Jim**</font>
<font color="darkred">**PRINT**</font>
    1 001 Fred
    2 1 Binky
    3 a000000b Jim
<font color="darkred">**TPROBES**</font>
3
<font color="darkred">**<CNTL-D>**</font>
UNIX> 
</pre>

The total number of probes is three, because finding **"001"**, requires zero probes, **"1"** requires one and **"a000000b"** requires two. The total is therefore three.

Let's try a harder example with double hashing:

<pre>UNIX> <font color="darkred">**hash_test 10 Last7 Double**</font>
<font color="darkred">**ADD 2 Fred**</font>
<font color="darkred">**ADD 00000100000002 Binky**</font>
<font color="darkred">**ADD c Luther**</font>
<font color="darkred">**PRINT**</font>
    0 00000100000002 Binky
    2 2 Fred
    4 c Luther
<font color="darkred">**TPROBES**</font>
2
<font color="darkred">**<CNTL-D>**</font>
UNIX> 
</pre>

Each of these keys hashes to two. First, **"2"** goes into index two. Then **"00000100000002"** collides. Its hash value using **XOR** is 0x12 = 18\. We take 18 mod 10 and that gives us an increment of 8\. Thus, the first probe will try 2+8 = 10, which is 0 mod 10\. Since that slot is empty, **"00000100000002"** goes into index 0\. Finally, when **"c"** collides, its hash value using **XOR** is also 2\. Therefore, it goes into index 2+2=4\.

When we call **TPROBES**, it returns 2, because **"2"** has zero probes, and **"00000100000002"** and **"c"** have one each.

Two final examples -- the first shows an example where the second hash produces an increment of zero. In that case, you set it to one:

<pre>UNIX> <font color="darkred">**hash_test 10 Last7 Double**</font>
<font color="darkred">**ADD 0 Fred**</font>
<font color="darkred">**ADD a Binky**</font>
<font color="darkred">**PRINT**</font>
    0 0 Fred
    1 a Binky
<font color="darkred">**TPROBES**</font>
1
<font color="darkred">**<CNTL-D>**</font>
UNIX> 
</pre>

When we insert **"a"**, both hash functions return 10, which equals 0 mod 10. Thus, we set the second hash function to 1, and the value goes into index 1.

The last example shows three keys that hash to 5 with both functions:

<pre>UNIX> <font color="darkred">**hash_test 10 Last7 Double**</font>
<font color="darkred">**ADD 5 Fred**</font>
<font color="darkred">**ADD f Binky**</font>
<font color="darkred">**PRINT**</font>
    0 f Binky
    5 5 Fred
<font color="darkred">**ADD 19 Luther**</font>
Couldn't put 19 into the table
UNIX> 
</pre>

When we try to put the third key into the table, it can't go there, because it keeps trying indices five and zero. Your code needs to work in this case -- it needs to identify that the key cannot go into table.

* * *

## When you can't put something into the hash table:

If the hash table is full, print "Hash Table Full" on standard error and exit.

If the hash table is not full print "Couldn't put _xxx_ into the table" on standard error, where _xxx_ is the key, and exit.

* * *

## More realistic usage

The files **[Pictures-MD5.txt](Pictures-MD5.txt)** and **[Pictures-SHA1.txt](Pictures-SHA1.txt)** contain hash dictionaries of a collection of photographs. Suppose I have the picture file [**Picture.jpg**](Picture.jpg), and I want to know if it's a picture that's in the collection. Then I can create its MD5 hash and check it against the dictionary:

<pre>UNIX> <font color="darkred">**openssl md5 Picture.jpg**</font>
MD5(Picture.jpg)= 0c0314df721e20694956605fbace2638
UNIX> <font color="darkred">**hash_test 2000 Last7 Linear Pictures-MD5.txt**</font>
<font color="darkred">**FIND 0c0314df721e20694956605fbace2638**</font>
0c0314df721e20694956605fbace2638 Modified/019955.JPG
<font color="darkred">**<CNTL-D>**</font>
UNIX> <font color="darkred">**openssl sha1 Picture.jpg**</font>
SHA1(Picture.jpg)= c646b63f187c5c77862237157f591f414dc0f2b8
UNIX> <font color="darkred">**hash_test 2000 Last7 Linear Pictures-SHA1.txt**</font>
<font color="darkred">**FIND c646b63f187c5c77862237157f591f414dc0f2b8**</font>
c646b63f187c5c77862237157f591f414dc0f2b8 Modified/019955.JPG
</pre>

That's nice, because it's a lot faster than trying to check against the individual files, which can be quite large.

Here we explore the difference between the various parameters on **[Pictures-SHA1.txt](Pictures-SHA1.txt)**:

<pre>UNIX> <font color="darkred">**echo TPROBES | hash_test 800 Last7 Linear Pictures-SHA1.txt**</font>
201
UNIX> <font color="darkred">**echo TPROBES | hash_test 800 XOR Linear Pictures-SHA1.txt**</font>
258
UNIX> <font color="darkred">**echo TPROBES | hash_test 800 Last7 Double Pictures-SHA1.txt**</font>
155
UNIX> <font color="darkred">**echo TPROBES | hash_test 800 XOR Double Pictures-SHA1.txt**</font>
171
UNIX> <font color="darkred">**echo TPROBES | hash_test 417 Last7 Linear Pictures-SHA1.txt**</font>
4896
UNIX> <font color="darkred">**echo TPROBES | hash_test 417 XOR Linear Pictures-SHA1.txt**</font>
3951
UNIX> <font color="darkred">**echo TPROBES | hash_test 417 Last7 Double Pictures-SHA1.txt**</font>
Couldn't put 0722c16fb69be89210669336d65a76132d2cc8d2 into the table
UNIX> <font color="darkred">**echo TPROBES | hash_test 417 XOR Double Pictures-SHA1.txt**</font>
Couldn't put d55f22e7e31ba01c7f4c3d2729bf28a812e6a400 into the table
UNIX> 
</pre>

When the load factor is just over a half, each element takes roughly half a probe each. Double hashing is clearly better than linear probing. The **Last7** hash function does better than **XOR**, but not by much. I can tell you it's just luck that one is better than the other.

When we make the hash table the exact same size as the input, linear probing works, but now each element takes roughly ten probes each. Double hashing fails because 417 is not a prime number, and double hashing may not check all of the elements in the hash table.

Below, we make the hash table's size a prime number, and double hashing works fine. It also has many fewer collisions.

<pre>UNIX> <font color="darkred">**echo TPROBES | hash_test 419 Last7 Linear Pictures-SHA1.txt**</font>
4808
UNIX> <font color="darkred">**echo TPROBES | hash_test 419 Last7 Double Pictures-SHA1.txt**</font>
1641
UNIX> 
</pre>