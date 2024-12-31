# Configuration settings
$script:logPath = "C:\Users\cash\Documents\SHIFT TRACKER SAVE LOGS"
$script:shiftLogFile = Join-Path $logPath "ShiftLogs.csv"
$script:profitLogFile = Join-Path $logPath "ProfitLogs.csv"
$script:accountFile = Join-Path $logPath "Accounts.xml"
$script:notepadFile = Join-Path $logPath "ShiftTrackerData.txt"
$script:costLogFile = Join-Path $logPath "CostLogs.csv"

# Initialize global variables
$global:totalProfit = 0.00
$global:shifts = @()

# Ensure log directory exists
if (!(Test-Path $logPath)) { 
    New-Item -ItemType Directory -Path $logPath | Out-Null 
}

# Class definitions
class Shift {
    [datetime]$StartTime
    [datetime]$EndTime
    [timespan]$Duration
    [string]$ShiftDate
    [int]$ShiftNumber
    [array]$AccountsUsed
    [int]$CoalUsed
    [int]$IronOreUsed
    [int]$SteelBarsUsed
    [int]$SteelBarsCreated
    [int]$CannonballsCreated
    [decimal]$Profit
}

# Account Management Functions
function Add-Account {
    Write-Host "=== Add New Account ==="
    $username = Read-Host "Enter Username"
    $password = Read-Host "Enter Password" -AsSecureString
    $name = Read-Host "Enter Account Name"

    $account = [PSCustomObject]@{
        Username = $username
        Password = $password
        Name = $name
    }

    $accounts = Get-Accounts
    $accounts += $account
    $accounts | Export-Clixml -Path $script:accountFile
    Write-Host "Account added successfully." -ForegroundColor Green
    Pause
}

function Get-Accounts {
    if (Test-Path $script:accountFile) {
        try {
            $accounts = Import-Clixml -Path $script:accountFile
            return $accounts
        } catch {
            Write-Host "Error loading accounts: $_" -ForegroundColor Red
            return @()
        }
    } else {
        return @()
    }
}

function Show-AllAccounts {
    Write-Host "=== All Accounts ==="
    $accounts = Get-Accounts
    if ($accounts.Count -eq 0) {
        Write-Host "No accounts found." -ForegroundColor Yellow
    } else {
        $accounts | Format-Table -Property Username, Name -AutoSize
    }
    Pause
}

# Shift Management Functions
function Start-Shift {
    Write-Host "=== Start New Shift ==="
    $shift = New-Object Shift
    $shift.ShiftDate = Read-Host "Enter Shift Date (YYYY-MM-DD)"
    $shift.ShiftNumber = [int](Read-Host "Enter Shift Number")
    $shift.StartTime = Get-Date

    $accounts = Get-Accounts
    if ($accounts.Count -gt 0) {
        $shift.AccountsUsed = @($accounts[0])
    } else {
        Write-Host "No accounts available. Proceeding without account." -ForegroundColor Yellow
    }

    $shift.CoalUsed = [int](Read-Host "Enter Coal Used")
    $shift.IronOreUsed = [int](Read-Host "Enter Iron Ore Used")
    $shift.SteelBarsUsed = [int](Read-Host "Enter Steel Bars Used")
    
    return $shift
}

function End-Shift {
    param(
        [Shift]$shift
    )
    $shift.EndTime = Get-Date
    $shift.Duration = New-TimeSpan -Start $shift.StartTime -End $shift.EndTime

    $shift.SteelBarsCreated = [int](Read-Host "Enter Steel Bars Created")
    $shift.CannonballsCreated = [int](Read-Host "Enter Cannonballs Created")
    $shift.Profit = [decimal](Read-Host "Enter Profit")

    $global:totalProfit += $shift.Profit
    $global:shifts += $shift
    Save-ShiftData
    Log-Shift $shift

    Write-Host "Shift ended and logged successfully." -ForegroundColor Green
    Pause
}

function Log-Shift {
    param(
        [Shift]$shift
    )

    $logEntry = [PSCustomObject]@{
        ShiftDate = $shift.ShiftDate
        ShiftNumber = $shift.ShiftNumber
        StartTime = $shift.StartTime
        EndTime = $shift.EndTime
        Duration = $shift.Duration
        CoalUsed = $shift.CoalUsed
        IronOreUsed = $shift.IronOreUsed
        SteelBarsUsed = $shift.SteelBarsUsed
        SteelBarsCreated = $shift.SteelBarsCreated
        CannonballsCreated = $shift.CannonballsCreated
        Profit = $shift.Profit
        AccountsUsed = ($shift.AccountsUsed | ForEach-Object {$_.Name}) -join ";"
    }

    $logEntry | Export-Csv $script:shiftLogFile -Append -NoTypeInformation
}

function Save-ShiftData {
    $global:shifts | Select-Object ShiftDate, ShiftNumber, Profit | Export-Csv $script:profitLogFile -Append -NoTypeInformation
}

function Show-ShiftHistory {
    Write-Host "=== Shift History ==="
    if (Test-Path $script:shiftLogFile) {
        $shiftHistory = Import-Csv $script:shiftLogFile
        if ($shiftHistory.Count -eq 0) {
            Write-Host "No shift logs found." -ForegroundColor Yellow
        } else {
            $shiftHistory | Format-Table -Property ShiftDate, ShiftNumber, StartTime, EndTime, Duration, CoalUsed, IronOreUsed, SteelBarsUsed, SteelBarsCreated, CannonballsCreated, Profit, AccountsUsed -AutoSize
        }
    } else {
        Write-Host "No shift logs found." -ForegroundColor Yellow
    }
    Pause
}

# Cost Management Functions
function Record-Cost {
    param (
        [Parameter(Mandatory=$true)]
        [decimal]$Amount,
        [Parameter(Mandatory=$true)]
        [string]$Reason
    )

    # Update the global total profit by subtracting the cost
    $global:totalProfit = $global:totalProfit - $Amount
    
    $costEntry = [PSCustomObject]@{
        Date = (Get-Date).ToString("yyyy-MM-dd")
        Time = (Get-Date).ToString("HH:mm:ss")
        Amount = $Amount
        Reason = $Reason
        RemainingProfit = $global:totalProfit
    }
    
    $costEntry | Export-Csv $script:costLogFile -Append -NoTypeInformation
    
    Write-Host "Cost of $$Amount recorded for: $Reason" -ForegroundColor Green
    Write-Host "New total profit: $$global:totalProfit" -ForegroundColor Cyan
}

function Show-CostHistory {
    Write-Host "=== Cost History ===" -ForegroundColor Yellow
    
    if (Test-Path $script:costLogFile) {
        $costHistory = Import-Csv $script:costLogFile
        if ($costHistory.Count -eq 0) {
            Write-Host "No cost logs found." -ForegroundColor Yellow
        } else {
            $costHistory | Format-Table -Property Date, Time, Amount, Reason, RemainingProfit -AutoSize
        }
    } else {
        Write-Host "No cost logs found." -ForegroundColor Yellow
    }
    Pause
}

# Data Management Functions
function Show-TotalProfit {
    Write-Host "Total Profit: $($global:totalProfit)" -ForegroundColor Cyan
    Pause
}

function Save-AllData {
    Write-Host "Saving all data to Notepad file..." -ForegroundColor Cyan
    
    $notepadContent = ""
    $notepadContent += "=== Shift History ===`r`n"
    $global:shifts | ForEach-Object {
        $notepadContent += "Shift Date: $($_.ShiftDate), Shift Number: $($_.ShiftNumber), Start Time: $($_.StartTime), End Time: $($_.EndTime), Duration: $($_.Duration), Coal Used: $($_.CoalUsed), Iron Ore Used: $($_.IronOreUsed), Steel Bars Used: $($_.SteelBarsUsed), Steel Bars Created: $($_.SteelBarsCreated), Cannonballs Created: $($_.CannonballsCreated), Profit: $($_.Profit), Accounts Used: $($_.AccountsUsed -join ', ')`r`n"
    }

    $notepadContent += "`r`n=== Total Profit ===`r`nTotal Profit: $($global:totalProfit)`r`n"

    $notepadContent += "`r`n=== Accounts ===`r`n"
    $accounts = Get-Accounts
    $accounts | ForEach-Object {
        $notepadContent += "Username: $($_.Username), Account Name: $($_.Name)`r`n"
    }

    $notepadContent | Out-File -FilePath $script:notepadFile -Force

    Write-Host "All data saved successfully to Notepad file." -ForegroundColor Green
    Pause
}

# Clear Functions
function Clear-ShiftLogs {
    if (Test-Path $script:shiftLogFile) {
        Remove-Item $script:shiftLogFile
        Write-Host "Shift logs have been cleared." -ForegroundColor Green
    } else {
        Write-Host "No shift logs found to clear." -ForegroundColor Yellow
    }
    Pause
}

function Clear-AccountLogs {
    if (Test-Path $script:accountFile) {
        Remove-Item $script:accountFile
        Write-Host "Account logs have been cleared." -ForegroundColor Green
    } else {
        Write-Host "No account logs found to clear." -ForegroundColor Yellow
    }
    Pause
}

function Clear-CostLogs {
    if (Test-Path $script:costLogFile) {
        Remove-Item $script:costLogFile
        Write-Host "Cost logs have been cleared." -ForegroundColor Green
    } else {
        Write-Host "No cost logs found to clear." -ForegroundColor Yellow
    }
    Pause
}

function Clear-TotalProfit {
    $global:totalProfit = 0.00
    Write-Host "Total profit has been cleared." -ForegroundColor Green
    Pause
}

# Main Menu
function Main-Menu {
    while ($true) {
        Clear-Host
        Write-Host "=== Shift Tracker ===" -ForegroundColor Blue
        Write-Host "1. Start Shift"
        Write-Host "2. End Shift"
        Write-Host "3. Add Account"
        Write-Host "4. Show Shift History"
        Write-Host "5. Show Total Profit"
        Write-Host "6. Show All Accounts"
        Write-Host "7. Record Cost"
        Write-Host "8. Show Cost History"
        Write-Host "9. Clear Logs"
        Write-Host "10. Save All Data"
        Write-Host "11. Exit"

        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            "1" { $currentShift = Start-Shift }
            "2" { 
                if ($currentShift) { 
                    End-Shift $currentShift 
                } else { 
                    Write-Host "No shift started." -ForegroundColor Red 
                } 
            }
            "3" { Add-Account }
            "4" { Show-ShiftHistory }
            "5" { Show-TotalProfit }
            "6" { Show-AllAccounts }
            "7" { 
                $amount = [decimal](Read-Host "Enter cost amount")
                $reason = Read-Host "Enter reason for cost"
                Record-Cost -Amount $amount -Reason $reason
            }
            "8" { Show-CostHistory }
            "9" {
                Clear-Host
                Write-Host "=== Clear Logs ===" -ForegroundColor Yellow
                Write-Host "1. Clear Shift Logs"
                Write-Host "2. Clear Account Logs"
                Write-Host "3. Clear Cost Logs"
                Write-Host "4. Clear Total Profit"
                Write-Host "5. Back to Main Menu"
                
                $clearChoice = Read-Host "Enter your choice"
                switch ($clearChoice) {
                    "1" { Clear-ShiftLogs }
                    "2" { Clear-AccountLogs }
                    "3" { Clear-CostLogs }
                    "4" { Clear-TotalProfit }
                    "5" { continue }
                    default { Write-Host "Invalid option." -ForegroundColor Red }
                }
            }
            "10" { Save-AllData }
            "11" { break }
            default { Write-Host "Invalid option. Please try again." -ForegroundColor Red }
        }
    }
}

# Start the application
Main-Menu