import { Bag } from "./collections/Bag";
import { Dictionary } from "./collections/Dictionary";

export class Carrito {
    static errorNoSePuedeAñadirLibroDescatalogado(): string {
        return 'No se pueden añadir libros descatalogados.';
    }

    static errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro(): string {
        return 'No se puede agregar menos de una copia de un libro.';
    }

    private libros: Bag<string> = new Bag;

    public añadir_cantidadDeCopias_delCatalogo(unLibroAAñadir: string, unaCantidadDeCopias: number, unCatalogoParaVerificar: Dictionary<string, number>): Carrito {
        if (unaCantidadDeCopias <= 0) {
            throw new Error(Carrito.errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro());
        }

        for (let i = 0; i < unaCantidadDeCopias; i++) {
            this.añadir_delCatalogo(unLibroAAñadir, unCatalogoParaVerificar);
        }

        return this
    }

    public añadir_delCatalogo(unLibroAAñadir: string, unCatalogoParaVerificar: Dictionary<string, number>): Carrito {
        if (!unCatalogoParaVerificar.includesKey(unLibroAAñadir)) {
            throw new Error(Carrito.errorNoSePuedeAñadirLibroDescatalogado());
        }

        this.libros.add(unLibroAAñadir);

        return this
    }

    public estaVacio(): boolean {
        return this.libros.isEmpty();
    }

    public incluye(unLibroAVerificar: string): boolean {
        return this.libros.includes(unLibroAVerificar);
    }

    public listar(): Bag<string> {
        return this.libros.copy();
    }

    public vaciar(): Carrito {
        this.libros = new Bag;
        return this;
    }
}