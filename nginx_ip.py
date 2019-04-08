#!/usr/bin/python

import matplotlib.pyplot as plt
nginx_file = '/data/applogs/nginx/access.log'

ip = {}

with open(nginx_file) as f:
	for i in f.readlines():
		s = i.strip().split()[0]
		length = len(ip.keys())

		if s in ip.keys():
		 	ip[s] = ip[s] + 1
		else:
			 ip[s] = 1

ip = sorted(ip.items(), key=lambda e:e[1], reverse=True)

newip = ip[0:10:1]
tu = dict(newip)

x = []
y = []
for k in tu:
	x.append(k)
	y.append(tu[k])

plt.title('ip access')
plt.xlabel('ip address')
plt.ylabel('PV')

plt.xticks(rotation=70)
for a,b in zip(x,y):
	plt.text(a, b, '%.0f' % b, ha='center', va= 'bottom',fontsize=7)

plt.bar(x,y)
plt.legend()
plt.show()
				 
