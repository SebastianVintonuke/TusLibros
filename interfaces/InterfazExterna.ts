import { DateTime } from "luxon";
import { Dictionary } from "../dominio/collections/Dictionary";
import { InterfazInterna } from "./InterfazInterna";
import { Bag } from "../dominio/collections/Bag";

export class InterfazExterna {
    static codigoDeError(): string {
        return '1|';
    }

    static codigoDeExito(): string {
        return '0|';
    }

    static errorFechaDeExpiracionInvalida(): string {
        return 'Error fecha de expiracion invalida.'
    }

    static errorFormatoDeRequestInvalido(): string {
        return 'Error formato de request invalido.'
    }

    static newCon(unaInterfazInterna: InterfazInterna): InterfazExterna {
        return new InterfazExterna().conInterfazInterna(unaInterfazInterna);
    }

    static statusBadRequest(): string {
        return '400'
    }

    static statusOK(): string {
        return '200'
    }

    private interfazInterna!: InterfazInterna;

    public agregarAlCarrito(requestParaAgregar: Dictionary<string, string>) {
        return this.manejarRequest_parametros_ejecutar(
            requestParaAgregar,
            ['cartId', 'bookIsbn', 'bookQuantity'],
            (cartId: string, bookIsbn: string, bookQuantity: string) => {
                const numberBookIsbn = Number(bookQuantity);
                if (isNaN(numberBookIsbn)) { throw new Error('At least one digit expected here') } // bookQuantity asNumber in Smalltalk, here it doesn't throw an exception
                this.interfazInterna.agregar_libros_alCarrito(numberBookIsbn, bookIsbn, cartId);
                return this.respuestaConStatus_yBody(InterfazExterna.statusOK(), `${InterfazExterna.codigoDeExito()}OK`);
            }
        );
    }

    public checkOut(requestParaCheckOut: Dictionary<string, string>) {
        return this.manejarRequest_parametros_ejecutar(
            requestParaCheckOut,
            ['cartId', 'ccn', 'cced', 'cco'],
            (cartId: string, ccn: string, cced: string, cco: string) => {
                const mesDeAñoDeExpiracion = this.crearMesDeAñoDeExpiracion(cced);
                const idDeTransaccion = this.interfazInterna.checkOutDelCarrito_conNumeroDeTarjeta_conMesDeAñoExpiracion_conNombre(cartId, ccn, mesDeAñoDeExpiracion, cco);
                return this.respuestaConStatus_yBody(InterfazExterna.statusOK(), `${InterfazExterna.codigoDeExito()}${idDeTransaccion}`);
            }
        );
    }

    public crearCarrito(requestParaCrear: Dictionary<string, string>) {
        return this.manejarRequest_parametros_ejecutar(
            requestParaCrear,
            ['clientId', 'password'],
            (clientId: string, password: string) => {
                const idDelCarritoCreado = this.interfazInterna.crearCarritoParaElUsuario_conContraseña(clientId, password);
                return this.respuestaConStatus_yBody(InterfazExterna.statusOK(), `${InterfazExterna.codigoDeExito()}${idDelCarritoCreado}`);
            }
        );
    }

    public listarCarrito(requestParaListar: Dictionary<string, string>) {
        return this.manejarRequest_parametros_ejecutar(
            requestParaListar,
            ['cartId'],
            (cartId: string) => {
                const libros = this.interfazInterna.listarCarrito(cartId);
                return this.respuestaConStatus_yBody(InterfazExterna.statusOK(), `${InterfazExterna.codigoDeExito()}${this.formatearLista(libros)}`);
            }
        );
    }

    private crearMesDeAñoDeExpiracion(unaFechaDeExpiracion: string): DateTime {
        try {
            const numeroDeMes = Number(unaFechaDeExpiracion.slice(0, 2));
            const numeroDeAño = Number(unaFechaDeExpiracion.slice(2, 6));
            const mesDeAñoDeVencimiento = DateTime.fromObject({ month: numeroDeMes, year: numeroDeAño });
            if (!mesDeAñoDeVencimiento.isValid) { throw new Error(mesDeAñoDeVencimiento.invalidExplanation as string | undefined) } // Smalltalk GregorianMonthOfYear throws an exception
            return mesDeAñoDeVencimiento
        } catch {
            throw new Error(InterfazExterna.errorFechaDeExpiracionInvalida());
        }
    }

    private formatearLista(librosAFormatear: Bag<string>): string {
        let stringLista = '';
        librosAFormatear.asSet().do(unLibro => {
            const stringCantidad = librosAFormatear.occurrencesOf(unLibro).toString();
            stringLista = `${stringLista}${unLibro}|${stringCantidad}|`
        });
        return stringLista.slice(0, -1); // Smalltalk allButLast 
    }

    private conInterfazInterna(unaInterfazInterna: InterfazInterna): InterfazExterna {
        this.interfazInterna = unaInterfazInterna;
        return this;
    }

    private manejarRequest_parametros_ejecutar(unaRequest: Dictionary<string, string>, unaListaDeParametros: Array<string>, unBloque: Function) {
        let valoresDeParametros: Array<any>;
        try {
            valoresDeParametros = unaListaDeParametros.map(parametro => unaRequest.at(parametro)) // collect in Smalltalk
        } catch(error) {
            return this.respuestaConStatus_yBody(
                InterfazExterna.statusBadRequest(),
                `${InterfazExterna.codigoDeError()}Error: ${InterfazExterna.errorFormatoDeRequestInvalido()}`
            )
        }

        try {
            return unBloque(...valoresDeParametros); // valueWithArguments in Smalltalk
        } catch(error) {
            return this.respuestaConStatus_yBody(
                InterfazExterna.statusOK(),
                `${InterfazExterna.codigoDeError()}Error: ${(error as Error).message}`
            )
        }
    }

    private respuestaConStatus_yBody(unStatus: string, unBody: string): Dictionary<string, string> {
        const respuesta = new Dictionary<string, string>();
        respuesta.at_put('status', unStatus);
        respuesta.at_put('body', unBody);

        return respuesta;
    }

}