## Hello and welcome!

This sandbox requires Docker and Python 3.9 or greater. A virtual Python environment is recommended!

Install dependencies:
```bash
pip install -e '.[dev]'
```
Run the service:
```bash
uvicorn --app-dir service main:service --reload
```
Run the tests:
```bash
pytest service
```
Access the service from your browser:

http://localhost:8000

Build a Docker image:
```bash
docker build -t fasticule:$(git rev-parse --short HEAD) fasticule:latest .
```
Run a corresponding container:
```bash
docker run --rm -it -p 8001:8001 fasticule
```
Access the Dockerized service from your browser:

http://localhost:8001

## Challenges

Select any 2 of the following 3 challenges. Once a challenge is completed, commit it with an appropriate comment so we can find your work. 

1. The service provides an http endpoint - use the provided self-signed certificate and key (in the `localhost-cert` directory) to create an https endoint for the service. Update the README to describe how to do this and how to test that it works.
1. By default, Docker containers run as root. Following the principle of least privilege, update the Dockerfile to run the service as a non-root user. 
1. Create a GitHub Actions workflow to build the docker image on each commit to the main branch. 

## Solution

1. Task 1 - To use the self signed certificate and key in the `localhost-cert` directory to create an https endpoint for the service.

    * Since we are using Uvicorn, I found that uvicorn provides commands that can locate and utilze the ssl keyfile and certfile. I have used these commands in the original uvicorn service reload statement to get the https endpoint running.

    * Updated Uvicorn Command to run use self signed certificate and key

    ```bash
    uvicorn --ssl-keyfile=./localhost-cert/key.pem --ssl-certfile ./localhost-cert/cert.pem --app-dir service main:service --reload
    ```

    ![Image 1 - Uvicorn command run](/screenshots/s1.png "Image 1 - Uvicorn command run")

    ![Image 2 - Service running on https](/screenshots/s2.png "Image 2 - Service running on https")

1. Task 2  - Run the docker service as a non-root user.

    * Initially, when the service is run without modifying the docker file, I ran the following command to check for the user -
    [docker exec -it [container_name] sh -c "whoami"] -> which gave the result as `root`.

    ![Image 3 - User before dockerfile update](/screenshots/s3.png "Image 3 - User before dockerfile update")

    * I modified the docker file to create a new group called "appusers" and created a user within it with the name "appuser".
    Before running the uvicorn main service, I added the USER appuser statement to run the service as the non root user.
    After buiding the docker file and running it with a different tag, to verify that the service is indeed being run as a non root user, i executed the same exec command again.

    ![Image 4 - User after updating dockerfile](/screenshots/s4.png "Image 4 - User after updating dockerfile")