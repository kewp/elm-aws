curl --data @aws_curl.json -X POST ^
-H "Endpoint: https://cognito-idp.us-east-1.amazonaws.com/" ^
-H "Content-Type: application/x-amz-json-1.1" ^
-H "X-Amz-Target: AWSCognitoIdentityProviderService.InitiateAuth" ^
https://cognito-idp.us-east-1.amazonaws.com