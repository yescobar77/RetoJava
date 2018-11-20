package ve.gob.mf.nuevo.proyecto.rest;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

/**
 * A class extending {@link Application} and annotated with @ApplicationPath is the Java EE 6
 * "no XML" approach to activating JAX-RS.
 * 
 * <p>
 * Resources are served relative to the servlet path specified in the {@link ApplicationPath}
 * annotation.
 * </p>
 */
/**
 * <p>La clase <code>ve.gob.oncop.proyecto.base.rest.JaxRsActivator</code> es la uan clase que 
 *  extiende {@link Application} y es anotada con @ApplicationPath es el Java EE 6
 *  "No XML" para la activación de JAX-RS.
 *
 *  @autor rrequena
 *  @since 17/09/2012
 *  @version 1.6
 *  @see {@link }
 *  @see {@link }
 *  @see {@link }
 */
@ApplicationPath("/rest")
public class JaxRsActivator extends Application {
	/* El cuerpo de la clase se ha dejado intencionadamente en blanco */
}
