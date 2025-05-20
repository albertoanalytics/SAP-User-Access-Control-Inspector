REPORT Z_USER_ACCESS_CONTROL.

* Declare constants for system users
CONSTANTS:
  c_system_user_sap    TYPE s_user_header-bname VALUE 'SAP%',
  c_system_user_ddic   TYPE s_user_header-bname VALUE 'DDIC',
  c_system_user_ewatch TYPE s_user_header-bname VALUE 'EARLYWATCH'.

* Declare types for user data
TYPES:
  BEGIN OF type_user,
    uname    TYPE s_user_header-bname,
    fullname TYPE s_user_header-name_text,
  END OF type_user,
  tt_user_data TYPE STANDARD TABLE OF type_user WITH NON-UNIQUE KEY uname.

* Declare types for user roles - changed to STANDARD TABLE to allow multiple roles per user
TYPES:
  BEGIN OF type_role,
    uname    TYPE s_user_auth-bname,
    rolename TYPE s_user_auth-agr_name,
  END OF type_role,
  tt_user_roles TYPE STANDARD TABLE OF type_role WITH KEY uname rolename.

* Declare types for ALV output
TYPES: 
  BEGIN OF type_alv,
    uname    TYPE s_user_header-bname,
    fullname TYPE s_user_header-name_text,
    rolename TYPE s_user_auth-agr_name,
  END OF type_alv,
  tt_alv TYPE TABLE OF type_alv WITH DEFAULT KEY.

DATA: lt_user_data  TYPE tt_user_data,
      lt_user_roles TYPE tt_user_roles,
      lt_alv        TYPE tt_alv.

* Select user data
SELECT bname name_text INTO TABLE @lt_user_data
  FROM s_user_header
  WHERE bname NOT LIKE @c_system_user_sap 
    AND bname <> @c_system_user_ddic 
    AND bname <> @c_system_user_ewatch.

* Check if users were found
IF sy-dbcnt = 0.
  MESSAGE 'No users found!' TYPE 'I' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.

* Select user roles - allow multiple roles per user
SELECT bname agr_name INTO TABLE @lt_user_roles
  FROM s_user_auth
  FOR ALL ENTRIES IN @lt_user_data
  WHERE bname = @lt_user_data-uname.

* Check if roles were found
IF sy-dbcnt = 0.
  MESSAGE 'No roles found for users!' TYPE 'I' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.

* Combine user data and roles into a single table for ALV display - corrected logic for multiple roles
LOOP AT lt_user_data INTO DATA(ls_user_data).
  LOOP AT lt_user_roles INTO DATA(ls_user_roles) WHERE uname = ls_user_data-uname.
    APPEND VALUE type_alv( 
      uname    = ls_user_data-uname 
      fullname = ls_user_data-fullname 
      rolename = ls_user_roles-rolename 
    ) TO lt_alv.
  ENDLOOP.
ENDLOOP.

* Output user data and assigned roles using ALV
TRY.
    cl_salv_table=>factory(
      IMPORTING 
        r_salv_table = DATA(o_salv)
      CHANGING
        t_table      = lt_alv
    ).
    
    * Optimize column widths
    DATA(o_columns) = o_salv->get_columns( ).
    o_columns->set_optimize( ).
    
    * Set column titles
    DATA(o_column) = CAST cl_salv_column_table( o_columns->get_column( 'UNAME' ) ).
    o_column->set_short_text( 'User ID' ).
    o_column->set_medium_text( 'User ID' ).
    o_column->set_long_text( 'User ID' ).
    
    o_column = CAST cl_salv_column_table( o_columns->get_column( 'FULLNAME' ) ).
    o_column->set_short_text( 'Full Name' ).
    o_column->set_medium_text( 'User Full Name' ).
    o_column->set_long_text( 'User Full Name' ).
    
    o_column = CAST cl_salv_column_table( o_columns->get_column( 'ROLENAME' ) ).
    o_column->set_short_text( 'Role' ).
    o_column->set_medium_text( 'Role Name' ).
    o_column->set_long_text( 'SAP Role Name' ).
    
    * Display the ALV
    o_salv->display( ).
    
  CATCH cx_salv_msg INTO DATA(lx_msg).
    MESSAGE lx_msg->get_text( ) TYPE 'E'.
ENDTRY.