package model;

import java.math.BigDecimal;

public class CarritoItem {
    private Producto producto;
    private int cantidad;

    public CarritoItem(Producto producto, int cantidad) {
        this.producto = producto;
        this.cantidad = cantidad;
    }
    
    // Getters y Setters
    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    // Método de utilidad para calcular el subtotal
    public BigDecimal getSubtotal() {
        if (producto != null && producto.getPrecio() != null) {
            // Se asume que getPrecio() devuelve un BigDecimal
            return producto.getPrecio().multiply(new BigDecimal(cantidad));
        }
        return BigDecimal.ZERO;
    }
}