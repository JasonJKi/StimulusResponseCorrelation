function h = moveTitle(h,tx,ty,tz)
%H=MOVETITLE(H,TX,TY,TZ)
%   shift position of matlab plot title
if nargin<4, tz=0; end
if nargin<3, ty=0; end
if nargin<2, tx=0; end;
titPos=get(h,'Position');
set(h,'Position',[titPos(1)+tx titPos(2)+ty titPos(3)+tz]);


end

