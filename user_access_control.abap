REPORT Z_USER_ACCESS_CONTROL.

* Declare constants for system users
CONSTANTS:
  c_system_user_sap TYPE s_user_header-bname VALUE 'SAP%',
  c_system_user_ddic TYPE s_user_header-bname VALUE 'DDIC',
  c_system_user_ewatch TYPE s_user_header-bname VALUE 'EARLYWATCH'.

* Declare types for user data
TYPES:
  BEGIN OF type_user,
    uname TYPE s_user_header-bname,
    fullname TYPE s_user_header-name_text,
  END OF type_user,
  tt_user_data TYPE STANDARD TABLE OF type_user WITH NON-UNIQUE KEY uname.

* Declare types for user roles
TYPES:
  BEGIN OF type_role,
    uname TYPE s_user_auth-bname,
    rolename TYPE s_user_auth-agr_name,
  END OF type_role,
  tt_user_roles TYPE HASHED TABLE OF type_role WITH UNIQUE KEY uname.

* Declare types for ALV output
TYPES: 
  BEGIN OF type_alv,
    uname TYPE s_user_header-bname,
    fullname TYPE s_user_header-name_text,
    rolename TYPE s_user_auth-agr_name,
  END OF type_alv,
  tt_alv TYPE TABLE OF type_alv WITH DEFAULT KEY.

DATA: lt_user_data TYPE tt_user_data,
      lt_user_roles TYPE tt_user_roles,
      lt_alv TYPE tt_alv.

* Select user data
SELECT bname name_text INTO TABLE @lt_user_data
  FROM s_user_header
  WHERE bname NOT LIKE @c_system_user_sap AND bname NOT LIKE @c_system_user_ddic AND bname NOT LIKE @c_system_user_ewatch.

* Check if users were found
IF sy-dbcnt = 0.
  WRITE: 'No users found!'.
  RETURN.
ENDIF.

* Select user roles
SELECT bname agr_name INTO TABLE @lt_user_roles
  FOR ALL ENTRIES IN @lt_user_data
  WHERE bname = @lt_user_data-uname.

* Check if roles were found
IF sy-dbcnt = 0.
  WRITE: 'No roles found for users!'.
  RETURN.
ENDIF.

* Combine user data and roles into a single table for ALV display
DATA(ls_user_data) = VALUE type_user( ).

LOOP AT lt_user_data INTO ls_user_data.
  DATA(ls_user_roles) = VALUE type_role( uname = ls_user_data-uname ).
  READ TABLE lt_user_roles WITH TABLE KEY uname = ls_user_data-uname INTO ls_user_roles.
  IF sy-subrc = 0.
    APPEND VALUE type_alv( uname = ls_user_data-uname fullname = ls_user_data-fullname rolename = ls_user_roles-rolename ) TO lt_alv.
  ENDIF.
ENDLOOP.

* Output user data and assigned roles using ALV
TRY.
    DATA(o_salv) = cl_salv_table=>factory( IMPORTING r_salv_table = o_salv CHANGING t_table = lt_alv ).
    o_salv->display( ).
  CATCH cx_salv_msg INTO DATA(lx_msg).
    WRITE: 'Error while creating ALV output!'.
    WRITE: / lx_msg->get_text( ).
ENDTRY.