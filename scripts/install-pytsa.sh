echo "PyTSA installation!"
git clone https://github.com/elenacuoco/p4TSA && cd p4TSA && cmake --install-prefix=/opt/conda CMakeLists.txt \
&& make -j "$(nproc)" \
&& make install \
&& cd python-wrapper \
&& python setup.py install \
&& cd .. \
&& cd .. \
&& rm -fr p4TSA
