#!/usr/local/Cellar/bash/4.3.30/bin/bash
#git update code and develop code to target server
#authr by zhishuo 
#date 2014-09-27

git_path='/Users/klaus/work/puhui_release/puhui'
#git_path='/Users/klaus/work/puhui/'
git_branch='develop'
#git_path_temp="/Users/klaus/work/beacon/ydc"
#trash="/dev/null 2>&1 "
trash="/tmp/tmp.log"
mvn_path="/usr/local/bin/mvn"
mvn_command="mvn clean package"
package_path="/target/"
left_package="/puhui-"
pwd_path="/Users/klaus/learn/company_script/"
server_path_left="/opt/tomcat-"
server_path_right="/webapps/"
git_fetch='git fetch'
declare -A map=(["risk"]="8081" ["lend"]="8080" ["report"]="8085" ["repay"]="8086" ["uc"]="8082" ["schedule"]="8088" ["settlement"]="8083")
cd $git_path
echo "是否切换分支 y/n"
read isChange
if [ $isChange = "y" ];then
    echo "请输入分支名称"
    read git_branch
    echo "更新代码分支${git_branch}"
    $git_fetch && git checkout $git_branch > $trash && git pull > $trash
fi
#如果为0证明执行成功
if [ $? == 0 ]; then
    echo "是否需要打包 y/n:"
    read isPackage
    if [ "y" = $isPackage ];then
	    echo "开始打包"
	    $mvn_command
		echo "打包成功"
    fi
	#打包成成功，继续执行上传代码操作
    if [ $? == 0 ]; then
			echo "请输入项目名称 如:risk"
			read product
			source_path="${git_path}${left_package}${product}${package_path}"
			echo "项目包目录:$source_path"
			#上传代码到服务器，停止服务器tomcat 部署新代码
            cd $pwd_path
            root_path=$server_path_left$product"-"${map[$product]}$server_path_right
            ./kill_tomcat.exp $product $root_path
            # 上传代码 启动服务
            ./upload.exp $product $source_path ${map[$product]}
            # 解压文件
            ./ssh.exp "sh /opt/tomcat-${product}-${map[$product]}/bin/startup.sh"
	else
    	echo "打包失败\r"
	fi
else
	echo "更新代码失败\r"
fi

