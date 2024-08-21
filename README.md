Script MDECheckStatus.ps1 contain menù that permit you to check status of MDE in Endpoint:
+===============================================+
|  Check Microsoft Defender for Endpoint        | 
+===============================================+
|                                               |
|    1) Verify Tamper Protection State          |
|    2) Check if MDE Module is Installed        |
|    3) MDE Client Analyzer                     |
|    4) Verify MDE Is Oboarded into Tenant      |
|    5) Check ForcePassive Mode RegKey          |
|    6) EXIT                                    |
+===============================================+
1 Verify is tamper protection is active on your device
2 Verify if Module to manage is installed on device, and is not you can install it directly from the script
3 Run MDE Client Analyzer directly from the script (you can choose path to download)
4 Verify is MDE is onboarded into M365 Tenant
5 Check if presente regkey to Force Passive Mode into Endpoint, if present script set it to 0
6 Exit from Menù

After All choise you need to wait 5 second.

You use script as is and is your responsability to use this script in all enviorment.
