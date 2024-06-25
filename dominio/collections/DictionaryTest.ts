import { TestCase } from "../../testing/TestCase";
import { Dictionary } from "./Dictionary";

export class DictionaryTest extends TestCase {
    public test01unDictionarySabeSiNoIncluyeUnaClave(): void {
        const unDictionary = new Dictionary;

        this.deny(unDictionary.includesKey(''));
    }

    public test02unDictionarySabeSiIncluyeUnaClave(): void {
        const unDictionary = new Dictionary;

        unDictionary.at_put('a', 1);

        this.assert(unDictionary.includesKey('a'));
    }

    public test03unDictionarySabeElValorAsociadoAUnaClave(): void {
        const unDictionary = new Dictionary;

        unDictionary.at_put('a', 1);

        this.assertEquals(unDictionary.at('a'), 1);
    }

    public test04unDictionaryLanzaUnErrorSiNoTieneUnValorAsociadoAUnaClave(): void {
        const unDictionary = new Dictionary;

        this.shouldRaise(() => { unDictionary.at('a'); }, 'key: a not found');
    }

    public test05unDictionarySabeRemoverUnaClave(): void {
        const unDictionary = new Dictionary;

        unDictionary.at_put('a', 1);
        this.assert(unDictionary.includesKey('a'));

        this.assertEquals(unDictionary.removeKey('a'), 1);
        this.deny(unDictionary.includesKey('a'));
    }

    public test06unDictionaryPuedeEjecutarUnComportamientoSiNoTieneLaClaveBuscada(): void {
        const unDictionary = new Dictionary;
        let closureExecuted = false;

        unDictionary.at_ifAbsent('a', () => {
            closureExecuted = true;
        });
        this.assert(closureExecuted);
    }

    public test07unDictionaryNoEjecutaUnComportamientoSiTieneLaClaveBuscada(): void {
        const unDictionary = new Dictionary;
        let closureExecuted = false;

        unDictionary.at_put('a', 1);
        unDictionary.at_ifAbsent('a', () => {
            closureExecuted = true;
        })
        this.deny(closureExecuted);
    }
}