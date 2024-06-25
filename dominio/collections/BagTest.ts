import { TestCase } from "../../testing/TestCase";
import { Bag } from "./Bag";

export class BagTest extends TestCase {
    public test01unaBagEmpiezaVacia(): void {
        const unaBag = new Bag;

        this.assert(unaBag.isEmpty());
    }

    public test02unaBagPuedeAgregarUnItem(): void {
        const unaBag = new Bag;

        unaBag.add('');

        this.deny(unaBag.isEmpty());
    }

    public test03unaBagSabeCuantoAgregoDeUnItem(): void {
        const unaBag = new Bag;

        unaBag.add('');

        this.assertEquals(unaBag.occurrencesOf(''), 1);
    }

    public test04unaBagSabeSiIncluyeUnItem(): void {
        const unaBag = new Bag;

        unaBag.add('');

        this.assert(unaBag.includes(''));
    }

    public test05unaBagSabeIterarParaTodosSusItems(): void {
        const unaBag = new Bag;
        let contadorDeA = 0;
        let contadorDeB = 0;

        unaBag.add('A');
        unaBag.add('A');
        unaBag.add('B');

        unaBag.do((anObject) => {
            if (anObject === 'A') {
                contadorDeA += 1;
            } else if (anObject === 'B') {
                contadorDeB += 1;
            }
        })

        this.assertEquals(contadorDeA, 2);
        this.assertEquals(contadorDeB, 1);
    }

    public test05unaBagSabeSuSize(): void {
        const unaBag = new Bag;

        unaBag.add('A');
        unaBag.add('B');

        this.assertEquals(unaBag.size(), 2);
    }
}