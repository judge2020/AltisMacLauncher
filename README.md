# AltisMacLauncher
Project Altis launcher for mac - looks like Win.

https://youtu.be/QQXQnsGaqAc

## Programming with swift as compared to C#

There are some similarities and some differences between C# and swift. A good reference point is [here](https://developer.ibm.com/swift/2016/02/25/swift-for-c-developers/). The main similarities are that they're both based on java, meaning syntax is widely similar.

The differences and compared to C#:

* In C# you **have** to semicolon; in swift it's discouraged to do this but won't break code.
* in swift a non-changing variable is set with `let`, like a C# `const`
* Conditional access is by putting a `?` after a variable, in both languages.
* in swift you have to unwrap a optional value with `!`
* In C# a variable can be used without it being set, in which it will throw `NullReferenceException`. in swift you have to unwrap optional variables




## Getting started:

Required:

- Mac / Mac VM
- [xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
- OS X 10.12 recommended.
- OS X 10.11/10.12 SDK
- [Brew](https://brew.sh/)
- [Cocoapods](https://cocoapods.org/#install)

Installation and setup

1. clone repo and cd to folder
2. `pod install`
3. open Project Altis.**xcworkspace** (WORKSPACE not project)
4. press the start button in the top right to confirm it builds
