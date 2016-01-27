![Stack](/Stack/Resources/Images.xcassets/AppIcon.appiconset/stack_app_icon60@3x.png "Stack")

# Stack #

Stack is an Ultimate news iOS app that aggregates news from the biggest digital content providers.

[App Store download](https://itunes.apple.com/us/app/stack./id1076823318?ls=1&mt=8)

## Setup

1. Clone repo
2. run `pod install`
 
In order to retrieve posts from Blogger backed blogs, you will need to register with Blogger and obtain an API key. Then install https://github.com/orta/cocoapods-keys and create a `BloggerAPIKey` key that uses your previously generated API key.

## Supported Backends

#### WordPress

The [WordPress REST API](https://github.com/WP-API/WP-API) plugin is being used to consume content.

The [Simple Parse Push Service](https://wordpress.org/plugins/simple-parse-push-service/) plugin is being used to provide push notification services

#### RSS

Push notifications are not supported for RSS backends

#### Blogger

Push notifications are not supported for Blogger backends

## Contributing

Issues and pull requests are welcome!

## Author

Bradley Smith: [@bsmithers11](https://twitter.com/bsmithers11)

## License

Stack is available under the MIT license. See the LICENSE file for more info.
