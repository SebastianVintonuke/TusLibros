import { TarjetaDeCredito } from "../dominio/TarjetaDeCredito";

export class MercadoPago {
    public debit_from(_anAmountToDebit: number, aCreditCard: TarjetaDeCredito): void {
        // Acá implementaríamos la comunicación con la API de Mercado Pago - Luciano.
        if (aCreditCard.number() === '1111111111111117') {
            throw new Error('Stolen card!');
        }
    }
}