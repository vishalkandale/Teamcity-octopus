def lambda_handler(event, context):
    operations = {
        "+": lambda x, y: x + y,
        "-": lambda x, y: x - y,
        "*": lambda x, y: x * y,
        "/": lambda x, y: x / y,
    }
    try:
        num1 = float(event['key1'])
        num2 = float(event['key2'])
        operation = event['key3']
        if operation not in operations:
            return {
                'message': "Invalid operation: " + operation
            }
        result = operations[operation](num1, num2)
        message = "Result: {}".format(result)
    except ValueError:
        message = "Invalid input. Please provide valid numbers."
    return {
        'message': message
    }