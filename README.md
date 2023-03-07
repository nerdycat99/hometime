# Hometime API App

## Setup

```
run bundle install
run rails db:create
run rails db:migrate
(no seeds required)
```

## Running Locally

The app has one POST route:
```
/api/v1/reservations
```

At the command prompt:
```
run rails s
```
You can use a tool such as postman or a curl command to submit requests to
```
http://localhost:3000/api/v1/reservations
```
the POST request requires a JSON payload in the structure of one of the two onboarded partners, you can see examples of these two partners payloads at the top of the test case at /spec/requests/api/v1/reservation_spec.rb.

If a request is submit with a payload in any other structure, the api will respond with a 400 advising you of this.

In order to onboard future partners you will need to create a Reservation Parser Service for that partner and hook this into the Reservation Parser Base Service which is used to identify a partner (verify_partner method) based on the partners' payload structures.
Individual reservation parsers are found under services/reservation_parsers. The format method is used to normalize/translate the JSON payload into params that the rails app can accept.


## Config/Testing

```
run rspec spec
```
The test case covers the guets and reservation models and the reservation post request