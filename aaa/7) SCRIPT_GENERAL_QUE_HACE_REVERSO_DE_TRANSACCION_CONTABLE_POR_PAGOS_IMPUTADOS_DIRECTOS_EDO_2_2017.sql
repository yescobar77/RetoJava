--  SCRIPT_GENERAL_QUE_HACE_REVERSO_DE_TRANSACCION_CONTABLE_POR_PAGOS_IMPUTADOS_DIRECTOS_EDO_2_2016_ADAPTADO.sql
--->LEER OBSERVACION
declare

V_ANHO  number(4) :=2017;

cursor busqueda is 
--OBSERVACION:
--ojo query modificado el dia 17-11-2016, se le incorporo la logica de fecha_modif=2 y el maximo
--de la fecha max(sp.fecha_modif) de la tabla seguimiento_pago para asi obtener la ultima fecha
--de registro de la ultima anulacion de ese pago y generar los asientos de reverso de ese pago con la fecha 
--max(sp.fecha_modif) conseguida.
SELECT  tr.clave_negocio,tr.orga_id,tr.anho_presup,tr.anho,tr.transa_id,tr.proceso_id,tr.clave_original
,pago.fecha_modif
        
FROM    
       transaccion tr,
       (SELECT  'neg=conciliacionImputado|anho='||P.ANHO||'|orga_id='||P.ORGA_ID||'|pago_id='||P.PAGO_ID||'|tipg_id='||P.TIPG_ID||'' clave,
                max(sp.fecha_modif)  fecha_modif,  --->nueva linea
                p.orga_id, p.anho, p.tipg_id,p.pago_id,p.edpa_id_fin edo                 
        FROM    PAGO P, PAGO_IMPUTADO PI
                , seguimiento_pago sp  --->nueva linea
        WHERE 
                P.ANHO      in (2016,2017)  AND 
                P.TIPG_ID IN (1,9,10)                AND
                P.EDPA_ID_FIN=2                      AND 
                P.IMPUTADO = 'S'                     AND    
                P.ANHO        =PI.ANHO               AND 
                P.ORGA_ID    = PI.ORGA_ID            AND 
                P.TIPG_ID    = PI.TIPG_ID            AND 
                P.PAGO_ID    = PI.PAGO_ID       
                and sp.anho=p.anho           --->nueva linea
                and sp.orga_id=p.orga_id     --->nueva linea
                and sp.tipg_id=p.tipg_id     --->nueva linea
                and sp.pago_id=p.pago_id     --->nueva linea
                and sp.edpa_id=2             --->nueva linea
                group by p.orga_id, p.anho, p.tipg_id,p.pago_id,p.edpa_id_fin   --->nueva linea
        )pago,
        (select t.clave_negocio,t.orga_id,t.anho_presup,sum(dc.haber) haber
                ,t.anho,t.transa_id,t.proceso_id,t.clave_original
         from diario_contable dc,detalle_asiento da,asiento a, transaccion t 
              where t.estado=0 and t.anho=2017 
	      and t.clave_negocio like 'neg=conciliacionImputado|anho=%'
              and t.anho=a.anho 
              and t.transa_id= a.transa_id
              and t.orga_id= a.orga_id
              and a.estado=0
              and a.anho= da.anho
              and a.asiento_id= da.asiento_id
              and da.estado=0
              and da.detasi_id= dc.detasi_id 
              and da.anho= dc.anho
              and dc.estado=0  
              and (dc.haber>0 or dc.debe>0)
         group by t.clave_negocio,t.orga_id,t.anho_presup,t.anho,t.transa_id,t.proceso_id,t.clave_original
        )tran
WHERE 
        pago.anho=tran.anho_presup
  and   pago.orga_id=tran.orga_id
  and   pago.clave=tran.clave_negocio  
  and   tr.clave_negocio=tran.clave_negocio
  and   tr.anho=tran.anho
  and   tr.orga_id=tran.orga_id
group by tr.clave_negocio,pago.fecha_modif,tr.orga_id,tr.anho_presup,tr.anho,tr.transa_id,tr.proceso_id,tr.clave_original  
order by tr.clave_negocio
;

   P_TRANSA TRANSACCION.TRANSA_ID%TYPE;
   P_ASIENTO ASIENTO.ASIENTO_ID%TYPE;

   cantidad number:= 0; 
begin

for reg in busqueda loop

cantidad := cantidad + 1;

select transaccion_seq.nextval into P_TRANSA from dual;
select asiento_seq.nextval into P_ASIENTO from dual;

  
-- incluir transaccion de anulacion
insert into transaccion (TRANSA_ID,PROCESO_ID,ANHO,CLAVE_NEGOCIO,
CLAVE_ORIGINAL,ORGA_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,CODIGO_VALIDACION,ANHO_PRESUP)
values (P_TRANSA, reg.proceso_id, reg.anho, reg.clave_negocio,
reg.clave_original, reg.orga_id, 
--to_date('31/12/2013','dd/mm/yyyy'), sysdate, 0, 0, 
reg.fecha_modif, sysdate, 0, 0, 
1, null, reg.anho_presup);

-- actualizar la transaccion anulada
UPDATE transaccion set estado = 1
WHERE transa_id = reg.transa_id;


--incluir asiento de anulacion
-- OJO, CAMBIAR EL SECUENCIAL DEL CUC DEPENDIENDO DEL A?O
IF V_ANHO=2014 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2014_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;


IF V_ANHO=2015 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2015_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2016 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2016_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2017 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2017_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2018 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2018_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2019 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2019_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2020 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2020_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2021 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2021_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2022 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2022_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2023 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2023_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2024 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2024_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2025 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2025_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

IF V_ANHO=2026 THEN
insert into asiento (ASIENTO_ID,TRANSA_ID,ANHO,CUC,CUC_ORIGINAL,
ORGA_ID,UNAD_ID,OBSERVACION,NUM_DOCUMENTO,TDOC_ID,CONCEPTO,
PERS_ID,MONEDA_ID,TIPOASI_ID,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,
ESTADO,ANHO_PRESUP) 
select P_ASIENTO, P_TRANSA, anho, cuc_2026_seq.nextval, cuc,
orga_id, unad_id, observacion, num_documento, tdoc_id, concepto,
pers_id, moneda_id, 3, reg.fecha_modif, sysdate, 0, 0, 
1, anho_presup
from asiento
where transa_id = reg.transa_id;
END IF;

-- actualizar asiento 
update asiento set estado = 1
where transa_id = reg.transa_id;

-- incluir cada detalle de asiento

declare
cursor busqueda2 is
  select *
  from detalle_asiento
  where asiento_id = (select asiento_id 
                      from asiento
                      where transa_id = reg.transa_id);
P_DETASI DETALLE_ASIENTO.DETASI_ID%TYPE;                      
begin  

  for reg2 in busqueda2 loop

    select detalle_asiento_seq.nextval into P_DETASI from dual;

    insert into detalle_asiento (DETASI_ID,ASIENTO_ID,MATRIZ_ID,ANHO,
    FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,ESTADO,ANHO_PRESUP)
    values (P_DETASI, P_ASIENTO, reg2.matriz_id, reg2.anho, 
     --      to_date('31/12/2013','dd/mm/yyyy'), sysdate, 0, 0, 1, reg2.anho_presup);
             reg.fecha_modif, sysdate, 0, 0, 1, reg2.anho_presup);

    update detalle_asiento set estado = 1
    where detasi_id = reg2.detasi_id;
    
    -- INSERTAR ANULACION DIARIOS CONTABLES
    
    insert into diario_contable(DIACON_ID,DETASI_ID,ANHO,CTAPAT_ID,PERIODO,CONECO_ID,AUXILIAR,
                                DEBE,HABER,FECHA_REG,FECHA_ACT,EXPEDIENTE,WORKITEM,ESTADO,ANHO_PRESUP)
    select diario_contable_seq.nextval, P_DETASI, anho, ctapat_id, 
    --'20131231', coneco_id, auxiliar, 
    TO_NUMBER(TO_CHAR(REG.FECHA_MODIF,'RRRRMMDD')), coneco_id, auxiliar, 
           haber, debe, 
          -- to_date('31/12/2013','dd/mm/yyyy'), sysdate, 0, 0, 1, anho_presup
             reg.fecha_modif, sysdate, 0, 0, 1, anho_presup
    from diario_contable
    where detasi_id = reg2.detasi_id;

    update diario_contable set estado = 1
    where detasi_id = reg2.detasi_id;

    -- INSERTAR ANULACION DIARIOS ECONOMICOS

    insert into diario_economico(DIAECO_ID,DETASI_ID,ANHO,CTAECO_ID,PERIODO,CONECO_ID,MONTO,FECHA_REG,
                                FECHA_ACT,EXPEDIENTE,WORKITEM,ESTADO,ANHO_PRESUP)
    select diario_economico_seq.nextval, P_DETASI, anho, ctaeco_id, 
    --'20131231', coneco_id, monto * -1, 
    TO_NUMBER(TO_CHAR(REG.FECHA_MODIF,'RRRRMMDD')), coneco_id, monto * -1, 
    --to_date('31/12/2013','dd/mm/yyyy'),
      reg.fecha_modif,
            sysdate, 0, 0, 1 , anho_presup
    from diario_economico
    where detasi_id = reg2.detasi_id;    
  
    update diario_economico set estado = 1
    where detasi_id = reg2.detasi_id;
  
    --INSERTAR ANULACION DIARIO EGRESO
    
    insert into diario_egreso(DIAEGR_ID,DETASI_ID,ANHO,ORGA_ID,CAPR_ID,FFIN_ID,PLUC_ID,UNOR_ID,UNAD_ID,
                              ENRE_CODIGO,PERIODO,INSTANCIA_ID,MONTO,MONTO_NETO,FECHA_REG,FECHA_ACT,EXPEDIENTE,
                              WORKITEM,ESTADO,ANHO_PRESUP)
    select diario_egreso_seq.nextval, P_DETASI, anho, orga_id, capr_id, ffin_id, pluc_id, unor_id, unad_id,
            enre_codigo, 
            --'20131231',instancia_id, monto * -1, monto_neto * -1, 
            TO_NUMBER(TO_CHAR(REG.FECHA_MODIF,'RRRRMMDD')),instancia_id, monto * -1, monto_neto * -1, 
            --to_date('31/12/2013','dd/mm/yyyy'), sysdate, 0,
            reg.fecha_modif, sysdate, 0,
            0, 1, anho_presup
    from diario_egreso
    where detasi_id = reg2.detasi_id;        

    update diario_egreso set estado = 1
    where detasi_id = reg2.detasi_id;
    
    --INSERTAR ANULACION DIARIO RECURSO
    
    insert into diario_recurso(DIAREC_ID,DETASI_ID,ANHO,PLUC_ID,ORGA_ID,UNAD_ID,
                               PERIODO,INSTANCIA_ID,MONTO,FECHA_REG,FECHA_ACT,EXPEDIENTE,
                              WORKITEM,ESTADO,ANHO_PRESUP)
    select diario_recurso_seq.nextval, P_DETASI, anho, pluc_id, orga_id,  unad_id,
          -- '20131231', instancia_id, monto * -1, 
           TO_NUMBER(TO_CHAR(REG.FECHA_MODIF,'RRRRMMDD')), instancia_id, monto * -1, 
           --to_date('31/12/2013','dd/mm/yyyy'), sysdate, 0, 0, 1, anho_presup
           reg.fecha_modif, sysdate, 0, 0, 1, anho_presup
    from diario_recurso
    where detasi_id = reg2.detasi_id;        

    update diario_recurso set estado = 1
    where detasi_id = reg2.detasi_id;


  end loop;

end;


end loop;

dbms_output.put_line('Termino el proceso, transaccion anuladas:'||cantidad);	
---hay 37 registros a procesar

end;	




