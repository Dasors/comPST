# comPST
Simple PowerShell script to access COM Port.
The defaul configration can be edited in the file

After connect, use:
    Type ! to close and exit
    Type ESC to end process in terminal (like Ctrl+C)

Usage: ComPST.ps1 [option] [value] ...
  optional arguments:
    --help , -h : help command
	   -v : show COM port available
	   -p : set COM port
	   -b : set Baudrate
	   -d : set DataBits
	 Example:
	   ComPST.ps1
	   ComPST.ps1 -p COM3
	   ComPST.ps1 -p COM3 -b 115200
	   ComPST.ps1 -p COM3 -b 115200 -d 8
	 Empty [option] will use default values

