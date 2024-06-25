import express, { Express, Request, Response } from 'express';
import { Server } from 'http';
import { Dictionary } from './dominio/collections/Dictionary';
import { InterfazExterna } from './interfaces/InterfazExterna';
import { InterfazInterna } from './interfaces/InterfazInterna';
import { OAuthAuthenticationSystem } from './externalServices/OAuthAuthenticationSystem';
import { MerchantProcessor } from './dominio/Cajero';
import { MercadoPago } from './externalServices/MercadoPago';
import { TarjetaDeCredito } from './dominio/TarjetaDeCredito';
import { Duration } from 'luxon';

export class ServidorWeb {
    static escucharEnPuerto9000(): ServidorWeb {
        return new ServidorWeb().escucharEnPuerto(9000);
    }

    static escucharEnPuerto(unPuerto: number): ServidorWeb {
        return new ServidorWeb().escucharEnPuerto(unPuerto);
    }

    private interfazExterna: InterfazExterna;
    private servidor: Express;
    private serverInstance?: Server;

    private catalogo(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();
        catalogo.at_put('9780137314942', 31505);
        catalogo.at_put('9780321278654', 45305);
        catalogo.at_put('9780201710915', 45180);
        catalogo.at_put('9780321125217', 41000);
        catalogo.at_put('9780735619654', 34900);
        catalogo.at_put('9780321146533', 29100);
        return catalogo
    }

    private escucharEnPuerto(unPuerto: number): ServidorWeb {
        this.serverInstance = this.servidor.listen(unPuerto, () => { console.log(`Servidor escuchando en puerto: ${unPuerto}`); });
        return this
    }

    constructor() {
        const interfazInterna = InterfazInterna.newConCatalogo_sistemaDeAutenticacion_merchantProcessor_yTiempoDeSesion(
            this.catalogo(),
            this.sistemaDeAutenticacion(),
            this.merchantProcessor(),
            this.tiempoDeSesion()
        )

        this.interfazExterna = InterfazExterna.newCon(interfazInterna);

        this.servidor = express();

        this.addServiceCreateCart();
        this.addServiceAddToCart();
        this.addServiceListCart();
        this.addServiceCheckOutCart();
    }

    private merchantProcessor(): MerchantProcessor {
        return (anAmountToDebit: number, aCreditCard: TarjetaDeCredito) => {
            new MercadoPago().debit_from(anAmountToDebit, aCreditCard)
        }
    }

    private sistemaDeAutenticacion(): (usuario: string, contraseña: string) => void {
        return (usuario, contraseña) => {
            new OAuthAuthenticationSystem().autenticate_withPassword(usuario, contraseña)
        }
    }

    private tiempoDeSesion(): Duration {
        return Duration.fromObject({ minutes: 30 });
    }

    public destruir(): void {
        if (this.serverInstance) {
            this.serverInstance.close(err => {
                if (err) {
                    console.error('Error:', err);
                } else {
                    console.log('Servidor detenido');
                }
            });
        }
    }

    private addServiceAddToCart(): void {
        this.agregarServicio_conBloque('/addToCart', (request) => {
            return this.interfazExterna.agregarAlCarrito(request)
        });
    }

    private addServiceCheckOutCart(): void {
        this.agregarServicio_conBloque('/checkOutCart', (request) => {
            return this.interfazExterna.checkOut(request)
        });
    }

    private addServiceCreateCart(): void {
        this.agregarServicio_conBloque('/createCart', (request) => {
            return this.interfazExterna.crearCarrito(request)
        });
    }

    private addServiceListCart(): void {
        this.agregarServicio_conBloque('/listCart', (request) => {
            return this.interfazExterna.listarCarrito(request)
        });
    }

    private agregarServicio_conBloque(unaRuta: string, unBloque: (request: Dictionary<string, string>) => Dictionary<string, string>): void {
        this.servidor.get(unaRuta, (request: Request, response: Response) => {

            const req = new Dictionary<string, string>();
            for (const key in request.query) {
                req.at_put(key, request.query[key] as string)
            }

            const respuesta = unBloque(req);
            const status = respuesta.at('status');
            const body = respuesta.at('body');
            response.status(Number(status)).type('text/plain; charset=utf-8').send(body);
        });
    }

}