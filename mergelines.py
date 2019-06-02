path = 'r/Users/vizier-sin/Desktop/file.txt'

with open(path) as file:
	a = file.readlines()

b = ''
for i in a:
	b += i.strip() #删除空白符（首尾）
c = b.split() #分割函数好，将字符串分割成字符保存在列表中
d = ''.join(c) #方法用于将序列中的元素以指定的字符连接生成一个新的字符串。

print(b) #输出一行，每个字段有空格分隔#
print(d) #无空格输出一行


