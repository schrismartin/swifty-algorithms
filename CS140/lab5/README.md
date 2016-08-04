# CS140 -- Lab 5

### 

*   CS140 -- Data Structures
*   [James S. Plank](http://www.cs.utk.edu/~plank)
*   Spring, 2014
*   Directory for files, makefile, executables and gradescript: **/home/plank/cs140/Labs/Lab5**
*   This is a two week lap.

* * *

## You are not allowed...

You are not allowed to modify **bitmatrix.h** or **bitmatrix_editor.cpp**.

* * *

## Bit-matrices

This lab is all about bit-matrices. These are matrices whose values can only be zero or one, and arithmetic is modulo 2\. You would be surprised how powerful these are. They are used in fault-tolerant storage applications, among other things, which is why I am fond of them.

Let's take some simple examples. Here are four bit-matrices:

| C003.txt | C244.txt | RV.txt | CV.txt |
|:--------:|:--------:|:------:|:------:|
|   ![a]   |   ![b]   |  ![c]  |  ![d]  |

[a]: http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C003.jpg
[b]: http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C244.jpg
[c]: http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/RV.jpg
[d]: http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/CV.jpg

When you add bit-matrices, you simply add elements in corresponding rows and columns, modulo two. So, for example:


![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C003.jpg) + ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C244.jpg) = ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/3-plus-244.jpg)

and

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/RV.jpg) + ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/RV.jpg) = ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/ZV.jpg)


Bit-matrix multiplication is just like standard matrix multiplication, except that addition and multiplication of the individual elements is done modulo two. For example, multiplying **[RV.txt](RV.txt)** and **[CV.txt](CV.txt)** will yield a 1 X 1 matrix whose value is:

<center>(1*1) + (0*0) + (1*1) + (0*1) + (0*1) + (0*0) + (0*0) + (1*1)</center>

This is 1+0+1+0+0+0+0+1 which equals 3%2 which equals 1\. Thus:

<center>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/RV.jpg) * ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/CV.jpg) = ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/O.jpg)

Similarly:

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/CV.jpg) * ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/RV.jpg) = ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Outer.jpg)

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C003.jpg) * ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/CV.jpg) = ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C003-CV.jpg)

and

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C003.jpg) * ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/C244.jpg) = ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/I.jpg)

</center>

That last example is interesting -- when the product of two square matrices is equal to the identity matrix, then these two matrices are _inverses_ of each other. Some matrices, like the one below, have no inverses:

<center>![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Outer.jpg)</center>

* * *

### Bitmatrix.h

You have a big job. Behold **[bitmatrix.h](bitmatrix.h)**:

<pre>#include <string>
#include <iostream>
#include <vector>
using namespace std;

class Bitmatrix {
  public:
    Bitmatrix(string fn);            // Read from a file
    Bitmatrix(int rows, int cols);   // Create an empty bitmatrix
    void Print(int w);               // Print it on standard ouptput with spaces & blank lines 
    void Write(string fn);           // Write it to a file either as hex or zeros & ones
    void PGM(string fn, int pixels, int border);  // Write it to a pgm file 
    int Rows();
    int Cols();
    void Set(int row, int col, char val); // Set the specified element to val
    char Val(int row, int col);           // Return the specified element
    void Swap_Rows(int r1, int r2);
    void R1_Plus_Equals_R2(int r1, int r2);
    Bitmatrix *Copy();
  protected:
    vector <string> M; // The matrix.  Elements are '0' or '1'.
};

Bitmatrix *Sum(Bitmatrix *a1, Bitmatrix *a2);
Bitmatrix *Product(Bitmatrix *a1, Bitmatrix *a2);
Bitmatrix *Sub_Matrix(Bitmatrix *a1, vector <int> &rows);
Bitmatrix *Inverse(Bitmatrix *m);

class HTE {
  public:
    string key;
    Bitmatrix *bm;
};

typedef vector <HTE *> HTVec;

class BM_Hash {
  public:
    BM_Hash(int size);
    void Store(string &key, Bitmatrix *bm);
    Bitmatrix *Recall(string &key);
    HTVec All();
  protected:
    vector <HTVec> table;
};
</pre>


The **Bitmatrix** class implements methods that allow you to create, read, write and manipulate bit-matrices. Here are the methods:

*   **Bitmatrix(int rows, int cols):** Create a bitmatrix of the specified size whose entries are all zeros. If **rows** or **cols** is less than or equal to zero, print an error message, but still create a 1 X 1 bit-matrix whose entry is zero.
*   **Bitmatrix(string fn)**: Read a bit-matrix from a file. The file should contain only zeros, ones, spaces and newlines, and each line should either be blank, or it should contain the same number of non-spaces as all other lines. I've written this one for you, so you don't need to sweat about it too much.
*   **void Write(string fn)**: Write the bit-matrix to a file. Here, just write out the zeros and ones with no spaces. Each row of the bit-matrix gets one row of output.
*   **void Print(int w):** Print the matrix on standard output. If **w** is less than or equal to zero, print each row on its own line with no spaces. Otherwise, print a space after every **w** columns and a blank line after every **w** rows. I've written this one for you.
*   **void PGM(string fn, int pixels, int border)**: Create a PGM file from the bit-matrix. This is how I made the pictures above. The zero entries are white (255) and the one entries are gray (100). Each entry is a **pixels** by **pixels** square. If **border** is greater than zero, then there should be a black border of that many pixels separating each square and around the whole matrix. The above matrices were created with **PGM(xxx, 10, 2)**.
*   **int Rows()**: Return the number of rows in the bit-matrix.
*   **int Cols()**: Return the number of columns in the bit-matrix.
*   **void Set(int row, int col, char val)**: Set the element in the specified row and column (zero-indexed, of course) to the given value. **Val** can be either 0 or '0' to specify zero, and either 1 or '1' to specify one. If **row** or **col** are bad, simply do nothing -- your code should not be erroneous with bad values.
*   **char Val(int row, int col)**: Return the specified value -- zero is 0 and one is 1. **Val()** should return -1 if given bad input.
*   **void Swap_Rows(int r1, int r2)**: Swap the specified rows. This should do nothing if given bad values.
*   **void R1_Plus_Equals_R2(int r1, int r2)** Set row **r1** to be the sum of rows **r1** and **r2**. Again, this should do nothing if given bad values. It's ok for **r2** to equal **r1**.
*   **Bitmatrix *Copy()** Create a new bit-matrix that is a copy of the given bit-matrix and return a pointer to it. To do this, you'll have to create a new empty bit-matrix of the proper size, and then use **Set()** to set its elements properly.

The only piece of data in a **bitmatrix** is a vector of strings named **M**. If **M** is storing a _r_ by _c_ matrix, then it will contain _r_ strings, each of which has _c_ characters. The characters are either '0' for zero or '1' for one.

So, you have to implement 10 methods (there are 12, but I've implemented two of them for you), and only one of them (**PGM()**) is difficult. Were I you, I'd wait until the end to do **PGM()**.

You have to implement four procedures which operate on pointers. Since these are not part of the data structure, you have to use **Rows()** **Cols()**, **Set()**, and **Val()** to implement them. You should _not_ modify the input matrices in any way.

*   **Bitmatrix *Sum(Bitmatrix *a1, Bitmatrix *a2)**: This creates a new bit-matrix which is the sum of **a1** and **a2**. If **a1** and **a2** are not the same size, return NULL.
*   **Bitmatrix *Product(Bitmatrix *a1, Bitmatrix *a2)**: This creates a new bit-matrix which is the product of **a1** and **a2**. This product will have **a1->Rows()** rows and **a2->Cols()** columns. If **a1->Cols()** and **a2->Rows()** do not match, then return NULL.
*   **Bitmatrix *Sub_Matrix(Bitmatrix *a1, vector <int> &rows)**: This creates a new bit-matrix composed of the specified rows of the given bit-matrix. It is ok to repeat entries in **rows**. However, if **rows** is empty or contains bad indices, return NULL.
*   **Bitmatrix *Inverse(Bitmatrix *a1)**: Create and return the inverse of **a1**. To do this, you should also use the **Swap_Rows()** and **R1_Plus_Equals_R2()** methods. I'll go into more detail on how to invert a bit-matrix below. If **a1** is not square or not invertible, return **NULL**.

The first three of these are very easy. **Inverse()** will be tougher.

Finally, you are also going to implement a hash table to store bit-matrices with keys that are strings. You should use the **djb_hash()** function from class as the hash function and you should use separate chaining as the collision resolution mechanism. Your hash table is a vector of vectors of pointers to **HTE**'s (hash table entries). Each hash table entry stores a key and a pointer to a bit-matrix.

The **BM_Hash** class has four methods:

*   **BM_Hash(int size)**: The constructor specifies the size of the table.
*   **void Store(string &key, Bitmatrix *bm)**: Store the given key and bit-matrix in the hash table. If the key is already there, replace the bit-matrix with the given one.
*   **Bitmatrix *Recall(string &key);** return the bit-matrix corresponding to the given **key**. If the key is not in the hash table, then return NULL.
*   **HTVec All()**: Return a vector of all hash table entries in the table. The vector should be ordered just like the hash table. In other words, suppose "A" hashes to 5, "B" hashes to 1 and "C" hashes to 1\. And suppose that "B" was added to the table before "C". Then **All()** should return the HTE's in the order "B", "C", "A".

You should _not_ call **new** or **delete** on bit-matrices when you implement any of the hash table methods. You should call **new** when you create a new **HTE**. That is the only time that you will call **new** in the hash table methods.

* * *

### Starter Code

The file **[bitmatrix_start.cpp](bitmatrix_start.cpp)** provides dummy implementations for everything in the lab, with the exception of **Bitmatrix(string fn)** and **Print()**. The nice thing about it is that it will compile with any program that uses **bitmatrix.h**. However, it won't run correctly. It's a good starting place for you.

* * *

### The testing program matrix_editor.cpp

I've written **[bitmatrix_editor.cpp](bitmatrix_editor.cpp)** as a program that uses all of the features of **bitmatrix.h**. You run it with an optional prompt as a command line argument. If you don't specify a prompt, it will not print a prompt. This is nice because you can treat the editor as an interactive editor, or you can write scripts for it.

Copy **bitmatrix_editor.cpp**, **bitmatrix.h** and **makefile** to your directory. Then copy **bitmatrix_start.cpp** to **bitmatrix.cpp** and type **make**:

<pre>UNIX> <font color="darkred">**make**</font>
g++ -c bitmatrix_editor.cpp
g++ -c bitmatrix.cpp
g++ -o bitmatrix_editor bitmatrix_editor.o bitmatrix.o
UNIX> 
</pre>

Now you have a version of **bitmatrix_editor** that only works for what I have implemented. However, let's explore those. Go ahead and copy the following matrix files too: **[C003.txt](C003.txt)**, **[C244.txt](C244.txt)**, **[CM4_3.txt](CM4_3.txt)**, **[CV.txt](CV.txt)**, **[RV.txt](RV.txt)**, **[t3.txt](t3.txt)** and **[t4.txt](t4.txt)**. **Bitmatrix_editor** reads lines of text from standard input. Blank lines and lines that begin with '#' are ignored. Otherwise, the first word on a line is a command and the remaining words are arguments.

At all times, there is one "current matrix." You may also store and recall matrices with single-word keys. Three simple commands are:

*   **READ _filename_**: This reads a bit-matrix from a given file using the **Read()** method. If there is an error, it will return a single-element matrix whose element is zero.
*   **PRINT _[w]_**: This calls the **Print()** method on the current matrix. If an argument is specified, it is the value of **w** that is passed to the **Print()** method. Otherwise, 0 is passed.
*   **QUIT**: Exits. You can also simply close standard input with CNTL-D.

Since I have implemented these for you in **bitmatrix_start.cpp**, they will work without any extra effort from you:

<pre>UNIX> <font color="darkred">**bitmatrix_editor "BM-Editor>"**</font>
BM-Editor> <font color="darkred">**READ C003.txt**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10000001
11000000
01100001
00110001
00011001
00001100
00000110
00000011
BM-Editor> <font color="darkred">**PRINT 4**</font>
1000 0001
1100 0000
0110 0001
0011 0001

0001 1001
0000 1100
0000 0110
0000 0011
BM-Editor> <font color="darkred">**READ RV.txt**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10100001
BM-Editor> <font color="darkred">**PRINT 4**</font>
1010 0001
BM-Editor> <font color="darkred">**QUIT**</font>
UNIX> 
</pre>

**bitmatrix_editor** also implements the following commands, which of course will only work when you implement the proper methods and procedures:

*   **EMPTY _rows_ _cols_**: Creates a bit-matrix of the given size whose values are all zeros. It sets the current matrix to this matrix.
*   **SET _row_ _col_ _value_**: Sets the given element of the current matrix to the given value.
*   **VAL _row_ _col_**: Returns the value of the given element.
*   **SWAP _r1_ _r2_**: Swaps the given rows of the current matrix using **Swap_Rows()**.
*   **+= _r1_ _r2_**: Sets **r1** of the current matrix equal to **r1+r2** using the **R1_Plus_Equals_R2()** method.
*   **WRITE _fn_**: Calls the **Write()** method to write the current matrix to the specified file.
*   **PGM _fn_ _pixels_ _border_**: Calls the **PGM()** method to create a PGM picture of the current matrix.
*   **STORE _key_**: Makes a copy of the current matrix and stores it into the hash table with the given key. If the key is already in the hash table, it will delete the bit-matrix before putting the copy into the hash table.
*   **RECALL _key_**: If the key is in the hash table, this will set the current matrix to a copy of the bit-matrix stored in the hash table.
*   **ALL _key_**: This calls **All()** and prints out each key, along with the dimensions of the bit-matrix stored there.
*   **SUM _key1_ _key2_**: This adds the two matrices stored with the given keys and puts the sum into the current matrix.
*   **PRODUCT _key1_ _key2_**: This multiplies the two matrices stored with the given keys and puts the product into the current matrix.
*   **SUBMATRIX _row1_ _row2_ _..._**: This creates a submatrix of the current matrix with the specified rows, and replaces the current matrix with the submatrix.
*   **INVERT**: This inverts the current matrix and replaces it with the inverse.

With these last four commands, **bitmatrix_editor** checks to make sure that you haven't modified the input matrices.

Some examples with the above matrices:

<pre>UNIX> <font color="darkred">**bitmatrix_editor 'BM-Editor>'**</font>
BM-Editor> <font color="darkred">**READ C003.txt**</font>
BM-Editor> <font color="darkred">**STORE C003**</font>
BM-Editor> <font color="darkred">**READ C244.txt**</font>
BM-Editor> <font color="darkred">**STORE C244**</font>
BM-Editor> <font color="darkred">**READ CV.txt**</font>
BM-Editor> <font color="darkred">**STORE CV**</font>
BM-Editor> <font color="darkred">**READ RV.txt**</font>
BM-Editor> <font color="darkred">**STORE RV**</font>
BM-Editor> <font color="darkred">**READ t3.txt**</font>
BM-Editor> <font color="darkred">**STORE t3**</font>
BM-Editor> <font color="darkred">**READ t4.txt**</font>
BM-Editor> <font color="darkred">**STORE t4**</font>
BM-Editor> <font color="darkred">**RECALL RV**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10100001
BM-Editor> <font color="darkred">**ALL**</font>
CV                               8 X   1
RV                               1 X   8
t3                              16 X   8
t4                               8 X  16
C003                             8 X   8
C244                             8 X   8
BM-Editor> <font color="darkred">**SUM C003 C003**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
BM-Editor> <font color="darkred">**SUM C003 C244**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
11111110
11111111
10000001
00111110
11100001
11110000
11111000
11111100
BM-Editor> <font color="darkred">**PRODUCT RV CV**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
1
BM-Editor> <font color="darkred">**PRODUCT C003 C244**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10000000
01000000
00100000
00010000
00001000
00000100
00000010
00000001
BM-Editor> <font color="darkred">**PRODUCT C003 CV**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
0
1
0
1
1
1
0
1
BM-Editor> <font color="darkred">**RECALL t3**</font>
BM-Editor> <font color="darkred">**PRINT 8**</font>
10000001
11000000
01100001
00110001
00011001
00001100
00000110
00000011

01111111
00111111
11100000
00001111
11111000
11111100
11111110
11111111
BM-Editor> <font color="darkred">**RECALL t4**</font>
BM-Editor> <font color="darkred">**PRINT 8**</font>
10000001 01111111
11000000 00111111
01100001 11100000
00110001 00001111
00011001 11111000
00001100 11111100
00000110 11111110
00000011 11111111
BM-Editor> <font color="darkred">**PRODUCT t3 t4**</font>
BM-Editor> <font color="darkred">**PRINT 8**</font>
10000010 10000000
01000001 01000000
10100010 00100000
01010011 00010000
00101011 00001000
00010101 00000100
00001010 00000010
00000101 00000001

10000000 11010101
01000000 11101010
00100000 10100000
00010000 00000101
00001000 01010111
00000100 10101011
00000010 01010101
00000001 10101010
BM-Editor> <font color="darkred">**PRODUCT t4 t3**</font>
BM-Editor> <font color="darkred">**PRINT 8**</font>
01010111
10101011
00000010
01010110
01111100
10111110
01011111
10101111
BM-Editor> <font color="darkred">**RECALL C003**</font>
BM-Editor> <font color="darkred">**INVERT**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
01111111
00111111
11100000
00001111
11111000
11111100
11111110
11111111
BM-Editor> <font color="darkred">**RECALL C244**</font>
BM-Editor> <font color="darkred">**INVERT**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10000001
11000000
01100001
00110001
00011001
00001100
00000110
00000011
BM-Editor> <font color="darkred">**PRODUCT CV RV**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10100001
00000000
10100001
10100001
10100001
00000000
00000000
10100001
BM-Editor> <font color="darkred">**INVERT**</font>
Matrix not invertible.
BM-Editor> <font color="darkred">**QUIT**</font>
UNIX>
</pre>

* * *

### Inverting a bit-matrix

Inverting a bit-matrix is easier than doing a general matrix inversion. However, the steps are the same. Suppose you want to invert the square matrix _M_. What you do is make a copy of _M_, and create an identity matrix of the same size as _M_. Call this matrix _Inv_. Then you perform **"SWAP"** and **"+="** operations on the copy of _M_ to turn it into an identity matrix. You perform the exact same operations on _Inv_. When you're done, the inverse of the original matrix is in _Inv_

Let's perform an example on the matrix in **[Inv-Ex.txt](Inv-Ex.txt)**:

<pre>10110
01011
10011
11001
01100
</pre>

You first go through each row of _M_ from the first to the last, doing the following steps:

*   Suppose you are at row _i_. If _M[i][i]_ is not one, then find a row _j_ where _j > i_ such that _M[j][i]_ equals one, and swap rows _i_ and _j_. If you can't find such a row, the matrix is not invertible.
*   Now, look at every row _j_ such that _j > i_. If _M[j][i]_ equals one, then set row _j_ equal to the sum of rows _i_ and _j_.

We'll do this for our example:

| **Action** | _M_ | _Inv_ |
|:----------:|:---:|:-----:|
| Start | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-0.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-0.jpg) |
| _i=0_ No swap necesary. Set row 2 = row 2 + row 0. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-1.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-1.jpg) |
| _i=0 still._ Set row 3 = row 3 + row 0. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-2.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-2.jpg) |
| _i=1_ No swap necesary. Set row 3 = row 3 + row 1. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-3.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-3.jpg) |
| _i=1 still._ Set row 4 = row 4 + row 1. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-4.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-4.jpg) |
| _i=2_ Swap row 2 and row 3 | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-5.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-5.jpg) |
| _i=2 still._ Set row 4 = row 4 + row 2. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-6.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-6.jpg) |
| _i=3_ Swap row 3 and row 4 | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-7.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-7.jpg) |


When you're done with this pass, _M_ will be an upper-triangular matrix. Now, you start with the last row and go to the first row. Suppose you are in row _i_:

*   If there is any _j > i_ where _M[i][j]_ equals one, replace row _i_ with the sum of row _i_ and row _j_.

When you are done with this step, _M_ will be the identity matrix, and _Inv_ will be the inverse of the original _M_:

<center>

| **Action** | _M_ | _Inv_ |
|:----------:|:---:|:-----:|
| Start: _i=4_ No action necessary. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-7.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-7.jpg) |
| _i=3_ Set row 3 = row 3 + row 4. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-8.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-8.jpg) |
| _i=2_ No action necessary. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-8.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-8.jpg) |
| _i=1_ Set row 1 = row 1 + row 3. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-A.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-A.jpg) |
| _i=1_ still. Set row 1 = row 1 + row 4. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-B.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-A.jpg) |
| _i=0_ Set row 0 = row 0 + row 2. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-B.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-B.jpg) |
| _i=0_ still. Set row 0 = row 0 + row 3. | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Ex-C.jpg) | ![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab5/Inv-C.jpg) |

</center>

Finally, let's double-check ourselves:

<pre>BM-Editor> <font color="darkred">**READ Inv-Ex.txt**</font>
BM-Editor> <font color="darkred">**STORE Inv-Ex**</font>
BM-Editor> <font color="darkred">**INVERT**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
01101
11011
11010
00111
10100
BM-Editor> <font color="darkred">**STORE Inv**</font>
BM-Editor> <font color="darkred">**PRODUCT Inv Inv-Ex**</font>
BM-Editor> <font color="darkred">**PRINT**</font>
10000
01000
00100
00010
00001
BM-Editor> 
</pre>

* * *

### Gradescript Rubric

First, this lab will count double.

The gradescript will have up to 200 test cases. 30 percent of them will test matrix inversion and 20 percent of them will test the PGM file. Your PGM doesn't have to match mine in format; however, its size and pixels must match mine exactly.