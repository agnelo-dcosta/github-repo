--Disable Rule
update GROUPDEFINITION set HRGROUP = '(?!.*)'
where id =   
  (select ARD.GROUP_DEFINITION_ID from EEERCALCATTRIBUTE EEER
  join APPLIEDRULEDEF ARD on ARD.EEERCALC_ATTR_ID = EEER.id
  join 
    (select ARDS.* from APPLIEDRULEDEFSET ARDS 
    join 
      (select max(effective_dt) as effective_dt, CLIENT_ID, PLAN_ID from APPLIEDRULEDEFSET
      where CLIENT_ID = '055378'
      and PLAN_ID = '101178'
      group by CLIENT_ID, PLAN_ID
      )
    ARDS1 on ARDS1.EFFECTIVE_DT = ARDS.EFFECTIVE_DT and ARDS1.CLIENT_ID = ARDS.CLIENT_ID and ARDS1.PLAN_ID = ARDS.PLAN_ID
    ) 
  ARDS2 on ARDS2.id = ARD.APPLIEDRULEDEFSET_ID
  join GROUPDEFINITION GD on ARD.GROUP_DEFINITION_ID= GD.id
  where EEER.ERSOURCEID = 'F'
  )
;

select * from GROUPDEFINITION where HRGROUP like 'METH';


--Enable 101178 rule
update GROUPDEFINITION set HRGROUP = 'TJUH E.*|TJUH L.*|TJUH M.*|TJUH N.*|TJUH A.P.*|TJUH F.P.*|METH E.*|METH L.*|METH M.*|METH N.*|METH A.P.*|METH F.P.*'
where id =  
  (select ARD.GROUP_DEFINITION_ID from EEERCALCATTRIBUTE EEER
  join APPLIEDRULEDEF ARD on ARD.EEERCALC_ATTR_ID = EEER.id
  join 
    (select ARDS.* from APPLIEDRULEDEFSET ARDS 
    join 
      (select max(effective_dt) as effective_dt, CLIENT_ID, PLAN_ID from APPLIEDRULEDEFSET
      where CLIENT_ID = '055378'
      and PLAN_ID = '101178'
      group by CLIENT_ID, PLAN_ID
      )
    ARDS1 on ARDS1.EFFECTIVE_DT = ARDS.EFFECTIVE_DT and ARDS1.CLIENT_ID = ARDS.CLIENT_ID and ARDS1.PLAN_ID = ARDS.PLAN_ID
    ) 
  ARDS2 on ARDS2.id = ARD.APPLIEDRULEDEFSET_ID
  join GROUPDEFINITION GD on ARD.GROUP_DEFINITION_ID= GD.id
  where EEER.ERSOURCEID = 'F'
  )
;


--Enable 406295 rule
update GROUPDEFINITION set HRGROUP = 'TJU  A.P.*|TJU  F.P.*|TJU  E.*|TJU  N.*'
where id = 
  (select ARD.GROUP_DEFINITION_ID from EEERCALCATTRIBUTE EEER
  join APPLIEDRULEDEF ARD on ARD.EEERCALC_ATTR_ID = EEER.id
  join 
    (select ARDS.* from APPLIEDRULEDEFSET ARDS 
    join 
      (select max(effective_dt) as effective_dt, CLIENT_ID, PLAN_ID from APPLIEDRULEDEFSET
      where CLIENT_ID = '055378'
      and PLAN_ID = '406295'
      group by CLIENT_ID, PLAN_ID
      )
    ARDS1 on ARDS1.EFFECTIVE_DT = ARDS.EFFECTIVE_DT and ARDS1.CLIENT_ID = ARDS.CLIENT_ID and ARDS1.PLAN_ID = ARDS.PLAN_ID
    ) 
  ARDS2 on ARDS2.id = ARD.APPLIEDRULEDEFSET_ID
  join GROUPDEFINITION GD on ARD.GROUP_DEFINITION_ID= GD.id
  where EEER.ERSOURCEID = 'F'
  )
;

--Double check HR Groups for both rules
select ARDS2.PLAN_ID, ARDS2.effective_dt , EEER.ERSOURCEID, ARD.EEERCALC_ATTR_ID, ARD.APPLIEDRULEDEFSET_ID, ARD.GROUP_DEFINITION_ID, GD.HRGROUP, GD.* from EEERCALCATTRIBUTE EEER
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




















select sys_guid() from dual; 

update EMPLOYEES set PREV_EMPLOYEE_SNAPSHOT_ID = <new id> where EMPLOYEE_UUID = ''; 
update EMPLOYEES_edit_history set EMPLOYEE_SNAPSHOT_ID = <new id> where HISTORY_ID = ''; 

select E.EMPLOYEE_UUID, EEH.HISTORY_ID from EMPLOYEES E 
join EMPLOYEES_EDIT_HISTORY EEH on E.EMPLOYEE_SNAPSHOT_ID = EEH.EMPLOYEE_SNAPSHOT_ID; 




select * from STATUS_UPDATE SU 
join tbljobqueue tbl on SU.TBLJOBQUEUE_ID = TBL.TBLJOBQUEUE_ID;

--get all data for current census where adjustment source eligibility date is
--different than census eligibility date
select pp.plan_xsid, payroll.social_security_number, payroll.max_payroll_date payroll_max_payroll_date, payroll.employee_id, payroll.first_name, payroll.last_name , payroll.employment_status  
   , PAYROLL.EMPLOYMENT_SUB_TYPE, PAYROLL.EMPLOYMENT_STATUS_DATE, PAYROLL.TERMINATION_DATE, PAYROLL.REPORTED_PAYROLL_FREQUENCY, PAYROLL.HIRE_DATE, PAYROLL.ADJUSTED_HIRE_DATE, PAYROLL.REPORTED_LOCATION, PAYROLL.HR_CODE     
,PAYROLL.ELIGIBILITY_DATE PAYROLL_ELIGIBILITY_DATE, CENSUS.ELIGIBILITY_DATE CENSUS_ELIGIBILITY_DATE, CENSUS.PROJECTED_ELIGIBILITY_DATE, PAYROLL.PROJECTED_ELIGIBILITY_DATE, CENSUS.MAX_PAYROLL_DATE CENSUS_MAX_PAYROLL_DATE, CENSUS.HR_CODE CENSUS_HR_CODE, CENSUS.HIRE_DATE CENSUS_HIRE_DATE, CENSUS.ADJUSTED_HIRE_DATE CENSUS_ADJUSTED_HIRE_DATE  
   , census.employment_status, census.employment_sub_type, census.employment_status_date
from  
(  
  with TEMP as   
    (  --get max payroll date for census
    select EMP.PLAN_UUID, EMP.SOCIAL_SECURITY_NUMBER, max(EMP.PAYROLL_DATE) MAX_PAYROLL_DATE from EMPLOYEES EMP  
    join payrolls pr on pr.payroll_uuid =  emp.payroll_uuid  
    where emp.plan_uuid = '6a661826d8cd4e768c0cecf4aeb2f27a'
    and pr.is_census = 1  
    and PR.FILE_PREFIX= 'CR'      
    group by emp.plan_uuid, emp.social_security_number  
    )    
  select E.PLAN_UUID, E.SOCIAL_SECURITY_NUMBER, SE.ELIGIBILITY_DATE, E.PAYROLL_DATE MAX_PAYROLL_DATE, E.HR_CODE, E.HIRE_DATE, 
  E.ADJUSTED_HIRE_DATE, e.employment_status, e.employment_sub_type, e.employment_status_date, SE.PROJECTED_ELIGIBILITY_DATE
  from SOURCEELIGIBILITY SE  
  join EMPLOYEES E on E.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID  
  join PAYROLLS P on P.PAYROLL_UUID=E.PAYROLL_UUID  
  join TEMP on TEMP.SOCIAL_SECURITY_NUMBER=E.SOCIAL_SECURITY_NUMBER and TEMP.MAX_PAYROLL_DATE=E.PAYROLL_DATE and TEMP.PLAN_UUID=E.PLAN_UUID  
  where E.PLAN_UUID = '6a661826d8cd4e768c0cecf4aeb2f27a' 
  and source='F'  
  and P.IS_CENSUS=1
) census join  
(  
  with temp as (--get max payroll date for adjustments
    select EMP.PLAN_UUID, EMP.SOCIAL_SECURITY_NUMBER, max(EMP.PAYROLL_DATE) MAX_PAYROLL_DATE from EMPLOYEES EMP  
    --join PAYROLLS PR on PR.PAYROLL_UUID =  EMP.PAYROLL_UUID  
    where EMP.PLAN_UUID = '6a661826d8cd4e768c0cecf4aeb2f27a'
    --and PR.FILE_PREFIX= 'CR'       
     and emp.is_adjustment=1  
    group by EMP.PLAN_UUID, EMP.SOCIAL_SECURITY_NUMBER  
  )  
  select E.PLAN_UUID, E.SOCIAL_SECURITY_NUMBER, E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.PAYROLL_DATE MAX_PAYROLL_DATE, E.EMPLOYMENT_STATUS, E.EMPLOYMENT_SUB_TYPE, 
  E.EMPLOYMENT_STATUS_DATE, E.TERMINATION_DATE, E.REPORTED_PAYROLL_FREQUENCY, E.HIRE_DATE, E.ADJUSTED_HIRE_DATE, E.REPORTED_LOCATION, E.HR_CODE, SE.ELIGIBILITY_DATE, SE.PROJECTED_ELIGIBILITY_DATE  
   from sourceeligibility se  
  join EMPLOYEES E on E.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID  
  --join PAYROLL_PLANS PP on PP.PLAN_UUID = E.PLAN_UUID  
  join PAYROLLS P on P.PAYROLL_UUID=E.PAYROLL_UUID  
  join TEMP on TEMP.SOCIAL_SECURITY_NUMBER=E.SOCIAL_SECURITY_NUMBER and TEMP.MAX_PAYROLL_DATE=E.PAYROLL_DATE and TEMP.PLAN_UUID=E.PLAN_UUID  
  where E.PLAN_UUID = '6a661826d8cd4e768c0cecf4aeb2f27a' 
  and source='F' and P.IS_CENSUS = 0  
    and P.FILE_PREFIX= 'CR' 
    and e.is_adjustment=1
) PAYROLL on CENSUS.PLAN_UUID=PAYROLL.PLAN_UUID and CENSUS.SOCIAL_SECURITY_NUMBER=PAYROLL.SOCIAL_SECURITY_NUMBER 
--ignore parts who switched sub area’s since that should trigger a recalculation in the payroll and the census for eligibility
and CENSUS.HR_CODE=PAYROLL.HR_CODE  
join payroll_plans pp on census.PLAN_UUID = pp.PLAN_UUID  
where   
(  
 --only need to fix participant who lose eligibility if census eligibility is greater than adjustment records eligibility date,
 --if adoh is changing forward it will get recalculated since the system will respect the latest adoh you have
(census.eligibility_date > payroll.eligibility_date)
or  
(CENSUS.PROJECTED_ELIGIBILITY_DATE > PAYROLL.ELIGIBILITY_DATE)
or  
(CENSUS.PROJECTED_ELIGIBILITY_DATE > PAYROLL.PROJECTED_ELIGIBILITY_DATE)
--or
 --ignore where eligibility date > census_payroll_date since it was in the future at the time
--((CENSUS.ELIGIBILITY_DATE is null and PAYROLL.ELIGIBILITY_DATE is not null and PAYROLL.ELIGIBILITY_DATE <= CENSUS.MAX_PAYROLL_DATE))  
)
;










update SOURCEELIGIBILITY set ELIGIBILITY_DATE = TO_DATE('XXXX','dd-mon-yyyy'), PROJECTED_ELIGIBILITY_DATE = null
where id in (select se.ID from SOURCEELIGIBILITY SE 
join EMPLOYEES EE on SE.EMPLOYEE_SNAPSHOT_ID = EE.EMPLOYEE_SNAPSHOT_ID
join payrolls p on ee.payroll_uuid = p.payroll_uuid
join PAYROLL_PLANS PP on EE.PLAN_UUID = PP.PLAN_UUID
where EE.SOCIAL_SECURITY_NUMBER = 'XXXX'
and PP.PLAN_XSID = 'XXXXXX'
and p.is_census = 1
and SE.source = 'X');


select * from employees where ee.hr_code in ('S01','S02','S03','S04','S05','H01','H02','H03','H04','H05','H06','H07','H08','H09')

select SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE, ADJUSTED_HIRE_DATE, PAYROLL_DATE from EMPLOYEES 
  join (select SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE, ADJUSTED_HIRE_DATE, max(PAYROLL_DATE) from EMPLOYEES
        group by SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE, ADJUSTED_HIRE_DATE);

select * from EMPLOYEES EE 
  join (select EE.SOCIAL_SECURITY_NUMBER, EE.PLAN_UUID, EE.location, EE.HR_CODE, EE.ADJUSTED_HIRE_DATE from EMPLOYEES EE
    join (select SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE, max(PAYROLL_DATE) as PAYROLL_DATE from EMPLOYEES
          group by SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE) MAX_EMP
    on EE.SOCIAL_SECURITY_NUMBER = MAX_EMP.SOCIAL_SECURITY_NUMBER and EE.PLAN_UUID = MAX_EMP.PLAN_UUID 
    and EE.location = MAX_EMP.location and EE.HR_CODE  = MAX_EMP.HR_CODE and EE.PAYROLL_DATE  = MAX_EMP.PAYROLL_DATE) MAX_EMP
  on EE.SOCIAL_SECURITY_NUMBER = MAX_EMP.SOCIAL_SECURITY_NUMBER and EE.PLAN_UUID = MAX_EMP.PLAN_UUID 
  and EE.location = MAX_EMP.location and EE.HR_CODE  = MAX_EMP.HR_CODE and MAX_EMP.ADJUSTED_HIRE_DATE != EE.ADJUSTED_HIRE_DATE
where EE.HR_CODE in ('S01','S02','S03','S04','S05','H01','H02','H03','H04','H05','H06','H07','H08','H09')
order by EE.SOCIAL_SECURITY_NUMBER, ee.payroll_date
;

  select EE.SOCIAL_SECURITY_NUMBER, ee.payroll_date, EE.ADJUSTED_HIRE_DATE, SE.ELIGIBILITY_DATE from EMPLOYEES EE 
    join sourceeligibility se on ee.employee_snapshot_id = SE.EMPLOYEE_SNAPSHOT_ID
    join (select * from (
      select EE.SOCIAL_SECURITY_NUMBER, EE.PLAN_UUID, EE.location, EE.HR_CODE, COUNT(unique EE.ADJUSTED_HIRE_DATE) as count from EMPLOYEES EE
      where EE.HR_CODE in ('S01','S02','S03','S04','S05','H01','H02','H03','H04','H05','H06','H07','H08','H09')
      group by SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE)
      where COUNT > 1) EE2 on EE.SOCIAL_SECURITY_NUMBER = EE2.SOCIAL_SECURITY_NUMBER and EE.PLAN_UUID = EE2.PLAN_UUID and EE.location = EE2.location and EE.HR_CODE  = EE2.HR_CODE and EE.payroll_date  = EE2.payroll_date
    join (select * from (
      select EE.SOCIAL_SECURITY_NUMBER, EE.PLAN_UUID, EE.location, EE.HR_CODE, se.source, COUNT(unique se.eligibility_date) as COUNT from EMPLOYEES EE
      join sourceeligibility se on se.employee_snapshot_id = ee.employee_snapshot_id
      where EE.HR_CODE in ('S01','S02','S03','S04','S05','H01','H02','H03','H04','H05','H06','H07','H08','H09')
      group by SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, HR_CODE, SE.source)
      where COUNT = 1) EE3 on EE2.SOCIAL_SECURITY_NUMBER = EE3.SOCIAL_SECURITY_NUMBER and EE2.PLAN_UUID = EE3.PLAN_UUID and EE2.location = EE3.location and EE2.HR_CODE  = EE3.HR_CODE and EE2.payroll_date  = EE3.payroll_date
      

;

select payroll_date, ADJUSTED_HIRE_DATE from employees where social_security_number = '490-21-1105';


select PPS.SSN, PPS.plan, PPS.source, SEED_YTD.YTD_contrib seed_Contrib, PPS.SUM_CONTRIB cr_sum_contrib,
case when SEED_YTD.YTD_CONTRIB is null then PPS.SUM_CONTRIB else PPS.SUM_CONTRIB+SEED_YTD.YTD_CONTRIB end SUM_CONTRIB , 
YTD.YTD_CONTRIB, ',' || '''' || YTD.PARTICIPANT_YTD_CONTRI_ID || '''' PARTICIPANT_YTD_CONTRI_ID  
from 
    (select c.username as ssn, m.sourcename as source, px.plan_xsid as plan, sum(pv.contribution) as SUM_CONTRIB, al.ID as loc_id
    from PAYROLL_PRODUCT_SPLIT PV 
    join PAYROLL_INPUT PI on PI.PAYROLL_INPUT_ID = PV.PAYROLL_INPUT_ID 
    join ACCOUNTENROLLMENT AE on AE.ACCOUNTENROLLMENTID = PI.ACCOUNTENROLLMENTID 
    join ACCOUNTLOCATIONS AL on AE.ACCOUNTLOCATION_ID = AL.id 
    join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID 
    join ACCOUNTSOURCE ACS on ACS.ACCOUNTSOURCEID = PI.ACCOUNTSOURCEID 
    join MASTERSOURCES M on M.MASTERSOURCESID = ACS.MASTERSOURCESID 
    join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AE.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
    where PI.PAYROLL_DATE >'31-DEC-2013' 
    and PI.INPUT_TYPE in ('COMBINED', 'ADJUSTMENT')
    and PI.REMITTANCE_TYPE in ('CONTRIBUTION', 'ADJUSTMENT')
    group by C.USERNAME, M.SOURCENAME, PX.PLAN_XSID, al.ID) PPS  
join  
    (select PX.PLAN_XSID as YTD_PLAN, C.USERNAME as YTD_SSN, MS.SOURCENAME as YTD_SOURCE, PYC.CONTRIBUTION_YTD as YTD_CONTRIB, PARTICIPANT_YTD_CONTRI_ID, AL.id as LOC_ID
    from PARTICIPANT_YTD_CONTRI PYC 
    join CUSTOMER C on C.CUSTOMERID = PYC.CUSTOMERID 
    join ACCOUNTLOCATIONS AL on PYC.ACCOUNTLOCATION_ID = AL.id 
    join ACCOUNTSOURCE ASRC on ASRC.ACCOUNTSOURCEID = PYC.ACCOUNTSOURCEID 
    join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AL.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
    join MASTERSOURCES MS on MS.MASTERSOURCESID = ASRC.MASTERSOURCESID 
    where PYC.FIN_YEAR>=2014 
    ) YTD 
on PPS.SSN = YTD.YTD_SSN and PPS.plan = YTD.YTD_PLAN and PPS.source = YTD.YTD_SOURCE and PPS.LOC_ID = YTD.LOC_ID 
left outer join
    (select PX.PLAN_XSID as YTD_PLAN, C.USERNAME as YTD_SSN, MS.SOURCENAME as YTD_SOURCE, PYCH.CONTRIBUTION_YTD as YTD_CONTRIB, PYCH.PARTICIPANT_YTD_CONTRI_ID, AL.id as LOC_ID
    from PARTICIPANT_YTD_CONTRI_HIST PYCH
    join PARTICIPANT_YTD_CONTRI PYC on PYC.PARTICIPANT_YTD_CONTRI_ID = PYCH.PARTICIPANT_YTD_CONTRI_ID
    join CUSTOMER C on C.CUSTOMERID = PYC.CUSTOMERID 
    join ACCOUNTLOCATIONS AL on PYC.ACCOUNTLOCATION_ID = AL.id 
    join ACCOUNTSOURCE ASRC on ASRC.ACCOUNTSOURCEID = PYC.ACCOUNTSOURCEID 
    join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AL.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
    join MASTERSOURCES MS on MS.MASTERSOURCESID = ASRC.MASTERSOURCESID 
    where PYC.FIN_YEAR>=2014 
    ) SEED_YTD
on PPS.SSN = SEED_YTD.YTD_SSN and PPS.plan = SEED_YTD.YTD_PLAN and PPS.source = SEED_YTD.YTD_SOURCE and PPS.LOC_ID = SEED_YTD.LOC_ID and YTD.PARTICIPANT_YTD_CONTRI_ID = SEED_YTD.PARTICIPANT_YTD_CONTRI_ID 
where PPS.SUM_CONTRIB != YTD.YTD_CONTRIB
or (SEED_YTD.YTD_CONTRIB is not null and PPS.SUM_CONTRIB+SEED_YTD.YTD_CONTRIB != YTD.YTD_CONTRIB)
and PPS.plan = '403401';
and PPS.SSN in  
(
);


select * from CUSTOMER where USERNAME = '661790103'; 7bf709ef26374ad1819c77a5919a1158
select * from accountenrollment where customerid = '0714fa1baf37471184356f059923ea3f';
select * from PAYROLL_INPUT where ACCOUNTENROLLMENTID 
in ('d14ce04e155346bd99f7c452661370bd','d14ce04e155346bd99f7c452661370bd','d14ce04e155346bd99f7c452661370bd','d14ce04e155346bd99f7c452661370bd');

select * from PAYROLL_PRODUCT_SPLIT where PAYROLL_INPUT_ID 
in ('72e4ec0f0dee4f5e931b57de0539a03a','92570fc8d9964a6f94b29ef075f73e72','dc67f9300e9f48feb6ef65447c740f22','9c422a21f92d4c47865fcf7e59385f26','453078dec5f243a4b1fb24ec6363b4d4');

select c.username as ssn, M.SOURCENAME, PX.PLAN_XSID, pv.contribution as SUM_CONTRIB 
from PAYROLL_PRODUCT_SPLIT PV 
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id 
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid 
join customer c on c.customerid = ae.customerid 
join accountsource acs on acs.accountsourceid = pi.accountsourceid 
join mastersources m on m.mastersourcesid = acs.mastersourcesid 
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AE.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
where 1=1
--and PI.PAYROLL_DATE >'31-DEC-2013' 
and PI.INPUT_TYPE in ('COMBINED', 'ADJUSTMENT')
and PI.REMITTANCE_TYPE in ('CONTRIBUTION', 'ADJUSTMENT')
and C.USERNAME = '710401012'
--group by C.USERNAME, M.SOURCENAME, PX.PLAN_XSID
;

SELECT px.plan_xsid as ytd_plan, c.username as ytd_ssn, ms.sourcename as ytd_source, PYC.FIN_YEAR, pyc.contribution_ytd as YTD_CONTRIB, pyc.PARTICIPANT_YTD_CONTRI_ID 
from PARTICIPANT_YTD_CONTRI_HIST PYCH
join PARTICIPANT_YTD_CONTRI PYC on PYC.PARTICIPANT_YTD_CONTRI_ID = PYCH.PARTICIPANT_YTD_CONTRI_ID
JOIN customer c ON c.customerid = pyc.customerid 
join ACCOUNTLOCATIONS al on pyc.accountlocation_id = al.ID 
join ACCOUNTSOURCE ASRC on ASRC.ACCOUNTSOURCEID = PYC.ACCOUNTSOURCEID 
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AL.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
join MASTERSOURCES MS on MS.MASTERSOURCESID = ASRC.MASTERSOURCESID
where PYC.FIN_YEAR>=2014 
and C.USERNAME = '661790103';

select * from ACCOUNTENROLLMENT AE 
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID 
where C.USERNAME = '661790103';

select * from PARTICIPANT_YTD_CONTRI_HIST where PARTICIPANT_YTD_CONTRI_ID = 'f2d02d98c9b14a038ca12f4156b03c3a';

select C.USERNAME, PYC.FIN_YEAR, PYC.ACCOUNTSOURCEID, PYC.ACCOUNTLOCATION_ID, PYCH.CONTRIBUTION_YTD, PYC.CONTRIBUTION_YTD from PARTICIPANT_YTD_CONTRI_HIST PYCH
join PARTICIPANT_YTD_CONTRI PYC on PYC.PARTICIPANT_YTD_CONTRI_ID = PYCH.PARTICIPANT_YTD_CONTRI_ID
join CUSTOMER C on C.CUSTOMERID = PYC.CUSTOMERID 
where C.USERNAME = '710401012';

group by PYC.CUSTOMERID, PYC.FIN_YEAR, PYC.ACCOUNTSOURCEID, PYC.ACCOUNTLOCATION_ID;
; where PARTICIPANT_YTD_CONTRI_ID in ('73a4fe6fc6ca463885b866a722eb8120','1853e6d6e5a446a7a01b24e283fd1b16','82bacdb8f709409cad77c3b547425d54','6f35f506f34a4c858cb96e3b9b17c1a9');


select max(payroll_date) from EMPLOYEES where ADJUSTMENT_REASON is null;
select * from employees_edit_history where employee_uuid = 'f44d5c718f234f9d840970a94a06d473';
select * from SOURCE_ENROLLMENT;
select * from EMPLOYEES where EMPLOYEE_UUID in (select EMPLOYEE_UUID from PAYROLL_DATA 
where CODE is not null and column_value < 0 ) 
and PLAN_UUID in (select PLAN_UUID from PAYROLL_PLANS where CLIENT_XSID = '054303');
select COUNT(*) from PAYROLL_PLANS;

update EMPLOYEES set ADJUSTMENT_REASON = null where SOCIAL_SECURITY_NUMBER = '847-17-2097';
select COUNT(*) from EMPLOYEES
where ADJUSTMENT_REASON is null ;
select EMPLOYEE_UUID, ADJUSTMENT_REASON from EMPLOYEES where SOCIAL_SECURITY_NUMBER = '847-17-2097';
select employee_uuid, ADJUSTMENT_REASON from EMPLOYEES where EMPLOYEE_UUID in ('1efb8422e6bb47368e3901880a2218ba','1acaf4d3e14f45dd842c7f3f0a378b3b', 'b6fb7a884f20402cbe8719b58f301f86');
and PLAN_UUID in (select PLAN_UUID from PAYROLL_PLANS where CLIENT_XSID = '054303');

select * from EMPLOYEES where;
update EMPLOYEES set ADJUSTMENT_REASON = 0 where ADJUSTMENT_REASON is null;


select PPS.SSN, PPS.plan, PPS.source, PPS.SUM_CONTRIB, YTD.YTD_CONTRIB , ',' || '''' || PARTICIPANT_YTD_CONTRI_ID || '''' PARTICIPANT_YTD_CONTRI_ID  from 
(select c.username as ssn, m.sourcename as source, px.plan_xsid as plan, sum(pv.contribution) as SUM_CONTRIB 
from PAYROLL_PRODUCT_SPLIT PV 
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id 
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid 
join customer c on c.customerid = ae.customerid 
join accountsource acs on acs.accountsourceid = pi.accountsourceid 
join mastersources m on m.mastersourcesid = acs.mastersourcesid 
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AE.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
where PI.PAYROLL_DATE >'31-DEC-2013'  
group by C.USERNAME, M.SOURCENAME, PX.PLAN_XSID) PPS  
join  
(SELECT px.plan_xsid as ytd_plan, c.username as ytd_ssn, ms.sourcename as ytd_source, pyc.contribution_ytd as YTD_CONTRIB, PARTICIPANT_YTD_CONTRI_ID 
from PARTICIPANT_YTD_CONTRI PYC 
JOIN customer c ON c.customerid = pyc.customerid 
join ACCOUNTLOCATIONS al on pyc.accountlocation_id = al.ID 
join ACCOUNTSOURCE ASRC on ASRC.ACCOUNTSOURCEID = PYC.ACCOUNTSOURCEID 
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AL.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4 
join MASTERSOURCES MS on MS.MASTERSOURCESID = ASRC.MASTERSOURCESID 
where PYC.FIN_YEAR>=2014 
) YTD 
on PPS.SSN = YTD.YTD_SSN and PPS.plan = YTD.YTD_PLAN and PPS.source = YTD.YTD_SOURCE 
where PPS.SUM_CONTRIB != YTD.YTD_CONTRIB 
and PPS.SSN in  
(
);


    select unique  pp.client_xsid, pp.employer_name, pp.plan_xsid, pp.plan_name from GROUPDEFINITION GD
    INNER JOIN appliedRuleDef ard ON ard.group_definition_id = gd.id
    inner join APPLIEDRULEDEFSET ARDS on ARDS.id = ARD.APPLIEDRULEDEFSET_ID
    join (select PLAN_ID, max(EFFECTIVE_DT) as MAX_DT from APPLIEDRULEDEFSET 
    group by PLAN_ID) ARSMAX on ARSMAX.MAX_DT = ARDS.EFFECTIVE_DT and ARSMAX.PLAN_ID = ARDS.PLAN_ID
    inner join PAYROLL_PLANS PP on ARDS.PLAN_ID = PP.PLAN_XSID
    inner join VESTINGATTRIBUTE SA on SA.id = ARD.VESTING_ATTR_ID
    join VESTINGSCHEDULE VS on SA.VESTING_SCHEDULE_ID = VS.id
    where 1=1
    --and ARDS.PLAN_ID = PLAN ---- PLAN
    --and SA.PURPOSE = 3
    and vs.name = ' Immediate'
    and ARDS.EFFECTIVE_DT is not null
    order by pp.client_xsid, pp.plan_xsid;
    
    select vs.name,va.* from VESTINGATTRIBUTE VA
    join VESTINGSCHEDULE VS on VA.VESTING_SCHEDULE_ID = VS.id
    where vs.name != ' Immediate';
    select * from VESTINGSCHEDULE;
    select * from PAYROLL_PLANS;
    select * from client;



update SERVICEACCUMULATOR
set SERVICE_CREDIT = NEWYOS ----NEW YOS
where id in (
select id from SERVICEACCUMULATOR SA
where SA.SERVICE_IDENTIFIER in (
    select SA.SERVICE_IDENTIFIER from GROUPDEFINITION GD
    INNER JOIN appliedRuleDef ard ON ard.group_definition_id = gd.id
    inner join APPLIEDRULEDEFSET ARDS on ARDS.id = ARD.APPLIEDRULEDEFSET_ID
    join (select PLAN_ID, max(EFFECTIVE_DT) as MAX_DT from APPLIEDRULEDEFSET 
    group by PLAN_ID) ARSMAX on ARSMAX.MAX_DT = ARDS.EFFECTIVE_DT and ARSMAX.PLAN_ID = ARDS.PLAN_ID
    inner join PAYROLL_PLANS PP on ARDS.PLAN_ID = PP.PLAN_XSID
    inner join SERVICEATTRIBUTE SA on SA.id = ARD.SERVICE_ATTR_ID
    WHERE ARDS.PLAN_ID = PLAN ---- PLAN
    and SA.PURPOSE = 3
    and ARDS.EFFECTIVE_DT is not null
)
and EMPLOYEE_SNAPSHOT_ID in 
(select EMPLOYEE_SNAPSHOT_ID  from EMPLOYEES  where EMPLOYEE_UUID = EMPLOYEE_UUID_FROM_STEP_2) ---- EMP UUID
);


update SERVICEACCUMULATOR
set SERVICE_CREDIT = 2 ----NEW YOS
where id in (
select id from SERVICEACCUMULATOR SA
where SA.SERVICE_IDENTIFIER in (
    select SA.SERVICE_IDENTIFIER from GROUPDEFINITION GD
    INNER JOIN appliedRuleDef ard ON ard.group_definition_id = gd.id
    inner join APPLIEDRULEDEFSET ARDS on ARDS.id = ARD.APPLIEDRULEDEFSET_ID
    join (select PLAN_ID, max(EFFECTIVE_DT) as MAX_DT from APPLIEDRULEDEFSET 
    group by PLAN_ID) ARSMAX on ARSMAX.MAX_DT = ARDS.EFFECTIVE_DT and ARSMAX.PLAN_ID = ARDS.PLAN_ID
    inner join PAYROLL_PLANS PP on ARDS.PLAN_ID = PP.PLAN_XSID
    inner join SERVICEATTRIBUTE SA on SA.id = ARD.SERVICE_ATTR_ID
    WHERE ARDS.PLAN_ID = '102488' ---- PLAN
    and SA.PURPOSE = 3
    and ARDS.EFFECTIVE_DT is not null
)
and EMPLOYEE_SNAPSHOT_ID in 
(select EMPLOYEE_SNAPSHOT_ID  from EMPLOYEES  where EMPLOYEE_UUID = '3df35abc22ac43d290913795f195e905') ---- EMP UUID
);


select * from EMPLOYEES; where EMPLOYEE_SNAPSHOT_ID = 'ee06867e4a1f4ced8af07461212b63ab';
select * from PAYROLL_PLANS where PLAN_UUID = '9bb4b364042f436dad7cf66c42f75767';
--AND ards.effective_dt  = '09-OCT-13'
        
select * from APPLIEDRULEDEFSET ARS
join (select PLAN_ID, max(EFFECTIVE_DT) as MAX_DT from APPLIEDRULEDEFSET 
group by PLAN_ID) ARSMAX on ARSMAX.MAX_DT = ARS.EFFECTIVE_DT and ARSMAX.PLAN_ID = ARS.PLAN_ID
where ars.PLAN_ID = '406138'
and EFFECTIVE_DT is not null;
ORDER BY EFFECTIVE_DT DESC;

 
 
insert into PAYROLL_HIST (
select sys_guid(), LOCATION_CUSTOMER_ID, 2013, YEARS_OF_SERVICE, 0, 0, 0, 0, 0, 0, 0, 0, to_date('31-OCT-13', 'dd-mon-YY'), sysdate, to_date('31-DEC-13', 'dd-mon-YY'), 0, 0, 'ADJUSTMENT', 0, 0, 0, 0
 from PAYROLL_HIST where PAYROLL_HIST_ID = (select PH.PAYROLL_HIST_ID from PAYROLL_HIST PH 
join LOCATION_CUSTOMER LC on PH.LOCATION_CUSTOMER_ID = LC.LOCATION_CUSTOMER_ID
join CUSTOMER C on LC.CUSTOMER_PK = C.PK
where LC.HR_AREA = 'H403' and LC.HR_SUBAREA = 'H03' -- New Location
and PH.FIN_YEAR = 2014
and c.username = '123456789')); -- SSN

select c.username, pppc.payroll_date, pppc.per_pay_hrs, pppc.* from payroll_per_pay_comp pppc 
join payroll_hist ph on pppc.payroll_hist_id = ph.payroll_hist_id
join location_customer lc on ph.location_customer_id = lc.location_customer_id
join customer c on lc.customer_pk = c.pk
where C.USERNAME = '123456789'
and PH.FIN_YEAR = 2013
and LC.HR_AREA = 'H403' and LC.HR_SUBAREA = 'H03'; -- New Location
order by PPPC.MODIFY_DATE desc;, PPPC.PAYROLL_DATE;

 update PAYROLL_HIST set LOCATION_CUSTOMER_ID = 56524 where PAYROLL_HIST_ID = '3e6dd5521f0a474d96202bb64a684728';
update LOCATION_CUSTOMER set CUSTOMER_PK = 54318  where LOCATION_CUSTOMER_ID = 56524;

select PH.* from PAYROLL_HIST PH 
join LOCATION_CUSTOMER LC on PH.LOCATION_CUSTOMER_ID = LC.LOCATION_CUSTOMER_ID
join CUSTOMER C on LC.CUSTOMER_PK = C.PK
where LC.HR_AREA = 'H403' and LC.HR_SUBAREA = 'H03'
and c.username = ''
where LC.CUSTOMER_PK = 54318;

select * from PAYROLL_HIST where LAST_BATCH_TYPE not in ('COMBINED', 'SEED');
select * from LOCATION_CUSTOMER where LOCATION_CUSTOMER_ID = 56523;

select * from CUSTOMER where CUSTOMERID = 'd2ffdb02c35441b6bfa7cbf9b515303a';
select * from CUSTOMER where CUSTOMERID = 'd2ffdb02c35441b6bfa7cbf9b515303a' or CUSTOMERID = 'c449c066ec444bb5b73ce5ec6dcae11c';
select * from CUSTOMER where USERNAME  = '008385752';
select ACCOUNTENROLLMENTID, CUSTOMERID, PK, ACCOUNTLOCATION_ID, STATUS from ACCOUNTENROLLMENT
where PK in ('73120','239072');
select ACCOUNTENROLLMENTID, CUSTOMERID, PK, ACCOUNTLOCATION_ID, STATUS from ACCOUNTENROLLMENT
where CUSTOMERID in ('d2ffdb02c35441b6bfa7cbf9b515303a','c449c066ec444bb5b73ce5ec6dcae11c');
D2FFDB02C35441B6BFA7CBF9B515303A
c449c066ec444bb5b73ce5ec6dcae11c

select C.USERNAME, PI.PAYROLL_DATE, PI.CONTRIBUTION from PAYROLL_INPUT PI
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID
where PI.CONTRIBUTION <  0
and pi.INPUT_Name = 'CR_014111_100439_JPL1_BASE_120217_180605.txt';

select * from CUSTOMER where CUSTOMERID = '3373d6f7acbb4d15b883902c4b4f9d24';
select * from participant_YTD_contri where CUSTOMERID = '76f46fc006c840a1a3a3a76458e72e3d';
select * from PARTICIPANT_YTD_CONTRI where PARTICIPANT_YTD_CONTRI_ID = 'a3827e53e5364f62ada0e118407c2a4e';

select pi.payroll_date, ae.accountsprovidedID, pv.*, ae.* from PAYROLL_PRODUCT_SPLIT PV
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id
join ACCOUNTENROLLMENT AE on AE.ACCOUNTENROLLMENTID = PI.ACCOUNTENROLLMENTID
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID
where C.CUSTOMERID = '3373d6f7acbb4d15b883902c4b4f9d24'
order by pi.payroll_date;

select c.customerid, Pi.PAYROLL_DATE, Pv.CONTRIBUTION, ms.sourcename from  PAYROLL_PRODUCT_SPLIT PV 
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id 
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid 
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID 
join accountsource acs on acs.accountsourceid = pi.accountsourceid 
join MASTERSOURCES MS on MS.MASTERSOURCESID = ACS.MASTERSOURCESID 
where PI.PAYROLL_DATE >'31-DEC-2013'  
and c.customerid = '76f46fc006c840a1a3a3a76458e72e3d'
and pi.status = 'DISBURSED'
order by sourcename, payroll_date;


select * from accountlocations;
select PPS.SSN, PPS.plan, PPS.source, PPS.SUM_CONTRIB, YTD.YTD_CONTRIB from
(select C.USERNAME as SSN, M.SOURCENAME as source, PX.PLAN_XSID as plan, SUM(PV.CONTRIBUTION) as SUM_CONTRIB
from PAYROLL_PRODUCT_SPLIT PV
join payroll_input pi on pi.payroll_input_id = pv.payroll_input_id
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid
join customer c on c.customerid = ae.customerid
join accountsource acs on acs.accountsourceid = pi.accountsourceid
join mastersources m on m.mastersourcesid = acs.mastersourcesid
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AE.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4
where PI.PAYROLL_DATE <='31-DEC-2014'
and PI.PAYROLL_DATE >= '1-JAN-2014'
--and c.customerid = '3373d6f7acbb4d15b883902c4b4f9d24'
and pi.status = 'DISBURSED'
group by C.USERNAME, M.SOURCENAME, PX.PLAN_XSID) PPS 
join 
(SELECT px.plan_xsid as ytd_plan, c.username as ytd_ssn, ms.sourcename as ytd_source, pyc.contribution_ytd as YTD_CONTRIB, pyc.*
from PARTICIPANT_YTD_CONTRI PYC
JOIN customer c ON c.customerid = pyc.customerid
join ACCOUNTLOCATIONS al on pyc.accountlocation_id = al.ID
join ACCOUNTSOURCE ASRC on ASRC.ACCOUNTSOURCEID = PYC.ACCOUNTSOURCEID
join PLANXSMAPPING PX on PX.ACCOUNTSPROVIDEDID = AL.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4
join MASTERSOURCES MS on MS.MASTERSOURCESID = ASRC.MASTERSOURCESID
where PYC.FIN_YEAR=2014
--and c.customerid = '3373d6f7acbb4d15b883902c4b4f9d24'
) YTD
on PPS.SSN = YTD.YTD_SSN and PPS.plan = YTD.YTD_PLAN and PPS.source = YTD.YTD_SOURCE
where --PPS.SUM_CONTRIB != YTD.YTD_CONTRIB
--and PPS.source = 'F'
--and PPS.plan = '403401'
--and 
PPS.SSN in ('006676914');


select C.USERNAME, PI.PAYROLL_DATE, PI.CONTRIBUTION from PAYROLL_INPUT PI
join accountenrollment ae on ae.accountenrollmentid = pi.accountenrollmentid
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID
where PI.CONTRIBUTION <  0
and pi.INPUT_Name = 'A_014111_100439_JPL1_BASE_120217_180605.txt';

select * from PARTICIPANT_YTD_CONTRI  where CUSTOMERID = '2151cf4ed3624d91a2791677ded4d7b3';
select * from CUSTOMER where CUSTOMERID = 'bef4f1788af44038bb02d5d6333b8195';



select * from PAYROLL_INPUT;
select * from BATCH_PROCESS_DETAIL where row_content is not null;




select E2.EMPLOYEE_UUID, E1.* from EMPLOYEES E1
join (select * from employees where CREATION_SOURCE = '3') e2 on E1.PLAN_UUID = E2.PLAN_UUID and E1.SOCIAL_SECURITY_NUMBER = E2.SOCIAL_SECURITY_NUMBER
and E1.PAYROLL_DATE = E2.PAYROLL_DATE and E1.EMPLOYEE_UUID != E2.EMPLOYEE_UUID
join PAYROLL_PLANS PP on PP.PLAN_UUID = E1.PLAN_UUID and pp.plan_xsid in ('403401','151576');
where E2.CREATION_SOURCE = '3';
order by E1.SOCIAL_SECURITY_NUMBER, E1.PAYROLL_DATE;

select * from employees e2 where E2.CREATION_SOURCE = '3'; 

select * from employees;
select AE.ACCOUNTENROLLMENTID, c.USERNAME, PX.PLAN_XSID, lc.status as Employment_Status, AE.STATUS, AE.ENABLED, AE.ELIGIBLE, AE.EFFECTIVE_START_DATE,
AE.EFFECTIVE_END_DATE, AE.CURRENTLY_EFFECTIVE, AE.ACCOUNT_TYPE, AE.FEEDBACK_INCLUDED_DATE, 
AE.FEEDBACK_INELIG_SEND_FLAG, AE.FEEDBACK_INELIG_SENT_DATE, AE.LASTACCESS, ae.*  from ACCOUNTENROLLMENT AE
join CUSTOMER C on C.CUSTOMERID = AE.CUSTOMERID
join PLANXSMAPPING PX on AE.ACCOUNTSPROVIDEDID = PX.ACCOUNTSPROVIDEDID and PX.XSTYPE_ID = 4
join LOCATION_CUSTOMER LC on LC.CUSTOMER_PK = C.PK
--where AE.STATUS = 'NOT_ELIGIBLE'
--where AE.FEEDBACK_INCLUDED_DATE is null
where C.USERNAME = '003427551'  order by PX.PLAN_XSID, AE.LASTACCESS
;

delete from ACCOUNTENROLLMENT where ACCOUNTENROLLMENTID = '3ce1c665016a4c11bdc2783ec41d3079';

update ACCOUNTENROLLMENT set STATUS = 'NOT_ELIGIBLE', EFFECTIVE_END_DATE = null
where ACCOUNTENROLLMENTID = '3ce1c665016a4c11bdc2783ec41d3079'
and STATUS = 'ELIGIBLE';

select * from PARTICIPANTDEFERRALS where ACCOUNTENROLLMENTID = '3ce1c665016a4c11bdc2783ec41d3079';

008250863
select * from customer where USERNAME = '008250863';
select * from EMPLOYEES where EMPLOYEE_UUID = 'b557fef8d8d94a88b81a7a107b48e41e';
select * from LOCATION_CUSTOMER;
select * from PLANXSMAPPING;
  --Adjustment File Bonus Not Equal to Stored Bonus
  select E.PAYROLL_DATE, E.EMPLOYEE_ID, PP.PLAN_XSID, PDH.DISPLAY_NAME, E.REPORTED_PAYROLL_FREQUENCY, PD.column_value as SYSTEM_BONUS, PDH.column_value as INCOMING_RECORD_BONUS 
  from EMPLOYEES E 
  join (select EEH.* from EMPLOYEES_EDIT_HISTORY EEH 
    join (select max(distinct EDIT_DATE) as EDIT_DATE, SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, PAYROLL_DATE, REPORTED_PAYROLL_FREQUENCY from EMPLOYEES_EDIT_HISTORY where UPDATED_BY = 'ADJUSTMENT' and ACTION_TAKEN = 'DELETE' group by SOCIAL_SECURITY_NUMBER, PLAN_UUID, location, PAYROLL_DATE, REPORTED_PAYROLL_FREQUENCY) 
    EEH1 on EEH1.SOCIAL_SECURITY_NUMBER = EEH.SOCIAL_SECURITY_NUMBER and EEH1.PLAN_UUID = EEH.PLAN_UUID and EEH1.location = EEH.location and EEH1.PAYROLL_DATE = EEH.PAYROLL_DATE and EEH1.EDIT_DATE = EEH.EDIT_DATE and                            EEH.REPORTED_PAYROLL_FREQUENCY = EEH1.REPORTED_PAYROLL_FREQUENCY 
  ) EEH on  E.SOCIAL_SECURITY_NUMBER    = EEH.SOCIAL_SECURITY_NUMBER and E.PLAN_UUID    = EEH.PLAN_UUID and E.location    = EEH.location and E.PAYROLL_DATE    = EEH.PAYROLL_DATE and                               EEH.REPORTED_PAYROLL_FREQUENCY = E.REPORTED_PAYROLL_FREQUENCY 
  join PAYROLL_DATA_HISTORY PDH on PDH.EMPLOYEE_UUID = EEH.EMPLOYEE_UUID and PDH.COLUMN_TYPE_UUID = '13062fe88c8b4091898699e3460b146c' 
  left outer join PAYROLL_DATA PD on PD.EMPLOYEE_UUID = E.EMPLOYEE_UUID and PD.COLUMN_TYPE_UUID = '13062fe88c8b4091898699e3460b146c' 
  join PAYROLL_PLANS PP on E.PLAN_UUID = PP.PLAN_UUID 
  where PP.PLAN_XSID in ('403400','403401','151576', '151562', '151579') 
  and (PDH.column_value != PD.column_value or (PD.column_value is null and PDH.column_value != 0)) 
  and E.EMPLOYEE_PLAN_STATUS != 'Z' 
  --and e.social_security_number = '412343321' 
  order by E.SOCIAL_SECURITY_NUMBER, E.PAYROLL_DATE,PP.PLAN_XSID 
  ;


--7 participants update 1000 hours on seed
select EMPLOYEE_UUID from EMPLOYEES where CREATION_SOURCE = 1 and SOCIAL_SECURITY_NUMBER = '008302179';

select EE.PAYROLL_DATE, EE.HOURS, EE.YTD_HOURS, EE.ADJUSTED_HIRE_DATE, EE.HR_CODE, se.* from SOURCEELIGIBILITY SE 
join EMPLOYEES EE on SE.EMPLOYEE_SNAPSHOT_ID = EE.EMPLOYEE_SNAPSHOT_ID
where EE.SOCIAL_SECURITY_NUMBER = '133654478'
and SE.source = 'F'
order by EE.PAYROLL_DATE;
--7 participants  
update SOURCEELIGIBILITY set ELIGIBILITY_DATE = TO_DATE('XXXX','dd-mon-yyyy'), PROJECTED_ELIGIBILITY_DATE = null
where id in (select se.ID from SOURCEELIGIBILITY SE 
join EMPLOYEES EE on SE.EMPLOYEE_SNAPSHOT_ID = EE.EMPLOYEE_SNAPSHOT_ID
join PAYROLL_PLANS PP on EE.PLAN_UUID = PP.PLAN_UUID
where EE.SOCIAL_SECURITY_NUMBER = 'XXXX'
and PP.PLAN_XSID = 'XXXXXX'
and SE.source = 'X');

update SOURCEELIGIBILITY set ELIGIBILITY_DATE = TO_DATE('DATE','dd-mon-yyyy'), PROJECTED_ELIGIBILITY_DATE = null, eligible = 1
where id in ('52bb0991a89c44be96ffc4cc2495e4a9', 'ca2942f02dd94e138bdc2a8d4aa6b256');

--EIS-02046
--SRI data clean up
select pp.plan_xsid, EMP.SOCIAL_SECURITY_NUMBER, emp.* from employees emp
join PAYROLL_PLANS PP on EMP.PLAN_UUID = PP.PLAN_UUID
join PAYROLL_DATA_HISTORY PDH on EMP.EMPLOYEE_UUID = PDH.EMPLOYEE_UUID
where 1=1
--and PP.PLAN_XSID in ('406325', '406326') --Only affects calculated match plans, SRI has in prod
and pdh.updated_by = 'ADJUSTMENT-PERFORMED'
and pdh.column_type_uuid = 'ec28b6b73e5a4153b271eb6a1699f31a' --This is the column type for contribution amounts
and PDH.CODE = 'D' --Only need them if they have received a D source before.
;

--EIS-04146
--Multiple ER calc'd sources data clean up
select pp.plan_xsid, EMP.SOCIAL_SECURITY_NUMBER, emp.* from EMPLOYEES EMP
join PAYROLL_PLANS PP on EMP.PLAN_UUID = PP.PLAN_UUID
join PAYROLL_DATA PD on EMP.EMPLOYEE_UUID = PD.EMPLOYEE_UUID and pd.code is not null
where pp.plan_xsid in ('406326', '406138')
and PD.COLUMN_TYPE_UUID = 'ec28b6b73e5a4153b271eb6a1699f31a' --This is the column type for contribution amounts
and PD.CODE in ('D', 'P', 'F') 
and emp.is_adjustment =1; --Only affects adjustments



-- Create Record in history table for audit purposes
insert into EMPLOYEES_EDIT_HISTORY 
(EDIT_DATE,HISTORY_ID,ACTION_TAKEN,EMPLOYEE_UUID, PAYROLL_UUID,PLAN_UUID,PAYROLL_DATE,SOCIAL_SECURITY_NUMBER,FULL_NAME,ADDRESS1,ADDRESS2,CITY,STATE,ZIP,BIRTH_DATE,HIRE_DATE,TERMINATION_DATE,REHIRE_DATE,COMPANY_DIVISION,HOURS,YTD_GROSS_WAGES,YTD_HOURS,FIRST_NAME,LAST_NAME,MIDDLE_NAME,location,DELETED_DATE,TOTAL_LOAN_PAYMENTS_ALLOCATED,EMPLOYER_MATCH,SAFE_HARBOR_MATCH,SAFE_HARBOR_NON_ELECTIVE,PROFIT_SHARING,REPORTED_LOCATION,TOTAL_YOS_FOR_ELIGIBILITY,TOTAL_YOS_FOR_VESTING,EMPLOYEE_PLAN_STATUS,EMPLOYMENT_STATUS,ELIGIBILITY_DATE,PROJECTED_ELIGIBILITY_DATE,VESTING_DATE,PROJECTED_VESTING_DATE,VESTING_PERCENTAGE,YTD_ANNIVERSARY_HOURS,ACCOUNT_TYPE,REPORTED_PAYROLL_FREQUENCY,EMPLOYEE_ID,EMPLOYEE_TITLE,ADDRESS3,COUNTRY_CODE,RESIDENCY_CODE,GENDER_ID,MARITAL_STATUS,PHONE_NUMBER1,PHONE_TYPE1,PHONE_EXTENSION1,PHONE_NUMBER2,PHONE_EXTENSION2,PHONE_TYPE2,EMAIL,REPORTED_PAYROLL_DATE,ADJUSTED_HIRE_DATE,EMPLOYMENT_SUB_TYPE,EMPLOYMENT_STATUS_DATE,EMPLOYEE_TYPE,PAYROLL_MODE,YOS,HCE_FLAG,KEY_FLAG,UNION_FLAG,PLAN_ENTRY_DATE,ALTERNATE_VESTING_START_DATE,HR_CODE,CALCULATION_METHOD_ID,CALCULATION_METHOD_RULESET_ID,FILE_UUID,YEARS_HISTORY_REPORTED,YTD_YEAR_TOTAL_CONTRIBUTION,HISTORY_YEAR,EMPLOYEE_SNAPSHOT_ID,PREV_EMPLOYEE_SNAPSHOT_ID,YEAR_TO_DATE_TYPE,CONTRIB_ELIGIBILITY_SOURCE_1,CONTRIB_ELIGIBILITY_DATE_1,CONTRIB_ELIGIBILITY_SOURCE_2,CONTRIB_ELIGIBILITY_DATE_2,CREATION_SOURCE,IS_ADJUSTMENT,BENEFITS_DATE,IS_GENERATED,ACCUMULATOR_ID,BUSINESS_EMAIL_ADDRESS,MONTHS_OF_SERVICE,FINAL_CONTRIBUTION,ADJUSTMENT_REASON) 
select current_timestamp, SYS_GUID(), 'DELETEMANUAL', E.* 
from EMPLOYEES E 
where E.EMPLOYEE_UUID = '67576bca23f54faeb6e3d7189259b124';

-- Delete record from employees table
delete from employees where EMPLOYEE_UUID = '67576bca23f54faeb6e3d7189259b124';



select file_uuid from PAYROLL_FILES 
where PROCESSING_START >= TO_DATE('01-JAN-14', 'dd-MON-YY')
and file_unc like '%CR_054303_054303_054303_HSBIWK_131230_181253.TXT%';


--get all data for current census where payroll source eligibility date is
--different than census
select pp.plan_xsid, payroll.social_security_number, payroll.max_payroll_date payroll_max_payroll_date, payroll.employee_id, payroll.first_name, payroll.last_name , payroll.employment_status
   , payroll.employment_sub_type, payroll.employment_status_date, payroll.termination_date, payroll.reported_payroll_frequency, payroll.hire_date, payroll.adjusted_hire_date, payroll.reported_location, payroll.hr_code   
,payroll.eligibility_date payroll_eligibility_date, census.eligibility_date census_eligibility_date, census.max_payroll_date census_max_payroll_date, census.hr_code census_hr_code, census.hire_date census_hire_date, census.adjusted_hire_date census_adjusted_hire_date
from
(
  with TEMP as 
    (
    --get max payroll date for census
    select EMP.PLAN_UUID, EMP.SOCIAL_SECURITY_NUMBER, max(EMP.PAYROLL_DATE) MAX_PAYROLL_DATE from EMPLOYEES EMP
    join payrolls pr on pr.payroll_uuid =  emp.payroll_uuid
    where emp.plan_uuid in ('ca3acbaa4d3848eeaaf69fb344ec22a1','6a661826d8cd4e768c0cecf4aeb2f27a','8a436c0713db4a69a8142cab5ff8ecf3')
    and pr.is_census = 1
    and PR.FILE_PREFIX= 'CR'
    and emp.file_uuid = 'e0012ed41ae84a66bf5b6387f5988e27' --<<<<<<<<<<<<<<<<<<<<<<<< FILE UUID
    group by emp.plan_uuid, emp.social_security_number
    )
  --get all data from census for max payroll date
  select e.plan_uuid, E.SOCIAL_SECURITY_NUMBER, SE.ELIGIBILITY_DATE, E.PAYROLL_DATE MAX_PAYROLL_DATE, E.HR_CODE, E.HIRE_DATE, E.ADJUSTED_HIRE_DATE
  from TPA.SOURCEELIGIBILITY SE
  join TPA.EMPLOYEES E on E.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID
  join TPA.PAYROLLS P on P.PAYROLL_UUID=E.PAYROLL_UUID
  join temp on temp.social_security_number=e.social_security_number and temp.max_payroll_date=e.payroll_date and TEMP.PLAN_UUID=E.PLAN_UUID
  where e.plan_uuid in ('ca3acbaa4d3848eeaaf69fb344ec22a1','6a661826d8cd4e768c0cecf4aeb2f27a','8a436c0713db4a69a8142cab5ff8ecf3')
  and source='F'
  and P.IS_CENSUS=1
  order by E.SOCIAL_SECURITY_NUMBER, E.PAYROLL_DATE desc
) census join
(
  with temp as (
    --get max payroll date for payroll
    select EMP.PLAN_UUID, EMP.SOCIAL_SECURITY_NUMBER, max(EMP.PAYROLL_DATE) MAX_PAYROLL_DATE from EMPLOYEES EMP
    join PAYROLLS PR on PR.PAYROLL_UUID =  EMP.PAYROLL_UUID
    where EMP.PLAN_UUID in ('ca3acbaa4d3848eeaaf69fb344ec22a1','6a661826d8cd4e768c0cecf4aeb2f27a','8a436c0713db4a69a8142cab5ff8ecf3')
    and pr.is_census = 0
    and PR.FILE_PREFIX= 'CR'
    and EMP.FILE_UUID = 'e0012ed41ae84a66bf5b6387f5988e27' --<<<<<<<<<<<<<<<<<<<<<<<< FILE UUID
    group by EMP.PLAN_UUID, EMP.SOCIAL_SECURITY_NUMBER
  )
  select E.PLAN_UUID, E.SOCIAL_SECURITY_NUMBER, E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.PAYROLL_DATE MAX_PAYROLL_DATE, E.EMPLOYMENT_STATUS, E.EMPLOYMENT_SUB_TYPE, E.EMPLOYMENT_STATUS_DATE
   , E.TERMINATION_DATE, E.REPORTED_PAYROLL_FREQUENCY, E.HIRE_DATE, E.ADJUSTED_HIRE_DATE, E.REPORTED_LOCATION, E.HR_CODE, SE.ELIGIBILITY_DATE
   from tpa.sourceeligibility se
  join TPA.EMPLOYEES E on E.EMPLOYEE_SNAPSHOT_ID = SE.EMPLOYEE_SNAPSHOT_ID
  join TPA.PAYROLL_PLANS PP on PP.PLAN_UUID = E.PLAN_UUID
  join TPA.PAYROLLS P on P.PAYROLL_UUID=E.PAYROLL_UUID
  join TEMP on TEMP.SOCIAL_SECURITY_NUMBER=E.SOCIAL_SECURITY_NUMBER and TEMP.MAX_PAYROLL_DATE=E.PAYROLL_DATE and TEMP.PLAN_UUID=E.PLAN_UUID
  where E.PLAN_UUID in ('ca3acbaa4d3848eeaaf69fb344ec22a1','6a661826d8cd4e768c0cecf4aeb2f27a','8a436c0713db4a69a8142cab5ff8ecf3')
  and source='F'
  and P.IS_CENSUS=0
  order by E.SOCIAL_SECURITY_NUMBER, E.PAYROLL_DATE desc
) PAYROLL on CENSUS.PLAN_UUID=PAYROLL.PLAN_UUID and CENSUS.SOCIAL_SECURITY_NUMBER=PAYROLL.SOCIAL_SECURITY_NUMBER
join payroll_plans pp on census.PLAN_UUID = pp.PLAN_UUID
where 
(
(census.eligibility_date<>payroll.eligibility_date)
or
((census.eligibility_date is null and payroll.eligibility_date is not null and payroll.eligibility_date<= sysdate))
)
 