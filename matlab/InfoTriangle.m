classdef infoTriangle
    properties
        C;
        m;
        n;
        norm;
        
        % Maximum Entropies
        HmaxX; HmaxY; Hmax;
        %H_Ux,H_Uy
        
        % Counts
        Ni; Nj; Nt; NiNj;
        
        % Point wise mutual infor
        PI; PMI; 
        
        % Temporary Variables
        MI; Hxy;
        
        % infor content and Entropy of distributions
        I_Pxy; H_Pxy;
        I_Px;  H_Px;
        I_Py;  H_Py;
        
        % Marginal and Joint Probabilities
        Px; Py; Pxy;

        % Entropy Decrement of Marginal and Joint Distributions
        DeltaH_Px; DeltaH_Py; DeltaH_Pxy;
        
        % Variation of infor of Marginal and Joint Distributions
        VI_X; 
        VI_Y; 
        VI_XY;
        VI;
        
        % Mutual Informations
        MI_Pxy; twoMI;

    end
    
    methods
        
        function obj = ConfusionMatrix(C)
            
            % Save copy of matrix
            obj.C = C;
            
            % Always normalise
            obj.norm = true;
            
            % Size of symmetric matrix
            [obj.n, obj.m] = size(C);
            
            % Calculate Maximum entropies
            obj.HmaxX = log2(obj.n);
            obj.HmaxY = log2(obj.m);
            obj.Hmax  = obj.HmaxX + obj.HmaxY;
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Point wise mutual informations
            % Evaluates:
            % 1. Pointwise quotient of probs. MI
            % 2. Joint Probability.           Pxy
            % 3. Mutual infor.          MI
            % 4. Joint Entropy.               Hxy
            
            % Get Counts
            obj.Ni = sum(obj.C,2);%column of row marginal counts
            obj.Nj = sum(obj.C,1);%row of column marginal counts
            obj.Nt = sum(obj.Ni);%either the sum of the row or columns marginal counts.
            
            % Evaluate the product matrix
            obj.NiNj = obj.Ni* obj.Nj;
            % Calculate pointwise quotient of probabilities
            obj.PI = (double(obj.C) * obj.Nt)./ obj.NiNj;
            % Calculate the Joint Probability
            obj.Pxy=double(obj.C)/obj.Nt;
            % Calculate Pointwise mutual infor
            obj.PMI = log2(obj.PI);
            nulls = sparse(obj.Pxy == 0);
            % Calculate the Mutual infor
            obj.MI = obj.Pxy.*obj.PMI;
            obj.MI(nulls)=0;          %Dispose of 0*log 0
            obj.MI = sum(sum(obj.MI));%The average of PMI is MI
            
            % Calculate the joint entropy
            obj.Hxy = obj.Pxy .* log2(obj.Pxy);
            obj.Hxy(nulls) = 0;
            obj.Hxy = -sum(sum(obj.Hxy));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % infor content and Entropy of the joint distribution
            [obj.I_Pxy,obj.H_Pxy] = obj.infor(obj.Pxy);
            
            % infor content and Entropy of the marginal
            obj.Px = sum(obj.Pxy,2);
            [obj.I_Px,obj.H_Px] = obj.infor(obj.Px);
            
            % infor content and Entropy of the marginal
            obj.Py = sum(obj.Pxy);
            [obj.I_Py,obj.H_Py] = obj.infor(obj.Py);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Evaluate the ternary variables
            
            % Entropy Decrement
            obj.DeltaH_Px  = obj.HmaxX - obj.H_Px;
            obj.DeltaH_Py  = obj.HmaxY - obj.H_Py;
            obj.DeltaH_Pxy = obj.DeltaH_Px + obj.DeltaH_Py;
            

            
            % Mutual infor
            obj.MI_Pxy = obj.H_Px + obj.H_Py - obj.H_Pxy;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

            % Sanity check
            sxy = size(obj.H_Pxy);
            sx  = size(obj.H_Px); 
            sy  = size(obj.H_Py); 
            sM  = size(obj.MI_Pxy);
            if any(sxy ~= sx | sxy ~= sy | sxy ~= sM)
                error('Double:explore_entropies','different dimensions in input entropies');
            end
            
            % Calculate unnormalized entropic coordinates
            obj.DeltaH_Pxy = (obj.Hmax - obj.H_Px - obj.H_Py);
            obj.twoMI      = (2*obj.MI_Pxy);
            obj.VI         = (obj.H_Pxy - obj.MI_Pxy);
            
            % Normalise entropic coordinates
            if obj.norm
                Hnorm           = obj.Hmax;
                
                obj.DeltaH_Pxy = obj.DeltaH_Pxy./Hnorm;
                obj.twoMI       = obj.twoMI./Hnorm;
                obj.VI          = obj.VI./Hnorm;
            end
            
            % Variation of infor
            
            disp "here"
            obj.VI_X  = obj.H_Px - obj.MI_Pxy;
            obj.VI_Y  = obj.H_Py - obj.MI_Pxy;
            obj.VI_XY = obj.VI_X + obj.VI_Y;
            
            
            disp "Done"
        end
    end
    
    
    methods(Static)
        function [I,EI] = infor(P)
            
            % information content from probability distribution
            I = -log2(P);
            lp = logical(P);
            
            % Entropy from information content
            if any(size(P) == 1)  %row distribution or column distribution, resp
                EI = sum(P(lp) .* I(lp));
            else                  %bivariate, be very careful
                EI = sum(sum(P(lp) .* I(lp)));
            end
            
        end
    end
    
end