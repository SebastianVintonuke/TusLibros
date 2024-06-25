export class Dictionary<K,T> {
    static keyNotFoundErrorDescriptionFor(key: string): string {
        return `key: ${key} not found`
    }

    private set: Map<K, T>;

    constructor() {
        this.set = new Map<K, T>();
    }

    public at_put(key: K, anObject: T): T {
        this.set.set(key, anObject);
        return anObject;
    }

    public includesKey(key: K): boolean {
        return this.set.has(key);
    }

    public at(key: K): T {
        if (!this.includesKey((key))) {
            throw new Error(Dictionary.keyNotFoundErrorDescriptionFor(key as string));
        }
        return this.set.get(key) as T;
    }

    public removeKey(key: K): T {
        const anObject = this.at(key);
        this.set.delete(key);
        return anObject;
    }

    public at_ifAbsent(key: K, aBlock: Function): T {
        if (!this.includesKey((key))) {
            aBlock();
        }
        return this.set.get(key) as T;
    }
}