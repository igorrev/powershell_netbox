function Connect-NetBox{
 
    Param(
    [parameter(Mandatory=$true, position=0,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("^http(s)?://.*")] [String]$BaseUrl,
    
    [parameter(Mandatory=$false)] [String]$Token = ""
    )
 
 $global:NetBoxBaseUrl = $BaseUrl + "/api"
 $global:NetBoxApiToken = $Token

 if ($Token -ne "") {
    $headers = @{
        Authorization = "Token $global:NetBoxApiToken"
    }
 }

 #$resp = Invoke-RestMethod -Method Get -Uri $global:NetBoxBaseUrl
 $resp = Invoke-WebRequest -Method Get -Uri $global:NetBoxBaseUrl
 $r=([system.Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray()) | ConvertFrom-Json).results 
 
 return $r
 
}