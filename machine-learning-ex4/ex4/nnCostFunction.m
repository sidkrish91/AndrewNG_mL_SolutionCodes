function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
a1 = [ones(m,1) X];
a2 = sigmoid(Theta1*a1');
a2 = [ones(1,m); a2];
a3 = sigmoid(a2'*Theta2');
h_theta = a3;

y_enc = zeros(size(h_theta));

for i = 1:length(y)
    y_enc(i,y(i))=1;
end
    
temp_cost = -y_enc.*log(h_theta)-(1-y_enc).*log(1-h_theta);
J = sum(temp_cost(:))/m;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

delta_2=0;
delta_1=0;

for t = 1:m
    a1 = X(t,:)';
    a1 = [1;a1];
    a2 = sigmoid(Theta1*a1);
    a2 = [1;a2];
    a3 = sigmoid(Theta2*a2);
    
    %layer 3
    y_actual = y(t,:);
    y_k = zeros(num_labels,1);
    y_k(y_actual) = 1;
    delta_3 = a3 - y_k;
    delta_2 = delta_2 + (delta_3*a2');
    
    delta_2temp = (Theta2(:,2:end)'*delta_3).*sigmoidGradient(Theta1*a1);
    delta_1 = delta_1 + (delta_2temp*a1');
end
    
    % Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Theta1_reg = Theta1(:,2:end);
Theta2_reg = Theta2(:,2:end);

reg_temp = (sumsqr(Theta1_reg(:))+sumsqr(Theta2_reg(:)))*lambda/(2*m);

J = J + reg_temp;

%Unregularised gradient
Theta1_grad = 1/m*delta_1;
Theta2_grad = 1/m*delta_2;

%Regularized gradient
reg_temp = zeros(size(Theta1_grad(:,2:end)));
reg_temp = Theta1(:,2:end)*lambda/m;
Theta1_grad(:,2:end) =  Theta1_grad(:,2:end) + reg_temp;

reg_temp = zeros(size(Theta2_grad(:,2:end)));
reg_temp = Theta2(:,2:end)*lambda/m;
Theta2_grad(:,2:end) =  Theta2_grad(:,2:end) + reg_temp;
















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
