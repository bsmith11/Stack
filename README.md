![Stack](/Stack/Resources/Images.xcassets/AppIcon.appiconset/stack_app_icon60@3x.png "Stack")

![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)

# Stack #

Stack is an Ultimate Frisbee news iOS app that aggregates news from the biggest digital content providers.

[App Store download](https://itunes.apple.com/us/app/stack./id1076823318?ls=1&mt=8)

## Setup

1. Clone repo
2. The project uses https://github.com/orta/cocoapods-keys to manage API keys. The project will still run fine even if you use trash values for the keys.
  1. In order to retrieve posts from Blogger backed blogs, you will need to register with Blogger and obtain an API key. This API key will then need to be stored using cocoapods-keys.
  2. The Parse keys can be safely be filled with trash values
3. run `pod install`

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
