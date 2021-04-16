# kukukonline

kukukonline is an application to report noise disturbance.
In Germany the default way to do so, seems to be via email.

## Deploy

``` shell script
flutter packages get
flutter packages pub run flutter_launcher_icons:main
cd ios; pod install
flutter build
```

## android signing

https://flutter.dev/docs/deployment/android

## ios/Runner/GoogleService-Info.plist

Download from https://console.firebase.google.com/project/{{your project_id}}/settings/general

## android/app/google-services.json

Download from https://console.firebase.google.com/project/{{your project_id}}/settings/general

## web/firebase.js

```
firebase.initializeApp({
    apiKey: "current_key from google-services.json",
    messagingSenderId: "project_number from google-services.json",
    appId: "1:project name:web:project name",
    projectId: "project_id from google-services.json",
});
```

## TODO

- [x] multi select recipients
- [x] select disturbance type
- [x] separate zip input
- [x] dynamic disturbance type filling
- [x] logging postal code, date, time
- [ ] add configuration for recipients
