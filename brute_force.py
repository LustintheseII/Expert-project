"""
Author : Lustintheshell
Program : brute force
"""

import itertools
import string
import math

def complexity(code):
    """calcule l'entropie d'un code donné."""
    lenght = len(code)
    type_de_domaine_recherche = 0
    categories = {
        "digits": (string.ascii_digits, 10),
        "uppercase": (string.ascii_uppercase, 26),
        "lowercase": (string.ascii_lowercase, 26),
        "punctuation": (string.ascii_punctuation, 32)
    }

    used_categories = set()

    for char in code:
        for  cat_name, (char_set, value) in categories.items():
            if char in char_set and cat_name not in used_categories:
                type_de_domaine_recherche += value
                used_categories.add(cat_name)
    
    if type_de_domaine_recherche == 0:
        print("Code invalide : aucun caractère reconnu.")
        return
    
    entropy = lenght * math.log2(type_de_domaine_recherche)
    print(f"Complexité du code trouvé : {entropy:.2f} bits")

def brute_force(target_code):
    """essaie de trouver le code en testant toutes les combinaisons possibles"""
    characters = string.ascii_lowercase + string.digits + string.punctuation + string.ascii_uppercase
    attempts = 0

    for length in range(1, len(target_code) + 1):
        for guess in itertools.product(characters, repeat=length):
            attempts += 1
            guess_str = ''.join(guess)
            print(f"Attempt {attempts}: {guess_str}")
            if guess_str == target_code:
                print(f"Code found: {guess_str}")
                return attempts

    print("Code not found. ")
    return attempts

if __name__ == "__main__":
    target_code = input("Enter the code to brute force : ")
    attempts = brute_force(target_code)
    print(f"Total attempts : {attempts}")