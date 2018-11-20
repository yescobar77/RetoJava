/*
 * @# CargarTipoDelegacionBB.java	1.0.0 2012
 * @# BeanRelacionUAD_UEL.java	1.0.0 2012 
 * Copyright 2012 oncop, Todos los derechos reservados.
 * oncop/CONFIDENCIAL
 */
package ve.gob.mf.nuevo.proyecto.vista;


import java.io.Serializable;

import javax.faces.application.FacesMessage;
import javax.faces.application.FacesMessage.Severity;
import javax.faces.context.FacesContext;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

import org.jboss.logging.Logger;

/**
 * @author yescobar
 *
 */

public class BaseBB implements Serializable{
	
	/**
	 * Representa el valor de serialVersionUID
	 */
	private static final long serialVersionUID = 1L;


	public BaseBB(){
		System.out.println("Cargando la clase BaseBB");
	}
	
	@Inject @Named("productorWeb") Logger logger;

	public Logger getLogger() {
	    return logger;
	}

	public void setLogger(Logger logger) {
	    this.logger = logger;
	}
	
	/**
    *
    * Metodo que retorna que el parametro indicado tiene en el request
    *
    * @param param parametro
    * @return Valor
    */
    public Object getParameterRequest(String param) {
       HttpServletRequest req = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
       return req.getParameter(param);
    }
    /**
    *
    * Metodo que retorna que el atributo indicado almacenado en la Session
    *
    * @param atributo atributo
    * @return Valor
    */
    public Object getAtributo(String atributo) {
    	return ((Map<String, Object>) FacesContext.getCurrentInstance().getExternalContext().getSessionMap()).get(atributo);
    }
	/**
     * Permite agregar mensajes al contexto de JSF a fin de ser utilizado en los
     * elementos de presentacion. Adicionalmente es posible definir el nivel de
     * severidad de dicho mensaje, para ello se debe utilizar alguno de los
     * niveles de severidad definidos en la clase {@link FacesMessage}.
     *
     * @param mensaje
     *            mensaje que se desea colocar en el contexto de la aplicacion
     *
     * @param nivel
     *            nivel de severidad del mensaje a colocar en el contexto
     */
    public void addMessage(Severity nivel, String mensaje) {

        FacesContext context = FacesContext.getCurrentInstance();

        FacesMessage message = new FacesMessage();

        message.setSeverity(nivel);

        message.setSummary(mensaje);

        context.addMessage(null, message);
    }
}
