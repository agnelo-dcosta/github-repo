update MASTERPROPERTIES set value = 'tiaadevws.envisagesystems.local' where element = 'FTP_HOST_NAME';
--update masterproperties set Value = 'TIAACRSPRINT02.envisagesystems.local' where element = 'FTP_HOST_NAME';
update MASTERPROPERTIES set value = 'root' where element = 'FTP_USER_NAME';
update MASTERPROPERTIES set value = 'ligzimm09' where element = 'FTP_USER_PASSWORD';
update MASTERPROPERTIES set value = '22' where element = 'FTP_PORT_NUMBER';
update MASTERPROPERTIES set value = 'SFTP' where element = 'FTP_SERVER_TYPE'; 
--the next three updates set the path for your local system ie C:\home\tester1\local\inbound
update MASTERPROPERTIES set value = '/home/tester1/local/inbound' where element = 'FTP_LOCAL_INBOUND_DIRECTORY';
update MASTERPROPERTIES set value = '/home/tester1/local/outbound' where element = 'FTP_LOCAL_OUTBOUND_DIRECTORY';
update MASTERPROPERTIES set value = '/home/tester1/system/outbound' where element = 'FTP_SYSTEM_OUTBOUND';
--the next 
update MASTERPROPERTIES set value = '/home/selbyp/stac/remote/inbound' where element = 'FTP_REMOTE_INBOUND_DIRECTORY';
update MASTERPROPERTIES set value = '/home/selbyp/stac/remote/outbound' where element = 'FTP_REMOTE_OUTBOUND_DIRECTORY';

truncate table EMPLOYERS;
truncate table EMPLOYERS_EDIT_HISTORY;
truncate table PAYROLL_DATA;
truncate table PAYROLL_DATA_HISTORY;
truncate table SOURCECONTRIBUTIONCALC;
truncate table PAYROLLS;
truncate table SERVICEACCUMULATOR;
truncate table SOURCEELIGIBILITY;
truncate table ELIGIBILITY_REASON;
truncate table LEAVEOFABSENCEACCUMULATOR;
truncate table EMPLOYEES;
truncate table EMPLOYEES_EDIT_HISTORY;

---EMPLOYEES---
select emp.hire_date, emp.adjusted_hire_date, EMP.HR_CODE, EMP.CREATION_SOURCE, EMP.PAYROLL_DATE, EMP.SOCIAL_SECURITY_NUMBER, emp.employee_type, emp.hours,
EMP.* from EMPLOYEES EMP 
where 1=1
--and EMP.SOCIAL_SECURITY_NUMBER = '323-45-6015'
and EMP.PAYROLL_UUID  in ('80a7b102c1014e58a2eb4e0e32496d9c', '80a7b102c1014e58a2eb4e0e32496d9c')
and EMP.EMPLOYEE_UUID in ('57b36ceb11ea41f29e543ed9acad598f')
--and emp.plan_uuid = 'ca3acbaa4d3848eeaaf69fb344ec22a1'
--and payroll_date > to_date('31-dec-2013','dd-mon-yyyy')
--and EMP.FILE_UUID = 'a9efe5e10876459bb274013434f5ef62'
--and EMP.REPORTED_LOCATION = 'H403'
--and EMP.HR_CODE = 'H05'
--and EMP.HIRE_DATE = TO_DATE('30-mar-2012','dd-mon-yyyy')
--and EMP.PAYROLL_DATE = TO_DATE('25-oct-2013','dd-mon-yyyy')
--and emp.last_name = 'TOMAS'
--and creation_source = 1
order by EMP.SOCIAL_SECURITY_NUMBER, EMP.PAYROLL_DATE;, EMP.EDIT_DATE
;


---EMPLOYERS---
select ER.* from EMPLOYERS ER join EMPLOYEES EE on ER.EMPLOYEE_UUID = EE.EMPLOYEE_UUID
where 1=1
and ee.social_security_number = '587-49-7144'
order by EE.SOCIAL_SECURITY_NUMBER, EE.PAYROLL_DATE;

---PAYROLLS---
select P.* from PAYROLLS P-- join employees emp on p.payroll_uuid = emp.payroll_uuid
where 1=1
--and p.payroll_date = to_date('26-APR-12')
--and emp.social_security_number like '454-19-5203%'
--and p.payroll_uuid in ('ba4cc317782c47c7bc0e0c1d57dbb38f','4c9352a2b18f489dbb5d7cc001057f3e')
--and p.plan_uuid = '292a5fe8bce04e7aa6d2818a099fa287'
--and location_uuid is null
--and p.payroll_date = '06-MAY-14'
and p.schedule_id = '058726f454a4450b8a8815d9ccbe0bd7'
order by P.PAYROLL_DATE
;

---PAYROLL DATA---
select EMP.SOCIAL_SECURITY_NUMBER, EMP.PAYROLL_DATE, PD.DISPLAY_NAME, PD.column_value, PD.CODE, PP.PLAN_XSID, PD.* 
from PAYROLL_DATA PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID 
join PAYROLL_PLANS PP on PP.PLAN_UUID = EMP.PLAN_UUID 
where 1=1
and EMP.SOCIAL_SECURITY_NUMBER in ('423-45-6746')
--and pd.EMPLOYEE_UUID = '103fda23de5b4a67a45d15f115269c98'
--and EMP.PAYROLL_DATE = TO_DATE('24-MAY-13','dd-mon-yy')
and PD.CODE is not null
--and Emp.PLAN_UUID in ('8a436c0713db4a69a8142cab5ff8ecf3', '8a436c0713db4a69a8142cab5ff8ecf3')
--and Display_name like 'YTD Contribution Amount'
--and PD.COLUMN_TYPE_UUID in ('ec28b6b73e5a4153b271eb6a1699f31a','421f4466332d4a93834b23f0eeea7e57')
order by EMP.SOCIAL_SECURITY_NUMBER, EMP.PAYROLL_DATE, PD.EMPLOYEE_UUID, PD.DISPLAY_NAME; 

---PAYROLL DATA HISTORY---
select EMP.PAYROLL_DATE, EMP.SOCIAL_SECURITY_NUMBER, PD.DISPLAY_NAME, PD.column_value, PD.CODE, PD.UPDATED_BY, EMP.PLAN_UUID, EMP.FILE_UUID, PD.* 
from PAYROLL_DATA_HISTORY PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID 
where 1=1
and EMP.SOCIAL_SECURITY_NUMBER in ('323-45-6746')
--and pd.EMPLOYEE_UUID = '103fda23de5b4a67a45d15f115269c98'
--and EMP.PAYROLL_DATE = TO_DATE('24-MAY-13','dd-mon-yy')
and PD.CODE is not null
--and Emp.PLAN_UUID in ('ca3acbaa4d3848eeaaf69fb344ec22a1', 'ca3acbaa4d3848eeaaf69fb344ec22a1')
--and Display_name like 'Cash Bonus Amount'
--and PD.COLUMN_TYPE_UUID in ('ec28b6b73e5a4153b271eb6a1699f31a','421f4466332d4a93834b23f0eeea7e57')
--and PD.UPDATED_BY is null
order by EMP.PAYROLL_DATE, PD.EDIT_DATE, PD.EMPLOYEE_UUID, PD.DISPLAY_NAME;

--PLANS--
select * from PAYROLL_PLANS 
where 1=1
--and PLAN_UUID in ('6a661826d8cd4e768c0cecf4aeb2f27a','ca3acbaa4d3848eeaaf69fb344ec22a1')
--and CLIENT_XSID = '011119'
and EMPLOYER_XSID = '148974'
;

--SOURCE ELIGIBILITY--
select EE.PAYROLL_DATE, EE.HOURS, EE.HR_CODE, SE.* from SOURCEELIGIBILITY SE
join EMPLOYEES EE on EE.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID
where 1=1
and EE.SOCIAL_SECURITY_NUMBER = '423-45-6746'
--and source = 'F'
order by EE.PAYROLL_DATE
;

--service accum--
select EE.PAYROLL_DATE, EE.HOURS, EE.HR_CODE, SE.* from SERVICEACCUMULATOR SE
join EMPLOYEES EE on EE.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID
where 1=1
and EE.SOCIAL_SECURITY_NUMBER = '223-45-6015'
--and source = 'F'
order by EE.PAYROLL_DATE
;

select * from PLAN_DETERMINATION_FILES
where 1=1
and FILE_UUID = '112aac4c6ca343589aee853a663c119a'
--and PAYROLL_UUID = 'a6134461e83f4e2fb4b477a084796819'
;
select * from PLAN_LOCATIONS;
select * from payroll_plans;

select * from EEERCALCATTRIBUTE; where id = '2a79ae03259a4e91891c8e7ab74f95db';
165ccbb1821c4551a4df7bfa048496cb
2a79aE03259a4E91891c8E7ab74F95DB
select * from APPLIEDRULEDEF;

select * from APPLIEDRULEDEFSET ARDS join (
select max(effective_dt) as effective_dt, CLIENT_ID, PLAN_ID from APPLIEDRULEDEFSET
where CLIENT_ID = '055378'
and PLAN_ID in ('101178', '406295')
group by CLIENT_ID, PLAN_ID
) ards1 on ards1.effective_dt = ards.effective_dt and ards1.CLIENT_ID = ards.CLIENT_ID and ards1.PLAN_ID = ards.PLAN_ID
;


update GROUPDEFINITION set HRGROUP = '(?!.*)'
where id = ;


--101178
update GROUPDEFINITION set HRGROUP = 'TJUH E.*|TJUH L.*|TJUH M.*|TJUH N.*|TJUH A.P.*|TJUH F.P.*|METH E.*|METH L.*|METH M.*|METH N.*|METH A.P.*|METH F.P.*'
where id = ;


--406295
update GROUPDEFINITION set HRGROUP = 'TJU  A.P.*|TJU  F.P.*|TJU  E.*|TJU  N.*'
where id = ;


select ARDS2.PLAN_ID, EEER.ERSOURCEID, ARD.EEERCALC_ATTR_ID, ARD.APPLIEDRULEDEFSET_ID, ARD.GROUP_DEFINITION_ID, GD.HRGROUP from EEERCALCATTRIBUTE EEER
join APPLIEDRULEDEF ARD on ARD.EEERCALC_ATTR_ID = EEER.id
join 
  (select ARDS.* from APPLIEDRULEDEFSET ARDS 
  join 
    (select max(effective_dt) as effective_dt, CLIENT_ID, PLAN_ID from APPLIEDRULEDEFSET
    where CLIENT_ID = '055378'
    and PLAN_ID in ('101178', '406295')
    group by CLIENT_ID, PLAN_ID
    )
  ARDS1 on ARDS1.EFFECTIVE_DT = ARDS.EFFECTIVE_DT and ARDS1.CLIENT_ID = ARDS.CLIENT_ID and ARDS1.PLAN_ID = ARDS.PLAN_ID
  ) 
ARDS2 on ARDS2.id = ARD.APPLIEDRULEDEFSET_ID
join GROUPDEFINITION GD on ARD.GROUP_DEFINITION_ID= GD.id
where EEER.ERSOURCEID = 'F'
;


select * from APPLIEDRULEDEFSET
    where CLIENT_ID = '055378'
    --and PLAN_ID in ('101178', '406295')
    and EFFECTIVE_DT is null
    ;
    
select * from APPLIEDRULEDEFSET ARDS
left outer join APPLIEDRULEDEFSET ARDS1 on ARDS.id = ARDS1.PREV_ID
    where ARDS.CLIENT_ID = '055378'
    and ARDS.PLAN_ID in ('101178', '406295');

select * from sourceeligibility where EMPLOYEE_SNAPSHOT_ID in ( 'dbee95f82727411d899757fb73080d26', '801c9c93ffbc4bbea2a8e3eda50e26c3');
select * from sourceeligibility where ID = 'f4386a654915428bb1cdf8145238648f';

select * from EMPLOYEES where EMPLOYEE_UUID = '950f4f3ba60a4640ad33d0f00060aafc';
select EMPLOYEE_SNAPSHOT_ID, E.CREATION_SOURCE, e.* from EMPLOYEES e where SOCIAL_SECURITY_NUMBER = '357-46-2807' and PAYROLL_DATE = '02-OCT-14';




select * from EMPLOYEES EEH
join EMPLOYEES EEH1 on EEH1.SOCIAL_SECURITY_NUMBER = EEH.SOCIAL_SECURITY_NUMBER and EEH1.PLAN_UUID = EEH.PLAN_UUID and EEH1.location = EEH.location and EEH1.PAYROLL_DATE = EEH.PAYROLL_DATE and EEH.REPORTED_PAYROLL_FREQUENCY = EEH1.REPORTED_PAYROLL_FREQUENCY 
join PAYROLL_DATA PD on EEH.EMPLOYEE_UUID = PD.EMPLOYEE_UUID
join PAYROLL_DATA PD1 on EEH1.EMPLOYEE_UUID = PD1.EMPLOYEE_UUID
where PD.CODE = 'E' and PD1.CODE = 'E'
and eeh.CREATION_SOURCE = 0 and eeh.CREATION_SOURCE = 0;

select * from EMPLOYEES EE
join EMPLOYEES_EDIT_HISTORY EEH on EE.EMPLOYEE_UUID = EEH.EMPLOYEE_UUID and EE.EMPLOYEE_SNAPSHOT_ID = EEH.EMPLOYEE_SNAPSHOT_ID
where ee.social_security_number = '';
  
select SOURCE_CODE from SOURCES where EE_ER='EE';

select PAYROLL_UUID;

select unique display_name, COLUMN_TYPE_UUID from payroll_data;

select HR_SUBAREA from PLANDETERMINATIONATTR
where client_id = '050531' and plan_id='406326';

select * from CLIENTPROPERTIES CP 
join CLIENTxsmapping C on CP.CLIENT_ID = C.CLIENT_ID
where element ='HR_SUBAREA_VALID_VALUES'
and client_xsid = '054303';
select * from manage_service;
select distinct GD.HRGROUP from APPLIEDRULEDEFSET ARDS
join APPLIEDRULEDEF ARD on ARD.APPLIEDRULEDEFSET_ID = ARDS.id
join GROUPDEFINITION gd on ARD.GROUP_DEFINITION_ID = GD.id
where client_id = '054303' and 
PLAN_ID = '151576'
;

--use new client XSID, set to new plan XSID, but filter based on old plan_xsid (plan_id is XSID, client_id is XSID)
update appliedruledefset set plan_id = '961029' where client_id = '131666' and plan_id = '406329';

update planDeterminationattr set plan_id = '961029' where client_id = '131666' and plan_id = '406329';


UPDATE payroll_data
SET payroll_data.column_value = (SELECT NVL(pd.column_value,0) + NVL(pdh.column_value,0)
                   from PAYROLL_DATA PD join PAYROLL_DATA_HISTORY PDH on PD.PAYROLL_DATA_ITEM_UUID = PDH.PAYROLL_DATA_ITEM_UUID  
                WHERE pd.column_type_uuid='ec28b6b73e5a4153b271eb6a1699f31a' and pdh.column_type_uuid='ec28b6b73e5a4153b271eb6a1699f31a' and  pdh.updated_by = 'ADJUSTMENT-PERFORMED' and (pdh.action_taken='UPDATE' OR pdh.action_taken='DELETE'))

select EMPLOYEE_UUID from EMPLOYEES where IS_ADJUSTMENT = 1;
select PD.EMPLOYEE_UUID, PD.DISPLAY_NAME, PD.CODE, PD.column_value, HISTORY.HIST, (PD.column_value + HISTORY.HIST) as new_sum from PAYROLL_DATA PD
join
  (select EMPLOYEE_UUID, CODE, SUM(column_value) as HIST from PAYROLL_DATA_HISTORY
  where updated_by = 'ADJUSTMENT-PERFORMED'
  group by EMPLOYEE_UUID, CODE) HISTORY on HISTORY.EMPLOYEE_UUID = PD.EMPLOYEE_UUID and pd.code = history.code
  where pd.EMPLOYEE_UUID in ('f44d5c718f234f9d840970a94a06d473','8b73100a8c914f02b21f219a00c50945','011e02afc5f64996a8caf0c30ab588f0','a0071b2bda50461d96413795c255f791',
  'fbc05dc82ec34cc2ba87b1aa6c9b6944','f23fca9908104f1bb85909340eac0ca2','27caf356e9e8431d893a6fd79bc8d05a','4d0704812418443a99b9f1e8f3431b48','67a71f2f825d4a7aa6d152e26303f821',
  'e0cf1f82a82c4e84a1513d2257b97d7e','103fda23de5b4a67a45d15f115269c98','9ecb811751e14906bad89cd2b4f937e3')
  and PD.CODE is not null
  and pd.CODE in ('A', 'E', '2')
;

begin
for EMPUUID in (select count(EMPLOYEE_UUID) from EMPLOYEES where IS_ADJUSTMENT = 1)
LOOP
  update EMPLOYEES set name = 'adj';
end LOOP;
end;


select * from payroll_files;

select * from PLAN_DETERMINATION_FILES where FILE_UUID = '112aac4c6ca343589aee853a663c119a';

select EMP.FULL_NAME, EMP.PAYROLL_DATE, EMP.IS_ADJUSTMENT, EMP.CREATION_SOURCE, EMP.EMPLOYEE_UUID, SE.source, EMP.ADJUSTED_HIRE_DATE, EMP.HIRE_DATE,   
EMP.PLAN_ENTRY_DATE, SE.ELIGIBILITY_DATE, PP.PLAN_XSID, EMP.PAYROLL_UUID, EMP.PLAN_UUID, emp.hr_code
FROM employees EMP   
left outer join SOURCEELIGIBILITY SE on EMP.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID  
join payroll_plans pp on emp.plan_uuid = pp.plan_uuid 
join PAYROLLS P on P.PAYROLL_UUID = EMP.PAYROLL_UUID 
where 1=1 --MP.SOCIAL_SECURITY_NUMBER in ('084-62-2703', '128-52-8055', '101-48-0899', '087-40-6811', '041-60-2445', '158-70-3478', '124-48-4830' ) 
and P.IS_CENSUS = 0 
--order by 1, emp.payroll_date desc
;

selecT sc.* from sourcecontributioncalc sc; join employees e on
e.employee_snapshot_id = sc.employee_snapshot_id
where e.social_security_number = '521-16-3423';

select * from COLUMN_TYPES;
select * from VESTING_INPUT_SOURCES;

select * from MASTERPROPERTIES where element = 'USE_ADOH';

select * from USER_CONSTRAINTS where TABLE_NAME = 'PAYROLL_PLANS';
select * from PLAN_LOCATIONS; where LOCATION_UUID in ('563a7acd709541ba929ef5f88db9bf4f','f728c84726d54c48b84c683025d3d16f');
select * from INPUT_FILES;
select * from PAYROLL_PLANS;

select EM.EMPLOYEE_ID, EM.PAYROLL_DATE, EM.PLAN_UUID, SE.ELIGIBILITY_DATE, SE.source from EMPLOYEES EM join 
(select max(E.PAYROLL_DATE) LATEST_ADJ_DATE, E.SOCIAL_SECURITY_NUMBER SSN from EMPLOYEES E
where E.IS_ADJUSTMENT = 1 group by E.SOCIAL_SECURITY_NUMBER) EMP 
on EMP.LATEST_ADJ_DATE = EM.PAYROLL_DATE and EMP.SSN = EM.SOCIAL_SECURITY_NUMBER
join SOURCEELIGIBILITY SE on EM.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID
order by EM.SOCIAL_SECURITY_NUMBER
;

select * from input_files;

select * from PAYROLL_PLANS where PLAN_XSID = '403400';
select * from PLAN_LOCATIONS where PLAN_UUID = 'a267415c80f64d91b23ec077626ba91d';
select * from PLAN_LOCATIONS where LOCATION_CODE = '148978';
044808b94E254a3480187D0b6105c739
9375EDCAF46141b6b033323F44bD08a0
BFAAC6BF9D914C879009D79304ABD8BA
A267415C80F64D91B23EC077626BA91D
select * from PAYROLLS where LOCATION_UUID != '9c686ad5c6cd4731abbb938958d86d33' and PLAN_UUID = '6c89c1c9de1e48ffaec235d2c6612e6f';
select * from PAYROLL_FILES where FILE_UUID in (select FILE_UUID from PAYROLLS where PLAN_UUID = '3940ea948a7149cd8926d429d80060e4');

select PP.*, PL.LOCATION_CODE from PAYROLL_PLANS PP 
join PLAN_LOCATIONS PL on PL.PLAN_UUID = PP.PLAN_UUID
where PP.PLAN_XSID = '151166'
and PL.LOCATION_CODE = 'K077';

select * from PLAN_DETERMINATION_FILES;

select EM.EMPLOYEE_ID, EM.PAYROLL_DATE, EM.PLAN_UUID, SE.ELIGIBILITY_DATE, SE.source from EMPLOYEES E join 
  (select min(EM.PAYROLL_DATE) LATEST_DATE, EM.SOCIAL_SECURITY_NUMBER SSN from EMPLOYEES EM join 
      (select max(E.PAYROLL_DATE) LATEST_ADJ_DATE, E.SOCIAL_SECURITY_NUMBER SSN_ADJ from EMPLOYEES E
        where E.IS_ADJUSTMENT = 1 group by E.SOCIAL_SECURITY_NUMBER) EMP 
    on EMP.SSN_ADJ = EM.SOCIAL_SECURITY_NUMBER
    where EM.IS_ADJUSTMENT = 0  and EM.PAYROLL_DATE > EMP.LATEST_ADJ_DATE
    group by EM.SOCIAL_SECURITY_NUMBER) EMPL
on EMPL.LATEST_DATE = E.PAYROLL_DATE and EMPL.SSN = E.SOCIAL_SECURITY_NUMBER
join SOURCEELIGIBILITY SE on E.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID
order by E.SOCIAL_SECURITY_NUMBER
;
--order by e.payroll_date desc;

select COUNT(*) from EMPLOYERS where EMPLOYER_UUID not in (
select max(ER.EMPLOYER_UUID)--, er.name, er.plan_id --count(unique er.name, er.plan_id)
from EMPLOYERS ER 
where 1=1
group by ER.name, ER.PLAN_ID
--order by er.name
);

select replace(PD.DISPLAY_NAME, 'Employer Match', 'Contribution') as DISPLAY_COLUMN_NAME, EMP.PAYROLL_DATE,  PD.column_value,
EMP.SOCIAL_SECURITY_NUMBER as SSN, EMP.EMPLOYEE_ID, PL.LOCATION_CODE as CAMPUS_ID, PD.CODE
from PAYROLL_DATA PD 
join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID
join PAYROLL_PLANS PP on PP.PLAN_UUID = EMP.PLAN_UUID
join PLAN_LOCATIONS PL on EMP.location = PL.LOCATION_UUID
where
PP.CLIENT_XSID = '011490' and PD.DISPLAY_NAME in('Compensation','Employer Match')
order by PD.DISPLAY_NAME, SSN, EMP.PAYROLL_DATE desc;


select * from PAYROLLS_HISTORY where FILE_UUID = 'd6d55b3c696941689f5be4a018e95a59';

update PAYROLLS set SCHEDULE_ID = '', 
select * from AUTOMATIC_DEFERRALS;
select * from PLAN_LOCATIONS; where LOCATION_CODE = '0002';-- where location_uuid = '797cca3ecc194ba7a8fbe0298d384dfa';

select * from EMPLOYEES_EDIT_HISTORY where SOCIAL_SECURITY_NUMBER = '356-94-7006' order by EDIT_DATE desc;
select * from EMPLOYEE_UDF;
select * from MANAGE_SERVICE MS join CLIENT C on C.CLIENT_UUID = MS.CLIENT_UUID
where C.CLIENT_XSID = '054303';
update MANAGE_SERVICE set LOOKBACK_OPTION = 1, LASTPAYROLL_OPTION = 1 where SERVICE_UUID = 'b94da3cb1df0487ea1223eb3642b863b';

select * from REALLOCATION;

select * from AUTOMATIC_DEFERRALS;

select E.EMPLOYEE_PLAN_STATUS, E.* from EMPLOYEES E where (E.EMPLOYEE_PLAN_STATUS is null or E.EMPLOYEE_PLAN_STATUS != 'Z'); and E.EMPLOYEE_UUID ='3a837e6a85034132824b3e813e4e8fd6';
update EMPLOYEES set EMPLOYEE_PLAN_STATUS = '' where EMPLOYEE_UUID = '3a837e6a85034132824b3e813e4e8fd6';

select * from SERVICEACCUMULATOR YOS, EMPLOYEES EMP
 where YOS.EMPLOYEE_SNAPSHOT_ID=EMP.EMPLOYEE_SNAPSHOT_ID and EMP.SOCIAL_SECURITY_NUMBER = '422-23-2016';
 select * from SERVICEACCUMULATOR where EMPLOYEE_SNAPSHOT_ID = '33606d064a6e4df682ae9d77b8c82c34';

 select * from SOURCEELIGIBILITY YOS, EMPLOYEES EMP
 where YOS.EMPLOYEE_SNAPSHOT_ID=EMP.EMPLOYEE_SNAPSHOT_ID and EMP.SOCIAL_SECURITY_NUMBER = '422-23-2016';

select * from SOURCE_ELIGIBILTY;
select * from SOURCEELIGIBILITY SC join EMPLOYEES E on
SC.EMPLOYEE_SNAPSHOT_ID = E.EMPLOYEE_SNAPSHOT_ID
where E.SOCIAL_SECURITY_NUMBER = '' order by E.PAYROLL_DATE;

select EMP.SOCIAL_SECURITY_NUMBER, YOS.* from SERVICEACCUMULATOR YOS
join EMPLOYEES EMP on YOS.EMPLOYEE_SNAPSHOT_ID=EMP.EMPLOYEE_SNAPSHOT_ID
where 1=1
--and EMP.SOCIAL_SECURITY_NUMBER = '260-26-1119'
order by EMP.SOCIAL_SECURITY_NUMBER;

select * from MANAGE_SERVICE MS
join CLIENT C on C.CLIENT_UUID = MS.CLIENT_UUID
where C.CLIENT_XSID = '011490';
update MANAGE_SERVICE set ETL_ENABLED = 0;

select * from EMPLOYEE_PREV_CONTRIB EPC join EMPLOYEES EMP on EMP.EMPLOYEE_UUID = EPC.EMPLOYEE_UUID
where EMP.SOCIAL_SECURITY_NUMBER in ('260-26-0001');

select * from PAYROLL_PLANS;
select PAYROLL_DATE, SUM(column_value) as COLUMN_VALUE_SUM from
((select PD.HISTORY_ID as UUID, EMP.PAYROLL_DATE, PD.column_value
from PAYROLL_DATA_HISTORY PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID
where EMP.SOCIAL_SECURITY_NUMBER ='333-84-1234'
and EMP.PLAN_UUID = '9375edcaf46141b6b033323f44bd08a0'-- '3940ea948a7149cd8926d429d80060e4'
and PD.CODE = 'E'
and PD.ACTION_TAKEN = 'UPDATE' and PD.UPDATED_BY = 'CALCULATION')
union
(select PD.PAYROLL_DATA_ITEM_UUID as UUID, EMP.PAYROLL_DATE, PD.column_value
from PAYROLL_DATA PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID
where EMP.SOCIAL_SECURITY_NUMBER ='333-84-1234'
and EMP.PLAN_UUID = '9375edcaf46141b6b033323f44bd08a0'-- '3940ea948a7149cd8926d429d80060e4'
and PD.CODE = 'E'))
where PAYROLL_DATE >= TO_DATE('01-AUG-13') and PAYROLL_DATE <= TO_DATE('01-NOV-13')
group by PAYROLL_DATE
order by PAYROLL_DATE;

select * from EEERCALCATTRIBUTE;

select * from APPLIEDRULEDEF where EEERCALC_ATTR_ID = '3b789619d17c4ec7b867923fc8676ecc';
select * from APPLIEDRULEDEF where APPLIEDRULEDEFSET_ID = '9fead76c9dc9467d8f2d8face6a6875b';

select * from APPLIEDRULEDEFSET where id = '9fead76c9dc9467d8f2d8face6a6875b';

select PD.*, PD.PAYROLL_DATA_ITEM_UUID as UUID, EMP.PAYROLL_DATE, PD.column_value
from PAYROLL_DATA_HISTORY PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID
where EMP.SOCIAL_SECURITY_NUMBER ='333-84-1234'
and EMP.PLAN_UUID = 'a267415c80f64d91b23ec077626ba91d'-- '3940ea948a7149cd8926d429d80060e4'
and PD.CODE = 'E'
and PD.ACTION_TAKEN = 'UPDATE' and PD.UPDATED_BY = 'CALCULATION';


select EMP.PAYROLL_DATE, SUM(PD.column_value) as COLUMN_VALUE_SUM
from PAYROLL_DATA_HISTORY PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID 
where EMP.SOCIAL_SECURITY_NUMBER = '333-84-1234' and EMP.PLAN_UUID = '9375edcaf46141b6b033323f44bd08a0' 
and PD.CODE = 'E' and PD.ACTION_TAKEN = 'UPDATE' and PD.UPDATED_BY = 'CALCULATION' 
and EMP.PAYROLL_DATE >= TO_DATE('01-AUG-13')
group by EMP.PAYROLL_DATE order by EMP.PAYROLL_DATE;

select EMP.PAYROLL_DATE, SUM(PD.column_value) as COLUMN_VALUE_SUM from PAYROLL_DATA_HISTORY PD join EMPLOYEES EMP on PD.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID
where EMP.SOCIAL_SECURITY_NUMBER = '333-84-1234'
and EMP.PLAN_UUID = '9375edcaf46141b6b033323f44bd08a0'
and PD.CODE = 'E'
and PD.ACTION_TAKEN = 'UPDATE'
and PD.UPDATED_BY = 'CALCULATION'
and EMP.PAYROLL_DATE >= TO_DATE('01-FEB-13')
group by EMP.PAYROLL_DATE order by EMP.PAYROLL_DATE;

select EMP.EMPLOYEE_PLAN_STATUS, EMP.* from EMPLOYEES EMP where EMP.SOCIAL_SECURITY_NUMBER like '789-78-9002'
--and emp.plan_uuid = '3940ea948a7149cd8926d429d80060e4'
order by EMP.SOCIAL_SECURITY_NUMBER, EMP.PLAN_UUID, EMP.PAYROLL_DATE;


select distinct(PAYROLL_UUID), PAYROLL_DATE
			  from EMPLOYEES EMPS 
			 where EMPS.FILE_UUID = 'b62f350988cd4574ac35e16ef0db7cb8' order by PAYROLL_DATE;
       
       select * from PAYROLLS where PAYROLL_UUID = 'f6e8736479b040d0a2cda8f599c9ae9b';
       select * from PAYROLL_FILES where FILE_UNC like '%CR_054303_054303_054303_WEEK_130523_260002%';
       
select * from SOURCECONTRIBUTIONCALC SCC join EMPLOYEES EMP on EMP.EMPLOYEE_SNAPSHOT_ID = SCC.EMPLOYEE_SNAPSHOT_ID
where EMP.SOCIAL_SECURITY_NUMBER = '774-98-1001';

select EMP.PAYROLL_DATE, AD.* from AUTOMATIC_DEFERRALS AD join EMPLOYEES EMP on EMP.EMPLOYEE_UUID = AD.EMPLOYEE_UUID
where EMP.SOCIAL_SECURITY_NUMBER like '774-98-1002';

update AUTOMATIC_DEFERRALS set INCREASE_AMOUNT = 2345.67 where DEFERRAL_UUID in ('3788ca449979414b89dccd4f63604917', 'f672216c7d3746c88076c38edaed678f');

select * from PLAN_TABLE;

desc PAYROLL_DATA;

desc AUTOMATIC_DEFERRALS;

select * from REALLOCATION;

select EMP.CREATION_SOURCE, EMP.IS_ADJUSTMENT, EMP.PAYROLL_DATE, EMP.SOCIAL_SECURITY_NUMBER, PD.EMPLOYEE_UUID, PD.DISPLAY_NAME, PD.column_value, PD.CODE
from PAYROLL_DATA PD join EMPLOYEES EMP on EMP.EMPLOYEE_UUID = PD.EMPLOYEE_UUID 
where EMP.SOCIAL_SECURITY_NUMBER like '789-78-9001'
--and emp.creation_source <> 3
-- and display_name in ('Year To Date Base', 'Year to date total compensation')
 order by EMP.PAYROLL_DATE, EMP.EMPLOYEE_UUID, PD.DISPLAY_NAME;
 
 select * from PAYROLLS where PAYROLL_UUID = 'f17cc4d630cc45afa636185637251841';
 
 select * from EMPLOYEES where EMPLOYEE_UUID = 'd9c1cf9998274f699b447559f68ff162';
 
 select * from EMPLOYEES_EDIT_HISTORY where EMPLOYEE_UUID = 'd9c1cf9998274f699b447559f68ff162' order by EDIT_DATE;
 
 select * from PAYROLL_FILES; where FILE_UUID = '865ad38e46554743b71ae1ad982e1f7d';
 
 select * from PLAN_DETERMINATION_FILES where LINE_VALUE like '%|774981009|%' and FILE_UUID = '865ad38e46554743b71ae1ad982e1f7d';
 
 select * from PAYROLL_PLANS where PLAN_UUID = '9684b45df6854366b6cf6a192777c8e2';

select * from SOURCEELIGIBILITY where EMPLOYEE_SNAPSHOT_ID = '0941219036e947d2bd930eb7dc5da536';

select * from SOURCECONTRIBUTIONCALC join;
select * from EMPLOYEES where SOCIAL_SECURITY_NUMBER like '774-98-1002' 
order by ;
select EMP.SOCIAL_SECURITY_NUMBER, PS.* from PAYROLLS PS join EMPLOYEES EMP on PS.PAYROLL_UUID = EMP.PAYROLL_UUID where SOCIAL_SECURITY_NUMBER like '260-26-0812';
select ER.* from EMPLOYERS ER join EMPLOYEES EMP on ER.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID where EMP.SOCIAL_SECURITY_NUMBER like '260-26-0810';

select * from PAYROLLS; where PAYROLL_UUID = 'ab1e2c936423401a9240f5aa07b9dfaf';

select * from PAYROLL_DATA_HISTORY
--where  display_name = 'Employer Match'
 order by EMPLOYEE_UUID, DISPLAY_NAME
 ;
       
select P.*
from PAYROLLS P, PAYROLL_PLANS PP 
where P.PLAN_UUID = PP.PLAN_UUID  
--and p.payroll_date >= ? 
and P.SCHEDULE_ID = '48c2fcb84fa949699b9ec1d506ee56ed'
and P.IS_ADJUSTMENT = '0' 
and P.FILE_UUID != 'f2741c07a9744c1e9aea29ae890a2527' 
and P.IS_CENSUS != '1' 
and PP.PLAN_TYPE_CODE != '457' 
and PP.EMPLOYER_XSID = (select EMPLOYER_XSID from PAYROLL_PLANS where PLAN_UUID = '3940ea948a7149cd8926d429d80060e4') order by P.PAYROLL_DATE ;


select * from PAYROLL_DATA_HISTORY 
where EMPLOYEE_UUID = '186ba6289ea64a5bab6bbbf3f9631f6d' and UPDATED_BY = 'ADJUSTMENT';


select EMP.SOCIAL_SECURITY_NUMBER, SCC.* from SOURCEELIGIBILITY SCC 
join EMPLOYEES EMP on EMP.EMPLOYEE_SNAPSHOT_ID = SCC.EMPLOYEE_SNAPSHOT_ID
--where emp.social_security_number = '201-30-5029';
where EMP.SOCIAL_SECURITY_NUMBER like '260-26-000%';

select * from EMPLOYEES where FILE_UUID = 'ab31930c022048fca51e7dab17788b9b';

select EMP.SOCIAL_SECURITY_NUMBER, UDF.* from EMPLOYEE_UDF UDF join EMPLOYEES EMP on UDF.EMPLOYEE_UUID = EMP.EMPLOYEE_UUID where EMP.SOCIAL_SECURITY_NUMBER like '260-26-0003';


select * 
from COLUMN_TYPES
where IS_ENABLED = 1
and CANONICAL_NAME = 'CASH_BONUS_AMOUNT'
order by TYPE_NAME;

 select * from (select ROW_NUMBER () 
 over (order by EMPS.EMPLOYEE_UUID) as R, 
 EMPS.*, EMPRS.RECIPIENT_VENDOR_SUB_PLAN_ID
 from EMPLOYEES EMPS, EMPLOYERS EMPRS
 where EMPS.EMPLOYEE_UUID = EMPRS.EMPLOYEE_UUID
 and FILE_UUID = '274f5998c9cc42148f5a6d2c02eddbce' 
 and DELETED_DATE is null)
 order by SOCIAL_SECURITY_NUMBER;
 
 select * from PAYROLLS where FILE_UUID = '8fcb4dc6a60d43bdbb02290551f19235' order by PAYROLL_DATE;
 
 select * from INPUT_FILES where FILE_UUID = 'd3a1b3d9cd57492c811b965ca87b2e4a';
 

select SOURCE_CODE from SOURCES where EE_ER = 'EE';

select *   from PLAN_DETERMINATION_FILES  where FILE_UUID = '076186662abd443092da5f5ac40ad8e9'; and PAYROLL_UUID = 'e3ce7dd402474d9692c2d79af769d50f'  order by LINE_NUMBER;

select * from PLAN_DETERMINATION;


select * from EMPLOYEES where FILE_UUID = 'a48e10dc6f3c4fcba9a2dd839528a699';
update EMPLOYEES set EMPLOYEE_PLAN_STATUS = 'Z' where EMPLOYEE_UUID = '033de32e577f46e7875f76249e8d26c9';
update EMPLOYEES set EMPLOYEE_PLAN_STATUS = 'Z' where EMPLOYEE_UUID = '2f44bf47c82b4496a3c29f64351081fe';


select distinct(PAYROLL_UUID), PAYROLL_DATE
from EMPLOYEES EMPS 
where EMPS.FILE_UUID = '39d3180794744e42b382930a92fd5c15'-- and employee_plan_status != 'Z'
order by PAYROLL_DATE;


select * from   (select ROW_NUMBER () over (order by EMPS.PAYROLL_DATE desc ) as R, EMPS.*, 
EMPRS.RECIPIENT_VENDOR_SUB_PLAN_ID 
from   EMPLOYEES EMPS, 
EMPLOYERS EMPRS
where  EMPRS.EMPLOYEE_UUID = EMPS.EMPLOYEE_UUID 
and EMPS.CREATION_SOURCE not in (3, 4, 5, 6) 
and SOCIAL_SECURITY_NUMBER = '102-39-6413'
and PLAN_UUID = '044808b94e254a3480187d0b6105c739'
and PAYROLL_DATE < TO_DATE('2013-10-11', 'YYYY-MM-DD'))
where  R = 1;


select * from masterproperties where element = 'SUPPLEMENTAL_TIED_TO_SCHEDULE';

select * from clientproperties where element = 'SUPPLEMENTAL_TIED_TO_SCHEDULE';