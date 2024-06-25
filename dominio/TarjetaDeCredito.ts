import { DateTime } from "luxon";

export class TarjetaDeCredito {
    static newConNumeroDeTarjeta_conMesDeAñoDeExpiracion_conTitular(unNumeroDeTarjeta: string, unMesDeAñoDeExpiracion: DateTime, unNombreDelTitular: string): TarjetaDeCredito {
        return new TarjetaDeCredito().conNumero_conMesDeAñoDeExpiracion_conTitular(unNumeroDeTarjeta, unMesDeAñoDeExpiracion, unNombreDelTitular);
    }

    private numeroDeTarjeta!: string;
    private mesDeAñoDeExpiracion!: DateTime;
    private titular!: string;

    public conNumero_conMesDeAñoDeExpiracion_conTitular(unNumeroDeTarjeta: string, unMesDeAñoDeExpiracion: DateTime, unNombreDelTitular: string): TarjetaDeCredito {
        this.numeroDeTarjeta = unNumeroDeTarjeta;
        this.mesDeAñoDeExpiracion = unMesDeAñoDeExpiracion;
        this.titular = unNombreDelTitular;
        return this;
    }

    public estaVencida(): boolean {
        return this.elAñoEstaVencido() || this.elMesEstaVencido() 
    }

    public number(): string {
        return this.numeroDeTarjeta
    }

    private elAñoEstaVencido(): boolean {
        return this.mesDeAñoDeExpiracion.year < DateTime.now().year
    }

    private elMesEstaVencido(): boolean {
        return this.mesDeAñoDeExpiracion.year === DateTime.now().year && this.mesDeAñoDeExpiracion.month < DateTime.now().month
    }
}