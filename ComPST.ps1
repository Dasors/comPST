# Created by: Danilo A Oliveira
# Date: 22 October 2021
# Version: 1.0.0

# ========================= DEFAULT CONFIG =========================================
$baudrate = 115200
$comport = "COM3"
$DataBits = 8
# ========================= FUNCTIONS ==============================================

function read-com {
	try{
		$line = $port.ReadExisting()
		if($line)
		{
    		Write-Host -NoNewline $line # Do stuff here
		}
	}
	catch [System.Exception]
	{
	}
}

function read-console {
	if([Console]::KeyAvailable)
	{
	    $key = [Console]::ReadKey($true)
		$char = $key.KeyChar
		# Use "!" to close port and exit
		if($char -eq "!")
		{
			$port.Close()
			Write-Host "--> Port closed"
		}
		#ESC is send like Ctrl+C to end process in terminal
		elseif($char -eq [char]27)
		{
			$port.Write([char]3)
		}
		else
		{	
			$port.Write($char)
		}
	}
}

function main-process {
	$port= new-Object System.IO.Ports.SerialPort $comport,$baudrate,None,$DataBits,one

	try{
		$port.Open()
		Write-Host "--> Connection established " 
	}
	catch{
		Write-Host "--> Failed to connect!" 
		exit 1
	}

	do {
		read-com
		read-console
	}while ($port.IsOpen)
}

function help {
	Write-Host "=========================================================="
	Write-Host "------------------ COM POWERSHELL TERMINAL ---------------"
	Write-Host ""
	Write-Host " Usage: ComPST.ps1 [option] [value] ..."
	Write-Host " optional arguments:"
	Write-Host "   --help , -h : help command"
	Write-Host "   -v : show COM port available"
	Write-Host "   -p : set COM port"
	Write-Host "   -b : set Baudrate"
	Write-Host "   -d : set DataBits"
	Write-Host " Example: "
	Write-Host "   ComPST.ps1"
	Write-Host "   ComPST.ps1 -p COM3"
	Write-Host "   ComPST.ps1 -p COM3 -b 115200"
	Write-Host "   ComPST.ps1 -p COM3 -b 115200 -d 8"
	Write-Host " Empty [option] will use default values"
	Write-Host " Default Configuration:"
	Write-Host "-- Port:" $comport
	Write-Host "-- Baudrate:" $baudrate
	Write-Host "-- DataBits:"$DataBits
	exit 1
}

function vPorts {
	foreach ($item in [System.IO.Ports.SerialPort]::GetPortNames())
	{
		$proceed = $true
		Write-Host ("--> PortName " + $item)
	}
	exit 1
}

# =================================================================================

if (($args.Count -ne 0) -and ($args.Count -ne 1) -and ($args.Count -ne 2) -and ($args.Count -ne 4) -and ($args.Count -ne 6))
{
	Write-Host "Invalid inputs! Use --help for more info"
	exit 1
}

if ($args.Count -gt 0)
{
	if(($args[0] -eq "--help") -or ($args[0] -eq "-h"))
	{
		help
	}
	elseif($args[0] -eq "-v")
	{
		vPorts
	}
	else
	{
		for(($i = 0); $i -lt ($args.Count-1); $i++)
		{
			if($args[$i] -eq "-p")
			{
				$i++
				$comport = $args[$i]
			}
			elseif($args[$i] -eq "-b"){
				$i++
				$baudrate = $args[$i]
			}
			elseif($args[$i] -eq "-d"){
				$i++
				$DataBits = $args[$i]
			}
			else{
				Write-Host "Invalid inputs! Use --help for more info"
				exit 1
			}
		}
	}
}

Write-Host "=========================================================="
Write-Host "------------------ COM POWERSHELL TERMINAL ---------------"
Write-Host "-- Type ! to close and exit"
Write-Host "-- Type ESC to end process in terminal (like Ctrl+C)"
Write-Host "-- Port:" $comport
Write-Host "-- Baudrate:" $baudrate
Write-Host "-- DataBits:"$DataBits
Write-Host "=========================================================="
Write-Host ""

main-process

Write-Host "--> End "