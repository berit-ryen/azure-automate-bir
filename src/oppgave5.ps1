[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $urlkortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'

$response = Invoke-WebRequest -Uri $urlkortstokk

$cards = $response.Content | ConvertFrom-Json

$sum = 0
foreach ($card in $cards) {
	$sum += switch ($card.value) 
    {
        'J' {10}
        'Q' {10}
        'K' {10}
        'A' {11}
        Default {$card.value}
    }  
}
 

# Skriver ut kortsktokk
$kortstokk = @()
foreach ($card in $cards) {
	$kortstokk = $kortstokk + ($card.suit[0] + $card.value + ",")
}

Write-host "Kortstokk: $kortstokk"
Write-Host "Poengsum: $sum"

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"