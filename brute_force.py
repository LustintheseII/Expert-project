"""
Author : Lustintheshell
Program : brute force
"""

import itertools
import string

def brute_force(target_code):
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