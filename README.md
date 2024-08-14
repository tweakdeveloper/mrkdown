# mrkdown

mrkdown is an iOS app to create Tumblr posts with Markdown.

![editor screen](docs/screenshots/editor.png)
![preview screen](docs/screenshots/preview.png)

## Motivation

I have become frustrated with the official [Tumblr](https://tumblr.com) iOS 
app's difficulties with creating a text post with formatting (italics, 
bold text, etc.). Therefore, I'm creating an app to allow you to write a Tumblr 
post in Markdown.

## Goals

* [ ] Preview functionality
  * [x] Headings
  * [x] Formatted text
  * [ ] Links
  * [ ] Images
* [ ] Ability to add media (images, etc.) to posts
* [ ] Queue and schedule functionality
* [ ] Works with reblogs
  * [ ] Possible share extension from the Tumblr app
* [ ] Syntax highlighting in editor view
* [ ] Report bugs in-app that open GitHub issues
* [ ] iPad layout
  * [ ] ~Potential Mac Catalyst support~
    * Due to the Mac Catalyst framework supporting UIKit rather than SwiftUI,
    this feature will most likely not be implemented.

## Compatibility

The current lowest supported iOS version is 16.4. If your iPhone appears in
[this list](https://support.apple.com/guide/iphone/supported-models-iphe3fa5df43/16.0/ios/16.0),
it should be supported. Please
[open an issue](https://github.com/tweakdeveloper/mrkdown/issues/new/choose)
using the "Bug Report" template if you experience any unexpected issues.

## Contributing

I'm happy to have you join me in creating mrkdown! Please reference
[my contribution guidelines](CONTRIBUTING.md), and if anything is unclear,
don't hesitate to
[open an issue](https://github.com/tweakdeveloper/mrkdown/issues/new/choose).

### Code of Conduct

All contributors are expected to comply with the
[mrkdown Code of Conduct](CODE_OF_CONDUCT.md).
