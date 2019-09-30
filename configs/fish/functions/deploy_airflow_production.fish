function deploy_airflow_production
	git checkout master
  git fetch
  git pull
  git checkout airflow-production
  git merge origin master --no-edit
  git push -u origin airflow-production
end
