# qemu-img-build
Create qcow images on request on debian host platform. The generated VM image will be based on debian/ubuntu.

## How to Use

	* Update 'config.sh' file to setup qcow image settings, such as image size, kernel version,etc.

	* Run the 'debian-img-burner.sh' script to generate the qcow image. It is expected to run the script as root user

	* On successful completion of script, the qcow image will be available at location 'QEMU_IMG_NAME'

	* Test the qemu image using the 'run-vm.sh' script. User can either ssh or vnc to access the VM.

## Notes
    * Refer 'https://wiki.ubuntu.com/Releases' to configure release names in 'config.h'

    * Script cannot create an image from outdated/end of life releases.

    * It is noted each release of ubuntu uses different softwares,tools  and configuration for
      OS services. More details on these specific release changes can be found below.

    * It is possible that VM may not have network connectivity due to wrong interface
      naming in older releases. watch out configuration in
      '/etc/network/interfaces' where network is managed by 'networking' service.

### Ubuntu-18.04(Bionic)
    * network is being managed by 'network-manager'. Add it to 'IMG_APPS' when building
      the image.
    * 'netplan' tool is used to configure network. Delete the interface from
      '/etc/network/interfaces' to avail the interface to netplan.
      (may need restart)


***Please feel free to reach me if you face any issues with the script.***


