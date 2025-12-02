package model;

import java.sql.Timestamp;

public class Usuario {
    // La variable ahora coincide con el nombre de la columna en la BD
    private int id_usuario;
    private String nombre;
    private String apellido;
    private String correo;
    private String contrasena;
    private String telefono;
    private String direccion;
    private String rol;
    private String estado;
    private Timestamp fecha_registro;

    // --- MÉTODOS CORREGIDOS ---
    // El getter y setter ahora usan el nombre completo "id_usuario"
    public int getId_usuario() { 
        return id_usuario; 
    }
    public void setId_usuario(int id_usuario) { 
        this.id_usuario = id_usuario; 
    }
    // -------------------------

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public Timestamp getFecha_registro() { return fecha_registro; }
    public void setFecha_registro(Timestamp fecha_registro) { this.fecha_registro = fecha_registro; }
}