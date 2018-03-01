<#
Powershell module for NetBox DCIM and IPAM software
#>

function Make-NetBoxRequest{
Param(
    [parameter(Mandatory=$true, position=0)]
    [AllowEmptyString()]
    [String]$Url,

    [parameter(Mandatory=$false)]
    [AllowEmptyString()]
    [ValidatePattern("^(http(s)?://.*)?")] [String]$BaseUrl,

    [parameter(Mandatory=$false)] [String]$Token = ""
)
    
    if ($Token -eq "") {
        $Token = $global:NetBoxApiToken
    }
    
    if ($Token -ne "") {
        $headers = @{
            Authorization = "Token $Token"
        }
    }

    if ($BaseUrl -ne "") {
        $RequestUrl = $BaseUrl + $Url
    }
    else {
        $RequestUrl = $global:NetBoxBaseUrl + $Url
    }

    ###write-host $RequestUrl
    #Invoke-WebRequest -Method Get -Uri $RequestUrl
    $resp = Invoke-WebRequest -Method Get -Uri $RequestUrl
    $r=[system.Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray()) | ConvertFrom-Json

    if ($r.results.Count -gt 0) {
        $r = $r.results
    }

    return $r
}

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

    $r = Make-NetBoxRequest -Url ""
 
    return $r
 
}

function Get-NetBoxSite{
 
    Param(
    [parameter(Mandatory=$false,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("(^http(s)?://.*)?")] [String]$BaseUrl,
    
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
        #$url = $BaseUrl + "/api/dcim/sites"
        $url = "/api/dcim/sites"
    }
    else {
        #$url = $global:NetBoxBaseUrl + "/dcim/sites"
        $url = "/dcim/sites"
    }

    if ($id -ne 0) {
        $url += "/$id"
    }

    $query =@{}
    if ($slug -ne "") {$query.Add("slug",$slug)}

    if ($query.Count -ge 1) {$url += '?' + (($query.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join '&')}


    #$resp = Invoke-RestMethod -Method Get -Uri $url
    ###$resp = Invoke-WebRequest -Method Get -Uri $url
    ###$r=([system.Text.Encoding]::UTF8.GetString($resp.RawContentStream.ToArray()) | ConvertFrom-Json)

    $r = Make-NetBoxRequest -Url $url -BaseUrl $BaseUrl -Token $Token
 
    return $r
 
}

function Get-NetBoxRegion{
 
    Param(
    [parameter(Mandatory=$false,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("(^http(s)?://.*)?")] [String]$BaseUrl,
    
    [parameter(Mandatory=$false)] [String]$Token = "",
    [parameter(Mandatory=$false)] [int]$id = 0,
    [parameter(Mandatory=$false)] [String]$slug = ""
    )
 
    if ($BaseUrl -ne "") {
        $url = "/api/dcim/regions"
    }
    else {
        $url = "/dcim/regions"
    }
    
    if ($id -ne 0) {
        $url += "/$id"
    }

    $query =@{}
    if ($slug -ne "") {$query.Add("slug",$slug)}

    if ($query.Count -ge 1) {$url += '?' + (($query.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join '&')}

    $r = Make-NetBoxRequest -Url $url -BaseUrl $BaseUrl -Token $Token
 
    return $r
 
}

function Get-NetBoxRack{
 
    Param(
    [parameter(Mandatory=$false,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("(^http(s)?://.*)?")] [String]$BaseUrl,
    
    [parameter(Mandatory=$false)] [String]$Token = "",
    [parameter(Mandatory=$false)] [int]$id = 0,
    [parameter(Mandatory=$false)] [String]$slug = ""
    )
 
    if ($BaseUrl -ne "") {
        $url = "/api/dcim/racks"
    }
    else {
        $url = "/dcim/racks"
    }
    
    if ($id -ne 0) {
        $url += "/$id"
    }

    $query =@{}
    if ($slug -ne "") {$query.Add("slug",$slug)}

    if ($query.Count -ge 1) {$url += '?' + (($query.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join '&')}

    $r = Make-NetBoxRequest -Url $url -BaseUrl $BaseUrl -Token $Token
 
    return $r
 
}

Export-ModuleMember -Function Connect-*,Get-*