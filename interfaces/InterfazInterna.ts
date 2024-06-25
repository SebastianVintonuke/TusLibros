import { DateTime, Duration } from "luxon";
import { Cajero, MerchantProcessor } from "../dominio/Cajero";
import { Dictionary } from "../dominio/collections/Dictionary";
import { Sesion } from "./Sesion";
import { Recibo } from "../dominio/Recibo";
import { TarjetaDeCredito } from "../dominio/TarjetaDeCredito";
import { Carrito } from "../dominio/Carrito";
import { Bag } from "../dominio/collections/Bag";
const { v4: uuidv4 } = require('uuid');

export class InterfazInterna {
    static errorCredencialesInvalidas(): string {
        return 'Credenciales invalidas, Nombre de usuario o contrasena invalidos.';
    }

    static errorElCarritoNoFueCreado(): string {
        return 'El carrito no fue creado.';
    }

    static errorSesionExpirada(): string {
        return 'Sesion expirada.';
    }

    static newConCatalogo_sistemaDeAutenticacion_merchantProcessor_yTiempoDeSesion(
        unCatalogoAVerificar: Dictionary<string, number>,
        unClosureQueAutenticaUnUsuarioYContraseña: (aClientId: string, aPassword: string) => void,
        unClosureQueCobra: MerchantProcessor,
        unaMedidaDeTiempoDeSesion: Duration
    ): InterfazInterna {
        return new InterfazInterna().conCatalogo_sistemaDeAutenticacion_merchantProcessor_yTiempoDeSesion(
            unCatalogoAVerificar,
            unClosureQueAutenticaUnUsuarioYContraseña,
            unClosureQueCobra,
            unaMedidaDeTiempoDeSesion
        );
    }

    static newConSesionQueNoExpiraCatalogo_sistemaDeAutenticacion_merchantProcessor(
        unCatalogoAVerificar: Dictionary<string, number>,
        unClosureQueAutenticaUnUsuarioYContraseña: (aClientId: string, aPassword: string) => void,
        unClosureQueCobra: MerchantProcessor
    ): InterfazInterna {
        return new InterfazInterna().conCatalogo_sistemaDeAutenticacion_merchantProcessor_yTiempoDeSesion(
            unCatalogoAVerificar,
            unClosureQueAutenticaUnUsuarioYContraseña,
            unClosureQueCobra,
            Duration.fromObject({ years: 100 })
        );
    }

    static newConSesionesExpiradasCatalogo_sistemaDeAutenticacion_merchantProcessor(
        unCatalogoAVerificar: Dictionary<string, number>,
        unClosureQueAutenticaUnUsuarioYContraseña: (aClientId: string, aPassword: string) => void,
        unClosureQueCobra: MerchantProcessor
    ): InterfazInterna {
        return new InterfazInterna().conCatalogo_sistemaDeAutenticacion_merchantProcessor_yTiempoDeSesion(
            unCatalogoAVerificar,
            unClosureQueAutenticaUnUsuarioYContraseña,
            unClosureQueCobra,
            Duration.fromObject({ seconds: -1 })
        );
    }
    
    private sesiones!: Dictionary<string, Sesion<Carrito>>;
    private catalogo!: Dictionary<string, number>;
    private sistemaDeAutenticacion!: (aClientId: string, aPassword: string) => void;
    private libroDeVentas!: Dictionary<string, Recibo>;
    private merchantProcessor!: MerchantProcessor;
    private medidaDeTiempoDeSesion!: Duration;

    constructor() {
        this.libroDeVentas = new Dictionary();
        this.sesiones = new Dictionary();
    }

    private conCatalogo_sistemaDeAutenticacion_merchantProcessor_yTiempoDeSesion(
        unCatalogoAVerificar: Dictionary<string, number>,
        unClosureQueAutenticaUnUsuarioYContraseña: (aClientId: string, aPassword: string) => void,
        unClosureQueCobra: MerchantProcessor,
        unaMedidaDeTiempoDeSesion: Duration
    ): InterfazInterna {
        this.catalogo = unCatalogoAVerificar;
        this.sistemaDeAutenticacion = unClosureQueAutenticaUnUsuarioYContraseña;
        this.merchantProcessor = unClosureQueCobra;
        this.medidaDeTiempoDeSesion = unaMedidaDeTiempoDeSesion;

        return this;
    }

    public agregar_libros_alCarrito(unaCantidadAAgregar: number, iSBNDeUnLibro: string, iDDelCarrito: string): void {
        const carrito = this.buscarCarrito(iDDelCarrito);

        carrito.añadir_cantidadDeCopias_delCatalogo(iSBNDeUnLibro, unaCantidadAAgregar, this.catalogo);
    }

    public checkOutDelCarrito_conNumeroDeTarjeta_conMesDeAñoExpiracion_conNombre(
        iDDeUnCarrito: string,
        unNumeroDeTarjeta: string,
        unMesDeAñoDeExpiracion: DateTime,
        unNombreDeTitular: string
    ): string {
        const carrito = this.buscarCarrito(iDDeUnCarrito);

        const tarjetaDeCredito = TarjetaDeCredito.newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular(unNumeroDeTarjeta, unMesDeAñoDeExpiracion, unNombreDeTitular);
        const cajero = Cajero.newConMerchantProcessor(this.merchantProcessor);
        const unRecibo = cajero.checkOutDelCarrito_delCatalogo_conTarjeta(carrito, this.catalogo, tarjetaDeCredito);
        const idDeTransaccion = this.agregarReciboAlLibroDeVentas(unRecibo);

        return idDeTransaccion
    }

    public crearCarritoParaElUsuario_conContraseña(unUsuario: string, unaContraseña: string): string {
        this.autenticarUsuario_conContraseña(unUsuario, unaContraseña);

        const iD = this.nuevoId();
        this.sesiones.at_put(iD, Sesion.newCon_conTiempoDeSesion(new Carrito(), this.medidaDeTiempoDeSesion));

        return iD
    }

    public listarCarrito(iDDelCarritoAListar: string): Bag<string> {
        const carrito = this.buscarCarrito(iDDelCarritoAListar);

        return carrito.listar();
    }

    public tieneCompraResgistradaCon(iDDeTransaccion: string): boolean {
        return this.libroDeVentas.includesKey(iDDeTransaccion);
    }

    private agregarReciboAlLibroDeVentas(unReciboDeCompra: Recibo): string {
        const iD = this.nuevoId();
        this.libroDeVentas.at_put(iD, unReciboDeCompra);
        return iD;
    }

    private autenticarUsuario_conContraseña(unUsuarioAAutenticar: string, unaContraseñaAAutenticar: string): void {
        try {
            this.sistemaDeAutenticacion(unUsuarioAAutenticar, unaContraseñaAAutenticar);
        } catch(_error) {
            throw new Error(InterfazInterna.errorCredencialesInvalidas());
        }
    }

    private buscarCarrito(iDDelCarritoABuscar: string): Carrito {
        const sesion = this.sesiones.at_ifAbsent(
            iDDelCarritoABuscar,
            () => { throw new Error(InterfazInterna.errorElCarritoNoFueCreado()); }
        );

        try {
            return sesion.acceder();
        } catch(error) {
            if (error instanceof Error) {
                this.sesiones.removeKey(iDDelCarritoABuscar);
                throw new Error(error.message);
            }
            throw new Error('should not happen');
        }
    }

    private nuevoId(): string {
        return uuidv4();
    }
}