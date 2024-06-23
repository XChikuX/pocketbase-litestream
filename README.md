## Prerequisites

To test this locally, you'll need to have an S3-compatible store to connect to. Please see the Litestream Guides to get set up on your preferred object store.

You'll need to set your object store credentials in your shell environment:

```
export LITESTREAM_ACCESS_KEY_ID=XXX
export LITESTREAM_SECRET_ACCESS_KEY=XXX
export REPLICA_BUCKET=XXX
export REPLICA_ENDPOINT=https://yourendpoint
export REPLICA_REGION=XXX #set to us-east-1 if you are using minio's default region
```

Building & running the container

You can build the application with the following command, if you are using this image as your base image:

docker build -t myapp .

Once the image is built, you can run it with the following command. Be sure to change the REPLICA_URL variable to point to your bucket.

```
docker run \
  -p 8090:8090 \
  -v ${PWD}:/pb_data \
  -e REPLICA_BUCKET=XXX \
  -e REPLICA_ENDPOINT=https://yourendpoint \
  -e REPLICA_REGION=XXX \
  -e LITESTREAM_ACCESS_KEY_ID \
  -e LITESTREAM_SECRET_ACCESS_KEY \
  myapp
```

Let's break down the options one-by-one:

    -p 8090:8090 maps the container's port 8090 to the host machine's port 8090 so you can access the application's web server for Pocketbase at `/_/` path.

    -v ${PWD}:/pb_data —mounts a volume from your current directory on the host to the /pb_data directory inside the container.

    -e REPLICA_BUCKET=..., -e REPLICA_ENDPOINT=..., -e REPLICA_REGION=... —sets environment variables for your replica. This is used by the startup script to restore the database from a replica if it doesn't exist and it is used in the Litestream configuration file.

    -e LITESTREAM_ACCESS_KEY_ID & -e LITESTREAM_SECRET_ACCESS_KEY—passes through your current environment variables for your S3 credentials to the container.
