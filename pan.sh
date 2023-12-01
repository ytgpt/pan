REPO="pandora-next/deploy"
API_URL="https://api.github.com/repos/$REPO/releases"

latest_release=$(curl -s $API_URL | grep -m 1 "browser_download_url.*amd64" | cut -d '"' -f 4)

file_name=$(echo $latest_release | awk -F/ '{print $NF}')

curl -LJO $latest_release

tar -zxvf "$file_name" --overwrite

mv -f ${file_name%.tar.gz} p

rm "$file_name"
