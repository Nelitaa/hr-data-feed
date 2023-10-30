# hr-data-feed
A simple web service to download a file from an SFTP server, parse the CSV/TSV, and call an API to save new users.

## Features

1. If a user does not exist in the HR Data Feed database, the we should create the user in the destination (POST <destination>/api/v1/users).
2. Track each the "sync" state of each user from the file. If the user is not present in a subsequent file, the user should be deactivated/deleted (DELETE <destination>/api/v1/users).
3. If a user is already present in the HR Data Feed database, then its data should be updated in the destination (PUT <destination>/api/v1/users/<UUID>).

### HR Data Feed API
The HR Data Feed should have its own API endpoints to:
1. Create a source SFTP server to download the file.
2. A corresponding destination API set of endpoints to create, update and delete users.
