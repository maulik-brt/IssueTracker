# IssueTracker
> IssueTracker - Blue whale apps

![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)  
![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)

## Version

1.0.18

## Features

IssueTrackers helps to report a problem in iOS application.
- Easy installation
- Create ticket directly to redmine
- No need to add extra information so, it will be very easy
- Helps to understand user's information which will directly goes to redmine ticket
- Markup on image to hightlight issue

You just need `project id` and roadmap id which called `target version`

```
let versionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
BWFeedback.shared.present(self, "XXXX", "\(versionNumber)(\(buildNumber))", "iOS", "XXXX", env, "160")
```

## Requirements

- iOS 11.0+ or later
- Xcode 10.5 or later
- Mac OS Catelina v10.15.4 or later

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```
pod 'IssueTracker'
```
