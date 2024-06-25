import { TestCaseTest } from "./TestCaseTest";
import { SetTest } from "../dominio/collections/SetTest";
import { BagTest } from "../dominio/collections/BagTest";
import { DictionaryTest } from "../dominio/collections/DictionaryTest";
import { CarritoTest } from "../dominio/CarritoTest";
import { ReciboTest } from "../dominio/ReciboTest";
import { TarjetaDeCreditoTest } from "../dominio/TarjetaDeCreditoTests";
import { CajeroTest } from "../dominio/CajeroTest";
import { SesionTest } from "../interfaces/SesionTest";
import { InterfazInternaTest } from "../interfaces/InterfazInternaTest";
import { InterfazExternaTest } from "../interfaces/InterfazExternaTest";

[
    new TestCaseTest,
    new SetTest,
    new BagTest,
    new DictionaryTest,
    new CarritoTest,
    new ReciboTest,
    new TarjetaDeCreditoTest,
    new CajeroTest,
    new SesionTest,
    new InterfazInternaTest,
    new InterfazExternaTest,
].forEach(testSuite => testSuite.runTests());