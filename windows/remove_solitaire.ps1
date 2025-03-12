$listOfApps = get-appxpackage
$appToRemove = $listOfApps | where-object {$_ -like "*Solitaire*"}
Remove-AppxPackage -package $appToRemove.packagefullname