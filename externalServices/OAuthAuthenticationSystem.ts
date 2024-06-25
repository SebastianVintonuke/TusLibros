export class OAuthAuthenticationSystem {
    public autenticate_withPassword(aClientId: string, aPassword: string): void {
        // Acá implementaríamos la comunicación con el sistema externo - Luciano.
        if (!(aClientId === 'yenny' && aPassword === 'elAteneo2003')) {
            throw new Error('Invalid credentials');
        }
    }
}