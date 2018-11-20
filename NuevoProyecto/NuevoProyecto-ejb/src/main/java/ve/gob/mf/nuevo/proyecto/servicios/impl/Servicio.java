package ve.gob.mf.nuevo.proyecto.servicios.impl;

import java.util.List;

import javax.ejb.Stateless;
import javax.inject.Inject;
import ve.gob.mf.nuevo.proyecto.daos.impl.ConsultasDaoImpl;
import ve.gob.mf.nuevo.proyecto.servicios.IServicio;
import ve.gob.ve.mf.nuevo.proyecto.dominio.Padre;

@Stateless
public class Servicio implements IServicio{

	@Inject ConsultasDaoImpl consultasDaoImpl;
	
	public List<Padre> ListaPadres(Integer anho) {
		// TODO Auto-generated method stub
		List <Padre> lista;
				
		lista = consultasDaoImpl.buscarTodosPorAtributo(anho);
		 
		return lista;
	}	
}
