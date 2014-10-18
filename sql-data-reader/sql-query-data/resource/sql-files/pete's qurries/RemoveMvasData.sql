--Remove all PHs script from MVAS (CR schema)
 rollback;
  begin
 for i in (select constraint_name, table_name from user_constraints) LOOP
   execute immediate 'alter table '||i.table_name||' disable constraint '||i.constraint_name||' cascade';
 end loop;
  end;

  /
  truncate table PARTICIPANT_ELECTION_VENDOR;
  truncate table PARTICIPANT_ELECTION;
  truncate table PARTICIPANTDEFERRALS;
  truncate table PARTICIPANT_YTD_CONTRI_HIST;
  truncate table PARTICIPANT_YTD_CONTRI;
  truncate table PAYROLL_PRODUCT_SPLIT;
  truncate table PAYROLL_VENDOR_SPLIT;
  truncate table PAYROLL_INPUT;
  truncate table PAYROLL_PER_PAY_COMP;
  truncate table PAYROLL_HIST;
  truncate table TIAA_CONTRACT;
  truncate table isv_acct_enroll;
  truncate table HARDSHIP_SUSPENSION;
  truncate table ACCOUNTENROLLMENT;
  truncate table EMP_STATUS_HIST;
  truncate table CUSTOMER_DOCUMENT_DETAIL;
  truncate table CUSTOMER_DOCUMENT;
  truncate table EMPLOYER_CUSTOMER;
  truncate table LOCATION_CUSTOMER_PLAN;
  truncate table LOCATION_CUSTOMER;
  truncate table EMPLOYER_CUSTOMER;
  truncate table CLIENT_CUSTOMER;
  truncate table CUSTOMER_PREFS;
  truncate table BATCH_REPORT;
  truncate table LIMIT_FORECASTED_CONTRI;
  truncate table TIAA_OPENTOKEN;
  truncate table PAST_PARTICIPANT_YTD_CONTRI;
  truncate table address;
  truncate table CUSTOMER;
  truncate table Past_PYC_HIST_HEADER;
  truncate table PAST_PYC_HIST_DETAIL;
 
  begin
 for i in (select constraint_name
               , table_name
           FROM user_constraints
           START WITH r_constraint_name IS NULL
           CONNECT BY r_constraint_name = PRIOR constraint_name
           order by LEVEL
           ) LOOP
   execute immediate 'alter table '||i.table_name||' enable novalidate constraint '||i.constraint_name||'';
 end loop;
  end;
  /