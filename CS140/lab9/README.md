# CS140 -- Lab A

### 

*   CS140 -- Data Structures and Algorithms I
*   [James S. Plank](http://www.cs.utk.edu/~plank)
*   This file: [**http://www.cs.utk.edu/~plank/plank/classes/cs140/Labs/LabA**](http://www.cs.utk.edu/~plank/plank/classes/cs140/Labs/LabA)

This lab builds on the Binary Search Tree data structure from the [lecture notes on trees.](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Notes/Trees/index.html) In particular, I have copied **bstree.h**, **bstree.cpp** and **bstree_test.cpp** to **[laba.h](laba.h)**, **[laba.cpp](laba.cpp)**, **[laba_test.cpp](laba_test.cpp)** respectively. I then added some public and protected methods to **[laba.h](laba.h)**. Your job is to implement them in **laba.cpp**:

*   **void Postorder()** -- this does a postorder printing of the tree. As with the **Print()** method, each line should precede each name by _2l_ spaces, where _l_ is the depth of the node. When you implement it, you should use the protected method **recursive_postorder()**. You should _not_ call **Depth()** to determine the depth of a node. The TA's will look for that, and they will take off for it.
*   **void Preorder()** -- this does a preorder printing of the tree. Its format is like **Postorder()**. When you implement it, you should use the protected method **recursive_preorder()**. Again, you should _not_ call **Depth()** to determine the depth of a node. The TA's will look for that, and they will take off for it.
*   **int Depth(string key)** -- this prints the depth of the node with the given key. You don't need recursion to implement this. If the key is not in the tree, return -1.
*   **int Height()** -- this prints the depth of the node with the maximum depth in the tree. You should call the recursive protected method **recursive_height()** to implement this. You should not call **Depth()**. If the tree is empty, its height is -1.
*   **int IsAVL()** -- this returns 1 if the tree is an AVL tree and 0 if it is not. You should call the recursive protected method **recursive_height_and_avl_check()** to implement this. When I implemented **recursive_height_and_avl_check(n)**, I had it return the height of the tree rooted at **n** if it is a legal AVL tree, and -2 if it is not a legal AVL tree.
*   **int Rotate(string key)** -- this finds the node with the given key and performs a rotation about this node, as defined in the [AVL Tree Lecture Notes](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Notes/AVL-Trees/index.html). It should return 1 if it is successful. It should return 0 if either the key is not in the tree, or the key is the root of the tree, since you cannot rotate the root.

Your job is to implement these methods in **laba.cpp**. That is the file that you should submit. _You are not allowed to modify **laba.h** or **laba_test.cpp**._

* * *

### The testing program

The program that we will use in the gradescript is **laba_test.cpp**. It is simply an augmentation of **bstree_test** from the binary search tree lecture notes. It has additional commands for each of the methods that you are implementing. So:

<pre>UNIX> <font color="darkred">**laba_test LABA':'**</font>
LABA: <font color="darkred">**INSERT Adam Resistant 833-118-4192 470-10-0161**</font>
LABA: <font color="darkred">**INSERT Dylan Politician 451-532-5606 940-23-2116**</font>
LABA: <font color="darkred">**INSERT Kaitlyn Fortescue 323-215-8830 975-92-4704**</font>
LABA: <font color="darkred">**PRINT**</font>
    Kaitlyn Fortescue
  Dylan Politician
Adam Resistant
LABA: <font color="darkred">**INSERT Brianna Quintillion 537-619-7786 208-57-2191**</font>
LABA: <font color="darkred">**PRINT**</font>
    Kaitlyn Fortescue
  Dylan Politician
    Brianna Quintillion
Adam Resistant
LABA: <font color="darkred">**POSTORDER**</font>
    Brianna Quintillion
    Kaitlyn Fortescue
  Dylan Politician
Adam Resistant
LABA: <font color="darkred">**PREORDER**</font>
Adam Resistant
  Dylan Politician
    Brianna Quintillion
    Kaitlyn Fortescue
LABA: <font color="darkred">**HEIGHT**</font>
2
LABA: <font color="darkred">**DEPTH Adam Resistant**</font>
0
LABA: <font color="darkred">**DEPTH Brianna Quintillion**</font>
2
LABA: <font color="darkred">**DEPTH Dylan Politician**</font>
1
LABA: <font color="darkred">**ISAVL**</font>
No
LABA: <font color="darkred">**ROTATE Dylan Politician**</font>
Rotated.
LABA: <font color="darkred">**PRINT**</font>
  Kaitlyn Fortescue
Dylan Politician
    Brianna Quintillion
  Adam Resistant
LABA: <font color="darkred">**ISAVL**</font>
Yes
LABA: <font color="darkred">**QUIT**</font>
UNIX> 
</pre>

The grading script does the following:

*   Cases 1 - 10 test **Insert()**, **Preorder()** and **Postorder**.
*   Cases 11 - 20 test **Insert()** and **Depth()**.
*   Cases 21 - 30 test **Insert()** and **Height()**.
*   Cases 31 - 40 test **Insert()** and **IsAVL()**.
*   Cases 40 - 50 test **Insert()**, **Rotate()** and **Print()**.
*   Cases 51 - 100 test every method in the **BSTree** class.