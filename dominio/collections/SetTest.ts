import { TestCase } from "../../testing/TestCase";
import { Set } from "./Set";

export class SetTest extends TestCase {
    public test01unSetSabeSiNoIncluyeUnObjeto(): void {
        const unSet = new Set<string>();

        this.deny(unSet.includes(''));
    }
    
    public test02unSetSabeSiIncluyeUnObjeto(): void {
        const unSet = new Set<string>();

        unSet.add('');

        this.assert(unSet.includes(''));
    }

    public test05unSetSabeIterarParaTodosSusObjetos(): void {
        const unSet = new Set<string>();
        let contador = 0;

        unSet.add('A');
        unSet.add('B');

        unSet.do((_anObject) => {
            contador += 1;
        })

        this.assertEquals(contador, 2);
    }
}