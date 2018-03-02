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

    [parameter(Mandatory=$false)] [String]$Token = "",

    [parameter(Mandatory=$false)]
    [ValidateSet("Get","Put","Patch")] [String]$HTTPmethod = "Get",

    [parameter(Mandatory=$false)]
    [String]$HTTPbody
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

    #debug
    #$MyInvocation.BoundParameters

    ###write-host $RequestUrl
    #Invoke-WebRequest -Method Get -Uri $RequestUrl
    if ($HTTPbody) {
        $resp = Invoke-WebRequest -Method $HTTPmethod -Uri $RequestUrl -Headers $headers -ContentType "application/json" -Body ([System.Text.Encoding]::UTF8.GetBytes($HTTPbody))
    }
    else {
        $resp = Invoke-WebRequest -Method $HTTPmethod -Uri $RequestUrl -Headers $headers -ContentType "application/json"
    }
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

function Get-NetBoxIPaddress{
 
    Param(
    [parameter(Mandatory=$false,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("(^http(s)?://.*)?")] [String]$BaseUrl,
    
    [parameter(Mandatory=$false)] [String]$Token = "",
    [parameter(Mandatory=$false)] [int]$id = 0,
    [parameter(Mandatory=$false)] [String]$AddressMask = ""
    #[parameter(Mandatory=$false)] [String]$slug = ""
    )
 
    if ($BaseUrl -ne "") {
        $url = "/api/ipam/ip-addresses"
    }
    else {
        $url = "/ipam/ip-addresses"
    }
    
    if ($id -ne 0) {
        $url += "/$id"
    }

    $query =@{}
    if ($slug -ne "") {$query.Add("slug",$slug)}

    if ($query.Count -ge 1) {$url += '?' + (($query.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join '&')}

    $r = Make-NetBoxRequest -Url $url -BaseUrl $BaseUrl -Token $Token -HTTPmethod Get

    if ($AddressMask -ne "") {
        
    }

 
    return $r
 
}

function Set-NetBoxIPaddress{
 
    Param(
    [parameter(Mandatory=$false,
    HelpMessage="Enter NetBox server name or IP with http:// or https:// prefix")]
    [ValidatePattern("(^http(s)?://.*)?")] [String]$BaseUrl,
    
    [parameter(Mandatory=$false)] [String]$Token = "",
    [parameter(Mandatory=$true)] [int]$id,
    [parameter(Mandatory=$false)] [String]$Description,
    [parameter(Mandatory=$false)] [int]$Status = 0
    #[parameter(Mandatory=$false)] [String]$slug = ""
    )
 
    if ($BaseUrl -ne "") {
        $url = "/api/ipam/ip-addresses"
    }
    else {
        $url = "/ipam/ip-addresses"
    }
    
    $url += "/$id/"

    $ip = @{
        id = $id
    }

    if ($PSBoundParameters.ContainsKey('Description')) {$ip.add("description",$Description)}
    if ($Status -ne 0) {$ip.add("status",$Status)}

    #$query =@{}
    #if ($slug -ne "") {$query.Add("slug",$slug)}

    #if ($query.Count -ge 1) {$url += '?' + (($query.GetEnumerator() | % { "$($_.Key)=$($_.Value)" }) -join '&')}

    $r = Make-NetBoxRequest -Url $url -BaseUrl $BaseUrl -Token $Token -HTTPmethod Patch -HTTPbody ($ip | ConvertTo-Json)
 
    return $r
 
}



Export-ModuleMember -Function Connect-*,Get-*,Set-*