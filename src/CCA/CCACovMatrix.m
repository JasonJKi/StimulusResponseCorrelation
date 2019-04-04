classdef CCACovMatrix < handle
    properties
        rxx
        ryy
        rxy
        ryx
    end
    
    methods
        function this = CCACovMatrix(rxx, ryy, rxy, ryx)
            if nargin < 1
                return
            end
            set(this, rxx, ryy, rxy, ryx)
        end
        
        function set(this, rxx, ryy, rxy, ryx)
            this.rxx = rxx;
            this.ryy = ryy;
            this.rxy = rxy;
            this.ryx = ryx;
        end
        
          function [rxx, ryy, rxy, ryx] = get(this)
            rxx = this.rxx;
            ryy = this.ryy;
            rxy = this.rxy;
            ryx = this.ryx;
        end
    end
end