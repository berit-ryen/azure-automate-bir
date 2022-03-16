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
 


function kortstokkprint {
    param (
        [Parameter()]
        [object[]]
        $cards
    )   

# Skriver ut kortsktokk
$kortstokk = @()
foreach ($card in $cards) {
	$kortstokk += ($card.suit[0] + $card.value)
}
$kortstokk
}

Write-host "Kortstokk: $(kortstokkprint($cards))"
Write-Host "Poengsum (kortstokkprint): $sum"

##
function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($card in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($card.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $card.value }
        }
    }
    return $poengKortstokk
}

Write-Output "Poengsum (sumPoengkortstokk): $(sumPoengKortstokk -kortstokk $kortstokk)"
#
#


$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-Host "Meg: $(kortstokkprint - $meg)"
Write-Host "Magnus: $(kortstokkprint -kortstokk $magnus)"
Write-Host "Kortstokk: $(kortstokkprint -kortstokk $cards)"

# ...

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(kortstokkprint -kortstokk $kortStokkMagnus) | $(kortstokkprint -kortstokk $kortStokkMagnus)"            
    Write-Output "meg    | $(kortstokkprint -kortstokk $kortStokkMeg) | $(kortstokkprint -kortstokk $kortStokkMeg)"

}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if ((kortstokkprint -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((kortstokkprint -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

# Hva er om begge har blackjack? Kanskje det kalles draw?
# frivillig - kan du endre koden til å ta hensyn til draw?

