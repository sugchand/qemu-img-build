#!/bin/bash 

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $SRC_DIR/config.sh

##############################################################################
export http_proxy=$HTTP_PROXY
export https_proxy=$HTTPS_PROXY
export ftp_proxy=$FTP_PROXY
QEMU_BIN=/home/sugeshch/repo/ovs_dpdk/qemu/x86_64-softmmu/qemu-system-x86_64
VNC_PORT=5
SSH_PORT=10022
##############################################################################
run_ok=false
if hash $QEMU_BIN 2>/dev/null; then
	run_ok=true
fi
if [ -e $QEMU_BIN ]; then
	run_ok=true
fi
if [ ! -e $QEMU_IMG_NAME ]; then
	run_ok=false
fi

if [ "$run_ok" = false ]; then
    echo "ERR: Qemu image/binary is missing."
    exit 1
fi

echo "**Login to VM with ssh 'sugesh@localhost -p $SSH_PORT'**"
echo "***************************************************************"
echo "**Login to VM with vnc vnc 'vncviewer localhost:$VNC_PORT'**"

$QEMU_BIN -cpu host -enable-kvm -m 4G -smp cores=6 -hda $QEMU_IMG_NAME -net user,net=20.0.0.0/24,host=20.0.0.1,hostfwd=tcp:127.0.0.1:$SSH_PORT-:22 -net nic -vnc :$VNC_PORT
