![image](https://github.com/user-attachments/assets/2c2a5e76-790e-4f08-b21b-0096a179ec4e)
![image](https://github.com/user-attachments/assets/44b4310d-e5af-4226-9b69-500a0d3df768)


# ShiftTracker-2.1
"New Simple Powershell- OSRS Blast Furnace / Cannon Ball -  Shift Tracker - Profit Tracker - Cost Tracker - Acc Managment ( Efficiency Tool )

SHIFT TRACKER -BF/CBZ - README & Instructions
Introduction:
SHIFT TRACKER -BF/CBZ is a PowerShell-based tool designed for managing shifts, accounts, and profit tracking. This script allows users to track their work shifts, including resources used, materials created, and profit generated. It also provides functionality for managing accounts, recording costs, and saving data logs to CSV and text files.

Prerequisites:
Windows PowerShell (Version 5.1 or above recommended).
Appropriate file permissions to read and write files in the specified directories.
Configuration:
The script contains configuration settings at the beginning, where files are saved:

powershell
Copy code
$script:logPath = "C:\Users\cash\Documents\SHIFT TRACKER SAVE LOGS"
Make sure this directory exists or change the $script:logPath variable to a valid directory.

Key Features:
Shift Management:

Start and end shifts, log the time worked, and record profit and resources used.
Keeps a history of shift logs.
Calculates and logs the total profit for all shifts.
Account Management:

Add new accounts, view existing accounts.
Accounts are saved securely in XML format.
Cost Tracking:

Record costs and reason for expenses, and subtract them from the total profit.
View cost history with the reason and remaining profit.
Data Storage:

Saves all shift logs, profit logs, account details, and cost records in CSV or XML files.
Export shift data to a Notepad-friendly format for easy viewing.
Clear Logs:

Clear shift logs, account logs, cost logs, or total profit when needed.
Menu Navigation:

Easy-to-navigate menu for all functionalities.
Interactive prompts for input.
Step-by-Step Instructions:
1. Setting Up the Script:
Clone or download the script and save it as SHIFT_TRACKER.ps1.
Ensure that the directory specified in $script:logPath exists, or change the path to a folder of your choice.
Open PowerShell as Administrator and navigate to the folder where the script is located.
Run the script using the following command:
powershell
Copy code
.\SHIFT_TRACKER.ps1
2. Using the Application:
The main menu will appear with the following options:

text
Copy code
1. Start Shift
2. End Shift
3. Add Account
4. Show Shift History
5. Show Total Profit
6. Show All Accounts
7. Record Cost
8. Show Cost History
9. Clear Logs
10. Save All Data
11. Exit
3. Starting and Ending a Shift:
Start a Shift:

Select option 1 to start a new shift.
Enter the shift details such as the shift date, number, coal used, iron ore used, and steel bars used.
End a Shift:

After starting a shift, select option 2 to end it.
You will be prompted to enter the number of steel bars created, cannonballs created, and profit generated during the shift.
The shift will be logged, and the total profit will be updated.
4. Managing Accounts:
Add Account:
Select option 3 to add a new account.
You’ll be asked for the username, password, and account name.
Show All Accounts:
Select option 6 to view all saved accounts.
5. Recording Costs:
Record Costs:
Select option 7 to record costs (e.g., materials or expenses).
Provide the amount and reason for the expense.
View Cost History:
Select option 8 to view the cost history and remaining profit.
6. Saving and Clearing Data:
Save All Data:

Select option 10 to save all shift data, profit, and account details to a text file.
Clear Logs:

Select option 9 to clear logs (shift logs, account logs, cost logs, or reset total profit).
7. Viewing Shift History & Profit:
View Shift History:
Select option 4 to view the detailed shift logs (including date, start/end times, resources used, and profit).
View Total Profit:
Select option 5 to view the total profit accumulated across all shifts.
File Locations:
Shift Logs: Saved as ShiftLogs.csv.
Profit Logs: Saved as ProfitLogs.csv.
Account Details: Saved in an encrypted XML file (Accounts.xml).
Costs: Saved as CostLogs.csv.
Notepad Data: Saved as ShiftTrackerData.txt.
Customization:
Modify $script:logPath if you want to change the directory where logs and data are stored.
The script supports CSV and XML for storing shift logs, profit, account information, and costs.
Troubleshooting:
Missing Files: If certain log files are missing, the script will automatically create them as long as the directory exists.
Permission Issues: Ensure PowerShell has appropriate permissions to read/write files in the target directory.
Exit:
To exit the application, select option 11.
Enjoy tracking your shifts and managing profits
