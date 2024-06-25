import { DateTime, Duration } from "luxon";

export class Sesion<T> {
    static errorSesionExpirada(): string {
        return 'Sesion expirada.';
    }

    static newCon_conTiempoDeSesion<T>(unObjeto: T, unaMedidaDeTiempoDeSesion: Duration): Sesion<T> {
        return new Sesion<T>().con_conTiempoDeSesion(unObjeto, unaMedidaDeTiempoDeSesion);
    }

    private valor!: T;
    private medidaDeTiempoDeSesion!: Duration;
    private finDeSesion!: DateTime;

    private con_conTiempoDeSesion(unObjeto: T, unaMedidaDeTiempoDeSesion: Duration): Sesion<T> {
        this.valor = unObjeto;
        this.medidaDeTiempoDeSesion = unaMedidaDeTiempoDeSesion
        this.renovarTiempoDeSesion();

        return this;
    }

    public acceder(): T {
        if (this.estaExpirada()) { throw new Error(Sesion.errorSesionExpirada()) }

        this.renovarTiempoDeSesion();

        return this.valor;
    }

    public estaExpirada(): boolean {
        return DateTime.now() > this.finDeSesion;
    }

    public pasarTiempo(unTiempoDeSesionAIncrementar: Duration): void {
        this.finDeSesion = this.finDeSesion.minus(unTiempoDeSesionAIncrementar);
    }

    private renovarTiempoDeSesion(): void {
        this.finDeSesion = DateTime.now().plus(this.medidaDeTiempoDeSesion);
    }
}