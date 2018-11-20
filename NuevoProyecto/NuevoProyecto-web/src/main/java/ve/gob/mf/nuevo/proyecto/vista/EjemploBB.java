package ve.gob.mf.nuevo.proyecto.vista;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

import org.jboss.logging.Logger;

import ve.gob.mf.nuevo.proyecto.servicios.IEjemploServicioLocal;

@ManagedBean
@SessionScoped
public class EjemploBB extends BaseBB {

	private static final long serialVersionUID = 1L;

	private Logger logger =  Logger.getLogger(EjemploBB.class);
	
	private String input1 = "Valor 1";
	
	private String hora;
	
	private String valorCmb1 = " ";
	private String valorCmb2 = " ";
	private List<String> listaCmb1;
	
	public EjemploBB() {
		// TODO Auto-generated constructor stub
	}

	@PostConstruct
	private void inicio(){
		logger.info(" Clase <" + this.getClass().getName() + "> creada");
	}
	
	@EJB
	IEjemploServicioLocal ejb;
	
	public String click(){
		logger.info(" Metodo click");
		return "pagina2";
	}
	
	public String request(){
		logger.info(" Metodo request");
		return " ";
	}

	public void metodoVoid(){
		logger.info(" Metodo void");
	}
	
	public void listenerSelect(){
		logger.info(" Metodo listenerSelect");
	}
	
	public List<String> listacmb1_items(){
		if (listaCmb1 == null){
			listaCmb1 = new ArrayList<String>();
			
			listaCmb1.add("qwerty 1");
			listaCmb1.add("qwerty 2");
			listaCmb1.add("qwerty 3");
		}
		
		return listaCmb1;
	}
	
	//-------------------------------
	
	public String getInput1() {
		return input1;
	}

	public void setInput1(String input1) {
		this.input1 = input1;
	}

	public IEjemploServicioLocal getEjb() {
		return ejb;
	}

	public void setEjb(IEjemploServicioLocal ejb) {
		this.ejb = ejb;
	}

	public String getValorCmb1() {
		return valorCmb1;
	}

	public void setValorCmb1(String valorCmb1) {
		this.valorCmb1 = valorCmb1;
	}

	public String getValorCmb2() {
		return valorCmb2;
	}

	public void setValorCmb2(String valorCmb2) {
		this.valorCmb2 = valorCmb2;
	}

	public String getHora() {
		return new Date().toString();
	}

	public void setHora(String hora) {
		this.hora = hora;
	}
	
	
}
