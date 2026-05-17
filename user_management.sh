#!/bin/bash

# Create a name for the new group.

echo "Please, insert a name for the new group."

while true; do 

read groupname 

if [ -z "$groupname" ]; then 
echo "Group name cannot be empty." 

elif getent group "$groupname" > /dev/null; then 
echo "Error: Group already exists. Please, use another name." 

elif groupadd "$groupname"; then 
echo "Group created correctly." 
break 
else echo "Failed to create group." 
fi 
done

# Create a name for the new user.

echo "Please, insert a name for the new user."                                  
                                                                                
while true; do                                                                  
read newuser                                                                    
                                                                                
if [ -z "$newuser" ]; then                                                      
echo "Name cannot be empty."                                                    
                                                                                
elif getent passwd "$newuser" > /dev/null; then                                 
echo "User already exists."                                                     
                                                                                
elif useradd -s /bin/bash -g "$groupname" "$newuser"; then                      
echo "User created correctly."                           
break                                                                           
else                                                                            
echo "Failed to create user."                                                   
fi                                                                              
done                           

# Create a password for each new user that is created.

echo "Now please, create a password for the user. It must include at least one uppercase letter, one lowercase letter, one number and one symbol (@#%/+)."

while true; do
read -s password

if [ -z "$password" ]; then
echo "Password cannot be empty" 

elif ! [[ $password =~ [0-9] ]]; then
echo "The password must contain a number."

elif ! [[ $password =~ [A-Z] ]]; then
echo "The password must contain an uppercase letter."

elif ! [[ $password =~ [a-z] ]]; then
echo "The password must contain a lowercase letter."

elif ! [[ $password =~ [@#%/+] ]]; then
echo "The password must contain a symbol (@#%/+)."

elif ! [[ $password =~ ^.{8,}$ ]]; then
echo "The password must be at least 8 characters long."

else
echo "$newuser:$password" | chpasswd 
echo "Password created successfully"
break
fi
done

# Ensure that the new user created is part of the new group created.

if groups $newuser | grep $groupname ; then
echo "The new user is part of the group created."
else
echo "The new user is not part of the new group."
fi

# Create a directory at the root / of the file system with same name as the user created.

if mkdir /$newuser; then
echo /$newuser directory created successfully.
else
echo /$newuser directory could not be created.
fi

# Set the ownership of the directory to the user and group created.

chown $newuser:$groupname /$newuser

# Set the permissions of the directory to full control for the owner and full control for the group created

chmod 1770 /$newuser

