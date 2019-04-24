classdef VisualSalience < ImageFeature
    %VISUALSALIENCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        
        % Super Class declarations
        %         methodName
        %         methodParam
        %         methodParamName
        %
        %         outputStruct;
        outputNames = {''};
        
    end
    
    properties (Access = private)
        
        prevMotionInfo = [];
        imagePrev = [];

    end
    
    methods
        
        function this = VisualSalience(methodParam)
            this.methodName = methodParam.methodName;
            init(this, methodParam);
            initOutputStruct(this);
        end
        
        function init(this, methodParam)
            this.methodParam = methodParam;
            this.methodParamName = methodParam.methodName;
        end
        
        function Features = estimate(this, image)
            minLength = 128;
            image = resizeImageToMinLength(image, minLength);
            
            if strcmp(this.methodName, 'itti_koch_visual_salience')
                this.methodParam.salmapmaxsize = round( max(size(image))/8 );
            end
            [gbvsMaps, motionInfo]= gbvs(image,this.methodParam, this.prevMotionInfo);
            if ~isempty(motionInfo)
                this.prevMotionInfo = motionInfo;
            end
            Features.Map = single(gbvsMaps.master_map_resized);
        end
        
        function reset(this)
            this.prevMotionInfo = [];
        end
        
    end
    
    methods (Access = private)
        
        
        function initOutputStruct(this)
            this.OutputStruct.Map = [];
%             this.OutputStruct.top_level_feat_maps = [];
%             this.OutputStruct.master_map = [];
%             numRawFeatures = (this.methodParam.channels);
        end
        
    end
    
end

