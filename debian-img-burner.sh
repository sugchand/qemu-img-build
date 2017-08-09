# Image burner program to generate debian images for qemu-kvm

#!/bin/bash -x

SRC_DIR=$PWD
. $SRC_DIR/config.sh

##############################################################################
DISK_MNT=/mnt/qemu-disk
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTPS_PROXY
export ftp_proxy=$FTP_PROXY
##############################################################################

function install_prereq {
    apt-get install -y debootstrap qemu-system qemu-kvm qemu-utils gdisk
}

# Clean up function to clear out system state.
function cleanup() {
    umount /dev/nbd0p2
    rm -rf $DISK_MNT
    qemu-nbd -d /dev/nbd0
    rm -rf $QEMU_IMG_NAME
}

# Pass the error code, exit-state and error string to the function.
# $1 : return error code.
# $2 : exit state, exit the program if error is critical.
# #3 : error string to print.
# 
function exit_on_error() {
    ret_code=$1
    is_exit=$2
    err_str=$3
    if [ $ret_code -ne 0 ]; then
        echo "** $err_str **"
    fi
    if [ $ret_code -ne 0 ] && [ $is_exit -ne 0 ]; then
        echo "** EXITING THE PROGRAM ERR: $ret_code **"
        exit $ret_code
    fi
}

function fdisk_part {
fdisk /dev/nbd0 << EEOF
I
$gpt

p
w

EEOF
}

# function to attach the image to nbd and format it.
function nbd_attach_format_install {
    modprobe nbd max_part=32
    qemu-nbd -c /dev/nbd0 $QEMU_IMG_NAME
    exit_on_error $? 1 "ERR: Failed to init nbd, cannot create image"
    fdisk_part
    exit_on_error $? 1 "ERR: Failed to do partition"
    mkswap /dev/nbd0p1
    exit_on_error $? 1 "ERR: Failed to create swap partition"
    mkfs.ext3 /dev/nbd0p2
    exit_on_error $? 1 "ERR: Failed to format partition"
    mkdir -p $DISK_MNT
    mount /dev/nbd0p2 $DISK_MNT
    exit_on_error $? 1 "ERR: Failed to mount disk,"
    debootstrap --include=$DEFAULT_IMG_APPS,$IMG_APPS $IMG_SUITE $DISK_MNT \
    $IMG_MIRROR_URL
}

function create_qcow_disk {
    # XXX :: validate the input before using the file name.
    case $QCOW_SIZE in
        10)
        QCOW_SIZE='10G'
        gpt='10G-ubuntu-gpt-disk'
        ;;
        15)
        QCOW_SIZE='15G'
        gpt='15G-ubuntu-gpt-disk'
        ;;
        20)
        QCOW_SIZE='20G'
        gpt='20G-ubuntu-gpt-disk'
        ;;
        *)
        QCOW_SIZE=10G
        gpt='10G-ubuntu-gpt-disk'
        ;;
    esac
    echo "Creating the disk of size $QCOW_SIZE and diskfile $gpt"
    qemu-img create -f qcow2 $QEMU_IMG_NAME $QCOW_SIZE
    exit_on_error $? 1 "ERR:Failed to create qemu-img"

}

function main {
    install_prereq
    cleanup
    create_qcow_disk
    nbd_attach_format_install
}

main
