# Museum App (UIKit)

<p align="left">	
<img src="https://img.shields.io/badge/version-1.0.0-blue">
</a>
<a href="https://www.linkedin.com/in/anatoliyostapenko">
<img src="https://img.shields.io/badge/linkedin-%230077B5.svg">
</a>
<a href="https://www.swift.org">
<img src="https://img.shields.io/badge/swift-F54A2A">
<a href="https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-16_2-release-notes">
<img src="https://img.shields.io/badge/iOS 16.2-000000?">
</p>

<p align="left">	
<img src="1024.png" width="120" height="120">
</p>

## Features
- Take a photo by iPhone or choose a photo from photo library.
- Recognize from the screen-captured image that this is exactly this product (painting for example)
- Show user the view with the image of the painting and the brief info regarding that
- Provide the user with the ability to immediately search for a product using Google or search for it on Wikipedia

## Usage
- The user has the option to take a photo on the iPhone or choose a photo from the library
<p align="left">	
<img src="firstPic.png" width="240" height="450">
</a>
<img src="buttonPic.png" width="240" height="450">
</a>
</p>

- Show the user a modal screen with the summary information found. 
- The user has the option to view detailed information from the Wiki or on the Internet.
<p align="left">	
<img src="wikiPic.png" width="240" height="450">
</a>
<img src="googlePic.png" width="240" height="450">
</a>
</p>


## Architecture:
- Consideration of screen rotation
- MVP + Coordinator design pattern
- Dependency injection + SnapKit library Cocoapods
- Swift UIKit without storyboard

## Used API:
- [serpapi](https://serpapi.com)
- [imgur](https://api.imgur.com)
- [wikipedia](https://en.wikipedia.org/w/api.php)
