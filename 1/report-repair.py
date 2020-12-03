import sys
nums = [int(n) for n in sys.stdin]
for a in nums:
	for b in nums:
		for c in nums:
			if a+b+c == 2020:
				print(a*b*c)
				exit()
print("No valid answer")
