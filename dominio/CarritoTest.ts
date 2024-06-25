import { TestCase } from '../testing/TestCase';
import { Carrito } from './Carrito';
import { Dictionary } from './collections/Dictionary';

export class CarritoTest extends TestCase {
    private unCarrito!: Carrito;

    private catalogoConExtremeProgramming(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();
        catalogo.at_put(this.libroExtremeProgramming(), 1);
        return catalogo;
    }

    private catalogoConExtremeProgrammingYTestDriveDevelopment(): Dictionary<string, number> {
        const catalogo = this.catalogoConExtremeProgramming();
        catalogo.at_put(this.libroTestDriveDevelopment(), 1);
        return catalogo;
    }

    private catalogoVacio(): Dictionary<string, number> {
        const catalogo = new Dictionary<string, number>();
        return catalogo;
    }

    private libroExtremeProgramming(): string {
        return 'ExtremeProgramming'
    }

    private libroTestDriveDevelopment(): string {
        return 'TestDriveDevelopment'
    }

    protected setUp(): void {
        this.unCarrito = new Carrito();
    }

    public test01unCarritoEmpiezaVacio(): void {
        this.assert(this.unCarrito.estaVacio());
        this.deny(this.unCarrito.incluye(this.libroExtremeProgramming()));
    }

    public test02unCarritoPuedeAgregarUnLibro(): void {
        this.unCarrito.añadir_delCatalogo(this.libroExtremeProgramming(), this.catalogoConExtremeProgramming());

        this.deny(this.unCarrito.estaVacio());
        this.assert(this.unCarrito.incluye(this.libroExtremeProgramming()));
    }

    public test03unCarritoPuedeAgregarOtroLibro(): void {
        this.unCarrito.añadir_delCatalogo(this.libroExtremeProgramming(), this.catalogoConExtremeProgramming());
        this.unCarrito.añadir_delCatalogo(this.libroTestDriveDevelopment(), this.catalogoConExtremeProgrammingYTestDriveDevelopment());

        this.assert(this.unCarrito.incluye(this.libroExtremeProgramming()));
        this.assert(this.unCarrito.incluye(this.libroTestDriveDevelopment()));
    }

    public test04unCarritoNoPuedeNoAgregarLibrosDescatalogados(): void {
        this.shouldRaise(() => {
            this.unCarrito.añadir_delCatalogo(this.libroExtremeProgramming(), this.catalogoVacio());
        }, Carrito.errorNoSePuedeAñadirLibroDescatalogado());
    }

    public test05listarUnCarritoVacioDevuelveUnaColeccionVacia(): void {
        this.assert(this.unCarrito.listar().isEmpty());
    }

    public test06listarUnCarritoConUnLibroDevuelveUnaColleccionConElLibro(): void {
        this.unCarrito.añadir_delCatalogo(this.libroExtremeProgramming(), this.catalogoConExtremeProgramming());

        this.assert(this.unCarrito.listar().includes(this.libroExtremeProgramming()));
    }

    public test07unCarritoPuedeAgregarMultiplesCopiasDeUnMismoLibro(): void {
        this.unCarrito.añadir_cantidadDeCopias_delCatalogo(this.libroExtremeProgramming(), 2, this.catalogoConExtremeProgramming());

        this.assertEquals(this.unCarrito.listar().occurrencesOf(this.libroExtremeProgramming()), 2);
    }

    public test08unCarritoNoPuedeAgregarCeroCopiasDeUnMismoLibro(): void {
        this.shouldRaise(() => {
            this.unCarrito.añadir_cantidadDeCopias_delCatalogo(this.libroExtremeProgramming(), 0, this.catalogoConExtremeProgramming());
        }, Carrito.errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro());
    }

    public test09unCarritoNoPuedeAgregarCopiasNegativasDeUnMismoLibro(): void {
        this.shouldRaise(() => {
            this.unCarrito.añadir_cantidadDeCopias_delCatalogo(this.libroExtremeProgramming(), -1, this.catalogoConExtremeProgramming());
        }, Carrito.errorNoSePuedeAgregarMenosDeUnaCopiaDeUnLibro());
    }

    public test10unCarritoSePuedeVaciar(): void {
        this.unCarrito.añadir_delCatalogo(this.libroExtremeProgramming(), this.catalogoConExtremeProgramming());

        this.deny(this.unCarrito.estaVacio());

        this.unCarrito.vaciar();

        this.assert(this.unCarrito.estaVacio());
    }
}