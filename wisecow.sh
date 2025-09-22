#!/usr/bin/env bash

# Add /usr/games so cowsay and fortune are found
export PATH=$PATH:/usr/games

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo "$line"
}

handleRequest() {
    # 1) Process the request
    get_api
    mod=$(fortune)

    # Build proper HTTP response
    body="<pre>$(cowsay "$mod")</pre>"
    content_length=${#body}

cat <<EOF > $RSPFILE
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: $content_length

$body
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 || 
    { 
        echo "Install prerequisites."
        exit 1
    }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while true; do
        cat $RSPFILE | nc -lN $SRVPORT | handleRequest
        sleep 0.01
    done
}

main
