# Configuration file for qcow-img-burner.

#Default set of application, Advised to keep the list as is.
DEFAULT_IMG_APPS=build-essential,msr-tools,libssl-dev,openssh-server,openssh-client,openssl,unzip,wget,python

#Tools to install in the VM image, append to the list for more apps seperated by comma.
IMG_APPS=vim,git,net-tools

#Linux image headers and tools, use specific version in need.
IMG_KERNEL_APPS=linux-image-generic,linux-headers-generic,linux-tools-generic
#Image mirror to pull the debian system from.
IMG_MIRROR_URL=http://archive.ubuntu.com/ubuntu/

#Image suite name, this can be stable,zesty, xenial
IMG_SUITE=zesty

#QCOW image size, can be 10, 15, 20, 200, 500
# By default it is 10(in GBs)
QCOW_SIZE=10

# Define the qemu image name in absolute path
QEMU_IMG_NAME='/tmp/default-ubuntu-test.qcow2'

#Proxy settings
HTTP_PROXY=''
HTTPS_PROXY=''
FTP_PROXY=''

#VM image root password, must set to login
ROOT_PWD='root'
