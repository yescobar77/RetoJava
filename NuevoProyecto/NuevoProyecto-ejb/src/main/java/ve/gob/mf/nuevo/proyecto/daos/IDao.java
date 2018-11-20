/*
 * @(# IDao.java	1.0.0 2012
 * Copyright 2008 oncop, Todos los derechos reservados.
 * oncop/CONFIDENCIAL
 */
package ve.gob.mf.nuevo.proyecto.daos;

import java.io.Serializable;
import java.util.List;

import javax.persistence.metamodel.EntityType;

/**
 * <p>La interface <code>ve.gob.oncop.scpa.daos.IDao</code> es la interface base
 *    para declarar los métodos de las operaciones CRUB básicas que pueden realizar las
 *    clases DAO's sobre los objetos de Dominio.
 *
 *  @autor rrequena
 *  @since 18/06/2012
 *  @version 1.6
 *  @see {@link java.io.Serializable}
 *  @see {@link java.util.List}
 *  @see {@link }
 */
public interface IDao<D, ID extends Serializable> {

	/**
	 * Método encargado de guardar el objeto de dominio en la
	 * base de datos.
	 * 
	 * @param domain Objeto a guardar
	 */
	public void guardar(D domain);
	
	/**
	 * Método encargado de borrar el objeto de dominio en la
	 * base de datos.
	 * 
	 * @param domain Objeto a guardar
	 */
	public void borrar(D domain);
	
	/**
	 * Método encargado de actualizar el objeto de dominio en la
	 * base de datos.
	 * 
	 * @param domain Objeto a guardar
	 */
	public void actualizar(D domain);
	
	/**
	 * Método encargado de buscar el objeto de dominio
	 * en la base de datos según su id
	 * 
	 * @param id
	 * @return Objeto de Dominio
	 */
	public D buscar(ID id);
	
	/**
	 * Método encargado de listar todos los objetos
	 * de dominio que estan registrados en la base de datos
	 * 
	 * @return Lista de Objetos de Dominios 
	 */
	public List<D> listar();
	
	public List<D> buscarTodosPorAtributo(String nombreAtributo, Object valor);
	
	/**
	 * Método encargado de retornar el tipo de una
	 * entidad
	 * 
	 * @return EntityType<D>
	 */
	public EntityType<D> getEntityType();
	
	public void guardarTodos(List<D> domain);
	
	public void actualizarTodos(List<D> domain);
}
