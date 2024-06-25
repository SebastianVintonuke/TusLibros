import { TestCase } from '../testing/TestCase';
import { InterfazExterna } from './InterfazExterna';
import { InterfazInterna } from './InterfazInterna';
import { Dictionary } from "../dominio/collections/Dictionary";
import { DateTime } from 'luxon';
import { Cajero, MerchantProcessor } from '../dominio/Cajero';
import { TarjetaDeCredito } from '../dominio/TarjetaDeCredito';
import { Carrito } from '../dominio/Carrito';

export class InterfazExternaTest extends TestCase {
    private assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida(
        unClosureConUnaRequestARealizar: (unaInterfazExterna: InterfazExterna, unPaqueteInvalido: Dictionary<string, string>) => Dictionary<string, string>
    ): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();

        const unPaqueteInvalido = new Dictionary<string, string>();
        const respuesta = unClosureConUnaRequestARealizar(unaInterfazExterna, unPaqueteInvalido);

        this.assertRespuesta_tieneStatus_yBody(
            respuesta,
            InterfazExterna.statusBadRequest(),
            `${InterfazExterna.codigoDeError()}Error: ${InterfazExterna.errorFormatoDeRequestInvalido()}`
        );
    }

    private assertQueUnaRespuestaDeCheckOutDeUnCarritoEsValida(unaRespuesta: Dictionary<string, string>): void {
        this.assertQueUnaRespuestaExitosaTieneUnID(unaRespuesta)
    }

    private assertQueUnaRespuestaDeCrearUnCarritoEsValida(unaRespuesta: Dictionary<string, string>): void {
        this.assertQueUnaRespuestaExitosaTieneUnID(unaRespuesta)
    }

    private assertQueUnaRespuestaExitosaTieneUnID(unaRespuesta: Dictionary<string, string>): void {
        this.assertEquals(unaRespuesta.at('status'), 200);
        this.assert(unaRespuesta.at('body').length >= 3);
    }

    private assertRespuesta_tieneStatus_yBody(unaRespuesta: Dictionary<string, string>, unStatus: string, unBody: string): void {
        this.assertEquals(unaRespuesta.at('status'), unStatus);
        this.assertEquals(unaRespuesta.at('body'), unBody);
    }

    private catalogoConExtremeProgramming(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();
        catalogo.at_put(this.iSBNLibroExtremeProgramming(), 1);
        return catalogo;
    }

    private catalogoVacio(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();
        return catalogo;
    }

    private crearPaqueteParaAgregarUnLibroConIdDeCarrito_iSBNDeLibro_cantidadDeLibros(unIdDeCarrito: string, unIsbnDeLibro: string, unaCantidad: string): Dictionary<string, string> {
        const paqueteParaAgregar = new Dictionary<string, string>();

        paqueteParaAgregar.at_put('cartId', unIdDeCarrito);
        paqueteParaAgregar.at_put('bookIsbn', unIsbnDeLibro);
        paqueteParaAgregar.at_put('bookQuantity', unaCantidad);

        return paqueteParaAgregar;
    }

    private crearPaqueteParaCheckOutConIdDeCarrito_ccnDeLaTarjeta_ccedDeLaTarjeta_ccoDeLaTarjeta(unIdDeCarrito: string, unCcn: string, unCced: string, unCco: string): Dictionary<string, string> {
        const paqueteParaCheckOut = new Dictionary<string, string>();

        paqueteParaCheckOut.at_put('cartId', unIdDeCarrito);
        paqueteParaCheckOut.at_put('ccn', unCcn);
        paqueteParaCheckOut.at_put('cced', unCced);
        paqueteParaCheckOut.at_put('cco', unCco);

        return paqueteParaCheckOut;
    }

    private crearPaqueteParaCrearCarritoConCliente_yContraseña(unIdDeCliente: string, unaContraseña: string): Dictionary<string, string> {
        const paqueteParaCrear = new Dictionary<string, string>();

        paqueteParaCrear.at_put('clientId', unIdDeCliente);
        paqueteParaCrear.at_put('password', unaContraseña);

        return paqueteParaCrear;
    }

    private crearPaqueteParaListarUnCarrito(unIdDeCarrito: string): Dictionary<string, string> {
        const paqueteParaListar = new Dictionary<string, string>();

        paqueteParaListar.at_put('cartId', unIdDeCarrito);

        return paqueteParaListar;
    }

    private iSBNLibroExtremeProgramming(): string {
        return '9780201710915'
    }

    private idDeCarritoDe(respuestaBodyDeCrear: string): string {
        return respuestaBodyDeCrear.slice(2);
    }

    private interfazExterna_listar(unaInterfazExterna: InterfazExterna, iDDelCarrito: string): Dictionary<string, string> {
        const paqueteParaListar = this.crearPaqueteParaListarUnCarrito(iDDelCarrito);

        return unaInterfazExterna.listarCarrito(paqueteParaListar);
    }

    private interfazExternaConInterfazInternaConCatalogoVacio(): InterfazExterna {
        const interfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                this.catalogoVacio(),
                                                this.stubAutenticadorQueAutenticaTodo(),
                                                this.stubMerchantProcessorQueCobraTodo()
                                            );
        return InterfazExterna.newCon(interfazInterna);
    }

    private interfazExternaConInterfazInternaQueHaceTodo(): InterfazExterna {
        const interfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                this.catalogoConExtremeProgramming(),
                                                this.stubAutenticadorQueAutenticaTodo(),
                                                this.stubMerchantProcessorQueCobraTodo()
                                            );
        return InterfazExterna.newCon(interfazInterna);
    }

    private interfazExternaConInterfazInternaQueNoAutenticaNada(): InterfazExterna {
        const interfazInterna = InterfazInterna.newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
                                                this.catalogoConExtremeProgramming(),
                                                this.stubAutenticadorQueNoAutenticaNada(),
                                                this.stubMerchantProcessorQueCobraTodo()
                                            );
        return InterfazExterna.newCon(interfazInterna);
    }

    private interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
        unaInterfazExterna: InterfazExterna,
        iDDelCarrito: string,
        iSBNDelLibroAAgregar: string,
        cantidadAAgregar: string
    ): Dictionary<string, string> {
        const paqueteParaAgregar = this.crearPaqueteParaAgregarUnLibroConIdDeCarrito_iSBNDeLibro_cantidadDeLibros(
            iDDelCarrito,
            iSBNDelLibroAAgregar,
            cantidadAAgregar
        );
        return unaInterfazExterna.agregarAlCarrito(paqueteParaAgregar);
    }

    private interfazInterna_checkOutAlCarrito_ccnDeLaTarjeta_ccedDeLaTarjeta_ccoDeLaTarjeta(
        unaInterfazExterna: InterfazExterna,
        iDDelCarrito: string,
        unCcn: string,
        unCced: string,
        unCco: string,
    ): Dictionary<string, string> {
        const paqueteParaCheckOut = this.crearPaqueteParaCheckOutConIdDeCarrito_ccnDeLaTarjeta_ccedDeLaTarjeta_ccoDeLaTarjeta(
            iDDelCarrito,
            unCcn,
            unCced,
            unCco
        )
        return unaInterfazExterna.checkOut(paqueteParaCheckOut);
    }

    private interfazInterna_crearCarritoConCliente_yContraseña(unaInterfazExterna: InterfazExterna, unCliente: string, unaContraseña: string): Dictionary<string, string> {
        const paqueteParaCrear = this.crearPaqueteParaCrearCarritoConCliente_yContraseña(unCliente, unaContraseña);
        return unaInterfazExterna.crearCarrito(paqueteParaCrear);
    }

    private interfazInternaIDDeUnCarritoCreado(unaInterfazExterna: InterfazExterna): string {
        const respuestaCrear = this.interfazInterna_crearCarritoConCliente_yContraseña(unaInterfazExterna, '', '');
        const iDDelCarrito = this.idDeCarritoDe(respuestaCrear.at('body'));
        return iDDelCarrito;
    }

    private mesDeAñoDeExpiracionValido(): string {
        const current = DateTime.now();
        const month = current.month;
        const year = current.year;

        if (month < 10) {
            return `0${month.toString()}${year.toString()}`
        } else {
            return `${month.toString()}${year.toString()}`
        }
        // return DateTime.now().toFormat('LLy');
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

    public test01unaInterfazExternaRespondeExitosamenteAlCrearCarrito(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();

        const respuestaCrear = this.interfazInterna_crearCarritoConCliente_yContraseña(unaInterfazExterna, '', '');

        this.assertQueUnaRespuestaDeCrearUnCarritoEsValida(respuestaCrear);
    }

    public test02unaInterfazExternaRespondeExitosamenteAlCreaDosCarritos(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();

        const respuestaCrear = this.interfazInterna_crearCarritoConCliente_yContraseña(unaInterfazExterna, '', '');
        const otraRespuestaCrear = this.interfazInterna_crearCarritoConCliente_yContraseña(unaInterfazExterna, '', '');

        this.assertQueUnaRespuestaDeCrearUnCarritoEsValida(respuestaCrear);
        this.assertQueUnaRespuestaDeCrearUnCarritoEsValida(otraRespuestaCrear);
    }

    public test03unaInterfazExternaRespondeExitosamenteAlAgregaUnLibro(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();

        const respuestaAgregar = this.interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
            unaInterfazExterna,
            this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna),
            this.iSBNLibroExtremeProgramming(),
            '1'
        );

        this.assertRespuesta_tieneStatus_yBody(
            respuestaAgregar,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeExito()}OK`
        );
    }

    public test04unaInterfazExternaRespondeUnErrorAlAgregaUnLibroQueNoEstaEnCatalogo(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaConCatalogoVacio();

        const respuestaAgregar = this.interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
            unaInterfazExterna,
            this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna),
            this.iSBNLibroExtremeProgramming(),
            '1'
        );

        this.assertRespuesta_tieneStatus_yBody(
            respuestaAgregar,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeError()}Error: ${Carrito.errorNoSePuedeAñadirLibroDescatalogado()}`
        );
    }

    public test05unaInterfazExternaRespondeExitosamenteAlListaUnCarritoVacio(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();

        const respuestaListar = this.interfazExterna_listar(
            unaInterfazExterna,
            this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna)
        );

        this.assertRespuesta_tieneStatus_yBody(
            respuestaListar,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeExito()}`
        );
    }

    public test06unaInterfazExternaRespondeExitosamenteAlListaUnCarritoConUnLibro(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();
        const iDDelCarrito = this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna);

        this.interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
            unaInterfazExterna,
            iDDelCarrito,
            this.iSBNLibroExtremeProgramming(),
            '1'
        );

        const respuestaListar = this.interfazExterna_listar(unaInterfazExterna, iDDelCarrito);

        this.assertRespuesta_tieneStatus_yBody(
            respuestaListar,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeExito()}${this.iSBNLibroExtremeProgramming()}|1`
        );
    }

    public test07unaInterfazExternaRespondeUnErrorAlListaUnCarritoSinCrearlo(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();

        const iDDelCarritoNoCreado = '1';
        const respuestaListar = this.interfazExterna_listar(unaInterfazExterna, iDDelCarritoNoCreado);

        this.assertRespuesta_tieneStatus_yBody(
            respuestaListar,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeError()}Error: ${InterfazInterna.errorElCarritoNoFueCreado()}`
        );
    }

    public test08unaInterfazExternaRespondeUnErrorAlCrearCarritoConUnaRequestInvalida(): void {
        this.assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida((unaInterfazExterna: InterfazExterna, unPaqueteInvalido: Dictionary<string, string>) => {
            return unaInterfazExterna.crearCarrito(unPaqueteInvalido);
        });
    }

    public test09unaInterfazExternaRespondeUnErrorAlListarConUnaRequestInvalida(): void {
        this.assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida((unaInterfazExterna: InterfazExterna, unPaqueteInvalido: Dictionary<string, string>) => {
            return unaInterfazExterna.listarCarrito(unPaqueteInvalido);
        });
    }

    public test10unaInterfazExternaRespondeUnErrorAlAgregarLibroConUnaRequestInvalida(): void {
        this.assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida((unaInterfazExterna: InterfazExterna, unPaqueteInvalido: Dictionary<string, string>) => {
            return unaInterfazExterna.agregarAlCarrito(unPaqueteInvalido);
        });
    }

    public test11unaInterfazExternaRespondeExitosamenteAlListaUnCarritoConMasDeUnaCopiaDeUnLibro(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();
        const iDDelCarrito = this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna);

        this.interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
            unaInterfazExterna,
            iDDelCarrito,
            this.iSBNLibroExtremeProgramming(),
            '2'
        );
        const respuestaListar = this.interfazExterna_listar(unaInterfazExterna, iDDelCarrito);

        this.assertRespuesta_tieneStatus_yBody(
            respuestaListar,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeExito()}${this.iSBNLibroExtremeProgramming()}|2`
        )
    }

    public test12unaInterfazExternaRespondeUnErrorAlCrearCarritoConUsuarioNoAutenticado(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueNoAutenticaNada();

        const respuestaCrear = this.interfazInterna_crearCarritoConCliente_yContraseña(unaInterfazExterna, '', '');

        this.assertRespuesta_tieneStatus_yBody(
            respuestaCrear,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeError()}Error: ${InterfazInterna.errorCredencialesInvalidas()}`
        );
    }

    public test13unaInterfazExternaRespondeUnErrorAlHacerCheckOutDeUnCarritoVacio(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();
        const respuestaCheckOut = this.interfazInterna_checkOutAlCarrito_ccnDeLaTarjeta_ccedDeLaTarjeta_ccoDeLaTarjeta(
            unaInterfazExterna,
            this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna),
            '',
            this.mesDeAñoDeExpiracionValido(),
            ''
        );

        this.assertRespuesta_tieneStatus_yBody(
            respuestaCheckOut,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeError()}Error: ${Cajero.errorNoSePuedeHacerCheckOutDeUnCarritoVacio()}`
        );
    }

    public test14unaInterfazExternaRespondeExitosamenteAlHacerCheckOutDeUnCarrito(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();
        const iDDelCarrito = this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna);

        this.interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
            unaInterfazExterna,
            iDDelCarrito,
            this.iSBNLibroExtremeProgramming(),
            '1'
        );

        const respuestaCheckOut = this.interfazInterna_checkOutAlCarrito_ccnDeLaTarjeta_ccedDeLaTarjeta_ccoDeLaTarjeta(
            unaInterfazExterna,
            iDDelCarrito,
            '',
            this.mesDeAñoDeExpiracionValido(),
            ''
        );

        this.assertQueUnaRespuestaDeCheckOutDeUnCarritoEsValida(respuestaCheckOut)
    }

    public test15unaInterfazExternaRespondeUnErrorAlHacerCheckOutConUnaRequestInvalida(): void {
        this.assertQueUnaInterfazExternaRespondeUnErrorAlUsarUnaRequestInvalida((unaInterfazExterna: InterfazExterna, unPaqueteInvalido: Dictionary<string, string>) => {
            return unaInterfazExterna.checkOut(unPaqueteInvalido);
        });
    }

    public test16unaInterfazExternaRespondeUnErrorAlHacerCheckOutConUnPaqueteConTarjetaConFechaDeExpiracionInvalida(): void {
        const unaInterfazExterna = this.interfazExternaConInterfazInternaQueHaceTodo();
        const iDDelCarrito = this.interfazInternaIDDeUnCarritoCreado(unaInterfazExterna);

        this.interfazInterna_agregarAlCarrito_IsbnDeLibro_cantidadDeLibros(
            unaInterfazExterna,
            iDDelCarrito,
            this.iSBNLibroExtremeProgramming(),
            '1'
        );
        const mesDeAñoDeExpiracionInvalido = '132023';
        const respuestaCheckOut = this.interfazInterna_checkOutAlCarrito_ccnDeLaTarjeta_ccedDeLaTarjeta_ccoDeLaTarjeta(
            unaInterfazExterna,
            iDDelCarrito,
            '',
            mesDeAñoDeExpiracionInvalido,
            ''
        );

        this.assertRespuesta_tieneStatus_yBody(
            respuestaCheckOut,
            InterfazExterna.statusOK(),
            `${InterfazExterna.codigoDeError()}Error: ${InterfazExterna.errorFechaDeExpiracionInvalida()}`
        );
    }
}