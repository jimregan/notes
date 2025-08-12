user_agent="Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.237 Safari/534.10"
nohup wget --timeout=300 --no-check-certificate -U "$user_agent" --trust-server-names=1 -x -c -i $1 -o $1.log &
