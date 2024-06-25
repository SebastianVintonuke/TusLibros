import { Carrito } from "./Carrito";
import { Recibo } from "./Recibo";
import { TarjetaDeCredito } from "./TarjetaDeCredito";
import { Bag } from "./collections/Bag";
import { Dictionary } from "./collections/Dictionary";

export type MerchantProcessor = (anAmountToDebit: number, aCreditCard: TarjetaDeCredito) => void;

export class Cajero {
    static errorNoSePudoRealizarElCobro(): string {
        return 'No se pudo realizar el cobro.';
    }

    static errorNoSePuedeHacerCheckOutDeUnCarritoVacio(): string {
        return 'No se puede hacer checkOut de un carrito vacio.';
    }

    static errorTarjetaDeCreditoVencida(): string {
        return 'Tarjeta de credito vencida.'
    }

    static newConMerchantProcessor(unMerchantProcessor: MerchantProcessor): Cajero {
        return new Cajero().conMerchantProcessor(unMerchantProcessor);
    }

    private merchantProcessor!: MerchantProcessor;

    public conMerchantProcessor(unClosureQueCobra: MerchantProcessor): Cajero {
        this.merchantProcessor = unClosureQueCobra;
        return this;
    }

    public checkOutDelCarrito_delCatalogo_conTarjeta(unCarrito: Carrito, unCatalogoParaVerificarPrecios: Dictionary<string, number>, unaTarjeta: TarjetaDeCredito): Recibo {
        if (unCarrito.estaVacio()) { throw new Error(Cajero.errorNoSePuedeHacerCheckOutDeUnCarritoVacio()) }
        if (unaTarjeta.estaVencida()) { throw new Error(Cajero.errorTarjetaDeCreditoVencida()) }

        const listaDeCompra = unCarrito.listar();
        const precioTotal = this.calcularPrecioTotalDe_aPartirDe(listaDeCompra, unCatalogoParaVerificarPrecios);

        this.cobrar_de(precioTotal, unaTarjeta);

        unCarrito.vaciar();

        return Recibo.newConPrecioTotal_ylistaDeCompra(precioTotal, listaDeCompra);
    }

    private calcularPrecioTotalDe_aPartirDe(listaDeCompra: Bag<string>, unCatalogoParaVerificarPrecios: Dictionary<string, number>): number {
        let precioTotal = 0;

        listaDeCompra.do(unLibro => {
            const precioPorUnidad = unCatalogoParaVerificarPrecios.at(unLibro);
            precioTotal = precioTotal + precioPorUnidad;
        });

        return precioTotal
    }

    private cobrar_de(precioTotal: number, unaTarjeta: TarjetaDeCredito): void {
        try {
            this.merchantProcessor(precioTotal, unaTarjeta);
        } catch(_error) {
            throw new Error(Cajero.errorNoSePudoRealizarElCobro());
        }
    }
}