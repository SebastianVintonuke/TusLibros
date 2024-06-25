import { Set } from "./Set";

export class Bag<T> {
    private contents: Map<T, number>;

    constructor() {
        this.contents = new Map<T, number>();
    }

    public add(newObject : T): void {
        if (this.contents.has(newObject )) {
            this.contents.set(newObject , this.contents.get(newObject )! + 1);
        } else {
            this.contents.set(newObject , 1);
        }
    }

    public isEmpty(): boolean {
        return this.contents.size === 0;
    }

    public includes(anObject: T): boolean {
        return this.contents.has(anObject);
    }

    public occurrencesOf(anObject: T): number {
        return this.contents.get(anObject) ?? 0;
    }

    public copy(): Bag<T> {
        const newBag = new Bag<T>();
        this.contents.forEach((count, anObject) => {
            for (let i = 0; i < count; i++) {
                newBag.add(anObject);
            }
        });
        return newBag;
    }

    public asSet(): Set<T> {
        const set = new Set<T>();
        this.contents.forEach((_count, anObject) => {
            set.add(anObject);
        });
        return set;
    }

    public do(aBlock: (anObject: T) => void): void {
        this.contents.forEach((count, anObject) => {
            for (let i = 0; i < count; i++) {
                aBlock(anObject);
            }
        });
    }

    public size(): number {
        return this.contents.size
    }
}