# Arrs

Wiki <https://wiki.servarr.com/>
Compose <https://github.com/automation-avenue/youtube-39-arr-apps-1-click/blob/main/docker-compose.yml>

- qBittorrent -> torrent
- Prowlarr -> indexer

- Sonarr -> tvshows
- Radarr -> movies
- Lidarr -> music
- Readarr -> books

## Arrs configuration

```nix
*arr = {
    config-dir = "/config/*arr";
    download-dir = "/downloads"; # Shared path

    backup-dir = "/backup/*arr";

    data-dirs = [
        "/data/tvshow"
        { root = "/data"; name = "tvshow"; } # /data/tvshow
        { root = "/data"; }                  # /data/tvshow
    ];

    download.clients = {
        qBittorrent = {
            enable = true;
            category = "tv-sonarr"; # ???

            host = "192.168.1.1";
            port = 8080; # tconf.webport;

            username = "admin"; # tconf.username;
            password = "admin"; # tconf.passwordHash;
        };
    }; 

    auth = {
        enable = true;

        method = "popup" | "form";

        username = "";
        passwordHash = "";
    };

};
```

## Per App configuration

## qBittorrent (torrent)

```nix
service.qBittorrent = {
    enable = true;

    openFirewall = true; # 8080 etc

    username = "admin";
    passwordHash = "admin";
};
```

## Prowlarr (indexer)

```nix
service.prowlarr = {
    indexers = [ "YTS" ];

    applications = {
        sonarr = {
            api-key = "aaaa";

            host = "192.168.1.1";
            port = 8989;  
        };
    };
};
```

## Jellyfin (media player)

```nix
jellyfin = {
    enable = true;

    auth = {
        username = "";
        passwordHash = "";
    };

    media = {
        content-type = "movies" | "tvseries";
        display-name = "Movies";

        folders = [ "/data/movies" "" ];
    };
};
```
