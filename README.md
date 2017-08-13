# qemu-img-build
Create qcow images on request on debian host platform. The generated VM image will be based on debian/ubuntu.

## How to Use

	* Update 'config.sh' file to setup qcow image settings, such as image size, kernel version,etc.

	* Run the 'debian-img-burner.sh' script to generate the qcow image. It is expected to run the script as root user

	* On successful completion of script, the qcow image will be available at location 'QEMU_IMG_NAME'

	* Test the qemu image using the 'run-vm.sh' script. User can either ssh or vnc to access the VM.



***Please feel free to reach me if you face any issues with the script.***


