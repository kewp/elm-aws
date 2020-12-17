curl --data @respond_to_auth_challenge.json -X POST ^
-H "Endpoint: https://cognito-idp.us-east-1.amazonaws.com/" ^
-H "Content-Type: application/x-amz-json-1.1" ^
-H "X-Amz-Target: AWSCognitoIdentityProviderService.RespondToAuthChallenge" ^
https://cognito-idp.us-east-1.amazonaws.com