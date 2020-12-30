1. create secret for the password

`printf <secret> | docker secret create POSTGRES_PASSWORD -`  
for example  
`printf aGNGV1FnYjVnREpBNEVXdzhTcDc= | docker secret create POSTGRES_PASSWORD -`
