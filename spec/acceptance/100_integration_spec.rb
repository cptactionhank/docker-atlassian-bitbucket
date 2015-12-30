require 'timeout'
require 'spec_helper'

describe 'Atlassian Bitbucket with Embedded Database' do
	include_examples 'an acceptable Bitbucket instance', 'using an embedded database'
end

describe 'Atlassian Bitbucket with PostgreSQL 9.3 Database' do
	include_examples 'an acceptable Bitbucket instance', 'using a PostgreSQL database' do
		if ENV["CI"] == "true"
			before :all do
				$container_postgres = Docker::Container.get 'postgres'
			end
		else
			before :all do
				Docker::Image.create fromImage: 'postgres:9.3'
        # Create and run a PostgreSQL 9.3 container instance
        $container_postgres = Docker::Container.create image: 'postgres:9.3'
        $container_postgres.start!
        # Wait for the PostgreSQL instance to start
        $container_postgres.wait_for_output %r{PostgreSQL\ init\ process\ complete;\ ready\ for\ start\ up\.}
        # Create Bitbucket database
        $container_postgres.exec ["psql", "--username", "postgres", "--command", "create database bitbucketdb owner postgres encoding 'utf8';"]
			end
			after :all do
				$container_postgres.remove force: true, v: true unless $container_postgres.nil?
			end
		end
	end
end

describe 'Atlassian Bitbucket with MySQL 5.6 Database', order: :defined do
	include_examples 'an acceptable Bitbucket instance', 'using a MySQL database' do
		if ENV["CI"] == "true"
			before :all do
				$container_mysql = Docker::Container.get 'mysql'
			end
		else
			before :all do
        Docker::Image.create fromImage: 'mysql:5.6'
        # Create and run a MySQL 5.6 container instance
        $container_mysql = Docker::Container.create image: 'mysql:5.6', env: ['MYSQL_ROOT_PASSWORD=mysecretpassword']
        $container_mysql.start!
        # Wait for the MySQL instance to start
        $container_mysql.wait_for_output %r{socket:\ '/var/run/mysqld/mysqld\.sock'\ \ port:\ 3306\ \ MySQL\ Community\ Server\ \(GPL\)}
        # Create Bitbucket database
        $container_mysql.exec ['mysql', '--user=root', '--password=mysecretpassword', '--execute', 'CREATE DATABASE bitbucketdb CHARACTER SET utf8 COLLATE utf8_bin;']
      end
      after :all do
        $container_mysql.remove force: true, v: true unless $container_mysql.nil?
      end
		end
	end
end
