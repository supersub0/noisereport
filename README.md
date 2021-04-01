# kukukonline

kukukonline is an application to report noise disturbance.
In Germany the default way to do so, seems to be via email.

## Deploy

``` shell script
flutter pub get
flutter packages get
flutter packages pub run flutter_launcher_icons:main
flutter build
```

## TODO

- [x] multi select recipients
- [x] select disturbance type
- [x] separate zip input
- [x] dynamic disturbance type filling
- [x] logging zip, DateTime
- [ ] add configuration for recipients
