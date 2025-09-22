echo "WDF installation!"
git clone https://gitlab.com/wdfpipe/wdf.git &&\
cd wdf && python setup.py install &&\
cd .. && rm -fr wdf/
