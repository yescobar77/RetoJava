<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page isErrorPage="true" %>
<html>
<HEAD>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM Software Development Platform">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE></TITLE>

</HEAD>

<BODY>
<P align="center"><FONT size="5">Ha ocurrido un error de ejecuci&oacute;n</FONT></P>
<P align="center">Por favor inicie la aplicaci&oacute;n nuevamente, y comun&iacute;quese con el Centro de Atenci&oacute;n al Usuario.</P>
<P align="center">Disculpe cualquier molestia causada.</P>
<%
	System.out.println("======================================================================");
	System.out.println("Ocurrio un error general en la aplicacion "+request.getContextPath());
	System.out.println("======================================================================");
	if (session != null) session.invalidate(); 
%>
</BODY>
</html>
