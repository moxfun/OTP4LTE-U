%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MIT License
%
% Copyright (c) 2016 Microsoft
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath ../../DnlinkTX

useSIB = 1;
useMIB = 1;
useRAR = 1;
useDCI0 = 2;           % Use real values for NDI in DCI0. Otherwise DCI0=1 uses NDI=0 throughout
useDATA = 1;
m = [];

for frame = 0:2
for subframe = 0:9
  tx.enb = struct('CellRefP',1,'NDLRB',50,'NCellID',11,'NFrame',frame,...
                  'NSubframe',subframe,'Ng',1,'PHICHDuration','Normal','CFI',3);
  if (subframe == 0) 
    useDCI0_local = useDCI0;
  else
    useDCI0_local = 0;
  end
  lenRB = 12;
  startRB = 0;
  o = genSubframe(frame, subframe, tx, useMIB, useSIB, useRAR, useDCI0_local, useDATA, lenRB, startRB);
  m = [m, o.grid];
end
end


g = modulate(2048, m*30000);


gr = zeros(length(g)*2,1);

% Signal in time can vary at a few, low-energy points. 
% We transform it to avoid false positive on these points
gr(1:2:end) = 32*abs(real(g)) + 50*32;
gr(2:2:end) = 32*abs(imag(g)) + 50*32;

f = fopen('tx_test1.outfile.ground', 'w');
fprintf(f,'%d,', floor(gr));
fclose(f);



