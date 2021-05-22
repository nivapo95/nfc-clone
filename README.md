
<p align="center">
  <h3 align="center">NFC CLONE</h3>

  <p align="center">
    A script to clone nfc cards
    <br />
    <a href="https://github.com/nivapo95/nfc-clone"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/nivapo95/nfc-clone">View Demo</a>
    ·
    <a href="https://github.com/nivapo95/nfc-clone/issues">Report Bug</a>
    ·
    <a href="https://github.com/nivapo95/nfc-clone/issues">Request Feature</a>
  </p>
</p>


A list of commonly used resources that I find helpful are listed in the acknowledgements.

### What you will need


* NFC Card reader (I used [ACR122U](https://www.amazon.com/ACS-ACR122U-Contactless-Smart-Reader/dp/B01KEGQFYY))
* A NFC card with existing data to replicate 
* Blank NFC cards (read+write)
* 
<!-- GETTING STARTED -->
## Getting Started

The NFC Card reader/writer used for this POC is called ACR122U-A9 
The Linux type I am using is a Debian 10

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Installation

1. Install nfc-clone

1. Install mfoc
   ```sh
   git clone https://github.com/nfc-tools/mfoc
   ```
2. Run the following commands
   ```sh
   autoreconf -is
   ./configure
   make && sudo make install
   ```
3. Recommended packages to install
   ```sh
   apt-get install libnfc-bin
   apt-get install libnfc-dev
   apt-get install libnfc-examples
   apt-get install pcsc-tools
   apt-get install pcscd
   apt-get install libacsccid1
   apt-get install --reinstall libpcsclite1
   ```



<!-- USAGE EXAMPLES -->
## Usage

Install all the packages aboe in a new folder.
Download the clone.sh file to the same folder.

Run the file as sudo using sudo bash ./clone.sh

Follow the steps on screen.



_For more examples, please refer to the [Documentation](https://example.com)_


<!-- ACKNOWLEDGEMENTS -->
## Usefull libks
* [Youtube tutorial](https://www.youtube.com/watch?v=c0Qsmgvj_oo)
* [Mfoc repo](https://github.com/nfc-tools/mfoc)
* [How to install libnfc on all operation systems](http://nfc-tools.org/index.php/Libnfc#Download)
* [Installin autoreconf (sometimes needed)](https://askubuntu.com/questions/265471/autoreconf-not-found-error-during-making-qemu-1-4-0)
* [Unable to claim usb interface - solved](https://stackoverflow.com/questions/31131569/unable-to-claim-usb-interface-device-or-resource-busy)
