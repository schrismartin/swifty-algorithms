# CS140 -- Lab 3

*   CS140 -- Data Structures
*   Spring, 2014
*   [James S. Plank](http://www.cs.utk.edu/~plank)
*   [**http://www.cs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3**](http://www.cs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3)
*   Lab Directory: **/home/plank/cs140/Labs/Lab3**

* * *

Back to PGM files.

To do this lab, you are to copy the program **[pgm_editor.cpp](pgm_editor.cpp)** from **/home/plank/cs140/Labs/Lab3**. You'll note that there is a comment that says "DO NOT CHANGE ANYTHING BELOW THIS LINE". I feel that this comment is pretty self-explanatory. The gradescript will check to see if you have changed anything below the line, and if you do, it will flag it as an error. What you do is write code where it says "Write your code here". You compile this program and run it, and that is what you submit for grading.

Here is **[pgm_editor.cpp](pgm_editor.cpp)**:

<pre>#include <cstdio>
#include <cstdlib>
#include <string>
#include <sstream>
#include <vector>
#include <iostream>
using namespace std;

typedef vector <int> IVec;

// Write your code here:

// DO NOT CHANGE ANYTHING BELOW THIS LINE

void bad_pgm(string s)
{
  cerr << "Bad PGM file: " << s << endl;
  exit(1);

}

....
</pre>

Your job is to write seven procedures. You can figure out their parameter types from how they are called within **pgm_editor.cpp**. They all revolve around PGM files, which are held in a vector of vectors of ints. Suppose that we have a PGM file **p**, declared as:


<pre>vector <IVec> p;
</pre>

Then **p.size()** is the number of rows of the PGM file. Each element **p[i]** will be a vector of the same size. **p[i].size()** is the number of columns in the PGM file. And **p[i][j]** contains the pixel value in row _i_ column _j_. In the procedures that you write, you may assume that you get a valid PGM file as input. You do not have to error check.

The seven procedures are:

1.  **pgm_write(p)**: This writes a PGM file **p** to standard output. I want the output to be in a very specific format:
    *   The first line is "P2"
    *   The second line is the number of columns followed by a space and the number of rows. There should be no special formatting to the second line.
    *   The third line is the word "255".
    *   The remaining lines have the pixels, 20 per line, each pixel printed with **printf("%4d")** and no extra spaces. Obviously, the last line may be incomplete.
2.  **pgm_create(r, c, pv)**. This creates and returns a PGM file which has _r_ rows, _c_ columns, and all pixels have the value _pv_.
3.  **pgm_cw(p)**. This rotates **p** 90 degrees clockwise. Obviously, **p** must be a reference parameter.
4.  **pgm_ccw(p)**. This rotates **p** 90 degrees counterclockwise. Obviously, **p** must be a reference parameter.
5.  **pgm_pad(p, w, pv)**. This adds _w_ pixels around the border of **p**. All the pixels will have the value **pv**.
6.  **pgm_panel(p, r, c)**. This changes **p** so that it has **r*c** copies of the PGM file, laid out in a _r * c_ grid. See the examples.
7.  **pgm_crop(p, r, c, rows, cols)**. This changes **p** so that it has a subset of the original picture -- the rectangle starting at row _r_ and column _c_, with _rows_ rows and _cols_ cols.

When **pgm_editor** is compiled and running correctly, you can use it either to create a PGM file, or to edit the PGM file on standard input and print the result on standard output. For example:

<pre>UNIX> <font color="darkred">**pgm_editor**</font>
usage: pgm_editor command....

        CREATE rows cols pixvalue
        CW
        CCW
        PAD pixels pixvalue
        PANEL r c
        CROP r c rows cols
UNIX> 
</pre>

* * *

<pre>UNIX> <font color="darkred">**pgm_editor CREATE 50 200 0 | convert - example_create.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_create.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor CW < Red.pgm | convert - example_cw.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_cw.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor CCW < Red.pgm | convert - example_ccw.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_ccw.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor PAD 30 0 < Rodney.pgm | convert - example_pad_1.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_pad_1.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor PAD 30 0 < Rodney.pgm | pgm_editor PAD 30 255 | pgm_editor PAD 1 0 | convert - example_pad_2.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_pad_2.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor PANEL 2 4 < Red.pgm | convert - example_panel_1.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_panel_1.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor PAD 6 0 < Rodney.pgm | pgm_editor PAD 3 255 | pgm_editor PANEL 3 5 | convert - example_panel_2.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_panel_2.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor CROP 45 60 50 100 < Red.pgm | convert - example_crop.jpg**</font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_crop.jpg)

* * *

<pre>UNIX> <font color="darkred">**pgm_editor CROP 45 60 50 100 < Red.pgm | pgm_editor PAD 2 0 | pgm_editor PAD 1 255 | pgm_editor PANEL 4 9 | convert - example_crop_panel.jpg** </font></pre>

![](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Labs/Lab3/example_crop_panel.jpg)

* * *

### Grading and Starting

Once again, you cannot modify the part of the program that says "**DO NOT CHANGE ANYTHING BELOW THIS LINE.**". If so, the gradescript will yell at you and won't get it correct.

To start this lab -- _**and do this during lab**_, write dummy versions of these procedures that don't work, but that compile. That way you at least have the procedure declarations correct. Then work on **pgm_create()** and **pgm_write()**. Then the others. Think about when you should be using reference parameters.