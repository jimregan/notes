for i in $(seq 1 26)
do 
    youtube-dl -o '%(id)s.%(ext)s' https://www.bbc.co.uk/programmes/b007cpvp/clips?page=$i
done
