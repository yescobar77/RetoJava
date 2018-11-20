package ve.gob.ve.mf.nuevo.proyecto.dominio;

import java.io.Serializable;
import javax.persistence.*;


/**
 * The persistent class for the Hijo database table.
 * 
 */
@Entity
public class Hijo implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name="id_h")
	private int idH;

	private String descripcion;

	@Column(name="id_padre")
	private int idPadre;

    public Hijo() {
    }

	public int getIdH() {
		return this.idH;
	}

	public void setIdH(int idH) {
		this.idH = idH;
	}

	public String getDescripcion() {
		return this.descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public int getIdPadre() {
		return this.idPadre;
	}

	public void setIdPadre(int idPadre) {
		this.idPadre = idPadre;
	}

}