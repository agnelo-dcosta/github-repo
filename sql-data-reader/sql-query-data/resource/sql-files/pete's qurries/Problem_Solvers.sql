--------------------------------------------------------------------------------
--Find a valid MVAS Login
select a2.* from adminaccount_backup a2 where a2.adminaccountid in (
select adminaccountid from (
select (
select count(*) from admin_group ag where ag.adminaccountid = aa.adminaccountid) as admin_count,
(select count(*) from capability_group cg) as capab_count,aa.adminaccountid from
ADMINACCOUNT_BACKUP AA)
where ENABLED = 'Y'
--and ADMIN_COUNT > CAPAB_COUNT/2
);

select * from adminaccount;

--For MVAS copy from gold box to get permissions back.
insert into admin_group 
select
  (select adminaccountid from adminaccount where username = 'mvas'),
  capability_group_id from admin_group where adminaccountid = (
    select adminaccountid as su_id from (
      select a2.* from adminaccount a2 where a2.adminaccountid in (
        select adminaccountid from (
          select
            (select count(*) from admin_group ag where ag.adminaccountid = aa.adminaccountid) as admin_count,
            (select count(*) from capability_group cg) as capab_count,
            aa.adminaccountid from adminaccount aa
        ) where admin_count > capab_count/2
      )
    ) where rownum = 1
  )
;


--------------------------------------------------------------------------------
--Fix Workflow Activity sequence exception for event systems
select WORKFLOWACTIVITY_WFAID_SEQ.NEXTVAL as SEQ, TAB1.MAX_TABLE_VAL, 
CASE WHEN WORKFLOWACTIVITY_WFAID_SEQ.NEXTVAL < TAB1.MAX_TABLE_VAL THEN concat('NO', WORKFLOWACTIVITY_WFAID_SEQ.NEXTVAL - TAB1.MAX_TABLE_VAL) ELSE 'YES' END Valid_ID from DUAL join
(select max(WORKFLOWACTIVITYID) as MAX_TABLE_VAL from WORKFLOWACTIVITY where WORKFLOWACTIVITYID is not null) TAB1 on 1=1;

select Address_Addressid_seq.NEXTVAL as SEQ, TAB1.MAX_TABLE_VAL, 
case when ADDRESS_ADDRESSID_SEQ.NEXTVAL < TAB1.MAX_TABLE_VAL then CONCAT('NO', ADDRESS_ADDRESSID_SEQ.NEXTVAL - TAB1.MAX_TABLE_VAL) else 'YES' end VALID_ID from DUAL join
(select max(Addressid) as MAX_TABLE_VAL from address) TAB1 on 1=1;

Alter sequence WORKFLOWACTIVITY_WFAID_SEQ INCREMENT BY 1;


select * from PURGETEMP;
truncate table WORKFLOWACTIVITY;
truncate table TBLWORKFLOWHEADERPROPERTY;
truncate table TBLJOBQUEUE;
truncate table WORKFLOWHEADER;

alter table "TBLWORKFLOWHEADERPROPERTY" add constraint "PK_TBLWORKFLOWHEADERPROPERTY" primary key ("WORKFLOWHEADERPROPERTYID") using index pctfree 10 initrans 2 maxtrans 255 compute statistics  storage(initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool default) tablespace "MVAS_SML01_DATA"  enable;
alter table "WORKFLOWACTIVITY" add constraint "PK_WORKFLOWACTIVITY" primary key ("WORKFLOWACTIVITYID") using index pctfree 10 initrans 2 maxtrans 255 compute statistics  storage(initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool default) tablespace "MVAS_SML01_DATA"  enable;
alter table "TBLJOBQUEUE" add constraint "PK_TBLJOBQUEUE" primary key ("TBLJOBQUEUE_ID") using index pctfree 10 initrans 2 maxtrans 255 compute statistics  storage(initial 65536 next 1048576 minextents 1 maxextents 2147483645 pctincrease 0 freelists 1 freelist groups 1 buffer_pool default) tablespace "MVAS_SML01_DATA"  enable;
ALTER TABLE "WORKFLOWHEADER" ADD CONSTRAINT "PK_WORKFLOWHEADER" PRIMARY KEY ("WORKFLOWID") USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT) TABLESPACE "MVAS_SML01_DATA"  ENABLE;

SQL DECLARE
 TYPE tabname IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
 l_tabname1   TABNAME;  l_tabname2   TABNAME; 
 i            NUMBER; j      NUMBER;
 l_rc         NUMBER;
 l_count      NUMBER;
 l_start      NUMBER; l_end  NUMBER;
 l_owner1     VARCHAR2(64);
 l_sql_num    NUMBER;
 l_sql_msg    VARCHAR2(200); 
 l_basetable NUMBER;
 l_arctable NUMBER;
 l_diff_count NUMBER;
 l_diff_count_before NUMBER;
 table_not_in_sync EXCEPTION;
 PRAGMA EXCEPTION_INIT(table_not_in_sync,-20140);
BEGIN
 l_rc := 9;     
 l_tabname1(1) := upper('workflowlog'); l_tabname1(2) := upper('workflowactivity');
 l_tabname1(3) := upper('tblworkflowheaderproperty'); l_tabname1(4) := upper('tbljobqueue');
 l_tabname1(5) := upper('workflowheader'); l_tabname1(6) := upper('workflow_process');
        l_tabname1(7) := upper('status_update');
 l_tabname2(1) := upper('workflowlog_arc'); l_tabname2(2) := upper('workflowactivity_arc');
 l_tabname2(3) := upper('tblworkflowheaderproperty_arc'); l_tabname2(4) := upper('tbljobqueue_arc');
 l_tabname2(5) := upper('workflowheader_arc'); l_tabname2(6) := upper('workflow_process_arc');
        l_tabname2(7) := upper('status_update_arc');
 l_start := 1;  l_end := 7;
 select count(*) into l_diff_count_before from purgetemp where insert_date LIKE (select SYSDATE FROM dual);
 select sys_context('USERENV','SESSION_USER') into l_owner1 from dual;
 FOR j IN l_start..l_end LOOP  
    select count(*) INTO l_basetable from user_tables where table_name = l_tabname1(j);
    select count(*) INTO l_arctable from user_tables where table_name = l_tabname2(j);
    IF l_basetable = 0 THEN
        Insert into purgetemp (owner,table_details,difference_type) VALUES (l_owner1, l_tabname1(j),'Table does not exist');
    ELSIF l_arctable = 0 THEN
        Insert into purgetemp (owner,table_details,difference_type) VALUES (l_owner1, l_tabname2(j),'Table does not exist');
    END IF;               
    Insert into purgetemp (owner,table_details,difference_type,column_name,data_type,data_length) 
        ((select l_owner1, 'IN mainTable:'||l_tabname1(j)||' NOT in ArchTable:'||l_tabname2(j),'tableStructure Diff',column_name,data_type,data_length 
        from user_tab_columns where table_name = l_tabname1(j)
        MINUS
        select l_owner1, 'IN mainTable:'||l_tabname1(j)||' NOT in ArchTable:'||l_tabname2(j),'tableStructure Diff',column_name,data_type,data_length
        from user_tab_columns where table_name = l_tabname2(j) and column_name <> 'ARC_DATE' )
        UNION ALL
        (select l_owner1, 'IN ArchTable:'||l_tabname2(j)||' NOT in MainTable:'||l_tabname1(j),'tableStructure Diff',column_name,data_type,data_length 
        from user_tab_columns where table_name = l_tabname2(j) and column_name <> 'ARC_DATE'
        MINUS
        select l_owner1, 'IN ArchTable:'||l_tabname2(j)||' NOT in MainTable:'||l_tabname1(j),'tableStructure Diff',column_name,data_type,data_length 
        from user_tab_columns where table_name = l_tabname1(j))
        );
    Insert into purgetemp(owner,table_details,child_table,difference_type,constraint_type)
        select l_owner1,'new FK added to base table:'|| substr(b.table_name,1,26), substr(a.table_name,1,26) as child_table ,'new FK in Base Table, not in arc','R' as text
        from user_constraints a, user_constraints b where a.constraint_type = 'R' and a.r_owner = b.owner and a.r_constraint_name = b.constraint_name 
        and b.table_name = l_tabname1(j)
        minus
        select l_owner1,'new FK added to base table:'|| substr(b.table_name,1,instr(b.table_name,'_ARC')-1),substr(a.table_name,1,instr(a.table_name,'_ARC')-1) as child_table,
        'new FK in Base Table, not in arc' as text,'R'
        from user_constraints a, user_constraints b  where a.constraint_type = 'R' and a.r_owner = b.owner and a.r_constraint_name = b.constraint_name  
        and b.table_name =l_tabname2(j);     
    Insert into purgetemp(owner,table_details,child_table,difference_type,constraint_type)      
        select l_owner1,'existing FK dropped from Parent table:'|| substr(b.table_name,1,instr(b.table_name,'_ARC')-1) parent_table,substr(a.table_name,1,instr(a.table_name,'_ARC')-1) child_table,
        'FK in Child Arc Table, not in Main' as text,'R' from user_constraints a, user_constraints b       
        where a.constraint_type = 'R' and a.r_owner = b.owner and a.r_constraint_name = b.constraint_name 
        and b.table_name =l_tabname2(j)
        minus
        select l_owner1,'existing FK dropped from Parent table:'||substr(b.table_name,1,26) parent_table,substr(a.table_name,1,26) child_table ,
        'FK in Child Arc Table, not in Main','R' as text from user_constraints a, user_constraints b
        where a.constraint_type = 'R' and a.r_owner = b.owner and a.r_constraint_name = b.constraint_name 
        and b.table_name = l_tabname1(j);
    insert into purgetemp (owner, table_details, column_name,difference_type,constraint_type)
        (select l_owner1, substr(table_name,1,26), column_name||position, 'PK difference', 'P' from user_cons_columns 
        where constraint_name IN (select constraint_name from user_constraints where constraint_type = 'P' and table_name = l_tabname1(j)) and table_name = l_tabname1(j)
        minus
        select l_owner1, substr(table_name,1,instr(table_name,'_ARC')-1), column_name||position, 'PK difference', 'P' from user_cons_columns 
        where constraint_name IN (select constraint_name from user_constraints where constraint_type = 'P' and table_name =l_tabname2(j)) and table_name =l_tabname2(j))
        union all
        (select l_owner1, substr(table_name,1,instr(table_name,'_ARC')-1), column_name||position, 'PK difference', 'P' from user_cons_columns 
        where constraint_name IN (select constraint_name from user_constraints where constraint_type = 'P' and table_name =l_tabname2(j)) and table_name =l_tabname2(j)
        minus
        select l_owner1, substr(table_name,1,26), column_name||position, 'PK difference', 'P' from user_cons_columns 
        where constraint_name IN (select constraint_name  from user_constraints where constraint_type = 'P' and table_name = l_tabname1(j)) 
        and table_name = l_tabname1(j));          
 END LOOP;
    commit;
    select count(*) into l_diff_count from purgetemp where insert_date LIKE (select SYSDATE FROM dual);
    IF l_diff_count > l_diff_count_before THEN 
        dbms_output.put_line('====ES: Main and Arc tables are not in Sync. No of differences :'||l_diff_count||'===');
        raise_application_error(-20140, 'Error raised, Main and Arc tables are not in Sync.');
        l_rc := 1;
    ELSE  
        dbms_output.put_line('====ES: Main and Arc tables are in Sync.===');
        l_rc := 0;
    END IF;
    dbms_output.put_line('Will this be printed?');  
EXCEPTION
  WHEN table_not_in_sync THEN
--    dbms_output.put_line('Tables not in Sync Exception thrown====ES: Main and Arc tables are not in Sync. No of differences :'||l_diff_count||'===');
   RAISE;
  WHEN others THEN
    RAISE;
    l_sql_num := SQLCODE; 
    L_SQL_MSG := SUBSTR(SQLERRM, 1, 200);
    AdminInsert.error_log(l_sql_msg,l_sql_num,'comparePurgeVsArchiveTables');