read -p "Enter the Device name::" DEV_INPUT
read -p "Enter the Mount Point::" MOUNT_POINT
DEVICE="/dev/$DEV_INPUT"

echo "Checking if $DEVICE is available"

if [ -b "$DEVICE" ]; then
        echo "Formatting $DEVICE with XFS"
        sudo mkfs -t xfs -f "$DEVICE"
sleep 3
        echo "Creating Mount Point at $MOUNT_POINT......"
        sudo mkdir -p "$MOUNT_POINT"
sleep 3
        echo  "configuring /etc/fstb for reboot persistence......"
        UUID=$(sudo blkid -s UUID -o value "$DEVICE")
sleep 2
        echo "UUID=$UUID  $MOUNT_POINT  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab
sleep 3
        echo "Mounting Volume......"
        sudo mount -a
sleep 2
        echo "SUCCESS: disk is ready and reboot-proof."
else
        echo "ERROR: Device $DEVICE not found. Check AWS attachment"
        exit 1
fi

