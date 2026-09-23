# Step 1 
```
git clone https://github.com/hashicorp/demo-consul-101
cd demo-consul-101-0.0.5/services/dashboard-service
```

# Step 2 Change color in style.css
### Modify the Dashboard V2 source
#### Open main.go
```
import (
        "embed"
        "encoding/json"
        "expvar"
        "fmt"
        "io"
        "io/fs"
        "io/ioutil"
        "log"
        "net/http"
        "os"
        "sync"
        "time"

        "github.com/gorilla/mux"
        gosocketio "github.com/graarh/golang-socketio"
        "github.com/graarh/golang-socketio/transport"
)

var countingServiceURL string
var port string

//go:embed assets
var assets embed.FS
```
##### Verify the static-file configuration
```
Your main() should contain:      
        
        router := mux.NewRouter()
        router.PathPrefix("/socket.io/").Handler(startWebsocket(failTrack))
        router.HandleFunc("/health", HealthHandler)
        router.HandleFunc("/health/api", HealthAPIHandler(failTrack))
        router.Handle("/metrics", expvar.Handler())
        assetFS, err := fs.Sub(assets, "assets")
        if err != nil {
                log.Fatal(err)
        }

        router.PathPrefix("/").Handler(http.FileServer(http.FS(assetFS)))
        log.Fatal(http.ListenAndServe(portWithColon, router))
}
```

# Step 3 - Compile the Dashboard V2 binary
#### Because Dashboard V2 EC2 instances are Ubuntu x86_64, compile for Linux AMD64:
```
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o dashboard-v2 .
```
#### Check the file 
```
➜ ls -la dashboard-v2 
-rwxr-xr-x@ 1 nin  staff  11595485 Sep 23 18:17 dashboard-v2
➜ file dashboard-v2 
dashboard-v2: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, Go BuildID=YlXLTuapGR8bTk2oONDM/dLxkJd3lQDub8IkXzOYO/P7fR9e6XlFaFeNFi3CDs/E284wLjZKgR2BHspLWXH, BuildID[sha1]=8a8188403dff9368f388c8251cf253c5eedd655e, with debug_info, not stripped
```

