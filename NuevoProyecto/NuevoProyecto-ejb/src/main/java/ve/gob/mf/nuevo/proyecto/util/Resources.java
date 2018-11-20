/*
 * @(# Resources.java	1.0.0 2012
 * Copyright 2008 oncop, Todos los derechos reservados.
 * oncop/CONFIDENCIAL
 */
package ve.gob.mf.nuevo.proyecto.util;

import org.jboss.logging.Logger;

import javax.enterprise.inject.Default;
import javax.enterprise.inject.Produces;
import javax.enterprise.inject.spi.InjectionPoint;
import javax.inject.Named;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 * <p>La clase <code>ve.gob.oncop.scpa.util.Resources</code> utiliza CDI para
 * crear un alias a los recursos de Java EE, tales como el contexto de
 * persistencia y el logger de la aplicación, para ser inyectados en los Beans
 * del CDI.
 * 
 * @autor rrequena
 * @since 18/06/2012
 * @version 1.6
 * @see {@link import org.jboss.logging.Logger}
 * @see {@link javax.enterprise.inject.Produces}
 * @see {@link javax.enterprise.inject.spi.InjectionPoint}
 * @see {@link javax.persistence.EntityManager}
 * @see {@link javax.persistence.PersistenceContext}
 * @see {@link }
 */
public class Resources {


	/**
	 * Representa el valor de entityManager
	 */
	@Produces
	@PersistenceContext(unitName = "UP_RetoJava")
	private EntityManager entityManager;

	/**
	 * Método encargado de retornar el logger de la aplicación
	 *  
	 * @param injectionPoint
	 * @return Logger
	 */
	@Named("productorEjb")
	@Produces
	public Logger produceLog(InjectionPoint injectionPoint) {
		return Logger.getLogger(injectionPoint.getMember().getDeclaringClass().getName());
	}
	
}
