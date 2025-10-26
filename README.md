# Equipe FFE Integration Service

Web service that provides integration between the French Equestrian Federation (FFE) and Equipe's competition management platform.

## API Endpoints

### Health Check

`GET /up`

Health check endpoint that returns 200 if the application is running properly, 500 otherwise. Used by load balancers and uptime monitors.

### FFE Entry File Conversion

`POST /file/entries`

Converts an FFE-format XML entry file to Equipe's entries.json format.

**Request:**

- Content-Type: `application/xml`
- Body: FFE XML entry file
- Headers:
  - `X-Federation-Organizer-ID`: Federation organizer identifier
  - `X-Federation-User-Name`: Name of the user uploading the file
  - `X-Federation-User-Email`: Email of the user uploading the file

**Response:**

- Content-Type: `application/json`
- Body: Valid entries.json that app.equipe.com can import

The uploaded files are stored and can be viewed in the admin interface.

### Result File Conversion

`POST /file/results`

Converts Equipe's results.json format to FFE XML result format.

**Request:**

- Content-Type: `application/json`
- Body: Results in Equipe's JSON format

**Response:**

- Content-Type: `application/xml`
- Body: FFE-formatted result XML

**Note:** The show must have been previously imported via equipe-ffe in order to export results.

### Result Validation

`POST /results`

Simulates whether the federation accepts results in the format provided by app.equipe.com without needing conversion.

## Admin Interface

### `/admin/uploads`

Administrative interface to view and manage uploaded entry files.

**Features:**

- Displays the 500 most recent entry file uploads
- Shows upload metadata:
  - Upload date/time
  - Show name and FFE ID
  - Organizer name
  - Uploader name and email
  - File size
- Download original uploaded XML files
- Requires authentication

## Deployment

The application is deployed using [Kamal](https://kamal-deploy.org/).

### Kamal Commands

```bash
# Deploy the application
bin/kamal deploy

# Access Rails console
bin/kamal console

# Access shell
bin/kamal shell

# View logs
bin/kamal logs

# Access database console
bin/kamal dbc

# Redeploy
bin/kamal redeploy
```

## Development

The application is a Ruby on Rails application that:

- Parses FFE XML entry files
- Converts data between FFE and Equipe formats
- Stores uploaded files for auditing and debugging
- Provides admin interfaces for monitoring uploads
