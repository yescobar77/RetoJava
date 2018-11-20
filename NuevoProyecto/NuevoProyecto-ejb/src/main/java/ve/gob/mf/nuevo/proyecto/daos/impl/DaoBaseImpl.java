/*
 * @(# DaoBaseImpl.java	1.0.0 2012
 * Copyright 2008 oncop, Todos los derechos reservados.
 * oncop/CONFIDENCIAL
 */
package ve.gob.mf.nuevo.proyecto.daos.impl;

import java.io.Serializable;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.metamodel.EntityType;
import javax.persistence.metamodel.Metamodel;

import ve.gob.mf.nuevo.proyecto.daos.IDao;


/**
 * <p>La clase <code>ve.gob.oncop.scpa.daos.impl.DaoBaseImpl</code> es encargada de implementar
 * el manejo de las operaciones bases para el CRUD de los objetos de dominios.</p> 
 * 
 * <p>Esta clase utiliza genéricos para la clase que herede de ella especifique el objeto de Dominio
 * con el que va a trabajar.</p>
 * 
 * <p>El parámetro <code>D</code> representa el tipo de la clase del objeto de dominio a manejar.
 * 
 * <p>El parámetro <code>ID</code> representa el tipo de dato o clase que pertenece el id del objeto de dominio
 * que esta manejando. 
 *
 *  @autor rrequena
 *  @since 18/06/2012
 *  @version 1.6
 *  @see {@link java.io.Serializable}
 *  @see {@link java.util.List}
 *  @see {@link javax.persistence.EntityManager}
 *  @see {@link javax.persistence.criteria.CriteriaBuilder}
 *  @see {@link javax.persistence.criteria.CriteriaQuery}
 *  @see {@link javax.persistence.criteria.Root}
 *  @see {@link ve.gob.oncop.scpa.daos.IDao}
 */
public abstract class DaoBaseImpl<D, ID extends Serializable> implements IDao<D, ID >, Serializable {
	
	/**
	 * Representa el valor de serialVersionUID
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * Representa el valor de entityClass
	 */
	private Class<D> entityClass;

	/**
	 * Constructor
	 */
	public DaoBaseImpl() {
		super();
	}
	
	public DaoBaseImpl(Class<D> entityClass) {
		this.entityClass = entityClass;
	}

	/* (non-Javadoc)
	 * @see ve.gob.oncop.scpa.daos.IDao#guardar(java.lang.Object)
	 */
	@Override
	public void guardar(D domain) {
		getEntityManagerDao().persist(domain);
	}

	/* (non-Javadoc)
	 * @see ve.gob.oncop.scpa.daos.IDao#borrar(java.lang.Object)
	 */
	@Override
	public void borrar(D domain) {
		getEntityManagerDao().remove(domain);
	}

	/* (non-Javadoc)
	 * @see ve.gob.oncop.scpa.daos.IDao#actualizar(java.lang.Object)
	 */
	@Override
	public void actualizar(D domain) {
		getEntityManagerDao().merge(domain);
	}

	/* (non-Javadoc)
	 * @see ve.gob.oncop.scpa.daos.IDao#buscar(java.lang.Object)
	 */
	@Override
	public D buscar(ID id) {
		
		return getEntityManagerDao().find(entityClass, id);
	}

	/* (non-Javadoc)
	 * @see ve.gob.oncop.scpa.daos.IDao#listar()
	 */
	@Override
	public List<D> listar() {
		// Creamos el Query	
	    CriteriaBuilder builder = getEntityManagerDao().getCriteriaBuilder();
	    CriteriaQuery<D> query = builder.createQuery(entityClass);
	    Root<D> entidades = query.from(entityClass);
	    query.select(entidades);
	    
	    //query.orderBy(builder.asc(entidades.get("id")));

		// Ejecutamos el query
		return getEntityManagerDao().createQuery(query).getResultList();
	}
	
	/* (non-Javadoc)
	 * @see ve.gob.oncop.scpa.daos.IDao#getEntityType()
	 */
	@Override
	public EntityType<D> getEntityType(){
		
		Metamodel metamodel = getEntityManagerDao().getMetamodel();
		EntityType<D> tipo = metamodel.entity(entityClass);
		return tipo;
	}

	public List<D> buscarTodosPorAtributo(String nombreAtributo, Object valor) {

	    CriteriaBuilder builder = getEntityManagerDao().getCriteriaBuilder();
	    CriteriaQuery<D> query = builder.createQuery(entityClass);
	    Root<D> entidades = query.from(entityClass);
	    query.select(entidades);

	    Predicate atributo = null;
	 
	    if ((nombreAtributo != null) && (!(nombreAtributo.isEmpty()))) {
	    	atributo = builder.equal(entidades.get(nombreAtributo), valor);
	    }

	    query.where(atributo);
	 
	    return getEntityManagerDao().createQuery(query).getResultList();
	}
	
	public void guardarTodos(List<D> domain){
		for ( int i=0; i<domain.size(); i++ ) {
			getEntityManagerDao().persist(domain.get(i));
			
		    if ( i % 20 == 0 ) {
		    	getEntityManagerDao().flush();
		    	getEntityManagerDao().clear();
		    }
		}
	}
	
	public void actualizarTodos(List<D> domain){
		for ( int i=0; i<domain.size(); i++ ) {
			getEntityManagerDao().merge(domain.get(i));
			
		    if ( i % 20 == 0 ) {
		    	getEntityManagerDao().flush();
		    	getEntityManagerDao().clear();
		    }
		}
	}
	
	
	/**
	 * Método que retorna el valor de entityManagerDao
	 * @return the entityManagerDao
	 */
	public abstract EntityManager getEntityManagerDao();


}
