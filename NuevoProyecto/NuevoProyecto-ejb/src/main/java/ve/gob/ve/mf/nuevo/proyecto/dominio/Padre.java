package ve.gob.ve.mf.nuevo.proyecto.dominio;

import java.io.Serializable;
import javax.persistence.*;


/**
 * The persistent class for the Padre database table.
 * 
 */
@Entity
public class Padre implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private int id_P;

	private String descripcion;

    public Padre() {
    }

	public int getId_P() {
		return this.id_P;
	}

	public void setId_P(int id_P) {
		this.id_P = id_P;
	}

	public String getDescripcion() {
		return this.descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

}