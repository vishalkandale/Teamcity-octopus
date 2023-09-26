# Check if Terraform is already installed
$terraformInstalled = Test-Path -Path "$env:ProgramFiles\Terraform"

# If Terraform is not installed, download and install it
if (-Not $terraformInstalled) {
    Write-Host "Terraform is not installed. Installing..."
    
    # Define the Terraform version to install (you can change this to your desired version)
    $terraformVersion = "0.15.0"

    # Define the download URL for Terraform
    $terraformDownloadUrl = "https://releases.hashicorp.com/terraform/$terraformVersion/terraform_$terraformVersion.zip"

    # Define the installation directory
    $installDir = "$env:ProgramFiles\Terraform"

    # Create the installation directory if it doesn't exist
    if (-Not (Test-Path -Path $installDir)) {
        New-Item -Path $installDir -ItemType Directory -Force
    }

    # Download and extract Terraform
    Invoke-WebRequest -Uri $terraformDownloadUrl -OutFile "$env:TEMP\terraform.zip"
    Expand-Archive -Path "$env:TEMP\terraform.zip" -DestinationPath $installDir

    # Add Terraform to the system's PATH environment variable
    $env:Path += ";$installDir"
    
    Write-Host "Terraform $terraformVersion has been installed."
}

# Navigate to your Terraform configuration directory


terraform --version
