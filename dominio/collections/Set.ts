export class Set<T> {
    private set: Map<T, null>;

    constructor() {
        this.set = new Map<T, null>();
    }

    public add(newObject: T): void {
        this.set.set(newObject, null);
    }

    public includes(anObject : T): boolean {
        return this.set.has(anObject );
    }

    public do(aBlock: (anObject: T) => void): void {
        this.set.forEach((_, key) => {
            aBlock(key);
        });
    }
}