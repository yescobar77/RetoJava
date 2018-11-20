package ve.gob.mf.nuevo.proyecto.daos.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.Query;

import org.jboss.logging.Logger;

import ve.gob.mf.nuevo.proyecto.daos.IConsultas;
import ve.gob.mf.nuevo.proyecto.daos.impl.DaoBaseImpl;
import ve.gob.ve.mf.nuevo.proyecto.dominio.Padre;


public class ConsultasDaoImpl extends DaoBaseImpl<Padre, Integer> implements IConsultas{
	
	@Inject EntityManager em;
    private Logger logger =  Logger.getLogger(ConsultasDaoImpl.class);
    
    @Override
	public EntityManager getEntityManagerDao() {
		// TODO Auto-generated method stub
		return em;
	}

	@Override
	public List<Padre> buscarTodosPorAtributo(Integer anho) {
		    // TODO Auto-generated method stub
	        StringBuilder sb = new StringBuilder();
			sb.append("select *");
			sb.append(" from Padre");
								
			Query query = em.createNativeQuery(sb.toString());
						
			logger.info("Query ==> " + sb.toString());
			
			List<Padre> resultado = query.getResultList();
			
			logger.info("Son ==> " + resultado.size());
			
			List<Padre> lista =new ArrayList<Padre>();
						
			return lista;
	}
}
