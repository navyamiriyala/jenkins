# FROM 015838347042.dkr.ecr.us-east-1.amazonaws.com/cicd-deplymt

FROM centos:latest
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y install httpd

COPY index.html /var/www/html/

CMD [ "/usr/sbin/httpd", "-D", "FOREGROUND" ]
