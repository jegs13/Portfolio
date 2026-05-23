This lab was proposed by the Cisco Networking Academy through the Linux Essentials course.



The instructions are the following:



Case Scenario

In the User Management challenge lab, you were tasked with creating users and groups. Using the commands one at a time from the command line can be a tedious process and could lead to potential errors in syntax. It is your duty, as an administrator, to make the process as seamless and efficient as possible.



Objectives

Create a bash script to perform user management tasks as outlined below:



* Create a new group. Each group must have a unique name. The script must check to ensure that no duplicate group names exist on the system. If a duplicate is found, an error needs to be reported, and the administrator must try another group name.
* Create a new user. Each user must have a unique name. The script must check to ensure that no duplicate usernames exist on the system. If a duplicate is found, an error needs to be reported and the administrator must try another username. The user will have a Bash login shell and belong to the group that was created in the previous step.
* Create a password for each user that is created.
* Ensure that the new user created is a member of the new group created.
* Create a directory at the root / of the file system with same name as the user created.
* Set the ownership of the directory to the user and group created.
* Set the permissions of the directory to full control for the owner and full control for the group created.
* Set the permissions to ensure that only the owner of a file can delete it from the directory.
* Ensure that the script is executable.
* This script should be designed to accept any username and any group name. DO NOT hardcode commands to create specific usernames and group names.



\## Step-by-Step Process



It is important to note that this script must be run with sudo because many of the commands included would need root privileges.



\### 1. Group Creation



The script first requests a group name from the user.



To prevent errors, I added validation to verify whether the group already exists before attempting to create it.



Commands used:

```bash

getent group

groupadd

```



I also used a `while` loop to repeatedly request input until the user provides a valid group name.



I used `if` conditionals together with test brackets `[]` to test if the group already exists, the script asks the user to enter a different name.



If the group already exists, the script asks the user to enter a different name.



\---



\### 2. Username Validation



The script then requests a username.



Before creating the user, the script checks whether the username already exists in the system.



Commands used:

```bash

id

useradd

```



This prevents duplicate users from being created.



Once again, I used ```while```, ```if``` and `[]` in order to check if the user is entering an acceptable name and give them another chance in case they do not. 



\---



\### 3. Password Validation



I implemented password validation rules to improve security and input quality.



The password requirements are:

\- Minimum length

\- At least one uppercase letter

\- At least one lowercase letter

\- At least one number

\- At least one symbol (@#%/+)



In this case, it was important to include the ! symbol to reverse the meaning of the conditional because I needed to verify that certain conditions were NOT met; then, using ```echo``` and a pipe to ```chpasswd``` would define the password for the new user.



If the password does not meet the requirements, the script displays an error message and asks the user to try again.



\---



\### 4. User Creation and Group Assignment



The script tries validating if the new user is part of the group that was created in the first step by checking with ```grep``` if the command ```groups``` outputs the name of the group as a result, otherwise, the user will receive a message saying that the addition was not successful.



Commands used:

```bash

groups

grep

if

```



\---



\### 5. Directory creation



At this step, I used the command ```mkdir``` with the variable $newuser to create the directory with the name of the new user. If for any reason, it was not possible, the user will receive a message informing about this.


### 6. Setting the ownership of the directory



For this, I used `chown` together with the user and group variables to assign ownership of the directory.



\### 7. Setting the permissions for giving the user and group full control as well as avoiding archive deletion.



Since the exercise requires preventing unauthorized file deletion, I enable the Sticky bit permission by adding 1000 to the formula of ```chmod```. Then, as it also requires giving full permission to the user and group owner while restricting permissions for other users, I added 770, which finally sets the argument of ```chmod``` as 1770 for the permissions of the directory created.

