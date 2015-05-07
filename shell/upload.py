#coding:utf-8

import paramiko
from time import sleep

print '-------------------------------------------------------------'
# 设置 host,username,password
while(True):
	environment = raw_input('please entry environment. (eg: "98 or 99"):')
	if environment != '' and environment != 'exit':
		break
	else:
		exit()

if environment == '98':
	host = '192.168.0.98'
	password = 'FK~yGKk40'
elif environment == '99':
	host = '192.168.0.99'
	password = 'AnrdeqtoC'
elif environment == '96':
	host = '192.168.0.96'
	password == 'AnHvNDD9D'
elif environment == '46':
	host = '192.168.0.46'
	password = 'JGV1*Tld4'

#默认用户名root
username = 'root'
# 默认端口号22
port =22

project  = raw_input('please entry project (eg uc or wealth or lend):')
if project =='exit':
	exit()
tomcat_port = raw_input('please entry remote tomcate port:')
if tomcat_port == 'exit':
	exit()
#设置tomcat 路径
tomcat_path =  '/opt/tomcat-'+project+'-'+tomcat_port+'/'
print 'tomcat_path:'+tomcat_path
#本地war包的路径
while(True):
	local_war_path = raw_input('please entry local war path:')
	if local_war_path != '' and local_war_path != 'exit':
		break
	else:
		exit()
local_war_path = local_war_path.replace('\\','/')
print 'local_war_path:'+local_war_path

#创建paramiko ssh 登录系统
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(host, port, username, password)
#关闭tomcat
shutdown_sh = 'sh '+tomcat_path+'/bin/shuntdown.sh'
print 'execute shell ----------->'+shutdown_sh
stdin, stdout, stderr = client.exec_command(shutdown_sh)
# 将 tomcat 进程停止
sleep(10)
print stdout.readlines()
print 'has ben shutdown'
#将tomcat 下的 webapp 下的原文件删除
rm_sh = 'rm -rf '+tomcat_path+'/webapps/*'
print 'execute shell ---------->'+rm_sh
stdin, stdout, stderr = client.exec_command(rm_sh)
print stdout.readlines()
#将本地war包上传至 远程服务器
t = paramiko.Transport((host,port))
t.connect(username=username,password=password)
sftp = paramiko.SFTPClient.from_transport(t)
remotePath = tomcat_path+'/webapps/puhui-'+project+'.war'
localPath = local_war_path+'/puhui-'+project+'-20140109.war'
s = sftp.put(localPath, remotePath)
print s;
#启动tomcat
startup_sh = 'sh '+tomcat_path+'/bin/startup.sh'
print 'execute shell ------------->'+startup_sh
stdin, stdout, stderr = client.exec_command(startup_sh)
print stdout.readlines()
print 'has been startup'
print '-------------------------------------------------------------'
