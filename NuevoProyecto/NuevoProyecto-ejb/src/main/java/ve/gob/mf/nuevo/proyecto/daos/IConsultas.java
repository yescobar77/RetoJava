package ve.gob.mf.nuevo.proyecto.daos;

import java.util.List;

import ve.gob.ve.mf.nuevo.proyecto.dominio.Padre;


public interface IConsultas extends IDao<Padre, Integer>{
	public List<Padre> buscarTodosPorAtributo(Integer anho);
}
