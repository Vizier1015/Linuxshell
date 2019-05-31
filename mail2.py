import smtplib
from email.mime.text import MIMEText
import sys

mail_host = 'smtp.163.com'
mail_user = '15618040081@163.com'
mail_passwd = 'bgwsin0715'
mail_postfix = '163.com'


def sendmail(to_list, subject, content):
    msg = MIMEText(content, 'plain', 'utf-8')
	me = "zabbix"+"<"+mail_user+"@"+mail_postfix+">"
	msg['Subject'] = subject
	msg['Form'] = me
	msg['To'] = to_list
	try:
		s = smtplib.SMTP()
		s.connect(mail_host)
		s.login(mail_user, mail_passwd)
		s.sendmail(me, to_list, msg.as_string())
		s.close()
		return True
	except Exception as e:
		print(str(e))
		return False

if __name__ == "__main__":
	sendmail(sys.argv[1],sys.argv[2],sys.argv[3])
