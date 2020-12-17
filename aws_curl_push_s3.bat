curl -X PUT -T "${file_to_upload}" ^
  -H "Host: elm-aws.s3.amazonaws.com" ^
  -H "Content-Type: application/x-compressed-tar" ^
  -H "Authorization: AWS ${s3_access_key}:${signature_hash}" ^
  https://${bucket}.s3.amazonaws.com/${file_to_upload}