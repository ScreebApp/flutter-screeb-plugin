<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://cocoapods.org/pods/Screeb"><img src="https://img.shields.io/cocoapods/v/Screeb.svg?style=flat" alt="Cocoapods"></a>
<a href="https://search.maven.org/search?q=g:%22app.screeb.sdk%22%20AND%20a:%22survey%22"><img src="https://img.shields.io/maven-central/v/app.screeb.sdk/survey.svg?label=Maven%20Central" alt="Maven Central"></a>
</p>

---

# Screeb flutter plugin

A flutter plugin to integrate Screeb mobile sdk for Android and/or iOS.

## Configuration

### iOS specific configuration

You should set IOS target build configuration `BUILD_LIBRARY_FOR_DISTRIBUTION` to `YES` in your `Podfile` to avoid runtime crash:
```ruby
post_install do |installer|
  ...
  installer.pods_project.targets.each do |target|
    ...

    target.build_configurations.each do |config|
      ...
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```

When upgrading a Screeb plugin version, it can be useful to run in /ios directory :
```
pod update Screeb
```

### Android specific configuration

The Android sdk needs to be notified of activities lifecycle changes to be correctly started.

It is mandatory to pass the Application context to the plugin in your custom Application class
in the `onCreate` function :

```kotlin
override fun onCreate() {
    super.onCreate()
    PluginScreebPlugin.setAppContext(this)
}
```

## Usage

Several commands are available in Screeb flutter plugin api :

### initSdk command

```dart
// Simple init command with no additionnal parameters
PluginScreeb.initSdk("<android-channel-id>", "<ios-channel-id>", null, null);
```

```dart
// Init command with identity and properties parameters
PluginScreeb.initSdk("<android-channel-id>", "<ios-channel-id>", "identity", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```

### setIdentity command

```dart
// Identity example without properties 
PluginScreeb.setIdentity("userId", null);

// Identity example with properties 
PluginScreeb.setIdentity("userId", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```

### trackEvent command

```dart
// Event example without properties 
PluginScreeb.trackEvent("eventId", null);

// Event example with properties 
PluginScreeb.trackEvent("eventId", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```

### trackScreen command

```dart
// Screen event example without properties 
PluginScreeb.trackScreen("screen_name", null);

// Screen event example with properties 
PluginScreeb.trackScreen("screen_name", <String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```

### setProperty command

```dart
// VisitorProperty example
PluginScreeb.setProperty(<String, dynamic>{
    'isConnected': true,
    'age': 27,
    'company' : 'Screeb',
    'technology' : 'iOS',
    'flutterAccount' : true
});
```
