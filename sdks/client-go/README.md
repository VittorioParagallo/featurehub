client-go
=========

A GoLang client SDK for FeatureHub.

Features
--------
* Client interface, with an autogenerated mock so you can unit test with this SDK
* Config type, with validation and defaults
* StreamingClient implementation:
    - Features are made available through "Get" methods:
        - `GetFeature` returns a whole feature (by key) with full metadata (but an untyped value)
        - `GetBoolean` returns a boolean feature (by key), or an error if it is unable to assert the value to a boolean
        - `GetNumber` / `GetRawJSON` / `GetString` as above
    - Levelled Logging (you can choose how verbose to make this)
	- Notifiers can be added for named feature keys, which will trigger a user-provided callback function whenever a feature with this key is updated
	- Notifiers can be added ahead of time (before the client even knows about the feature-keys in question)
* Custom errors (allows you to handle different errors in specific ways)


Usage
-----
Some snippets to get you going.

### Connecting to FeatureHub
There are 3 steps to connecting:
1) Prepare a config
2) Use the config to make a client
3) Tell the client to start handling features

#### Prepare a configuration:
```go
    config := &client.Config{
        SDKKey:        "default/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/ajhsgdJHGAFKJAHSGDFKAJHHSDLFKAJLSKJDHFLAJKHlkjahlkjhfsld",
        ServerAddress: "http://1.2.3.4:8085",
        WaitForData:   true,
    }
```

#### Use it to make a new client:
```go
	fhClient, err := client.NewStreamingClient(config)
	if err != nil {
		log.Fatalf("Error connecting to FeatureHub: %s", err)
    }
```

#### Start handling data (will block until some data is received if `config.WaitForData` is set):
```go
    fhClient.Start()
```


### Requesting Features
The client SDK offers various `Get` methods to retrieve different types of features:
* `GetBoolean(key)`: returns a true or false
* `GetRawJSON(key)`: returns a serialised JSON object
* `GetNumber(key)`: returns a float64
* `GetString(key)`: returns a string

#### Retrive a BOOLEAN value:
```go
	someBoolean, err := fhClient.GetBoolean("booleanfeature")
	if err != nil {
		log.Fatalf("Error retrieving a BOOLEAN feature: %s", err)
	}
	log.Printf("Retrieved a BOOLEAN feature: %v", someBoolean)
```

#### Retrive a JSON value:
```go
	someJSON, err := fhClient.GetRawJSON("jsonfeature")
	if err != nil {
		log.Fatalf("Error retrieving a JSON feature: %s", err)
	}
	log.Printf("Retrieved a JSON feature: %s", someJSON)
```

#### Retrive a NUMBER value:
```go
	someNumber, err := fhClient.GetNumber("numberfeature")
	if err != nil {
		log.Fatalf("Error retrieving a NUMBER feature: %s", err)
	}
	log.Printf("Retrieved a NUMBER feature: %f", someNumber)
```

#### Retrive a STRING value:
```go
	someString, err := fhClient.GetString("stringfeature")
	if err != nil {
		log.Fatalf("Error retrieving a STRING feature: %s", err)
	}
    log.Printf("Retrieved a STRING feature: %s", someString)
```


### Configuring Notifiers (callbacks)
The client SDK allows the user to define callback notifications which will be triggered whenever a specific feature key is updated.
Notifiers can be defined at any time, even before the client has received data.
* `AddNotifierBoolean(key string, callback func(bool))`: Calls the provided function with a boolean value
* `AddNotifierFeature(key string, callback func(*models.FeatureState))`: Calls the provided function with a raw feature state
* `AddNotifierJSON(key string, callback func(string))`: Calls the provided function with a JSON string value
* `AddNotifierNumber(key string, callback func(float64))`: Calls the provided function with a float64 value
* `AddNotifierString(key string, callback func(string))`: Calls the provided function with a string value
* `DeleteNotifier(key string) error`: Deletes any configured notifier for the given key (or returns an error if no notifier was found)


### Configuring a Readiness Listener
The client SDK allows the user to define a callback function which will be triggered once, when the client first receives some data from the server.
* `ReadinessListener(callback func())`: Sets the readiness listener to a specific user-provided function


### Analytics Collector
The client SDK provides the ability to generate analytics events with the `LogAnalyticsEvent` method. An event will be generated for each feature that we have.
```go
	action := "payment"
	tags := map[string]string{"user": "bob"}
	client.LogAnalyticsEvent(action, tags)
```
Currently the SDK only supports a logging analytics collector, which is configured by default whenever you use the SDK. It logs events to the console at DEBUG level.


Todo
----
- [X] Config
- [X] Client interface
- [X] StreamingClient
- [X] Unit tests
- [X] Handle feature_delete events
- [X] Compare versions when "feature" event is received (don't just overwrite)
- [X] Allow notify / callback functions (add and remove)
- [X] Global "readyness" callback (either OK when data has arrived, or an error if there was a fail)
- [X] Analytics support
- [ ] Google Analytics support
- [ ] Re-introduce the "polling" client (if we decide to go down that route for other SDKs)
- [ ] Run tests and code-generation inside Docker (instead of requiring Go to be installed locally)
