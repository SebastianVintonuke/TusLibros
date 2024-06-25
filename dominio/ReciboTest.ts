import { TestCase } from "../testing/TestCase"
import { Recibo } from "./Recibo";
import { Bag } from "./collections/Bag";

export class ReciboTest extends TestCase {
    private libroExtremeProgramming(): string {
        return 'ExtremeProgramming'
    }

    private listaDeComprasConDosExtremeProgramming(): Bag<string> {
        const listaDeCompras = this.listaDeComprasConExtremeProgramming();
        listaDeCompras.add(this.libroExtremeProgramming());
        return listaDeCompras;
    }

    private listaDeComprasConExtremeProgramming(): Bag<string> {
        const listaDeCompras = new Bag<string>();
        listaDeCompras.add(this.libroExtremeProgramming());
        return listaDeCompras;
    }

    public test01unReciboSabeQueLibrosFueronComprados(): void {
        const unRecibo = Recibo.newConPrecioTotal_ylistaDeCompra(1, this.listaDeComprasConExtremeProgramming());

        const librosComprados = unRecibo.librosComprados();

        this.assert(librosComprados.includes(this.libroExtremeProgramming()));
    }

    public test02unReciboSabeLaCantidadDeCadaLibroComprado(): void {
        const unRecibo = Recibo.newConPrecioTotal_ylistaDeCompra(1, this.listaDeComprasConDosExtremeProgramming());

        this.assertEquals(unRecibo.cuantosComproDe(this.libroExtremeProgramming()), 2);
    }
}