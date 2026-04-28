FROM ubuntu:latest
RUN apt update -y &&  apt install -y apache2 unzip wget
WORKDIR /var/www/html
RUN rm -rf *
RUN wget https://templatemo.com/tm-zip-files-2020/templatemo_616_split_index.zip && unzip templatemo_616_split_index.zip 
RUN cp -r templatemo_616_split_index/* . &&    rm -rf templatemo_616_split_index templatemo_616_split_index.zip
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]