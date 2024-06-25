import { TestCase } from '../testing/TestCase';
import { Dictionary } from '../dominio/collections/Dictionary';
import { Cajero, MerchantProcessor } from '../dominio/Cajero';
import { TarjetaDeCredito } from '../dominio/TarjetaDeCredito';
import { InterfazInterna } from './InterfazInterna';
import { DateTime } from 'luxon';
import { Sesion } from './Sesion';

export class InterfazInternaTest extends TestCase {
    private catalogoConExtremeProgramming(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();

        catalogo.at_put(this.iSBNLibroExtremeProgramming(), 1);

        return catalogo;
    }

    private catalogoVacio(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();

        return catalogo;
    }

    private iSBNLibroExtremeProgramming(): string {
        return '9780201710915'
    }

    private stubAutenticadorQueAutenticaTodo(): (usuario: string, contraseña: string) => void {
        return (_usuario: string, _contraseña: string) => {};
    }

    private stubAutenticadorQueNoAutenticaNada(): (usuario: string, contraseña: string) => void {
        return (_usuario: string, _contraseña: string) => {
            throw new Error('Invalid credentials');
        };
    }

    private stubMerchantProcessorQueCobraTodo(): MerchantProcessor {
        return (_monto: number, _tarjeta: TarjetaDeCredito) => {}
    }

    private stubMerchantProcessorQueNoCobraNada(): MerchantProcessor {
        return (_monto: number, _tarjeta: TarjetaDeCredito) => {
            throw new Error('Merchant Processor Error');
        }
    }

    public test01unaInterfazInternaCreaUnCarritoYEmpiezaVacio(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoVacio(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        const iDDelCarrito = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');

        this.assert(unaInterfazInterna.listarCarrito(iDDelCarrito).isEmpty());
    }

    public test02unaInterfazInternaLanzaUnErrorAlListarUnCarritoSinCrearlo(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoVacio(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        const iDDeUnCarritoNoCreado = '1';

        this.shouldRaise(
            () => {
                unaInterfazInterna.listarCarrito(iDDeUnCarritoNoCreado);
            },
            InterfazInterna.errorElCarritoNoFueCreado()
        );
    }

    public test03unaInterfazInternaPuedeAgregarUnLibroYApareceAlListar(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );
        
        const iDDelCarrito = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');
        unaInterfazInterna.agregar_libros_alCarrito(1, this.iSBNLibroExtremeProgramming(), iDDelCarrito);

        const listado = unaInterfazInterna.listarCarrito(iDDelCarrito);

        this.assertEquals(listado.size(), 1);
        this.assert(listado.includes(this.iSBNLibroExtremeProgramming()));
    }

    public test04unaInterfazInternaCreaDosCarritosDiferentes(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        const iDDeUnCarritoConLibro = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');
        const iDDeUnCarritoVacio = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');

        unaInterfazInterna.agregar_libros_alCarrito(1, this.iSBNLibroExtremeProgramming(), iDDeUnCarritoConLibro);

        this.assert(iDDeUnCarritoConLibro !== iDDeUnCarritoVacio);
        this.assert(unaInterfazInterna.listarCarrito(iDDeUnCarritoConLibro).includes(this.iSBNLibroExtremeProgramming()));
        this.assert(unaInterfazInterna.listarCarrito(iDDeUnCarritoVacio).isEmpty());
    }

    public test05unaInterfazInternaLanzaUnErrorAlAgregarUnLibroAUnCarritoSinCrearlo(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        const iDDeUnCarritoNoCreado = '1';

        this.shouldRaise(
            () => {
                unaInterfazInterna.agregar_libros_alCarrito(1, this.iSBNLibroExtremeProgramming(), iDDeUnCarritoNoCreado);
            },
            InterfazInterna.errorElCarritoNoFueCreado()
        );
    }

    public test06unaInterfazInternaPuedeAgregarMasDeUnLibroYApareceAlListar(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );
        
        const iDDelCarrito = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');
        unaInterfazInterna.agregar_libros_alCarrito(2, this.iSBNLibroExtremeProgramming(), iDDelCarrito);

        const listado = unaInterfazInterna.listarCarrito(iDDelCarrito);

        this.assert(listado.includes(this.iSBNLibroExtremeProgramming()));
        this.assertEquals(listado.occurrencesOf(this.iSBNLibroExtremeProgramming()), 2);
    }

    public test07unaInterfazInternaNoPuedeCrearUnCarritoSiElUsuarioNoEstaRegistrado(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoVacio(),
                                                        this.stubAutenticadorQueNoAutenticaNada(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        this.shouldRaise(
            () => {
                unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '')
            },
            InterfazInterna.errorCredencialesInvalidas()
        );
    }

    public test08unaInterfazInternaLanzaUnErrorAlHacerCheckOutDeUnCarritoSinCrearlo(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoVacio(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        const iDDeUnCarritoNoCreado = '1';

        this.shouldRaise(
            () => {
                unaInterfazInterna.checkOutDelCarrito_conNumeroDeTarjeta_conMesDeAñoExpiracion_conNombre(iDDeUnCarritoNoCreado, '', DateTime.now(), '')
            },
            InterfazInterna.errorElCarritoNoFueCreado()
        );
    }

    public test09unaInterfazInternaPuedeHacerCheckOutDeUnCarritoYApareceEnLibroDeVentas(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueCobraTodo()
                                                    );

        const iDDelCarrito = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');
        unaInterfazInterna.agregar_libros_alCarrito(1, this.iSBNLibroExtremeProgramming(), iDDelCarrito);

        const iDDeTransaccion = unaInterfazInterna.checkOutDelCarrito_conNumeroDeTarjeta_conMesDeAñoExpiracion_conNombre(iDDelCarrito, '', DateTime.now(), '');

        this.assert(unaInterfazInterna.tieneCompraResgistradaCon(iDDeTransaccion));
    }

    public test10unaInterfazInternaNoPuedeHacerCheckOutDeUnCarritoSiFallaElMerchantProcessorYNoApareceEnElLibroDeVentas(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueNoCobraNada()
                                                    );

        const iDDelCarrito = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');
        unaInterfazInterna.agregar_libros_alCarrito(1, this.iSBNLibroExtremeProgramming(), iDDelCarrito);

        let iDDeTransaccion: string | undefined;

        this.shouldRaise(
            () => {
                iDDeTransaccion = unaInterfazInterna.checkOutDelCarrito_conNumeroDeTarjeta_conMesDeAñoExpiracion_conNombre(iDDelCarrito, '', DateTime.now(), '');
            },
            Cajero.errorNoSePudoRealizarElCobro()
        );

        if (!iDDeTransaccion) return
        this.deny(unaInterfazInterna.tieneCompraResgistradaCon(iDDeTransaccion));
    }

    public test11unaInterfazInternaBorraElCarritoSiLaSesionExpiro(): void {
        const unaInterfazInterna = InterfazInterna.newConSesionesExpiradasCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                        this.catalogoConExtremeProgramming(),
                                                        this.stubAutenticadorQueAutenticaTodo(),
                                                        this.stubMerchantProcessorQueNoCobraNada()
                                                    );

        const iDDelCarrito = unaInterfazInterna.crearCarritoParaElUsuario_conContraseña('', '');

        this.shouldRaise(
            () => { unaInterfazInterna.listarCarrito(iDDelCarrito); },
            Sesion.errorSesionExpirada()
        );

        this.shouldRaise(
            () => { unaInterfazInterna.listarCarrito(iDDelCarrito); },
            InterfazInterna.errorElCarritoNoFueCreado()
        );
    }
}