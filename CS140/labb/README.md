## CS140 Practice Lab - AVL Trees

*   [James S. Plank](http://www.cs.utk.edu/~plank)
*   Directory: **~plank/cs140/Labs/Old-Lab-A-AVL**
*   Last modification date: _Sun Apr 17 23:42:25 EDT 2011_

* * *

### AVLTree.cpp

Your job is to implement AVL trees in **avltree.cpp**. You should implement it according to the rules outlined in the [lecture notes on AVL Trees](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Notes/AVL-Trees/index.html).

The header file for AVL trees is in **[avltree.h](avltree.h)**:

<pre>#include <iostream>
#include <vector>
using namespace std;

class AVLTNode {
  public:
    AVLTNode *left;
    AVLTNode *right;
    AVLTNode *parent;
    int height;
    string key;
    void *val;
};

class AVLTree {
  public:
    AVLTree();
    ~AVLTree();
    int Insert(string key, void *val);
    void *Find(string key);
    int Delete(string key);
    void Print();
    int Size();
    int Empty();
    vector <void *> Sorted_Vector();
  protected:
    AVLTNode *sentinel;
    int size;
    vector <void *> array;

    void Check_Balance(AVLTNode *n);
    AVLTNode *Rebalance(AVLTNode *n);
    void Rotate(AVLTNode *n);

    void recursive_inorder_print(int level, AVLTNode *n);
    void recursive_make_vector(AVLTNode *n);
    void recursive_destroy(AVLTNode *n);

};
</pre>

The public methods are exactly the same as the Binary Search Tree data structure from the lecture notes. There are just four differences:

1.  Each node has a _height_ field.
2.  There is a protected method called **Rotate(n)**. It should perform a rotation about node _n_, updating all pointers and heights of all relevant nodes.
3.  There is a protected method called **Rebalance(n)**. It should check to see if a node is balanced. If it is, it should just return _n_. If it is not balanced, then it should rebalance it by properly identifying and performing the type of rebalance (Zig-Zig or Zig-Zag), and then returning the root of the new subtree.
4.  There is a protected method called **Check_Balance(n)**. Its job is to set the height of node _n_, and then to set _n_ equal to **Rebalance(n)**. If the new height of _n_ is different from its old height, then it should continue checking _n->parent_. If not, it can return.

Now, when you perform insertion to create a node _n_, call **Check_Balance(_n->parent_)**. That will identify whether rebalancing is necessary on any node up to the root, and it will perform the rebalancing.

When you perform deletion on _n_, use **Check_Balance()** to fix the balancing when you're done. If you order your operations correctly, you can simply make a recursive call to **Delete()** when _n_ has two children.

The only traversal that you should modify from the lecture nodes is **recursive_inorder_print()**. It should print the height of each node before it prints its keys.

The other traversals will be unchanged from the lecture notes on binary search trees. Test your code with **avltree_test**:

<pre>UNIX> <font color="darkred">**avltree_test 'AVL>'**</font>
AVL> <font color="darkred">**INSERT Fred 0 0**</font>
AVL> <font color="darkred">**INSERT Luther 1 1**</font>
AVL> <font color="darkred">**PRINT** </font>
  0 Luther
1 Fred
AVL> <font color="darkred">**INSERT Xavier 2 2**</font>
AVL> <font color="darkred">**PRINT**</font>
  0 Xavier
1 Luther
  0 Fred
AVL> <font color="darkred">**INSERT Binky 3 3**</font>
AVL> <font color="darkred">**INSERT Daisy 4 4**</font>
AVL> <font color="darkred">**PRINT**</font>
  0 Xavier
2 Luther
    0 Fred
  1 Daisy
    0 Binky
AVL> <font color="darkred">**DELETE Xavier**</font>
AVL> <font color="darkred">**PRINT**</font>
  1 Luther
    0 Fred
2 Daisy
  0 Binky
AVL> <font color="darkred">**QUIT**</font>
UNIX> 
</pre>

I have an executable **avltree_test_help** that prints out when it detects imbalances, and when it performs rotations. Here is the same set of commands as above:

<pre>UNIX> <font color="darkred">**avltree_test_help 'AVL>'**</font>
AVL> <font color="darkred">**INSERT Fred 0 0**</font>
AVL> <font color="darkred">**INSERT Luther 1 1**</font>
AVL> <font color="darkred">**PRINT** </font>
  0 Luther
1 Fred
AVL> <font color="darkred">**INSERT Xavier 2 2**</font>
Zig-zig imbalance rooted by Fred
Rotate about Luther
AVL> <font color="darkred">**PRINT**</font>
  0 Xavier
1 Luther
  0 Fred
AVL> <font color="darkred">**INSERT Binky 3 3**</font>
AVL> <font color="darkred">**INSERT Daisy 4 4**</font>
Zig-zag imbalance rooted by Fred
Rotate about Daisy
Rotate about Daisy
AVL> <font color="darkred">**PRINT**</font>
  0 Xavier
2 Luther
    0 Fred
  1 Daisy
    0 Binky
AVL> <font color="darkred">**DELETE Xavier**</font>
Zig-zig imbalance rooted by Luther
Rotate about Daisy
AVL> <font color="darkred">**PRINT**</font>
  1 Luther
    0 Fred
2 Daisy
  0 Binky
AVL> <font color="darkred">**QUIT**</font>
UNIX>
</pre>