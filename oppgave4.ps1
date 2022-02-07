[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $urlkortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'

$response = Invoke-WebRequest -Uri $urlkortstokk

$cards = $response.Content | ConvertFrom-Json

$kortstokk = @()
foreach ($card in $cards) {
	$kortstokk = $kortstokk + ($card.suit[0] + $card.value + ",")
}

Write-host "Kortstokk: $kortstokk"
