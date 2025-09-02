class FibonacciGenerator:
    @staticmethod
    def generate_fibonacci(limit):
        fibonacci_sequence = []
        a, b = 0, 1
        while a <= limit:
            fibonacci_sequence.append(a)
            a, b = b, a + b
        return fibonacci_sequence
