import random

def v_code():
	code = ''
	for i in range(5):
		add = random.choice([random.randrange(10),chr(random.randrange(65,91))]) 		code += str(add)
	print(code)

v_code()
