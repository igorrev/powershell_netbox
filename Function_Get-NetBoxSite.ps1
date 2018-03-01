function Get-NetBoxSite{
 
    Param(
    [parameter(Mandatory=$false,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("^http(s)?://.*")] [String]$BaseUrl,
    
    [parameter(Mandatory=$false)] [String]$Token = "",
    [parameter(Mandatory=$false)] [int]$id = 0,
    [parameter(Mandatory=$false)] [String]$slug = ""
    )
 
    # $global:NetBoxBaseUrl = $BaseUrl + "/api"
    # $global:NetBoxApiToken = $Token
    if ($Token -eq "") {
        $Token = $global:NetBoxApiToken
    }
    
    if ($Token -ne "") {
        $headers = @{
            Authorization = "Token $Token"
        }
    }

    if ($BaseUrl -ne "") {
        $url = $BaseUrl + "/api/dcim/sites"
    }
    else {
        $url = $global:NetBoxBaseUrl + "/dcim/sites"
    }

    if ($id -ne 0) {
        $url += "/$id"
    }

    $query =@{}
    if ($slug -ne "") {$query.Add("slug",$slug)}

    if ($query.Count -ge 1) {$url += '?' + (($query.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join '&')}


    #$resp = Invoke-RestMethod -Method Get -Uri $url
    $resp = Invoke-WebRequest -Method Get -Uri $url
    $r=([system.Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray()) | ConvertFrom-Json)

    if ( $r.count -gt 0) {
       $r=$r.results
    }
 
    return $r
 
}