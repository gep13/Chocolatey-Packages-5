import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL)'"
            "(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri 'https://elm-lang.org/install'

    $re  = "^https.+\/(\d+\.\d+(?:\.\d+)?)\/installer-for-windows\.exe$"
    $urls = @($download_page.Links | ? href -match $re | % { $_.href })

    $versionMatch = $urls[0] | Select-String -Pattern $re
    $version = $versionMatch.Matches[0].Groups[1].Value
    $url = $urls[0]

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update
