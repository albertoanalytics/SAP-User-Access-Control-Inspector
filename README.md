# SAP IT General Controls: User Access Control

This repository contains a simple ABAP report for inspecting user access controls in SAP systems, a critical aspect of IT General Controls. The report provides a list of users (excluding standard SAP system users) and their assigned roles.

## Table of Contents

1. [Project Description](#project-description)
2. [Script](#script)
3. [System Compatibility](#system-compatibility)
4. [Installation](#installation)
5. [Usage](#usage)
6. [References](#references)
7. [Contact Information](#contact-information)
8. [License](#license)

## Project Description

The provided ABAP report is part of a broader IT General Controls inspection process for SAP systems. IT General Controls are critical for ensuring the integrity, confidentiality, and availability of an organization's IT systems and data.

This ABAP report focuses on User Access Control, one of the key aspects of IT General Controls. It provides an overview of users and their assigned roles, which is crucial for monitoring access rights, detecting segregation of duties (SoD) conflicts, and maintaining system security.

[Return to Top](#sap-it-general-controls-user-access-control)

## Script

```abap
REPORT Z_USER_ACCESS_CONTROL.

* Declare internal table and structure for user data
TYPES: BEGIN OF ty_s_user_data,
         uname LIKE s_user_header-bname,
         fullname LIKE s_user_header-name_text,
       END OF ty_s_user_data.
DATA: lt_user_data TYPE TABLE OF ty_s_user_data,
      ls_user_data TYPE ty_s_user_data.

* Declare internal table and structure for user roles
TYPES: BEGIN OF ty_s_user_roles,
         uname LIKE s_user_auth-bname,
         rolename LIKE s_user_auth-agr_name,
       END OF ty_s_user_roles.
DATA: lt_user_roles TYPE TABLE OF ty_s_user_roles,
      ls_user_roles TYPE ty_s_user_roles.

* Select user data
SELECT bname name_text INTO CORRESPONDING FIELDS OF TABLE lt_user_data
  FROM s_user_header
  WHERE bname NOT LIKE 'SAP%' AND bname NOT LIKE 'DDIC' AND bname NOT LIKE 'EARLYWATCH'.
 
* Select user roles
SELECT bname agr_name INTO CORRESPONDING FIELDS OF TABLE lt_user_roles
  FOR ALL ENTRIES IN lt_user_data
  WHERE bname = lt_user_data-uname.

* Output user data and assigned roles
WRITE: 'User ID', 20 'Full Name', 50 'Role'.
SKIP.
LOOP AT lt_user_data INTO ls_user_data.
  WRITE: ls_user_data-uname, 20 ls_user_data-fullname.
  LOOP AT lt_user_roles INTO ls_user_roles WHERE uname = ls_user_data-uname.
    WRITE: 50 ls_user_roles-rolename.
    SKIP.
  ENDLOOP.
ENDLOOP.
```

[Return to Top](#sap-it-general-controls-user-access-control)

## System Compatibility

This script is not dependent on a specific SAP FI version or SAP system. It should work across various SAP systems, including SAP R/3, SAP ECC, and SAP S/4HANA, as long as the underlying data dictionary objects and structures (S_USER_HEADER and S_USER_AUTH) are available.

However, depending on your SAP system version, configuration, or customizations, some adjustments may be needed. Always test the script in a non-production environment before deploying it in a production system.

[Return to Top](#sap-it-general-controls-user-access-control)

## Installation

The script can be added to your

 SAP system using the ABAP development tools. Simply create a new ABAP report (or include the script in an existing report) and copy the provided code.

[Return to Top](#sap-it-general-controls-user-access-control)

## Usage

Execute the ABAP report using the transaction SE38 or your preferred method. The output will be a list of users and their assigned roles.

[Return to Top](#sap-it-general-controls-user-access-control)

## References

1. [SAP User Authorization Objects Explained](https://blogs.sap.com/2014/09/02/user-authorizations-objects-explained/)
2. [ABAP Programming (BC-ABA) | SAP Help Portal](https://help.sap.com/viewer/c238d694b825421f940829321ffa326a/7.5.11/en-US)

[Return to Top](#sap-it-general-controls-user-access-control)

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for license rights and limitations.

[Return to Top](#sap-it-general-controls-user-access-control)

## Contact Information

Please feel free to contact me if you have any questions or feedback:

- Name: Alberto F. Hernandez
- Email: ah8664383@gmail.com
- Linkedin: https://www.linkedin.com/in/albertoscode/

[Return to Top](#sap-it-general-controls-user-access-control)
