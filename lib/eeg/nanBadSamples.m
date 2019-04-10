function Xout = nanBadSamples(X,P,Q,zero,xtent)
if nargin<5, xtent=1; end
if nargin<4, zero=0; end
if nargin<3, Q=4; end
if nargin<2, P=3; end

if size(X,1)>size(X<2), X=X.'; end % electrodes in row dimension

for p=1:P
    for ch=1:size(X,1)
        gind=find(~isnan(X(ch,:)));
        mustd=std(X(ch,gind));
        mask=double ( abs(X(ch,:))>Q*mustd );
        badsmp=find(mask);        
        if zero
            mask=filtfilt(ones(xtent,1),1,mask)>0;
            X(ch,find(mask))=0;            
            % X(ch,badsmp)=0;    
        else
            mask=filtfilt([ones(xtent,1); 0],1,mask)>0;
            X(ch,find(mask))=NaN;            
        end        
    end
    sum(isnan(X(:)))/length(X(:))
end

Xout=X;
return

