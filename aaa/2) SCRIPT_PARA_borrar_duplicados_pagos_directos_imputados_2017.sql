--SCRIPT_PARA_borrar_duplicados_pagos_directos_imputados_2017.sql

declare
cursor busqueda is 

select transa_id, anho_presup, clave_negocio, orga_id
from transaccion
where (anho_presup,  clave_negocio, orga_id) in (
 select anho_presup, clave_negocio, orga_id
    from transaccion
    where (anho_presup, orga_id, clave_negocio) in (    
    SELECT  
            P.ANHO,
            P.ORGA_ID,
            'neg=conciliacionImputado|anho='||P.ANHO||'|orga_id='||P.ORGA_ID||'|pago_id='||P.PAGO_ID||'|tipg_id='||P.TIPG_ID||'' CLAVE
           --ojo este script se pasa también con pagoNoImputado
        FROM 
        PAGO P, PAGO_IMPUTADO PI
		WHERE 
                P.ANHO     in (2016,2017)                   AND 
	        P.TIPG_ID IN (1,9,10)           AND
                --p.orga_id=10 and p.pago_id=4773 and 
                --p.orga_id=26 and
                P.IMPUTADO = 'S'                     AND    
                P.EDPA_ID_FIN = 1                    AND 
                /*TO_NUMBER(TO_CHAR(P.FECHA_PAGO,'YYYYMMDD')) >= 20130101 AND
                TO_NUMBER(TO_CHAR(P.FECHA_PAGO,'YYYYMMDD')) <= 20131231 AND*/
	        PI.ANHO    = P.ANHO                  AND 
	        PI.ORGA_ID = P.ORGA_ID               AND 
	        PI.PAGO_ID = P.PAGO_ID               AND
	        PI.TIPG_ID = P.TIPG_ID               
       )   
 and estado=0        
 and TO_NUMBER(TO_CHAR(fecha_reg,'YYYY'))=2017 
 group by anho_presup, clave_negocio, orga_id,fecha_reg
 HAVING count(*)>1
);

   P_ANHO NUMBER(4) :=  2017;
   P_TRANSA TRANSACCION.TRANSA_ID%TYPE;
   P_CLAVE TRANSACCION.CLAVE_NEGOCIO%TYPE;
   P_ASIENTO ASIENTO.ASIENTO_ID%TYPE;
   P_PROCESO PROCESO.PROCESO_ID%TYPE;
   cantidad number:= 0;
   mintran number:= 0;
begin

for reg in busqueda loop


select min(transa_id) into mintran
from transaccion where anho_presup=P_anho and orga_id=reg.orga_id and clave_negocio=reg.clave_negocio;

if (reg.transa_id)<>mintran then

cantidad := cantidad + 1;

P_TRANSA := reg.transa_id;
  
begin
select asiento_id into P_ASIENTO
from asiento
where anho_presup = P_ANHO
and transa_id = P_TRANSA;
exception
when no_data_found then
    P_ASIENTO := NULL;
end;

delete diario_contable
where detasi_id in (select detasi_id
	  			   		   				from detalle_asiento
										where asiento_id = (select asiento_id
										                                       from asiento
																			   where anho_presup = P_ANHO
																			   and     asiento_id = P_ASIENTO   
																				 )
										);
										
										
delete contab.diario_economico
where detasi_id in (select detasi_id
	  			   		   				from detalle_asiento
										where asiento_id = (select asiento_id
										                                       from asiento
																			   where anho_presup = P_ANHO
																			   and     asiento_id = P_ASIENTO   
																				 )
										);
										
delete contab.diario_egreso
where detasi_id in (select detasi_id
	  			   		   				from detalle_asiento
										where asiento_id = (select asiento_id
										                                       from asiento
																			   where anho_presup = P_ANHO
																			   and     asiento_id = P_ASIENTO   
																				 )
										);
										
										
delete contab.diario_recurso
where detasi_id in (select detasi_id
	  			   		   				from detalle_asiento
										where asiento_id = (select asiento_id
										                                       from asiento
																			   where anho_presup = P_ANHO
																			   and     asiento_id = P_ASIENTO   
																				 )
										);
									
delete detalle_asiento
where asiento_id = (select asiento_id
                                       from asiento
									   where asiento_id = P_ASIENTO
									   and     anho_presup = P_ANHO   
										 );						

										 
delete asiento
where asiento_id = P_ASIENTO
and     anho_presup = P_ANHO;


delete transaccion
where transa_id =  P_TRANSA;

--dbms_output.put_line('clave borrada:'||reg.clave_negocio||' transa='||reg.transa_id);	

end if;

end loop;

dbms_output.put_line('Termino el proceso, transaccion borradas:'||cantidad);	
--hay 66.656 registros a procesar

end;	

