package model;

public class Tarjeta {
    private int id_tarjeta;
    private int id_usuario;
    private String ultimosDigitos; // Solo los últimos 4 dígitos
    private String nombreTitular;
    private String fechaExpiracion; // Formato MM/AA
    private String tipo; // Visa, Mastercard, Amex

    // Constructor vacío
    public Tarjeta() {
    }

    // Getters
    public int getId_tarjeta() {
        return id_tarjeta;
    }

    public int getId_usuario() {
        return id_usuario;
    }

    public String getUltimosDigitos() {
        return ultimosDigitos;
    }

    public String getNombreTitular() {
        return nombreTitular;
    }

    public String getFechaExpiracion() {
        return fechaExpiracion;
    }

    public String getTipo() {
        return tipo;
    }

    // Setters
    public void setId_tarjeta(int id_tarjeta) {
        this.id_tarjeta = id_tarjeta;
    }

    public void setId_usuario(int id_usuario) {
        this.id_usuario = id_usuario;
    }

    public void setUltimosDigitos(String ultimosDigitos) {
        this.ultimosDigitos = ultimosDigitos;
    }

    public void setNombreTitular(String nombreTitular) {
        this.nombreTitular = nombreTitular;
    }

    public void setFechaExpiracion(String fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
}