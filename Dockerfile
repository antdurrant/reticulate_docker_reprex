FROM rocker/shiny-verse:latest


# install Python 3.7 (Miniconda) and set path variable
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /opt/conda && \
#     rm ~/miniconda.sh && \
#     /opt/conda/bin/conda clean -tipsy && \
#     ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#     echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
#     echo "conda activate base" >> ~/.bashrc
# ENV PATH /opt/conda/bin:$PATH



# from miniconda
RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH

# install nltk & download multilingual wordnet
RUN conda install -c conda-forge nltk_data

# let R know the right version of python to use
# ENV RETICULATE_PYTHON "/opt/conda/bin/python"
#   
#   copy the setup script, run it, then delete it
COPY src/setup.R /
RUN Rscript setup.R && rm setup.R
#   
COPY reprex/with_condaenv_auto /srv/shiny-server/
# 
EXPOSE 3838

