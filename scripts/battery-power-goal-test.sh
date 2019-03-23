#!/bin/bash

adb wait-for-device

adb kill-server
adb tcpip 5555
adb connect 10.0.0.:55555


read -p "Disconnect device from USB and press the return key..."

adb shell settings put system screen_off_timeout 7200000
adb shell dumpsys batterystats --reset
adb shell dumpsys batterystats --enable full-wake-history

adb shell dumpsys battery > /power-test-results/battery-before.txt

adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.VIEW -d https://www.html5rocks.com

adb shell dumpsys battery > /power-test-results/battery-after.txt
adb shell dumpsys batterystats -c > /power-test-results/batterystats-c.txt
adb shell dumpsys batterystats > /power-test-results/batterystats.txt
adb shell dumpsys batterystats org.mozilla.geckoview_example > /power-test-results/batterystats-geckoview.txt

adb bugreport /power-test-results

adb disconnect 10.252.35.237:5555

read -p "Connect device to USB and press the return key..."
adb wait-for-device

# BROWSERS STILL-TO-TEST:
# Firefox 65.0.1: Fenix (Android 7, G5)
# Reference browser (Android 7, G5)

# WORKING:
#
# Firefox 65.0.1: Fennec, 65.0.1, Android 7, G5
# stephendonner/moz_src/mozilla-unified on   (git)-[master|rebase]- [=✘»!+?] on ☿ default [?] is 📦 ⚠ via 𝗥 v1.32.0 via 🐍 system
# ➜ adb shell am start -n org.mozilla.firefox/org.mozilla.gecko.BrowserApp -a android.intent.action.VIEW -d https://www.html5rocks.com
# Starting: Intent { act=android.intent.action.VIEW dat=https://www.html5rocks.com/... cmp=org.mozilla.firefox/org.mozilla.gecko.BrowserApp }
