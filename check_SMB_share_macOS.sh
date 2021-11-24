#!/bin/bash

# Function mount SMB share
function mountSHARE {
echo ""
echo "Unmount SMB share..."
/sbin/umount /Users/admin/Desktop/mnt1
echo ""
echo "Try to mount SMB share..."
sleep 3
/sbin/mount -t smbfs //viewer:viewer@192.168.44.5/share_settings /Users/admin/Desktop/mnt1
if [ $? -eq 0 ]; then
  echo "SMB share succesfully mounted!"
else
  echo "Error mounting SMB share!"
  exit 0
fi

}


# Function test READ from SMB share
function testREAD {
echo "Start checking READ access..."
cat /Users/admin/Desktop/mnt1/do_not_delete & pid=$!;
{ sleep 3; kill "$pid"; }
if [ $? -ne 0 ]; then
  contentShare=$(cat /Users/admin/Desktop/mnt1/do_not_delete)
    if [ "$contentShare" = QAZ123wsx456EDC ]; then
      echo "READ from SMB share OK!"
      echo ""
      echo "OK" > /tmp/SMB_share_test_result.log
    else
      echo "READ from SMB share FAILED!"
      echo "FAIL" > /tmp/SMB_share_test_result.log
    fi
else
  echo "READ from SMB share FAILED!"
  echo "FAIL" > /tmp/SMB_share_test_result.log
fi

}


# SMB share already mounted check
isMounted=`/sbin/mount | grep 192.168.44.5/share_settings`

if [ -n "$isMounted" ]; then
  echo ""
  echo "SMB share probably already mounted..."
  echo ""
  testREAD
elif [ -z "$isMounted" ]; then
  mountSHARE
  echo ""
  testREAD
fi
