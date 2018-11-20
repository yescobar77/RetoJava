package ve.gob.mf.nuevo.proyecto.util;

import javax.enterprise.context.RequestScoped;
import javax.enterprise.inject.Produces;
import javax.enterprise.inject.spi.InjectionPoint;
import javax.faces.context.FacesContext;

import org.jboss.logging.Logger;
import javax.inject.Named;

/**
 * <p>
 * La clase <code>ve.gob.oncop.scpa.util.Resources</code> utiliza CDI para crear
 * un alias a los recursos de Java EE, tales como el contexto de JSF y el logger
 * de la aplicación, para ser inyectados en los Beans del CDI.
 * 
 * @autor rrequena
 * @since 18/06/2012
 * @version 1.6
 * @see {@link org.jboss.logging.Logger}
 * @see {@link javax.enterprise.inject.Produces}
 * @see {@link javax.enterprise.inject.spi.InjectionPoint}
 * @see {@link javax.faces.context.FacesContext}
 * @see {@link }
 */
public class WebResources {

	/**
	 * Método encargado de retornar el contexto de JSF utilizando el patron de
	 * Productor
	 * 
	 * @return FacesContext
	 */
	@Produces
	@RequestScoped
	public FacesContext produceFacesContext() {
		return FacesContext.getCurrentInstance();
	}

	 /**
	 * Método encargado de retornar el logger de la aplicación
	 * 
	 * @param injectionPoint
	 * @return Logger
	 */
	@Named("productorWeb")
	@Produces
	public Logger produceLog(InjectionPoint injectionPoint) {
		return Logger.getLogger(injectionPoint.getMember().getDeclaringClass()
				.getName());
	}

}
