#!/usr/bin/env bash
case $(id -u) in
    0)
        # install java 8
        apt update
        apt upgrade
        apt install -y openjdk-8-jdk xauth
        apt install -y junit4 maven git emacs unzip gradle
	apt upgrade

	( VERSION=0.17.0; \
        curl -sSL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
          | tar -C /opt -xJ && \
            ln -s "/opt/infer-linux64-v$VERSION/bin/infer" /usr/local/bin/infer
	)

        ;;
    *)
	mkdir benchmarks
	cd benchmarks
	
	wget https://github.com/jhy/jsoup/archive/jsoup-1.9.2.tar.gz
	tar xzvf jsoup-1.9.2.tar.gz
	( cd jsoup-jsoup-1.9.2; mvn clean; infer run -- mvn compile )
	( cd jsoup-jsoup-1.9.2; mvn test )
	
	wget https://github.com/jhy/jsoup/archive/jsoup-1.10.1.tar.gz
	tar xzvf jsoup-1.10.1.tar.gz
	( cd jsoup-jsoup-1.10.1; mvn clean; infer run -- mvn compile )
	( cd jsoup-jsoup-1.10.1; mvn test )

	# note! commons-math-3.2 has test failures!
	wget http://archive.apache.org/dist/commons/math/source/commons-math3-3.2-src.tar.gz
	tar xzvf commons-math3-3.2-src.tar.gz
	( cd commons-math3-3.2-src; mvn test )
	# 3.3 runs fine
	wget http://archive.apache.org/dist/commons/math/source/commons-math3-3.3-src.tar.gz
	tar xzvf commons-math3-3.3-src.tar.gz
	( cd commons-math3-3.3-src; mvn test )

	# 1 test failure
	wget http://archive.apache.org/dist/commons/lang/source/commons-lang3-3.2.1-src.tar.gz
	tar xzvf commons-lang3-3.2.1-src.tar.gz 
	( cd commons-lang3-3.2.1-src; mvn test )

	# 1 test failure
        wget http://archive.apache.org/dist/commons/lang/source/commons-lang3-3.3-src.tar.gz
	tar xzvf commons-lang3-3.3-src.tar.gz 
	( cd commons-lang3-3.3-src; mvn test )

        wget "http://archive.apache.org/dist/maven/scm/maven-scm-1.9.1-source-release.zip" 
	unzip maven-scm-1.9.1-source-release.zip
	( cd maven-scm-1.9.1; mvn clean; infer run -- mvn compile )

        wget "http://archive.apache.org/dist/maven/scm/maven-scm-1.11.2-source-release.zip"
        unzip maven-scm-1.11.2-source-release.zip
	( cd maven-scm-1.11.2; mvn clean; infer run -- mvn -Drat.skip=true compile )

        wget "https://archive.apache.org/dist/jmeter/source/apache-jmeter-5.1_src.tgz"
        tar xzvf apache-jmeter-5.1_src.tgz
        ( cd apache-jmeter-5.1; ./gradlew test )

        wget "https://archive.apache.org/dist/jmeter/source/apache-jmeter-5.2.1_src.tgz"
        tar xzvf apache-jmeter-5.2.1_src.tgz
        ( cd apache-jmeter-5.2.1; ./gradlew test )

        ;;
esac
