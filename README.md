<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://cocoapods.org/pods/Screeb"><img src="https://img.shields.io/cocoapods/v/Screeb.svg?style=flat" alt="Cocoapods"></a>
<a href="https://search.maven.org/search?q=g:%22app.screeb.sdk%22%20AND%20a:%22android-sdk%22"><img src="https://img.shields.io/maven-central/v/app.screeb.sdk/android-sdk.svg?label=Maven%20Central" alt="Maven Central"></a>
</p>

---

# plugin_screeb

A flutter plugin to integrate Screeb mobile sdk for Android and/or iOS.

## Getting Started

Screeb sdk needs to be installed and initialized on each platform before being used in flutter.

### Android

Installation with MavenCentral : 

```groovy
implementation 'app.screeb.sdk:android-sdk:1.1.0'
```

Initialization in your custom Application class

```kotlin
// simple initialization
val screeb = Screeb.Builder()
        .withContext(this)
        .withChannelId("<website-id>")
        .build()

// detailed initialization using a unique id and custom properties, see Identify visitors section
val screeb = Screeb.Builder()
        .withContext(this)
        .withChannelId("<website-id>")
        .withVisitorId("johndoe@screeb.app") // optional
        .withVisitorProperties(VisitorProperties().apply {
            this["email"] = "johndoe@screeb.app"
            this["age"] = 32
        }) // optional
        .build()
```

### iOS

Installation instruction in the project's Podfile

```ruby
pod "Screeb", "0.7.0"
```

Initialization in your AppDelegate.swift file :

```swift
Screeb.initSdk(context: controller, channelId: "<website-id>")
```

## Usage in flutter

Several commands are available in Screeb flutter plugin api :

### SetIdentity command

```dart
PluginScreeb.setIdentity("userId");
```

### SendTrackingEvent command

```dart
// Event example without properties 
PluginScreeb.sendTrackingEvent("eventId");

// Event example with properties 
PluginScreeb.sendTrackingEvent("eventId", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```

### SendTrackingScreen command

```dart
// Screen event example without properties 
PluginScreeb.sendTrackingScreen("screen_name");

// Screen event example with properties 
PluginScreeb.sendTrackingScreen("screen_name", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```

### VisitorProperty command

```dart
// VisitorProperty example
PluginScreeb.visitorProperty("screen_name", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```
