function Add-NewEmptyFile {
    param ([parameter(Position = 0)][string] $Filename)
    New-Item -ItemType file $Filename
}