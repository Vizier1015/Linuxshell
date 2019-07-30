import pymysql
import xlwt
import os


host = '115.*.*.*'
user = 'root'
passwd = ''
db = 'prc_py'
sheet_name = 'dqc'
path = os.path.join(os.getcwd(),'1.xls')                        #'/Users/vizier-sin/PycharmProjects/2.xls'
port = 3306
sql = """select * from jobs"""

conn = pymysql.connect(host,user,passwd,db,port)
cursor = conn.cursor()

sql_exec = cursor.execute(sql)

print(sql_exec)

cursor.scroll(0,mode='absolute')

results = cursor.fetchall()

fields = cursor.description
workbook = xlwt.Workbook()
sheet = workbook.add_sheet(sheet_name, cell_overwrite_ok=True)

for field in range(0,len(fields)):
    sheet.write(0,field,fields[field][0])

row = 1
col = 0

for row in range(1,len(results)+1):
    for col in range(0, len(fields)):
        sheet.write(row, col, u'%s' % results[row - 1][col])
workbook.save(path)








