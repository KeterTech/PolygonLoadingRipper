@echo off
set file=691623fa5819625c6e5e
curl "https://asset-polygon-loading.power-of-tech.com/publish_kh3m6hfbshlc8su6/model/V008/%file%.bin?t=0&c=1&w=4cdc08af4f1078fd9d7974b1ee237e1654942c8baf0e30b77314d050b1e35351&v=1-18-08-06-04" -L --header "Host: asset-polygon-loading.power-of-tech.com" --header "Accept: */*" --header "Accept-Encoding: deflate, gzip" --header "User-Agent: UnityPlayer/2022.3.6f1-DWR (UnityWebRequest/1.0, libcurl/8.1.1-DEV)" --header "X-Unity-Version: 2019.4.31f1" --proxy-header "User-Agent: UnityPlayer/2022.3.6f1-DWR (UnityWebRequest/1.0, libcurl/8.1.1-DEV)" -o %file%.gz
gzip.exe -d %file%.gz -c > %file%.bin
del %file%.gz
pause
