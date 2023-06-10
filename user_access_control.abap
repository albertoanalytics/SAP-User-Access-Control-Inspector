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