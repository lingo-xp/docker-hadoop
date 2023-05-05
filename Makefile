DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch = "2.0.4-hadoop3.3.5-java8"
build:
	docker build -t lingoxp/hadoop-base:$(current_branch) ./base
	docker build -t lingoxp/hadoop-namenode:$(current_branch) ./namenode
	docker build -t lingoxp/hadoop-datanode:$(current_branch) ./datanode
	docker build -t lingoxp/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t lingoxp/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t lingoxp/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t lingoxp/hadoop-submit:$(current_branch) ./submit

push:
	docker push lingoxp/hadoop-base:$(current_branch)
	docker push lingoxp/hadoop-namenode:$(current_branch)
	docker push lingoxp/hadoop-datanode:$(current_branch)
	docker push lingoxp/hadoop-resourcemanager:$(current_branch)
	docker push lingoxp/hadoop-nodemanager:$(current_branch)
	docker push lingoxp/hadoop-historyserver:$(current_branch)
	docker push lingoxp/hadoop-submit:$(current_branch)
wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(current_branch) hdfs dfs -rm -r /input
