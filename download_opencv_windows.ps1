$tag = "4.10.0.20240612"
$version = "4100"
$uriArray = @(
    "https://github.com/wolfweb/opencv_files/releases/download/${tag}/opencv${version}_win_x64.zip"
    "https://github.com/wolfweb/opencv_files/releases/download/${tag}/opencv${version}_win_x86.zip"
)

function Download($uri, $outFile) {
    Write-Host "Downloading ${uri}"
    if (!(Test-Path $outFile)) {
        Invoke-WebRequest -Uri $uri -OutFile $outFile -ErrorAction Stop
    }
}

New-Item opencv_files -Type directory -Force -ErrorAction Stop | Out-Null
cd opencv_files

[Net.ServicePointManager]::SecurityProtocol = @([Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12)

foreach ($uri in $uriArray) {
    $outFile = [System.IO.Path]::GetFileName($uri)
    $outFileWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($uri)
    Download $uri $outFile
    Expand-Archive -Path $outFile -DestinationPath $outFileWithoutExtension -Force -ErrorAction Stop
    Remove-Item -Path $outFile -ErrorAction Stop
}

cd ..
