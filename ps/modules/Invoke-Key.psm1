function Invoke-Key {
	param(
			[Parameter(mandatory=$true, position=0)]
			[ValidateSet("CAPSLOCK","SCROLLLOCK","NUMLOCK")]
			$Key
	     )



		$KeyBoardObject = New-Object -ComObject WScript.Shell
		$KeyBoardObject.SendKeys("{$Key}")
}
