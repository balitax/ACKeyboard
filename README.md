# ACKeyboard

[![CI Status](https://img.shields.io/travis/balitax/ACKeyboard.svg?style=flat)](https://travis-ci.org/balitax/ACKeyboard)
[![Version](https://img.shields.io/cocoapods/v/ACKeyboard.svg?style=flat)](https://cocoapods.org/pods/ACKeyboard)
[![License](https://img.shields.io/cocoapods/l/ACKeyboard.svg?style=flat)](https://cocoapods.org/pods/ACKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/ACKeyboard.svg?style=flat)](https://cocoapods.org/pods/ACKeyboard)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- Min swift 4.2
- XCode 10
- iOS 12

## Installation

ACKeyboard is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ACKeyboard'
```

## How to use 

```ruby

let acKeyboard = ACKeyboard()

 acKeyboard
            .on(event: .willShow) { [weak self] option in
                self?.submitButtonLayoutIfNeeded(by: option.endKeyboardFrame.height.supportSafeArea)
            }
            .on(event: .willHide) { [weak self] option in
                self?.resetLayoutSubmitButton()
            }
            .autoHideKeyboard(onTap: view)
            .start()

```

## Demo
<video src="
https://github.com/balitax/ACKeyboard/assets/1490342/33bd84d8-3b19-4f12-ad4b-d95c9de448d6" width="300" />

## Author

Agus Cahyono, cahyo.mamen@gmail.com

## License

ACKeyboard is available under the MIT license. See the LICENSE file for more info.
