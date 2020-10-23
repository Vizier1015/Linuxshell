# @Time : 2020/8/26 
# @Author : VizierBi
import logging

zabbix_agent_dir = ' /opt/zabbix-agent4.4.3/conf'


class Logger(object):
    def __init__(self):
        self.logger = logging.getLogger('vbidev')
        self.fh = logging.FileHandler('vbi.log')
        self.formatter = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
        self.logger.setLevel(logging.INFO)
        self.fh.setFormatter(self.formatter)
        self.logger.addHandler(self.fh)

    def Info(self, message):
        self.logger.info(message)
        return 1

    def Error(self, messages):
        self.logger.error(messages)
