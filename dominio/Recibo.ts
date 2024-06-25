import { Bag } from "./collections/Bag";
import { Set } from "./collections/Set";

export class Recibo {
    static newConPrecioTotal_ylistaDeCompra(unPrecioTotal: number, unaListaDeCompra: Bag<string>): Recibo {
        return new Recibo().precioTotal_yListaDeCompra(unPrecioTotal, unaListaDeCompra);
    }

    private precioTotal!: number;
    private listaDeCompra!: Bag<string>;

    public precioTotal_yListaDeCompra(unPrecioTotal: number, unaListaDeCompra: Bag<string>): Recibo {
        this.precioTotal = unPrecioTotal;
        this.listaDeCompra = unaListaDeCompra;
        return this;
    }

    public cuantosComproDe(unLibro: string): number {
        return this.listaDeCompra.occurrencesOf(unLibro);
    }

    public librosComprados(): Set<string> {
        return this.listaDeCompra.asSet();
    }

    public tienePrecioTotal(unPrecioTotal: number): boolean {
        return this.precioTotal === unPrecioTotal;
    }
}