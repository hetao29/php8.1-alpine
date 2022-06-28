# php7.4-alpine

## usage

```bash
make start
```

## nginx

```conf
	location ~ \.php$ {
		fastcgi_param REMOTE_ADDR $http_x_real_ip;
		fastcgi_pass   127.0.0.1:10000; #php8.1(docker)
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
		include        fastcgi_params;
	}
```

## conf

```yaml
    volumes:
        - www:/data/mgr/
```
