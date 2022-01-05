# Credit Guy Leech (@guyrleech) https://twitter.com/guyrleech/status/1478773221642186757?ref_src=twsrc%5Etfw January 5, 2022
# A PowerShell one liner that displays CPU usage in a manner similar to the Linux utility "top"
while($true) { cls ; '' ; ps |sort cpu -Descending|select -first 20 |ft -auto; Start-Sleep -Milliseconds 500 }
