#! /bin/bash
#################################################################################################################################################################

#author Firoj Khan ,Mithilesh kumar
#@since 2020-06-10
  
#send.sh is a simple, easy and fast service for file sharing from the command-line. 
#It allows you to upload data and files to the local host server and you can further download it from Server and save this file to desired directory.
#After that we generated an Http link for the file so that we can download the file through wget on the command line.
  
###################################################################################################################################################################

# Issue the SFTP command.Also, We started  a heredocs block to start feeding the SFTP program your command block.
read -p "Enter the  location properties file: " FILE_NAME
#Connecting to the local host server 
#Fetching the value of HOST_IP from Properties file.
key="HOST_IP"

# Variable to hold the Property Value
prop_value=""

getProperty()
{
        prop_key=$1
        prop_value=`cat ${FILE_NAME} | grep ${prop_key} | cut -d'=' -f2`
}

getProperty ${key}
#echo "Key = ${key} ; Value = " ${prop_value}
var1=${prop_value}
echo $var1
HOST=$var1

# Key in Property File
#Fetching the value of Upload_Address from Properties file.
key="Upload_Address"
# Variable to hold the Property Value
prop_value=""

getProperty()
{
        prop_key=$1
        prop_value=`cat ${FILE_NAME} | grep ${prop_key} | cut -d'=' -f2`
}

getProperty ${key}
#echo "Key = ${key} ; Value = " ${prop_value}
FILE=${prop_value}
echo $FILE

# Key in Property File
#Fetching the value of File_Path from Properties file.
key="File_Path"

# Variable to hold the Property Value
prop_value=""

getProperty()
{
        prop_key=$1
        prop_value=`cat ${FILE_NAME} | grep ${prop_key} | cut -d'=' -f2`
}

getProperty ${key}
#echo "Key = ${key} ; Value = " ${prop_value}
var=${prop_value}
echo $var

#Fetching the file name from the file location.
directorytemp=$(echo $var | tr "/" "\n")
for addr in $directorytemp
do
        file_name=$addr
    done 
echo $file_name

echo "Enter your password "
sftp  $HOST <<EOF
cd $FILE
#uploading of a file to the server.
put $var
bye
EOF
slash="/"
temp1=$FILE$slash
concate=$temp1$file_name
echo $concate

# Key in Property File
key="Dir_Path"

# Variable to hold the Property Value
prop_value=""

getProperty()
{
        prop_key=$1
        prop_value=`cat ${FILE_NAME} | grep ${prop_key} | cut -d'=' -f2`
}

getProperty ${key}
#echo "Key = ${key} ; Value = " ${prop_value}
workDir=${prop_value}
echo $workDir

#workDir=" /sftp/firoj/workingDir"
echo "Successfully Uploading of a file to the localhost server"
echo "Enter sudo password of a system"
sudo cp -f $concate $workDir
#Issue the SFTP command.Also, We started  a heredocs block to start feeding the SFTP program your command block.
echo "Enter password again"

sftp  $HOST <<EOF
#lpwd is used to check the Local present working directory.
lpwd
#the file which are uploading to the server should be in home directory.
lcd $FILE
#get is a sftp command which is used to download a file.
#get $file_name
#Marking the end of the heredocs.
EOF

echo "Generation of the http link"
#Place your into file the /var/www/html directory (might need root privileges for this).
sudo cp -f $var /var/www/html
#changing the command line directory to html directory.
cd var
cd www 
cd html

#We generated http link and wget is used to to download file from that link.
linktemp="http://"
localLink="$(hostname -i)"
httpLink=$linktemp$localLink
echo "This is http link we can used to share anyone:"
echo $httpLink$slash$file_name
echo End of the file 




