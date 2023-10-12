# Use an official Terraform image as the base image
FROM hashicorp/terraform:latest

# Copy your Terraform code into the container
COPY . /app

# Set the working directory to your Terraform code
WORKDIR /app

# Optionally, install any additional tools or dependencies
# RUN apt-get update && apt-get install -y some-package

# Define the entry point for your container
ENTRYPOINT [ "terraform" ]
