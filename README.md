## CoffeeByVakulenkoVIPER

**Features** 
- shows table of cafes from http://147.78.66.203:3210/swagger, and distance from user to cafe
- POST: /auth/register & /auth/login
- GET: /locations & /location/{id}/menu
- shows cafes on map
- make an order by adding amount of coffee cups

**Stack** 
- VIPER, dependencies injection with CocoaPods,
- CoreLocation, SnapKit, YandexMapsMobile, Security (KeyChain)
- Swagger API (POST & GET requests), Alamofire, DispatchGroup, Error handling with Result
- EndPont, Factory (URLRequestFactoryProtocol), Singleton (KeyChain, User Defaults), Alerts, ActivityIndicator
- Generic for Mapper, Delegate
- TableView, CollectionView and CollectionFlowLayOut, Custom Cells, FileManager

**To do**
- e-mail validation with regular expressions
- bug fixes

