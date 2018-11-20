/*
 * @# NuevoProyectoException.java	1.0.0 2012
 * Copyright 2012 oncop, Todos los derechos reservados.
 * oncop/CONFIDENCIAL
 */
package ve.gob.mf.nuevo.proyecto.util;

/**
 * @author yescobar
 *
 */
public class NuevoProyectoException extends RuntimeException{

	/**
	 * Representa el valor de serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
	
	private String mensaje;
	
	private Exception e;
	
	private String codigoError;
	
	private Capa capa;

	
	public enum Capa {
		DAO, EJB, WEB
	}
	
	
	public NuevoProyectoException(String codigoError, String mensaje, Capa capa,  Exception e) {
		super (e);
		this.mensaje = mensaje;
		this.e = e;
		this.codigoError = codigoError;	
		this.capa = capa;
	}
	
	
	public NuevoProyectoException() {
		
	}


	/**
	 * Método que retorna el valor de mensaje
	 * @return the mensaje
	 */
	public String getMensaje() {
		return mensaje;
	}


	/**
	 * Método encargado de configurar el valor de campo mensaje
	 * @param mensaje the mensaje to set
	 */
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}


	/**
	 * Método que retorna el valor de e
	 * @return the e
	 */
	public Exception getE() {
		return e;
	}


	/**
	 * Método encargado de configurar el valor de campo e
	 * @param e the e to set
	 */
	public void setE(Exception e) {
		this.e = e;
	}


	/**
	 * Método que retorna el valor de codigoError
	 * @return the codigoError
	 */
	public String getCodigoError() {
		return codigoError;
	}


	/**
	 * Método encargado de configurar el valor de campo codigoError
	 * @param codigoError the codigoError to set
	 */
	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}


	/**
	 * Método que retorna el valor de capa
	 * @return the capa
	 */
	public Capa getCapa() {
		return capa;
	}


	/**
	 * Método encargado de configurar el valor de campo capa
	 * @param capa the capa to set
	 */
	public void setCapa(Capa capa) {
		this.capa = capa;
	}

	
}
