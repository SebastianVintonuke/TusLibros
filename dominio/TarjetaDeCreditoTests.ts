import { TestCase } from "../testing/TestCase"
import { TarjetaDeCredito } from "./TarjetaDeCredito";
import { DateTime } from "luxon";

export class TarjetaDeCreditoTest extends TestCase {
    public test01unaTarjetaDeCreditoSabeResponderSiEstaVencida(): void {
        const unaFechaDeVencimiento = DateTime.fromObject({ month: 12, year: 2000 });

        const unaTarjeta = TarjetaDeCredito.newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular('1', unaFechaDeVencimiento, '');

        this.assert(unaTarjeta.estaVencida());
    }

    public test02unaTarjetaDeCreditoSabeResponderSiNoEstaVencida(): void {
        const unaFechaDeVencimiento = DateTime.now();

        const unaTarjeta = TarjetaDeCredito.newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular('1', unaFechaDeVencimiento, '');

        this.deny(unaTarjeta.estaVencida());
    }

    public test03unaTarjetaDeCreditoSabeResponderSuNumero(): void {
        const unaFechaDeVencimiento = DateTime.now();

        const unaTarjeta = TarjetaDeCredito.newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular('1', unaFechaDeVencimiento, '');

        this.assertEquals(unaTarjeta.number(), 1);
    }
}