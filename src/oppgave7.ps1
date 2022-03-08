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

Write-Output "Kortstokk: $(kortstokkprint($cards))"
Write-Output "Poengsum: $sum"

$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-Output "Meg: $(kortstokkprint($meg))"
Write-Output "Magnus: $(kortstokkprint($magnus))"
Write-Output "Kortstokk: $(kortstokkprint($cards))"

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
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortstokkprint -cards $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(kortstokkprint -cards $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}