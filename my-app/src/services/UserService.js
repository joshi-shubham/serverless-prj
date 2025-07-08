
export async function getAllUsers() {

    try{
        const response = await fetch('https://bookish-potato-4g4j4w9pww535xxx-8080.app.github.dev/api/users');
        return await response.json();
    }catch(error) {
        return [];
    }
    
}

export async function createUser(data) {
    const response = await fetch(`https://bookish-potato-4g4j4w9pww535xxx-8080.app.github.dev/api/user`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({user: data})
      })
    return await response.json();
}