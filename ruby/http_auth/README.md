## Run server

```
bundle install
rackup -p 9000
```

## Run client

```
ruby client.rb
```

## Run curl

```
curl -s -X POST http://localhost:9000/login \
  -H "Content-Type: application/json" \
  -d '{"email":"kandy@kandy.com","password":"pass"}'
```

```
curl -s http://localhost:9000/protected \
  -H "Authorization: Bearer <token-here>"
```
