import { DateTime } from "luxon";
import { TestCase } from "../testing/TestCase";
import { Cajero, MerchantProcessor } from "./Cajero";
import { Carrito } from "./Carrito";
import { TarjetaDeCredito } from "./TarjetaDeCredito";
import { Dictionary } from "./collections/Dictionary";
import { Recibo } from "./Recibo";

export class CajeroTest extends TestCase {
    private unCarrito!: Carrito;

    private assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQue(
        unClosureQueModificaElCarrito: () => void,
        unMerchantProcessor: MerchantProcessor,
        unaTarjetaDeCredito: TarjetaDeCredito,
        unClosureAValidar: (recibo: Recibo) => void
    ): void {
        unClosureQueModificaElCarrito();

        const unCajero = Cajero.newConMerchantProcessor(unMerchantProcessor);
        const unRecibo = unCajero.checkOutDelCarrito_delCatalogo_conTarjeta(
                            this.unCarrito,
                            this.catalogoConExtremeProgramming(),
                            unaTarjetaDeCredito
                        );

        unClosureAValidar(unRecibo);
    }

    private assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQueLanzaElError(
        unClosureQueModificaElCarrito: () => void,
        unMerchantProcessor: MerchantProcessor,
        unaTarjetaDeCredito: TarjetaDeCredito,
        unErrorAValidar: string
    ): void {
        unClosureQueModificaElCarrito();

        const unCajero = Cajero.newConMerchantProcessor(unMerchantProcessor);

        this.shouldRaise(() => {
            unCajero.checkOutDelCarrito_delCatalogo_conTarjeta(
                this.unCarrito,
                this.catalogoConExtremeProgramming(),
                unaTarjetaDeCredito
            )
        }, unErrorAValidar)
    }

    private catalogoConExtremeProgramming(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();
        catalogo.at_put(this.libroExtremeProgramming(), 1);
        return catalogo;
    }

    private fakeTarjetaDeCreditoValida(): TarjetaDeCredito {
        return TarjetaDeCredito.newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular('1', DateTime.now(), '');
    }

    private fakeTarjetaDeCreditoVencida(): TarjetaDeCredito {
        return TarjetaDeCredito.newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular('1', DateTime.fromObject({ month: 12, year: 2000 }), '');
    }

    private libroExtremeProgramming(): string {
        return 'ExtremeProgramming'
    }

    protected setUp(): void {
        this.unCarrito = new Carrito();
    }

    private stubMerchantProcessorQueCobra(): MerchantProcessor {
        return (monto: number, tarjeta: TarjetaDeCredito) => {}
    }

    private stubMerchantProcessorQueFalla(): MerchantProcessor {
        return (monto: number, tarjeta: TarjetaDeCredito) => {
            throw new Error('Merchant Processor Error');
        }
    }

    public test01unCajeroNoPuedeHacerCheckOutDeUnCarritoVacio(): void {
        this.assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQueLanzaElError(
            () => {},
            this.stubMerchantProcessorQueCobra(),
            this.fakeTarjetaDeCreditoValida(),
            Cajero.errorNoSePuedeHacerCheckOutDeUnCarritoVacio()
        )
    }

    public test02unCajeroPuedeHacerCheckOutDeUnCarritoConUnLibroYDevuelveUnReciboQueSabeElMonto(): void {
        this.assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQue(
            () => {
                this.unCarrito.añadir_delCatalogo(
                    this.libroExtremeProgramming(),
                    this.catalogoConExtremeProgramming()
                );
            },
            this.stubMerchantProcessorQueCobra(),
            this.fakeTarjetaDeCreditoValida(),
            (unRecibo: Recibo) => {
                this.deny(unRecibo.tienePrecioTotal(0));
                this.assert(unRecibo.tienePrecioTotal(1));
                this.deny(unRecibo.tienePrecioTotal(2));
            }
        )
    }

    public test03unCajeroPuedeHacerCheckOutDeUnCarritoConMasDeUnLibroYDevuelveUnReciboQueSabeElMonto(): void {
        this.assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQue(
            () => {
                this.unCarrito.añadir_delCatalogo(
                    this.libroExtremeProgramming(),
                    this.catalogoConExtremeProgramming()
                );
                this.unCarrito.añadir_delCatalogo(
                    this.libroExtremeProgramming(),
                    this.catalogoConExtremeProgramming()
                );
            },
            this.stubMerchantProcessorQueCobra(),
            this.fakeTarjetaDeCreditoValida(),
            (unRecibo: Recibo) => {
                this.deny(unRecibo.tienePrecioTotal(1));
                this.assert(unRecibo.tienePrecioTotal(2));
                this.deny(unRecibo.tienePrecioTotal(3));
            }
        )
    }

    public test04unCajeroNoPuedeHacerCheckOutDeUnCarritoConUnaTarjetaVencida(): void {
        this.assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQueLanzaElError(
            () => {
                this.unCarrito.añadir_delCatalogo(
                    this.libroExtremeProgramming(),
                    this.catalogoConExtremeProgramming()
                );
            },
            this.stubMerchantProcessorQueCobra(),
            this.fakeTarjetaDeCreditoVencida(),
            Cajero.errorTarjetaDeCreditoVencida()
        )
    }

    public test05unCajeroNoPuedeHacerCheckOutSiSuMerchantProcessorFalla(): void {
        this.assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQueLanzaElError(
            () => {
                this.unCarrito.añadir_delCatalogo(
                    this.libroExtremeProgramming(),
                    this.catalogoConExtremeProgramming()
                );
            },
            this.stubMerchantProcessorQueFalla(),
            this.fakeTarjetaDeCreditoValida(),
            Cajero.errorNoSePudoRealizarElCobro()
        )
    }

    public test06unCajeroVaciaElCarritoLuegoDelCheckOut(): void {
        this.assertAlCarritoHacer_cajeroConMerchantProcessor_hacerCheckoutConTarjeta_validarQue(
            () => {
                this.unCarrito.añadir_delCatalogo(
                    this.libroExtremeProgramming(),
                    this.catalogoConExtremeProgramming()
                );
            },
            this.stubMerchantProcessorQueCobra(),
            this.fakeTarjetaDeCreditoValida(),
            (_unRecibo: Recibo) => {
                this.assert(this.unCarrito.estaVacio());
            }
        )
    }
}