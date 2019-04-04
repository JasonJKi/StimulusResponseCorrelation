function cc = compute_cc_fixed(X,Y,wins)

if nargin<3, error('Not enough arguments'); end

if ( (size(X,1)~=size(Y,1)) || (size(X,2)~=size(Y,2)) )
    error('Input matrices X and Y must have the same size')
end

D=size(X,2);
Nwindows=size(wins,2);
cc=zeros(Nwindows,D);

% for i = 1:Nwindows
%     windx=wins{i};            
%     num = mean( X(windx,:).*Y(windx,:) ) - mean(X(windx,:)).*mean(Y(windx,:));
%     den = sqrt(mean(X(windx,:).^2) - (mean(X(windx,:))).^2) .* sqrt(mean(Y(windx,:).^2) - (mean(Y(windx,:))).^2);
%     cc(i,:)=num./den;
% end

% for i = 1:Nwindows
%     windx=wins{i};            
%     num = nanmean( X(windx,:).*Y(windx,:) ) - nanmean(X(windx,:)).*nanmean(Y(windx,:));
%     den = sqrt(nanmean(X(windx,:).^2) - (nanmean(X(windx,:))).^2) .* sqrt(nanmean(Y(windx,:).^2) - (nanmean(Y(windx,:))).^2);
%     cc(i,:)=num./den;
% end


for i = 1:Nwindows
    windx=wins{i};   
    for c=1:size(X,2)        
        [Rxy,Rxx,Ryy] = nanRXY(X(windx,c).',Y(windx,c).');
        cc(i,c)=Rxy/sqrt(Rxx*Ryy);
        cc(i,c)=real(cc(i,c)); %?
    end    
end
