# README

This app is a proof of concept of using a router service, here you'll find out how to use it

## Dependencies

- Ruby `3.1.2`

## Run
- `gem install bundler -v '2.5.6'`
- `bundle i`
- `rails s`

Now you can visit `localhost:3000/routes` with mandatory params `origin_port` & `destination_port` and optional params `criteria` (`cheapest` is the default)

- `origin_port` & `destination_port` can be `CNSHA`, `NLRTM`, `ESBCN` or `BRSSZ`
- `criteria` can be `cheapest` or `fastest`

## Usage
### Cheapest
For example using CNSHA as origin port & NLRTM as destination port, with cheapest criteria
`localhost:3000/routes?origin_port=CNSHA&destination_port=NLRTM&criteria=cheapest`
```
[
   {
      "origin_port":"CNSHA",
      "destination_port":"ESBCN",
      "departure_date":"2022-01-29",
      "arrival_date":"2022-02-12",
      "sailing_code":"ERXQ",
      "rate":"261.96",
      "rate_currency":"EUR",
      "usd":1.1138,
      "jpy":130.85
   },
   {
      "origin_port":"ESBCN",
      "destination_port":"NLRTM",
      "departure_date":"2022-02-16",
      "arrival_date":"2022-02-20",
      "sailing_code":"ETRG",
      "rate":"69.96",
      "rate_currency":"USD",
      "usd":1.1482,
      "jpy":149.93
   }
]
```

### Fastest
For example using CNSHA as origin port & NLRTM as destination port, with fastest criteria
`localhost:3000/routes?origin_port=CNSHA&destination_port=NLRTM&criteria=fastest`
```
{
   "origin_port":"CNSHA",
   "destination_port":"NLRTM",
   "departure_date":"2022-01-29",
   "arrival_date":"2022-02-15",
   "sailing_code":"QRST",
   "rate":"761.96",
   "rate_currency":"EUR"
}
```

## Test
### Unit Tests
Comprehensive unit tests have been implemented to ensure that individual components of our codebase function as expected in isolation. These tests cover functions, methods, and classes, allowing issues to be identified and fixed early in the development process.

### Controller Tests
Our controller tests validate the behavior of our application's endpoints and ensure that the integration between different components works as intended. By simulating HTTP requests and responses, we verify that the controllers handle incoming requests correctly and produce the expected outputs.

### Run tests

`bundle exec rspec`

## Docker Image

If you prefer not to install all the dependencies locally or want to ensure consistency across different environments, a Docker image for this application is available. Follow the instructions below to run the application using Docker

### Build Image
`docker build -t router-app .`

### Run Image
`docker run -p 3000:3000 -t router-app`

Now, you can use the app like stated in Usage section
