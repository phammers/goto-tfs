param(
  [Parameter(Mandatory=$true)]
  [String]$study
)
function GetCollectionName {

    Param ([string]$studyName, [string] $tfsUrl)

    for (($i=2015); $i -lt (Get-Date).Year + 1; $i++){
       try{
           $url = Invoke-WebRequest "$tfsUrl/PROD$i/$study" -Method 'GET' -UseDefaultCredentials
           if ($url.StatusCode -eq 200){
             return "PROD$i"
           }
       }
       catch {}
    }

    return ""
}
$settings = Get-Content "$PSScriptRoot\settings.json" | ConvertFrom-Json
$study = $study.ToUpper().Trim()
$collectionName = GetCollectionName $study $settings.tfsUrl.Trim()
Set-Alias browser $settings.browserPath.Trim()
if($collectionName -eq "")
{
    Write-Host "Study $study does not exist in our tfs collections"
    return 1
}
browser "$($settings.tfsUrl.Trim())/$collectionName/$study"



