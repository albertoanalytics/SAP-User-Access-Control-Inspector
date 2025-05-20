# SAP IT General Controls: User Access Control V3.0

This repository contains an enhanced ABAP report for inspecting user access controls in SAP systems, a critical part of IT General Controls. The report provides an Advanced List Viewer (ALV) display of users (excluding standard SAP system users) and their assigned roles.

## Table of Contents
1. [Project Description](#project-description)
2. [Script](#script)
3. [System Compatibility](#system-compatibility)
4. [Installation](#installation)
5. [Usage](#usage)
6. [References](#references)
7. [License](#license)

## Project Description
This ABAP report plays an integral role within the larger spectrum of the IT General Controls assessment procedure specifically designed for SAP systems. The quintessential role of IT General Controls is to fortify the organization's IT systems and data, ensuring their integrity, confidentiality, and availability, thus contributing to a resilient and secure technological environment.

Version 3.0 of the User Access Control ABAP report includes significant enhancements over the previous version. It now provides an Advanced List Viewer (ALV) display of users and their assigned roles, which aids in easy visualization and sorting of user access rights data. The report properly handles multiple roles per user and includes improved system user filtering for greater accuracy.

[Return to Top](#sap-it-general-controls-user-access-control-v30)

## Script
The provided script can be found in the repository. It includes improvements like:
- Constants for system users
- Optimized standard tables for handling multiple roles per user
- Comprehensive checks for user and role availability
- Enhanced column formatting for better readability
- ALV display of user data and assigned roles with proper titles and optimization

[Return to Top](#sap-it-general-controls-user-access-control-v20)

## System Compatibility
This script is not dependent on a specific SAP FI version or SAP system. It should work across various SAP systems, including SAP R/3, SAP ECC, and SAP S/4HANA, as long as the underlying data dictionary objects and structures (S_USER_HEADER and S_USER_AUTH) are available.

However, depending on your SAP system version, configuration, or customizations, some adjustments may be needed. Always test the script in a non-production environment before deploying it in a production system.

[Return to Top](#sap-it-general-controls-user-access-control-v20)

## Installation
The script can be added to your SAP system using the ABAP development tools. Simply create a new ABAP report (or include the script in an existing report) and copy the provided code.

1. Log in to your SAP system
2. Enter transaction code SE38
3. Create a new program with the name Z_USER_ACCESS_CONTROL
4. Paste the corrected code
5. Save and activate the program

[Return to Top](#sap-it-general-controls-user-access-control-v20)

## Usage
Execute the ABAP report using the transaction SE38 or your preferred method. The output will be an Advanced List Viewer (ALV) display of users and their assigned roles.

The ALV provides the following features:
- Optimized column widths for better readability
- Custom column titles
- Ability to sort and filter users and roles
- Export options to various formats (Excel, etc.)

[Return to Top](#sap-it-general-controls-user-access-control-v20)

## References
1. [SAP User Authorization Objects Explained](https://blogs.sap.com/2014/09/02/user-authorizations-objects-explained/)
2. [ABAP Programming (BC-ABA) | SAP Help Portal](https://help.sap.com/viewer/c238d694b825421f940829321ffa326a/7.5.11/en-US)

[Return to Top](#sap-it-general-controls-user-access-control-v20)

## License
This project is licensed under the terms of the MIT license. See the [LICENSE](License.txt) file for license rights and limitations.

[Return to Top](#sap-it-general-controls-user-access-control-v20)
