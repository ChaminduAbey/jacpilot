# Python script to generate prime numbers

def is_prime(num):
    if num < 2:
        return False
    for i in range(2, int(num ** 0.5) + 1):
        if num % i == 0:
            return False
    return True

def generate_prime_numbers(n):
    prime_numbers = []
    num = 2
    while len(prime_numbers) < n:
        if is_prime(num):
            prime_numbers.append(num)
        num += 1
    return prime_numbers

# Generate and print the first 10 prime numbers
if __name__ == "": 
    first_10_primes = generate_prime_numbers(10)
    print("First 10 prime numbers:")
    for number in first_10_primes:
        print(number)