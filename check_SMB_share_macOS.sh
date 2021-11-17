#!/bin/bash

# Function mount SMB share
function mountSHARE {
echo ""
echo "Unmount SMB share..."
umount /Users/admin/Desktop/mnt1
echo ""
echo "Try to mount SMB share..."
sleep 3
mount -t smbfs //viewer:viewer@192.168.45.104/share /Users/admin/Desktop/mnt1
if [ $? -eq 0 ]; then
  echo "SMB share succesfully mounted!"
else
  echo "Error mounting SMB share!"
fi
}


# Function test READ from SMB share
function testREAD {
echo "Start checking READ access..."
contentShare=$(cat /Users/admin/Desktop/mnt1/do_not_delete)
echo "$contentShare"
if [ "$contentShare" = 123 ]; then
  echo "READ from SMB share OK!"
  echo ""
  echo "OK" > ./test_share_result.log
else
  echo "READ from SMB share FAILED!"
  echo "FAIL" > ./test_share_result.log
fi
}


# SMB share already mounted check
isMounted=`mount | grep 192.168.45.104/share`

if [ -n "$isMounted" ]; then
  echo ""
  echo "SMB share already mounted"
  echo ""
  testREAD
elif [ -z "$isMounted" ]; then
  mountSHARE
  echo ""
  testREAD
fi
