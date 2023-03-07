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
the POST request requires a JSON payload in the structure of one of the two onboarded partners, you can see examples of these two partners payloads at the top of the test case at /spec/requests/api/v1/reservation_spec.rb. If the reservation was successfully created or updated a 204 will be returned. If there were errors with the request the respond will be a 4xx with an appropriate message.

If a request is submit with a payload in any other structure, the api will respond with a 400 advising you of this.

In order to onboard future partners you will need to create a Reservation Parser Service for that partner and hook this into the Reservation Parser Base Service which is used to identify a partner (verify_partner method) based on the partners' payload structures.
Individual reservation parsers are found under services/reservation_parsers. The format method is used to normalize/translate the JSON payload into params that the rails app can accept.


## Config/Testing

```
run rspec spec
```
The test case covers the guets and reservation models and the reservation post request. 
NB: rubocop is also used for this project.


## Additional Notes / Improvement Ideas

This implementation does not verify that the amounts input correctly sum up to the required amount (i.e security, total and payout amounts). Further business rules are required to implement this.
The number of guests is not used, instead the app simply records the number of adults, children and infants. Again a further improvement might be to check whether the total figure and the sum of these are the same but business rules would be required to do so.
Similarly the number of nights is not used as it is considered superflous, the start_date and end_date can be used to calculate this and again, if required a validation could be implemented to ensure that this calculated value matches the input.
The currency and status are controlled as enums; only one currency is currently set up to be accepted (AUD) and any other currency input will result in an error message. At present the statues of accepted, pending and cancelled have been used.
