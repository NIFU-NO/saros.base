$Folders = Get-ChildItem C:\Users\py128\AppData\Local\Temp\Saros\21149_DU\_site\ -Directory -Recurse

ForEach ($Folder in $Folders)
{
    $wdFormatPDF = 17
    $word = New-Object -ComObject word.application
    $word.visible = $false
    $folderpath = "$($Folder.FullName)\*"
    $fileTypes = "*.docx"
    Get-ChildItem -path $folderpath -include $fileTypes |
    foreach-object `
    {
     $path =  ($_.fullname).substring(0,($_.FullName).lastindexOf("."))
     "Converting $path to pdf ..."
     $doc = $word.documents.open($_.fullname)
     $doc.saveas([ref] $path, [ref]$wdFormatPDF)
     $doc.close()
    }
    $word.Quit()
}