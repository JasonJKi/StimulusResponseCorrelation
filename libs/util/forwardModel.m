function A = forwardModel(W, R)
%FORWARDMODEL A = forwardModel(W,R)
%   compute the forward model
A = R * W * inv(W' * R * W);
end

