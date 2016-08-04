## CS140 Lab 7 - Code Processing

*   [Jim Plank](http://www.cs.utk.edu/~plank)
*   Directory: **~plank/cs140/Labs/Lab7**
*   Last modification date: _Mon Mar 12 15:49:09 EDT 2012_

* * *

You and your friends Rad and Banjolina decide to go into business providing web and cell phone support for reward programs like **[mycokerewards.com](http://mycokerewards.com)**. Users can set up accounts with you that will maintain _points_. Users can accumulate points by collecting codes from various products (such as bottlecaps and 12-packs, as in **[mycokerewards.com](http://mycokerewards.com)**), and then they can spend the points on various prizes.

Users can enter codes via a web site, or they can register one or more cell phones with their account, and then they can text codes to a given phone number, which will register the points.

Rad is handling the business and marketing end of this endeavor, and Banjolina is doing all of the web programming. Your job is to write the server that maintains information about users, prizes and codes, and talks with Banjolina's web front-end. Since you haven't taken CS360 yet, your server won't do any real networking. Instead, it will communicate via files and standard input.

As with many of our labs, I give you a header file that defines a class, and you have to implement the methods. I have a driver program that you compile with your code, and that will be the final product.

Here's the header, in **[code_processor.h](code_processor.h)**:

<pre>#include <set>
#include <deque>
#include <map>
#include <vector>
#include <iostream>
#include <cstdlib>
#include <fstream>
using namespace std;

class User {
  public:
     string username;
     string realname;
     int points;
     set <string> phone_numbers;
};

class Prize {
  public:
     string id;
     string description;
     int points;
     int quantity;
};

class Code_Processor {
  public:
    int New_Prize(string id, string description, int points, int quantity);
    int New_User(string username, string realname, int starting_points);
    int Delete_User(string username);

    int Add_Phone(string username, string phone);
    int Remove_Phone(string username, string phone);
    string Show_Phones(string username);

    int Enter_Code(string username, string code);
    int Text_Code(string phone, string code);
    int Mark_Code_Used(string code);

    int Balance(string username);
    int Redeem_Prize(string username, string prize);

    ~Code_Processor();
    int Write(const char *file);

    void Double_Check_Internals();   /* You don't write this */

  protected:
    map <string, User *> Names;
    map <string, User *> Phones;
    set <string> Codes;
    map <string, Prize *> Prizes;
};
</pre>


While this looks like a mouthful, it's not too bad. **Users** store the following data:

*   A **username**, which is a one-word name.
*   A **realname**, which is the users's full name. For example, my username might be **"jimplank"** and my real name **"Jim Plank"**.
*   The total number of points that the user has.
*   A set containing the phone numbers registered to the user. Phone numbers are stored simply as strings.

**Prizes** store the following data:

*   An **id**. This is a unique string for each prize.
*   A **description**. This is a longer description of each prize.
*   The number of **points** that it takes to get one prize.
*   The **quantity** of prizes.

A **Code_Processor** keeps track of Users, Codes and Prizes. Users are stored in the map **Names**, which is keyed on their usernames. Phone numbers are stored in the map **Phones**, which is keyed on the phone numbers, and whose **second** field points to the user that has registered the cell phone.

There is a set **Codes**, which stores the codes that have been entered by all users. This set exists so that users can't enter a code more than once. Finally, there is a map **Prizes**, keyed on the id of each prize.

You'll note that both **Names** and **Phones** point to users. In other words, each user has just one **User** instance, and that is pointed to both in **Names** and in **Phones**. If the user has multiple phones, then there will be multiple entries in **Phones** that point to that user. Moreover, there are two data structures that hold phones -- **Phones**, which is keyed on the phone number, and the set **phone_numbers** which is part of the User's data.

Now, you are to write the following methods:

*   **New_Prize(string id, string description, int points, int quantity)**: This creates a new prize and puts it into **Prizes**. You should return zero if all is ok. You should return -1 from the following errors without creating anything new:
    *   There is already a prize with the given **id** in prizes.
    *   **Points** is less than or equal to zero.
    *   **Quantity** is less than or equal to zero.
*   **New_User(string username, string realname, int starting_points)**: This creates a new user with the given information, and puts it into **Names**. The user will start with no registered phone numbers. You should return zero if all is ok. You should return -1 from the following errors without creating anything new:
    *   There is already a user with that **username**.
    *   **Starting_points** is less than zero.
*   **Delete_User(string username)**: This should erase the user from **Names**, and it should erase all of the user's phone numbers from **Phones**. After that, it should call **delete** on the user's pointer. You should return zero if all is ok. You should return -1 if the **username** is not in **Names**.
*   **Add_Phone(string username, string phone)**: This should register the given phone string with the user. That means putting the phone on both the **Phones** map, and on the user's **phone_numbers** set. You should return zero if all is ok. You should return -1 from the following errors without creating anything new:
    *   There is no user with that **username**.
    *   The phone number is already registered, either with that user or with another.
*   **Remove_Phone(string username, string phone)**: This should remove the phone from the system -- both from **Phones** and from the user's **phone_numbers** set. You should return zero if all is ok. You should return -1 from the following errors without performing any system modifications:
    *   There is no user with that **username**.
    *   There is no phone string with that **phone**.
    *   The phone number is registered to a different user.
*   **Show_Phones(string username)**: This should return a string containing all of that user's phone numbers, in lexicographic order, each separated by a newline. There should be a newline at the end of the string too. If the user doesn't exist, return the string **"BAD USER"**. If the user has no phones, simply return an empty string.
*   **Enter_Code(string username, string code)**: This is called when a user enters a code. You need to first check the **Codes** set to see if the code has been entered before. If it has, or if the user doesn't exist, return -1\. Otherwise, you need to check to see if the code is valid: A valid code's **djbhash()** must either be divisible by 17 or 13\. If divisible by 17, then it is worth ten points. Otherwise, if it is divisible by 13, then it is worth three points. If the code is valid, then add it to **Codes**, increment the user's account and return the number of points added. If the code is not valid, simply return zero.
*   **Text_Code(string phone, string code)**: This should work just like **Enter_Code()**, except the user's account is identified by the phone number. If the phone number doesn't exist, return -1. Otherwise, this should work just like **Enter_Code()**.
*   **Mark_Code_Used(string code)**: This is called to mark a code as used, even though no user is entering it. This is used to help rebuild the server from a saved state (see **Write()** below). If the code is not valid or it is already in **Codes**, return -1\. Otherwise, add it to **Codes** and return 0.
*   **Balance(string username)**: This should return the user's points. If the user doesn't exist, return -1.
*   **Redeem_Prize(string username, string prize)**: This is called when a user wants to redeem a prize. The prize is identified by its **id**. If the user or prize don't exist, or if the user doesn't have enough points, return -1\. Otherwise, decrement the points from the user's account, and decrement the prize's quantity by one. If the prize's quantity is zero, remove the prize from the system (which should involve a **delete** call).
*   **~Code_Processor()**: Since **new** is called to create users and prizes, you need to write a destructor that calls **delete** on all the users and prizes. The destructor doesn't have to clear the maps or sets -- that will be done automatically for you when the **Code_Processor** goes away. If you don't understand this point, please ask about it in class.
*   I'll describe **Write()** later.
*   You don't write **Double_Check_Internals()**. I have written it, and it is in **[double_checker.cpp](double_checker.cpp)**, which you must include when you compile your program. My **makefile** does this for you. The intent of **Double_Check_Internals()** is to make sure that your treatment of phone numbers is consistent, and that you have closed any open files.

* * *

## cp_tester.cpp

The program **[cp_tester.cpp](cp_tester.cpp)** is a front end for **[code_processor.cpp](code_processor.cpp)**. You call it with filenames on the command line argument, and it reads files that have commands to execute on a **Code_Processor**. If a filename is "_-_", it reads the commands from standard input. The commands are specified on separate lines -- blank lines are ok, and lines that begin with a pound sign are ignored. Lines may not have more than 20 words on them.

Otherwise, the following commands are supported:

*   "_**PRIZE** id points quantity description_": Calls **New_Prize()** with the given arguments. **Id** is a single word. **Description** may be multiple words.*   "_**ADD_USER** username starting_points realname_": Calls **New_User()** with the given arguments. **Username** must be one word. **Realname** can contain any number of words.*   "_**DELETE_USER** username_": Calls **Delete_User** with the given username.*   "_**ADD_PHONE** username phone-number_": Makes the appropriate **Add_Phone()** call. Both **username** and **phone-number** must be one word.*   "_**REMOVE_PHONE** username phone-number_": Makes the appropriate **Remove_Phone()** call.*   "_**SHOW_PHONES** username_": Makes the appropriate **Show_Phones()** call.*   "_**ENTER_CODE** username code_": Makes the appropriate **Enter_Code()** call. The code should be one word.*   "_**TEXT_CODE** phone code_": Makes the appropriate **Text_Code()** call.*   "_**MARK_USED** code ..._": You can specify up to 19 codes on a line. It will call **Mark_Code_Used()** on each of these codes.*   "_**BALANCE** username_": calls **Balance()** and prints the output.*   "_**REDEEM** username prize_": calls **Redeem()**.*   "_**DOUBLE_CHECK**_": calls **Double_Check_Internals()**.*   "_**WRITE** filename_": calls **Write()** on the given filename. Explanation below.*   "_**QUIT**_": stops reading. You can simply end input too, and that will stop reading.

    * * *

    ### Write()

    The **Write()** method is very important. Whenever you write a server like this one, you should make it _fault-tolerant_. In other words, you should make it so that it can save its state so that you can terminate the server and start it up again later. The **Write()** method should save the **Code_Processor**'s state to the given file and return 0. It should return -1 if it can't open/create the file.

    The format of **Write()** should be as a file that **cp_tester** can use as input to recreate the state of the **Code_Processor**. It should only consist of **ADD_USER**, **PRIZE**, **ADD_PHONE** and **MARK_USED** lines, and when **cp_tester** is run with the file as input, it should recreate the state of the **Code_Processor**.

    I don't care about the order or format of the lines, as long as they create the proper **Code_Processor** when they are fed to **cp_tester**. My grading program will test your files by using them as input to my **cp_tester** and looking at the output of my **Write()** call.

    * * *

    ### Some examples

    Let's start with a very simple example:

    <pre>UNIX> <font color="darkred">**cp_tester -**</font>
    CP_Tester> <font color="darkred">**ADD_USER tigerwoods 0 Tiger Woods**</font>
    ADD_USER successful
    CP_Tester> <font color="darkred">**ADD_USER the-donald 100 Donald Trump**</font>
    ADD_USER successful
    CP_Tester> <font color="darkred">**PRIZE mp3 40 5000 Free MP3 download from Bapster**</font>
    PRIZE successful
    CP_Tester> <font color="darkred">**PRIZE cancun 10000 1 All expense-paid vacation to Cancun**</font>
    PRIZE successful
    CP_Tester> <font color="darkred">**WRITE cp1.txt**</font>
    WRITE successful
    CP_Tester> <font color="darkred">**QUIT**</font>
    UNIX> <font color="darkred">**cat cp1.txt**</font>
    PRIZE     cancun     10000      1 All expense-paid vacation to Cancun
    PRIZE     mp3           40   5000 Free MP3 download from Bapster
    ADD_USER  the-donald   100 Donald Trump
    ADD_USER  tigerwoods     0 Tiger Woods
    UNIX> 
    </pre>

    I've added two prizes and two users, and then written the server's state to **[cp1.txt](cp1.txt)**. You'll note that the order of **[cp1.txt](cp1.txt)** is different from my input. That's fine -- if you use it as input to **cp_tester**, it will create the same server state. For example:

    <pre>UNIX> <font color="darkred">**cp_tester cp1.txt -**</font>
    CP_Tester> <font color="darkred">**BALANCE tigerwoods**</font>
    0 Points
    CP_Tester> <font color="darkred">**BALANCE the-donald**</font>
    100 Points
    CP_Tester> <font color="darkred">**WRITE cp2.txt**</font>
    WRITE successful
    CP_Tester> <font color="darkred">**QUIT**</font>
    UNIX> <font color="darkred">**cat cp2.txt**</font>
    PRIZE     cancun     10000      1 All expense-paid vacation to Cancun
    PRIZE     mp3           40   5000 Free MP3 download from Bapster
    ADD_USER  the-donald   100 Donald Trump
    ADD_USER  tigerwoods     0 Tiger Woods
    UNIX> 
    </pre>

    When I called **cp_tester**, I gave it two command line arguments: **cp1.txt** and **-**. So, it first read commands from **cp1.txt**, which recreated the same state as when I created **cp1.txt**, and then it read from standard input. When I entered **WRITE cp2.txt**, it created **cp2.txt**, which is identical to **cp1.txt**, since they have the same state.

    Suppose I call **cp_tester** with **cp1.txt** and **cp2.txt** on the command line. I should expect four error messages, since the users and prizes already exist when it tries to process **cp2.txt**:

    <pre>UNIX> <font color="darkred">**cp_tester cp1.txt cp2.txt**</font>
    Prize cancun couldn't be added
    Prize mp3 couldn't be added
    ADD_USER the-donald unsuccessful
    ADD_USER tigerwoods unsuccessful
    UNIX> 
    </pre>

    This is because **cp_tester** checks the return values of the **New_Prize()** and **New_User()** calls.

    Let's add a few phone numbers and enter some codes. If you check the hashes using **djbhash.cpp** from [the hashing lecture notes](http://web.eecs.utk.edu/~plank/plank/classes/cs140/Notes/Hashing/index.html), you'll see that they are each divisible by 13 and not by 17, so they are each worth three points:

    <pre>UNIX> <font color="darkred">**/home/plank/cs140/Notes/Hashing/djbhash | awk '{ print $1%17, $1%13 }'**</font>
    <font color="darkred">**Df18ly81CO1mo4**</font>
    11 0
    <font color="darkred">**IDWNZJ20ENkAxP**</font>
    2 0
    <font color="darkred">**h0yuKnVD6DvRUu**</font>
    11 0
    UNIX> <font color="darkred">**cp_tester cp1.txt -**</font>
    CP_Tester> <font color="darkred">**ADD_PHONE tigerwoods 865-974-4400** </font>
    ADD_PHONE successful
    CP_Tester> <font color="darkred">**ADD_PHONE tigerwoods 1-800-Big-Putt**</font>
    ADD_PHONE successful
    CP_Tester> <font color="darkred">**SHOW_PHONES tigerwoods**</font>
    1-800-Big-Putt
    865-974-4400
    CP_Tester> <font color="darkred">**ENTER_CODE tigerwoods Df18ly81CO1mo4**</font>
    ENTER_CODE: Added 3 points to tigerwoods.
    CP_Tester> <font color="darkred">**TEXT_CODE 865-974-4400 IDWNZJ20ENkAxP**</font>
    TEXT_CODE: Added 3 points.
    CP_Tester> <font color="darkred">**TEXT_CODE 1-800-Big-Putt h0yuKnVD6DvRUu**</font>
    TEXT_CODE: Added 3 points.
    CP_Tester> <font color="darkred">**BALANCE tigerwoods**</font>
    9 Points
    CP_Tester> <font color="darkred">**WRITE cp3.txt**</font>
    WRITE successful
    CP_Tester> <font color="darkred">**QUIT**</font>
    UNIX> 
    </pre>

    Each **ENTER_CODE** and **TEXT_CODE** call adds three points to **tigerwoods**' account, giving him 9 points in all. After the **WRITE** call, **[cp3.txt](cp3.txt)** looks as follows:

    <pre>PRIZE     cancun     10000      1 All expense-paid vacation to Cancun
    PRIZE     mp3           40   5000 Free MP3 download from Bapster
    ADD_USER  the-donald   100 Donald Trump
    ADD_USER  tigerwoods     9 Tiger Woods
    ADD_PHONE tigerwoods 1-800-Big-Putt
    ADD_PHONE tigerwoods 865-974-4400
    MARK_USED Df18ly81CO1mo4 IDWNZJ20ENkAxP h0yuKnVD6DvRUu
    </pre>

    The phones have been registered to **tigerwoods**, his point total has been updated, and the codes have been marked as used. Although I put multiple codes on a **MARK_USED** line, you don't have to. Just remember the 20-word limit on a line.

    And again, your output does not have to match mine -- it simply needs to create the same **Code_Processor**.

    Let's take a look at an example where some prizes are redeemed:

    <pre>UNIX> <font color="darkred">**cp_tester cp3.txt -**</font>
    CP_Tester> <font color="darkred">**ADD_USER billgates 500000 Bill Gates**</font>
    ADD_USER successful
    CP_Tester> <font color="darkred">**REDEEM tigerwoods mp3**</font>
    REDEEM:       either the user doesn't exist,
                  or the prize doesn't exist,
                  or the user can't afford the prize.
    CP_Tester> <font color="darkred">**REDEEM the-donald mp3**</font>
    REDEEM successful
    CP_Tester> <font color="darkred">**REDEEM billgates cancun**</font>
    REDEEM successful
    CP_Tester> <font color="darkred">**WRITE cp4.txt**</font>
    WRITE successful
    CP_Tester> <font color="darkred">**QUIT**</font>
    UNIX> <font color="darkred">**cat cp4.txt**</font>
    PRIZE     mp3           40   4999 Free MP3 download from Bapster
    ADD_USER  billgates  490000 Bill Gates
    ADD_USER  the-donald    60 Donald Trump
    ADD_USER  tigerwoods     9 Tiger Woods
    ADD_PHONE tigerwoods 1-800-Big-Putt
    ADD_PHONE tigerwoods 865-974-4400
    MARK_USED Df18ly81CO1mo4 IDWNZJ20ENkAxP h0yuKnVD6DvRUu
    UNIX> 
    </pre>

    Since **tigerwoods** only has 9 points, he can't even afford an MP3 from Bapster. **the-donald** has no such problem, and **billgates** can easily afford the Cancun vacation (like he needs it). The updated points for the users and the updated quantities for the prizes have been reflected in the file. Since the quantity of **cancun** went to zero, it has been removed from the system.

    * * *

    ### The Gradescript

    Obviously, the gradescript is going to use **cp_tester** to test your **code_processor.cpp**. The output of **cp_tester** must match mine, and any files created by **WRITE** must create the same **Code_Processor** as mine. I will test this by using your file as input to my **cp_tester**, calling **WRITE**, and then checking the output file against mine verbatim. I'm doing this to be nice to you, since I'm not making exact formatting matter.

    * * *

    ### random_codes.cpp

    The program **[random_codes.cpp](random_codes.cpp)** generates random, valid codes.

    * * *

    ### Strategy

    Your strategy here should be to first create a **code_processor.cpp** that implements dummy methods for each method. That way you can compile the program and create a **cp_tester**. It won't work (except for **QUIT**), but now you can start programming incrementally.

    The first thing you should do is implement **New_Prize()**, and then implement the part of the **Write()** method that creates the file and stores the prizes. Test this by only making **PRIZE** and **WRITE** calls in **cp_tester**.

    Then move onto the others. I implemented these in the following order:

    *   **New_Prize()** and associated **Write()**.
    *   **Add_User()**, **Balance()** and associated **Write()**.
    *   **Add_Phone()**, and associated **Write()**.
    *   **Remove_Phone()** and **Show_Phones()**. With these, I made sure that **Double_Check_Internals()** works, since this is one of those places where it may not work.
    *   **Redeem_Prize()**.
    *   **Delete_User()**. Again, I made sure that **Double_Check_Internals()** works here.
    *   **Enter_Code()** and associated **Write()**.
    *   **Text_Code()**.
    *   **Mark_Code_Used()**.
    *   The destructor.Although this is a large lab writeup, each of these methods is relatively small. While the grading will of course include the gradescript, the TA's will double-check your destructor by hand.