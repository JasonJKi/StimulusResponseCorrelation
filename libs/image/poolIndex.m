function indx = poolIndex(height,width,kernel)
indx = kron(reshape(1:(height*width/(kernel^2)),width/kernel,[])',ones(kernel));
