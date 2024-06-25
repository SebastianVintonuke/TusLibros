import { TestCase } from "./TestCase";

export class TestCaseTest extends TestCase {
    public test01AssertIsSuccessfulForTrue(): void {
        const aTest = new TestCase();
        aTest.assert(true);
    }

    public test02AssertRaiseAnErrorForFalse(): void {
        const aTest = new TestCase();
        this.shouldRaise(()=>{aTest.assert(false)}, 'Assertion failed');
    }

    public test03DenyIsSuccessfulForFalse(): void {
        const aTest = new TestCase();
        aTest.deny(false);
    }

    public test04DenyRaiseAnErrorForTrue(): void {
        const aTest = new TestCase();
        this.shouldRaise(()=>{aTest.deny(true)}, 'Assertion failed');
    }

    public test05AssertEqualsIsSuccessfulFor1And1(): void {
        const aTest = new TestCase();
        aTest.assertEquals(1, 1);
    }

    public test06AssertEqualsRaiseAnErrorFor1And0(): void {
        const aTest = new TestCase();
        this.shouldRaise(()=>{ aTest.assertEquals(1, 0) }, 'Expected "0" but was "1"');
    }

    public test07ShouldRaiseCatchsAnErrorAndTheMessageMatches(): void {
        this.shouldRaise(()=>{ throw new Error('Error expected') }, 'Error expected');
    }

    public test08ShouldRaiseCatchsAnErrorAndTheMessageNotMatches(): void {
        this.shouldRaise(()=>{
            this.shouldRaise(()=>{ throw new Error('Error not expected') }, 'Error expected')
        }, `Expected error "Error expected" but was "Error not expected"`);
    }

    public test09ShouldRaiseDontCatchsAnError(): void {
        this.shouldRaise(()=>{
            this.shouldRaise(()=>{}, 'Error')
        }, 'Assertion failed');
    }
}