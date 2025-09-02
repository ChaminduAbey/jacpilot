# Main script to call Fibonacci, Prime and Triangular methods
from generate_fibonacci import FibonacciGenerator
from generate_prime_numbers import generate_prime_numbers

def main():
    fibonacci_sequence = FibonacciGenerator.generate_fibonacci(30)
    print(fibonacci_sequence)
