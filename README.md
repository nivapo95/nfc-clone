



<!-- PROJECT LOGO -->
<br />
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


<!-- GETTING STARTED -->
## Getting Started

The NFC Card reader/writer used for this POC is called ACR122U-A9 
The Linux type I am using is a Debian 10

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Installation

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
3. Enter your API in `config.js`
   ```JS
   const API_KEY = 'ENTER YOUR API';
   ```



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Img Shields](https://shields.io)
* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Pages](https://pages.github.com)
* [Animate.css](https://daneden.github.io/animate.css)
* [Loaders.css](https://connoratherton.com/loaders)
* [Slick Carousel](https://kenwheeler.github.io/slick)
* [Smooth Scroll](https://github.com/cferdinandi/smooth-scroll)
* [Sticky Kit](http://leafo.net/sticky-kit)
* [JVectorMap](http://jvectormap.com)
* [Font Awesome](https://fontawesome.com)
