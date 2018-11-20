package ve.gob.mf.nuevo.proyecto.servicios.impl;

import javax.ejb.Stateless;

import org.jboss.logging.Logger;
import ve.gob.mf.nuevo.proyecto.servicios.IEjemploServicioLocal;

@Stateless
public class EjemploServicio implements IEjemploServicioLocal{

	private Logger logger =  Logger.getLogger(EjemploServicio.class);
	
	public EjemploServicio() {
		// TODO Auto-generated constructor stub
	}
	 
}
