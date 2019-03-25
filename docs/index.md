# Android Power-Testing Docs

🔥🦊⏱

## (The) More stuff You should Know 🌈⭐

* Test Plan: [Android Power/Battery-Use](https://docs.google.com/document/d/1r1J_BZnE5l8nXoLVXVR1hUlEkzaPX2gx_ueZABkzi6g/edit) (Google Doc, WIP)
* Main bug: [bug 1511350](https://bugzilla.mozilla.org/show_bug.cgi?id=1511350) - Test impact of dark mode on power usage
* Builds atop Bob Clary's work with Rob Wood on [power.py](https://searchfox.org/mozilla-central/rev/b3ac60ff061c7891e77c26b73b61804aa1a8f682/testing/raptor/raptor/power.py)
* Raptor power-testing code refactoring needed to quickly abstract and extend supported testing capabilities ([bug 1534778](https://bugzilla.mozilla.org/show_bug.cgi?id=1534778) 'quick' first step)

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
 * even then, due to (wise) scheme-handling/remote-loading security models, they are unlikely to work (i.e. be parsed)
  * note to self: [insert example from recent shell session, here]:
    * $
* profile pre-seeded with remote URL as homepage
  * implies additional profile seeding/management (but, done well, guess this could also help centralize/abstract a bit?)
* profile pre-seeded with local (to-sdcard/file?) file path
* ...or is this mostly moot with Raptor (via [runner.js](https://searchfox.org/mozilla-central/rev/b3ac60ff061c7891e77c26b73b61804aa1a8f682/testing/raptor/webext/raptor/runner.js)) being able to inject content at/after runtime?
* (least-favorite option?) loading remote "dead-pixel test" pages:
```
.
```

# Fennec

## APKs/Builds
* [Fennec 66.0 APK](http://archive.mozilla.org/pub/mobile/releases/66.0/android-x86/en-US/)


## Docs
* https://wiki.mozilla.org/Mobile/Fennec/Android

## Example Android {intents, namespaces, binary paths} to Vet
(Key parts, below; mix and match with the namespace of whichever browser variant you're targetting).  They are as-of-yet unvetted for our DOM-color testing needs.
* org.mozilla.gecko.BrowserApp
*

Binary Paths:
* Fennec (release) - ```org.mozilla.firefox```
* Fenix - ```org.mozilla.fenix```
* GeckoView - ```org.mozilla.geckoview```
* Reference Browser - 

```
$ adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.App -a android.intent.action.VIEW -d URL
```
```
$ adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.MAIN -d data%3Atext%2Fhtml%2C%3Cbody%20style%3D%22background-color%3Ablack%22%3E
```
The above:
* launches Fennec
* tries to load data%3Atext%2Fhtml%2C%3Cbody%20style%3D%22background-color%3Ablack%22%3E in Google (as the string you read here)

```
  $ adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.MAIN -d data%3Atext%2Fhtml%2C%3Cbody%20style%3D%22background-color%3Ablack%22%3E
  Starting: Intent { act=android.intent.action.MAIN dat=data:text/html,<body style="background-color:black"> cmp=org.mozilla.firefox/org.mozilla.gecko.App }
  Error type 3
  Error: Activity class {org.mozilla.firefox/org.mozilla.gecko.App} does not exist.
```



# GeckoView

## APKs/Builds

## Docs
* [Bootstrap Gecko](https://mozilla.github.io/geckoview/tutorials/geckoview-quick-start#bootstrap-gecko), for GeckoView and Fennec (Fenix too?) development

## Examples
* GeckoView power.py battery-level/usage test-run [console output](https://gist.github.com/stephendonner/f864cdf861d8b221e7c80f7f73354fde#file-raptor-power-geckoview-success-txt) (Moto G5, Android 7):

```
$ ./mach raptor-test --power-test --test raptor-speedometer --app fennec --binary org.mozilla.firefox --host 10.0.0.26
```

# Reference Browser

## APKs/Builds
* Direct link to [latest nightly APK](https://index.taskcluster.net/v1/task/project.mobile.reference-browser.signed-nightly.nightly.latest/artifacts/public/app-geckoNightly-aarch64-release-unsigned.apk), which we can use in automation/shell scripts

Can't yet get ```adb -d install [nightly.apk]``` working:
```
➜ adb -d install /Users/stephendonner/Downloads/app-geckoNightly-aarch64-release-unsigned.apk
adb: failed to install /Users/stephendonner/Downloads/app-geckoNightly-aarch64-release-unsigned.apk: Failure [INSTALL_FAILED_NO_MATCHING_ABIS: Failed to extract native libraries, res=-113]

android-power-testing on  master [!] took 14s
```

# Fenix

## APKs/Builds
* https://github.com/mozilla-mobile/fenix#build-instructions

From #fenix on Slack, re: Fenix support for Raptor, "I did add some level of Raptor integration to Fenix, but I only put it in debug builds and special builds to avoid allowing malicious apps to run Fenix with arbitrary WebExtensions."

```
$ adb shell am start -n "org.mozilla.fenix.debug/org.mozilla.fenix.HomeActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
```

```
$ adb shell am start -a "android.intent.action.VIEW" -d "http://developer.android.com"
```
Per the above, it appears once you namespace (what I call it) in adb, the calls to android.intent.action.VIEW or .MAIN, etc., can happen separately

Below illustrates that -d about:blank works
```
$ adb shell am start -a "android.intent.action.VIEW" -d about:blank
Starting: Intent { act=android.intent.action.VIEW dat=about:blank }
```


# Random Resources
* [ADB docs](https://developer.android.com/studio/command-line/adb)
* Handy ADB and fastboot gist: https://gist.github.com/MacKentoch/feb819727e9f3bacde307e9c53449daf
