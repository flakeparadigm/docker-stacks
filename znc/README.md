# ZNC

## Initial Setup
1. Run the initial ZNC setup: `docker-compose run znc '--makeconf'` (Use port `16697` to work with the existing docker-compose config).
2. Login to the web interface and go to "Global Settings".
3. Configure an endpoint on port `8080` for WEB-only, no SSL.
4. Change your browser to the hostname configured in the `.env` file, using https. The page should now load through Traefik.
5. Login and go to "Global Settings" again, replacing the `16697` endpoint with an IRC-only one.
