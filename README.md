# docker-smf
Docker image for SMF

## How to run
`docker run -p 8500:80 -e 'SMF_BOARD_URL=http://localhost:8500/' eeems/smf`

Access the site with <http://localhost:8500>

Admin credentials: `Admin/admin`

## Example
![Screen-recording](https://i.imgur.com/laKoSDV.gif)

## Example docker-compose.yml

```yaml
version: '3'
services:
  smf:
    container_name: smf
    image: eeems/smf
    ports:
      - "8500:80"
    environment:
      - SMF_BOARD_URL=http://localhost:8500/

```
