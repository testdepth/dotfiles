function build_push_supervisor_docker
	docker login --username=nehiljain --password=d0ck3rP@sswd!
docker build -t nehiljain/snowflake-supervisor:latest .
docker push nehiljain/snowflake-supervisor:latest
end
