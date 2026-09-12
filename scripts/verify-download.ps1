param(
  [Parameter(Mandatory=$true)][string]$ZipPath,
  [Parameter(Mandatory=$true)][string]$ExpectedSha256
)
$actual = (Get-FileHash -Path $ZipPath -Algorithm SHA256).Hash.ToLower()
$expected = $ExpectedSha256.ToLower()
if ($actual -eq $expected) {
  Write-Host "OK: SHA256 match $actual"
} else {
  Write-Error "FAIL: expected $expected but got $actual"
  exit 1
}
