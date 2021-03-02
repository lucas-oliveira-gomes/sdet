### API Test
 - Access `www.interzoid.com` and create a free account (do not spend any money, use a
10minutemail.com e-mail account id if you need more than 25 tries).
 - API that should be tested is available `https://www.interzoid.com/services/getweathercity`
 - Fill the request with these required fields with this information:

City  | State | Expected Behavior
------------- | -------------
Round Rock  | TX | 200
Tampa  | TX | 404
'--' | '--' | 400

 - Your test must validate:
  - HTTP Status Code;
  - HTTP Status Description;
----
#### How to execute
 - Clone this repository:
 `git clone https://github.com/lucas-oliveira-gomes/sdet.git`
 
 - Navigate to the api-test folder
  `cd sdet\api-test`
 
 - Using maven execute the test:
  `mvn test`
