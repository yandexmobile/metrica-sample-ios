There is a sample application to demonstrate basic usage of Yandex.Metrica for Apps.

EULA could be found at:
http://legal.yandex.com/metrica_termsofuse/

Documentation could be found at:
http://api.yandex.com/metrica-mobile-sdk/

Quick start
1. Install CocoaPods (http://cocoapods.org/) to manage project dependancies, if you haven't done it yet.

2. Clone repository:
    git clone https://github.com/yandexmobile/metrica-sample-ios

3.  Go to cloned repository and install dependancies:
    pod install

    Notice: YandexMobileMetrica pod spec isn't currently placed at 'https://github.com/CocoaPods/Specs/', but as soon as out pull request will be accepted it would be available from there.
    Notice: KSCrash pod spec is not at 'https://github.com/CocoaPods/Specs/', so currently we specified direct url to its podspec in pod file.


4. Open project workspace MobileMetricaSample.xcworkspace.

5. Build and run MobileMetricaSample target.
