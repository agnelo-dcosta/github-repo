
update tbljobqueue set processstatusid = 401 where processid = 40 and workflowid = XXXXX;

select * from processstatus where processid = 5;
select * from WORKFLOWDEFINITION where WORKFLOWDEFINITIONID = 'CONVERT_TO_POSTEXTRACT';
select * from processlist where description like '%Post%';

update tbljobqueue set complete = 0, locked = 0, processstatusid = 60 
where WORKFLOWID = 507108 and PROCESSID = 6;

update TBLJOBQUEUE set complete = 1, locked = 0 where 
complete = 0 --and WORKFLOWID != 507108
;
select count(*) from tbljobqueue where complete = 0;
select * from tbljobqueue where locked = 1 or complete = 0;
select * from tblworkflowheaderproperty where workflowid = 581268;
delete from tblworkflowheaderproperty where workflowheaderpropertyid = 2486625;
truncate table tblworkflowheaderproperty;
truncate table workflowlog;
truncate table BATCH_FAILURE;
delete from tbljobqueue where LASTACTIVITY is null;


select * from tblworkflowheaderproperty where element = 'SEEDVERSION';
select * from QRTZ_SIMPLE_TRIGGERS;
select * from CLIENTPROPERTIES where element like '%FILE_PRO_AL_ADJ%';

select * from payroll_schedule_dates where payroll_schedule_id = '24cfb8c2f91e4417b730a04e482e64a2' and fin_year = 2013  order by seq;
delete from tblworkflowheaderproperty; where element = 'AS_OF_DATE';



select * from processstatus where processid = 51;

select * from TBLJOBQUEUE
where not PROCESSID in (12, 19, 73)
--and workflowid in (616421)
--and processid = 6
--and complete = 0
--and LASTACTIVITY is not null
order by LASTACTIVITY desc;

select whp.* from TBLJOBQUEUE TJQ 
join TBLWORKFLOWHEADERPROPERTY WHP on WHP.WORKFLOWID = TJQ.WORKFLOWID 
where TJQ.PROCESSID in (5,6,16,17,51,111) 
and WHP.WORKFLOWID = 629234
--and TJQ.PROCESSSTATUSID in (52,62,162,172,512,1112) 
--and WHP.element = 'FILENAME' 
--AND WHP.PROPERTYVALUE = 'TC_ABO_062026_101641_101641_140829_010001.txt'
;

select * from TBLWORKFLOWHEADERPROPERTY 
--where PROPERTYVALUE like '%A_054303_054303_054303_ADJUST_140423_092745%'
where WORKFLOWID = 936131;
order by CREATEDATE;

select unique PL.PROCESSID, WD.TARGETCLASS from PROCESSSTATUS PL
join WORKFLOWDEFINITION WD on PL.WORKFLOWDEFINITIONID = WD.WORKFLOWDEFINITIONID
where PL.PROCESSID = 6;


select * from workflowlog 
where 1=1
and workflowid=629234
--and recordsubtype <> 'INFORMATIONAL'
--and detailtext like '%A_054303_054303_054303_ADJUST_140423_092745%' order by createdate desc
;