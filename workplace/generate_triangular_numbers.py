# Python script to generate the first 10 triangular numbers

def generate_triangular_numbers(n):
    triangular_numbers = []
    for i in range(1, n + 1):
        triangular_number = (i * (i + 1)) // 2
        triangular_numbers.append(triangular_number)
    return triangular_numbers

# Generate and print the first 10 triangular numbers
if __name__ == "": 
    first_10_triangular_numbers = generate_triangular_numbers(10)
    print("First 10 triangular numbers:")
    for number in first_10_triangular_numbers:
        print(number)