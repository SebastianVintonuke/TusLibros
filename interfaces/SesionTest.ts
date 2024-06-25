import { TestCase } from '../testing/TestCase';
import { Sesion } from './Sesion';
import { Duration } from 'luxon';

export class SesionTest extends TestCase {

    private treintaMinutos(): Duration {
        return Duration.fromObject({ minutes: 30 });
    }

    private treintayunMinutos(): Duration {
        return Duration.fromObject({ minutes: 31 });
    }

    private veintinueveMinutos(): Duration {
        return Duration.fromObject({ minutes: 29 });
    }

    public test01unaSesionNoExpiranSiNoPasoSuTiempoDeExpiracion(): void {
        const unaSesion = Sesion.newCon_conTiempoDeSesion('', this.treintaMinutos());

        this.deny(unaSesion.estaExpirada());
    }

    public test02unaSesionExpiranPasadoSuTiempoDeExpiracion(): void {
        const unaSesion = Sesion.newCon_conTiempoDeSesion('', this.treintaMinutos());

        unaSesion.pasarTiempo(this.treintayunMinutos());

        this.assert(unaSesion.estaExpirada());
    }

    public test03unaSesionSeRenuevaSiSeAccedeAntesDeQuePaseSuTiempoDeExpiracion(): void {
        const unaSesion = Sesion.newCon_conTiempoDeSesion('', this.treintaMinutos());

        unaSesion.pasarTiempo(this.veintinueveMinutos());
        unaSesion.acceder();
        unaSesion.pasarTiempo(this.veintinueveMinutos());

        this.deny(unaSesion.estaExpirada());
    }

    public test04unaSesionLanzaUnErrorSiSeIntentaAccederPasadoSuTiempoDeExpiracion(): void {
        const unaSesion = Sesion.newCon_conTiempoDeSesion('', this.treintaMinutos());

        unaSesion.pasarTiempo(this.treintayunMinutos());

        this.shouldRaise(
            () => {
                unaSesion.acceder();
            },
            Sesion.errorSesionExpirada()
        );
    }

    public test05unaSesionPuedeAccederASuContenidoSiNoPasoSuTiempoDeExpiracion(): void {
        const unContenido = 1;
        const unaSesion = Sesion.newCon_conTiempoDeSesion(unContenido, this.treintaMinutos());

        this.assertEquals(unaSesion.acceder(), unContenido);
    }
}