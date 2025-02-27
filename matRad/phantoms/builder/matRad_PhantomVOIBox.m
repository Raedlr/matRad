classdef matRad_PhantomVOIBox < matRad_PhantomVOIVolume
    % matRad_PhantomVOIBox implements a class that helps to create box VOIs
    %
    % References
    %     -
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Copyright 2022 the matRad development team.
    %
    % This file is part of the matRad project. It is subject to the license
    % terms in the LICENSE file found in the top-level directory of this
    % distribution and at https://github.com/e0404/matRad/LICENSE.md. No part
    % of the matRad project, including this file, may be copied, modified,
    % propagated, or distributed except according to the terms contained in the
    % LICENSE file.
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties %additional property of cubic objects
        boxDimensions;
    end

    methods (Access = public)

        function obj = matRad_PhantomVOIBox(name,type,boxDimensions,varargin)
            p = inputParser;
            addParameter(p,'objectives',{});
            addParameter(p,'offset',[0,0,0]);
            addParameter(p,'HU',0);
            parse(p,varargin{:});

            obj@matRad_PhantomVOIVolume(name,type,p); %call superclass constructor
            obj.boxDimensions = boxDimensions;
        end

        function [cst] = initializeParameters(obj,ct,cst)
            %add this objective to the phantomBuilders cst

            cst = initializeParameters@matRad_PhantomVOIVolume(obj,cst);
            center = round(ct.cubeDim/2);
            VOIHelper = zeros(ct.cubeDim);
            offsets = obj.offset;
            dims = obj.boxDimensions;

            xMinMax = center(2)+offsets(1) + round(dims(1)/2)*[-1,1];
            yMinMax = center(1)+offsets(2) + round(dims(2)/2)*[-1,1];
            zMinMax = center(3)+offsets(3) + round(dims(3)/2)*[-1,1];
            
            %Correct if out of bounds
            xMinMax(xMinMax < 1) = 1;
            yMinMax(yMinMax < 1) = 1;
            zMinMax(zMinMax < 1) = 1;

            xMinMax(xMinMax > ct.cubeDim(2)) = ct.cubeDim(2);
            yMinMax(yMinMax > ct.cubeDim(1)) = ct.cubeDim(1);
            zMinMax(zMinMax > ct.cubeDim(3)) = ct.cubeDim(3);
            
            for x = xMinMax(1):1:xMinMax(2) 
                for y = yMinMax(1):1:yMinMax(2)
                   for z = zMinMax(1):1:zMinMax(2)
                        VOIHelper(y,x,z) = 1;
                   end
                end
            end
            
            cst{end,4}{1} = find(VOIHelper);
            

        end
    end
end  