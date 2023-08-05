## Build Release IOS
flutter clean && flutter clean && flutter pub get && flutter pub upgrade && flutter build ios --release

## Build Release IPA
flutter clean && flutter build ipa --release --export-options-plist=path/to/ExportOptions.plist

## Build Release Android appbundle
flutter clean && flutter pub get && flutter pub upgrade && flutter build appbundle --release

## Build Release Android apk
flutter clean && flutter build apk --release

## Run Releases
flutter clean && flutter clean && flutter pub get && flutter pub upgrade && flutter run --release

## Run gradlew async
./gradlew build or ./gradlew tasks

## Change version gradlew
./gradlew wrapper --gradle-version=x.x.x

## Clear IOS
rm -rf ios/Pods && rm -rf ios/Podfile.lock && rm -rf ios/.symlinks

## Install Firebase Doc
https://firebase.flutter.dev/docs/overview

## IOS Fix Command CompileSwift failed with a nonzero exit code
cd ios
pod deintegrate
pod repo update
pod update
cd ..
flutter pub cache repair
flutter run

### Clear pub cache (https://dart.dev/tools/pub/cmd/pub-cache)
flutter pub cache clean

### Xcode warning: Stale file '/path/to/file' is located outside of the allowed root paths
Cmd+Shift+K
Cmd+Shift+R

### Enabling Native Crash Support on a Flutter App in the Play Store.
https://www.youtube.com/watch?v=Ef_Ho801zZg
dir zip file: build/app/intermediates/merged_native_libs/release/out/lib
web google play console: Chọn ứng dụng / Trình khám phá App bundle / Số lần tải xuống / Biểu tượng gỡ lỗi gốc (click upload và kéo thả file zip vào)

### Generate hive model
flutter pub run build_runner watch --delete-conflicting-outputs

### Using Boxshadow
https://stackoverflow.com/questions/63953351/how-can-i-convert-css-boxshadow-to-flutter-boxshadow