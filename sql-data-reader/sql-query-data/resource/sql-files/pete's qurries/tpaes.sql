update TBLJOBPROCESSOR set DESCRIPTION = 'EIS-L-PSELBY.envisagesystems.local';
--update TBLJOBPROCESSOR set DESCRIPTION = 'TIAACRSPRINT02.envisagesystems.local';

select * from workflowdefinition;
select * from workflowdefinition where WorkflowDefinitionID in ('EDGEXPORT', 'FILE_VALIDATION');
select * from tbljobprocrole;
select * from tbljobprocessor;
select * from tblworkflowheaderproperty where propertyvalue like '%A_054303_054303_054303_ADJ26_130130_050501%';
select * from tblworkflowheaderproperty where workflowid = '3318943';




select * from TBLJOBQUEUE
where not PROCESSID in (11, 31)
--and workflowid = 5156373
--and LASTACTIVITY is not null
order by lastactivity desc; 



select workflowid, processid, createdate, DETAILTEXT from workflowlog 
where 1=1
and WORKFLOWID=5562085
--and recordsubtype = 'ERROR'
--and detailtext like '%CR_553371_987110_987110_BW_140102_030111%' 
order by createdate desc;

update tbljobqueue set complete = 1, locked = 0 where complete = 0;
select * from TBLWORKFLOWHEADERPROPERTY where WORKFLOWID = '5929574';
delete from TBLJOBQUEUE where LASTACTIVITY is null;

select * from tblworkflowheaderproperty
where 1=1
and WORKFLOWID = '5156498'
--and element = 'TEMPLATE_ID'
order by CREATEDATE desc;

select * from TBLWORKFLOWHEADERPROPERTY 
where PROPERTYVALUE like '%CR_054303_054303_054303_HSBIWK_140328_141910%'
--where WORKFLOWID = 581355;
order by CREATEDATE;

delete from tbljobqueue where workflowid > '3338358';

select * from WORKFLOWFAMILY;
select * from processlist where PROCESSID = '19';
select * from WORKFLOWDEFINITION;\
select * from PROCESSSTATUS where PROCESSID = '14';

delete from tblworkflowheaderproperty where element = 'FORMATTER_NAME';
update TBLJOBQUEUE set locked = 0, complete = 0 where WORKFLOWID = '3338358' and PROCESSID = 21;

select WORKFLOWACTIVITY_WFAID_SEQ.NEXTVAL as SEQ, TAB1.MAX_TABLE_VAL, 
CASE WHEN WORKFLOWACTIVITY_WFAID_SEQ.NEXTVAL < TAB1.MAX_TABLE_VAL THEN concat('NO', WORKFLOWACTIVITY_WFAID_SEQ.NEXTVAL - TAB1.MAX_TABLE_VAL) ELSE 'YES' END Valid_ID from DUAL join
(select max(WORKFLOWACTIVITYID) as MAX_TABLE_VAL from WORKFLOWACTIVITY where WORKFLOWACTIVITYID is not null) TAB1 on 1=1;
Alter sequence WORKFLOWACTIVITY_WFAID_SEQ INCREMENT BY 1;
