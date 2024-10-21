# Web Service to convert FFE Entry file

`POST /file/entries`

Receives a XML file in FFE-format. The system converts this and return a valid entries.json that app.equipe.com can import.

`POST /file/results`

Receives a results.json in the request mode. The system converts this and return FFE result xml.

`POST /results`

Dummy the similate if the federation accepts the result in the format provided by app.equipe.com without needing to convert it.


# Create database backup fly

List secrets

```bash
fly console -a equipe-ffe
env
```

```bash
fly proxy 15432:5432 -a equipe-ffe-database
pg_dump -h localhost -p 15432 -U equipe_ffe equipe_ffe > backup.sql
psql -d ffe_equipe_development < backup.sql
```


