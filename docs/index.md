# Android Power-Testing Docs

🔥🦊⏱

## (The) More stuff You should Know 🌈⭐

* Test Plan: [Android Power/Battery-Use](https://docs.google.com/document/d/1r1J_BZnE5l8nXoLVXVR1hUlEkzaPX2gx_ueZABkzi6g/edit) (Google Doc, WIP)
* Main bug: [bug 1511350](https://bugzilla.mozilla.org/show_bug.cgi?id=1511350) - Test impact of dark mode on power usage
* Builds atop Bob Clary's work with Rob Wood on [power.py](https://searchfox.org/mozilla-central/rev/b3ac60ff061c7891e77c26b73b61804aa1a8f682/testing/raptor/raptor/power.py)
* Raptor power-testing code refactoring needed to quickly abstract and extend supported testing capabilities ([bug 1534778](https://bugzilla.mozilla.org/show_bug.cgi?id=1534778) 'quick' first step)

## Example Android {intents, namespaces, binary paths} to Vet
(Key parts, below; mix and match with the namespace of whichever browser variant you're targetting).  They are as-of-yet unvetted for our DOM-color testing needs.

Android Intents
* -a android.intent.action.VIEW
* -a android.intent.action.MAIN


Binary Paths (```--binary```):
* Fennec (release) - ```org.mozilla.firefox```
* Fennec (beta?) - ```.org.mozilla.fennec_aurora```
* Fenix - ```org.mozilla.fenix```
* GeckoView - ```org.mozilla.geckoview```
* Reference Browser - ```org.mozilla.reference.browser```


## Initial Testing Focus
Example given from [bug 1511350](https://bugzilla.mozilla.org/show_bug.cgi?id=1511350#c0):

```
data:text/html,<body style="background-color:black">
```

Ostensibly, the following are our (mostly unvetted) options for testing with a black background:
* data: URLs
 * these MUST be [URL-encoded](https://www.urlencoder.org/), like so:
```
data%3Atext%2Fhtml%2C%3Cbody%20style%3D%22background-color%3Ablack%22%3E
```
 * I think we need to base64-encode (https://www.base64encode.net/) (Python: https://github.com/base64encode/examples/blob/master/base64encode.py) the raw data: URL from bug 1511350
 * even then, due to (wise) scheme-handling/remote-loading security models, they are unlikely to work (i.e. be parsed)
  * note to self: [insert example from recent shell session, here]:
    * $
* profile pre-seeded with remote URL as homepage
  * implies additional profile seeding/management (but, done well, guess this could also help centralize/abstract a bit?)
* profile pre-seeded with local (to-sdcard/file?) file path
* ...or is this mostly moot with Raptor (via [runner.js](https://searchfox.org/mozilla-central/rev/b3ac60ff061c7891e77c26b73b61804aa1a8f682/testing/raptor/webext/raptor/runner.js)) being able to inject content at/after runtime?
* (least-favorite option?) loading remote "dead-pixel test" pages:
```
adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.VIEW -d https://jasonfarrell.com/misc/deadpixeltest.php?p=2
```

# Fenix

## APKs/Build(s)
* APKs: https://tools.taskcluster.net/index/project.mobile.fenix.signed-nightly.nightly/latest
* Build(s): https://github.com/mozilla-mobile/fenix#build-instructions

## Docs

## Examples
From #fenix on Slack, re: Fenix support for Raptor, "I did add some level of Raptor integration to Fenix, but I only put it in debug builds and special builds to avoid allowing malicious apps to run Fenix with arbitrary WebExtensions."

```
$ adb shell am start -n "org.mozilla.fenix/org.mozilla.fenix.HomeActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
```

```
$ adb shell am start -a "android.intent.action.VIEW" -d "http://developer.android.com"
```

# Fennec

## APKs/Builds
* [Fennec 66.0 APK](http://archive.mozilla.org/pub/mobile/releases/66.0/android-x86/en-US/)

## Docs
* https://wiki.mozilla.org/Mobile/Fennec/Android

## Examples
```
$ adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.VIEW -d data%3Atext%2Fhtml%2C%3Cbody%20style%3D%22background-color%3Ablack%22%3E
```
The above:
* launches Fennec
* tries to search Google for data%3Atext%2Fhtml%2C%3Cbody%20style%3D%22background-color%3Ablack%22%3E (as the string you read here)
## Raptor Power Testing
```
$ ./mach raptor-test --power-test --test raptor-speedometer --app fennec --binary org.mozilla.firefox --host 10.0.0.26
```



```
$ adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.VIEW -d https://jasonfarrell.com/misc/deadpixeltest.php?p=2
Starting: Intent { act=android.intent.action.VIEW dat=https://jasonfarrell.com/... cmp=org.mozilla.firefox/org.mozilla.gecko.BrowserApp }
```

# GeckoView

## APKs/Builds

## Docs
* [Bootstrap Gecko](https://mozilla.github.io/geckoview/tutorials/geckoview-quick-start#bootstrap-gecko), for GeckoView and Fennec (Fenix too?) development

## Examples
* GeckoView power.py battery-level/usage test-run [console output](https://gist.github.com/stephendonner/f864cdf861d8b221e7c80f7f73354fde#file-raptor-power-geckoview-success-txt) (Moto G5, Android 7):

## Raptor Power Testing

# Reference Browser

## APKs/Builds
* APK
Direct link to [latest nightly APK](https://index.taskcluster.net/v1/task/project.mobile.reference-browser.signed-nightly.nightly.latest/artifacts/public/app-geckoNightly-arm-armeabi-v7a-release-unsigned.apk), which we can use in automation/shell scripts

## Install

```
$ adb -d install /Users/stephendonner/Downloads/app-geckoNightly-arm-armeabi-v7a-release-unsigned.apk 
```

## Docs

https://github.com/mozilla-mobile/reference-browser
https://github.com/mozilla-mobile/android-components

## Examples

## Raptor Power Testing

# Random Resources
* ADB
  * [ADB docs](https://developer.android.com/studio/command-line/adb)
  * [Handy ADB and fastboot gist](https://gist.github.com/MacKentoch/feb819727e9f3bacde307e9c53449daf)
  * [ADB cheatsheet](https://devhints.io/adb)
