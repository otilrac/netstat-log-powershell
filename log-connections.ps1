function Write-Stat([object]$fs, [string]$value)
{
    $current = get-date
    $line = $current.ToString().PadRight(24)
    $line += $value.ToString().PadLeft(5)
    write-host $line -ForegroundColor yellow

    $fs.WriteLine($line)
}

function Write-Header([object]$fs)
{
    $line = 'Time'.PadRight(24) + 'Active TCP'
    write-host $line
    $fs.WriteLine($line)
}

# open file
$path = (get-item -path ".\netstat.log").FullName
$fs = [System.IO.StreamWriter] $path

# just headers
write-header($fs)

# set interval and timeout
$timeout = new-timespan -seconds 10
$timer = [diagnostics.stopwatch]::StartNew()

# logging..
while ($timer.elapsed -lt $timeout){
    $activeTcp = (netstat -ano | select-string 'TCP')
    # $listening = $activeTcp | select-string 'listening'
    # $wait = $activeTcp | select-string '_wait'

    write-stat $fs $activeTcp.count
    start-sleep -seconds 5
}

$fs.close()
write-host "Done"