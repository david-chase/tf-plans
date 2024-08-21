#-------------------------------------------------------------------
# PowerShell script to download recommendations in TerraForm format for an instance
#-------------------------------------------------------------------

param (
    [Parameter( Mandatory )]
    [string]$instance="",
    [string]$user="", 
    [string]$pass="",
    [string]$analysisId="",  
    [string]$cloud=""
)

$aClouds = @( "cloud/aws", "cloud/azure", "cloud/gcp", "containers/kubernetes" )

# Suss out the user instance, user name, and password
if( -not $user ) { $user = $env:DensifyUser }
if( -not $pass ) { $pass = $env:DensifyPass }
if( -not $instance ) { $instance = Read-Host -Prompt "Enter instance name" }
if( ( -not $user ) -or ( -not $pass ) ) { Write-Host; Write-Host "Note: To remember your Densify credentials you may set environment variables named DensifyUser and DensifyPass respectively"; Write-Host }
if( -not $user ) { $user = Read-Host -Prompt "Enter your Densify user id" }
if( -not $pass ) { $pass = Read-Host -Prompt "Enter your Densify password" }

# Instances can be specified as fully qualified or in short form.  If user specified it in short form, add the .densify.com part
# If they specified it in long form, just parse out the short form and store it in $sInstanceTitle.  We'll use this later
if( -not $instance.Contains( ".densify.com" ) ) {
    $sInstanceTitle = $instance
    $instance += ".densify.com" 
} # END if
else {
    $sInstanceTitle = $instance.Substring( 0, $instance.IndexOf( "." ) )
} # END else

#-------------------------------------------------------------------
# STEP 1 - Request an authentication token
#-------------------------------------------------------------------

# Start composing our REST request 
$hHeaders = @{
            "Accept"="application/json"
            "Content-Type"="application/json"
            }

$hBody = @{ 
    'userName'=$user 
    'pwd'=$pass 
    }

$sUri = "https://" + $instance + "/CIRBA/api/v2/authorize"
$oAuthToken = Invoke-RestMethod -Method Post -Uri $sUri -Headers $hHeaders -Body ( $hBody | ConvertTo-Json ) -ErrorAction Stop

#-------------------------------------------------------------------
# STEP 2 - If no analysisId was specified, output a list
#-------------------------------------------------------------------

# Start composing our REST request 
# Note that we now need to include our authorization token in the header
if( -not $analysisId ) {
    $aAnalyses = @()

    ForEach( $cloud in $aClouds ) {
        $sEndPoint = "/CIRBA/api/v2/analysis/" + $cloud

        $hHeaders = @{
                    "Authorization"= "Bearer " + $oAuthToken.apiToken
                    "Accept"="application/json"
                    }

        $sUri = "https://" + $instance + $sEndPoint
        $aResponse = ( Invoke-RestMethod -Method Get -Uri $sUri -Headers $hHeaders -ErrorAction Stop ) 

        $aAnalyses += $aResponse

    } # END ForEach( $cloud in $aClouds )

    $aAnalyses | Out-Host

    Exit
} # END if( -not $analysisId ) {
#-------------------------------------------------------------------
# STEP 3 - Download recommendations in Terraform format only for the analysis we specified
#-------------------------------------------------------------------

# Start composing our REST request 
# Notice that we are requesting our output in terraform-map format
$hHeaders = @{
            "Authorization"= "Bearer " + $oAuthToken.apiToken
            
			# Uncomment only one of the lines below that begins with "Accept=" depending on whether you want output in JSON or Terraform format.
            # "Accept"="application/json"
            "Accept"="application/terraform-map"
            }
ForEach( $cloud in $aClouds ) {
    $sEndPoint = "/CIRBA/api/v2/analysis/" + $cloud
    $sUri = "https://" + $instance + $sEndPoint + "/" + $analysisId + "/results"

    try { $aResponse = Invoke-RestMethod -Method Get -Uri $sUri -Headers $hHeaders -ErrorAction Stop } catch { $aResponse = @() }
    
    # If this cloud includes an analysisid that matches, output it
    if( $aResponse.Count ) {  
        Write-Output $aResponse
     }

} # END ForEach( $cloud in $aClouds )