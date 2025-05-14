"""
Autor : Lust
Program : Comparison between two bruters
Language : Python, Bash
"""
#!/bin/bash

# 1. Configuration
PASSWORD="A1b!f"
HASH=$(echo -n "$PASSWORD" | md5sum | awk '{print $1}')
HASH_FILE="hash_test.txt"
PYTHON_SCRIPT="brute_test.py"

# 2. Crée le fichier hash
echo "longpass:$HASH" > "$HASH_FILE"

# 3. Script Python de brute force
cat <<EOF > $PYTHON_SCRIPT
import string, math, time
from concurrent.futures import ThreadPoolExecutor, as_completed

def complexity(code):
    length = len(code)
    type_de_domaine_recherche = 0
    categories = {
        "digits": (string.digits, 10),
        "uppercase": (string.ascii_uppercase, 26),
        "lowercase": (string.ascii_lowercase, 26),
        "punctuation": (string.punctuation, 32)
    }
    used_categories = set()
    for char in code:
        for cat_name, (char_set, value) in categories.items():
            if char in char_set and cat_name not in used_categories:
                type_de_domaine_recherche += value
                used_categories.add(cat_name)
    entropy = length * math.log2(type_de_domaine_recherche)
    print(f"Complexité du code trouvé : {entropy:.2f} bits")

def get_relevant_characters(code):
    categories = {
        "digits": string.digits,
        "uppercase": string.ascii_uppercase,
        "lowercase": string.ascii_lowercase,
        "punctuation": string.punctuation
    }
    relevant_chars = set()
    for char in code:
        for char_set in categories.values():
            if char in char_set:
                relevant_chars.update(char_set)
                break
    return ''.join(sorted(relevant_chars))

def chunked_product(characters, length, chunk_size):
    total = len(characters) ** length
    for start in range(0, total, chunk_size):
        end = min(start + chunk_size, total)
        chunk = []
        for index in range(start, end):
            temp = index
            guess = []
            for _ in range(length):
                guess.append(characters[temp % len(characters)])
                temp //= len(characters)
            chunk.append(''.join(reversed(guess)))
        yield chunk

def worker(chunk, target_code):
    for guess_str in chunk:
        if guess_str == target_code:
            return guess_str
    return None

def brute_force_parallel(target_code, max_workers=4, chunk_size=10000):
    characters = get_relevant_characters(target_code)
    attempts = 0
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        for length in range(1, len(target_code) + 1):
            futures = []
            for chunk in chunked_product(characters, length, chunk_size):
                futures.append(executor.submit(worker, chunk, target_code))
            for future in as_completed(futures):
                result = future.result()
                attempts += chunk_size
                if result is not None:
                    print(f"Code found: {result}")
                    complexity(target_code)
                    return attempts
    print("Code not found.")
    return attempts

if __name__ == "__main__":
    target_code = "$PASSWORD"
    start_time = time.time()
    attempts = brute_force_parallel(target_code)
    duration = time.time() - start_time
    print(f"Total attempts: {attempts}")
    print(f"Time taken: {duration:.2f} seconds")
    print(f"Attempts per second: {attempts / duration:.2f}")
EOF

# 4. Lance le test Python
echo -e "\n--- Python Brute Force ---"
python3 "$PYTHON_SCRIPT"

# 5. Lance le test John the Ripper
echo -e "\n--- John the Ripper Brute Force ---"
echo "Démarrage de John the Ripper..."
START=$(date +%s)
john --format=raw-md5 --incremental "$HASH_FILE"
END=$(date +%s)
echo "Durée : $((END - START)) secondes"
john --show --format=raw-md5 "$HASH_FILE"