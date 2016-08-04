## CS140 Lab 8 - Dlists

*   [Jim Plank](http://www.cs.utk.edu/~plank)
*   Directory: **~plank/cs140/Labs/Lab8**
*   Last modification date: _Tue Mar 27 22:47:42 EDT 2012_

* * *

### Part 1: dlist.cpp

This lab has two parts. The first is straightforward. Write **dlist.cpp** so that it properly implements all of the methods of the **Dlist** class, as described in the [lecture notes on linked data structures](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Notes/Linked/index.html).

You are _not_ allowed to have any STL data structures or header files in your implementation -- you may only include **<iostream>** **<cstdlib>** and **"Dlist.h"**. The implementation should be as described in the lecture notes: as a circular list with a sentinel node.

Also, your destructor is not allowed to call **Erase()** or **Pop_Back()** or **Pop_Front()**. You should manually delete every node on the list.

The gradescript will test all of the **dlistrev-_x_.cpp** programs from the lecture notes, plus the program **list_editor** that I describe below.

* * *

### Part 2: dl_hash.cpp

Behold **[dl_hash.h](dl_hash.h)**, which gives the API for a hash table for strings:


<pre>#include "dlist.h"
#include <vector>
using namespace std;

class DL_Hash {
  public:
    DL_Hash(int size);
    ~DL_Hash();
    void Insert(string &s);
    int Present(string &s);
    void Erase(string &s);
    void Strip_All_Substring(string &s);
    void Print();
  protected:
    vector <Dlist *> table;
};
</pre>

Your job is to implement this class in **dl_hash.cpp**.

The hash table is going to use separate chaining, using the **Dlist** type to implement the chains. Please make note that each element of the hash table is a pointer to a list, so you'll have to call "**new Dlist**" for every element of the table in your constructor. You'll also have to call **delete** in the destructor.

**Insert()** inserts a string into the hash table. Use **djb_hash()** as the hash function. If the string is already there, it should do nothing. **Present()** returns whether the string is present in the hash table, and **Erase()** erases the string if it is there. If it's not there, **Erase()** should do nothing.

**Strip_All_Substring()** should delete every entry in the hash table that has the given string as a substring. You should not use the **Erase()** method of the **DL_Hash** class for this. You should use the **Erase()** method of the **Dlist** class.

Finally, **Print()** prints out the hash table. It does this in order of hash table entry, and for strings that have the same hash value, they are printed in the order in which the elements were inserted into the hash table. The format should be one string per line, where each line contains the hash index, padded to four characters and right justified, then a space and then the string.

To test this, I have written **[dl_hash_test.cpp](dl_hash_test.cpp)** which is a simple command-based program which supports **INSERT**, **INSERT**, **PRESENT**, **ERASE**, **STRIP**, **PRINT** and **QUIT**. Its command line arguments are the table size and a prompt. Using it is straightforward:

<pre>UNIX> <font color="darkred">**dl_hash_test 50 'DL_Hash>'**</font>
DL_Hash> <font color="darkred">**INSERT Thor**</font>
DL_Hash> <font color="darkred">**INSERT Binky**</font>
DL_Hash> <font color="darkred">**INSERT Brody Masonry**</font>
DL_Hash> <font color="darkred">**PRESENT Thor**</font>
Yes
DL_Hash> <font color="darkred">**PRESENT Frenchy**</font>
No
DL_Hash> <font color="darkred">**PRINT**</font>
  42 Binky
  42 Brody Masonry
  46 Thor
DL_Hash> <font color="darkred">**ERASE Thor**</font>
DL_Hash> <font color="darkred">**PRINT**</font>
  42 Binky
  42 Brody Masonry
DL_Hash> <font color="darkred">**ERASE Thor**</font>           -- This does nothing, since Thor is no longer in the table.
DL_Hash> <font color="darkred">**PRINT**</font>
  42 Binky
  42 Brody Masonry
DL_Hash> <font color="darkred">**INSERT Binky**</font>         -- This does nothing, since Binky is already in the table.
DL_Hash> <font color="darkred">**PRINT**</font>
  42 Binky
  42 Brody Masonry
DL_Hash> <font color="darkred">**INSERT Pinky**</font>
DL_Hash> <font color="darkred">**INSERT Dinky**</font>
DL_Hash> <font color="darkred">**INSERT Winky**</font>
DL_Hash> <font color="darkred">**PRINT**</font>
  33 Winky
  34 Dinky
  36 Pinky
  42 Binky
  42 Brody Masonry
DL_Hash> <font color="darkred">**STRIP ink**</font>
DL_Hash> <font color="darkred">**PRINT**</font>
  42 Brody Masonry
DL_Hash> <font color="darkred">**QUIT**</font>
UNIX> 
</pre>

* * *

### The list editor

[List_editor.cpp](list_editor.cpp) is yet another command-line program that lets me test your code. There is always a current list that is being edited. The list holds strings that are single words, and the words in a list must be unique.

The following commands are supported:

*   **CLEAR**: This deletes the list and creates a new one with **new**.
*   **PRINT_FORWARD**: This prints the list, all on one line in the forward direction.
*   **PRINT_REVERSE**: This prints the list, all on one line in the reverse direction.
*   **PUSH_BACK _s_**: This calls **Push_Back** on the string _s_.
*   **PUSH_FRONT _s_**: This calls **Push_Front** on the string _s_.
*   **POP_BACK _s_**: This calls **Pop_Back** on the string _s_.
*   **POP_FRONT _s_**: This calls **Pop_Front** on the string _s_.
*   **ERASE _s_**: This calls **Erase** on the pointer to the node that holds string _s_. If _s_ is not on the list, this does nothing.
*   **INSERT_BEFORE _s1_ _s2_**: This calls **Insert_Before(s1, d)**, where **d** is the pointer to the node that holds string _s2_. If _s2_ is not on the list, this does nothing.
*   **INSERT_AFTER _s1_ _s2_**: This calls **Insert_After(s1, d)**, where **d** is the pointer to the node that holds string _s2_. If _s2_ is not on the list, this does nothing.
*   **EMPTY**: This returns whether the list is empty.
*   **SIZE**: This returns the list's size.
*   **QUIT**: Exit.

So, for example:

<pre>UNIX> <font color="darkred">**list_editor 'Editor>'**</font>
Editor> <font color="darkred">**PUSH_BACK a**</font>
Editor> <font color="darkred">**PUSH_BACK b**</font>
Editor> <font color="darkred">**PUSH_BACK c**</font>
Editor> <font color="darkred">**PUSH_BACK d**</font>
Editor> <font color="darkred">**PRINT_FORWARD**</font>
a b c d
Editor> <font color="darkred">**PUSH_FRONT z**</font>
Editor> <font color="darkred">**PRINT_FORWARD**</font>
z a b c d
Editor> <font color="darkred">**PRINT_REVERSE**</font>
d c b a z
Editor> <font color="darkred">**POP_BACK**</font>
d
Editor> <font color="darkred">**POP_FRONT**</font>
z
Editor> <font color="darkred">**PRINT_FORWARD**</font>
a b c
Editor> <font color="darkred">**SIZE**</font>
3
Editor> <font color="darkred">**EMPTY** </font>
No
Editor> <font color="darkred">**INSERT_BEFORE xxx b**</font>
Editor> <font color="darkred">**PRINT_FORWARD**</font>
a xxx b c
Editor> <font color="darkred">**INSERT_AFTER yyy b**</font>
Editor> <font color="darkred">**PRINT_FORWARD**</font>
a xxx b yyy c
Editor> <font color="darkred">**ERASE b**</font>
Editor> <font color="darkred">**PRINT_FORWARD**</font>
a xxx yyy c
Editor> <font color="darkred">**SIZE**</font>
4
Editor> <font color="darkred">**CLEAR**</font>
Editor> <font color="darkred">**EMPTY**</font>
Yes
Editor> <font color="darkred">**PUSH_BACK a**</font>
Editor> <font color="darkred">**PRINT_FORWARD**</font>
a
Editor> <font color="darkred">**QUIT**</font>
UNIX> 
</pre>