def sum_between_max_min(arr):
    if len(arr) < 2:
        return 0
    
    idx_max = arr.index(max(arr))
    idx_min = arr.index(min(arr))
    
    left = min(idx_max, idx_min)
    right = max(idx_max, idx_min)
    
    total = 0
    for i in range(left + 1, right):
        if arr[i] < 0:
            total += arr[i]
    
    return total


def main():
    print("=" * 50)
    print("SUM OF NEGATIVE ELEMENTS BETWEEN MAX AND MIN")
    print("=" * 50)
    
    while True:
        try:
            n = int(input("\nEnter array size N: "))
            if n <= 0:
                print("Error: N must be a positive number!")
                continue
            break
        except ValueError:
            print("Error: please enter an integer!")
    
    print(f"\nEnter {n} integer elements separated by spaces:")
    while True:
        try:
            user_input = input(">>> ").split()
            if len(user_input) != n:
                print(f"Error: you must enter exactly {n} elements! Entered: {len(user_input)}")
                continue
            arr = [int(x) for x in user_input]
            break
        except ValueError:
            print("Error: all elements must be integers!")
    
    print(f"\nSource array A: {arr}")
    print(f"Maximum element: {max(arr)} (index {arr.index(max(arr))})")
    print(f"Minimum element: {min(arr)} (index {arr.index(min(arr))})")
    idx_max = arr.index(max(arr))
    idx_min = arr.index(min(arr))
    left = min(idx_max, idx_min)
    right = max(idx_max, idx_min)
    
    between = arr[left + 1:right]
    print(f"Elements between max and min: {between}")
    
    result = sum_between_max_min(arr)
    print(f"\nSum of negative elements = {result}")
    print("=" * 50)


if __name__ == "__main__":
    main()